
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Google Cloud DNS
## version: v1beta2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Configures and serves authoritative DNS records.
## 
## https://developers.google.com/cloud-dns
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
  gcpServiceName = "dns"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DnsProjectsGet_593676 = ref object of OpenApiRestCall_593408
proc url_DnsProjectsGet_593678(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DnsProjectsGet_593677(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Fetch the representation of an existing Project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : Identifies the project addressed by this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_593804 = path.getOrDefault("project")
  valid_593804 = validateParameter(valid_593804, JString, required = true,
                                 default = nil)
  if valid_593804 != nil:
    section.add "project", valid_593804
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
  ##   clientOperationId: JString
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
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
                                 default = newJString("json"))
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
  var valid_593824 = query.getOrDefault("clientOperationId")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "clientOperationId", valid_593824
  var valid_593825 = query.getOrDefault("prettyPrint")
  valid_593825 = validateParameter(valid_593825, JBool, required = false,
                                 default = newJBool(true))
  if valid_593825 != nil:
    section.add "prettyPrint", valid_593825
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593848: Call_DnsProjectsGet_593676; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetch the representation of an existing Project.
  ## 
  let valid = call_593848.validator(path, query, header, formData, body)
  let scheme = call_593848.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593848.url(scheme.get, call_593848.host, call_593848.base,
                         call_593848.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593848, url, valid)

proc call*(call_593919: Call_DnsProjectsGet_593676; project: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          clientOperationId: string = ""; prettyPrint: bool = true): Recallable =
  ## dnsProjectsGet
  ## Fetch the representation of an existing Project.
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
  ##   clientOperationId: string
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_593920 = newJObject()
  var query_593922 = newJObject()
  add(query_593922, "fields", newJString(fields))
  add(query_593922, "quotaUser", newJString(quotaUser))
  add(query_593922, "alt", newJString(alt))
  add(query_593922, "oauth_token", newJString(oauthToken))
  add(query_593922, "userIp", newJString(userIp))
  add(query_593922, "key", newJString(key))
  add(query_593922, "clientOperationId", newJString(clientOperationId))
  add(path_593920, "project", newJString(project))
  add(query_593922, "prettyPrint", newJBool(prettyPrint))
  result = call_593919.call(path_593920, query_593922, nil, nil, nil)

var dnsProjectsGet* = Call_DnsProjectsGet_593676(name: "dnsProjectsGet",
    meth: HttpMethod.HttpGet, host: "dns.googleapis.com", route: "/{project}",
    validator: validate_DnsProjectsGet_593677, base: "/dns/v1beta2/projects",
    url: url_DnsProjectsGet_593678, schemes: {Scheme.Https})
type
  Call_DnsManagedZonesCreate_593979 = ref object of OpenApiRestCall_593408
proc url_DnsManagedZonesCreate_593981(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/managedZones")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DnsManagedZonesCreate_593980(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new ManagedZone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : Identifies the project addressed by this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_593982 = path.getOrDefault("project")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "project", valid_593982
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
  ##   clientOperationId: JString
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
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
  var valid_593987 = query.getOrDefault("userIp")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "userIp", valid_593987
  var valid_593988 = query.getOrDefault("key")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "key", valid_593988
  var valid_593989 = query.getOrDefault("clientOperationId")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "clientOperationId", valid_593989
  var valid_593990 = query.getOrDefault("prettyPrint")
  valid_593990 = validateParameter(valid_593990, JBool, required = false,
                                 default = newJBool(true))
  if valid_593990 != nil:
    section.add "prettyPrint", valid_593990
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

proc call*(call_593992: Call_DnsManagedZonesCreate_593979; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new ManagedZone.
  ## 
  let valid = call_593992.validator(path, query, header, formData, body)
  let scheme = call_593992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593992.url(scheme.get, call_593992.host, call_593992.base,
                         call_593992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593992, url, valid)

proc call*(call_593993: Call_DnsManagedZonesCreate_593979; project: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          clientOperationId: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dnsManagedZonesCreate
  ## Create a new ManagedZone.
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
  ##   clientOperationId: string
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_593994 = newJObject()
  var query_593995 = newJObject()
  var body_593996 = newJObject()
  add(query_593995, "fields", newJString(fields))
  add(query_593995, "quotaUser", newJString(quotaUser))
  add(query_593995, "alt", newJString(alt))
  add(query_593995, "oauth_token", newJString(oauthToken))
  add(query_593995, "userIp", newJString(userIp))
  add(query_593995, "key", newJString(key))
  add(query_593995, "clientOperationId", newJString(clientOperationId))
  add(path_593994, "project", newJString(project))
  if body != nil:
    body_593996 = body
  add(query_593995, "prettyPrint", newJBool(prettyPrint))
  result = call_593993.call(path_593994, query_593995, nil, nil, body_593996)

var dnsManagedZonesCreate* = Call_DnsManagedZonesCreate_593979(
    name: "dnsManagedZonesCreate", meth: HttpMethod.HttpPost,
    host: "dns.googleapis.com", route: "/{project}/managedZones",
    validator: validate_DnsManagedZonesCreate_593980,
    base: "/dns/v1beta2/projects", url: url_DnsManagedZonesCreate_593981,
    schemes: {Scheme.Https})
type
  Call_DnsManagedZonesList_593961 = ref object of OpenApiRestCall_593408
proc url_DnsManagedZonesList_593963(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/managedZones")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DnsManagedZonesList_593962(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Enumerate ManagedZones that have been created but not yet deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : Identifies the project addressed by this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_593964 = path.getOrDefault("project")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "project", valid_593964
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional. A tag returned by a previous list request that was truncated. Use this parameter to continue a previous list request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   dnsName: JString
  ##          : Restricts the list to return only zones with this domain name.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Optional. Maximum number of results to be returned. If unspecified, the server will decide how many results to return.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593965 = query.getOrDefault("fields")
  valid_593965 = validateParameter(valid_593965, JString, required = false,
                                 default = nil)
  if valid_593965 != nil:
    section.add "fields", valid_593965
  var valid_593966 = query.getOrDefault("pageToken")
  valid_593966 = validateParameter(valid_593966, JString, required = false,
                                 default = nil)
  if valid_593966 != nil:
    section.add "pageToken", valid_593966
  var valid_593967 = query.getOrDefault("quotaUser")
  valid_593967 = validateParameter(valid_593967, JString, required = false,
                                 default = nil)
  if valid_593967 != nil:
    section.add "quotaUser", valid_593967
  var valid_593968 = query.getOrDefault("alt")
  valid_593968 = validateParameter(valid_593968, JString, required = false,
                                 default = newJString("json"))
  if valid_593968 != nil:
    section.add "alt", valid_593968
  var valid_593969 = query.getOrDefault("dnsName")
  valid_593969 = validateParameter(valid_593969, JString, required = false,
                                 default = nil)
  if valid_593969 != nil:
    section.add "dnsName", valid_593969
  var valid_593970 = query.getOrDefault("oauth_token")
  valid_593970 = validateParameter(valid_593970, JString, required = false,
                                 default = nil)
  if valid_593970 != nil:
    section.add "oauth_token", valid_593970
  var valid_593971 = query.getOrDefault("userIp")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = nil)
  if valid_593971 != nil:
    section.add "userIp", valid_593971
  var valid_593972 = query.getOrDefault("maxResults")
  valid_593972 = validateParameter(valid_593972, JInt, required = false, default = nil)
  if valid_593972 != nil:
    section.add "maxResults", valid_593972
  var valid_593973 = query.getOrDefault("key")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = nil)
  if valid_593973 != nil:
    section.add "key", valid_593973
  var valid_593974 = query.getOrDefault("prettyPrint")
  valid_593974 = validateParameter(valid_593974, JBool, required = false,
                                 default = newJBool(true))
  if valid_593974 != nil:
    section.add "prettyPrint", valid_593974
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593975: Call_DnsManagedZonesList_593961; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enumerate ManagedZones that have been created but not yet deleted.
  ## 
  let valid = call_593975.validator(path, query, header, formData, body)
  let scheme = call_593975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593975.url(scheme.get, call_593975.host, call_593975.base,
                         call_593975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593975, url, valid)

proc call*(call_593976: Call_DnsManagedZonesList_593961; project: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; dnsName: string = ""; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## dnsManagedZonesList
  ## Enumerate ManagedZones that have been created but not yet deleted.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. A tag returned by a previous list request that was truncated. Use this parameter to continue a previous list request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   dnsName: string
  ##          : Restricts the list to return only zones with this domain name.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Optional. Maximum number of results to be returned. If unspecified, the server will decide how many results to return.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_593977 = newJObject()
  var query_593978 = newJObject()
  add(query_593978, "fields", newJString(fields))
  add(query_593978, "pageToken", newJString(pageToken))
  add(query_593978, "quotaUser", newJString(quotaUser))
  add(query_593978, "alt", newJString(alt))
  add(query_593978, "dnsName", newJString(dnsName))
  add(query_593978, "oauth_token", newJString(oauthToken))
  add(query_593978, "userIp", newJString(userIp))
  add(query_593978, "maxResults", newJInt(maxResults))
  add(query_593978, "key", newJString(key))
  add(path_593977, "project", newJString(project))
  add(query_593978, "prettyPrint", newJBool(prettyPrint))
  result = call_593976.call(path_593977, query_593978, nil, nil, nil)

var dnsManagedZonesList* = Call_DnsManagedZonesList_593961(
    name: "dnsManagedZonesList", meth: HttpMethod.HttpGet,
    host: "dns.googleapis.com", route: "/{project}/managedZones",
    validator: validate_DnsManagedZonesList_593962, base: "/dns/v1beta2/projects",
    url: url_DnsManagedZonesList_593963, schemes: {Scheme.Https})
type
  Call_DnsManagedZonesUpdate_594014 = ref object of OpenApiRestCall_593408
proc url_DnsManagedZonesUpdate_594016(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "managedZone" in path, "`managedZone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/managedZones/"),
               (kind: VariableSegment, value: "managedZone")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DnsManagedZonesUpdate_594015(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update an existing ManagedZone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managedZone: JString (required)
  ##              : Identifies the managed zone addressed by this request. Can be the managed zone name or id.
  ##   project: JString (required)
  ##          : Identifies the project addressed by this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managedZone` field"
  var valid_594017 = path.getOrDefault("managedZone")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "managedZone", valid_594017
  var valid_594018 = path.getOrDefault("project")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "project", valid_594018
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
  ##   clientOperationId: JString
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594019 = query.getOrDefault("fields")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = nil)
  if valid_594019 != nil:
    section.add "fields", valid_594019
  var valid_594020 = query.getOrDefault("quotaUser")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = nil)
  if valid_594020 != nil:
    section.add "quotaUser", valid_594020
  var valid_594021 = query.getOrDefault("alt")
  valid_594021 = validateParameter(valid_594021, JString, required = false,
                                 default = newJString("json"))
  if valid_594021 != nil:
    section.add "alt", valid_594021
  var valid_594022 = query.getOrDefault("oauth_token")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = nil)
  if valid_594022 != nil:
    section.add "oauth_token", valid_594022
  var valid_594023 = query.getOrDefault("userIp")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = nil)
  if valid_594023 != nil:
    section.add "userIp", valid_594023
  var valid_594024 = query.getOrDefault("key")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = nil)
  if valid_594024 != nil:
    section.add "key", valid_594024
  var valid_594025 = query.getOrDefault("clientOperationId")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "clientOperationId", valid_594025
  var valid_594026 = query.getOrDefault("prettyPrint")
  valid_594026 = validateParameter(valid_594026, JBool, required = false,
                                 default = newJBool(true))
  if valid_594026 != nil:
    section.add "prettyPrint", valid_594026
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

