
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Cloud Vision
## version: v1p2beta1
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
    host: "vision.googleapis.com", route: "/v1p2beta1/files:annotate",
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
    host: "vision.googleapis.com", route: "/v1p2beta1/files:asyncBatchAnnotate",
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
    host: "vision.googleapis.com", route: "/v1p2beta1/images:annotate",
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
    host: "vision.googleapis.com", route: "/v1p2beta1/images:asyncBatchAnnotate",
    validator: validate_VisionImagesAsyncBatchAnnotate_594003, base: "/",
    url: url_VisionImagesAsyncBatchAnnotate_594004, schemes: {Scheme.Https})
type
  Call_VisionProjectsFilesAnnotate_594021 = ref object of OpenApiRestCall_593421
proc url_VisionProjectsFilesAnnotate_594023(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1p2beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/files:annotate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VisionProjectsFilesAnnotate_594022(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_594038 = path.getOrDefault("parent")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "parent", valid_594038
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594051: Call_VisionProjectsFilesAnnotate_594021; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Service that performs image detection and annotation for a batch of files.
  ## Now only "application/pdf", "image/tiff" and "image/gif" are supported.
  ## 
  ## This service will extract at most 5 (customers can specify which 5 in
  ## AnnotateFileRequest.pages) frames (gif) or pages (pdf or tiff) from each
  ## file provided and perform detection and annotation for each image
  ## extracted.
  ## 
  let valid = call_594051.validator(path, query, header, formData, body)
  let scheme = call_594051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594051.url(scheme.get, call_594051.host, call_594051.base,
                         call_594051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594051, url, valid)

proc call*(call_594052: Call_VisionProjectsFilesAnnotate_594021; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## visionProjectsFilesAnnotate
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
  var path_594053 = newJObject()
  var query_594054 = newJObject()
  var body_594055 = newJObject()
  add(query_594054, "upload_protocol", newJString(uploadProtocol))
  add(query_594054, "fields", newJString(fields))
  add(query_594054, "quotaUser", newJString(quotaUser))
  add(query_594054, "alt", newJString(alt))
  add(query_594054, "oauth_token", newJString(oauthToken))
  add(query_594054, "callback", newJString(callback))
  add(query_594054, "access_token", newJString(accessToken))
  add(query_594054, "uploadType", newJString(uploadType))
  add(path_594053, "parent", newJString(parent))
  add(query_594054, "key", newJString(key))
  add(query_594054, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594055 = body
  add(query_594054, "prettyPrint", newJBool(prettyPrint))
  result = call_594052.call(path_594053, query_594054, nil, nil, body_594055)

var visionProjectsFilesAnnotate* = Call_VisionProjectsFilesAnnotate_594021(
    name: "visionProjectsFilesAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1p2beta1/{parent}/files:annotate",
    validator: validate_VisionProjectsFilesAnnotate_594022, base: "/",
    url: url_VisionProjectsFilesAnnotate_594023, schemes: {Scheme.Https})
type
  Call_VisionProjectsFilesAsyncBatchAnnotate_594056 = ref object of OpenApiRestCall_593421
proc url_VisionProjectsFilesAsyncBatchAnnotate_594058(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1p2beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/files:asyncBatchAnnotate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VisionProjectsFilesAsyncBatchAnnotate_594057(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_594059 = path.getOrDefault("parent")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "parent", valid_594059
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
  var valid_594060 = query.getOrDefault("upload_protocol")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "upload_protocol", valid_594060
  var valid_594061 = query.getOrDefault("fields")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "fields", valid_594061
  var valid_594062 = query.getOrDefault("quotaUser")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "quotaUser", valid_594062
  var valid_594063 = query.getOrDefault("alt")
  valid_594063 = validateParameter(valid_594063, JString, required = false,
                                 default = newJString("json"))
  if valid_594063 != nil:
    section.add "alt", valid_594063
  var valid_594064 = query.getOrDefault("oauth_token")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = nil)
  if valid_594064 != nil:
    section.add "oauth_token", valid_594064
  var valid_594065 = query.getOrDefault("callback")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "callback", valid_594065
  var valid_594066 = query.getOrDefault("access_token")
  valid_594066 = validateParameter(valid_594066, JString, required = false,
                                 default = nil)
  if valid_594066 != nil:
    section.add "access_token", valid_594066
  var valid_594067 = query.getOrDefault("uploadType")
  valid_594067 = validateParameter(valid_594067, JString, required = false,
                                 default = nil)
  if valid_594067 != nil:
    section.add "uploadType", valid_594067
  var valid_594068 = query.getOrDefault("key")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = nil)
  if valid_594068 != nil:
    section.add "key", valid_594068
  var valid_594069 = query.getOrDefault("$.xgafv")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = newJString("1"))
  if valid_594069 != nil:
    section.add "$.xgafv", valid_594069
  var valid_594070 = query.getOrDefault("prettyPrint")
  valid_594070 = validateParameter(valid_594070, JBool, required = false,
                                 default = newJBool(true))
  if valid_594070 != nil:
    section.add "prettyPrint", valid_594070
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

proc call*(call_594072: Call_VisionProjectsFilesAsyncBatchAnnotate_594056;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Run asynchronous image detection and annotation for a list of generic
  ## files, such as PDF files, which may contain multiple pages and multiple
  ## images per page. Progress and results can be retrieved through the
  ## `google.longrunning.Operations` interface.
  ## `Operation.metadata` contains `OperationMetadata` (metadata).
  ## `Operation.response` contains `AsyncBatchAnnotateFilesResponse` (results).
  ## 
  let valid = call_594072.validator(path, query, header, formData, body)
  let scheme = call_594072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594072.url(scheme.get, call_594072.host, call_594072.base,
                         call_594072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594072, url, valid)

proc call*(call_594073: Call_VisionProjectsFilesAsyncBatchAnnotate_594056;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## visionProjectsFilesAsyncBatchAnnotate
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
  var path_594074 = newJObject()
  var query_594075 = newJObject()
  var body_594076 = newJObject()
  add(query_594075, "upload_protocol", newJString(uploadProtocol))
  add(query_594075, "fields", newJString(fields))
  add(query_594075, "quotaUser", newJString(quotaUser))
  add(query_594075, "alt", newJString(alt))
  add(query_594075, "oauth_token", newJString(oauthToken))
  add(query_594075, "callback", newJString(callback))
  add(query_594075, "access_token", newJString(accessToken))
  add(query_594075, "uploadType", newJString(uploadType))
  add(path_594074, "parent", newJString(parent))
  add(query_594075, "key", newJString(key))
  add(query_594075, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594076 = body
  add(query_594075, "prettyPrint", newJBool(prettyPrint))
  result = call_594073.call(path_594074, query_594075, nil, nil, body_594076)

var visionProjectsFilesAsyncBatchAnnotate* = Call_VisionProjectsFilesAsyncBatchAnnotate_594056(
    name: "visionProjectsFilesAsyncBatchAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com",
    route: "/v1p2beta1/{parent}/files:asyncBatchAnnotate",
    validator: validate_VisionProjectsFilesAsyncBatchAnnotate_594057, base: "/",
    url: url_VisionProjectsFilesAsyncBatchAnnotate_594058, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsImagesAnnotate_594077 = ref object of OpenApiRestCall_593421
proc url_VisionProjectsLocationsImagesAnnotate_594079(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1p2beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/images:annotate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VisionProjectsLocationsImagesAnnotate_594078(path: JsonNode;
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
  var valid_594080 = path.getOrDefault("parent")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "parent", valid_594080
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
  var valid_594081 = query.getOrDefault("upload_protocol")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = nil)
  if valid_594081 != nil:
    section.add "upload_protocol", valid_594081
  var valid_594082 = query.getOrDefault("fields")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = nil)
  if valid_594082 != nil:
    section.add "fields", valid_594082
  var valid_594083 = query.getOrDefault("quotaUser")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = nil)
  if valid_594083 != nil:
    section.add "quotaUser", valid_594083
  var valid_594084 = query.getOrDefault("alt")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = newJString("json"))
  if valid_594084 != nil:
    section.add "alt", valid_594084
  var valid_594085 = query.getOrDefault("oauth_token")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = nil)
  if valid_594085 != nil:
    section.add "oauth_token", valid_594085
  var valid_594086 = query.getOrDefault("callback")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = nil)
  if valid_594086 != nil:
    section.add "callback", valid_594086
  var valid_594087 = query.getOrDefault("access_token")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = nil)
  if valid_594087 != nil:
    section.add "access_token", valid_594087
  var valid_594088 = query.getOrDefault("uploadType")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = nil)
  if valid_594088 != nil:
    section.add "uploadType", valid_594088
  var valid_594089 = query.getOrDefault("key")
  valid_594089 = validateParameter(valid_594089, JString, required = false,
                                 default = nil)
  if valid_594089 != nil:
    section.add "key", valid_594089
  var valid_594090 = query.getOrDefault("$.xgafv")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = newJString("1"))
  if valid_594090 != nil:
    section.add "$.xgafv", valid_594090
  var valid_594091 = query.getOrDefault("prettyPrint")
  valid_594091 = validateParameter(valid_594091, JBool, required = false,
                                 default = newJBool(true))
  if valid_594091 != nil:
    section.add "prettyPrint", valid_594091
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

