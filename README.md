# gcplat
Google Cloud Platform (GCP) APIs in Nim

## Work in Progress

Haven't decided how to handle parameters with empty strings, so for now, you need to supply JSON arguments to the `call` as per the fallback https://github.com/disruptek/openapi syntax...

## Supported APIs

[Sadly, only the 172 most popular GCP APIs are supported at this time.](https://github.com/disruptek/gcplat/tree/master/src/gcplat) :cry:

## Example

Your import statement names the APIs you want to use and the versions of same,
with any hyphens or periods turned into underscores.

```nim
import asyncdispatch
import httpclient
import httpcore

import gcplat/firebase_v1beta1  # ie. Firebase v1beta1

# setup authentication with supplied service account credentials
var auth = newAuthenticator("/some/path/service_account.json")

# add some scopes
auth.scope.add "https://www.googleapis.com/auth/cloud-platform"
auth.scope.add "https://www.googleapis.com/auth/logging.write"
auth.scope.add "https://www.googleapis.com/auth/drive"

let
  request = firebaseProjectsList.call(path=nil, query=nil, header=nil,
                                      formData=nil, body=nil)
  response = request.retried()
echo waitfor response.body

# you can optionally refresh your authentication token manually
# (by default we ensure the token will last at least 10 seconds)

# to make sure this token won't expire in the next 60 seconds
let freshFor1min = waitfor authenticate(fresh = 60)
assert freshFor1min == true

# to fetch a new token that will expire in 15min
let lasts15min = waitfor authenticate(lifetime = 15 * 60)
assert lasts15min == true
```

## Details

This project is based almost entirely upon the following:

- OpenAPI Code Generator https://github.com/disruptek/openapi

Patches welcome!

## License

MIT
