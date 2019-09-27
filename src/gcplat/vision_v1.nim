
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593421): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "vision"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_VisionFilesAnnotate_593690 = ref object of OpenApiRestCall_593421
proc url_VisionFilesAnnotate_593692(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_VisionFilesAnnotate_593691(path: JsonNode; query: JsonNode;
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
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593804 = query.getOrDefault("upload_protocol")
  valid_593804 = validateParameter(valid_593804, JString, required = false,
                                 default = nil)
  if valid_593804 != nil:
    section.add "upload_protocol", valid_593804
  var valid_593805 = query.getOrDefault("fields")
  valid_593805 = validateParameter(valid_593805, JString, required = false,
                                 default = nil)
  if valid_593805 != nil:
    section.add "fields", valid_593805
  var valid_593806 = query.getOrDefault("quotaUser")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "quotaUser", valid_593806
  var valid_593820 = query.getOrDefault("alt")
  valid_593820 = validateParameter(valid_593820, JString, required = false,
                                 default = newJString("json"))
  if valid_593820 != nil:
    section.add "alt", valid_593820
  var valid_593821 = query.getOrDefault("oauth_token")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = nil)
  if valid_593821 != nil:
    section.add "oauth_token", valid_593821
  var valid_593822 = query.getOrDefault("callback")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = nil)
  if valid_593822 != nil:
    section.add "callback", valid_593822
  var valid_593823 = query.getOrDefault("access_token")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "access_token", valid_593823
  var valid_593824 = query.getOrDefault("uploadType")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "uploadType", valid_593824
  var valid_593825 = query.getOrDefault("key")
  valid_593825 = validateParameter(valid_593825, JString, required = false,
                                 default = nil)
  if valid_593825 != nil:
    section.add "key", valid_593825
  var valid_593826 = query.getOrDefault("$.xgafv")
  valid_593826 = validateParameter(valid_593826, JString, required = false,
                                 default = newJString("1"))
  if valid_593826 != nil:
    section.add "$.xgafv", valid_593826
  var valid_593827 = query.getOrDefault("prettyPrint")
  valid_593827 = validateParameter(valid_593827, JBool, required = false,
                                 default = newJBool(true))
  if valid_593827 != nil:
    section.add "prettyPrint", valid_593827
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

proc call*(call_593851: Call_VisionFilesAnnotate_593690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Service that performs image detection and annotation for a batch of files.
  ## Now only "application/pdf", "image/tiff" and "image/gif" are supported.
  ## 
  ## This service will extract at most 5 (customers can specify which 5 in
  ## AnnotateFileRequest.pages) frames (gif) or pages (pdf or tiff) from each
  ## file provided and perform detection and annotation for each image
  ## extracted.
  ## 
  let valid = call_593851.validator(path, query, header, formData, body)
  let scheme = call_593851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593851.url(scheme.get, call_593851.host, call_593851.base,
                         call_593851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593851, url, valid)

proc call*(call_593922: Call_VisionFilesAnnotate_593690;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## visionFilesAnnotate
  ## Service that performs image detection and annotation for a batch of files.
  ## Now only "application/pdf", "image/tiff" and "image/gif" are supported.
  ## 
  ## This service will extract at most 5 (customers can specify which 5 in
  ## AnnotateFileRequest.pages) frames (gif) or pages (pdf or tiff) from each
  ## file provided and perform detection and annotation for each image
  ## extracted.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_593923 = newJObject()
  var body_593925 = newJObject()
  add(query_593923, "upload_protocol", newJString(uploadProtocol))
  add(query_593923, "fields", newJString(fields))
  add(query_593923, "quotaUser", newJString(quotaUser))
  add(query_593923, "alt", newJString(alt))
  add(query_593923, "oauth_token", newJString(oauthToken))
  add(query_593923, "callback", newJString(callback))
  add(query_593923, "access_token", newJString(accessToken))
  add(query_593923, "uploadType", newJString(uploadType))
  add(query_593923, "key", newJString(key))
  add(query_593923, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_593925 = body
  add(query_593923, "prettyPrint", newJBool(prettyPrint))
  result = call_593922.call(nil, query_593923, nil, nil, body_593925)

var visionFilesAnnotate* = Call_VisionFilesAnnotate_593690(
    name: "visionFilesAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/files:annotate",
    validator: validate_VisionFilesAnnotate_593691, base: "/",
    url: url_VisionFilesAnnotate_593692, schemes: {Scheme.Https})
type
  Call_VisionFilesAsyncBatchAnnotate_593964 = ref object of OpenApiRestCall_593421
proc url_VisionFilesAsyncBatchAnnotate_593966(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_VisionFilesAsyncBatchAnnotate_593965(path: JsonNode; query: JsonNode;
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
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593967 = query.getOrDefault("upload_protocol")
  valid_593967 = validateParameter(valid_593967, JString, required = false,
                                 default = nil)
  if valid_593967 != nil:
    section.add "upload_protocol", valid_593967
  var valid_593968 = query.getOrDefault("fields")
  valid_593968 = validateParameter(valid_593968, JString, required = false,
                                 default = nil)
  if valid_593968 != nil:
    section.add "fields", valid_593968
  var valid_593969 = query.getOrDefault("quotaUser")
  valid_593969 = validateParameter(valid_593969, JString, required = false,
                                 default = nil)
  if valid_593969 != nil:
    section.add "quotaUser", valid_593969
  var valid_593970 = query.getOrDefault("alt")
  valid_593970 = validateParameter(valid_593970, JString, required = false,
                                 default = newJString("json"))
  if valid_593970 != nil:
    section.add "alt", valid_593970
  var valid_593971 = query.getOrDefault("oauth_token")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = nil)
  if valid_593971 != nil:
    section.add "oauth_token", valid_593971
  var valid_593972 = query.getOrDefault("callback")
  valid_593972 = validateParameter(valid_593972, JString, required = false,
                                 default = nil)
  if valid_593972 != nil:
    section.add "callback", valid_593972
  var valid_593973 = query.getOrDefault("access_token")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = nil)
  if valid_593973 != nil:
    section.add "access_token", valid_593973
  var valid_593974 = query.getOrDefault("uploadType")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = nil)
  if valid_593974 != nil:
    section.add "uploadType", valid_593974
  var valid_593975 = query.getOrDefault("key")
  valid_593975 = validateParameter(valid_593975, JString, required = false,
                                 default = nil)
  if valid_593975 != nil:
    section.add "key", valid_593975
  var valid_593976 = query.getOrDefault("$.xgafv")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = newJString("1"))
  if valid_593976 != nil:
    section.add "$.xgafv", valid_593976
  var valid_593977 = query.getOrDefault("prettyPrint")
  valid_593977 = validateParameter(valid_593977, JBool, required = false,
                                 default = newJBool(true))
  if valid_593977 != nil:
    section.add "prettyPrint", valid_593977
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

proc call*(call_593979: Call_VisionFilesAsyncBatchAnnotate_593964; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Run asynchronous image detection and annotation for a list of generic
  ## files, such as PDF files, which may contain multiple pages and multiple
  ## images per page. Progress and results can be retrieved through the
  ## `google.longrunning.Operations` interface.
  ## `Operation.metadata` contains `OperationMetadata` (metadata).
  ## `Operation.response` contains `AsyncBatchAnnotateFilesResponse` (results).
  ## 
  let valid = call_593979.validator(path, query, header, formData, body)
  let scheme = call_593979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593979.url(scheme.get, call_593979.host, call_593979.base,
                         call_593979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593979, url, valid)

proc call*(call_593980: Call_VisionFilesAsyncBatchAnnotate_593964;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## visionFilesAsyncBatchAnnotate
  ## Run asynchronous image detection and annotation for a list of generic
  ## files, such as PDF files, which may contain multiple pages and multiple
  ## images per page. Progress and results can be retrieved through the
  ## `google.longrunning.Operations` interface.
  ## `Operation.metadata` contains `OperationMetadata` (metadata).
  ## `Operation.response` contains `AsyncBatchAnnotateFilesResponse` (results).
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_593981 = newJObject()
  var body_593982 = newJObject()
  add(query_593981, "upload_protocol", newJString(uploadProtocol))
  add(query_593981, "fields", newJString(fields))
  add(query_593981, "quotaUser", newJString(quotaUser))
  add(query_593981, "alt", newJString(alt))
  add(query_593981, "oauth_token", newJString(oauthToken))
  add(query_593981, "callback", newJString(callback))
  add(query_593981, "access_token", newJString(accessToken))
  add(query_593981, "uploadType", newJString(uploadType))
  add(query_593981, "key", newJString(key))
  add(query_593981, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_593982 = body
  add(query_593981, "prettyPrint", newJBool(prettyPrint))
  result = call_593980.call(nil, query_593981, nil, nil, body_593982)

var visionFilesAsyncBatchAnnotate* = Call_VisionFilesAsyncBatchAnnotate_593964(
    name: "visionFilesAsyncBatchAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/files:asyncBatchAnnotate",
    validator: validate_VisionFilesAsyncBatchAnnotate_593965, base: "/",
    url: url_VisionFilesAsyncBatchAnnotate_593966, schemes: {Scheme.Https})
type
  Call_VisionImagesAnnotate_593983 = ref object of OpenApiRestCall_593421
proc url_VisionImagesAnnotate_593985(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_VisionImagesAnnotate_593984(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Run image detection and annotation for a batch of images.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593986 = query.getOrDefault("upload_protocol")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = nil)
  if valid_593986 != nil:
    section.add "upload_protocol", valid_593986
  var valid_593987 = query.getOrDefault("fields")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "fields", valid_593987
  var valid_593988 = query.getOrDefault("quotaUser")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "quotaUser", valid_593988
  var valid_593989 = query.getOrDefault("alt")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = newJString("json"))
  if valid_593989 != nil:
    section.add "alt", valid_593989
  var valid_593990 = query.getOrDefault("oauth_token")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "oauth_token", valid_593990
  var valid_593991 = query.getOrDefault("callback")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = nil)
  if valid_593991 != nil:
    section.add "callback", valid_593991
  var valid_593992 = query.getOrDefault("access_token")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "access_token", valid_593992
  var valid_593993 = query.getOrDefault("uploadType")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = nil)
  if valid_593993 != nil:
    section.add "uploadType", valid_593993
  var valid_593994 = query.getOrDefault("key")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "key", valid_593994
  var valid_593995 = query.getOrDefault("$.xgafv")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = newJString("1"))
  if valid_593995 != nil:
    section.add "$.xgafv", valid_593995
  var valid_593996 = query.getOrDefault("prettyPrint")
  valid_593996 = validateParameter(valid_593996, JBool, required = false,
                                 default = newJBool(true))
  if valid_593996 != nil:
    section.add "prettyPrint", valid_593996
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

proc call*(call_593998: Call_VisionImagesAnnotate_593983; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Run image detection and annotation for a batch of images.
  ## 
  let valid = call_593998.validator(path, query, header, formData, body)
  let scheme = call_593998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593998.url(scheme.get, call_593998.host, call_593998.base,
                         call_593998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593998, url, valid)

proc call*(call_593999: Call_VisionImagesAnnotate_593983;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## visionImagesAnnotate
  ## Run image detection and annotation for a batch of images.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594000 = newJObject()
  var body_594001 = newJObject()
  add(query_594000, "upload_protocol", newJString(uploadProtocol))
  add(query_594000, "fields", newJString(fields))
  add(query_594000, "quotaUser", newJString(quotaUser))
  add(query_594000, "alt", newJString(alt))
  add(query_594000, "oauth_token", newJString(oauthToken))
  add(query_594000, "callback", newJString(callback))
  add(query_594000, "access_token", newJString(accessToken))
  add(query_594000, "uploadType", newJString(uploadType))
  add(query_594000, "key", newJString(key))
  add(query_594000, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594001 = body
  add(query_594000, "prettyPrint", newJBool(prettyPrint))
  result = call_593999.call(nil, query_594000, nil, nil, body_594001)

var visionImagesAnnotate* = Call_VisionImagesAnnotate_593983(
    name: "visionImagesAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/images:annotate",
    validator: validate_VisionImagesAnnotate_593984, base: "/",
    url: url_VisionImagesAnnotate_593985, schemes: {Scheme.Https})
type
  Call_VisionImagesAsyncBatchAnnotate_594002 = ref object of OpenApiRestCall_593421
proc url_VisionImagesAsyncBatchAnnotate_594004(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_VisionImagesAsyncBatchAnnotate_594003(path: JsonNode;
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
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594005 = query.getOrDefault("upload_protocol")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = nil)
  if valid_594005 != nil:
    section.add "upload_protocol", valid_594005
  var valid_594006 = query.getOrDefault("fields")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "fields", valid_594006
  var valid_594007 = query.getOrDefault("quotaUser")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "quotaUser", valid_594007
  var valid_594008 = query.getOrDefault("alt")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = newJString("json"))
  if valid_594008 != nil:
    section.add "alt", valid_594008
  var valid_594009 = query.getOrDefault("oauth_token")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "oauth_token", valid_594009
  var valid_594010 = query.getOrDefault("callback")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "callback", valid_594010
  var valid_594011 = query.getOrDefault("access_token")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "access_token", valid_594011
  var valid_594012 = query.getOrDefault("uploadType")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "uploadType", valid_594012
  var valid_594013 = query.getOrDefault("key")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "key", valid_594013
  var valid_594014 = query.getOrDefault("$.xgafv")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = newJString("1"))
  if valid_594014 != nil:
    section.add "$.xgafv", valid_594014
  var valid_594015 = query.getOrDefault("prettyPrint")
  valid_594015 = validateParameter(valid_594015, JBool, required = false,
                                 default = newJBool(true))
  if valid_594015 != nil:
    section.add "prettyPrint", valid_594015
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

proc call*(call_594017: Call_VisionImagesAsyncBatchAnnotate_594002; path: JsonNode;
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
  let valid = call_594017.validator(path, query, header, formData, body)
  let scheme = call_594017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594017.url(scheme.get, call_594017.host, call_594017.base,
                         call_594017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594017, url, valid)

proc call*(call_594018: Call_VisionImagesAsyncBatchAnnotate_594002;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594019 = newJObject()
  var body_594020 = newJObject()
  add(query_594019, "upload_protocol", newJString(uploadProtocol))
  add(query_594019, "fields", newJString(fields))
  add(query_594019, "quotaUser", newJString(quotaUser))
  add(query_594019, "alt", newJString(alt))
  add(query_594019, "oauth_token", newJString(oauthToken))
  add(query_594019, "callback", newJString(callback))
  add(query_594019, "access_token", newJString(accessToken))
  add(query_594019, "uploadType", newJString(uploadType))
  add(query_594019, "key", newJString(key))
  add(query_594019, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594020 = body
  add(query_594019, "prettyPrint", newJBool(prettyPrint))
  result = call_594018.call(nil, query_594019, nil, nil, body_594020)

var visionImagesAsyncBatchAnnotate* = Call_VisionImagesAsyncBatchAnnotate_594002(
    name: "visionImagesAsyncBatchAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/images:asyncBatchAnnotate",
    validator: validate_VisionImagesAsyncBatchAnnotate_594003, base: "/",
    url: url_VisionImagesAsyncBatchAnnotate_594004, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsOperationsGet_594021 = ref object of OpenApiRestCall_593421
proc url_VisionProjectsLocationsOperationsGet_594023(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VisionProjectsLocationsOperationsGet_594022(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594038 = path.getOrDefault("name")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "name", valid_594038
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594039 = query.getOrDefault("upload_protocol")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = nil)
  if valid_594039 != nil:
    section.add "upload_protocol", valid_594039
  var valid_594040 = query.getOrDefault("fields")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = nil)
  if valid_594040 != nil:
    section.add "fields", valid_594040
  var valid_594041 = query.getOrDefault("quotaUser")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = nil)
  if valid_594041 != nil:
    section.add "quotaUser", valid_594041
  var valid_594042 = query.getOrDefault("alt")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = newJString("json"))
  if valid_594042 != nil:
    section.add "alt", valid_594042
  var valid_594043 = query.getOrDefault("oauth_token")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = nil)
  if valid_594043 != nil:
    section.add "oauth_token", valid_594043
  var valid_594044 = query.getOrDefault("callback")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = nil)
  if valid_594044 != nil:
    section.add "callback", valid_594044
  var valid_594045 = query.getOrDefault("access_token")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = nil)
  if valid_594045 != nil:
    section.add "access_token", valid_594045
  var valid_594046 = query.getOrDefault("uploadType")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = nil)
  if valid_594046 != nil:
    section.add "uploadType", valid_594046
  var valid_594047 = query.getOrDefault("key")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = nil)
  if valid_594047 != nil:
    section.add "key", valid_594047
  var valid_594048 = query.getOrDefault("$.xgafv")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = newJString("1"))
  if valid_594048 != nil:
    section.add "$.xgafv", valid_594048
  var valid_594049 = query.getOrDefault("prettyPrint")
  valid_594049 = validateParameter(valid_594049, JBool, required = false,
                                 default = newJBool(true))
  if valid_594049 != nil:
    section.add "prettyPrint", valid_594049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594050: Call_VisionProjectsLocationsOperationsGet_594021;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_594050.validator(path, query, header, formData, body)
  let scheme = call_594050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594050.url(scheme.get, call_594050.host, call_594050.base,
                         call_594050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594050, url, valid)

