# gcplat
Google Cloud Platform (GCP) APIs in Nim

## Work in Progress

The request signing hasn't been implemented yet...

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
  request = firebaseProjectsList.call(nil, nil, nil, nil, nil)
  response = request.retried()
echo waitfor response.body
```

## Details

This project is based almost entirely upon the following:

- OpenAPI Code Generator https://github.com/disruptek/openapi

Patches welcome!

## License

MIT
