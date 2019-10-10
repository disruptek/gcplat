
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Vision
## version: v1p1beta1
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

  OpenApiRestCall_588450 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588450](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588450): Option[Scheme] {.used.} =
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
  Call_VisionFilesAnnotate_588719 = ref object of OpenApiRestCall_588450
proc url_VisionFilesAnnotate_588721(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_VisionFilesAnnotate_588720(path: JsonNode; query: JsonNode;
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
  var valid_588833 = query.getOrDefault("upload_protocol")
  valid_588833 = validateParameter(valid_588833, JString, required = false,
                                 default = nil)
  if valid_588833 != nil:
    section.add "upload_protocol", valid_588833
  var valid_588834 = query.getOrDefault("fields")
  valid_588834 = validateParameter(valid_588834, JString, required = false,
                                 default = nil)
  if valid_588834 != nil:
    section.add "fields", valid_588834
  var valid_588835 = query.getOrDefault("quotaUser")
  valid_588835 = validateParameter(valid_588835, JString, required = false,
                                 default = nil)
  if valid_588835 != nil:
    section.add "quotaUser", valid_588835
  var valid_588849 = query.getOrDefault("alt")
  valid_588849 = validateParameter(valid_588849, JString, required = false,
                                 default = newJString("json"))
  if valid_588849 != nil:
    section.add "alt", valid_588849
  var valid_588850 = query.getOrDefault("oauth_token")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = nil)
  if valid_588850 != nil:
    section.add "oauth_token", valid_588850
  var valid_588851 = query.getOrDefault("callback")
  valid_588851 = validateParameter(valid_588851, JString, required = false,
                                 default = nil)
  if valid_588851 != nil:
    section.add "callback", valid_588851
  var valid_588852 = query.getOrDefault("access_token")
  valid_588852 = validateParameter(valid_588852, JString, required = false,
                                 default = nil)
  if valid_588852 != nil:
    section.add "access_token", valid_588852
  var valid_588853 = query.getOrDefault("uploadType")
  valid_588853 = validateParameter(valid_588853, JString, required = false,
                                 default = nil)
  if valid_588853 != nil:
    section.add "uploadType", valid_588853
  var valid_588854 = query.getOrDefault("key")
  valid_588854 = validateParameter(valid_588854, JString, required = false,
                                 default = nil)
  if valid_588854 != nil:
    section.add "key", valid_588854
  var valid_588855 = query.getOrDefault("$.xgafv")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = newJString("1"))
  if valid_588855 != nil:
    section.add "$.xgafv", valid_588855
  var valid_588856 = query.getOrDefault("prettyPrint")
  valid_588856 = validateParameter(valid_588856, JBool, required = false,
                                 default = newJBool(true))
  if valid_588856 != nil:
    section.add "prettyPrint", valid_588856
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

