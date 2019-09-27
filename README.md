# gcplat
Google Cloud Platform (GCP) APIs in Nim

## Supported APIs

[Sadly, only the 172 most popular GCP APIs are supported at this time.](https://github.com/disruptek/gcplat/tree/master/src/gcplat) :cry:

## Example

Your import statement names the APIs you want to use and the versions of same,
with any hyphens or periods turned into underscores.

```nim
import asyncdispatch
import httpclient
import httpcore

import gcplat/compute_v1 # ie. Compute API version 1

let
  # the call() gets arguments you might expect; they have sensible
  # defaults depending upon the call, the API, whether they are
  # required, what their types are, whether we can infer a default...
  myProject = computeProjectsGet.call(project="my-project-id")
for response in myProject.retried(tries=3):
  if response.code.is2xx:
    echo waitfor response.body
    break

```

## Details

This project is based almost entirely upon the following:

- OpenAPI Code Generator https://github.com/disruptek/openapi

Patches welcome!

## License

MIT
