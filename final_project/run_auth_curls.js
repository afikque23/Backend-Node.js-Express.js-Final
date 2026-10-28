const http = require('http');
const fs = require('fs');
const path = require('path');

const outputDir = path.join(__dirname, 'outputs');

function makeRequest(options, body = null) {
  return new Promise((resolve, reject) => {
    const req = http.request(options, (res) => {
      let data = '';
      let cookies = res.headers['set-cookie'] || [];
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        resolve({ statusCode: res.statusCode, body: data, cookies });
      });
    });
    req.on('error', reject);
    if (body) req.write(body);
    req.end();
  });
}

async function run() {
  // Step 1: Register user (already done but doing again to be safe)
  const regBody = JSON.stringify({ username: 'testuser2', password: 'mypassword' });
  const regRes = await makeRequest({
    hostname: 'localhost', port: 5000, path: '/register',
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(regBody) }
  }, regBody);
  console.log('Register:', regRes.body);

  // Step 2: Login to get session cookie
  const loginBody = JSON.stringify({ username: 'testuser2', password: 'mypassword' });
  const loginRes = await makeRequest({
    hostname: 'localhost', port: 5000, path: '/customer/login',
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(loginBody) }
  }, loginBody);
  console.log('Login:', loginRes.body);
  const sessionCookie = loginRes.cookies.map(c => c.split(';')[0]).join('; ');
  console.log('Session cookie:', sessionCookie);

  // Step 3: Add a review for ISBN 1
  const isbn = '1';
  const reviewAddRes = await makeRequest({
    hostname: 'localhost', port: 5000,
    path: `/customer/auth/review/${isbn}?review=This+is+a+great+book!`,
    method: 'PUT',
    headers: { 'Cookie': sessionCookie }
  });
  console.log('Review added:', reviewAddRes.body);

  const reviewAddedCmd = `curl -s -X PUT "http://localhost:5000/customer/auth/review/${isbn}?review=This+is+a+great+book!" --cookie "${sessionCookie}"`;
  fs.writeFileSync(path.join(outputDir, 'reviewadded'),
    `Command: ${reviewAddedCmd}\nOutput:\n${reviewAddRes.body}`, 'utf8');
  console.log('Q9 done: reviewadded');

  // Step 4: Delete the review for ISBN 1
  const reviewDelRes = await makeRequest({
    hostname: 'localhost', port: 5000,
    path: `/customer/auth/review/${isbn}`,
    method: 'DELETE',
    headers: { 'Cookie': sessionCookie }
  });
  console.log('Review deleted:', reviewDelRes.body);

  const reviewDelCmd = `curl -s -X DELETE "http://localhost:5000/customer/auth/review/${isbn}" --cookie "${sessionCookie}"`;
  fs.writeFileSync(path.join(outputDir, 'deletereview'),
    `Command: ${reviewDelCmd}\nOutput:\n${reviewDelRes.body}`, 'utf8');
  console.log('Q10 done: deletereview');

  console.log('All done!');
}

run().catch(console.error);
