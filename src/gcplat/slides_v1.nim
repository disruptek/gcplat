
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  gcpServiceName = "slides"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SlidesPresentationsCreate_593690 = ref object of OpenApiRestCall_593421
proc url_SlidesPresentationsCreate_593692(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SlidesPresentationsCreate_593691(path: JsonNode; query: JsonNode;
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

proc call*(call_593851: Call_SlidesPresentationsCreate_593690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a blank presentation using the title given in the request. If a
  ## `presentationId` is provided, it is used as the ID of the new presentation.
  ## Otherwise, a new ID is generated. Other fields in the request, including
  ## any provided content, are ignored.
  ## Returns the created presentation.
  ## 
  let valid = call_593851.validator(path, query, header, formData, body)
  let scheme = call_593851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593851.url(scheme.get, call_593851.host, call_593851.base,
                         call_593851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593851, url, valid)

proc call*(call_593922: Call_SlidesPresentationsCreate_593690;
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

var slidesPresentationsCreate* = Call_SlidesPresentationsCreate_593690(
    name: "slidesPresentationsCreate", meth: HttpMethod.HttpPost,
    host: "slides.googleapis.com", route: "/v1/presentations",
    validator: validate_SlidesPresentationsCreate_593691, base: "/",
    url: url_SlidesPresentationsCreate_593692, schemes: {Scheme.Https})
type
  Call_SlidesPresentationsGet_593964 = ref object of OpenApiRestCall_593421
proc url_SlidesPresentationsGet_593966(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "presentationId" in path, "`presentationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/presentations/"),
               (kind: VariableSegment, value: "presentationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SlidesPresentationsGet_593965(path: JsonNode; query: JsonNode;
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
  var valid_593981 = path.getOrDefault("presentationId")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "presentationId", valid_593981
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
  var valid_593982 = query.getOrDefault("upload_protocol")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "upload_protocol", valid_593982
  var valid_593983 = query.getOrDefault("fields")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "fields", valid_593983
  var valid_593984 = query.getOrDefault("quotaUser")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = nil)
  if valid_593984 != nil:
    section.add "quotaUser", valid_593984
  var valid_593985 = query.getOrDefault("alt")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = newJString("json"))
  if valid_593985 != nil:
    section.add "alt", valid_593985
  var valid_593986 = query.getOrDefault("oauth_token")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = nil)
  if valid_593986 != nil:
    section.add "oauth_token", valid_593986
  var valid_593987 = query.getOrDefault("callback")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "callback", valid_593987
  var valid_593988 = query.getOrDefault("access_token")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "access_token", valid_593988
  var valid_593989 = query.getOrDefault("uploadType")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "uploadType", valid_593989
  var valid_593990 = query.getOrDefault("key")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "key", valid_593990
  var valid_593991 = query.getOrDefault("$.xgafv")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = newJString("1"))
  if valid_593991 != nil:
    section.add "$.xgafv", valid_593991
  var valid_593992 = query.getOrDefault("prettyPrint")
  valid_593992 = validateParameter(valid_593992, JBool, required = false,
                                 default = newJBool(true))
  if valid_593992 != nil:
    section.add "prettyPrint", valid_593992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593993: Call_SlidesPresentationsGet_593964; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest version of the specified presentation.
  ## 
  let valid = call_593993.validator(path, query, header, formData, body)
  let scheme = call_593993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593993.url(scheme.get, call_593993.host, call_593993.base,
                         call_593993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593993, url, valid)

proc call*(call_593994: Call_SlidesPresentationsGet_593964; presentationId: string;
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
  var path_593995 = newJObject()
  var query_593996 = newJObject()
  add(query_593996, "upload_protocol", newJString(uploadProtocol))
  add(query_593996, "fields", newJString(fields))
  add(query_593996, "quotaUser", newJString(quotaUser))
  add(query_593996, "alt", newJString(alt))
  add(path_593995, "presentationId", newJString(presentationId))
  add(query_593996, "oauth_token", newJString(oauthToken))
  add(query_593996, "callback", newJString(callback))
  add(query_593996, "access_token", newJString(accessToken))
  add(query_593996, "uploadType", newJString(uploadType))
  add(query_593996, "key", newJString(key))
  add(query_593996, "$.xgafv", newJString(Xgafv))
  add(query_593996, "prettyPrint", newJBool(prettyPrint))
  result = call_593994.call(path_593995, query_593996, nil, nil, nil)

var slidesPresentationsGet* = Call_SlidesPresentationsGet_593964(
    name: "slidesPresentationsGet", meth: HttpMethod.HttpGet,
    host: "slides.googleapis.com", route: "/v1/presentations/{presentationId}",
    validator: validate_SlidesPresentationsGet_593965, base: "/",
    url: url_SlidesPresentationsGet_593966, schemes: {Scheme.Https})
type
  Call_SlidesPresentationsPagesGet_593997 = ref object of OpenApiRestCall_593421
proc url_SlidesPresentationsPagesGet_593999(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_SlidesPresentationsPagesGet_593998(path: JsonNode; query: JsonNode;
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
  var valid_594000 = path.getOrDefault("pageObjectId")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "pageObjectId", valid_594000
  var valid_594001 = path.getOrDefault("presentationId")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "presentationId", valid_594001
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
  var valid_594002 = query.getOrDefault("upload_protocol")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = nil)
  if valid_594002 != nil:
    section.add "upload_protocol", valid_594002
  var valid_594003 = query.getOrDefault("fields")
  valid_594003 = validateParameter(valid_594003, JString, required = false,
                                 default = nil)
  if valid_594003 != nil:
    section.add "fields", valid_594003
  var valid_594004 = query.getOrDefault("quotaUser")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = nil)
  if valid_594004 != nil:
    section.add "quotaUser", valid_594004
  var valid_594005 = query.getOrDefault("alt")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = newJString("json"))
  if valid_594005 != nil:
    section.add "alt", valid_594005
  var valid_594006 = query.getOrDefault("oauth_token")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "oauth_token", valid_594006
  var valid_594007 = query.getOrDefault("callback")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "callback", valid_594007
  var valid_594008 = query.getOrDefault("access_token")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "access_token", valid_594008
  var valid_594009 = query.getOrDefault("uploadType")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "uploadType", valid_594009
  var valid_594010 = query.getOrDefault("key")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "key", valid_594010
  var valid_594011 = query.getOrDefault("$.xgafv")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = newJString("1"))
  if valid_594011 != nil:
    section.add "$.xgafv", valid_594011
  var valid_594012 = query.getOrDefault("prettyPrint")
  valid_594012 = validateParameter(valid_594012, JBool, required = false,
                                 default = newJBool(true))
  if valid_594012 != nil:
    section.add "prettyPrint", valid_594012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594013: Call_SlidesPresentationsPagesGet_593997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest version of the specified page in the presentation.
  ## 
  let valid = call_594013.validator(path, query, header, formData, body)
  let scheme = call_594013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594013.url(scheme.get, call_594013.host, call_594013.base,
                         call_594013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594013, url, valid)

