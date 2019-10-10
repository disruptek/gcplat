
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
    host: "vision.googleapis.com", route: "/v1/files:annotate",
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
    host: "vision.googleapis.com", route: "/v1/files:asyncBatchAnnotate",
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
    host: "vision.googleapis.com", route: "/v1/images:annotate",
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
    host: "vision.googleapis.com", route: "/v1/images:asyncBatchAnnotate",
    validator: validate_VisionImagesAsyncBatchAnnotate_589032, base: "/",
    url: url_VisionImagesAsyncBatchAnnotate_589033, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsGet_589050 = ref object of OpenApiRestCall_588450
proc url_VisionProjectsLocationsProductSetsGet_589052(protocol: Scheme;
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

proc validate_VisionProjectsLocationsProductSetsGet_589051(path: JsonNode;
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
  var valid_589067 = path.getOrDefault("name")
  valid_589067 = validateParameter(valid_589067, JString, required = true,
                                 default = nil)
  if valid_589067 != nil:
    section.add "name", valid_589067
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
  if body != nil:
    result.add "body", body

proc call*(call_589079: Call_VisionProjectsLocationsProductSetsGet_589050;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information associated with a ProductSet.
  ## 
  ## Possible errors:
  ## 
  ## * Returns NOT_FOUND if the ProductSet does not exist.
  ## 
  let valid = call_589079.validator(path, query, header, formData, body)
  let scheme = call_589079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589079.url(scheme.get, call_589079.host, call_589079.base,
                         call_589079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589079, url, valid)

proc call*(call_589080: Call_VisionProjectsLocationsProductSetsGet_589050;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## visionProjectsLocationsProductSetsGet
  ## Gets information associated with a ProductSet.
  ## 
  ## Possible errors:
  ## 
  ## * Returns NOT_FOUND if the ProductSet does not exist.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. Resource name of the ProductSet to get.
  ## 
  ## Format is:
  ## `projects/PROJECT_ID/locations/LOG_ID/productSets/PRODUCT_SET_ID`
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
  var path_589081 = newJObject()
  var query_589082 = newJObject()
  add(query_589082, "upload_protocol", newJString(uploadProtocol))
  add(query_589082, "fields", newJString(fields))
  add(query_589082, "quotaUser", newJString(quotaUser))
  add(path_589081, "name", newJString(name))
  add(query_589082, "alt", newJString(alt))
  add(query_589082, "oauth_token", newJString(oauthToken))
  add(query_589082, "callback", newJString(callback))
  add(query_589082, "access_token", newJString(accessToken))
  add(query_589082, "uploadType", newJString(uploadType))
  add(query_589082, "key", newJString(key))
  add(query_589082, "$.xgafv", newJString(Xgafv))
  add(query_589082, "prettyPrint", newJBool(prettyPrint))
  result = call_589080.call(path_589081, query_589082, nil, nil, nil)

var visionProjectsLocationsProductSetsGet* = Call_VisionProjectsLocationsProductSetsGet_589050(
    name: "visionProjectsLocationsProductSetsGet", meth: HttpMethod.HttpGet,
    host: "vision.googleapis.com", route: "/v1/{name}",
    validator: validate_VisionProjectsLocationsProductSetsGet_589051, base: "/",
    url: url_VisionProjectsLocationsProductSetsGet_589052, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsPatch_589102 = ref object of OpenApiRestCall_588450
proc url_VisionProjectsLocationsProductSetsPatch_589104(protocol: Scheme;
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

proc validate_VisionProjectsLocationsProductSetsPatch_589103(path: JsonNode;
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
  var valid_589105 = path.getOrDefault("name")
  valid_589105 = validateParameter(valid_589105, JString, required = true,
                                 default = nil)
  if valid_589105 != nil:
    section.add "name", valid_589105
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
  var valid_589106 = query.getOrDefault("upload_protocol")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "upload_protocol", valid_589106
  var valid_589107 = query.getOrDefault("fields")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "fields", valid_589107
  var valid_589108 = query.getOrDefault("quotaUser")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "quotaUser", valid_589108
  var valid_589109 = query.getOrDefault("alt")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = newJString("json"))
  if valid_589109 != nil:
    section.add "alt", valid_589109
  var valid_589110 = query.getOrDefault("oauth_token")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "oauth_token", valid_589110
  var valid_589111 = query.getOrDefault("callback")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "callback", valid_589111
  var valid_589112 = query.getOrDefault("access_token")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "access_token", valid_589112
  var valid_589113 = query.getOrDefault("uploadType")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "uploadType", valid_589113
  var valid_589114 = query.getOrDefault("key")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "key", valid_589114
  var valid_589115 = query.getOrDefault("$.xgafv")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = newJString("1"))
  if valid_589115 != nil:
    section.add "$.xgafv", valid_589115
  var valid_589116 = query.getOrDefault("prettyPrint")
  valid_589116 = validateParameter(valid_589116, JBool, required = false,
                                 default = newJBool(true))
  if valid_589116 != nil:
    section.add "prettyPrint", valid_589116
  var valid_589117 = query.getOrDefault("updateMask")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "updateMask", valid_589117
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

proc call*(call_589119: Call_VisionProjectsLocationsProductSetsPatch_589102;
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
  let valid = call_589119.validator(path, query, header, formData, body)
  let scheme = call_589119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589119.url(scheme.get, call_589119.host, call_589119.base,
                         call_589119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589119, url, valid)

proc call*(call_589120: Call_VisionProjectsLocationsProductSetsPatch_589102;
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
  var path_589121 = newJObject()
  var query_589122 = newJObject()
  var body_589123 = newJObject()
  add(query_589122, "upload_protocol", newJString(uploadProtocol))
  add(query_589122, "fields", newJString(fields))
  add(query_589122, "quotaUser", newJString(quotaUser))
  add(path_589121, "name", newJString(name))
  add(query_589122, "alt", newJString(alt))
  add(query_589122, "oauth_token", newJString(oauthToken))
  add(query_589122, "callback", newJString(callback))
  add(query_589122, "access_token", newJString(accessToken))
  add(query_589122, "uploadType", newJString(uploadType))
  add(query_589122, "key", newJString(key))
  add(query_589122, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589123 = body
  add(query_589122, "prettyPrint", newJBool(prettyPrint))
  add(query_589122, "updateMask", newJString(updateMask))
  result = call_589120.call(path_589121, query_589122, nil, nil, body_589123)

var visionProjectsLocationsProductSetsPatch* = Call_VisionProjectsLocationsProductSetsPatch_589102(
    name: "visionProjectsLocationsProductSetsPatch", meth: HttpMethod.HttpPatch,
    host: "vision.googleapis.com", route: "/v1/{name}",
    validator: validate_VisionProjectsLocationsProductSetsPatch_589103, base: "/",
    url: url_VisionProjectsLocationsProductSetsPatch_589104,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsDelete_589083 = ref object of OpenApiRestCall_588450
proc url_VisionProjectsLocationsProductSetsDelete_589085(protocol: Scheme;
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

proc validate_VisionProjectsLocationsProductSetsDelete_589084(path: JsonNode;
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
  var valid_589086 = path.getOrDefault("name")
  valid_589086 = validateParameter(valid_589086, JString, required = true,
                                 default = nil)
  if valid_589086 != nil:
    section.add "name", valid_589086
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
  var valid_589087 = query.getOrDefault("upload_protocol")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "upload_protocol", valid_589087
  var valid_589088 = query.getOrDefault("fields")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "fields", valid_589088
  var valid_589089 = query.getOrDefault("quotaUser")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "quotaUser", valid_589089
  var valid_589090 = query.getOrDefault("alt")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = newJString("json"))
  if valid_589090 != nil:
    section.add "alt", valid_589090
  var valid_589091 = query.getOrDefault("oauth_token")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "oauth_token", valid_589091
  var valid_589092 = query.getOrDefault("callback")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "callback", valid_589092
  var valid_589093 = query.getOrDefault("access_token")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "access_token", valid_589093
  var valid_589094 = query.getOrDefault("uploadType")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "uploadType", valid_589094
  var valid_589095 = query.getOrDefault("key")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "key", valid_589095
  var valid_589096 = query.getOrDefault("$.xgafv")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = newJString("1"))
  if valid_589096 != nil:
    section.add "$.xgafv", valid_589096
  var valid_589097 = query.getOrDefault("prettyPrint")
  valid_589097 = validateParameter(valid_589097, JBool, required = false,
                                 default = newJBool(true))
  if valid_589097 != nil:
    section.add "prettyPrint", valid_589097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589098: Call_VisionProjectsLocationsProductSetsDelete_589083;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently deletes a ProductSet. Products and ReferenceImages in the
  ## ProductSet are not deleted.
  ## 
  ## The actual image files are not deleted from Google Cloud Storage.
  ## 
  let valid = call_589098.validator(path, query, header, formData, body)
  let scheme = call_589098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589098.url(scheme.get, call_589098.host, call_589098.base,
                         call_589098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589098, url, valid)

proc call*(call_589099: Call_VisionProjectsLocationsProductSetsDelete_589083;
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
  var path_589100 = newJObject()
  var query_589101 = newJObject()
  add(query_589101, "upload_protocol", newJString(uploadProtocol))
  add(query_589101, "fields", newJString(fields))
  add(query_589101, "quotaUser", newJString(quotaUser))
  add(path_589100, "name", newJString(name))
  add(query_589101, "alt", newJString(alt))
  add(query_589101, "oauth_token", newJString(oauthToken))
  add(query_589101, "callback", newJString(callback))
  add(query_589101, "access_token", newJString(accessToken))
  add(query_589101, "uploadType", newJString(uploadType))
  add(query_589101, "key", newJString(key))
  add(query_589101, "$.xgafv", newJString(Xgafv))
  add(query_589101, "prettyPrint", newJBool(prettyPrint))
  result = call_589099.call(path_589100, query_589101, nil, nil, nil)

var visionProjectsLocationsProductSetsDelete* = Call_VisionProjectsLocationsProductSetsDelete_589083(
    name: "visionProjectsLocationsProductSetsDelete", meth: HttpMethod.HttpDelete,
    host: "vision.googleapis.com", route: "/v1/{name}",
    validator: validate_VisionProjectsLocationsProductSetsDelete_589084,
    base: "/", url: url_VisionProjectsLocationsProductSetsDelete_589085,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsProductsList_589124 = ref object of OpenApiRestCall_588450
proc url_VisionProjectsLocationsProductSetsProductsList_589126(protocol: Scheme;
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

proc validate_VisionProjectsLocationsProductSetsProductsList_589125(
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
  var valid_589127 = path.getOrDefault("name")
  valid_589127 = validateParameter(valid_589127, JString, required = true,
                                 default = nil)
  if valid_589127 != nil:
    section.add "name", valid_589127
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
  var valid_589128 = query.getOrDefault("upload_protocol")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "upload_protocol", valid_589128
  var valid_589129 = query.getOrDefault("fields")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "fields", valid_589129
  var valid_589130 = query.getOrDefault("pageToken")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "pageToken", valid_589130
  var valid_589131 = query.getOrDefault("quotaUser")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "quotaUser", valid_589131
  var valid_589132 = query.getOrDefault("alt")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = newJString("json"))
  if valid_589132 != nil:
    section.add "alt", valid_589132
  var valid_589133 = query.getOrDefault("oauth_token")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "oauth_token", valid_589133
  var valid_589134 = query.getOrDefault("callback")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "callback", valid_589134
  var valid_589135 = query.getOrDefault("access_token")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "access_token", valid_589135
  var valid_589136 = query.getOrDefault("uploadType")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "uploadType", valid_589136
  var valid_589137 = query.getOrDefault("key")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "key", valid_589137
  var valid_589138 = query.getOrDefault("$.xgafv")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = newJString("1"))
  if valid_589138 != nil:
    section.add "$.xgafv", valid_589138
  var valid_589139 = query.getOrDefault("pageSize")
  valid_589139 = validateParameter(valid_589139, JInt, required = false, default = nil)
  if valid_589139 != nil:
    section.add "pageSize", valid_589139
  var valid_589140 = query.getOrDefault("prettyPrint")
  valid_589140 = validateParameter(valid_589140, JBool, required = false,
                                 default = newJBool(true))
  if valid_589140 != nil:
    section.add "prettyPrint", valid_589140
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589141: Call_VisionProjectsLocationsProductSetsProductsList_589124;
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
  let valid = call_589141.validator(path, query, header, formData, body)
  let scheme = call_589141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589141.url(scheme.get, call_589141.host, call_589141.base,
                         call_589141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589141, url, valid)

proc call*(call_589142: Call_VisionProjectsLocationsProductSetsProductsList_589124;
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
  var path_589143 = newJObject()
  var query_589144 = newJObject()
  add(query_589144, "upload_protocol", newJString(uploadProtocol))
  add(query_589144, "fields", newJString(fields))
  add(query_589144, "pageToken", newJString(pageToken))
  add(query_589144, "quotaUser", newJString(quotaUser))
  add(path_589143, "name", newJString(name))
  add(query_589144, "alt", newJString(alt))
  add(query_589144, "oauth_token", newJString(oauthToken))
  add(query_589144, "callback", newJString(callback))
  add(query_589144, "access_token", newJString(accessToken))
  add(query_589144, "uploadType", newJString(uploadType))
  add(query_589144, "key", newJString(key))
  add(query_589144, "$.xgafv", newJString(Xgafv))
  add(query_589144, "pageSize", newJInt(pageSize))
  add(query_589144, "prettyPrint", newJBool(prettyPrint))
  result = call_589142.call(path_589143, query_589144, nil, nil, nil)

var visionProjectsLocationsProductSetsProductsList* = Call_VisionProjectsLocationsProductSetsProductsList_589124(
    name: "visionProjectsLocationsProductSetsProductsList",
    meth: HttpMethod.HttpGet, host: "vision.googleapis.com",
    route: "/v1/{name}/products",
    validator: validate_VisionProjectsLocationsProductSetsProductsList_589125,
    base: "/", url: url_VisionProjectsLocationsProductSetsProductsList_589126,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsAddProduct_589145 = ref object of OpenApiRestCall_588450
proc url_VisionProjectsLocationsProductSetsAddProduct_589147(protocol: Scheme;
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

proc validate_VisionProjectsLocationsProductSetsAddProduct_589146(path: JsonNode;
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
  var valid_589148 = path.getOrDefault("name")
  valid_589148 = validateParameter(valid_589148, JString, required = true,
                                 default = nil)
  if valid_589148 != nil:
    section.add "name", valid_589148
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
  var valid_589149 = query.getOrDefault("upload_protocol")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = nil)
  if valid_589149 != nil:
    section.add "upload_protocol", valid_589149
  var valid_589150 = query.getOrDefault("fields")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "fields", valid_589150
  var valid_589151 = query.getOrDefault("quotaUser")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "quotaUser", valid_589151
  var valid_589152 = query.getOrDefault("alt")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = newJString("json"))
  if valid_589152 != nil:
    section.add "alt", valid_589152
  var valid_589153 = query.getOrDefault("oauth_token")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "oauth_token", valid_589153
  var valid_589154 = query.getOrDefault("callback")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "callback", valid_589154
  var valid_589155 = query.getOrDefault("access_token")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "access_token", valid_589155
  var valid_589156 = query.getOrDefault("uploadType")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "uploadType", valid_589156
  var valid_589157 = query.getOrDefault("key")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "key", valid_589157
  var valid_589158 = query.getOrDefault("$.xgafv")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = newJString("1"))
  if valid_589158 != nil:
    section.add "$.xgafv", valid_589158
  var valid_589159 = query.getOrDefault("prettyPrint")
  valid_589159 = validateParameter(valid_589159, JBool, required = false,
                                 default = newJBool(true))
  if valid_589159 != nil:
    section.add "prettyPrint", valid_589159
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

proc call*(call_589161: Call_VisionProjectsLocationsProductSetsAddProduct_589145;
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
  let valid = call_589161.validator(path, query, header, formData, body)
  let scheme = call_589161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589161.url(scheme.get, call_589161.host, call_589161.base,
                         call_589161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589161, url, valid)

proc call*(call_589162: Call_VisionProjectsLocationsProductSetsAddProduct_589145;
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
  var path_589163 = newJObject()
  var query_589164 = newJObject()
  var body_589165 = newJObject()
  add(query_589164, "upload_protocol", newJString(uploadProtocol))
  add(query_589164, "fields", newJString(fields))
  add(query_589164, "quotaUser", newJString(quotaUser))
  add(path_589163, "name", newJString(name))
  add(query_589164, "alt", newJString(alt))
  add(query_589164, "oauth_token", newJString(oauthToken))
  add(query_589164, "callback", newJString(callback))
  add(query_589164, "access_token", newJString(accessToken))
  add(query_589164, "uploadType", newJString(uploadType))
  add(query_589164, "key", newJString(key))
  add(query_589164, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589165 = body
  add(query_589164, "prettyPrint", newJBool(prettyPrint))
  result = call_589162.call(path_589163, query_589164, nil, nil, body_589165)

var visionProjectsLocationsProductSetsAddProduct* = Call_VisionProjectsLocationsProductSetsAddProduct_589145(
    name: "visionProjectsLocationsProductSetsAddProduct",
    meth: HttpMethod.HttpPost, host: "vision.googleapis.com",
    route: "/v1/{name}:addProduct",
    validator: validate_VisionProjectsLocationsProductSetsAddProduct_589146,
    base: "/", url: url_VisionProjectsLocationsProductSetsAddProduct_589147,
    schemes: {Scheme.Https})
type
  Call_VisionOperationsCancel_589166 = ref object of OpenApiRestCall_588450
proc url_VisionOperationsCancel_589168(protocol: Scheme; host: string; base: string;
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

proc validate_VisionOperationsCancel_589167(path: JsonNode; query: JsonNode;
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
  var valid_589169 = path.getOrDefault("name")
  valid_589169 = validateParameter(valid_589169, JString, required = true,
                                 default = nil)
  if valid_589169 != nil:
    section.add "name", valid_589169
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
  var valid_589170 = query.getOrDefault("upload_protocol")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = nil)
  if valid_589170 != nil:
    section.add "upload_protocol", valid_589170
  var valid_589171 = query.getOrDefault("fields")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "fields", valid_589171
  var valid_589172 = query.getOrDefault("quotaUser")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "quotaUser", valid_589172
  var valid_589173 = query.getOrDefault("alt")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = newJString("json"))
  if valid_589173 != nil:
    section.add "alt", valid_589173
  var valid_589174 = query.getOrDefault("oauth_token")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "oauth_token", valid_589174
  var valid_589175 = query.getOrDefault("callback")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "callback", valid_589175
  var valid_589176 = query.getOrDefault("access_token")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "access_token", valid_589176
  var valid_589177 = query.getOrDefault("uploadType")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "uploadType", valid_589177
  var valid_589178 = query.getOrDefault("key")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "key", valid_589178
  var valid_589179 = query.getOrDefault("$.xgafv")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = newJString("1"))
  if valid_589179 != nil:
    section.add "$.xgafv", valid_589179
  var valid_589180 = query.getOrDefault("prettyPrint")
  valid_589180 = validateParameter(valid_589180, JBool, required = false,
                                 default = newJBool(true))
  if valid_589180 != nil:
    section.add "prettyPrint", valid_589180
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

proc call*(call_589182: Call_VisionOperationsCancel_589166; path: JsonNode;
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
  let valid = call_589182.validator(path, query, header, formData, body)
  let scheme = call_589182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589182.url(scheme.get, call_589182.host, call_589182.base,
                         call_589182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589182, url, valid)

proc call*(call_589183: Call_VisionOperationsCancel_589166; name: string;
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
  var path_589184 = newJObject()
  var query_589185 = newJObject()
  var body_589186 = newJObject()
  add(query_589185, "upload_protocol", newJString(uploadProtocol))
  add(query_589185, "fields", newJString(fields))
  add(query_589185, "quotaUser", newJString(quotaUser))
  add(path_589184, "name", newJString(name))
  add(query_589185, "alt", newJString(alt))
  add(query_589185, "oauth_token", newJString(oauthToken))
  add(query_589185, "callback", newJString(callback))
  add(query_589185, "access_token", newJString(accessToken))
  add(query_589185, "uploadType", newJString(uploadType))
  add(query_589185, "key", newJString(key))
  add(query_589185, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589186 = body
  add(query_589185, "prettyPrint", newJBool(prettyPrint))
  result = call_589183.call(path_589184, query_589185, nil, nil, body_589186)

var visionOperationsCancel* = Call_VisionOperationsCancel_589166(
    name: "visionOperationsCancel", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_VisionOperationsCancel_589167, base: "/",
    url: url_VisionOperationsCancel_589168, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsRemoveProduct_589187 = ref object of OpenApiRestCall_588450
proc url_VisionProjectsLocationsProductSetsRemoveProduct_589189(protocol: Scheme;
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

proc validate_VisionProjectsLocationsProductSetsRemoveProduct_589188(
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
  var valid_589190 = path.getOrDefault("name")
  valid_589190 = validateParameter(valid_589190, JString, required = true,
                                 default = nil)
  if valid_589190 != nil:
    section.add "name", valid_589190
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
  var valid_589191 = query.getOrDefault("upload_protocol")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = nil)
  if valid_589191 != nil:
    section.add "upload_protocol", valid_589191
  var valid_589192 = query.getOrDefault("fields")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "fields", valid_589192
  var valid_589193 = query.getOrDefault("quotaUser")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "quotaUser", valid_589193
  var valid_589194 = query.getOrDefault("alt")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = newJString("json"))
  if valid_589194 != nil:
    section.add "alt", valid_589194
  var valid_589195 = query.getOrDefault("oauth_token")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "oauth_token", valid_589195
  var valid_589196 = query.getOrDefault("callback")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "callback", valid_589196
  var valid_589197 = query.getOrDefault("access_token")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = nil)
  if valid_589197 != nil:
    section.add "access_token", valid_589197
  var valid_589198 = query.getOrDefault("uploadType")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "uploadType", valid_589198
  var valid_589199 = query.getOrDefault("key")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = nil)
  if valid_589199 != nil:
    section.add "key", valid_589199
  var valid_589200 = query.getOrDefault("$.xgafv")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = newJString("1"))
  if valid_589200 != nil:
    section.add "$.xgafv", valid_589200
  var valid_589201 = query.getOrDefault("prettyPrint")
  valid_589201 = validateParameter(valid_589201, JBool, required = false,
                                 default = newJBool(true))
  if valid_589201 != nil:
    section.add "prettyPrint", valid_589201
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

proc call*(call_589203: Call_VisionProjectsLocationsProductSetsRemoveProduct_589187;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a Product from the specified ProductSet.
  ## 
  let valid = call_589203.validator(path, query, header, formData, body)
  let scheme = call_589203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589203.url(scheme.get, call_589203.host, call_589203.base,
                         call_589203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589203, url, valid)

proc call*(call_589204: Call_VisionProjectsLocationsProductSetsRemoveProduct_589187;
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
  var path_589205 = newJObject()
  var query_589206 = newJObject()
  var body_589207 = newJObject()
  add(query_589206, "upload_protocol", newJString(uploadProtocol))
  add(query_589206, "fields", newJString(fields))
  add(query_589206, "quotaUser", newJString(quotaUser))
  add(path_589205, "name", newJString(name))
  add(query_589206, "alt", newJString(alt))
  add(query_589206, "oauth_token", newJString(oauthToken))
  add(query_589206, "callback", newJString(callback))
  add(query_589206, "access_token", newJString(accessToken))
  add(query_589206, "uploadType", newJString(uploadType))
  add(query_589206, "key", newJString(key))
  add(query_589206, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589207 = body
  add(query_589206, "prettyPrint", newJBool(prettyPrint))
  result = call_589204.call(path_589205, query_589206, nil, nil, body_589207)

var visionProjectsLocationsProductSetsRemoveProduct* = Call_VisionProjectsLocationsProductSetsRemoveProduct_589187(
    name: "visionProjectsLocationsProductSetsRemoveProduct",
    meth: HttpMethod.HttpPost, host: "vision.googleapis.com",
    route: "/v1/{name}:removeProduct",
    validator: validate_VisionProjectsLocationsProductSetsRemoveProduct_589188,
    base: "/", url: url_VisionProjectsLocationsProductSetsRemoveProduct_589189,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsFilesAnnotate_589208 = ref object of OpenApiRestCall_588450
proc url_VisionProjectsLocationsFilesAnnotate_589210(protocol: Scheme;
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

proc validate_VisionProjectsLocationsFilesAnnotate_589209(path: JsonNode;
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
  var valid_589211 = path.getOrDefault("parent")
  valid_589211 = validateParameter(valid_589211, JString, required = true,
                                 default = nil)
  if valid_589211 != nil:
    section.add "parent", valid_589211
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
  var valid_589212 = query.getOrDefault("upload_protocol")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = nil)
  if valid_589212 != nil:
    section.add "upload_protocol", valid_589212
  var valid_589213 = query.getOrDefault("fields")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "fields", valid_589213
  var valid_589214 = query.getOrDefault("quotaUser")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "quotaUser", valid_589214
  var valid_589215 = query.getOrDefault("alt")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = newJString("json"))
  if valid_589215 != nil:
    section.add "alt", valid_589215
  var valid_589216 = query.getOrDefault("oauth_token")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = nil)
  if valid_589216 != nil:
    section.add "oauth_token", valid_589216
  var valid_589217 = query.getOrDefault("callback")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = nil)
  if valid_589217 != nil:
    section.add "callback", valid_589217
  var valid_589218 = query.getOrDefault("access_token")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "access_token", valid_589218
  var valid_589219 = query.getOrDefault("uploadType")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "uploadType", valid_589219
  var valid_589220 = query.getOrDefault("key")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "key", valid_589220
  var valid_589221 = query.getOrDefault("$.xgafv")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = newJString("1"))
  if valid_589221 != nil:
    section.add "$.xgafv", valid_589221
  var valid_589222 = query.getOrDefault("prettyPrint")
  valid_589222 = validateParameter(valid_589222, JBool, required = false,
                                 default = newJBool(true))
  if valid_589222 != nil:
    section.add "prettyPrint", valid_589222
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

proc call*(call_589224: Call_VisionProjectsLocationsFilesAnnotate_589208;
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
  let valid = call_589224.validator(path, query, header, formData, body)
  let scheme = call_589224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589224.url(scheme.get, call_589224.host, call_589224.base,
                         call_589224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589224, url, valid)

proc call*(call_589225: Call_VisionProjectsLocationsFilesAnnotate_589208;
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
  var path_589226 = newJObject()
  var query_589227 = newJObject()
  var body_589228 = newJObject()
  add(query_589227, "upload_protocol", newJString(uploadProtocol))
  add(query_589227, "fields", newJString(fields))
  add(query_589227, "quotaUser", newJString(quotaUser))
  add(query_589227, "alt", newJString(alt))
  add(query_589227, "oauth_token", newJString(oauthToken))
  add(query_589227, "callback", newJString(callback))
  add(query_589227, "access_token", newJString(accessToken))
  add(query_589227, "uploadType", newJString(uploadType))
  add(path_589226, "parent", newJString(parent))
  add(query_589227, "key", newJString(key))
  add(query_589227, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589228 = body
  add(query_589227, "prettyPrint", newJBool(prettyPrint))
  result = call_589225.call(path_589226, query_589227, nil, nil, body_589228)

var visionProjectsLocationsFilesAnnotate* = Call_VisionProjectsLocationsFilesAnnotate_589208(
    name: "visionProjectsLocationsFilesAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{parent}/files:annotate",
    validator: validate_VisionProjectsLocationsFilesAnnotate_589209, base: "/",
    url: url_VisionProjectsLocationsFilesAnnotate_589210, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsFilesAsyncBatchAnnotate_589229 = ref object of OpenApiRestCall_588450
proc url_VisionProjectsLocationsFilesAsyncBatchAnnotate_589231(protocol: Scheme;
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

proc validate_VisionProjectsLocationsFilesAsyncBatchAnnotate_589230(
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
  var valid_589232 = path.getOrDefault("parent")
  valid_589232 = validateParameter(valid_589232, JString, required = true,
                                 default = nil)
  if valid_589232 != nil:
    section.add "parent", valid_589232
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
  var valid_589233 = query.getOrDefault("upload_protocol")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = nil)
  if valid_589233 != nil:
    section.add "upload_protocol", valid_589233
  var valid_589234 = query.getOrDefault("fields")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "fields", valid_589234
  var valid_589235 = query.getOrDefault("quotaUser")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = nil)
  if valid_589235 != nil:
    section.add "quotaUser", valid_589235
  var valid_589236 = query.getOrDefault("alt")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = newJString("json"))
  if valid_589236 != nil:
    section.add "alt", valid_589236
  var valid_589237 = query.getOrDefault("oauth_token")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = nil)
  if valid_589237 != nil:
    section.add "oauth_token", valid_589237
  var valid_589238 = query.getOrDefault("callback")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = nil)
  if valid_589238 != nil:
    section.add "callback", valid_589238
  var valid_589239 = query.getOrDefault("access_token")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = nil)
  if valid_589239 != nil:
    section.add "access_token", valid_589239
  var valid_589240 = query.getOrDefault("uploadType")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = nil)
  if valid_589240 != nil:
    section.add "uploadType", valid_589240
  var valid_589241 = query.getOrDefault("key")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = nil)
  if valid_589241 != nil:
    section.add "key", valid_589241
  var valid_589242 = query.getOrDefault("$.xgafv")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = newJString("1"))
  if valid_589242 != nil:
    section.add "$.xgafv", valid_589242
  var valid_589243 = query.getOrDefault("prettyPrint")
  valid_589243 = validateParameter(valid_589243, JBool, required = false,
                                 default = newJBool(true))
  if valid_589243 != nil:
    section.add "prettyPrint", valid_589243
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

proc call*(call_589245: Call_VisionProjectsLocationsFilesAsyncBatchAnnotate_589229;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Run asynchronous image detection and annotation for a list of generic
  ## files, such as PDF files, which may contain multiple pages and multiple
  ## images per page. Progress and results can be retrieved through the
  ## `google.longrunning.Operations` interface.
  ## `Operation.metadata` contains `OperationMetadata` (metadata).
  ## `Operation.response` contains `AsyncBatchAnnotateFilesResponse` (results).
  ## 
  let valid = call_589245.validator(path, query, header, formData, body)
  let scheme = call_589245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589245.url(scheme.get, call_589245.host, call_589245.base,
                         call_589245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589245, url, valid)

proc call*(call_589246: Call_VisionProjectsLocationsFilesAsyncBatchAnnotate_589229;
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
  var path_589247 = newJObject()
  var query_589248 = newJObject()
  var body_589249 = newJObject()
  add(query_589248, "upload_protocol", newJString(uploadProtocol))
  add(query_589248, "fields", newJString(fields))
  add(query_589248, "quotaUser", newJString(quotaUser))
  add(query_589248, "alt", newJString(alt))
  add(query_589248, "oauth_token", newJString(oauthToken))
  add(query_589248, "callback", newJString(callback))
  add(query_589248, "access_token", newJString(accessToken))
  add(query_589248, "uploadType", newJString(uploadType))
  add(path_589247, "parent", newJString(parent))
  add(query_589248, "key", newJString(key))
  add(query_589248, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589249 = body
  add(query_589248, "prettyPrint", newJBool(prettyPrint))
  result = call_589246.call(path_589247, query_589248, nil, nil, body_589249)

var visionProjectsLocationsFilesAsyncBatchAnnotate* = Call_VisionProjectsLocationsFilesAsyncBatchAnnotate_589229(
    name: "visionProjectsLocationsFilesAsyncBatchAnnotate",
    meth: HttpMethod.HttpPost, host: "vision.googleapis.com",
    route: "/v1/{parent}/files:asyncBatchAnnotate",
    validator: validate_VisionProjectsLocationsFilesAsyncBatchAnnotate_589230,
    base: "/", url: url_VisionProjectsLocationsFilesAsyncBatchAnnotate_589231,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsImagesAnnotate_589250 = ref object of OpenApiRestCall_588450
proc url_VisionProjectsLocationsImagesAnnotate_589252(protocol: Scheme;
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

proc validate_VisionProjectsLocationsImagesAnnotate_589251(path: JsonNode;
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
  var valid_589253 = path.getOrDefault("parent")
  valid_589253 = validateParameter(valid_589253, JString, required = true,
                                 default = nil)
  if valid_589253 != nil:
    section.add "parent", valid_589253
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
  var valid_589254 = query.getOrDefault("upload_protocol")
  valid_589254 = validateParameter(valid_589254, JString, required = false,
                                 default = nil)
  if valid_589254 != nil:
    section.add "upload_protocol", valid_589254
  var valid_589255 = query.getOrDefault("fields")
  valid_589255 = validateParameter(valid_589255, JString, required = false,
                                 default = nil)
  if valid_589255 != nil:
    section.add "fields", valid_589255
  var valid_589256 = query.getOrDefault("quotaUser")
  valid_589256 = validateParameter(valid_589256, JString, required = false,
                                 default = nil)
  if valid_589256 != nil:
    section.add "quotaUser", valid_589256
  var valid_589257 = query.getOrDefault("alt")
  valid_589257 = validateParameter(valid_589257, JString, required = false,
                                 default = newJString("json"))
  if valid_589257 != nil:
    section.add "alt", valid_589257
  var valid_589258 = query.getOrDefault("oauth_token")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = nil)
  if valid_589258 != nil:
    section.add "oauth_token", valid_589258
  var valid_589259 = query.getOrDefault("callback")
  valid_589259 = validateParameter(valid_589259, JString, required = false,
                                 default = nil)
  if valid_589259 != nil:
    section.add "callback", valid_589259
  var valid_589260 = query.getOrDefault("access_token")
  valid_589260 = validateParameter(valid_589260, JString, required = false,
                                 default = nil)
  if valid_589260 != nil:
    section.add "access_token", valid_589260
  var valid_589261 = query.getOrDefault("uploadType")
  valid_589261 = validateParameter(valid_589261, JString, required = false,
                                 default = nil)
  if valid_589261 != nil:
    section.add "uploadType", valid_589261
  var valid_589262 = query.getOrDefault("key")
  valid_589262 = validateParameter(valid_589262, JString, required = false,
                                 default = nil)
  if valid_589262 != nil:
    section.add "key", valid_589262
  var valid_589263 = query.getOrDefault("$.xgafv")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = newJString("1"))
  if valid_589263 != nil:
    section.add "$.xgafv", valid_589263
  var valid_589264 = query.getOrDefault("prettyPrint")
  valid_589264 = validateParameter(valid_589264, JBool, required = false,
                                 default = newJBool(true))
  if valid_589264 != nil:
    section.add "prettyPrint", valid_589264
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

proc call*(call_589266: Call_VisionProjectsLocationsImagesAnnotate_589250;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Run image detection and annotation for a batch of images.
  ## 
  let valid = call_589266.validator(path, query, header, formData, body)
  let scheme = call_589266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589266.url(scheme.get, call_589266.host, call_589266.base,
                         call_589266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589266, url, valid)

proc call*(call_589267: Call_VisionProjectsLocationsImagesAnnotate_589250;
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
  var path_589268 = newJObject()
  var query_589269 = newJObject()
  var body_589270 = newJObject()
  add(query_589269, "upload_protocol", newJString(uploadProtocol))
  add(query_589269, "fields", newJString(fields))
  add(query_589269, "quotaUser", newJString(quotaUser))
  add(query_589269, "alt", newJString(alt))
  add(query_589269, "oauth_token", newJString(oauthToken))
  add(query_589269, "callback", newJString(callback))
  add(query_589269, "access_token", newJString(accessToken))
  add(query_589269, "uploadType", newJString(uploadType))
  add(path_589268, "parent", newJString(parent))
  add(query_589269, "key", newJString(key))
  add(query_589269, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589270 = body
  add(query_589269, "prettyPrint", newJBool(prettyPrint))
  result = call_589267.call(path_589268, query_589269, nil, nil, body_589270)

var visionProjectsLocationsImagesAnnotate* = Call_VisionProjectsLocationsImagesAnnotate_589250(
    name: "visionProjectsLocationsImagesAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{parent}/images:annotate",
    validator: validate_VisionProjectsLocationsImagesAnnotate_589251, base: "/",
    url: url_VisionProjectsLocationsImagesAnnotate_589252, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsImagesAsyncBatchAnnotate_589271 = ref object of OpenApiRestCall_588450
proc url_VisionProjectsLocationsImagesAsyncBatchAnnotate_589273(protocol: Scheme;
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

proc validate_VisionProjectsLocationsImagesAsyncBatchAnnotate_589272(
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
  var valid_589274 = path.getOrDefault("parent")
  valid_589274 = validateParameter(valid_589274, JString, required = true,
                                 default = nil)
  if valid_589274 != nil:
    section.add "parent", valid_589274
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
  var valid_589275 = query.getOrDefault("upload_protocol")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = nil)
  if valid_589275 != nil:
    section.add "upload_protocol", valid_589275
  var valid_589276 = query.getOrDefault("fields")
  valid_589276 = validateParameter(valid_589276, JString, required = false,
                                 default = nil)
  if valid_589276 != nil:
    section.add "fields", valid_589276
  var valid_589277 = query.getOrDefault("quotaUser")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = nil)
  if valid_589277 != nil:
    section.add "quotaUser", valid_589277
  var valid_589278 = query.getOrDefault("alt")
  valid_589278 = validateParameter(valid_589278, JString, required = false,
                                 default = newJString("json"))
  if valid_589278 != nil:
    section.add "alt", valid_589278
  var valid_589279 = query.getOrDefault("oauth_token")
  valid_589279 = validateParameter(valid_589279, JString, required = false,
                                 default = nil)
  if valid_589279 != nil:
    section.add "oauth_token", valid_589279
  var valid_589280 = query.getOrDefault("callback")
  valid_589280 = validateParameter(valid_589280, JString, required = false,
                                 default = nil)
  if valid_589280 != nil:
    section.add "callback", valid_589280
  var valid_589281 = query.getOrDefault("access_token")
  valid_589281 = validateParameter(valid_589281, JString, required = false,
                                 default = nil)
  if valid_589281 != nil:
    section.add "access_token", valid_589281
  var valid_589282 = query.getOrDefault("uploadType")
  valid_589282 = validateParameter(valid_589282, JString, required = false,
                                 default = nil)
  if valid_589282 != nil:
    section.add "uploadType", valid_589282
  var valid_589283 = query.getOrDefault("key")
  valid_589283 = validateParameter(valid_589283, JString, required = false,
                                 default = nil)
  if valid_589283 != nil:
    section.add "key", valid_589283
  var valid_589284 = query.getOrDefault("$.xgafv")
  valid_589284 = validateParameter(valid_589284, JString, required = false,
                                 default = newJString("1"))
  if valid_589284 != nil:
    section.add "$.xgafv", valid_589284
  var valid_589285 = query.getOrDefault("prettyPrint")
  valid_589285 = validateParameter(valid_589285, JBool, required = false,
                                 default = newJBool(true))
  if valid_589285 != nil:
    section.add "prettyPrint", valid_589285
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

proc call*(call_589287: Call_VisionProjectsLocationsImagesAsyncBatchAnnotate_589271;
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
  let valid = call_589287.validator(path, query, header, formData, body)
  let scheme = call_589287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589287.url(scheme.get, call_589287.host, call_589287.base,
                         call_589287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589287, url, valid)

proc call*(call_589288: Call_VisionProjectsLocationsImagesAsyncBatchAnnotate_589271;
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
  var path_589289 = newJObject()
  var query_589290 = newJObject()
  var body_589291 = newJObject()
  add(query_589290, "upload_protocol", newJString(uploadProtocol))
  add(query_589290, "fields", newJString(fields))
  add(query_589290, "quotaUser", newJString(quotaUser))
  add(query_589290, "alt", newJString(alt))
  add(query_589290, "oauth_token", newJString(oauthToken))
  add(query_589290, "callback", newJString(callback))
  add(query_589290, "access_token", newJString(accessToken))
  add(query_589290, "uploadType", newJString(uploadType))
  add(path_589289, "parent", newJString(parent))
  add(query_589290, "key", newJString(key))
  add(query_589290, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589291 = body
  add(query_589290, "prettyPrint", newJBool(prettyPrint))
  result = call_589288.call(path_589289, query_589290, nil, nil, body_589291)

var visionProjectsLocationsImagesAsyncBatchAnnotate* = Call_VisionProjectsLocationsImagesAsyncBatchAnnotate_589271(
    name: "visionProjectsLocationsImagesAsyncBatchAnnotate",
    meth: HttpMethod.HttpPost, host: "vision.googleapis.com",
    route: "/v1/{parent}/images:asyncBatchAnnotate",
    validator: validate_VisionProjectsLocationsImagesAsyncBatchAnnotate_589272,
    base: "/", url: url_VisionProjectsLocationsImagesAsyncBatchAnnotate_589273,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsCreate_589313 = ref object of OpenApiRestCall_588450
proc url_VisionProjectsLocationsProductSetsCreate_589315(protocol: Scheme;
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

proc validate_VisionProjectsLocationsProductSetsCreate_589314(path: JsonNode;
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
  var valid_589316 = path.getOrDefault("parent")
  valid_589316 = validateParameter(valid_589316, JString, required = true,
                                 default = nil)
  if valid_589316 != nil:
    section.add "parent", valid_589316
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
  var valid_589317 = query.getOrDefault("upload_protocol")
  valid_589317 = validateParameter(valid_589317, JString, required = false,
                                 default = nil)
  if valid_589317 != nil:
    section.add "upload_protocol", valid_589317
  var valid_589318 = query.getOrDefault("fields")
  valid_589318 = validateParameter(valid_589318, JString, required = false,
                                 default = nil)
  if valid_589318 != nil:
    section.add "fields", valid_589318
  var valid_589319 = query.getOrDefault("quotaUser")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = nil)
  if valid_589319 != nil:
    section.add "quotaUser", valid_589319
  var valid_589320 = query.getOrDefault("alt")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = newJString("json"))
  if valid_589320 != nil:
    section.add "alt", valid_589320
  var valid_589321 = query.getOrDefault("oauth_token")
  valid_589321 = validateParameter(valid_589321, JString, required = false,
                                 default = nil)
  if valid_589321 != nil:
    section.add "oauth_token", valid_589321
  var valid_589322 = query.getOrDefault("callback")
  valid_589322 = validateParameter(valid_589322, JString, required = false,
                                 default = nil)
  if valid_589322 != nil:
    section.add "callback", valid_589322
  var valid_589323 = query.getOrDefault("access_token")
  valid_589323 = validateParameter(valid_589323, JString, required = false,
                                 default = nil)
  if valid_589323 != nil:
    section.add "access_token", valid_589323
  var valid_589324 = query.getOrDefault("uploadType")
  valid_589324 = validateParameter(valid_589324, JString, required = false,
                                 default = nil)
  if valid_589324 != nil:
    section.add "uploadType", valid_589324
  var valid_589325 = query.getOrDefault("key")
  valid_589325 = validateParameter(valid_589325, JString, required = false,
                                 default = nil)
  if valid_589325 != nil:
    section.add "key", valid_589325
  var valid_589326 = query.getOrDefault("$.xgafv")
  valid_589326 = validateParameter(valid_589326, JString, required = false,
                                 default = newJString("1"))
  if valid_589326 != nil:
    section.add "$.xgafv", valid_589326
  var valid_589327 = query.getOrDefault("productSetId")
  valid_589327 = validateParameter(valid_589327, JString, required = false,
                                 default = nil)
  if valid_589327 != nil:
    section.add "productSetId", valid_589327
  var valid_589328 = query.getOrDefault("prettyPrint")
  valid_589328 = validateParameter(valid_589328, JBool, required = false,
                                 default = newJBool(true))
  if valid_589328 != nil:
    section.add "prettyPrint", valid_589328
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

proc call*(call_589330: Call_VisionProjectsLocationsProductSetsCreate_589313;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates and returns a new ProductSet resource.
  ## 
  ## Possible errors:
  ## 
  ## * Returns INVALID_ARGUMENT if display_name is missing, or is longer than
  ##   4096 characters.
  ## 
  let valid = call_589330.validator(path, query, header, formData, body)
  let scheme = call_589330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589330.url(scheme.get, call_589330.host, call_589330.base,
                         call_589330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589330, url, valid)

proc call*(call_589331: Call_VisionProjectsLocationsProductSetsCreate_589313;
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
  var path_589332 = newJObject()
  var query_589333 = newJObject()
  var body_589334 = newJObject()
  add(query_589333, "upload_protocol", newJString(uploadProtocol))
  add(query_589333, "fields", newJString(fields))
  add(query_589333, "quotaUser", newJString(quotaUser))
  add(query_589333, "alt", newJString(alt))
  add(query_589333, "oauth_token", newJString(oauthToken))
  add(query_589333, "callback", newJString(callback))
  add(query_589333, "access_token", newJString(accessToken))
  add(query_589333, "uploadType", newJString(uploadType))
  add(path_589332, "parent", newJString(parent))
  add(query_589333, "key", newJString(key))
  add(query_589333, "$.xgafv", newJString(Xgafv))
  add(query_589333, "productSetId", newJString(productSetId))
  if body != nil:
    body_589334 = body
  add(query_589333, "prettyPrint", newJBool(prettyPrint))
  result = call_589331.call(path_589332, query_589333, nil, nil, body_589334)

var visionProjectsLocationsProductSetsCreate* = Call_VisionProjectsLocationsProductSetsCreate_589313(
    name: "visionProjectsLocationsProductSetsCreate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{parent}/productSets",
    validator: validate_VisionProjectsLocationsProductSetsCreate_589314,
    base: "/", url: url_VisionProjectsLocationsProductSetsCreate_589315,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsList_589292 = ref object of OpenApiRestCall_588450
proc url_VisionProjectsLocationsProductSetsList_589294(protocol: Scheme;
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

proc validate_VisionProjectsLocationsProductSetsList_589293(path: JsonNode;
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
  var valid_589295 = path.getOrDefault("parent")
  valid_589295 = validateParameter(valid_589295, JString, required = true,
                                 default = nil)
  if valid_589295 != nil:
    section.add "parent", valid_589295
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
  var valid_589296 = query.getOrDefault("upload_protocol")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = nil)
  if valid_589296 != nil:
    section.add "upload_protocol", valid_589296
  var valid_589297 = query.getOrDefault("fields")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = nil)
  if valid_589297 != nil:
    section.add "fields", valid_589297
  var valid_589298 = query.getOrDefault("pageToken")
  valid_589298 = validateParameter(valid_589298, JString, required = false,
                                 default = nil)
  if valid_589298 != nil:
    section.add "pageToken", valid_589298
  var valid_589299 = query.getOrDefault("quotaUser")
  valid_589299 = validateParameter(valid_589299, JString, required = false,
                                 default = nil)
  if valid_589299 != nil:
    section.add "quotaUser", valid_589299
  var valid_589300 = query.getOrDefault("alt")
  valid_589300 = validateParameter(valid_589300, JString, required = false,
                                 default = newJString("json"))
  if valid_589300 != nil:
    section.add "alt", valid_589300
  var valid_589301 = query.getOrDefault("oauth_token")
  valid_589301 = validateParameter(valid_589301, JString, required = false,
                                 default = nil)
  if valid_589301 != nil:
    section.add "oauth_token", valid_589301
  var valid_589302 = query.getOrDefault("callback")
  valid_589302 = validateParameter(valid_589302, JString, required = false,
                                 default = nil)
  if valid_589302 != nil:
    section.add "callback", valid_589302
  var valid_589303 = query.getOrDefault("access_token")
  valid_589303 = validateParameter(valid_589303, JString, required = false,
                                 default = nil)
  if valid_589303 != nil:
    section.add "access_token", valid_589303
  var valid_589304 = query.getOrDefault("uploadType")
  valid_589304 = validateParameter(valid_589304, JString, required = false,
                                 default = nil)
  if valid_589304 != nil:
    section.add "uploadType", valid_589304
  var valid_589305 = query.getOrDefault("key")
  valid_589305 = validateParameter(valid_589305, JString, required = false,
                                 default = nil)
  if valid_589305 != nil:
    section.add "key", valid_589305
  var valid_589306 = query.getOrDefault("$.xgafv")
  valid_589306 = validateParameter(valid_589306, JString, required = false,
                                 default = newJString("1"))
  if valid_589306 != nil:
    section.add "$.xgafv", valid_589306
  var valid_589307 = query.getOrDefault("pageSize")
  valid_589307 = validateParameter(valid_589307, JInt, required = false, default = nil)
  if valid_589307 != nil:
    section.add "pageSize", valid_589307
  var valid_589308 = query.getOrDefault("prettyPrint")
  valid_589308 = validateParameter(valid_589308, JBool, required = false,
                                 default = newJBool(true))
  if valid_589308 != nil:
    section.add "prettyPrint", valid_589308
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589309: Call_VisionProjectsLocationsProductSetsList_589292;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists ProductSets in an unspecified order.
  ## 
  ## Possible errors:
  ## 
  ## * Returns INVALID_ARGUMENT if page_size is greater than 100, or less
  ##   than 1.
  ## 
  let valid = call_589309.validator(path, query, header, formData, body)
  let scheme = call_589309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589309.url(scheme.get, call_589309.host, call_589309.base,
                         call_589309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589309, url, valid)

proc call*(call_589310: Call_VisionProjectsLocationsProductSetsList_589292;
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
  var path_589311 = newJObject()
  var query_589312 = newJObject()
  add(query_589312, "upload_protocol", newJString(uploadProtocol))
  add(query_589312, "fields", newJString(fields))
  add(query_589312, "pageToken", newJString(pageToken))
  add(query_589312, "quotaUser", newJString(quotaUser))
  add(query_589312, "alt", newJString(alt))
  add(query_589312, "oauth_token", newJString(oauthToken))
  add(query_589312, "callback", newJString(callback))
  add(query_589312, "access_token", newJString(accessToken))
  add(query_589312, "uploadType", newJString(uploadType))
  add(path_589311, "parent", newJString(parent))
  add(query_589312, "key", newJString(key))
  add(query_589312, "$.xgafv", newJString(Xgafv))
  add(query_589312, "pageSize", newJInt(pageSize))
  add(query_589312, "prettyPrint", newJBool(prettyPrint))
  result = call_589310.call(path_589311, query_589312, nil, nil, nil)

var visionProjectsLocationsProductSetsList* = Call_VisionProjectsLocationsProductSetsList_589292(
    name: "visionProjectsLocationsProductSetsList", meth: HttpMethod.HttpGet,
    host: "vision.googleapis.com", route: "/v1/{parent}/productSets",
    validator: validate_VisionProjectsLocationsProductSetsList_589293, base: "/",
    url: url_VisionProjectsLocationsProductSetsList_589294,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsImport_589335 = ref object of OpenApiRestCall_588450
proc url_VisionProjectsLocationsProductSetsImport_589337(protocol: Scheme;
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

proc validate_VisionProjectsLocationsProductSetsImport_589336(path: JsonNode;
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
  var valid_589338 = path.getOrDefault("parent")
  valid_589338 = validateParameter(valid_589338, JString, required = true,
                                 default = nil)
  if valid_589338 != nil:
    section.add "parent", valid_589338
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
  var valid_589339 = query.getOrDefault("upload_protocol")
  valid_589339 = validateParameter(valid_589339, JString, required = false,
                                 default = nil)
  if valid_589339 != nil:
    section.add "upload_protocol", valid_589339
  var valid_589340 = query.getOrDefault("fields")
  valid_589340 = validateParameter(valid_589340, JString, required = false,
                                 default = nil)
  if valid_589340 != nil:
    section.add "fields", valid_589340
  var valid_589341 = query.getOrDefault("quotaUser")
  valid_589341 = validateParameter(valid_589341, JString, required = false,
                                 default = nil)
  if valid_589341 != nil:
    section.add "quotaUser", valid_589341
  var valid_589342 = query.getOrDefault("alt")
  valid_589342 = validateParameter(valid_589342, JString, required = false,
                                 default = newJString("json"))
  if valid_589342 != nil:
    section.add "alt", valid_589342
  var valid_589343 = query.getOrDefault("oauth_token")
  valid_589343 = validateParameter(valid_589343, JString, required = false,
                                 default = nil)
  if valid_589343 != nil:
    section.add "oauth_token", valid_589343
  var valid_589344 = query.getOrDefault("callback")
  valid_589344 = validateParameter(valid_589344, JString, required = false,
                                 default = nil)
  if valid_589344 != nil:
    section.add "callback", valid_589344
  var valid_589345 = query.getOrDefault("access_token")
  valid_589345 = validateParameter(valid_589345, JString, required = false,
                                 default = nil)
  if valid_589345 != nil:
    section.add "access_token", valid_589345
  var valid_589346 = query.getOrDefault("uploadType")
  valid_589346 = validateParameter(valid_589346, JString, required = false,
                                 default = nil)
  if valid_589346 != nil:
    section.add "uploadType", valid_589346
  var valid_589347 = query.getOrDefault("key")
  valid_589347 = validateParameter(valid_589347, JString, required = false,
                                 default = nil)
  if valid_589347 != nil:
    section.add "key", valid_589347
  var valid_589348 = query.getOrDefault("$.xgafv")
  valid_589348 = validateParameter(valid_589348, JString, required = false,
                                 default = newJString("1"))
  if valid_589348 != nil:
    section.add "$.xgafv", valid_589348
  var valid_589349 = query.getOrDefault("prettyPrint")
  valid_589349 = validateParameter(valid_589349, JBool, required = false,
                                 default = newJBool(true))
  if valid_589349 != nil:
    section.add "prettyPrint", valid_589349
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

proc call*(call_589351: Call_VisionProjectsLocationsProductSetsImport_589335;
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
  let valid = call_589351.validator(path, query, header, formData, body)
  let scheme = call_589351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589351.url(scheme.get, call_589351.host, call_589351.base,
                         call_589351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589351, url, valid)

proc call*(call_589352: Call_VisionProjectsLocationsProductSetsImport_589335;
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
  var path_589353 = newJObject()
  var query_589354 = newJObject()
  var body_589355 = newJObject()
  add(query_589354, "upload_protocol", newJString(uploadProtocol))
  add(query_589354, "fields", newJString(fields))
  add(query_589354, "quotaUser", newJString(quotaUser))
  add(query_589354, "alt", newJString(alt))
  add(query_589354, "oauth_token", newJString(oauthToken))
  add(query_589354, "callback", newJString(callback))
  add(query_589354, "access_token", newJString(accessToken))
  add(query_589354, "uploadType", newJString(uploadType))
  add(path_589353, "parent", newJString(parent))
  add(query_589354, "key", newJString(key))
  add(query_589354, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589355 = body
  add(query_589354, "prettyPrint", newJBool(prettyPrint))
  result = call_589352.call(path_589353, query_589354, nil, nil, body_589355)

var visionProjectsLocationsProductSetsImport* = Call_VisionProjectsLocationsProductSetsImport_589335(
    name: "visionProjectsLocationsProductSetsImport", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{parent}/productSets:import",
    validator: validate_VisionProjectsLocationsProductSetsImport_589336,
    base: "/", url: url_VisionProjectsLocationsProductSetsImport_589337,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductsCreate_589377 = ref object of OpenApiRestCall_588450
proc url_VisionProjectsLocationsProductsCreate_589379(protocol: Scheme;
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

proc validate_VisionProjectsLocationsProductsCreate_589378(path: JsonNode;
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
  var valid_589380 = path.getOrDefault("parent")
  valid_589380 = validateParameter(valid_589380, JString, required = true,
                                 default = nil)
  if valid_589380 != nil:
    section.add "parent", valid_589380
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
  var valid_589381 = query.getOrDefault("upload_protocol")
  valid_589381 = validateParameter(valid_589381, JString, required = false,
                                 default = nil)
  if valid_589381 != nil:
    section.add "upload_protocol", valid_589381
  var valid_589382 = query.getOrDefault("fields")
  valid_589382 = validateParameter(valid_589382, JString, required = false,
                                 default = nil)
  if valid_589382 != nil:
    section.add "fields", valid_589382
  var valid_589383 = query.getOrDefault("quotaUser")
  valid_589383 = validateParameter(valid_589383, JString, required = false,
                                 default = nil)
  if valid_589383 != nil:
    section.add "quotaUser", valid_589383
  var valid_589384 = query.getOrDefault("alt")
  valid_589384 = validateParameter(valid_589384, JString, required = false,
                                 default = newJString("json"))
  if valid_589384 != nil:
    section.add "alt", valid_589384
  var valid_589385 = query.getOrDefault("oauth_token")
  valid_589385 = validateParameter(valid_589385, JString, required = false,
                                 default = nil)
  if valid_589385 != nil:
    section.add "oauth_token", valid_589385
  var valid_589386 = query.getOrDefault("callback")
  valid_589386 = validateParameter(valid_589386, JString, required = false,
                                 default = nil)
  if valid_589386 != nil:
    section.add "callback", valid_589386
  var valid_589387 = query.getOrDefault("access_token")
  valid_589387 = validateParameter(valid_589387, JString, required = false,
                                 default = nil)
  if valid_589387 != nil:
    section.add "access_token", valid_589387
  var valid_589388 = query.getOrDefault("uploadType")
  valid_589388 = validateParameter(valid_589388, JString, required = false,
                                 default = nil)
  if valid_589388 != nil:
    section.add "uploadType", valid_589388
  var valid_589389 = query.getOrDefault("productId")
  valid_589389 = validateParameter(valid_589389, JString, required = false,
                                 default = nil)
  if valid_589389 != nil:
    section.add "productId", valid_589389
  var valid_589390 = query.getOrDefault("key")
  valid_589390 = validateParameter(valid_589390, JString, required = false,
                                 default = nil)
  if valid_589390 != nil:
    section.add "key", valid_589390
  var valid_589391 = query.getOrDefault("$.xgafv")
  valid_589391 = validateParameter(valid_589391, JString, required = false,
                                 default = newJString("1"))
  if valid_589391 != nil:
    section.add "$.xgafv", valid_589391
  var valid_589392 = query.getOrDefault("prettyPrint")
  valid_589392 = validateParameter(valid_589392, JBool, required = false,
                                 default = newJBool(true))
  if valid_589392 != nil:
    section.add "prettyPrint", valid_589392
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

proc call*(call_589394: Call_VisionProjectsLocationsProductsCreate_589377;
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
  let valid = call_589394.validator(path, query, header, formData, body)
  let scheme = call_589394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589394.url(scheme.get, call_589394.host, call_589394.base,
                         call_589394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589394, url, valid)

proc call*(call_589395: Call_VisionProjectsLocationsProductsCreate_589377;
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
  var path_589396 = newJObject()
  var query_589397 = newJObject()
  var body_589398 = newJObject()
  add(query_589397, "upload_protocol", newJString(uploadProtocol))
  add(query_589397, "fields", newJString(fields))
  add(query_589397, "quotaUser", newJString(quotaUser))
  add(query_589397, "alt", newJString(alt))
  add(query_589397, "oauth_token", newJString(oauthToken))
  add(query_589397, "callback", newJString(callback))
  add(query_589397, "access_token", newJString(accessToken))
  add(query_589397, "uploadType", newJString(uploadType))
  add(path_589396, "parent", newJString(parent))
  add(query_589397, "productId", newJString(productId))
  add(query_589397, "key", newJString(key))
  add(query_589397, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589398 = body
  add(query_589397, "prettyPrint", newJBool(prettyPrint))
  result = call_589395.call(path_589396, query_589397, nil, nil, body_589398)

var visionProjectsLocationsProductsCreate* = Call_VisionProjectsLocationsProductsCreate_589377(
    name: "visionProjectsLocationsProductsCreate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{parent}/products",
    validator: validate_VisionProjectsLocationsProductsCreate_589378, base: "/",
    url: url_VisionProjectsLocationsProductsCreate_589379, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductsList_589356 = ref object of OpenApiRestCall_588450
proc url_VisionProjectsLocationsProductsList_589358(protocol: Scheme; host: string;
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

proc validate_VisionProjectsLocationsProductsList_589357(path: JsonNode;
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
  var valid_589359 = path.getOrDefault("parent")
  valid_589359 = validateParameter(valid_589359, JString, required = true,
                                 default = nil)
  if valid_589359 != nil:
    section.add "parent", valid_589359
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
  var valid_589360 = query.getOrDefault("upload_protocol")
  valid_589360 = validateParameter(valid_589360, JString, required = false,
                                 default = nil)
  if valid_589360 != nil:
    section.add "upload_protocol", valid_589360
  var valid_589361 = query.getOrDefault("fields")
  valid_589361 = validateParameter(valid_589361, JString, required = false,
                                 default = nil)
  if valid_589361 != nil:
    section.add "fields", valid_589361
  var valid_589362 = query.getOrDefault("pageToken")
  valid_589362 = validateParameter(valid_589362, JString, required = false,
                                 default = nil)
  if valid_589362 != nil:
    section.add "pageToken", valid_589362
  var valid_589363 = query.getOrDefault("quotaUser")
  valid_589363 = validateParameter(valid_589363, JString, required = false,
                                 default = nil)
  if valid_589363 != nil:
    section.add "quotaUser", valid_589363
  var valid_589364 = query.getOrDefault("alt")
  valid_589364 = validateParameter(valid_589364, JString, required = false,
                                 default = newJString("json"))
  if valid_589364 != nil:
    section.add "alt", valid_589364
  var valid_589365 = query.getOrDefault("oauth_token")
  valid_589365 = validateParameter(valid_589365, JString, required = false,
                                 default = nil)
  if valid_589365 != nil:
    section.add "oauth_token", valid_589365
  var valid_589366 = query.getOrDefault("callback")
  valid_589366 = validateParameter(valid_589366, JString, required = false,
                                 default = nil)
  if valid_589366 != nil:
    section.add "callback", valid_589366
  var valid_589367 = query.getOrDefault("access_token")
  valid_589367 = validateParameter(valid_589367, JString, required = false,
                                 default = nil)
  if valid_589367 != nil:
    section.add "access_token", valid_589367
  var valid_589368 = query.getOrDefault("uploadType")
  valid_589368 = validateParameter(valid_589368, JString, required = false,
                                 default = nil)
  if valid_589368 != nil:
    section.add "uploadType", valid_589368
  var valid_589369 = query.getOrDefault("key")
  valid_589369 = validateParameter(valid_589369, JString, required = false,
                                 default = nil)
  if valid_589369 != nil:
    section.add "key", valid_589369
  var valid_589370 = query.getOrDefault("$.xgafv")
  valid_589370 = validateParameter(valid_589370, JString, required = false,
                                 default = newJString("1"))
  if valid_589370 != nil:
    section.add "$.xgafv", valid_589370
  var valid_589371 = query.getOrDefault("pageSize")
  valid_589371 = validateParameter(valid_589371, JInt, required = false, default = nil)
  if valid_589371 != nil:
    section.add "pageSize", valid_589371
  var valid_589372 = query.getOrDefault("prettyPrint")
  valid_589372 = validateParameter(valid_589372, JBool, required = false,
                                 default = newJBool(true))
  if valid_589372 != nil:
    section.add "prettyPrint", valid_589372
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589373: Call_VisionProjectsLocationsProductsList_589356;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists products in an unspecified order.
  ## 
  ## Possible errors:
  ## 
  ## * Returns INVALID_ARGUMENT if page_size is greater than 100 or less than 1.
  ## 
  let valid = call_589373.validator(path, query, header, formData, body)
  let scheme = call_589373.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589373.url(scheme.get, call_589373.host, call_589373.base,
                         call_589373.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589373, url, valid)

proc call*(call_589374: Call_VisionProjectsLocationsProductsList_589356;
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
  var path_589375 = newJObject()
  var query_589376 = newJObject()
  add(query_589376, "upload_protocol", newJString(uploadProtocol))
  add(query_589376, "fields", newJString(fields))
  add(query_589376, "pageToken", newJString(pageToken))
  add(query_589376, "quotaUser", newJString(quotaUser))
  add(query_589376, "alt", newJString(alt))
  add(query_589376, "oauth_token", newJString(oauthToken))
  add(query_589376, "callback", newJString(callback))
  add(query_589376, "access_token", newJString(accessToken))
  add(query_589376, "uploadType", newJString(uploadType))
  add(path_589375, "parent", newJString(parent))
  add(query_589376, "key", newJString(key))
  add(query_589376, "$.xgafv", newJString(Xgafv))
  add(query_589376, "pageSize", newJInt(pageSize))
  add(query_589376, "prettyPrint", newJBool(prettyPrint))
  result = call_589374.call(path_589375, query_589376, nil, nil, nil)

var visionProjectsLocationsProductsList* = Call_VisionProjectsLocationsProductsList_589356(
    name: "visionProjectsLocationsProductsList", meth: HttpMethod.HttpGet,
    host: "vision.googleapis.com", route: "/v1/{parent}/products",
    validator: validate_VisionProjectsLocationsProductsList_589357, base: "/",
    url: url_VisionProjectsLocationsProductsList_589358, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductsPurge_589399 = ref object of OpenApiRestCall_588450
proc url_VisionProjectsLocationsProductsPurge_589401(protocol: Scheme;
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

proc validate_VisionProjectsLocationsProductsPurge_589400(path: JsonNode;
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
  var valid_589402 = path.getOrDefault("parent")
  valid_589402 = validateParameter(valid_589402, JString, required = true,
                                 default = nil)
  if valid_589402 != nil:
    section.add "parent", valid_589402
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
  var valid_589403 = query.getOrDefault("upload_protocol")
  valid_589403 = validateParameter(valid_589403, JString, required = false,
                                 default = nil)
  if valid_589403 != nil:
    section.add "upload_protocol", valid_589403
  var valid_589404 = query.getOrDefault("fields")
  valid_589404 = validateParameter(valid_589404, JString, required = false,
                                 default = nil)
  if valid_589404 != nil:
    section.add "fields", valid_589404
  var valid_589405 = query.getOrDefault("quotaUser")
  valid_589405 = validateParameter(valid_589405, JString, required = false,
                                 default = nil)
  if valid_589405 != nil:
    section.add "quotaUser", valid_589405
  var valid_589406 = query.getOrDefault("alt")
  valid_589406 = validateParameter(valid_589406, JString, required = false,
                                 default = newJString("json"))
  if valid_589406 != nil:
    section.add "alt", valid_589406
  var valid_589407 = query.getOrDefault("oauth_token")
  valid_589407 = validateParameter(valid_589407, JString, required = false,
                                 default = nil)
  if valid_589407 != nil:
    section.add "oauth_token", valid_589407
  var valid_589408 = query.getOrDefault("callback")
  valid_589408 = validateParameter(valid_589408, JString, required = false,
                                 default = nil)
  if valid_589408 != nil:
    section.add "callback", valid_589408
  var valid_589409 = query.getOrDefault("access_token")
  valid_589409 = validateParameter(valid_589409, JString, required = false,
                                 default = nil)
  if valid_589409 != nil:
    section.add "access_token", valid_589409
  var valid_589410 = query.getOrDefault("uploadType")
  valid_589410 = validateParameter(valid_589410, JString, required = false,
                                 default = nil)
  if valid_589410 != nil:
    section.add "uploadType", valid_589410
  var valid_589411 = query.getOrDefault("key")
  valid_589411 = validateParameter(valid_589411, JString, required = false,
                                 default = nil)
  if valid_589411 != nil:
    section.add "key", valid_589411
  var valid_589412 = query.getOrDefault("$.xgafv")
  valid_589412 = validateParameter(valid_589412, JString, required = false,
                                 default = newJString("1"))
  if valid_589412 != nil:
    section.add "$.xgafv", valid_589412
  var valid_589413 = query.getOrDefault("prettyPrint")
  valid_589413 = validateParameter(valid_589413, JBool, required = false,
                                 default = newJBool(true))
  if valid_589413 != nil:
    section.add "prettyPrint", valid_589413
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

proc call*(call_589415: Call_VisionProjectsLocationsProductsPurge_589399;
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
  let valid = call_589415.validator(path, query, header, formData, body)
  let scheme = call_589415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589415.url(scheme.get, call_589415.host, call_589415.base,
                         call_589415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589415, url, valid)

proc call*(call_589416: Call_VisionProjectsLocationsProductsPurge_589399;
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
  var path_589417 = newJObject()
  var query_589418 = newJObject()
  var body_589419 = newJObject()
  add(query_589418, "upload_protocol", newJString(uploadProtocol))
  add(query_589418, "fields", newJString(fields))
  add(query_589418, "quotaUser", newJString(quotaUser))
  add(query_589418, "alt", newJString(alt))
  add(query_589418, "oauth_token", newJString(oauthToken))
  add(query_589418, "callback", newJString(callback))
  add(query_589418, "access_token", newJString(accessToken))
  add(query_589418, "uploadType", newJString(uploadType))
  add(path_589417, "parent", newJString(parent))
  add(query_589418, "key", newJString(key))
  add(query_589418, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589419 = body
  add(query_589418, "prettyPrint", newJBool(prettyPrint))
  result = call_589416.call(path_589417, query_589418, nil, nil, body_589419)

var visionProjectsLocationsProductsPurge* = Call_VisionProjectsLocationsProductsPurge_589399(
    name: "visionProjectsLocationsProductsPurge", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{parent}/products:purge",
    validator: validate_VisionProjectsLocationsProductsPurge_589400, base: "/",
    url: url_VisionProjectsLocationsProductsPurge_589401, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductsReferenceImagesCreate_589441 = ref object of OpenApiRestCall_588450
proc url_VisionProjectsLocationsProductsReferenceImagesCreate_589443(
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

proc validate_VisionProjectsLocationsProductsReferenceImagesCreate_589442(
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
  var valid_589444 = path.getOrDefault("parent")
  valid_589444 = validateParameter(valid_589444, JString, required = true,
                                 default = nil)
  if valid_589444 != nil:
    section.add "parent", valid_589444
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
  var valid_589445 = query.getOrDefault("upload_protocol")
  valid_589445 = validateParameter(valid_589445, JString, required = false,
                                 default = nil)
  if valid_589445 != nil:
    section.add "upload_protocol", valid_589445
  var valid_589446 = query.getOrDefault("fields")
  valid_589446 = validateParameter(valid_589446, JString, required = false,
                                 default = nil)
  if valid_589446 != nil:
    section.add "fields", valid_589446
  var valid_589447 = query.getOrDefault("quotaUser")
  valid_589447 = validateParameter(valid_589447, JString, required = false,
                                 default = nil)
  if valid_589447 != nil:
    section.add "quotaUser", valid_589447
  var valid_589448 = query.getOrDefault("alt")
  valid_589448 = validateParameter(valid_589448, JString, required = false,
                                 default = newJString("json"))
  if valid_589448 != nil:
    section.add "alt", valid_589448
  var valid_589449 = query.getOrDefault("referenceImageId")
  valid_589449 = validateParameter(valid_589449, JString, required = false,
                                 default = nil)
  if valid_589449 != nil:
    section.add "referenceImageId", valid_589449
  var valid_589450 = query.getOrDefault("oauth_token")
  valid_589450 = validateParameter(valid_589450, JString, required = false,
                                 default = nil)
  if valid_589450 != nil:
    section.add "oauth_token", valid_589450
  var valid_589451 = query.getOrDefault("callback")
  valid_589451 = validateParameter(valid_589451, JString, required = false,
                                 default = nil)
  if valid_589451 != nil:
    section.add "callback", valid_589451
  var valid_589452 = query.getOrDefault("access_token")
  valid_589452 = validateParameter(valid_589452, JString, required = false,
                                 default = nil)
  if valid_589452 != nil:
    section.add "access_token", valid_589452
  var valid_589453 = query.getOrDefault("uploadType")
  valid_589453 = validateParameter(valid_589453, JString, required = false,
                                 default = nil)
  if valid_589453 != nil:
    section.add "uploadType", valid_589453
  var valid_589454 = query.getOrDefault("key")
  valid_589454 = validateParameter(valid_589454, JString, required = false,
                                 default = nil)
  if valid_589454 != nil:
    section.add "key", valid_589454
  var valid_589455 = query.getOrDefault("$.xgafv")
  valid_589455 = validateParameter(valid_589455, JString, required = false,
                                 default = newJString("1"))
  if valid_589455 != nil:
    section.add "$.xgafv", valid_589455
  var valid_589456 = query.getOrDefault("prettyPrint")
  valid_589456 = validateParameter(valid_589456, JBool, required = false,
                                 default = newJBool(true))
  if valid_589456 != nil:
    section.add "prettyPrint", valid_589456
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

proc call*(call_589458: Call_VisionProjectsLocationsProductsReferenceImagesCreate_589441;
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
  let valid = call_589458.validator(path, query, header, formData, body)
  let scheme = call_589458.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589458.url(scheme.get, call_589458.host, call_589458.base,
                         call_589458.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589458, url, valid)

proc call*(call_589459: Call_VisionProjectsLocationsProductsReferenceImagesCreate_589441;
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
  var path_589460 = newJObject()
  var query_589461 = newJObject()
  var body_589462 = newJObject()
  add(query_589461, "upload_protocol", newJString(uploadProtocol))
  add(query_589461, "fields", newJString(fields))
  add(query_589461, "quotaUser", newJString(quotaUser))
  add(query_589461, "alt", newJString(alt))
  add(query_589461, "referenceImageId", newJString(referenceImageId))
  add(query_589461, "oauth_token", newJString(oauthToken))
  add(query_589461, "callback", newJString(callback))
  add(query_589461, "access_token", newJString(accessToken))
  add(query_589461, "uploadType", newJString(uploadType))
  add(path_589460, "parent", newJString(parent))
  add(query_589461, "key", newJString(key))
  add(query_589461, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589462 = body
  add(query_589461, "prettyPrint", newJBool(prettyPrint))
  result = call_589459.call(path_589460, query_589461, nil, nil, body_589462)

var visionProjectsLocationsProductsReferenceImagesCreate* = Call_VisionProjectsLocationsProductsReferenceImagesCreate_589441(
    name: "visionProjectsLocationsProductsReferenceImagesCreate",
    meth: HttpMethod.HttpPost, host: "vision.googleapis.com",
    route: "/v1/{parent}/referenceImages",
    validator: validate_VisionProjectsLocationsProductsReferenceImagesCreate_589442,
    base: "/", url: url_VisionProjectsLocationsProductsReferenceImagesCreate_589443,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductsReferenceImagesList_589420 = ref object of OpenApiRestCall_588450
proc url_VisionProjectsLocationsProductsReferenceImagesList_589422(
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

proc validate_VisionProjectsLocationsProductsReferenceImagesList_589421(
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
  var valid_589423 = path.getOrDefault("parent")
  valid_589423 = validateParameter(valid_589423, JString, required = true,
                                 default = nil)
  if valid_589423 != nil:
    section.add "parent", valid_589423
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
  var valid_589424 = query.getOrDefault("upload_protocol")
  valid_589424 = validateParameter(valid_589424, JString, required = false,
                                 default = nil)
  if valid_589424 != nil:
    section.add "upload_protocol", valid_589424
  var valid_589425 = query.getOrDefault("fields")
  valid_589425 = validateParameter(valid_589425, JString, required = false,
                                 default = nil)
  if valid_589425 != nil:
    section.add "fields", valid_589425
  var valid_589426 = query.getOrDefault("pageToken")
  valid_589426 = validateParameter(valid_589426, JString, required = false,
                                 default = nil)
  if valid_589426 != nil:
    section.add "pageToken", valid_589426
  var valid_589427 = query.getOrDefault("quotaUser")
  valid_589427 = validateParameter(valid_589427, JString, required = false,
                                 default = nil)
  if valid_589427 != nil:
    section.add "quotaUser", valid_589427
  var valid_589428 = query.getOrDefault("alt")
  valid_589428 = validateParameter(valid_589428, JString, required = false,
                                 default = newJString("json"))
  if valid_589428 != nil:
    section.add "alt", valid_589428
  var valid_589429 = query.getOrDefault("oauth_token")
  valid_589429 = validateParameter(valid_589429, JString, required = false,
                                 default = nil)
  if valid_589429 != nil:
    section.add "oauth_token", valid_589429
  var valid_589430 = query.getOrDefault("callback")
  valid_589430 = validateParameter(valid_589430, JString, required = false,
                                 default = nil)
  if valid_589430 != nil:
    section.add "callback", valid_589430
  var valid_589431 = query.getOrDefault("access_token")
  valid_589431 = validateParameter(valid_589431, JString, required = false,
                                 default = nil)
  if valid_589431 != nil:
    section.add "access_token", valid_589431
  var valid_589432 = query.getOrDefault("uploadType")
  valid_589432 = validateParameter(valid_589432, JString, required = false,
                                 default = nil)
  if valid_589432 != nil:
    section.add "uploadType", valid_589432
  var valid_589433 = query.getOrDefault("key")
  valid_589433 = validateParameter(valid_589433, JString, required = false,
                                 default = nil)
  if valid_589433 != nil:
    section.add "key", valid_589433
  var valid_589434 = query.getOrDefault("$.xgafv")
  valid_589434 = validateParameter(valid_589434, JString, required = false,
                                 default = newJString("1"))
  if valid_589434 != nil:
    section.add "$.xgafv", valid_589434
  var valid_589435 = query.getOrDefault("pageSize")
  valid_589435 = validateParameter(valid_589435, JInt, required = false, default = nil)
  if valid_589435 != nil:
    section.add "pageSize", valid_589435
  var valid_589436 = query.getOrDefault("prettyPrint")
  valid_589436 = validateParameter(valid_589436, JBool, required = false,
                                 default = newJBool(true))
  if valid_589436 != nil:
    section.add "prettyPrint", valid_589436
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589437: Call_VisionProjectsLocationsProductsReferenceImagesList_589420;
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
  let valid = call_589437.validator(path, query, header, formData, body)
  let scheme = call_589437.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589437.url(scheme.get, call_589437.host, call_589437.base,
                         call_589437.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589437, url, valid)

proc call*(call_589438: Call_VisionProjectsLocationsProductsReferenceImagesList_589420;
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
  var path_589439 = newJObject()
  var query_589440 = newJObject()
  add(query_589440, "upload_protocol", newJString(uploadProtocol))
  add(query_589440, "fields", newJString(fields))
  add(query_589440, "pageToken", newJString(pageToken))
  add(query_589440, "quotaUser", newJString(quotaUser))
  add(query_589440, "alt", newJString(alt))
  add(query_589440, "oauth_token", newJString(oauthToken))
  add(query_589440, "callback", newJString(callback))
  add(query_589440, "access_token", newJString(accessToken))
  add(query_589440, "uploadType", newJString(uploadType))
  add(path_589439, "parent", newJString(parent))
  add(query_589440, "key", newJString(key))
  add(query_589440, "$.xgafv", newJString(Xgafv))
  add(query_589440, "pageSize", newJInt(pageSize))
  add(query_589440, "prettyPrint", newJBool(prettyPrint))
  result = call_589438.call(path_589439, query_589440, nil, nil, nil)

var visionProjectsLocationsProductsReferenceImagesList* = Call_VisionProjectsLocationsProductsReferenceImagesList_589420(
    name: "visionProjectsLocationsProductsReferenceImagesList",
    meth: HttpMethod.HttpGet, host: "vision.googleapis.com",
    route: "/v1/{parent}/referenceImages",
    validator: validate_VisionProjectsLocationsProductsReferenceImagesList_589421,
    base: "/", url: url_VisionProjectsLocationsProductsReferenceImagesList_589422,
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
