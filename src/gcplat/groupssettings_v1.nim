
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Groups Settings
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Manages permission levels and related settings of a group.
## 
## https://developers.google.com/google-apps/groups-settings/get_started
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
  gcpServiceName = "groupssettings"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GroupsSettingsGroupsUpdate_579960 = ref object of OpenApiRestCall_579408
proc url_GroupsSettingsGroupsUpdate_579962(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupUniqueId" in path, "`groupUniqueId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "groupUniqueId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupsSettingsGroupsUpdate_579961(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupUniqueId: JString (required)
  ##                : The group's email address.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `groupUniqueId` field"
  var valid_579963 = path.getOrDefault("groupUniqueId")
  valid_579963 = validateParameter(valid_579963, JString, required = true,
                                 default = nil)
  if valid_579963 != nil:
    section.add "groupUniqueId", valid_579963
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
  var valid_579964 = query.getOrDefault("fields")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "fields", valid_579964
  var valid_579965 = query.getOrDefault("quotaUser")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "quotaUser", valid_579965
  var valid_579966 = query.getOrDefault("alt")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = newJString("atom"))
  if valid_579966 != nil:
    section.add "alt", valid_579966
  var valid_579967 = query.getOrDefault("oauth_token")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "oauth_token", valid_579967
  var valid_579968 = query.getOrDefault("userIp")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "userIp", valid_579968
  var valid_579969 = query.getOrDefault("key")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "key", valid_579969
  var valid_579970 = query.getOrDefault("prettyPrint")
  valid_579970 = validateParameter(valid_579970, JBool, required = false,
                                 default = newJBool(true))
  if valid_579970 != nil:
    section.add "prettyPrint", valid_579970
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

proc call*(call_579972: Call_GroupsSettingsGroupsUpdate_579960; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing resource.
  ## 
  let valid = call_579972.validator(path, query, header, formData, body)
  let scheme = call_579972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579972.url(scheme.get, call_579972.host, call_579972.base,
                         call_579972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579972, url, valid)

proc call*(call_579973: Call_GroupsSettingsGroupsUpdate_579960;
          groupUniqueId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "atom"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## groupsSettingsGroupsUpdate
  ## Updates an existing resource.
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
  ##   groupUniqueId: string (required)
  ##                : The group's email address.
  var path_579974 = newJObject()
  var query_579975 = newJObject()
  var body_579976 = newJObject()
  add(query_579975, "fields", newJString(fields))
  add(query_579975, "quotaUser", newJString(quotaUser))
  add(query_579975, "alt", newJString(alt))
  add(query_579975, "oauth_token", newJString(oauthToken))
  add(query_579975, "userIp", newJString(userIp))
  add(query_579975, "key", newJString(key))
  if body != nil:
    body_579976 = body
  add(query_579975, "prettyPrint", newJBool(prettyPrint))
  add(path_579974, "groupUniqueId", newJString(groupUniqueId))
  result = call_579973.call(path_579974, query_579975, nil, nil, body_579976)

var groupsSettingsGroupsUpdate* = Call_GroupsSettingsGroupsUpdate_579960(
    name: "groupsSettingsGroupsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{groupUniqueId}",
    validator: validate_GroupsSettingsGroupsUpdate_579961,
    base: "/groups/v1/groups", url: url_GroupsSettingsGroupsUpdate_579962,
    schemes: {Scheme.Https})
type
  Call_GroupsSettingsGroupsGet_579676 = ref object of OpenApiRestCall_579408
proc url_GroupsSettingsGroupsGet_579678(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupUniqueId" in path, "`groupUniqueId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "groupUniqueId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupsSettingsGroupsGet_579677(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets one resource by id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupUniqueId: JString (required)
  ##                : The group's email address.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `groupUniqueId` field"
  var valid_579804 = path.getOrDefault("groupUniqueId")
  valid_579804 = validateParameter(valid_579804, JString, required = true,
                                 default = nil)
  if valid_579804 != nil:
    section.add "groupUniqueId", valid_579804
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
                                 default = newJString("atom"))
  if valid_579820 != nil:
    section.add "alt", valid_579820
  var valid_579821 = query.getOrDefault("oauth_token")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "oauth_token", valid_579821
  var valid_579822 = query.getOrDefault("userIp")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "userIp", valid_579822
  var valid_579823 = query.getOrDefault("key")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "key", valid_579823
  var valid_579824 = query.getOrDefault("prettyPrint")
  valid_579824 = validateParameter(valid_579824, JBool, required = false,
                                 default = newJBool(true))
  if valid_579824 != nil:
    section.add "prettyPrint", valid_579824
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579847: Call_GroupsSettingsGroupsGet_579676; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one resource by id.
  ## 
  let valid = call_579847.validator(path, query, header, formData, body)
  let scheme = call_579847.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579847.url(scheme.get, call_579847.host, call_579847.base,
                         call_579847.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579847, url, valid)