proc call*(call_594014: Call_SlidesPresentationsPagesGet_593997;
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
  var path_594015 = newJObject()
  var query_594016 = newJObject()
  add(query_594016, "upload_protocol", newJString(uploadProtocol))
  add(query_594016, "fields", newJString(fields))
  add(path_594015, "pageObjectId", newJString(pageObjectId))
  add(query_594016, "quotaUser", newJString(quotaUser))
  add(query_594016, "alt", newJString(alt))
  add(path_594015, "presentationId", newJString(presentationId))
  add(query_594016, "oauth_token", newJString(oauthToken))
  add(query_594016, "callback", newJString(callback))
  add(query_594016, "access_token", newJString(accessToken))
  add(query_594016, "uploadType", newJString(uploadType))
  add(query_594016, "key", newJString(key))
  add(query_594016, "$.xgafv", newJString(Xgafv))
  add(query_594016, "prettyPrint", newJBool(prettyPrint))
  result = call_594014.call(path_594015, query_594016, nil, nil, nil)

var slidesPresentationsPagesGet* = Call_SlidesPresentationsPagesGet_593997(
    name: "slidesPresentationsPagesGet", meth: HttpMethod.HttpGet,
    host: "slides.googleapis.com",
    route: "/v1/presentations/{presentationId}/pages/{pageObjectId}",
    validator: validate_SlidesPresentationsPagesGet_593998, base: "/",
    url: url_SlidesPresentationsPagesGet_593999, schemes: {Scheme.Https})
type
  Call_SlidesPresentationsPagesGetThumbnail_594017 = ref object of OpenApiRestCall_593421
proc url_SlidesPresentationsPagesGetThumbnail_594019(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_SlidesPresentationsPagesGetThumbnail_594018(path: JsonNode;
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
  var valid_594020 = path.getOrDefault("pageObjectId")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "pageObjectId", valid_594020
  var valid_594021 = path.getOrDefault("presentationId")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "presentationId", valid_594021
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
  var valid_594022 = query.getOrDefault("upload_protocol")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = nil)
  if valid_594022 != nil:
    section.add "upload_protocol", valid_594022
  var valid_594023 = query.getOrDefault("fields")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = nil)
  if valid_594023 != nil:
    section.add "fields", valid_594023
  var valid_594024 = query.getOrDefault("quotaUser")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = nil)
  if valid_594024 != nil:
    section.add "quotaUser", valid_594024
  var valid_594025 = query.getOrDefault("alt")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = newJString("json"))
  if valid_594025 != nil:
    section.add "alt", valid_594025
  var valid_594026 = query.getOrDefault("thumbnailProperties.mimeType")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = newJString("PNG"))
  if valid_594026 != nil:
    section.add "thumbnailProperties.mimeType", valid_594026
  var valid_594027 = query.getOrDefault("oauth_token")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "oauth_token", valid_594027
  var valid_594028 = query.getOrDefault("callback")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "callback", valid_594028
  var valid_594029 = query.getOrDefault("access_token")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "access_token", valid_594029
  var valid_594030 = query.getOrDefault("uploadType")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "uploadType", valid_594030
  var valid_594031 = query.getOrDefault("key")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "key", valid_594031
  var valid_594032 = query.getOrDefault("thumbnailProperties.thumbnailSize")
  valid_594032 = validateParameter(valid_594032, JString, required = false, default = newJString(
      "THUMBNAIL_SIZE_UNSPECIFIED"))
  if valid_594032 != nil:
    section.add "thumbnailProperties.thumbnailSize", valid_594032
  var valid_594033 = query.getOrDefault("$.xgafv")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = newJString("1"))
  if valid_594033 != nil:
    section.add "$.xgafv", valid_594033
  var valid_594034 = query.getOrDefault("prettyPrint")
  valid_594034 = validateParameter(valid_594034, JBool, required = false,
                                 default = newJBool(true))
  if valid_594034 != nil:
    section.add "prettyPrint", valid_594034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594035: Call_SlidesPresentationsPagesGetThumbnail_594017;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates a thumbnail of the latest version of the specified page in the
  ## presentation and returns a URL to the thumbnail image.
  ## 
  ## This request counts as an [expensive read request](/slides/limits) for
  ## quota purposes.
  ## 
  let valid = call_594035.validator(path, query, header, formData, body)
  let scheme = call_594035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594035.url(scheme.get, call_594035.host, call_594035.base,
                         call_594035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594035, url, valid)

