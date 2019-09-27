
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GroupsSettingsGroupsUpdate_593960 = ref object of OpenApiRestCall_593408
proc url_GroupsSettingsGroupsUpdate_593962(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupUniqueId" in path, "`groupUniqueId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "groupUniqueId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupsSettingsGroupsUpdate_593961(path: JsonNode; query: JsonNode;
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
  var valid_593963 = path.getOrDefault("groupUniqueId")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "groupUniqueId", valid_593963
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
  var valid_593964 = query.getOrDefault("fields")
  valid_593964 = validateParameter(valid_593964, JString, required = false,
                                 default = nil)
  if valid_593964 != nil:
    section.add "fields", valid_593964
  var valid_593965 = query.getOrDefault("quotaUser")
  valid_593965 = validateParameter(valid_593965, JString, required = false,
                                 default = nil)
  if valid_593965 != nil:
    section.add "quotaUser", valid_593965
  var valid_593966 = query.getOrDefault("alt")
  valid_593966 = validateParameter(valid_593966, JString, required = false,
                                 default = newJString("atom"))
  if valid_593966 != nil:
    section.add "alt", valid_593966
  var valid_593967 = query.getOrDefault("oauth_token")
  valid_593967 = validateParameter(valid_593967, JString, required = false,
                                 default = nil)
  if valid_593967 != nil:
    section.add "oauth_token", valid_593967
  var valid_593968 = query.getOrDefault("userIp")
  valid_593968 = validateParameter(valid_593968, JString, required = false,
                                 default = nil)
  if valid_593968 != nil:
    section.add "userIp", valid_593968
  var valid_593969 = query.getOrDefault("key")
  valid_593969 = validateParameter(valid_593969, JString, required = false,
                                 default = nil)
  if valid_593969 != nil:
    section.add "key", valid_593969
  var valid_593970 = query.getOrDefault("prettyPrint")
  valid_593970 = validateParameter(valid_593970, JBool, required = false,
                                 default = newJBool(true))
  if valid_593970 != nil:
    section.add "prettyPrint", valid_593970
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

proc call*(call_593972: Call_GroupsSettingsGroupsUpdate_593960; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing resource.
  ## 
  let valid = call_593972.validator(path, query, header, formData, body)
  let scheme = call_593972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593972.url(scheme.get, call_593972.host, call_593972.base,
                         call_593972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593972, url, valid)

proc call*(call_593973: Call_GroupsSettingsGroupsUpdate_593960;
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
  var path_593974 = newJObject()
  var query_593975 = newJObject()
  var body_593976 = newJObject()
  add(query_593975, "fields", newJString(fields))
  add(query_593975, "quotaUser", newJString(quotaUser))
  add(query_593975, "alt", newJString(alt))
  add(query_593975, "oauth_token", newJString(oauthToken))
  add(query_593975, "userIp", newJString(userIp))
  add(query_593975, "key", newJString(key))
  if body != nil:
    body_593976 = body
  add(query_593975, "prettyPrint", newJBool(prettyPrint))
  add(path_593974, "groupUniqueId", newJString(groupUniqueId))
  result = call_593973.call(path_593974, query_593975, nil, nil, body_593976)

var groupsSettingsGroupsUpdate* = Call_GroupsSettingsGroupsUpdate_593960(
    name: "groupsSettingsGroupsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{groupUniqueId}",
    validator: validate_GroupsSettingsGroupsUpdate_593961,
    base: "/groups/v1/groups", url: url_GroupsSettingsGroupsUpdate_593962,
    schemes: {Scheme.Https})
type
  Call_GroupsSettingsGroupsGet_593676 = ref object of OpenApiRestCall_593408
proc url_GroupsSettingsGroupsGet_593678(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupUniqueId" in path, "`groupUniqueId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "groupUniqueId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupsSettingsGroupsGet_593677(path: JsonNode; query: JsonNode;
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
  var valid_593804 = path.getOrDefault("groupUniqueId")
  valid_593804 = validateParameter(valid_593804, JString, required = true,
                                 default = nil)
  if valid_593804 != nil:
    section.add "groupUniqueId", valid_593804
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
                                 default = newJString("atom"))
  if valid_593820 != nil:
    section.add "alt", valid_593820
  var valid_593821 = query.getOrDefault("oauth_token")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = nil)
  if valid_593821 != nil:
    section.add "oauth_token", valid_593821
  var valid_593822 = query.getOrDefault("userIp")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = nil)
  if valid_593822 != nil:
    section.add "userIp", valid_593822
  var valid_593823 = query.getOrDefault("key")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "key", valid_593823
  var valid_593824 = query.getOrDefault("prettyPrint")
  valid_593824 = validateParameter(valid_593824, JBool, required = false,
                                 default = newJBool(true))
  if valid_593824 != nil:
    section.add "prettyPrint", valid_593824
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593847: Call_GroupsSettingsGroupsGet_593676; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one resource by id.
  ## 
  let valid = call_593847.validator(path, query, header, formData, body)
  let scheme = call_593847.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593847.url(scheme.get, call_593847.host, call_593847.base,
                         call_593847.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593847, url, valid)

