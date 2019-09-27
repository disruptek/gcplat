
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Google Compute Engine Instance Group Manager
## version: v1beta2
## termsOfService: (not provided)
## license: (not provided)
## 
## [Deprecated. Please use Instance Group Manager in Compute API] Provides groups of homogenous Compute Engine instances.
## 
## https://developers.google.com/compute/docs/instance-groups/manager/v1beta2
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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
  gcpServiceName = "replicapool"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ReplicapoolInstanceGroupManagersInsert_593981 = ref object of OpenApiRestCall_593424
proc url_ReplicapoolInstanceGroupManagersInsert_593983(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/instanceGroupManagers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicapoolInstanceGroupManagersInsert_593982(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an instance group manager, as well as the instance group and the specified number of instances.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_593984 = path.getOrDefault("zone")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "zone", valid_593984
  var valid_593985 = path.getOrDefault("project")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "project", valid_593985
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
  ##   size: JInt (required)
  ##       : Number of instances that should exist.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593986 = query.getOrDefault("fields")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = nil)
  if valid_593986 != nil:
    section.add "fields", valid_593986
  var valid_593987 = query.getOrDefault("quotaUser")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "quotaUser", valid_593987
  var valid_593988 = query.getOrDefault("alt")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = newJString("json"))
  if valid_593988 != nil:
    section.add "alt", valid_593988
  var valid_593989 = query.getOrDefault("oauth_token")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "oauth_token", valid_593989
  var valid_593990 = query.getOrDefault("userIp")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "userIp", valid_593990
  var valid_593991 = query.getOrDefault("key")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = nil)
  if valid_593991 != nil:
    section.add "key", valid_593991
  assert query != nil, "query argument is necessary due to required `size` field"
  var valid_593992 = query.getOrDefault("size")
  valid_593992 = validateParameter(valid_593992, JInt, required = true, default = nil)
  if valid_593992 != nil:
    section.add "size", valid_593992
  var valid_593993 = query.getOrDefault("prettyPrint")
  valid_593993 = validateParameter(valid_593993, JBool, required = false,
                                 default = newJBool(true))
  if valid_593993 != nil:
    section.add "prettyPrint", valid_593993
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

