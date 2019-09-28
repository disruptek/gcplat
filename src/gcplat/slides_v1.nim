
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
  gcpServiceName = "slides"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SlidesPresentationsCreate_579690 = ref object of OpenApiRestCall_579421
proc url_SlidesPresentationsCreate_579692(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SlidesPresentationsCreate_579691(path: JsonNode; query: JsonNode;
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

proc call*(call_579851: Call_SlidesPresentationsCreate_579690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a blank presentation using the title given in the request. If a
  ## `presentationId` is provided, it is used as the ID of the new presentation.
  ## Otherwise, a new ID is generated. Other fields in the request, including
  ## any provided content, are ignored.
  ## Returns the created presentation.
  ## 
  let valid = call_579851.validator(path, query, header, formData, body)
  let scheme = call_579851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579851.url(scheme.get, call_579851.host, call_579851.base,
                         call_579851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579851, url, valid)

proc call*(call_579922: Call_SlidesPresentationsCreate_579690;
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

var slidesPresentationsCreate* = Call_SlidesPresentationsCreate_579690(
    name: "slidesPresentationsCreate", meth: HttpMethod.HttpPost,
    host: "slides.googleapis.com", route: "/v1/presentations",
    validator: validate_SlidesPresentationsCreate_579691, base: "/",
    url: url_SlidesPresentationsCreate_579692, schemes: {Scheme.Https})
type
  Call_SlidesPresentationsGet_579964 = ref object of OpenApiRestCall_579421
proc url_SlidesPresentationsGet_579966(protocol: Scheme; host: string; base: string;
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

proc validate_SlidesPresentationsGet_579965(path: JsonNode; query: JsonNode;
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
  var valid_579981 = path.getOrDefault("presentationId")
  valid_579981 = validateParameter(valid_579981, JString, required = true,
                                 default = nil)
  if valid_579981 != nil:
    section.add "presentationId", valid_579981
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
  var valid_579982 = query.getOrDefault("upload_protocol")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "upload_protocol", valid_579982
  var valid_579983 = query.getOrDefault("fields")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "fields", valid_579983
  var valid_579984 = query.getOrDefault("quotaUser")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "quotaUser", valid_579984
  var valid_579985 = query.getOrDefault("alt")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = newJString("json"))
  if valid_579985 != nil:
    section.add "alt", valid_579985
  var valid_579986 = query.getOrDefault("oauth_token")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "oauth_token", valid_579986
  var valid_579987 = query.getOrDefault("callback")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "callback", valid_579987
  var valid_579988 = query.getOrDefault("access_token")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "access_token", valid_579988
  var valid_579989 = query.getOrDefault("uploadType")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "uploadType", valid_579989
  var valid_579990 = query.getOrDefault("key")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "key", valid_579990
  var valid_579991 = query.getOrDefault("$.xgafv")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = newJString("1"))
  if valid_579991 != nil:
    section.add "$.xgafv", valid_579991
  var valid_579992 = query.getOrDefault("prettyPrint")
  valid_579992 = validateParameter(valid_579992, JBool, required = false,
                                 default = newJBool(true))
  if valid_579992 != nil:
    section.add "prettyPrint", valid_579992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579993: Call_SlidesPresentationsGet_579964; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest version of the specified presentation.
  ## 
  let valid = call_579993.validator(path, query, header, formData, body)
  let scheme = call_579993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579993.url(scheme.get, call_579993.host, call_579993.base,
                         call_579993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579993, url, valid)

proc call*(call_579994: Call_SlidesPresentationsGet_579964; presentationId: string;
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
  var path_579995 = newJObject()
  var query_579996 = newJObject()
  add(query_579996, "upload_protocol", newJString(uploadProtocol))
  add(query_579996, "fields", newJString(fields))
  add(query_579996, "quotaUser", newJString(quotaUser))
  add(query_579996, "alt", newJString(alt))
  add(path_579995, "presentationId", newJString(presentationId))
  add(query_579996, "oauth_token", newJString(oauthToken))
  add(query_579996, "callback", newJString(callback))
  add(query_579996, "access_token", newJString(accessToken))
  add(query_579996, "uploadType", newJString(uploadType))
  add(query_579996, "key", newJString(key))
  add(query_579996, "$.xgafv", newJString(Xgafv))
  add(query_579996, "prettyPrint", newJBool(prettyPrint))
  result = call_579994.call(path_579995, query_579996, nil, nil, nil)

var slidesPresentationsGet* = Call_SlidesPresentationsGet_579964(
    name: "slidesPresentationsGet", meth: HttpMethod.HttpGet,
    host: "slides.googleapis.com", route: "/v1/presentations/{presentationId}",
    validator: validate_SlidesPresentationsGet_579965, base: "/",
    url: url_SlidesPresentationsGet_579966, schemes: {Scheme.Https})
type
  Call_SlidesPresentationsPagesGet_579997 = ref object of OpenApiRestCall_579421
proc url_SlidesPresentationsPagesGet_579999(protocol: Scheme; host: string;
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

proc validate_SlidesPresentationsPagesGet_579998(path: JsonNode; query: JsonNode;
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
  var valid_580000 = path.getOrDefault("pageObjectId")
  valid_580000 = validateParameter(valid_580000, JString, required = true,
                                 default = nil)
  if valid_580000 != nil:
    section.add "pageObjectId", valid_580000
  var valid_580001 = path.getOrDefault("presentationId")
  valid_580001 = validateParameter(valid_580001, JString, required = true,
                                 default = nil)
  if valid_580001 != nil:
    section.add "presentationId", valid_580001
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
  var valid_580002 = query.getOrDefault("upload_protocol")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "upload_protocol", valid_580002
  var valid_580003 = query.getOrDefault("fields")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "fields", valid_580003
  var valid_580004 = query.getOrDefault("quotaUser")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "quotaUser", valid_580004
  var valid_580005 = query.getOrDefault("alt")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = newJString("json"))
  if valid_580005 != nil:
    section.add "alt", valid_580005
  var valid_580006 = query.getOrDefault("oauth_token")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "oauth_token", valid_580006
  var valid_580007 = query.getOrDefault("callback")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "callback", valid_580007
  var valid_580008 = query.getOrDefault("access_token")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "access_token", valid_580008
  var valid_580009 = query.getOrDefault("uploadType")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "uploadType", valid_580009
  var valid_580010 = query.getOrDefault("key")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "key", valid_580010
  var valid_580011 = query.getOrDefault("$.xgafv")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = newJString("1"))
  if valid_580011 != nil:
    section.add "$.xgafv", valid_580011
  var valid_580012 = query.getOrDefault("prettyPrint")
  valid_580012 = validateParameter(valid_580012, JBool, required = false,
                                 default = newJBool(true))
  if valid_580012 != nil:
    section.add "prettyPrint", valid_580012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580013: Call_SlidesPresentationsPagesGet_579997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest version of the specified page in the presentation.
  ## 
  let valid = call_580013.validator(path, query, header, formData, body)
  let scheme = call_580013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580013.url(scheme.get, call_580013.host, call_580013.base,
                         call_580013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580013, url, valid)

proc call*(call_580014: Call_SlidesPresentationsPagesGet_579997;
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
  var path_580015 = newJObject()
  var query_580016 = newJObject()
  add(query_580016, "upload_protocol", newJString(uploadProtocol))
  add(query_580016, "fields", newJString(fields))
  add(path_580015, "pageObjectId", newJString(pageObjectId))
  add(query_580016, "quotaUser", newJString(quotaUser))
  add(query_580016, "alt", newJString(alt))
  add(path_580015, "presentationId", newJString(presentationId))
  add(query_580016, "oauth_token", newJString(oauthToken))
  add(query_580016, "callback", newJString(callback))
  add(query_580016, "access_token", newJString(accessToken))
  add(query_580016, "uploadType", newJString(uploadType))
  add(query_580016, "key", newJString(key))
  add(query_580016, "$.xgafv", newJString(Xgafv))
  add(query_580016, "prettyPrint", newJBool(prettyPrint))
  result = call_580014.call(path_580015, query_580016, nil, nil, nil)

var slidesPresentationsPagesGet* = Call_SlidesPresentationsPagesGet_579997(
    name: "slidesPresentationsPagesGet", meth: HttpMethod.HttpGet,
    host: "slides.googleapis.com",
    route: "/v1/presentations/{presentationId}/pages/{pageObjectId}",
    validator: validate_SlidesPresentationsPagesGet_579998, base: "/",
    url: url_SlidesPresentationsPagesGet_579999, schemes: {Scheme.Https})
type
  Call_SlidesPresentationsPagesGetThumbnail_580017 = ref object of OpenApiRestCall_579421
proc url_SlidesPresentationsPagesGetThumbnail_580019(protocol: Scheme;
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

proc validate_SlidesPresentationsPagesGetThumbnail_580018(path: JsonNode;
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
  var valid_580020 = path.getOrDefault("pageObjectId")
  valid_580020 = validateParameter(valid_580020, JString, required = true,
                                 default = nil)
  if valid_580020 != nil:
    section.add "pageObjectId", valid_580020
  var valid_580021 = path.getOrDefault("presentationId")
  valid_580021 = validateParameter(valid_580021, JString, required = true,
                                 default = nil)
  if valid_580021 != nil:
    section.add "presentationId", valid_580021
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
  var valid_580022 = query.getOrDefault("upload_protocol")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "upload_protocol", valid_580022
  var valid_580023 = query.getOrDefault("fields")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "fields", valid_580023
  var valid_580024 = query.getOrDefault("quotaUser")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "quotaUser", valid_580024
  var valid_580025 = query.getOrDefault("alt")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = newJString("json"))
  if valid_580025 != nil:
    section.add "alt", valid_580025
  var valid_580026 = query.getOrDefault("thumbnailProperties.mimeType")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = newJString("PNG"))
  if valid_580026 != nil:
    section.add "thumbnailProperties.mimeType", valid_580026
  var valid_580027 = query.getOrDefault("oauth_token")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "oauth_token", valid_580027
  var valid_580028 = query.getOrDefault("callback")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "callback", valid_580028
  var valid_580029 = query.getOrDefault("access_token")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "access_token", valid_580029
  var valid_580030 = query.getOrDefault("uploadType")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "uploadType", valid_580030
  var valid_580031 = query.getOrDefault("key")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "key", valid_580031
  var valid_580032 = query.getOrDefault("thumbnailProperties.thumbnailSize")
  valid_580032 = validateParameter(valid_580032, JString, required = false, default = newJString(
      "THUMBNAIL_SIZE_UNSPECIFIED"))
  if valid_580032 != nil:
    section.add "thumbnailProperties.thumbnailSize", valid_580032
  var valid_580033 = query.getOrDefault("$.xgafv")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = newJString("1"))
  if valid_580033 != nil:
    section.add "$.xgafv", valid_580033
  var valid_580034 = query.getOrDefault("prettyPrint")
  valid_580034 = validateParameter(valid_580034, JBool, required = false,
                                 default = newJBool(true))
  if valid_580034 != nil:
    section.add "prettyPrint", valid_580034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580035: Call_SlidesPresentationsPagesGetThumbnail_580017;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates a thumbnail of the latest version of the specified page in the
  ## presentation and returns a URL to the thumbnail image.
  ## 
  ## This request counts as an [expensive read request](/slides/limits) for
  ## quota purposes.
  ## 
  let valid = call_580035.validator(path, query, header, formData, body)
  let scheme = call_580035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580035.url(scheme.get, call_580035.host, call_580035.base,
                         call_580035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580035, url, valid)

proc call*(call_580036: Call_SlidesPresentationsPagesGetThumbnail_580017;
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
  var path_580037 = newJObject()
  var query_580038 = newJObject()
  add(query_580038, "upload_protocol", newJString(uploadProtocol))
  add(query_580038, "fields", newJString(fields))
  add(path_580037, "pageObjectId", newJString(pageObjectId))
  add(query_580038, "quotaUser", newJString(quotaUser))
  add(query_580038, "alt", newJString(alt))
  add(path_580037, "presentationId", newJString(presentationId))
  add(query_580038, "thumbnailProperties.mimeType",
      newJString(thumbnailPropertiesMimeType))
  add(query_580038, "oauth_token", newJString(oauthToken))
  add(query_580038, "callback", newJString(callback))
  add(query_580038, "access_token", newJString(accessToken))
  add(query_580038, "uploadType", newJString(uploadType))
  add(query_580038, "key", newJString(key))
  add(query_580038, "thumbnailProperties.thumbnailSize",
      newJString(thumbnailPropertiesThumbnailSize))
  add(query_580038, "$.xgafv", newJString(Xgafv))
  add(query_580038, "prettyPrint", newJBool(prettyPrint))
  result = call_580036.call(path_580037, query_580038, nil, nil, nil)

var slidesPresentationsPagesGetThumbnail* = Call_SlidesPresentationsPagesGetThumbnail_580017(
    name: "slidesPresentationsPagesGetThumbnail", meth: HttpMethod.HttpGet,
    host: "slides.googleapis.com",
    route: "/v1/presentations/{presentationId}/pages/{pageObjectId}/thumbnail",
    validator: validate_SlidesPresentationsPagesGetThumbnail_580018, base: "/",
    url: url_SlidesPresentationsPagesGetThumbnail_580019, schemes: {Scheme.Https})
type
  Call_SlidesPresentationsBatchUpdate_580039 = ref object of OpenApiRestCall_579421
proc url_SlidesPresentationsBatchUpdate_580041(protocol: Scheme; host: string;
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

proc validate_SlidesPresentationsBatchUpdate_580040(path: JsonNode;
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
  var valid_580042 = path.getOrDefault("presentationId")
  valid_580042 = validateParameter(valid_580042, JString, required = true,
                                 default = nil)
  if valid_580042 != nil:
    section.add "presentationId", valid_580042
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
  var valid_580043 = query.getOrDefault("upload_protocol")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "upload_protocol", valid_580043
  var valid_580044 = query.getOrDefault("fields")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "fields", valid_580044
  var valid_580045 = query.getOrDefault("quotaUser")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "quotaUser", valid_580045
  var valid_580046 = query.getOrDefault("alt")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = newJString("json"))
  if valid_580046 != nil:
    section.add "alt", valid_580046
  var valid_580047 = query.getOrDefault("oauth_token")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "oauth_token", valid_580047
  var valid_580048 = query.getOrDefault("callback")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "callback", valid_580048
  var valid_580049 = query.getOrDefault("access_token")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "access_token", valid_580049
  var valid_580050 = query.getOrDefault("uploadType")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "uploadType", valid_580050
  var valid_580051 = query.getOrDefault("key")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "key", valid_580051
  var valid_580052 = query.getOrDefault("$.xgafv")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = newJString("1"))
  if valid_580052 != nil:
    section.add "$.xgafv", valid_580052
  var valid_580053 = query.getOrDefault("prettyPrint")
  valid_580053 = validateParameter(valid_580053, JBool, required = false,
                                 default = newJBool(true))
  if valid_580053 != nil:
    section.add "prettyPrint", valid_580053
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

proc call*(call_580055: Call_SlidesPresentationsBatchUpdate_580039; path: JsonNode;
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
  let valid = call_580055.validator(path, query, header, formData, body)
  let scheme = call_580055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580055.url(scheme.get, call_580055.host, call_580055.base,
                         call_580055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580055, url, valid)

proc call*(call_580056: Call_SlidesPresentationsBatchUpdate_580039;
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
  var path_580057 = newJObject()
  var query_580058 = newJObject()
  var body_580059 = newJObject()
  add(query_580058, "upload_protocol", newJString(uploadProtocol))
  add(query_580058, "fields", newJString(fields))
  add(query_580058, "quotaUser", newJString(quotaUser))
  add(query_580058, "alt", newJString(alt))
  add(path_580057, "presentationId", newJString(presentationId))
  add(query_580058, "oauth_token", newJString(oauthToken))
  add(query_580058, "callback", newJString(callback))
  add(query_580058, "access_token", newJString(accessToken))
  add(query_580058, "uploadType", newJString(uploadType))
  add(query_580058, "key", newJString(key))
  add(query_580058, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580059 = body
  add(query_580058, "prettyPrint", newJBool(prettyPrint))
  result = call_580056.call(path_580057, query_580058, nil, nil, body_580059)

var slidesPresentationsBatchUpdate* = Call_SlidesPresentationsBatchUpdate_580039(
    name: "slidesPresentationsBatchUpdate", meth: HttpMethod.HttpPost,
    host: "slides.googleapis.com",
    route: "/v1/presentations/{presentationId}:batchUpdate",
    validator: validate_SlidesPresentationsBatchUpdate_580040, base: "/",
    url: url_SlidesPresentationsBatchUpdate_580041, schemes: {Scheme.Https})
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
