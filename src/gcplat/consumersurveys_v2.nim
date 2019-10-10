
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Consumer Surveys
## version: v2
## termsOfService: (not provided)
## license: (not provided)
## 
## Creates and conducts surveys, lists the surveys that an authenticated user owns, and retrieves survey results and information about specified surveys.
## 
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

  OpenApiRestCall_588441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588441): Option[Scheme] {.used.} =
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
  gcpServiceName = "consumersurveys"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ConsumersurveysMobileapppanelsList_588709 = ref object of OpenApiRestCall_588441
proc url_ConsumersurveysMobileapppanelsList_588711(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ConsumersurveysMobileapppanelsList_588710(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the MobileAppPanels available to the authenticated user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   token: JString
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: JInt
  section = newJObject()
  var valid_588823 = query.getOrDefault("token")
  valid_588823 = validateParameter(valid_588823, JString, required = false,
                                 default = nil)
  if valid_588823 != nil:
    section.add "token", valid_588823
  var valid_588824 = query.getOrDefault("fields")
  valid_588824 = validateParameter(valid_588824, JString, required = false,
                                 default = nil)
  if valid_588824 != nil:
    section.add "fields", valid_588824
  var valid_588825 = query.getOrDefault("quotaUser")
  valid_588825 = validateParameter(valid_588825, JString, required = false,
                                 default = nil)
  if valid_588825 != nil:
    section.add "quotaUser", valid_588825
  var valid_588839 = query.getOrDefault("alt")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = newJString("json"))
  if valid_588839 != nil:
    section.add "alt", valid_588839
  var valid_588840 = query.getOrDefault("oauth_token")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "oauth_token", valid_588840
  var valid_588841 = query.getOrDefault("userIp")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "userIp", valid_588841
  var valid_588842 = query.getOrDefault("maxResults")
  valid_588842 = validateParameter(valid_588842, JInt, required = false, default = nil)
  if valid_588842 != nil:
    section.add "maxResults", valid_588842
  var valid_588843 = query.getOrDefault("key")
  valid_588843 = validateParameter(valid_588843, JString, required = false,
                                 default = nil)
  if valid_588843 != nil:
    section.add "key", valid_588843
  var valid_588844 = query.getOrDefault("prettyPrint")
  valid_588844 = validateParameter(valid_588844, JBool, required = false,
                                 default = newJBool(true))
  if valid_588844 != nil:
    section.add "prettyPrint", valid_588844
  var valid_588845 = query.getOrDefault("startIndex")
  valid_588845 = validateParameter(valid_588845, JInt, required = false, default = nil)
  if valid_588845 != nil:
    section.add "startIndex", valid_588845
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588868: Call_ConsumersurveysMobileapppanelsList_588709;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the MobileAppPanels available to the authenticated user.
  ## 
  let valid = call_588868.validator(path, query, header, formData, body)
  let scheme = call_588868.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588868.url(scheme.get, call_588868.host, call_588868.base,
                         call_588868.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588868, url, valid)

proc call*(call_588939: Call_ConsumersurveysMobileapppanelsList_588709;
          token: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true;
          startIndex: int = 0): Recallable =
  ## consumersurveysMobileapppanelsList
  ## Lists the MobileAppPanels available to the authenticated user.
  ##   token: string
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: int
  var query_588940 = newJObject()
  add(query_588940, "token", newJString(token))
  add(query_588940, "fields", newJString(fields))
  add(query_588940, "quotaUser", newJString(quotaUser))
  add(query_588940, "alt", newJString(alt))
  add(query_588940, "oauth_token", newJString(oauthToken))
  add(query_588940, "userIp", newJString(userIp))
  add(query_588940, "maxResults", newJInt(maxResults))
  add(query_588940, "key", newJString(key))
  add(query_588940, "prettyPrint", newJBool(prettyPrint))
  add(query_588940, "startIndex", newJInt(startIndex))
  result = call_588939.call(nil, query_588940, nil, nil, nil)

var consumersurveysMobileapppanelsList* = Call_ConsumersurveysMobileapppanelsList_588709(
    name: "consumersurveysMobileapppanelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/mobileAppPanels",
    validator: validate_ConsumersurveysMobileapppanelsList_588710,
    base: "/consumersurveys/v2", url: url_ConsumersurveysMobileapppanelsList_588711,
    schemes: {Scheme.Https})
type
  Call_ConsumersurveysMobileapppanelsUpdate_589009 = ref object of OpenApiRestCall_588441
proc url_ConsumersurveysMobileapppanelsUpdate_589011(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "panelId" in path, "`panelId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/mobileAppPanels/"),
               (kind: VariableSegment, value: "panelId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConsumersurveysMobileapppanelsUpdate_589010(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a MobileAppPanel. Currently the only property that can be updated is the owners property.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   panelId: JString (required)
  ##          : External URL ID for the panel.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `panelId` field"
  var valid_589012 = path.getOrDefault("panelId")
  valid_589012 = validateParameter(valid_589012, JString, required = true,
                                 default = nil)
  if valid_589012 != nil:
    section.add "panelId", valid_589012
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589013 = query.getOrDefault("fields")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "fields", valid_589013
  var valid_589014 = query.getOrDefault("quotaUser")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "quotaUser", valid_589014
  var valid_589015 = query.getOrDefault("alt")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = newJString("json"))
  if valid_589015 != nil:
    section.add "alt", valid_589015
  var valid_589016 = query.getOrDefault("oauth_token")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "oauth_token", valid_589016
  var valid_589017 = query.getOrDefault("userIp")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "userIp", valid_589017
  var valid_589018 = query.getOrDefault("key")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "key", valid_589018
  var valid_589019 = query.getOrDefault("prettyPrint")
  valid_589019 = validateParameter(valid_589019, JBool, required = false,
                                 default = newJBool(true))
  if valid_589019 != nil:
    section.add "prettyPrint", valid_589019
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

proc call*(call_589021: Call_ConsumersurveysMobileapppanelsUpdate_589009;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a MobileAppPanel. Currently the only property that can be updated is the owners property.
  ## 
  let valid = call_589021.validator(path, query, header, formData, body)
  let scheme = call_589021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589021.url(scheme.get, call_589021.host, call_589021.base,
                         call_589021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589021, url, valid)

proc call*(call_589022: Call_ConsumersurveysMobileapppanelsUpdate_589009;
          panelId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## consumersurveysMobileapppanelsUpdate
  ## Updates a MobileAppPanel. Currently the only property that can be updated is the owners property.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   panelId: string (required)
  ##          : External URL ID for the panel.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589023 = newJObject()
  var query_589024 = newJObject()
  var body_589025 = newJObject()
  add(query_589024, "fields", newJString(fields))
  add(query_589024, "quotaUser", newJString(quotaUser))
  add(query_589024, "alt", newJString(alt))
  add(query_589024, "oauth_token", newJString(oauthToken))
  add(query_589024, "userIp", newJString(userIp))
  add(query_589024, "key", newJString(key))
  add(path_589023, "panelId", newJString(panelId))
  if body != nil:
    body_589025 = body
  add(query_589024, "prettyPrint", newJBool(prettyPrint))
  result = call_589022.call(path_589023, query_589024, nil, nil, body_589025)

var consumersurveysMobileapppanelsUpdate* = Call_ConsumersurveysMobileapppanelsUpdate_589009(
    name: "consumersurveysMobileapppanelsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/mobileAppPanels/{panelId}",
    validator: validate_ConsumersurveysMobileapppanelsUpdate_589010,
    base: "/consumersurveys/v2", url: url_ConsumersurveysMobileapppanelsUpdate_589011,
    schemes: {Scheme.Https})
type
  Call_ConsumersurveysMobileapppanelsGet_588980 = ref object of OpenApiRestCall_588441
proc url_ConsumersurveysMobileapppanelsGet_588982(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "panelId" in path, "`panelId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/mobileAppPanels/"),
               (kind: VariableSegment, value: "panelId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConsumersurveysMobileapppanelsGet_588981(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a MobileAppPanel that is available to the authenticated user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   panelId: JString (required)
  ##          : External URL ID for the panel.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `panelId` field"
  var valid_588997 = path.getOrDefault("panelId")
  valid_588997 = validateParameter(valid_588997, JString, required = true,
                                 default = nil)
  if valid_588997 != nil:
    section.add "panelId", valid_588997
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_588998 = query.getOrDefault("fields")
  valid_588998 = validateParameter(valid_588998, JString, required = false,
                                 default = nil)
  if valid_588998 != nil:
    section.add "fields", valid_588998
  var valid_588999 = query.getOrDefault("quotaUser")
  valid_588999 = validateParameter(valid_588999, JString, required = false,
                                 default = nil)
  if valid_588999 != nil:
    section.add "quotaUser", valid_588999
  var valid_589000 = query.getOrDefault("alt")
  valid_589000 = validateParameter(valid_589000, JString, required = false,
                                 default = newJString("json"))
  if valid_589000 != nil:
    section.add "alt", valid_589000
  var valid_589001 = query.getOrDefault("oauth_token")
  valid_589001 = validateParameter(valid_589001, JString, required = false,
                                 default = nil)
  if valid_589001 != nil:
    section.add "oauth_token", valid_589001
  var valid_589002 = query.getOrDefault("userIp")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = nil)
  if valid_589002 != nil:
    section.add "userIp", valid_589002
  var valid_589003 = query.getOrDefault("key")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = nil)
  if valid_589003 != nil:
    section.add "key", valid_589003
  var valid_589004 = query.getOrDefault("prettyPrint")
  valid_589004 = validateParameter(valid_589004, JBool, required = false,
                                 default = newJBool(true))
  if valid_589004 != nil:
    section.add "prettyPrint", valid_589004
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589005: Call_ConsumersurveysMobileapppanelsGet_588980;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a MobileAppPanel that is available to the authenticated user.
  ## 
  let valid = call_589005.validator(path, query, header, formData, body)
  let scheme = call_589005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589005.url(scheme.get, call_589005.host, call_589005.base,
                         call_589005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589005, url, valid)

proc call*(call_589006: Call_ConsumersurveysMobileapppanelsGet_588980;
          panelId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## consumersurveysMobileapppanelsGet
  ## Retrieves a MobileAppPanel that is available to the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   panelId: string (required)
  ##          : External URL ID for the panel.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589007 = newJObject()
  var query_589008 = newJObject()
  add(query_589008, "fields", newJString(fields))
  add(query_589008, "quotaUser", newJString(quotaUser))
  add(query_589008, "alt", newJString(alt))
  add(query_589008, "oauth_token", newJString(oauthToken))
  add(query_589008, "userIp", newJString(userIp))
  add(query_589008, "key", newJString(key))
  add(path_589007, "panelId", newJString(panelId))
  add(query_589008, "prettyPrint", newJBool(prettyPrint))
  result = call_589006.call(path_589007, query_589008, nil, nil, nil)

var consumersurveysMobileapppanelsGet* = Call_ConsumersurveysMobileapppanelsGet_588980(
    name: "consumersurveysMobileapppanelsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/mobileAppPanels/{panelId}",
    validator: validate_ConsumersurveysMobileapppanelsGet_588981,
    base: "/consumersurveys/v2", url: url_ConsumersurveysMobileapppanelsGet_588982,
    schemes: {Scheme.Https})
type
  Call_ConsumersurveysSurveysInsert_589042 = ref object of OpenApiRestCall_588441
proc url_ConsumersurveysSurveysInsert_589044(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ConsumersurveysSurveysInsert_589043(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a survey.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589045 = query.getOrDefault("fields")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "fields", valid_589045
  var valid_589046 = query.getOrDefault("quotaUser")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "quotaUser", valid_589046
  var valid_589047 = query.getOrDefault("alt")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = newJString("json"))
  if valid_589047 != nil:
    section.add "alt", valid_589047
  var valid_589048 = query.getOrDefault("oauth_token")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "oauth_token", valid_589048
  var valid_589049 = query.getOrDefault("userIp")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "userIp", valid_589049
  var valid_589050 = query.getOrDefault("key")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "key", valid_589050
  var valid_589051 = query.getOrDefault("prettyPrint")
  valid_589051 = validateParameter(valid_589051, JBool, required = false,
                                 default = newJBool(true))
  if valid_589051 != nil:
    section.add "prettyPrint", valid_589051
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

proc call*(call_589053: Call_ConsumersurveysSurveysInsert_589042; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a survey.
  ## 
  let valid = call_589053.validator(path, query, header, formData, body)
  let scheme = call_589053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589053.url(scheme.get, call_589053.host, call_589053.base,
                         call_589053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589053, url, valid)

proc call*(call_589054: Call_ConsumersurveysSurveysInsert_589042;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## consumersurveysSurveysInsert
  ## Creates a survey.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589055 = newJObject()
  var body_589056 = newJObject()
  add(query_589055, "fields", newJString(fields))
  add(query_589055, "quotaUser", newJString(quotaUser))
  add(query_589055, "alt", newJString(alt))
  add(query_589055, "oauth_token", newJString(oauthToken))
  add(query_589055, "userIp", newJString(userIp))
  add(query_589055, "key", newJString(key))
  if body != nil:
    body_589056 = body
  add(query_589055, "prettyPrint", newJBool(prettyPrint))
  result = call_589054.call(nil, query_589055, nil, nil, body_589056)

var consumersurveysSurveysInsert* = Call_ConsumersurveysSurveysInsert_589042(
    name: "consumersurveysSurveysInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/surveys",
    validator: validate_ConsumersurveysSurveysInsert_589043,
    base: "/consumersurveys/v2", url: url_ConsumersurveysSurveysInsert_589044,
    schemes: {Scheme.Https})
type
  Call_ConsumersurveysSurveysList_589026 = ref object of OpenApiRestCall_588441
proc url_ConsumersurveysSurveysList_589028(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ConsumersurveysSurveysList_589027(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the surveys owned by the authenticated user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   token: JString
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: JInt
  section = newJObject()
  var valid_589029 = query.getOrDefault("token")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "token", valid_589029
  var valid_589030 = query.getOrDefault("fields")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "fields", valid_589030
  var valid_589031 = query.getOrDefault("quotaUser")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "quotaUser", valid_589031
  var valid_589032 = query.getOrDefault("alt")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = newJString("json"))
  if valid_589032 != nil:
    section.add "alt", valid_589032
  var valid_589033 = query.getOrDefault("oauth_token")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "oauth_token", valid_589033
  var valid_589034 = query.getOrDefault("userIp")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "userIp", valid_589034
  var valid_589035 = query.getOrDefault("maxResults")
  valid_589035 = validateParameter(valid_589035, JInt, required = false, default = nil)
  if valid_589035 != nil:
    section.add "maxResults", valid_589035
  var valid_589036 = query.getOrDefault("key")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "key", valid_589036
  var valid_589037 = query.getOrDefault("prettyPrint")
  valid_589037 = validateParameter(valid_589037, JBool, required = false,
                                 default = newJBool(true))
  if valid_589037 != nil:
    section.add "prettyPrint", valid_589037
  var valid_589038 = query.getOrDefault("startIndex")
  valid_589038 = validateParameter(valid_589038, JInt, required = false, default = nil)
  if valid_589038 != nil:
    section.add "startIndex", valid_589038
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589039: Call_ConsumersurveysSurveysList_589026; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the surveys owned by the authenticated user.
  ## 
  let valid = call_589039.validator(path, query, header, formData, body)
  let scheme = call_589039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589039.url(scheme.get, call_589039.host, call_589039.base,
                         call_589039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589039, url, valid)

proc call*(call_589040: Call_ConsumersurveysSurveysList_589026; token: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true; startIndex: int = 0): Recallable =
  ## consumersurveysSurveysList
  ## Lists the surveys owned by the authenticated user.
  ##   token: string
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: int
  var query_589041 = newJObject()
  add(query_589041, "token", newJString(token))
  add(query_589041, "fields", newJString(fields))
  add(query_589041, "quotaUser", newJString(quotaUser))
  add(query_589041, "alt", newJString(alt))
  add(query_589041, "oauth_token", newJString(oauthToken))
  add(query_589041, "userIp", newJString(userIp))
  add(query_589041, "maxResults", newJInt(maxResults))
  add(query_589041, "key", newJString(key))
  add(query_589041, "prettyPrint", newJBool(prettyPrint))
  add(query_589041, "startIndex", newJInt(startIndex))
  result = call_589040.call(nil, query_589041, nil, nil, nil)

var consumersurveysSurveysList* = Call_ConsumersurveysSurveysList_589026(
    name: "consumersurveysSurveysList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/surveys",
    validator: validate_ConsumersurveysSurveysList_589027,
    base: "/consumersurveys/v2", url: url_ConsumersurveysSurveysList_589028,
    schemes: {Scheme.Https})
type
  Call_ConsumersurveysSurveysStart_589057 = ref object of OpenApiRestCall_588441
proc url_ConsumersurveysSurveysStart_589059(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/surveys/"),
               (kind: VariableSegment, value: "resourceId"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConsumersurveysSurveysStart_589058(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Begins running a survey.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_589060 = path.getOrDefault("resourceId")
  valid_589060 = validateParameter(valid_589060, JString, required = true,
                                 default = nil)
  if valid_589060 != nil:
    section.add "resourceId", valid_589060
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589061 = query.getOrDefault("fields")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "fields", valid_589061
  var valid_589062 = query.getOrDefault("quotaUser")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "quotaUser", valid_589062
  var valid_589063 = query.getOrDefault("alt")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = newJString("json"))
  if valid_589063 != nil:
    section.add "alt", valid_589063
  var valid_589064 = query.getOrDefault("oauth_token")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "oauth_token", valid_589064
  var valid_589065 = query.getOrDefault("userIp")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "userIp", valid_589065
  var valid_589066 = query.getOrDefault("key")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "key", valid_589066
  var valid_589067 = query.getOrDefault("prettyPrint")
  valid_589067 = validateParameter(valid_589067, JBool, required = false,
                                 default = newJBool(true))
  if valid_589067 != nil:
    section.add "prettyPrint", valid_589067
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

proc call*(call_589069: Call_ConsumersurveysSurveysStart_589057; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Begins running a survey.
  ## 
  let valid = call_589069.validator(path, query, header, formData, body)
  let scheme = call_589069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589069.url(scheme.get, call_589069.host, call_589069.base,
                         call_589069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589069, url, valid)

proc call*(call_589070: Call_ConsumersurveysSurveysStart_589057;
          resourceId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## consumersurveysSurveysStart
  ## Begins running a survey.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   resourceId: string (required)
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589071 = newJObject()
  var query_589072 = newJObject()
  var body_589073 = newJObject()
  add(query_589072, "fields", newJString(fields))
  add(query_589072, "quotaUser", newJString(quotaUser))
  add(query_589072, "alt", newJString(alt))
  add(query_589072, "oauth_token", newJString(oauthToken))
  add(query_589072, "userIp", newJString(userIp))
  add(query_589072, "key", newJString(key))
  add(path_589071, "resourceId", newJString(resourceId))
  if body != nil:
    body_589073 = body
  add(query_589072, "prettyPrint", newJBool(prettyPrint))
  result = call_589070.call(path_589071, query_589072, nil, nil, body_589073)

var consumersurveysSurveysStart* = Call_ConsumersurveysSurveysStart_589057(
    name: "consumersurveysSurveysStart", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/surveys/{resourceId}/start",
    validator: validate_ConsumersurveysSurveysStart_589058,
    base: "/consumersurveys/v2", url: url_ConsumersurveysSurveysStart_589059,
    schemes: {Scheme.Https})
type
  Call_ConsumersurveysSurveysStop_589074 = ref object of OpenApiRestCall_588441
proc url_ConsumersurveysSurveysStop_589076(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/surveys/"),
               (kind: VariableSegment, value: "resourceId"),
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConsumersurveysSurveysStop_589075(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Stops a running survey.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_589077 = path.getOrDefault("resourceId")
  valid_589077 = validateParameter(valid_589077, JString, required = true,
                                 default = nil)
  if valid_589077 != nil:
    section.add "resourceId", valid_589077
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589078 = query.getOrDefault("fields")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "fields", valid_589078
  var valid_589079 = query.getOrDefault("quotaUser")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "quotaUser", valid_589079
  var valid_589080 = query.getOrDefault("alt")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = newJString("json"))
  if valid_589080 != nil:
    section.add "alt", valid_589080
  var valid_589081 = query.getOrDefault("oauth_token")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "oauth_token", valid_589081
  var valid_589082 = query.getOrDefault("userIp")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "userIp", valid_589082
  var valid_589083 = query.getOrDefault("key")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "key", valid_589083
  var valid_589084 = query.getOrDefault("prettyPrint")
  valid_589084 = validateParameter(valid_589084, JBool, required = false,
                                 default = newJBool(true))
  if valid_589084 != nil:
    section.add "prettyPrint", valid_589084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589085: Call_ConsumersurveysSurveysStop_589074; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops a running survey.
  ## 
  let valid = call_589085.validator(path, query, header, formData, body)
  let scheme = call_589085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589085.url(scheme.get, call_589085.host, call_589085.base,
                         call_589085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589085, url, valid)

proc call*(call_589086: Call_ConsumersurveysSurveysStop_589074; resourceId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## consumersurveysSurveysStop
  ## Stops a running survey.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   resourceId: string (required)
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589087 = newJObject()
  var query_589088 = newJObject()
  add(query_589088, "fields", newJString(fields))
  add(query_589088, "quotaUser", newJString(quotaUser))
  add(query_589088, "alt", newJString(alt))
  add(query_589088, "oauth_token", newJString(oauthToken))
  add(query_589088, "userIp", newJString(userIp))
  add(query_589088, "key", newJString(key))
  add(path_589087, "resourceId", newJString(resourceId))
  add(query_589088, "prettyPrint", newJBool(prettyPrint))
  result = call_589086.call(path_589087, query_589088, nil, nil, nil)

var consumersurveysSurveysStop* = Call_ConsumersurveysSurveysStop_589074(
    name: "consumersurveysSurveysStop", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/surveys/{resourceId}/stop",
    validator: validate_ConsumersurveysSurveysStop_589075,
    base: "/consumersurveys/v2", url: url_ConsumersurveysSurveysStop_589076,
    schemes: {Scheme.Https})
type
  Call_ConsumersurveysSurveysUpdate_589104 = ref object of OpenApiRestCall_588441
proc url_ConsumersurveysSurveysUpdate_589106(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "surveyUrlId" in path, "`surveyUrlId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/surveys/"),
               (kind: VariableSegment, value: "surveyUrlId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConsumersurveysSurveysUpdate_589105(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a survey. Currently the only property that can be updated is the owners property.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   surveyUrlId: JString (required)
  ##              : External URL ID for the survey.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `surveyUrlId` field"
  var valid_589107 = path.getOrDefault("surveyUrlId")
  valid_589107 = validateParameter(valid_589107, JString, required = true,
                                 default = nil)
  if valid_589107 != nil:
    section.add "surveyUrlId", valid_589107
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589108 = query.getOrDefault("fields")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "fields", valid_589108
  var valid_589109 = query.getOrDefault("quotaUser")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "quotaUser", valid_589109
  var valid_589110 = query.getOrDefault("alt")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = newJString("json"))
  if valid_589110 != nil:
    section.add "alt", valid_589110
  var valid_589111 = query.getOrDefault("oauth_token")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "oauth_token", valid_589111
  var valid_589112 = query.getOrDefault("userIp")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "userIp", valid_589112
  var valid_589113 = query.getOrDefault("key")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "key", valid_589113
  var valid_589114 = query.getOrDefault("prettyPrint")
  valid_589114 = validateParameter(valid_589114, JBool, required = false,
                                 default = newJBool(true))
  if valid_589114 != nil:
    section.add "prettyPrint", valid_589114
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

proc call*(call_589116: Call_ConsumersurveysSurveysUpdate_589104; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a survey. Currently the only property that can be updated is the owners property.
  ## 
  let valid = call_589116.validator(path, query, header, formData, body)
  let scheme = call_589116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589116.url(scheme.get, call_589116.host, call_589116.base,
                         call_589116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589116, url, valid)

proc call*(call_589117: Call_ConsumersurveysSurveysUpdate_589104;
          surveyUrlId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## consumersurveysSurveysUpdate
  ## Updates a survey. Currently the only property that can be updated is the owners property.
  ##   surveyUrlId: string (required)
  ##              : External URL ID for the survey.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589118 = newJObject()
  var query_589119 = newJObject()
  var body_589120 = newJObject()
  add(path_589118, "surveyUrlId", newJString(surveyUrlId))
  add(query_589119, "fields", newJString(fields))
  add(query_589119, "quotaUser", newJString(quotaUser))
  add(query_589119, "alt", newJString(alt))
  add(query_589119, "oauth_token", newJString(oauthToken))
  add(query_589119, "userIp", newJString(userIp))
  add(query_589119, "key", newJString(key))
  if body != nil:
    body_589120 = body
  add(query_589119, "prettyPrint", newJBool(prettyPrint))
  result = call_589117.call(path_589118, query_589119, nil, nil, body_589120)

var consumersurveysSurveysUpdate* = Call_ConsumersurveysSurveysUpdate_589104(
    name: "consumersurveysSurveysUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/surveys/{surveyUrlId}",
    validator: validate_ConsumersurveysSurveysUpdate_589105,
    base: "/consumersurveys/v2", url: url_ConsumersurveysSurveysUpdate_589106,
    schemes: {Scheme.Https})
type
  Call_ConsumersurveysSurveysGet_589089 = ref object of OpenApiRestCall_588441
proc url_ConsumersurveysSurveysGet_589091(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "surveyUrlId" in path, "`surveyUrlId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/surveys/"),
               (kind: VariableSegment, value: "surveyUrlId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConsumersurveysSurveysGet_589090(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves information about the specified survey.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   surveyUrlId: JString (required)
  ##              : External URL ID for the survey.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `surveyUrlId` field"
  var valid_589092 = path.getOrDefault("surveyUrlId")
  valid_589092 = validateParameter(valid_589092, JString, required = true,
                                 default = nil)
  if valid_589092 != nil:
    section.add "surveyUrlId", valid_589092
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589093 = query.getOrDefault("fields")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "fields", valid_589093
  var valid_589094 = query.getOrDefault("quotaUser")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "quotaUser", valid_589094
  var valid_589095 = query.getOrDefault("alt")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = newJString("json"))
  if valid_589095 != nil:
    section.add "alt", valid_589095
  var valid_589096 = query.getOrDefault("oauth_token")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "oauth_token", valid_589096
  var valid_589097 = query.getOrDefault("userIp")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "userIp", valid_589097
  var valid_589098 = query.getOrDefault("key")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "key", valid_589098
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
  if body != nil:
    result.add "body", body

proc call*(call_589100: Call_ConsumersurveysSurveysGet_589089; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about the specified survey.
  ## 
  let valid = call_589100.validator(path, query, header, formData, body)
  let scheme = call_589100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589100.url(scheme.get, call_589100.host, call_589100.base,
                         call_589100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589100, url, valid)

proc call*(call_589101: Call_ConsumersurveysSurveysGet_589089; surveyUrlId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## consumersurveysSurveysGet
  ## Retrieves information about the specified survey.
  ##   surveyUrlId: string (required)
  ##              : External URL ID for the survey.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589102 = newJObject()
  var query_589103 = newJObject()
  add(path_589102, "surveyUrlId", newJString(surveyUrlId))
  add(query_589103, "fields", newJString(fields))
  add(query_589103, "quotaUser", newJString(quotaUser))
  add(query_589103, "alt", newJString(alt))
  add(query_589103, "oauth_token", newJString(oauthToken))
  add(query_589103, "userIp", newJString(userIp))
  add(query_589103, "key", newJString(key))
  add(query_589103, "prettyPrint", newJBool(prettyPrint))
  result = call_589101.call(path_589102, query_589103, nil, nil, nil)

var consumersurveysSurveysGet* = Call_ConsumersurveysSurveysGet_589089(
    name: "consumersurveysSurveysGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/surveys/{surveyUrlId}",
    validator: validate_ConsumersurveysSurveysGet_589090,
    base: "/consumersurveys/v2", url: url_ConsumersurveysSurveysGet_589091,
    schemes: {Scheme.Https})
type
  Call_ConsumersurveysSurveysDelete_589121 = ref object of OpenApiRestCall_588441
proc url_ConsumersurveysSurveysDelete_589123(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "surveyUrlId" in path, "`surveyUrlId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/surveys/"),
               (kind: VariableSegment, value: "surveyUrlId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConsumersurveysSurveysDelete_589122(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a survey from view in all user GET requests.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   surveyUrlId: JString (required)
  ##              : External URL ID for the survey.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `surveyUrlId` field"
  var valid_589124 = path.getOrDefault("surveyUrlId")
  valid_589124 = validateParameter(valid_589124, JString, required = true,
                                 default = nil)
  if valid_589124 != nil:
    section.add "surveyUrlId", valid_589124
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589125 = query.getOrDefault("fields")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "fields", valid_589125
  var valid_589126 = query.getOrDefault("quotaUser")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "quotaUser", valid_589126
  var valid_589127 = query.getOrDefault("alt")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = newJString("json"))
  if valid_589127 != nil:
    section.add "alt", valid_589127
  var valid_589128 = query.getOrDefault("oauth_token")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "oauth_token", valid_589128
  var valid_589129 = query.getOrDefault("userIp")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "userIp", valid_589129
  var valid_589130 = query.getOrDefault("key")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "key", valid_589130
  var valid_589131 = query.getOrDefault("prettyPrint")
  valid_589131 = validateParameter(valid_589131, JBool, required = false,
                                 default = newJBool(true))
  if valid_589131 != nil:
    section.add "prettyPrint", valid_589131
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589132: Call_ConsumersurveysSurveysDelete_589121; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a survey from view in all user GET requests.
  ## 
  let valid = call_589132.validator(path, query, header, formData, body)
  let scheme = call_589132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589132.url(scheme.get, call_589132.host, call_589132.base,
                         call_589132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589132, url, valid)

proc call*(call_589133: Call_ConsumersurveysSurveysDelete_589121;
          surveyUrlId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## consumersurveysSurveysDelete
  ## Removes a survey from view in all user GET requests.
  ##   surveyUrlId: string (required)
  ##              : External URL ID for the survey.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589134 = newJObject()
  var query_589135 = newJObject()
  add(path_589134, "surveyUrlId", newJString(surveyUrlId))
  add(query_589135, "fields", newJString(fields))
  add(query_589135, "quotaUser", newJString(quotaUser))
  add(query_589135, "alt", newJString(alt))
  add(query_589135, "oauth_token", newJString(oauthToken))
  add(query_589135, "userIp", newJString(userIp))
  add(query_589135, "key", newJString(key))
  add(query_589135, "prettyPrint", newJBool(prettyPrint))
  result = call_589133.call(path_589134, query_589135, nil, nil, nil)

var consumersurveysSurveysDelete* = Call_ConsumersurveysSurveysDelete_589121(
    name: "consumersurveysSurveysDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/surveys/{surveyUrlId}",
    validator: validate_ConsumersurveysSurveysDelete_589122,
    base: "/consumersurveys/v2", url: url_ConsumersurveysSurveysDelete_589123,
    schemes: {Scheme.Https})
type
  Call_ConsumersurveysResultsGet_589136 = ref object of OpenApiRestCall_588441
proc url_ConsumersurveysResultsGet_589138(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "surveyUrlId" in path, "`surveyUrlId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/surveys/"),
               (kind: VariableSegment, value: "surveyUrlId"),
               (kind: ConstantSegment, value: "/results")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConsumersurveysResultsGet_589137(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves any survey results that have been produced so far. Results are formatted as an Excel file. You must add "?alt=media" to the URL as an argument to get results.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   surveyUrlId: JString (required)
  ##              : External URL ID for the survey.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `surveyUrlId` field"
  var valid_589139 = path.getOrDefault("surveyUrlId")
  valid_589139 = validateParameter(valid_589139, JString, required = true,
                                 default = nil)
  if valid_589139 != nil:
    section.add "surveyUrlId", valid_589139
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589140 = query.getOrDefault("fields")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "fields", valid_589140
  var valid_589141 = query.getOrDefault("quotaUser")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "quotaUser", valid_589141
  var valid_589142 = query.getOrDefault("alt")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = newJString("json"))
  if valid_589142 != nil:
    section.add "alt", valid_589142
  var valid_589143 = query.getOrDefault("oauth_token")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = nil)
  if valid_589143 != nil:
    section.add "oauth_token", valid_589143
  var valid_589144 = query.getOrDefault("userIp")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "userIp", valid_589144
  var valid_589145 = query.getOrDefault("key")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = nil)
  if valid_589145 != nil:
    section.add "key", valid_589145
  var valid_589146 = query.getOrDefault("prettyPrint")
  valid_589146 = validateParameter(valid_589146, JBool, required = false,
                                 default = newJBool(true))
  if valid_589146 != nil:
    section.add "prettyPrint", valid_589146
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

proc call*(call_589148: Call_ConsumersurveysResultsGet_589136; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves any survey results that have been produced so far. Results are formatted as an Excel file. You must add "?alt=media" to the URL as an argument to get results.
  ## 
  let valid = call_589148.validator(path, query, header, formData, body)
  let scheme = call_589148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589148.url(scheme.get, call_589148.host, call_589148.base,
                         call_589148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589148, url, valid)

proc call*(call_589149: Call_ConsumersurveysResultsGet_589136; surveyUrlId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## consumersurveysResultsGet
  ## Retrieves any survey results that have been produced so far. Results are formatted as an Excel file. You must add "?alt=media" to the URL as an argument to get results.
  ##   surveyUrlId: string (required)
  ##              : External URL ID for the survey.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589150 = newJObject()
  var query_589151 = newJObject()
  var body_589152 = newJObject()
  add(path_589150, "surveyUrlId", newJString(surveyUrlId))
  add(query_589151, "fields", newJString(fields))
  add(query_589151, "quotaUser", newJString(quotaUser))
  add(query_589151, "alt", newJString(alt))
  add(query_589151, "oauth_token", newJString(oauthToken))
  add(query_589151, "userIp", newJString(userIp))
  add(query_589151, "key", newJString(key))
  if body != nil:
    body_589152 = body
  add(query_589151, "prettyPrint", newJBool(prettyPrint))
  result = call_589149.call(path_589150, query_589151, nil, nil, body_589152)

var consumersurveysResultsGet* = Call_ConsumersurveysResultsGet_589136(
    name: "consumersurveysResultsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/surveys/{surveyUrlId}/results",
    validator: validate_ConsumersurveysResultsGet_589137,
    base: "/consumersurveys/v2", url: url_ConsumersurveysResultsGet_589138,
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
