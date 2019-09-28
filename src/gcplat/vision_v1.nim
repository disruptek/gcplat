
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

  OpenApiRestCall_579421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579421): Option[Scheme] {.used.} =
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
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_VisionFilesAnnotate_579690 = ref object of OpenApiRestCall_579421
proc url_VisionFilesAnnotate_579692(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_VisionFilesAnnotate_579691(path: JsonNode; query: JsonNode;
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
  var valid_579804 = query.getOrDefault("upload_protocol")
  valid_579804 = validateParameter(valid_579804, JString, required = false,
                                 default = nil)
  if valid_579804 != nil:
    section.add "upload_protocol", valid_579804
  var valid_579805 = query.getOrDefault("fields")
  valid_579805 = validateParameter(valid_579805, JString, required = false,
                                 default = nil)
  if valid_579805 != nil:
    section.add "fields", valid_579805
  var valid_579806 = query.getOrDefault("quotaUser")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "quotaUser", valid_579806
  var valid_579820 = query.getOrDefault("alt")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = newJString("json"))
  if valid_579820 != nil:
    section.add "alt", valid_579820
  var valid_579821 = query.getOrDefault("oauth_token")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "oauth_token", valid_579821
  var valid_579822 = query.getOrDefault("callback")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "callback", valid_579822
  var valid_579823 = query.getOrDefault("access_token")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "access_token", valid_579823
  var valid_579824 = query.getOrDefault("uploadType")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "uploadType", valid_579824
  var valid_579825 = query.getOrDefault("key")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "key", valid_579825
  var valid_579826 = query.getOrDefault("$.xgafv")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = newJString("1"))
  if valid_579826 != nil:
    section.add "$.xgafv", valid_579826
  var valid_579827 = query.getOrDefault("prettyPrint")
  valid_579827 = validateParameter(valid_579827, JBool, required = false,
                                 default = newJBool(true))
  if valid_579827 != nil:
    section.add "prettyPrint", valid_579827
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

