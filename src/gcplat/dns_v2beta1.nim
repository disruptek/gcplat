
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Cloud DNS
## version: v2beta1
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
  gcpServiceName = "dns"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DnsProjectsGet_579676 = ref object of OpenApiRestCall_579408
proc url_DnsProjectsGet_579678(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DnsProjectsGet_579677(path: JsonNode; query: JsonNode;
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
  var valid_579804 = path.getOrDefault("project")
  valid_579804 = validateParameter(valid_579804, JString, required = true,
                                 default = nil)
  if valid_579804 != nil:
    section.add "project", valid_579804
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
  var valid_579824 = query.getOrDefault("clientOperationId")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "clientOperationId", valid_579824
  var valid_579825 = query.getOrDefault("prettyPrint")
  valid_579825 = validateParameter(valid_579825, JBool, required = false,
                                 default = newJBool(true))
  if valid_579825 != nil:
    section.add "prettyPrint", valid_579825
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579848: Call_DnsProjectsGet_579676; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetch the representation of an existing Project.
  ## 
  let valid = call_579848.validator(path, query, header, formData, body)
  let scheme = call_579848.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579848.url(scheme.get, call_579848.host, call_579848.base,
                         call_579848.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579848, url, valid)

proc call*(call_579919: Call_DnsProjectsGet_579676; project: string;
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
  var path_579920 = newJObject()
  var query_579922 = newJObject()
  add(query_579922, "fields", newJString(fields))
  add(query_579922, "quotaUser", newJString(quotaUser))
  add(query_579922, "alt", newJString(alt))
  add(query_579922, "oauth_token", newJString(oauthToken))
  add(query_579922, "userIp", newJString(userIp))
  add(query_579922, "key", newJString(key))
  add(query_579922, "clientOperationId", newJString(clientOperationId))
  add(path_579920, "project", newJString(project))
  add(query_579922, "prettyPrint", newJBool(prettyPrint))
  result = call_579919.call(path_579920, query_579922, nil, nil, nil)

var dnsProjectsGet* = Call_DnsProjectsGet_579676(name: "dnsProjectsGet",
    meth: HttpMethod.HttpGet, host: "dns.googleapis.com", route: "/{project}",
    validator: validate_DnsProjectsGet_579677, base: "/dns/v2beta1/projects",
    url: url_DnsProjectsGet_579678, schemes: {Scheme.Https})
type
  Call_DnsManagedZonesCreate_579979 = ref object of OpenApiRestCall_579408
proc url_DnsManagedZonesCreate_579981(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DnsManagedZonesCreate_579980(path: JsonNode; query: JsonNode;
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
  var valid_579982 = path.getOrDefault("project")
  valid_579982 = validateParameter(valid_579982, JString, required = true,
                                 default = nil)
  if valid_579982 != nil:
    section.add "project", valid_579982
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
  var valid_579987 = query.getOrDefault("userIp")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "userIp", valid_579987
  var valid_579988 = query.getOrDefault("key")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "key", valid_579988
  var valid_579989 = query.getOrDefault("clientOperationId")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "clientOperationId", valid_579989
  var valid_579990 = query.getOrDefault("prettyPrint")
  valid_579990 = validateParameter(valid_579990, JBool, required = false,
                                 default = newJBool(true))
  if valid_579990 != nil:
    section.add "prettyPrint", valid_579990
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

proc call*(call_579992: Call_DnsManagedZonesCreate_579979; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new ManagedZone.
  ## 
  let valid = call_579992.validator(path, query, header, formData, body)
  let scheme = call_579992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579992.url(scheme.get, call_579992.host, call_579992.base,
                         call_579992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579992, url, valid)

proc call*(call_579993: Call_DnsManagedZonesCreate_579979; project: string;
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
  var path_579994 = newJObject()
  var query_579995 = newJObject()
  var body_579996 = newJObject()
  add(query_579995, "fields", newJString(fields))
  add(query_579995, "quotaUser", newJString(quotaUser))
  add(query_579995, "alt", newJString(alt))
  add(query_579995, "oauth_token", newJString(oauthToken))
  add(query_579995, "userIp", newJString(userIp))
  add(query_579995, "key", newJString(key))
  add(query_579995, "clientOperationId", newJString(clientOperationId))
  add(path_579994, "project", newJString(project))
  if body != nil:
    body_579996 = body
  add(query_579995, "prettyPrint", newJBool(prettyPrint))
  result = call_579993.call(path_579994, query_579995, nil, nil, body_579996)

var dnsManagedZonesCreate* = Call_DnsManagedZonesCreate_579979(
    name: "dnsManagedZonesCreate", meth: HttpMethod.HttpPost,
    host: "dns.googleapis.com", route: "/{project}/managedZones",
    validator: validate_DnsManagedZonesCreate_579980,
    base: "/dns/v2beta1/projects", url: url_DnsManagedZonesCreate_579981,
    schemes: {Scheme.Https})
type
  Call_DnsManagedZonesList_579961 = ref object of OpenApiRestCall_579408
proc url_DnsManagedZonesList_579963(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DnsManagedZonesList_579962(path: JsonNode; query: JsonNode;
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
  var valid_579964 = path.getOrDefault("project")
  valid_579964 = validateParameter(valid_579964, JString, required = true,
                                 default = nil)
  if valid_579964 != nil:
    section.add "project", valid_579964
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
  var valid_579965 = query.getOrDefault("fields")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "fields", valid_579965
  var valid_579966 = query.getOrDefault("pageToken")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "pageToken", valid_579966
  var valid_579967 = query.getOrDefault("quotaUser")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "quotaUser", valid_579967
  var valid_579968 = query.getOrDefault("alt")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = newJString("json"))
  if valid_579968 != nil:
    section.add "alt", valid_579968
  var valid_579969 = query.getOrDefault("dnsName")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "dnsName", valid_579969
  var valid_579970 = query.getOrDefault("oauth_token")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "oauth_token", valid_579970
  var valid_579971 = query.getOrDefault("userIp")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "userIp", valid_579971
  var valid_579972 = query.getOrDefault("maxResults")
  valid_579972 = validateParameter(valid_579972, JInt, required = false, default = nil)
  if valid_579972 != nil:
    section.add "maxResults", valid_579972
  var valid_579973 = query.getOrDefault("key")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "key", valid_579973
  var valid_579974 = query.getOrDefault("prettyPrint")
  valid_579974 = validateParameter(valid_579974, JBool, required = false,
                                 default = newJBool(true))
  if valid_579974 != nil:
    section.add "prettyPrint", valid_579974
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579975: Call_DnsManagedZonesList_579961; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enumerate ManagedZones that have been created but not yet deleted.
  ## 
  let valid = call_579975.validator(path, query, header, formData, body)
  let scheme = call_579975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579975.url(scheme.get, call_579975.host, call_579975.base,
                         call_579975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579975, url, valid)

proc call*(call_579976: Call_DnsManagedZonesList_579961; project: string;
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
  var path_579977 = newJObject()
  var query_579978 = newJObject()
  add(query_579978, "fields", newJString(fields))
  add(query_579978, "pageToken", newJString(pageToken))
  add(query_579978, "quotaUser", newJString(quotaUser))
  add(query_579978, "alt", newJString(alt))
  add(query_579978, "dnsName", newJString(dnsName))
  add(query_579978, "oauth_token", newJString(oauthToken))
  add(query_579978, "userIp", newJString(userIp))
  add(query_579978, "maxResults", newJInt(maxResults))
  add(query_579978, "key", newJString(key))
  add(path_579977, "project", newJString(project))
  add(query_579978, "prettyPrint", newJBool(prettyPrint))
  result = call_579976.call(path_579977, query_579978, nil, nil, nil)

var dnsManagedZonesList* = Call_DnsManagedZonesList_579961(
    name: "dnsManagedZonesList", meth: HttpMethod.HttpGet,
    host: "dns.googleapis.com", route: "/{project}/managedZones",
    validator: validate_DnsManagedZonesList_579962, base: "/dns/v2beta1/projects",
    url: url_DnsManagedZonesList_579963, schemes: {Scheme.Https})
type
  Call_DnsManagedZonesUpdate_580014 = ref object of OpenApiRestCall_579408
proc url_DnsManagedZonesUpdate_580016(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DnsManagedZonesUpdate_580015(path: JsonNode; query: JsonNode;
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
  var valid_580017 = path.getOrDefault("managedZone")
  valid_580017 = validateParameter(valid_580017, JString, required = true,
                                 default = nil)
  if valid_580017 != nil:
    section.add "managedZone", valid_580017
  var valid_580018 = path.getOrDefault("project")
  valid_580018 = validateParameter(valid_580018, JString, required = true,
                                 default = nil)
  if valid_580018 != nil:
    section.add "project", valid_580018
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
  var valid_580019 = query.getOrDefault("fields")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "fields", valid_580019
  var valid_580020 = query.getOrDefault("quotaUser")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "quotaUser", valid_580020
  var valid_580021 = query.getOrDefault("alt")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = newJString("json"))
  if valid_580021 != nil:
    section.add "alt", valid_580021
  var valid_580022 = query.getOrDefault("oauth_token")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "oauth_token", valid_580022
  var valid_580023 = query.getOrDefault("userIp")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "userIp", valid_580023
  var valid_580024 = query.getOrDefault("key")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "key", valid_580024
  var valid_580025 = query.getOrDefault("clientOperationId")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "clientOperationId", valid_580025
  var valid_580026 = query.getOrDefault("prettyPrint")
  valid_580026 = validateParameter(valid_580026, JBool, required = false,
                                 default = newJBool(true))
  if valid_580026 != nil:
    section.add "prettyPrint", valid_580026
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

proc call*(call_580028: Call_DnsManagedZonesUpdate_580014; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an existing ManagedZone.
  ## 
  let valid = call_580028.validator(path, query, header, formData, body)
  let scheme = call_580028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580028.url(scheme.get, call_580028.host, call_580028.base,
                         call_580028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580028, url, valid)

proc call*(call_580029: Call_DnsManagedZonesUpdate_580014; managedZone: string;
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
  var path_580030 = newJObject()
  var query_580031 = newJObject()
  var body_580032 = newJObject()
  add(query_580031, "fields", newJString(fields))
  add(query_580031, "quotaUser", newJString(quotaUser))
  add(query_580031, "alt", newJString(alt))
  add(query_580031, "oauth_token", newJString(oauthToken))
  add(path_580030, "managedZone", newJString(managedZone))
  add(query_580031, "userIp", newJString(userIp))
  add(query_580031, "key", newJString(key))
  add(query_580031, "clientOperationId", newJString(clientOperationId))
  add(path_580030, "project", newJString(project))
  if body != nil:
    body_580032 = body
  add(query_580031, "prettyPrint", newJBool(prettyPrint))
  result = call_580029.call(path_580030, query_580031, nil, nil, body_580032)

var dnsManagedZonesUpdate* = Call_DnsManagedZonesUpdate_580014(
    name: "dnsManagedZonesUpdate", meth: HttpMethod.HttpPut,
    host: "dns.googleapis.com", route: "/{project}/managedZones/{managedZone}",
    validator: validate_DnsManagedZonesUpdate_580015,
    base: "/dns/v2beta1/projects", url: url_DnsManagedZonesUpdate_580016,
    schemes: {Scheme.Https})
type
  Call_DnsManagedZonesGet_579997 = ref object of OpenApiRestCall_579408
proc url_DnsManagedZonesGet_579999(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DnsManagedZonesGet_579998(path: JsonNode; query: JsonNode;
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
  var valid_580000 = path.getOrDefault("managedZone")
  valid_580000 = validateParameter(valid_580000, JString, required = true,
                                 default = nil)
  if valid_580000 != nil:
    section.add "managedZone", valid_580000
  var valid_580001 = path.getOrDefault("project")
  valid_580001 = validateParameter(valid_580001, JString, required = true,
                                 default = nil)
  if valid_580001 != nil:
    section.add "project", valid_580001
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
  var valid_580002 = query.getOrDefault("fields")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "fields", valid_580002
  var valid_580003 = query.getOrDefault("quotaUser")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "quotaUser", valid_580003
  var valid_580004 = query.getOrDefault("alt")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = newJString("json"))
  if valid_580004 != nil:
    section.add "alt", valid_580004
  var valid_580005 = query.getOrDefault("oauth_token")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "oauth_token", valid_580005
  var valid_580006 = query.getOrDefault("userIp")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "userIp", valid_580006
  var valid_580007 = query.getOrDefault("key")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "key", valid_580007
  var valid_580008 = query.getOrDefault("clientOperationId")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "clientOperationId", valid_580008
  var valid_580009 = query.getOrDefault("prettyPrint")
  valid_580009 = validateParameter(valid_580009, JBool, required = false,
                                 default = newJBool(true))
  if valid_580009 != nil:
    section.add "prettyPrint", valid_580009
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580010: Call_DnsManagedZonesGet_579997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetch the representation of an existing ManagedZone.
  ## 
  let valid = call_580010.validator(path, query, header, formData, body)
  let scheme = call_580010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580010.url(scheme.get, call_580010.host, call_580010.base,
                         call_580010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580010, url, valid)

proc call*(call_580011: Call_DnsManagedZonesGet_579997; managedZone: string;
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
  var path_580012 = newJObject()
  var query_580013 = newJObject()
  add(query_580013, "fields", newJString(fields))
  add(query_580013, "quotaUser", newJString(quotaUser))
  add(query_580013, "alt", newJString(alt))
  add(query_580013, "oauth_token", newJString(oauthToken))
  add(path_580012, "managedZone", newJString(managedZone))
  add(query_580013, "userIp", newJString(userIp))
  add(query_580013, "key", newJString(key))
  add(query_580013, "clientOperationId", newJString(clientOperationId))
  add(path_580012, "project", newJString(project))
  add(query_580013, "prettyPrint", newJBool(prettyPrint))
  result = call_580011.call(path_580012, query_580013, nil, nil, nil)

var dnsManagedZonesGet* = Call_DnsManagedZonesGet_579997(
    name: "dnsManagedZonesGet", meth: HttpMethod.HttpGet,
    host: "dns.googleapis.com", route: "/{project}/managedZones/{managedZone}",
    validator: validate_DnsManagedZonesGet_579998, base: "/dns/v2beta1/projects",
    url: url_DnsManagedZonesGet_579999, schemes: {Scheme.Https})
type
  Call_DnsManagedZonesPatch_580050 = ref object of OpenApiRestCall_579408
proc url_DnsManagedZonesPatch_580052(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DnsManagedZonesPatch_580051(path: JsonNode; query: JsonNode;
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
  var valid_580053 = path.getOrDefault("managedZone")
  valid_580053 = validateParameter(valid_580053, JString, required = true,
                                 default = nil)
  if valid_580053 != nil:
    section.add "managedZone", valid_580053
  var valid_580054 = path.getOrDefault("project")
  valid_580054 = validateParameter(valid_580054, JString, required = true,
                                 default = nil)
  if valid_580054 != nil:
    section.add "project", valid_580054
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
  var valid_580055 = query.getOrDefault("fields")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "fields", valid_580055
  var valid_580056 = query.getOrDefault("quotaUser")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "quotaUser", valid_580056
  var valid_580057 = query.getOrDefault("alt")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = newJString("json"))
  if valid_580057 != nil:
    section.add "alt", valid_580057
  var valid_580058 = query.getOrDefault("oauth_token")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "oauth_token", valid_580058
  var valid_580059 = query.getOrDefault("userIp")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "userIp", valid_580059
  var valid_580060 = query.getOrDefault("key")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "key", valid_580060
  var valid_580061 = query.getOrDefault("clientOperationId")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "clientOperationId", valid_580061
  var valid_580062 = query.getOrDefault("prettyPrint")
  valid_580062 = validateParameter(valid_580062, JBool, required = false,
                                 default = newJBool(true))
  if valid_580062 != nil:
    section.add "prettyPrint", valid_580062
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

proc call*(call_580064: Call_DnsManagedZonesPatch_580050; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Apply a partial update to an existing ManagedZone.
  ## 
  let valid = call_580064.validator(path, query, header, formData, body)
  let scheme = call_580064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580064.url(scheme.get, call_580064.host, call_580064.base,
                         call_580064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580064, url, valid)

proc call*(call_580065: Call_DnsManagedZonesPatch_580050; managedZone: string;
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
  var path_580066 = newJObject()
  var query_580067 = newJObject()
  var body_580068 = newJObject()
  add(query_580067, "fields", newJString(fields))
  add(query_580067, "quotaUser", newJString(quotaUser))
  add(query_580067, "alt", newJString(alt))
  add(query_580067, "oauth_token", newJString(oauthToken))
  add(path_580066, "managedZone", newJString(managedZone))
  add(query_580067, "userIp", newJString(userIp))
  add(query_580067, "key", newJString(key))
  add(query_580067, "clientOperationId", newJString(clientOperationId))
  add(path_580066, "project", newJString(project))
  if body != nil:
    body_580068 = body
  add(query_580067, "prettyPrint", newJBool(prettyPrint))
  result = call_580065.call(path_580066, query_580067, nil, nil, body_580068)

var dnsManagedZonesPatch* = Call_DnsManagedZonesPatch_580050(
    name: "dnsManagedZonesPatch", meth: HttpMethod.HttpPatch,
    host: "dns.googleapis.com", route: "/{project}/managedZones/{managedZone}",
    validator: validate_DnsManagedZonesPatch_580051,
    base: "/dns/v2beta1/projects", url: url_DnsManagedZonesPatch_580052,
    schemes: {Scheme.Https})
type
  Call_DnsManagedZonesDelete_580033 = ref object of OpenApiRestCall_579408
proc url_DnsManagedZonesDelete_580035(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DnsManagedZonesDelete_580034(path: JsonNode; query: JsonNode;
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
  var valid_580036 = path.getOrDefault("managedZone")
  valid_580036 = validateParameter(valid_580036, JString, required = true,
                                 default = nil)
  if valid_580036 != nil:
    section.add "managedZone", valid_580036
  var valid_580037 = path.getOrDefault("project")
  valid_580037 = validateParameter(valid_580037, JString, required = true,
                                 default = nil)
  if valid_580037 != nil:
    section.add "project", valid_580037
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
  var valid_580038 = query.getOrDefault("fields")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "fields", valid_580038
  var valid_580039 = query.getOrDefault("quotaUser")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "quotaUser", valid_580039
  var valid_580040 = query.getOrDefault("alt")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = newJString("json"))
  if valid_580040 != nil:
    section.add "alt", valid_580040
  var valid_580041 = query.getOrDefault("oauth_token")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "oauth_token", valid_580041
  var valid_580042 = query.getOrDefault("userIp")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "userIp", valid_580042
  var valid_580043 = query.getOrDefault("key")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "key", valid_580043
  var valid_580044 = query.getOrDefault("clientOperationId")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "clientOperationId", valid_580044
  var valid_580045 = query.getOrDefault("prettyPrint")
  valid_580045 = validateParameter(valid_580045, JBool, required = false,
                                 default = newJBool(true))
  if valid_580045 != nil:
    section.add "prettyPrint", valid_580045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580046: Call_DnsManagedZonesDelete_580033; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a previously created ManagedZone.
  ## 
  let valid = call_580046.validator(path, query, header, formData, body)
  let scheme = call_580046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580046.url(scheme.get, call_580046.host, call_580046.base,
                         call_580046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580046, url, valid)

proc call*(call_580047: Call_DnsManagedZonesDelete_580033; managedZone: string;
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
  var path_580048 = newJObject()
  var query_580049 = newJObject()
  add(query_580049, "fields", newJString(fields))
  add(query_580049, "quotaUser", newJString(quotaUser))
  add(query_580049, "alt", newJString(alt))
  add(query_580049, "oauth_token", newJString(oauthToken))
  add(path_580048, "managedZone", newJString(managedZone))
  add(query_580049, "userIp", newJString(userIp))
  add(query_580049, "key", newJString(key))
  add(query_580049, "clientOperationId", newJString(clientOperationId))
  add(path_580048, "project", newJString(project))
  add(query_580049, "prettyPrint", newJBool(prettyPrint))
  result = call_580047.call(path_580048, query_580049, nil, nil, nil)

var dnsManagedZonesDelete* = Call_DnsManagedZonesDelete_580033(
    name: "dnsManagedZonesDelete", meth: HttpMethod.HttpDelete,
    host: "dns.googleapis.com", route: "/{project}/managedZones/{managedZone}",
    validator: validate_DnsManagedZonesDelete_580034,
    base: "/dns/v2beta1/projects", url: url_DnsManagedZonesDelete_580035,
    schemes: {Scheme.Https})
type
  Call_DnsChangesCreate_580089 = ref object of OpenApiRestCall_579408
proc url_DnsChangesCreate_580091(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DnsChangesCreate_580090(path: JsonNode; query: JsonNode;
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
  var valid_580092 = path.getOrDefault("managedZone")
  valid_580092 = validateParameter(valid_580092, JString, required = true,
                                 default = nil)
  if valid_580092 != nil:
    section.add "managedZone", valid_580092
  var valid_580093 = path.getOrDefault("project")
  valid_580093 = validateParameter(valid_580093, JString, required = true,
                                 default = nil)
  if valid_580093 != nil:
    section.add "project", valid_580093
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
  var valid_580094 = query.getOrDefault("fields")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "fields", valid_580094
  var valid_580095 = query.getOrDefault("quotaUser")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "quotaUser", valid_580095
  var valid_580096 = query.getOrDefault("alt")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = newJString("json"))
  if valid_580096 != nil:
    section.add "alt", valid_580096
  var valid_580097 = query.getOrDefault("oauth_token")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "oauth_token", valid_580097
  var valid_580098 = query.getOrDefault("userIp")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "userIp", valid_580098
  var valid_580099 = query.getOrDefault("key")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "key", valid_580099
  var valid_580100 = query.getOrDefault("clientOperationId")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "clientOperationId", valid_580100
  var valid_580101 = query.getOrDefault("prettyPrint")
  valid_580101 = validateParameter(valid_580101, JBool, required = false,
                                 default = newJBool(true))
  if valid_580101 != nil:
    section.add "prettyPrint", valid_580101
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

proc call*(call_580103: Call_DnsChangesCreate_580089; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Atomically update the ResourceRecordSet collection.
  ## 
  let valid = call_580103.validator(path, query, header, formData, body)
  let scheme = call_580103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580103.url(scheme.get, call_580103.host, call_580103.base,
                         call_580103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580103, url, valid)

proc call*(call_580104: Call_DnsChangesCreate_580089; managedZone: string;
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
  var path_580105 = newJObject()
  var query_580106 = newJObject()
  var body_580107 = newJObject()
  add(query_580106, "fields", newJString(fields))
  add(query_580106, "quotaUser", newJString(quotaUser))
  add(query_580106, "alt", newJString(alt))
  add(query_580106, "oauth_token", newJString(oauthToken))
  add(path_580105, "managedZone", newJString(managedZone))
  add(query_580106, "userIp", newJString(userIp))
  add(query_580106, "key", newJString(key))
  add(query_580106, "clientOperationId", newJString(clientOperationId))
  add(path_580105, "project", newJString(project))
  if body != nil:
    body_580107 = body
  add(query_580106, "prettyPrint", newJBool(prettyPrint))
  result = call_580104.call(path_580105, query_580106, nil, nil, body_580107)

var dnsChangesCreate* = Call_DnsChangesCreate_580089(name: "dnsChangesCreate",
    meth: HttpMethod.HttpPost, host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/changes",
    validator: validate_DnsChangesCreate_580090, base: "/dns/v2beta1/projects",
    url: url_DnsChangesCreate_580091, schemes: {Scheme.Https})
type
  Call_DnsChangesList_580069 = ref object of OpenApiRestCall_579408
proc url_DnsChangesList_580071(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DnsChangesList_580070(path: JsonNode; query: JsonNode;
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
  var valid_580072 = path.getOrDefault("managedZone")
  valid_580072 = validateParameter(valid_580072, JString, required = true,
                                 default = nil)
  if valid_580072 != nil:
    section.add "managedZone", valid_580072
  var valid_580073 = path.getOrDefault("project")
  valid_580073 = validateParameter(valid_580073, JString, required = true,
                                 default = nil)
  if valid_580073 != nil:
    section.add "project", valid_580073
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
  var valid_580074 = query.getOrDefault("fields")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "fields", valid_580074
  var valid_580075 = query.getOrDefault("pageToken")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "pageToken", valid_580075
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
  var valid_580080 = query.getOrDefault("sortBy")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = newJString("CHANGE_SEQUENCE"))
  if valid_580080 != nil:
    section.add "sortBy", valid_580080
  var valid_580081 = query.getOrDefault("maxResults")
  valid_580081 = validateParameter(valid_580081, JInt, required = false, default = nil)
  if valid_580081 != nil:
    section.add "maxResults", valid_580081
  var valid_580082 = query.getOrDefault("key")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "key", valid_580082
  var valid_580083 = query.getOrDefault("sortOrder")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "sortOrder", valid_580083
  var valid_580084 = query.getOrDefault("prettyPrint")
  valid_580084 = validateParameter(valid_580084, JBool, required = false,
                                 default = newJBool(true))
  if valid_580084 != nil:
    section.add "prettyPrint", valid_580084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580085: Call_DnsChangesList_580069; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enumerate Changes to a ResourceRecordSet collection.
  ## 
  let valid = call_580085.validator(path, query, header, formData, body)
  let scheme = call_580085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580085.url(scheme.get, call_580085.host, call_580085.base,
                         call_580085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580085, url, valid)

proc call*(call_580086: Call_DnsChangesList_580069; managedZone: string;
          project: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; sortBy: string = "CHANGE_SEQUENCE"; maxResults: int = 0;
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
  var path_580087 = newJObject()
  var query_580088 = newJObject()
  add(query_580088, "fields", newJString(fields))
  add(query_580088, "pageToken", newJString(pageToken))
  add(query_580088, "quotaUser", newJString(quotaUser))
  add(query_580088, "alt", newJString(alt))
  add(query_580088, "oauth_token", newJString(oauthToken))
  add(path_580087, "managedZone", newJString(managedZone))
  add(query_580088, "userIp", newJString(userIp))
  add(query_580088, "sortBy", newJString(sortBy))
  add(query_580088, "maxResults", newJInt(maxResults))
  add(query_580088, "key", newJString(key))
  add(query_580088, "sortOrder", newJString(sortOrder))
  add(path_580087, "project", newJString(project))
  add(query_580088, "prettyPrint", newJBool(prettyPrint))
  result = call_580086.call(path_580087, query_580088, nil, nil, nil)

var dnsChangesList* = Call_DnsChangesList_580069(name: "dnsChangesList",
    meth: HttpMethod.HttpGet, host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/changes",
    validator: validate_DnsChangesList_580070, base: "/dns/v2beta1/projects",
    url: url_DnsChangesList_580071, schemes: {Scheme.Https})
type
  Call_DnsChangesGet_580108 = ref object of OpenApiRestCall_579408
proc url_DnsChangesGet_580110(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DnsChangesGet_580109(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_580111 = path.getOrDefault("changeId")
  valid_580111 = validateParameter(valid_580111, JString, required = true,
                                 default = nil)
  if valid_580111 != nil:
    section.add "changeId", valid_580111
  var valid_580112 = path.getOrDefault("managedZone")
  valid_580112 = validateParameter(valid_580112, JString, required = true,
                                 default = nil)
  if valid_580112 != nil:
    section.add "managedZone", valid_580112
  var valid_580113 = path.getOrDefault("project")
  valid_580113 = validateParameter(valid_580113, JString, required = true,
                                 default = nil)
  if valid_580113 != nil:
    section.add "project", valid_580113
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
  var valid_580114 = query.getOrDefault("fields")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "fields", valid_580114
  var valid_580115 = query.getOrDefault("quotaUser")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "quotaUser", valid_580115
  var valid_580116 = query.getOrDefault("alt")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = newJString("json"))
  if valid_580116 != nil:
    section.add "alt", valid_580116
  var valid_580117 = query.getOrDefault("oauth_token")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "oauth_token", valid_580117
  var valid_580118 = query.getOrDefault("userIp")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "userIp", valid_580118
  var valid_580119 = query.getOrDefault("key")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "key", valid_580119
  var valid_580120 = query.getOrDefault("clientOperationId")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "clientOperationId", valid_580120
  var valid_580121 = query.getOrDefault("prettyPrint")
  valid_580121 = validateParameter(valid_580121, JBool, required = false,
                                 default = newJBool(true))
  if valid_580121 != nil:
    section.add "prettyPrint", valid_580121
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580122: Call_DnsChangesGet_580108; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetch the representation of an existing Change.
  ## 
  let valid = call_580122.validator(path, query, header, formData, body)
  let scheme = call_580122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580122.url(scheme.get, call_580122.host, call_580122.base,
                         call_580122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580122, url, valid)

proc call*(call_580123: Call_DnsChangesGet_580108; changeId: string;
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
  var path_580124 = newJObject()
  var query_580125 = newJObject()
  add(query_580125, "fields", newJString(fields))
  add(path_580124, "changeId", newJString(changeId))
  add(query_580125, "quotaUser", newJString(quotaUser))
  add(query_580125, "alt", newJString(alt))
  add(query_580125, "oauth_token", newJString(oauthToken))
  add(path_580124, "managedZone", newJString(managedZone))
  add(query_580125, "userIp", newJString(userIp))
  add(query_580125, "key", newJString(key))
  add(query_580125, "clientOperationId", newJString(clientOperationId))
  add(path_580124, "project", newJString(project))
  add(query_580125, "prettyPrint", newJBool(prettyPrint))
  result = call_580123.call(path_580124, query_580125, nil, nil, nil)

var dnsChangesGet* = Call_DnsChangesGet_580108(name: "dnsChangesGet",
    meth: HttpMethod.HttpGet, host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/changes/{changeId}",
    validator: validate_DnsChangesGet_580109, base: "/dns/v2beta1/projects",
    url: url_DnsChangesGet_580110, schemes: {Scheme.Https})
type
  Call_DnsDnsKeysList_580126 = ref object of OpenApiRestCall_579408
proc url_DnsDnsKeysList_580128(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DnsDnsKeysList_580127(path: JsonNode; query: JsonNode;
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
  var valid_580129 = path.getOrDefault("managedZone")
  valid_580129 = validateParameter(valid_580129, JString, required = true,
                                 default = nil)
  if valid_580129 != nil:
    section.add "managedZone", valid_580129
  var valid_580130 = path.getOrDefault("project")
  valid_580130 = validateParameter(valid_580130, JString, required = true,
                                 default = nil)
  if valid_580130 != nil:
    section.add "project", valid_580130
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
  var valid_580131 = query.getOrDefault("fields")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "fields", valid_580131
  var valid_580132 = query.getOrDefault("pageToken")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "pageToken", valid_580132
  var valid_580133 = query.getOrDefault("quotaUser")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "quotaUser", valid_580133
  var valid_580134 = query.getOrDefault("alt")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = newJString("json"))
  if valid_580134 != nil:
    section.add "alt", valid_580134
  var valid_580135 = query.getOrDefault("digestType")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "digestType", valid_580135
  var valid_580136 = query.getOrDefault("oauth_token")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "oauth_token", valid_580136
  var valid_580137 = query.getOrDefault("userIp")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "userIp", valid_580137
  var valid_580138 = query.getOrDefault("maxResults")
  valid_580138 = validateParameter(valid_580138, JInt, required = false, default = nil)
  if valid_580138 != nil:
    section.add "maxResults", valid_580138
  var valid_580139 = query.getOrDefault("key")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "key", valid_580139
  var valid_580140 = query.getOrDefault("prettyPrint")
  valid_580140 = validateParameter(valid_580140, JBool, required = false,
                                 default = newJBool(true))
  if valid_580140 != nil:
    section.add "prettyPrint", valid_580140
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580141: Call_DnsDnsKeysList_580126; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enumerate DnsKeys to a ResourceRecordSet collection.
  ## 
  let valid = call_580141.validator(path, query, header, formData, body)
  let scheme = call_580141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580141.url(scheme.get, call_580141.host, call_580141.base,
                         call_580141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580141, url, valid)

proc call*(call_580142: Call_DnsDnsKeysList_580126; managedZone: string;
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
  var path_580143 = newJObject()
  var query_580144 = newJObject()
  add(query_580144, "fields", newJString(fields))
  add(query_580144, "pageToken", newJString(pageToken))
  add(query_580144, "quotaUser", newJString(quotaUser))
  add(query_580144, "alt", newJString(alt))
  add(query_580144, "digestType", newJString(digestType))
  add(query_580144, "oauth_token", newJString(oauthToken))
  add(path_580143, "managedZone", newJString(managedZone))
  add(query_580144, "userIp", newJString(userIp))
  add(query_580144, "maxResults", newJInt(maxResults))
  add(query_580144, "key", newJString(key))
  add(path_580143, "project", newJString(project))
  add(query_580144, "prettyPrint", newJBool(prettyPrint))
  result = call_580142.call(path_580143, query_580144, nil, nil, nil)

var dnsDnsKeysList* = Call_DnsDnsKeysList_580126(name: "dnsDnsKeysList",
    meth: HttpMethod.HttpGet, host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/dnsKeys",
    validator: validate_DnsDnsKeysList_580127, base: "/dns/v2beta1/projects",
    url: url_DnsDnsKeysList_580128, schemes: {Scheme.Https})
type
  Call_DnsDnsKeysGet_580145 = ref object of OpenApiRestCall_579408
proc url_DnsDnsKeysGet_580147(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DnsDnsKeysGet_580146(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_580148 = path.getOrDefault("dnsKeyId")
  valid_580148 = validateParameter(valid_580148, JString, required = true,
                                 default = nil)
  if valid_580148 != nil:
    section.add "dnsKeyId", valid_580148
  var valid_580149 = path.getOrDefault("managedZone")
  valid_580149 = validateParameter(valid_580149, JString, required = true,
                                 default = nil)
  if valid_580149 != nil:
    section.add "managedZone", valid_580149
  var valid_580150 = path.getOrDefault("project")
  valid_580150 = validateParameter(valid_580150, JString, required = true,
                                 default = nil)
  if valid_580150 != nil:
    section.add "project", valid_580150
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
  var valid_580151 = query.getOrDefault("fields")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "fields", valid_580151
  var valid_580152 = query.getOrDefault("quotaUser")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "quotaUser", valid_580152
  var valid_580153 = query.getOrDefault("alt")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = newJString("json"))
  if valid_580153 != nil:
    section.add "alt", valid_580153
  var valid_580154 = query.getOrDefault("digestType")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "digestType", valid_580154
  var valid_580155 = query.getOrDefault("oauth_token")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "oauth_token", valid_580155
  var valid_580156 = query.getOrDefault("userIp")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "userIp", valid_580156
  var valid_580157 = query.getOrDefault("key")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "key", valid_580157
  var valid_580158 = query.getOrDefault("clientOperationId")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "clientOperationId", valid_580158
  var valid_580159 = query.getOrDefault("prettyPrint")
  valid_580159 = validateParameter(valid_580159, JBool, required = false,
                                 default = newJBool(true))
  if valid_580159 != nil:
    section.add "prettyPrint", valid_580159
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580160: Call_DnsDnsKeysGet_580145; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetch the representation of an existing DnsKey.
  ## 
  let valid = call_580160.validator(path, query, header, formData, body)
  let scheme = call_580160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580160.url(scheme.get, call_580160.host, call_580160.base,
                         call_580160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580160, url, valid)

proc call*(call_580161: Call_DnsDnsKeysGet_580145; dnsKeyId: string;
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
  var path_580162 = newJObject()
  var query_580163 = newJObject()
  add(path_580162, "dnsKeyId", newJString(dnsKeyId))
  add(query_580163, "fields", newJString(fields))
  add(query_580163, "quotaUser", newJString(quotaUser))
  add(query_580163, "alt", newJString(alt))
  add(query_580163, "digestType", newJString(digestType))
  add(query_580163, "oauth_token", newJString(oauthToken))
  add(path_580162, "managedZone", newJString(managedZone))
  add(query_580163, "userIp", newJString(userIp))
  add(query_580163, "key", newJString(key))
  add(query_580163, "clientOperationId", newJString(clientOperationId))
  add(path_580162, "project", newJString(project))
  add(query_580163, "prettyPrint", newJBool(prettyPrint))
  result = call_580161.call(path_580162, query_580163, nil, nil, nil)

var dnsDnsKeysGet* = Call_DnsDnsKeysGet_580145(name: "dnsDnsKeysGet",
    meth: HttpMethod.HttpGet, host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/dnsKeys/{dnsKeyId}",
    validator: validate_DnsDnsKeysGet_580146, base: "/dns/v2beta1/projects",
    url: url_DnsDnsKeysGet_580147, schemes: {Scheme.Https})
type
  Call_DnsManagedZoneOperationsList_580164 = ref object of OpenApiRestCall_579408
proc url_DnsManagedZoneOperationsList_580166(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DnsManagedZoneOperationsList_580165(path: JsonNode; query: JsonNode;
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
  var valid_580167 = path.getOrDefault("managedZone")
  valid_580167 = validateParameter(valid_580167, JString, required = true,
                                 default = nil)
  if valid_580167 != nil:
    section.add "managedZone", valid_580167
  var valid_580168 = path.getOrDefault("project")
  valid_580168 = validateParameter(valid_580168, JString, required = true,
                                 default = nil)
  if valid_580168 != nil:
    section.add "project", valid_580168
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
  var valid_580169 = query.getOrDefault("fields")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "fields", valid_580169
  var valid_580170 = query.getOrDefault("pageToken")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "pageToken", valid_580170
  var valid_580171 = query.getOrDefault("quotaUser")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "quotaUser", valid_580171
  var valid_580172 = query.getOrDefault("alt")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = newJString("json"))
  if valid_580172 != nil:
    section.add "alt", valid_580172
  var valid_580173 = query.getOrDefault("oauth_token")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "oauth_token", valid_580173
  var valid_580174 = query.getOrDefault("userIp")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "userIp", valid_580174
  var valid_580175 = query.getOrDefault("sortBy")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = newJString("START_TIME"))
  if valid_580175 != nil:
    section.add "sortBy", valid_580175
  var valid_580176 = query.getOrDefault("maxResults")
  valid_580176 = validateParameter(valid_580176, JInt, required = false, default = nil)
  if valid_580176 != nil:
    section.add "maxResults", valid_580176
  var valid_580177 = query.getOrDefault("key")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "key", valid_580177
  var valid_580178 = query.getOrDefault("prettyPrint")
  valid_580178 = validateParameter(valid_580178, JBool, required = false,
                                 default = newJBool(true))
  if valid_580178 != nil:
    section.add "prettyPrint", valid_580178
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580179: Call_DnsManagedZoneOperationsList_580164; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enumerate Operations for the given ManagedZone.
  ## 
  let valid = call_580179.validator(path, query, header, formData, body)
  let scheme = call_580179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580179.url(scheme.get, call_580179.host, call_580179.base,
                         call_580179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580179, url, valid)

proc call*(call_580180: Call_DnsManagedZoneOperationsList_580164;
          managedZone: string; project: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; sortBy: string = "START_TIME";
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
  var path_580181 = newJObject()
  var query_580182 = newJObject()
  add(query_580182, "fields", newJString(fields))
  add(query_580182, "pageToken", newJString(pageToken))
  add(query_580182, "quotaUser", newJString(quotaUser))
  add(query_580182, "alt", newJString(alt))
  add(query_580182, "oauth_token", newJString(oauthToken))
  add(path_580181, "managedZone", newJString(managedZone))
  add(query_580182, "userIp", newJString(userIp))
  add(query_580182, "sortBy", newJString(sortBy))
  add(query_580182, "maxResults", newJInt(maxResults))
  add(query_580182, "key", newJString(key))
  add(path_580181, "project", newJString(project))
  add(query_580182, "prettyPrint", newJBool(prettyPrint))
  result = call_580180.call(path_580181, query_580182, nil, nil, nil)

var dnsManagedZoneOperationsList* = Call_DnsManagedZoneOperationsList_580164(
    name: "dnsManagedZoneOperationsList", meth: HttpMethod.HttpGet,
    host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/operations",
    validator: validate_DnsManagedZoneOperationsList_580165,
    base: "/dns/v2beta1/projects", url: url_DnsManagedZoneOperationsList_580166,
    schemes: {Scheme.Https})
type
  Call_DnsManagedZoneOperationsGet_580183 = ref object of OpenApiRestCall_579408
proc url_DnsManagedZoneOperationsGet_580185(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DnsManagedZoneOperationsGet_580184(path: JsonNode; query: JsonNode;
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
  var valid_580186 = path.getOrDefault("operation")
  valid_580186 = validateParameter(valid_580186, JString, required = true,
                                 default = nil)
  if valid_580186 != nil:
    section.add "operation", valid_580186
  var valid_580187 = path.getOrDefault("managedZone")
  valid_580187 = validateParameter(valid_580187, JString, required = true,
                                 default = nil)
  if valid_580187 != nil:
    section.add "managedZone", valid_580187
  var valid_580188 = path.getOrDefault("project")
  valid_580188 = validateParameter(valid_580188, JString, required = true,
                                 default = nil)
  if valid_580188 != nil:
    section.add "project", valid_580188
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
  var valid_580189 = query.getOrDefault("fields")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "fields", valid_580189
  var valid_580190 = query.getOrDefault("quotaUser")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "quotaUser", valid_580190
  var valid_580191 = query.getOrDefault("alt")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = newJString("json"))
  if valid_580191 != nil:
    section.add "alt", valid_580191
  var valid_580192 = query.getOrDefault("oauth_token")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "oauth_token", valid_580192
  var valid_580193 = query.getOrDefault("userIp")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "userIp", valid_580193
  var valid_580194 = query.getOrDefault("key")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "key", valid_580194
  var valid_580195 = query.getOrDefault("clientOperationId")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "clientOperationId", valid_580195
  var valid_580196 = query.getOrDefault("prettyPrint")
  valid_580196 = validateParameter(valid_580196, JBool, required = false,
                                 default = newJBool(true))
  if valid_580196 != nil:
    section.add "prettyPrint", valid_580196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580197: Call_DnsManagedZoneOperationsGet_580183; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetch the representation of an existing Operation.
  ## 
  let valid = call_580197.validator(path, query, header, formData, body)
  let scheme = call_580197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580197.url(scheme.get, call_580197.host, call_580197.base,
                         call_580197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580197, url, valid)

proc call*(call_580198: Call_DnsManagedZoneOperationsGet_580183; operation: string;
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
  var path_580199 = newJObject()
  var query_580200 = newJObject()
  add(query_580200, "fields", newJString(fields))
  add(query_580200, "quotaUser", newJString(quotaUser))
  add(query_580200, "alt", newJString(alt))
  add(path_580199, "operation", newJString(operation))
  add(query_580200, "oauth_token", newJString(oauthToken))
  add(path_580199, "managedZone", newJString(managedZone))
  add(query_580200, "userIp", newJString(userIp))
  add(query_580200, "key", newJString(key))
  add(query_580200, "clientOperationId", newJString(clientOperationId))
  add(path_580199, "project", newJString(project))
  add(query_580200, "prettyPrint", newJBool(prettyPrint))
  result = call_580198.call(path_580199, query_580200, nil, nil, nil)

var dnsManagedZoneOperationsGet* = Call_DnsManagedZoneOperationsGet_580183(
    name: "dnsManagedZoneOperationsGet", meth: HttpMethod.HttpGet,
    host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/operations/{operation}",
    validator: validate_DnsManagedZoneOperationsGet_580184,
    base: "/dns/v2beta1/projects", url: url_DnsManagedZoneOperationsGet_580185,
    schemes: {Scheme.Https})
type
  Call_DnsResourceRecordSetsList_580201 = ref object of OpenApiRestCall_579408
proc url_DnsResourceRecordSetsList_580203(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DnsResourceRecordSetsList_580202(path: JsonNode; query: JsonNode;
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
  var valid_580204 = path.getOrDefault("managedZone")
  valid_580204 = validateParameter(valid_580204, JString, required = true,
                                 default = nil)
  if valid_580204 != nil:
    section.add "managedZone", valid_580204
  var valid_580205 = path.getOrDefault("project")
  valid_580205 = validateParameter(valid_580205, JString, required = true,
                                 default = nil)
  if valid_580205 != nil:
    section.add "project", valid_580205
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
  var valid_580206 = query.getOrDefault("fields")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "fields", valid_580206
  var valid_580207 = query.getOrDefault("pageToken")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "pageToken", valid_580207
  var valid_580208 = query.getOrDefault("quotaUser")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "quotaUser", valid_580208
  var valid_580209 = query.getOrDefault("alt")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = newJString("json"))
  if valid_580209 != nil:
    section.add "alt", valid_580209
  var valid_580210 = query.getOrDefault("type")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "type", valid_580210
  var valid_580211 = query.getOrDefault("oauth_token")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "oauth_token", valid_580211
  var valid_580212 = query.getOrDefault("userIp")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "userIp", valid_580212
  var valid_580213 = query.getOrDefault("maxResults")
  valid_580213 = validateParameter(valid_580213, JInt, required = false, default = nil)
  if valid_580213 != nil:
    section.add "maxResults", valid_580213
  var valid_580214 = query.getOrDefault("key")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "key", valid_580214
  var valid_580215 = query.getOrDefault("name")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "name", valid_580215
  var valid_580216 = query.getOrDefault("prettyPrint")
  valid_580216 = validateParameter(valid_580216, JBool, required = false,
                                 default = newJBool(true))
  if valid_580216 != nil:
    section.add "prettyPrint", valid_580216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580217: Call_DnsResourceRecordSetsList_580201; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enumerate ResourceRecordSets that have been created but not yet deleted.
  ## 
  let valid = call_580217.validator(path, query, header, formData, body)
  let scheme = call_580217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580217.url(scheme.get, call_580217.host, call_580217.base,
                         call_580217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580217, url, valid)

proc call*(call_580218: Call_DnsResourceRecordSetsList_580201; managedZone: string;
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
  var path_580219 = newJObject()
  var query_580220 = newJObject()
  add(query_580220, "fields", newJString(fields))
  add(query_580220, "pageToken", newJString(pageToken))
  add(query_580220, "quotaUser", newJString(quotaUser))
  add(query_580220, "alt", newJString(alt))
  add(query_580220, "type", newJString(`type`))
  add(query_580220, "oauth_token", newJString(oauthToken))
  add(path_580219, "managedZone", newJString(managedZone))
  add(query_580220, "userIp", newJString(userIp))
  add(query_580220, "maxResults", newJInt(maxResults))
  add(query_580220, "key", newJString(key))
  add(query_580220, "name", newJString(name))
  add(path_580219, "project", newJString(project))
  add(query_580220, "prettyPrint", newJBool(prettyPrint))
  result = call_580218.call(path_580219, query_580220, nil, nil, nil)

var dnsResourceRecordSetsList* = Call_DnsResourceRecordSetsList_580201(
    name: "dnsResourceRecordSetsList", meth: HttpMethod.HttpGet,
    host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/rrsets",
    validator: validate_DnsResourceRecordSetsList_580202,
    base: "/dns/v2beta1/projects", url: url_DnsResourceRecordSetsList_580203,
    schemes: {Scheme.Https})
type
  Call_DnsPoliciesCreate_580238 = ref object of OpenApiRestCall_579408
proc url_DnsPoliciesCreate_580240(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DnsPoliciesCreate_580239(path: JsonNode; query: JsonNode;
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
  var valid_580241 = path.getOrDefault("project")
  valid_580241 = validateParameter(valid_580241, JString, required = true,
                                 default = nil)
  if valid_580241 != nil:
    section.add "project", valid_580241
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
  var valid_580242 = query.getOrDefault("fields")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "fields", valid_580242
  var valid_580243 = query.getOrDefault("quotaUser")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "quotaUser", valid_580243
  var valid_580244 = query.getOrDefault("alt")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = newJString("json"))
  if valid_580244 != nil:
    section.add "alt", valid_580244
  var valid_580245 = query.getOrDefault("oauth_token")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "oauth_token", valid_580245
  var valid_580246 = query.getOrDefault("userIp")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "userIp", valid_580246
  var valid_580247 = query.getOrDefault("key")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "key", valid_580247
  var valid_580248 = query.getOrDefault("clientOperationId")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "clientOperationId", valid_580248
  var valid_580249 = query.getOrDefault("prettyPrint")
  valid_580249 = validateParameter(valid_580249, JBool, required = false,
                                 default = newJBool(true))
  if valid_580249 != nil:
    section.add "prettyPrint", valid_580249
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

proc call*(call_580251: Call_DnsPoliciesCreate_580238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new Policy
  ## 
  let valid = call_580251.validator(path, query, header, formData, body)
  let scheme = call_580251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580251.url(scheme.get, call_580251.host, call_580251.base,
                         call_580251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580251, url, valid)

proc call*(call_580252: Call_DnsPoliciesCreate_580238; project: string;
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
  var path_580253 = newJObject()
  var query_580254 = newJObject()
  var body_580255 = newJObject()
  add(query_580254, "fields", newJString(fields))
  add(query_580254, "quotaUser", newJString(quotaUser))
  add(query_580254, "alt", newJString(alt))
  add(query_580254, "oauth_token", newJString(oauthToken))
  add(query_580254, "userIp", newJString(userIp))
  add(query_580254, "key", newJString(key))
  add(query_580254, "clientOperationId", newJString(clientOperationId))
  add(path_580253, "project", newJString(project))
  if body != nil:
    body_580255 = body
  add(query_580254, "prettyPrint", newJBool(prettyPrint))
  result = call_580252.call(path_580253, query_580254, nil, nil, body_580255)

var dnsPoliciesCreate* = Call_DnsPoliciesCreate_580238(name: "dnsPoliciesCreate",
    meth: HttpMethod.HttpPost, host: "dns.googleapis.com",
    route: "/{project}/policies", validator: validate_DnsPoliciesCreate_580239,
    base: "/dns/v2beta1/projects", url: url_DnsPoliciesCreate_580240,
    schemes: {Scheme.Https})
type
  Call_DnsPoliciesList_580221 = ref object of OpenApiRestCall_579408
proc url_DnsPoliciesList_580223(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DnsPoliciesList_580222(path: JsonNode; query: JsonNode;
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
  var valid_580224 = path.getOrDefault("project")
  valid_580224 = validateParameter(valid_580224, JString, required = true,
                                 default = nil)
  if valid_580224 != nil:
    section.add "project", valid_580224
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
  var valid_580225 = query.getOrDefault("fields")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "fields", valid_580225
  var valid_580226 = query.getOrDefault("pageToken")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "pageToken", valid_580226
  var valid_580227 = query.getOrDefault("quotaUser")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "quotaUser", valid_580227
  var valid_580228 = query.getOrDefault("alt")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = newJString("json"))
  if valid_580228 != nil:
    section.add "alt", valid_580228
  var valid_580229 = query.getOrDefault("oauth_token")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "oauth_token", valid_580229
  var valid_580230 = query.getOrDefault("userIp")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "userIp", valid_580230
  var valid_580231 = query.getOrDefault("maxResults")
  valid_580231 = validateParameter(valid_580231, JInt, required = false, default = nil)
  if valid_580231 != nil:
    section.add "maxResults", valid_580231
  var valid_580232 = query.getOrDefault("key")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "key", valid_580232
  var valid_580233 = query.getOrDefault("prettyPrint")
  valid_580233 = validateParameter(valid_580233, JBool, required = false,
                                 default = newJBool(true))
  if valid_580233 != nil:
    section.add "prettyPrint", valid_580233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580234: Call_DnsPoliciesList_580221; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enumerate all Policies associated with a project.
  ## 
  let valid = call_580234.validator(path, query, header, formData, body)
  let scheme = call_580234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580234.url(scheme.get, call_580234.host, call_580234.base,
                         call_580234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580234, url, valid)

proc call*(call_580235: Call_DnsPoliciesList_580221; project: string;
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
  var path_580236 = newJObject()
  var query_580237 = newJObject()
  add(query_580237, "fields", newJString(fields))
  add(query_580237, "pageToken", newJString(pageToken))
  add(query_580237, "quotaUser", newJString(quotaUser))
  add(query_580237, "alt", newJString(alt))
  add(query_580237, "oauth_token", newJString(oauthToken))
  add(query_580237, "userIp", newJString(userIp))
  add(query_580237, "maxResults", newJInt(maxResults))
  add(query_580237, "key", newJString(key))
  add(path_580236, "project", newJString(project))
  add(query_580237, "prettyPrint", newJBool(prettyPrint))
  result = call_580235.call(path_580236, query_580237, nil, nil, nil)

var dnsPoliciesList* = Call_DnsPoliciesList_580221(name: "dnsPoliciesList",
    meth: HttpMethod.HttpGet, host: "dns.googleapis.com",
    route: "/{project}/policies", validator: validate_DnsPoliciesList_580222,
    base: "/dns/v2beta1/projects", url: url_DnsPoliciesList_580223,
    schemes: {Scheme.Https})
type
  Call_DnsPoliciesUpdate_580273 = ref object of OpenApiRestCall_579408
proc url_DnsPoliciesUpdate_580275(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DnsPoliciesUpdate_580274(path: JsonNode; query: JsonNode;
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
  var valid_580276 = path.getOrDefault("policy")
  valid_580276 = validateParameter(valid_580276, JString, required = true,
                                 default = nil)
  if valid_580276 != nil:
    section.add "policy", valid_580276
  var valid_580277 = path.getOrDefault("project")
  valid_580277 = validateParameter(valid_580277, JString, required = true,
                                 default = nil)
  if valid_580277 != nil:
    section.add "project", valid_580277
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
  var valid_580278 = query.getOrDefault("fields")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "fields", valid_580278
  var valid_580279 = query.getOrDefault("quotaUser")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "quotaUser", valid_580279
  var valid_580280 = query.getOrDefault("alt")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = newJString("json"))
  if valid_580280 != nil:
    section.add "alt", valid_580280
  var valid_580281 = query.getOrDefault("oauth_token")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "oauth_token", valid_580281
  var valid_580282 = query.getOrDefault("userIp")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = nil)
  if valid_580282 != nil:
    section.add "userIp", valid_580282
  var valid_580283 = query.getOrDefault("key")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = nil)
  if valid_580283 != nil:
    section.add "key", valid_580283
  var valid_580284 = query.getOrDefault("clientOperationId")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "clientOperationId", valid_580284
  var valid_580285 = query.getOrDefault("prettyPrint")
  valid_580285 = validateParameter(valid_580285, JBool, required = false,
                                 default = newJBool(true))
  if valid_580285 != nil:
    section.add "prettyPrint", valid_580285
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

proc call*(call_580287: Call_DnsPoliciesUpdate_580273; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an existing Policy.
  ## 
  let valid = call_580287.validator(path, query, header, formData, body)
  let scheme = call_580287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580287.url(scheme.get, call_580287.host, call_580287.base,
                         call_580287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580287, url, valid)

proc call*(call_580288: Call_DnsPoliciesUpdate_580273; policy: string;
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
  var path_580289 = newJObject()
  var query_580290 = newJObject()
  var body_580291 = newJObject()
  add(query_580290, "fields", newJString(fields))
  add(path_580289, "policy", newJString(policy))
  add(query_580290, "quotaUser", newJString(quotaUser))
  add(query_580290, "alt", newJString(alt))
  add(query_580290, "oauth_token", newJString(oauthToken))
  add(query_580290, "userIp", newJString(userIp))
  add(query_580290, "key", newJString(key))
  add(query_580290, "clientOperationId", newJString(clientOperationId))
  add(path_580289, "project", newJString(project))
  if body != nil:
    body_580291 = body
  add(query_580290, "prettyPrint", newJBool(prettyPrint))
  result = call_580288.call(path_580289, query_580290, nil, nil, body_580291)

var dnsPoliciesUpdate* = Call_DnsPoliciesUpdate_580273(name: "dnsPoliciesUpdate",
    meth: HttpMethod.HttpPut, host: "dns.googleapis.com",
    route: "/{project}/policies/{policy}", validator: validate_DnsPoliciesUpdate_580274,
    base: "/dns/v2beta1/projects", url: url_DnsPoliciesUpdate_580275,
    schemes: {Scheme.Https})
type
  Call_DnsPoliciesGet_580256 = ref object of OpenApiRestCall_579408
proc url_DnsPoliciesGet_580258(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DnsPoliciesGet_580257(path: JsonNode; query: JsonNode;
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
  var valid_580259 = path.getOrDefault("policy")
  valid_580259 = validateParameter(valid_580259, JString, required = true,
                                 default = nil)
  if valid_580259 != nil:
    section.add "policy", valid_580259
  var valid_580260 = path.getOrDefault("project")
  valid_580260 = validateParameter(valid_580260, JString, required = true,
                                 default = nil)
  if valid_580260 != nil:
    section.add "project", valid_580260
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
  var valid_580261 = query.getOrDefault("fields")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "fields", valid_580261
  var valid_580262 = query.getOrDefault("quotaUser")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "quotaUser", valid_580262
  var valid_580263 = query.getOrDefault("alt")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = newJString("json"))
  if valid_580263 != nil:
    section.add "alt", valid_580263
  var valid_580264 = query.getOrDefault("oauth_token")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = nil)
  if valid_580264 != nil:
    section.add "oauth_token", valid_580264
  var valid_580265 = query.getOrDefault("userIp")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "userIp", valid_580265
  var valid_580266 = query.getOrDefault("key")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "key", valid_580266
  var valid_580267 = query.getOrDefault("clientOperationId")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "clientOperationId", valid_580267
  var valid_580268 = query.getOrDefault("prettyPrint")
  valid_580268 = validateParameter(valid_580268, JBool, required = false,
                                 default = newJBool(true))
  if valid_580268 != nil:
    section.add "prettyPrint", valid_580268
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580269: Call_DnsPoliciesGet_580256; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetch the representation of an existing Policy.
  ## 
  let valid = call_580269.validator(path, query, header, formData, body)
  let scheme = call_580269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580269.url(scheme.get, call_580269.host, call_580269.base,
                         call_580269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580269, url, valid)

proc call*(call_580270: Call_DnsPoliciesGet_580256; policy: string; project: string;
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
  var path_580271 = newJObject()
  var query_580272 = newJObject()
  add(query_580272, "fields", newJString(fields))
  add(path_580271, "policy", newJString(policy))
  add(query_580272, "quotaUser", newJString(quotaUser))
  add(query_580272, "alt", newJString(alt))
  add(query_580272, "oauth_token", newJString(oauthToken))
  add(query_580272, "userIp", newJString(userIp))
  add(query_580272, "key", newJString(key))
  add(query_580272, "clientOperationId", newJString(clientOperationId))
  add(path_580271, "project", newJString(project))
  add(query_580272, "prettyPrint", newJBool(prettyPrint))
  result = call_580270.call(path_580271, query_580272, nil, nil, nil)

var dnsPoliciesGet* = Call_DnsPoliciesGet_580256(name: "dnsPoliciesGet",
    meth: HttpMethod.HttpGet, host: "dns.googleapis.com",
    route: "/{project}/policies/{policy}", validator: validate_DnsPoliciesGet_580257,
    base: "/dns/v2beta1/projects", url: url_DnsPoliciesGet_580258,
    schemes: {Scheme.Https})
type
  Call_DnsPoliciesPatch_580309 = ref object of OpenApiRestCall_579408
proc url_DnsPoliciesPatch_580311(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DnsPoliciesPatch_580310(path: JsonNode; query: JsonNode;
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
  var valid_580312 = path.getOrDefault("policy")
  valid_580312 = validateParameter(valid_580312, JString, required = true,
                                 default = nil)
  if valid_580312 != nil:
    section.add "policy", valid_580312
  var valid_580313 = path.getOrDefault("project")
  valid_580313 = validateParameter(valid_580313, JString, required = true,
                                 default = nil)
  if valid_580313 != nil:
    section.add "project", valid_580313
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
  var valid_580314 = query.getOrDefault("fields")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = nil)
  if valid_580314 != nil:
    section.add "fields", valid_580314
  var valid_580315 = query.getOrDefault("quotaUser")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "quotaUser", valid_580315
  var valid_580316 = query.getOrDefault("alt")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = newJString("json"))
  if valid_580316 != nil:
    section.add "alt", valid_580316
  var valid_580317 = query.getOrDefault("oauth_token")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = nil)
  if valid_580317 != nil:
    section.add "oauth_token", valid_580317
  var valid_580318 = query.getOrDefault("userIp")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = nil)
  if valid_580318 != nil:
    section.add "userIp", valid_580318
  var valid_580319 = query.getOrDefault("key")
  valid_580319 = validateParameter(valid_580319, JString, required = false,
                                 default = nil)
  if valid_580319 != nil:
    section.add "key", valid_580319
  var valid_580320 = query.getOrDefault("clientOperationId")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = nil)
  if valid_580320 != nil:
    section.add "clientOperationId", valid_580320
  var valid_580321 = query.getOrDefault("prettyPrint")
  valid_580321 = validateParameter(valid_580321, JBool, required = false,
                                 default = newJBool(true))
  if valid_580321 != nil:
    section.add "prettyPrint", valid_580321
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

proc call*(call_580323: Call_DnsPoliciesPatch_580309; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Apply a partial update to an existing Policy.
  ## 
  let valid = call_580323.validator(path, query, header, formData, body)
  let scheme = call_580323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580323.url(scheme.get, call_580323.host, call_580323.base,
                         call_580323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580323, url, valid)

proc call*(call_580324: Call_DnsPoliciesPatch_580309; policy: string;
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
  var path_580325 = newJObject()
  var query_580326 = newJObject()
  var body_580327 = newJObject()
  add(query_580326, "fields", newJString(fields))
  add(path_580325, "policy", newJString(policy))
  add(query_580326, "quotaUser", newJString(quotaUser))
  add(query_580326, "alt", newJString(alt))
  add(query_580326, "oauth_token", newJString(oauthToken))
  add(query_580326, "userIp", newJString(userIp))
  add(query_580326, "key", newJString(key))
  add(query_580326, "clientOperationId", newJString(clientOperationId))
  add(path_580325, "project", newJString(project))
  if body != nil:
    body_580327 = body
  add(query_580326, "prettyPrint", newJBool(prettyPrint))
  result = call_580324.call(path_580325, query_580326, nil, nil, body_580327)

var dnsPoliciesPatch* = Call_DnsPoliciesPatch_580309(name: "dnsPoliciesPatch",
    meth: HttpMethod.HttpPatch, host: "dns.googleapis.com",
    route: "/{project}/policies/{policy}", validator: validate_DnsPoliciesPatch_580310,
    base: "/dns/v2beta1/projects", url: url_DnsPoliciesPatch_580311,
    schemes: {Scheme.Https})
type
  Call_DnsPoliciesDelete_580292 = ref object of OpenApiRestCall_579408
proc url_DnsPoliciesDelete_580294(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_DnsPoliciesDelete_580293(path: JsonNode; query: JsonNode;
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
  var valid_580295 = path.getOrDefault("policy")
  valid_580295 = validateParameter(valid_580295, JString, required = true,
                                 default = nil)
  if valid_580295 != nil:
    section.add "policy", valid_580295
  var valid_580296 = path.getOrDefault("project")
  valid_580296 = validateParameter(valid_580296, JString, required = true,
                                 default = nil)
  if valid_580296 != nil:
    section.add "project", valid_580296
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
  var valid_580297 = query.getOrDefault("fields")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = nil)
  if valid_580297 != nil:
    section.add "fields", valid_580297
  var valid_580298 = query.getOrDefault("quotaUser")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = nil)
  if valid_580298 != nil:
    section.add "quotaUser", valid_580298
  var valid_580299 = query.getOrDefault("alt")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = newJString("json"))
  if valid_580299 != nil:
    section.add "alt", valid_580299
  var valid_580300 = query.getOrDefault("oauth_token")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = nil)
  if valid_580300 != nil:
    section.add "oauth_token", valid_580300
  var valid_580301 = query.getOrDefault("userIp")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = nil)
  if valid_580301 != nil:
    section.add "userIp", valid_580301
  var valid_580302 = query.getOrDefault("key")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "key", valid_580302
  var valid_580303 = query.getOrDefault("clientOperationId")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = nil)
  if valid_580303 != nil:
    section.add "clientOperationId", valid_580303
  var valid_580304 = query.getOrDefault("prettyPrint")
  valid_580304 = validateParameter(valid_580304, JBool, required = false,
                                 default = newJBool(true))
  if valid_580304 != nil:
    section.add "prettyPrint", valid_580304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580305: Call_DnsPoliciesDelete_580292; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a previously created Policy. Will fail if the policy is still being referenced by a network.
  ## 
  let valid = call_580305.validator(path, query, header, formData, body)
  let scheme = call_580305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580305.url(scheme.get, call_580305.host, call_580305.base,
                         call_580305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580305, url, valid)

proc call*(call_580306: Call_DnsPoliciesDelete_580292; policy: string;
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
  var path_580307 = newJObject()
  var query_580308 = newJObject()
  add(query_580308, "fields", newJString(fields))
  add(path_580307, "policy", newJString(policy))
  add(query_580308, "quotaUser", newJString(quotaUser))
  add(query_580308, "alt", newJString(alt))
  add(query_580308, "oauth_token", newJString(oauthToken))
  add(query_580308, "userIp", newJString(userIp))
  add(query_580308, "key", newJString(key))
  add(query_580308, "clientOperationId", newJString(clientOperationId))
  add(path_580307, "project", newJString(project))
  add(query_580308, "prettyPrint", newJBool(prettyPrint))
  result = call_580306.call(path_580307, query_580308, nil, nil, nil)

var dnsPoliciesDelete* = Call_DnsPoliciesDelete_580292(name: "dnsPoliciesDelete",
    meth: HttpMethod.HttpDelete, host: "dns.googleapis.com",
    route: "/{project}/policies/{policy}", validator: validate_DnsPoliciesDelete_580293,
    base: "/dns/v2beta1/projects", url: url_DnsPoliciesDelete_580294,
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
