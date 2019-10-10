
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Slides
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Reads and writes Google Slides presentations.
## 
## https://developers.google.com/slides/
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
  gcpServiceName = "slides"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SlidesPresentationsCreate_588719 = ref object of OpenApiRestCall_588450
proc url_SlidesPresentationsCreate_588721(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SlidesPresentationsCreate_588720(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a blank presentation using the title given in the request. If a
  ## `presentationId` is provided, it is used as the ID of the new presentation.
  ## Otherwise, a new ID is generated. Other fields in the request, including
  ## any provided content, are ignored.
  ## Returns the created presentation.
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

proc call*(call_588880: Call_SlidesPresentationsCreate_588719; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a blank presentation using the title given in the request. If a
  ## `presentationId` is provided, it is used as the ID of the new presentation.
  ## Otherwise, a new ID is generated. Other fields in the request, including
  ## any provided content, are ignored.
  ## Returns the created presentation.
  ## 
  let valid = call_588880.validator(path, query, header, formData, body)
  let scheme = call_588880.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588880.url(scheme.get, call_588880.host, call_588880.base,
                         call_588880.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588880, url, valid)

proc call*(call_588951: Call_SlidesPresentationsCreate_588719;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## slidesPresentationsCreate
  ## Creates a blank presentation using the title given in the request. If a
  ## `presentationId` is provided, it is used as the ID of the new presentation.
  ## Otherwise, a new ID is generated. Other fields in the request, including
  ## any provided content, are ignored.
  ## Returns the created presentation.
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

var slidesPresentationsCreate* = Call_SlidesPresentationsCreate_588719(
    name: "slidesPresentationsCreate", meth: HttpMethod.HttpPost,
    host: "slides.googleapis.com", route: "/v1/presentations",
    validator: validate_SlidesPresentationsCreate_588720, base: "/",
    url: url_SlidesPresentationsCreate_588721, schemes: {Scheme.Https})
type
  Call_SlidesPresentationsGet_588993 = ref object of OpenApiRestCall_588450
proc url_SlidesPresentationsGet_588995(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "presentationId" in path, "`presentationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/presentations/"),
               (kind: VariableSegment, value: "presentationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SlidesPresentationsGet_588994(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the latest version of the specified presentation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   presentationId: JString (required)
  ##                 : The ID of the presentation to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `presentationId` field"
  var valid_589010 = path.getOrDefault("presentationId")
  valid_589010 = validateParameter(valid_589010, JString, required = true,
                                 default = nil)
  if valid_589010 != nil:
    section.add "presentationId", valid_589010
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
  var valid_589011 = query.getOrDefault("upload_protocol")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "upload_protocol", valid_589011
  var valid_589012 = query.getOrDefault("fields")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "fields", valid_589012
  var valid_589013 = query.getOrDefault("quotaUser")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "quotaUser", valid_589013
  var valid_589014 = query.getOrDefault("alt")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = newJString("json"))
  if valid_589014 != nil:
    section.add "alt", valid_589014
  var valid_589015 = query.getOrDefault("oauth_token")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "oauth_token", valid_589015
  var valid_589016 = query.getOrDefault("callback")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "callback", valid_589016
  var valid_589017 = query.getOrDefault("access_token")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "access_token", valid_589017
  var valid_589018 = query.getOrDefault("uploadType")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "uploadType", valid_589018
  var valid_589019 = query.getOrDefault("key")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "key", valid_589019
  var valid_589020 = query.getOrDefault("$.xgafv")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = newJString("1"))
  if valid_589020 != nil:
    section.add "$.xgafv", valid_589020
  var valid_589021 = query.getOrDefault("prettyPrint")
  valid_589021 = validateParameter(valid_589021, JBool, required = false,
                                 default = newJBool(true))
  if valid_589021 != nil:
    section.add "prettyPrint", valid_589021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589022: Call_SlidesPresentationsGet_588993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest version of the specified presentation.
  ## 
  let valid = call_589022.validator(path, query, header, formData, body)
  let scheme = call_589022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589022.url(scheme.get, call_589022.host, call_589022.base,
                         call_589022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589022, url, valid)

proc call*(call_589023: Call_SlidesPresentationsGet_588993; presentationId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## slidesPresentationsGet
  ## Gets the latest version of the specified presentation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   presentationId: string (required)
  ##                 : The ID of the presentation to retrieve.
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
  var path_589024 = newJObject()
  var query_589025 = newJObject()
  add(query_589025, "upload_protocol", newJString(uploadProtocol))
  add(query_589025, "fields", newJString(fields))
  add(query_589025, "quotaUser", newJString(quotaUser))
  add(query_589025, "alt", newJString(alt))
  add(path_589024, "presentationId", newJString(presentationId))
  add(query_589025, "oauth_token", newJString(oauthToken))
  add(query_589025, "callback", newJString(callback))
  add(query_589025, "access_token", newJString(accessToken))
  add(query_589025, "uploadType", newJString(uploadType))
  add(query_589025, "key", newJString(key))
  add(query_589025, "$.xgafv", newJString(Xgafv))
  add(query_589025, "prettyPrint", newJBool(prettyPrint))
  result = call_589023.call(path_589024, query_589025, nil, nil, nil)

var slidesPresentationsGet* = Call_SlidesPresentationsGet_588993(
    name: "slidesPresentationsGet", meth: HttpMethod.HttpGet,
    host: "slides.googleapis.com", route: "/v1/presentations/{presentationId}",
    validator: validate_SlidesPresentationsGet_588994, base: "/",
    url: url_SlidesPresentationsGet_588995, schemes: {Scheme.Https})
type
  Call_SlidesPresentationsPagesGet_589026 = ref object of OpenApiRestCall_588450
proc url_SlidesPresentationsPagesGet_589028(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "presentationId" in path, "`presentationId` is a required path parameter"
  assert "pageObjectId" in path, "`pageObjectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/presentations/"),
               (kind: VariableSegment, value: "presentationId"),
               (kind: ConstantSegment, value: "/pages/"),
               (kind: VariableSegment, value: "pageObjectId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SlidesPresentationsPagesGet_589027(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the latest version of the specified page in the presentation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   pageObjectId: JString (required)
  ##               : The object ID of the page to retrieve.
  ##   presentationId: JString (required)
  ##                 : The ID of the presentation to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `pageObjectId` field"
  var valid_589029 = path.getOrDefault("pageObjectId")
  valid_589029 = validateParameter(valid_589029, JString, required = true,
                                 default = nil)
  if valid_589029 != nil:
    section.add "pageObjectId", valid_589029
  var valid_589030 = path.getOrDefault("presentationId")
  valid_589030 = validateParameter(valid_589030, JString, required = true,
                                 default = nil)
  if valid_589030 != nil:
    section.add "presentationId", valid_589030
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
  var valid_589031 = query.getOrDefault("upload_protocol")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "upload_protocol", valid_589031
  var valid_589032 = query.getOrDefault("fields")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "fields", valid_589032
  var valid_589033 = query.getOrDefault("quotaUser")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "quotaUser", valid_589033
  var valid_589034 = query.getOrDefault("alt")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = newJString("json"))
  if valid_589034 != nil:
    section.add "alt", valid_589034
  var valid_589035 = query.getOrDefault("oauth_token")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "oauth_token", valid_589035
  var valid_589036 = query.getOrDefault("callback")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "callback", valid_589036
  var valid_589037 = query.getOrDefault("access_token")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "access_token", valid_589037
  var valid_589038 = query.getOrDefault("uploadType")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "uploadType", valid_589038
  var valid_589039 = query.getOrDefault("key")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "key", valid_589039
  var valid_589040 = query.getOrDefault("$.xgafv")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = newJString("1"))
  if valid_589040 != nil:
    section.add "$.xgafv", valid_589040
  var valid_589041 = query.getOrDefault("prettyPrint")
  valid_589041 = validateParameter(valid_589041, JBool, required = false,
                                 default = newJBool(true))
  if valid_589041 != nil:
    section.add "prettyPrint", valid_589041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589042: Call_SlidesPresentationsPagesGet_589026; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest version of the specified page in the presentation.
  ## 
  let valid = call_589042.validator(path, query, header, formData, body)
  let scheme = call_589042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589042.url(scheme.get, call_589042.host, call_589042.base,
                         call_589042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589042, url, valid)

proc call*(call_589043: Call_SlidesPresentationsPagesGet_589026;
          pageObjectId: string; presentationId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## slidesPresentationsPagesGet
  ## Gets the latest version of the specified page in the presentation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageObjectId: string (required)
  ##               : The object ID of the page to retrieve.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   presentationId: string (required)
  ##                 : The ID of the presentation to retrieve.
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
  var path_589044 = newJObject()
  var query_589045 = newJObject()
  add(query_589045, "upload_protocol", newJString(uploadProtocol))
  add(query_589045, "fields", newJString(fields))
  add(path_589044, "pageObjectId", newJString(pageObjectId))
  add(query_589045, "quotaUser", newJString(quotaUser))
  add(query_589045, "alt", newJString(alt))
  add(path_589044, "presentationId", newJString(presentationId))
  add(query_589045, "oauth_token", newJString(oauthToken))
  add(query_589045, "callback", newJString(callback))
  add(query_589045, "access_token", newJString(accessToken))
  add(query_589045, "uploadType", newJString(uploadType))
  add(query_589045, "key", newJString(key))
  add(query_589045, "$.xgafv", newJString(Xgafv))
  add(query_589045, "prettyPrint", newJBool(prettyPrint))
  result = call_589043.call(path_589044, query_589045, nil, nil, nil)

var slidesPresentationsPagesGet* = Call_SlidesPresentationsPagesGet_589026(
    name: "slidesPresentationsPagesGet", meth: HttpMethod.HttpGet,
    host: "slides.googleapis.com",
    route: "/v1/presentations/{presentationId}/pages/{pageObjectId}",
    validator: validate_SlidesPresentationsPagesGet_589027, base: "/",
    url: url_SlidesPresentationsPagesGet_589028, schemes: {Scheme.Https})
type
  Call_SlidesPresentationsPagesGetThumbnail_589046 = ref object of OpenApiRestCall_588450
proc url_SlidesPresentationsPagesGetThumbnail_589048(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "presentationId" in path, "`presentationId` is a required path parameter"
  assert "pageObjectId" in path, "`pageObjectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/presentations/"),
               (kind: VariableSegment, value: "presentationId"),
               (kind: ConstantSegment, value: "/pages/"),
               (kind: VariableSegment, value: "pageObjectId"),
               (kind: ConstantSegment, value: "/thumbnail")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SlidesPresentationsPagesGetThumbnail_589047(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generates a thumbnail of the latest version of the specified page in the
  ## presentation and returns a URL to the thumbnail image.
  ## 
  ## This request counts as an [expensive read request](/slides/limits) for
  ## quota purposes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   pageObjectId: JString (required)
  ##               : The object ID of the page whose thumbnail to retrieve.
  ##   presentationId: JString (required)
  ##                 : The ID of the presentation to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `pageObjectId` field"
  var valid_589049 = path.getOrDefault("pageObjectId")
  valid_589049 = validateParameter(valid_589049, JString, required = true,
                                 default = nil)
  if valid_589049 != nil:
    section.add "pageObjectId", valid_589049
  var valid_589050 = path.getOrDefault("presentationId")
  valid_589050 = validateParameter(valid_589050, JString, required = true,
                                 default = nil)
  if valid_589050 != nil:
    section.add "presentationId", valid_589050
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
  ##   thumbnailProperties.mimeType: JString
  ##                               : The optional mime type of the thumbnail image.
  ## 
  ## If you don't specify the mime type, the default mime type will be PNG.
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
  ##   thumbnailProperties.thumbnailSize: JString
  ##                                    : The optional thumbnail image size.
  ## 
  ## If you don't specify the size, the server chooses a default size of the
  ## image.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589051 = query.getOrDefault("upload_protocol")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "upload_protocol", valid_589051
  var valid_589052 = query.getOrDefault("fields")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "fields", valid_589052
  var valid_589053 = query.getOrDefault("quotaUser")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "quotaUser", valid_589053
  var valid_589054 = query.getOrDefault("alt")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = newJString("json"))
  if valid_589054 != nil:
    section.add "alt", valid_589054
  var valid_589055 = query.getOrDefault("thumbnailProperties.mimeType")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = newJString("PNG"))
  if valid_589055 != nil:
    section.add "thumbnailProperties.mimeType", valid_589055
  var valid_589056 = query.getOrDefault("oauth_token")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "oauth_token", valid_589056
  var valid_589057 = query.getOrDefault("callback")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "callback", valid_589057
  var valid_589058 = query.getOrDefault("access_token")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "access_token", valid_589058
  var valid_589059 = query.getOrDefault("uploadType")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "uploadType", valid_589059
  var valid_589060 = query.getOrDefault("key")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "key", valid_589060
  var valid_589061 = query.getOrDefault("thumbnailProperties.thumbnailSize")
  valid_589061 = validateParameter(valid_589061, JString, required = false, default = newJString(
      "THUMBNAIL_SIZE_UNSPECIFIED"))
  if valid_589061 != nil:
    section.add "thumbnailProperties.thumbnailSize", valid_589061
  var valid_589062 = query.getOrDefault("$.xgafv")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = newJString("1"))
  if valid_589062 != nil:
    section.add "$.xgafv", valid_589062
  var valid_589063 = query.getOrDefault("prettyPrint")
  valid_589063 = validateParameter(valid_589063, JBool, required = false,
                                 default = newJBool(true))
  if valid_589063 != nil:
    section.add "prettyPrint", valid_589063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589064: Call_SlidesPresentationsPagesGetThumbnail_589046;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates a thumbnail of the latest version of the specified page in the
  ## presentation and returns a URL to the thumbnail image.
  ## 
  ## This request counts as an [expensive read request](/slides/limits) for
  ## quota purposes.
  ## 
  let valid = call_589064.validator(path, query, header, formData, body)
  let scheme = call_589064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589064.url(scheme.get, call_589064.host, call_589064.base,
                         call_589064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589064, url, valid)

proc call*(call_589065: Call_SlidesPresentationsPagesGetThumbnail_589046;
          pageObjectId: string; presentationId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          thumbnailPropertiesMimeType: string = "PNG"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; thumbnailPropertiesThumbnailSize: string = "THUMBNAIL_SIZE_UNSPECIFIED";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## slidesPresentationsPagesGetThumbnail
  ## Generates a thumbnail of the latest version of the specified page in the
  ## presentation and returns a URL to the thumbnail image.
  ## 
  ## This request counts as an [expensive read request](/slides/limits) for
  ## quota purposes.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageObjectId: string (required)
  ##               : The object ID of the page whose thumbnail to retrieve.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   presentationId: string (required)
  ##                 : The ID of the presentation to retrieve.
  ##   thumbnailPropertiesMimeType: string
  ##                              : The optional mime type of the thumbnail image.
  ## 
  ## If you don't specify the mime type, the default mime type will be PNG.
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
  ##   thumbnailPropertiesThumbnailSize: string
  ##                                   : The optional thumbnail image size.
  ## 
  ## If you don't specify the size, the server chooses a default size of the
  ## image.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589066 = newJObject()
  var query_589067 = newJObject()
  add(query_589067, "upload_protocol", newJString(uploadProtocol))
  add(query_589067, "fields", newJString(fields))
  add(path_589066, "pageObjectId", newJString(pageObjectId))
  add(query_589067, "quotaUser", newJString(quotaUser))
  add(query_589067, "alt", newJString(alt))
  add(path_589066, "presentationId", newJString(presentationId))
  add(query_589067, "thumbnailProperties.mimeType",
      newJString(thumbnailPropertiesMimeType))
  add(query_589067, "oauth_token", newJString(oauthToken))
  add(query_589067, "callback", newJString(callback))
  add(query_589067, "access_token", newJString(accessToken))
  add(query_589067, "uploadType", newJString(uploadType))
  add(query_589067, "key", newJString(key))
  add(query_589067, "thumbnailProperties.thumbnailSize",
      newJString(thumbnailPropertiesThumbnailSize))
  add(query_589067, "$.xgafv", newJString(Xgafv))
  add(query_589067, "prettyPrint", newJBool(prettyPrint))
  result = call_589065.call(path_589066, query_589067, nil, nil, nil)

var slidesPresentationsPagesGetThumbnail* = Call_SlidesPresentationsPagesGetThumbnail_589046(
    name: "slidesPresentationsPagesGetThumbnail", meth: HttpMethod.HttpGet,
    host: "slides.googleapis.com",
    route: "/v1/presentations/{presentationId}/pages/{pageObjectId}/thumbnail",
    validator: validate_SlidesPresentationsPagesGetThumbnail_589047, base: "/",
    url: url_SlidesPresentationsPagesGetThumbnail_589048, schemes: {Scheme.Https})
type
  Call_SlidesPresentationsBatchUpdate_589068 = ref object of OpenApiRestCall_588450
proc url_SlidesPresentationsBatchUpdate_589070(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "presentationId" in path, "`presentationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/presentations/"),
               (kind: VariableSegment, value: "presentationId"),
               (kind: ConstantSegment, value: ":batchUpdate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SlidesPresentationsBatchUpdate_589069(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Applies one or more updates to the presentation.
  ## 
  ## Each request is validated before
  ## being applied. If any request is not valid, then the entire request will
  ## fail and nothing will be applied.
  ## 
  ## Some requests have replies to
  ## give you some information about how they are applied. Other requests do
  ## not need to return information; these each return an empty reply.
  ## The order of replies matches that of the requests.
  ## 
  ## For example, suppose you call batchUpdate with four updates, and only the
  ## third one returns information. The response would have two empty replies:
  ## the reply to the third request, and another empty reply, in that order.
  ## 
  ## Because other users may be editing the presentation, the presentation
  ## might not exactly reflect your changes: your changes may
  ## be altered with respect to collaborator changes. If there are no
  ## collaborators, the presentation should reflect your changes. In any case,
  ## the updates in your request are guaranteed to be applied together
  ## atomically.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   presentationId: JString (required)
  ##                 : The presentation to apply the updates to.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `presentationId` field"
  var valid_589071 = path.getOrDefault("presentationId")
  valid_589071 = validateParameter(valid_589071, JString, required = true,
                                 default = nil)
  if valid_589071 != nil:
    section.add "presentationId", valid_589071
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
  var valid_589072 = query.getOrDefault("upload_protocol")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "upload_protocol", valid_589072
  var valid_589073 = query.getOrDefault("fields")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "fields", valid_589073
  var valid_589074 = query.getOrDefault("quotaUser")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "quotaUser", valid_589074
  var valid_589075 = query.getOrDefault("alt")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = newJString("json"))
  if valid_589075 != nil:
    section.add "alt", valid_589075
  var valid_589076 = query.getOrDefault("oauth_token")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "oauth_token", valid_589076
  var valid_589077 = query.getOrDefault("callback")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "callback", valid_589077
  var valid_589078 = query.getOrDefault("access_token")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "access_token", valid_589078
  var valid_589079 = query.getOrDefault("uploadType")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "uploadType", valid_589079
  var valid_589080 = query.getOrDefault("key")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "key", valid_589080
  var valid_589081 = query.getOrDefault("$.xgafv")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = newJString("1"))
  if valid_589081 != nil:
    section.add "$.xgafv", valid_589081
  var valid_589082 = query.getOrDefault("prettyPrint")
  valid_589082 = validateParameter(valid_589082, JBool, required = false,
                                 default = newJBool(true))
  if valid_589082 != nil:
    section.add "prettyPrint", valid_589082
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

proc call*(call_589084: Call_SlidesPresentationsBatchUpdate_589068; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Applies one or more updates to the presentation.
  ## 
  ## Each request is validated before
  ## being applied. If any request is not valid, then the entire request will
  ## fail and nothing will be applied.
  ## 
  ## Some requests have replies to
  ## give you some information about how they are applied. Other requests do
  ## not need to return information; these each return an empty reply.
  ## The order of replies matches that of the requests.
  ## 
  ## For example, suppose you call batchUpdate with four updates, and only the
  ## third one returns information. The response would have two empty replies:
  ## the reply to the third request, and another empty reply, in that order.
  ## 
  ## Because other users may be editing the presentation, the presentation
  ## might not exactly reflect your changes: your changes may
  ## be altered with respect to collaborator changes. If there are no
  ## collaborators, the presentation should reflect your changes. In any case,
  ## the updates in your request are guaranteed to be applied together
  ## atomically.
  ## 
  let valid = call_589084.validator(path, query, header, formData, body)
  let scheme = call_589084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589084.url(scheme.get, call_589084.host, call_589084.base,
                         call_589084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589084, url, valid)

proc call*(call_589085: Call_SlidesPresentationsBatchUpdate_589068;
          presentationId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## slidesPresentationsBatchUpdate
  ## Applies one or more updates to the presentation.
  ## 
  ## Each request is validated before
  ## being applied. If any request is not valid, then the entire request will
  ## fail and nothing will be applied.
  ## 
  ## Some requests have replies to
  ## give you some information about how they are applied. Other requests do
  ## not need to return information; these each return an empty reply.
  ## The order of replies matches that of the requests.
  ## 
  ## For example, suppose you call batchUpdate with four updates, and only the
  ## third one returns information. The response would have two empty replies:
  ## the reply to the third request, and another empty reply, in that order.
  ## 
  ## Because other users may be editing the presentation, the presentation
  ## might not exactly reflect your changes: your changes may
  ## be altered with respect to collaborator changes. If there are no
  ## collaborators, the presentation should reflect your changes. In any case,
  ## the updates in your request are guaranteed to be applied together
  ## atomically.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   presentationId: string (required)
  ##                 : The presentation to apply the updates to.
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
  var path_589086 = newJObject()
  var query_589087 = newJObject()
  var body_589088 = newJObject()
  add(query_589087, "upload_protocol", newJString(uploadProtocol))
  add(query_589087, "fields", newJString(fields))
  add(query_589087, "quotaUser", newJString(quotaUser))
  add(query_589087, "alt", newJString(alt))
  add(path_589086, "presentationId", newJString(presentationId))
  add(query_589087, "oauth_token", newJString(oauthToken))
  add(query_589087, "callback", newJString(callback))
  add(query_589087, "access_token", newJString(accessToken))
  add(query_589087, "uploadType", newJString(uploadType))
  add(query_589087, "key", newJString(key))
  add(query_589087, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589088 = body
  add(query_589087, "prettyPrint", newJBool(prettyPrint))
  result = call_589085.call(path_589086, query_589087, nil, nil, body_589088)

var slidesPresentationsBatchUpdate* = Call_SlidesPresentationsBatchUpdate_589068(
    name: "slidesPresentationsBatchUpdate", meth: HttpMethod.HttpPost,
    host: "slides.googleapis.com",
    route: "/v1/presentations/{presentationId}:batchUpdate",
    validator: validate_SlidesPresentationsBatchUpdate_589069, base: "/",
    url: url_SlidesPresentationsBatchUpdate_589070, schemes: {Scheme.Https})
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
