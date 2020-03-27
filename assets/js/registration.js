const form = document.getElementById("registration_form");

let buildPublicKeyOptions = (name, challenge) => {
  return {
    challenge: Uint8Array.from(challenge, c => c.charCodeAt(0)),
    rp: {
      name: "Wiwatta Mongkhonchit",
      id: "localhost",
    },
    user: {
      id: window.crypto.getRandomValues(new Uint8Array(64)),
      name: name,
      displayName: name,
    },
    pubKeyCredParams: [{alg: -7, type: "public-key"}],
    timeout: 60000,
    attestation: "direct"
  };
};

form.onsubmit = (e) => {
  e.preventDefault();
  e.stopPropagation();

  let name = e.target.querySelector("input[name='name']");
  let email = e.target.querySelector("input[name='email']");

  challenge(email.value, name.value);
};

async function challenge(email, name) {
  let challenge_url = "http://localhost:4000/register/challenge";
  let challenge_request = {
    headers: { "Content-type": "application/json; charset=utf-8" },
    method: "POST",
    body: JSON.stringify({
      name: name,
      email: email
    })
  };

  let response = await fetch(challenge_url, challenge_request);
  let data = await response.json();
  let pkeyOpts = buildPublicKeyOptions(data.name, data.public_key.challenge);
  let credential = await navigator.credentials.create({publicKey: pkeyOpts});
};