proc call*(call_579918: Call_GroupsSettingsGroupsGet_579676; groupUniqueId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "atom";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## groupsSettingsGroupsGet
  ## Gets one resource by id.
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
  ##   groupUniqueId: string (required)
  ##                : The group's email address.
  var path_579919 = newJObject()
  var query_579921 = newJObject()
  add(query_579921, "fields", newJString(fields))
  add(query_579921, "quotaUser", newJString(quotaUser))
  add(query_579921, "alt", newJString(alt))
  add(query_579921, "oauth_token", newJString(oauthToken))
  add(query_579921, "userIp", newJString(userIp))
  add(query_579921, "key", newJString(key))
  add(query_579921, "prettyPrint", newJBool(prettyPrint))
  add(path_579919, "groupUniqueId", newJString(groupUniqueId))
  result = call_579918.call(path_579919, query_579921, nil, nil, nil)

var groupsSettingsGroupsGet* = Call_GroupsSettingsGroupsGet_579676(
    name: "groupsSettingsGroupsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{groupUniqueId}",
    validator: validate_GroupsSettingsGroupsGet_579677, base: "/groups/v1/groups",
    url: url_GroupsSettingsGroupsGet_579678, schemes: {Scheme.Https})
type
  Call_GroupsSettingsGroupsPatch_579977 = ref object of OpenApiRestCall_579408
proc url_GroupsSettingsGroupsPatch_579979(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupUniqueId" in path, "`groupUniqueId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "groupUniqueId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupsSettingsGroupsPatch_579978(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing resource. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupUniqueId: JString (required)
  ##                : The group's email address.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `groupUniqueId` field"
  var valid_579980 = path.getOrDefault("groupUniqueId")
  valid_579980 = validateParameter(valid_579980, JString, required = true,
                                 default = nil)
  if valid_579980 != nil:
    section.add "groupUniqueId", valid_579980
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
  var valid_579981 = query.getOrDefault("fields")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "fields", valid_579981
  var valid_579982 = query.getOrDefault("quotaUser")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "quotaUser", valid_579982
  var valid_579983 = query.getOrDefault("alt")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = newJString("atom"))
  if valid_579983 != nil:
    section.add "alt", valid_579983
  var valid_579984 = query.getOrDefault("oauth_token")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "oauth_token", valid_579984
  var valid_579985 = query.getOrDefault("userIp")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "userIp", valid_579985
  var valid_579986 = query.getOrDefault("key")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "key", valid_579986
  var valid_579987 = query.getOrDefault("prettyPrint")
  valid_579987 = validateParameter(valid_579987, JBool, required = false,
                                 default = newJBool(true))
  if valid_579987 != nil:
    section.add "prettyPrint", valid_579987
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

proc call*(call_579989: Call_GroupsSettingsGroupsPatch_579977; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing resource. This method supports patch semantics.
  ## 
  let valid = call_579989.validator(path, query, header, formData, body)
  let scheme = call_579989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579989.url(scheme.get, call_579989.host, call_579989.base,
                         call_579989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579989, url, valid)

proc call*(call_579990: Call_GroupsSettingsGroupsPatch_579977;
          groupUniqueId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "atom"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## groupsSettingsGroupsPatch
  ## Updates an existing resource. This method supports patch semantics.
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
  ##   groupUniqueId: string (required)
  ##                : The group's email address.
  var path_579991 = newJObject()
  var query_579992 = newJObject()
  var body_579993 = newJObject()
  add(query_579992, "fields", newJString(fields))
  add(query_579992, "quotaUser", newJString(quotaUser))
  add(query_579992, "alt", newJString(alt))
  add(query_579992, "oauth_token", newJString(oauthToken))
  add(query_579992, "userIp", newJString(userIp))
  add(query_579992, "key", newJString(key))
  if body != nil:
    body_579993 = body
  add(query_579992, "prettyPrint", newJBool(prettyPrint))
  add(path_579991, "groupUniqueId", newJString(groupUniqueId))
  result = call_579990.call(path_579991, query_579992, nil, nil, body_579993)

var groupsSettingsGroupsPatch* = Call_GroupsSettingsGroupsPatch_579977(
    name: "groupsSettingsGroupsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{groupUniqueId}",
    validator: validate_GroupsSettingsGroupsPatch_579978,
    base: "/groups/v1/groups", url: url_GroupsSettingsGroupsPatch_579979,
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