proc call*(call_579851: Call_VisionFilesAnnotate_579690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Service that performs image detection and annotation for a batch of files.
  ## Now only "application/pdf", "image/tiff" and "image/gif" are supported.
  ## 
  ## This service will extract at most 5 (customers can specify which 5 in
  ## AnnotateFileRequest.pages) frames (gif) or pages (pdf or tiff) from each
  ## file provided and perform detection and annotation for each image
  ## extracted.
  ## 
  let valid = call_579851.validator(path, query, header, formData, body)
  let scheme = call_579851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579851.url(scheme.get, call_579851.host, call_579851.base,
                         call_579851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579851, url, valid)

proc call*(call_579922: Call_VisionFilesAnnotate_579690;
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
  var query_579923 = newJObject()
  var body_579925 = newJObject()
  add(query_579923, "upload_protocol", newJString(uploadProtocol))
  add(query_579923, "fields", newJString(fields))
  add(query_579923, "quotaUser", newJString(quotaUser))
  add(query_579923, "alt", newJString(alt))
  add(query_579923, "oauth_token", newJString(oauthToken))
  add(query_579923, "callback", newJString(callback))
  add(query_579923, "access_token", newJString(accessToken))
  add(query_579923, "uploadType", newJString(uploadType))
  add(query_579923, "key", newJString(key))
  add(query_579923, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579925 = body
  add(query_579923, "prettyPrint", newJBool(prettyPrint))
  result = call_579922.call(nil, query_579923, nil, nil, body_579925)

var visionFilesAnnotate* = Call_VisionFilesAnnotate_579690(
    name: "visionFilesAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/files:annotate",
    validator: validate_VisionFilesAnnotate_579691, base: "/",
    url: url_VisionFilesAnnotate_579692, schemes: {Scheme.Https})
type
  Call_VisionFilesAsyncBatchAnnotate_579964 = ref object of OpenApiRestCall_579421
proc url_VisionFilesAsyncBatchAnnotate_579966(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_VisionFilesAsyncBatchAnnotate_579965(path: JsonNode; query: JsonNode;
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
  var valid_579967 = query.getOrDefault("upload_protocol")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "upload_protocol", valid_579967
  var valid_579968 = query.getOrDefault("fields")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "fields", valid_579968
  var valid_579969 = query.getOrDefault("quotaUser")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "quotaUser", valid_579969
  var valid_579970 = query.getOrDefault("alt")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = newJString("json"))
  if valid_579970 != nil:
    section.add "alt", valid_579970
  var valid_579971 = query.getOrDefault("oauth_token")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "oauth_token", valid_579971
  var valid_579972 = query.getOrDefault("callback")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "callback", valid_579972
  var valid_579973 = query.getOrDefault("access_token")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "access_token", valid_579973
  var valid_579974 = query.getOrDefault("uploadType")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "uploadType", valid_579974
  var valid_579975 = query.getOrDefault("key")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "key", valid_579975
  var valid_579976 = query.getOrDefault("$.xgafv")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = newJString("1"))
  if valid_579976 != nil:
    section.add "$.xgafv", valid_579976
  var valid_579977 = query.getOrDefault("prettyPrint")
  valid_579977 = validateParameter(valid_579977, JBool, required = false,
                                 default = newJBool(true))
  if valid_579977 != nil:
    section.add "prettyPrint", valid_579977
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

proc call*(call_579979: Call_VisionFilesAsyncBatchAnnotate_579964; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Run asynchronous image detection and annotation for a list of generic
  ## files, such as PDF files, which may contain multiple pages and multiple
  ## images per page. Progress and results can be retrieved through the
  ## `google.longrunning.Operations` interface.
  ## `Operation.metadata` contains `OperationMetadata` (metadata).
  ## `Operation.response` contains `AsyncBatchAnnotateFilesResponse` (results).
  ## 
  let valid = call_579979.validator(path, query, header, formData, body)
  let scheme = call_579979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579979.url(scheme.get, call_579979.host, call_579979.base,
                         call_579979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579979, url, valid)

proc call*(call_579980: Call_VisionFilesAsyncBatchAnnotate_579964;
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
  var query_579981 = newJObject()
  var body_579982 = newJObject()
  add(query_579981, "upload_protocol", newJString(uploadProtocol))
  add(query_579981, "fields", newJString(fields))
  add(query_579981, "quotaUser", newJString(quotaUser))
  add(query_579981, "alt", newJString(alt))
  add(query_579981, "oauth_token", newJString(oauthToken))
  add(query_579981, "callback", newJString(callback))
  add(query_579981, "access_token", newJString(accessToken))
  add(query_579981, "uploadType", newJString(uploadType))
  add(query_579981, "key", newJString(key))
  add(query_579981, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579982 = body
  add(query_579981, "prettyPrint", newJBool(prettyPrint))
  result = call_579980.call(nil, query_579981, nil, nil, body_579982)

var visionFilesAsyncBatchAnnotate* = Call_VisionFilesAsyncBatchAnnotate_579964(
    name: "visionFilesAsyncBatchAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/files:asyncBatchAnnotate",
    validator: validate_VisionFilesAsyncBatchAnnotate_579965, base: "/",
    url: url_VisionFilesAsyncBatchAnnotate_579966, schemes: {Scheme.Https})
type
  Call_VisionImagesAnnotate_579983 = ref object of OpenApiRestCall_579421
proc url_VisionImagesAnnotate_579985(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_VisionImagesAnnotate_579984(path: JsonNode; query: JsonNode;
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
  var valid_579986 = query.getOrDefault("upload_protocol")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "upload_protocol", valid_579986
  var valid_579987 = query.getOrDefault("fields")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "fields", valid_579987
  var valid_579988 = query.getOrDefault("quotaUser")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "quotaUser", valid_579988
  var valid_579989 = query.getOrDefault("alt")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = newJString("json"))
  if valid_579989 != nil:
    section.add "alt", valid_579989
  var valid_579990 = query.getOrDefault("oauth_token")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "oauth_token", valid_579990
  var valid_579991 = query.getOrDefault("callback")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "callback", valid_579991
  var valid_579992 = query.getOrDefault("access_token")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "access_token", valid_579992
  var valid_579993 = query.getOrDefault("uploadType")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "uploadType", valid_579993
  var valid_579994 = query.getOrDefault("key")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "key", valid_579994
  var valid_579995 = query.getOrDefault("$.xgafv")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = newJString("1"))
  if valid_579995 != nil:
    section.add "$.xgafv", valid_579995
  var valid_579996 = query.getOrDefault("prettyPrint")
  valid_579996 = validateParameter(valid_579996, JBool, required = false,
                                 default = newJBool(true))
  if valid_579996 != nil:
    section.add "prettyPrint", valid_579996
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

proc call*(call_579998: Call_VisionImagesAnnotate_579983; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Run image detection and annotation for a batch of images.
  ## 
  let valid = call_579998.validator(path, query, header, formData, body)
  let scheme = call_579998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579998.url(scheme.get, call_579998.host, call_579998.base,
                         call_579998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579998, url, valid)

proc call*(call_579999: Call_VisionImagesAnnotate_579983;
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
  var query_580000 = newJObject()
  var body_580001 = newJObject()
  add(query_580000, "upload_protocol", newJString(uploadProtocol))
  add(query_580000, "fields", newJString(fields))
  add(query_580000, "quotaUser", newJString(quotaUser))
  add(query_580000, "alt", newJString(alt))
  add(query_580000, "oauth_token", newJString(oauthToken))
  add(query_580000, "callback", newJString(callback))
  add(query_580000, "access_token", newJString(accessToken))
  add(query_580000, "uploadType", newJString(uploadType))
  add(query_580000, "key", newJString(key))
  add(query_580000, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580001 = body
  add(query_580000, "prettyPrint", newJBool(prettyPrint))
  result = call_579999.call(nil, query_580000, nil, nil, body_580001)

var visionImagesAnnotate* = Call_VisionImagesAnnotate_579983(
    name: "visionImagesAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/images:annotate",
    validator: validate_VisionImagesAnnotate_579984, base: "/",
    url: url_VisionImagesAnnotate_579985, schemes: {Scheme.Https})
type
  Call_VisionImagesAsyncBatchAnnotate_580002 = ref object of OpenApiRestCall_579421
proc url_VisionImagesAsyncBatchAnnotate_580004(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_VisionImagesAsyncBatchAnnotate_580003(path: JsonNode;
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
  var valid_580005 = query.getOrDefault("upload_protocol")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "upload_protocol", valid_580005
  var valid_580006 = query.getOrDefault("fields")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "fields", valid_580006
  var valid_580007 = query.getOrDefault("quotaUser")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "quotaUser", valid_580007
  var valid_580008 = query.getOrDefault("alt")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = newJString("json"))
  if valid_580008 != nil:
    section.add "alt", valid_580008
  var valid_580009 = query.getOrDefault("oauth_token")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "oauth_token", valid_580009
  var valid_580010 = query.getOrDefault("callback")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "callback", valid_580010
  var valid_580011 = query.getOrDefault("access_token")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "access_token", valid_580011
  var valid_580012 = query.getOrDefault("uploadType")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "uploadType", valid_580012
  var valid_580013 = query.getOrDefault("key")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "key", valid_580013
  var valid_580014 = query.getOrDefault("$.xgafv")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = newJString("1"))
  if valid_580014 != nil:
    section.add "$.xgafv", valid_580014
  var valid_580015 = query.getOrDefault("prettyPrint")
  valid_580015 = validateParameter(valid_580015, JBool, required = false,
                                 default = newJBool(true))
  if valid_580015 != nil:
    section.add "prettyPrint", valid_580015
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

proc call*(call_580017: Call_VisionImagesAsyncBatchAnnotate_580002; path: JsonNode;
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
  let valid = call_580017.validator(path, query, header, formData, body)
  let scheme = call_580017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580017.url(scheme.get, call_580017.host, call_580017.base,
                         call_580017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580017, url, valid)

proc call*(call_580018: Call_VisionImagesAsyncBatchAnnotate_580002;
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
  var query_580019 = newJObject()
  var body_580020 = newJObject()
  add(query_580019, "upload_protocol", newJString(uploadProtocol))
  add(query_580019, "fields", newJString(fields))
  add(query_580019, "quotaUser", newJString(quotaUser))
  add(query_580019, "alt", newJString(alt))
  add(query_580019, "oauth_token", newJString(oauthToken))
  add(query_580019, "callback", newJString(callback))
  add(query_580019, "access_token", newJString(accessToken))
  add(query_580019, "uploadType", newJString(uploadType))
  add(query_580019, "key", newJString(key))
  add(query_580019, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580020 = body
  add(query_580019, "prettyPrint", newJBool(prettyPrint))
  result = call_580018.call(nil, query_580019, nil, nil, body_580020)

var visionImagesAsyncBatchAnnotate* = Call_VisionImagesAsyncBatchAnnotate_580002(
    name: "visionImagesAsyncBatchAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/images:asyncBatchAnnotate",
    validator: validate_VisionImagesAsyncBatchAnnotate_580003, base: "/",
    url: url_VisionImagesAsyncBatchAnnotate_580004, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsOperationsGet_580021 = ref object of OpenApiRestCall_579421
proc url_VisionProjectsLocationsOperationsGet_580023(protocol: Scheme;
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

proc validate_VisionProjectsLocationsOperationsGet_580022(path: JsonNode;
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
  var valid_580038 = path.getOrDefault("name")
  valid_580038 = validateParameter(valid_580038, JString, required = true,
                                 default = nil)
  if valid_580038 != nil:
    section.add "name", valid_580038
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
  var valid_580039 = query.getOrDefault("upload_protocol")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "upload_protocol", valid_580039
  var valid_580040 = query.getOrDefault("fields")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "fields", valid_580040
  var valid_580041 = query.getOrDefault("quotaUser")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "quotaUser", valid_580041
  var valid_580042 = query.getOrDefault("alt")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = newJString("json"))
  if valid_580042 != nil:
    section.add "alt", valid_580042
  var valid_580043 = query.getOrDefault("oauth_token")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "oauth_token", valid_580043
  var valid_580044 = query.getOrDefault("callback")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "callback", valid_580044
  var valid_580045 = query.getOrDefault("access_token")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "access_token", valid_580045
  var valid_580046 = query.getOrDefault("uploadType")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "uploadType", valid_580046
  var valid_580047 = query.getOrDefault("key")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "key", valid_580047
  var valid_580048 = query.getOrDefault("$.xgafv")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = newJString("1"))
  if valid_580048 != nil:
    section.add "$.xgafv", valid_580048
  var valid_580049 = query.getOrDefault("prettyPrint")
  valid_580049 = validateParameter(valid_580049, JBool, required = false,
                                 default = newJBool(true))
  if valid_580049 != nil:
    section.add "prettyPrint", valid_580049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580050: Call_VisionProjectsLocationsOperationsGet_580021;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_580050.validator(path, query, header, formData, body)
  let scheme = call_580050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580050.url(scheme.get, call_580050.host, call_580050.base,
                         call_580050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580050, url, valid)

proc call*(call_580051: Call_VisionProjectsLocationsOperationsGet_580021;
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
  var path_580052 = newJObject()
  var query_580053 = newJObject()
  add(query_580053, "upload_protocol", newJString(uploadProtocol))
  add(query_580053, "fields", newJString(fields))
  add(query_580053, "quotaUser", newJString(quotaUser))
  add(path_580052, "name", newJString(name))
  add(query_580053, "alt", newJString(alt))
  add(query_580053, "oauth_token", newJString(oauthToken))
  add(query_580053, "callback", newJString(callback))
  add(query_580053, "access_token", newJString(accessToken))
  add(query_580053, "uploadType", newJString(uploadType))
  add(query_580053, "key", newJString(key))
  add(query_580053, "$.xgafv", newJString(Xgafv))
  add(query_580053, "prettyPrint", newJBool(prettyPrint))
  result = call_580051.call(path_580052, query_580053, nil, nil, nil)

var visionProjectsLocationsOperationsGet* = Call_VisionProjectsLocationsOperationsGet_580021(
    name: "visionProjectsLocationsOperationsGet", meth: HttpMethod.HttpGet,
    host: "vision.googleapis.com", route: "/v1/{name}",
    validator: validate_VisionProjectsLocationsOperationsGet_580022, base: "/",
    url: url_VisionProjectsLocationsOperationsGet_580023, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsPatch_580073 = ref object of OpenApiRestCall_579421
proc url_VisionProjectsLocationsProductSetsPatch_580075(protocol: Scheme;
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

proc validate_VisionProjectsLocationsProductSetsPatch_580074(path: JsonNode;
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
  var valid_580076 = path.getOrDefault("name")
  valid_580076 = validateParameter(valid_580076, JString, required = true,
                                 default = nil)
  if valid_580076 != nil:
    section.add "name", valid_580076
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
  var valid_580077 = query.getOrDefault("upload_protocol")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "upload_protocol", valid_580077
  var valid_580078 = query.getOrDefault("fields")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "fields", valid_580078
  var valid_580079 = query.getOrDefault("quotaUser")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "quotaUser", valid_580079
  var valid_580080 = query.getOrDefault("alt")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = newJString("json"))
  if valid_580080 != nil:
    section.add "alt", valid_580080
  var valid_580081 = query.getOrDefault("oauth_token")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "oauth_token", valid_580081
  var valid_580082 = query.getOrDefault("callback")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "callback", valid_580082
  var valid_580083 = query.getOrDefault("access_token")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "access_token", valid_580083
  var valid_580084 = query.getOrDefault("uploadType")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "uploadType", valid_580084
  var valid_580085 = query.getOrDefault("key")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "key", valid_580085
  var valid_580086 = query.getOrDefault("$.xgafv")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = newJString("1"))
  if valid_580086 != nil:
    section.add "$.xgafv", valid_580086
  var valid_580087 = query.getOrDefault("prettyPrint")
  valid_580087 = validateParameter(valid_580087, JBool, required = false,
                                 default = newJBool(true))
  if valid_580087 != nil:
    section.add "prettyPrint", valid_580087
  var valid_580088 = query.getOrDefault("updateMask")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "updateMask", valid_580088
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

proc call*(call_580090: Call_VisionProjectsLocationsProductSetsPatch_580073;
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
  let valid = call_580090.validator(path, query, header, formData, body)
  let scheme = call_580090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580090.url(scheme.get, call_580090.host, call_580090.base,
                         call_580090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580090, url, valid)

proc call*(call_580091: Call_VisionProjectsLocationsProductSetsPatch_580073;
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
  var path_580092 = newJObject()
  var query_580093 = newJObject()
  var body_580094 = newJObject()
  add(query_580093, "upload_protocol", newJString(uploadProtocol))
  add(query_580093, "fields", newJString(fields))
  add(query_580093, "quotaUser", newJString(quotaUser))
  add(path_580092, "name", newJString(name))
  add(query_580093, "alt", newJString(alt))
  add(query_580093, "oauth_token", newJString(oauthToken))
  add(query_580093, "callback", newJString(callback))
  add(query_580093, "access_token", newJString(accessToken))
  add(query_580093, "uploadType", newJString(uploadType))
  add(query_580093, "key", newJString(key))
  add(query_580093, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580094 = body
  add(query_580093, "prettyPrint", newJBool(prettyPrint))
  add(query_580093, "updateMask", newJString(updateMask))
  result = call_580091.call(path_580092, query_580093, nil, nil, body_580094)

var visionProjectsLocationsProductSetsPatch* = Call_VisionProjectsLocationsProductSetsPatch_580073(
    name: "visionProjectsLocationsProductSetsPatch", meth: HttpMethod.HttpPatch,
    host: "vision.googleapis.com", route: "/v1/{name}",
    validator: validate_VisionProjectsLocationsProductSetsPatch_580074, base: "/",
    url: url_VisionProjectsLocationsProductSetsPatch_580075,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsDelete_580054 = ref object of OpenApiRestCall_579421
proc url_VisionProjectsLocationsProductSetsDelete_580056(protocol: Scheme;
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

proc validate_VisionProjectsLocationsProductSetsDelete_580055(path: JsonNode;
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
  var valid_580057 = path.getOrDefault("name")
  valid_580057 = validateParameter(valid_580057, JString, required = true,
                                 default = nil)
  if valid_580057 != nil:
    section.add "name", valid_580057
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
  var valid_580058 = query.getOrDefault("upload_protocol")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "upload_protocol", valid_580058
  var valid_580059 = query.getOrDefault("fields")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "fields", valid_580059
  var valid_580060 = query.getOrDefault("quotaUser")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "quotaUser", valid_580060
  var valid_580061 = query.getOrDefault("alt")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = newJString("json"))
  if valid_580061 != nil:
    section.add "alt", valid_580061
  var valid_580062 = query.getOrDefault("oauth_token")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "oauth_token", valid_580062
  var valid_580063 = query.getOrDefault("callback")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "callback", valid_580063
  var valid_580064 = query.getOrDefault("access_token")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "access_token", valid_580064
  var valid_580065 = query.getOrDefault("uploadType")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "uploadType", valid_580065
  var valid_580066 = query.getOrDefault("key")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "key", valid_580066
  var valid_580067 = query.getOrDefault("$.xgafv")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = newJString("1"))
  if valid_580067 != nil:
    section.add "$.xgafv", valid_580067
  var valid_580068 = query.getOrDefault("prettyPrint")
  valid_580068 = validateParameter(valid_580068, JBool, required = false,
                                 default = newJBool(true))
  if valid_580068 != nil:
    section.add "prettyPrint", valid_580068
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580069: Call_VisionProjectsLocationsProductSetsDelete_580054;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently deletes a ProductSet. Products and ReferenceImages in the
  ## ProductSet are not deleted.
  ## 
  ## The actual image files are not deleted from Google Cloud Storage.
  ## 
  let valid = call_580069.validator(path, query, header, formData, body)
  let scheme = call_580069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580069.url(scheme.get, call_580069.host, call_580069.base,
                         call_580069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580069, url, valid)

proc call*(call_580070: Call_VisionProjectsLocationsProductSetsDelete_580054;
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
  var path_580071 = newJObject()
  var query_580072 = newJObject()
  add(query_580072, "upload_protocol", newJString(uploadProtocol))
  add(query_580072, "fields", newJString(fields))
  add(query_580072, "quotaUser", newJString(quotaUser))
  add(path_580071, "name", newJString(name))
  add(query_580072, "alt", newJString(alt))
  add(query_580072, "oauth_token", newJString(oauthToken))
  add(query_580072, "callback", newJString(callback))
  add(query_580072, "access_token", newJString(accessToken))
  add(query_580072, "uploadType", newJString(uploadType))
  add(query_580072, "key", newJString(key))
  add(query_580072, "$.xgafv", newJString(Xgafv))
  add(query_580072, "prettyPrint", newJBool(prettyPrint))
  result = call_580070.call(path_580071, query_580072, nil, nil, nil)

var visionProjectsLocationsProductSetsDelete* = Call_VisionProjectsLocationsProductSetsDelete_580054(
    name: "visionProjectsLocationsProductSetsDelete", meth: HttpMethod.HttpDelete,
    host: "vision.googleapis.com", route: "/v1/{name}",
    validator: validate_VisionProjectsLocationsProductSetsDelete_580055,
    base: "/", url: url_VisionProjectsLocationsProductSetsDelete_580056,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsProductsList_580095 = ref object of OpenApiRestCall_579421
proc url_VisionProjectsLocationsProductSetsProductsList_580097(protocol: Scheme;
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

proc validate_VisionProjectsLocationsProductSetsProductsList_580096(
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
  var valid_580098 = path.getOrDefault("name")
  valid_580098 = validateParameter(valid_580098, JString, required = true,
                                 default = nil)
  if valid_580098 != nil:
    section.add "name", valid_580098
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
  var valid_580099 = query.getOrDefault("upload_protocol")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "upload_protocol", valid_580099
  var valid_580100 = query.getOrDefault("fields")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "fields", valid_580100
  var valid_580101 = query.getOrDefault("pageToken")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "pageToken", valid_580101
  var valid_580102 = query.getOrDefault("quotaUser")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "quotaUser", valid_580102
  var valid_580103 = query.getOrDefault("alt")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = newJString("json"))
  if valid_580103 != nil:
    section.add "alt", valid_580103
  var valid_580104 = query.getOrDefault("oauth_token")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "oauth_token", valid_580104
  var valid_580105 = query.getOrDefault("callback")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "callback", valid_580105
  var valid_580106 = query.getOrDefault("access_token")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "access_token", valid_580106
  var valid_580107 = query.getOrDefault("uploadType")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "uploadType", valid_580107
  var valid_580108 = query.getOrDefault("key")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "key", valid_580108
  var valid_580109 = query.getOrDefault("$.xgafv")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = newJString("1"))
  if valid_580109 != nil:
    section.add "$.xgafv", valid_580109
  var valid_580110 = query.getOrDefault("pageSize")
  valid_580110 = validateParameter(valid_580110, JInt, required = false, default = nil)
  if valid_580110 != nil:
    section.add "pageSize", valid_580110
  var valid_580111 = query.getOrDefault("prettyPrint")
  valid_580111 = validateParameter(valid_580111, JBool, required = false,
                                 default = newJBool(true))
  if valid_580111 != nil:
    section.add "prettyPrint", valid_580111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580112: Call_VisionProjectsLocationsProductSetsProductsList_580095;
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
  let valid = call_580112.validator(path, query, header, formData, body)
  let scheme = call_580112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580112.url(scheme.get, call_580112.host, call_580112.base,
                         call_580112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580112, url, valid)

proc call*(call_580113: Call_VisionProjectsLocationsProductSetsProductsList_580095;
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
  var path_580114 = newJObject()
  var query_580115 = newJObject()
  add(query_580115, "upload_protocol", newJString(uploadProtocol))
  add(query_580115, "fields", newJString(fields))
  add(query_580115, "pageToken", newJString(pageToken))
  add(query_580115, "quotaUser", newJString(quotaUser))
  add(path_580114, "name", newJString(name))
  add(query_580115, "alt", newJString(alt))
  add(query_580115, "oauth_token", newJString(oauthToken))
  add(query_580115, "callback", newJString(callback))
  add(query_580115, "access_token", newJString(accessToken))
  add(query_580115, "uploadType", newJString(uploadType))
  add(query_580115, "key", newJString(key))
  add(query_580115, "$.xgafv", newJString(Xgafv))
  add(query_580115, "pageSize", newJInt(pageSize))
  add(query_580115, "prettyPrint", newJBool(prettyPrint))
  result = call_580113.call(path_580114, query_580115, nil, nil, nil)

var visionProjectsLocationsProductSetsProductsList* = Call_VisionProjectsLocationsProductSetsProductsList_580095(
    name: "visionProjectsLocationsProductSetsProductsList",
    meth: HttpMethod.HttpGet, host: "vision.googleapis.com",
    route: "/v1/{name}/products",
    validator: validate_VisionProjectsLocationsProductSetsProductsList_580096,
    base: "/", url: url_VisionProjectsLocationsProductSetsProductsList_580097,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsAddProduct_580116 = ref object of OpenApiRestCall_579421
proc url_VisionProjectsLocationsProductSetsAddProduct_580118(protocol: Scheme;
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

proc validate_VisionProjectsLocationsProductSetsAddProduct_580117(path: JsonNode;
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
  var valid_580119 = path.getOrDefault("name")
  valid_580119 = validateParameter(valid_580119, JString, required = true,
                                 default = nil)
  if valid_580119 != nil:
    section.add "name", valid_580119
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
  var valid_580120 = query.getOrDefault("upload_protocol")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "upload_protocol", valid_580120
  var valid_580121 = query.getOrDefault("fields")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "fields", valid_580121
  var valid_580122 = query.getOrDefault("quotaUser")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "quotaUser", valid_580122
  var valid_580123 = query.getOrDefault("alt")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = newJString("json"))
  if valid_580123 != nil:
    section.add "alt", valid_580123
  var valid_580124 = query.getOrDefault("oauth_token")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "oauth_token", valid_580124
  var valid_580125 = query.getOrDefault("callback")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "callback", valid_580125
  var valid_580126 = query.getOrDefault("access_token")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "access_token", valid_580126
  var valid_580127 = query.getOrDefault("uploadType")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "uploadType", valid_580127
  var valid_580128 = query.getOrDefault("key")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "key", valid_580128
  var valid_580129 = query.getOrDefault("$.xgafv")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = newJString("1"))
  if valid_580129 != nil:
    section.add "$.xgafv", valid_580129
  var valid_580130 = query.getOrDefault("prettyPrint")
  valid_580130 = validateParameter(valid_580130, JBool, required = false,
                                 default = newJBool(true))
  if valid_580130 != nil:
    section.add "prettyPrint", valid_580130
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

proc call*(call_580132: Call_VisionProjectsLocationsProductSetsAddProduct_580116;
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
  let valid = call_580132.validator(path, query, header, formData, body)
  let scheme = call_580132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580132.url(scheme.get, call_580132.host, call_580132.base,
                         call_580132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580132, url, valid)

proc call*(call_580133: Call_VisionProjectsLocationsProductSetsAddProduct_580116;
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
  var path_580134 = newJObject()
  var query_580135 = newJObject()
  var body_580136 = newJObject()
  add(query_580135, "upload_protocol", newJString(uploadProtocol))
  add(query_580135, "fields", newJString(fields))
  add(query_580135, "quotaUser", newJString(quotaUser))
  add(path_580134, "name", newJString(name))
  add(query_580135, "alt", newJString(alt))
  add(query_580135, "oauth_token", newJString(oauthToken))
  add(query_580135, "callback", newJString(callback))
  add(query_580135, "access_token", newJString(accessToken))
  add(query_580135, "uploadType", newJString(uploadType))
  add(query_580135, "key", newJString(key))
  add(query_580135, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580136 = body
  add(query_580135, "prettyPrint", newJBool(prettyPrint))
  result = call_580133.call(path_580134, query_580135, nil, nil, body_580136)

var visionProjectsLocationsProductSetsAddProduct* = Call_VisionProjectsLocationsProductSetsAddProduct_580116(
    name: "visionProjectsLocationsProductSetsAddProduct",
    meth: HttpMethod.HttpPost, host: "vision.googleapis.com",
    route: "/v1/{name}:addProduct",
    validator: validate_VisionProjectsLocationsProductSetsAddProduct_580117,
    base: "/", url: url_VisionProjectsLocationsProductSetsAddProduct_580118,
    schemes: {Scheme.Https})
type
  Call_VisionOperationsCancel_580137 = ref object of OpenApiRestCall_579421
proc url_VisionOperationsCancel_580139(protocol: Scheme; host: string; base: string;
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

proc validate_VisionOperationsCancel_580138(path: JsonNode; query: JsonNode;
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
  var valid_580140 = path.getOrDefault("name")
  valid_580140 = validateParameter(valid_580140, JString, required = true,
                                 default = nil)
  if valid_580140 != nil:
    section.add "name", valid_580140
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
  var valid_580141 = query.getOrDefault("upload_protocol")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "upload_protocol", valid_580141
  var valid_580142 = query.getOrDefault("fields")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "fields", valid_580142
  var valid_580143 = query.getOrDefault("quotaUser")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "quotaUser", valid_580143
  var valid_580144 = query.getOrDefault("alt")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = newJString("json"))
  if valid_580144 != nil:
    section.add "alt", valid_580144
  var valid_580145 = query.getOrDefault("oauth_token")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "oauth_token", valid_580145
  var valid_580146 = query.getOrDefault("callback")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "callback", valid_580146
  var valid_580147 = query.getOrDefault("access_token")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "access_token", valid_580147
  var valid_580148 = query.getOrDefault("uploadType")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "uploadType", valid_580148
  var valid_580149 = query.getOrDefault("key")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "key", valid_580149
  var valid_580150 = query.getOrDefault("$.xgafv")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = newJString("1"))
  if valid_580150 != nil:
    section.add "$.xgafv", valid_580150
  var valid_580151 = query.getOrDefault("prettyPrint")
  valid_580151 = validateParameter(valid_580151, JBool, required = false,
                                 default = newJBool(true))
  if valid_580151 != nil:
    section.add "prettyPrint", valid_580151
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

proc call*(call_580153: Call_VisionOperationsCancel_580137; path: JsonNode;
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
  let valid = call_580153.validator(path, query, header, formData, body)
  let scheme = call_580153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580153.url(scheme.get, call_580153.host, call_580153.base,
                         call_580153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580153, url, valid)

proc call*(call_580154: Call_VisionOperationsCancel_580137; name: string;
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
  var path_580155 = newJObject()
  var query_580156 = newJObject()
  var body_580157 = newJObject()
  add(query_580156, "upload_protocol", newJString(uploadProtocol))
  add(query_580156, "fields", newJString(fields))
  add(query_580156, "quotaUser", newJString(quotaUser))
  add(path_580155, "name", newJString(name))
  add(query_580156, "alt", newJString(alt))
  add(query_580156, "oauth_token", newJString(oauthToken))
  add(query_580156, "callback", newJString(callback))
  add(query_580156, "access_token", newJString(accessToken))
  add(query_580156, "uploadType", newJString(uploadType))
  add(query_580156, "key", newJString(key))
  add(query_580156, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580157 = body
  add(query_580156, "prettyPrint", newJBool(prettyPrint))
  result = call_580154.call(path_580155, query_580156, nil, nil, body_580157)

var visionOperationsCancel* = Call_VisionOperationsCancel_580137(
    name: "visionOperationsCancel", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_VisionOperationsCancel_580138, base: "/",
    url: url_VisionOperationsCancel_580139, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsRemoveProduct_580158 = ref object of OpenApiRestCall_579421
proc url_VisionProjectsLocationsProductSetsRemoveProduct_580160(protocol: Scheme;
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

proc validate_VisionProjectsLocationsProductSetsRemoveProduct_580159(
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
  var valid_580161 = path.getOrDefault("name")
  valid_580161 = validateParameter(valid_580161, JString, required = true,
                                 default = nil)
  if valid_580161 != nil:
    section.add "name", valid_580161
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
  var valid_580162 = query.getOrDefault("upload_protocol")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "upload_protocol", valid_580162
  var valid_580163 = query.getOrDefault("fields")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "fields", valid_580163
  var valid_580164 = query.getOrDefault("quotaUser")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "quotaUser", valid_580164
  var valid_580165 = query.getOrDefault("alt")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = newJString("json"))
  if valid_580165 != nil:
    section.add "alt", valid_580165
  var valid_580166 = query.getOrDefault("oauth_token")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "oauth_token", valid_580166
  var valid_580167 = query.getOrDefault("callback")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "callback", valid_580167
  var valid_580168 = query.getOrDefault("access_token")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "access_token", valid_580168
  var valid_580169 = query.getOrDefault("uploadType")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "uploadType", valid_580169
  var valid_580170 = query.getOrDefault("key")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "key", valid_580170
  var valid_580171 = query.getOrDefault("$.xgafv")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = newJString("1"))
  if valid_580171 != nil:
    section.add "$.xgafv", valid_580171
  var valid_580172 = query.getOrDefault("prettyPrint")
  valid_580172 = validateParameter(valid_580172, JBool, required = false,
                                 default = newJBool(true))
  if valid_580172 != nil:
    section.add "prettyPrint", valid_580172
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

proc call*(call_580174: Call_VisionProjectsLocationsProductSetsRemoveProduct_580158;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a Product from the specified ProductSet.
  ## 
  let valid = call_580174.validator(path, query, header, formData, body)
  let scheme = call_580174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580174.url(scheme.get, call_580174.host, call_580174.base,
                         call_580174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580174, url, valid)

proc call*(call_580175: Call_VisionProjectsLocationsProductSetsRemoveProduct_580158;
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
  var path_580176 = newJObject()
  var query_580177 = newJObject()
  var body_580178 = newJObject()
  add(query_580177, "upload_protocol", newJString(uploadProtocol))
  add(query_580177, "fields", newJString(fields))
  add(query_580177, "quotaUser", newJString(quotaUser))
  add(path_580176, "name", newJString(name))
  add(query_580177, "alt", newJString(alt))
  add(query_580177, "oauth_token", newJString(oauthToken))
  add(query_580177, "callback", newJString(callback))
  add(query_580177, "access_token", newJString(accessToken))
  add(query_580177, "uploadType", newJString(uploadType))
  add(query_580177, "key", newJString(key))
  add(query_580177, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580178 = body
  add(query_580177, "prettyPrint", newJBool(prettyPrint))
  result = call_580175.call(path_580176, query_580177, nil, nil, body_580178)

var visionProjectsLocationsProductSetsRemoveProduct* = Call_VisionProjectsLocationsProductSetsRemoveProduct_580158(
    name: "visionProjectsLocationsProductSetsRemoveProduct",
    meth: HttpMethod.HttpPost, host: "vision.googleapis.com",
    route: "/v1/{name}:removeProduct",
    validator: validate_VisionProjectsLocationsProductSetsRemoveProduct_580159,
    base: "/", url: url_VisionProjectsLocationsProductSetsRemoveProduct_580160,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsFilesAnnotate_580179 = ref object of OpenApiRestCall_579421
proc url_VisionProjectsLocationsFilesAnnotate_580181(protocol: Scheme;
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

proc validate_VisionProjectsLocationsFilesAnnotate_580180(path: JsonNode;
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
  var valid_580182 = path.getOrDefault("parent")
  valid_580182 = validateParameter(valid_580182, JString, required = true,
                                 default = nil)
  if valid_580182 != nil:
    section.add "parent", valid_580182
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
  var valid_580183 = query.getOrDefault("upload_protocol")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "upload_protocol", valid_580183
  var valid_580184 = query.getOrDefault("fields")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "fields", valid_580184
  var valid_580185 = query.getOrDefault("quotaUser")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "quotaUser", valid_580185
  var valid_580186 = query.getOrDefault("alt")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = newJString("json"))
  if valid_580186 != nil:
    section.add "alt", valid_580186
  var valid_580187 = query.getOrDefault("oauth_token")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "oauth_token", valid_580187
  var valid_580188 = query.getOrDefault("callback")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "callback", valid_580188
  var valid_580189 = query.getOrDefault("access_token")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "access_token", valid_580189
  var valid_580190 = query.getOrDefault("uploadType")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "uploadType", valid_580190
  var valid_580191 = query.getOrDefault("key")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "key", valid_580191
  var valid_580192 = query.getOrDefault("$.xgafv")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = newJString("1"))
  if valid_580192 != nil:
    section.add "$.xgafv", valid_580192
  var valid_580193 = query.getOrDefault("prettyPrint")
  valid_580193 = validateParameter(valid_580193, JBool, required = false,
                                 default = newJBool(true))
  if valid_580193 != nil:
    section.add "prettyPrint", valid_580193
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

proc call*(call_580195: Call_VisionProjectsLocationsFilesAnnotate_580179;
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
  let valid = call_580195.validator(path, query, header, formData, body)
  let scheme = call_580195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580195.url(scheme.get, call_580195.host, call_580195.base,
                         call_580195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580195, url, valid)

proc call*(call_580196: Call_VisionProjectsLocationsFilesAnnotate_580179;
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
  var path_580197 = newJObject()
  var query_580198 = newJObject()
  var body_580199 = newJObject()
  add(query_580198, "upload_protocol", newJString(uploadProtocol))
  add(query_580198, "fields", newJString(fields))
  add(query_580198, "quotaUser", newJString(quotaUser))
  add(query_580198, "alt", newJString(alt))
  add(query_580198, "oauth_token", newJString(oauthToken))
  add(query_580198, "callback", newJString(callback))
  add(query_580198, "access_token", newJString(accessToken))
  add(query_580198, "uploadType", newJString(uploadType))
  add(path_580197, "parent", newJString(parent))
  add(query_580198, "key", newJString(key))
  add(query_580198, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580199 = body
  add(query_580198, "prettyPrint", newJBool(prettyPrint))
  result = call_580196.call(path_580197, query_580198, nil, nil, body_580199)

var visionProjectsLocationsFilesAnnotate* = Call_VisionProjectsLocationsFilesAnnotate_580179(
    name: "visionProjectsLocationsFilesAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{parent}/files:annotate",
    validator: validate_VisionProjectsLocationsFilesAnnotate_580180, base: "/",
    url: url_VisionProjectsLocationsFilesAnnotate_580181, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsFilesAsyncBatchAnnotate_580200 = ref object of OpenApiRestCall_579421
proc url_VisionProjectsLocationsFilesAsyncBatchAnnotate_580202(protocol: Scheme;
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

proc validate_VisionProjectsLocationsFilesAsyncBatchAnnotate_580201(
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
  var valid_580203 = path.getOrDefault("parent")
  valid_580203 = validateParameter(valid_580203, JString, required = true,
                                 default = nil)
  if valid_580203 != nil:
    section.add "parent", valid_580203
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
  var valid_580204 = query.getOrDefault("upload_protocol")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "upload_protocol", valid_580204
  var valid_580205 = query.getOrDefault("fields")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "fields", valid_580205
  var valid_580206 = query.getOrDefault("quotaUser")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "quotaUser", valid_580206
  var valid_580207 = query.getOrDefault("alt")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = newJString("json"))
  if valid_580207 != nil:
    section.add "alt", valid_580207
  var valid_580208 = query.getOrDefault("oauth_token")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "oauth_token", valid_580208
  var valid_580209 = query.getOrDefault("callback")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "callback", valid_580209
  var valid_580210 = query.getOrDefault("access_token")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "access_token", valid_580210
  var valid_580211 = query.getOrDefault("uploadType")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "uploadType", valid_580211
  var valid_580212 = query.getOrDefault("key")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "key", valid_580212
  var valid_580213 = query.getOrDefault("$.xgafv")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = newJString("1"))
  if valid_580213 != nil:
    section.add "$.xgafv", valid_580213
  var valid_580214 = query.getOrDefault("prettyPrint")
  valid_580214 = validateParameter(valid_580214, JBool, required = false,
                                 default = newJBool(true))
  if valid_580214 != nil:
    section.add "prettyPrint", valid_580214
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

proc call*(call_580216: Call_VisionProjectsLocationsFilesAsyncBatchAnnotate_580200;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Run asynchronous image detection and annotation for a list of generic
  ## files, such as PDF files, which may contain multiple pages and multiple
  ## images per page. Progress and results can be retrieved through the
  ## `google.longrunning.Operations` interface.
  ## `Operation.metadata` contains `OperationMetadata` (metadata).
  ## `Operation.response` contains `AsyncBatchAnnotateFilesResponse` (results).
  ## 
  let valid = call_580216.validator(path, query, header, formData, body)
  let scheme = call_580216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580216.url(scheme.get, call_580216.host, call_580216.base,
                         call_580216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580216, url, valid)

proc call*(call_580217: Call_VisionProjectsLocationsFilesAsyncBatchAnnotate_580200;
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
  var path_580218 = newJObject()
  var query_580219 = newJObject()
  var body_580220 = newJObject()
  add(query_580219, "upload_protocol", newJString(uploadProtocol))
  add(query_580219, "fields", newJString(fields))
  add(query_580219, "quotaUser", newJString(quotaUser))
  add(query_580219, "alt", newJString(alt))
  add(query_580219, "oauth_token", newJString(oauthToken))
  add(query_580219, "callback", newJString(callback))
  add(query_580219, "access_token", newJString(accessToken))
  add(query_580219, "uploadType", newJString(uploadType))
  add(path_580218, "parent", newJString(parent))
  add(query_580219, "key", newJString(key))
  add(query_580219, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580220 = body
  add(query_580219, "prettyPrint", newJBool(prettyPrint))
  result = call_580217.call(path_580218, query_580219, nil, nil, body_580220)

var visionProjectsLocationsFilesAsyncBatchAnnotate* = Call_VisionProjectsLocationsFilesAsyncBatchAnnotate_580200(
    name: "visionProjectsLocationsFilesAsyncBatchAnnotate",
    meth: HttpMethod.HttpPost, host: "vision.googleapis.com",
    route: "/v1/{parent}/files:asyncBatchAnnotate",
    validator: validate_VisionProjectsLocationsFilesAsyncBatchAnnotate_580201,
    base: "/", url: url_VisionProjectsLocationsFilesAsyncBatchAnnotate_580202,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsImagesAnnotate_580221 = ref object of OpenApiRestCall_579421
proc url_VisionProjectsLocationsImagesAnnotate_580223(protocol: Scheme;
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

proc validate_VisionProjectsLocationsImagesAnnotate_580222(path: JsonNode;
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
  var valid_580224 = path.getOrDefault("parent")
  valid_580224 = validateParameter(valid_580224, JString, required = true,
                                 default = nil)
  if valid_580224 != nil:
    section.add "parent", valid_580224
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
  var valid_580225 = query.getOrDefault("upload_protocol")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "upload_protocol", valid_580225
  var valid_580226 = query.getOrDefault("fields")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "fields", valid_580226
  var valid_580227 = query.getOrDefault("quotaUser")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "quotaUser", valid_580227
  var valid_580228 = query.getOrDefault("alt")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = newJString("json"))
  if valid_580228 != nil:
    section.add "alt", valid_580228
  var valid_580229 = query.getOrDefault("oauth_token")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "oauth_token", valid_580229
  var valid_580230 = query.getOrDefault("callback")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "callback", valid_580230
  var valid_580231 = query.getOrDefault("access_token")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "access_token", valid_580231
  var valid_580232 = query.getOrDefault("uploadType")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "uploadType", valid_580232
  var valid_580233 = query.getOrDefault("key")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "key", valid_580233
  var valid_580234 = query.getOrDefault("$.xgafv")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = newJString("1"))
  if valid_580234 != nil:
    section.add "$.xgafv", valid_580234
  var valid_580235 = query.getOrDefault("prettyPrint")
  valid_580235 = validateParameter(valid_580235, JBool, required = false,
                                 default = newJBool(true))
  if valid_580235 != nil:
    section.add "prettyPrint", valid_580235
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

proc call*(call_580237: Call_VisionProjectsLocationsImagesAnnotate_580221;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Run image detection and annotation for a batch of images.
  ## 
  let valid = call_580237.validator(path, query, header, formData, body)
  let scheme = call_580237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580237.url(scheme.get, call_580237.host, call_580237.base,
                         call_580237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580237, url, valid)

proc call*(call_580238: Call_VisionProjectsLocationsImagesAnnotate_580221;
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
  var path_580239 = newJObject()
  var query_580240 = newJObject()
  var body_580241 = newJObject()
  add(query_580240, "upload_protocol", newJString(uploadProtocol))
  add(query_580240, "fields", newJString(fields))
  add(query_580240, "quotaUser", newJString(quotaUser))
  add(query_580240, "alt", newJString(alt))
  add(query_580240, "oauth_token", newJString(oauthToken))
  add(query_580240, "callback", newJString(callback))
  add(query_580240, "access_token", newJString(accessToken))
  add(query_580240, "uploadType", newJString(uploadType))
  add(path_580239, "parent", newJString(parent))
  add(query_580240, "key", newJString(key))
  add(query_580240, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580241 = body
  add(query_580240, "prettyPrint", newJBool(prettyPrint))
  result = call_580238.call(path_580239, query_580240, nil, nil, body_580241)

var visionProjectsLocationsImagesAnnotate* = Call_VisionProjectsLocationsImagesAnnotate_580221(
    name: "visionProjectsLocationsImagesAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{parent}/images:annotate",
    validator: validate_VisionProjectsLocationsImagesAnnotate_580222, base: "/",
    url: url_VisionProjectsLocationsImagesAnnotate_580223, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsImagesAsyncBatchAnnotate_580242 = ref object of OpenApiRestCall_579421
proc url_VisionProjectsLocationsImagesAsyncBatchAnnotate_580244(protocol: Scheme;
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

proc validate_VisionProjectsLocationsImagesAsyncBatchAnnotate_580243(
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
  var valid_580245 = path.getOrDefault("parent")
  valid_580245 = validateParameter(valid_580245, JString, required = true,
                                 default = nil)
  if valid_580245 != nil:
    section.add "parent", valid_580245
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
  var valid_580246 = query.getOrDefault("upload_protocol")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "upload_protocol", valid_580246
  var valid_580247 = query.getOrDefault("fields")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "fields", valid_580247
  var valid_580248 = query.getOrDefault("quotaUser")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "quotaUser", valid_580248
  var valid_580249 = query.getOrDefault("alt")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = newJString("json"))
  if valid_580249 != nil:
    section.add "alt", valid_580249
  var valid_580250 = query.getOrDefault("oauth_token")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "oauth_token", valid_580250
  var valid_580251 = query.getOrDefault("callback")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "callback", valid_580251
  var valid_580252 = query.getOrDefault("access_token")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "access_token", valid_580252
  var valid_580253 = query.getOrDefault("uploadType")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = nil)
  if valid_580253 != nil:
    section.add "uploadType", valid_580253
  var valid_580254 = query.getOrDefault("key")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = nil)
  if valid_580254 != nil:
    section.add "key", valid_580254
  var valid_580255 = query.getOrDefault("$.xgafv")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = newJString("1"))
  if valid_580255 != nil:
    section.add "$.xgafv", valid_580255
  var valid_580256 = query.getOrDefault("prettyPrint")
  valid_580256 = validateParameter(valid_580256, JBool, required = false,
                                 default = newJBool(true))
  if valid_580256 != nil:
    section.add "prettyPrint", valid_580256
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

proc call*(call_580258: Call_VisionProjectsLocationsImagesAsyncBatchAnnotate_580242;
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
  let valid = call_580258.validator(path, query, header, formData, body)
  let scheme = call_580258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580258.url(scheme.get, call_580258.host, call_580258.base,
                         call_580258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580258, url, valid)

proc call*(call_580259: Call_VisionProjectsLocationsImagesAsyncBatchAnnotate_580242;
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
  var path_580260 = newJObject()
  var query_580261 = newJObject()
  var body_580262 = newJObject()
  add(query_580261, "upload_protocol", newJString(uploadProtocol))
  add(query_580261, "fields", newJString(fields))
  add(query_580261, "quotaUser", newJString(quotaUser))
  add(query_580261, "alt", newJString(alt))
  add(query_580261, "oauth_token", newJString(oauthToken))
  add(query_580261, "callback", newJString(callback))
  add(query_580261, "access_token", newJString(accessToken))
  add(query_580261, "uploadType", newJString(uploadType))
  add(path_580260, "parent", newJString(parent))
  add(query_580261, "key", newJString(key))
  add(query_580261, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580262 = body
  add(query_580261, "prettyPrint", newJBool(prettyPrint))
  result = call_580259.call(path_580260, query_580261, nil, nil, body_580262)

var visionProjectsLocationsImagesAsyncBatchAnnotate* = Call_VisionProjectsLocationsImagesAsyncBatchAnnotate_580242(
    name: "visionProjectsLocationsImagesAsyncBatchAnnotate",
    meth: HttpMethod.HttpPost, host: "vision.googleapis.com",
    route: "/v1/{parent}/images:asyncBatchAnnotate",
    validator: validate_VisionProjectsLocationsImagesAsyncBatchAnnotate_580243,
    base: "/", url: url_VisionProjectsLocationsImagesAsyncBatchAnnotate_580244,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsCreate_580284 = ref object of OpenApiRestCall_579421
proc url_VisionProjectsLocationsProductSetsCreate_580286(protocol: Scheme;
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

proc validate_VisionProjectsLocationsProductSetsCreate_580285(path: JsonNode;
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
  var valid_580287 = path.getOrDefault("parent")
  valid_580287 = validateParameter(valid_580287, JString, required = true,
                                 default = nil)
  if valid_580287 != nil:
    section.add "parent", valid_580287
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
  var valid_580288 = query.getOrDefault("upload_protocol")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = nil)
  if valid_580288 != nil:
    section.add "upload_protocol", valid_580288
  var valid_580289 = query.getOrDefault("fields")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = nil)
  if valid_580289 != nil:
    section.add "fields", valid_580289
  var valid_580290 = query.getOrDefault("quotaUser")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = nil)
  if valid_580290 != nil:
    section.add "quotaUser", valid_580290
  var valid_580291 = query.getOrDefault("alt")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = newJString("json"))
  if valid_580291 != nil:
    section.add "alt", valid_580291
  var valid_580292 = query.getOrDefault("oauth_token")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = nil)
  if valid_580292 != nil:
    section.add "oauth_token", valid_580292
  var valid_580293 = query.getOrDefault("callback")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "callback", valid_580293
  var valid_580294 = query.getOrDefault("access_token")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = nil)
  if valid_580294 != nil:
    section.add "access_token", valid_580294
  var valid_580295 = query.getOrDefault("uploadType")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "uploadType", valid_580295
  var valid_580296 = query.getOrDefault("key")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = nil)
  if valid_580296 != nil:
    section.add "key", valid_580296
  var valid_580297 = query.getOrDefault("$.xgafv")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = newJString("1"))
  if valid_580297 != nil:
    section.add "$.xgafv", valid_580297
  var valid_580298 = query.getOrDefault("productSetId")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = nil)
  if valid_580298 != nil:
    section.add "productSetId", valid_580298
  var valid_580299 = query.getOrDefault("prettyPrint")
  valid_580299 = validateParameter(valid_580299, JBool, required = false,
                                 default = newJBool(true))
  if valid_580299 != nil:
    section.add "prettyPrint", valid_580299
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

proc call*(call_580301: Call_VisionProjectsLocationsProductSetsCreate_580284;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates and returns a new ProductSet resource.
  ## 
  ## Possible errors:
  ## 
  ## * Returns INVALID_ARGUMENT if display_name is missing, or is longer than
  ##   4096 characters.
  ## 
  let valid = call_580301.validator(path, query, header, formData, body)
  let scheme = call_580301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580301.url(scheme.get, call_580301.host, call_580301.base,
                         call_580301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580301, url, valid)

proc call*(call_580302: Call_VisionProjectsLocationsProductSetsCreate_580284;
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
  var path_580303 = newJObject()
  var query_580304 = newJObject()
  var body_580305 = newJObject()
  add(query_580304, "upload_protocol", newJString(uploadProtocol))
  add(query_580304, "fields", newJString(fields))
  add(query_580304, "quotaUser", newJString(quotaUser))
  add(query_580304, "alt", newJString(alt))
  add(query_580304, "oauth_token", newJString(oauthToken))
  add(query_580304, "callback", newJString(callback))
  add(query_580304, "access_token", newJString(accessToken))
  add(query_580304, "uploadType", newJString(uploadType))
  add(path_580303, "parent", newJString(parent))
  add(query_580304, "key", newJString(key))
  add(query_580304, "$.xgafv", newJString(Xgafv))
  add(query_580304, "productSetId", newJString(productSetId))
  if body != nil:
    body_580305 = body
  add(query_580304, "prettyPrint", newJBool(prettyPrint))
  result = call_580302.call(path_580303, query_580304, nil, nil, body_580305)

var visionProjectsLocationsProductSetsCreate* = Call_VisionProjectsLocationsProductSetsCreate_580284(
    name: "visionProjectsLocationsProductSetsCreate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{parent}/productSets",
    validator: validate_VisionProjectsLocationsProductSetsCreate_580285,
    base: "/", url: url_VisionProjectsLocationsProductSetsCreate_580286,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsList_580263 = ref object of OpenApiRestCall_579421
proc url_VisionProjectsLocationsProductSetsList_580265(protocol: Scheme;
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

proc validate_VisionProjectsLocationsProductSetsList_580264(path: JsonNode;
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
  var valid_580266 = path.getOrDefault("parent")
  valid_580266 = validateParameter(valid_580266, JString, required = true,
                                 default = nil)
  if valid_580266 != nil:
    section.add "parent", valid_580266
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
  var valid_580267 = query.getOrDefault("upload_protocol")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "upload_protocol", valid_580267
  var valid_580268 = query.getOrDefault("fields")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = nil)
  if valid_580268 != nil:
    section.add "fields", valid_580268
  var valid_580269 = query.getOrDefault("pageToken")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = nil)
  if valid_580269 != nil:
    section.add "pageToken", valid_580269
  var valid_580270 = query.getOrDefault("quotaUser")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "quotaUser", valid_580270
  var valid_580271 = query.getOrDefault("alt")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = newJString("json"))
  if valid_580271 != nil:
    section.add "alt", valid_580271
  var valid_580272 = query.getOrDefault("oauth_token")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "oauth_token", valid_580272
  var valid_580273 = query.getOrDefault("callback")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "callback", valid_580273
  var valid_580274 = query.getOrDefault("access_token")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "access_token", valid_580274
  var valid_580275 = query.getOrDefault("uploadType")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = nil)
  if valid_580275 != nil:
    section.add "uploadType", valid_580275
  var valid_580276 = query.getOrDefault("key")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "key", valid_580276
  var valid_580277 = query.getOrDefault("$.xgafv")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = newJString("1"))
  if valid_580277 != nil:
    section.add "$.xgafv", valid_580277
  var valid_580278 = query.getOrDefault("pageSize")
  valid_580278 = validateParameter(valid_580278, JInt, required = false, default = nil)
  if valid_580278 != nil:
    section.add "pageSize", valid_580278
  var valid_580279 = query.getOrDefault("prettyPrint")
  valid_580279 = validateParameter(valid_580279, JBool, required = false,
                                 default = newJBool(true))
  if valid_580279 != nil:
    section.add "prettyPrint", valid_580279
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580280: Call_VisionProjectsLocationsProductSetsList_580263;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists ProductSets in an unspecified order.
  ## 
  ## Possible errors:
  ## 
  ## * Returns INVALID_ARGUMENT if page_size is greater than 100, or less
  ##   than 1.
  ## 
  let valid = call_580280.validator(path, query, header, formData, body)
  let scheme = call_580280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580280.url(scheme.get, call_580280.host, call_580280.base,
                         call_580280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580280, url, valid)

proc call*(call_580281: Call_VisionProjectsLocationsProductSetsList_580263;
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
  var path_580282 = newJObject()
  var query_580283 = newJObject()
  add(query_580283, "upload_protocol", newJString(uploadProtocol))
  add(query_580283, "fields", newJString(fields))
  add(query_580283, "pageToken", newJString(pageToken))
  add(query_580283, "quotaUser", newJString(quotaUser))
  add(query_580283, "alt", newJString(alt))
  add(query_580283, "oauth_token", newJString(oauthToken))
  add(query_580283, "callback", newJString(callback))
  add(query_580283, "access_token", newJString(accessToken))
  add(query_580283, "uploadType", newJString(uploadType))
  add(path_580282, "parent", newJString(parent))
  add(query_580283, "key", newJString(key))
  add(query_580283, "$.xgafv", newJString(Xgafv))
  add(query_580283, "pageSize", newJInt(pageSize))
  add(query_580283, "prettyPrint", newJBool(prettyPrint))
  result = call_580281.call(path_580282, query_580283, nil, nil, nil)

var visionProjectsLocationsProductSetsList* = Call_VisionProjectsLocationsProductSetsList_580263(
    name: "visionProjectsLocationsProductSetsList", meth: HttpMethod.HttpGet,
    host: "vision.googleapis.com", route: "/v1/{parent}/productSets",
    validator: validate_VisionProjectsLocationsProductSetsList_580264, base: "/",
    url: url_VisionProjectsLocationsProductSetsList_580265,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsImport_580306 = ref object of OpenApiRestCall_579421
proc url_VisionProjectsLocationsProductSetsImport_580308(protocol: Scheme;
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

proc validate_VisionProjectsLocationsProductSetsImport_580307(path: JsonNode;
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
  var valid_580309 = path.getOrDefault("parent")
  valid_580309 = validateParameter(valid_580309, JString, required = true,
                                 default = nil)
  if valid_580309 != nil:
    section.add "parent", valid_580309
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
  var valid_580310 = query.getOrDefault("upload_protocol")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = nil)
  if valid_580310 != nil:
    section.add "upload_protocol", valid_580310
  var valid_580311 = query.getOrDefault("fields")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = nil)
  if valid_580311 != nil:
    section.add "fields", valid_580311
  var valid_580312 = query.getOrDefault("quotaUser")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = nil)
  if valid_580312 != nil:
    section.add "quotaUser", valid_580312
  var valid_580313 = query.getOrDefault("alt")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = newJString("json"))
  if valid_580313 != nil:
    section.add "alt", valid_580313
  var valid_580314 = query.getOrDefault("oauth_token")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = nil)
  if valid_580314 != nil:
    section.add "oauth_token", valid_580314
  var valid_580315 = query.getOrDefault("callback")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "callback", valid_580315
  var valid_580316 = query.getOrDefault("access_token")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "access_token", valid_580316
  var valid_580317 = query.getOrDefault("uploadType")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = nil)
  if valid_580317 != nil:
    section.add "uploadType", valid_580317
  var valid_580318 = query.getOrDefault("key")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = nil)
  if valid_580318 != nil:
    section.add "key", valid_580318
  var valid_580319 = query.getOrDefault("$.xgafv")
  valid_580319 = validateParameter(valid_580319, JString, required = false,
                                 default = newJString("1"))
  if valid_580319 != nil:
    section.add "$.xgafv", valid_580319
  var valid_580320 = query.getOrDefault("prettyPrint")
  valid_580320 = validateParameter(valid_580320, JBool, required = false,
                                 default = newJBool(true))
  if valid_580320 != nil:
    section.add "prettyPrint", valid_580320
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

proc call*(call_580322: Call_VisionProjectsLocationsProductSetsImport_580306;
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
  let valid = call_580322.validator(path, query, header, formData, body)
  let scheme = call_580322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580322.url(scheme.get, call_580322.host, call_580322.base,
                         call_580322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580322, url, valid)

proc call*(call_580323: Call_VisionProjectsLocationsProductSetsImport_580306;
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
  var path_580324 = newJObject()
  var query_580325 = newJObject()
  var body_580326 = newJObject()
  add(query_580325, "upload_protocol", newJString(uploadProtocol))
  add(query_580325, "fields", newJString(fields))
  add(query_580325, "quotaUser", newJString(quotaUser))
  add(query_580325, "alt", newJString(alt))
  add(query_580325, "oauth_token", newJString(oauthToken))
  add(query_580325, "callback", newJString(callback))
  add(query_580325, "access_token", newJString(accessToken))
  add(query_580325, "uploadType", newJString(uploadType))
  add(path_580324, "parent", newJString(parent))
  add(query_580325, "key", newJString(key))
  add(query_580325, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580326 = body
  add(query_580325, "prettyPrint", newJBool(prettyPrint))
  result = call_580323.call(path_580324, query_580325, nil, nil, body_580326)

var visionProjectsLocationsProductSetsImport* = Call_VisionProjectsLocationsProductSetsImport_580306(
    name: "visionProjectsLocationsProductSetsImport", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{parent}/productSets:import",
    validator: validate_VisionProjectsLocationsProductSetsImport_580307,
    base: "/", url: url_VisionProjectsLocationsProductSetsImport_580308,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductsCreate_580348 = ref object of OpenApiRestCall_579421
proc url_VisionProjectsLocationsProductsCreate_580350(protocol: Scheme;
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

proc validate_VisionProjectsLocationsProductsCreate_580349(path: JsonNode;
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
  var valid_580351 = path.getOrDefault("parent")
  valid_580351 = validateParameter(valid_580351, JString, required = true,
                                 default = nil)
  if valid_580351 != nil:
    section.add "parent", valid_580351
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
  var valid_580352 = query.getOrDefault("upload_protocol")
  valid_580352 = validateParameter(valid_580352, JString, required = false,
                                 default = nil)
  if valid_580352 != nil:
    section.add "upload_protocol", valid_580352
  var valid_580353 = query.getOrDefault("fields")
  valid_580353 = validateParameter(valid_580353, JString, required = false,
                                 default = nil)
  if valid_580353 != nil:
    section.add "fields", valid_580353
  var valid_580354 = query.getOrDefault("quotaUser")
  valid_580354 = validateParameter(valid_580354, JString, required = false,
                                 default = nil)
  if valid_580354 != nil:
    section.add "quotaUser", valid_580354
  var valid_580355 = query.getOrDefault("alt")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = newJString("json"))
  if valid_580355 != nil:
    section.add "alt", valid_580355
  var valid_580356 = query.getOrDefault("oauth_token")
  valid_580356 = validateParameter(valid_580356, JString, required = false,
                                 default = nil)
  if valid_580356 != nil:
    section.add "oauth_token", valid_580356
  var valid_580357 = query.getOrDefault("callback")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = nil)
  if valid_580357 != nil:
    section.add "callback", valid_580357
  var valid_580358 = query.getOrDefault("access_token")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = nil)
  if valid_580358 != nil:
    section.add "access_token", valid_580358
  var valid_580359 = query.getOrDefault("uploadType")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = nil)
  if valid_580359 != nil:
    section.add "uploadType", valid_580359
  var valid_580360 = query.getOrDefault("productId")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = nil)
  if valid_580360 != nil:
    section.add "productId", valid_580360
  var valid_580361 = query.getOrDefault("key")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "key", valid_580361
  var valid_580362 = query.getOrDefault("$.xgafv")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = newJString("1"))
  if valid_580362 != nil:
    section.add "$.xgafv", valid_580362
  var valid_580363 = query.getOrDefault("prettyPrint")
  valid_580363 = validateParameter(valid_580363, JBool, required = false,
                                 default = newJBool(true))
  if valid_580363 != nil:
    section.add "prettyPrint", valid_580363
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

proc call*(call_580365: Call_VisionProjectsLocationsProductsCreate_580348;
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
  let valid = call_580365.validator(path, query, header, formData, body)
  let scheme = call_580365.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580365.url(scheme.get, call_580365.host, call_580365.base,
                         call_580365.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580365, url, valid)

proc call*(call_580366: Call_VisionProjectsLocationsProductsCreate_580348;
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
  var path_580367 = newJObject()
  var query_580368 = newJObject()
  var body_580369 = newJObject()
  add(query_580368, "upload_protocol", newJString(uploadProtocol))
  add(query_580368, "fields", newJString(fields))
  add(query_580368, "quotaUser", newJString(quotaUser))
  add(query_580368, "alt", newJString(alt))
  add(query_580368, "oauth_token", newJString(oauthToken))
  add(query_580368, "callback", newJString(callback))
  add(query_580368, "access_token", newJString(accessToken))
  add(query_580368, "uploadType", newJString(uploadType))
  add(path_580367, "parent", newJString(parent))
  add(query_580368, "productId", newJString(productId))
  add(query_580368, "key", newJString(key))
  add(query_580368, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580369 = body
  add(query_580368, "prettyPrint", newJBool(prettyPrint))
  result = call_580366.call(path_580367, query_580368, nil, nil, body_580369)

var visionProjectsLocationsProductsCreate* = Call_VisionProjectsLocationsProductsCreate_580348(
    name: "visionProjectsLocationsProductsCreate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{parent}/products",
    validator: validate_VisionProjectsLocationsProductsCreate_580349, base: "/",
    url: url_VisionProjectsLocationsProductsCreate_580350, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductsList_580327 = ref object of OpenApiRestCall_579421
proc url_VisionProjectsLocationsProductsList_580329(protocol: Scheme; host: string;
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

proc validate_VisionProjectsLocationsProductsList_580328(path: JsonNode;
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
  var valid_580330 = path.getOrDefault("parent")
  valid_580330 = validateParameter(valid_580330, JString, required = true,
                                 default = nil)
  if valid_580330 != nil:
    section.add "parent", valid_580330
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
  var valid_580331 = query.getOrDefault("upload_protocol")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = nil)
  if valid_580331 != nil:
    section.add "upload_protocol", valid_580331
  var valid_580332 = query.getOrDefault("fields")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = nil)
  if valid_580332 != nil:
    section.add "fields", valid_580332
  var valid_580333 = query.getOrDefault("pageToken")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = nil)
  if valid_580333 != nil:
    section.add "pageToken", valid_580333
  var valid_580334 = query.getOrDefault("quotaUser")
  valid_580334 = validateParameter(valid_580334, JString, required = false,
                                 default = nil)
  if valid_580334 != nil:
    section.add "quotaUser", valid_580334
  var valid_580335 = query.getOrDefault("alt")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = newJString("json"))
  if valid_580335 != nil:
    section.add "alt", valid_580335
  var valid_580336 = query.getOrDefault("oauth_token")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = nil)
  if valid_580336 != nil:
    section.add "oauth_token", valid_580336
  var valid_580337 = query.getOrDefault("callback")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = nil)
  if valid_580337 != nil:
    section.add "callback", valid_580337
  var valid_580338 = query.getOrDefault("access_token")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "access_token", valid_580338
  var valid_580339 = query.getOrDefault("uploadType")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "uploadType", valid_580339
  var valid_580340 = query.getOrDefault("key")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = nil)
  if valid_580340 != nil:
    section.add "key", valid_580340
  var valid_580341 = query.getOrDefault("$.xgafv")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = newJString("1"))
  if valid_580341 != nil:
    section.add "$.xgafv", valid_580341
  var valid_580342 = query.getOrDefault("pageSize")
  valid_580342 = validateParameter(valid_580342, JInt, required = false, default = nil)
  if valid_580342 != nil:
    section.add "pageSize", valid_580342
  var valid_580343 = query.getOrDefault("prettyPrint")
  valid_580343 = validateParameter(valid_580343, JBool, required = false,
                                 default = newJBool(true))
  if valid_580343 != nil:
    section.add "prettyPrint", valid_580343
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580344: Call_VisionProjectsLocationsProductsList_580327;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists products in an unspecified order.
  ## 
  ## Possible errors:
  ## 
  ## * Returns INVALID_ARGUMENT if page_size is greater than 100 or less than 1.
  ## 
  let valid = call_580344.validator(path, query, header, formData, body)
  let scheme = call_580344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580344.url(scheme.get, call_580344.host, call_580344.base,
                         call_580344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580344, url, valid)

proc call*(call_580345: Call_VisionProjectsLocationsProductsList_580327;
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
  var path_580346 = newJObject()
  var query_580347 = newJObject()
  add(query_580347, "upload_protocol", newJString(uploadProtocol))
  add(query_580347, "fields", newJString(fields))
  add(query_580347, "pageToken", newJString(pageToken))
  add(query_580347, "quotaUser", newJString(quotaUser))
  add(query_580347, "alt", newJString(alt))
  add(query_580347, "oauth_token", newJString(oauthToken))
  add(query_580347, "callback", newJString(callback))
  add(query_580347, "access_token", newJString(accessToken))
  add(query_580347, "uploadType", newJString(uploadType))
  add(path_580346, "parent", newJString(parent))
  add(query_580347, "key", newJString(key))
  add(query_580347, "$.xgafv", newJString(Xgafv))
  add(query_580347, "pageSize", newJInt(pageSize))
  add(query_580347, "prettyPrint", newJBool(prettyPrint))
  result = call_580345.call(path_580346, query_580347, nil, nil, nil)

var visionProjectsLocationsProductsList* = Call_VisionProjectsLocationsProductsList_580327(
    name: "visionProjectsLocationsProductsList", meth: HttpMethod.HttpGet,
    host: "vision.googleapis.com", route: "/v1/{parent}/products",
    validator: validate_VisionProjectsLocationsProductsList_580328, base: "/",
    url: url_VisionProjectsLocationsProductsList_580329, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductsPurge_580370 = ref object of OpenApiRestCall_579421
proc url_VisionProjectsLocationsProductsPurge_580372(protocol: Scheme;
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

proc validate_VisionProjectsLocationsProductsPurge_580371(path: JsonNode;
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
  var valid_580373 = path.getOrDefault("parent")
  valid_580373 = validateParameter(valid_580373, JString, required = true,
                                 default = nil)
  if valid_580373 != nil:
    section.add "parent", valid_580373
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
  var valid_580374 = query.getOrDefault("upload_protocol")
  valid_580374 = validateParameter(valid_580374, JString, required = false,
                                 default = nil)
  if valid_580374 != nil:
    section.add "upload_protocol", valid_580374
  var valid_580375 = query.getOrDefault("fields")
  valid_580375 = validateParameter(valid_580375, JString, required = false,
                                 default = nil)
  if valid_580375 != nil:
    section.add "fields", valid_580375
  var valid_580376 = query.getOrDefault("quotaUser")
  valid_580376 = validateParameter(valid_580376, JString, required = false,
                                 default = nil)
  if valid_580376 != nil:
    section.add "quotaUser", valid_580376
  var valid_580377 = query.getOrDefault("alt")
  valid_580377 = validateParameter(valid_580377, JString, required = false,
                                 default = newJString("json"))
  if valid_580377 != nil:
    section.add "alt", valid_580377
  var valid_580378 = query.getOrDefault("oauth_token")
  valid_580378 = validateParameter(valid_580378, JString, required = false,
                                 default = nil)
  if valid_580378 != nil:
    section.add "oauth_token", valid_580378
  var valid_580379 = query.getOrDefault("callback")
  valid_580379 = validateParameter(valid_580379, JString, required = false,
                                 default = nil)
  if valid_580379 != nil:
    section.add "callback", valid_580379
  var valid_580380 = query.getOrDefault("access_token")
  valid_580380 = validateParameter(valid_580380, JString, required = false,
                                 default = nil)
  if valid_580380 != nil:
    section.add "access_token", valid_580380
  var valid_580381 = query.getOrDefault("uploadType")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = nil)
  if valid_580381 != nil:
    section.add "uploadType", valid_580381
  var valid_580382 = query.getOrDefault("key")
  valid_580382 = validateParameter(valid_580382, JString, required = false,
                                 default = nil)
  if valid_580382 != nil:
    section.add "key", valid_580382
  var valid_580383 = query.getOrDefault("$.xgafv")
  valid_580383 = validateParameter(valid_580383, JString, required = false,
                                 default = newJString("1"))
  if valid_580383 != nil:
    section.add "$.xgafv", valid_580383
  var valid_580384 = query.getOrDefault("prettyPrint")
  valid_580384 = validateParameter(valid_580384, JBool, required = false,
                                 default = newJBool(true))
  if valid_580384 != nil:
    section.add "prettyPrint", valid_580384
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

proc call*(call_580386: Call_VisionProjectsLocationsProductsPurge_580370;
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
  let valid = call_580386.validator(path, query, header, formData, body)
  let scheme = call_580386.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580386.url(scheme.get, call_580386.host, call_580386.base,
                         call_580386.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580386, url, valid)

proc call*(call_580387: Call_VisionProjectsLocationsProductsPurge_580370;
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
  var path_580388 = newJObject()
  var query_580389 = newJObject()
  var body_580390 = newJObject()
  add(query_580389, "upload_protocol", newJString(uploadProtocol))
  add(query_580389, "fields", newJString(fields))
  add(query_580389, "quotaUser", newJString(quotaUser))
  add(query_580389, "alt", newJString(alt))
  add(query_580389, "oauth_token", newJString(oauthToken))
  add(query_580389, "callback", newJString(callback))
  add(query_580389, "access_token", newJString(accessToken))
  add(query_580389, "uploadType", newJString(uploadType))
  add(path_580388, "parent", newJString(parent))
  add(query_580389, "key", newJString(key))
  add(query_580389, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580390 = body
  add(query_580389, "prettyPrint", newJBool(prettyPrint))
  result = call_580387.call(path_580388, query_580389, nil, nil, body_580390)

var visionProjectsLocationsProductsPurge* = Call_VisionProjectsLocationsProductsPurge_580370(
    name: "visionProjectsLocationsProductsPurge", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{parent}/products:purge",
    validator: validate_VisionProjectsLocationsProductsPurge_580371, base: "/",
    url: url_VisionProjectsLocationsProductsPurge_580372, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductsReferenceImagesCreate_580412 = ref object of OpenApiRestCall_579421
proc url_VisionProjectsLocationsProductsReferenceImagesCreate_580414(
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

proc validate_VisionProjectsLocationsProductsReferenceImagesCreate_580413(
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
  var valid_580415 = path.getOrDefault("parent")
  valid_580415 = validateParameter(valid_580415, JString, required = true,
                                 default = nil)
  if valid_580415 != nil:
    section.add "parent", valid_580415
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
  var valid_580416 = query.getOrDefault("upload_protocol")
  valid_580416 = validateParameter(valid_580416, JString, required = false,
                                 default = nil)
  if valid_580416 != nil:
    section.add "upload_protocol", valid_580416
  var valid_580417 = query.getOrDefault("fields")
  valid_580417 = validateParameter(valid_580417, JString, required = false,
                                 default = nil)
  if valid_580417 != nil:
    section.add "fields", valid_580417
  var valid_580418 = query.getOrDefault("quotaUser")
  valid_580418 = validateParameter(valid_580418, JString, required = false,
                                 default = nil)
  if valid_580418 != nil:
    section.add "quotaUser", valid_580418
  var valid_580419 = query.getOrDefault("alt")
  valid_580419 = validateParameter(valid_580419, JString, required = false,
                                 default = newJString("json"))
  if valid_580419 != nil:
    section.add "alt", valid_580419
  var valid_580420 = query.getOrDefault("referenceImageId")
  valid_580420 = validateParameter(valid_580420, JString, required = false,
                                 default = nil)
  if valid_580420 != nil:
    section.add "referenceImageId", valid_580420
  var valid_580421 = query.getOrDefault("oauth_token")
  valid_580421 = validateParameter(valid_580421, JString, required = false,
                                 default = nil)
  if valid_580421 != nil:
    section.add "oauth_token", valid_580421
  var valid_580422 = query.getOrDefault("callback")
  valid_580422 = validateParameter(valid_580422, JString, required = false,
                                 default = nil)
  if valid_580422 != nil:
    section.add "callback", valid_580422
  var valid_580423 = query.getOrDefault("access_token")
  valid_580423 = validateParameter(valid_580423, JString, required = false,
                                 default = nil)
  if valid_580423 != nil:
    section.add "access_token", valid_580423
  var valid_580424 = query.getOrDefault("uploadType")
  valid_580424 = validateParameter(valid_580424, JString, required = false,
                                 default = nil)
  if valid_580424 != nil:
    section.add "uploadType", valid_580424
  var valid_580425 = query.getOrDefault("key")
  valid_580425 = validateParameter(valid_580425, JString, required = false,
                                 default = nil)
  if valid_580425 != nil:
    section.add "key", valid_580425
  var valid_580426 = query.getOrDefault("$.xgafv")
  valid_580426 = validateParameter(valid_580426, JString, required = false,
                                 default = newJString("1"))
  if valid_580426 != nil:
    section.add "$.xgafv", valid_580426
  var valid_580427 = query.getOrDefault("prettyPrint")
  valid_580427 = validateParameter(valid_580427, JBool, required = false,
                                 default = newJBool(true))
  if valid_580427 != nil:
    section.add "prettyPrint", valid_580427
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

proc call*(call_580429: Call_VisionProjectsLocationsProductsReferenceImagesCreate_580412;
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
  let valid = call_580429.validator(path, query, header, formData, body)
  let scheme = call_580429.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580429.url(scheme.get, call_580429.host, call_580429.base,
                         call_580429.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580429, url, valid)

proc call*(call_580430: Call_VisionProjectsLocationsProductsReferenceImagesCreate_580412;
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
  var path_580431 = newJObject()
  var query_580432 = newJObject()
  var body_580433 = newJObject()
  add(query_580432, "upload_protocol", newJString(uploadProtocol))
  add(query_580432, "fields", newJString(fields))
  add(query_580432, "quotaUser", newJString(quotaUser))
  add(query_580432, "alt", newJString(alt))
  add(query_580432, "referenceImageId", newJString(referenceImageId))
  add(query_580432, "oauth_token", newJString(oauthToken))
  add(query_580432, "callback", newJString(callback))
  add(query_580432, "access_token", newJString(accessToken))
  add(query_580432, "uploadType", newJString(uploadType))
  add(path_580431, "parent", newJString(parent))
  add(query_580432, "key", newJString(key))
  add(query_580432, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580433 = body
  add(query_580432, "prettyPrint", newJBool(prettyPrint))
  result = call_580430.call(path_580431, query_580432, nil, nil, body_580433)

var visionProjectsLocationsProductsReferenceImagesCreate* = Call_VisionProjectsLocationsProductsReferenceImagesCreate_580412(
    name: "visionProjectsLocationsProductsReferenceImagesCreate",
    meth: HttpMethod.HttpPost, host: "vision.googleapis.com",
    route: "/v1/{parent}/referenceImages",
    validator: validate_VisionProjectsLocationsProductsReferenceImagesCreate_580413,
    base: "/", url: url_VisionProjectsLocationsProductsReferenceImagesCreate_580414,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductsReferenceImagesList_580391 = ref object of OpenApiRestCall_579421
proc url_VisionProjectsLocationsProductsReferenceImagesList_580393(
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

proc validate_VisionProjectsLocationsProductsReferenceImagesList_580392(
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
  var valid_580394 = path.getOrDefault("parent")
  valid_580394 = validateParameter(valid_580394, JString, required = true,
                                 default = nil)
  if valid_580394 != nil:
    section.add "parent", valid_580394
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
  var valid_580395 = query.getOrDefault("upload_protocol")
  valid_580395 = validateParameter(valid_580395, JString, required = false,
                                 default = nil)
  if valid_580395 != nil:
    section.add "upload_protocol", valid_580395
  var valid_580396 = query.getOrDefault("fields")
  valid_580396 = validateParameter(valid_580396, JString, required = false,
                                 default = nil)
  if valid_580396 != nil:
    section.add "fields", valid_580396
  var valid_580397 = query.getOrDefault("pageToken")
  valid_580397 = validateParameter(valid_580397, JString, required = false,
                                 default = nil)
  if valid_580397 != nil:
    section.add "pageToken", valid_580397
  var valid_580398 = query.getOrDefault("quotaUser")
  valid_580398 = validateParameter(valid_580398, JString, required = false,
                                 default = nil)
  if valid_580398 != nil:
    section.add "quotaUser", valid_580398
  var valid_580399 = query.getOrDefault("alt")
  valid_580399 = validateParameter(valid_580399, JString, required = false,
                                 default = newJString("json"))
  if valid_580399 != nil:
    section.add "alt", valid_580399
  var valid_580400 = query.getOrDefault("oauth_token")
  valid_580400 = validateParameter(valid_580400, JString, required = false,
                                 default = nil)
  if valid_580400 != nil:
    section.add "oauth_token", valid_580400
  var valid_580401 = query.getOrDefault("callback")
  valid_580401 = validateParameter(valid_580401, JString, required = false,
                                 default = nil)
  if valid_580401 != nil:
    section.add "callback", valid_580401
  var valid_580402 = query.getOrDefault("access_token")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = nil)
  if valid_580402 != nil:
    section.add "access_token", valid_580402
  var valid_580403 = query.getOrDefault("uploadType")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = nil)
  if valid_580403 != nil:
    section.add "uploadType", valid_580403
  var valid_580404 = query.getOrDefault("key")
  valid_580404 = validateParameter(valid_580404, JString, required = false,
                                 default = nil)
  if valid_580404 != nil:
    section.add "key", valid_580404
  var valid_580405 = query.getOrDefault("$.xgafv")
  valid_580405 = validateParameter(valid_580405, JString, required = false,
                                 default = newJString("1"))
  if valid_580405 != nil:
    section.add "$.xgafv", valid_580405
  var valid_580406 = query.getOrDefault("pageSize")
  valid_580406 = validateParameter(valid_580406, JInt, required = false, default = nil)
  if valid_580406 != nil:
    section.add "pageSize", valid_580406
  var valid_580407 = query.getOrDefault("prettyPrint")
  valid_580407 = validateParameter(valid_580407, JBool, required = false,
                                 default = newJBool(true))
  if valid_580407 != nil:
    section.add "prettyPrint", valid_580407
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580408: Call_VisionProjectsLocationsProductsReferenceImagesList_580391;
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
  let valid = call_580408.validator(path, query, header, formData, body)
  let scheme = call_580408.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580408.url(scheme.get, call_580408.host, call_580408.base,
                         call_580408.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580408, url, valid)

proc call*(call_580409: Call_VisionProjectsLocationsProductsReferenceImagesList_580391;
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
  var path_580410 = newJObject()
  var query_580411 = newJObject()
  add(query_580411, "upload_protocol", newJString(uploadProtocol))
  add(query_580411, "fields", newJString(fields))
  add(query_580411, "pageToken", newJString(pageToken))
  add(query_580411, "quotaUser", newJString(quotaUser))
  add(query_580411, "alt", newJString(alt))
  add(query_580411, "oauth_token", newJString(oauthToken))
  add(query_580411, "callback", newJString(callback))
  add(query_580411, "access_token", newJString(accessToken))
  add(query_580411, "uploadType", newJString(uploadType))
  add(path_580410, "parent", newJString(parent))
  add(query_580411, "key", newJString(key))
  add(query_580411, "$.xgafv", newJString(Xgafv))
  add(query_580411, "pageSize", newJInt(pageSize))
  add(query_580411, "prettyPrint", newJBool(prettyPrint))
  result = call_580409.call(path_580410, query_580411, nil, nil, nil)

var visionProjectsLocationsProductsReferenceImagesList* = Call_VisionProjectsLocationsProductsReferenceImagesList_580391(
    name: "visionProjectsLocationsProductsReferenceImagesList",
    meth: HttpMethod.HttpGet, host: "vision.googleapis.com",
    route: "/v1/{parent}/referenceImages",
    validator: validate_VisionProjectsLocationsProductsReferenceImagesList_580392,
    base: "/", url: url_VisionProjectsLocationsProductsReferenceImagesList_580393,
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

proc authenticate*(fresh: float64 = -3600.0; lifetime: int = 3600): Future[bool] {.async.} =
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