proc call*(call_593918: Call_GroupsSettingsGroupsGet_593676; groupUniqueId: string;
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
  var path_593919 = newJObject()
  var query_593921 = newJObject()
  add(query_593921, "fields", newJString(fields))
  add(query_593921, "quotaUser", newJString(quotaUser))
  add(query_593921, "alt", newJString(alt))
  add(query_593921, "oauth_token", newJString(oauthToken))
  add(query_593921, "userIp", newJString(userIp))
  add(query_593921, "key", newJString(key))
  add(query_593921, "prettyPrint", newJBool(prettyPrint))
  add(path_593919, "groupUniqueId", newJString(groupUniqueId))
  result = call_593918.call(path_593919, query_593921, nil, nil, nil)

var groupsSettingsGroupsGet* = Call_GroupsSettingsGroupsGet_593676(
    name: "groupsSettingsGroupsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{groupUniqueId}",
    validator: validate_GroupsSettingsGroupsGet_593677, base: "/groups/v1/groups",
    url: url_GroupsSettingsGroupsGet_593678, schemes: {Scheme.Https})
type
  Call_GroupsSettingsGroupsPatch_593977 = ref object of OpenApiRestCall_593408
proc url_GroupsSettingsGroupsPatch_593979(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupUniqueId" in path, "`groupUniqueId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "groupUniqueId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupsSettingsGroupsPatch_593978(path: JsonNode; query: JsonNode;
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
  var valid_593980 = path.getOrDefault("groupUniqueId")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "groupUniqueId", valid_593980
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
  var valid_593981 = query.getOrDefault("fields")
  valid_593981 = validateParameter(valid_593981, JString, required = false,
                                 default = nil)
  if valid_593981 != nil:
    section.add "fields", valid_593981
  var valid_593982 = query.getOrDefault("quotaUser")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "quotaUser", valid_593982
  var valid_593983 = query.getOrDefault("alt")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = newJString("atom"))
  if valid_593983 != nil:
    section.add "alt", valid_593983
  var valid_593984 = query.getOrDefault("oauth_token")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = nil)
  if valid_593984 != nil:
    section.add "oauth_token", valid_593984
  var valid_593985 = query.getOrDefault("userIp")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = nil)
  if valid_593985 != nil:
    section.add "userIp", valid_593985
  var valid_593986 = query.getOrDefault("key")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = nil)
  if valid_593986 != nil:
    section.add "key", valid_593986
  var valid_593987 = query.getOrDefault("prettyPrint")
  valid_593987 = validateParameter(valid_593987, JBool, required = false,
                                 default = newJBool(true))
  if valid_593987 != nil:
    section.add "prettyPrint", valid_593987
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

proc call*(call_593989: Call_GroupsSettingsGroupsPatch_593977; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing resource. This method supports patch semantics.
  ## 
  let valid = call_593989.validator(path, query, header, formData, body)
  let scheme = call_593989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593989.url(scheme.get, call_593989.host, call_593989.base,
                         call_593989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593989, url, valid)

proc call*(call_593990: Call_GroupsSettingsGroupsPatch_593977;
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
  var path_593991 = newJObject()
  var query_593992 = newJObject()
  var body_593993 = newJObject()
  add(query_593992, "fields", newJString(fields))
  add(query_593992, "quotaUser", newJString(quotaUser))
  add(query_593992, "alt", newJString(alt))
  add(query_593992, "oauth_token", newJString(oauthToken))
  add(query_593992, "userIp", newJString(userIp))
  add(query_593992, "key", newJString(key))
  if body != nil:
    body_593993 = body
  add(query_593992, "prettyPrint", newJBool(prettyPrint))
  add(path_593991, "groupUniqueId", newJString(groupUniqueId))
  result = call_593990.call(path_593991, query_593992, nil, nil, body_593993)

var groupsSettingsGroupsPatch* = Call_GroupsSettingsGroupsPatch_593977(
    name: "groupsSettingsGroupsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{groupUniqueId}",
    validator: validate_GroupsSettingsGroupsPatch_593978,
    base: "/groups/v1/groups", url: url_GroupsSettingsGroupsPatch_593979,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