proc call*(call_594051: Call_VisionProjectsLocationsOperationsGet_594021;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## visionProjectsLocationsOperationsGet
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594052 = newJObject()
  var query_594053 = newJObject()
  add(query_594053, "upload_protocol", newJString(uploadProtocol))
  add(query_594053, "fields", newJString(fields))
  add(query_594053, "quotaUser", newJString(quotaUser))
  add(path_594052, "name", newJString(name))
  add(query_594053, "alt", newJString(alt))
  add(query_594053, "oauth_token", newJString(oauthToken))
  add(query_594053, "callback", newJString(callback))
  add(query_594053, "access_token", newJString(accessToken))
  add(query_594053, "uploadType", newJString(uploadType))
  add(query_594053, "key", newJString(key))
  add(query_594053, "$.xgafv", newJString(Xgafv))
  add(query_594053, "prettyPrint", newJBool(prettyPrint))
  result = call_594051.call(path_594052, query_594053, nil, nil, nil)

var visionProjectsLocationsOperationsGet* = Call_VisionProjectsLocationsOperationsGet_594021(
    name: "visionProjectsLocationsOperationsGet", meth: HttpMethod.HttpGet,
    host: "vision.googleapis.com", route: "/v1/{name}",
    validator: validate_VisionProjectsLocationsOperationsGet_594022, base: "/",
    url: url_VisionProjectsLocationsOperationsGet_594023, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsPatch_594073 = ref object of OpenApiRestCall_593421
proc url_VisionProjectsLocationsProductSetsPatch_594075(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VisionProjectsLocationsProductSetsPatch_594074(path: JsonNode;
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
  var valid_594076 = path.getOrDefault("name")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "name", valid_594076
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: JString
  ##             : The FieldMask that specifies which fields to
  ## update.
  ## If update_mask isn't specified, all mutable fields are to be updated.
  ## Valid mask path is `display_name`.
  section = newJObject()
  var valid_594077 = query.getOrDefault("upload_protocol")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = nil)
  if valid_594077 != nil:
    section.add "upload_protocol", valid_594077
  var valid_594078 = query.getOrDefault("fields")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = nil)
  if valid_594078 != nil:
    section.add "fields", valid_594078
  var valid_594079 = query.getOrDefault("quotaUser")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = nil)
  if valid_594079 != nil:
    section.add "quotaUser", valid_594079
  var valid_594080 = query.getOrDefault("alt")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = newJString("json"))
  if valid_594080 != nil:
    section.add "alt", valid_594080
  var valid_594081 = query.getOrDefault("oauth_token")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = nil)
  if valid_594081 != nil:
    section.add "oauth_token", valid_594081
  var valid_594082 = query.getOrDefault("callback")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = nil)
  if valid_594082 != nil:
    section.add "callback", valid_594082
  var valid_594083 = query.getOrDefault("access_token")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = nil)
  if valid_594083 != nil:
    section.add "access_token", valid_594083
  var valid_594084 = query.getOrDefault("uploadType")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = nil)
  if valid_594084 != nil:
    section.add "uploadType", valid_594084
  var valid_594085 = query.getOrDefault("key")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = nil)
  if valid_594085 != nil:
    section.add "key", valid_594085
  var valid_594086 = query.getOrDefault("$.xgafv")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = newJString("1"))
  if valid_594086 != nil:
    section.add "$.xgafv", valid_594086
  var valid_594087 = query.getOrDefault("prettyPrint")
  valid_594087 = validateParameter(valid_594087, JBool, required = false,
                                 default = newJBool(true))
  if valid_594087 != nil:
    section.add "prettyPrint", valid_594087
  var valid_594088 = query.getOrDefault("updateMask")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = nil)
  if valid_594088 != nil:
    section.add "updateMask", valid_594088
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