proc call*(call_594028: Call_DnsManagedZonesUpdate_594014; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an existing ManagedZone.
  ## 
  let valid = call_594028.validator(path, query, header, formData, body)
  let scheme = call_594028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594028.url(scheme.get, call_594028.host, call_594028.base,
                         call_594028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594028, url, valid)

proc call*(call_594029: Call_DnsManagedZonesUpdate_594014; managedZone: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; clientOperationId: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dnsManagedZonesUpdate
  ## Update an existing ManagedZone.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   managedZone: string (required)
  ##              : Identifies the managed zone addressed by this request. Can be the managed zone name or id.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   clientOperationId: string
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594030 = newJObject()
  var query_594031 = newJObject()
  var body_594032 = newJObject()
  add(query_594031, "fields", newJString(fields))
  add(query_594031, "quotaUser", newJString(quotaUser))
  add(query_594031, "alt", newJString(alt))
  add(query_594031, "oauth_token", newJString(oauthToken))
  add(path_594030, "managedZone", newJString(managedZone))
  add(query_594031, "userIp", newJString(userIp))
  add(query_594031, "key", newJString(key))
  add(query_594031, "clientOperationId", newJString(clientOperationId))
  add(path_594030, "project", newJString(project))
  if body != nil:
    body_594032 = body
  add(query_594031, "prettyPrint", newJBool(prettyPrint))
  result = call_594029.call(path_594030, query_594031, nil, nil, body_594032)

var dnsManagedZonesUpdate* = Call_DnsManagedZonesUpdate_594014(
    name: "dnsManagedZonesUpdate", meth: HttpMethod.HttpPut,
    host: "dns.googleapis.com", route: "/{project}/managedZones/{managedZone}",
    validator: validate_DnsManagedZonesUpdate_594015,
    base: "/dns/v1beta2/projects", url: url_DnsManagedZonesUpdate_594016,
    schemes: {Scheme.Https})
type
  Call_DnsManagedZonesGet_593997 = ref object of OpenApiRestCall_593408
proc url_DnsManagedZonesGet_593999(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "managedZone" in path, "`managedZone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/managedZones/"),
               (kind: VariableSegment, value: "managedZone")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DnsManagedZonesGet_593998(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Fetch the representation of an existing ManagedZone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managedZone: JString (required)
  ##              : Identifies the managed zone addressed by this request. Can be the managed zone name or id.
  ##   project: JString (required)
  ##          : Identifies the project addressed by this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managedZone` field"
  var valid_594000 = path.getOrDefault("managedZone")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "managedZone", valid_594000
  var valid_594001 = path.getOrDefault("project")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "project", valid_594001
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
  ##   clientOperationId: JString
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594002 = query.getOrDefault("fields")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = nil)
  if valid_594002 != nil:
    section.add "fields", valid_594002
  var valid_594003 = query.getOrDefault("quotaUser")
  valid_594003 = validateParameter(valid_594003, JString, required = false,
                                 default = nil)
  if valid_594003 != nil:
    section.add "quotaUser", valid_594003
  var valid_594004 = query.getOrDefault("alt")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = newJString("json"))
  if valid_594004 != nil:
    section.add "alt", valid_594004
  var valid_594005 = query.getOrDefault("oauth_token")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = nil)
  if valid_594005 != nil:
    section.add "oauth_token", valid_594005
  var valid_594006 = query.getOrDefault("userIp")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "userIp", valid_594006
  var valid_594007 = query.getOrDefault("key")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "key", valid_594007
  var valid_594008 = query.getOrDefault("clientOperationId")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "clientOperationId", valid_594008
  var valid_594009 = query.getOrDefault("prettyPrint")
  valid_594009 = validateParameter(valid_594009, JBool, required = false,
                                 default = newJBool(true))
  if valid_594009 != nil:
    section.add "prettyPrint", valid_594009
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594010: Call_DnsManagedZonesGet_593997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetch the representation of an existing ManagedZone.
  ## 
  let valid = call_594010.validator(path, query, header, formData, body)
  let scheme = call_594010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594010.url(scheme.get, call_594010.host, call_594010.base,
                         call_594010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594010, url, valid)

proc call*(call_594011: Call_DnsManagedZonesGet_593997; managedZone: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; clientOperationId: string = ""; prettyPrint: bool = true): Recallable =
  ## dnsManagedZonesGet
  ## Fetch the representation of an existing ManagedZone.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   managedZone: string (required)
  ##              : Identifies the managed zone addressed by this request. Can be the managed zone name or id.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   clientOperationId: string
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594012 = newJObject()
  var query_594013 = newJObject()
  add(query_594013, "fields", newJString(fields))
  add(query_594013, "quotaUser", newJString(quotaUser))
  add(query_594013, "alt", newJString(alt))
  add(query_594013, "oauth_token", newJString(oauthToken))
  add(path_594012, "managedZone", newJString(managedZone))
  add(query_594013, "userIp", newJString(userIp))
  add(query_594013, "key", newJString(key))
  add(query_594013, "clientOperationId", newJString(clientOperationId))
  add(path_594012, "project", newJString(project))
  add(query_594013, "prettyPrint", newJBool(prettyPrint))
  result = call_594011.call(path_594012, query_594013, nil, nil, nil)

var dnsManagedZonesGet* = Call_DnsManagedZonesGet_593997(
    name: "dnsManagedZonesGet", meth: HttpMethod.HttpGet,
    host: "dns.googleapis.com", route: "/{project}/managedZones/{managedZone}",
    validator: validate_DnsManagedZonesGet_593998, base: "/dns/v1beta2/projects",
    url: url_DnsManagedZonesGet_593999, schemes: {Scheme.Https})
type
  Call_DnsManagedZonesPatch_594050 = ref object of OpenApiRestCall_593408
proc url_DnsManagedZonesPatch_594052(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "managedZone" in path, "`managedZone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/managedZones/"),
               (kind: VariableSegment, value: "managedZone")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DnsManagedZonesPatch_594051(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Apply a partial update to an existing ManagedZone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managedZone: JString (required)
  ##              : Identifies the managed zone addressed by this request. Can be the managed zone name or id.
  ##   project: JString (required)
  ##          : Identifies the project addressed by this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managedZone` field"
  var valid_594053 = path.getOrDefault("managedZone")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "managedZone", valid_594053
  var valid_594054 = path.getOrDefault("project")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "project", valid_594054
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
  ##   clientOperationId: JString
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594055 = query.getOrDefault("fields")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "fields", valid_594055
  var valid_594056 = query.getOrDefault("quotaUser")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = nil)
  if valid_594056 != nil:
    section.add "quotaUser", valid_594056
  var valid_594057 = query.getOrDefault("alt")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = newJString("json"))
  if valid_594057 != nil:
    section.add "alt", valid_594057
  var valid_594058 = query.getOrDefault("oauth_token")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "oauth_token", valid_594058
  var valid_594059 = query.getOrDefault("userIp")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = nil)
  if valid_594059 != nil:
    section.add "userIp", valid_594059
  var valid_594060 = query.getOrDefault("key")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "key", valid_594060
  var valid_594061 = query.getOrDefault("clientOperationId")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "clientOperationId", valid_594061
  var valid_594062 = query.getOrDefault("prettyPrint")
  valid_594062 = validateParameter(valid_594062, JBool, required = false,
                                 default = newJBool(true))
  if valid_594062 != nil:
    section.add "prettyPrint", valid_594062
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

proc call*(call_594064: Call_DnsManagedZonesPatch_594050; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Apply a partial update to an existing ManagedZone.
  ## 
  let valid = call_594064.validator(path, query, header, formData, body)
  let scheme = call_594064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594064.url(scheme.get, call_594064.host, call_594064.base,
                         call_594064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594064, url, valid)

proc call*(call_594065: Call_DnsManagedZonesPatch_594050; managedZone: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; clientOperationId: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dnsManagedZonesPatch
  ## Apply a partial update to an existing ManagedZone.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   managedZone: string (required)
  ##              : Identifies the managed zone addressed by this request. Can be the managed zone name or id.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   clientOperationId: string
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594066 = newJObject()
  var query_594067 = newJObject()
  var body_594068 = newJObject()
  add(query_594067, "fields", newJString(fields))
  add(query_594067, "quotaUser", newJString(quotaUser))
  add(query_594067, "alt", newJString(alt))
  add(query_594067, "oauth_token", newJString(oauthToken))
  add(path_594066, "managedZone", newJString(managedZone))
  add(query_594067, "userIp", newJString(userIp))
  add(query_594067, "key", newJString(key))
  add(query_594067, "clientOperationId", newJString(clientOperationId))
  add(path_594066, "project", newJString(project))
  if body != nil:
    body_594068 = body
  add(query_594067, "prettyPrint", newJBool(prettyPrint))
  result = call_594065.call(path_594066, query_594067, nil, nil, body_594068)

var dnsManagedZonesPatch* = Call_DnsManagedZonesPatch_594050(
    name: "dnsManagedZonesPatch", meth: HttpMethod.HttpPatch,
    host: "dns.googleapis.com", route: "/{project}/managedZones/{managedZone}",
    validator: validate_DnsManagedZonesPatch_594051,
    base: "/dns/v1beta2/projects", url: url_DnsManagedZonesPatch_594052,
    schemes: {Scheme.Https})
type
  Call_DnsManagedZonesDelete_594033 = ref object of OpenApiRestCall_593408
proc url_DnsManagedZonesDelete_594035(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "managedZone" in path, "`managedZone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/managedZones/"),
               (kind: VariableSegment, value: "managedZone")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DnsManagedZonesDelete_594034(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a previously created ManagedZone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managedZone: JString (required)
  ##              : Identifies the managed zone addressed by this request. Can be the managed zone name or id.
  ##   project: JString (required)
  ##          : Identifies the project addressed by this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managedZone` field"
  var valid_594036 = path.getOrDefault("managedZone")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "managedZone", valid_594036
  var valid_594037 = path.getOrDefault("project")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "project", valid_594037
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
  ##   clientOperationId: JString
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594038 = query.getOrDefault("fields")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "fields", valid_594038
  var valid_594039 = query.getOrDefault("quotaUser")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = nil)
  if valid_594039 != nil:
    section.add "quotaUser", valid_594039
  var valid_594040 = query.getOrDefault("alt")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = newJString("json"))
  if valid_594040 != nil:
    section.add "alt", valid_594040
  var valid_594041 = query.getOrDefault("oauth_token")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = nil)
  if valid_594041 != nil:
    section.add "oauth_token", valid_594041
  var valid_594042 = query.getOrDefault("userIp")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = nil)
  if valid_594042 != nil:
    section.add "userIp", valid_594042
  var valid_594043 = query.getOrDefault("key")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = nil)
  if valid_594043 != nil:
    section.add "key", valid_594043
  var valid_594044 = query.getOrDefault("clientOperationId")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = nil)
  if valid_594044 != nil:
    section.add "clientOperationId", valid_594044
  var valid_594045 = query.getOrDefault("prettyPrint")
  valid_594045 = validateParameter(valid_594045, JBool, required = false,
                                 default = newJBool(true))
  if valid_594045 != nil:
    section.add "prettyPrint", valid_594045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594046: Call_DnsManagedZonesDelete_594033; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a previously created ManagedZone.
  ## 
  let valid = call_594046.validator(path, query, header, formData, body)
  let scheme = call_594046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594046.url(scheme.get, call_594046.host, call_594046.base,
                         call_594046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594046, url, valid)

