
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Surveys
## version: v2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
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
  gcpServiceName = "surveys"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SurveysSurveysInsert_579947 = ref object of OpenApiRestCall_579408
proc url_SurveysSurveysInsert_579949(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SurveysSurveysInsert_579948(path: JsonNode; query: JsonNode;
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
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579950 = query.getOrDefault("fields")
  valid_579950 = validateParameter(valid_579950, JString, required = false,
                                 default = nil)
  if valid_579950 != nil:
    section.add "fields", valid_579950
  var valid_579951 = query.getOrDefault("quotaUser")
  valid_579951 = validateParameter(valid_579951, JString, required = false,
                                 default = nil)
  if valid_579951 != nil:
    section.add "quotaUser", valid_579951
  var valid_579952 = query.getOrDefault("alt")
  valid_579952 = validateParameter(valid_579952, JString, required = false,
                                 default = newJString("json"))
  if valid_579952 != nil:
    section.add "alt", valid_579952
  var valid_579953 = query.getOrDefault("oauth_token")
  valid_579953 = validateParameter(valid_579953, JString, required = false,
                                 default = nil)
  if valid_579953 != nil:
    section.add "oauth_token", valid_579953
  var valid_579954 = query.getOrDefault("userIp")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = nil)
  if valid_579954 != nil:
    section.add "userIp", valid_579954
  var valid_579955 = query.getOrDefault("key")
  valid_579955 = validateParameter(valid_579955, JString, required = false,
                                 default = nil)
  if valid_579955 != nil:
    section.add "key", valid_579955
  var valid_579956 = query.getOrDefault("prettyPrint")
  valid_579956 = validateParameter(valid_579956, JBool, required = false,
                                 default = newJBool(true))
  if valid_579956 != nil:
    section.add "prettyPrint", valid_579956
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

proc call*(call_579958: Call_SurveysSurveysInsert_579947; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a survey.
  ## 
  let valid = call_579958.validator(path, query, header, formData, body)
  let scheme = call_579958.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579958.url(scheme.get, call_579958.host, call_579958.base,
                         call_579958.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579958, url, valid)

proc call*(call_579959: Call_SurveysSurveysInsert_579947; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## surveysSurveysInsert
  ## Creates a survey.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579960 = newJObject()
  var body_579961 = newJObject()
  add(query_579960, "fields", newJString(fields))
  add(query_579960, "quotaUser", newJString(quotaUser))
  add(query_579960, "alt", newJString(alt))
  add(query_579960, "oauth_token", newJString(oauthToken))
  add(query_579960, "userIp", newJString(userIp))
  add(query_579960, "key", newJString(key))
  if body != nil:
    body_579961 = body
  add(query_579960, "prettyPrint", newJBool(prettyPrint))
  result = call_579959.call(nil, query_579960, nil, nil, body_579961)

var surveysSurveysInsert* = Call_SurveysSurveysInsert_579947(
    name: "surveysSurveysInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/surveys",
    validator: validate_SurveysSurveysInsert_579948, base: "/surveys/v2",
    url: url_SurveysSurveysInsert_579949, schemes: {Scheme.Https})
type
  Call_SurveysSurveysList_579676 = ref object of OpenApiRestCall_579408
proc url_SurveysSurveysList_579678(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SurveysSurveysList_579677(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
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
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
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

proc call*(call_579835: Call_SurveysSurveysList_579676; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the surveys owned by the authenticated user.
  ## 
  let valid = call_579835.validator(path, query, header, formData, body)
  let scheme = call_579835.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579835.url(scheme.get, call_579835.host, call_579835.base,
                         call_579835.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579835, url, valid)

proc call*(call_579906: Call_SurveysSurveysList_579676; token: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true; startIndex: int = 0): Recallable =
  ## surveysSurveysList
  ## Lists the surveys owned by the authenticated user.
  ##   token: string
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
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

var surveysSurveysList* = Call_SurveysSurveysList_579676(
    name: "surveysSurveysList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/surveys",
    validator: validate_SurveysSurveysList_579677, base: "/surveys/v2",
    url: url_SurveysSurveysList_579678, schemes: {Scheme.Https})
type
  Call_SurveysSurveysStart_579962 = ref object of OpenApiRestCall_579408
proc url_SurveysSurveysStart_579964(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_SurveysSurveysStart_579963(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Begins running a survey.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_579979 = path.getOrDefault("resourceId")
  valid_579979 = validateParameter(valid_579979, JString, required = true,
                                 default = nil)
  if valid_579979 != nil:
    section.add "resourceId", valid_579979
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
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

proc call*(call_579988: Call_SurveysSurveysStart_579962; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Begins running a survey.
  ## 
  let valid = call_579988.validator(path, query, header, formData, body)
  let scheme = call_579988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579988.url(scheme.get, call_579988.host, call_579988.base,
                         call_579988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579988, url, valid)

proc call*(call_579989: Call_SurveysSurveysStart_579962; resourceId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## surveysSurveysStart
  ## Begins running a survey.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   resourceId: string (required)
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
  add(path_579990, "resourceId", newJString(resourceId))
  if body != nil:
    body_579992 = body
  add(query_579991, "prettyPrint", newJBool(prettyPrint))
  result = call_579989.call(path_579990, query_579991, nil, nil, body_579992)

var surveysSurveysStart* = Call_SurveysSurveysStart_579962(
    name: "surveysSurveysStart", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/surveys/{resourceId}/start",
    validator: validate_SurveysSurveysStart_579963, base: "/surveys/v2",
    url: url_SurveysSurveysStart_579964, schemes: {Scheme.Https})
type
  Call_SurveysSurveysStop_579993 = ref object of OpenApiRestCall_579408
proc url_SurveysSurveysStop_579995(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_SurveysSurveysStop_579994(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Stops a running survey.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_579996 = path.getOrDefault("resourceId")
  valid_579996 = validateParameter(valid_579996, JString, required = true,
                                 default = nil)
  if valid_579996 != nil:
    section.add "resourceId", valid_579996
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
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
  var valid_580002 = query.getOrDefault("key")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "key", valid_580002
  var valid_580003 = query.getOrDefault("prettyPrint")
  valid_580003 = validateParameter(valid_580003, JBool, required = false,
                                 default = newJBool(true))
  if valid_580003 != nil:
    section.add "prettyPrint", valid_580003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580004: Call_SurveysSurveysStop_579993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops a running survey.
  ## 
  let valid = call_580004.validator(path, query, header, formData, body)
  let scheme = call_580004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580004.url(scheme.get, call_580004.host, call_580004.base,
                         call_580004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580004, url, valid)

proc call*(call_580005: Call_SurveysSurveysStop_579993; resourceId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## surveysSurveysStop
  ## Stops a running survey.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   resourceId: string (required)
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580006 = newJObject()
  var query_580007 = newJObject()
  add(query_580007, "fields", newJString(fields))
  add(query_580007, "quotaUser", newJString(quotaUser))
  add(query_580007, "alt", newJString(alt))
  add(query_580007, "oauth_token", newJString(oauthToken))
  add(query_580007, "userIp", newJString(userIp))
  add(query_580007, "key", newJString(key))
  add(path_580006, "resourceId", newJString(resourceId))
  add(query_580007, "prettyPrint", newJBool(prettyPrint))
  result = call_580005.call(path_580006, query_580007, nil, nil, nil)

var surveysSurveysStop* = Call_SurveysSurveysStop_579993(
    name: "surveysSurveysStop", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/surveys/{resourceId}/stop",
    validator: validate_SurveysSurveysStop_579994, base: "/surveys/v2",
    url: url_SurveysSurveysStop_579995, schemes: {Scheme.Https})
type
  Call_SurveysSurveysUpdate_580023 = ref object of OpenApiRestCall_579408
proc url_SurveysSurveysUpdate_580025(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_SurveysSurveysUpdate_580024(path: JsonNode; query: JsonNode;
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
  var valid_580026 = path.getOrDefault("surveyUrlId")
  valid_580026 = validateParameter(valid_580026, JString, required = true,
                                 default = nil)
  if valid_580026 != nil:
    section.add "surveyUrlId", valid_580026
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580027 = query.getOrDefault("fields")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "fields", valid_580027
  var valid_580028 = query.getOrDefault("quotaUser")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "quotaUser", valid_580028
  var valid_580029 = query.getOrDefault("alt")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = newJString("json"))
  if valid_580029 != nil:
    section.add "alt", valid_580029
  var valid_580030 = query.getOrDefault("oauth_token")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "oauth_token", valid_580030
  var valid_580031 = query.getOrDefault("userIp")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "userIp", valid_580031
  var valid_580032 = query.getOrDefault("key")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "key", valid_580032
  var valid_580033 = query.getOrDefault("prettyPrint")
  valid_580033 = validateParameter(valid_580033, JBool, required = false,
                                 default = newJBool(true))
  if valid_580033 != nil:
    section.add "prettyPrint", valid_580033
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

proc call*(call_580035: Call_SurveysSurveysUpdate_580023; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a survey. Currently the only property that can be updated is the owners property.
  ## 
  let valid = call_580035.validator(path, query, header, formData, body)
  let scheme = call_580035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580035.url(scheme.get, call_580035.host, call_580035.base,
                         call_580035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580035, url, valid)

proc call*(call_580036: Call_SurveysSurveysUpdate_580023; surveyUrlId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## surveysSurveysUpdate
  ## Updates a survey. Currently the only property that can be updated is the owners property.
  ##   surveyUrlId: string (required)
  ##              : External URL ID for the survey.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580037 = newJObject()
  var query_580038 = newJObject()
  var body_580039 = newJObject()
  add(path_580037, "surveyUrlId", newJString(surveyUrlId))
  add(query_580038, "fields", newJString(fields))
  add(query_580038, "quotaUser", newJString(quotaUser))
  add(query_580038, "alt", newJString(alt))
  add(query_580038, "oauth_token", newJString(oauthToken))
  add(query_580038, "userIp", newJString(userIp))
  add(query_580038, "key", newJString(key))
  if body != nil:
    body_580039 = body
  add(query_580038, "prettyPrint", newJBool(prettyPrint))
  result = call_580036.call(path_580037, query_580038, nil, nil, body_580039)

var surveysSurveysUpdate* = Call_SurveysSurveysUpdate_580023(
    name: "surveysSurveysUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/surveys/{surveyUrlId}",
    validator: validate_SurveysSurveysUpdate_580024, base: "/surveys/v2",
    url: url_SurveysSurveysUpdate_580025, schemes: {Scheme.Https})
type
  Call_SurveysSurveysGet_580008 = ref object of OpenApiRestCall_579408
proc url_SurveysSurveysGet_580010(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_SurveysSurveysGet_580009(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
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
  var valid_580011 = path.getOrDefault("surveyUrlId")
  valid_580011 = validateParameter(valid_580011, JString, required = true,
                                 default = nil)
  if valid_580011 != nil:
    section.add "surveyUrlId", valid_580011
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
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
  if body != nil:
    result.add "body", body

proc call*(call_580019: Call_SurveysSurveysGet_580008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about the specified survey.
  ## 
  let valid = call_580019.validator(path, query, header, formData, body)
  let scheme = call_580019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580019.url(scheme.get, call_580019.host, call_580019.base,
                         call_580019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580019, url, valid)

proc call*(call_580020: Call_SurveysSurveysGet_580008; surveyUrlId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## surveysSurveysGet
  ## Retrieves information about the specified survey.
  ##   surveyUrlId: string (required)
  ##              : External URL ID for the survey.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580021 = newJObject()
  var query_580022 = newJObject()
  add(path_580021, "surveyUrlId", newJString(surveyUrlId))
  add(query_580022, "fields", newJString(fields))
  add(query_580022, "quotaUser", newJString(quotaUser))
  add(query_580022, "alt", newJString(alt))
  add(query_580022, "oauth_token", newJString(oauthToken))
  add(query_580022, "userIp", newJString(userIp))
  add(query_580022, "key", newJString(key))
  add(query_580022, "prettyPrint", newJBool(prettyPrint))
  result = call_580020.call(path_580021, query_580022, nil, nil, nil)

var surveysSurveysGet* = Call_SurveysSurveysGet_580008(name: "surveysSurveysGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/surveys/{surveyUrlId}", validator: validate_SurveysSurveysGet_580009,
    base: "/surveys/v2", url: url_SurveysSurveysGet_580010, schemes: {Scheme.Https})
type
  Call_SurveysSurveysDelete_580040 = ref object of OpenApiRestCall_579408
proc url_SurveysSurveysDelete_580042(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_SurveysSurveysDelete_580041(path: JsonNode; query: JsonNode;
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
  var valid_580043 = path.getOrDefault("surveyUrlId")
  valid_580043 = validateParameter(valid_580043, JString, required = true,
                                 default = nil)
  if valid_580043 != nil:
    section.add "surveyUrlId", valid_580043
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
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
  var valid_580048 = query.getOrDefault("userIp")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "userIp", valid_580048
  var valid_580049 = query.getOrDefault("key")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "key", valid_580049
  var valid_580050 = query.getOrDefault("prettyPrint")
  valid_580050 = validateParameter(valid_580050, JBool, required = false,
                                 default = newJBool(true))
  if valid_580050 != nil:
    section.add "prettyPrint", valid_580050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580051: Call_SurveysSurveysDelete_580040; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a survey from view in all user GET requests.
  ## 
  let valid = call_580051.validator(path, query, header, formData, body)
  let scheme = call_580051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580051.url(scheme.get, call_580051.host, call_580051.base,
                         call_580051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580051, url, valid)

proc call*(call_580052: Call_SurveysSurveysDelete_580040; surveyUrlId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## surveysSurveysDelete
  ## Removes a survey from view in all user GET requests.
  ##   surveyUrlId: string (required)
  ##              : External URL ID for the survey.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580053 = newJObject()
  var query_580054 = newJObject()
  add(path_580053, "surveyUrlId", newJString(surveyUrlId))
  add(query_580054, "fields", newJString(fields))
  add(query_580054, "quotaUser", newJString(quotaUser))
  add(query_580054, "alt", newJString(alt))
  add(query_580054, "oauth_token", newJString(oauthToken))
  add(query_580054, "userIp", newJString(userIp))
  add(query_580054, "key", newJString(key))
  add(query_580054, "prettyPrint", newJBool(prettyPrint))
  result = call_580052.call(path_580053, query_580054, nil, nil, nil)

var surveysSurveysDelete* = Call_SurveysSurveysDelete_580040(
    name: "surveysSurveysDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/surveys/{surveyUrlId}",
    validator: validate_SurveysSurveysDelete_580041, base: "/surveys/v2",
    url: url_SurveysSurveysDelete_580042, schemes: {Scheme.Https})
type
  Call_SurveysResultsGet_580055 = ref object of OpenApiRestCall_579408
proc url_SurveysResultsGet_580057(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_SurveysResultsGet_580056(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
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
  var valid_580058 = path.getOrDefault("surveyUrlId")
  valid_580058 = validateParameter(valid_580058, JString, required = true,
                                 default = nil)
  if valid_580058 != nil:
    section.add "surveyUrlId", valid_580058
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
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
  var valid_580063 = query.getOrDefault("userIp")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "userIp", valid_580063
  var valid_580064 = query.getOrDefault("key")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "key", valid_580064
  var valid_580065 = query.getOrDefault("prettyPrint")
  valid_580065 = validateParameter(valid_580065, JBool, required = false,
                                 default = newJBool(true))
  if valid_580065 != nil:
    section.add "prettyPrint", valid_580065
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

proc call*(call_580067: Call_SurveysResultsGet_580055; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves any survey results that have been produced so far. Results are formatted as an Excel file. You must add "?alt=media" to the URL as an argument to get results.
  ## 
  let valid = call_580067.validator(path, query, header, formData, body)
  let scheme = call_580067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580067.url(scheme.get, call_580067.host, call_580067.base,
                         call_580067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580067, url, valid)

proc call*(call_580068: Call_SurveysResultsGet_580055; surveyUrlId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## surveysResultsGet
  ## Retrieves any survey results that have been produced so far. Results are formatted as an Excel file. You must add "?alt=media" to the URL as an argument to get results.
  ##   surveyUrlId: string (required)
  ##              : External URL ID for the survey.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580069 = newJObject()
  var query_580070 = newJObject()
  var body_580071 = newJObject()
  add(path_580069, "surveyUrlId", newJString(surveyUrlId))
  add(query_580070, "fields", newJString(fields))
  add(query_580070, "quotaUser", newJString(quotaUser))
  add(query_580070, "alt", newJString(alt))
  add(query_580070, "oauth_token", newJString(oauthToken))
  add(query_580070, "userIp", newJString(userIp))
  add(query_580070, "key", newJString(key))
  if body != nil:
    body_580071 = body
  add(query_580070, "prettyPrint", newJBool(prettyPrint))
  result = call_580068.call(path_580069, query_580070, nil, nil, body_580071)

var surveysResultsGet* = Call_SurveysResultsGet_580055(name: "surveysResultsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/surveys/{surveyUrlId}/results",
    validator: validate_SurveysResultsGet_580056, base: "/surveys/v2",
    url: url_SurveysResultsGet_580057, schemes: {Scheme.Https})
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
