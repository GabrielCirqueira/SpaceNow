#!/usr/bin/env node
const fs = require('fs').promises;
const path = require('path');

const exts = new Set(['.ts', '.tsx', '.js', '.jsx']);

async function walk(dir) {
  const entries = await fs.readdir(dir, { withFileTypes: true });
  const files = [];
  for (const e of entries) {
    const full = path.join(dir, e.name);
    if (e.isDirectory()) {
      if (e.name === 'node_modules' || e.name === '.git') continue;
      files.push(...(await walk(full)));
    } else if (e.isFile() && exts.has(path.extname(e.name))) {
      files.push(full);
    }
  }
  return files;
}

function normalizeClassString(s) {
  // split by whitespace, filter empty, remove duplicates while preserving order
  const parts = s.split(/\s+/).filter(Boolean);
  const seen = new Set();
  const out = [];
  for (const p of parts) {
    if (!seen.has(p)) {
      seen.add(p);
      out.push(p);
    }
  }
  return out.join(' ');
}

function findClosing(str, startIdx, quote) {
  let i = startIdx;
  while (i < str.length) {
    const ch = str[i];
    if (ch === '\\') {
      i += 2; // skip escaped
      continue;
    }
    if (ch === quote) return i;
    i++;
  }
  return -1;
}

async function processFile(file) {
  let src = await fs.readFile(file, 'utf8');
  let i = 0;
  let changed = false;
  const out = [];
  while (true) {
    const idx = src.indexOf('className', i);
    if (idx === -1) break;
    // copy up to idx
    out.push(src.slice(i, idx));
    let eq = src.indexOf('=', idx);
    if (eq === -1) { i = idx + 8; out.push(src.slice(idx, idx + 8)); continue; }
    // write 'className' and upto '='
    out.push(src.slice(idx, eq + 1));
    let j = eq + 1;
    // skip whitespace
    while (j < src.length && /\s/.test(src[j])) j++;
    if (j >= src.length) break;
    const ch = src[j];
    if (ch === '"' || ch === "'" || ch === '`') {
      const close = findClosing(src, j + 1, ch);
      if (close === -1) { out.push(src.slice(j)); break; }
      const inner = src.slice(j + 1, close);
      // skip template strings containing ${}
      if (ch === '`' && inner.includes('${')) {
        out.push(src.slice(j, close + 1));
        i = close + 1;
        continue;
      }
      const normalized = normalizeClassString(inner);
      if (normalized !== inner) changed = true;
      out.push(ch + normalized + ch);
      i = close + 1;
      continue;
    }
    // handle {`...`} or {"..."} patterns
    if (ch === '{') {
      let k = j + 1;
      while (k < src.length && /\s/.test(src[k])) k++;
      const next = src[k];
      if (next === '`' || next === '"' || next === "'") {
        const close = findClosing(src, k + 1, next);
        if (close === -1) { out.push(src.slice(j, j + 1)); i = j + 1; continue; }
        const inner = src.slice(k + 1, close);
        // skip template with ${}
        if (next === '`' && inner.includes('${')) {
          // copy the whole {`...`}
          const endBrace = src.indexOf('}', close + 1);
          if (endBrace === -1) { out.push(src.slice(j)); break; }
          out.push(src.slice(j, endBrace + 1));
          i = endBrace + 1;
          continue;
        }
        const normalized = normalizeClassString(inner);
        if (normalized !== inner) changed = true;
        // write {`normalized`} or {"normalized"}
        out.push('{' + next + normalized + next + '}');
        // move i after the closing brace '}'
        const endBrace = src.indexOf('}', close + 1);
        if (endBrace === -1) { i = close + 1; } else { i = endBrace + 1; }
        continue;
      }
      // unknown pattern; just copy '{' and move on
      out.push('{');
      i = j + 1;
      continue;
    }
    // otherwise nothing we can parse; copy char and continue
    out.push(src[j]);
    i = j + 1;
  }
  // append remainder
  if (i < src.length) out.push(src.slice(i));
  const newSrc = out.join('');
  if (changed && newSrc !== src) {
    await fs.writeFile(file, newSrc, 'utf8');
    console.log('Normalized', file);
  }
}

async function main() {
  const target = process.argv[2] || 'src';
  const abs = path.resolve(process.cwd(), target);
  try {
    const stat = await fs.stat(abs);
    const files = stat.isDirectory() ? await walk(abs) : [abs];
    for (const f of files) {
      try { await processFile(f); } catch (e) { /* ignore file errors */ }
    }
  } catch (err) {
    console.error('Error:', err.message);
    process.exitCode = 1;
  }
}

main();