proc call*(call_594036: Call_SlidesPresentationsPagesGetThumbnail_594017;
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
  var path_594037 = newJObject()
  var query_594038 = newJObject()
  add(query_594038, "upload_protocol", newJString(uploadProtocol))
  add(query_594038, "fields", newJString(fields))
  add(path_594037, "pageObjectId", newJString(pageObjectId))
  add(query_594038, "quotaUser", newJString(quotaUser))
  add(query_594038, "alt", newJString(alt))
  add(path_594037, "presentationId", newJString(presentationId))
  add(query_594038, "thumbnailProperties.mimeType",
      newJString(thumbnailPropertiesMimeType))
  add(query_594038, "oauth_token", newJString(oauthToken))
  add(query_594038, "callback", newJString(callback))
  add(query_594038, "access_token", newJString(accessToken))
  add(query_594038, "uploadType", newJString(uploadType))
  add(query_594038, "key", newJString(key))
  add(query_594038, "thumbnailProperties.thumbnailSize",
      newJString(thumbnailPropertiesThumbnailSize))
  add(query_594038, "$.xgafv", newJString(Xgafv))
  add(query_594038, "prettyPrint", newJBool(prettyPrint))
  result = call_594036.call(path_594037, query_594038, nil, nil, nil)

var slidesPresentationsPagesGetThumbnail* = Call_SlidesPresentationsPagesGetThumbnail_594017(
    name: "slidesPresentationsPagesGetThumbnail", meth: HttpMethod.HttpGet,
    host: "slides.googleapis.com",
    route: "/v1/presentations/{presentationId}/pages/{pageObjectId}/thumbnail",
    validator: validate_SlidesPresentationsPagesGetThumbnail_594018, base: "/",
    url: url_SlidesPresentationsPagesGetThumbnail_594019, schemes: {Scheme.Https})
type
  Call_SlidesPresentationsBatchUpdate_594039 = ref object of OpenApiRestCall_593421
proc url_SlidesPresentationsBatchUpdate_594041(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_SlidesPresentationsBatchUpdate_594040(path: JsonNode;
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
  var valid_594042 = path.getOrDefault("presentationId")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "presentationId", valid_594042
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
  var valid_594043 = query.getOrDefault("upload_protocol")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = nil)
  if valid_594043 != nil:
    section.add "upload_protocol", valid_594043
  var valid_594044 = query.getOrDefault("fields")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = nil)
  if valid_594044 != nil:
    section.add "fields", valid_594044
  var valid_594045 = query.getOrDefault("quotaUser")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = nil)
  if valid_594045 != nil:
    section.add "quotaUser", valid_594045
  var valid_594046 = query.getOrDefault("alt")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = newJString("json"))
  if valid_594046 != nil:
    section.add "alt", valid_594046
  var valid_594047 = query.getOrDefault("oauth_token")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = nil)
  if valid_594047 != nil:
    section.add "oauth_token", valid_594047
  var valid_594048 = query.getOrDefault("callback")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "callback", valid_594048
  var valid_594049 = query.getOrDefault("access_token")
  valid_594049 = validateParameter(valid_594049, JString, required = false,
                                 default = nil)
  if valid_594049 != nil:
    section.add "access_token", valid_594049
  var valid_594050 = query.getOrDefault("uploadType")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = nil)
  if valid_594050 != nil:
    section.add "uploadType", valid_594050
  var valid_594051 = query.getOrDefault("key")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "key", valid_594051
  var valid_594052 = query.getOrDefault("$.xgafv")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = newJString("1"))
  if valid_594052 != nil:
    section.add "$.xgafv", valid_594052
  var valid_594053 = query.getOrDefault("prettyPrint")
  valid_594053 = validateParameter(valid_594053, JBool, required = false,
                                 default = newJBool(true))
  if valid_594053 != nil:
    section.add "prettyPrint", valid_594053
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

