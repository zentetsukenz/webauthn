async function fetch_json(url, options) {
  const response = await fetch(url, options);
  const body = await response.json();
  if (body.fail)
    throw body.fail;
  return body;
}

async function init (formData) {
  formData.append("step", "init");

  let registration;
  try {
    registration = await fetch_json("/register", {
      method: "POST",
      body: formData
    });
  } catch (err) {
    console.error(err);
    throw err;
  }

  return registration;
};

async function create(challenge, credential) {
  let formData = new FormData();
  formData.append("step", "credential");
  formData.append("challenge", challenge);
  Object.keys(credential).forEach(
    key => formData.append("credential[" + key + "]", credential[key])
  );

  let registrationResponse;
  try {
    registrationResponse = await fetch_json("/register", {
      method: "POST",
      body: formData
    });
  } catch (err) {
    console.error(err);
    throw err;
  }

  return registrationResponse;
}

export { init, create }
