import * as WebAuth from "./webauthn.js";

document.addEventListener("DOMContentLoaded", e => {
  document.getElementById("registration_form").addEventListener("submit", submit);
});

const submit = async (e) => {
  e.preventDefault();
  e.stopPropagation();

  WebAuth.init(new FormData(e.target)).then(handleAfterInit);
};

async function handleAfterInit (registration) {
  switch(registration.instruction) {
  case "credential":
    return await handleCredential(registration);
    break;
  default:
    throw "unhandled instruction";
  }
}

async function handleCredential (registration) {
  const {challenge} = registration.credential;
  const publicKeyOptions = transformCredentialCreateOptions(registration.credential);

  let credential;
  try {
    credential = await navigator.credentials.create({
      publicKey: publicKeyOptions
    });
  } catch (err) {
    console.error(err);
    throw err;
  }

  let credentialForServer = transformNewAssertionForServer(credential);
  WebAuth.create(challenge, credentialForServer)
    .then(resp => console.log(resp));
}

const transformCredentialCreateOptions = (serverOptions) => {
  let credentialOptions = {};

  credentialOptions.challenge = Uint8Array.from(atob(serverOptions.challenge), c => c.charCodeAt(0));

  credentialOptions.rp = {
    id: serverOptions.rp.id,
    name: serverOptions.rp.name,
  };

  credentialOptions.user = {
    id: Uint8Array.from(atob(serverOptions.user.id), c => c.charCodeAt(0)),
    name: serverOptions.user.name,
    displayName: serverOptions.user.display_name,
  };

  credentialOptions.pubKeyCredParams = serverOptions.public_key_credential_params;
  credentialOptions.timeout = serverOptions.timeout;
  credentialOptions.attestation = serverOptions.attestation;

  if (serverOptions.user_verification) {
    credentialOptions.authenticatorSelection = {
      userVerification: serverOptions.user_verification
    };
  }

  return credentialOptions;
};

const transformNewAssertionForServer = (newAssertion) => {
  const attObj = new Uint8Array(newAssertion.response.attestationObject);
  const clientDataJSON = new Uint8Array(newAssertion.response.clientDataJSON);
  const rawId = new Uint8Array(newAssertion.rawId);
  
  const registrationClientExtensions = newAssertion.getClientExtensionResults();

  return {
    id: newAssertion.id,
    raw_id: btoa(rawId),
    type: newAssertion.type,
    attestation_object: btoa(attObj),
    client_data: btoa(clientDataJSON),
    registration_client_extensions: JSON.stringify(registrationClientExtensions)
  };
}