proc call*(call_594090: Call_VisionProjectsLocationsProductSetsPatch_594073;
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
  let valid = call_594090.validator(path, query, header, formData, body)
  let scheme = call_594090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594090.url(scheme.get, call_594090.host, call_594090.base,
                         call_594090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594090, url, valid)

proc call*(call_594091: Call_VisionProjectsLocationsProductSetsPatch_594073;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## visionProjectsLocationsProductSetsPatch
  ## Makes changes to a ProductSet resource.
  ## Only display_name can be updated currently.
  ## 
  ## Possible errors:
  ## 
  ## * Returns NOT_FOUND if the ProductSet does not exist.
  ## * Returns INVALID_ARGUMENT if display_name is present in update_mask but
  ##   missing from the request or longer than 4096 characters.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the ProductSet.
  ## 
  ## Format is:
  ## `projects/PROJECT_ID/locations/LOC_ID/productSets/PRODUCT_SET_ID`.
  ## 
  ## This field is ignored when creating a ProductSet.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: string
  ##             : The FieldMask that specifies which fields to
  ## update.
  ## If update_mask isn't specified, all mutable fields are to be updated.
  ## Valid mask path is `display_name`.
  var path_594092 = newJObject()
  var query_594093 = newJObject()
  var body_594094 = newJObject()
  add(query_594093, "upload_protocol", newJString(uploadProtocol))
  add(query_594093, "fields", newJString(fields))
  add(query_594093, "quotaUser", newJString(quotaUser))
  add(path_594092, "name", newJString(name))
  add(query_594093, "alt", newJString(alt))
  add(query_594093, "oauth_token", newJString(oauthToken))
  add(query_594093, "callback", newJString(callback))
  add(query_594093, "access_token", newJString(accessToken))
  add(query_594093, "uploadType", newJString(uploadType))
  add(query_594093, "key", newJString(key))
  add(query_594093, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594094 = body
  add(query_594093, "prettyPrint", newJBool(prettyPrint))
  add(query_594093, "updateMask", newJString(updateMask))
  result = call_594091.call(path_594092, query_594093, nil, nil, body_594094)

var visionProjectsLocationsProductSetsPatch* = Call_VisionProjectsLocationsProductSetsPatch_594073(
    name: "visionProjectsLocationsProductSetsPatch", meth: HttpMethod.HttpPatch,
    host: "vision.googleapis.com", route: "/v1/{name}",
    validator: validate_VisionProjectsLocationsProductSetsPatch_594074, base: "/",
    url: url_VisionProjectsLocationsProductSetsPatch_594075,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsDelete_594054 = ref object of OpenApiRestCall_593421
proc url_VisionProjectsLocationsProductSetsDelete_594056(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VisionProjectsLocationsProductSetsDelete_594055(path: JsonNode;
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
  var valid_594057 = path.getOrDefault("name")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "name", valid_594057
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594058 = query.getOrDefault("upload_protocol")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "upload_protocol", valid_594058
  var valid_594059 = query.getOrDefault("fields")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = nil)
  if valid_594059 != nil:
    section.add "fields", valid_594059
  var valid_594060 = query.getOrDefault("quotaUser")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "quotaUser", valid_594060
  var valid_594061 = query.getOrDefault("alt")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = newJString("json"))
  if valid_594061 != nil:
    section.add "alt", valid_594061
  var valid_594062 = query.getOrDefault("oauth_token")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "oauth_token", valid_594062
  var valid_594063 = query.getOrDefault("callback")
  valid_594063 = validateParameter(valid_594063, JString, required = false,
                                 default = nil)
  if valid_594063 != nil:
    section.add "callback", valid_594063
  var valid_594064 = query.getOrDefault("access_token")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = nil)
  if valid_594064 != nil:
    section.add "access_token", valid_594064
  var valid_594065 = query.getOrDefault("uploadType")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "uploadType", valid_594065
  var valid_594066 = query.getOrDefault("key")
  valid_594066 = validateParameter(valid_594066, JString, required = false,
                                 default = nil)
  if valid_594066 != nil:
    section.add "key", valid_594066
  var valid_594067 = query.getOrDefault("$.xgafv")
  valid_594067 = validateParameter(valid_594067, JString, required = false,
                                 default = newJString("1"))
  if valid_594067 != nil:
    section.add "$.xgafv", valid_594067
  var valid_594068 = query.getOrDefault("prettyPrint")
  valid_594068 = validateParameter(valid_594068, JBool, required = false,
                                 default = newJBool(true))
  if valid_594068 != nil:
    section.add "prettyPrint", valid_594068
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594069: Call_VisionProjectsLocationsProductSetsDelete_594054;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently deletes a ProductSet. Products and ReferenceImages in the
  ## ProductSet are not deleted.
  ## 
  ## The actual image files are not deleted from Google Cloud Storage.
  ## 
  let valid = call_594069.validator(path, query, header, formData, body)
  let scheme = call_594069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594069.url(scheme.get, call_594069.host, call_594069.base,
                         call_594069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594069, url, valid)

proc call*(call_594070: Call_VisionProjectsLocationsProductSetsDelete_594054;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## visionProjectsLocationsProductSetsDelete
  ## Permanently deletes a ProductSet. Products and ReferenceImages in the
  ## ProductSet are not deleted.
  ## 
  ## The actual image files are not deleted from Google Cloud Storage.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. Resource name of the ProductSet to delete.
  ## 
  ## Format is:
  ## `projects/PROJECT_ID/locations/LOC_ID/productSets/PRODUCT_SET_ID`
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594071 = newJObject()
  var query_594072 = newJObject()
  add(query_594072, "upload_protocol", newJString(uploadProtocol))
  add(query_594072, "fields", newJString(fields))
  add(query_594072, "quotaUser", newJString(quotaUser))
  add(path_594071, "name", newJString(name))
  add(query_594072, "alt", newJString(alt))
  add(query_594072, "oauth_token", newJString(oauthToken))
  add(query_594072, "callback", newJString(callback))
  add(query_594072, "access_token", newJString(accessToken))
  add(query_594072, "uploadType", newJString(uploadType))
  add(query_594072, "key", newJString(key))
  add(query_594072, "$.xgafv", newJString(Xgafv))
  add(query_594072, "prettyPrint", newJBool(prettyPrint))
  result = call_594070.call(path_594071, query_594072, nil, nil, nil)

var visionProjectsLocationsProductSetsDelete* = Call_VisionProjectsLocationsProductSetsDelete_594054(
    name: "visionProjectsLocationsProductSetsDelete", meth: HttpMethod.HttpDelete,
    host: "vision.googleapis.com", route: "/v1/{name}",
    validator: validate_VisionProjectsLocationsProductSetsDelete_594055,
    base: "/", url: url_VisionProjectsLocationsProductSetsDelete_594056,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsProductsList_594095 = ref object of OpenApiRestCall_593421
proc url_VisionProjectsLocationsProductSetsProductsList_594097(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VisionProjectsLocationsProductSetsProductsList_594096(
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
  var valid_594098 = path.getOrDefault("name")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "name", valid_594098
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The next_page_token returned from a previous List request, if any.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of items to return. Default 10, maximum 100.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594099 = query.getOrDefault("upload_protocol")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "upload_protocol", valid_594099
  var valid_594100 = query.getOrDefault("fields")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = nil)
  if valid_594100 != nil:
    section.add "fields", valid_594100
  var valid_594101 = query.getOrDefault("pageToken")
  valid_594101 = validateParameter(valid_594101, JString, required = false,
                                 default = nil)
  if valid_594101 != nil:
    section.add "pageToken", valid_594101
  var valid_594102 = query.getOrDefault("quotaUser")
  valid_594102 = validateParameter(valid_594102, JString, required = false,
                                 default = nil)
  if valid_594102 != nil:
    section.add "quotaUser", valid_594102
  var valid_594103 = query.getOrDefault("alt")
  valid_594103 = validateParameter(valid_594103, JString, required = false,
                                 default = newJString("json"))
  if valid_594103 != nil:
    section.add "alt", valid_594103
  var valid_594104 = query.getOrDefault("oauth_token")
  valid_594104 = validateParameter(valid_594104, JString, required = false,
                                 default = nil)
  if valid_594104 != nil:
    section.add "oauth_token", valid_594104
  var valid_594105 = query.getOrDefault("callback")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = nil)
  if valid_594105 != nil:
    section.add "callback", valid_594105
  var valid_594106 = query.getOrDefault("access_token")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = nil)
  if valid_594106 != nil:
    section.add "access_token", valid_594106
  var valid_594107 = query.getOrDefault("uploadType")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = nil)
  if valid_594107 != nil:
    section.add "uploadType", valid_594107
  var valid_594108 = query.getOrDefault("key")
  valid_594108 = validateParameter(valid_594108, JString, required = false,
                                 default = nil)
  if valid_594108 != nil:
    section.add "key", valid_594108
  var valid_594109 = query.getOrDefault("$.xgafv")
  valid_594109 = validateParameter(valid_594109, JString, required = false,
                                 default = newJString("1"))
  if valid_594109 != nil:
    section.add "$.xgafv", valid_594109
  var valid_594110 = query.getOrDefault("pageSize")
  valid_594110 = validateParameter(valid_594110, JInt, required = false, default = nil)
  if valid_594110 != nil:
    section.add "pageSize", valid_594110
  var valid_594111 = query.getOrDefault("prettyPrint")
  valid_594111 = validateParameter(valid_594111, JBool, required = false,
                                 default = newJBool(true))
  if valid_594111 != nil:
    section.add "prettyPrint", valid_594111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594112: Call_VisionProjectsLocationsProductSetsProductsList_594095;
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
  let valid = call_594112.validator(path, query, header, formData, body)
  let scheme = call_594112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594112.url(scheme.get, call_594112.host, call_594112.base,
                         call_594112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594112, url, valid)

proc call*(call_594113: Call_VisionProjectsLocationsProductSetsProductsList_594095;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## visionProjectsLocationsProductSetsProductsList
  ## Lists the Products in a ProductSet, in an unspecified order. If the
  ## ProductSet does not exist, the products field of the response will be
  ## empty.
  ## 
  ## Possible errors:
  ## 
  ## * Returns INVALID_ARGUMENT if page_size is greater than 100 or less than 1.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The next_page_token returned from a previous List request, if any.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The ProductSet resource for which to retrieve Products.
  ## 
  ## Format is:
  ## `projects/PROJECT_ID/locations/LOC_ID/productSets/PRODUCT_SET_ID`
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return. Default 10, maximum 100.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594114 = newJObject()
  var query_594115 = newJObject()
  add(query_594115, "upload_protocol", newJString(uploadProtocol))
  add(query_594115, "fields", newJString(fields))
  add(query_594115, "pageToken", newJString(pageToken))
  add(query_594115, "quotaUser", newJString(quotaUser))
  add(path_594114, "name", newJString(name))
  add(query_594115, "alt", newJString(alt))
  add(query_594115, "oauth_token", newJString(oauthToken))
  add(query_594115, "callback", newJString(callback))
  add(query_594115, "access_token", newJString(accessToken))
  add(query_594115, "uploadType", newJString(uploadType))
  add(query_594115, "key", newJString(key))
  add(query_594115, "$.xgafv", newJString(Xgafv))
  add(query_594115, "pageSize", newJInt(pageSize))
  add(query_594115, "prettyPrint", newJBool(prettyPrint))
  result = call_594113.call(path_594114, query_594115, nil, nil, nil)

var visionProjectsLocationsProductSetsProductsList* = Call_VisionProjectsLocationsProductSetsProductsList_594095(
    name: "visionProjectsLocationsProductSetsProductsList",
    meth: HttpMethod.HttpGet, host: "vision.googleapis.com",
    route: "/v1/{name}/products",
    validator: validate_VisionProjectsLocationsProductSetsProductsList_594096,
    base: "/", url: url_VisionProjectsLocationsProductSetsProductsList_594097,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsAddProduct_594116 = ref object of OpenApiRestCall_593421
proc url_VisionProjectsLocationsProductSetsAddProduct_594118(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VisionProjectsLocationsProductSetsAddProduct_594117(path: JsonNode;
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
  var valid_594119 = path.getOrDefault("name")
  valid_594119 = validateParameter(valid_594119, JString, required = true,
                                 default = nil)
  if valid_594119 != nil:
    section.add "name", valid_594119
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594120 = query.getOrDefault("upload_protocol")
  valid_594120 = validateParameter(valid_594120, JString, required = false,
                                 default = nil)
  if valid_594120 != nil:
    section.add "upload_protocol", valid_594120
  var valid_594121 = query.getOrDefault("fields")
  valid_594121 = validateParameter(valid_594121, JString, required = false,
                                 default = nil)
  if valid_594121 != nil:
    section.add "fields", valid_594121
  var valid_594122 = query.getOrDefault("quotaUser")
  valid_594122 = validateParameter(valid_594122, JString, required = false,
                                 default = nil)
  if valid_594122 != nil:
    section.add "quotaUser", valid_594122
  var valid_594123 = query.getOrDefault("alt")
  valid_594123 = validateParameter(valid_594123, JString, required = false,
                                 default = newJString("json"))
  if valid_594123 != nil:
    section.add "alt", valid_594123
  var valid_594124 = query.getOrDefault("oauth_token")
  valid_594124 = validateParameter(valid_594124, JString, required = false,
                                 default = nil)
  if valid_594124 != nil:
    section.add "oauth_token", valid_594124
  var valid_594125 = query.getOrDefault("callback")
  valid_594125 = validateParameter(valid_594125, JString, required = false,
                                 default = nil)
  if valid_594125 != nil:
    section.add "callback", valid_594125
  var valid_594126 = query.getOrDefault("access_token")
  valid_594126 = validateParameter(valid_594126, JString, required = false,
                                 default = nil)
  if valid_594126 != nil:
    section.add "access_token", valid_594126
  var valid_594127 = query.getOrDefault("uploadType")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "uploadType", valid_594127
  var valid_594128 = query.getOrDefault("key")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = nil)
  if valid_594128 != nil:
    section.add "key", valid_594128
  var valid_594129 = query.getOrDefault("$.xgafv")
  valid_594129 = validateParameter(valid_594129, JString, required = false,
                                 default = newJString("1"))
  if valid_594129 != nil:
    section.add "$.xgafv", valid_594129
  var valid_594130 = query.getOrDefault("prettyPrint")
  valid_594130 = validateParameter(valid_594130, JBool, required = false,
                                 default = newJBool(true))
  if valid_594130 != nil:
    section.add "prettyPrint", valid_594130
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

proc call*(call_594132: Call_VisionProjectsLocationsProductSetsAddProduct_594116;
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
  let valid = call_594132.validator(path, query, header, formData, body)
  let scheme = call_594132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594132.url(scheme.get, call_594132.host, call_594132.base,
                         call_594132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594132, url, valid)

proc call*(call_594133: Call_VisionProjectsLocationsProductSetsAddProduct_594116;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## visionProjectsLocationsProductSetsAddProduct
  ## Adds a Product to the specified ProductSet. If the Product is already
  ## present, no change is made.
  ## 
  ## One Product can be added to at most 100 ProductSets.
  ## 
  ## Possible errors:
  ## 
  ## * Returns NOT_FOUND if the Product or the ProductSet doesn't exist.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name for the ProductSet to modify.
  ## 
  ## Format is:
  ## `projects/PROJECT_ID/locations/LOC_ID/productSets/PRODUCT_SET_ID`
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594134 = newJObject()
  var query_594135 = newJObject()
  var body_594136 = newJObject()
  add(query_594135, "upload_protocol", newJString(uploadProtocol))
  add(query_594135, "fields", newJString(fields))
  add(query_594135, "quotaUser", newJString(quotaUser))
  add(path_594134, "name", newJString(name))
  add(query_594135, "alt", newJString(alt))
  add(query_594135, "oauth_token", newJString(oauthToken))
  add(query_594135, "callback", newJString(callback))
  add(query_594135, "access_token", newJString(accessToken))
  add(query_594135, "uploadType", newJString(uploadType))
  add(query_594135, "key", newJString(key))
  add(query_594135, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594136 = body
  add(query_594135, "prettyPrint", newJBool(prettyPrint))
  result = call_594133.call(path_594134, query_594135, nil, nil, body_594136)

var visionProjectsLocationsProductSetsAddProduct* = Call_VisionProjectsLocationsProductSetsAddProduct_594116(
    name: "visionProjectsLocationsProductSetsAddProduct",
    meth: HttpMethod.HttpPost, host: "vision.googleapis.com",
    route: "/v1/{name}:addProduct",
    validator: validate_VisionProjectsLocationsProductSetsAddProduct_594117,
    base: "/", url: url_VisionProjectsLocationsProductSetsAddProduct_594118,
    schemes: {Scheme.Https})
type
  Call_VisionOperationsCancel_594137 = ref object of OpenApiRestCall_593421
proc url_VisionOperationsCancel_594139(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VisionOperationsCancel_594138(path: JsonNode; query: JsonNode;
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
  var valid_594140 = path.getOrDefault("name")
  valid_594140 = validateParameter(valid_594140, JString, required = true,
                                 default = nil)
  if valid_594140 != nil:
    section.add "name", valid_594140
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594141 = query.getOrDefault("upload_protocol")
  valid_594141 = validateParameter(valid_594141, JString, required = false,
                                 default = nil)
  if valid_594141 != nil:
    section.add "upload_protocol", valid_594141
  var valid_594142 = query.getOrDefault("fields")
  valid_594142 = validateParameter(valid_594142, JString, required = false,
                                 default = nil)
  if valid_594142 != nil:
    section.add "fields", valid_594142
  var valid_594143 = query.getOrDefault("quotaUser")
  valid_594143 = validateParameter(valid_594143, JString, required = false,
                                 default = nil)
  if valid_594143 != nil:
    section.add "quotaUser", valid_594143
  var valid_594144 = query.getOrDefault("alt")
  valid_594144 = validateParameter(valid_594144, JString, required = false,
                                 default = newJString("json"))
  if valid_594144 != nil:
    section.add "alt", valid_594144
  var valid_594145 = query.getOrDefault("oauth_token")
  valid_594145 = validateParameter(valid_594145, JString, required = false,
                                 default = nil)
  if valid_594145 != nil:
    section.add "oauth_token", valid_594145
  var valid_594146 = query.getOrDefault("callback")
  valid_594146 = validateParameter(valid_594146, JString, required = false,
                                 default = nil)
  if valid_594146 != nil:
    section.add "callback", valid_594146
  var valid_594147 = query.getOrDefault("access_token")
  valid_594147 = validateParameter(valid_594147, JString, required = false,
                                 default = nil)
  if valid_594147 != nil:
    section.add "access_token", valid_594147
  var valid_594148 = query.getOrDefault("uploadType")
  valid_594148 = validateParameter(valid_594148, JString, required = false,
                                 default = nil)
  if valid_594148 != nil:
    section.add "uploadType", valid_594148
  var valid_594149 = query.getOrDefault("key")
  valid_594149 = validateParameter(valid_594149, JString, required = false,
                                 default = nil)
  if valid_594149 != nil:
    section.add "key", valid_594149
  var valid_594150 = query.getOrDefault("$.xgafv")
  valid_594150 = validateParameter(valid_594150, JString, required = false,
                                 default = newJString("1"))
  if valid_594150 != nil:
    section.add "$.xgafv", valid_594150
  var valid_594151 = query.getOrDefault("prettyPrint")
  valid_594151 = validateParameter(valid_594151, JBool, required = false,
                                 default = newJBool(true))
  if valid_594151 != nil:
    section.add "prettyPrint", valid_594151
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

proc call*(call_594153: Call_VisionOperationsCancel_594137; path: JsonNode;
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
  let valid = call_594153.validator(path, query, header, formData, body)
  let scheme = call_594153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594153.url(scheme.get, call_594153.host, call_594153.base,
                         call_594153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594153, url, valid)

proc call*(call_594154: Call_VisionOperationsCancel_594137; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be cancelled.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594155 = newJObject()
  var query_594156 = newJObject()
  var body_594157 = newJObject()
  add(query_594156, "upload_protocol", newJString(uploadProtocol))
  add(query_594156, "fields", newJString(fields))
  add(query_594156, "quotaUser", newJString(quotaUser))
  add(path_594155, "name", newJString(name))
  add(query_594156, "alt", newJString(alt))
  add(query_594156, "oauth_token", newJString(oauthToken))
  add(query_594156, "callback", newJString(callback))
  add(query_594156, "access_token", newJString(accessToken))
  add(query_594156, "uploadType", newJString(uploadType))
  add(query_594156, "key", newJString(key))
  add(query_594156, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594157 = body
  add(query_594156, "prettyPrint", newJBool(prettyPrint))
  result = call_594154.call(path_594155, query_594156, nil, nil, body_594157)

var visionOperationsCancel* = Call_VisionOperationsCancel_594137(
    name: "visionOperationsCancel", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_VisionOperationsCancel_594138, base: "/",
    url: url_VisionOperationsCancel_594139, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsRemoveProduct_594158 = ref object of OpenApiRestCall_593421
proc url_VisionProjectsLocationsProductSetsRemoveProduct_594160(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VisionProjectsLocationsProductSetsRemoveProduct_594159(
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
  var valid_594161 = path.getOrDefault("name")
  valid_594161 = validateParameter(valid_594161, JString, required = true,
                                 default = nil)
  if valid_594161 != nil:
    section.add "name", valid_594161
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594162 = query.getOrDefault("upload_protocol")
  valid_594162 = validateParameter(valid_594162, JString, required = false,
                                 default = nil)
  if valid_594162 != nil:
    section.add "upload_protocol", valid_594162
  var valid_594163 = query.getOrDefault("fields")
  valid_594163 = validateParameter(valid_594163, JString, required = false,
                                 default = nil)
  if valid_594163 != nil:
    section.add "fields", valid_594163
  var valid_594164 = query.getOrDefault("quotaUser")
  valid_594164 = validateParameter(valid_594164, JString, required = false,
                                 default = nil)
  if valid_594164 != nil:
    section.add "quotaUser", valid_594164
  var valid_594165 = query.getOrDefault("alt")
  valid_594165 = validateParameter(valid_594165, JString, required = false,
                                 default = newJString("json"))
  if valid_594165 != nil:
    section.add "alt", valid_594165
  var valid_594166 = query.getOrDefault("oauth_token")
  valid_594166 = validateParameter(valid_594166, JString, required = false,
                                 default = nil)
  if valid_594166 != nil:
    section.add "oauth_token", valid_594166
  var valid_594167 = query.getOrDefault("callback")
  valid_594167 = validateParameter(valid_594167, JString, required = false,
                                 default = nil)
  if valid_594167 != nil:
    section.add "callback", valid_594167
  var valid_594168 = query.getOrDefault("access_token")
  valid_594168 = validateParameter(valid_594168, JString, required = false,
                                 default = nil)
  if valid_594168 != nil:
    section.add "access_token", valid_594168
  var valid_594169 = query.getOrDefault("uploadType")
  valid_594169 = validateParameter(valid_594169, JString, required = false,
                                 default = nil)
  if valid_594169 != nil:
    section.add "uploadType", valid_594169
  var valid_594170 = query.getOrDefault("key")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = nil)
  if valid_594170 != nil:
    section.add "key", valid_594170
  var valid_594171 = query.getOrDefault("$.xgafv")
  valid_594171 = validateParameter(valid_594171, JString, required = false,
                                 default = newJString("1"))
  if valid_594171 != nil:
    section.add "$.xgafv", valid_594171
  var valid_594172 = query.getOrDefault("prettyPrint")
  valid_594172 = validateParameter(valid_594172, JBool, required = false,
                                 default = newJBool(true))
  if valid_594172 != nil:
    section.add "prettyPrint", valid_594172
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

proc call*(call_594174: Call_VisionProjectsLocationsProductSetsRemoveProduct_594158;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a Product from the specified ProductSet.
  ## 
  let valid = call_594174.validator(path, query, header, formData, body)
  let scheme = call_594174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594174.url(scheme.get, call_594174.host, call_594174.base,
                         call_594174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594174, url, valid)

proc call*(call_594175: Call_VisionProjectsLocationsProductSetsRemoveProduct_594158;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## visionProjectsLocationsProductSetsRemoveProduct
  ## Removes a Product from the specified ProductSet.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name for the ProductSet to modify.
  ## 
  ## Format is:
  ## `projects/PROJECT_ID/locations/LOC_ID/productSets/PRODUCT_SET_ID`
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594176 = newJObject()
  var query_594177 = newJObject()
  var body_594178 = newJObject()
  add(query_594177, "upload_protocol", newJString(uploadProtocol))
  add(query_594177, "fields", newJString(fields))
  add(query_594177, "quotaUser", newJString(quotaUser))
  add(path_594176, "name", newJString(name))
  add(query_594177, "alt", newJString(alt))
  add(query_594177, "oauth_token", newJString(oauthToken))
  add(query_594177, "callback", newJString(callback))
  add(query_594177, "access_token", newJString(accessToken))
  add(query_594177, "uploadType", newJString(uploadType))
  add(query_594177, "key", newJString(key))
  add(query_594177, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594178 = body
  add(query_594177, "prettyPrint", newJBool(prettyPrint))
  result = call_594175.call(path_594176, query_594177, nil, nil, body_594178)

var visionProjectsLocationsProductSetsRemoveProduct* = Call_VisionProjectsLocationsProductSetsRemoveProduct_594158(
    name: "visionProjectsLocationsProductSetsRemoveProduct",
    meth: HttpMethod.HttpPost, host: "vision.googleapis.com",
    route: "/v1/{name}:removeProduct",
    validator: validate_VisionProjectsLocationsProductSetsRemoveProduct_594159,
    base: "/", url: url_VisionProjectsLocationsProductSetsRemoveProduct_594160,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsFilesAnnotate_594179 = ref object of OpenApiRestCall_593421
proc url_VisionProjectsLocationsFilesAnnotate_594181(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VisionProjectsLocationsFilesAnnotate_594180(path: JsonNode;
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
  var valid_594182 = path.getOrDefault("parent")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "parent", valid_594182
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594183 = query.getOrDefault("upload_protocol")
  valid_594183 = validateParameter(valid_594183, JString, required = false,
                                 default = nil)
  if valid_594183 != nil:
    section.add "upload_protocol", valid_594183
  var valid_594184 = query.getOrDefault("fields")
  valid_594184 = validateParameter(valid_594184, JString, required = false,
                                 default = nil)
  if valid_594184 != nil:
    section.add "fields", valid_594184
  var valid_594185 = query.getOrDefault("quotaUser")
  valid_594185 = validateParameter(valid_594185, JString, required = false,
                                 default = nil)
  if valid_594185 != nil:
    section.add "quotaUser", valid_594185
  var valid_594186 = query.getOrDefault("alt")
  valid_594186 = validateParameter(valid_594186, JString, required = false,
                                 default = newJString("json"))
  if valid_594186 != nil:
    section.add "alt", valid_594186
  var valid_594187 = query.getOrDefault("oauth_token")
  valid_594187 = validateParameter(valid_594187, JString, required = false,
                                 default = nil)
  if valid_594187 != nil:
    section.add "oauth_token", valid_594187
  var valid_594188 = query.getOrDefault("callback")
  valid_594188 = validateParameter(valid_594188, JString, required = false,
                                 default = nil)
  if valid_594188 != nil:
    section.add "callback", valid_594188
  var valid_594189 = query.getOrDefault("access_token")
  valid_594189 = validateParameter(valid_594189, JString, required = false,
                                 default = nil)
  if valid_594189 != nil:
    section.add "access_token", valid_594189
  var valid_594190 = query.getOrDefault("uploadType")
  valid_594190 = validateParameter(valid_594190, JString, required = false,
                                 default = nil)
  if valid_594190 != nil:
    section.add "uploadType", valid_594190
  var valid_594191 = query.getOrDefault("key")
  valid_594191 = validateParameter(valid_594191, JString, required = false,
                                 default = nil)
  if valid_594191 != nil:
    section.add "key", valid_594191
  var valid_594192 = query.getOrDefault("$.xgafv")
  valid_594192 = validateParameter(valid_594192, JString, required = false,
                                 default = newJString("1"))
  if valid_594192 != nil:
    section.add "$.xgafv", valid_594192
  var valid_594193 = query.getOrDefault("prettyPrint")
  valid_594193 = validateParameter(valid_594193, JBool, required = false,
                                 default = newJBool(true))
  if valid_594193 != nil:
    section.add "prettyPrint", valid_594193
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

proc call*(call_594195: Call_VisionProjectsLocationsFilesAnnotate_594179;
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
  let valid = call_594195.validator(path, query, header, formData, body)
  let scheme = call_594195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594195.url(scheme.get, call_594195.host, call_594195.base,
                         call_594195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594195, url, valid)

proc call*(call_594196: Call_VisionProjectsLocationsFilesAnnotate_594179;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## visionProjectsLocationsFilesAnnotate
  ## Service that performs image detection and annotation for a batch of files.
  ## Now only "application/pdf", "image/tiff" and "image/gif" are supported.
  ## 
  ## This service will extract at most 5 (customers can specify which 5 in
  ## AnnotateFileRequest.pages) frames (gif) or pages (pdf or tiff) from each
  ## file provided and perform detection and annotation for each image
  ## extracted.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594197 = newJObject()
  var query_594198 = newJObject()
  var body_594199 = newJObject()
  add(query_594198, "upload_protocol", newJString(uploadProtocol))
  add(query_594198, "fields", newJString(fields))
  add(query_594198, "quotaUser", newJString(quotaUser))
  add(query_594198, "alt", newJString(alt))
  add(query_594198, "oauth_token", newJString(oauthToken))
  add(query_594198, "callback", newJString(callback))
  add(query_594198, "access_token", newJString(accessToken))
  add(query_594198, "uploadType", newJString(uploadType))
  add(path_594197, "parent", newJString(parent))
  add(query_594198, "key", newJString(key))
  add(query_594198, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594199 = body
  add(query_594198, "prettyPrint", newJBool(prettyPrint))
  result = call_594196.call(path_594197, query_594198, nil, nil, body_594199)

var visionProjectsLocationsFilesAnnotate* = Call_VisionProjectsLocationsFilesAnnotate_594179(
    name: "visionProjectsLocationsFilesAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{parent}/files:annotate",
    validator: validate_VisionProjectsLocationsFilesAnnotate_594180, base: "/",
    url: url_VisionProjectsLocationsFilesAnnotate_594181, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsFilesAsyncBatchAnnotate_594200 = ref object of OpenApiRestCall_593421
proc url_VisionProjectsLocationsFilesAsyncBatchAnnotate_594202(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VisionProjectsLocationsFilesAsyncBatchAnnotate_594201(
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
  var valid_594203 = path.getOrDefault("parent")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = nil)
  if valid_594203 != nil:
    section.add "parent", valid_594203
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594204 = query.getOrDefault("upload_protocol")
  valid_594204 = validateParameter(valid_594204, JString, required = false,
                                 default = nil)
  if valid_594204 != nil:
    section.add "upload_protocol", valid_594204
  var valid_594205 = query.getOrDefault("fields")
  valid_594205 = validateParameter(valid_594205, JString, required = false,
                                 default = nil)
  if valid_594205 != nil:
    section.add "fields", valid_594205
  var valid_594206 = query.getOrDefault("quotaUser")
  valid_594206 = validateParameter(valid_594206, JString, required = false,
                                 default = nil)
  if valid_594206 != nil:
    section.add "quotaUser", valid_594206
  var valid_594207 = query.getOrDefault("alt")
  valid_594207 = validateParameter(valid_594207, JString, required = false,
                                 default = newJString("json"))
  if valid_594207 != nil:
    section.add "alt", valid_594207
  var valid_594208 = query.getOrDefault("oauth_token")
  valid_594208 = validateParameter(valid_594208, JString, required = false,
                                 default = nil)
  if valid_594208 != nil:
    section.add "oauth_token", valid_594208
  var valid_594209 = query.getOrDefault("callback")
  valid_594209 = validateParameter(valid_594209, JString, required = false,
                                 default = nil)
  if valid_594209 != nil:
    section.add "callback", valid_594209
  var valid_594210 = query.getOrDefault("access_token")
  valid_594210 = validateParameter(valid_594210, JString, required = false,
                                 default = nil)
  if valid_594210 != nil:
    section.add "access_token", valid_594210
  var valid_594211 = query.getOrDefault("uploadType")
  valid_594211 = validateParameter(valid_594211, JString, required = false,
                                 default = nil)
  if valid_594211 != nil:
    section.add "uploadType", valid_594211
  var valid_594212 = query.getOrDefault("key")
  valid_594212 = validateParameter(valid_594212, JString, required = false,
                                 default = nil)
  if valid_594212 != nil:
    section.add "key", valid_594212
  var valid_594213 = query.getOrDefault("$.xgafv")
  valid_594213 = validateParameter(valid_594213, JString, required = false,
                                 default = newJString("1"))
  if valid_594213 != nil:
    section.add "$.xgafv", valid_594213
  var valid_594214 = query.getOrDefault("prettyPrint")
  valid_594214 = validateParameter(valid_594214, JBool, required = false,
                                 default = newJBool(true))
  if valid_594214 != nil:
    section.add "prettyPrint", valid_594214
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

proc call*(call_594216: Call_VisionProjectsLocationsFilesAsyncBatchAnnotate_594200;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Run asynchronous image detection and annotation for a list of generic
  ## files, such as PDF files, which may contain multiple pages and multiple
  ## images per page. Progress and results can be retrieved through the
  ## `google.longrunning.Operations` interface.
  ## `Operation.metadata` contains `OperationMetadata` (metadata).
  ## `Operation.response` contains `AsyncBatchAnnotateFilesResponse` (results).
  ## 
  let valid = call_594216.validator(path, query, header, formData, body)
  let scheme = call_594216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594216.url(scheme.get, call_594216.host, call_594216.base,
                         call_594216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594216, url, valid)

proc call*(call_594217: Call_VisionProjectsLocationsFilesAsyncBatchAnnotate_594200;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## visionProjectsLocationsFilesAsyncBatchAnnotate
  ## Run asynchronous image detection and annotation for a list of generic
  ## files, such as PDF files, which may contain multiple pages and multiple
  ## images per page. Progress and results can be retrieved through the
  ## `google.longrunning.Operations` interface.
  ## `Operation.metadata` contains `OperationMetadata` (metadata).
  ## `Operation.response` contains `AsyncBatchAnnotateFilesResponse` (results).
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594218 = newJObject()
  var query_594219 = newJObject()
  var body_594220 = newJObject()
  add(query_594219, "upload_protocol", newJString(uploadProtocol))
  add(query_594219, "fields", newJString(fields))
  add(query_594219, "quotaUser", newJString(quotaUser))
  add(query_594219, "alt", newJString(alt))
  add(query_594219, "oauth_token", newJString(oauthToken))
  add(query_594219, "callback", newJString(callback))
  add(query_594219, "access_token", newJString(accessToken))
  add(query_594219, "uploadType", newJString(uploadType))
  add(path_594218, "parent", newJString(parent))
  add(query_594219, "key", newJString(key))
  add(query_594219, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594220 = body
  add(query_594219, "prettyPrint", newJBool(prettyPrint))
  result = call_594217.call(path_594218, query_594219, nil, nil, body_594220)

var visionProjectsLocationsFilesAsyncBatchAnnotate* = Call_VisionProjectsLocationsFilesAsyncBatchAnnotate_594200(
    name: "visionProjectsLocationsFilesAsyncBatchAnnotate",
    meth: HttpMethod.HttpPost, host: "vision.googleapis.com",
    route: "/v1/{parent}/files:asyncBatchAnnotate",
    validator: validate_VisionProjectsLocationsFilesAsyncBatchAnnotate_594201,
    base: "/", url: url_VisionProjectsLocationsFilesAsyncBatchAnnotate_594202,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsImagesAnnotate_594221 = ref object of OpenApiRestCall_593421
proc url_VisionProjectsLocationsImagesAnnotate_594223(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VisionProjectsLocationsImagesAnnotate_594222(path: JsonNode;
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
  var valid_594224 = path.getOrDefault("parent")
  valid_594224 = validateParameter(valid_594224, JString, required = true,
                                 default = nil)
  if valid_594224 != nil:
    section.add "parent", valid_594224
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594225 = query.getOrDefault("upload_protocol")
  valid_594225 = validateParameter(valid_594225, JString, required = false,
                                 default = nil)
  if valid_594225 != nil:
    section.add "upload_protocol", valid_594225
  var valid_594226 = query.getOrDefault("fields")
  valid_594226 = validateParameter(valid_594226, JString, required = false,
                                 default = nil)
  if valid_594226 != nil:
    section.add "fields", valid_594226
  var valid_594227 = query.getOrDefault("quotaUser")
  valid_594227 = validateParameter(valid_594227, JString, required = false,
                                 default = nil)
  if valid_594227 != nil:
    section.add "quotaUser", valid_594227
  var valid_594228 = query.getOrDefault("alt")
  valid_594228 = validateParameter(valid_594228, JString, required = false,
                                 default = newJString("json"))
  if valid_594228 != nil:
    section.add "alt", valid_594228
  var valid_594229 = query.getOrDefault("oauth_token")
  valid_594229 = validateParameter(valid_594229, JString, required = false,
                                 default = nil)
  if valid_594229 != nil:
    section.add "oauth_token", valid_594229
  var valid_594230 = query.getOrDefault("callback")
  valid_594230 = validateParameter(valid_594230, JString, required = false,
                                 default = nil)
  if valid_594230 != nil:
    section.add "callback", valid_594230
  var valid_594231 = query.getOrDefault("access_token")
  valid_594231 = validateParameter(valid_594231, JString, required = false,
                                 default = nil)
  if valid_594231 != nil:
    section.add "access_token", valid_594231
  var valid_594232 = query.getOrDefault("uploadType")
  valid_594232 = validateParameter(valid_594232, JString, required = false,
                                 default = nil)
  if valid_594232 != nil:
    section.add "uploadType", valid_594232
  var valid_594233 = query.getOrDefault("key")
  valid_594233 = validateParameter(valid_594233, JString, required = false,
                                 default = nil)
  if valid_594233 != nil:
    section.add "key", valid_594233
  var valid_594234 = query.getOrDefault("$.xgafv")
  valid_594234 = validateParameter(valid_594234, JString, required = false,
                                 default = newJString("1"))
  if valid_594234 != nil:
    section.add "$.xgafv", valid_594234
  var valid_594235 = query.getOrDefault("prettyPrint")
  valid_594235 = validateParameter(valid_594235, JBool, required = false,
                                 default = newJBool(true))
  if valid_594235 != nil:
    section.add "prettyPrint", valid_594235
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

proc call*(call_594237: Call_VisionProjectsLocationsImagesAnnotate_594221;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Run image detection and annotation for a batch of images.
  ## 
  let valid = call_594237.validator(path, query, header, formData, body)
  let scheme = call_594237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594237.url(scheme.get, call_594237.host, call_594237.base,
                         call_594237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594237, url, valid)

proc call*(call_594238: Call_VisionProjectsLocationsImagesAnnotate_594221;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## visionProjectsLocationsImagesAnnotate
  ## Run image detection and annotation for a batch of images.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594239 = newJObject()
  var query_594240 = newJObject()
  var body_594241 = newJObject()
  add(query_594240, "upload_protocol", newJString(uploadProtocol))
  add(query_594240, "fields", newJString(fields))
  add(query_594240, "quotaUser", newJString(quotaUser))
  add(query_594240, "alt", newJString(alt))
  add(query_594240, "oauth_token", newJString(oauthToken))
  add(query_594240, "callback", newJString(callback))
  add(query_594240, "access_token", newJString(accessToken))
  add(query_594240, "uploadType", newJString(uploadType))
  add(path_594239, "parent", newJString(parent))
  add(query_594240, "key", newJString(key))
  add(query_594240, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594241 = body
  add(query_594240, "prettyPrint", newJBool(prettyPrint))
  result = call_594238.call(path_594239, query_594240, nil, nil, body_594241)

var visionProjectsLocationsImagesAnnotate* = Call_VisionProjectsLocationsImagesAnnotate_594221(
    name: "visionProjectsLocationsImagesAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{parent}/images:annotate",
    validator: validate_VisionProjectsLocationsImagesAnnotate_594222, base: "/",
    url: url_VisionProjectsLocationsImagesAnnotate_594223, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsImagesAsyncBatchAnnotate_594242 = ref object of OpenApiRestCall_593421
proc url_VisionProjectsLocationsImagesAsyncBatchAnnotate_594244(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VisionProjectsLocationsImagesAsyncBatchAnnotate_594243(
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
  var valid_594245 = path.getOrDefault("parent")
  valid_594245 = validateParameter(valid_594245, JString, required = true,
                                 default = nil)
  if valid_594245 != nil:
    section.add "parent", valid_594245
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594246 = query.getOrDefault("upload_protocol")
  valid_594246 = validateParameter(valid_594246, JString, required = false,
                                 default = nil)
  if valid_594246 != nil:
    section.add "upload_protocol", valid_594246
  var valid_594247 = query.getOrDefault("fields")
  valid_594247 = validateParameter(valid_594247, JString, required = false,
                                 default = nil)
  if valid_594247 != nil:
    section.add "fields", valid_594247
  var valid_594248 = query.getOrDefault("quotaUser")
  valid_594248 = validateParameter(valid_594248, JString, required = false,
                                 default = nil)
  if valid_594248 != nil:
    section.add "quotaUser", valid_594248
  var valid_594249 = query.getOrDefault("alt")
  valid_594249 = validateParameter(valid_594249, JString, required = false,
                                 default = newJString("json"))
  if valid_594249 != nil:
    section.add "alt", valid_594249
  var valid_594250 = query.getOrDefault("oauth_token")
  valid_594250 = validateParameter(valid_594250, JString, required = false,
                                 default = nil)
  if valid_594250 != nil:
    section.add "oauth_token", valid_594250
  var valid_594251 = query.getOrDefault("callback")
  valid_594251 = validateParameter(valid_594251, JString, required = false,
                                 default = nil)
  if valid_594251 != nil:
    section.add "callback", valid_594251
  var valid_594252 = query.getOrDefault("access_token")
  valid_594252 = validateParameter(valid_594252, JString, required = false,
                                 default = nil)
  if valid_594252 != nil:
    section.add "access_token", valid_594252
  var valid_594253 = query.getOrDefault("uploadType")
  valid_594253 = validateParameter(valid_594253, JString, required = false,
                                 default = nil)
  if valid_594253 != nil:
    section.add "uploadType", valid_594253
  var valid_594254 = query.getOrDefault("key")
  valid_594254 = validateParameter(valid_594254, JString, required = false,
                                 default = nil)
  if valid_594254 != nil:
    section.add "key", valid_594254
  var valid_594255 = query.getOrDefault("$.xgafv")
  valid_594255 = validateParameter(valid_594255, JString, required = false,
                                 default = newJString("1"))
  if valid_594255 != nil:
    section.add "$.xgafv", valid_594255
  var valid_594256 = query.getOrDefault("prettyPrint")
  valid_594256 = validateParameter(valid_594256, JBool, required = false,
                                 default = newJBool(true))
  if valid_594256 != nil:
    section.add "prettyPrint", valid_594256
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

proc call*(call_594258: Call_VisionProjectsLocationsImagesAsyncBatchAnnotate_594242;
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
  let valid = call_594258.validator(path, query, header, formData, body)
  let scheme = call_594258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594258.url(scheme.get, call_594258.host, call_594258.base,
                         call_594258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594258, url, valid)

proc call*(call_594259: Call_VisionProjectsLocationsImagesAsyncBatchAnnotate_594242;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594260 = newJObject()
  var query_594261 = newJObject()
  var body_594262 = newJObject()
  add(query_594261, "upload_protocol", newJString(uploadProtocol))
  add(query_594261, "fields", newJString(fields))
  add(query_594261, "quotaUser", newJString(quotaUser))
  add(query_594261, "alt", newJString(alt))
  add(query_594261, "oauth_token", newJString(oauthToken))
  add(query_594261, "callback", newJString(callback))
  add(query_594261, "access_token", newJString(accessToken))
  add(query_594261, "uploadType", newJString(uploadType))
  add(path_594260, "parent", newJString(parent))
  add(query_594261, "key", newJString(key))
  add(query_594261, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594262 = body
  add(query_594261, "prettyPrint", newJBool(prettyPrint))
  result = call_594259.call(path_594260, query_594261, nil, nil, body_594262)

var visionProjectsLocationsImagesAsyncBatchAnnotate* = Call_VisionProjectsLocationsImagesAsyncBatchAnnotate_594242(
    name: "visionProjectsLocationsImagesAsyncBatchAnnotate",
    meth: HttpMethod.HttpPost, host: "vision.googleapis.com",
    route: "/v1/{parent}/images:asyncBatchAnnotate",
    validator: validate_VisionProjectsLocationsImagesAsyncBatchAnnotate_594243,
    base: "/", url: url_VisionProjectsLocationsImagesAsyncBatchAnnotate_594244,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsCreate_594284 = ref object of OpenApiRestCall_593421
proc url_VisionProjectsLocationsProductSetsCreate_594286(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VisionProjectsLocationsProductSetsCreate_594285(path: JsonNode;
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
  var valid_594287 = path.getOrDefault("parent")
  valid_594287 = validateParameter(valid_594287, JString, required = true,
                                 default = nil)
  if valid_594287 != nil:
    section.add "parent", valid_594287
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   productSetId: JString
  ##               : A user-supplied resource id for this ProductSet. If set, the server will
  ## attempt to use this value as the resource id. If it is already in use, an
  ## error is returned with code ALREADY_EXISTS. Must be at most 128 characters
  ## long. It cannot contain the character `/`.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594288 = query.getOrDefault("upload_protocol")
  valid_594288 = validateParameter(valid_594288, JString, required = false,
                                 default = nil)
  if valid_594288 != nil:
    section.add "upload_protocol", valid_594288
  var valid_594289 = query.getOrDefault("fields")
  valid_594289 = validateParameter(valid_594289, JString, required = false,
                                 default = nil)
  if valid_594289 != nil:
    section.add "fields", valid_594289
  var valid_594290 = query.getOrDefault("quotaUser")
  valid_594290 = validateParameter(valid_594290, JString, required = false,
                                 default = nil)
  if valid_594290 != nil:
    section.add "quotaUser", valid_594290
  var valid_594291 = query.getOrDefault("alt")
  valid_594291 = validateParameter(valid_594291, JString, required = false,
                                 default = newJString("json"))
  if valid_594291 != nil:
    section.add "alt", valid_594291
  var valid_594292 = query.getOrDefault("oauth_token")
  valid_594292 = validateParameter(valid_594292, JString, required = false,
                                 default = nil)
  if valid_594292 != nil:
    section.add "oauth_token", valid_594292
  var valid_594293 = query.getOrDefault("callback")
  valid_594293 = validateParameter(valid_594293, JString, required = false,
                                 default = nil)
  if valid_594293 != nil:
    section.add "callback", valid_594293
  var valid_594294 = query.getOrDefault("access_token")
  valid_594294 = validateParameter(valid_594294, JString, required = false,
                                 default = nil)
  if valid_594294 != nil:
    section.add "access_token", valid_594294
  var valid_594295 = query.getOrDefault("uploadType")
  valid_594295 = validateParameter(valid_594295, JString, required = false,
                                 default = nil)
  if valid_594295 != nil:
    section.add "uploadType", valid_594295
  var valid_594296 = query.getOrDefault("key")
  valid_594296 = validateParameter(valid_594296, JString, required = false,
                                 default = nil)
  if valid_594296 != nil:
    section.add "key", valid_594296
  var valid_594297 = query.getOrDefault("$.xgafv")
  valid_594297 = validateParameter(valid_594297, JString, required = false,
                                 default = newJString("1"))
  if valid_594297 != nil:
    section.add "$.xgafv", valid_594297
  var valid_594298 = query.getOrDefault("productSetId")
  valid_594298 = validateParameter(valid_594298, JString, required = false,
                                 default = nil)
  if valid_594298 != nil:
    section.add "productSetId", valid_594298
  var valid_594299 = query.getOrDefault("prettyPrint")
  valid_594299 = validateParameter(valid_594299, JBool, required = false,
                                 default = newJBool(true))
  if valid_594299 != nil:
    section.add "prettyPrint", valid_594299
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

proc call*(call_594301: Call_VisionProjectsLocationsProductSetsCreate_594284;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates and returns a new ProductSet resource.
  ## 
  ## Possible errors:
  ## 
  ## * Returns INVALID_ARGUMENT if display_name is missing, or is longer than
  ##   4096 characters.
  ## 
  let valid = call_594301.validator(path, query, header, formData, body)
  let scheme = call_594301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594301.url(scheme.get, call_594301.host, call_594301.base,
                         call_594301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594301, url, valid)

proc call*(call_594302: Call_VisionProjectsLocationsProductSetsCreate_594284;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; productSetId: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## visionProjectsLocationsProductSetsCreate
  ## Creates and returns a new ProductSet resource.
  ## 
  ## Possible errors:
  ## 
  ## * Returns INVALID_ARGUMENT if display_name is missing, or is longer than
  ##   4096 characters.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The project in which the ProductSet should be created.
  ## 
  ## Format is `projects/PROJECT_ID/locations/LOC_ID`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   productSetId: string
  ##               : A user-supplied resource id for this ProductSet. If set, the server will
  ## attempt to use this value as the resource id. If it is already in use, an
  ## error is returned with code ALREADY_EXISTS. Must be at most 128 characters
  ## long. It cannot contain the character `/`.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594303 = newJObject()
  var query_594304 = newJObject()
  var body_594305 = newJObject()
  add(query_594304, "upload_protocol", newJString(uploadProtocol))
  add(query_594304, "fields", newJString(fields))
  add(query_594304, "quotaUser", newJString(quotaUser))
  add(query_594304, "alt", newJString(alt))
  add(query_594304, "oauth_token", newJString(oauthToken))
  add(query_594304, "callback", newJString(callback))
  add(query_594304, "access_token", newJString(accessToken))
  add(query_594304, "uploadType", newJString(uploadType))
  add(path_594303, "parent", newJString(parent))
  add(query_594304, "key", newJString(key))
  add(query_594304, "$.xgafv", newJString(Xgafv))
  add(query_594304, "productSetId", newJString(productSetId))
  if body != nil:
    body_594305 = body
  add(query_594304, "prettyPrint", newJBool(prettyPrint))
  result = call_594302.call(path_594303, query_594304, nil, nil, body_594305)

var visionProjectsLocationsProductSetsCreate* = Call_VisionProjectsLocationsProductSetsCreate_594284(
    name: "visionProjectsLocationsProductSetsCreate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{parent}/productSets",
    validator: validate_VisionProjectsLocationsProductSetsCreate_594285,
    base: "/", url: url_VisionProjectsLocationsProductSetsCreate_594286,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsList_594263 = ref object of OpenApiRestCall_593421
proc url_VisionProjectsLocationsProductSetsList_594265(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VisionProjectsLocationsProductSetsList_594264(path: JsonNode;
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
  var valid_594266 = path.getOrDefault("parent")
  valid_594266 = validateParameter(valid_594266, JString, required = true,
                                 default = nil)
  if valid_594266 != nil:
    section.add "parent", valid_594266
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The next_page_token returned from a previous List request, if any.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of items to return. Default 10, maximum 100.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594267 = query.getOrDefault("upload_protocol")
  valid_594267 = validateParameter(valid_594267, JString, required = false,
                                 default = nil)
  if valid_594267 != nil:
    section.add "upload_protocol", valid_594267
  var valid_594268 = query.getOrDefault("fields")
  valid_594268 = validateParameter(valid_594268, JString, required = false,
                                 default = nil)
  if valid_594268 != nil:
    section.add "fields", valid_594268
  var valid_594269 = query.getOrDefault("pageToken")
  valid_594269 = validateParameter(valid_594269, JString, required = false,
                                 default = nil)
  if valid_594269 != nil:
    section.add "pageToken", valid_594269
  var valid_594270 = query.getOrDefault("quotaUser")
  valid_594270 = validateParameter(valid_594270, JString, required = false,
                                 default = nil)
  if valid_594270 != nil:
    section.add "quotaUser", valid_594270
  var valid_594271 = query.getOrDefault("alt")
  valid_594271 = validateParameter(valid_594271, JString, required = false,
                                 default = newJString("json"))
  if valid_594271 != nil:
    section.add "alt", valid_594271
  var valid_594272 = query.getOrDefault("oauth_token")
  valid_594272 = validateParameter(valid_594272, JString, required = false,
                                 default = nil)
  if valid_594272 != nil:
    section.add "oauth_token", valid_594272
  var valid_594273 = query.getOrDefault("callback")
  valid_594273 = validateParameter(valid_594273, JString, required = false,
                                 default = nil)
  if valid_594273 != nil:
    section.add "callback", valid_594273
  var valid_594274 = query.getOrDefault("access_token")
  valid_594274 = validateParameter(valid_594274, JString, required = false,
                                 default = nil)
  if valid_594274 != nil:
    section.add "access_token", valid_594274
  var valid_594275 = query.getOrDefault("uploadType")
  valid_594275 = validateParameter(valid_594275, JString, required = false,
                                 default = nil)
  if valid_594275 != nil:
    section.add "uploadType", valid_594275
  var valid_594276 = query.getOrDefault("key")
  valid_594276 = validateParameter(valid_594276, JString, required = false,
                                 default = nil)
  if valid_594276 != nil:
    section.add "key", valid_594276
  var valid_594277 = query.getOrDefault("$.xgafv")
  valid_594277 = validateParameter(valid_594277, JString, required = false,
                                 default = newJString("1"))
  if valid_594277 != nil:
    section.add "$.xgafv", valid_594277
  var valid_594278 = query.getOrDefault("pageSize")
  valid_594278 = validateParameter(valid_594278, JInt, required = false, default = nil)
  if valid_594278 != nil:
    section.add "pageSize", valid_594278
  var valid_594279 = query.getOrDefault("prettyPrint")
  valid_594279 = validateParameter(valid_594279, JBool, required = false,
                                 default = newJBool(true))
  if valid_594279 != nil:
    section.add "prettyPrint", valid_594279
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594280: Call_VisionProjectsLocationsProductSetsList_594263;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists ProductSets in an unspecified order.
  ## 
  ## Possible errors:
  ## 
  ## * Returns INVALID_ARGUMENT if page_size is greater than 100, or less
  ##   than 1.
  ## 
  let valid = call_594280.validator(path, query, header, formData, body)
  let scheme = call_594280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594280.url(scheme.get, call_594280.host, call_594280.base,
                         call_594280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594280, url, valid)

proc call*(call_594281: Call_VisionProjectsLocationsProductSetsList_594263;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## visionProjectsLocationsProductSetsList
  ## Lists ProductSets in an unspecified order.
  ## 
  ## Possible errors:
  ## 
  ## * Returns INVALID_ARGUMENT if page_size is greater than 100, or less
  ##   than 1.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The next_page_token returned from a previous List request, if any.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The project from which ProductSets should be listed.
  ## 
  ## Format is `projects/PROJECT_ID/locations/LOC_ID`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return. Default 10, maximum 100.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594282 = newJObject()
  var query_594283 = newJObject()
  add(query_594283, "upload_protocol", newJString(uploadProtocol))
  add(query_594283, "fields", newJString(fields))
  add(query_594283, "pageToken", newJString(pageToken))
  add(query_594283, "quotaUser", newJString(quotaUser))
  add(query_594283, "alt", newJString(alt))
  add(query_594283, "oauth_token", newJString(oauthToken))
  add(query_594283, "callback", newJString(callback))
  add(query_594283, "access_token", newJString(accessToken))
  add(query_594283, "uploadType", newJString(uploadType))
  add(path_594282, "parent", newJString(parent))
  add(query_594283, "key", newJString(key))
  add(query_594283, "$.xgafv", newJString(Xgafv))
  add(query_594283, "pageSize", newJInt(pageSize))
  add(query_594283, "prettyPrint", newJBool(prettyPrint))
  result = call_594281.call(path_594282, query_594283, nil, nil, nil)

var visionProjectsLocationsProductSetsList* = Call_VisionProjectsLocationsProductSetsList_594263(
    name: "visionProjectsLocationsProductSetsList", meth: HttpMethod.HttpGet,
    host: "vision.googleapis.com", route: "/v1/{parent}/productSets",
    validator: validate_VisionProjectsLocationsProductSetsList_594264, base: "/",
    url: url_VisionProjectsLocationsProductSetsList_594265,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsImport_594306 = ref object of OpenApiRestCall_593421
proc url_VisionProjectsLocationsProductSetsImport_594308(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VisionProjectsLocationsProductSetsImport_594307(path: JsonNode;
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
  var valid_594309 = path.getOrDefault("parent")
  valid_594309 = validateParameter(valid_594309, JString, required = true,
                                 default = nil)
  if valid_594309 != nil:
    section.add "parent", valid_594309
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594310 = query.getOrDefault("upload_protocol")
  valid_594310 = validateParameter(valid_594310, JString, required = false,
                                 default = nil)
  if valid_594310 != nil:
    section.add "upload_protocol", valid_594310
  var valid_594311 = query.getOrDefault("fields")
  valid_594311 = validateParameter(valid_594311, JString, required = false,
                                 default = nil)
  if valid_594311 != nil:
    section.add "fields", valid_594311
  var valid_594312 = query.getOrDefault("quotaUser")
  valid_594312 = validateParameter(valid_594312, JString, required = false,
                                 default = nil)
  if valid_594312 != nil:
    section.add "quotaUser", valid_594312
  var valid_594313 = query.getOrDefault("alt")
  valid_594313 = validateParameter(valid_594313, JString, required = false,
                                 default = newJString("json"))
  if valid_594313 != nil:
    section.add "alt", valid_594313
  var valid_594314 = query.getOrDefault("oauth_token")
  valid_594314 = validateParameter(valid_594314, JString, required = false,
                                 default = nil)
  if valid_594314 != nil:
    section.add "oauth_token", valid_594314
  var valid_594315 = query.getOrDefault("callback")
  valid_594315 = validateParameter(valid_594315, JString, required = false,
                                 default = nil)
  if valid_594315 != nil:
    section.add "callback", valid_594315
  var valid_594316 = query.getOrDefault("access_token")
  valid_594316 = validateParameter(valid_594316, JString, required = false,
                                 default = nil)
  if valid_594316 != nil:
    section.add "access_token", valid_594316
  var valid_594317 = query.getOrDefault("uploadType")
  valid_594317 = validateParameter(valid_594317, JString, required = false,
                                 default = nil)
  if valid_594317 != nil:
    section.add "uploadType", valid_594317
  var valid_594318 = query.getOrDefault("key")
  valid_594318 = validateParameter(valid_594318, JString, required = false,
                                 default = nil)
  if valid_594318 != nil:
    section.add "key", valid_594318
  var valid_594319 = query.getOrDefault("$.xgafv")
  valid_594319 = validateParameter(valid_594319, JString, required = false,
                                 default = newJString("1"))
  if valid_594319 != nil:
    section.add "$.xgafv", valid_594319
  var valid_594320 = query.getOrDefault("prettyPrint")
  valid_594320 = validateParameter(valid_594320, JBool, required = false,
                                 default = newJBool(true))
  if valid_594320 != nil:
    section.add "prettyPrint", valid_594320
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

proc call*(call_594322: Call_VisionProjectsLocationsProductSetsImport_594306;
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
  let valid = call_594322.validator(path, query, header, formData, body)
  let scheme = call_594322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594322.url(scheme.get, call_594322.host, call_594322.base,
                         call_594322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594322, url, valid)

proc call*(call_594323: Call_VisionProjectsLocationsProductSetsImport_594306;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The project in which the ProductSets should be imported.
  ## 
  ## Format is `projects/PROJECT_ID/locations/LOC_ID`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594324 = newJObject()
  var query_594325 = newJObject()
  var body_594326 = newJObject()
  add(query_594325, "upload_protocol", newJString(uploadProtocol))
  add(query_594325, "fields", newJString(fields))
  add(query_594325, "quotaUser", newJString(quotaUser))
  add(query_594325, "alt", newJString(alt))
  add(query_594325, "oauth_token", newJString(oauthToken))
  add(query_594325, "callback", newJString(callback))
  add(query_594325, "access_token", newJString(accessToken))
  add(query_594325, "uploadType", newJString(uploadType))
  add(path_594324, "parent", newJString(parent))
  add(query_594325, "key", newJString(key))
  add(query_594325, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594326 = body
  add(query_594325, "prettyPrint", newJBool(prettyPrint))
  result = call_594323.call(path_594324, query_594325, nil, nil, body_594326)

var visionProjectsLocationsProductSetsImport* = Call_VisionProjectsLocationsProductSetsImport_594306(
    name: "visionProjectsLocationsProductSetsImport", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{parent}/productSets:import",
    validator: validate_VisionProjectsLocationsProductSetsImport_594307,
    base: "/", url: url_VisionProjectsLocationsProductSetsImport_594308,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductsCreate_594348 = ref object of OpenApiRestCall_593421
proc url_VisionProjectsLocationsProductsCreate_594350(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VisionProjectsLocationsProductsCreate_594349(path: JsonNode;
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
  var valid_594351 = path.getOrDefault("parent")
  valid_594351 = validateParameter(valid_594351, JString, required = true,
                                 default = nil)
  if valid_594351 != nil:
    section.add "parent", valid_594351
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   productId: JString
  ##            : A user-supplied resource id for this Product. If set, the server will
  ## attempt to use this value as the resource id. If it is already in use, an
  ## error is returned with code ALREADY_EXISTS. Must be at most 128 characters
  ## long. It cannot contain the character `/`.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594352 = query.getOrDefault("upload_protocol")
  valid_594352 = validateParameter(valid_594352, JString, required = false,
                                 default = nil)
  if valid_594352 != nil:
    section.add "upload_protocol", valid_594352
  var valid_594353 = query.getOrDefault("fields")
  valid_594353 = validateParameter(valid_594353, JString, required = false,
                                 default = nil)
  if valid_594353 != nil:
    section.add "fields", valid_594353
  var valid_594354 = query.getOrDefault("quotaUser")
  valid_594354 = validateParameter(valid_594354, JString, required = false,
                                 default = nil)
  if valid_594354 != nil:
    section.add "quotaUser", valid_594354
  var valid_594355 = query.getOrDefault("alt")
  valid_594355 = validateParameter(valid_594355, JString, required = false,
                                 default = newJString("json"))
  if valid_594355 != nil:
    section.add "alt", valid_594355
  var valid_594356 = query.getOrDefault("oauth_token")
  valid_594356 = validateParameter(valid_594356, JString, required = false,
                                 default = nil)
  if valid_594356 != nil:
    section.add "oauth_token", valid_594356
  var valid_594357 = query.getOrDefault("callback")
  valid_594357 = validateParameter(valid_594357, JString, required = false,
                                 default = nil)
  if valid_594357 != nil:
    section.add "callback", valid_594357
  var valid_594358 = query.getOrDefault("access_token")
  valid_594358 = validateParameter(valid_594358, JString, required = false,
                                 default = nil)
  if valid_594358 != nil:
    section.add "access_token", valid_594358
  var valid_594359 = query.getOrDefault("uploadType")
  valid_594359 = validateParameter(valid_594359, JString, required = false,
                                 default = nil)
  if valid_594359 != nil:
    section.add "uploadType", valid_594359
  var valid_594360 = query.getOrDefault("productId")
  valid_594360 = validateParameter(valid_594360, JString, required = false,
                                 default = nil)
  if valid_594360 != nil:
    section.add "productId", valid_594360
  var valid_594361 = query.getOrDefault("key")
  valid_594361 = validateParameter(valid_594361, JString, required = false,
                                 default = nil)
  if valid_594361 != nil:
    section.add "key", valid_594361
  var valid_594362 = query.getOrDefault("$.xgafv")
  valid_594362 = validateParameter(valid_594362, JString, required = false,
                                 default = newJString("1"))
  if valid_594362 != nil:
    section.add "$.xgafv", valid_594362
  var valid_594363 = query.getOrDefault("prettyPrint")
  valid_594363 = validateParameter(valid_594363, JBool, required = false,
                                 default = newJBool(true))
  if valid_594363 != nil:
    section.add "prettyPrint", valid_594363
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

proc call*(call_594365: Call_VisionProjectsLocationsProductsCreate_594348;
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
  let valid = call_594365.validator(path, query, header, formData, body)
  let scheme = call_594365.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594365.url(scheme.get, call_594365.host, call_594365.base,
                         call_594365.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594365, url, valid)

proc call*(call_594366: Call_VisionProjectsLocationsProductsCreate_594348;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          productId: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## visionProjectsLocationsProductsCreate
  ## Creates and returns a new product resource.
  ## 
  ## Possible errors:
  ## 
  ## * Returns INVALID_ARGUMENT if display_name is missing or longer than 4096
  ##   characters.
  ## * Returns INVALID_ARGUMENT if description is longer than 4096 characters.
  ## * Returns INVALID_ARGUMENT if product_category is missing or invalid.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594367 = newJObject()
  var query_594368 = newJObject()
  var body_594369 = newJObject()
  add(query_594368, "upload_protocol", newJString(uploadProtocol))
  add(query_594368, "fields", newJString(fields))
  add(query_594368, "quotaUser", newJString(quotaUser))
  add(query_594368, "alt", newJString(alt))
  add(query_594368, "oauth_token", newJString(oauthToken))
  add(query_594368, "callback", newJString(callback))
  add(query_594368, "access_token", newJString(accessToken))
  add(query_594368, "uploadType", newJString(uploadType))
  add(path_594367, "parent", newJString(parent))
  add(query_594368, "productId", newJString(productId))
  add(query_594368, "key", newJString(key))
  add(query_594368, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594369 = body
  add(query_594368, "prettyPrint", newJBool(prettyPrint))
  result = call_594366.call(path_594367, query_594368, nil, nil, body_594369)

var visionProjectsLocationsProductsCreate* = Call_VisionProjectsLocationsProductsCreate_594348(
    name: "visionProjectsLocationsProductsCreate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{parent}/products",
    validator: validate_VisionProjectsLocationsProductsCreate_594349, base: "/",
    url: url_VisionProjectsLocationsProductsCreate_594350, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductsList_594327 = ref object of OpenApiRestCall_593421
proc url_VisionProjectsLocationsProductsList_594329(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VisionProjectsLocationsProductsList_594328(path: JsonNode;
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
  var valid_594330 = path.getOrDefault("parent")
  valid_594330 = validateParameter(valid_594330, JString, required = true,
                                 default = nil)
  if valid_594330 != nil:
    section.add "parent", valid_594330
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The next_page_token returned from a previous List request, if any.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of items to return. Default 10, maximum 100.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594331 = query.getOrDefault("upload_protocol")
  valid_594331 = validateParameter(valid_594331, JString, required = false,
                                 default = nil)
  if valid_594331 != nil:
    section.add "upload_protocol", valid_594331
  var valid_594332 = query.getOrDefault("fields")
  valid_594332 = validateParameter(valid_594332, JString, required = false,
                                 default = nil)
  if valid_594332 != nil:
    section.add "fields", valid_594332
  var valid_594333 = query.getOrDefault("pageToken")
  valid_594333 = validateParameter(valid_594333, JString, required = false,
                                 default = nil)
  if valid_594333 != nil:
    section.add "pageToken", valid_594333
  var valid_594334 = query.getOrDefault("quotaUser")
  valid_594334 = validateParameter(valid_594334, JString, required = false,
                                 default = nil)
  if valid_594334 != nil:
    section.add "quotaUser", valid_594334
  var valid_594335 = query.getOrDefault("alt")
  valid_594335 = validateParameter(valid_594335, JString, required = false,
                                 default = newJString("json"))
  if valid_594335 != nil:
    section.add "alt", valid_594335
  var valid_594336 = query.getOrDefault("oauth_token")
  valid_594336 = validateParameter(valid_594336, JString, required = false,
                                 default = nil)
  if valid_594336 != nil:
    section.add "oauth_token", valid_594336
  var valid_594337 = query.getOrDefault("callback")
  valid_594337 = validateParameter(valid_594337, JString, required = false,
                                 default = nil)
  if valid_594337 != nil:
    section.add "callback", valid_594337
  var valid_594338 = query.getOrDefault("access_token")
  valid_594338 = validateParameter(valid_594338, JString, required = false,
                                 default = nil)
  if valid_594338 != nil:
    section.add "access_token", valid_594338
  var valid_594339 = query.getOrDefault("uploadType")
  valid_594339 = validateParameter(valid_594339, JString, required = false,
                                 default = nil)
  if valid_594339 != nil:
    section.add "uploadType", valid_594339
  var valid_594340 = query.getOrDefault("key")
  valid_594340 = validateParameter(valid_594340, JString, required = false,
                                 default = nil)
  if valid_594340 != nil:
    section.add "key", valid_594340
  var valid_594341 = query.getOrDefault("$.xgafv")
  valid_594341 = validateParameter(valid_594341, JString, required = false,
                                 default = newJString("1"))
  if valid_594341 != nil:
    section.add "$.xgafv", valid_594341
  var valid_594342 = query.getOrDefault("pageSize")
  valid_594342 = validateParameter(valid_594342, JInt, required = false, default = nil)
  if valid_594342 != nil:
    section.add "pageSize", valid_594342
  var valid_594343 = query.getOrDefault("prettyPrint")
  valid_594343 = validateParameter(valid_594343, JBool, required = false,
                                 default = newJBool(true))
  if valid_594343 != nil:
    section.add "prettyPrint", valid_594343
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594344: Call_VisionProjectsLocationsProductsList_594327;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists products in an unspecified order.
  ## 
  ## Possible errors:
  ## 
  ## * Returns INVALID_ARGUMENT if page_size is greater than 100 or less than 1.
  ## 
  let valid = call_594344.validator(path, query, header, formData, body)
  let scheme = call_594344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594344.url(scheme.get, call_594344.host, call_594344.base,
                         call_594344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594344, url, valid)

proc call*(call_594345: Call_VisionProjectsLocationsProductsList_594327;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## visionProjectsLocationsProductsList
  ## Lists products in an unspecified order.
  ## 
  ## Possible errors:
  ## 
  ## * Returns INVALID_ARGUMENT if page_size is greater than 100 or less than 1.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The next_page_token returned from a previous List request, if any.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The project OR ProductSet from which Products should be listed.
  ## 
  ## Format:
  ## `projects/PROJECT_ID/locations/LOC_ID`
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return. Default 10, maximum 100.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594346 = newJObject()
  var query_594347 = newJObject()
  add(query_594347, "upload_protocol", newJString(uploadProtocol))
  add(query_594347, "fields", newJString(fields))
  add(query_594347, "pageToken", newJString(pageToken))
  add(query_594347, "quotaUser", newJString(quotaUser))
  add(query_594347, "alt", newJString(alt))
  add(query_594347, "oauth_token", newJString(oauthToken))
  add(query_594347, "callback", newJString(callback))
  add(query_594347, "access_token", newJString(accessToken))
  add(query_594347, "uploadType", newJString(uploadType))
  add(path_594346, "parent", newJString(parent))
  add(query_594347, "key", newJString(key))
  add(query_594347, "$.xgafv", newJString(Xgafv))
  add(query_594347, "pageSize", newJInt(pageSize))
  add(query_594347, "prettyPrint", newJBool(prettyPrint))
  result = call_594345.call(path_594346, query_594347, nil, nil, nil)

var visionProjectsLocationsProductsList* = Call_VisionProjectsLocationsProductsList_594327(
    name: "visionProjectsLocationsProductsList", meth: HttpMethod.HttpGet,
    host: "vision.googleapis.com", route: "/v1/{parent}/products",
    validator: validate_VisionProjectsLocationsProductsList_594328, base: "/",
    url: url_VisionProjectsLocationsProductsList_594329, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductsPurge_594370 = ref object of OpenApiRestCall_593421
proc url_VisionProjectsLocationsProductsPurge_594372(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VisionProjectsLocationsProductsPurge_594371(path: JsonNode;
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
  var valid_594373 = path.getOrDefault("parent")
  valid_594373 = validateParameter(valid_594373, JString, required = true,
                                 default = nil)
  if valid_594373 != nil:
    section.add "parent", valid_594373
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594374 = query.getOrDefault("upload_protocol")
  valid_594374 = validateParameter(valid_594374, JString, required = false,
                                 default = nil)
  if valid_594374 != nil:
    section.add "upload_protocol", valid_594374
  var valid_594375 = query.getOrDefault("fields")
  valid_594375 = validateParameter(valid_594375, JString, required = false,
                                 default = nil)
  if valid_594375 != nil:
    section.add "fields", valid_594375
  var valid_594376 = query.getOrDefault("quotaUser")
  valid_594376 = validateParameter(valid_594376, JString, required = false,
                                 default = nil)
  if valid_594376 != nil:
    section.add "quotaUser", valid_594376
  var valid_594377 = query.getOrDefault("alt")
  valid_594377 = validateParameter(valid_594377, JString, required = false,
                                 default = newJString("json"))
  if valid_594377 != nil:
    section.add "alt", valid_594377
  var valid_594378 = query.getOrDefault("oauth_token")
  valid_594378 = validateParameter(valid_594378, JString, required = false,
                                 default = nil)
  if valid_594378 != nil:
    section.add "oauth_token", valid_594378
  var valid_594379 = query.getOrDefault("callback")
  valid_594379 = validateParameter(valid_594379, JString, required = false,
                                 default = nil)
  if valid_594379 != nil:
    section.add "callback", valid_594379
  var valid_594380 = query.getOrDefault("access_token")
  valid_594380 = validateParameter(valid_594380, JString, required = false,
                                 default = nil)
  if valid_594380 != nil:
    section.add "access_token", valid_594380
  var valid_594381 = query.getOrDefault("uploadType")
  valid_594381 = validateParameter(valid_594381, JString, required = false,
                                 default = nil)
  if valid_594381 != nil:
    section.add "uploadType", valid_594381
  var valid_594382 = query.getOrDefault("key")
  valid_594382 = validateParameter(valid_594382, JString, required = false,
                                 default = nil)
  if valid_594382 != nil:
    section.add "key", valid_594382
  var valid_594383 = query.getOrDefault("$.xgafv")
  valid_594383 = validateParameter(valid_594383, JString, required = false,
                                 default = newJString("1"))
  if valid_594383 != nil:
    section.add "$.xgafv", valid_594383
  var valid_594384 = query.getOrDefault("prettyPrint")
  valid_594384 = validateParameter(valid_594384, JBool, required = false,
                                 default = newJBool(true))
  if valid_594384 != nil:
    section.add "prettyPrint", valid_594384
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

proc call*(call_594386: Call_VisionProjectsLocationsProductsPurge_594370;
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
  let valid = call_594386.validator(path, query, header, formData, body)
  let scheme = call_594386.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594386.url(scheme.get, call_594386.host, call_594386.base,
                         call_594386.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594386, url, valid)

proc call*(call_594387: Call_VisionProjectsLocationsProductsPurge_594370;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The project and location in which the Products should be deleted.
  ## 
  ## Format is `projects/PROJECT_ID/locations/LOC_ID`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594388 = newJObject()
  var query_594389 = newJObject()
  var body_594390 = newJObject()
  add(query_594389, "upload_protocol", newJString(uploadProtocol))
  add(query_594389, "fields", newJString(fields))
  add(query_594389, "quotaUser", newJString(quotaUser))
  add(query_594389, "alt", newJString(alt))
  add(query_594389, "oauth_token", newJString(oauthToken))
  add(query_594389, "callback", newJString(callback))
  add(query_594389, "access_token", newJString(accessToken))
  add(query_594389, "uploadType", newJString(uploadType))
  add(path_594388, "parent", newJString(parent))
  add(query_594389, "key", newJString(key))
  add(query_594389, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594390 = body
  add(query_594389, "prettyPrint", newJBool(prettyPrint))
  result = call_594387.call(path_594388, query_594389, nil, nil, body_594390)

var visionProjectsLocationsProductsPurge* = Call_VisionProjectsLocationsProductsPurge_594370(
    name: "visionProjectsLocationsProductsPurge", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{parent}/products:purge",
    validator: validate_VisionProjectsLocationsProductsPurge_594371, base: "/",
    url: url_VisionProjectsLocationsProductsPurge_594372, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductsReferenceImagesCreate_594412 = ref object of OpenApiRestCall_593421
proc url_VisionProjectsLocationsProductsReferenceImagesCreate_594414(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VisionProjectsLocationsProductsReferenceImagesCreate_594413(
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
  var valid_594415 = path.getOrDefault("parent")
  valid_594415 = validateParameter(valid_594415, JString, required = true,
                                 default = nil)
  if valid_594415 != nil:
    section.add "parent", valid_594415
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   referenceImageId: JString
  ##                   : A user-supplied resource id for the ReferenceImage to be added. If set,
  ## the server will attempt to use this value as the resource id. If it is
  ## already in use, an error is returned with code ALREADY_EXISTS. Must be at
  ## most 128 characters long. It cannot contain the character `/`.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594416 = query.getOrDefault("upload_protocol")
  valid_594416 = validateParameter(valid_594416, JString, required = false,
                                 default = nil)
  if valid_594416 != nil:
    section.add "upload_protocol", valid_594416
  var valid_594417 = query.getOrDefault("fields")
  valid_594417 = validateParameter(valid_594417, JString, required = false,
                                 default = nil)
  if valid_594417 != nil:
    section.add "fields", valid_594417
  var valid_594418 = query.getOrDefault("quotaUser")
  valid_594418 = validateParameter(valid_594418, JString, required = false,
                                 default = nil)
  if valid_594418 != nil:
    section.add "quotaUser", valid_594418
  var valid_594419 = query.getOrDefault("alt")
  valid_594419 = validateParameter(valid_594419, JString, required = false,
                                 default = newJString("json"))
  if valid_594419 != nil:
    section.add "alt", valid_594419
  var valid_594420 = query.getOrDefault("referenceImageId")
  valid_594420 = validateParameter(valid_594420, JString, required = false,
                                 default = nil)
  if valid_594420 != nil:
    section.add "referenceImageId", valid_594420
  var valid_594421 = query.getOrDefault("oauth_token")
  valid_594421 = validateParameter(valid_594421, JString, required = false,
                                 default = nil)
  if valid_594421 != nil:
    section.add "oauth_token", valid_594421
  var valid_594422 = query.getOrDefault("callback")
  valid_594422 = validateParameter(valid_594422, JString, required = false,
                                 default = nil)
  if valid_594422 != nil:
    section.add "callback", valid_594422
  var valid_594423 = query.getOrDefault("access_token")
  valid_594423 = validateParameter(valid_594423, JString, required = false,
                                 default = nil)
  if valid_594423 != nil:
    section.add "access_token", valid_594423
  var valid_594424 = query.getOrDefault("uploadType")
  valid_594424 = validateParameter(valid_594424, JString, required = false,
                                 default = nil)
  if valid_594424 != nil:
    section.add "uploadType", valid_594424
  var valid_594425 = query.getOrDefault("key")
  valid_594425 = validateParameter(valid_594425, JString, required = false,
                                 default = nil)
  if valid_594425 != nil:
    section.add "key", valid_594425
  var valid_594426 = query.getOrDefault("$.xgafv")
  valid_594426 = validateParameter(valid_594426, JString, required = false,
                                 default = newJString("1"))
  if valid_594426 != nil:
    section.add "$.xgafv", valid_594426
  var valid_594427 = query.getOrDefault("prettyPrint")
  valid_594427 = validateParameter(valid_594427, JBool, required = false,
                                 default = newJBool(true))
  if valid_594427 != nil:
    section.add "prettyPrint", valid_594427
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

proc call*(call_594429: Call_VisionProjectsLocationsProductsReferenceImagesCreate_594412;
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
  let valid = call_594429.validator(path, query, header, formData, body)
  let scheme = call_594429.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594429.url(scheme.get, call_594429.host, call_594429.base,
                         call_594429.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594429, url, valid)

proc call*(call_594430: Call_VisionProjectsLocationsProductsReferenceImagesCreate_594412;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; referenceImageId: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   referenceImageId: string
  ##                   : A user-supplied resource id for the ReferenceImage to be added. If set,
  ## the server will attempt to use this value as the resource id. If it is
  ## already in use, an error is returned with code ALREADY_EXISTS. Must be at
  ## most 128 characters long. It cannot contain the character `/`.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. Resource name of the product in which to create the reference image.
  ## 
  ## Format is
  ## `projects/PROJECT_ID/locations/LOC_ID/products/PRODUCT_ID`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594431 = newJObject()
  var query_594432 = newJObject()
  var body_594433 = newJObject()
  add(query_594432, "upload_protocol", newJString(uploadProtocol))
  add(query_594432, "fields", newJString(fields))
  add(query_594432, "quotaUser", newJString(quotaUser))
  add(query_594432, "alt", newJString(alt))
  add(query_594432, "referenceImageId", newJString(referenceImageId))
  add(query_594432, "oauth_token", newJString(oauthToken))
  add(query_594432, "callback", newJString(callback))
  add(query_594432, "access_token", newJString(accessToken))
  add(query_594432, "uploadType", newJString(uploadType))
  add(path_594431, "parent", newJString(parent))
  add(query_594432, "key", newJString(key))
  add(query_594432, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594433 = body
  add(query_594432, "prettyPrint", newJBool(prettyPrint))
  result = call_594430.call(path_594431, query_594432, nil, nil, body_594433)

var visionProjectsLocationsProductsReferenceImagesCreate* = Call_VisionProjectsLocationsProductsReferenceImagesCreate_594412(
    name: "visionProjectsLocationsProductsReferenceImagesCreate",
    meth: HttpMethod.HttpPost, host: "vision.googleapis.com",
    route: "/v1/{parent}/referenceImages",
    validator: validate_VisionProjectsLocationsProductsReferenceImagesCreate_594413,
    base: "/", url: url_VisionProjectsLocationsProductsReferenceImagesCreate_594414,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductsReferenceImagesList_594391 = ref object of OpenApiRestCall_593421
proc url_VisionProjectsLocationsProductsReferenceImagesList_594393(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_VisionProjectsLocationsProductsReferenceImagesList_594392(
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
  var valid_594394 = path.getOrDefault("parent")
  valid_594394 = validateParameter(valid_594394, JString, required = true,
                                 default = nil)
  if valid_594394 != nil:
    section.add "parent", valid_594394
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A token identifying a page of results to be returned. This is the value
  ## of `nextPageToken` returned in a previous reference image list request.
  ## 
  ## Defaults to the first page if not specified.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of items to return. Default 10, maximum 100.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594395 = query.getOrDefault("upload_protocol")
  valid_594395 = validateParameter(valid_594395, JString, required = false,
                                 default = nil)
  if valid_594395 != nil:
    section.add "upload_protocol", valid_594395
  var valid_594396 = query.getOrDefault("fields")
  valid_594396 = validateParameter(valid_594396, JString, required = false,
                                 default = nil)
  if valid_594396 != nil:
    section.add "fields", valid_594396
  var valid_594397 = query.getOrDefault("pageToken")
  valid_594397 = validateParameter(valid_594397, JString, required = false,
                                 default = nil)
  if valid_594397 != nil:
    section.add "pageToken", valid_594397
  var valid_594398 = query.getOrDefault("quotaUser")
  valid_594398 = validateParameter(valid_594398, JString, required = false,
                                 default = nil)
  if valid_594398 != nil:
    section.add "quotaUser", valid_594398
  var valid_594399 = query.getOrDefault("alt")
  valid_594399 = validateParameter(valid_594399, JString, required = false,
                                 default = newJString("json"))
  if valid_594399 != nil:
    section.add "alt", valid_594399
  var valid_594400 = query.getOrDefault("oauth_token")
  valid_594400 = validateParameter(valid_594400, JString, required = false,
                                 default = nil)
  if valid_594400 != nil:
    section.add "oauth_token", valid_594400
  var valid_594401 = query.getOrDefault("callback")
  valid_594401 = validateParameter(valid_594401, JString, required = false,
                                 default = nil)
  if valid_594401 != nil:
    section.add "callback", valid_594401
  var valid_594402 = query.getOrDefault("access_token")
  valid_594402 = validateParameter(valid_594402, JString, required = false,
                                 default = nil)
  if valid_594402 != nil:
    section.add "access_token", valid_594402
  var valid_594403 = query.getOrDefault("uploadType")
  valid_594403 = validateParameter(valid_594403, JString, required = false,
                                 default = nil)
  if valid_594403 != nil:
    section.add "uploadType", valid_594403
  var valid_594404 = query.getOrDefault("key")
  valid_594404 = validateParameter(valid_594404, JString, required = false,
                                 default = nil)
  if valid_594404 != nil:
    section.add "key", valid_594404
  var valid_594405 = query.getOrDefault("$.xgafv")
  valid_594405 = validateParameter(valid_594405, JString, required = false,
                                 default = newJString("1"))
  if valid_594405 != nil:
    section.add "$.xgafv", valid_594405
  var valid_594406 = query.getOrDefault("pageSize")
  valid_594406 = validateParameter(valid_594406, JInt, required = false, default = nil)
  if valid_594406 != nil:
    section.add "pageSize", valid_594406
  var valid_594407 = query.getOrDefault("prettyPrint")
  valid_594407 = validateParameter(valid_594407, JBool, required = false,
                                 default = newJBool(true))
  if valid_594407 != nil:
    section.add "prettyPrint", valid_594407
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594408: Call_VisionProjectsLocationsProductsReferenceImagesList_594391;
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
  let valid = call_594408.validator(path, query, header, formData, body)
  let scheme = call_594408.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594408.url(scheme.get, call_594408.host, call_594408.base,
                         call_594408.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594408, url, valid)

proc call*(call_594409: Call_VisionProjectsLocationsProductsReferenceImagesList_594391;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## visionProjectsLocationsProductsReferenceImagesList
  ## Lists reference images.
  ## 
  ## Possible errors:
  ## 
  ## * Returns NOT_FOUND if the parent product does not exist.
  ## * Returns INVALID_ARGUMENT if the page_size is greater than 100, or less
  ##   than 1.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token identifying a page of results to be returned. This is the value
  ## of `nextPageToken` returned in a previous reference image list request.
  ## 
  ## Defaults to the first page if not specified.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. Resource name of the product containing the reference images.
  ## 
  ## Format is
  ## `projects/PROJECT_ID/locations/LOC_ID/products/PRODUCT_ID`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return. Default 10, maximum 100.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594410 = newJObject()
  var query_594411 = newJObject()
  add(query_594411, "upload_protocol", newJString(uploadProtocol))
  add(query_594411, "fields", newJString(fields))
  add(query_594411, "pageToken", newJString(pageToken))
  add(query_594411, "quotaUser", newJString(quotaUser))
  add(query_594411, "alt", newJString(alt))
  add(query_594411, "oauth_token", newJString(oauthToken))
  add(query_594411, "callback", newJString(callback))
  add(query_594411, "access_token", newJString(accessToken))
  add(query_594411, "uploadType", newJString(uploadType))
  add(path_594410, "parent", newJString(parent))
  add(query_594411, "key", newJString(key))
  add(query_594411, "$.xgafv", newJString(Xgafv))
  add(query_594411, "pageSize", newJInt(pageSize))
  add(query_594411, "prettyPrint", newJBool(prettyPrint))
  result = call_594409.call(path_594410, query_594411, nil, nil, nil)

var visionProjectsLocationsProductsReferenceImagesList* = Call_VisionProjectsLocationsProductsReferenceImagesList_594391(
    name: "visionProjectsLocationsProductsReferenceImagesList",
    meth: HttpMethod.HttpGet, host: "vision.googleapis.com",
    route: "/v1/{parent}/referenceImages",
    validator: validate_VisionProjectsLocationsProductsReferenceImagesList_594392,
    base: "/", url: url_VisionProjectsLocationsProductsReferenceImagesList_594393,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