proc call*(call_594055: Call_SlidesPresentationsBatchUpdate_594039; path: JsonNode;
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
  let valid = call_594055.validator(path, query, header, formData, body)
  let scheme = call_594055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594055.url(scheme.get, call_594055.host, call_594055.base,
                         call_594055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594055, url, valid)

proc call*(call_594056: Call_SlidesPresentationsBatchUpdate_594039;
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
  var path_594057 = newJObject()
  var query_594058 = newJObject()
  var body_594059 = newJObject()
  add(query_594058, "upload_protocol", newJString(uploadProtocol))
  add(query_594058, "fields", newJString(fields))
  add(query_594058, "quotaUser", newJString(quotaUser))
  add(query_594058, "alt", newJString(alt))
  add(path_594057, "presentationId", newJString(presentationId))
  add(query_594058, "oauth_token", newJString(oauthToken))
  add(query_594058, "callback", newJString(callback))
  add(query_594058, "access_token", newJString(accessToken))
  add(query_594058, "uploadType", newJString(uploadType))
  add(query_594058, "key", newJString(key))
  add(query_594058, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594059 = body
  add(query_594058, "prettyPrint", newJBool(prettyPrint))
  result = call_594056.call(path_594057, query_594058, nil, nil, body_594059)

var slidesPresentationsBatchUpdate* = Call_SlidesPresentationsBatchUpdate_594039(
    name: "slidesPresentationsBatchUpdate", meth: HttpMethod.HttpPost,
    host: "slides.googleapis.com",
    route: "/v1/presentations/{presentationId}:batchUpdate",
    validator: validate_SlidesPresentationsBatchUpdate_594040, base: "/",
    url: url_SlidesPresentationsBatchUpdate_594041, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