proc call*(call_588880: Call_VisionFilesAnnotate_588719; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Service that performs image detection and annotation for a batch of files.
  ## Now only "application/pdf", "image/tiff" and "image/gif" are supported.
  ## 
  ## This service will extract at most 5 (customers can specify which 5 in
  ## AnnotateFileRequest.pages) frames (gif) or pages (pdf or tiff) from each
  ## file provided and perform detection and annotation for each image
  ## extracted.
  ## 
  let valid = call_588880.validator(path, query, header, formData, body)
  let scheme = call_588880.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588880.url(scheme.get, call_588880.host, call_588880.base,
                         call_588880.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588880, url, valid)

proc call*(call_588951: Call_VisionFilesAnnotate_588719;
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
  var query_588952 = newJObject()
  var body_588954 = newJObject()
  add(query_588952, "upload_protocol", newJString(uploadProtocol))
  add(query_588952, "fields", newJString(fields))
  add(query_588952, "quotaUser", newJString(quotaUser))
  add(query_588952, "alt", newJString(alt))
  add(query_588952, "oauth_token", newJString(oauthToken))
  add(query_588952, "callback", newJString(callback))
  add(query_588952, "access_token", newJString(accessToken))
  add(query_588952, "uploadType", newJString(uploadType))
  add(query_588952, "key", newJString(key))
  add(query_588952, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_588954 = body
  add(query_588952, "prettyPrint", newJBool(prettyPrint))
  result = call_588951.call(nil, query_588952, nil, nil, body_588954)

var visionFilesAnnotate* = Call_VisionFilesAnnotate_588719(
    name: "visionFilesAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1p1beta1/files:annotate",
    validator: validate_VisionFilesAnnotate_588720, base: "/",
    url: url_VisionFilesAnnotate_588721, schemes: {Scheme.Https})
type
  Call_VisionFilesAsyncBatchAnnotate_588993 = ref object of OpenApiRestCall_588450
proc url_VisionFilesAsyncBatchAnnotate_588995(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_VisionFilesAsyncBatchAnnotate_588994(path: JsonNode; query: JsonNode;
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
  var valid_588996 = query.getOrDefault("upload_protocol")
  valid_588996 = validateParameter(valid_588996, JString, required = false,
                                 default = nil)
  if valid_588996 != nil:
    section.add "upload_protocol", valid_588996
  var valid_588997 = query.getOrDefault("fields")
  valid_588997 = validateParameter(valid_588997, JString, required = false,
                                 default = nil)
  if valid_588997 != nil:
    section.add "fields", valid_588997
  var valid_588998 = query.getOrDefault("quotaUser")
  valid_588998 = validateParameter(valid_588998, JString, required = false,
                                 default = nil)
  if valid_588998 != nil:
    section.add "quotaUser", valid_588998
  var valid_588999 = query.getOrDefault("alt")
  valid_588999 = validateParameter(valid_588999, JString, required = false,
                                 default = newJString("json"))
  if valid_588999 != nil:
    section.add "alt", valid_588999
  var valid_589000 = query.getOrDefault("oauth_token")
  valid_589000 = validateParameter(valid_589000, JString, required = false,
                                 default = nil)
  if valid_589000 != nil:
    section.add "oauth_token", valid_589000
  var valid_589001 = query.getOrDefault("callback")
  valid_589001 = validateParameter(valid_589001, JString, required = false,
                                 default = nil)
  if valid_589001 != nil:
    section.add "callback", valid_589001
  var valid_589002 = query.getOrDefault("access_token")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = nil)
  if valid_589002 != nil:
    section.add "access_token", valid_589002
  var valid_589003 = query.getOrDefault("uploadType")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = nil)
  if valid_589003 != nil:
    section.add "uploadType", valid_589003
  var valid_589004 = query.getOrDefault("key")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "key", valid_589004
  var valid_589005 = query.getOrDefault("$.xgafv")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = newJString("1"))
  if valid_589005 != nil:
    section.add "$.xgafv", valid_589005
  var valid_589006 = query.getOrDefault("prettyPrint")
  valid_589006 = validateParameter(valid_589006, JBool, required = false,
                                 default = newJBool(true))
  if valid_589006 != nil:
    section.add "prettyPrint", valid_589006
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

proc call*(call_589008: Call_VisionFilesAsyncBatchAnnotate_588993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Run asynchronous image detection and annotation for a list of generic
  ## files, such as PDF files, which may contain multiple pages and multiple
  ## images per page. Progress and results can be retrieved through the
  ## `google.longrunning.Operations` interface.
  ## `Operation.metadata` contains `OperationMetadata` (metadata).
  ## `Operation.response` contains `AsyncBatchAnnotateFilesResponse` (results).
  ## 
  let valid = call_589008.validator(path, query, header, formData, body)
  let scheme = call_589008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589008.url(scheme.get, call_589008.host, call_589008.base,
                         call_589008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589008, url, valid)

proc call*(call_589009: Call_VisionFilesAsyncBatchAnnotate_588993;
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
  var query_589010 = newJObject()
  var body_589011 = newJObject()
  add(query_589010, "upload_protocol", newJString(uploadProtocol))
  add(query_589010, "fields", newJString(fields))
  add(query_589010, "quotaUser", newJString(quotaUser))
  add(query_589010, "alt", newJString(alt))
  add(query_589010, "oauth_token", newJString(oauthToken))
  add(query_589010, "callback", newJString(callback))
  add(query_589010, "access_token", newJString(accessToken))
  add(query_589010, "uploadType", newJString(uploadType))
  add(query_589010, "key", newJString(key))
  add(query_589010, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589011 = body
  add(query_589010, "prettyPrint", newJBool(prettyPrint))
  result = call_589009.call(nil, query_589010, nil, nil, body_589011)

var visionFilesAsyncBatchAnnotate* = Call_VisionFilesAsyncBatchAnnotate_588993(
    name: "visionFilesAsyncBatchAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1p1beta1/files:asyncBatchAnnotate",
    validator: validate_VisionFilesAsyncBatchAnnotate_588994, base: "/",
    url: url_VisionFilesAsyncBatchAnnotate_588995, schemes: {Scheme.Https})
type
  Call_VisionImagesAnnotate_589012 = ref object of OpenApiRestCall_588450
proc url_VisionImagesAnnotate_589014(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_VisionImagesAnnotate_589013(path: JsonNode; query: JsonNode;
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
  var valid_589015 = query.getOrDefault("upload_protocol")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "upload_protocol", valid_589015
  var valid_589016 = query.getOrDefault("fields")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "fields", valid_589016
  var valid_589017 = query.getOrDefault("quotaUser")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "quotaUser", valid_589017
  var valid_589018 = query.getOrDefault("alt")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = newJString("json"))
  if valid_589018 != nil:
    section.add "alt", valid_589018
  var valid_589019 = query.getOrDefault("oauth_token")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "oauth_token", valid_589019
  var valid_589020 = query.getOrDefault("callback")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = nil)
  if valid_589020 != nil:
    section.add "callback", valid_589020
  var valid_589021 = query.getOrDefault("access_token")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "access_token", valid_589021
  var valid_589022 = query.getOrDefault("uploadType")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "uploadType", valid_589022
  var valid_589023 = query.getOrDefault("key")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "key", valid_589023
  var valid_589024 = query.getOrDefault("$.xgafv")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = newJString("1"))
  if valid_589024 != nil:
    section.add "$.xgafv", valid_589024
  var valid_589025 = query.getOrDefault("prettyPrint")
  valid_589025 = validateParameter(valid_589025, JBool, required = false,
                                 default = newJBool(true))
  if valid_589025 != nil:
    section.add "prettyPrint", valid_589025
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

proc call*(call_589027: Call_VisionImagesAnnotate_589012; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Run image detection and annotation for a batch of images.
  ## 
  let valid = call_589027.validator(path, query, header, formData, body)
  let scheme = call_589027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589027.url(scheme.get, call_589027.host, call_589027.base,
                         call_589027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589027, url, valid)

proc call*(call_589028: Call_VisionImagesAnnotate_589012;
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
  var query_589029 = newJObject()
  var body_589030 = newJObject()
  add(query_589029, "upload_protocol", newJString(uploadProtocol))
  add(query_589029, "fields", newJString(fields))
  add(query_589029, "quotaUser", newJString(quotaUser))
  add(query_589029, "alt", newJString(alt))
  add(query_589029, "oauth_token", newJString(oauthToken))
  add(query_589029, "callback", newJString(callback))
  add(query_589029, "access_token", newJString(accessToken))
  add(query_589029, "uploadType", newJString(uploadType))
  add(query_589029, "key", newJString(key))
  add(query_589029, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589030 = body
  add(query_589029, "prettyPrint", newJBool(prettyPrint))
  result = call_589028.call(nil, query_589029, nil, nil, body_589030)

var visionImagesAnnotate* = Call_VisionImagesAnnotate_589012(
    name: "visionImagesAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1p1beta1/images:annotate",
    validator: validate_VisionImagesAnnotate_589013, base: "/",
    url: url_VisionImagesAnnotate_589014, schemes: {Scheme.Https})
type
  Call_VisionImagesAsyncBatchAnnotate_589031 = ref object of OpenApiRestCall_588450
proc url_VisionImagesAsyncBatchAnnotate_589033(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_VisionImagesAsyncBatchAnnotate_589032(path: JsonNode;
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
  var valid_589034 = query.getOrDefault("upload_protocol")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "upload_protocol", valid_589034
  var valid_589035 = query.getOrDefault("fields")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "fields", valid_589035
  var valid_589036 = query.getOrDefault("quotaUser")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "quotaUser", valid_589036
  var valid_589037 = query.getOrDefault("alt")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = newJString("json"))
  if valid_589037 != nil:
    section.add "alt", valid_589037
  var valid_589038 = query.getOrDefault("oauth_token")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "oauth_token", valid_589038
  var valid_589039 = query.getOrDefault("callback")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "callback", valid_589039
  var valid_589040 = query.getOrDefault("access_token")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "access_token", valid_589040
  var valid_589041 = query.getOrDefault("uploadType")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "uploadType", valid_589041
  var valid_589042 = query.getOrDefault("key")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "key", valid_589042
  var valid_589043 = query.getOrDefault("$.xgafv")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = newJString("1"))
  if valid_589043 != nil:
    section.add "$.xgafv", valid_589043
  var valid_589044 = query.getOrDefault("prettyPrint")
  valid_589044 = validateParameter(valid_589044, JBool, required = false,
                                 default = newJBool(true))
  if valid_589044 != nil:
    section.add "prettyPrint", valid_589044
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

proc call*(call_589046: Call_VisionImagesAsyncBatchAnnotate_589031; path: JsonNode;
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
  let valid = call_589046.validator(path, query, header, formData, body)
  let scheme = call_589046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589046.url(scheme.get, call_589046.host, call_589046.base,
                         call_589046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589046, url, valid)

proc call*(call_589047: Call_VisionImagesAsyncBatchAnnotate_589031;
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
  var query_589048 = newJObject()
  var body_589049 = newJObject()
  add(query_589048, "upload_protocol", newJString(uploadProtocol))
  add(query_589048, "fields", newJString(fields))
  add(query_589048, "quotaUser", newJString(quotaUser))
  add(query_589048, "alt", newJString(alt))
  add(query_589048, "oauth_token", newJString(oauthToken))
  add(query_589048, "callback", newJString(callback))
  add(query_589048, "access_token", newJString(accessToken))
  add(query_589048, "uploadType", newJString(uploadType))
  add(query_589048, "key", newJString(key))
  add(query_589048, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589049 = body
  add(query_589048, "prettyPrint", newJBool(prettyPrint))
  result = call_589047.call(nil, query_589048, nil, nil, body_589049)

var visionImagesAsyncBatchAnnotate* = Call_VisionImagesAsyncBatchAnnotate_589031(
    name: "visionImagesAsyncBatchAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1p1beta1/images:asyncBatchAnnotate",
    validator: validate_VisionImagesAsyncBatchAnnotate_589032, base: "/",
    url: url_VisionImagesAsyncBatchAnnotate_589033, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsFilesAnnotate_589050 = ref object of OpenApiRestCall_588450
proc url_VisionProjectsLocationsFilesAnnotate_589052(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1p1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/files:annotate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VisionProjectsLocationsFilesAnnotate_589051(path: JsonNode;
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
  var valid_589067 = path.getOrDefault("parent")
  valid_589067 = validateParameter(valid_589067, JString, required = true,
                                 default = nil)
  if valid_589067 != nil:
    section.add "parent", valid_589067
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
  var valid_589068 = query.getOrDefault("upload_protocol")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "upload_protocol", valid_589068
  var valid_589069 = query.getOrDefault("fields")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "fields", valid_589069
  var valid_589070 = query.getOrDefault("quotaUser")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "quotaUser", valid_589070
  var valid_589071 = query.getOrDefault("alt")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = newJString("json"))
  if valid_589071 != nil:
    section.add "alt", valid_589071
  var valid_589072 = query.getOrDefault("oauth_token")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "oauth_token", valid_589072
  var valid_589073 = query.getOrDefault("callback")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "callback", valid_589073
  var valid_589074 = query.getOrDefault("access_token")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "access_token", valid_589074
  var valid_589075 = query.getOrDefault("uploadType")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "uploadType", valid_589075
  var valid_589076 = query.getOrDefault("key")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "key", valid_589076
  var valid_589077 = query.getOrDefault("$.xgafv")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = newJString("1"))
  if valid_589077 != nil:
    section.add "$.xgafv", valid_589077
  var valid_589078 = query.getOrDefault("prettyPrint")
  valid_589078 = validateParameter(valid_589078, JBool, required = false,
                                 default = newJBool(true))
  if valid_589078 != nil:
    section.add "prettyPrint", valid_589078
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

proc call*(call_589080: Call_VisionProjectsLocationsFilesAnnotate_589050;
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
  let valid = call_589080.validator(path, query, header, formData, body)
  let scheme = call_589080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589080.url(scheme.get, call_589080.host, call_589080.base,
                         call_589080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589080, url, valid)

proc call*(call_589081: Call_VisionProjectsLocationsFilesAnnotate_589050;
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
  var path_589082 = newJObject()
  var query_589083 = newJObject()
  var body_589084 = newJObject()
  add(query_589083, "upload_protocol", newJString(uploadProtocol))
  add(query_589083, "fields", newJString(fields))
  add(query_589083, "quotaUser", newJString(quotaUser))
  add(query_589083, "alt", newJString(alt))
  add(query_589083, "oauth_token", newJString(oauthToken))
  add(query_589083, "callback", newJString(callback))
  add(query_589083, "access_token", newJString(accessToken))
  add(query_589083, "uploadType", newJString(uploadType))
  add(path_589082, "parent", newJString(parent))
  add(query_589083, "key", newJString(key))
  add(query_589083, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589084 = body
  add(query_589083, "prettyPrint", newJBool(prettyPrint))
  result = call_589081.call(path_589082, query_589083, nil, nil, body_589084)

var visionProjectsLocationsFilesAnnotate* = Call_VisionProjectsLocationsFilesAnnotate_589050(
    name: "visionProjectsLocationsFilesAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1p1beta1/{parent}/files:annotate",
    validator: validate_VisionProjectsLocationsFilesAnnotate_589051, base: "/",
    url: url_VisionProjectsLocationsFilesAnnotate_589052, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsFilesAsyncBatchAnnotate_589085 = ref object of OpenApiRestCall_588450
proc url_VisionProjectsLocationsFilesAsyncBatchAnnotate_589087(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1p1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/files:asyncBatchAnnotate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VisionProjectsLocationsFilesAsyncBatchAnnotate_589086(
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
  var valid_589088 = path.getOrDefault("parent")
  valid_589088 = validateParameter(valid_589088, JString, required = true,
                                 default = nil)
  if valid_589088 != nil:
    section.add "parent", valid_589088
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
  var valid_589089 = query.getOrDefault("upload_protocol")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "upload_protocol", valid_589089
  var valid_589090 = query.getOrDefault("fields")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "fields", valid_589090
  var valid_589091 = query.getOrDefault("quotaUser")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "quotaUser", valid_589091
  var valid_589092 = query.getOrDefault("alt")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = newJString("json"))
  if valid_589092 != nil:
    section.add "alt", valid_589092
  var valid_589093 = query.getOrDefault("oauth_token")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "oauth_token", valid_589093
  var valid_589094 = query.getOrDefault("callback")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "callback", valid_589094
  var valid_589095 = query.getOrDefault("access_token")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "access_token", valid_589095
  var valid_589096 = query.getOrDefault("uploadType")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "uploadType", valid_589096
  var valid_589097 = query.getOrDefault("key")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "key", valid_589097
  var valid_589098 = query.getOrDefault("$.xgafv")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = newJString("1"))
  if valid_589098 != nil:
    section.add "$.xgafv", valid_589098
  var valid_589099 = query.getOrDefault("prettyPrint")
  valid_589099 = validateParameter(valid_589099, JBool, required = false,
                                 default = newJBool(true))
  if valid_589099 != nil:
    section.add "prettyPrint", valid_589099
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

proc call*(call_589101: Call_VisionProjectsLocationsFilesAsyncBatchAnnotate_589085;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Run asynchronous image detection and annotation for a list of generic
  ## files, such as PDF files, which may contain multiple pages and multiple
  ## images per page. Progress and results can be retrieved through the
  ## `google.longrunning.Operations` interface.
  ## `Operation.metadata` contains `OperationMetadata` (metadata).
  ## `Operation.response` contains `AsyncBatchAnnotateFilesResponse` (results).
  ## 
  let valid = call_589101.validator(path, query, header, formData, body)
  let scheme = call_589101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589101.url(scheme.get, call_589101.host, call_589101.base,
                         call_589101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589101, url, valid)

proc call*(call_589102: Call_VisionProjectsLocationsFilesAsyncBatchAnnotate_589085;
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
  var path_589103 = newJObject()
  var query_589104 = newJObject()
  var body_589105 = newJObject()
  add(query_589104, "upload_protocol", newJString(uploadProtocol))
  add(query_589104, "fields", newJString(fields))
  add(query_589104, "quotaUser", newJString(quotaUser))
  add(query_589104, "alt", newJString(alt))
  add(query_589104, "oauth_token", newJString(oauthToken))
  add(query_589104, "callback", newJString(callback))
  add(query_589104, "access_token", newJString(accessToken))
  add(query_589104, "uploadType", newJString(uploadType))
  add(path_589103, "parent", newJString(parent))
  add(query_589104, "key", newJString(key))
  add(query_589104, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589105 = body
  add(query_589104, "prettyPrint", newJBool(prettyPrint))
  result = call_589102.call(path_589103, query_589104, nil, nil, body_589105)

var visionProjectsLocationsFilesAsyncBatchAnnotate* = Call_VisionProjectsLocationsFilesAsyncBatchAnnotate_589085(
    name: "visionProjectsLocationsFilesAsyncBatchAnnotate",
    meth: HttpMethod.HttpPost, host: "vision.googleapis.com",
    route: "/v1p1beta1/{parent}/files:asyncBatchAnnotate",
    validator: validate_VisionProjectsLocationsFilesAsyncBatchAnnotate_589086,
    base: "/", url: url_VisionProjectsLocationsFilesAsyncBatchAnnotate_589087,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsImagesAnnotate_589106 = ref object of OpenApiRestCall_588450
proc url_VisionProjectsLocationsImagesAnnotate_589108(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1p1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/images:annotate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VisionProjectsLocationsImagesAnnotate_589107(path: JsonNode;
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
  var valid_589109 = path.getOrDefault("parent")
  valid_589109 = validateParameter(valid_589109, JString, required = true,
                                 default = nil)
  if valid_589109 != nil:
    section.add "parent", valid_589109
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
  var valid_589110 = query.getOrDefault("upload_protocol")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "upload_protocol", valid_589110
  var valid_589111 = query.getOrDefault("fields")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "fields", valid_589111
  var valid_589112 = query.getOrDefault("quotaUser")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "quotaUser", valid_589112
  var valid_589113 = query.getOrDefault("alt")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = newJString("json"))
  if valid_589113 != nil:
    section.add "alt", valid_589113
  var valid_589114 = query.getOrDefault("oauth_token")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "oauth_token", valid_589114
  var valid_589115 = query.getOrDefault("callback")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "callback", valid_589115
  var valid_589116 = query.getOrDefault("access_token")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "access_token", valid_589116
  var valid_589117 = query.getOrDefault("uploadType")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "uploadType", valid_589117
  var valid_589118 = query.getOrDefault("key")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "key", valid_589118
  var valid_589119 = query.getOrDefault("$.xgafv")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = newJString("1"))
  if valid_589119 != nil:
    section.add "$.xgafv", valid_589119
  var valid_589120 = query.getOrDefault("prettyPrint")
  valid_589120 = validateParameter(valid_589120, JBool, required = false,
                                 default = newJBool(true))
  if valid_589120 != nil:
    section.add "prettyPrint", valid_589120
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

proc call*(call_589122: Call_VisionProjectsLocationsImagesAnnotate_589106;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Run image detection and annotation for a batch of images.
  ## 
  let valid = call_589122.validator(path, query, header, formData, body)
  let scheme = call_589122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589122.url(scheme.get, call_589122.host, call_589122.base,
                         call_589122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589122, url, valid)

proc call*(call_589123: Call_VisionProjectsLocationsImagesAnnotate_589106;
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
  var path_589124 = newJObject()
  var query_589125 = newJObject()
  var body_589126 = newJObject()
  add(query_589125, "upload_protocol", newJString(uploadProtocol))
  add(query_589125, "fields", newJString(fields))
  add(query_589125, "quotaUser", newJString(quotaUser))
  add(query_589125, "alt", newJString(alt))
  add(query_589125, "oauth_token", newJString(oauthToken))
  add(query_589125, "callback", newJString(callback))
  add(query_589125, "access_token", newJString(accessToken))
  add(query_589125, "uploadType", newJString(uploadType))
  add(path_589124, "parent", newJString(parent))
  add(query_589125, "key", newJString(key))
  add(query_589125, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589126 = body
  add(query_589125, "prettyPrint", newJBool(prettyPrint))
  result = call_589123.call(path_589124, query_589125, nil, nil, body_589126)

var visionProjectsLocationsImagesAnnotate* = Call_VisionProjectsLocationsImagesAnnotate_589106(
    name: "visionProjectsLocationsImagesAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1p1beta1/{parent}/images:annotate",
    validator: validate_VisionProjectsLocationsImagesAnnotate_589107, base: "/",
    url: url_VisionProjectsLocationsImagesAnnotate_589108, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsImagesAsyncBatchAnnotate_589127 = ref object of OpenApiRestCall_588450
proc url_VisionProjectsLocationsImagesAsyncBatchAnnotate_589129(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1p1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/images:asyncBatchAnnotate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VisionProjectsLocationsImagesAsyncBatchAnnotate_589128(
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
  var valid_589130 = path.getOrDefault("parent")
  valid_589130 = validateParameter(valid_589130, JString, required = true,
                                 default = nil)
  if valid_589130 != nil:
    section.add "parent", valid_589130
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
  var valid_589131 = query.getOrDefault("upload_protocol")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "upload_protocol", valid_589131
  var valid_589132 = query.getOrDefault("fields")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "fields", valid_589132
  var valid_589133 = query.getOrDefault("quotaUser")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "quotaUser", valid_589133
  var valid_589134 = query.getOrDefault("alt")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = newJString("json"))
  if valid_589134 != nil:
    section.add "alt", valid_589134
  var valid_589135 = query.getOrDefault("oauth_token")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "oauth_token", valid_589135
  var valid_589136 = query.getOrDefault("callback")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "callback", valid_589136
  var valid_589137 = query.getOrDefault("access_token")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "access_token", valid_589137
  var valid_589138 = query.getOrDefault("uploadType")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "uploadType", valid_589138
  var valid_589139 = query.getOrDefault("key")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "key", valid_589139
  var valid_589140 = query.getOrDefault("$.xgafv")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = newJString("1"))
  if valid_589140 != nil:
    section.add "$.xgafv", valid_589140
  var valid_589141 = query.getOrDefault("prettyPrint")
  valid_589141 = validateParameter(valid_589141, JBool, required = false,
                                 default = newJBool(true))
  if valid_589141 != nil:
    section.add "prettyPrint", valid_589141
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

proc call*(call_589143: Call_VisionProjectsLocationsImagesAsyncBatchAnnotate_589127;
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
  let valid = call_589143.validator(path, query, header, formData, body)
  let scheme = call_589143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589143.url(scheme.get, call_589143.host, call_589143.base,
                         call_589143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589143, url, valid)

proc call*(call_589144: Call_VisionProjectsLocationsImagesAsyncBatchAnnotate_589127;
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
  var path_589145 = newJObject()
  var query_589146 = newJObject()
  var body_589147 = newJObject()
  add(query_589146, "upload_protocol", newJString(uploadProtocol))
  add(query_589146, "fields", newJString(fields))
  add(query_589146, "quotaUser", newJString(quotaUser))
  add(query_589146, "alt", newJString(alt))
  add(query_589146, "oauth_token", newJString(oauthToken))
  add(query_589146, "callback", newJString(callback))
  add(query_589146, "access_token", newJString(accessToken))
  add(query_589146, "uploadType", newJString(uploadType))
  add(path_589145, "parent", newJString(parent))
  add(query_589146, "key", newJString(key))
  add(query_589146, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589147 = body
  add(query_589146, "prettyPrint", newJBool(prettyPrint))
  result = call_589144.call(path_589145, query_589146, nil, nil, body_589147)

var visionProjectsLocationsImagesAsyncBatchAnnotate* = Call_VisionProjectsLocationsImagesAsyncBatchAnnotate_589127(
    name: "visionProjectsLocationsImagesAsyncBatchAnnotate",
    meth: HttpMethod.HttpPost, host: "vision.googleapis.com",
    route: "/v1p1beta1/{parent}/images:asyncBatchAnnotate",
    validator: validate_VisionProjectsLocationsImagesAsyncBatchAnnotate_589128,
    base: "/", url: url_VisionProjectsLocationsImagesAsyncBatchAnnotate_589129,
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
