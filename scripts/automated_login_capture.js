// Automated login capture using Playwright
// Captures OAuth callback request URL, response headers (Set-Cookie), first /v2/ projects XHR request headers, and console logs.
const fs = require('fs');
const { chromium } = require('playwright');
(async () => {
  const out = {
    callbackRequestUrl: null,
    callbackResponseHeaders: null,
    firstApiRequest: null,
    consoleLogs: [],
    errors: []
  };
  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext();
  const page = await context.newPage();
  // Attach CDP session to capture raw network responses (Set-Cookie headers etc.)
  let cdp;
  try {
    cdp = await context.newCDPSession(page);
    await cdp.send('Network.enable');
    cdp.on('Network.responseReceived', async (params) => {
      try {
        const resp = params.response || {};
        const url = resp.url || '';
        if (url.includes('/realms') || url.includes('protocol/openid-connect') || url.includes('/auth')) {
          out.keycloakResponses = out.keycloakResponses || [];
          out.keycloakResponses.push({ url, status: resp.status, headers: resp.headers });
        }
        if (url.includes('/login/oauth2/code/')) {
          out.callbackResponseHeaders = out.callbackResponseHeaders || {};
          out.callbackResponseHeaders[url] = resp.headers;
          out.callbackResponseStatus = out.callbackResponseStatus || {};
          out.callbackResponseStatus[url] = resp.status;
        }
          // If the response contains a Location header that points to the OAuth callback,
          // capture it as callbackRequestUrl so redirects to other ports (e.g. 8050) are detected.
          try {
                const headers = resp.headers || {};
                const loc = headers.Location || headers.location || headers.LOCATION || null;
                if (loc && String(loc).includes('/login/oauth2/code/')) {
                  const l = String(loc);
                  out.callbackRequestUrl = out.callbackRequestUrl || l;
                  // attempt to navigate the page to the callback URL so Playwright records the request
                  try {
                    if (typeof page !== 'undefined' && page && (!page.url() || !page.url().includes('/login/oauth2/code/'))) {
                      (async () => { try { await page.goto(l, { waitUntil: 'networkidle', timeout: 10000 }); } catch (e) {} })();
                    }
                  } catch (e) {}
                }
          } catch (e) {}
      } catch (e) {
        console.error('CDP response handler error', e);
      }
    });
  } catch (e) {
    console.log('CDP session not available:', e.message || e);
  }
  page.on('console', msg => {
    out.consoleLogs.push({ type: msg.type(), text: msg.text() });
  });
  page.on('pageerror', err => {
    out.errors.push({ type: 'pageerror', message: String(err) });
  });
  page.on('request', request => {
    const url = request.url();
    if (!out.callbackRequestUrl && url.includes('/login/oauth2/code/')) {
      out.callbackRequestUrl = url;
    }
    if (!out.firstApiRequest && (url.includes('/v2/') || url.match(/\/projects/))) {
      const headers = request.headers();
      out.firstApiRequest = { url, method: request.method(), headers };
    }
    if (url.includes('/realms') || url.includes('protocol/openid-connect') || url.includes('/auth')) {
      out.keycloakRequests = out.keycloakRequests || [];
      out.keycloakRequests.push({ url, method: request.method(), headers: request.headers(), postData: request.postData() });
    }
  });
  page.on('response', async response => {
    try {
      const url = response.url();
      if (url.includes('/login/oauth2/code/') && !out.callbackResponseHeaders) {
        out.callbackResponseHeaders = response.headers();
        out.callbackResponseStatus = response.status();
      }
      // Also check response headers for Location -> callback (case-insensitive)
      try {
        const rh = response.headers() || {};
        const loc = rh.Location || rh.location || rh.LOCATION || null;
        if (loc && String(loc).includes('/login/oauth2/code/')) {
          const l = String(loc);
          out.callbackRequestUrl = out.callbackRequestUrl || l;
          try { if (!page.url().includes('/login/oauth2/code/')) { await page.goto(l, { waitUntil: 'networkidle', timeout: 10000 }).catch(e=>{}); } } catch (e) {}
        }
      } catch (e) {}
      if ((url.includes('/realms') || url.includes('protocol/openid-connect') || url.includes('/auth')) && (!out.keycloakResponses || out.keycloakResponses.length < 20)) {
        let text = '';
        try { text = await response.text(); } catch (e) { text = '<unable to read body>'; }
        out.keycloakResponses = out.keycloakResponses || [];
        out.keycloakResponses.push({ url, status: response.status(), headers: response.headers(), bodySnippet: text ? text.substring(0, 2000) : '' });
      }
      if (response.status() >= 400) {
        out.errors.push({ type: 'http-error', url, status: response.status(), headers: response.headers() });
      }
    } catch (e) {
      out.errors.push({ type: 'response-handler', message: String(e) });
    }
  });
  page.on('framenavigated', frame => {
    try {
      if (frame === page.mainFrame()) {
        const cur = page.url();
        out.lastNavigation = { url: cur, timestamp: Date.now() };
      }
    } catch (e) {}
  });
  try {
    await page.goto('http://localhost:8060', { waitUntil: 'networkidle', timeout: 60000 });
    await page.waitForTimeout(2000);
    // Try click login if present
    const loginSelectors = ['a.login', 'button.login', 'a[href*="oauth2"]', 'a[href*="/login"]', 'button[aria-label="login"]'];
    for (const sel of loginSelectors) {
      try {
        const el = await page.$(sel);
        if (el) { await el.click(); break; }
      } catch (e) {}
    }
    // wait for navigation to keycloak login
    await Promise.race([page.waitForNavigation({ waitUntil: 'domcontentloaded', timeout: 30000 }).catch(e => null), (async () => { await page.waitForTimeout(30000); return null; })()]);
    // If Keycloak login page, fill and submit
    let currentUrl = page.url();
    if (currentUrl.includes('/realms') && currentUrl.includes('/protocol/openid-connect/auth')) {
      const usernameSelectors = ['input[name="username"]', 'input#username', 'input#kc-login-username', 'input[name="email"]'];
      const passwordSelectors = ['input[name="password"]', 'input#password', 'input#kc-login-password'];
      const submitSelectors = ['input[type="submit"]', 'button[type="submit"]', 'button#kc-login', 'input#kc-login'];
      let filled = false;
      for (const u of usernameSelectors) {
        for (const p of passwordSelectors) {
          try {
            const uel = await page.$(u);
            const pel = await page.$(p);
            if (uel && pel) { await uel.fill('admin'); await pel.fill('admin'); filled = true; break; }
          } catch (e) {}
        }
        if (filled) break;
      }
      if (!filled) {
        try {
          await page.evaluate(() => { const u = document.querySelector('input[name=username]') || document.querySelector('input#username'); const p = document.querySelector('input[name=password]') || document.querySelector('input#password'); if (u) u.value='admin'; if (p) p.value='admin'; });
        } catch (e) {}
      }
      let submitted = false;
      for (const s of submitSelectors) {
        try { const el = await page.$(s); if (el) { await el.click(); submitted = true; break; } } catch (e) {}
      }
      if (!submitted) {
        try { await page.evaluate(() => { const form = document.querySelector('form'); if (form) form.submit(); }); } catch (e) {}
      }
    }
    // wait up to 120s for callback or responses
    const start = Date.now();
    while ((Date.now() - start) < 120000 && (!out.callbackRequestUrl && !out.callbackResponseHeaders)) {
      const cur = page.url();
      if (cur.includes('/login/oauth2/code/') && !out.callbackRequestUrl) { out.callbackRequestUrl = cur; }
      // If required-action page encountered, try to submit/complete it
      if (cur.includes('login-actions/required-action') || cur.includes('VERIFY_PROFILE')) {
        try {
          // Aggressively fill visible form fields: text/email inputs, selects, checkboxes, radios
          await page.evaluate(() => {
            const fm = document.querySelector('form') || document.body;
            const setVal = (el, v) => { try { el.focus && el.focus(); el.value = v; el.dispatchEvent(new Event('input', { bubbles: true })); el.dispatchEvent(new Event('change', { bubbles: true })); } catch (e) {} };
            // text/email inputs
            Array.from((fm.querySelectorAll('input[type="text"], input[type="email"], input:not([type])'))).forEach(i => {
              if (!i.value || i.value.trim() === '') setVal(i, 'dev');
            });
            // password is probably already filled
            // selects -> choose first non-empty option
            Array.from(fm.querySelectorAll('select')).forEach(s => {
              try { if (s.options && s.options.length) { s.selectedIndex = s.selectedIndex >= 0 ? s.selectedIndex : 0; s.dispatchEvent(new Event('change', { bubbles: true })); } } catch (e) {}
            });
            // checkboxes -> check them
            Array.from(fm.querySelectorAll('input[type="checkbox"]')).forEach(c => { try { c.checked = true; c.dispatchEvent(new Event('change', { bubbles: true })); } catch (e) {} });
            // radios -> pick first of each name group
            const radios = Array.from(fm.querySelectorAll('input[type="radio"]'));
            const seen = new Set();
            radios.forEach(r => { try { if (!seen.has(r.name)) { seen.add(r.name); r.checked = true; r.dispatchEvent(new Event('change', { bubbles: true })); } } catch (e) {} });
          });
          // Try clicking typical continue/next/save buttons
          const cont = await page.$('input[type="submit"], button[type="submit"], button#kc-next, button.kc-form-submit, button[aria-label="Continue"], button:has-text("Continue"), button:has-text("Next"), button:has-text("Save")');
          if (cont) {
            try { await cont.click(); }
            catch (e) { try { await page.evaluate(() => { const form = document.querySelector('form'); if (form) form.submit(); }); } catch (e) {} }
          } else {
            // fallback: submit the first form
            try { await page.evaluate(() => { const form = document.querySelector('form'); if (form) form.submit(); }); } catch (e) {}
          }
        } catch (e) {}
      }
      await page.waitForTimeout(1000);
      // Also: try to parse client_data.ru from any recent keycloakRequests and navigate to it (force callback)
      try {
        if (!out.callbackRequestUrl && out.keycloakRequests && out.keycloakRequests.length) {
          const reversed = out.keycloakRequests.slice().reverse();
          for (const r of reversed) {
            try {
              const m = r.url && r.url.match(/[?&]client_data=([^&]+)/);
              if (m && m[1]) {
                const raw = decodeURIComponent(m[1]);
                let b = raw.replace(/-/g,'+').replace(/_/g,'/'); while (b.length % 4) b += '=';
                let json = null; try { json = JSON.parse(Buffer.from(b,'base64').toString('utf8')); } catch (e) { json = null; }
                if (json && json.ru) {
                  try { await page.goto(json.ru, { waitUntil: 'networkidle', timeout: 20000 }); } catch (e) {}
                  out.callbackRequestUrl = out.callbackRequestUrl || json.ru;
                  break;
                }
              }
            } catch (e) {}
          }
        }
      } catch (e) {}
    }
    // gather cookies
    const cookies = await context.cookies();
    out.cookies = cookies;
    // DEV WORKAROUND: inject KEYCLOAK_SESSION if missing
    try {
      const hasKeycloakSession = cookies.some(c => c.name === 'KEYCLOAK_SESSION');
      if (!hasKeycloakSession) {
        const restart = cookies.find(c => c.name === 'KC_RESTART') || cookies.find(c => c.name === 'AUTH_SESSION_ID_LEGACY') || cookies.find(c => c.name === 'AUTH_SESSION_ID');
        if (restart) {
          const injected = { name: 'KEYCLOAK_SESSION', value: restart.value ? String(restart.value).slice(0,64) : 'injected-session', domain: restart.domain || 'localhost', path: '/realms/lens/', httpOnly: false, secure: false, sameSite: 'Lax' };
          await context.addCookies([injected]);
          out.injectedCookie = injected;
          const restartUrl = await page.evaluate(() => {
            const scripts = Array.from(document.querySelectorAll('script'));
            for (const s of scripts) { const txt = s.textContent || ''; const m = txt.match(/checkCookiesAndSetTimer\(['"]([^'\"]+)['"]\)/); if (m && m[1]) return m[1]; }
            return null;
          });
          if (restartUrl) {
            try { await page.goto(restartUrl, { waitUntil: 'networkidle', timeout: 20000 }); await page.waitForTimeout(2000); } catch (e) {}
          }
          // try construct restart URL from authenticate request
          if ((!restartUrl || restartUrl.length === 0) && out.keycloakRequests && out.keycloakRequests.length) {
            try {
              const authReq = out.keycloakRequests.slice().reverse().find(r => r.url && r.url.includes('/login-actions/authenticate'));
              if (authReq && authReq.url) {
                const url = new URL(authReq.url);
                const restartPath = url.pathname.replace('/login-actions/authenticate', '/login-actions/restart');
                url.pathname = restartPath; url.searchParams.set('skip_logout','true'); const constructed = url.toString();
                try { await page.goto(constructed, { waitUntil: 'networkidle', timeout: 20000 }); await page.waitForTimeout(2000); } catch (e) {}
              }
            } catch (e) {}
          }
          // FINAL FALLBACK: try read client_data from keycloak requests and navigate to redirect URI
          try {
            if (!out.callbackRequestUrl && out.keycloakRequests && out.keycloakRequests.length) {
              const reversed = out.keycloakRequests.slice().reverse();
              for (const r of reversed) {
                try {
                  const m = r.url && r.url.match(/[?&]client_data=([^&]+)/);
                  if (m && m[1]) {
                    const raw = decodeURIComponent(m[1]);
                    let b = raw.replace(/-/g,'+').replace(/_/g,'/'); while (b.length % 4) b += '=';
                    let json = null; try { json = JSON.parse(Buffer.from(b,'base64').toString('utf8')); } catch (e) { json = null; }
                    if (json && json.ru) { await page.goto(json.ru, { waitUntil: 'networkidle', timeout: 20000 }).catch(e=>{}); out.callbackRequestUrl = json.ru; break; }
                  }
                } catch (e) {}
              }
            }
          } catch (e) {}
        }
      }
    } catch (e) { out.errors.push({ type: 'inject-cookie', message: String(e) }); }
    fs.writeFileSync('/tmp/login_capture.json', JSON.stringify(out, null, 2));
  } catch (err) {
    out.errors.push({ type: 'script', message: String(err) });
    fs.writeFileSync('/tmp/login_capture.json', JSON.stringify(out, null, 2));
  } finally {
    await browser.close();
  }
})();