proc call*(call_594093: Call_VisionProjectsLocationsImagesAnnotate_594077;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Run image detection and annotation for a batch of images.
  ## 
  let valid = call_594093.validator(path, query, header, formData, body)
  let scheme = call_594093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594093.url(scheme.get, call_594093.host, call_594093.base,
                         call_594093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594093, url, valid)

proc call*(call_594094: Call_VisionProjectsLocationsImagesAnnotate_594077;
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
  var path_594095 = newJObject()
  var query_594096 = newJObject()
  var body_594097 = newJObject()
  add(query_594096, "upload_protocol", newJString(uploadProtocol))
  add(query_594096, "fields", newJString(fields))
  add(query_594096, "quotaUser", newJString(quotaUser))
  add(query_594096, "alt", newJString(alt))
  add(query_594096, "oauth_token", newJString(oauthToken))
  add(query_594096, "callback", newJString(callback))
  add(query_594096, "access_token", newJString(accessToken))
  add(query_594096, "uploadType", newJString(uploadType))
  add(path_594095, "parent", newJString(parent))
  add(query_594096, "key", newJString(key))
  add(query_594096, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594097 = body
  add(query_594096, "prettyPrint", newJBool(prettyPrint))
  result = call_594094.call(path_594095, query_594096, nil, nil, body_594097)

var visionProjectsLocationsImagesAnnotate* = Call_VisionProjectsLocationsImagesAnnotate_594077(
    name: "visionProjectsLocationsImagesAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1p2beta1/{parent}/images:annotate",
    validator: validate_VisionProjectsLocationsImagesAnnotate_594078, base: "/",
    url: url_VisionProjectsLocationsImagesAnnotate_594079, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsImagesAsyncBatchAnnotate_594098 = ref object of OpenApiRestCall_593421
proc url_VisionProjectsLocationsImagesAsyncBatchAnnotate_594100(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1p2beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/images:asyncBatchAnnotate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VisionProjectsLocationsImagesAsyncBatchAnnotate_594099(
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
  var valid_594101 = path.getOrDefault("parent")
  valid_594101 = validateParameter(valid_594101, JString, required = true,
                                 default = nil)
  if valid_594101 != nil:
    section.add "parent", valid_594101
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
  var valid_594102 = query.getOrDefault("upload_protocol")
  valid_594102 = validateParameter(valid_594102, JString, required = false,
                                 default = nil)
  if valid_594102 != nil:
    section.add "upload_protocol", valid_594102
  var valid_594103 = query.getOrDefault("fields")
  valid_594103 = validateParameter(valid_594103, JString, required = false,
                                 default = nil)
  if valid_594103 != nil:
    section.add "fields", valid_594103
  var valid_594104 = query.getOrDefault("quotaUser")
  valid_594104 = validateParameter(valid_594104, JString, required = false,
                                 default = nil)
  if valid_594104 != nil:
    section.add "quotaUser", valid_594104
  var valid_594105 = query.getOrDefault("alt")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = newJString("json"))
  if valid_594105 != nil:
    section.add "alt", valid_594105
  var valid_594106 = query.getOrDefault("oauth_token")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = nil)
  if valid_594106 != nil:
    section.add "oauth_token", valid_594106
  var valid_594107 = query.getOrDefault("callback")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = nil)
  if valid_594107 != nil:
    section.add "callback", valid_594107
  var valid_594108 = query.getOrDefault("access_token")
  valid_594108 = validateParameter(valid_594108, JString, required = false,
                                 default = nil)
  if valid_594108 != nil:
    section.add "access_token", valid_594108
  var valid_594109 = query.getOrDefault("uploadType")
  valid_594109 = validateParameter(valid_594109, JString, required = false,
                                 default = nil)
  if valid_594109 != nil:
    section.add "uploadType", valid_594109
  var valid_594110 = query.getOrDefault("key")
  valid_594110 = validateParameter(valid_594110, JString, required = false,
                                 default = nil)
  if valid_594110 != nil:
    section.add "key", valid_594110
  var valid_594111 = query.getOrDefault("$.xgafv")
  valid_594111 = validateParameter(valid_594111, JString, required = false,
                                 default = newJString("1"))
  if valid_594111 != nil:
    section.add "$.xgafv", valid_594111
  var valid_594112 = query.getOrDefault("prettyPrint")
  valid_594112 = validateParameter(valid_594112, JBool, required = false,
                                 default = newJBool(true))
  if valid_594112 != nil:
    section.add "prettyPrint", valid_594112
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

proc call*(call_594114: Call_VisionProjectsLocationsImagesAsyncBatchAnnotate_594098;
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
  let valid = call_594114.validator(path, query, header, formData, body)
  let scheme = call_594114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594114.url(scheme.get, call_594114.host, call_594114.base,
                         call_594114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594114, url, valid)

proc call*(call_594115: Call_VisionProjectsLocationsImagesAsyncBatchAnnotate_594098;
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
  var path_594116 = newJObject()
  var query_594117 = newJObject()
  var body_594118 = newJObject()
  add(query_594117, "upload_protocol", newJString(uploadProtocol))
  add(query_594117, "fields", newJString(fields))
  add(query_594117, "quotaUser", newJString(quotaUser))
  add(query_594117, "alt", newJString(alt))
  add(query_594117, "oauth_token", newJString(oauthToken))
  add(query_594117, "callback", newJString(callback))
  add(query_594117, "access_token", newJString(accessToken))
  add(query_594117, "uploadType", newJString(uploadType))
  add(path_594116, "parent", newJString(parent))
  add(query_594117, "key", newJString(key))
  add(query_594117, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594118 = body
  add(query_594117, "prettyPrint", newJBool(prettyPrint))
  result = call_594115.call(path_594116, query_594117, nil, nil, body_594118)

var visionProjectsLocationsImagesAsyncBatchAnnotate* = Call_VisionProjectsLocationsImagesAsyncBatchAnnotate_594098(
    name: "visionProjectsLocationsImagesAsyncBatchAnnotate",
    meth: HttpMethod.HttpPost, host: "vision.googleapis.com",
    route: "/v1p2beta1/{parent}/images:asyncBatchAnnotate",
    validator: validate_VisionProjectsLocationsImagesAsyncBatchAnnotate_594099,
    base: "/", url: url_VisionProjectsLocationsImagesAsyncBatchAnnotate_594100,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
