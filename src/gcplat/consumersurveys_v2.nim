
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

  OpenApiRestCall_579408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579408): Option[Scheme] {.used.} =
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
  gcpServiceName = "consumersurveys"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ConsumersurveysMobileapppanelsList_579676 = ref object of OpenApiRestCall_579408
proc url_ConsumersurveysMobileapppanelsList_579678(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ConsumersurveysMobileapppanelsList_579677(path: JsonNode;
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
  var valid_579790 = query.getOrDefault("token")
  valid_579790 = validateParameter(valid_579790, JString, required = false,
                                 default = nil)
  if valid_579790 != nil:
    section.add "token", valid_579790
  var valid_579791 = query.getOrDefault("fields")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "fields", valid_579791
  var valid_579792 = query.getOrDefault("quotaUser")
  valid_579792 = validateParameter(valid_579792, JString, required = false,
                                 default = nil)
  if valid_579792 != nil:
    section.add "quotaUser", valid_579792
  var valid_579806 = query.getOrDefault("alt")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = newJString("json"))
  if valid_579806 != nil:
    section.add "alt", valid_579806
  var valid_579807 = query.getOrDefault("oauth_token")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "oauth_token", valid_579807
  var valid_579808 = query.getOrDefault("userIp")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "userIp", valid_579808
  var valid_579809 = query.getOrDefault("maxResults")
  valid_579809 = validateParameter(valid_579809, JInt, required = false, default = nil)
  if valid_579809 != nil:
    section.add "maxResults", valid_579809
  var valid_579810 = query.getOrDefault("key")
  valid_579810 = validateParameter(valid_579810, JString, required = false,
                                 default = nil)
  if valid_579810 != nil:
    section.add "key", valid_579810
  var valid_579811 = query.getOrDefault("prettyPrint")
  valid_579811 = validateParameter(valid_579811, JBool, required = false,
                                 default = newJBool(true))
  if valid_579811 != nil:
    section.add "prettyPrint", valid_579811
  var valid_579812 = query.getOrDefault("startIndex")
  valid_579812 = validateParameter(valid_579812, JInt, required = false, default = nil)
  if valid_579812 != nil:
    section.add "startIndex", valid_579812
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579835: Call_ConsumersurveysMobileapppanelsList_579676;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the MobileAppPanels available to the authenticated user.
  ## 
  let valid = call_579835.validator(path, query, header, formData, body)
  let scheme = call_579835.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579835.url(scheme.get, call_579835.host, call_579835.base,
                         call_579835.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579835, url, valid)

proc call*(call_579906: Call_ConsumersurveysMobileapppanelsList_579676;
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
  var query_579907 = newJObject()
  add(query_579907, "token", newJString(token))
  add(query_579907, "fields", newJString(fields))
  add(query_579907, "quotaUser", newJString(quotaUser))
  add(query_579907, "alt", newJString(alt))
  add(query_579907, "oauth_token", newJString(oauthToken))
  add(query_579907, "userIp", newJString(userIp))
  add(query_579907, "maxResults", newJInt(maxResults))
  add(query_579907, "key", newJString(key))
  add(query_579907, "prettyPrint", newJBool(prettyPrint))
  add(query_579907, "startIndex", newJInt(startIndex))
  result = call_579906.call(nil, query_579907, nil, nil, nil)

var consumersurveysMobileapppanelsList* = Call_ConsumersurveysMobileapppanelsList_579676(
    name: "consumersurveysMobileapppanelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/mobileAppPanels",
    validator: validate_ConsumersurveysMobileapppanelsList_579677,
    base: "/consumersurveys/v2", url: url_ConsumersurveysMobileapppanelsList_579678,
    schemes: {Scheme.Https})
type
  Call_ConsumersurveysMobileapppanelsUpdate_579976 = ref object of OpenApiRestCall_579408
proc url_ConsumersurveysMobileapppanelsUpdate_579978(protocol: Scheme;
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

proc validate_ConsumersurveysMobileapppanelsUpdate_579977(path: JsonNode;
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
  var valid_579979 = path.getOrDefault("panelId")
  valid_579979 = validateParameter(valid_579979, JString, required = true,
                                 default = nil)
  if valid_579979 != nil:
    section.add "panelId", valid_579979
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
  var valid_579980 = query.getOrDefault("fields")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "fields", valid_579980
  var valid_579981 = query.getOrDefault("quotaUser")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "quotaUser", valid_579981
  var valid_579982 = query.getOrDefault("alt")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = newJString("json"))
  if valid_579982 != nil:
    section.add "alt", valid_579982
  var valid_579983 = query.getOrDefault("oauth_token")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "oauth_token", valid_579983
  var valid_579984 = query.getOrDefault("userIp")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "userIp", valid_579984
  var valid_579985 = query.getOrDefault("key")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "key", valid_579985
  var valid_579986 = query.getOrDefault("prettyPrint")
  valid_579986 = validateParameter(valid_579986, JBool, required = false,
                                 default = newJBool(true))
  if valid_579986 != nil:
    section.add "prettyPrint", valid_579986
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

proc call*(call_579988: Call_ConsumersurveysMobileapppanelsUpdate_579976;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a MobileAppPanel. Currently the only property that can be updated is the owners property.
  ## 
  let valid = call_579988.validator(path, query, header, formData, body)
  let scheme = call_579988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579988.url(scheme.get, call_579988.host, call_579988.base,
                         call_579988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579988, url, valid)

proc call*(call_579989: Call_ConsumersurveysMobileapppanelsUpdate_579976;
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
  var path_579990 = newJObject()
  var query_579991 = newJObject()
  var body_579992 = newJObject()
  add(query_579991, "fields", newJString(fields))
  add(query_579991, "quotaUser", newJString(quotaUser))
  add(query_579991, "alt", newJString(alt))
  add(query_579991, "oauth_token", newJString(oauthToken))
  add(query_579991, "userIp", newJString(userIp))
  add(query_579991, "key", newJString(key))
  add(path_579990, "panelId", newJString(panelId))
  if body != nil:
    body_579992 = body
  add(query_579991, "prettyPrint", newJBool(prettyPrint))
  result = call_579989.call(path_579990, query_579991, nil, nil, body_579992)

var consumersurveysMobileapppanelsUpdate* = Call_ConsumersurveysMobileapppanelsUpdate_579976(
    name: "consumersurveysMobileapppanelsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/mobileAppPanels/{panelId}",
    validator: validate_ConsumersurveysMobileapppanelsUpdate_579977,
    base: "/consumersurveys/v2", url: url_ConsumersurveysMobileapppanelsUpdate_579978,
    schemes: {Scheme.Https})
type
  Call_ConsumersurveysMobileapppanelsGet_579947 = ref object of OpenApiRestCall_579408
proc url_ConsumersurveysMobileapppanelsGet_579949(protocol: Scheme; host: string;
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

proc validate_ConsumersurveysMobileapppanelsGet_579948(path: JsonNode;
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
  var valid_579964 = path.getOrDefault("panelId")
  valid_579964 = validateParameter(valid_579964, JString, required = true,
                                 default = nil)
  if valid_579964 != nil:
    section.add "panelId", valid_579964
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
  var valid_579965 = query.getOrDefault("fields")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "fields", valid_579965
  var valid_579966 = query.getOrDefault("quotaUser")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "quotaUser", valid_579966
  var valid_579967 = query.getOrDefault("alt")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = newJString("json"))
  if valid_579967 != nil:
    section.add "alt", valid_579967
  var valid_579968 = query.getOrDefault("oauth_token")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "oauth_token", valid_579968
  var valid_579969 = query.getOrDefault("userIp")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "userIp", valid_579969
  var valid_579970 = query.getOrDefault("key")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "key", valid_579970
  var valid_579971 = query.getOrDefault("prettyPrint")
  valid_579971 = validateParameter(valid_579971, JBool, required = false,
                                 default = newJBool(true))
  if valid_579971 != nil:
    section.add "prettyPrint", valid_579971
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579972: Call_ConsumersurveysMobileapppanelsGet_579947;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a MobileAppPanel that is available to the authenticated user.
  ## 
  let valid = call_579972.validator(path, query, header, formData, body)
  let scheme = call_579972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579972.url(scheme.get, call_579972.host, call_579972.base,
                         call_579972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579972, url, valid)

proc call*(call_579973: Call_ConsumersurveysMobileapppanelsGet_579947;
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
  var path_579974 = newJObject()
  var query_579975 = newJObject()
  add(query_579975, "fields", newJString(fields))
  add(query_579975, "quotaUser", newJString(quotaUser))
  add(query_579975, "alt", newJString(alt))
  add(query_579975, "oauth_token", newJString(oauthToken))
  add(query_579975, "userIp", newJString(userIp))
  add(query_579975, "key", newJString(key))
  add(path_579974, "panelId", newJString(panelId))
  add(query_579975, "prettyPrint", newJBool(prettyPrint))
  result = call_579973.call(path_579974, query_579975, nil, nil, nil)

var consumersurveysMobileapppanelsGet* = Call_ConsumersurveysMobileapppanelsGet_579947(
    name: "consumersurveysMobileapppanelsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/mobileAppPanels/{panelId}",
    validator: validate_ConsumersurveysMobileapppanelsGet_579948,
    base: "/consumersurveys/v2", url: url_ConsumersurveysMobileapppanelsGet_579949,
    schemes: {Scheme.Https})
type
  Call_ConsumersurveysSurveysInsert_580009 = ref object of OpenApiRestCall_579408
proc url_ConsumersurveysSurveysInsert_580011(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ConsumersurveysSurveysInsert_580010(path: JsonNode; query: JsonNode;
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
  var valid_580012 = query.getOrDefault("fields")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "fields", valid_580012
  var valid_580013 = query.getOrDefault("quotaUser")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "quotaUser", valid_580013
  var valid_580014 = query.getOrDefault("alt")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = newJString("json"))
  if valid_580014 != nil:
    section.add "alt", valid_580014
  var valid_580015 = query.getOrDefault("oauth_token")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "oauth_token", valid_580015
  var valid_580016 = query.getOrDefault("userIp")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "userIp", valid_580016
  var valid_580017 = query.getOrDefault("key")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "key", valid_580017
  var valid_580018 = query.getOrDefault("prettyPrint")
  valid_580018 = validateParameter(valid_580018, JBool, required = false,
                                 default = newJBool(true))
  if valid_580018 != nil:
    section.add "prettyPrint", valid_580018
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

proc call*(call_580020: Call_ConsumersurveysSurveysInsert_580009; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a survey.
  ## 
  let valid = call_580020.validator(path, query, header, formData, body)
  let scheme = call_580020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580020.url(scheme.get, call_580020.host, call_580020.base,
                         call_580020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580020, url, valid)

proc call*(call_580021: Call_ConsumersurveysSurveysInsert_580009;
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
  var query_580022 = newJObject()
  var body_580023 = newJObject()
  add(query_580022, "fields", newJString(fields))
  add(query_580022, "quotaUser", newJString(quotaUser))
  add(query_580022, "alt", newJString(alt))
  add(query_580022, "oauth_token", newJString(oauthToken))
  add(query_580022, "userIp", newJString(userIp))
  add(query_580022, "key", newJString(key))
  if body != nil:
    body_580023 = body
  add(query_580022, "prettyPrint", newJBool(prettyPrint))
  result = call_580021.call(nil, query_580022, nil, nil, body_580023)

var consumersurveysSurveysInsert* = Call_ConsumersurveysSurveysInsert_580009(
    name: "consumersurveysSurveysInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/surveys",
    validator: validate_ConsumersurveysSurveysInsert_580010,
    base: "/consumersurveys/v2", url: url_ConsumersurveysSurveysInsert_580011,
    schemes: {Scheme.Https})
type
  Call_ConsumersurveysSurveysList_579993 = ref object of OpenApiRestCall_579408
proc url_ConsumersurveysSurveysList_579995(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ConsumersurveysSurveysList_579994(path: JsonNode; query: JsonNode;
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
  var valid_579996 = query.getOrDefault("token")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "token", valid_579996
  var valid_579997 = query.getOrDefault("fields")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "fields", valid_579997
  var valid_579998 = query.getOrDefault("quotaUser")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "quotaUser", valid_579998
  var valid_579999 = query.getOrDefault("alt")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = newJString("json"))
  if valid_579999 != nil:
    section.add "alt", valid_579999
  var valid_580000 = query.getOrDefault("oauth_token")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "oauth_token", valid_580000
  var valid_580001 = query.getOrDefault("userIp")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "userIp", valid_580001
  var valid_580002 = query.getOrDefault("maxResults")
  valid_580002 = validateParameter(valid_580002, JInt, required = false, default = nil)
  if valid_580002 != nil:
    section.add "maxResults", valid_580002
  var valid_580003 = query.getOrDefault("key")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "key", valid_580003
  var valid_580004 = query.getOrDefault("prettyPrint")
  valid_580004 = validateParameter(valid_580004, JBool, required = false,
                                 default = newJBool(true))
  if valid_580004 != nil:
    section.add "prettyPrint", valid_580004
  var valid_580005 = query.getOrDefault("startIndex")
  valid_580005 = validateParameter(valid_580005, JInt, required = false, default = nil)
  if valid_580005 != nil:
    section.add "startIndex", valid_580005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580006: Call_ConsumersurveysSurveysList_579993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the surveys owned by the authenticated user.
  ## 
  let valid = call_580006.validator(path, query, header, formData, body)
  let scheme = call_580006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580006.url(scheme.get, call_580006.host, call_580006.base,
                         call_580006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580006, url, valid)

proc call*(call_580007: Call_ConsumersurveysSurveysList_579993; token: string = "";
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
  var query_580008 = newJObject()
  add(query_580008, "token", newJString(token))
  add(query_580008, "fields", newJString(fields))
  add(query_580008, "quotaUser", newJString(quotaUser))
  add(query_580008, "alt", newJString(alt))
  add(query_580008, "oauth_token", newJString(oauthToken))
  add(query_580008, "userIp", newJString(userIp))
  add(query_580008, "maxResults", newJInt(maxResults))
  add(query_580008, "key", newJString(key))
  add(query_580008, "prettyPrint", newJBool(prettyPrint))
  add(query_580008, "startIndex", newJInt(startIndex))
  result = call_580007.call(nil, query_580008, nil, nil, nil)

var consumersurveysSurveysList* = Call_ConsumersurveysSurveysList_579993(
    name: "consumersurveysSurveysList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/surveys",
    validator: validate_ConsumersurveysSurveysList_579994,
    base: "/consumersurveys/v2", url: url_ConsumersurveysSurveysList_579995,
    schemes: {Scheme.Https})
type
  Call_ConsumersurveysSurveysStart_580024 = ref object of OpenApiRestCall_579408
proc url_ConsumersurveysSurveysStart_580026(protocol: Scheme; host: string;
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

proc validate_ConsumersurveysSurveysStart_580025(path: JsonNode; query: JsonNode;
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
  var valid_580027 = path.getOrDefault("resourceId")
  valid_580027 = validateParameter(valid_580027, JString, required = true,
                                 default = nil)
  if valid_580027 != nil:
    section.add "resourceId", valid_580027
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
  var valid_580028 = query.getOrDefault("fields")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "fields", valid_580028
  var valid_580029 = query.getOrDefault("quotaUser")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "quotaUser", valid_580029
  var valid_580030 = query.getOrDefault("alt")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = newJString("json"))
  if valid_580030 != nil:
    section.add "alt", valid_580030
  var valid_580031 = query.getOrDefault("oauth_token")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "oauth_token", valid_580031
  var valid_580032 = query.getOrDefault("userIp")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "userIp", valid_580032
  var valid_580033 = query.getOrDefault("key")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "key", valid_580033
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580036: Call_ConsumersurveysSurveysStart_580024; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Begins running a survey.
  ## 
  let valid = call_580036.validator(path, query, header, formData, body)
  let scheme = call_580036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580036.url(scheme.get, call_580036.host, call_580036.base,
                         call_580036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580036, url, valid)

proc call*(call_580037: Call_ConsumersurveysSurveysStart_580024;
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
  var path_580038 = newJObject()
  var query_580039 = newJObject()
  var body_580040 = newJObject()
  add(query_580039, "fields", newJString(fields))
  add(query_580039, "quotaUser", newJString(quotaUser))
  add(query_580039, "alt", newJString(alt))
  add(query_580039, "oauth_token", newJString(oauthToken))
  add(query_580039, "userIp", newJString(userIp))
  add(query_580039, "key", newJString(key))
  add(path_580038, "resourceId", newJString(resourceId))
  if body != nil:
    body_580040 = body
  add(query_580039, "prettyPrint", newJBool(prettyPrint))
  result = call_580037.call(path_580038, query_580039, nil, nil, body_580040)

var consumersurveysSurveysStart* = Call_ConsumersurveysSurveysStart_580024(
    name: "consumersurveysSurveysStart", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/surveys/{resourceId}/start",
    validator: validate_ConsumersurveysSurveysStart_580025,
    base: "/consumersurveys/v2", url: url_ConsumersurveysSurveysStart_580026,
    schemes: {Scheme.Https})
type
  Call_ConsumersurveysSurveysStop_580041 = ref object of OpenApiRestCall_579408
proc url_ConsumersurveysSurveysStop_580043(protocol: Scheme; host: string;
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

proc validate_ConsumersurveysSurveysStop_580042(path: JsonNode; query: JsonNode;
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
  var valid_580044 = path.getOrDefault("resourceId")
  valid_580044 = validateParameter(valid_580044, JString, required = true,
                                 default = nil)
  if valid_580044 != nil:
    section.add "resourceId", valid_580044
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
  var valid_580045 = query.getOrDefault("fields")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "fields", valid_580045
  var valid_580046 = query.getOrDefault("quotaUser")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "quotaUser", valid_580046
  var valid_580047 = query.getOrDefault("alt")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = newJString("json"))
  if valid_580047 != nil:
    section.add "alt", valid_580047
  var valid_580048 = query.getOrDefault("oauth_token")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "oauth_token", valid_580048
  var valid_580049 = query.getOrDefault("userIp")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "userIp", valid_580049
  var valid_580050 = query.getOrDefault("key")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "key", valid_580050
  var valid_580051 = query.getOrDefault("prettyPrint")
  valid_580051 = validateParameter(valid_580051, JBool, required = false,
                                 default = newJBool(true))
  if valid_580051 != nil:
    section.add "prettyPrint", valid_580051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580052: Call_ConsumersurveysSurveysStop_580041; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops a running survey.
  ## 
  let valid = call_580052.validator(path, query, header, formData, body)
  let scheme = call_580052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580052.url(scheme.get, call_580052.host, call_580052.base,
                         call_580052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580052, url, valid)

proc call*(call_580053: Call_ConsumersurveysSurveysStop_580041; resourceId: string;
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
  var path_580054 = newJObject()
  var query_580055 = newJObject()
  add(query_580055, "fields", newJString(fields))
  add(query_580055, "quotaUser", newJString(quotaUser))
  add(query_580055, "alt", newJString(alt))
  add(query_580055, "oauth_token", newJString(oauthToken))
  add(query_580055, "userIp", newJString(userIp))
  add(query_580055, "key", newJString(key))
  add(path_580054, "resourceId", newJString(resourceId))
  add(query_580055, "prettyPrint", newJBool(prettyPrint))
  result = call_580053.call(path_580054, query_580055, nil, nil, nil)

var consumersurveysSurveysStop* = Call_ConsumersurveysSurveysStop_580041(
    name: "consumersurveysSurveysStop", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/surveys/{resourceId}/stop",
    validator: validate_ConsumersurveysSurveysStop_580042,
    base: "/consumersurveys/v2", url: url_ConsumersurveysSurveysStop_580043,
    schemes: {Scheme.Https})
type
  Call_ConsumersurveysSurveysUpdate_580071 = ref object of OpenApiRestCall_579408
proc url_ConsumersurveysSurveysUpdate_580073(protocol: Scheme; host: string;
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

proc validate_ConsumersurveysSurveysUpdate_580072(path: JsonNode; query: JsonNode;
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
  var valid_580074 = path.getOrDefault("surveyUrlId")
  valid_580074 = validateParameter(valid_580074, JString, required = true,
                                 default = nil)
  if valid_580074 != nil:
    section.add "surveyUrlId", valid_580074
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
  var valid_580075 = query.getOrDefault("fields")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "fields", valid_580075
  var valid_580076 = query.getOrDefault("quotaUser")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "quotaUser", valid_580076
  var valid_580077 = query.getOrDefault("alt")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = newJString("json"))
  if valid_580077 != nil:
    section.add "alt", valid_580077
  var valid_580078 = query.getOrDefault("oauth_token")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "oauth_token", valid_580078
  var valid_580079 = query.getOrDefault("userIp")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "userIp", valid_580079
  var valid_580080 = query.getOrDefault("key")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "key", valid_580080
  var valid_580081 = query.getOrDefault("prettyPrint")
  valid_580081 = validateParameter(valid_580081, JBool, required = false,
                                 default = newJBool(true))
  if valid_580081 != nil:
    section.add "prettyPrint", valid_580081
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

proc call*(call_580083: Call_ConsumersurveysSurveysUpdate_580071; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a survey. Currently the only property that can be updated is the owners property.
  ## 
  let valid = call_580083.validator(path, query, header, formData, body)
  let scheme = call_580083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580083.url(scheme.get, call_580083.host, call_580083.base,
                         call_580083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580083, url, valid)

proc call*(call_580084: Call_ConsumersurveysSurveysUpdate_580071;
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
  var path_580085 = newJObject()
  var query_580086 = newJObject()
  var body_580087 = newJObject()
  add(path_580085, "surveyUrlId", newJString(surveyUrlId))
  add(query_580086, "fields", newJString(fields))
  add(query_580086, "quotaUser", newJString(quotaUser))
  add(query_580086, "alt", newJString(alt))
  add(query_580086, "oauth_token", newJString(oauthToken))
  add(query_580086, "userIp", newJString(userIp))
  add(query_580086, "key", newJString(key))
  if body != nil:
    body_580087 = body
  add(query_580086, "prettyPrint", newJBool(prettyPrint))
  result = call_580084.call(path_580085, query_580086, nil, nil, body_580087)

var consumersurveysSurveysUpdate* = Call_ConsumersurveysSurveysUpdate_580071(
    name: "consumersurveysSurveysUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/surveys/{surveyUrlId}",
    validator: validate_ConsumersurveysSurveysUpdate_580072,
    base: "/consumersurveys/v2", url: url_ConsumersurveysSurveysUpdate_580073,
    schemes: {Scheme.Https})
type
  Call_ConsumersurveysSurveysGet_580056 = ref object of OpenApiRestCall_579408
proc url_ConsumersurveysSurveysGet_580058(protocol: Scheme; host: string;
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

proc validate_ConsumersurveysSurveysGet_580057(path: JsonNode; query: JsonNode;
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
  var valid_580059 = path.getOrDefault("surveyUrlId")
  valid_580059 = validateParameter(valid_580059, JString, required = true,
                                 default = nil)
  if valid_580059 != nil:
    section.add "surveyUrlId", valid_580059
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
  var valid_580060 = query.getOrDefault("fields")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "fields", valid_580060
  var valid_580061 = query.getOrDefault("quotaUser")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "quotaUser", valid_580061
  var valid_580062 = query.getOrDefault("alt")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = newJString("json"))
  if valid_580062 != nil:
    section.add "alt", valid_580062
  var valid_580063 = query.getOrDefault("oauth_token")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "oauth_token", valid_580063
  var valid_580064 = query.getOrDefault("userIp")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "userIp", valid_580064
  var valid_580065 = query.getOrDefault("key")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "key", valid_580065
  var valid_580066 = query.getOrDefault("prettyPrint")
  valid_580066 = validateParameter(valid_580066, JBool, required = false,
                                 default = newJBool(true))
  if valid_580066 != nil:
    section.add "prettyPrint", valid_580066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580067: Call_ConsumersurveysSurveysGet_580056; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about the specified survey.
  ## 
  let valid = call_580067.validator(path, query, header, formData, body)
  let scheme = call_580067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580067.url(scheme.get, call_580067.host, call_580067.base,
                         call_580067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580067, url, valid)

proc call*(call_580068: Call_ConsumersurveysSurveysGet_580056; surveyUrlId: string;
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
  var path_580069 = newJObject()
  var query_580070 = newJObject()
  add(path_580069, "surveyUrlId", newJString(surveyUrlId))
  add(query_580070, "fields", newJString(fields))
  add(query_580070, "quotaUser", newJString(quotaUser))
  add(query_580070, "alt", newJString(alt))
  add(query_580070, "oauth_token", newJString(oauthToken))
  add(query_580070, "userIp", newJString(userIp))
  add(query_580070, "key", newJString(key))
  add(query_580070, "prettyPrint", newJBool(prettyPrint))
  result = call_580068.call(path_580069, query_580070, nil, nil, nil)

var consumersurveysSurveysGet* = Call_ConsumersurveysSurveysGet_580056(
    name: "consumersurveysSurveysGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/surveys/{surveyUrlId}",
    validator: validate_ConsumersurveysSurveysGet_580057,
    base: "/consumersurveys/v2", url: url_ConsumersurveysSurveysGet_580058,
    schemes: {Scheme.Https})
type
  Call_ConsumersurveysSurveysDelete_580088 = ref object of OpenApiRestCall_579408
proc url_ConsumersurveysSurveysDelete_580090(protocol: Scheme; host: string;
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

proc validate_ConsumersurveysSurveysDelete_580089(path: JsonNode; query: JsonNode;
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
  var valid_580091 = path.getOrDefault("surveyUrlId")
  valid_580091 = validateParameter(valid_580091, JString, required = true,
                                 default = nil)
  if valid_580091 != nil:
    section.add "surveyUrlId", valid_580091
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
  var valid_580092 = query.getOrDefault("fields")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "fields", valid_580092
  var valid_580093 = query.getOrDefault("quotaUser")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "quotaUser", valid_580093
  var valid_580094 = query.getOrDefault("alt")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = newJString("json"))
  if valid_580094 != nil:
    section.add "alt", valid_580094
  var valid_580095 = query.getOrDefault("oauth_token")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "oauth_token", valid_580095
  var valid_580096 = query.getOrDefault("userIp")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "userIp", valid_580096
  var valid_580097 = query.getOrDefault("key")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "key", valid_580097
  var valid_580098 = query.getOrDefault("prettyPrint")
  valid_580098 = validateParameter(valid_580098, JBool, required = false,
                                 default = newJBool(true))
  if valid_580098 != nil:
    section.add "prettyPrint", valid_580098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580099: Call_ConsumersurveysSurveysDelete_580088; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a survey from view in all user GET requests.
  ## 
  let valid = call_580099.validator(path, query, header, formData, body)
  let scheme = call_580099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580099.url(scheme.get, call_580099.host, call_580099.base,
                         call_580099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580099, url, valid)

proc call*(call_580100: Call_ConsumersurveysSurveysDelete_580088;
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
  var path_580101 = newJObject()
  var query_580102 = newJObject()
  add(path_580101, "surveyUrlId", newJString(surveyUrlId))
  add(query_580102, "fields", newJString(fields))
  add(query_580102, "quotaUser", newJString(quotaUser))
  add(query_580102, "alt", newJString(alt))
  add(query_580102, "oauth_token", newJString(oauthToken))
  add(query_580102, "userIp", newJString(userIp))
  add(query_580102, "key", newJString(key))
  add(query_580102, "prettyPrint", newJBool(prettyPrint))
  result = call_580100.call(path_580101, query_580102, nil, nil, nil)

var consumersurveysSurveysDelete* = Call_ConsumersurveysSurveysDelete_580088(
    name: "consumersurveysSurveysDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/surveys/{surveyUrlId}",
    validator: validate_ConsumersurveysSurveysDelete_580089,
    base: "/consumersurveys/v2", url: url_ConsumersurveysSurveysDelete_580090,
    schemes: {Scheme.Https})
type
  Call_ConsumersurveysResultsGet_580103 = ref object of OpenApiRestCall_579408
proc url_ConsumersurveysResultsGet_580105(protocol: Scheme; host: string;
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

proc validate_ConsumersurveysResultsGet_580104(path: JsonNode; query: JsonNode;
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
  var valid_580106 = path.getOrDefault("surveyUrlId")
  valid_580106 = validateParameter(valid_580106, JString, required = true,
                                 default = nil)
  if valid_580106 != nil:
    section.add "surveyUrlId", valid_580106
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
  var valid_580107 = query.getOrDefault("fields")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "fields", valid_580107
  var valid_580108 = query.getOrDefault("quotaUser")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "quotaUser", valid_580108
  var valid_580109 = query.getOrDefault("alt")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = newJString("json"))
  if valid_580109 != nil:
    section.add "alt", valid_580109
  var valid_580110 = query.getOrDefault("oauth_token")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "oauth_token", valid_580110
  var valid_580111 = query.getOrDefault("userIp")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "userIp", valid_580111
  var valid_580112 = query.getOrDefault("key")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "key", valid_580112
  var valid_580113 = query.getOrDefault("prettyPrint")
  valid_580113 = validateParameter(valid_580113, JBool, required = false,
                                 default = newJBool(true))
  if valid_580113 != nil:
    section.add "prettyPrint", valid_580113
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

proc call*(call_580115: Call_ConsumersurveysResultsGet_580103; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves any survey results that have been produced so far. Results are formatted as an Excel file. You must add "?alt=media" to the URL as an argument to get results.
  ## 
  let valid = call_580115.validator(path, query, header, formData, body)
  let scheme = call_580115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580115.url(scheme.get, call_580115.host, call_580115.base,
                         call_580115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580115, url, valid)

proc call*(call_580116: Call_ConsumersurveysResultsGet_580103; surveyUrlId: string;
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
  var path_580117 = newJObject()
  var query_580118 = newJObject()
  var body_580119 = newJObject()
  add(path_580117, "surveyUrlId", newJString(surveyUrlId))
  add(query_580118, "fields", newJString(fields))
  add(query_580118, "quotaUser", newJString(quotaUser))
  add(query_580118, "alt", newJString(alt))
  add(query_580118, "oauth_token", newJString(oauthToken))
  add(query_580118, "userIp", newJString(userIp))
  add(query_580118, "key", newJString(key))
  if body != nil:
    body_580119 = body
  add(query_580118, "prettyPrint", newJBool(prettyPrint))
  result = call_580116.call(path_580117, query_580118, nil, nil, body_580119)

var consumersurveysResultsGet* = Call_ConsumersurveysResultsGet_580103(
    name: "consumersurveysResultsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/surveys/{surveyUrlId}/results",
    validator: validate_ConsumersurveysResultsGet_580104,
    base: "/consumersurveys/v2", url: url_ConsumersurveysResultsGet_580105,
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
