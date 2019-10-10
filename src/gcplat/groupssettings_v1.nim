
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
  gcpServiceName = "groupssettings"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GroupsSettingsGroupsUpdate_588993 = ref object of OpenApiRestCall_588441
proc url_GroupsSettingsGroupsUpdate_588995(protocol: Scheme; host: string;
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

proc validate_GroupsSettingsGroupsUpdate_588994(path: JsonNode; query: JsonNode;
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
  var valid_588996 = path.getOrDefault("groupUniqueId")
  valid_588996 = validateParameter(valid_588996, JString, required = true,
                                 default = nil)
  if valid_588996 != nil:
    section.add "groupUniqueId", valid_588996
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
                                 default = newJString("atom"))
  if valid_588999 != nil:
    section.add "alt", valid_588999
  var valid_589000 = query.getOrDefault("oauth_token")
  valid_589000 = validateParameter(valid_589000, JString, required = false,
                                 default = nil)
  if valid_589000 != nil:
    section.add "oauth_token", valid_589000
  var valid_589001 = query.getOrDefault("userIp")
  valid_589001 = validateParameter(valid_589001, JString, required = false,
                                 default = nil)
  if valid_589001 != nil:
    section.add "userIp", valid_589001
  var valid_589002 = query.getOrDefault("key")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = nil)
  if valid_589002 != nil:
    section.add "key", valid_589002
  var valid_589003 = query.getOrDefault("prettyPrint")
  valid_589003 = validateParameter(valid_589003, JBool, required = false,
                                 default = newJBool(true))
  if valid_589003 != nil:
    section.add "prettyPrint", valid_589003
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