proc call*(call_593995: Call_ReplicapoolInstanceGroupManagersInsert_593981;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an instance group manager, as well as the instance group and the specified number of instances.
  ## 
  let valid = call_593995.validator(path, query, header, formData, body)
  let scheme = call_593995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593995.url(scheme.get, call_593995.host, call_593995.base,
                         call_593995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593995, url, valid)

proc call*(call_593996: Call_ReplicapoolInstanceGroupManagersInsert_593981;
          zone: string; size: int; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## replicapoolInstanceGroupManagersInsert
  ## Creates an instance group manager, as well as the instance group and the specified number of instances.
  ##   zone: string (required)
  ##       : The name of the zone in which the instance group manager resides.
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
  ##   size: int (required)
  ##       : Number of instances that should exist.
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_593997 = newJObject()
  var query_593998 = newJObject()
  var body_593999 = newJObject()
  add(path_593997, "zone", newJString(zone))
  add(query_593998, "fields", newJString(fields))
  add(query_593998, "quotaUser", newJString(quotaUser))
  add(query_593998, "alt", newJString(alt))
  add(query_593998, "oauth_token", newJString(oauthToken))
  add(query_593998, "userIp", newJString(userIp))
  add(query_593998, "key", newJString(key))
  add(query_593998, "size", newJInt(size))
  add(path_593997, "project", newJString(project))
  if body != nil:
    body_593999 = body
  add(query_593998, "prettyPrint", newJBool(prettyPrint))
  result = call_593996.call(path_593997, query_593998, nil, nil, body_593999)

var replicapoolInstanceGroupManagersInsert* = Call_ReplicapoolInstanceGroupManagersInsert_593981(
    name: "replicapoolInstanceGroupManagersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/instanceGroupManagers",
    validator: validate_ReplicapoolInstanceGroupManagersInsert_593982,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersInsert_593983,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersList_593692 = ref object of OpenApiRestCall_593424
proc url_ReplicapoolInstanceGroupManagersList_593694(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/instanceGroupManagers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicapoolInstanceGroupManagersList_593693(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of Instance Group Manager resources contained within the specified zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_593820 = path.getOrDefault("zone")
  valid_593820 = validateParameter(valid_593820, JString, required = true,
                                 default = nil)
  if valid_593820 != nil:
    section.add "zone", valid_593820
  var valid_593821 = path.getOrDefault("project")
  valid_593821 = validateParameter(valid_593821, JString, required = true,
                                 default = nil)
  if valid_593821 != nil:
    section.add "project", valid_593821
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional. Tag returned by a previous list request truncated by maxResults. Used to continue a previous list request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Optional. Maximum count of results to be returned. Maximum value is 500 and default value is 500.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Optional. Filter expression for filtering listed resources.
  section = newJObject()
  var valid_593822 = query.getOrDefault("fields")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = nil)
  if valid_593822 != nil:
    section.add "fields", valid_593822
  var valid_593823 = query.getOrDefault("pageToken")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "pageToken", valid_593823
  var valid_593824 = query.getOrDefault("quotaUser")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "quotaUser", valid_593824
  var valid_593838 = query.getOrDefault("alt")
  valid_593838 = validateParameter(valid_593838, JString, required = false,
                                 default = newJString("json"))
  if valid_593838 != nil:
    section.add "alt", valid_593838
  var valid_593839 = query.getOrDefault("oauth_token")
  valid_593839 = validateParameter(valid_593839, JString, required = false,
                                 default = nil)
  if valid_593839 != nil:
    section.add "oauth_token", valid_593839
  var valid_593840 = query.getOrDefault("userIp")
  valid_593840 = validateParameter(valid_593840, JString, required = false,
                                 default = nil)
  if valid_593840 != nil:
    section.add "userIp", valid_593840
  var valid_593842 = query.getOrDefault("maxResults")
  valid_593842 = validateParameter(valid_593842, JInt, required = false,
                                 default = newJInt(500))
  if valid_593842 != nil:
    section.add "maxResults", valid_593842
  var valid_593843 = query.getOrDefault("key")
  valid_593843 = validateParameter(valid_593843, JString, required = false,
                                 default = nil)
  if valid_593843 != nil:
    section.add "key", valid_593843
  var valid_593844 = query.getOrDefault("prettyPrint")
  valid_593844 = validateParameter(valid_593844, JBool, required = false,
                                 default = newJBool(true))
  if valid_593844 != nil:
    section.add "prettyPrint", valid_593844
  var valid_593845 = query.getOrDefault("filter")
  valid_593845 = validateParameter(valid_593845, JString, required = false,
                                 default = nil)
  if valid_593845 != nil:
    section.add "filter", valid_593845
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593868: Call_ReplicapoolInstanceGroupManagersList_593692;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of Instance Group Manager resources contained within the specified zone.
  ## 
  let valid = call_593868.validator(path, query, header, formData, body)
  let scheme = call_593868.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593868.url(scheme.get, call_593868.host, call_593868.base,
                         call_593868.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593868, url, valid)

proc call*(call_593939: Call_ReplicapoolInstanceGroupManagersList_593692;
          zone: string; project: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 500; key: string = "";
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## replicapoolInstanceGroupManagersList
  ## Retrieves the list of Instance Group Manager resources contained within the specified zone.
  ##   zone: string (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. Tag returned by a previous list request truncated by maxResults. Used to continue a previous list request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Optional. Maximum count of results to be returned. Maximum value is 500 and default value is 500.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Optional. Filter expression for filtering listed resources.
  var path_593940 = newJObject()
  var query_593942 = newJObject()
  add(path_593940, "zone", newJString(zone))
  add(query_593942, "fields", newJString(fields))
  add(query_593942, "pageToken", newJString(pageToken))
  add(query_593942, "quotaUser", newJString(quotaUser))
  add(query_593942, "alt", newJString(alt))
  add(query_593942, "oauth_token", newJString(oauthToken))
  add(query_593942, "userIp", newJString(userIp))
  add(query_593942, "maxResults", newJInt(maxResults))
  add(query_593942, "key", newJString(key))
  add(path_593940, "project", newJString(project))
  add(query_593942, "prettyPrint", newJBool(prettyPrint))
  add(query_593942, "filter", newJString(filter))
  result = call_593939.call(path_593940, query_593942, nil, nil, nil)

var replicapoolInstanceGroupManagersList* = Call_ReplicapoolInstanceGroupManagersList_593692(
    name: "replicapoolInstanceGroupManagersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/instanceGroupManagers",
    validator: validate_ReplicapoolInstanceGroupManagersList_593693,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersList_593694, schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersGet_594000 = ref object of OpenApiRestCall_593424
proc url_ReplicapoolInstanceGroupManagersGet_594002(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "instanceGroupManager" in path,
        "`instanceGroupManager` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/instanceGroupManagers/"),
               (kind: VariableSegment, value: "instanceGroupManager")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicapoolInstanceGroupManagersGet_594001(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the specified Instance Group Manager resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   instanceGroupManager: JString (required)
  ##                       : Name of the instance resource to return.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594003 = path.getOrDefault("zone")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "zone", valid_594003
  var valid_594004 = path.getOrDefault("instanceGroupManager")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "instanceGroupManager", valid_594004
  var valid_594005 = path.getOrDefault("project")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "project", valid_594005
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
  var valid_594006 = query.getOrDefault("fields")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "fields", valid_594006
  var valid_594007 = query.getOrDefault("quotaUser")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "quotaUser", valid_594007
  var valid_594008 = query.getOrDefault("alt")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = newJString("json"))
  if valid_594008 != nil:
    section.add "alt", valid_594008
  var valid_594009 = query.getOrDefault("oauth_token")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "oauth_token", valid_594009
  var valid_594010 = query.getOrDefault("userIp")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "userIp", valid_594010
  var valid_594011 = query.getOrDefault("key")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "key", valid_594011
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

proc call*(call_594013: Call_ReplicapoolInstanceGroupManagersGet_594000;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the specified Instance Group Manager resource.
  ## 
  let valid = call_594013.validator(path, query, header, formData, body)
  let scheme = call_594013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594013.url(scheme.get, call_594013.host, call_594013.base,
                         call_594013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594013, url, valid)

proc call*(call_594014: Call_ReplicapoolInstanceGroupManagersGet_594000;
          zone: string; instanceGroupManager: string; project: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## replicapoolInstanceGroupManagersGet
  ## Returns the specified Instance Group Manager resource.
  ##   zone: string (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instanceGroupManager: string (required)
  ##                       : Name of the instance resource to return.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594015 = newJObject()
  var query_594016 = newJObject()
  add(path_594015, "zone", newJString(zone))
  add(query_594016, "fields", newJString(fields))
  add(query_594016, "quotaUser", newJString(quotaUser))
  add(path_594015, "instanceGroupManager", newJString(instanceGroupManager))
  add(query_594016, "alt", newJString(alt))
  add(query_594016, "oauth_token", newJString(oauthToken))
  add(query_594016, "userIp", newJString(userIp))
  add(query_594016, "key", newJString(key))
  add(path_594015, "project", newJString(project))
  add(query_594016, "prettyPrint", newJBool(prettyPrint))
  result = call_594014.call(path_594015, query_594016, nil, nil, nil)

var replicapoolInstanceGroupManagersGet* = Call_ReplicapoolInstanceGroupManagersGet_594000(
    name: "replicapoolInstanceGroupManagersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/zones/{zone}/instanceGroupManagers/{instanceGroupManager}",
    validator: validate_ReplicapoolInstanceGroupManagersGet_594001,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersGet_594002, schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersDelete_594017 = ref object of OpenApiRestCall_593424
proc url_ReplicapoolInstanceGroupManagersDelete_594019(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "instanceGroupManager" in path,
        "`instanceGroupManager` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/instanceGroupManagers/"),
               (kind: VariableSegment, value: "instanceGroupManager")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicapoolInstanceGroupManagersDelete_594018(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the instance group manager and all instances contained within. If you'd like to delete the manager without deleting the instances, you must first abandon the instances to remove them from the group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   instanceGroupManager: JString (required)
  ##                       : Name of the Instance Group Manager resource to delete.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594020 = path.getOrDefault("zone")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "zone", valid_594020
  var valid_594021 = path.getOrDefault("instanceGroupManager")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "instanceGroupManager", valid_594021
  var valid_594022 = path.getOrDefault("project")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "project", valid_594022
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
  var valid_594026 = query.getOrDefault("oauth_token")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "oauth_token", valid_594026
  var valid_594027 = query.getOrDefault("userIp")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "userIp", valid_594027
  var valid_594028 = query.getOrDefault("key")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "key", valid_594028
  var valid_594029 = query.getOrDefault("prettyPrint")
  valid_594029 = validateParameter(valid_594029, JBool, required = false,
                                 default = newJBool(true))
  if valid_594029 != nil:
    section.add "prettyPrint", valid_594029
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594030: Call_ReplicapoolInstanceGroupManagersDelete_594017;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the instance group manager and all instances contained within. If you'd like to delete the manager without deleting the instances, you must first abandon the instances to remove them from the group.
  ## 
  let valid = call_594030.validator(path, query, header, formData, body)
  let scheme = call_594030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594030.url(scheme.get, call_594030.host, call_594030.base,
                         call_594030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594030, url, valid)

proc call*(call_594031: Call_ReplicapoolInstanceGroupManagersDelete_594017;
          zone: string; instanceGroupManager: string; project: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## replicapoolInstanceGroupManagersDelete
  ## Deletes the instance group manager and all instances contained within. If you'd like to delete the manager without deleting the instances, you must first abandon the instances to remove them from the group.
  ##   zone: string (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instanceGroupManager: string (required)
  ##                       : Name of the Instance Group Manager resource to delete.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594032 = newJObject()
  var query_594033 = newJObject()
  add(path_594032, "zone", newJString(zone))
  add(query_594033, "fields", newJString(fields))
  add(query_594033, "quotaUser", newJString(quotaUser))
  add(path_594032, "instanceGroupManager", newJString(instanceGroupManager))
  add(query_594033, "alt", newJString(alt))
  add(query_594033, "oauth_token", newJString(oauthToken))
  add(query_594033, "userIp", newJString(userIp))
  add(query_594033, "key", newJString(key))
  add(path_594032, "project", newJString(project))
  add(query_594033, "prettyPrint", newJBool(prettyPrint))
  result = call_594031.call(path_594032, query_594033, nil, nil, nil)

var replicapoolInstanceGroupManagersDelete* = Call_ReplicapoolInstanceGroupManagersDelete_594017(
    name: "replicapoolInstanceGroupManagersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{project}/zones/{zone}/instanceGroupManagers/{instanceGroupManager}",
    validator: validate_ReplicapoolInstanceGroupManagersDelete_594018,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersDelete_594019,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersAbandonInstances_594034 = ref object of OpenApiRestCall_593424
proc url_ReplicapoolInstanceGroupManagersAbandonInstances_594036(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "instanceGroupManager" in path,
        "`instanceGroupManager` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/instanceGroupManagers/"),
               (kind: VariableSegment, value: "instanceGroupManager"),
               (kind: ConstantSegment, value: "/abandonInstances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicapoolInstanceGroupManagersAbandonInstances_594035(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Removes the specified instances from the managed instance group, and from any target pools of which they were members, without deleting the instances.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   instanceGroupManager: JString (required)
  ##                       : The name of the instance group manager.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594037 = path.getOrDefault("zone")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "zone", valid_594037
  var valid_594038 = path.getOrDefault("instanceGroupManager")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "instanceGroupManager", valid_594038
  var valid_594039 = path.getOrDefault("project")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "project", valid_594039
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
  var valid_594040 = query.getOrDefault("fields")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = nil)
  if valid_594040 != nil:
    section.add "fields", valid_594040
  var valid_594041 = query.getOrDefault("quotaUser")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = nil)
  if valid_594041 != nil:
    section.add "quotaUser", valid_594041
  var valid_594042 = query.getOrDefault("alt")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = newJString("json"))
  if valid_594042 != nil:
    section.add "alt", valid_594042
  var valid_594043 = query.getOrDefault("oauth_token")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = nil)
  if valid_594043 != nil:
    section.add "oauth_token", valid_594043
  var valid_594044 = query.getOrDefault("userIp")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = nil)
  if valid_594044 != nil:
    section.add "userIp", valid_594044
  var valid_594045 = query.getOrDefault("key")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = nil)
  if valid_594045 != nil:
    section.add "key", valid_594045
  var valid_594046 = query.getOrDefault("prettyPrint")
  valid_594046 = validateParameter(valid_594046, JBool, required = false,
                                 default = newJBool(true))
  if valid_594046 != nil:
    section.add "prettyPrint", valid_594046
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

proc call*(call_594048: Call_ReplicapoolInstanceGroupManagersAbandonInstances_594034;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes the specified instances from the managed instance group, and from any target pools of which they were members, without deleting the instances.
  ## 
  let valid = call_594048.validator(path, query, header, formData, body)
  let scheme = call_594048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594048.url(scheme.get, call_594048.host, call_594048.base,
                         call_594048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594048, url, valid)

proc call*(call_594049: Call_ReplicapoolInstanceGroupManagersAbandonInstances_594034;
          zone: string; instanceGroupManager: string; project: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## replicapoolInstanceGroupManagersAbandonInstances
  ## Removes the specified instances from the managed instance group, and from any target pools of which they were members, without deleting the instances.
  ##   zone: string (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instanceGroupManager: string (required)
  ##                       : The name of the instance group manager.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594050 = newJObject()
  var query_594051 = newJObject()
  var body_594052 = newJObject()
  add(path_594050, "zone", newJString(zone))
  add(query_594051, "fields", newJString(fields))
  add(query_594051, "quotaUser", newJString(quotaUser))
  add(path_594050, "instanceGroupManager", newJString(instanceGroupManager))
  add(query_594051, "alt", newJString(alt))
  add(query_594051, "oauth_token", newJString(oauthToken))
  add(query_594051, "userIp", newJString(userIp))
  add(query_594051, "key", newJString(key))
  add(path_594050, "project", newJString(project))
  if body != nil:
    body_594052 = body
  add(query_594051, "prettyPrint", newJBool(prettyPrint))
  result = call_594049.call(path_594050, query_594051, nil, nil, body_594052)

var replicapoolInstanceGroupManagersAbandonInstances* = Call_ReplicapoolInstanceGroupManagersAbandonInstances_594034(
    name: "replicapoolInstanceGroupManagersAbandonInstances",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{project}/zones/{zone}/instanceGroupManagers/{instanceGroupManager}/abandonInstances",
    validator: validate_ReplicapoolInstanceGroupManagersAbandonInstances_594035,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersAbandonInstances_594036,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersDeleteInstances_594053 = ref object of OpenApiRestCall_593424
proc url_ReplicapoolInstanceGroupManagersDeleteInstances_594055(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "instanceGroupManager" in path,
        "`instanceGroupManager` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/instanceGroupManagers/"),
               (kind: VariableSegment, value: "instanceGroupManager"),
               (kind: ConstantSegment, value: "/deleteInstances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicapoolInstanceGroupManagersDeleteInstances_594054(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes the specified instances. The instances are deleted, then removed from the instance group and any target pools of which they were a member. The targetSize of the instance group manager is reduced by the number of instances deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   instanceGroupManager: JString (required)
  ##                       : The name of the instance group manager.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594056 = path.getOrDefault("zone")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "zone", valid_594056
  var valid_594057 = path.getOrDefault("instanceGroupManager")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "instanceGroupManager", valid_594057
  var valid_594058 = path.getOrDefault("project")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "project", valid_594058
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
  var valid_594059 = query.getOrDefault("fields")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = nil)
  if valid_594059 != nil:
    section.add "fields", valid_594059
  var valid_594060 = query.getOrDefault("quotaUser")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "quotaUser", valid_594060
  var valid_594061 = query.getOrDefault("alt")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = newJString("json"))
  if valid_594061 != nil:
    section.add "alt", valid_594061
  var valid_594062 = query.getOrDefault("oauth_token")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "oauth_token", valid_594062
  var valid_594063 = query.getOrDefault("userIp")
  valid_594063 = validateParameter(valid_594063, JString, required = false,
                                 default = nil)
  if valid_594063 != nil:
    section.add "userIp", valid_594063
  var valid_594064 = query.getOrDefault("key")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = nil)
  if valid_594064 != nil:
    section.add "key", valid_594064
  var valid_594065 = query.getOrDefault("prettyPrint")
  valid_594065 = validateParameter(valid_594065, JBool, required = false,
                                 default = newJBool(true))
  if valid_594065 != nil:
    section.add "prettyPrint", valid_594065
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

proc call*(call_594067: Call_ReplicapoolInstanceGroupManagersDeleteInstances_594053;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified instances. The instances are deleted, then removed from the instance group and any target pools of which they were a member. The targetSize of the instance group manager is reduced by the number of instances deleted.
  ## 
  let valid = call_594067.validator(path, query, header, formData, body)
  let scheme = call_594067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594067.url(scheme.get, call_594067.host, call_594067.base,
                         call_594067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594067, url, valid)

proc call*(call_594068: Call_ReplicapoolInstanceGroupManagersDeleteInstances_594053;
          zone: string; instanceGroupManager: string; project: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## replicapoolInstanceGroupManagersDeleteInstances
  ## Deletes the specified instances. The instances are deleted, then removed from the instance group and any target pools of which they were a member. The targetSize of the instance group manager is reduced by the number of instances deleted.
  ##   zone: string (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instanceGroupManager: string (required)
  ##                       : The name of the instance group manager.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594069 = newJObject()
  var query_594070 = newJObject()
  var body_594071 = newJObject()
  add(path_594069, "zone", newJString(zone))
  add(query_594070, "fields", newJString(fields))
  add(query_594070, "quotaUser", newJString(quotaUser))
  add(path_594069, "instanceGroupManager", newJString(instanceGroupManager))
  add(query_594070, "alt", newJString(alt))
  add(query_594070, "oauth_token", newJString(oauthToken))
  add(query_594070, "userIp", newJString(userIp))
  add(query_594070, "key", newJString(key))
  add(path_594069, "project", newJString(project))
  if body != nil:
    body_594071 = body
  add(query_594070, "prettyPrint", newJBool(prettyPrint))
  result = call_594068.call(path_594069, query_594070, nil, nil, body_594071)

var replicapoolInstanceGroupManagersDeleteInstances* = Call_ReplicapoolInstanceGroupManagersDeleteInstances_594053(
    name: "replicapoolInstanceGroupManagersDeleteInstances",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{project}/zones/{zone}/instanceGroupManagers/{instanceGroupManager}/deleteInstances",
    validator: validate_ReplicapoolInstanceGroupManagersDeleteInstances_594054,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersDeleteInstances_594055,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersRecreateInstances_594072 = ref object of OpenApiRestCall_593424
proc url_ReplicapoolInstanceGroupManagersRecreateInstances_594074(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "instanceGroupManager" in path,
        "`instanceGroupManager` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/instanceGroupManagers/"),
               (kind: VariableSegment, value: "instanceGroupManager"),
               (kind: ConstantSegment, value: "/recreateInstances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicapoolInstanceGroupManagersRecreateInstances_594073(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Recreates the specified instances. The instances are deleted, then recreated using the instance group manager's current instance template.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   instanceGroupManager: JString (required)
  ##                       : The name of the instance group manager.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594075 = path.getOrDefault("zone")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "zone", valid_594075
  var valid_594076 = path.getOrDefault("instanceGroupManager")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "instanceGroupManager", valid_594076
  var valid_594077 = path.getOrDefault("project")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "project", valid_594077
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
  var valid_594078 = query.getOrDefault("fields")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = nil)
  if valid_594078 != nil:
    section.add "fields", valid_594078
  var valid_594079 = query.getOrDefault("quotaUser")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = nil)
  if valid_594079 != nil:
    section.add "quotaUser", valid_594079
  var valid_594080 = query.getOrDefault("alt")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = newJString("json"))
  if valid_594080 != nil:
    section.add "alt", valid_594080
  var valid_594081 = query.getOrDefault("oauth_token")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = nil)
  if valid_594081 != nil:
    section.add "oauth_token", valid_594081
  var valid_594082 = query.getOrDefault("userIp")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = nil)
  if valid_594082 != nil:
    section.add "userIp", valid_594082
  var valid_594083 = query.getOrDefault("key")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = nil)
  if valid_594083 != nil:
    section.add "key", valid_594083
  var valid_594084 = query.getOrDefault("prettyPrint")
  valid_594084 = validateParameter(valid_594084, JBool, required = false,
                                 default = newJBool(true))
  if valid_594084 != nil:
    section.add "prettyPrint", valid_594084
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

proc call*(call_594086: Call_ReplicapoolInstanceGroupManagersRecreateInstances_594072;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Recreates the specified instances. The instances are deleted, then recreated using the instance group manager's current instance template.
  ## 
  let valid = call_594086.validator(path, query, header, formData, body)
  let scheme = call_594086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594086.url(scheme.get, call_594086.host, call_594086.base,
                         call_594086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594086, url, valid)

proc call*(call_594087: Call_ReplicapoolInstanceGroupManagersRecreateInstances_594072;
          zone: string; instanceGroupManager: string; project: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## replicapoolInstanceGroupManagersRecreateInstances
  ## Recreates the specified instances. The instances are deleted, then recreated using the instance group manager's current instance template.
  ##   zone: string (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instanceGroupManager: string (required)
  ##                       : The name of the instance group manager.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594088 = newJObject()
  var query_594089 = newJObject()
  var body_594090 = newJObject()
  add(path_594088, "zone", newJString(zone))
  add(query_594089, "fields", newJString(fields))
  add(query_594089, "quotaUser", newJString(quotaUser))
  add(path_594088, "instanceGroupManager", newJString(instanceGroupManager))
  add(query_594089, "alt", newJString(alt))
  add(query_594089, "oauth_token", newJString(oauthToken))
  add(query_594089, "userIp", newJString(userIp))
  add(query_594089, "key", newJString(key))
  add(path_594088, "project", newJString(project))
  if body != nil:
    body_594090 = body
  add(query_594089, "prettyPrint", newJBool(prettyPrint))
  result = call_594087.call(path_594088, query_594089, nil, nil, body_594090)

var replicapoolInstanceGroupManagersRecreateInstances* = Call_ReplicapoolInstanceGroupManagersRecreateInstances_594072(
    name: "replicapoolInstanceGroupManagersRecreateInstances",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{project}/zones/{zone}/instanceGroupManagers/{instanceGroupManager}/recreateInstances",
    validator: validate_ReplicapoolInstanceGroupManagersRecreateInstances_594073,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersRecreateInstances_594074,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersResize_594091 = ref object of OpenApiRestCall_593424
proc url_ReplicapoolInstanceGroupManagersResize_594093(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "instanceGroupManager" in path,
        "`instanceGroupManager` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/instanceGroupManagers/"),
               (kind: VariableSegment, value: "instanceGroupManager"),
               (kind: ConstantSegment, value: "/resize")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicapoolInstanceGroupManagersResize_594092(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resizes the managed instance group up or down. If resized up, new instances are created using the current instance template. If resized down, instances are removed in the order outlined in Resizing a managed instance group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   instanceGroupManager: JString (required)
  ##                       : The name of the instance group manager.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594094 = path.getOrDefault("zone")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "zone", valid_594094
  var valid_594095 = path.getOrDefault("instanceGroupManager")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "instanceGroupManager", valid_594095
  var valid_594096 = path.getOrDefault("project")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "project", valid_594096
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
  ##   size: JInt (required)
  ##       : Number of instances that should exist in this Instance Group Manager.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594097 = query.getOrDefault("fields")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = nil)
  if valid_594097 != nil:
    section.add "fields", valid_594097
  var valid_594098 = query.getOrDefault("quotaUser")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "quotaUser", valid_594098
  var valid_594099 = query.getOrDefault("alt")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = newJString("json"))
  if valid_594099 != nil:
    section.add "alt", valid_594099
  var valid_594100 = query.getOrDefault("oauth_token")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = nil)
  if valid_594100 != nil:
    section.add "oauth_token", valid_594100
  var valid_594101 = query.getOrDefault("userIp")
  valid_594101 = validateParameter(valid_594101, JString, required = false,
                                 default = nil)
  if valid_594101 != nil:
    section.add "userIp", valid_594101
  var valid_594102 = query.getOrDefault("key")
  valid_594102 = validateParameter(valid_594102, JString, required = false,
                                 default = nil)
  if valid_594102 != nil:
    section.add "key", valid_594102
  assert query != nil, "query argument is necessary due to required `size` field"
  var valid_594103 = query.getOrDefault("size")
  valid_594103 = validateParameter(valid_594103, JInt, required = true, default = nil)
  if valid_594103 != nil:
    section.add "size", valid_594103
  var valid_594104 = query.getOrDefault("prettyPrint")
  valid_594104 = validateParameter(valid_594104, JBool, required = false,
                                 default = newJBool(true))
  if valid_594104 != nil:
    section.add "prettyPrint", valid_594104
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594105: Call_ReplicapoolInstanceGroupManagersResize_594091;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resizes the managed instance group up or down. If resized up, new instances are created using the current instance template. If resized down, instances are removed in the order outlined in Resizing a managed instance group.
  ## 
  let valid = call_594105.validator(path, query, header, formData, body)
  let scheme = call_594105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594105.url(scheme.get, call_594105.host, call_594105.base,
                         call_594105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594105, url, valid)

proc call*(call_594106: Call_ReplicapoolInstanceGroupManagersResize_594091;
          zone: string; instanceGroupManager: string; size: int; project: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## replicapoolInstanceGroupManagersResize
  ## Resizes the managed instance group up or down. If resized up, new instances are created using the current instance template. If resized down, instances are removed in the order outlined in Resizing a managed instance group.
  ##   zone: string (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instanceGroupManager: string (required)
  ##                       : The name of the instance group manager.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   size: int (required)
  ##       : Number of instances that should exist in this Instance Group Manager.
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594107 = newJObject()
  var query_594108 = newJObject()
  add(path_594107, "zone", newJString(zone))
  add(query_594108, "fields", newJString(fields))
  add(query_594108, "quotaUser", newJString(quotaUser))
  add(path_594107, "instanceGroupManager", newJString(instanceGroupManager))
  add(query_594108, "alt", newJString(alt))
  add(query_594108, "oauth_token", newJString(oauthToken))
  add(query_594108, "userIp", newJString(userIp))
  add(query_594108, "key", newJString(key))
  add(query_594108, "size", newJInt(size))
  add(path_594107, "project", newJString(project))
  add(query_594108, "prettyPrint", newJBool(prettyPrint))
  result = call_594106.call(path_594107, query_594108, nil, nil, nil)

var replicapoolInstanceGroupManagersResize* = Call_ReplicapoolInstanceGroupManagersResize_594091(
    name: "replicapoolInstanceGroupManagersResize", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/zones/{zone}/instanceGroupManagers/{instanceGroupManager}/resize",
    validator: validate_ReplicapoolInstanceGroupManagersResize_594092,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersResize_594093,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersSetInstanceTemplate_594109 = ref object of OpenApiRestCall_593424
proc url_ReplicapoolInstanceGroupManagersSetInstanceTemplate_594111(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "instanceGroupManager" in path,
        "`instanceGroupManager` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/instanceGroupManagers/"),
               (kind: VariableSegment, value: "instanceGroupManager"),
               (kind: ConstantSegment, value: "/setInstanceTemplate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicapoolInstanceGroupManagersSetInstanceTemplate_594110(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the instance template to use when creating new instances in this group. Existing instances are not affected.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   instanceGroupManager: JString (required)
  ##                       : The name of the instance group manager.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594112 = path.getOrDefault("zone")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "zone", valid_594112
  var valid_594113 = path.getOrDefault("instanceGroupManager")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "instanceGroupManager", valid_594113
  var valid_594114 = path.getOrDefault("project")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "project", valid_594114
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
  var valid_594115 = query.getOrDefault("fields")
  valid_594115 = validateParameter(valid_594115, JString, required = false,
                                 default = nil)
  if valid_594115 != nil:
    section.add "fields", valid_594115
  var valid_594116 = query.getOrDefault("quotaUser")
  valid_594116 = validateParameter(valid_594116, JString, required = false,
                                 default = nil)
  if valid_594116 != nil:
    section.add "quotaUser", valid_594116
  var valid_594117 = query.getOrDefault("alt")
  valid_594117 = validateParameter(valid_594117, JString, required = false,
                                 default = newJString("json"))
  if valid_594117 != nil:
    section.add "alt", valid_594117
  var valid_594118 = query.getOrDefault("oauth_token")
  valid_594118 = validateParameter(valid_594118, JString, required = false,
                                 default = nil)
  if valid_594118 != nil:
    section.add "oauth_token", valid_594118
  var valid_594119 = query.getOrDefault("userIp")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "userIp", valid_594119
  var valid_594120 = query.getOrDefault("key")
  valid_594120 = validateParameter(valid_594120, JString, required = false,
                                 default = nil)
  if valid_594120 != nil:
    section.add "key", valid_594120
  var valid_594121 = query.getOrDefault("prettyPrint")
  valid_594121 = validateParameter(valid_594121, JBool, required = false,
                                 default = newJBool(true))
  if valid_594121 != nil:
    section.add "prettyPrint", valid_594121
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

proc call*(call_594123: Call_ReplicapoolInstanceGroupManagersSetInstanceTemplate_594109;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the instance template to use when creating new instances in this group. Existing instances are not affected.
  ## 
  let valid = call_594123.validator(path, query, header, formData, body)
  let scheme = call_594123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594123.url(scheme.get, call_594123.host, call_594123.base,
                         call_594123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594123, url, valid)

proc call*(call_594124: Call_ReplicapoolInstanceGroupManagersSetInstanceTemplate_594109;
          zone: string; instanceGroupManager: string; project: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## replicapoolInstanceGroupManagersSetInstanceTemplate
  ## Sets the instance template to use when creating new instances in this group. Existing instances are not affected.
  ##   zone: string (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instanceGroupManager: string (required)
  ##                       : The name of the instance group manager.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594125 = newJObject()
  var query_594126 = newJObject()
  var body_594127 = newJObject()
  add(path_594125, "zone", newJString(zone))
  add(query_594126, "fields", newJString(fields))
  add(query_594126, "quotaUser", newJString(quotaUser))
  add(path_594125, "instanceGroupManager", newJString(instanceGroupManager))
  add(query_594126, "alt", newJString(alt))
  add(query_594126, "oauth_token", newJString(oauthToken))
  add(query_594126, "userIp", newJString(userIp))
  add(query_594126, "key", newJString(key))
  add(path_594125, "project", newJString(project))
  if body != nil:
    body_594127 = body
  add(query_594126, "prettyPrint", newJBool(prettyPrint))
  result = call_594124.call(path_594125, query_594126, nil, nil, body_594127)

var replicapoolInstanceGroupManagersSetInstanceTemplate* = Call_ReplicapoolInstanceGroupManagersSetInstanceTemplate_594109(
    name: "replicapoolInstanceGroupManagersSetInstanceTemplate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{project}/zones/{zone}/instanceGroupManagers/{instanceGroupManager}/setInstanceTemplate",
    validator: validate_ReplicapoolInstanceGroupManagersSetInstanceTemplate_594110,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersSetInstanceTemplate_594111,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolInstanceGroupManagersSetTargetPools_594128 = ref object of OpenApiRestCall_593424
proc url_ReplicapoolInstanceGroupManagersSetTargetPools_594130(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "instanceGroupManager" in path,
        "`instanceGroupManager` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/instanceGroupManagers/"),
               (kind: VariableSegment, value: "instanceGroupManager"),
               (kind: ConstantSegment, value: "/setTargetPools")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicapoolInstanceGroupManagersSetTargetPools_594129(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Modifies the target pools to which all new instances in this group are assigned. Existing instances in the group are not affected.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   instanceGroupManager: JString (required)
  ##                       : The name of the instance group manager.
  ##   project: JString (required)
  ##          : The Google Developers Console project name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594131 = path.getOrDefault("zone")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "zone", valid_594131
  var valid_594132 = path.getOrDefault("instanceGroupManager")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "instanceGroupManager", valid_594132
  var valid_594133 = path.getOrDefault("project")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = nil)
  if valid_594133 != nil:
    section.add "project", valid_594133
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
  var valid_594134 = query.getOrDefault("fields")
  valid_594134 = validateParameter(valid_594134, JString, required = false,
                                 default = nil)
  if valid_594134 != nil:
    section.add "fields", valid_594134
  var valid_594135 = query.getOrDefault("quotaUser")
  valid_594135 = validateParameter(valid_594135, JString, required = false,
                                 default = nil)
  if valid_594135 != nil:
    section.add "quotaUser", valid_594135
  var valid_594136 = query.getOrDefault("alt")
  valid_594136 = validateParameter(valid_594136, JString, required = false,
                                 default = newJString("json"))
  if valid_594136 != nil:
    section.add "alt", valid_594136
  var valid_594137 = query.getOrDefault("oauth_token")
  valid_594137 = validateParameter(valid_594137, JString, required = false,
                                 default = nil)
  if valid_594137 != nil:
    section.add "oauth_token", valid_594137
  var valid_594138 = query.getOrDefault("userIp")
  valid_594138 = validateParameter(valid_594138, JString, required = false,
                                 default = nil)
  if valid_594138 != nil:
    section.add "userIp", valid_594138
  var valid_594139 = query.getOrDefault("key")
  valid_594139 = validateParameter(valid_594139, JString, required = false,
                                 default = nil)
  if valid_594139 != nil:
    section.add "key", valid_594139
  var valid_594140 = query.getOrDefault("prettyPrint")
  valid_594140 = validateParameter(valid_594140, JBool, required = false,
                                 default = newJBool(true))
  if valid_594140 != nil:
    section.add "prettyPrint", valid_594140
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

proc call*(call_594142: Call_ReplicapoolInstanceGroupManagersSetTargetPools_594128;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modifies the target pools to which all new instances in this group are assigned. Existing instances in the group are not affected.
  ## 
  let valid = call_594142.validator(path, query, header, formData, body)
  let scheme = call_594142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594142.url(scheme.get, call_594142.host, call_594142.base,
                         call_594142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594142, url, valid)

proc call*(call_594143: Call_ReplicapoolInstanceGroupManagersSetTargetPools_594128;
          zone: string; instanceGroupManager: string; project: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## replicapoolInstanceGroupManagersSetTargetPools
  ## Modifies the target pools to which all new instances in this group are assigned. Existing instances in the group are not affected.
  ##   zone: string (required)
  ##       : The name of the zone in which the instance group manager resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instanceGroupManager: string (required)
  ##                       : The name of the instance group manager.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The Google Developers Console project name.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594144 = newJObject()
  var query_594145 = newJObject()
  var body_594146 = newJObject()
  add(path_594144, "zone", newJString(zone))
  add(query_594145, "fields", newJString(fields))
  add(query_594145, "quotaUser", newJString(quotaUser))
  add(path_594144, "instanceGroupManager", newJString(instanceGroupManager))
  add(query_594145, "alt", newJString(alt))
  add(query_594145, "oauth_token", newJString(oauthToken))
  add(query_594145, "userIp", newJString(userIp))
  add(query_594145, "key", newJString(key))
  add(path_594144, "project", newJString(project))
  if body != nil:
    body_594146 = body
  add(query_594145, "prettyPrint", newJBool(prettyPrint))
  result = call_594143.call(path_594144, query_594145, nil, nil, body_594146)

var replicapoolInstanceGroupManagersSetTargetPools* = Call_ReplicapoolInstanceGroupManagersSetTargetPools_594128(
    name: "replicapoolInstanceGroupManagersSetTargetPools",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/{project}/zones/{zone}/instanceGroupManagers/{instanceGroupManager}/setTargetPools",
    validator: validate_ReplicapoolInstanceGroupManagersSetTargetPools_594129,
    base: "/replicapool/v1beta2/projects",
    url: url_ReplicapoolInstanceGroupManagersSetTargetPools_594130,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolZoneOperationsList_594147 = ref object of OpenApiRestCall_593424
proc url_ReplicapoolZoneOperationsList_594149(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicapoolZoneOperationsList_594148(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of operation resources contained within the specified zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Name of the zone scoping this request.
  ##   project: JString (required)
  ##          : Name of the project scoping this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594150 = path.getOrDefault("zone")
  valid_594150 = validateParameter(valid_594150, JString, required = true,
                                 default = nil)
  if valid_594150 != nil:
    section.add "zone", valid_594150
  var valid_594151 = path.getOrDefault("project")
  valid_594151 = validateParameter(valid_594151, JString, required = true,
                                 default = nil)
  if valid_594151 != nil:
    section.add "project", valid_594151
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional. Tag returned by a previous list request truncated by maxResults. Used to continue a previous list request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Optional. Maximum count of results to be returned. Maximum value is 500 and default value is 500.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Optional. Filter expression for filtering listed resources.
  section = newJObject()
  var valid_594152 = query.getOrDefault("fields")
  valid_594152 = validateParameter(valid_594152, JString, required = false,
                                 default = nil)
  if valid_594152 != nil:
    section.add "fields", valid_594152
  var valid_594153 = query.getOrDefault("pageToken")
  valid_594153 = validateParameter(valid_594153, JString, required = false,
                                 default = nil)
  if valid_594153 != nil:
    section.add "pageToken", valid_594153
  var valid_594154 = query.getOrDefault("quotaUser")
  valid_594154 = validateParameter(valid_594154, JString, required = false,
                                 default = nil)
  if valid_594154 != nil:
    section.add "quotaUser", valid_594154
  var valid_594155 = query.getOrDefault("alt")
  valid_594155 = validateParameter(valid_594155, JString, required = false,
                                 default = newJString("json"))
  if valid_594155 != nil:
    section.add "alt", valid_594155
  var valid_594156 = query.getOrDefault("oauth_token")
  valid_594156 = validateParameter(valid_594156, JString, required = false,
                                 default = nil)
  if valid_594156 != nil:
    section.add "oauth_token", valid_594156
  var valid_594157 = query.getOrDefault("userIp")
  valid_594157 = validateParameter(valid_594157, JString, required = false,
                                 default = nil)
  if valid_594157 != nil:
    section.add "userIp", valid_594157
  var valid_594158 = query.getOrDefault("maxResults")
  valid_594158 = validateParameter(valid_594158, JInt, required = false,
                                 default = newJInt(500))
  if valid_594158 != nil:
    section.add "maxResults", valid_594158
  var valid_594159 = query.getOrDefault("key")
  valid_594159 = validateParameter(valid_594159, JString, required = false,
                                 default = nil)
  if valid_594159 != nil:
    section.add "key", valid_594159
  var valid_594160 = query.getOrDefault("prettyPrint")
  valid_594160 = validateParameter(valid_594160, JBool, required = false,
                                 default = newJBool(true))
  if valid_594160 != nil:
    section.add "prettyPrint", valid_594160
  var valid_594161 = query.getOrDefault("filter")
  valid_594161 = validateParameter(valid_594161, JString, required = false,
                                 default = nil)
  if valid_594161 != nil:
    section.add "filter", valid_594161
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594162: Call_ReplicapoolZoneOperationsList_594147; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of operation resources contained within the specified zone.
  ## 
  let valid = call_594162.validator(path, query, header, formData, body)
  let scheme = call_594162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594162.url(scheme.get, call_594162.host, call_594162.base,
                         call_594162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594162, url, valid)

proc call*(call_594163: Call_ReplicapoolZoneOperationsList_594147; zone: string;
          project: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 500; key: string = "";
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## replicapoolZoneOperationsList
  ## Retrieves the list of operation resources contained within the specified zone.
  ##   zone: string (required)
  ##       : Name of the zone scoping this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. Tag returned by a previous list request truncated by maxResults. Used to continue a previous list request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Optional. Maximum count of results to be returned. Maximum value is 500 and default value is 500.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : Name of the project scoping this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Optional. Filter expression for filtering listed resources.
  var path_594164 = newJObject()
  var query_594165 = newJObject()
  add(path_594164, "zone", newJString(zone))
  add(query_594165, "fields", newJString(fields))
  add(query_594165, "pageToken", newJString(pageToken))
  add(query_594165, "quotaUser", newJString(quotaUser))
  add(query_594165, "alt", newJString(alt))
  add(query_594165, "oauth_token", newJString(oauthToken))
  add(query_594165, "userIp", newJString(userIp))
  add(query_594165, "maxResults", newJInt(maxResults))
  add(query_594165, "key", newJString(key))
  add(path_594164, "project", newJString(project))
  add(query_594165, "prettyPrint", newJBool(prettyPrint))
  add(query_594165, "filter", newJString(filter))
  result = call_594163.call(path_594164, query_594165, nil, nil, nil)

var replicapoolZoneOperationsList* = Call_ReplicapoolZoneOperationsList_594147(
    name: "replicapoolZoneOperationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/zones/{zone}/operations",
    validator: validate_ReplicapoolZoneOperationsList_594148,
    base: "/replicapool/v1beta2/projects", url: url_ReplicapoolZoneOperationsList_594149,
    schemes: {Scheme.Https})
type
  Call_ReplicapoolZoneOperationsGet_594166 = ref object of OpenApiRestCall_593424
proc url_ReplicapoolZoneOperationsGet_594168(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "operation" in path, "`operation` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicapoolZoneOperationsGet_594167(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the specified zone-specific operation resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Name of the zone scoping this request.
  ##   operation: JString (required)
  ##            : Name of the operation resource to return.
  ##   project: JString (required)
  ##          : Name of the project scoping this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594169 = path.getOrDefault("zone")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "zone", valid_594169
  var valid_594170 = path.getOrDefault("operation")
  valid_594170 = validateParameter(valid_594170, JString, required = true,
                                 default = nil)
  if valid_594170 != nil:
    section.add "operation", valid_594170
  var valid_594171 = path.getOrDefault("project")
  valid_594171 = validateParameter(valid_594171, JString, required = true,
                                 default = nil)
  if valid_594171 != nil:
    section.add "project", valid_594171
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
  var valid_594172 = query.getOrDefault("fields")
  valid_594172 = validateParameter(valid_594172, JString, required = false,
                                 default = nil)
  if valid_594172 != nil:
    section.add "fields", valid_594172
  var valid_594173 = query.getOrDefault("quotaUser")
  valid_594173 = validateParameter(valid_594173, JString, required = false,
                                 default = nil)
  if valid_594173 != nil:
    section.add "quotaUser", valid_594173
  var valid_594174 = query.getOrDefault("alt")
  valid_594174 = validateParameter(valid_594174, JString, required = false,
                                 default = newJString("json"))
  if valid_594174 != nil:
    section.add "alt", valid_594174
  var valid_594175 = query.getOrDefault("oauth_token")
  valid_594175 = validateParameter(valid_594175, JString, required = false,
                                 default = nil)
  if valid_594175 != nil:
    section.add "oauth_token", valid_594175
  var valid_594176 = query.getOrDefault("userIp")
  valid_594176 = validateParameter(valid_594176, JString, required = false,
                                 default = nil)
  if valid_594176 != nil:
    section.add "userIp", valid_594176
  var valid_594177 = query.getOrDefault("key")
  valid_594177 = validateParameter(valid_594177, JString, required = false,
                                 default = nil)
  if valid_594177 != nil:
    section.add "key", valid_594177
  var valid_594178 = query.getOrDefault("prettyPrint")
  valid_594178 = validateParameter(valid_594178, JBool, required = false,
                                 default = newJBool(true))
  if valid_594178 != nil:
    section.add "prettyPrint", valid_594178
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594179: Call_ReplicapoolZoneOperationsGet_594166; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified zone-specific operation resource.
  ## 
  let valid = call_594179.validator(path, query, header, formData, body)
  let scheme = call_594179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594179.url(scheme.get, call_594179.host, call_594179.base,
                         call_594179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594179, url, valid)

proc call*(call_594180: Call_ReplicapoolZoneOperationsGet_594166; zone: string;
          operation: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## replicapoolZoneOperationsGet
  ## Retrieves the specified zone-specific operation resource.
  ##   zone: string (required)
  ##       : Name of the zone scoping this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   operation: string (required)
  ##            : Name of the operation resource to return.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : Name of the project scoping this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594181 = newJObject()
  var query_594182 = newJObject()
  add(path_594181, "zone", newJString(zone))
  add(query_594182, "fields", newJString(fields))
  add(query_594182, "quotaUser", newJString(quotaUser))
  add(query_594182, "alt", newJString(alt))
  add(path_594181, "operation", newJString(operation))
  add(query_594182, "oauth_token", newJString(oauthToken))
  add(query_594182, "userIp", newJString(userIp))
  add(query_594182, "key", newJString(key))
  add(path_594181, "project", newJString(project))
  add(query_594182, "prettyPrint", newJBool(prettyPrint))
  result = call_594180.call(path_594181, query_594182, nil, nil, nil)

var replicapoolZoneOperationsGet* = Call_ReplicapoolZoneOperationsGet_594166(
    name: "replicapoolZoneOperationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/operations/{operation}",
    validator: validate_ReplicapoolZoneOperationsGet_594167,
    base: "/replicapool/v1beta2/projects", url: url_ReplicapoolZoneOperationsGet_594168,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