proc call*(call_594047: Call_DnsManagedZonesDelete_594033; managedZone: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; clientOperationId: string = ""; prettyPrint: bool = true): Recallable =
  ## dnsManagedZonesDelete
  ## Delete a previously created ManagedZone.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   managedZone: string (required)
  ##              : Identifies the managed zone addressed by this request. Can be the managed zone name or id.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   clientOperationId: string
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594048 = newJObject()
  var query_594049 = newJObject()
  add(query_594049, "fields", newJString(fields))
  add(query_594049, "quotaUser", newJString(quotaUser))
  add(query_594049, "alt", newJString(alt))
  add(query_594049, "oauth_token", newJString(oauthToken))
  add(path_594048, "managedZone", newJString(managedZone))
  add(query_594049, "userIp", newJString(userIp))
  add(query_594049, "key", newJString(key))
  add(query_594049, "clientOperationId", newJString(clientOperationId))
  add(path_594048, "project", newJString(project))
  add(query_594049, "prettyPrint", newJBool(prettyPrint))
  result = call_594047.call(path_594048, query_594049, nil, nil, nil)

var dnsManagedZonesDelete* = Call_DnsManagedZonesDelete_594033(
    name: "dnsManagedZonesDelete", meth: HttpMethod.HttpDelete,
    host: "dns.googleapis.com", route: "/{project}/managedZones/{managedZone}",
    validator: validate_DnsManagedZonesDelete_594034,
    base: "/dns/v1beta2/projects", url: url_DnsManagedZonesDelete_594035,
    schemes: {Scheme.Https})
type
  Call_DnsChangesCreate_594089 = ref object of OpenApiRestCall_593408
proc url_DnsChangesCreate_594091(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "managedZone" in path, "`managedZone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/managedZones/"),
               (kind: VariableSegment, value: "managedZone"),
               (kind: ConstantSegment, value: "/changes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DnsChangesCreate_594090(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Atomically update the ResourceRecordSet collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managedZone: JString (required)
  ##              : Identifies the managed zone addressed by this request. Can be the managed zone name or id.
  ##   project: JString (required)
  ##          : Identifies the project addressed by this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managedZone` field"
  var valid_594092 = path.getOrDefault("managedZone")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "managedZone", valid_594092
  var valid_594093 = path.getOrDefault("project")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "project", valid_594093
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
  ##   clientOperationId: JString
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594094 = query.getOrDefault("fields")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = nil)
  if valid_594094 != nil:
    section.add "fields", valid_594094
  var valid_594095 = query.getOrDefault("quotaUser")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = nil)
  if valid_594095 != nil:
    section.add "quotaUser", valid_594095
  var valid_594096 = query.getOrDefault("alt")
  valid_594096 = validateParameter(valid_594096, JString, required = false,
                                 default = newJString("json"))
  if valid_594096 != nil:
    section.add "alt", valid_594096
  var valid_594097 = query.getOrDefault("oauth_token")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = nil)
  if valid_594097 != nil:
    section.add "oauth_token", valid_594097
  var valid_594098 = query.getOrDefault("userIp")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "userIp", valid_594098
  var valid_594099 = query.getOrDefault("key")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "key", valid_594099
  var valid_594100 = query.getOrDefault("clientOperationId")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = nil)
  if valid_594100 != nil:
    section.add "clientOperationId", valid_594100
  var valid_594101 = query.getOrDefault("prettyPrint")
  valid_594101 = validateParameter(valid_594101, JBool, required = false,
                                 default = newJBool(true))
  if valid_594101 != nil:
    section.add "prettyPrint", valid_594101
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

proc call*(call_594103: Call_DnsChangesCreate_594089; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Atomically update the ResourceRecordSet collection.
  ## 
  let valid = call_594103.validator(path, query, header, formData, body)
  let scheme = call_594103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594103.url(scheme.get, call_594103.host, call_594103.base,
                         call_594103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594103, url, valid)

proc call*(call_594104: Call_DnsChangesCreate_594089; managedZone: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; clientOperationId: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dnsChangesCreate
  ## Atomically update the ResourceRecordSet collection.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   managedZone: string (required)
  ##              : Identifies the managed zone addressed by this request. Can be the managed zone name or id.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   clientOperationId: string
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594105 = newJObject()
  var query_594106 = newJObject()
  var body_594107 = newJObject()
  add(query_594106, "fields", newJString(fields))
  add(query_594106, "quotaUser", newJString(quotaUser))
  add(query_594106, "alt", newJString(alt))
  add(query_594106, "oauth_token", newJString(oauthToken))
  add(path_594105, "managedZone", newJString(managedZone))
  add(query_594106, "userIp", newJString(userIp))
  add(query_594106, "key", newJString(key))
  add(query_594106, "clientOperationId", newJString(clientOperationId))
  add(path_594105, "project", newJString(project))
  if body != nil:
    body_594107 = body
  add(query_594106, "prettyPrint", newJBool(prettyPrint))
  result = call_594104.call(path_594105, query_594106, nil, nil, body_594107)

var dnsChangesCreate* = Call_DnsChangesCreate_594089(name: "dnsChangesCreate",
    meth: HttpMethod.HttpPost, host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/changes",
    validator: validate_DnsChangesCreate_594090, base: "/dns/v1beta2/projects",
    url: url_DnsChangesCreate_594091, schemes: {Scheme.Https})
type
  Call_DnsChangesList_594069 = ref object of OpenApiRestCall_593408
proc url_DnsChangesList_594071(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "managedZone" in path, "`managedZone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/managedZones/"),
               (kind: VariableSegment, value: "managedZone"),
               (kind: ConstantSegment, value: "/changes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DnsChangesList_594070(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Enumerate Changes to a ResourceRecordSet collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managedZone: JString (required)
  ##              : Identifies the managed zone addressed by this request. Can be the managed zone name or id.
  ##   project: JString (required)
  ##          : Identifies the project addressed by this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managedZone` field"
  var valid_594072 = path.getOrDefault("managedZone")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "managedZone", valid_594072
  var valid_594073 = path.getOrDefault("project")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "project", valid_594073
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional. A tag returned by a previous list request that was truncated. Use this parameter to continue a previous list request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   sortBy: JString
  ##         : Sorting criterion. The only supported value is change sequence.
  ##   maxResults: JInt
  ##             : Optional. Maximum number of results to be returned. If unspecified, the server will decide how many results to return.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   sortOrder: JString
  ##            : Sorting order direction: 'ascending' or 'descending'.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594074 = query.getOrDefault("fields")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = nil)
  if valid_594074 != nil:
    section.add "fields", valid_594074
  var valid_594075 = query.getOrDefault("pageToken")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = nil)
  if valid_594075 != nil:
    section.add "pageToken", valid_594075
  var valid_594076 = query.getOrDefault("quotaUser")
  valid_594076 = validateParameter(valid_594076, JString, required = false,
                                 default = nil)
  if valid_594076 != nil:
    section.add "quotaUser", valid_594076
  var valid_594077 = query.getOrDefault("alt")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = newJString("json"))
  if valid_594077 != nil:
    section.add "alt", valid_594077
  var valid_594078 = query.getOrDefault("oauth_token")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = nil)
  if valid_594078 != nil:
    section.add "oauth_token", valid_594078
  var valid_594079 = query.getOrDefault("userIp")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = nil)
  if valid_594079 != nil:
    section.add "userIp", valid_594079
  var valid_594080 = query.getOrDefault("sortBy")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = newJString("changeSequence"))
  if valid_594080 != nil:
    section.add "sortBy", valid_594080
  var valid_594081 = query.getOrDefault("maxResults")
  valid_594081 = validateParameter(valid_594081, JInt, required = false, default = nil)
  if valid_594081 != nil:
    section.add "maxResults", valid_594081
  var valid_594082 = query.getOrDefault("key")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = nil)
  if valid_594082 != nil:
    section.add "key", valid_594082
  var valid_594083 = query.getOrDefault("sortOrder")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = nil)
  if valid_594083 != nil:
    section.add "sortOrder", valid_594083
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
  if body != nil:
    result.add "body", body