proc call*(call_589005: Call_GroupsSettingsGroupsUpdate_588993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing resource.
  ## 
  let valid = call_589005.validator(path, query, header, formData, body)
  let scheme = call_589005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589005.url(scheme.get, call_589005.host, call_589005.base,
                         call_589005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589005, url, valid)

proc call*(call_589006: Call_GroupsSettingsGroupsUpdate_588993;
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
  var path_589007 = newJObject()
  var query_589008 = newJObject()
  var body_589009 = newJObject()
  add(query_589008, "fields", newJString(fields))
  add(query_589008, "quotaUser", newJString(quotaUser))
  add(query_589008, "alt", newJString(alt))
  add(query_589008, "oauth_token", newJString(oauthToken))
  add(query_589008, "userIp", newJString(userIp))
  add(query_589008, "key", newJString(key))
  if body != nil:
    body_589009 = body
  add(query_589008, "prettyPrint", newJBool(prettyPrint))
  add(path_589007, "groupUniqueId", newJString(groupUniqueId))
  result = call_589006.call(path_589007, query_589008, nil, nil, body_589009)

var groupsSettingsGroupsUpdate* = Call_GroupsSettingsGroupsUpdate_588993(
    name: "groupsSettingsGroupsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{groupUniqueId}",
    validator: validate_GroupsSettingsGroupsUpdate_588994,
    base: "/groups/v1/groups", url: url_GroupsSettingsGroupsUpdate_588995,
    schemes: {Scheme.Https})
type
  Call_GroupsSettingsGroupsGet_588709 = ref object of OpenApiRestCall_588441
proc url_GroupsSettingsGroupsGet_588711(protocol: Scheme; host: string; base: string;
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

proc validate_GroupsSettingsGroupsGet_588710(path: JsonNode; query: JsonNode;
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
  var valid_588837 = path.getOrDefault("groupUniqueId")
  valid_588837 = validateParameter(valid_588837, JString, required = true,
                                 default = nil)
  if valid_588837 != nil:
    section.add "groupUniqueId", valid_588837
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
  var valid_588838 = query.getOrDefault("fields")
  valid_588838 = validateParameter(valid_588838, JString, required = false,
                                 default = nil)
  if valid_588838 != nil:
    section.add "fields", valid_588838
  var valid_588839 = query.getOrDefault("quotaUser")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = nil)
  if valid_588839 != nil:
    section.add "quotaUser", valid_588839
  var valid_588853 = query.getOrDefault("alt")
  valid_588853 = validateParameter(valid_588853, JString, required = false,
                                 default = newJString("atom"))
  if valid_588853 != nil:
    section.add "alt", valid_588853
  var valid_588854 = query.getOrDefault("oauth_token")
  valid_588854 = validateParameter(valid_588854, JString, required = false,
                                 default = nil)
  if valid_588854 != nil:
    section.add "oauth_token", valid_588854
  var valid_588855 = query.getOrDefault("userIp")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = nil)
  if valid_588855 != nil:
    section.add "userIp", valid_588855
  var valid_588856 = query.getOrDefault("key")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "key", valid_588856
  var valid_588857 = query.getOrDefault("prettyPrint")
  valid_588857 = validateParameter(valid_588857, JBool, required = false,
                                 default = newJBool(true))
  if valid_588857 != nil:
    section.add "prettyPrint", valid_588857
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588880: Call_GroupsSettingsGroupsGet_588709; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one resource by id.
  ## 
  let valid = call_588880.validator(path, query, header, formData, body)
  let scheme = call_588880.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588880.url(scheme.get, call_588880.host, call_588880.base,
                         call_588880.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588880, url, valid)

proc call*(call_588951: Call_GroupsSettingsGroupsGet_588709; groupUniqueId: string;
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
  var path_588952 = newJObject()
  var query_588954 = newJObject()
  add(query_588954, "fields", newJString(fields))
  add(query_588954, "quotaUser", newJString(quotaUser))
  add(query_588954, "alt", newJString(alt))
  add(query_588954, "oauth_token", newJString(oauthToken))
  add(query_588954, "userIp", newJString(userIp))
  add(query_588954, "key", newJString(key))
  add(query_588954, "prettyPrint", newJBool(prettyPrint))
  add(path_588952, "groupUniqueId", newJString(groupUniqueId))
  result = call_588951.call(path_588952, query_588954, nil, nil, nil)

var groupsSettingsGroupsGet* = Call_GroupsSettingsGroupsGet_588709(
    name: "groupsSettingsGroupsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{groupUniqueId}",
    validator: validate_GroupsSettingsGroupsGet_588710, base: "/groups/v1/groups",
    url: url_GroupsSettingsGroupsGet_588711, schemes: {Scheme.Https})
type
  Call_GroupsSettingsGroupsPatch_589010 = ref object of OpenApiRestCall_588441
proc url_GroupsSettingsGroupsPatch_589012(protocol: Scheme; host: string;
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

proc validate_GroupsSettingsGroupsPatch_589011(path: JsonNode; query: JsonNode;
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
  var valid_589013 = path.getOrDefault("groupUniqueId")
  valid_589013 = validateParameter(valid_589013, JString, required = true,
                                 default = nil)
  if valid_589013 != nil:
    section.add "groupUniqueId", valid_589013
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
  var valid_589014 = query.getOrDefault("fields")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "fields", valid_589014
  var valid_589015 = query.getOrDefault("quotaUser")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "quotaUser", valid_589015
  var valid_589016 = query.getOrDefault("alt")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = newJString("atom"))
  if valid_589016 != nil:
    section.add "alt", valid_589016
  var valid_589017 = query.getOrDefault("oauth_token")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "oauth_token", valid_589017
  var valid_589018 = query.getOrDefault("userIp")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "userIp", valid_589018
  var valid_589019 = query.getOrDefault("key")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "key", valid_589019
  var valid_589020 = query.getOrDefault("prettyPrint")
  valid_589020 = validateParameter(valid_589020, JBool, required = false,
                                 default = newJBool(true))
  if valid_589020 != nil:
    section.add "prettyPrint", valid_589020
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

proc call*(call_589022: Call_GroupsSettingsGroupsPatch_589010; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing resource. This method supports patch semantics.
  ## 
  let valid = call_589022.validator(path, query, header, formData, body)
  let scheme = call_589022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589022.url(scheme.get, call_589022.host, call_589022.base,
                         call_589022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589022, url, valid)

proc call*(call_589023: Call_GroupsSettingsGroupsPatch_589010;
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
  var path_589024 = newJObject()
  var query_589025 = newJObject()
  var body_589026 = newJObject()
  add(query_589025, "fields", newJString(fields))
  add(query_589025, "quotaUser", newJString(quotaUser))
  add(query_589025, "alt", newJString(alt))
  add(query_589025, "oauth_token", newJString(oauthToken))
  add(query_589025, "userIp", newJString(userIp))
  add(query_589025, "key", newJString(key))
  if body != nil:
    body_589026 = body
  add(query_589025, "prettyPrint", newJBool(prettyPrint))
  add(path_589024, "groupUniqueId", newJString(groupUniqueId))
  result = call_589023.call(path_589024, query_589025, nil, nil, body_589026)

var groupsSettingsGroupsPatch* = Call_GroupsSettingsGroupsPatch_589010(
    name: "groupsSettingsGroupsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{groupUniqueId}",
    validator: validate_GroupsSettingsGroupsPatch_589011,
    base: "/groups/v1/groups", url: url_GroupsSettingsGroupsPatch_589012,
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
