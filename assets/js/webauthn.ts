interface User {
  readonly email: string;
}

interface Credential {

}

function getCredentials(user: User): Credential | null {
  console.log(user)

  return null
}

export { User, Credential, getCredentials }