proc call*(call_594085: Call_DnsChangesList_594069; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enumerate Changes to a ResourceRecordSet collection.
  ## 
  let valid = call_594085.validator(path, query, header, formData, body)
  let scheme = call_594085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594085.url(scheme.get, call_594085.host, call_594085.base,
                         call_594085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594085, url, valid)

proc call*(call_594086: Call_DnsChangesList_594069; managedZone: string;
          project: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; sortBy: string = "changeSequence"; maxResults: int = 0;
          key: string = ""; sortOrder: string = ""; prettyPrint: bool = true): Recallable =
  ## dnsChangesList
  ## Enumerate Changes to a ResourceRecordSet collection.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. A tag returned by a previous list request that was truncated. Use this parameter to continue a previous list request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   managedZone: string (required)
  ##              : Identifies the managed zone addressed by this request. Can be the managed zone name or id.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   sortBy: string
  ##         : Sorting criterion. The only supported value is change sequence.
  ##   maxResults: int
  ##             : Optional. Maximum number of results to be returned. If unspecified, the server will decide how many results to return.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   sortOrder: string
  ##            : Sorting order direction: 'ascending' or 'descending'.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594087 = newJObject()
  var query_594088 = newJObject()
  add(query_594088, "fields", newJString(fields))
  add(query_594088, "pageToken", newJString(pageToken))
  add(query_594088, "quotaUser", newJString(quotaUser))
  add(query_594088, "alt", newJString(alt))
  add(query_594088, "oauth_token", newJString(oauthToken))
  add(path_594087, "managedZone", newJString(managedZone))
  add(query_594088, "userIp", newJString(userIp))
  add(query_594088, "sortBy", newJString(sortBy))
  add(query_594088, "maxResults", newJInt(maxResults))
  add(query_594088, "key", newJString(key))
  add(query_594088, "sortOrder", newJString(sortOrder))
  add(path_594087, "project", newJString(project))
  add(query_594088, "prettyPrint", newJBool(prettyPrint))
  result = call_594086.call(path_594087, query_594088, nil, nil, nil)

var dnsChangesList* = Call_DnsChangesList_594069(name: "dnsChangesList",
    meth: HttpMethod.HttpGet, host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/changes",
    validator: validate_DnsChangesList_594070, base: "/dns/v1beta2/projects",
    url: url_DnsChangesList_594071, schemes: {Scheme.Https})
type
  Call_DnsChangesGet_594108 = ref object of OpenApiRestCall_593408
proc url_DnsChangesGet_594110(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "managedZone" in path, "`managedZone` is a required path parameter"
  assert "changeId" in path, "`changeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/managedZones/"),
               (kind: VariableSegment, value: "managedZone"),
               (kind: ConstantSegment, value: "/changes/"),
               (kind: VariableSegment, value: "changeId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DnsChangesGet_594109(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetch the representation of an existing Change.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   changeId: JString (required)
  ##           : The identifier of the requested change, from a previous ResourceRecordSetsChangeResponse.
  ##   managedZone: JString (required)
  ##              : Identifies the managed zone addressed by this request. Can be the managed zone name or id.
  ##   project: JString (required)
  ##          : Identifies the project addressed by this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `changeId` field"
  var valid_594111 = path.getOrDefault("changeId")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "changeId", valid_594111
  var valid_594112 = path.getOrDefault("managedZone")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "managedZone", valid_594112
  var valid_594113 = path.getOrDefault("project")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "project", valid_594113
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
  ##   clientOperationId: JString
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594114 = query.getOrDefault("fields")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = nil)
  if valid_594114 != nil:
    section.add "fields", valid_594114
  var valid_594115 = query.getOrDefault("quotaUser")
  valid_594115 = validateParameter(valid_594115, JString, required = false,
                                 default = nil)
  if valid_594115 != nil:
    section.add "quotaUser", valid_594115
  var valid_594116 = query.getOrDefault("alt")
  valid_594116 = validateParameter(valid_594116, JString, required = false,
                                 default = newJString("json"))
  if valid_594116 != nil:
    section.add "alt", valid_594116
  var valid_594117 = query.getOrDefault("oauth_token")
  valid_594117 = validateParameter(valid_594117, JString, required = false,
                                 default = nil)
  if valid_594117 != nil:
    section.add "oauth_token", valid_594117
  var valid_594118 = query.getOrDefault("userIp")
  valid_594118 = validateParameter(valid_594118, JString, required = false,
                                 default = nil)
  if valid_594118 != nil:
    section.add "userIp", valid_594118
  var valid_594119 = query.getOrDefault("key")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "key", valid_594119
  var valid_594120 = query.getOrDefault("clientOperationId")
  valid_594120 = validateParameter(valid_594120, JString, required = false,
                                 default = nil)
  if valid_594120 != nil:
    section.add "clientOperationId", valid_594120
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
  if body != nil:
    result.add "body", body

proc call*(call_594122: Call_DnsChangesGet_594108; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetch the representation of an existing Change.
  ## 
  let valid = call_594122.validator(path, query, header, formData, body)
  let scheme = call_594122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594122.url(scheme.get, call_594122.host, call_594122.base,
                         call_594122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594122, url, valid)

proc call*(call_594123: Call_DnsChangesGet_594108; changeId: string;
          managedZone: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; clientOperationId: string = "";
          prettyPrint: bool = true): Recallable =
  ## dnsChangesGet
  ## Fetch the representation of an existing Change.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   changeId: string (required)
  ##           : The identifier of the requested change, from a previous ResourceRecordSetsChangeResponse.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   managedZone: string (required)
  ##              : Identifies the managed zone addressed by this request. Can be the managed zone name or id.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   clientOperationId: string
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594124 = newJObject()
  var query_594125 = newJObject()
  add(query_594125, "fields", newJString(fields))
  add(path_594124, "changeId", newJString(changeId))
  add(query_594125, "quotaUser", newJString(quotaUser))
  add(query_594125, "alt", newJString(alt))
  add(query_594125, "oauth_token", newJString(oauthToken))
  add(path_594124, "managedZone", newJString(managedZone))
  add(query_594125, "userIp", newJString(userIp))
  add(query_594125, "key", newJString(key))
  add(query_594125, "clientOperationId", newJString(clientOperationId))
  add(path_594124, "project", newJString(project))
  add(query_594125, "prettyPrint", newJBool(prettyPrint))
  result = call_594123.call(path_594124, query_594125, nil, nil, nil)

var dnsChangesGet* = Call_DnsChangesGet_594108(name: "dnsChangesGet",
    meth: HttpMethod.HttpGet, host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/changes/{changeId}",
    validator: validate_DnsChangesGet_594109, base: "/dns/v1beta2/projects",
    url: url_DnsChangesGet_594110, schemes: {Scheme.Https})
type
  Call_DnsDnsKeysList_594126 = ref object of OpenApiRestCall_593408
proc url_DnsDnsKeysList_594128(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "managedZone" in path, "`managedZone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/managedZones/"),
               (kind: VariableSegment, value: "managedZone"),
               (kind: ConstantSegment, value: "/dnsKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DnsDnsKeysList_594127(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Enumerate DnsKeys to a ResourceRecordSet collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managedZone: JString (required)
  ##              : Identifies the managed zone addressed by this request. Can be the managed zone name or id.
  ##   project: JString (required)
  ##          : Identifies the project addressed by this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managedZone` field"
  var valid_594129 = path.getOrDefault("managedZone")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "managedZone", valid_594129
  var valid_594130 = path.getOrDefault("project")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "project", valid_594130
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional. A tag returned by a previous list request that was truncated. Use this parameter to continue a previous list request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   digestType: JString
  ##             : An optional comma-separated list of digest types to compute and display for key signing keys. If omitted, the recommended digest type will be computed and displayed.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Optional. Maximum number of results to be returned. If unspecified, the server will decide how many results to return.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594131 = query.getOrDefault("fields")
  valid_594131 = validateParameter(valid_594131, JString, required = false,
                                 default = nil)
  if valid_594131 != nil:
    section.add "fields", valid_594131
  var valid_594132 = query.getOrDefault("pageToken")
  valid_594132 = validateParameter(valid_594132, JString, required = false,
                                 default = nil)
  if valid_594132 != nil:
    section.add "pageToken", valid_594132
  var valid_594133 = query.getOrDefault("quotaUser")
  valid_594133 = validateParameter(valid_594133, JString, required = false,
                                 default = nil)
  if valid_594133 != nil:
    section.add "quotaUser", valid_594133
  var valid_594134 = query.getOrDefault("alt")
  valid_594134 = validateParameter(valid_594134, JString, required = false,
                                 default = newJString("json"))
  if valid_594134 != nil:
    section.add "alt", valid_594134
  var valid_594135 = query.getOrDefault("digestType")
  valid_594135 = validateParameter(valid_594135, JString, required = false,
                                 default = nil)
  if valid_594135 != nil:
    section.add "digestType", valid_594135
  var valid_594136 = query.getOrDefault("oauth_token")
  valid_594136 = validateParameter(valid_594136, JString, required = false,
                                 default = nil)
  if valid_594136 != nil:
    section.add "oauth_token", valid_594136
  var valid_594137 = query.getOrDefault("userIp")
  valid_594137 = validateParameter(valid_594137, JString, required = false,
                                 default = nil)
  if valid_594137 != nil:
    section.add "userIp", valid_594137
  var valid_594138 = query.getOrDefault("maxResults")
  valid_594138 = validateParameter(valid_594138, JInt, required = false, default = nil)
  if valid_594138 != nil:
    section.add "maxResults", valid_594138
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
  if body != nil:
    result.add "body", body

proc call*(call_594141: Call_DnsDnsKeysList_594126; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enumerate DnsKeys to a ResourceRecordSet collection.
  ## 
  let valid = call_594141.validator(path, query, header, formData, body)
  let scheme = call_594141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594141.url(scheme.get, call_594141.host, call_594141.base,
                         call_594141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594141, url, valid)

proc call*(call_594142: Call_DnsDnsKeysList_594126; managedZone: string;
          project: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; digestType: string = "";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## dnsDnsKeysList
  ## Enumerate DnsKeys to a ResourceRecordSet collection.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. A tag returned by a previous list request that was truncated. Use this parameter to continue a previous list request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   digestType: string
  ##             : An optional comma-separated list of digest types to compute and display for key signing keys. If omitted, the recommended digest type will be computed and displayed.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   managedZone: string (required)
  ##              : Identifies the managed zone addressed by this request. Can be the managed zone name or id.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Optional. Maximum number of results to be returned. If unspecified, the server will decide how many results to return.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594143 = newJObject()
  var query_594144 = newJObject()
  add(query_594144, "fields", newJString(fields))
  add(query_594144, "pageToken", newJString(pageToken))
  add(query_594144, "quotaUser", newJString(quotaUser))
  add(query_594144, "alt", newJString(alt))
  add(query_594144, "digestType", newJString(digestType))
  add(query_594144, "oauth_token", newJString(oauthToken))
  add(path_594143, "managedZone", newJString(managedZone))
  add(query_594144, "userIp", newJString(userIp))
  add(query_594144, "maxResults", newJInt(maxResults))
  add(query_594144, "key", newJString(key))
  add(path_594143, "project", newJString(project))
  add(query_594144, "prettyPrint", newJBool(prettyPrint))
  result = call_594142.call(path_594143, query_594144, nil, nil, nil)

var dnsDnsKeysList* = Call_DnsDnsKeysList_594126(name: "dnsDnsKeysList",
    meth: HttpMethod.HttpGet, host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/dnsKeys",
    validator: validate_DnsDnsKeysList_594127, base: "/dns/v1beta2/projects",
    url: url_DnsDnsKeysList_594128, schemes: {Scheme.Https})
type
  Call_DnsDnsKeysGet_594145 = ref object of OpenApiRestCall_593408
proc url_DnsDnsKeysGet_594147(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "managedZone" in path, "`managedZone` is a required path parameter"
  assert "dnsKeyId" in path, "`dnsKeyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/managedZones/"),
               (kind: VariableSegment, value: "managedZone"),
               (kind: ConstantSegment, value: "/dnsKeys/"),
               (kind: VariableSegment, value: "dnsKeyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DnsDnsKeysGet_594146(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetch the representation of an existing DnsKey.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dnsKeyId: JString (required)
  ##           : The identifier of the requested DnsKey.
  ##   managedZone: JString (required)
  ##              : Identifies the managed zone addressed by this request. Can be the managed zone name or id.
  ##   project: JString (required)
  ##          : Identifies the project addressed by this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `dnsKeyId` field"
  var valid_594148 = path.getOrDefault("dnsKeyId")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = nil)
  if valid_594148 != nil:
    section.add "dnsKeyId", valid_594148
  var valid_594149 = path.getOrDefault("managedZone")
  valid_594149 = validateParameter(valid_594149, JString, required = true,
                                 default = nil)
  if valid_594149 != nil:
    section.add "managedZone", valid_594149
  var valid_594150 = path.getOrDefault("project")
  valid_594150 = validateParameter(valid_594150, JString, required = true,
                                 default = nil)
  if valid_594150 != nil:
    section.add "project", valid_594150
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   digestType: JString
  ##             : An optional comma-separated list of digest types to compute and display for key signing keys. If omitted, the recommended digest type will be computed and displayed.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   clientOperationId: JString
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594151 = query.getOrDefault("fields")
  valid_594151 = validateParameter(valid_594151, JString, required = false,
                                 default = nil)
  if valid_594151 != nil:
    section.add "fields", valid_594151
  var valid_594152 = query.getOrDefault("quotaUser")
  valid_594152 = validateParameter(valid_594152, JString, required = false,
                                 default = nil)
  if valid_594152 != nil:
    section.add "quotaUser", valid_594152
  var valid_594153 = query.getOrDefault("alt")
  valid_594153 = validateParameter(valid_594153, JString, required = false,
                                 default = newJString("json"))
  if valid_594153 != nil:
    section.add "alt", valid_594153
  var valid_594154 = query.getOrDefault("digestType")
  valid_594154 = validateParameter(valid_594154, JString, required = false,
                                 default = nil)
  if valid_594154 != nil:
    section.add "digestType", valid_594154
  var valid_594155 = query.getOrDefault("oauth_token")
  valid_594155 = validateParameter(valid_594155, JString, required = false,
                                 default = nil)
  if valid_594155 != nil:
    section.add "oauth_token", valid_594155
  var valid_594156 = query.getOrDefault("userIp")
  valid_594156 = validateParameter(valid_594156, JString, required = false,
                                 default = nil)
  if valid_594156 != nil:
    section.add "userIp", valid_594156
  var valid_594157 = query.getOrDefault("key")
  valid_594157 = validateParameter(valid_594157, JString, required = false,
                                 default = nil)
  if valid_594157 != nil:
    section.add "key", valid_594157
  var valid_594158 = query.getOrDefault("clientOperationId")
  valid_594158 = validateParameter(valid_594158, JString, required = false,
                                 default = nil)
  if valid_594158 != nil:
    section.add "clientOperationId", valid_594158
  var valid_594159 = query.getOrDefault("prettyPrint")
  valid_594159 = validateParameter(valid_594159, JBool, required = false,
                                 default = newJBool(true))
  if valid_594159 != nil:
    section.add "prettyPrint", valid_594159
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594160: Call_DnsDnsKeysGet_594145; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetch the representation of an existing DnsKey.
  ## 
  let valid = call_594160.validator(path, query, header, formData, body)
  let scheme = call_594160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594160.url(scheme.get, call_594160.host, call_594160.base,
                         call_594160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594160, url, valid)

proc call*(call_594161: Call_DnsDnsKeysGet_594145; dnsKeyId: string;
          managedZone: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; digestType: string = "";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          clientOperationId: string = ""; prettyPrint: bool = true): Recallable =
  ## dnsDnsKeysGet
  ## Fetch the representation of an existing DnsKey.
  ##   dnsKeyId: string (required)
  ##           : The identifier of the requested DnsKey.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   digestType: string
  ##             : An optional comma-separated list of digest types to compute and display for key signing keys. If omitted, the recommended digest type will be computed and displayed.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   managedZone: string (required)
  ##              : Identifies the managed zone addressed by this request. Can be the managed zone name or id.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   clientOperationId: string
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594162 = newJObject()
  var query_594163 = newJObject()
  add(path_594162, "dnsKeyId", newJString(dnsKeyId))
  add(query_594163, "fields", newJString(fields))
  add(query_594163, "quotaUser", newJString(quotaUser))
  add(query_594163, "alt", newJString(alt))
  add(query_594163, "digestType", newJString(digestType))
  add(query_594163, "oauth_token", newJString(oauthToken))
  add(path_594162, "managedZone", newJString(managedZone))
  add(query_594163, "userIp", newJString(userIp))
  add(query_594163, "key", newJString(key))
  add(query_594163, "clientOperationId", newJString(clientOperationId))
  add(path_594162, "project", newJString(project))
  add(query_594163, "prettyPrint", newJBool(prettyPrint))
  result = call_594161.call(path_594162, query_594163, nil, nil, nil)

var dnsDnsKeysGet* = Call_DnsDnsKeysGet_594145(name: "dnsDnsKeysGet",
    meth: HttpMethod.HttpGet, host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/dnsKeys/{dnsKeyId}",
    validator: validate_DnsDnsKeysGet_594146, base: "/dns/v1beta2/projects",
    url: url_DnsDnsKeysGet_594147, schemes: {Scheme.Https})
type
  Call_DnsManagedZoneOperationsList_594164 = ref object of OpenApiRestCall_593408
proc url_DnsManagedZoneOperationsList_594166(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "managedZone" in path, "`managedZone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/managedZones/"),
               (kind: VariableSegment, value: "managedZone"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DnsManagedZoneOperationsList_594165(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Enumerate Operations for the given ManagedZone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managedZone: JString (required)
  ##              : Identifies the managed zone addressed by this request.
  ##   project: JString (required)
  ##          : Identifies the project addressed by this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managedZone` field"
  var valid_594167 = path.getOrDefault("managedZone")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "managedZone", valid_594167
  var valid_594168 = path.getOrDefault("project")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "project", valid_594168
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional. A tag returned by a previous list request that was truncated. Use this parameter to continue a previous list request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   sortBy: JString
  ##         : Sorting criterion. The only supported values are START_TIME and ID.
  ##   maxResults: JInt
  ##             : Optional. Maximum number of results to be returned. If unspecified, the server will decide how many results to return.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594169 = query.getOrDefault("fields")
  valid_594169 = validateParameter(valid_594169, JString, required = false,
                                 default = nil)
  if valid_594169 != nil:
    section.add "fields", valid_594169
  var valid_594170 = query.getOrDefault("pageToken")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = nil)
  if valid_594170 != nil:
    section.add "pageToken", valid_594170
  var valid_594171 = query.getOrDefault("quotaUser")
  valid_594171 = validateParameter(valid_594171, JString, required = false,
                                 default = nil)
  if valid_594171 != nil:
    section.add "quotaUser", valid_594171
  var valid_594172 = query.getOrDefault("alt")
  valid_594172 = validateParameter(valid_594172, JString, required = false,
                                 default = newJString("json"))
  if valid_594172 != nil:
    section.add "alt", valid_594172
  var valid_594173 = query.getOrDefault("oauth_token")
  valid_594173 = validateParameter(valid_594173, JString, required = false,
                                 default = nil)
  if valid_594173 != nil:
    section.add "oauth_token", valid_594173
  var valid_594174 = query.getOrDefault("userIp")
  valid_594174 = validateParameter(valid_594174, JString, required = false,
                                 default = nil)
  if valid_594174 != nil:
    section.add "userIp", valid_594174
  var valid_594175 = query.getOrDefault("sortBy")
  valid_594175 = validateParameter(valid_594175, JString, required = false,
                                 default = newJString("startTime"))
  if valid_594175 != nil:
    section.add "sortBy", valid_594175
  var valid_594176 = query.getOrDefault("maxResults")
  valid_594176 = validateParameter(valid_594176, JInt, required = false, default = nil)
  if valid_594176 != nil:
    section.add "maxResults", valid_594176
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

proc call*(call_594179: Call_DnsManagedZoneOperationsList_594164; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enumerate Operations for the given ManagedZone.
  ## 
  let valid = call_594179.validator(path, query, header, formData, body)
  let scheme = call_594179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594179.url(scheme.get, call_594179.host, call_594179.base,
                         call_594179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594179, url, valid)

proc call*(call_594180: Call_DnsManagedZoneOperationsList_594164;
          managedZone: string; project: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; sortBy: string = "startTime";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## dnsManagedZoneOperationsList
  ## Enumerate Operations for the given ManagedZone.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. A tag returned by a previous list request that was truncated. Use this parameter to continue a previous list request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   managedZone: string (required)
  ##              : Identifies the managed zone addressed by this request.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   sortBy: string
  ##         : Sorting criterion. The only supported values are START_TIME and ID.
  ##   maxResults: int
  ##             : Optional. Maximum number of results to be returned. If unspecified, the server will decide how many results to return.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594181 = newJObject()
  var query_594182 = newJObject()
  add(query_594182, "fields", newJString(fields))
  add(query_594182, "pageToken", newJString(pageToken))
  add(query_594182, "quotaUser", newJString(quotaUser))
  add(query_594182, "alt", newJString(alt))
  add(query_594182, "oauth_token", newJString(oauthToken))
  add(path_594181, "managedZone", newJString(managedZone))
  add(query_594182, "userIp", newJString(userIp))
  add(query_594182, "sortBy", newJString(sortBy))
  add(query_594182, "maxResults", newJInt(maxResults))
  add(query_594182, "key", newJString(key))
  add(path_594181, "project", newJString(project))
  add(query_594182, "prettyPrint", newJBool(prettyPrint))
  result = call_594180.call(path_594181, query_594182, nil, nil, nil)

var dnsManagedZoneOperationsList* = Call_DnsManagedZoneOperationsList_594164(
    name: "dnsManagedZoneOperationsList", meth: HttpMethod.HttpGet,
    host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/operations",
    validator: validate_DnsManagedZoneOperationsList_594165,
    base: "/dns/v1beta2/projects", url: url_DnsManagedZoneOperationsList_594166,
    schemes: {Scheme.Https})
type
  Call_DnsManagedZoneOperationsGet_594183 = ref object of OpenApiRestCall_593408
proc url_DnsManagedZoneOperationsGet_594185(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "managedZone" in path, "`managedZone` is a required path parameter"
  assert "operation" in path, "`operation` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/managedZones/"),
               (kind: VariableSegment, value: "managedZone"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DnsManagedZoneOperationsGet_594184(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetch the representation of an existing Operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operation: JString (required)
  ##            : Identifies the operation addressed by this request.
  ##   managedZone: JString (required)
  ##              : Identifies the managed zone addressed by this request.
  ##   project: JString (required)
  ##          : Identifies the project addressed by this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `operation` field"
  var valid_594186 = path.getOrDefault("operation")
  valid_594186 = validateParameter(valid_594186, JString, required = true,
                                 default = nil)
  if valid_594186 != nil:
    section.add "operation", valid_594186
  var valid_594187 = path.getOrDefault("managedZone")
  valid_594187 = validateParameter(valid_594187, JString, required = true,
                                 default = nil)
  if valid_594187 != nil:
    section.add "managedZone", valid_594187
  var valid_594188 = path.getOrDefault("project")
  valid_594188 = validateParameter(valid_594188, JString, required = true,
                                 default = nil)
  if valid_594188 != nil:
    section.add "project", valid_594188
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
  ##   clientOperationId: JString
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594189 = query.getOrDefault("fields")
  valid_594189 = validateParameter(valid_594189, JString, required = false,
                                 default = nil)
  if valid_594189 != nil:
    section.add "fields", valid_594189
  var valid_594190 = query.getOrDefault("quotaUser")
  valid_594190 = validateParameter(valid_594190, JString, required = false,
                                 default = nil)
  if valid_594190 != nil:
    section.add "quotaUser", valid_594190
  var valid_594191 = query.getOrDefault("alt")
  valid_594191 = validateParameter(valid_594191, JString, required = false,
                                 default = newJString("json"))
  if valid_594191 != nil:
    section.add "alt", valid_594191
  var valid_594192 = query.getOrDefault("oauth_token")
  valid_594192 = validateParameter(valid_594192, JString, required = false,
                                 default = nil)
  if valid_594192 != nil:
    section.add "oauth_token", valid_594192
  var valid_594193 = query.getOrDefault("userIp")
  valid_594193 = validateParameter(valid_594193, JString, required = false,
                                 default = nil)
  if valid_594193 != nil:
    section.add "userIp", valid_594193
  var valid_594194 = query.getOrDefault("key")
  valid_594194 = validateParameter(valid_594194, JString, required = false,
                                 default = nil)
  if valid_594194 != nil:
    section.add "key", valid_594194
  var valid_594195 = query.getOrDefault("clientOperationId")
  valid_594195 = validateParameter(valid_594195, JString, required = false,
                                 default = nil)
  if valid_594195 != nil:
    section.add "clientOperationId", valid_594195
  var valid_594196 = query.getOrDefault("prettyPrint")
  valid_594196 = validateParameter(valid_594196, JBool, required = false,
                                 default = newJBool(true))
  if valid_594196 != nil:
    section.add "prettyPrint", valid_594196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594197: Call_DnsManagedZoneOperationsGet_594183; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetch the representation of an existing Operation.
  ## 
  let valid = call_594197.validator(path, query, header, formData, body)
  let scheme = call_594197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594197.url(scheme.get, call_594197.host, call_594197.base,
                         call_594197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594197, url, valid)

proc call*(call_594198: Call_DnsManagedZoneOperationsGet_594183; operation: string;
          managedZone: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; clientOperationId: string = "";
          prettyPrint: bool = true): Recallable =
  ## dnsManagedZoneOperationsGet
  ## Fetch the representation of an existing Operation.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   operation: string (required)
  ##            : Identifies the operation addressed by this request.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   managedZone: string (required)
  ##              : Identifies the managed zone addressed by this request.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   clientOperationId: string
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594199 = newJObject()
  var query_594200 = newJObject()
  add(query_594200, "fields", newJString(fields))
  add(query_594200, "quotaUser", newJString(quotaUser))
  add(query_594200, "alt", newJString(alt))
  add(path_594199, "operation", newJString(operation))
  add(query_594200, "oauth_token", newJString(oauthToken))
  add(path_594199, "managedZone", newJString(managedZone))
  add(query_594200, "userIp", newJString(userIp))
  add(query_594200, "key", newJString(key))
  add(query_594200, "clientOperationId", newJString(clientOperationId))
  add(path_594199, "project", newJString(project))
  add(query_594200, "prettyPrint", newJBool(prettyPrint))
  result = call_594198.call(path_594199, query_594200, nil, nil, nil)

var dnsManagedZoneOperationsGet* = Call_DnsManagedZoneOperationsGet_594183(
    name: "dnsManagedZoneOperationsGet", meth: HttpMethod.HttpGet,
    host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/operations/{operation}",
    validator: validate_DnsManagedZoneOperationsGet_594184,
    base: "/dns/v1beta2/projects", url: url_DnsManagedZoneOperationsGet_594185,
    schemes: {Scheme.Https})
type
  Call_DnsResourceRecordSetsList_594201 = ref object of OpenApiRestCall_593408
proc url_DnsResourceRecordSetsList_594203(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "managedZone" in path, "`managedZone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/managedZones/"),
               (kind: VariableSegment, value: "managedZone"),
               (kind: ConstantSegment, value: "/rrsets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DnsResourceRecordSetsList_594202(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Enumerate ResourceRecordSets that have been created but not yet deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managedZone: JString (required)
  ##              : Identifies the managed zone addressed by this request. Can be the managed zone name or id.
  ##   project: JString (required)
  ##          : Identifies the project addressed by this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managedZone` field"
  var valid_594204 = path.getOrDefault("managedZone")
  valid_594204 = validateParameter(valid_594204, JString, required = true,
                                 default = nil)
  if valid_594204 != nil:
    section.add "managedZone", valid_594204
  var valid_594205 = path.getOrDefault("project")
  valid_594205 = validateParameter(valid_594205, JString, required = true,
                                 default = nil)
  if valid_594205 != nil:
    section.add "project", valid_594205
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional. A tag returned by a previous list request that was truncated. Use this parameter to continue a previous list request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   type: JString
  ##       : Restricts the list to return only records of this type. If present, the "name" parameter must also be present.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Optional. Maximum number of results to be returned. If unspecified, the server will decide how many results to return.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: JString
  ##       : Restricts the list to return only records with this fully qualified domain name.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594206 = query.getOrDefault("fields")
  valid_594206 = validateParameter(valid_594206, JString, required = false,
                                 default = nil)
  if valid_594206 != nil:
    section.add "fields", valid_594206
  var valid_594207 = query.getOrDefault("pageToken")
  valid_594207 = validateParameter(valid_594207, JString, required = false,
                                 default = nil)
  if valid_594207 != nil:
    section.add "pageToken", valid_594207
  var valid_594208 = query.getOrDefault("quotaUser")
  valid_594208 = validateParameter(valid_594208, JString, required = false,
                                 default = nil)
  if valid_594208 != nil:
    section.add "quotaUser", valid_594208
  var valid_594209 = query.getOrDefault("alt")
  valid_594209 = validateParameter(valid_594209, JString, required = false,
                                 default = newJString("json"))
  if valid_594209 != nil:
    section.add "alt", valid_594209
  var valid_594210 = query.getOrDefault("type")
  valid_594210 = validateParameter(valid_594210, JString, required = false,
                                 default = nil)
  if valid_594210 != nil:
    section.add "type", valid_594210
  var valid_594211 = query.getOrDefault("oauth_token")
  valid_594211 = validateParameter(valid_594211, JString, required = false,
                                 default = nil)
  if valid_594211 != nil:
    section.add "oauth_token", valid_594211
  var valid_594212 = query.getOrDefault("userIp")
  valid_594212 = validateParameter(valid_594212, JString, required = false,
                                 default = nil)
  if valid_594212 != nil:
    section.add "userIp", valid_594212
  var valid_594213 = query.getOrDefault("maxResults")
  valid_594213 = validateParameter(valid_594213, JInt, required = false, default = nil)
  if valid_594213 != nil:
    section.add "maxResults", valid_594213
  var valid_594214 = query.getOrDefault("key")
  valid_594214 = validateParameter(valid_594214, JString, required = false,
                                 default = nil)
  if valid_594214 != nil:
    section.add "key", valid_594214
  var valid_594215 = query.getOrDefault("name")
  valid_594215 = validateParameter(valid_594215, JString, required = false,
                                 default = nil)
  if valid_594215 != nil:
    section.add "name", valid_594215
  var valid_594216 = query.getOrDefault("prettyPrint")
  valid_594216 = validateParameter(valid_594216, JBool, required = false,
                                 default = newJBool(true))
  if valid_594216 != nil:
    section.add "prettyPrint", valid_594216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594217: Call_DnsResourceRecordSetsList_594201; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enumerate ResourceRecordSets that have been created but not yet deleted.
  ## 
  let valid = call_594217.validator(path, query, header, formData, body)
  let scheme = call_594217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594217.url(scheme.get, call_594217.host, call_594217.base,
                         call_594217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594217, url, valid)

proc call*(call_594218: Call_DnsResourceRecordSetsList_594201; managedZone: string;
          project: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; `type`: string = "";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; name: string = ""; prettyPrint: bool = true): Recallable =
  ## dnsResourceRecordSetsList
  ## Enumerate ResourceRecordSets that have been created but not yet deleted.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. A tag returned by a previous list request that was truncated. Use this parameter to continue a previous list request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   type: string
  ##       : Restricts the list to return only records of this type. If present, the "name" parameter must also be present.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   managedZone: string (required)
  ##              : Identifies the managed zone addressed by this request. Can be the managed zone name or id.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Optional. Maximum number of results to be returned. If unspecified, the server will decide how many results to return.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : Restricts the list to return only records with this fully qualified domain name.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594219 = newJObject()
  var query_594220 = newJObject()
  add(query_594220, "fields", newJString(fields))
  add(query_594220, "pageToken", newJString(pageToken))
  add(query_594220, "quotaUser", newJString(quotaUser))
  add(query_594220, "alt", newJString(alt))
  add(query_594220, "type", newJString(`type`))
  add(query_594220, "oauth_token", newJString(oauthToken))
  add(path_594219, "managedZone", newJString(managedZone))
  add(query_594220, "userIp", newJString(userIp))
  add(query_594220, "maxResults", newJInt(maxResults))
  add(query_594220, "key", newJString(key))
  add(query_594220, "name", newJString(name))
  add(path_594219, "project", newJString(project))
  add(query_594220, "prettyPrint", newJBool(prettyPrint))
  result = call_594218.call(path_594219, query_594220, nil, nil, nil)

var dnsResourceRecordSetsList* = Call_DnsResourceRecordSetsList_594201(
    name: "dnsResourceRecordSetsList", meth: HttpMethod.HttpGet,
    host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/rrsets",
    validator: validate_DnsResourceRecordSetsList_594202,
    base: "/dns/v1beta2/projects", url: url_DnsResourceRecordSetsList_594203,
    schemes: {Scheme.Https})
type
  Call_DnsPoliciesCreate_594238 = ref object of OpenApiRestCall_593408
proc url_DnsPoliciesCreate_594240(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/policies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DnsPoliciesCreate_594239(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Create a new Policy
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : Identifies the project addressed by this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_594241 = path.getOrDefault("project")
  valid_594241 = validateParameter(valid_594241, JString, required = true,
                                 default = nil)
  if valid_594241 != nil:
    section.add "project", valid_594241
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
  ##   clientOperationId: JString
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594242 = query.getOrDefault("fields")
  valid_594242 = validateParameter(valid_594242, JString, required = false,
                                 default = nil)
  if valid_594242 != nil:
    section.add "fields", valid_594242
  var valid_594243 = query.getOrDefault("quotaUser")
  valid_594243 = validateParameter(valid_594243, JString, required = false,
                                 default = nil)
  if valid_594243 != nil:
    section.add "quotaUser", valid_594243
  var valid_594244 = query.getOrDefault("alt")
  valid_594244 = validateParameter(valid_594244, JString, required = false,
                                 default = newJString("json"))
  if valid_594244 != nil:
    section.add "alt", valid_594244
  var valid_594245 = query.getOrDefault("oauth_token")
  valid_594245 = validateParameter(valid_594245, JString, required = false,
                                 default = nil)
  if valid_594245 != nil:
    section.add "oauth_token", valid_594245
  var valid_594246 = query.getOrDefault("userIp")
  valid_594246 = validateParameter(valid_594246, JString, required = false,
                                 default = nil)
  if valid_594246 != nil:
    section.add "userIp", valid_594246
  var valid_594247 = query.getOrDefault("key")
  valid_594247 = validateParameter(valid_594247, JString, required = false,
                                 default = nil)
  if valid_594247 != nil:
    section.add "key", valid_594247
  var valid_594248 = query.getOrDefault("clientOperationId")
  valid_594248 = validateParameter(valid_594248, JString, required = false,
                                 default = nil)
  if valid_594248 != nil:
    section.add "clientOperationId", valid_594248
  var valid_594249 = query.getOrDefault("prettyPrint")
  valid_594249 = validateParameter(valid_594249, JBool, required = false,
                                 default = newJBool(true))
  if valid_594249 != nil:
    section.add "prettyPrint", valid_594249
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

proc call*(call_594251: Call_DnsPoliciesCreate_594238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new Policy
  ## 
  let valid = call_594251.validator(path, query, header, formData, body)
  let scheme = call_594251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594251.url(scheme.get, call_594251.host, call_594251.base,
                         call_594251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594251, url, valid)

proc call*(call_594252: Call_DnsPoliciesCreate_594238; project: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          clientOperationId: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## dnsPoliciesCreate
  ## Create a new Policy
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
  ##   clientOperationId: string
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594253 = newJObject()
  var query_594254 = newJObject()
  var body_594255 = newJObject()
  add(query_594254, "fields", newJString(fields))
  add(query_594254, "quotaUser", newJString(quotaUser))
  add(query_594254, "alt", newJString(alt))
  add(query_594254, "oauth_token", newJString(oauthToken))
  add(query_594254, "userIp", newJString(userIp))
  add(query_594254, "key", newJString(key))
  add(query_594254, "clientOperationId", newJString(clientOperationId))
  add(path_594253, "project", newJString(project))
  if body != nil:
    body_594255 = body
  add(query_594254, "prettyPrint", newJBool(prettyPrint))
  result = call_594252.call(path_594253, query_594254, nil, nil, body_594255)

var dnsPoliciesCreate* = Call_DnsPoliciesCreate_594238(name: "dnsPoliciesCreate",
    meth: HttpMethod.HttpPost, host: "dns.googleapis.com",
    route: "/{project}/policies", validator: validate_DnsPoliciesCreate_594239,
    base: "/dns/v1beta2/projects", url: url_DnsPoliciesCreate_594240,
    schemes: {Scheme.Https})
type
  Call_DnsPoliciesList_594221 = ref object of OpenApiRestCall_593408
proc url_DnsPoliciesList_594223(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/policies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DnsPoliciesList_594222(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Enumerate all Policies associated with a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : Identifies the project addressed by this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_594224 = path.getOrDefault("project")
  valid_594224 = validateParameter(valid_594224, JString, required = true,
                                 default = nil)
  if valid_594224 != nil:
    section.add "project", valid_594224
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional. A tag returned by a previous list request that was truncated. Use this parameter to continue a previous list request.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Optional. Maximum number of results to be returned. If unspecified, the server will decide how many results to return.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594225 = query.getOrDefault("fields")
  valid_594225 = validateParameter(valid_594225, JString, required = false,
                                 default = nil)
  if valid_594225 != nil:
    section.add "fields", valid_594225
  var valid_594226 = query.getOrDefault("pageToken")
  valid_594226 = validateParameter(valid_594226, JString, required = false,
                                 default = nil)
  if valid_594226 != nil:
    section.add "pageToken", valid_594226
  var valid_594227 = query.getOrDefault("quotaUser")
  valid_594227 = validateParameter(valid_594227, JString, required = false,
                                 default = nil)
  if valid_594227 != nil:
    section.add "quotaUser", valid_594227
  var valid_594228 = query.getOrDefault("alt")
  valid_594228 = validateParameter(valid_594228, JString, required = false,
                                 default = newJString("json"))
  if valid_594228 != nil:
    section.add "alt", valid_594228
  var valid_594229 = query.getOrDefault("oauth_token")
  valid_594229 = validateParameter(valid_594229, JString, required = false,
                                 default = nil)
  if valid_594229 != nil:
    section.add "oauth_token", valid_594229
  var valid_594230 = query.getOrDefault("userIp")
  valid_594230 = validateParameter(valid_594230, JString, required = false,
                                 default = nil)
  if valid_594230 != nil:
    section.add "userIp", valid_594230
  var valid_594231 = query.getOrDefault("maxResults")
  valid_594231 = validateParameter(valid_594231, JInt, required = false, default = nil)
  if valid_594231 != nil:
    section.add "maxResults", valid_594231
  var valid_594232 = query.getOrDefault("key")
  valid_594232 = validateParameter(valid_594232, JString, required = false,
                                 default = nil)
  if valid_594232 != nil:
    section.add "key", valid_594232
  var valid_594233 = query.getOrDefault("prettyPrint")
  valid_594233 = validateParameter(valid_594233, JBool, required = false,
                                 default = newJBool(true))
  if valid_594233 != nil:
    section.add "prettyPrint", valid_594233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594234: Call_DnsPoliciesList_594221; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enumerate all Policies associated with a project.
  ## 
  let valid = call_594234.validator(path, query, header, formData, body)
  let scheme = call_594234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594234.url(scheme.get, call_594234.host, call_594234.base,
                         call_594234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594234, url, valid)

proc call*(call_594235: Call_DnsPoliciesList_594221; project: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## dnsPoliciesList
  ## Enumerate all Policies associated with a project.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. A tag returned by a previous list request that was truncated. Use this parameter to continue a previous list request.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Optional. Maximum number of results to be returned. If unspecified, the server will decide how many results to return.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594236 = newJObject()
  var query_594237 = newJObject()
  add(query_594237, "fields", newJString(fields))
  add(query_594237, "pageToken", newJString(pageToken))
  add(query_594237, "quotaUser", newJString(quotaUser))
  add(query_594237, "alt", newJString(alt))
  add(query_594237, "oauth_token", newJString(oauthToken))
  add(query_594237, "userIp", newJString(userIp))
  add(query_594237, "maxResults", newJInt(maxResults))
  add(query_594237, "key", newJString(key))
  add(path_594236, "project", newJString(project))
  add(query_594237, "prettyPrint", newJBool(prettyPrint))
  result = call_594235.call(path_594236, query_594237, nil, nil, nil)

var dnsPoliciesList* = Call_DnsPoliciesList_594221(name: "dnsPoliciesList",
    meth: HttpMethod.HttpGet, host: "dns.googleapis.com",
    route: "/{project}/policies", validator: validate_DnsPoliciesList_594222,
    base: "/dns/v1beta2/projects", url: url_DnsPoliciesList_594223,
    schemes: {Scheme.Https})
type
  Call_DnsPoliciesUpdate_594273 = ref object of OpenApiRestCall_593408
proc url_DnsPoliciesUpdate_594275(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "policy" in path, "`policy` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DnsPoliciesUpdate_594274(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Update an existing Policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policy: JString (required)
  ##         : User given friendly name of the policy addressed by this request.
  ##   project: JString (required)
  ##          : Identifies the project addressed by this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policy` field"
  var valid_594276 = path.getOrDefault("policy")
  valid_594276 = validateParameter(valid_594276, JString, required = true,
                                 default = nil)
  if valid_594276 != nil:
    section.add "policy", valid_594276
  var valid_594277 = path.getOrDefault("project")
  valid_594277 = validateParameter(valid_594277, JString, required = true,
                                 default = nil)
  if valid_594277 != nil:
    section.add "project", valid_594277
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
  ##   clientOperationId: JString
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594278 = query.getOrDefault("fields")
  valid_594278 = validateParameter(valid_594278, JString, required = false,
                                 default = nil)
  if valid_594278 != nil:
    section.add "fields", valid_594278
  var valid_594279 = query.getOrDefault("quotaUser")
  valid_594279 = validateParameter(valid_594279, JString, required = false,
                                 default = nil)
  if valid_594279 != nil:
    section.add "quotaUser", valid_594279
  var valid_594280 = query.getOrDefault("alt")
  valid_594280 = validateParameter(valid_594280, JString, required = false,
                                 default = newJString("json"))
  if valid_594280 != nil:
    section.add "alt", valid_594280
  var valid_594281 = query.getOrDefault("oauth_token")
  valid_594281 = validateParameter(valid_594281, JString, required = false,
                                 default = nil)
  if valid_594281 != nil:
    section.add "oauth_token", valid_594281
  var valid_594282 = query.getOrDefault("userIp")
  valid_594282 = validateParameter(valid_594282, JString, required = false,
                                 default = nil)
  if valid_594282 != nil:
    section.add "userIp", valid_594282
  var valid_594283 = query.getOrDefault("key")
  valid_594283 = validateParameter(valid_594283, JString, required = false,
                                 default = nil)
  if valid_594283 != nil:
    section.add "key", valid_594283
  var valid_594284 = query.getOrDefault("clientOperationId")
  valid_594284 = validateParameter(valid_594284, JString, required = false,
                                 default = nil)
  if valid_594284 != nil:
    section.add "clientOperationId", valid_594284
  var valid_594285 = query.getOrDefault("prettyPrint")
  valid_594285 = validateParameter(valid_594285, JBool, required = false,
                                 default = newJBool(true))
  if valid_594285 != nil:
    section.add "prettyPrint", valid_594285
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

proc call*(call_594287: Call_DnsPoliciesUpdate_594273; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an existing Policy.
  ## 
  let valid = call_594287.validator(path, query, header, formData, body)
  let scheme = call_594287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594287.url(scheme.get, call_594287.host, call_594287.base,
                         call_594287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594287, url, valid)

proc call*(call_594288: Call_DnsPoliciesUpdate_594273; policy: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; clientOperationId: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dnsPoliciesUpdate
  ## Update an existing Policy.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   policy: string (required)
  ##         : User given friendly name of the policy addressed by this request.
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
  ##   clientOperationId: string
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594289 = newJObject()
  var query_594290 = newJObject()
  var body_594291 = newJObject()
  add(query_594290, "fields", newJString(fields))
  add(path_594289, "policy", newJString(policy))
  add(query_594290, "quotaUser", newJString(quotaUser))
  add(query_594290, "alt", newJString(alt))
  add(query_594290, "oauth_token", newJString(oauthToken))
  add(query_594290, "userIp", newJString(userIp))
  add(query_594290, "key", newJString(key))
  add(query_594290, "clientOperationId", newJString(clientOperationId))
  add(path_594289, "project", newJString(project))
  if body != nil:
    body_594291 = body
  add(query_594290, "prettyPrint", newJBool(prettyPrint))
  result = call_594288.call(path_594289, query_594290, nil, nil, body_594291)

var dnsPoliciesUpdate* = Call_DnsPoliciesUpdate_594273(name: "dnsPoliciesUpdate",
    meth: HttpMethod.HttpPut, host: "dns.googleapis.com",
    route: "/{project}/policies/{policy}", validator: validate_DnsPoliciesUpdate_594274,
    base: "/dns/v1beta2/projects", url: url_DnsPoliciesUpdate_594275,
    schemes: {Scheme.Https})
type
  Call_DnsPoliciesGet_594256 = ref object of OpenApiRestCall_593408
proc url_DnsPoliciesGet_594258(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "policy" in path, "`policy` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DnsPoliciesGet_594257(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Fetch the representation of an existing Policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policy: JString (required)
  ##         : User given friendly name of the policy addressed by this request.
  ##   project: JString (required)
  ##          : Identifies the project addressed by this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policy` field"
  var valid_594259 = path.getOrDefault("policy")
  valid_594259 = validateParameter(valid_594259, JString, required = true,
                                 default = nil)
  if valid_594259 != nil:
    section.add "policy", valid_594259
  var valid_594260 = path.getOrDefault("project")
  valid_594260 = validateParameter(valid_594260, JString, required = true,
                                 default = nil)
  if valid_594260 != nil:
    section.add "project", valid_594260
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
  ##   clientOperationId: JString
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594261 = query.getOrDefault("fields")
  valid_594261 = validateParameter(valid_594261, JString, required = false,
                                 default = nil)
  if valid_594261 != nil:
    section.add "fields", valid_594261
  var valid_594262 = query.getOrDefault("quotaUser")
  valid_594262 = validateParameter(valid_594262, JString, required = false,
                                 default = nil)
  if valid_594262 != nil:
    section.add "quotaUser", valid_594262
  var valid_594263 = query.getOrDefault("alt")
  valid_594263 = validateParameter(valid_594263, JString, required = false,
                                 default = newJString("json"))
  if valid_594263 != nil:
    section.add "alt", valid_594263
  var valid_594264 = query.getOrDefault("oauth_token")
  valid_594264 = validateParameter(valid_594264, JString, required = false,
                                 default = nil)
  if valid_594264 != nil:
    section.add "oauth_token", valid_594264
  var valid_594265 = query.getOrDefault("userIp")
  valid_594265 = validateParameter(valid_594265, JString, required = false,
                                 default = nil)
  if valid_594265 != nil:
    section.add "userIp", valid_594265
  var valid_594266 = query.getOrDefault("key")
  valid_594266 = validateParameter(valid_594266, JString, required = false,
                                 default = nil)
  if valid_594266 != nil:
    section.add "key", valid_594266
  var valid_594267 = query.getOrDefault("clientOperationId")
  valid_594267 = validateParameter(valid_594267, JString, required = false,
                                 default = nil)
  if valid_594267 != nil:
    section.add "clientOperationId", valid_594267
  var valid_594268 = query.getOrDefault("prettyPrint")
  valid_594268 = validateParameter(valid_594268, JBool, required = false,
                                 default = newJBool(true))
  if valid_594268 != nil:
    section.add "prettyPrint", valid_594268
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594269: Call_DnsPoliciesGet_594256; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetch the representation of an existing Policy.
  ## 
  let valid = call_594269.validator(path, query, header, formData, body)
  let scheme = call_594269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594269.url(scheme.get, call_594269.host, call_594269.base,
                         call_594269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594269, url, valid)

proc call*(call_594270: Call_DnsPoliciesGet_594256; policy: string; project: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          clientOperationId: string = ""; prettyPrint: bool = true): Recallable =
  ## dnsPoliciesGet
  ## Fetch the representation of an existing Policy.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   policy: string (required)
  ##         : User given friendly name of the policy addressed by this request.
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
  ##   clientOperationId: string
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594271 = newJObject()
  var query_594272 = newJObject()
  add(query_594272, "fields", newJString(fields))
  add(path_594271, "policy", newJString(policy))
  add(query_594272, "quotaUser", newJString(quotaUser))
  add(query_594272, "alt", newJString(alt))
  add(query_594272, "oauth_token", newJString(oauthToken))
  add(query_594272, "userIp", newJString(userIp))
  add(query_594272, "key", newJString(key))
  add(query_594272, "clientOperationId", newJString(clientOperationId))
  add(path_594271, "project", newJString(project))
  add(query_594272, "prettyPrint", newJBool(prettyPrint))
  result = call_594270.call(path_594271, query_594272, nil, nil, nil)

var dnsPoliciesGet* = Call_DnsPoliciesGet_594256(name: "dnsPoliciesGet",
    meth: HttpMethod.HttpGet, host: "dns.googleapis.com",
    route: "/{project}/policies/{policy}", validator: validate_DnsPoliciesGet_594257,
    base: "/dns/v1beta2/projects", url: url_DnsPoliciesGet_594258,
    schemes: {Scheme.Https})
type
  Call_DnsPoliciesPatch_594309 = ref object of OpenApiRestCall_593408
proc url_DnsPoliciesPatch_594311(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "policy" in path, "`policy` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DnsPoliciesPatch_594310(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Apply a partial update to an existing Policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policy: JString (required)
  ##         : User given friendly name of the policy addressed by this request.
  ##   project: JString (required)
  ##          : Identifies the project addressed by this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policy` field"
  var valid_594312 = path.getOrDefault("policy")
  valid_594312 = validateParameter(valid_594312, JString, required = true,
                                 default = nil)
  if valid_594312 != nil:
    section.add "policy", valid_594312
  var valid_594313 = path.getOrDefault("project")
  valid_594313 = validateParameter(valid_594313, JString, required = true,
                                 default = nil)
  if valid_594313 != nil:
    section.add "project", valid_594313
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
  ##   clientOperationId: JString
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594314 = query.getOrDefault("fields")
  valid_594314 = validateParameter(valid_594314, JString, required = false,
                                 default = nil)
  if valid_594314 != nil:
    section.add "fields", valid_594314
  var valid_594315 = query.getOrDefault("quotaUser")
  valid_594315 = validateParameter(valid_594315, JString, required = false,
                                 default = nil)
  if valid_594315 != nil:
    section.add "quotaUser", valid_594315
  var valid_594316 = query.getOrDefault("alt")
  valid_594316 = validateParameter(valid_594316, JString, required = false,
                                 default = newJString("json"))
  if valid_594316 != nil:
    section.add "alt", valid_594316
  var valid_594317 = query.getOrDefault("oauth_token")
  valid_594317 = validateParameter(valid_594317, JString, required = false,
                                 default = nil)
  if valid_594317 != nil:
    section.add "oauth_token", valid_594317
  var valid_594318 = query.getOrDefault("userIp")
  valid_594318 = validateParameter(valid_594318, JString, required = false,
                                 default = nil)
  if valid_594318 != nil:
    section.add "userIp", valid_594318
  var valid_594319 = query.getOrDefault("key")
  valid_594319 = validateParameter(valid_594319, JString, required = false,
                                 default = nil)
  if valid_594319 != nil:
    section.add "key", valid_594319
  var valid_594320 = query.getOrDefault("clientOperationId")
  valid_594320 = validateParameter(valid_594320, JString, required = false,
                                 default = nil)
  if valid_594320 != nil:
    section.add "clientOperationId", valid_594320
  var valid_594321 = query.getOrDefault("prettyPrint")
  valid_594321 = validateParameter(valid_594321, JBool, required = false,
                                 default = newJBool(true))
  if valid_594321 != nil:
    section.add "prettyPrint", valid_594321
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

proc call*(call_594323: Call_DnsPoliciesPatch_594309; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Apply a partial update to an existing Policy.
  ## 
  let valid = call_594323.validator(path, query, header, formData, body)
  let scheme = call_594323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594323.url(scheme.get, call_594323.host, call_594323.base,
                         call_594323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594323, url, valid)

proc call*(call_594324: Call_DnsPoliciesPatch_594309; policy: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; clientOperationId: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## dnsPoliciesPatch
  ## Apply a partial update to an existing Policy.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   policy: string (required)
  ##         : User given friendly name of the policy addressed by this request.
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
  ##   clientOperationId: string
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594325 = newJObject()
  var query_594326 = newJObject()
  var body_594327 = newJObject()
  add(query_594326, "fields", newJString(fields))
  add(path_594325, "policy", newJString(policy))
  add(query_594326, "quotaUser", newJString(quotaUser))
  add(query_594326, "alt", newJString(alt))
  add(query_594326, "oauth_token", newJString(oauthToken))
  add(query_594326, "userIp", newJString(userIp))
  add(query_594326, "key", newJString(key))
  add(query_594326, "clientOperationId", newJString(clientOperationId))
  add(path_594325, "project", newJString(project))
  if body != nil:
    body_594327 = body
  add(query_594326, "prettyPrint", newJBool(prettyPrint))
  result = call_594324.call(path_594325, query_594326, nil, nil, body_594327)

var dnsPoliciesPatch* = Call_DnsPoliciesPatch_594309(name: "dnsPoliciesPatch",
    meth: HttpMethod.HttpPatch, host: "dns.googleapis.com",
    route: "/{project}/policies/{policy}", validator: validate_DnsPoliciesPatch_594310,
    base: "/dns/v1beta2/projects", url: url_DnsPoliciesPatch_594311,
    schemes: {Scheme.Https})
type
  Call_DnsPoliciesDelete_594292 = ref object of OpenApiRestCall_593408
proc url_DnsPoliciesDelete_594294(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "policy" in path, "`policy` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DnsPoliciesDelete_594293(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Delete a previously created Policy. Will fail if the policy is still being referenced by a network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policy: JString (required)
  ##         : User given friendly name of the policy addressed by this request.
  ##   project: JString (required)
  ##          : Identifies the project addressed by this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policy` field"
  var valid_594295 = path.getOrDefault("policy")
  valid_594295 = validateParameter(valid_594295, JString, required = true,
                                 default = nil)
  if valid_594295 != nil:
    section.add "policy", valid_594295
  var valid_594296 = path.getOrDefault("project")
  valid_594296 = validateParameter(valid_594296, JString, required = true,
                                 default = nil)
  if valid_594296 != nil:
    section.add "project", valid_594296
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
  ##   clientOperationId: JString
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594297 = query.getOrDefault("fields")
  valid_594297 = validateParameter(valid_594297, JString, required = false,
                                 default = nil)
  if valid_594297 != nil:
    section.add "fields", valid_594297
  var valid_594298 = query.getOrDefault("quotaUser")
  valid_594298 = validateParameter(valid_594298, JString, required = false,
                                 default = nil)
  if valid_594298 != nil:
    section.add "quotaUser", valid_594298
  var valid_594299 = query.getOrDefault("alt")
  valid_594299 = validateParameter(valid_594299, JString, required = false,
                                 default = newJString("json"))
  if valid_594299 != nil:
    section.add "alt", valid_594299
  var valid_594300 = query.getOrDefault("oauth_token")
  valid_594300 = validateParameter(valid_594300, JString, required = false,
                                 default = nil)
  if valid_594300 != nil:
    section.add "oauth_token", valid_594300
  var valid_594301 = query.getOrDefault("userIp")
  valid_594301 = validateParameter(valid_594301, JString, required = false,
                                 default = nil)
  if valid_594301 != nil:
    section.add "userIp", valid_594301
  var valid_594302 = query.getOrDefault("key")
  valid_594302 = validateParameter(valid_594302, JString, required = false,
                                 default = nil)
  if valid_594302 != nil:
    section.add "key", valid_594302
  var valid_594303 = query.getOrDefault("clientOperationId")
  valid_594303 = validateParameter(valid_594303, JString, required = false,
                                 default = nil)
  if valid_594303 != nil:
    section.add "clientOperationId", valid_594303
  var valid_594304 = query.getOrDefault("prettyPrint")
  valid_594304 = validateParameter(valid_594304, JBool, required = false,
                                 default = newJBool(true))
  if valid_594304 != nil:
    section.add "prettyPrint", valid_594304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594305: Call_DnsPoliciesDelete_594292; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a previously created Policy. Will fail if the policy is still being referenced by a network.
  ## 
  let valid = call_594305.validator(path, query, header, formData, body)
  let scheme = call_594305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594305.url(scheme.get, call_594305.host, call_594305.base,
                         call_594305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594305, url, valid)

proc call*(call_594306: Call_DnsPoliciesDelete_594292; policy: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; clientOperationId: string = ""; prettyPrint: bool = true): Recallable =
  ## dnsPoliciesDelete
  ## Delete a previously created Policy. Will fail if the policy is still being referenced by a network.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   policy: string (required)
  ##         : User given friendly name of the policy addressed by this request.
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
  ##   clientOperationId: string
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594307 = newJObject()
  var query_594308 = newJObject()
  add(query_594308, "fields", newJString(fields))
  add(path_594307, "policy", newJString(policy))
  add(query_594308, "quotaUser", newJString(quotaUser))
  add(query_594308, "alt", newJString(alt))
  add(query_594308, "oauth_token", newJString(oauthToken))
  add(query_594308, "userIp", newJString(userIp))
  add(query_594308, "key", newJString(key))
  add(query_594308, "clientOperationId", newJString(clientOperationId))
  add(path_594307, "project", newJString(project))
  add(query_594308, "prettyPrint", newJBool(prettyPrint))
  result = call_594306.call(path_594307, query_594308, nil, nil, nil)

var dnsPoliciesDelete* = Call_DnsPoliciesDelete_594292(name: "dnsPoliciesDelete",
    meth: HttpMethod.HttpDelete, host: "dns.googleapis.com",
    route: "/{project}/policies/{policy}", validator: validate_DnsPoliciesDelete_594293,
    base: "/dns/v1beta2/projects", url: url_DnsPoliciesDelete_594294,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
