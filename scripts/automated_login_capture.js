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

  page.on('console', msg => {
    out.consoleLogs.push({ type: msg.type(), text: msg.text() });
    console.log('[console]', msg.type(), msg.text());
  });

  page.on('pageerror', err => {
    out.errors.push({ type: 'pageerror', message: String(err) });
    console.error('[pageerror]', err);
  });

  page.on('request', request => {
    // capture callback request when it is sent
    const url = request.url();
    if (!out.callbackRequestUrl && url.includes('/login/oauth2/code/')) {
      out.callbackRequestUrl = url;
      console.log('[capture] callback request URL:', url);
    }

    // capture first API request to /v2/ or /projects
    if (!out.firstApiRequest && (url.includes('/v2/') || url.match(/\/projects/))) {
      const headers = request.headers();
      out.firstApiRequest = {
        url,
        method: request.method(),
        headers
      };
      console.log('[capture] firstApiRequest:', out.firstApiRequest.url);
    }
  });

  page.on('response', async response => {
    try {
      const url = response.url();
      if (url.includes('/login/oauth2/code/') && !out.callbackResponseHeaders) {
        const headers = response.headers();
        out.callbackResponseHeaders = headers;
        console.log('[capture] callback response headers captured for', url);
      }
    } catch (e) {
      out.errors.push({ type: 'response-handler', message: String(e) });
    }
  });

  try {
    console.log('Opening http://localhost:8060');
    await page.goto('http://localhost:8060', { waitUntil: 'networkidle', timeout: 60000 });

    // Wait briefly for SPA to perform any initial XHRs
    await page.waitForTimeout(2000);

    // If there's a login button/link, try to click it. We'll try multiple selectors.
    const loginSelectors = ['a.login', 'button.login', 'a[href*="oauth2"]', 'a[href*="/login"]', 'button[aria-label="login"]'];
    for (const sel of loginSelectors) {
      try {
        const el = await page.$(sel);
        if (el) {
          console.log('Found login element', sel, 'clicking');
          await el.click();
          break;
        }
      } catch (e) {
        // ignore
      }
    }

    // Wait up to 30s for navigation to Keycloak login page (it will be a navigation to realm openid-connect/auth)
    console.log('Waiting for navigation to Keycloak login...');
    const nav = await Promise.race([
      page.waitForNavigation({ waitUntil: 'domcontentloaded', timeout: 30000 }).catch(e => null),
      (async () => { await page.waitForTimeout(30000); return null; })()
    ]);

    // If page URL contains keycloak auth, attempt to fill credentials
    let currentUrl = page.url();
    console.log('Current URL after initial wait:', currentUrl);

    if (currentUrl.includes('/realms') || currentUrl.includes('/protocol/openid-connect/auth')) {
      console.log('Detected Keycloak login page, attempting to fill credentials');
      // try common selectors
      try {
        await page.fill('input[name="username"]', 'admin');
        await page.fill('input[name="password"]', 'admin');
        await page.click('input[type="submit"], button[type="submit"], button.login-button');
      } catch (e) {
        console.log('Could not auto-fill Keycloak form:', e.message);
      }
    } else {
      console.log('Not on Keycloak login page; continuing to wait for callback or XHRs');
    }

    // Wait up to 40s for callback request/response to occur
    const start = Date.now();
    while ((Date.now() - start) < 40000 && (!out.callbackRequestUrl || !out.callbackResponseHeaders)) {
      await page.waitForTimeout(1000);
    }

    // After waiting, also gather cookies
    const cookies = await context.cookies();
    out.cookies = cookies;

    // Save result
    fs.writeFileSync('/tmp/login_capture.json', JSON.stringify(out, null, 2));
    console.log('Saved capture to /tmp/login_capture.json');
  } catch (err) {
    console.error('Script error', err);
    out.errors.push({ type: 'script', message: String(err) });
    fs.writeFileSync('/tmp/login_capture.json', JSON.stringify(out, null, 2));
  } finally {
    await browser.close();
    console.log('Browser closed');
  }
})();

