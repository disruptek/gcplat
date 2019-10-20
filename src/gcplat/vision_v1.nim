
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Vision
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Integrates Google Vision features, including image labeling, face, logo, and landmark detection, optical character recognition (OCR), and detection of explicit content, into applications.
## 
## https://cloud.google.com/vision/
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_578348 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578348](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578348): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "vision"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_VisionFilesAnnotate_578619 = ref object of OpenApiRestCall_578348
proc url_VisionFilesAnnotate_578621(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_VisionFilesAnnotate_578620(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Service that performs image detection and annotation for a batch of files.
  ## Now only "application/pdf", "image/tiff" and "image/gif" are supported.
  ## 
  ## This service will extract at most 5 (customers can specify which 5 in
  ## AnnotateFileRequest.pages) frames (gif) or pages (pdf or tiff) from each
  ## file provided and perform detection and annotation for each image
  ## extracted.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578733 = query.getOrDefault("key")
  valid_578733 = validateParameter(valid_578733, JString, required = false,
                                 default = nil)
  if valid_578733 != nil:
    section.add "key", valid_578733
  var valid_578747 = query.getOrDefault("prettyPrint")
  valid_578747 = validateParameter(valid_578747, JBool, required = false,
                                 default = newJBool(true))
  if valid_578747 != nil:
    section.add "prettyPrint", valid_578747
  var valid_578748 = query.getOrDefault("oauth_token")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "oauth_token", valid_578748
  var valid_578749 = query.getOrDefault("$.xgafv")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = newJString("1"))
  if valid_578749 != nil:
    section.add "$.xgafv", valid_578749
  var valid_578750 = query.getOrDefault("alt")
  valid_578750 = validateParameter(valid_578750, JString, required = false,
                                 default = newJString("json"))
  if valid_578750 != nil:
    section.add "alt", valid_578750
  var valid_578751 = query.getOrDefault("uploadType")
  valid_578751 = validateParameter(valid_578751, JString, required = false,
                                 default = nil)
  if valid_578751 != nil:
    section.add "uploadType", valid_578751
  var valid_578752 = query.getOrDefault("quotaUser")
  valid_578752 = validateParameter(valid_578752, JString, required = false,
                                 default = nil)
  if valid_578752 != nil:
    section.add "quotaUser", valid_578752
  var valid_578753 = query.getOrDefault("callback")
  valid_578753 = validateParameter(valid_578753, JString, required = false,
                                 default = nil)
  if valid_578753 != nil:
    section.add "callback", valid_578753
  var valid_578754 = query.getOrDefault("fields")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "fields", valid_578754
  var valid_578755 = query.getOrDefault("access_token")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "access_token", valid_578755
  var valid_578756 = query.getOrDefault("upload_protocol")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "upload_protocol", valid_578756
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578780: Call_VisionFilesAnnotate_578619; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Service that performs image detection and annotation for a batch of files.
  ## Now only "application/pdf", "image/tiff" and "image/gif" are supported.
  ## 
  ## This service will extract at most 5 (customers can specify which 5 in
  ## AnnotateFileRequest.pages) frames (gif) or pages (pdf or tiff) from each
  ## file provided and perform detection and annotation for each image
  ## extracted.
  ## 
  let valid = call_578780.validator(path, query, header, formData, body)
  let scheme = call_578780.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578780.url(scheme.get, call_578780.host, call_578780.base,
                         call_578780.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578780, url, valid)

proc call*(call_578851: Call_VisionFilesAnnotate_578619; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## visionFilesAnnotate
  ## Service that performs image detection and annotation for a batch of files.
  ## Now only "application/pdf", "image/tiff" and "image/gif" are supported.
  ## 
  ## This service will extract at most 5 (customers can specify which 5 in
  ## AnnotateFileRequest.pages) frames (gif) or pages (pdf or tiff) from each
  ## file provided and perform detection and annotation for each image
  ## extracted.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578852 = newJObject()
  var body_578854 = newJObject()
  add(query_578852, "key", newJString(key))
  add(query_578852, "prettyPrint", newJBool(prettyPrint))
  add(query_578852, "oauth_token", newJString(oauthToken))
  add(query_578852, "$.xgafv", newJString(Xgafv))
  add(query_578852, "alt", newJString(alt))
  add(query_578852, "uploadType", newJString(uploadType))
  add(query_578852, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578854 = body
  add(query_578852, "callback", newJString(callback))
  add(query_578852, "fields", newJString(fields))
  add(query_578852, "access_token", newJString(accessToken))
  add(query_578852, "upload_protocol", newJString(uploadProtocol))
  result = call_578851.call(nil, query_578852, nil, nil, body_578854)

var visionFilesAnnotate* = Call_VisionFilesAnnotate_578619(
    name: "visionFilesAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/files:annotate",
    validator: validate_VisionFilesAnnotate_578620, base: "/",
    url: url_VisionFilesAnnotate_578621, schemes: {Scheme.Https})
type
  Call_VisionFilesAsyncBatchAnnotate_578893 = ref object of OpenApiRestCall_578348
proc url_VisionFilesAsyncBatchAnnotate_578895(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_VisionFilesAsyncBatchAnnotate_578894(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Run asynchronous image detection and annotation for a list of generic
  ## files, such as PDF files, which may contain multiple pages and multiple
  ## images per page. Progress and results can be retrieved through the
  ## `google.longrunning.Operations` interface.
  ## `Operation.metadata` contains `OperationMetadata` (metadata).
  ## `Operation.response` contains `AsyncBatchAnnotateFilesResponse` (results).
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578896 = query.getOrDefault("key")
  valid_578896 = validateParameter(valid_578896, JString, required = false,
                                 default = nil)
  if valid_578896 != nil:
    section.add "key", valid_578896
  var valid_578897 = query.getOrDefault("prettyPrint")
  valid_578897 = validateParameter(valid_578897, JBool, required = false,
                                 default = newJBool(true))
  if valid_578897 != nil:
    section.add "prettyPrint", valid_578897
  var valid_578898 = query.getOrDefault("oauth_token")
  valid_578898 = validateParameter(valid_578898, JString, required = false,
                                 default = nil)
  if valid_578898 != nil:
    section.add "oauth_token", valid_578898
  var valid_578899 = query.getOrDefault("$.xgafv")
  valid_578899 = validateParameter(valid_578899, JString, required = false,
                                 default = newJString("1"))
  if valid_578899 != nil:
    section.add "$.xgafv", valid_578899
  var valid_578900 = query.getOrDefault("alt")
  valid_578900 = validateParameter(valid_578900, JString, required = false,
                                 default = newJString("json"))
  if valid_578900 != nil:
    section.add "alt", valid_578900
  var valid_578901 = query.getOrDefault("uploadType")
  valid_578901 = validateParameter(valid_578901, JString, required = false,
                                 default = nil)
  if valid_578901 != nil:
    section.add "uploadType", valid_578901
  var valid_578902 = query.getOrDefault("quotaUser")
  valid_578902 = validateParameter(valid_578902, JString, required = false,
                                 default = nil)
  if valid_578902 != nil:
    section.add "quotaUser", valid_578902
  var valid_578903 = query.getOrDefault("callback")
  valid_578903 = validateParameter(valid_578903, JString, required = false,
                                 default = nil)
  if valid_578903 != nil:
    section.add "callback", valid_578903
  var valid_578904 = query.getOrDefault("fields")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "fields", valid_578904
  var valid_578905 = query.getOrDefault("access_token")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = nil)
  if valid_578905 != nil:
    section.add "access_token", valid_578905
  var valid_578906 = query.getOrDefault("upload_protocol")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = nil)
  if valid_578906 != nil:
    section.add "upload_protocol", valid_578906
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578908: Call_VisionFilesAsyncBatchAnnotate_578893; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Run asynchronous image detection and annotation for a list of generic
  ## files, such as PDF files, which may contain multiple pages and multiple
  ## images per page. Progress and results can be retrieved through the
  ## `google.longrunning.Operations` interface.
  ## `Operation.metadata` contains `OperationMetadata` (metadata).
  ## `Operation.response` contains `AsyncBatchAnnotateFilesResponse` (results).
  ## 
  let valid = call_578908.validator(path, query, header, formData, body)
  let scheme = call_578908.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578908.url(scheme.get, call_578908.host, call_578908.base,
                         call_578908.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578908, url, valid)

proc call*(call_578909: Call_VisionFilesAsyncBatchAnnotate_578893;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## visionFilesAsyncBatchAnnotate
  ## Run asynchronous image detection and annotation for a list of generic
  ## files, such as PDF files, which may contain multiple pages and multiple
  ## images per page. Progress and results can be retrieved through the
  ## `google.longrunning.Operations` interface.
  ## `Operation.metadata` contains `OperationMetadata` (metadata).
  ## `Operation.response` contains `AsyncBatchAnnotateFilesResponse` (results).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578910 = newJObject()
  var body_578911 = newJObject()
  add(query_578910, "key", newJString(key))
  add(query_578910, "prettyPrint", newJBool(prettyPrint))
  add(query_578910, "oauth_token", newJString(oauthToken))
  add(query_578910, "$.xgafv", newJString(Xgafv))
  add(query_578910, "alt", newJString(alt))
  add(query_578910, "uploadType", newJString(uploadType))
  add(query_578910, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578911 = body
  add(query_578910, "callback", newJString(callback))
  add(query_578910, "fields", newJString(fields))
  add(query_578910, "access_token", newJString(accessToken))
  add(query_578910, "upload_protocol", newJString(uploadProtocol))
  result = call_578909.call(nil, query_578910, nil, nil, body_578911)

var visionFilesAsyncBatchAnnotate* = Call_VisionFilesAsyncBatchAnnotate_578893(
    name: "visionFilesAsyncBatchAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/files:asyncBatchAnnotate",
    validator: validate_VisionFilesAsyncBatchAnnotate_578894, base: "/",
    url: url_VisionFilesAsyncBatchAnnotate_578895, schemes: {Scheme.Https})
type
  Call_VisionImagesAnnotate_578912 = ref object of OpenApiRestCall_578348
proc url_VisionImagesAnnotate_578914(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_VisionImagesAnnotate_578913(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Run image detection and annotation for a batch of images.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578915 = query.getOrDefault("key")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "key", valid_578915
  var valid_578916 = query.getOrDefault("prettyPrint")
  valid_578916 = validateParameter(valid_578916, JBool, required = false,
                                 default = newJBool(true))
  if valid_578916 != nil:
    section.add "prettyPrint", valid_578916
  var valid_578917 = query.getOrDefault("oauth_token")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "oauth_token", valid_578917
  var valid_578918 = query.getOrDefault("$.xgafv")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = newJString("1"))
  if valid_578918 != nil:
    section.add "$.xgafv", valid_578918
  var valid_578919 = query.getOrDefault("alt")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = newJString("json"))
  if valid_578919 != nil:
    section.add "alt", valid_578919
  var valid_578920 = query.getOrDefault("uploadType")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "uploadType", valid_578920
  var valid_578921 = query.getOrDefault("quotaUser")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "quotaUser", valid_578921
  var valid_578922 = query.getOrDefault("callback")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "callback", valid_578922
  var valid_578923 = query.getOrDefault("fields")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "fields", valid_578923
  var valid_578924 = query.getOrDefault("access_token")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "access_token", valid_578924
  var valid_578925 = query.getOrDefault("upload_protocol")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "upload_protocol", valid_578925
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578927: Call_VisionImagesAnnotate_578912; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Run image detection and annotation for a batch of images.
  ## 
  let valid = call_578927.validator(path, query, header, formData, body)
  let scheme = call_578927.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578927.url(scheme.get, call_578927.host, call_578927.base,
                         call_578927.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578927, url, valid)

proc call*(call_578928: Call_VisionImagesAnnotate_578912; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## visionImagesAnnotate
  ## Run image detection and annotation for a batch of images.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578929 = newJObject()
  var body_578930 = newJObject()
  add(query_578929, "key", newJString(key))
  add(query_578929, "prettyPrint", newJBool(prettyPrint))
  add(query_578929, "oauth_token", newJString(oauthToken))
  add(query_578929, "$.xgafv", newJString(Xgafv))
  add(query_578929, "alt", newJString(alt))
  add(query_578929, "uploadType", newJString(uploadType))
  add(query_578929, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578930 = body
  add(query_578929, "callback", newJString(callback))
  add(query_578929, "fields", newJString(fields))
  add(query_578929, "access_token", newJString(accessToken))
  add(query_578929, "upload_protocol", newJString(uploadProtocol))
  result = call_578928.call(nil, query_578929, nil, nil, body_578930)

var visionImagesAnnotate* = Call_VisionImagesAnnotate_578912(
    name: "visionImagesAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/images:annotate",
    validator: validate_VisionImagesAnnotate_578913, base: "/",
    url: url_VisionImagesAnnotate_578914, schemes: {Scheme.Https})
type
  Call_VisionImagesAsyncBatchAnnotate_578931 = ref object of OpenApiRestCall_578348
proc url_VisionImagesAsyncBatchAnnotate_578933(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_VisionImagesAsyncBatchAnnotate_578932(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Run asynchronous image detection and annotation for a list of images.
  ## 
  ## Progress and results can be retrieved through the
  ## `google.longrunning.Operations` interface.
  ## `Operation.metadata` contains `OperationMetadata` (metadata).
  ## `Operation.response` contains `AsyncBatchAnnotateImagesResponse` (results).
  ## 
  ## This service will write image annotation outputs to json files in customer
  ## GCS bucket, each json file containing BatchAnnotateImagesResponse proto.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578934 = query.getOrDefault("key")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "key", valid_578934
  var valid_578935 = query.getOrDefault("prettyPrint")
  valid_578935 = validateParameter(valid_578935, JBool, required = false,
                                 default = newJBool(true))
  if valid_578935 != nil:
    section.add "prettyPrint", valid_578935
  var valid_578936 = query.getOrDefault("oauth_token")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "oauth_token", valid_578936
  var valid_578937 = query.getOrDefault("$.xgafv")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = newJString("1"))
  if valid_578937 != nil:
    section.add "$.xgafv", valid_578937
  var valid_578938 = query.getOrDefault("alt")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = newJString("json"))
  if valid_578938 != nil:
    section.add "alt", valid_578938
  var valid_578939 = query.getOrDefault("uploadType")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "uploadType", valid_578939
  var valid_578940 = query.getOrDefault("quotaUser")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "quotaUser", valid_578940
  var valid_578941 = query.getOrDefault("callback")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "callback", valid_578941
  var valid_578942 = query.getOrDefault("fields")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "fields", valid_578942
  var valid_578943 = query.getOrDefault("access_token")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "access_token", valid_578943
  var valid_578944 = query.getOrDefault("upload_protocol")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "upload_protocol", valid_578944
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578946: Call_VisionImagesAsyncBatchAnnotate_578931; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Run asynchronous image detection and annotation for a list of images.
  ## 
  ## Progress and results can be retrieved through the
  ## `google.longrunning.Operations` interface.
  ## `Operation.metadata` contains `OperationMetadata` (metadata).
  ## `Operation.response` contains `AsyncBatchAnnotateImagesResponse` (results).
  ## 
  ## This service will write image annotation outputs to json files in customer
  ## GCS bucket, each json file containing BatchAnnotateImagesResponse proto.
  ## 
  let valid = call_578946.validator(path, query, header, formData, body)
  let scheme = call_578946.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578946.url(scheme.get, call_578946.host, call_578946.base,
                         call_578946.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578946, url, valid)

proc call*(call_578947: Call_VisionImagesAsyncBatchAnnotate_578931;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## visionImagesAsyncBatchAnnotate
  ## Run asynchronous image detection and annotation for a list of images.
  ## 
  ## Progress and results can be retrieved through the
  ## `google.longrunning.Operations` interface.
  ## `Operation.metadata` contains `OperationMetadata` (metadata).
  ## `Operation.response` contains `AsyncBatchAnnotateImagesResponse` (results).
  ## 
  ## This service will write image annotation outputs to json files in customer
  ## GCS bucket, each json file containing BatchAnnotateImagesResponse proto.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578948 = newJObject()
  var body_578949 = newJObject()
  add(query_578948, "key", newJString(key))
  add(query_578948, "prettyPrint", newJBool(prettyPrint))
  add(query_578948, "oauth_token", newJString(oauthToken))
  add(query_578948, "$.xgafv", newJString(Xgafv))
  add(query_578948, "alt", newJString(alt))
  add(query_578948, "uploadType", newJString(uploadType))
  add(query_578948, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578949 = body
  add(query_578948, "callback", newJString(callback))
  add(query_578948, "fields", newJString(fields))
  add(query_578948, "access_token", newJString(accessToken))
  add(query_578948, "upload_protocol", newJString(uploadProtocol))
  result = call_578947.call(nil, query_578948, nil, nil, body_578949)

var visionImagesAsyncBatchAnnotate* = Call_VisionImagesAsyncBatchAnnotate_578931(
    name: "visionImagesAsyncBatchAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/images:asyncBatchAnnotate",
    validator: validate_VisionImagesAsyncBatchAnnotate_578932, base: "/",
    url: url_VisionImagesAsyncBatchAnnotate_578933, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsGet_578950 = ref object of OpenApiRestCall_578348
proc url_VisionProjectsLocationsProductSetsGet_578952(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VisionProjectsLocationsProductSetsGet_578951(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information associated with a ProductSet.
  ## 
  ## Possible errors:
  ## 
  ## * Returns NOT_FOUND if the ProductSet does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. Resource name of the ProductSet to get.
  ## 
  ## Format is:
  ## `projects/PROJECT_ID/locations/LOG_ID/productSets/PRODUCT_SET_ID`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578967 = path.getOrDefault("name")
  valid_578967 = validateParameter(valid_578967, JString, required = true,
                                 default = nil)
  if valid_578967 != nil:
    section.add "name", valid_578967
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578968 = query.getOrDefault("key")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "key", valid_578968
  var valid_578969 = query.getOrDefault("prettyPrint")
  valid_578969 = validateParameter(valid_578969, JBool, required = false,
                                 default = newJBool(true))
  if valid_578969 != nil:
    section.add "prettyPrint", valid_578969
  var valid_578970 = query.getOrDefault("oauth_token")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "oauth_token", valid_578970
  var valid_578971 = query.getOrDefault("$.xgafv")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = newJString("1"))
  if valid_578971 != nil:
    section.add "$.xgafv", valid_578971
  var valid_578972 = query.getOrDefault("alt")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = newJString("json"))
  if valid_578972 != nil:
    section.add "alt", valid_578972
  var valid_578973 = query.getOrDefault("uploadType")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "uploadType", valid_578973
  var valid_578974 = query.getOrDefault("quotaUser")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "quotaUser", valid_578974
  var valid_578975 = query.getOrDefault("callback")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "callback", valid_578975
  var valid_578976 = query.getOrDefault("fields")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "fields", valid_578976
  var valid_578977 = query.getOrDefault("access_token")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "access_token", valid_578977
  var valid_578978 = query.getOrDefault("upload_protocol")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "upload_protocol", valid_578978
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578979: Call_VisionProjectsLocationsProductSetsGet_578950;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information associated with a ProductSet.
  ## 
  ## Possible errors:
  ## 
  ## * Returns NOT_FOUND if the ProductSet does not exist.
  ## 
  let valid = call_578979.validator(path, query, header, formData, body)
  let scheme = call_578979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578979.url(scheme.get, call_578979.host, call_578979.base,
                         call_578979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578979, url, valid)

proc call*(call_578980: Call_VisionProjectsLocationsProductSetsGet_578950;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## visionProjectsLocationsProductSetsGet
  ## Gets information associated with a ProductSet.
  ## 
  ## Possible errors:
  ## 
  ## * Returns NOT_FOUND if the ProductSet does not exist.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. Resource name of the ProductSet to get.
  ## 
  ## Format is:
  ## `projects/PROJECT_ID/locations/LOG_ID/productSets/PRODUCT_SET_ID`
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578981 = newJObject()
  var query_578982 = newJObject()
  add(query_578982, "key", newJString(key))
  add(query_578982, "prettyPrint", newJBool(prettyPrint))
  add(query_578982, "oauth_token", newJString(oauthToken))
  add(query_578982, "$.xgafv", newJString(Xgafv))
  add(query_578982, "alt", newJString(alt))
  add(query_578982, "uploadType", newJString(uploadType))
  add(query_578982, "quotaUser", newJString(quotaUser))
  add(path_578981, "name", newJString(name))
  add(query_578982, "callback", newJString(callback))
  add(query_578982, "fields", newJString(fields))
  add(query_578982, "access_token", newJString(accessToken))
  add(query_578982, "upload_protocol", newJString(uploadProtocol))
  result = call_578980.call(path_578981, query_578982, nil, nil, nil)

var visionProjectsLocationsProductSetsGet* = Call_VisionProjectsLocationsProductSetsGet_578950(
    name: "visionProjectsLocationsProductSetsGet", meth: HttpMethod.HttpGet,
    host: "vision.googleapis.com", route: "/v1/{name}",
    validator: validate_VisionProjectsLocationsProductSetsGet_578951, base: "/",
    url: url_VisionProjectsLocationsProductSetsGet_578952, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsPatch_579002 = ref object of OpenApiRestCall_578348
proc url_VisionProjectsLocationsProductSetsPatch_579004(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VisionProjectsLocationsProductSetsPatch_579003(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Makes changes to a ProductSet resource.
  ## Only display_name can be updated currently.
  ## 
  ## Possible errors:
  ## 
  ## * Returns NOT_FOUND if the ProductSet does not exist.
  ## * Returns INVALID_ARGUMENT if display_name is present in update_mask but
  ##   missing from the request or longer than 4096 characters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the ProductSet.
  ## 
  ## Format is:
  ## `projects/PROJECT_ID/locations/LOC_ID/productSets/PRODUCT_SET_ID`.
  ## 
  ## This field is ignored when creating a ProductSet.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579005 = path.getOrDefault("name")
  valid_579005 = validateParameter(valid_579005, JString, required = true,
                                 default = nil)
  if valid_579005 != nil:
    section.add "name", valid_579005
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: JString
  ##             : The FieldMask that specifies which fields to
  ## update.
  ## If update_mask isn't specified, all mutable fields are to be updated.
  ## Valid mask path is `display_name`.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579006 = query.getOrDefault("key")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "key", valid_579006
  var valid_579007 = query.getOrDefault("prettyPrint")
  valid_579007 = validateParameter(valid_579007, JBool, required = false,
                                 default = newJBool(true))
  if valid_579007 != nil:
    section.add "prettyPrint", valid_579007
  var valid_579008 = query.getOrDefault("oauth_token")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "oauth_token", valid_579008
  var valid_579009 = query.getOrDefault("$.xgafv")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = newJString("1"))
  if valid_579009 != nil:
    section.add "$.xgafv", valid_579009
  var valid_579010 = query.getOrDefault("alt")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = newJString("json"))
  if valid_579010 != nil:
    section.add "alt", valid_579010
  var valid_579011 = query.getOrDefault("uploadType")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "uploadType", valid_579011
  var valid_579012 = query.getOrDefault("quotaUser")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "quotaUser", valid_579012
  var valid_579013 = query.getOrDefault("updateMask")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "updateMask", valid_579013
  var valid_579014 = query.getOrDefault("callback")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "callback", valid_579014
  var valid_579015 = query.getOrDefault("fields")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "fields", valid_579015
  var valid_579016 = query.getOrDefault("access_token")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "access_token", valid_579016
  var valid_579017 = query.getOrDefault("upload_protocol")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "upload_protocol", valid_579017
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579019: Call_VisionProjectsLocationsProductSetsPatch_579002;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Makes changes to a ProductSet resource.
  ## Only display_name can be updated currently.
  ## 
  ## Possible errors:
  ## 
  ## * Returns NOT_FOUND if the ProductSet does not exist.
  ## * Returns INVALID_ARGUMENT if display_name is present in update_mask but
  ##   missing from the request or longer than 4096 characters.
  ## 
  let valid = call_579019.validator(path, query, header, formData, body)
  let scheme = call_579019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579019.url(scheme.get, call_579019.host, call_579019.base,
                         call_579019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579019, url, valid)

proc call*(call_579020: Call_VisionProjectsLocationsProductSetsPatch_579002;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; updateMask: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## visionProjectsLocationsProductSetsPatch
  ## Makes changes to a ProductSet resource.
  ## Only display_name can be updated currently.
  ## 
  ## Possible errors:
  ## 
  ## * Returns NOT_FOUND if the ProductSet does not exist.
  ## * Returns INVALID_ARGUMENT if display_name is present in update_mask but
  ##   missing from the request or longer than 4096 characters.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the ProductSet.
  ## 
  ## Format is:
  ## `projects/PROJECT_ID/locations/LOC_ID/productSets/PRODUCT_SET_ID`.
  ## 
  ## This field is ignored when creating a ProductSet.
  ##   updateMask: string
  ##             : The FieldMask that specifies which fields to
  ## update.
  ## If update_mask isn't specified, all mutable fields are to be updated.
  ## Valid mask path is `display_name`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579021 = newJObject()
  var query_579022 = newJObject()
  var body_579023 = newJObject()
  add(query_579022, "key", newJString(key))
  add(query_579022, "prettyPrint", newJBool(prettyPrint))
  add(query_579022, "oauth_token", newJString(oauthToken))
  add(query_579022, "$.xgafv", newJString(Xgafv))
  add(query_579022, "alt", newJString(alt))
  add(query_579022, "uploadType", newJString(uploadType))
  add(query_579022, "quotaUser", newJString(quotaUser))
  add(path_579021, "name", newJString(name))
  add(query_579022, "updateMask", newJString(updateMask))
  if body != nil:
    body_579023 = body
  add(query_579022, "callback", newJString(callback))
  add(query_579022, "fields", newJString(fields))
  add(query_579022, "access_token", newJString(accessToken))
  add(query_579022, "upload_protocol", newJString(uploadProtocol))
  result = call_579020.call(path_579021, query_579022, nil, nil, body_579023)

var visionProjectsLocationsProductSetsPatch* = Call_VisionProjectsLocationsProductSetsPatch_579002(
    name: "visionProjectsLocationsProductSetsPatch", meth: HttpMethod.HttpPatch,
    host: "vision.googleapis.com", route: "/v1/{name}",
    validator: validate_VisionProjectsLocationsProductSetsPatch_579003, base: "/",
    url: url_VisionProjectsLocationsProductSetsPatch_579004,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsDelete_578983 = ref object of OpenApiRestCall_578348
proc url_VisionProjectsLocationsProductSetsDelete_578985(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VisionProjectsLocationsProductSetsDelete_578984(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Permanently deletes a ProductSet. Products and ReferenceImages in the
  ## ProductSet are not deleted.
  ## 
  ## The actual image files are not deleted from Google Cloud Storage.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. Resource name of the ProductSet to delete.
  ## 
  ## Format is:
  ## `projects/PROJECT_ID/locations/LOC_ID/productSets/PRODUCT_SET_ID`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578986 = path.getOrDefault("name")
  valid_578986 = validateParameter(valid_578986, JString, required = true,
                                 default = nil)
  if valid_578986 != nil:
    section.add "name", valid_578986
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578987 = query.getOrDefault("key")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "key", valid_578987
  var valid_578988 = query.getOrDefault("prettyPrint")
  valid_578988 = validateParameter(valid_578988, JBool, required = false,
                                 default = newJBool(true))
  if valid_578988 != nil:
    section.add "prettyPrint", valid_578988
  var valid_578989 = query.getOrDefault("oauth_token")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "oauth_token", valid_578989
  var valid_578990 = query.getOrDefault("$.xgafv")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = newJString("1"))
  if valid_578990 != nil:
    section.add "$.xgafv", valid_578990
  var valid_578991 = query.getOrDefault("alt")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = newJString("json"))
  if valid_578991 != nil:
    section.add "alt", valid_578991
  var valid_578992 = query.getOrDefault("uploadType")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "uploadType", valid_578992
  var valid_578993 = query.getOrDefault("quotaUser")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "quotaUser", valid_578993
  var valid_578994 = query.getOrDefault("callback")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "callback", valid_578994
  var valid_578995 = query.getOrDefault("fields")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "fields", valid_578995
  var valid_578996 = query.getOrDefault("access_token")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "access_token", valid_578996
  var valid_578997 = query.getOrDefault("upload_protocol")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "upload_protocol", valid_578997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578998: Call_VisionProjectsLocationsProductSetsDelete_578983;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently deletes a ProductSet. Products and ReferenceImages in the
  ## ProductSet are not deleted.
  ## 
  ## The actual image files are not deleted from Google Cloud Storage.
  ## 
  let valid = call_578998.validator(path, query, header, formData, body)
  let scheme = call_578998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578998.url(scheme.get, call_578998.host, call_578998.base,
                         call_578998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578998, url, valid)

proc call*(call_578999: Call_VisionProjectsLocationsProductSetsDelete_578983;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## visionProjectsLocationsProductSetsDelete
  ## Permanently deletes a ProductSet. Products and ReferenceImages in the
  ## ProductSet are not deleted.
  ## 
  ## The actual image files are not deleted from Google Cloud Storage.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. Resource name of the ProductSet to delete.
  ## 
  ## Format is:
  ## `projects/PROJECT_ID/locations/LOC_ID/productSets/PRODUCT_SET_ID`
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579000 = newJObject()
  var query_579001 = newJObject()
  add(query_579001, "key", newJString(key))
  add(query_579001, "prettyPrint", newJBool(prettyPrint))
  add(query_579001, "oauth_token", newJString(oauthToken))
  add(query_579001, "$.xgafv", newJString(Xgafv))
  add(query_579001, "alt", newJString(alt))
  add(query_579001, "uploadType", newJString(uploadType))
  add(query_579001, "quotaUser", newJString(quotaUser))
  add(path_579000, "name", newJString(name))
  add(query_579001, "callback", newJString(callback))
  add(query_579001, "fields", newJString(fields))
  add(query_579001, "access_token", newJString(accessToken))
  add(query_579001, "upload_protocol", newJString(uploadProtocol))
  result = call_578999.call(path_579000, query_579001, nil, nil, nil)

var visionProjectsLocationsProductSetsDelete* = Call_VisionProjectsLocationsProductSetsDelete_578983(
    name: "visionProjectsLocationsProductSetsDelete", meth: HttpMethod.HttpDelete,
    host: "vision.googleapis.com", route: "/v1/{name}",
    validator: validate_VisionProjectsLocationsProductSetsDelete_578984,
    base: "/", url: url_VisionProjectsLocationsProductSetsDelete_578985,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsProductsList_579024 = ref object of OpenApiRestCall_578348
proc url_VisionProjectsLocationsProductSetsProductsList_579026(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/products")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VisionProjectsLocationsProductSetsProductsList_579025(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the Products in a ProductSet, in an unspecified order. If the
  ## ProductSet does not exist, the products field of the response will be
  ## empty.
  ## 
  ## Possible errors:
  ## 
  ## * Returns INVALID_ARGUMENT if page_size is greater than 100 or less than 1.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The ProductSet resource for which to retrieve Products.
  ## 
  ## Format is:
  ## `projects/PROJECT_ID/locations/LOC_ID/productSets/PRODUCT_SET_ID`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579027 = path.getOrDefault("name")
  valid_579027 = validateParameter(valid_579027, JString, required = true,
                                 default = nil)
  if valid_579027 != nil:
    section.add "name", valid_579027
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of items to return. Default 10, maximum 100.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The next_page_token returned from a previous List request, if any.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579028 = query.getOrDefault("key")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "key", valid_579028
  var valid_579029 = query.getOrDefault("prettyPrint")
  valid_579029 = validateParameter(valid_579029, JBool, required = false,
                                 default = newJBool(true))
  if valid_579029 != nil:
    section.add "prettyPrint", valid_579029
  var valid_579030 = query.getOrDefault("oauth_token")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "oauth_token", valid_579030
  var valid_579031 = query.getOrDefault("$.xgafv")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = newJString("1"))
  if valid_579031 != nil:
    section.add "$.xgafv", valid_579031
  var valid_579032 = query.getOrDefault("pageSize")
  valid_579032 = validateParameter(valid_579032, JInt, required = false, default = nil)
  if valid_579032 != nil:
    section.add "pageSize", valid_579032
  var valid_579033 = query.getOrDefault("alt")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = newJString("json"))
  if valid_579033 != nil:
    section.add "alt", valid_579033
  var valid_579034 = query.getOrDefault("uploadType")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "uploadType", valid_579034
  var valid_579035 = query.getOrDefault("quotaUser")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "quotaUser", valid_579035
  var valid_579036 = query.getOrDefault("pageToken")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "pageToken", valid_579036
  var valid_579037 = query.getOrDefault("callback")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "callback", valid_579037
  var valid_579038 = query.getOrDefault("fields")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "fields", valid_579038
  var valid_579039 = query.getOrDefault("access_token")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "access_token", valid_579039
  var valid_579040 = query.getOrDefault("upload_protocol")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "upload_protocol", valid_579040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579041: Call_VisionProjectsLocationsProductSetsProductsList_579024;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the Products in a ProductSet, in an unspecified order. If the
  ## ProductSet does not exist, the products field of the response will be
  ## empty.
  ## 
  ## Possible errors:
  ## 
  ## * Returns INVALID_ARGUMENT if page_size is greater than 100 or less than 1.
  ## 
  let valid = call_579041.validator(path, query, header, formData, body)
  let scheme = call_579041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579041.url(scheme.get, call_579041.host, call_579041.base,
                         call_579041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579041, url, valid)

proc call*(call_579042: Call_VisionProjectsLocationsProductSetsProductsList_579024;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## visionProjectsLocationsProductSetsProductsList
  ## Lists the Products in a ProductSet, in an unspecified order. If the
  ## ProductSet does not exist, the products field of the response will be
  ## empty.
  ## 
  ## Possible errors:
  ## 
  ## * Returns INVALID_ARGUMENT if page_size is greater than 100 or less than 1.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return. Default 10, maximum 100.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The ProductSet resource for which to retrieve Products.
  ## 
  ## Format is:
  ## `projects/PROJECT_ID/locations/LOC_ID/productSets/PRODUCT_SET_ID`
  ##   pageToken: string
  ##            : The next_page_token returned from a previous List request, if any.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579043 = newJObject()
  var query_579044 = newJObject()
  add(query_579044, "key", newJString(key))
  add(query_579044, "prettyPrint", newJBool(prettyPrint))
  add(query_579044, "oauth_token", newJString(oauthToken))
  add(query_579044, "$.xgafv", newJString(Xgafv))
  add(query_579044, "pageSize", newJInt(pageSize))
  add(query_579044, "alt", newJString(alt))
  add(query_579044, "uploadType", newJString(uploadType))
  add(query_579044, "quotaUser", newJString(quotaUser))
  add(path_579043, "name", newJString(name))
  add(query_579044, "pageToken", newJString(pageToken))
  add(query_579044, "callback", newJString(callback))
  add(query_579044, "fields", newJString(fields))
  add(query_579044, "access_token", newJString(accessToken))
  add(query_579044, "upload_protocol", newJString(uploadProtocol))
  result = call_579042.call(path_579043, query_579044, nil, nil, nil)

var visionProjectsLocationsProductSetsProductsList* = Call_VisionProjectsLocationsProductSetsProductsList_579024(
    name: "visionProjectsLocationsProductSetsProductsList",
    meth: HttpMethod.HttpGet, host: "vision.googleapis.com",
    route: "/v1/{name}/products",
    validator: validate_VisionProjectsLocationsProductSetsProductsList_579025,
    base: "/", url: url_VisionProjectsLocationsProductSetsProductsList_579026,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsAddProduct_579045 = ref object of OpenApiRestCall_578348
proc url_VisionProjectsLocationsProductSetsAddProduct_579047(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":addProduct")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VisionProjectsLocationsProductSetsAddProduct_579046(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a Product to the specified ProductSet. If the Product is already
  ## present, no change is made.
  ## 
  ## One Product can be added to at most 100 ProductSets.
  ## 
  ## Possible errors:
  ## 
  ## * Returns NOT_FOUND if the Product or the ProductSet doesn't exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The resource name for the ProductSet to modify.
  ## 
  ## Format is:
  ## `projects/PROJECT_ID/locations/LOC_ID/productSets/PRODUCT_SET_ID`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579048 = path.getOrDefault("name")
  valid_579048 = validateParameter(valid_579048, JString, required = true,
                                 default = nil)
  if valid_579048 != nil:
    section.add "name", valid_579048
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579049 = query.getOrDefault("key")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "key", valid_579049
  var valid_579050 = query.getOrDefault("prettyPrint")
  valid_579050 = validateParameter(valid_579050, JBool, required = false,
                                 default = newJBool(true))
  if valid_579050 != nil:
    section.add "prettyPrint", valid_579050
  var valid_579051 = query.getOrDefault("oauth_token")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "oauth_token", valid_579051
  var valid_579052 = query.getOrDefault("$.xgafv")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = newJString("1"))
  if valid_579052 != nil:
    section.add "$.xgafv", valid_579052
  var valid_579053 = query.getOrDefault("alt")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = newJString("json"))
  if valid_579053 != nil:
    section.add "alt", valid_579053
  var valid_579054 = query.getOrDefault("uploadType")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "uploadType", valid_579054
  var valid_579055 = query.getOrDefault("quotaUser")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "quotaUser", valid_579055
  var valid_579056 = query.getOrDefault("callback")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "callback", valid_579056
  var valid_579057 = query.getOrDefault("fields")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "fields", valid_579057
  var valid_579058 = query.getOrDefault("access_token")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "access_token", valid_579058
  var valid_579059 = query.getOrDefault("upload_protocol")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "upload_protocol", valid_579059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579061: Call_VisionProjectsLocationsProductSetsAddProduct_579045;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a Product to the specified ProductSet. If the Product is already
  ## present, no change is made.
  ## 
  ## One Product can be added to at most 100 ProductSets.
  ## 
  ## Possible errors:
  ## 
  ## * Returns NOT_FOUND if the Product or the ProductSet doesn't exist.
  ## 
  let valid = call_579061.validator(path, query, header, formData, body)
  let scheme = call_579061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579061.url(scheme.get, call_579061.host, call_579061.base,
                         call_579061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579061, url, valid)

proc call*(call_579062: Call_VisionProjectsLocationsProductSetsAddProduct_579045;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## visionProjectsLocationsProductSetsAddProduct
  ## Adds a Product to the specified ProductSet. If the Product is already
  ## present, no change is made.
  ## 
  ## One Product can be added to at most 100 ProductSets.
  ## 
  ## Possible errors:
  ## 
  ## * Returns NOT_FOUND if the Product or the ProductSet doesn't exist.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name for the ProductSet to modify.
  ## 
  ## Format is:
  ## `projects/PROJECT_ID/locations/LOC_ID/productSets/PRODUCT_SET_ID`
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579063 = newJObject()
  var query_579064 = newJObject()
  var body_579065 = newJObject()
  add(query_579064, "key", newJString(key))
  add(query_579064, "prettyPrint", newJBool(prettyPrint))
  add(query_579064, "oauth_token", newJString(oauthToken))
  add(query_579064, "$.xgafv", newJString(Xgafv))
  add(query_579064, "alt", newJString(alt))
  add(query_579064, "uploadType", newJString(uploadType))
  add(query_579064, "quotaUser", newJString(quotaUser))
  add(path_579063, "name", newJString(name))
  if body != nil:
    body_579065 = body
  add(query_579064, "callback", newJString(callback))
  add(query_579064, "fields", newJString(fields))
  add(query_579064, "access_token", newJString(accessToken))
  add(query_579064, "upload_protocol", newJString(uploadProtocol))
  result = call_579062.call(path_579063, query_579064, nil, nil, body_579065)

var visionProjectsLocationsProductSetsAddProduct* = Call_VisionProjectsLocationsProductSetsAddProduct_579045(
    name: "visionProjectsLocationsProductSetsAddProduct",
    meth: HttpMethod.HttpPost, host: "vision.googleapis.com",
    route: "/v1/{name}:addProduct",
    validator: validate_VisionProjectsLocationsProductSetsAddProduct_579046,
    base: "/", url: url_VisionProjectsLocationsProductSetsAddProduct_579047,
    schemes: {Scheme.Https})
type
  Call_VisionOperationsCancel_579066 = ref object of OpenApiRestCall_578348
proc url_VisionOperationsCancel_579068(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VisionOperationsCancel_579067(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be cancelled.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579069 = path.getOrDefault("name")
  valid_579069 = validateParameter(valid_579069, JString, required = true,
                                 default = nil)
  if valid_579069 != nil:
    section.add "name", valid_579069
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579070 = query.getOrDefault("key")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = nil)
  if valid_579070 != nil:
    section.add "key", valid_579070
  var valid_579071 = query.getOrDefault("prettyPrint")
  valid_579071 = validateParameter(valid_579071, JBool, required = false,
                                 default = newJBool(true))
  if valid_579071 != nil:
    section.add "prettyPrint", valid_579071
  var valid_579072 = query.getOrDefault("oauth_token")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "oauth_token", valid_579072
  var valid_579073 = query.getOrDefault("$.xgafv")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = newJString("1"))
  if valid_579073 != nil:
    section.add "$.xgafv", valid_579073
  var valid_579074 = query.getOrDefault("alt")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = newJString("json"))
  if valid_579074 != nil:
    section.add "alt", valid_579074
  var valid_579075 = query.getOrDefault("uploadType")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "uploadType", valid_579075
  var valid_579076 = query.getOrDefault("quotaUser")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "quotaUser", valid_579076
  var valid_579077 = query.getOrDefault("callback")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "callback", valid_579077
  var valid_579078 = query.getOrDefault("fields")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "fields", valid_579078
  var valid_579079 = query.getOrDefault("access_token")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "access_token", valid_579079
  var valid_579080 = query.getOrDefault("upload_protocol")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "upload_protocol", valid_579080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579082: Call_VisionOperationsCancel_579066; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ## 
  let valid = call_579082.validator(path, query, header, formData, body)
  let scheme = call_579082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579082.url(scheme.get, call_579082.host, call_579082.base,
                         call_579082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579082, url, valid)

proc call*(call_579083: Call_VisionOperationsCancel_579066; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## visionOperationsCancel
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be cancelled.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579084 = newJObject()
  var query_579085 = newJObject()
  var body_579086 = newJObject()
  add(query_579085, "key", newJString(key))
  add(query_579085, "prettyPrint", newJBool(prettyPrint))
  add(query_579085, "oauth_token", newJString(oauthToken))
  add(query_579085, "$.xgafv", newJString(Xgafv))
  add(query_579085, "alt", newJString(alt))
  add(query_579085, "uploadType", newJString(uploadType))
  add(query_579085, "quotaUser", newJString(quotaUser))
  add(path_579084, "name", newJString(name))
  if body != nil:
    body_579086 = body
  add(query_579085, "callback", newJString(callback))
  add(query_579085, "fields", newJString(fields))
  add(query_579085, "access_token", newJString(accessToken))
  add(query_579085, "upload_protocol", newJString(uploadProtocol))
  result = call_579083.call(path_579084, query_579085, nil, nil, body_579086)

var visionOperationsCancel* = Call_VisionOperationsCancel_579066(
    name: "visionOperationsCancel", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_VisionOperationsCancel_579067, base: "/",
    url: url_VisionOperationsCancel_579068, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsRemoveProduct_579087 = ref object of OpenApiRestCall_578348
proc url_VisionProjectsLocationsProductSetsRemoveProduct_579089(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":removeProduct")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VisionProjectsLocationsProductSetsRemoveProduct_579088(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Removes a Product from the specified ProductSet.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The resource name for the ProductSet to modify.
  ## 
  ## Format is:
  ## `projects/PROJECT_ID/locations/LOC_ID/productSets/PRODUCT_SET_ID`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579090 = path.getOrDefault("name")
  valid_579090 = validateParameter(valid_579090, JString, required = true,
                                 default = nil)
  if valid_579090 != nil:
    section.add "name", valid_579090
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579091 = query.getOrDefault("key")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "key", valid_579091
  var valid_579092 = query.getOrDefault("prettyPrint")
  valid_579092 = validateParameter(valid_579092, JBool, required = false,
                                 default = newJBool(true))
  if valid_579092 != nil:
    section.add "prettyPrint", valid_579092
  var valid_579093 = query.getOrDefault("oauth_token")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "oauth_token", valid_579093
  var valid_579094 = query.getOrDefault("$.xgafv")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = newJString("1"))
  if valid_579094 != nil:
    section.add "$.xgafv", valid_579094
  var valid_579095 = query.getOrDefault("alt")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = newJString("json"))
  if valid_579095 != nil:
    section.add "alt", valid_579095
  var valid_579096 = query.getOrDefault("uploadType")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = nil)
  if valid_579096 != nil:
    section.add "uploadType", valid_579096
  var valid_579097 = query.getOrDefault("quotaUser")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "quotaUser", valid_579097
  var valid_579098 = query.getOrDefault("callback")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "callback", valid_579098
  var valid_579099 = query.getOrDefault("fields")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "fields", valid_579099
  var valid_579100 = query.getOrDefault("access_token")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "access_token", valid_579100
  var valid_579101 = query.getOrDefault("upload_protocol")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "upload_protocol", valid_579101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579103: Call_VisionProjectsLocationsProductSetsRemoveProduct_579087;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a Product from the specified ProductSet.
  ## 
  let valid = call_579103.validator(path, query, header, formData, body)
  let scheme = call_579103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579103.url(scheme.get, call_579103.host, call_579103.base,
                         call_579103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579103, url, valid)

proc call*(call_579104: Call_VisionProjectsLocationsProductSetsRemoveProduct_579087;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## visionProjectsLocationsProductSetsRemoveProduct
  ## Removes a Product from the specified ProductSet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name for the ProductSet to modify.
  ## 
  ## Format is:
  ## `projects/PROJECT_ID/locations/LOC_ID/productSets/PRODUCT_SET_ID`
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579105 = newJObject()
  var query_579106 = newJObject()
  var body_579107 = newJObject()
  add(query_579106, "key", newJString(key))
  add(query_579106, "prettyPrint", newJBool(prettyPrint))
  add(query_579106, "oauth_token", newJString(oauthToken))
  add(query_579106, "$.xgafv", newJString(Xgafv))
  add(query_579106, "alt", newJString(alt))
  add(query_579106, "uploadType", newJString(uploadType))
  add(query_579106, "quotaUser", newJString(quotaUser))
  add(path_579105, "name", newJString(name))
  if body != nil:
    body_579107 = body
  add(query_579106, "callback", newJString(callback))
  add(query_579106, "fields", newJString(fields))
  add(query_579106, "access_token", newJString(accessToken))
  add(query_579106, "upload_protocol", newJString(uploadProtocol))
  result = call_579104.call(path_579105, query_579106, nil, nil, body_579107)

var visionProjectsLocationsProductSetsRemoveProduct* = Call_VisionProjectsLocationsProductSetsRemoveProduct_579087(
    name: "visionProjectsLocationsProductSetsRemoveProduct",
    meth: HttpMethod.HttpPost, host: "vision.googleapis.com",
    route: "/v1/{name}:removeProduct",
    validator: validate_VisionProjectsLocationsProductSetsRemoveProduct_579088,
    base: "/", url: url_VisionProjectsLocationsProductSetsRemoveProduct_579089,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsFilesAnnotate_579108 = ref object of OpenApiRestCall_578348
proc url_VisionProjectsLocationsFilesAnnotate_579110(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/files:annotate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VisionProjectsLocationsFilesAnnotate_579109(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Service that performs image detection and annotation for a batch of files.
  ## Now only "application/pdf", "image/tiff" and "image/gif" are supported.
  ## 
  ## This service will extract at most 5 (customers can specify which 5 in
  ## AnnotateFileRequest.pages) frames (gif) or pages (pdf or tiff) from each
  ## file provided and perform detection and annotation for each image
  ## extracted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Optional. Target project and location to make a call.
  ## 
  ## Format: `projects/{project-id}/locations/{location-id}`.
  ## 
  ## If no parent is specified, a region will be chosen automatically.
  ## 
  ## Supported location-ids:
  ##     `us`: USA country only,
  ##     `asia`: East asia areas, like Japan, Taiwan,
  ##     `eu`: The European Union.
  ## 
  ## Example: `projects/project-A/locations/eu`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579111 = path.getOrDefault("parent")
  valid_579111 = validateParameter(valid_579111, JString, required = true,
                                 default = nil)
  if valid_579111 != nil:
    section.add "parent", valid_579111
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579112 = query.getOrDefault("key")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = nil)
  if valid_579112 != nil:
    section.add "key", valid_579112
  var valid_579113 = query.getOrDefault("prettyPrint")
  valid_579113 = validateParameter(valid_579113, JBool, required = false,
                                 default = newJBool(true))
  if valid_579113 != nil:
    section.add "prettyPrint", valid_579113
  var valid_579114 = query.getOrDefault("oauth_token")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = nil)
  if valid_579114 != nil:
    section.add "oauth_token", valid_579114
  var valid_579115 = query.getOrDefault("$.xgafv")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = newJString("1"))
  if valid_579115 != nil:
    section.add "$.xgafv", valid_579115
  var valid_579116 = query.getOrDefault("alt")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = newJString("json"))
  if valid_579116 != nil:
    section.add "alt", valid_579116
  var valid_579117 = query.getOrDefault("uploadType")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = nil)
  if valid_579117 != nil:
    section.add "uploadType", valid_579117
  var valid_579118 = query.getOrDefault("quotaUser")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = nil)
  if valid_579118 != nil:
    section.add "quotaUser", valid_579118
  var valid_579119 = query.getOrDefault("callback")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "callback", valid_579119
  var valid_579120 = query.getOrDefault("fields")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "fields", valid_579120
  var valid_579121 = query.getOrDefault("access_token")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "access_token", valid_579121
  var valid_579122 = query.getOrDefault("upload_protocol")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "upload_protocol", valid_579122
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579124: Call_VisionProjectsLocationsFilesAnnotate_579108;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Service that performs image detection and annotation for a batch of files.
  ## Now only "application/pdf", "image/tiff" and "image/gif" are supported.
  ## 
  ## This service will extract at most 5 (customers can specify which 5 in
  ## AnnotateFileRequest.pages) frames (gif) or pages (pdf or tiff) from each
  ## file provided and perform detection and annotation for each image
  ## extracted.
  ## 
  let valid = call_579124.validator(path, query, header, formData, body)
  let scheme = call_579124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579124.url(scheme.get, call_579124.host, call_579124.base,
                         call_579124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579124, url, valid)

proc call*(call_579125: Call_VisionProjectsLocationsFilesAnnotate_579108;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## visionProjectsLocationsFilesAnnotate
  ## Service that performs image detection and annotation for a batch of files.
  ## Now only "application/pdf", "image/tiff" and "image/gif" are supported.
  ## 
  ## This service will extract at most 5 (customers can specify which 5 in
  ## AnnotateFileRequest.pages) frames (gif) or pages (pdf or tiff) from each
  ## file provided and perform detection and annotation for each image
  ## extracted.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Optional. Target project and location to make a call.
  ## 
  ## Format: `projects/{project-id}/locations/{location-id}`.
  ## 
  ## If no parent is specified, a region will be chosen automatically.
  ## 
  ## Supported location-ids:
  ##     `us`: USA country only,
  ##     `asia`: East asia areas, like Japan, Taiwan,
  ##     `eu`: The European Union.
  ## 
  ## Example: `projects/project-A/locations/eu`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579126 = newJObject()
  var query_579127 = newJObject()
  var body_579128 = newJObject()
  add(query_579127, "key", newJString(key))
  add(query_579127, "prettyPrint", newJBool(prettyPrint))
  add(query_579127, "oauth_token", newJString(oauthToken))
  add(query_579127, "$.xgafv", newJString(Xgafv))
  add(query_579127, "alt", newJString(alt))
  add(query_579127, "uploadType", newJString(uploadType))
  add(query_579127, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579128 = body
  add(query_579127, "callback", newJString(callback))
  add(path_579126, "parent", newJString(parent))
  add(query_579127, "fields", newJString(fields))
  add(query_579127, "access_token", newJString(accessToken))
  add(query_579127, "upload_protocol", newJString(uploadProtocol))
  result = call_579125.call(path_579126, query_579127, nil, nil, body_579128)

var visionProjectsLocationsFilesAnnotate* = Call_VisionProjectsLocationsFilesAnnotate_579108(
    name: "visionProjectsLocationsFilesAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{parent}/files:annotate",
    validator: validate_VisionProjectsLocationsFilesAnnotate_579109, base: "/",
    url: url_VisionProjectsLocationsFilesAnnotate_579110, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsFilesAsyncBatchAnnotate_579129 = ref object of OpenApiRestCall_578348
proc url_VisionProjectsLocationsFilesAsyncBatchAnnotate_579131(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/files:asyncBatchAnnotate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VisionProjectsLocationsFilesAsyncBatchAnnotate_579130(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Run asynchronous image detection and annotation for a list of generic
  ## files, such as PDF files, which may contain multiple pages and multiple
  ## images per page. Progress and results can be retrieved through the
  ## `google.longrunning.Operations` interface.
  ## `Operation.metadata` contains `OperationMetadata` (metadata).
  ## `Operation.response` contains `AsyncBatchAnnotateFilesResponse` (results).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Optional. Target project and location to make a call.
  ## 
  ## Format: `projects/{project-id}/locations/{location-id}`.
  ## 
  ## If no parent is specified, a region will be chosen automatically.
  ## 
  ## Supported location-ids:
  ##     `us`: USA country only,
  ##     `asia`: East asia areas, like Japan, Taiwan,
  ##     `eu`: The European Union.
  ## 
  ## Example: `projects/project-A/locations/eu`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579132 = path.getOrDefault("parent")
  valid_579132 = validateParameter(valid_579132, JString, required = true,
                                 default = nil)
  if valid_579132 != nil:
    section.add "parent", valid_579132
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579133 = query.getOrDefault("key")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = nil)
  if valid_579133 != nil:
    section.add "key", valid_579133
  var valid_579134 = query.getOrDefault("prettyPrint")
  valid_579134 = validateParameter(valid_579134, JBool, required = false,
                                 default = newJBool(true))
  if valid_579134 != nil:
    section.add "prettyPrint", valid_579134
  var valid_579135 = query.getOrDefault("oauth_token")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = nil)
  if valid_579135 != nil:
    section.add "oauth_token", valid_579135
  var valid_579136 = query.getOrDefault("$.xgafv")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = newJString("1"))
  if valid_579136 != nil:
    section.add "$.xgafv", valid_579136
  var valid_579137 = query.getOrDefault("alt")
  valid_579137 = validateParameter(valid_579137, JString, required = false,
                                 default = newJString("json"))
  if valid_579137 != nil:
    section.add "alt", valid_579137
  var valid_579138 = query.getOrDefault("uploadType")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = nil)
  if valid_579138 != nil:
    section.add "uploadType", valid_579138
  var valid_579139 = query.getOrDefault("quotaUser")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = nil)
  if valid_579139 != nil:
    section.add "quotaUser", valid_579139
  var valid_579140 = query.getOrDefault("callback")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = nil)
  if valid_579140 != nil:
    section.add "callback", valid_579140
  var valid_579141 = query.getOrDefault("fields")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "fields", valid_579141
  var valid_579142 = query.getOrDefault("access_token")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "access_token", valid_579142
  var valid_579143 = query.getOrDefault("upload_protocol")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = nil)
  if valid_579143 != nil:
    section.add "upload_protocol", valid_579143
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579145: Call_VisionProjectsLocationsFilesAsyncBatchAnnotate_579129;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Run asynchronous image detection and annotation for a list of generic
  ## files, such as PDF files, which may contain multiple pages and multiple
  ## images per page. Progress and results can be retrieved through the
  ## `google.longrunning.Operations` interface.
  ## `Operation.metadata` contains `OperationMetadata` (metadata).
  ## `Operation.response` contains `AsyncBatchAnnotateFilesResponse` (results).
  ## 
  let valid = call_579145.validator(path, query, header, formData, body)
  let scheme = call_579145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579145.url(scheme.get, call_579145.host, call_579145.base,
                         call_579145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579145, url, valid)

proc call*(call_579146: Call_VisionProjectsLocationsFilesAsyncBatchAnnotate_579129;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## visionProjectsLocationsFilesAsyncBatchAnnotate
  ## Run asynchronous image detection and annotation for a list of generic
  ## files, such as PDF files, which may contain multiple pages and multiple
  ## images per page. Progress and results can be retrieved through the
  ## `google.longrunning.Operations` interface.
  ## `Operation.metadata` contains `OperationMetadata` (metadata).
  ## `Operation.response` contains `AsyncBatchAnnotateFilesResponse` (results).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Optional. Target project and location to make a call.
  ## 
  ## Format: `projects/{project-id}/locations/{location-id}`.
  ## 
  ## If no parent is specified, a region will be chosen automatically.
  ## 
  ## Supported location-ids:
  ##     `us`: USA country only,
  ##     `asia`: East asia areas, like Japan, Taiwan,
  ##     `eu`: The European Union.
  ## 
  ## Example: `projects/project-A/locations/eu`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579147 = newJObject()
  var query_579148 = newJObject()
  var body_579149 = newJObject()
  add(query_579148, "key", newJString(key))
  add(query_579148, "prettyPrint", newJBool(prettyPrint))
  add(query_579148, "oauth_token", newJString(oauthToken))
  add(query_579148, "$.xgafv", newJString(Xgafv))
  add(query_579148, "alt", newJString(alt))
  add(query_579148, "uploadType", newJString(uploadType))
  add(query_579148, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579149 = body
  add(query_579148, "callback", newJString(callback))
  add(path_579147, "parent", newJString(parent))
  add(query_579148, "fields", newJString(fields))
  add(query_579148, "access_token", newJString(accessToken))
  add(query_579148, "upload_protocol", newJString(uploadProtocol))
  result = call_579146.call(path_579147, query_579148, nil, nil, body_579149)

var visionProjectsLocationsFilesAsyncBatchAnnotate* = Call_VisionProjectsLocationsFilesAsyncBatchAnnotate_579129(
    name: "visionProjectsLocationsFilesAsyncBatchAnnotate",
    meth: HttpMethod.HttpPost, host: "vision.googleapis.com",
    route: "/v1/{parent}/files:asyncBatchAnnotate",
    validator: validate_VisionProjectsLocationsFilesAsyncBatchAnnotate_579130,
    base: "/", url: url_VisionProjectsLocationsFilesAsyncBatchAnnotate_579131,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsImagesAnnotate_579150 = ref object of OpenApiRestCall_578348
proc url_VisionProjectsLocationsImagesAnnotate_579152(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/images:annotate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VisionProjectsLocationsImagesAnnotate_579151(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Run image detection and annotation for a batch of images.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Optional. Target project and location to make a call.
  ## 
  ## Format: `projects/{project-id}/locations/{location-id}`.
  ## 
  ## If no parent is specified, a region will be chosen automatically.
  ## 
  ## Supported location-ids:
  ##     `us`: USA country only,
  ##     `asia`: East asia areas, like Japan, Taiwan,
  ##     `eu`: The European Union.
  ## 
  ## Example: `projects/project-A/locations/eu`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579153 = path.getOrDefault("parent")
  valid_579153 = validateParameter(valid_579153, JString, required = true,
                                 default = nil)
  if valid_579153 != nil:
    section.add "parent", valid_579153
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579154 = query.getOrDefault("key")
  valid_579154 = validateParameter(valid_579154, JString, required = false,
                                 default = nil)
  if valid_579154 != nil:
    section.add "key", valid_579154
  var valid_579155 = query.getOrDefault("prettyPrint")
  valid_579155 = validateParameter(valid_579155, JBool, required = false,
                                 default = newJBool(true))
  if valid_579155 != nil:
    section.add "prettyPrint", valid_579155
  var valid_579156 = query.getOrDefault("oauth_token")
  valid_579156 = validateParameter(valid_579156, JString, required = false,
                                 default = nil)
  if valid_579156 != nil:
    section.add "oauth_token", valid_579156
  var valid_579157 = query.getOrDefault("$.xgafv")
  valid_579157 = validateParameter(valid_579157, JString, required = false,
                                 default = newJString("1"))
  if valid_579157 != nil:
    section.add "$.xgafv", valid_579157
  var valid_579158 = query.getOrDefault("alt")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = newJString("json"))
  if valid_579158 != nil:
    section.add "alt", valid_579158
  var valid_579159 = query.getOrDefault("uploadType")
  valid_579159 = validateParameter(valid_579159, JString, required = false,
                                 default = nil)
  if valid_579159 != nil:
    section.add "uploadType", valid_579159
  var valid_579160 = query.getOrDefault("quotaUser")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = nil)
  if valid_579160 != nil:
    section.add "quotaUser", valid_579160
  var valid_579161 = query.getOrDefault("callback")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = nil)
  if valid_579161 != nil:
    section.add "callback", valid_579161
  var valid_579162 = query.getOrDefault("fields")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "fields", valid_579162
  var valid_579163 = query.getOrDefault("access_token")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "access_token", valid_579163
  var valid_579164 = query.getOrDefault("upload_protocol")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "upload_protocol", valid_579164
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579166: Call_VisionProjectsLocationsImagesAnnotate_579150;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Run image detection and annotation for a batch of images.
  ## 
  let valid = call_579166.validator(path, query, header, formData, body)
  let scheme = call_579166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579166.url(scheme.get, call_579166.host, call_579166.base,
                         call_579166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579166, url, valid)

proc call*(call_579167: Call_VisionProjectsLocationsImagesAnnotate_579150;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## visionProjectsLocationsImagesAnnotate
  ## Run image detection and annotation for a batch of images.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Optional. Target project and location to make a call.
  ## 
  ## Format: `projects/{project-id}/locations/{location-id}`.
  ## 
  ## If no parent is specified, a region will be chosen automatically.
  ## 
  ## Supported location-ids:
  ##     `us`: USA country only,
  ##     `asia`: East asia areas, like Japan, Taiwan,
  ##     `eu`: The European Union.
  ## 
  ## Example: `projects/project-A/locations/eu`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579168 = newJObject()
  var query_579169 = newJObject()
  var body_579170 = newJObject()
  add(query_579169, "key", newJString(key))
  add(query_579169, "prettyPrint", newJBool(prettyPrint))
  add(query_579169, "oauth_token", newJString(oauthToken))
  add(query_579169, "$.xgafv", newJString(Xgafv))
  add(query_579169, "alt", newJString(alt))
  add(query_579169, "uploadType", newJString(uploadType))
  add(query_579169, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579170 = body
  add(query_579169, "callback", newJString(callback))
  add(path_579168, "parent", newJString(parent))
  add(query_579169, "fields", newJString(fields))
  add(query_579169, "access_token", newJString(accessToken))
  add(query_579169, "upload_protocol", newJString(uploadProtocol))
  result = call_579167.call(path_579168, query_579169, nil, nil, body_579170)

var visionProjectsLocationsImagesAnnotate* = Call_VisionProjectsLocationsImagesAnnotate_579150(
    name: "visionProjectsLocationsImagesAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{parent}/images:annotate",
    validator: validate_VisionProjectsLocationsImagesAnnotate_579151, base: "/",
    url: url_VisionProjectsLocationsImagesAnnotate_579152, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsImagesAsyncBatchAnnotate_579171 = ref object of OpenApiRestCall_578348
proc url_VisionProjectsLocationsImagesAsyncBatchAnnotate_579173(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/images:asyncBatchAnnotate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VisionProjectsLocationsImagesAsyncBatchAnnotate_579172(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Run asynchronous image detection and annotation for a list of images.
  ## 
  ## Progress and results can be retrieved through the
  ## `google.longrunning.Operations` interface.
  ## `Operation.metadata` contains `OperationMetadata` (metadata).
  ## `Operation.response` contains `AsyncBatchAnnotateImagesResponse` (results).
  ## 
  ## This service will write image annotation outputs to json files in customer
  ## GCS bucket, each json file containing BatchAnnotateImagesResponse proto.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Optional. Target project and location to make a call.
  ## 
  ## Format: `projects/{project-id}/locations/{location-id}`.
  ## 
  ## If no parent is specified, a region will be chosen automatically.
  ## 
  ## Supported location-ids:
  ##     `us`: USA country only,
  ##     `asia`: East asia areas, like Japan, Taiwan,
  ##     `eu`: The European Union.
  ## 
  ## Example: `projects/project-A/locations/eu`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579174 = path.getOrDefault("parent")
  valid_579174 = validateParameter(valid_579174, JString, required = true,
                                 default = nil)
  if valid_579174 != nil:
    section.add "parent", valid_579174
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579175 = query.getOrDefault("key")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = nil)
  if valid_579175 != nil:
    section.add "key", valid_579175
  var valid_579176 = query.getOrDefault("prettyPrint")
  valid_579176 = validateParameter(valid_579176, JBool, required = false,
                                 default = newJBool(true))
  if valid_579176 != nil:
    section.add "prettyPrint", valid_579176
  var valid_579177 = query.getOrDefault("oauth_token")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = nil)
  if valid_579177 != nil:
    section.add "oauth_token", valid_579177
  var valid_579178 = query.getOrDefault("$.xgafv")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = newJString("1"))
  if valid_579178 != nil:
    section.add "$.xgafv", valid_579178
  var valid_579179 = query.getOrDefault("alt")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = newJString("json"))
  if valid_579179 != nil:
    section.add "alt", valid_579179
  var valid_579180 = query.getOrDefault("uploadType")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = nil)
  if valid_579180 != nil:
    section.add "uploadType", valid_579180
  var valid_579181 = query.getOrDefault("quotaUser")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = nil)
  if valid_579181 != nil:
    section.add "quotaUser", valid_579181
  var valid_579182 = query.getOrDefault("callback")
  valid_579182 = validateParameter(valid_579182, JString, required = false,
                                 default = nil)
  if valid_579182 != nil:
    section.add "callback", valid_579182
  var valid_579183 = query.getOrDefault("fields")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = nil)
  if valid_579183 != nil:
    section.add "fields", valid_579183
  var valid_579184 = query.getOrDefault("access_token")
  valid_579184 = validateParameter(valid_579184, JString, required = false,
                                 default = nil)
  if valid_579184 != nil:
    section.add "access_token", valid_579184
  var valid_579185 = query.getOrDefault("upload_protocol")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = nil)
  if valid_579185 != nil:
    section.add "upload_protocol", valid_579185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579187: Call_VisionProjectsLocationsImagesAsyncBatchAnnotate_579171;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Run asynchronous image detection and annotation for a list of images.
  ## 
  ## Progress and results can be retrieved through the
  ## `google.longrunning.Operations` interface.
  ## `Operation.metadata` contains `OperationMetadata` (metadata).
  ## `Operation.response` contains `AsyncBatchAnnotateImagesResponse` (results).
  ## 
  ## This service will write image annotation outputs to json files in customer
  ## GCS bucket, each json file containing BatchAnnotateImagesResponse proto.
  ## 
  let valid = call_579187.validator(path, query, header, formData, body)
  let scheme = call_579187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579187.url(scheme.get, call_579187.host, call_579187.base,
                         call_579187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579187, url, valid)

proc call*(call_579188: Call_VisionProjectsLocationsImagesAsyncBatchAnnotate_579171;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## visionProjectsLocationsImagesAsyncBatchAnnotate
  ## Run asynchronous image detection and annotation for a list of images.
  ## 
  ## Progress and results can be retrieved through the
  ## `google.longrunning.Operations` interface.
  ## `Operation.metadata` contains `OperationMetadata` (metadata).
  ## `Operation.response` contains `AsyncBatchAnnotateImagesResponse` (results).
  ## 
  ## This service will write image annotation outputs to json files in customer
  ## GCS bucket, each json file containing BatchAnnotateImagesResponse proto.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Optional. Target project and location to make a call.
  ## 
  ## Format: `projects/{project-id}/locations/{location-id}`.
  ## 
  ## If no parent is specified, a region will be chosen automatically.
  ## 
  ## Supported location-ids:
  ##     `us`: USA country only,
  ##     `asia`: East asia areas, like Japan, Taiwan,
  ##     `eu`: The European Union.
  ## 
  ## Example: `projects/project-A/locations/eu`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579189 = newJObject()
  var query_579190 = newJObject()
  var body_579191 = newJObject()
  add(query_579190, "key", newJString(key))
  add(query_579190, "prettyPrint", newJBool(prettyPrint))
  add(query_579190, "oauth_token", newJString(oauthToken))
  add(query_579190, "$.xgafv", newJString(Xgafv))
  add(query_579190, "alt", newJString(alt))
  add(query_579190, "uploadType", newJString(uploadType))
  add(query_579190, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579191 = body
  add(query_579190, "callback", newJString(callback))
  add(path_579189, "parent", newJString(parent))
  add(query_579190, "fields", newJString(fields))
  add(query_579190, "access_token", newJString(accessToken))
  add(query_579190, "upload_protocol", newJString(uploadProtocol))
  result = call_579188.call(path_579189, query_579190, nil, nil, body_579191)

var visionProjectsLocationsImagesAsyncBatchAnnotate* = Call_VisionProjectsLocationsImagesAsyncBatchAnnotate_579171(
    name: "visionProjectsLocationsImagesAsyncBatchAnnotate",
    meth: HttpMethod.HttpPost, host: "vision.googleapis.com",
    route: "/v1/{parent}/images:asyncBatchAnnotate",
    validator: validate_VisionProjectsLocationsImagesAsyncBatchAnnotate_579172,
    base: "/", url: url_VisionProjectsLocationsImagesAsyncBatchAnnotate_579173,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsCreate_579213 = ref object of OpenApiRestCall_578348
proc url_VisionProjectsLocationsProductSetsCreate_579215(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/productSets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VisionProjectsLocationsProductSetsCreate_579214(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates and returns a new ProductSet resource.
  ## 
  ## Possible errors:
  ## 
  ## * Returns INVALID_ARGUMENT if display_name is missing, or is longer than
  ##   4096 characters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The project in which the ProductSet should be created.
  ## 
  ## Format is `projects/PROJECT_ID/locations/LOC_ID`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579216 = path.getOrDefault("parent")
  valid_579216 = validateParameter(valid_579216, JString, required = true,
                                 default = nil)
  if valid_579216 != nil:
    section.add "parent", valid_579216
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   productSetId: JString
  ##               : A user-supplied resource id for this ProductSet. If set, the server will
  ## attempt to use this value as the resource id. If it is already in use, an
  ## error is returned with code ALREADY_EXISTS. Must be at most 128 characters
  ## long. It cannot contain the character `/`.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579217 = query.getOrDefault("key")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = nil)
  if valid_579217 != nil:
    section.add "key", valid_579217
  var valid_579218 = query.getOrDefault("prettyPrint")
  valid_579218 = validateParameter(valid_579218, JBool, required = false,
                                 default = newJBool(true))
  if valid_579218 != nil:
    section.add "prettyPrint", valid_579218
  var valid_579219 = query.getOrDefault("oauth_token")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = nil)
  if valid_579219 != nil:
    section.add "oauth_token", valid_579219
  var valid_579220 = query.getOrDefault("$.xgafv")
  valid_579220 = validateParameter(valid_579220, JString, required = false,
                                 default = newJString("1"))
  if valid_579220 != nil:
    section.add "$.xgafv", valid_579220
  var valid_579221 = query.getOrDefault("alt")
  valid_579221 = validateParameter(valid_579221, JString, required = false,
                                 default = newJString("json"))
  if valid_579221 != nil:
    section.add "alt", valid_579221
  var valid_579222 = query.getOrDefault("uploadType")
  valid_579222 = validateParameter(valid_579222, JString, required = false,
                                 default = nil)
  if valid_579222 != nil:
    section.add "uploadType", valid_579222
  var valid_579223 = query.getOrDefault("quotaUser")
  valid_579223 = validateParameter(valid_579223, JString, required = false,
                                 default = nil)
  if valid_579223 != nil:
    section.add "quotaUser", valid_579223
  var valid_579224 = query.getOrDefault("productSetId")
  valid_579224 = validateParameter(valid_579224, JString, required = false,
                                 default = nil)
  if valid_579224 != nil:
    section.add "productSetId", valid_579224
  var valid_579225 = query.getOrDefault("callback")
  valid_579225 = validateParameter(valid_579225, JString, required = false,
                                 default = nil)
  if valid_579225 != nil:
    section.add "callback", valid_579225
  var valid_579226 = query.getOrDefault("fields")
  valid_579226 = validateParameter(valid_579226, JString, required = false,
                                 default = nil)
  if valid_579226 != nil:
    section.add "fields", valid_579226
  var valid_579227 = query.getOrDefault("access_token")
  valid_579227 = validateParameter(valid_579227, JString, required = false,
                                 default = nil)
  if valid_579227 != nil:
    section.add "access_token", valid_579227
  var valid_579228 = query.getOrDefault("upload_protocol")
  valid_579228 = validateParameter(valid_579228, JString, required = false,
                                 default = nil)
  if valid_579228 != nil:
    section.add "upload_protocol", valid_579228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579230: Call_VisionProjectsLocationsProductSetsCreate_579213;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates and returns a new ProductSet resource.
  ## 
  ## Possible errors:
  ## 
  ## * Returns INVALID_ARGUMENT if display_name is missing, or is longer than
  ##   4096 characters.
  ## 
  let valid = call_579230.validator(path, query, header, formData, body)
  let scheme = call_579230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579230.url(scheme.get, call_579230.host, call_579230.base,
                         call_579230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579230, url, valid)

proc call*(call_579231: Call_VisionProjectsLocationsProductSetsCreate_579213;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; productSetId: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## visionProjectsLocationsProductSetsCreate
  ## Creates and returns a new ProductSet resource.
  ## 
  ## Possible errors:
  ## 
  ## * Returns INVALID_ARGUMENT if display_name is missing, or is longer than
  ##   4096 characters.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   productSetId: string
  ##               : A user-supplied resource id for this ProductSet. If set, the server will
  ## attempt to use this value as the resource id. If it is already in use, an
  ## error is returned with code ALREADY_EXISTS. Must be at most 128 characters
  ## long. It cannot contain the character `/`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The project in which the ProductSet should be created.
  ## 
  ## Format is `projects/PROJECT_ID/locations/LOC_ID`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579232 = newJObject()
  var query_579233 = newJObject()
  var body_579234 = newJObject()
  add(query_579233, "key", newJString(key))
  add(query_579233, "prettyPrint", newJBool(prettyPrint))
  add(query_579233, "oauth_token", newJString(oauthToken))
  add(query_579233, "$.xgafv", newJString(Xgafv))
  add(query_579233, "alt", newJString(alt))
  add(query_579233, "uploadType", newJString(uploadType))
  add(query_579233, "quotaUser", newJString(quotaUser))
  add(query_579233, "productSetId", newJString(productSetId))
  if body != nil:
    body_579234 = body
  add(query_579233, "callback", newJString(callback))
  add(path_579232, "parent", newJString(parent))
  add(query_579233, "fields", newJString(fields))
  add(query_579233, "access_token", newJString(accessToken))
  add(query_579233, "upload_protocol", newJString(uploadProtocol))
  result = call_579231.call(path_579232, query_579233, nil, nil, body_579234)

var visionProjectsLocationsProductSetsCreate* = Call_VisionProjectsLocationsProductSetsCreate_579213(
    name: "visionProjectsLocationsProductSetsCreate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{parent}/productSets",
    validator: validate_VisionProjectsLocationsProductSetsCreate_579214,
    base: "/", url: url_VisionProjectsLocationsProductSetsCreate_579215,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsList_579192 = ref object of OpenApiRestCall_578348
proc url_VisionProjectsLocationsProductSetsList_579194(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/productSets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VisionProjectsLocationsProductSetsList_579193(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists ProductSets in an unspecified order.
  ## 
  ## Possible errors:
  ## 
  ## * Returns INVALID_ARGUMENT if page_size is greater than 100, or less
  ##   than 1.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The project from which ProductSets should be listed.
  ## 
  ## Format is `projects/PROJECT_ID/locations/LOC_ID`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579195 = path.getOrDefault("parent")
  valid_579195 = validateParameter(valid_579195, JString, required = true,
                                 default = nil)
  if valid_579195 != nil:
    section.add "parent", valid_579195
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of items to return. Default 10, maximum 100.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The next_page_token returned from a previous List request, if any.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579196 = query.getOrDefault("key")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = nil)
  if valid_579196 != nil:
    section.add "key", valid_579196
  var valid_579197 = query.getOrDefault("prettyPrint")
  valid_579197 = validateParameter(valid_579197, JBool, required = false,
                                 default = newJBool(true))
  if valid_579197 != nil:
    section.add "prettyPrint", valid_579197
  var valid_579198 = query.getOrDefault("oauth_token")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = nil)
  if valid_579198 != nil:
    section.add "oauth_token", valid_579198
  var valid_579199 = query.getOrDefault("$.xgafv")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = newJString("1"))
  if valid_579199 != nil:
    section.add "$.xgafv", valid_579199
  var valid_579200 = query.getOrDefault("pageSize")
  valid_579200 = validateParameter(valid_579200, JInt, required = false, default = nil)
  if valid_579200 != nil:
    section.add "pageSize", valid_579200
  var valid_579201 = query.getOrDefault("alt")
  valid_579201 = validateParameter(valid_579201, JString, required = false,
                                 default = newJString("json"))
  if valid_579201 != nil:
    section.add "alt", valid_579201
  var valid_579202 = query.getOrDefault("uploadType")
  valid_579202 = validateParameter(valid_579202, JString, required = false,
                                 default = nil)
  if valid_579202 != nil:
    section.add "uploadType", valid_579202
  var valid_579203 = query.getOrDefault("quotaUser")
  valid_579203 = validateParameter(valid_579203, JString, required = false,
                                 default = nil)
  if valid_579203 != nil:
    section.add "quotaUser", valid_579203
  var valid_579204 = query.getOrDefault("pageToken")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = nil)
  if valid_579204 != nil:
    section.add "pageToken", valid_579204
  var valid_579205 = query.getOrDefault("callback")
  valid_579205 = validateParameter(valid_579205, JString, required = false,
                                 default = nil)
  if valid_579205 != nil:
    section.add "callback", valid_579205
  var valid_579206 = query.getOrDefault("fields")
  valid_579206 = validateParameter(valid_579206, JString, required = false,
                                 default = nil)
  if valid_579206 != nil:
    section.add "fields", valid_579206
  var valid_579207 = query.getOrDefault("access_token")
  valid_579207 = validateParameter(valid_579207, JString, required = false,
                                 default = nil)
  if valid_579207 != nil:
    section.add "access_token", valid_579207
  var valid_579208 = query.getOrDefault("upload_protocol")
  valid_579208 = validateParameter(valid_579208, JString, required = false,
                                 default = nil)
  if valid_579208 != nil:
    section.add "upload_protocol", valid_579208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579209: Call_VisionProjectsLocationsProductSetsList_579192;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists ProductSets in an unspecified order.
  ## 
  ## Possible errors:
  ## 
  ## * Returns INVALID_ARGUMENT if page_size is greater than 100, or less
  ##   than 1.
  ## 
  let valid = call_579209.validator(path, query, header, formData, body)
  let scheme = call_579209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579209.url(scheme.get, call_579209.host, call_579209.base,
                         call_579209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579209, url, valid)

proc call*(call_579210: Call_VisionProjectsLocationsProductSetsList_579192;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## visionProjectsLocationsProductSetsList
  ## Lists ProductSets in an unspecified order.
  ## 
  ## Possible errors:
  ## 
  ## * Returns INVALID_ARGUMENT if page_size is greater than 100, or less
  ##   than 1.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return. Default 10, maximum 100.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The next_page_token returned from a previous List request, if any.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The project from which ProductSets should be listed.
  ## 
  ## Format is `projects/PROJECT_ID/locations/LOC_ID`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579211 = newJObject()
  var query_579212 = newJObject()
  add(query_579212, "key", newJString(key))
  add(query_579212, "prettyPrint", newJBool(prettyPrint))
  add(query_579212, "oauth_token", newJString(oauthToken))
  add(query_579212, "$.xgafv", newJString(Xgafv))
  add(query_579212, "pageSize", newJInt(pageSize))
  add(query_579212, "alt", newJString(alt))
  add(query_579212, "uploadType", newJString(uploadType))
  add(query_579212, "quotaUser", newJString(quotaUser))
  add(query_579212, "pageToken", newJString(pageToken))
  add(query_579212, "callback", newJString(callback))
  add(path_579211, "parent", newJString(parent))
  add(query_579212, "fields", newJString(fields))
  add(query_579212, "access_token", newJString(accessToken))
  add(query_579212, "upload_protocol", newJString(uploadProtocol))
  result = call_579210.call(path_579211, query_579212, nil, nil, nil)

var visionProjectsLocationsProductSetsList* = Call_VisionProjectsLocationsProductSetsList_579192(
    name: "visionProjectsLocationsProductSetsList", meth: HttpMethod.HttpGet,
    host: "vision.googleapis.com", route: "/v1/{parent}/productSets",
    validator: validate_VisionProjectsLocationsProductSetsList_579193, base: "/",
    url: url_VisionProjectsLocationsProductSetsList_579194,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsImport_579235 = ref object of OpenApiRestCall_578348
proc url_VisionProjectsLocationsProductSetsImport_579237(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/productSets:import")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VisionProjectsLocationsProductSetsImport_579236(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Asynchronous API that imports a list of reference images to specified
  ## product sets based on a list of image information.
  ## 
  ## The google.longrunning.Operation API can be used to keep track of the
  ## progress and results of the request.
  ## `Operation.metadata` contains `BatchOperationMetadata`. (progress)
  ## `Operation.response` contains `ImportProductSetsResponse`. (results)
  ## 
  ## The input source of this method is a csv file on Google Cloud Storage.
  ## For the format of the csv file please see
  ## ImportProductSetsGcsSource.csv_file_uri.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The project in which the ProductSets should be imported.
  ## 
  ## Format is `projects/PROJECT_ID/locations/LOC_ID`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579238 = path.getOrDefault("parent")
  valid_579238 = validateParameter(valid_579238, JString, required = true,
                                 default = nil)
  if valid_579238 != nil:
    section.add "parent", valid_579238
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579239 = query.getOrDefault("key")
  valid_579239 = validateParameter(valid_579239, JString, required = false,
                                 default = nil)
  if valid_579239 != nil:
    section.add "key", valid_579239
  var valid_579240 = query.getOrDefault("prettyPrint")
  valid_579240 = validateParameter(valid_579240, JBool, required = false,
                                 default = newJBool(true))
  if valid_579240 != nil:
    section.add "prettyPrint", valid_579240
  var valid_579241 = query.getOrDefault("oauth_token")
  valid_579241 = validateParameter(valid_579241, JString, required = false,
                                 default = nil)
  if valid_579241 != nil:
    section.add "oauth_token", valid_579241
  var valid_579242 = query.getOrDefault("$.xgafv")
  valid_579242 = validateParameter(valid_579242, JString, required = false,
                                 default = newJString("1"))
  if valid_579242 != nil:
    section.add "$.xgafv", valid_579242
  var valid_579243 = query.getOrDefault("alt")
  valid_579243 = validateParameter(valid_579243, JString, required = false,
                                 default = newJString("json"))
  if valid_579243 != nil:
    section.add "alt", valid_579243
  var valid_579244 = query.getOrDefault("uploadType")
  valid_579244 = validateParameter(valid_579244, JString, required = false,
                                 default = nil)
  if valid_579244 != nil:
    section.add "uploadType", valid_579244
  var valid_579245 = query.getOrDefault("quotaUser")
  valid_579245 = validateParameter(valid_579245, JString, required = false,
                                 default = nil)
  if valid_579245 != nil:
    section.add "quotaUser", valid_579245
  var valid_579246 = query.getOrDefault("callback")
  valid_579246 = validateParameter(valid_579246, JString, required = false,
                                 default = nil)
  if valid_579246 != nil:
    section.add "callback", valid_579246
  var valid_579247 = query.getOrDefault("fields")
  valid_579247 = validateParameter(valid_579247, JString, required = false,
                                 default = nil)
  if valid_579247 != nil:
    section.add "fields", valid_579247
  var valid_579248 = query.getOrDefault("access_token")
  valid_579248 = validateParameter(valid_579248, JString, required = false,
                                 default = nil)
  if valid_579248 != nil:
    section.add "access_token", valid_579248
  var valid_579249 = query.getOrDefault("upload_protocol")
  valid_579249 = validateParameter(valid_579249, JString, required = false,
                                 default = nil)
  if valid_579249 != nil:
    section.add "upload_protocol", valid_579249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579251: Call_VisionProjectsLocationsProductSetsImport_579235;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Asynchronous API that imports a list of reference images to specified
  ## product sets based on a list of image information.
  ## 
  ## The google.longrunning.Operation API can be used to keep track of the
  ## progress and results of the request.
  ## `Operation.metadata` contains `BatchOperationMetadata`. (progress)
  ## `Operation.response` contains `ImportProductSetsResponse`. (results)
  ## 
  ## The input source of this method is a csv file on Google Cloud Storage.
  ## For the format of the csv file please see
  ## ImportProductSetsGcsSource.csv_file_uri.
  ## 
  let valid = call_579251.validator(path, query, header, formData, body)
  let scheme = call_579251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579251.url(scheme.get, call_579251.host, call_579251.base,
                         call_579251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579251, url, valid)

proc call*(call_579252: Call_VisionProjectsLocationsProductSetsImport_579235;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## visionProjectsLocationsProductSetsImport
  ## Asynchronous API that imports a list of reference images to specified
  ## product sets based on a list of image information.
  ## 
  ## The google.longrunning.Operation API can be used to keep track of the
  ## progress and results of the request.
  ## `Operation.metadata` contains `BatchOperationMetadata`. (progress)
  ## `Operation.response` contains `ImportProductSetsResponse`. (results)
  ## 
  ## The input source of this method is a csv file on Google Cloud Storage.
  ## For the format of the csv file please see
  ## ImportProductSetsGcsSource.csv_file_uri.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The project in which the ProductSets should be imported.
  ## 
  ## Format is `projects/PROJECT_ID/locations/LOC_ID`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579253 = newJObject()
  var query_579254 = newJObject()
  var body_579255 = newJObject()
  add(query_579254, "key", newJString(key))
  add(query_579254, "prettyPrint", newJBool(prettyPrint))
  add(query_579254, "oauth_token", newJString(oauthToken))
  add(query_579254, "$.xgafv", newJString(Xgafv))
  add(query_579254, "alt", newJString(alt))
  add(query_579254, "uploadType", newJString(uploadType))
  add(query_579254, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579255 = body
  add(query_579254, "callback", newJString(callback))
  add(path_579253, "parent", newJString(parent))
  add(query_579254, "fields", newJString(fields))
  add(query_579254, "access_token", newJString(accessToken))
  add(query_579254, "upload_protocol", newJString(uploadProtocol))
  result = call_579252.call(path_579253, query_579254, nil, nil, body_579255)

var visionProjectsLocationsProductSetsImport* = Call_VisionProjectsLocationsProductSetsImport_579235(
    name: "visionProjectsLocationsProductSetsImport", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{parent}/productSets:import",
    validator: validate_VisionProjectsLocationsProductSetsImport_579236,
    base: "/", url: url_VisionProjectsLocationsProductSetsImport_579237,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductsCreate_579277 = ref object of OpenApiRestCall_578348
proc url_VisionProjectsLocationsProductsCreate_579279(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/products")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VisionProjectsLocationsProductsCreate_579278(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates and returns a new product resource.
  ## 
  ## Possible errors:
  ## 
  ## * Returns INVALID_ARGUMENT if display_name is missing or longer than 4096
  ##   characters.
  ## * Returns INVALID_ARGUMENT if description is longer than 4096 characters.
  ## * Returns INVALID_ARGUMENT if product_category is missing or invalid.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The project in which the Product should be created.
  ## 
  ## Format is
  ## `projects/PROJECT_ID/locations/LOC_ID`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579280 = path.getOrDefault("parent")
  valid_579280 = validateParameter(valid_579280, JString, required = true,
                                 default = nil)
  if valid_579280 != nil:
    section.add "parent", valid_579280
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   productId: JString
  ##            : A user-supplied resource id for this Product. If set, the server will
  ## attempt to use this value as the resource id. If it is already in use, an
  ## error is returned with code ALREADY_EXISTS. Must be at most 128 characters
  ## long. It cannot contain the character `/`.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579281 = query.getOrDefault("key")
  valid_579281 = validateParameter(valid_579281, JString, required = false,
                                 default = nil)
  if valid_579281 != nil:
    section.add "key", valid_579281
  var valid_579282 = query.getOrDefault("prettyPrint")
  valid_579282 = validateParameter(valid_579282, JBool, required = false,
                                 default = newJBool(true))
  if valid_579282 != nil:
    section.add "prettyPrint", valid_579282
  var valid_579283 = query.getOrDefault("oauth_token")
  valid_579283 = validateParameter(valid_579283, JString, required = false,
                                 default = nil)
  if valid_579283 != nil:
    section.add "oauth_token", valid_579283
  var valid_579284 = query.getOrDefault("$.xgafv")
  valid_579284 = validateParameter(valid_579284, JString, required = false,
                                 default = newJString("1"))
  if valid_579284 != nil:
    section.add "$.xgafv", valid_579284
  var valid_579285 = query.getOrDefault("alt")
  valid_579285 = validateParameter(valid_579285, JString, required = false,
                                 default = newJString("json"))
  if valid_579285 != nil:
    section.add "alt", valid_579285
  var valid_579286 = query.getOrDefault("uploadType")
  valid_579286 = validateParameter(valid_579286, JString, required = false,
                                 default = nil)
  if valid_579286 != nil:
    section.add "uploadType", valid_579286
  var valid_579287 = query.getOrDefault("quotaUser")
  valid_579287 = validateParameter(valid_579287, JString, required = false,
                                 default = nil)
  if valid_579287 != nil:
    section.add "quotaUser", valid_579287
  var valid_579288 = query.getOrDefault("callback")
  valid_579288 = validateParameter(valid_579288, JString, required = false,
                                 default = nil)
  if valid_579288 != nil:
    section.add "callback", valid_579288
  var valid_579289 = query.getOrDefault("productId")
  valid_579289 = validateParameter(valid_579289, JString, required = false,
                                 default = nil)
  if valid_579289 != nil:
    section.add "productId", valid_579289
  var valid_579290 = query.getOrDefault("fields")
  valid_579290 = validateParameter(valid_579290, JString, required = false,
                                 default = nil)
  if valid_579290 != nil:
    section.add "fields", valid_579290
  var valid_579291 = query.getOrDefault("access_token")
  valid_579291 = validateParameter(valid_579291, JString, required = false,
                                 default = nil)
  if valid_579291 != nil:
    section.add "access_token", valid_579291
  var valid_579292 = query.getOrDefault("upload_protocol")
  valid_579292 = validateParameter(valid_579292, JString, required = false,
                                 default = nil)
  if valid_579292 != nil:
    section.add "upload_protocol", valid_579292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579294: Call_VisionProjectsLocationsProductsCreate_579277;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates and returns a new product resource.
  ## 
  ## Possible errors:
  ## 
  ## * Returns INVALID_ARGUMENT if display_name is missing or longer than 4096
  ##   characters.
  ## * Returns INVALID_ARGUMENT if description is longer than 4096 characters.
  ## * Returns INVALID_ARGUMENT if product_category is missing or invalid.
  ## 
  let valid = call_579294.validator(path, query, header, formData, body)
  let scheme = call_579294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579294.url(scheme.get, call_579294.host, call_579294.base,
                         call_579294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579294, url, valid)

proc call*(call_579295: Call_VisionProjectsLocationsProductsCreate_579277;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; productId: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## visionProjectsLocationsProductsCreate
  ## Creates and returns a new product resource.
  ## 
  ## Possible errors:
  ## 
  ## * Returns INVALID_ARGUMENT if display_name is missing or longer than 4096
  ##   characters.
  ## * Returns INVALID_ARGUMENT if description is longer than 4096 characters.
  ## * Returns INVALID_ARGUMENT if product_category is missing or invalid.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The project in which the Product should be created.
  ## 
  ## Format is
  ## `projects/PROJECT_ID/locations/LOC_ID`.
  ##   productId: string
  ##            : A user-supplied resource id for this Product. If set, the server will
  ## attempt to use this value as the resource id. If it is already in use, an
  ## error is returned with code ALREADY_EXISTS. Must be at most 128 characters
  ## long. It cannot contain the character `/`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579296 = newJObject()
  var query_579297 = newJObject()
  var body_579298 = newJObject()
  add(query_579297, "key", newJString(key))
  add(query_579297, "prettyPrint", newJBool(prettyPrint))
  add(query_579297, "oauth_token", newJString(oauthToken))
  add(query_579297, "$.xgafv", newJString(Xgafv))
  add(query_579297, "alt", newJString(alt))
  add(query_579297, "uploadType", newJString(uploadType))
  add(query_579297, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579298 = body
  add(query_579297, "callback", newJString(callback))
  add(path_579296, "parent", newJString(parent))
  add(query_579297, "productId", newJString(productId))
  add(query_579297, "fields", newJString(fields))
  add(query_579297, "access_token", newJString(accessToken))
  add(query_579297, "upload_protocol", newJString(uploadProtocol))
  result = call_579295.call(path_579296, query_579297, nil, nil, body_579298)

var visionProjectsLocationsProductsCreate* = Call_VisionProjectsLocationsProductsCreate_579277(
    name: "visionProjectsLocationsProductsCreate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{parent}/products",
    validator: validate_VisionProjectsLocationsProductsCreate_579278, base: "/",
    url: url_VisionProjectsLocationsProductsCreate_579279, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductsList_579256 = ref object of OpenApiRestCall_578348
proc url_VisionProjectsLocationsProductsList_579258(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/products")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VisionProjectsLocationsProductsList_579257(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists products in an unspecified order.
  ## 
  ## Possible errors:
  ## 
  ## * Returns INVALID_ARGUMENT if page_size is greater than 100 or less than 1.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The project OR ProductSet from which Products should be listed.
  ## 
  ## Format:
  ## `projects/PROJECT_ID/locations/LOC_ID`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579259 = path.getOrDefault("parent")
  valid_579259 = validateParameter(valid_579259, JString, required = true,
                                 default = nil)
  if valid_579259 != nil:
    section.add "parent", valid_579259
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of items to return. Default 10, maximum 100.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The next_page_token returned from a previous List request, if any.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579260 = query.getOrDefault("key")
  valid_579260 = validateParameter(valid_579260, JString, required = false,
                                 default = nil)
  if valid_579260 != nil:
    section.add "key", valid_579260
  var valid_579261 = query.getOrDefault("prettyPrint")
  valid_579261 = validateParameter(valid_579261, JBool, required = false,
                                 default = newJBool(true))
  if valid_579261 != nil:
    section.add "prettyPrint", valid_579261
  var valid_579262 = query.getOrDefault("oauth_token")
  valid_579262 = validateParameter(valid_579262, JString, required = false,
                                 default = nil)
  if valid_579262 != nil:
    section.add "oauth_token", valid_579262
  var valid_579263 = query.getOrDefault("$.xgafv")
  valid_579263 = validateParameter(valid_579263, JString, required = false,
                                 default = newJString("1"))
  if valid_579263 != nil:
    section.add "$.xgafv", valid_579263
  var valid_579264 = query.getOrDefault("pageSize")
  valid_579264 = validateParameter(valid_579264, JInt, required = false, default = nil)
  if valid_579264 != nil:
    section.add "pageSize", valid_579264
  var valid_579265 = query.getOrDefault("alt")
  valid_579265 = validateParameter(valid_579265, JString, required = false,
                                 default = newJString("json"))
  if valid_579265 != nil:
    section.add "alt", valid_579265
  var valid_579266 = query.getOrDefault("uploadType")
  valid_579266 = validateParameter(valid_579266, JString, required = false,
                                 default = nil)
  if valid_579266 != nil:
    section.add "uploadType", valid_579266
  var valid_579267 = query.getOrDefault("quotaUser")
  valid_579267 = validateParameter(valid_579267, JString, required = false,
                                 default = nil)
  if valid_579267 != nil:
    section.add "quotaUser", valid_579267
  var valid_579268 = query.getOrDefault("pageToken")
  valid_579268 = validateParameter(valid_579268, JString, required = false,
                                 default = nil)
  if valid_579268 != nil:
    section.add "pageToken", valid_579268
  var valid_579269 = query.getOrDefault("callback")
  valid_579269 = validateParameter(valid_579269, JString, required = false,
                                 default = nil)
  if valid_579269 != nil:
    section.add "callback", valid_579269
  var valid_579270 = query.getOrDefault("fields")
  valid_579270 = validateParameter(valid_579270, JString, required = false,
                                 default = nil)
  if valid_579270 != nil:
    section.add "fields", valid_579270
  var valid_579271 = query.getOrDefault("access_token")
  valid_579271 = validateParameter(valid_579271, JString, required = false,
                                 default = nil)
  if valid_579271 != nil:
    section.add "access_token", valid_579271
  var valid_579272 = query.getOrDefault("upload_protocol")
  valid_579272 = validateParameter(valid_579272, JString, required = false,
                                 default = nil)
  if valid_579272 != nil:
    section.add "upload_protocol", valid_579272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579273: Call_VisionProjectsLocationsProductsList_579256;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists products in an unspecified order.
  ## 
  ## Possible errors:
  ## 
  ## * Returns INVALID_ARGUMENT if page_size is greater than 100 or less than 1.
  ## 
  let valid = call_579273.validator(path, query, header, formData, body)
  let scheme = call_579273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579273.url(scheme.get, call_579273.host, call_579273.base,
                         call_579273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579273, url, valid)

proc call*(call_579274: Call_VisionProjectsLocationsProductsList_579256;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## visionProjectsLocationsProductsList
  ## Lists products in an unspecified order.
  ## 
  ## Possible errors:
  ## 
  ## * Returns INVALID_ARGUMENT if page_size is greater than 100 or less than 1.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return. Default 10, maximum 100.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The next_page_token returned from a previous List request, if any.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The project OR ProductSet from which Products should be listed.
  ## 
  ## Format:
  ## `projects/PROJECT_ID/locations/LOC_ID`
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579275 = newJObject()
  var query_579276 = newJObject()
  add(query_579276, "key", newJString(key))
  add(query_579276, "prettyPrint", newJBool(prettyPrint))
  add(query_579276, "oauth_token", newJString(oauthToken))
  add(query_579276, "$.xgafv", newJString(Xgafv))
  add(query_579276, "pageSize", newJInt(pageSize))
  add(query_579276, "alt", newJString(alt))
  add(query_579276, "uploadType", newJString(uploadType))
  add(query_579276, "quotaUser", newJString(quotaUser))
  add(query_579276, "pageToken", newJString(pageToken))
  add(query_579276, "callback", newJString(callback))
  add(path_579275, "parent", newJString(parent))
  add(query_579276, "fields", newJString(fields))
  add(query_579276, "access_token", newJString(accessToken))
  add(query_579276, "upload_protocol", newJString(uploadProtocol))
  result = call_579274.call(path_579275, query_579276, nil, nil, nil)

var visionProjectsLocationsProductsList* = Call_VisionProjectsLocationsProductsList_579256(
    name: "visionProjectsLocationsProductsList", meth: HttpMethod.HttpGet,
    host: "vision.googleapis.com", route: "/v1/{parent}/products",
    validator: validate_VisionProjectsLocationsProductsList_579257, base: "/",
    url: url_VisionProjectsLocationsProductsList_579258, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductsPurge_579299 = ref object of OpenApiRestCall_578348
proc url_VisionProjectsLocationsProductsPurge_579301(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/products:purge")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VisionProjectsLocationsProductsPurge_579300(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Asynchronous API to delete all Products in a ProductSet or all Products
  ## that are in no ProductSet.
  ## 
  ## If a Product is a member of the specified ProductSet in addition to other
  ## ProductSets, the Product will still be deleted.
  ## 
  ## It is recommended to not delete the specified ProductSet until after this
  ## operation has completed. It is also recommended to not add any of the
  ## Products involved in the batch delete to a new ProductSet while this
  ## operation is running because those Products may still end up deleted.
  ## 
  ## It's not possible to undo the PurgeProducts operation. Therefore, it is
  ## recommended to keep the csv files used in ImportProductSets (if that was
  ## how you originally built the Product Set) before starting PurgeProducts, in
  ## case you need to re-import the data after deletion.
  ## 
  ## If the plan is to purge all of the Products from a ProductSet and then
  ## re-use the empty ProductSet to re-import new Products into the empty
  ## ProductSet, you must wait until the PurgeProducts operation has finished
  ## for that ProductSet.
  ## 
  ## The google.longrunning.Operation API can be used to keep track of the
  ## progress and results of the request.
  ## `Operation.metadata` contains `BatchOperationMetadata`. (progress)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The project and location in which the Products should be deleted.
  ## 
  ## Format is `projects/PROJECT_ID/locations/LOC_ID`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579302 = path.getOrDefault("parent")
  valid_579302 = validateParameter(valid_579302, JString, required = true,
                                 default = nil)
  if valid_579302 != nil:
    section.add "parent", valid_579302
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579303 = query.getOrDefault("key")
  valid_579303 = validateParameter(valid_579303, JString, required = false,
                                 default = nil)
  if valid_579303 != nil:
    section.add "key", valid_579303
  var valid_579304 = query.getOrDefault("prettyPrint")
  valid_579304 = validateParameter(valid_579304, JBool, required = false,
                                 default = newJBool(true))
  if valid_579304 != nil:
    section.add "prettyPrint", valid_579304
  var valid_579305 = query.getOrDefault("oauth_token")
  valid_579305 = validateParameter(valid_579305, JString, required = false,
                                 default = nil)
  if valid_579305 != nil:
    section.add "oauth_token", valid_579305
  var valid_579306 = query.getOrDefault("$.xgafv")
  valid_579306 = validateParameter(valid_579306, JString, required = false,
                                 default = newJString("1"))
  if valid_579306 != nil:
    section.add "$.xgafv", valid_579306
  var valid_579307 = query.getOrDefault("alt")
  valid_579307 = validateParameter(valid_579307, JString, required = false,
                                 default = newJString("json"))
  if valid_579307 != nil:
    section.add "alt", valid_579307
  var valid_579308 = query.getOrDefault("uploadType")
  valid_579308 = validateParameter(valid_579308, JString, required = false,
                                 default = nil)
  if valid_579308 != nil:
    section.add "uploadType", valid_579308
  var valid_579309 = query.getOrDefault("quotaUser")
  valid_579309 = validateParameter(valid_579309, JString, required = false,
                                 default = nil)
  if valid_579309 != nil:
    section.add "quotaUser", valid_579309
  var valid_579310 = query.getOrDefault("callback")
  valid_579310 = validateParameter(valid_579310, JString, required = false,
                                 default = nil)
  if valid_579310 != nil:
    section.add "callback", valid_579310
  var valid_579311 = query.getOrDefault("fields")
  valid_579311 = validateParameter(valid_579311, JString, required = false,
                                 default = nil)
  if valid_579311 != nil:
    section.add "fields", valid_579311
  var valid_579312 = query.getOrDefault("access_token")
  valid_579312 = validateParameter(valid_579312, JString, required = false,
                                 default = nil)
  if valid_579312 != nil:
    section.add "access_token", valid_579312
  var valid_579313 = query.getOrDefault("upload_protocol")
  valid_579313 = validateParameter(valid_579313, JString, required = false,
                                 default = nil)
  if valid_579313 != nil:
    section.add "upload_protocol", valid_579313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579315: Call_VisionProjectsLocationsProductsPurge_579299;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Asynchronous API to delete all Products in a ProductSet or all Products
  ## that are in no ProductSet.
  ## 
  ## If a Product is a member of the specified ProductSet in addition to other
  ## ProductSets, the Product will still be deleted.
  ## 
  ## It is recommended to not delete the specified ProductSet until after this
  ## operation has completed. It is also recommended to not add any of the
  ## Products involved in the batch delete to a new ProductSet while this
  ## operation is running because those Products may still end up deleted.
  ## 
  ## It's not possible to undo the PurgeProducts operation. Therefore, it is
  ## recommended to keep the csv files used in ImportProductSets (if that was
  ## how you originally built the Product Set) before starting PurgeProducts, in
  ## case you need to re-import the data after deletion.
  ## 
  ## If the plan is to purge all of the Products from a ProductSet and then
  ## re-use the empty ProductSet to re-import new Products into the empty
  ## ProductSet, you must wait until the PurgeProducts operation has finished
  ## for that ProductSet.
  ## 
  ## The google.longrunning.Operation API can be used to keep track of the
  ## progress and results of the request.
  ## `Operation.metadata` contains `BatchOperationMetadata`. (progress)
  ## 
  let valid = call_579315.validator(path, query, header, formData, body)
  let scheme = call_579315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579315.url(scheme.get, call_579315.host, call_579315.base,
                         call_579315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579315, url, valid)

proc call*(call_579316: Call_VisionProjectsLocationsProductsPurge_579299;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## visionProjectsLocationsProductsPurge
  ## Asynchronous API to delete all Products in a ProductSet or all Products
  ## that are in no ProductSet.
  ## 
  ## If a Product is a member of the specified ProductSet in addition to other
  ## ProductSets, the Product will still be deleted.
  ## 
  ## It is recommended to not delete the specified ProductSet until after this
  ## operation has completed. It is also recommended to not add any of the
  ## Products involved in the batch delete to a new ProductSet while this
  ## operation is running because those Products may still end up deleted.
  ## 
  ## It's not possible to undo the PurgeProducts operation. Therefore, it is
  ## recommended to keep the csv files used in ImportProductSets (if that was
  ## how you originally built the Product Set) before starting PurgeProducts, in
  ## case you need to re-import the data after deletion.
  ## 
  ## If the plan is to purge all of the Products from a ProductSet and then
  ## re-use the empty ProductSet to re-import new Products into the empty
  ## ProductSet, you must wait until the PurgeProducts operation has finished
  ## for that ProductSet.
  ## 
  ## The google.longrunning.Operation API can be used to keep track of the
  ## progress and results of the request.
  ## `Operation.metadata` contains `BatchOperationMetadata`. (progress)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The project and location in which the Products should be deleted.
  ## 
  ## Format is `projects/PROJECT_ID/locations/LOC_ID`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579317 = newJObject()
  var query_579318 = newJObject()
  var body_579319 = newJObject()
  add(query_579318, "key", newJString(key))
  add(query_579318, "prettyPrint", newJBool(prettyPrint))
  add(query_579318, "oauth_token", newJString(oauthToken))
  add(query_579318, "$.xgafv", newJString(Xgafv))
  add(query_579318, "alt", newJString(alt))
  add(query_579318, "uploadType", newJString(uploadType))
  add(query_579318, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579319 = body
  add(query_579318, "callback", newJString(callback))
  add(path_579317, "parent", newJString(parent))
  add(query_579318, "fields", newJString(fields))
  add(query_579318, "access_token", newJString(accessToken))
  add(query_579318, "upload_protocol", newJString(uploadProtocol))
  result = call_579316.call(path_579317, query_579318, nil, nil, body_579319)

var visionProjectsLocationsProductsPurge* = Call_VisionProjectsLocationsProductsPurge_579299(
    name: "visionProjectsLocationsProductsPurge", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{parent}/products:purge",
    validator: validate_VisionProjectsLocationsProductsPurge_579300, base: "/",
    url: url_VisionProjectsLocationsProductsPurge_579301, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductsReferenceImagesCreate_579341 = ref object of OpenApiRestCall_578348
proc url_VisionProjectsLocationsProductsReferenceImagesCreate_579343(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/referenceImages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VisionProjectsLocationsProductsReferenceImagesCreate_579342(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates and returns a new ReferenceImage resource.
  ## 
  ## The `bounding_poly` field is optional. If `bounding_poly` is not specified,
  ## the system will try to detect regions of interest in the image that are
  ## compatible with the product_category on the parent product. If it is
  ## specified, detection is ALWAYS skipped. The system converts polygons into
  ## non-rotated rectangles.
  ## 
  ## Note that the pipeline will resize the image if the image resolution is too
  ## large to process (above 50MP).
  ## 
  ## Possible errors:
  ## 
  ## * Returns INVALID_ARGUMENT if the image_uri is missing or longer than 4096
  ##   characters.
  ## * Returns INVALID_ARGUMENT if the product does not exist.
  ## * Returns INVALID_ARGUMENT if bounding_poly is not provided, and nothing
  ##   compatible with the parent product's product_category is detected.
  ## * Returns INVALID_ARGUMENT if bounding_poly contains more than 10 polygons.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. Resource name of the product in which to create the reference image.
  ## 
  ## Format is
  ## `projects/PROJECT_ID/locations/LOC_ID/products/PRODUCT_ID`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579344 = path.getOrDefault("parent")
  valid_579344 = validateParameter(valid_579344, JString, required = true,
                                 default = nil)
  if valid_579344 != nil:
    section.add "parent", valid_579344
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   referenceImageId: JString
  ##                   : A user-supplied resource id for the ReferenceImage to be added. If set,
  ## the server will attempt to use this value as the resource id. If it is
  ## already in use, an error is returned with code ALREADY_EXISTS. Must be at
  ## most 128 characters long. It cannot contain the character `/`.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579345 = query.getOrDefault("key")
  valid_579345 = validateParameter(valid_579345, JString, required = false,
                                 default = nil)
  if valid_579345 != nil:
    section.add "key", valid_579345
  var valid_579346 = query.getOrDefault("prettyPrint")
  valid_579346 = validateParameter(valid_579346, JBool, required = false,
                                 default = newJBool(true))
  if valid_579346 != nil:
    section.add "prettyPrint", valid_579346
  var valid_579347 = query.getOrDefault("oauth_token")
  valid_579347 = validateParameter(valid_579347, JString, required = false,
                                 default = nil)
  if valid_579347 != nil:
    section.add "oauth_token", valid_579347
  var valid_579348 = query.getOrDefault("$.xgafv")
  valid_579348 = validateParameter(valid_579348, JString, required = false,
                                 default = newJString("1"))
  if valid_579348 != nil:
    section.add "$.xgafv", valid_579348
  var valid_579349 = query.getOrDefault("referenceImageId")
  valid_579349 = validateParameter(valid_579349, JString, required = false,
                                 default = nil)
  if valid_579349 != nil:
    section.add "referenceImageId", valid_579349
  var valid_579350 = query.getOrDefault("alt")
  valid_579350 = validateParameter(valid_579350, JString, required = false,
                                 default = newJString("json"))
  if valid_579350 != nil:
    section.add "alt", valid_579350
  var valid_579351 = query.getOrDefault("uploadType")
  valid_579351 = validateParameter(valid_579351, JString, required = false,
                                 default = nil)
  if valid_579351 != nil:
    section.add "uploadType", valid_579351
  var valid_579352 = query.getOrDefault("quotaUser")
  valid_579352 = validateParameter(valid_579352, JString, required = false,
                                 default = nil)
  if valid_579352 != nil:
    section.add "quotaUser", valid_579352
  var valid_579353 = query.getOrDefault("callback")
  valid_579353 = validateParameter(valid_579353, JString, required = false,
                                 default = nil)
  if valid_579353 != nil:
    section.add "callback", valid_579353
  var valid_579354 = query.getOrDefault("fields")
  valid_579354 = validateParameter(valid_579354, JString, required = false,
                                 default = nil)
  if valid_579354 != nil:
    section.add "fields", valid_579354
  var valid_579355 = query.getOrDefault("access_token")
  valid_579355 = validateParameter(valid_579355, JString, required = false,
                                 default = nil)
  if valid_579355 != nil:
    section.add "access_token", valid_579355
  var valid_579356 = query.getOrDefault("upload_protocol")
  valid_579356 = validateParameter(valid_579356, JString, required = false,
                                 default = nil)
  if valid_579356 != nil:
    section.add "upload_protocol", valid_579356
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579358: Call_VisionProjectsLocationsProductsReferenceImagesCreate_579341;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates and returns a new ReferenceImage resource.
  ## 
  ## The `bounding_poly` field is optional. If `bounding_poly` is not specified,
  ## the system will try to detect regions of interest in the image that are
  ## compatible with the product_category on the parent product. If it is
  ## specified, detection is ALWAYS skipped. The system converts polygons into
  ## non-rotated rectangles.
  ## 
  ## Note that the pipeline will resize the image if the image resolution is too
  ## large to process (above 50MP).
  ## 
  ## Possible errors:
  ## 
  ## * Returns INVALID_ARGUMENT if the image_uri is missing or longer than 4096
  ##   characters.
  ## * Returns INVALID_ARGUMENT if the product does not exist.
  ## * Returns INVALID_ARGUMENT if bounding_poly is not provided, and nothing
  ##   compatible with the parent product's product_category is detected.
  ## * Returns INVALID_ARGUMENT if bounding_poly contains more than 10 polygons.
  ## 
  let valid = call_579358.validator(path, query, header, formData, body)
  let scheme = call_579358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579358.url(scheme.get, call_579358.host, call_579358.base,
                         call_579358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579358, url, valid)

proc call*(call_579359: Call_VisionProjectsLocationsProductsReferenceImagesCreate_579341;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; referenceImageId: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## visionProjectsLocationsProductsReferenceImagesCreate
  ## Creates and returns a new ReferenceImage resource.
  ## 
  ## The `bounding_poly` field is optional. If `bounding_poly` is not specified,
  ## the system will try to detect regions of interest in the image that are
  ## compatible with the product_category on the parent product. If it is
  ## specified, detection is ALWAYS skipped. The system converts polygons into
  ## non-rotated rectangles.
  ## 
  ## Note that the pipeline will resize the image if the image resolution is too
  ## large to process (above 50MP).
  ## 
  ## Possible errors:
  ## 
  ## * Returns INVALID_ARGUMENT if the image_uri is missing or longer than 4096
  ##   characters.
  ## * Returns INVALID_ARGUMENT if the product does not exist.
  ## * Returns INVALID_ARGUMENT if bounding_poly is not provided, and nothing
  ##   compatible with the parent product's product_category is detected.
  ## * Returns INVALID_ARGUMENT if bounding_poly contains more than 10 polygons.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   referenceImageId: string
  ##                   : A user-supplied resource id for the ReferenceImage to be added. If set,
  ## the server will attempt to use this value as the resource id. If it is
  ## already in use, an error is returned with code ALREADY_EXISTS. Must be at
  ## most 128 characters long. It cannot contain the character `/`.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. Resource name of the product in which to create the reference image.
  ## 
  ## Format is
  ## `projects/PROJECT_ID/locations/LOC_ID/products/PRODUCT_ID`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579360 = newJObject()
  var query_579361 = newJObject()
  var body_579362 = newJObject()
  add(query_579361, "key", newJString(key))
  add(query_579361, "prettyPrint", newJBool(prettyPrint))
  add(query_579361, "oauth_token", newJString(oauthToken))
  add(query_579361, "$.xgafv", newJString(Xgafv))
  add(query_579361, "referenceImageId", newJString(referenceImageId))
  add(query_579361, "alt", newJString(alt))
  add(query_579361, "uploadType", newJString(uploadType))
  add(query_579361, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579362 = body
  add(query_579361, "callback", newJString(callback))
  add(path_579360, "parent", newJString(parent))
  add(query_579361, "fields", newJString(fields))
  add(query_579361, "access_token", newJString(accessToken))
  add(query_579361, "upload_protocol", newJString(uploadProtocol))
  result = call_579359.call(path_579360, query_579361, nil, nil, body_579362)

var visionProjectsLocationsProductsReferenceImagesCreate* = Call_VisionProjectsLocationsProductsReferenceImagesCreate_579341(
    name: "visionProjectsLocationsProductsReferenceImagesCreate",
    meth: HttpMethod.HttpPost, host: "vision.googleapis.com",
    route: "/v1/{parent}/referenceImages",
    validator: validate_VisionProjectsLocationsProductsReferenceImagesCreate_579342,
    base: "/", url: url_VisionProjectsLocationsProductsReferenceImagesCreate_579343,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductsReferenceImagesList_579320 = ref object of OpenApiRestCall_578348
proc url_VisionProjectsLocationsProductsReferenceImagesList_579322(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/referenceImages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VisionProjectsLocationsProductsReferenceImagesList_579321(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists reference images.
  ## 
  ## Possible errors:
  ## 
  ## * Returns NOT_FOUND if the parent product does not exist.
  ## * Returns INVALID_ARGUMENT if the page_size is greater than 100, or less
  ##   than 1.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. Resource name of the product containing the reference images.
  ## 
  ## Format is
  ## `projects/PROJECT_ID/locations/LOC_ID/products/PRODUCT_ID`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579323 = path.getOrDefault("parent")
  valid_579323 = validateParameter(valid_579323, JString, required = true,
                                 default = nil)
  if valid_579323 != nil:
    section.add "parent", valid_579323
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of items to return. Default 10, maximum 100.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : A token identifying a page of results to be returned. This is the value
  ## of `nextPageToken` returned in a previous reference image list request.
  ## 
  ## Defaults to the first page if not specified.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579324 = query.getOrDefault("key")
  valid_579324 = validateParameter(valid_579324, JString, required = false,
                                 default = nil)
  if valid_579324 != nil:
    section.add "key", valid_579324
  var valid_579325 = query.getOrDefault("prettyPrint")
  valid_579325 = validateParameter(valid_579325, JBool, required = false,
                                 default = newJBool(true))
  if valid_579325 != nil:
    section.add "prettyPrint", valid_579325
  var valid_579326 = query.getOrDefault("oauth_token")
  valid_579326 = validateParameter(valid_579326, JString, required = false,
                                 default = nil)
  if valid_579326 != nil:
    section.add "oauth_token", valid_579326
  var valid_579327 = query.getOrDefault("$.xgafv")
  valid_579327 = validateParameter(valid_579327, JString, required = false,
                                 default = newJString("1"))
  if valid_579327 != nil:
    section.add "$.xgafv", valid_579327
  var valid_579328 = query.getOrDefault("pageSize")
  valid_579328 = validateParameter(valid_579328, JInt, required = false, default = nil)
  if valid_579328 != nil:
    section.add "pageSize", valid_579328
  var valid_579329 = query.getOrDefault("alt")
  valid_579329 = validateParameter(valid_579329, JString, required = false,
                                 default = newJString("json"))
  if valid_579329 != nil:
    section.add "alt", valid_579329
  var valid_579330 = query.getOrDefault("uploadType")
  valid_579330 = validateParameter(valid_579330, JString, required = false,
                                 default = nil)
  if valid_579330 != nil:
    section.add "uploadType", valid_579330
  var valid_579331 = query.getOrDefault("quotaUser")
  valid_579331 = validateParameter(valid_579331, JString, required = false,
                                 default = nil)
  if valid_579331 != nil:
    section.add "quotaUser", valid_579331
  var valid_579332 = query.getOrDefault("pageToken")
  valid_579332 = validateParameter(valid_579332, JString, required = false,
                                 default = nil)
  if valid_579332 != nil:
    section.add "pageToken", valid_579332
  var valid_579333 = query.getOrDefault("callback")
  valid_579333 = validateParameter(valid_579333, JString, required = false,
                                 default = nil)
  if valid_579333 != nil:
    section.add "callback", valid_579333
  var valid_579334 = query.getOrDefault("fields")
  valid_579334 = validateParameter(valid_579334, JString, required = false,
                                 default = nil)
  if valid_579334 != nil:
    section.add "fields", valid_579334
  var valid_579335 = query.getOrDefault("access_token")
  valid_579335 = validateParameter(valid_579335, JString, required = false,
                                 default = nil)
  if valid_579335 != nil:
    section.add "access_token", valid_579335
  var valid_579336 = query.getOrDefault("upload_protocol")
  valid_579336 = validateParameter(valid_579336, JString, required = false,
                                 default = nil)
  if valid_579336 != nil:
    section.add "upload_protocol", valid_579336
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579337: Call_VisionProjectsLocationsProductsReferenceImagesList_579320;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists reference images.
  ## 
  ## Possible errors:
  ## 
  ## * Returns NOT_FOUND if the parent product does not exist.
  ## * Returns INVALID_ARGUMENT if the page_size is greater than 100, or less
  ##   than 1.
  ## 
  let valid = call_579337.validator(path, query, header, formData, body)
  let scheme = call_579337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579337.url(scheme.get, call_579337.host, call_579337.base,
                         call_579337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579337, url, valid)

proc call*(call_579338: Call_VisionProjectsLocationsProductsReferenceImagesList_579320;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## visionProjectsLocationsProductsReferenceImagesList
  ## Lists reference images.
  ## 
  ## Possible errors:
  ## 
  ## * Returns NOT_FOUND if the parent product does not exist.
  ## * Returns INVALID_ARGUMENT if the page_size is greater than 100, or less
  ##   than 1.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return. Default 10, maximum 100.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : A token identifying a page of results to be returned. This is the value
  ## of `nextPageToken` returned in a previous reference image list request.
  ## 
  ## Defaults to the first page if not specified.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. Resource name of the product containing the reference images.
  ## 
  ## Format is
  ## `projects/PROJECT_ID/locations/LOC_ID/products/PRODUCT_ID`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579339 = newJObject()
  var query_579340 = newJObject()
  add(query_579340, "key", newJString(key))
  add(query_579340, "prettyPrint", newJBool(prettyPrint))
  add(query_579340, "oauth_token", newJString(oauthToken))
  add(query_579340, "$.xgafv", newJString(Xgafv))
  add(query_579340, "pageSize", newJInt(pageSize))
  add(query_579340, "alt", newJString(alt))
  add(query_579340, "uploadType", newJString(uploadType))
  add(query_579340, "quotaUser", newJString(quotaUser))
  add(query_579340, "pageToken", newJString(pageToken))
  add(query_579340, "callback", newJString(callback))
  add(path_579339, "parent", newJString(parent))
  add(query_579340, "fields", newJString(fields))
  add(query_579340, "access_token", newJString(accessToken))
  add(query_579340, "upload_protocol", newJString(uploadProtocol))
  result = call_579338.call(path_579339, query_579340, nil, nil, nil)

var visionProjectsLocationsProductsReferenceImagesList* = Call_VisionProjectsLocationsProductsReferenceImagesList_579320(
    name: "visionProjectsLocationsProductsReferenceImagesList",
    meth: HttpMethod.HttpGet, host: "vision.googleapis.com",
    route: "/v1/{parent}/referenceImages",
    validator: validate_VisionProjectsLocationsProductsReferenceImagesList_579321,
    base: "/", url: url_VisionProjectsLocationsProductsReferenceImagesList_579322,
    schemes: {Scheme.Https})
export
  rest

type
  GoogleAuth = ref object
    endpoint*: Uri
    token: string
    expiry*: float64
    issued*: float64
    email: string
    key: string
    scope*: seq[string]
    form: string
    digest: Hash

const
  endpoint = "https://www.googleapis.com/oauth2/v4/token".parseUri
var auth = GoogleAuth(endpoint: endpoint)
proc hash(auth: GoogleAuth): Hash =
  ## yield differing values for effectively different auth payloads
  result = hash($auth.endpoint)
  result = result !& hash(auth.email)
  result = result !& hash(auth.key)
  result = result !& hash(auth.scope.join(" "))
  result = !$result

proc newAuthenticator*(path: string): GoogleAuth =
  let
    input = readFile(path)
    js = parseJson(input)
  auth.email = js["client_email"].getStr
  auth.key = js["private_key"].getStr
  result = auth

proc store(auth: var GoogleAuth; token: string; expiry: int; form: string) =
  auth.token = token
  auth.issued = epochTime()
  auth.expiry = auth.issued + expiry.float64
  auth.form = form
  auth.digest = auth.hash

proc authenticate*(fresh: float64 = 3600.0; lifetime: int = 3600): Future[bool] {.async.} =
  ## get or refresh an authentication token; provide `fresh`
  ## to ensure that the token won't expire in the next N seconds.
  ## provide `lifetime` to indicate how long the token should last.
  let clock = epochTime()
  if auth.expiry > clock + fresh:
    if auth.hash == auth.digest:
      return true
  let
    expiry = clock.int + lifetime
    header = JOSEHeader(alg: RS256, typ: "JWT")
    claims = %*{"iss": auth.email, "scope": auth.scope.join(" "),
              "aud": "https://www.googleapis.com/oauth2/v4/token", "exp": expiry,
              "iat": clock.int}
  var tok = JWT(header: header, claims: toClaims(claims))
  tok.sign(auth.key)
  let post = encodeQuery({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                       "assertion": $tok}, usePlus = false, omitEq = false)
  var client = newAsyncHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/x-www-form-urlencoded",
                                 "Content-Length": $post.len})
  let response = await client.request($auth.endpoint, HttpPost, body = post)
  if not response.code.is2xx:
    return false
  let body = await response.body
  client.close
  try:
    let js = parseJson(body)
    auth.store(js["access_token"].getStr, js["expires_in"].getInt,
               js["token_type"].getStr)
  except KeyError:
    return false
  except JsonParsingError:
    return false
  return true

proc composeQueryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs, usePlus = false, omitEq = false)

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  var headers = massageHeaders(input.getOrDefault("header"))
  let body = input.getOrDefault("body").getStr
  if auth.scope.len == 0:
    raise newException(ValueError, "specify authentication scopes")
  if not waitfor authenticate(fresh = 10.0):
    raise newException(IOError, "unable to refresh authentication token")
  headers.add ("Authorization", auth.form & " " & auth.token)
  headers.add ("Content-Type", "application/json")
  headers.add ("Content-Length", $body.len)
  result = newRecallable(call, url, headers, body = body)
