
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

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

  OpenApiRestCall_579373 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579373](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579373): Option[Scheme] {.used.} =
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
  Call_VisionFilesAnnotate_579644 = ref object of OpenApiRestCall_579373
proc url_VisionFilesAnnotate_579646(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_VisionFilesAnnotate_579645(path: JsonNode; query: JsonNode;
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
  var valid_579758 = query.getOrDefault("key")
  valid_579758 = validateParameter(valid_579758, JString, required = false,
                                 default = nil)
  if valid_579758 != nil:
    section.add "key", valid_579758
  var valid_579772 = query.getOrDefault("prettyPrint")
  valid_579772 = validateParameter(valid_579772, JBool, required = false,
                                 default = newJBool(true))
  if valid_579772 != nil:
    section.add "prettyPrint", valid_579772
  var valid_579773 = query.getOrDefault("oauth_token")
  valid_579773 = validateParameter(valid_579773, JString, required = false,
                                 default = nil)
  if valid_579773 != nil:
    section.add "oauth_token", valid_579773
  var valid_579774 = query.getOrDefault("$.xgafv")
  valid_579774 = validateParameter(valid_579774, JString, required = false,
                                 default = newJString("1"))
  if valid_579774 != nil:
    section.add "$.xgafv", valid_579774
  var valid_579775 = query.getOrDefault("alt")
  valid_579775 = validateParameter(valid_579775, JString, required = false,
                                 default = newJString("json"))
  if valid_579775 != nil:
    section.add "alt", valid_579775
  var valid_579776 = query.getOrDefault("uploadType")
  valid_579776 = validateParameter(valid_579776, JString, required = false,
                                 default = nil)
  if valid_579776 != nil:
    section.add "uploadType", valid_579776
  var valid_579777 = query.getOrDefault("quotaUser")
  valid_579777 = validateParameter(valid_579777, JString, required = false,
                                 default = nil)
  if valid_579777 != nil:
    section.add "quotaUser", valid_579777
  var valid_579778 = query.getOrDefault("callback")
  valid_579778 = validateParameter(valid_579778, JString, required = false,
                                 default = nil)
  if valid_579778 != nil:
    section.add "callback", valid_579778
  var valid_579779 = query.getOrDefault("fields")
  valid_579779 = validateParameter(valid_579779, JString, required = false,
                                 default = nil)
  if valid_579779 != nil:
    section.add "fields", valid_579779
  var valid_579780 = query.getOrDefault("access_token")
  valid_579780 = validateParameter(valid_579780, JString, required = false,
                                 default = nil)
  if valid_579780 != nil:
    section.add "access_token", valid_579780
  var valid_579781 = query.getOrDefault("upload_protocol")
  valid_579781 = validateParameter(valid_579781, JString, required = false,
                                 default = nil)
  if valid_579781 != nil:
    section.add "upload_protocol", valid_579781
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

proc call*(call_579805: Call_VisionFilesAnnotate_579644; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Service that performs image detection and annotation for a batch of files.
  ## Now only "application/pdf", "image/tiff" and "image/gif" are supported.
  ## 
  ## This service will extract at most 5 (customers can specify which 5 in
  ## AnnotateFileRequest.pages) frames (gif) or pages (pdf or tiff) from each
  ## file provided and perform detection and annotation for each image
  ## extracted.
  ## 
  let valid = call_579805.validator(path, query, header, formData, body)
  let scheme = call_579805.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579805.url(scheme.get, call_579805.host, call_579805.base,
                         call_579805.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579805, url, valid)

proc call*(call_579876: Call_VisionFilesAnnotate_579644; key: string = "";
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
  var query_579877 = newJObject()
  var body_579879 = newJObject()
  add(query_579877, "key", newJString(key))
  add(query_579877, "prettyPrint", newJBool(prettyPrint))
  add(query_579877, "oauth_token", newJString(oauthToken))
  add(query_579877, "$.xgafv", newJString(Xgafv))
  add(query_579877, "alt", newJString(alt))
  add(query_579877, "uploadType", newJString(uploadType))
  add(query_579877, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579879 = body
  add(query_579877, "callback", newJString(callback))
  add(query_579877, "fields", newJString(fields))
  add(query_579877, "access_token", newJString(accessToken))
  add(query_579877, "upload_protocol", newJString(uploadProtocol))
  result = call_579876.call(nil, query_579877, nil, nil, body_579879)

var visionFilesAnnotate* = Call_VisionFilesAnnotate_579644(
    name: "visionFilesAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/files:annotate",
    validator: validate_VisionFilesAnnotate_579645, base: "/",
    url: url_VisionFilesAnnotate_579646, schemes: {Scheme.Https})
type
  Call_VisionFilesAsyncBatchAnnotate_579918 = ref object of OpenApiRestCall_579373
proc url_VisionFilesAsyncBatchAnnotate_579920(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_VisionFilesAsyncBatchAnnotate_579919(path: JsonNode; query: JsonNode;
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
  var valid_579921 = query.getOrDefault("key")
  valid_579921 = validateParameter(valid_579921, JString, required = false,
                                 default = nil)
  if valid_579921 != nil:
    section.add "key", valid_579921
  var valid_579922 = query.getOrDefault("prettyPrint")
  valid_579922 = validateParameter(valid_579922, JBool, required = false,
                                 default = newJBool(true))
  if valid_579922 != nil:
    section.add "prettyPrint", valid_579922
  var valid_579923 = query.getOrDefault("oauth_token")
  valid_579923 = validateParameter(valid_579923, JString, required = false,
                                 default = nil)
  if valid_579923 != nil:
    section.add "oauth_token", valid_579923
  var valid_579924 = query.getOrDefault("$.xgafv")
  valid_579924 = validateParameter(valid_579924, JString, required = false,
                                 default = newJString("1"))
  if valid_579924 != nil:
    section.add "$.xgafv", valid_579924
  var valid_579925 = query.getOrDefault("alt")
  valid_579925 = validateParameter(valid_579925, JString, required = false,
                                 default = newJString("json"))
  if valid_579925 != nil:
    section.add "alt", valid_579925
  var valid_579926 = query.getOrDefault("uploadType")
  valid_579926 = validateParameter(valid_579926, JString, required = false,
                                 default = nil)
  if valid_579926 != nil:
    section.add "uploadType", valid_579926
  var valid_579927 = query.getOrDefault("quotaUser")
  valid_579927 = validateParameter(valid_579927, JString, required = false,
                                 default = nil)
  if valid_579927 != nil:
    section.add "quotaUser", valid_579927
  var valid_579928 = query.getOrDefault("callback")
  valid_579928 = validateParameter(valid_579928, JString, required = false,
                                 default = nil)
  if valid_579928 != nil:
    section.add "callback", valid_579928
  var valid_579929 = query.getOrDefault("fields")
  valid_579929 = validateParameter(valid_579929, JString, required = false,
                                 default = nil)
  if valid_579929 != nil:
    section.add "fields", valid_579929
  var valid_579930 = query.getOrDefault("access_token")
  valid_579930 = validateParameter(valid_579930, JString, required = false,
                                 default = nil)
  if valid_579930 != nil:
    section.add "access_token", valid_579930
  var valid_579931 = query.getOrDefault("upload_protocol")
  valid_579931 = validateParameter(valid_579931, JString, required = false,
                                 default = nil)
  if valid_579931 != nil:
    section.add "upload_protocol", valid_579931
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

proc call*(call_579933: Call_VisionFilesAsyncBatchAnnotate_579918; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Run asynchronous image detection and annotation for a list of generic
  ## files, such as PDF files, which may contain multiple pages and multiple
  ## images per page. Progress and results can be retrieved through the
  ## `google.longrunning.Operations` interface.
  ## `Operation.metadata` contains `OperationMetadata` (metadata).
  ## `Operation.response` contains `AsyncBatchAnnotateFilesResponse` (results).
  ## 
  let valid = call_579933.validator(path, query, header, formData, body)
  let scheme = call_579933.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579933.url(scheme.get, call_579933.host, call_579933.base,
                         call_579933.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579933, url, valid)

proc call*(call_579934: Call_VisionFilesAsyncBatchAnnotate_579918;
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
  var query_579935 = newJObject()
  var body_579936 = newJObject()
  add(query_579935, "key", newJString(key))
  add(query_579935, "prettyPrint", newJBool(prettyPrint))
  add(query_579935, "oauth_token", newJString(oauthToken))
  add(query_579935, "$.xgafv", newJString(Xgafv))
  add(query_579935, "alt", newJString(alt))
  add(query_579935, "uploadType", newJString(uploadType))
  add(query_579935, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579936 = body
  add(query_579935, "callback", newJString(callback))
  add(query_579935, "fields", newJString(fields))
  add(query_579935, "access_token", newJString(accessToken))
  add(query_579935, "upload_protocol", newJString(uploadProtocol))
  result = call_579934.call(nil, query_579935, nil, nil, body_579936)

var visionFilesAsyncBatchAnnotate* = Call_VisionFilesAsyncBatchAnnotate_579918(
    name: "visionFilesAsyncBatchAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/files:asyncBatchAnnotate",
    validator: validate_VisionFilesAsyncBatchAnnotate_579919, base: "/",
    url: url_VisionFilesAsyncBatchAnnotate_579920, schemes: {Scheme.Https})
type
  Call_VisionImagesAnnotate_579937 = ref object of OpenApiRestCall_579373
proc url_VisionImagesAnnotate_579939(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_VisionImagesAnnotate_579938(path: JsonNode; query: JsonNode;
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
  var valid_579940 = query.getOrDefault("key")
  valid_579940 = validateParameter(valid_579940, JString, required = false,
                                 default = nil)
  if valid_579940 != nil:
    section.add "key", valid_579940
  var valid_579941 = query.getOrDefault("prettyPrint")
  valid_579941 = validateParameter(valid_579941, JBool, required = false,
                                 default = newJBool(true))
  if valid_579941 != nil:
    section.add "prettyPrint", valid_579941
  var valid_579942 = query.getOrDefault("oauth_token")
  valid_579942 = validateParameter(valid_579942, JString, required = false,
                                 default = nil)
  if valid_579942 != nil:
    section.add "oauth_token", valid_579942
  var valid_579943 = query.getOrDefault("$.xgafv")
  valid_579943 = validateParameter(valid_579943, JString, required = false,
                                 default = newJString("1"))
  if valid_579943 != nil:
    section.add "$.xgafv", valid_579943
  var valid_579944 = query.getOrDefault("alt")
  valid_579944 = validateParameter(valid_579944, JString, required = false,
                                 default = newJString("json"))
  if valid_579944 != nil:
    section.add "alt", valid_579944
  var valid_579945 = query.getOrDefault("uploadType")
  valid_579945 = validateParameter(valid_579945, JString, required = false,
                                 default = nil)
  if valid_579945 != nil:
    section.add "uploadType", valid_579945
  var valid_579946 = query.getOrDefault("quotaUser")
  valid_579946 = validateParameter(valid_579946, JString, required = false,
                                 default = nil)
  if valid_579946 != nil:
    section.add "quotaUser", valid_579946
  var valid_579947 = query.getOrDefault("callback")
  valid_579947 = validateParameter(valid_579947, JString, required = false,
                                 default = nil)
  if valid_579947 != nil:
    section.add "callback", valid_579947
  var valid_579948 = query.getOrDefault("fields")
  valid_579948 = validateParameter(valid_579948, JString, required = false,
                                 default = nil)
  if valid_579948 != nil:
    section.add "fields", valid_579948
  var valid_579949 = query.getOrDefault("access_token")
  valid_579949 = validateParameter(valid_579949, JString, required = false,
                                 default = nil)
  if valid_579949 != nil:
    section.add "access_token", valid_579949
  var valid_579950 = query.getOrDefault("upload_protocol")
  valid_579950 = validateParameter(valid_579950, JString, required = false,
                                 default = nil)
  if valid_579950 != nil:
    section.add "upload_protocol", valid_579950
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

proc call*(call_579952: Call_VisionImagesAnnotate_579937; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Run image detection and annotation for a batch of images.
  ## 
  let valid = call_579952.validator(path, query, header, formData, body)
  let scheme = call_579952.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579952.url(scheme.get, call_579952.host, call_579952.base,
                         call_579952.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579952, url, valid)

proc call*(call_579953: Call_VisionImagesAnnotate_579937; key: string = "";
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
  var query_579954 = newJObject()
  var body_579955 = newJObject()
  add(query_579954, "key", newJString(key))
  add(query_579954, "prettyPrint", newJBool(prettyPrint))
  add(query_579954, "oauth_token", newJString(oauthToken))
  add(query_579954, "$.xgafv", newJString(Xgafv))
  add(query_579954, "alt", newJString(alt))
  add(query_579954, "uploadType", newJString(uploadType))
  add(query_579954, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579955 = body
  add(query_579954, "callback", newJString(callback))
  add(query_579954, "fields", newJString(fields))
  add(query_579954, "access_token", newJString(accessToken))
  add(query_579954, "upload_protocol", newJString(uploadProtocol))
  result = call_579953.call(nil, query_579954, nil, nil, body_579955)

var visionImagesAnnotate* = Call_VisionImagesAnnotate_579937(
    name: "visionImagesAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/images:annotate",
    validator: validate_VisionImagesAnnotate_579938, base: "/",
    url: url_VisionImagesAnnotate_579939, schemes: {Scheme.Https})
type
  Call_VisionImagesAsyncBatchAnnotate_579956 = ref object of OpenApiRestCall_579373
proc url_VisionImagesAsyncBatchAnnotate_579958(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_VisionImagesAsyncBatchAnnotate_579957(path: JsonNode;
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
  var valid_579959 = query.getOrDefault("key")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = nil)
  if valid_579959 != nil:
    section.add "key", valid_579959
  var valid_579960 = query.getOrDefault("prettyPrint")
  valid_579960 = validateParameter(valid_579960, JBool, required = false,
                                 default = newJBool(true))
  if valid_579960 != nil:
    section.add "prettyPrint", valid_579960
  var valid_579961 = query.getOrDefault("oauth_token")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = nil)
  if valid_579961 != nil:
    section.add "oauth_token", valid_579961
  var valid_579962 = query.getOrDefault("$.xgafv")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = newJString("1"))
  if valid_579962 != nil:
    section.add "$.xgafv", valid_579962
  var valid_579963 = query.getOrDefault("alt")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = newJString("json"))
  if valid_579963 != nil:
    section.add "alt", valid_579963
  var valid_579964 = query.getOrDefault("uploadType")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "uploadType", valid_579964
  var valid_579965 = query.getOrDefault("quotaUser")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "quotaUser", valid_579965
  var valid_579966 = query.getOrDefault("callback")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "callback", valid_579966
  var valid_579967 = query.getOrDefault("fields")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "fields", valid_579967
  var valid_579968 = query.getOrDefault("access_token")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "access_token", valid_579968
  var valid_579969 = query.getOrDefault("upload_protocol")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "upload_protocol", valid_579969
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

proc call*(call_579971: Call_VisionImagesAsyncBatchAnnotate_579956; path: JsonNode;
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
  let valid = call_579971.validator(path, query, header, formData, body)
  let scheme = call_579971.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579971.url(scheme.get, call_579971.host, call_579971.base,
                         call_579971.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579971, url, valid)

proc call*(call_579972: Call_VisionImagesAsyncBatchAnnotate_579956;
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
  var query_579973 = newJObject()
  var body_579974 = newJObject()
  add(query_579973, "key", newJString(key))
  add(query_579973, "prettyPrint", newJBool(prettyPrint))
  add(query_579973, "oauth_token", newJString(oauthToken))
  add(query_579973, "$.xgafv", newJString(Xgafv))
  add(query_579973, "alt", newJString(alt))
  add(query_579973, "uploadType", newJString(uploadType))
  add(query_579973, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579974 = body
  add(query_579973, "callback", newJString(callback))
  add(query_579973, "fields", newJString(fields))
  add(query_579973, "access_token", newJString(accessToken))
  add(query_579973, "upload_protocol", newJString(uploadProtocol))
  result = call_579972.call(nil, query_579973, nil, nil, body_579974)

var visionImagesAsyncBatchAnnotate* = Call_VisionImagesAsyncBatchAnnotate_579956(
    name: "visionImagesAsyncBatchAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/images:asyncBatchAnnotate",
    validator: validate_VisionImagesAsyncBatchAnnotate_579957, base: "/",
    url: url_VisionImagesAsyncBatchAnnotate_579958, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsOperationsGet_579975 = ref object of OpenApiRestCall_579373
proc url_VisionProjectsLocationsOperationsGet_579977(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VisionProjectsLocationsOperationsGet_579976(path: JsonNode;
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
  var valid_579992 = path.getOrDefault("name")
  valid_579992 = validateParameter(valid_579992, JString, required = true,
                                 default = nil)
  if valid_579992 != nil:
    section.add "name", valid_579992
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
  var valid_579993 = query.getOrDefault("key")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "key", valid_579993
  var valid_579994 = query.getOrDefault("prettyPrint")
  valid_579994 = validateParameter(valid_579994, JBool, required = false,
                                 default = newJBool(true))
  if valid_579994 != nil:
    section.add "prettyPrint", valid_579994
  var valid_579995 = query.getOrDefault("oauth_token")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "oauth_token", valid_579995
  var valid_579996 = query.getOrDefault("$.xgafv")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = newJString("1"))
  if valid_579996 != nil:
    section.add "$.xgafv", valid_579996
  var valid_579997 = query.getOrDefault("alt")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = newJString("json"))
  if valid_579997 != nil:
    section.add "alt", valid_579997
  var valid_579998 = query.getOrDefault("uploadType")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "uploadType", valid_579998
  var valid_579999 = query.getOrDefault("quotaUser")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "quotaUser", valid_579999
  var valid_580000 = query.getOrDefault("callback")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "callback", valid_580000
  var valid_580001 = query.getOrDefault("fields")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "fields", valid_580001
  var valid_580002 = query.getOrDefault("access_token")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "access_token", valid_580002
  var valid_580003 = query.getOrDefault("upload_protocol")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "upload_protocol", valid_580003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580004: Call_VisionProjectsLocationsOperationsGet_579975;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_580004.validator(path, query, header, formData, body)
  let scheme = call_580004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580004.url(scheme.get, call_580004.host, call_580004.base,
                         call_580004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580004, url, valid)

proc call*(call_580005: Call_VisionProjectsLocationsOperationsGet_579975;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## visionProjectsLocationsOperationsGet
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
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
  ##       : The name of the operation resource.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580006 = newJObject()
  var query_580007 = newJObject()
  add(query_580007, "key", newJString(key))
  add(query_580007, "prettyPrint", newJBool(prettyPrint))
  add(query_580007, "oauth_token", newJString(oauthToken))
  add(query_580007, "$.xgafv", newJString(Xgafv))
  add(query_580007, "alt", newJString(alt))
  add(query_580007, "uploadType", newJString(uploadType))
  add(query_580007, "quotaUser", newJString(quotaUser))
  add(path_580006, "name", newJString(name))
  add(query_580007, "callback", newJString(callback))
  add(query_580007, "fields", newJString(fields))
  add(query_580007, "access_token", newJString(accessToken))
  add(query_580007, "upload_protocol", newJString(uploadProtocol))
  result = call_580005.call(path_580006, query_580007, nil, nil, nil)

var visionProjectsLocationsOperationsGet* = Call_VisionProjectsLocationsOperationsGet_579975(
    name: "visionProjectsLocationsOperationsGet", meth: HttpMethod.HttpGet,
    host: "vision.googleapis.com", route: "/v1/{name}",
    validator: validate_VisionProjectsLocationsOperationsGet_579976, base: "/",
    url: url_VisionProjectsLocationsOperationsGet_579977, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsPatch_580027 = ref object of OpenApiRestCall_579373
proc url_VisionProjectsLocationsProductSetsPatch_580029(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VisionProjectsLocationsProductSetsPatch_580028(path: JsonNode;
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
  var valid_580030 = path.getOrDefault("name")
  valid_580030 = validateParameter(valid_580030, JString, required = true,
                                 default = nil)
  if valid_580030 != nil:
    section.add "name", valid_580030
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
  var valid_580031 = query.getOrDefault("key")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "key", valid_580031
  var valid_580032 = query.getOrDefault("prettyPrint")
  valid_580032 = validateParameter(valid_580032, JBool, required = false,
                                 default = newJBool(true))
  if valid_580032 != nil:
    section.add "prettyPrint", valid_580032
  var valid_580033 = query.getOrDefault("oauth_token")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "oauth_token", valid_580033
  var valid_580034 = query.getOrDefault("$.xgafv")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = newJString("1"))
  if valid_580034 != nil:
    section.add "$.xgafv", valid_580034
  var valid_580035 = query.getOrDefault("alt")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = newJString("json"))
  if valid_580035 != nil:
    section.add "alt", valid_580035
  var valid_580036 = query.getOrDefault("uploadType")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "uploadType", valid_580036
  var valid_580037 = query.getOrDefault("quotaUser")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "quotaUser", valid_580037
  var valid_580038 = query.getOrDefault("updateMask")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "updateMask", valid_580038
  var valid_580039 = query.getOrDefault("callback")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "callback", valid_580039
  var valid_580040 = query.getOrDefault("fields")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "fields", valid_580040
  var valid_580041 = query.getOrDefault("access_token")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "access_token", valid_580041
  var valid_580042 = query.getOrDefault("upload_protocol")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "upload_protocol", valid_580042
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

proc call*(call_580044: Call_VisionProjectsLocationsProductSetsPatch_580027;
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
  let valid = call_580044.validator(path, query, header, formData, body)
  let scheme = call_580044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580044.url(scheme.get, call_580044.host, call_580044.base,
                         call_580044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580044, url, valid)

proc call*(call_580045: Call_VisionProjectsLocationsProductSetsPatch_580027;
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
  var path_580046 = newJObject()
  var query_580047 = newJObject()
  var body_580048 = newJObject()
  add(query_580047, "key", newJString(key))
  add(query_580047, "prettyPrint", newJBool(prettyPrint))
  add(query_580047, "oauth_token", newJString(oauthToken))
  add(query_580047, "$.xgafv", newJString(Xgafv))
  add(query_580047, "alt", newJString(alt))
  add(query_580047, "uploadType", newJString(uploadType))
  add(query_580047, "quotaUser", newJString(quotaUser))
  add(path_580046, "name", newJString(name))
  add(query_580047, "updateMask", newJString(updateMask))
  if body != nil:
    body_580048 = body
  add(query_580047, "callback", newJString(callback))
  add(query_580047, "fields", newJString(fields))
  add(query_580047, "access_token", newJString(accessToken))
  add(query_580047, "upload_protocol", newJString(uploadProtocol))
  result = call_580045.call(path_580046, query_580047, nil, nil, body_580048)

var visionProjectsLocationsProductSetsPatch* = Call_VisionProjectsLocationsProductSetsPatch_580027(
    name: "visionProjectsLocationsProductSetsPatch", meth: HttpMethod.HttpPatch,
    host: "vision.googleapis.com", route: "/v1/{name}",
    validator: validate_VisionProjectsLocationsProductSetsPatch_580028, base: "/",
    url: url_VisionProjectsLocationsProductSetsPatch_580029,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsDelete_580008 = ref object of OpenApiRestCall_579373
proc url_VisionProjectsLocationsProductSetsDelete_580010(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VisionProjectsLocationsProductSetsDelete_580009(path: JsonNode;
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
  var valid_580011 = path.getOrDefault("name")
  valid_580011 = validateParameter(valid_580011, JString, required = true,
                                 default = nil)
  if valid_580011 != nil:
    section.add "name", valid_580011
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
  var valid_580012 = query.getOrDefault("key")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "key", valid_580012
  var valid_580013 = query.getOrDefault("prettyPrint")
  valid_580013 = validateParameter(valid_580013, JBool, required = false,
                                 default = newJBool(true))
  if valid_580013 != nil:
    section.add "prettyPrint", valid_580013
  var valid_580014 = query.getOrDefault("oauth_token")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "oauth_token", valid_580014
  var valid_580015 = query.getOrDefault("$.xgafv")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = newJString("1"))
  if valid_580015 != nil:
    section.add "$.xgafv", valid_580015
  var valid_580016 = query.getOrDefault("alt")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = newJString("json"))
  if valid_580016 != nil:
    section.add "alt", valid_580016
  var valid_580017 = query.getOrDefault("uploadType")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "uploadType", valid_580017
  var valid_580018 = query.getOrDefault("quotaUser")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "quotaUser", valid_580018
  var valid_580019 = query.getOrDefault("callback")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "callback", valid_580019
  var valid_580020 = query.getOrDefault("fields")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "fields", valid_580020
  var valid_580021 = query.getOrDefault("access_token")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "access_token", valid_580021
  var valid_580022 = query.getOrDefault("upload_protocol")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "upload_protocol", valid_580022
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580023: Call_VisionProjectsLocationsProductSetsDelete_580008;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently deletes a ProductSet. Products and ReferenceImages in the
  ## ProductSet are not deleted.
  ## 
  ## The actual image files are not deleted from Google Cloud Storage.
  ## 
  let valid = call_580023.validator(path, query, header, formData, body)
  let scheme = call_580023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580023.url(scheme.get, call_580023.host, call_580023.base,
                         call_580023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580023, url, valid)

proc call*(call_580024: Call_VisionProjectsLocationsProductSetsDelete_580008;
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
  var path_580025 = newJObject()
  var query_580026 = newJObject()
  add(query_580026, "key", newJString(key))
  add(query_580026, "prettyPrint", newJBool(prettyPrint))
  add(query_580026, "oauth_token", newJString(oauthToken))
  add(query_580026, "$.xgafv", newJString(Xgafv))
  add(query_580026, "alt", newJString(alt))
  add(query_580026, "uploadType", newJString(uploadType))
  add(query_580026, "quotaUser", newJString(quotaUser))
  add(path_580025, "name", newJString(name))
  add(query_580026, "callback", newJString(callback))
  add(query_580026, "fields", newJString(fields))
  add(query_580026, "access_token", newJString(accessToken))
  add(query_580026, "upload_protocol", newJString(uploadProtocol))
  result = call_580024.call(path_580025, query_580026, nil, nil, nil)

var visionProjectsLocationsProductSetsDelete* = Call_VisionProjectsLocationsProductSetsDelete_580008(
    name: "visionProjectsLocationsProductSetsDelete", meth: HttpMethod.HttpDelete,
    host: "vision.googleapis.com", route: "/v1/{name}",
    validator: validate_VisionProjectsLocationsProductSetsDelete_580009,
    base: "/", url: url_VisionProjectsLocationsProductSetsDelete_580010,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsProductsList_580049 = ref object of OpenApiRestCall_579373
proc url_VisionProjectsLocationsProductSetsProductsList_580051(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VisionProjectsLocationsProductSetsProductsList_580050(
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
  var valid_580052 = path.getOrDefault("name")
  valid_580052 = validateParameter(valid_580052, JString, required = true,
                                 default = nil)
  if valid_580052 != nil:
    section.add "name", valid_580052
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
  var valid_580053 = query.getOrDefault("key")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "key", valid_580053
  var valid_580054 = query.getOrDefault("prettyPrint")
  valid_580054 = validateParameter(valid_580054, JBool, required = false,
                                 default = newJBool(true))
  if valid_580054 != nil:
    section.add "prettyPrint", valid_580054
  var valid_580055 = query.getOrDefault("oauth_token")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "oauth_token", valid_580055
  var valid_580056 = query.getOrDefault("$.xgafv")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = newJString("1"))
  if valid_580056 != nil:
    section.add "$.xgafv", valid_580056
  var valid_580057 = query.getOrDefault("pageSize")
  valid_580057 = validateParameter(valid_580057, JInt, required = false, default = nil)
  if valid_580057 != nil:
    section.add "pageSize", valid_580057
  var valid_580058 = query.getOrDefault("alt")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = newJString("json"))
  if valid_580058 != nil:
    section.add "alt", valid_580058
  var valid_580059 = query.getOrDefault("uploadType")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "uploadType", valid_580059
  var valid_580060 = query.getOrDefault("quotaUser")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "quotaUser", valid_580060
  var valid_580061 = query.getOrDefault("pageToken")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "pageToken", valid_580061
  var valid_580062 = query.getOrDefault("callback")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "callback", valid_580062
  var valid_580063 = query.getOrDefault("fields")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "fields", valid_580063
  var valid_580064 = query.getOrDefault("access_token")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "access_token", valid_580064
  var valid_580065 = query.getOrDefault("upload_protocol")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "upload_protocol", valid_580065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580066: Call_VisionProjectsLocationsProductSetsProductsList_580049;
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
  let valid = call_580066.validator(path, query, header, formData, body)
  let scheme = call_580066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580066.url(scheme.get, call_580066.host, call_580066.base,
                         call_580066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580066, url, valid)

proc call*(call_580067: Call_VisionProjectsLocationsProductSetsProductsList_580049;
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
  var path_580068 = newJObject()
  var query_580069 = newJObject()
  add(query_580069, "key", newJString(key))
  add(query_580069, "prettyPrint", newJBool(prettyPrint))
  add(query_580069, "oauth_token", newJString(oauthToken))
  add(query_580069, "$.xgafv", newJString(Xgafv))
  add(query_580069, "pageSize", newJInt(pageSize))
  add(query_580069, "alt", newJString(alt))
  add(query_580069, "uploadType", newJString(uploadType))
  add(query_580069, "quotaUser", newJString(quotaUser))
  add(path_580068, "name", newJString(name))
  add(query_580069, "pageToken", newJString(pageToken))
  add(query_580069, "callback", newJString(callback))
  add(query_580069, "fields", newJString(fields))
  add(query_580069, "access_token", newJString(accessToken))
  add(query_580069, "upload_protocol", newJString(uploadProtocol))
  result = call_580067.call(path_580068, query_580069, nil, nil, nil)

var visionProjectsLocationsProductSetsProductsList* = Call_VisionProjectsLocationsProductSetsProductsList_580049(
    name: "visionProjectsLocationsProductSetsProductsList",
    meth: HttpMethod.HttpGet, host: "vision.googleapis.com",
    route: "/v1/{name}/products",
    validator: validate_VisionProjectsLocationsProductSetsProductsList_580050,
    base: "/", url: url_VisionProjectsLocationsProductSetsProductsList_580051,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsAddProduct_580070 = ref object of OpenApiRestCall_579373
proc url_VisionProjectsLocationsProductSetsAddProduct_580072(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VisionProjectsLocationsProductSetsAddProduct_580071(path: JsonNode;
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
  var valid_580073 = path.getOrDefault("name")
  valid_580073 = validateParameter(valid_580073, JString, required = true,
                                 default = nil)
  if valid_580073 != nil:
    section.add "name", valid_580073
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
  var valid_580074 = query.getOrDefault("key")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "key", valid_580074
  var valid_580075 = query.getOrDefault("prettyPrint")
  valid_580075 = validateParameter(valid_580075, JBool, required = false,
                                 default = newJBool(true))
  if valid_580075 != nil:
    section.add "prettyPrint", valid_580075
  var valid_580076 = query.getOrDefault("oauth_token")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "oauth_token", valid_580076
  var valid_580077 = query.getOrDefault("$.xgafv")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = newJString("1"))
  if valid_580077 != nil:
    section.add "$.xgafv", valid_580077
  var valid_580078 = query.getOrDefault("alt")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = newJString("json"))
  if valid_580078 != nil:
    section.add "alt", valid_580078
  var valid_580079 = query.getOrDefault("uploadType")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "uploadType", valid_580079
  var valid_580080 = query.getOrDefault("quotaUser")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "quotaUser", valid_580080
  var valid_580081 = query.getOrDefault("callback")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "callback", valid_580081
  var valid_580082 = query.getOrDefault("fields")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "fields", valid_580082
  var valid_580083 = query.getOrDefault("access_token")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "access_token", valid_580083
  var valid_580084 = query.getOrDefault("upload_protocol")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "upload_protocol", valid_580084
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

proc call*(call_580086: Call_VisionProjectsLocationsProductSetsAddProduct_580070;
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
  let valid = call_580086.validator(path, query, header, formData, body)
  let scheme = call_580086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580086.url(scheme.get, call_580086.host, call_580086.base,
                         call_580086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580086, url, valid)

proc call*(call_580087: Call_VisionProjectsLocationsProductSetsAddProduct_580070;
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
  var path_580088 = newJObject()
  var query_580089 = newJObject()
  var body_580090 = newJObject()
  add(query_580089, "key", newJString(key))
  add(query_580089, "prettyPrint", newJBool(prettyPrint))
  add(query_580089, "oauth_token", newJString(oauthToken))
  add(query_580089, "$.xgafv", newJString(Xgafv))
  add(query_580089, "alt", newJString(alt))
  add(query_580089, "uploadType", newJString(uploadType))
  add(query_580089, "quotaUser", newJString(quotaUser))
  add(path_580088, "name", newJString(name))
  if body != nil:
    body_580090 = body
  add(query_580089, "callback", newJString(callback))
  add(query_580089, "fields", newJString(fields))
  add(query_580089, "access_token", newJString(accessToken))
  add(query_580089, "upload_protocol", newJString(uploadProtocol))
  result = call_580087.call(path_580088, query_580089, nil, nil, body_580090)

var visionProjectsLocationsProductSetsAddProduct* = Call_VisionProjectsLocationsProductSetsAddProduct_580070(
    name: "visionProjectsLocationsProductSetsAddProduct",
    meth: HttpMethod.HttpPost, host: "vision.googleapis.com",
    route: "/v1/{name}:addProduct",
    validator: validate_VisionProjectsLocationsProductSetsAddProduct_580071,
    base: "/", url: url_VisionProjectsLocationsProductSetsAddProduct_580072,
    schemes: {Scheme.Https})
type
  Call_VisionOperationsCancel_580091 = ref object of OpenApiRestCall_579373
proc url_VisionOperationsCancel_580093(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VisionOperationsCancel_580092(path: JsonNode; query: JsonNode;
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
  var valid_580094 = path.getOrDefault("name")
  valid_580094 = validateParameter(valid_580094, JString, required = true,
                                 default = nil)
  if valid_580094 != nil:
    section.add "name", valid_580094
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
  var valid_580095 = query.getOrDefault("key")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "key", valid_580095
  var valid_580096 = query.getOrDefault("prettyPrint")
  valid_580096 = validateParameter(valid_580096, JBool, required = false,
                                 default = newJBool(true))
  if valid_580096 != nil:
    section.add "prettyPrint", valid_580096
  var valid_580097 = query.getOrDefault("oauth_token")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "oauth_token", valid_580097
  var valid_580098 = query.getOrDefault("$.xgafv")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = newJString("1"))
  if valid_580098 != nil:
    section.add "$.xgafv", valid_580098
  var valid_580099 = query.getOrDefault("alt")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = newJString("json"))
  if valid_580099 != nil:
    section.add "alt", valid_580099
  var valid_580100 = query.getOrDefault("uploadType")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "uploadType", valid_580100
  var valid_580101 = query.getOrDefault("quotaUser")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "quotaUser", valid_580101
  var valid_580102 = query.getOrDefault("callback")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "callback", valid_580102
  var valid_580103 = query.getOrDefault("fields")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "fields", valid_580103
  var valid_580104 = query.getOrDefault("access_token")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "access_token", valid_580104
  var valid_580105 = query.getOrDefault("upload_protocol")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "upload_protocol", valid_580105
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

proc call*(call_580107: Call_VisionOperationsCancel_580091; path: JsonNode;
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
  let valid = call_580107.validator(path, query, header, formData, body)
  let scheme = call_580107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580107.url(scheme.get, call_580107.host, call_580107.base,
                         call_580107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580107, url, valid)

proc call*(call_580108: Call_VisionOperationsCancel_580091; name: string;
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
  var path_580109 = newJObject()
  var query_580110 = newJObject()
  var body_580111 = newJObject()
  add(query_580110, "key", newJString(key))
  add(query_580110, "prettyPrint", newJBool(prettyPrint))
  add(query_580110, "oauth_token", newJString(oauthToken))
  add(query_580110, "$.xgafv", newJString(Xgafv))
  add(query_580110, "alt", newJString(alt))
  add(query_580110, "uploadType", newJString(uploadType))
  add(query_580110, "quotaUser", newJString(quotaUser))
  add(path_580109, "name", newJString(name))
  if body != nil:
    body_580111 = body
  add(query_580110, "callback", newJString(callback))
  add(query_580110, "fields", newJString(fields))
  add(query_580110, "access_token", newJString(accessToken))
  add(query_580110, "upload_protocol", newJString(uploadProtocol))
  result = call_580108.call(path_580109, query_580110, nil, nil, body_580111)

var visionOperationsCancel* = Call_VisionOperationsCancel_580091(
    name: "visionOperationsCancel", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_VisionOperationsCancel_580092, base: "/",
    url: url_VisionOperationsCancel_580093, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsRemoveProduct_580112 = ref object of OpenApiRestCall_579373
proc url_VisionProjectsLocationsProductSetsRemoveProduct_580114(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VisionProjectsLocationsProductSetsRemoveProduct_580113(
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
  var valid_580115 = path.getOrDefault("name")
  valid_580115 = validateParameter(valid_580115, JString, required = true,
                                 default = nil)
  if valid_580115 != nil:
    section.add "name", valid_580115
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
  var valid_580116 = query.getOrDefault("key")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "key", valid_580116
  var valid_580117 = query.getOrDefault("prettyPrint")
  valid_580117 = validateParameter(valid_580117, JBool, required = false,
                                 default = newJBool(true))
  if valid_580117 != nil:
    section.add "prettyPrint", valid_580117
  var valid_580118 = query.getOrDefault("oauth_token")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "oauth_token", valid_580118
  var valid_580119 = query.getOrDefault("$.xgafv")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = newJString("1"))
  if valid_580119 != nil:
    section.add "$.xgafv", valid_580119
  var valid_580120 = query.getOrDefault("alt")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = newJString("json"))
  if valid_580120 != nil:
    section.add "alt", valid_580120
  var valid_580121 = query.getOrDefault("uploadType")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "uploadType", valid_580121
  var valid_580122 = query.getOrDefault("quotaUser")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "quotaUser", valid_580122
  var valid_580123 = query.getOrDefault("callback")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "callback", valid_580123
  var valid_580124 = query.getOrDefault("fields")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "fields", valid_580124
  var valid_580125 = query.getOrDefault("access_token")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "access_token", valid_580125
  var valid_580126 = query.getOrDefault("upload_protocol")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "upload_protocol", valid_580126
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

proc call*(call_580128: Call_VisionProjectsLocationsProductSetsRemoveProduct_580112;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a Product from the specified ProductSet.
  ## 
  let valid = call_580128.validator(path, query, header, formData, body)
  let scheme = call_580128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580128.url(scheme.get, call_580128.host, call_580128.base,
                         call_580128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580128, url, valid)

proc call*(call_580129: Call_VisionProjectsLocationsProductSetsRemoveProduct_580112;
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
  var path_580130 = newJObject()
  var query_580131 = newJObject()
  var body_580132 = newJObject()
  add(query_580131, "key", newJString(key))
  add(query_580131, "prettyPrint", newJBool(prettyPrint))
  add(query_580131, "oauth_token", newJString(oauthToken))
  add(query_580131, "$.xgafv", newJString(Xgafv))
  add(query_580131, "alt", newJString(alt))
  add(query_580131, "uploadType", newJString(uploadType))
  add(query_580131, "quotaUser", newJString(quotaUser))
  add(path_580130, "name", newJString(name))
  if body != nil:
    body_580132 = body
  add(query_580131, "callback", newJString(callback))
  add(query_580131, "fields", newJString(fields))
  add(query_580131, "access_token", newJString(accessToken))
  add(query_580131, "upload_protocol", newJString(uploadProtocol))
  result = call_580129.call(path_580130, query_580131, nil, nil, body_580132)

var visionProjectsLocationsProductSetsRemoveProduct* = Call_VisionProjectsLocationsProductSetsRemoveProduct_580112(
    name: "visionProjectsLocationsProductSetsRemoveProduct",
    meth: HttpMethod.HttpPost, host: "vision.googleapis.com",
    route: "/v1/{name}:removeProduct",
    validator: validate_VisionProjectsLocationsProductSetsRemoveProduct_580113,
    base: "/", url: url_VisionProjectsLocationsProductSetsRemoveProduct_580114,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsFilesAnnotate_580133 = ref object of OpenApiRestCall_579373
proc url_VisionProjectsFilesAnnotate_580135(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VisionProjectsFilesAnnotate_580134(path: JsonNode; query: JsonNode;
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
  var valid_580136 = path.getOrDefault("parent")
  valid_580136 = validateParameter(valid_580136, JString, required = true,
                                 default = nil)
  if valid_580136 != nil:
    section.add "parent", valid_580136
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
  var valid_580137 = query.getOrDefault("key")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "key", valid_580137
  var valid_580138 = query.getOrDefault("prettyPrint")
  valid_580138 = validateParameter(valid_580138, JBool, required = false,
                                 default = newJBool(true))
  if valid_580138 != nil:
    section.add "prettyPrint", valid_580138
  var valid_580139 = query.getOrDefault("oauth_token")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "oauth_token", valid_580139
  var valid_580140 = query.getOrDefault("$.xgafv")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = newJString("1"))
  if valid_580140 != nil:
    section.add "$.xgafv", valid_580140
  var valid_580141 = query.getOrDefault("alt")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = newJString("json"))
  if valid_580141 != nil:
    section.add "alt", valid_580141
  var valid_580142 = query.getOrDefault("uploadType")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "uploadType", valid_580142
  var valid_580143 = query.getOrDefault("quotaUser")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "quotaUser", valid_580143
  var valid_580144 = query.getOrDefault("callback")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "callback", valid_580144
  var valid_580145 = query.getOrDefault("fields")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "fields", valid_580145
  var valid_580146 = query.getOrDefault("access_token")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "access_token", valid_580146
  var valid_580147 = query.getOrDefault("upload_protocol")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "upload_protocol", valid_580147
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

proc call*(call_580149: Call_VisionProjectsFilesAnnotate_580133; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Service that performs image detection and annotation for a batch of files.
  ## Now only "application/pdf", "image/tiff" and "image/gif" are supported.
  ## 
  ## This service will extract at most 5 (customers can specify which 5 in
  ## AnnotateFileRequest.pages) frames (gif) or pages (pdf or tiff) from each
  ## file provided and perform detection and annotation for each image
  ## extracted.
  ## 
  let valid = call_580149.validator(path, query, header, formData, body)
  let scheme = call_580149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580149.url(scheme.get, call_580149.host, call_580149.base,
                         call_580149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580149, url, valid)

proc call*(call_580150: Call_VisionProjectsFilesAnnotate_580133; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## visionProjectsFilesAnnotate
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
  var path_580151 = newJObject()
  var query_580152 = newJObject()
  var body_580153 = newJObject()
  add(query_580152, "key", newJString(key))
  add(query_580152, "prettyPrint", newJBool(prettyPrint))
  add(query_580152, "oauth_token", newJString(oauthToken))
  add(query_580152, "$.xgafv", newJString(Xgafv))
  add(query_580152, "alt", newJString(alt))
  add(query_580152, "uploadType", newJString(uploadType))
  add(query_580152, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580153 = body
  add(query_580152, "callback", newJString(callback))
  add(path_580151, "parent", newJString(parent))
  add(query_580152, "fields", newJString(fields))
  add(query_580152, "access_token", newJString(accessToken))
  add(query_580152, "upload_protocol", newJString(uploadProtocol))
  result = call_580150.call(path_580151, query_580152, nil, nil, body_580153)

var visionProjectsFilesAnnotate* = Call_VisionProjectsFilesAnnotate_580133(
    name: "visionProjectsFilesAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{parent}/files:annotate",
    validator: validate_VisionProjectsFilesAnnotate_580134, base: "/",
    url: url_VisionProjectsFilesAnnotate_580135, schemes: {Scheme.Https})
type
  Call_VisionProjectsFilesAsyncBatchAnnotate_580154 = ref object of OpenApiRestCall_579373
proc url_VisionProjectsFilesAsyncBatchAnnotate_580156(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VisionProjectsFilesAsyncBatchAnnotate_580155(path: JsonNode;
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
  var valid_580157 = path.getOrDefault("parent")
  valid_580157 = validateParameter(valid_580157, JString, required = true,
                                 default = nil)
  if valid_580157 != nil:
    section.add "parent", valid_580157
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
  var valid_580158 = query.getOrDefault("key")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "key", valid_580158
  var valid_580159 = query.getOrDefault("prettyPrint")
  valid_580159 = validateParameter(valid_580159, JBool, required = false,
                                 default = newJBool(true))
  if valid_580159 != nil:
    section.add "prettyPrint", valid_580159
  var valid_580160 = query.getOrDefault("oauth_token")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "oauth_token", valid_580160
  var valid_580161 = query.getOrDefault("$.xgafv")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = newJString("1"))
  if valid_580161 != nil:
    section.add "$.xgafv", valid_580161
  var valid_580162 = query.getOrDefault("alt")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = newJString("json"))
  if valid_580162 != nil:
    section.add "alt", valid_580162
  var valid_580163 = query.getOrDefault("uploadType")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "uploadType", valid_580163
  var valid_580164 = query.getOrDefault("quotaUser")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "quotaUser", valid_580164
  var valid_580165 = query.getOrDefault("callback")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "callback", valid_580165
  var valid_580166 = query.getOrDefault("fields")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "fields", valid_580166
  var valid_580167 = query.getOrDefault("access_token")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "access_token", valid_580167
  var valid_580168 = query.getOrDefault("upload_protocol")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "upload_protocol", valid_580168
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

proc call*(call_580170: Call_VisionProjectsFilesAsyncBatchAnnotate_580154;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Run asynchronous image detection and annotation for a list of generic
  ## files, such as PDF files, which may contain multiple pages and multiple
  ## images per page. Progress and results can be retrieved through the
  ## `google.longrunning.Operations` interface.
  ## `Operation.metadata` contains `OperationMetadata` (metadata).
  ## `Operation.response` contains `AsyncBatchAnnotateFilesResponse` (results).
  ## 
  let valid = call_580170.validator(path, query, header, formData, body)
  let scheme = call_580170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580170.url(scheme.get, call_580170.host, call_580170.base,
                         call_580170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580170, url, valid)

proc call*(call_580171: Call_VisionProjectsFilesAsyncBatchAnnotate_580154;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## visionProjectsFilesAsyncBatchAnnotate
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
  var path_580172 = newJObject()
  var query_580173 = newJObject()
  var body_580174 = newJObject()
  add(query_580173, "key", newJString(key))
  add(query_580173, "prettyPrint", newJBool(prettyPrint))
  add(query_580173, "oauth_token", newJString(oauthToken))
  add(query_580173, "$.xgafv", newJString(Xgafv))
  add(query_580173, "alt", newJString(alt))
  add(query_580173, "uploadType", newJString(uploadType))
  add(query_580173, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580174 = body
  add(query_580173, "callback", newJString(callback))
  add(path_580172, "parent", newJString(parent))
  add(query_580173, "fields", newJString(fields))
  add(query_580173, "access_token", newJString(accessToken))
  add(query_580173, "upload_protocol", newJString(uploadProtocol))
  result = call_580171.call(path_580172, query_580173, nil, nil, body_580174)

var visionProjectsFilesAsyncBatchAnnotate* = Call_VisionProjectsFilesAsyncBatchAnnotate_580154(
    name: "visionProjectsFilesAsyncBatchAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{parent}/files:asyncBatchAnnotate",
    validator: validate_VisionProjectsFilesAsyncBatchAnnotate_580155, base: "/",
    url: url_VisionProjectsFilesAsyncBatchAnnotate_580156, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsImagesAnnotate_580175 = ref object of OpenApiRestCall_579373
proc url_VisionProjectsLocationsImagesAnnotate_580177(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VisionProjectsLocationsImagesAnnotate_580176(path: JsonNode;
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
  var valid_580178 = path.getOrDefault("parent")
  valid_580178 = validateParameter(valid_580178, JString, required = true,
                                 default = nil)
  if valid_580178 != nil:
    section.add "parent", valid_580178
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
  var valid_580179 = query.getOrDefault("key")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "key", valid_580179
  var valid_580180 = query.getOrDefault("prettyPrint")
  valid_580180 = validateParameter(valid_580180, JBool, required = false,
                                 default = newJBool(true))
  if valid_580180 != nil:
    section.add "prettyPrint", valid_580180
  var valid_580181 = query.getOrDefault("oauth_token")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = nil)
  if valid_580181 != nil:
    section.add "oauth_token", valid_580181
  var valid_580182 = query.getOrDefault("$.xgafv")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = newJString("1"))
  if valid_580182 != nil:
    section.add "$.xgafv", valid_580182
  var valid_580183 = query.getOrDefault("alt")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = newJString("json"))
  if valid_580183 != nil:
    section.add "alt", valid_580183
  var valid_580184 = query.getOrDefault("uploadType")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "uploadType", valid_580184
  var valid_580185 = query.getOrDefault("quotaUser")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "quotaUser", valid_580185
  var valid_580186 = query.getOrDefault("callback")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "callback", valid_580186
  var valid_580187 = query.getOrDefault("fields")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "fields", valid_580187
  var valid_580188 = query.getOrDefault("access_token")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "access_token", valid_580188
  var valid_580189 = query.getOrDefault("upload_protocol")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "upload_protocol", valid_580189
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

proc call*(call_580191: Call_VisionProjectsLocationsImagesAnnotate_580175;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Run image detection and annotation for a batch of images.
  ## 
  let valid = call_580191.validator(path, query, header, formData, body)
  let scheme = call_580191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580191.url(scheme.get, call_580191.host, call_580191.base,
                         call_580191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580191, url, valid)

proc call*(call_580192: Call_VisionProjectsLocationsImagesAnnotate_580175;
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
  var path_580193 = newJObject()
  var query_580194 = newJObject()
  var body_580195 = newJObject()
  add(query_580194, "key", newJString(key))
  add(query_580194, "prettyPrint", newJBool(prettyPrint))
  add(query_580194, "oauth_token", newJString(oauthToken))
  add(query_580194, "$.xgafv", newJString(Xgafv))
  add(query_580194, "alt", newJString(alt))
  add(query_580194, "uploadType", newJString(uploadType))
  add(query_580194, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580195 = body
  add(query_580194, "callback", newJString(callback))
  add(path_580193, "parent", newJString(parent))
  add(query_580194, "fields", newJString(fields))
  add(query_580194, "access_token", newJString(accessToken))
  add(query_580194, "upload_protocol", newJString(uploadProtocol))
  result = call_580192.call(path_580193, query_580194, nil, nil, body_580195)

var visionProjectsLocationsImagesAnnotate* = Call_VisionProjectsLocationsImagesAnnotate_580175(
    name: "visionProjectsLocationsImagesAnnotate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{parent}/images:annotate",
    validator: validate_VisionProjectsLocationsImagesAnnotate_580176, base: "/",
    url: url_VisionProjectsLocationsImagesAnnotate_580177, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsImagesAsyncBatchAnnotate_580196 = ref object of OpenApiRestCall_579373
proc url_VisionProjectsLocationsImagesAsyncBatchAnnotate_580198(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VisionProjectsLocationsImagesAsyncBatchAnnotate_580197(
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
  var valid_580199 = path.getOrDefault("parent")
  valid_580199 = validateParameter(valid_580199, JString, required = true,
                                 default = nil)
  if valid_580199 != nil:
    section.add "parent", valid_580199
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
  var valid_580200 = query.getOrDefault("key")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "key", valid_580200
  var valid_580201 = query.getOrDefault("prettyPrint")
  valid_580201 = validateParameter(valid_580201, JBool, required = false,
                                 default = newJBool(true))
  if valid_580201 != nil:
    section.add "prettyPrint", valid_580201
  var valid_580202 = query.getOrDefault("oauth_token")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "oauth_token", valid_580202
  var valid_580203 = query.getOrDefault("$.xgafv")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = newJString("1"))
  if valid_580203 != nil:
    section.add "$.xgafv", valid_580203
  var valid_580204 = query.getOrDefault("alt")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = newJString("json"))
  if valid_580204 != nil:
    section.add "alt", valid_580204
  var valid_580205 = query.getOrDefault("uploadType")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "uploadType", valid_580205
  var valid_580206 = query.getOrDefault("quotaUser")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "quotaUser", valid_580206
  var valid_580207 = query.getOrDefault("callback")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "callback", valid_580207
  var valid_580208 = query.getOrDefault("fields")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "fields", valid_580208
  var valid_580209 = query.getOrDefault("access_token")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "access_token", valid_580209
  var valid_580210 = query.getOrDefault("upload_protocol")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "upload_protocol", valid_580210
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

proc call*(call_580212: Call_VisionProjectsLocationsImagesAsyncBatchAnnotate_580196;
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
  let valid = call_580212.validator(path, query, header, formData, body)
  let scheme = call_580212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580212.url(scheme.get, call_580212.host, call_580212.base,
                         call_580212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580212, url, valid)

proc call*(call_580213: Call_VisionProjectsLocationsImagesAsyncBatchAnnotate_580196;
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
  var path_580214 = newJObject()
  var query_580215 = newJObject()
  var body_580216 = newJObject()
  add(query_580215, "key", newJString(key))
  add(query_580215, "prettyPrint", newJBool(prettyPrint))
  add(query_580215, "oauth_token", newJString(oauthToken))
  add(query_580215, "$.xgafv", newJString(Xgafv))
  add(query_580215, "alt", newJString(alt))
  add(query_580215, "uploadType", newJString(uploadType))
  add(query_580215, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580216 = body
  add(query_580215, "callback", newJString(callback))
  add(path_580214, "parent", newJString(parent))
  add(query_580215, "fields", newJString(fields))
  add(query_580215, "access_token", newJString(accessToken))
  add(query_580215, "upload_protocol", newJString(uploadProtocol))
  result = call_580213.call(path_580214, query_580215, nil, nil, body_580216)

var visionProjectsLocationsImagesAsyncBatchAnnotate* = Call_VisionProjectsLocationsImagesAsyncBatchAnnotate_580196(
    name: "visionProjectsLocationsImagesAsyncBatchAnnotate",
    meth: HttpMethod.HttpPost, host: "vision.googleapis.com",
    route: "/v1/{parent}/images:asyncBatchAnnotate",
    validator: validate_VisionProjectsLocationsImagesAsyncBatchAnnotate_580197,
    base: "/", url: url_VisionProjectsLocationsImagesAsyncBatchAnnotate_580198,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsCreate_580238 = ref object of OpenApiRestCall_579373
proc url_VisionProjectsLocationsProductSetsCreate_580240(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VisionProjectsLocationsProductSetsCreate_580239(path: JsonNode;
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
  var valid_580241 = path.getOrDefault("parent")
  valid_580241 = validateParameter(valid_580241, JString, required = true,
                                 default = nil)
  if valid_580241 != nil:
    section.add "parent", valid_580241
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
  var valid_580242 = query.getOrDefault("key")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "key", valid_580242
  var valid_580243 = query.getOrDefault("prettyPrint")
  valid_580243 = validateParameter(valid_580243, JBool, required = false,
                                 default = newJBool(true))
  if valid_580243 != nil:
    section.add "prettyPrint", valid_580243
  var valid_580244 = query.getOrDefault("oauth_token")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = nil)
  if valid_580244 != nil:
    section.add "oauth_token", valid_580244
  var valid_580245 = query.getOrDefault("$.xgafv")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = newJString("1"))
  if valid_580245 != nil:
    section.add "$.xgafv", valid_580245
  var valid_580246 = query.getOrDefault("alt")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = newJString("json"))
  if valid_580246 != nil:
    section.add "alt", valid_580246
  var valid_580247 = query.getOrDefault("uploadType")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "uploadType", valid_580247
  var valid_580248 = query.getOrDefault("quotaUser")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "quotaUser", valid_580248
  var valid_580249 = query.getOrDefault("productSetId")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "productSetId", valid_580249
  var valid_580250 = query.getOrDefault("callback")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "callback", valid_580250
  var valid_580251 = query.getOrDefault("fields")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "fields", valid_580251
  var valid_580252 = query.getOrDefault("access_token")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "access_token", valid_580252
  var valid_580253 = query.getOrDefault("upload_protocol")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = nil)
  if valid_580253 != nil:
    section.add "upload_protocol", valid_580253
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

proc call*(call_580255: Call_VisionProjectsLocationsProductSetsCreate_580238;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates and returns a new ProductSet resource.
  ## 
  ## Possible errors:
  ## 
  ## * Returns INVALID_ARGUMENT if display_name is missing, or is longer than
  ##   4096 characters.
  ## 
  let valid = call_580255.validator(path, query, header, formData, body)
  let scheme = call_580255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580255.url(scheme.get, call_580255.host, call_580255.base,
                         call_580255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580255, url, valid)

proc call*(call_580256: Call_VisionProjectsLocationsProductSetsCreate_580238;
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
  var path_580257 = newJObject()
  var query_580258 = newJObject()
  var body_580259 = newJObject()
  add(query_580258, "key", newJString(key))
  add(query_580258, "prettyPrint", newJBool(prettyPrint))
  add(query_580258, "oauth_token", newJString(oauthToken))
  add(query_580258, "$.xgafv", newJString(Xgafv))
  add(query_580258, "alt", newJString(alt))
  add(query_580258, "uploadType", newJString(uploadType))
  add(query_580258, "quotaUser", newJString(quotaUser))
  add(query_580258, "productSetId", newJString(productSetId))
  if body != nil:
    body_580259 = body
  add(query_580258, "callback", newJString(callback))
  add(path_580257, "parent", newJString(parent))
  add(query_580258, "fields", newJString(fields))
  add(query_580258, "access_token", newJString(accessToken))
  add(query_580258, "upload_protocol", newJString(uploadProtocol))
  result = call_580256.call(path_580257, query_580258, nil, nil, body_580259)

var visionProjectsLocationsProductSetsCreate* = Call_VisionProjectsLocationsProductSetsCreate_580238(
    name: "visionProjectsLocationsProductSetsCreate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{parent}/productSets",
    validator: validate_VisionProjectsLocationsProductSetsCreate_580239,
    base: "/", url: url_VisionProjectsLocationsProductSetsCreate_580240,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsList_580217 = ref object of OpenApiRestCall_579373
proc url_VisionProjectsLocationsProductSetsList_580219(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VisionProjectsLocationsProductSetsList_580218(path: JsonNode;
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
  var valid_580220 = path.getOrDefault("parent")
  valid_580220 = validateParameter(valid_580220, JString, required = true,
                                 default = nil)
  if valid_580220 != nil:
    section.add "parent", valid_580220
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
  var valid_580221 = query.getOrDefault("key")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "key", valid_580221
  var valid_580222 = query.getOrDefault("prettyPrint")
  valid_580222 = validateParameter(valid_580222, JBool, required = false,
                                 default = newJBool(true))
  if valid_580222 != nil:
    section.add "prettyPrint", valid_580222
  var valid_580223 = query.getOrDefault("oauth_token")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "oauth_token", valid_580223
  var valid_580224 = query.getOrDefault("$.xgafv")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = newJString("1"))
  if valid_580224 != nil:
    section.add "$.xgafv", valid_580224
  var valid_580225 = query.getOrDefault("pageSize")
  valid_580225 = validateParameter(valid_580225, JInt, required = false, default = nil)
  if valid_580225 != nil:
    section.add "pageSize", valid_580225
  var valid_580226 = query.getOrDefault("alt")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = newJString("json"))
  if valid_580226 != nil:
    section.add "alt", valid_580226
  var valid_580227 = query.getOrDefault("uploadType")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "uploadType", valid_580227
  var valid_580228 = query.getOrDefault("quotaUser")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "quotaUser", valid_580228
  var valid_580229 = query.getOrDefault("pageToken")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "pageToken", valid_580229
  var valid_580230 = query.getOrDefault("callback")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "callback", valid_580230
  var valid_580231 = query.getOrDefault("fields")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "fields", valid_580231
  var valid_580232 = query.getOrDefault("access_token")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "access_token", valid_580232
  var valid_580233 = query.getOrDefault("upload_protocol")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "upload_protocol", valid_580233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580234: Call_VisionProjectsLocationsProductSetsList_580217;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists ProductSets in an unspecified order.
  ## 
  ## Possible errors:
  ## 
  ## * Returns INVALID_ARGUMENT if page_size is greater than 100, or less
  ##   than 1.
  ## 
  let valid = call_580234.validator(path, query, header, formData, body)
  let scheme = call_580234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580234.url(scheme.get, call_580234.host, call_580234.base,
                         call_580234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580234, url, valid)

proc call*(call_580235: Call_VisionProjectsLocationsProductSetsList_580217;
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
  var path_580236 = newJObject()
  var query_580237 = newJObject()
  add(query_580237, "key", newJString(key))
  add(query_580237, "prettyPrint", newJBool(prettyPrint))
  add(query_580237, "oauth_token", newJString(oauthToken))
  add(query_580237, "$.xgafv", newJString(Xgafv))
  add(query_580237, "pageSize", newJInt(pageSize))
  add(query_580237, "alt", newJString(alt))
  add(query_580237, "uploadType", newJString(uploadType))
  add(query_580237, "quotaUser", newJString(quotaUser))
  add(query_580237, "pageToken", newJString(pageToken))
  add(query_580237, "callback", newJString(callback))
  add(path_580236, "parent", newJString(parent))
  add(query_580237, "fields", newJString(fields))
  add(query_580237, "access_token", newJString(accessToken))
  add(query_580237, "upload_protocol", newJString(uploadProtocol))
  result = call_580235.call(path_580236, query_580237, nil, nil, nil)

var visionProjectsLocationsProductSetsList* = Call_VisionProjectsLocationsProductSetsList_580217(
    name: "visionProjectsLocationsProductSetsList", meth: HttpMethod.HttpGet,
    host: "vision.googleapis.com", route: "/v1/{parent}/productSets",
    validator: validate_VisionProjectsLocationsProductSetsList_580218, base: "/",
    url: url_VisionProjectsLocationsProductSetsList_580219,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductSetsImport_580260 = ref object of OpenApiRestCall_579373
proc url_VisionProjectsLocationsProductSetsImport_580262(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VisionProjectsLocationsProductSetsImport_580261(path: JsonNode;
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
  var valid_580263 = path.getOrDefault("parent")
  valid_580263 = validateParameter(valid_580263, JString, required = true,
                                 default = nil)
  if valid_580263 != nil:
    section.add "parent", valid_580263
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
  var valid_580264 = query.getOrDefault("key")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = nil)
  if valid_580264 != nil:
    section.add "key", valid_580264
  var valid_580265 = query.getOrDefault("prettyPrint")
  valid_580265 = validateParameter(valid_580265, JBool, required = false,
                                 default = newJBool(true))
  if valid_580265 != nil:
    section.add "prettyPrint", valid_580265
  var valid_580266 = query.getOrDefault("oauth_token")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "oauth_token", valid_580266
  var valid_580267 = query.getOrDefault("$.xgafv")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = newJString("1"))
  if valid_580267 != nil:
    section.add "$.xgafv", valid_580267
  var valid_580268 = query.getOrDefault("alt")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = newJString("json"))
  if valid_580268 != nil:
    section.add "alt", valid_580268
  var valid_580269 = query.getOrDefault("uploadType")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = nil)
  if valid_580269 != nil:
    section.add "uploadType", valid_580269
  var valid_580270 = query.getOrDefault("quotaUser")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "quotaUser", valid_580270
  var valid_580271 = query.getOrDefault("callback")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "callback", valid_580271
  var valid_580272 = query.getOrDefault("fields")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "fields", valid_580272
  var valid_580273 = query.getOrDefault("access_token")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "access_token", valid_580273
  var valid_580274 = query.getOrDefault("upload_protocol")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "upload_protocol", valid_580274
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

proc call*(call_580276: Call_VisionProjectsLocationsProductSetsImport_580260;
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
  let valid = call_580276.validator(path, query, header, formData, body)
  let scheme = call_580276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580276.url(scheme.get, call_580276.host, call_580276.base,
                         call_580276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580276, url, valid)

proc call*(call_580277: Call_VisionProjectsLocationsProductSetsImport_580260;
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
  var path_580278 = newJObject()
  var query_580279 = newJObject()
  var body_580280 = newJObject()
  add(query_580279, "key", newJString(key))
  add(query_580279, "prettyPrint", newJBool(prettyPrint))
  add(query_580279, "oauth_token", newJString(oauthToken))
  add(query_580279, "$.xgafv", newJString(Xgafv))
  add(query_580279, "alt", newJString(alt))
  add(query_580279, "uploadType", newJString(uploadType))
  add(query_580279, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580280 = body
  add(query_580279, "callback", newJString(callback))
  add(path_580278, "parent", newJString(parent))
  add(query_580279, "fields", newJString(fields))
  add(query_580279, "access_token", newJString(accessToken))
  add(query_580279, "upload_protocol", newJString(uploadProtocol))
  result = call_580277.call(path_580278, query_580279, nil, nil, body_580280)

var visionProjectsLocationsProductSetsImport* = Call_VisionProjectsLocationsProductSetsImport_580260(
    name: "visionProjectsLocationsProductSetsImport", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{parent}/productSets:import",
    validator: validate_VisionProjectsLocationsProductSetsImport_580261,
    base: "/", url: url_VisionProjectsLocationsProductSetsImport_580262,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductsCreate_580302 = ref object of OpenApiRestCall_579373
proc url_VisionProjectsLocationsProductsCreate_580304(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VisionProjectsLocationsProductsCreate_580303(path: JsonNode;
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
  var valid_580305 = path.getOrDefault("parent")
  valid_580305 = validateParameter(valid_580305, JString, required = true,
                                 default = nil)
  if valid_580305 != nil:
    section.add "parent", valid_580305
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
  var valid_580306 = query.getOrDefault("key")
  valid_580306 = validateParameter(valid_580306, JString, required = false,
                                 default = nil)
  if valid_580306 != nil:
    section.add "key", valid_580306
  var valid_580307 = query.getOrDefault("prettyPrint")
  valid_580307 = validateParameter(valid_580307, JBool, required = false,
                                 default = newJBool(true))
  if valid_580307 != nil:
    section.add "prettyPrint", valid_580307
  var valid_580308 = query.getOrDefault("oauth_token")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = nil)
  if valid_580308 != nil:
    section.add "oauth_token", valid_580308
  var valid_580309 = query.getOrDefault("$.xgafv")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = newJString("1"))
  if valid_580309 != nil:
    section.add "$.xgafv", valid_580309
  var valid_580310 = query.getOrDefault("alt")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = newJString("json"))
  if valid_580310 != nil:
    section.add "alt", valid_580310
  var valid_580311 = query.getOrDefault("uploadType")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = nil)
  if valid_580311 != nil:
    section.add "uploadType", valid_580311
  var valid_580312 = query.getOrDefault("quotaUser")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = nil)
  if valid_580312 != nil:
    section.add "quotaUser", valid_580312
  var valid_580313 = query.getOrDefault("callback")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = nil)
  if valid_580313 != nil:
    section.add "callback", valid_580313
  var valid_580314 = query.getOrDefault("productId")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = nil)
  if valid_580314 != nil:
    section.add "productId", valid_580314
  var valid_580315 = query.getOrDefault("fields")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "fields", valid_580315
  var valid_580316 = query.getOrDefault("access_token")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "access_token", valid_580316
  var valid_580317 = query.getOrDefault("upload_protocol")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = nil)
  if valid_580317 != nil:
    section.add "upload_protocol", valid_580317
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

proc call*(call_580319: Call_VisionProjectsLocationsProductsCreate_580302;
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
  let valid = call_580319.validator(path, query, header, formData, body)
  let scheme = call_580319.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580319.url(scheme.get, call_580319.host, call_580319.base,
                         call_580319.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580319, url, valid)

proc call*(call_580320: Call_VisionProjectsLocationsProductsCreate_580302;
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
  var path_580321 = newJObject()
  var query_580322 = newJObject()
  var body_580323 = newJObject()
  add(query_580322, "key", newJString(key))
  add(query_580322, "prettyPrint", newJBool(prettyPrint))
  add(query_580322, "oauth_token", newJString(oauthToken))
  add(query_580322, "$.xgafv", newJString(Xgafv))
  add(query_580322, "alt", newJString(alt))
  add(query_580322, "uploadType", newJString(uploadType))
  add(query_580322, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580323 = body
  add(query_580322, "callback", newJString(callback))
  add(path_580321, "parent", newJString(parent))
  add(query_580322, "productId", newJString(productId))
  add(query_580322, "fields", newJString(fields))
  add(query_580322, "access_token", newJString(accessToken))
  add(query_580322, "upload_protocol", newJString(uploadProtocol))
  result = call_580320.call(path_580321, query_580322, nil, nil, body_580323)

var visionProjectsLocationsProductsCreate* = Call_VisionProjectsLocationsProductsCreate_580302(
    name: "visionProjectsLocationsProductsCreate", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{parent}/products",
    validator: validate_VisionProjectsLocationsProductsCreate_580303, base: "/",
    url: url_VisionProjectsLocationsProductsCreate_580304, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductsList_580281 = ref object of OpenApiRestCall_579373
proc url_VisionProjectsLocationsProductsList_580283(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VisionProjectsLocationsProductsList_580282(path: JsonNode;
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
  var valid_580284 = path.getOrDefault("parent")
  valid_580284 = validateParameter(valid_580284, JString, required = true,
                                 default = nil)
  if valid_580284 != nil:
    section.add "parent", valid_580284
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
  var valid_580285 = query.getOrDefault("key")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = nil)
  if valid_580285 != nil:
    section.add "key", valid_580285
  var valid_580286 = query.getOrDefault("prettyPrint")
  valid_580286 = validateParameter(valid_580286, JBool, required = false,
                                 default = newJBool(true))
  if valid_580286 != nil:
    section.add "prettyPrint", valid_580286
  var valid_580287 = query.getOrDefault("oauth_token")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "oauth_token", valid_580287
  var valid_580288 = query.getOrDefault("$.xgafv")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = newJString("1"))
  if valid_580288 != nil:
    section.add "$.xgafv", valid_580288
  var valid_580289 = query.getOrDefault("pageSize")
  valid_580289 = validateParameter(valid_580289, JInt, required = false, default = nil)
  if valid_580289 != nil:
    section.add "pageSize", valid_580289
  var valid_580290 = query.getOrDefault("alt")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = newJString("json"))
  if valid_580290 != nil:
    section.add "alt", valid_580290
  var valid_580291 = query.getOrDefault("uploadType")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "uploadType", valid_580291
  var valid_580292 = query.getOrDefault("quotaUser")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = nil)
  if valid_580292 != nil:
    section.add "quotaUser", valid_580292
  var valid_580293 = query.getOrDefault("pageToken")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "pageToken", valid_580293
  var valid_580294 = query.getOrDefault("callback")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = nil)
  if valid_580294 != nil:
    section.add "callback", valid_580294
  var valid_580295 = query.getOrDefault("fields")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "fields", valid_580295
  var valid_580296 = query.getOrDefault("access_token")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = nil)
  if valid_580296 != nil:
    section.add "access_token", valid_580296
  var valid_580297 = query.getOrDefault("upload_protocol")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = nil)
  if valid_580297 != nil:
    section.add "upload_protocol", valid_580297
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580298: Call_VisionProjectsLocationsProductsList_580281;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists products in an unspecified order.
  ## 
  ## Possible errors:
  ## 
  ## * Returns INVALID_ARGUMENT if page_size is greater than 100 or less than 1.
  ## 
  let valid = call_580298.validator(path, query, header, formData, body)
  let scheme = call_580298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580298.url(scheme.get, call_580298.host, call_580298.base,
                         call_580298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580298, url, valid)

proc call*(call_580299: Call_VisionProjectsLocationsProductsList_580281;
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
  var path_580300 = newJObject()
  var query_580301 = newJObject()
  add(query_580301, "key", newJString(key))
  add(query_580301, "prettyPrint", newJBool(prettyPrint))
  add(query_580301, "oauth_token", newJString(oauthToken))
  add(query_580301, "$.xgafv", newJString(Xgafv))
  add(query_580301, "pageSize", newJInt(pageSize))
  add(query_580301, "alt", newJString(alt))
  add(query_580301, "uploadType", newJString(uploadType))
  add(query_580301, "quotaUser", newJString(quotaUser))
  add(query_580301, "pageToken", newJString(pageToken))
  add(query_580301, "callback", newJString(callback))
  add(path_580300, "parent", newJString(parent))
  add(query_580301, "fields", newJString(fields))
  add(query_580301, "access_token", newJString(accessToken))
  add(query_580301, "upload_protocol", newJString(uploadProtocol))
  result = call_580299.call(path_580300, query_580301, nil, nil, nil)

var visionProjectsLocationsProductsList* = Call_VisionProjectsLocationsProductsList_580281(
    name: "visionProjectsLocationsProductsList", meth: HttpMethod.HttpGet,
    host: "vision.googleapis.com", route: "/v1/{parent}/products",
    validator: validate_VisionProjectsLocationsProductsList_580282, base: "/",
    url: url_VisionProjectsLocationsProductsList_580283, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductsPurge_580324 = ref object of OpenApiRestCall_579373
proc url_VisionProjectsLocationsProductsPurge_580326(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VisionProjectsLocationsProductsPurge_580325(path: JsonNode;
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
  var valid_580327 = path.getOrDefault("parent")
  valid_580327 = validateParameter(valid_580327, JString, required = true,
                                 default = nil)
  if valid_580327 != nil:
    section.add "parent", valid_580327
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
  var valid_580328 = query.getOrDefault("key")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = nil)
  if valid_580328 != nil:
    section.add "key", valid_580328
  var valid_580329 = query.getOrDefault("prettyPrint")
  valid_580329 = validateParameter(valid_580329, JBool, required = false,
                                 default = newJBool(true))
  if valid_580329 != nil:
    section.add "prettyPrint", valid_580329
  var valid_580330 = query.getOrDefault("oauth_token")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = nil)
  if valid_580330 != nil:
    section.add "oauth_token", valid_580330
  var valid_580331 = query.getOrDefault("$.xgafv")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = newJString("1"))
  if valid_580331 != nil:
    section.add "$.xgafv", valid_580331
  var valid_580332 = query.getOrDefault("alt")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = newJString("json"))
  if valid_580332 != nil:
    section.add "alt", valid_580332
  var valid_580333 = query.getOrDefault("uploadType")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = nil)
  if valid_580333 != nil:
    section.add "uploadType", valid_580333
  var valid_580334 = query.getOrDefault("quotaUser")
  valid_580334 = validateParameter(valid_580334, JString, required = false,
                                 default = nil)
  if valid_580334 != nil:
    section.add "quotaUser", valid_580334
  var valid_580335 = query.getOrDefault("callback")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = nil)
  if valid_580335 != nil:
    section.add "callback", valid_580335
  var valid_580336 = query.getOrDefault("fields")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = nil)
  if valid_580336 != nil:
    section.add "fields", valid_580336
  var valid_580337 = query.getOrDefault("access_token")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = nil)
  if valid_580337 != nil:
    section.add "access_token", valid_580337
  var valid_580338 = query.getOrDefault("upload_protocol")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "upload_protocol", valid_580338
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

proc call*(call_580340: Call_VisionProjectsLocationsProductsPurge_580324;
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
  let valid = call_580340.validator(path, query, header, formData, body)
  let scheme = call_580340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580340.url(scheme.get, call_580340.host, call_580340.base,
                         call_580340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580340, url, valid)

proc call*(call_580341: Call_VisionProjectsLocationsProductsPurge_580324;
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
  var path_580342 = newJObject()
  var query_580343 = newJObject()
  var body_580344 = newJObject()
  add(query_580343, "key", newJString(key))
  add(query_580343, "prettyPrint", newJBool(prettyPrint))
  add(query_580343, "oauth_token", newJString(oauthToken))
  add(query_580343, "$.xgafv", newJString(Xgafv))
  add(query_580343, "alt", newJString(alt))
  add(query_580343, "uploadType", newJString(uploadType))
  add(query_580343, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580344 = body
  add(query_580343, "callback", newJString(callback))
  add(path_580342, "parent", newJString(parent))
  add(query_580343, "fields", newJString(fields))
  add(query_580343, "access_token", newJString(accessToken))
  add(query_580343, "upload_protocol", newJString(uploadProtocol))
  result = call_580341.call(path_580342, query_580343, nil, nil, body_580344)

var visionProjectsLocationsProductsPurge* = Call_VisionProjectsLocationsProductsPurge_580324(
    name: "visionProjectsLocationsProductsPurge", meth: HttpMethod.HttpPost,
    host: "vision.googleapis.com", route: "/v1/{parent}/products:purge",
    validator: validate_VisionProjectsLocationsProductsPurge_580325, base: "/",
    url: url_VisionProjectsLocationsProductsPurge_580326, schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductsReferenceImagesCreate_580366 = ref object of OpenApiRestCall_579373
proc url_VisionProjectsLocationsProductsReferenceImagesCreate_580368(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VisionProjectsLocationsProductsReferenceImagesCreate_580367(
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
  var valid_580369 = path.getOrDefault("parent")
  valid_580369 = validateParameter(valid_580369, JString, required = true,
                                 default = nil)
  if valid_580369 != nil:
    section.add "parent", valid_580369
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
  var valid_580370 = query.getOrDefault("key")
  valid_580370 = validateParameter(valid_580370, JString, required = false,
                                 default = nil)
  if valid_580370 != nil:
    section.add "key", valid_580370
  var valid_580371 = query.getOrDefault("prettyPrint")
  valid_580371 = validateParameter(valid_580371, JBool, required = false,
                                 default = newJBool(true))
  if valid_580371 != nil:
    section.add "prettyPrint", valid_580371
  var valid_580372 = query.getOrDefault("oauth_token")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = nil)
  if valid_580372 != nil:
    section.add "oauth_token", valid_580372
  var valid_580373 = query.getOrDefault("$.xgafv")
  valid_580373 = validateParameter(valid_580373, JString, required = false,
                                 default = newJString("1"))
  if valid_580373 != nil:
    section.add "$.xgafv", valid_580373
  var valid_580374 = query.getOrDefault("referenceImageId")
  valid_580374 = validateParameter(valid_580374, JString, required = false,
                                 default = nil)
  if valid_580374 != nil:
    section.add "referenceImageId", valid_580374
  var valid_580375 = query.getOrDefault("alt")
  valid_580375 = validateParameter(valid_580375, JString, required = false,
                                 default = newJString("json"))
  if valid_580375 != nil:
    section.add "alt", valid_580375
  var valid_580376 = query.getOrDefault("uploadType")
  valid_580376 = validateParameter(valid_580376, JString, required = false,
                                 default = nil)
  if valid_580376 != nil:
    section.add "uploadType", valid_580376
  var valid_580377 = query.getOrDefault("quotaUser")
  valid_580377 = validateParameter(valid_580377, JString, required = false,
                                 default = nil)
  if valid_580377 != nil:
    section.add "quotaUser", valid_580377
  var valid_580378 = query.getOrDefault("callback")
  valid_580378 = validateParameter(valid_580378, JString, required = false,
                                 default = nil)
  if valid_580378 != nil:
    section.add "callback", valid_580378
  var valid_580379 = query.getOrDefault("fields")
  valid_580379 = validateParameter(valid_580379, JString, required = false,
                                 default = nil)
  if valid_580379 != nil:
    section.add "fields", valid_580379
  var valid_580380 = query.getOrDefault("access_token")
  valid_580380 = validateParameter(valid_580380, JString, required = false,
                                 default = nil)
  if valid_580380 != nil:
    section.add "access_token", valid_580380
  var valid_580381 = query.getOrDefault("upload_protocol")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = nil)
  if valid_580381 != nil:
    section.add "upload_protocol", valid_580381
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

proc call*(call_580383: Call_VisionProjectsLocationsProductsReferenceImagesCreate_580366;
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
  let valid = call_580383.validator(path, query, header, formData, body)
  let scheme = call_580383.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580383.url(scheme.get, call_580383.host, call_580383.base,
                         call_580383.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580383, url, valid)

proc call*(call_580384: Call_VisionProjectsLocationsProductsReferenceImagesCreate_580366;
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
  var path_580385 = newJObject()
  var query_580386 = newJObject()
  var body_580387 = newJObject()
  add(query_580386, "key", newJString(key))
  add(query_580386, "prettyPrint", newJBool(prettyPrint))
  add(query_580386, "oauth_token", newJString(oauthToken))
  add(query_580386, "$.xgafv", newJString(Xgafv))
  add(query_580386, "referenceImageId", newJString(referenceImageId))
  add(query_580386, "alt", newJString(alt))
  add(query_580386, "uploadType", newJString(uploadType))
  add(query_580386, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580387 = body
  add(query_580386, "callback", newJString(callback))
  add(path_580385, "parent", newJString(parent))
  add(query_580386, "fields", newJString(fields))
  add(query_580386, "access_token", newJString(accessToken))
  add(query_580386, "upload_protocol", newJString(uploadProtocol))
  result = call_580384.call(path_580385, query_580386, nil, nil, body_580387)

var visionProjectsLocationsProductsReferenceImagesCreate* = Call_VisionProjectsLocationsProductsReferenceImagesCreate_580366(
    name: "visionProjectsLocationsProductsReferenceImagesCreate",
    meth: HttpMethod.HttpPost, host: "vision.googleapis.com",
    route: "/v1/{parent}/referenceImages",
    validator: validate_VisionProjectsLocationsProductsReferenceImagesCreate_580367,
    base: "/", url: url_VisionProjectsLocationsProductsReferenceImagesCreate_580368,
    schemes: {Scheme.Https})
type
  Call_VisionProjectsLocationsProductsReferenceImagesList_580345 = ref object of OpenApiRestCall_579373
proc url_VisionProjectsLocationsProductsReferenceImagesList_580347(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_VisionProjectsLocationsProductsReferenceImagesList_580346(
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
  var valid_580348 = path.getOrDefault("parent")
  valid_580348 = validateParameter(valid_580348, JString, required = true,
                                 default = nil)
  if valid_580348 != nil:
    section.add "parent", valid_580348
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
  var valid_580349 = query.getOrDefault("key")
  valid_580349 = validateParameter(valid_580349, JString, required = false,
                                 default = nil)
  if valid_580349 != nil:
    section.add "key", valid_580349
  var valid_580350 = query.getOrDefault("prettyPrint")
  valid_580350 = validateParameter(valid_580350, JBool, required = false,
                                 default = newJBool(true))
  if valid_580350 != nil:
    section.add "prettyPrint", valid_580350
  var valid_580351 = query.getOrDefault("oauth_token")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "oauth_token", valid_580351
  var valid_580352 = query.getOrDefault("$.xgafv")
  valid_580352 = validateParameter(valid_580352, JString, required = false,
                                 default = newJString("1"))
  if valid_580352 != nil:
    section.add "$.xgafv", valid_580352
  var valid_580353 = query.getOrDefault("pageSize")
  valid_580353 = validateParameter(valid_580353, JInt, required = false, default = nil)
  if valid_580353 != nil:
    section.add "pageSize", valid_580353
  var valid_580354 = query.getOrDefault("alt")
  valid_580354 = validateParameter(valid_580354, JString, required = false,
                                 default = newJString("json"))
  if valid_580354 != nil:
    section.add "alt", valid_580354
  var valid_580355 = query.getOrDefault("uploadType")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = nil)
  if valid_580355 != nil:
    section.add "uploadType", valid_580355
  var valid_580356 = query.getOrDefault("quotaUser")
  valid_580356 = validateParameter(valid_580356, JString, required = false,
                                 default = nil)
  if valid_580356 != nil:
    section.add "quotaUser", valid_580356
  var valid_580357 = query.getOrDefault("pageToken")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = nil)
  if valid_580357 != nil:
    section.add "pageToken", valid_580357
  var valid_580358 = query.getOrDefault("callback")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = nil)
  if valid_580358 != nil:
    section.add "callback", valid_580358
  var valid_580359 = query.getOrDefault("fields")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = nil)
  if valid_580359 != nil:
    section.add "fields", valid_580359
  var valid_580360 = query.getOrDefault("access_token")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = nil)
  if valid_580360 != nil:
    section.add "access_token", valid_580360
  var valid_580361 = query.getOrDefault("upload_protocol")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "upload_protocol", valid_580361
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580362: Call_VisionProjectsLocationsProductsReferenceImagesList_580345;
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
  let valid = call_580362.validator(path, query, header, formData, body)
  let scheme = call_580362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580362.url(scheme.get, call_580362.host, call_580362.base,
                         call_580362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580362, url, valid)

proc call*(call_580363: Call_VisionProjectsLocationsProductsReferenceImagesList_580345;
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
  var path_580364 = newJObject()
  var query_580365 = newJObject()
  add(query_580365, "key", newJString(key))
  add(query_580365, "prettyPrint", newJBool(prettyPrint))
  add(query_580365, "oauth_token", newJString(oauthToken))
  add(query_580365, "$.xgafv", newJString(Xgafv))
  add(query_580365, "pageSize", newJInt(pageSize))
  add(query_580365, "alt", newJString(alt))
  add(query_580365, "uploadType", newJString(uploadType))
  add(query_580365, "quotaUser", newJString(quotaUser))
  add(query_580365, "pageToken", newJString(pageToken))
  add(query_580365, "callback", newJString(callback))
  add(path_580364, "parent", newJString(parent))
  add(query_580365, "fields", newJString(fields))
  add(query_580365, "access_token", newJString(accessToken))
  add(query_580365, "upload_protocol", newJString(uploadProtocol))
  result = call_580363.call(path_580364, query_580365, nil, nil, nil)

var visionProjectsLocationsProductsReferenceImagesList* = Call_VisionProjectsLocationsProductsReferenceImagesList_580345(
    name: "visionProjectsLocationsProductsReferenceImagesList",
    meth: HttpMethod.HttpGet, host: "vision.googleapis.com",
    route: "/v1/{parent}/referenceImages",
    validator: validate_VisionProjectsLocationsProductsReferenceImagesList_580346,
    base: "/", url: url_VisionProjectsLocationsProductsReferenceImagesList_580347,
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
