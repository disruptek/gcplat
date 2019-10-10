
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Cloud DNS
## version: v1
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
  gcpServiceName = "dns"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DnsProjectsGet_588709 = ref object of OpenApiRestCall_588441
proc url_DnsProjectsGet_588711(protocol: Scheme; host: string; base: string;
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

proc validate_DnsProjectsGet_588710(path: JsonNode; query: JsonNode;
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
  var valid_588837 = path.getOrDefault("project")
  valid_588837 = validateParameter(valid_588837, JString, required = true,
                                 default = nil)
  if valid_588837 != nil:
    section.add "project", valid_588837
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
                                 default = newJString("json"))
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
  var valid_588857 = query.getOrDefault("clientOperationId")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "clientOperationId", valid_588857
  var valid_588858 = query.getOrDefault("prettyPrint")
  valid_588858 = validateParameter(valid_588858, JBool, required = false,
                                 default = newJBool(true))
  if valid_588858 != nil:
    section.add "prettyPrint", valid_588858
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588881: Call_DnsProjectsGet_588709; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetch the representation of an existing Project.
  ## 
  let valid = call_588881.validator(path, query, header, formData, body)
  let scheme = call_588881.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588881.url(scheme.get, call_588881.host, call_588881.base,
                         call_588881.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588881, url, valid)

proc call*(call_588952: Call_DnsProjectsGet_588709; project: string;
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
  var path_588953 = newJObject()
  var query_588955 = newJObject()
  add(query_588955, "fields", newJString(fields))
  add(query_588955, "quotaUser", newJString(quotaUser))
  add(query_588955, "alt", newJString(alt))
  add(query_588955, "oauth_token", newJString(oauthToken))
  add(query_588955, "userIp", newJString(userIp))
  add(query_588955, "key", newJString(key))
  add(query_588955, "clientOperationId", newJString(clientOperationId))
  add(path_588953, "project", newJString(project))
  add(query_588955, "prettyPrint", newJBool(prettyPrint))
  result = call_588952.call(path_588953, query_588955, nil, nil, nil)

var dnsProjectsGet* = Call_DnsProjectsGet_588709(name: "dnsProjectsGet",
    meth: HttpMethod.HttpGet, host: "dns.googleapis.com", route: "/{project}",
    validator: validate_DnsProjectsGet_588710, base: "/dns/v1/projects",
    url: url_DnsProjectsGet_588711, schemes: {Scheme.Https})
type
  Call_DnsManagedZonesCreate_589012 = ref object of OpenApiRestCall_588441
proc url_DnsManagedZonesCreate_589014(protocol: Scheme; host: string; base: string;
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

proc validate_DnsManagedZonesCreate_589013(path: JsonNode; query: JsonNode;
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
  var valid_589015 = path.getOrDefault("project")
  valid_589015 = validateParameter(valid_589015, JString, required = true,
                                 default = nil)
  if valid_589015 != nil:
    section.add "project", valid_589015
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
  var valid_589016 = query.getOrDefault("fields")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "fields", valid_589016
  var valid_589017 = query.getOrDefault("quotaUser")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "quotaUser", valid_589017
  var valid_589018 = query.getOrDefault("alt")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = newJString("json"))
  if valid_589018 != nil:
    section.add "alt", valid_589018
  var valid_589019 = query.getOrDefault("oauth_token")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "oauth_token", valid_589019
  var valid_589020 = query.getOrDefault("userIp")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = nil)
  if valid_589020 != nil:
    section.add "userIp", valid_589020
  var valid_589021 = query.getOrDefault("key")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "key", valid_589021
  var valid_589022 = query.getOrDefault("clientOperationId")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "clientOperationId", valid_589022
  var valid_589023 = query.getOrDefault("prettyPrint")
  valid_589023 = validateParameter(valid_589023, JBool, required = false,
                                 default = newJBool(true))
  if valid_589023 != nil:
    section.add "prettyPrint", valid_589023
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

proc call*(call_589025: Call_DnsManagedZonesCreate_589012; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new ManagedZone.
  ## 
  let valid = call_589025.validator(path, query, header, formData, body)
  let scheme = call_589025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589025.url(scheme.get, call_589025.host, call_589025.base,
                         call_589025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589025, url, valid)

proc call*(call_589026: Call_DnsManagedZonesCreate_589012; project: string;
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
  var path_589027 = newJObject()
  var query_589028 = newJObject()
  var body_589029 = newJObject()
  add(query_589028, "fields", newJString(fields))
  add(query_589028, "quotaUser", newJString(quotaUser))
  add(query_589028, "alt", newJString(alt))
  add(query_589028, "oauth_token", newJString(oauthToken))
  add(query_589028, "userIp", newJString(userIp))
  add(query_589028, "key", newJString(key))
  add(query_589028, "clientOperationId", newJString(clientOperationId))
  add(path_589027, "project", newJString(project))
  if body != nil:
    body_589029 = body
  add(query_589028, "prettyPrint", newJBool(prettyPrint))
  result = call_589026.call(path_589027, query_589028, nil, nil, body_589029)

var dnsManagedZonesCreate* = Call_DnsManagedZonesCreate_589012(
    name: "dnsManagedZonesCreate", meth: HttpMethod.HttpPost,
    host: "dns.googleapis.com", route: "/{project}/managedZones",
    validator: validate_DnsManagedZonesCreate_589013, base: "/dns/v1/projects",
    url: url_DnsManagedZonesCreate_589014, schemes: {Scheme.Https})
type
  Call_DnsManagedZonesList_588994 = ref object of OpenApiRestCall_588441
proc url_DnsManagedZonesList_588996(protocol: Scheme; host: string; base: string;
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

proc validate_DnsManagedZonesList_588995(path: JsonNode; query: JsonNode;
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
  var valid_588997 = path.getOrDefault("project")
  valid_588997 = validateParameter(valid_588997, JString, required = true,
                                 default = nil)
  if valid_588997 != nil:
    section.add "project", valid_588997
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
  var valid_588998 = query.getOrDefault("fields")
  valid_588998 = validateParameter(valid_588998, JString, required = false,
                                 default = nil)
  if valid_588998 != nil:
    section.add "fields", valid_588998
  var valid_588999 = query.getOrDefault("pageToken")
  valid_588999 = validateParameter(valid_588999, JString, required = false,
                                 default = nil)
  if valid_588999 != nil:
    section.add "pageToken", valid_588999
  var valid_589000 = query.getOrDefault("quotaUser")
  valid_589000 = validateParameter(valid_589000, JString, required = false,
                                 default = nil)
  if valid_589000 != nil:
    section.add "quotaUser", valid_589000
  var valid_589001 = query.getOrDefault("alt")
  valid_589001 = validateParameter(valid_589001, JString, required = false,
                                 default = newJString("json"))
  if valid_589001 != nil:
    section.add "alt", valid_589001
  var valid_589002 = query.getOrDefault("dnsName")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = nil)
  if valid_589002 != nil:
    section.add "dnsName", valid_589002
  var valid_589003 = query.getOrDefault("oauth_token")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = nil)
  if valid_589003 != nil:
    section.add "oauth_token", valid_589003
  var valid_589004 = query.getOrDefault("userIp")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "userIp", valid_589004
  var valid_589005 = query.getOrDefault("maxResults")
  valid_589005 = validateParameter(valid_589005, JInt, required = false, default = nil)
  if valid_589005 != nil:
    section.add "maxResults", valid_589005
  var valid_589006 = query.getOrDefault("key")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "key", valid_589006
  var valid_589007 = query.getOrDefault("prettyPrint")
  valid_589007 = validateParameter(valid_589007, JBool, required = false,
                                 default = newJBool(true))
  if valid_589007 != nil:
    section.add "prettyPrint", valid_589007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589008: Call_DnsManagedZonesList_588994; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enumerate ManagedZones that have been created but not yet deleted.
  ## 
  let valid = call_589008.validator(path, query, header, formData, body)
  let scheme = call_589008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589008.url(scheme.get, call_589008.host, call_589008.base,
                         call_589008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589008, url, valid)

proc call*(call_589009: Call_DnsManagedZonesList_588994; project: string;
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
  var path_589010 = newJObject()
  var query_589011 = newJObject()
  add(query_589011, "fields", newJString(fields))
  add(query_589011, "pageToken", newJString(pageToken))
  add(query_589011, "quotaUser", newJString(quotaUser))
  add(query_589011, "alt", newJString(alt))
  add(query_589011, "dnsName", newJString(dnsName))
  add(query_589011, "oauth_token", newJString(oauthToken))
  add(query_589011, "userIp", newJString(userIp))
  add(query_589011, "maxResults", newJInt(maxResults))
  add(query_589011, "key", newJString(key))
  add(path_589010, "project", newJString(project))
  add(query_589011, "prettyPrint", newJBool(prettyPrint))
  result = call_589009.call(path_589010, query_589011, nil, nil, nil)

var dnsManagedZonesList* = Call_DnsManagedZonesList_588994(
    name: "dnsManagedZonesList", meth: HttpMethod.HttpGet,
    host: "dns.googleapis.com", route: "/{project}/managedZones",
    validator: validate_DnsManagedZonesList_588995, base: "/dns/v1/projects",
    url: url_DnsManagedZonesList_588996, schemes: {Scheme.Https})
type
  Call_DnsManagedZonesUpdate_589047 = ref object of OpenApiRestCall_588441
proc url_DnsManagedZonesUpdate_589049(protocol: Scheme; host: string; base: string;
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

proc validate_DnsManagedZonesUpdate_589048(path: JsonNode; query: JsonNode;
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
  var valid_589050 = path.getOrDefault("managedZone")
  valid_589050 = validateParameter(valid_589050, JString, required = true,
                                 default = nil)
  if valid_589050 != nil:
    section.add "managedZone", valid_589050
  var valid_589051 = path.getOrDefault("project")
  valid_589051 = validateParameter(valid_589051, JString, required = true,
                                 default = nil)
  if valid_589051 != nil:
    section.add "project", valid_589051
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
  var valid_589052 = query.getOrDefault("fields")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "fields", valid_589052
  var valid_589053 = query.getOrDefault("quotaUser")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "quotaUser", valid_589053
  var valid_589054 = query.getOrDefault("alt")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = newJString("json"))
  if valid_589054 != nil:
    section.add "alt", valid_589054
  var valid_589055 = query.getOrDefault("oauth_token")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "oauth_token", valid_589055
  var valid_589056 = query.getOrDefault("userIp")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "userIp", valid_589056
  var valid_589057 = query.getOrDefault("key")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "key", valid_589057
  var valid_589058 = query.getOrDefault("clientOperationId")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "clientOperationId", valid_589058
  var valid_589059 = query.getOrDefault("prettyPrint")
  valid_589059 = validateParameter(valid_589059, JBool, required = false,
                                 default = newJBool(true))
  if valid_589059 != nil:
    section.add "prettyPrint", valid_589059
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

proc call*(call_589061: Call_DnsManagedZonesUpdate_589047; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an existing ManagedZone.
  ## 
  let valid = call_589061.validator(path, query, header, formData, body)
  let scheme = call_589061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589061.url(scheme.get, call_589061.host, call_589061.base,
                         call_589061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589061, url, valid)

proc call*(call_589062: Call_DnsManagedZonesUpdate_589047; managedZone: string;
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
  var path_589063 = newJObject()
  var query_589064 = newJObject()
  var body_589065 = newJObject()
  add(query_589064, "fields", newJString(fields))
  add(query_589064, "quotaUser", newJString(quotaUser))
  add(query_589064, "alt", newJString(alt))
  add(query_589064, "oauth_token", newJString(oauthToken))
  add(path_589063, "managedZone", newJString(managedZone))
  add(query_589064, "userIp", newJString(userIp))
  add(query_589064, "key", newJString(key))
  add(query_589064, "clientOperationId", newJString(clientOperationId))
  add(path_589063, "project", newJString(project))
  if body != nil:
    body_589065 = body
  add(query_589064, "prettyPrint", newJBool(prettyPrint))
  result = call_589062.call(path_589063, query_589064, nil, nil, body_589065)

var dnsManagedZonesUpdate* = Call_DnsManagedZonesUpdate_589047(
    name: "dnsManagedZonesUpdate", meth: HttpMethod.HttpPut,
    host: "dns.googleapis.com", route: "/{project}/managedZones/{managedZone}",
    validator: validate_DnsManagedZonesUpdate_589048, base: "/dns/v1/projects",
    url: url_DnsManagedZonesUpdate_589049, schemes: {Scheme.Https})
type
  Call_DnsManagedZonesGet_589030 = ref object of OpenApiRestCall_588441
proc url_DnsManagedZonesGet_589032(protocol: Scheme; host: string; base: string;
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

proc validate_DnsManagedZonesGet_589031(path: JsonNode; query: JsonNode;
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
  var valid_589033 = path.getOrDefault("managedZone")
  valid_589033 = validateParameter(valid_589033, JString, required = true,
                                 default = nil)
  if valid_589033 != nil:
    section.add "managedZone", valid_589033
  var valid_589034 = path.getOrDefault("project")
  valid_589034 = validateParameter(valid_589034, JString, required = true,
                                 default = nil)
  if valid_589034 != nil:
    section.add "project", valid_589034
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
  var valid_589035 = query.getOrDefault("fields")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "fields", valid_589035
  var valid_589036 = query.getOrDefault("quotaUser")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "quotaUser", valid_589036
  var valid_589037 = query.getOrDefault("alt")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = newJString("json"))
  if valid_589037 != nil:
    section.add "alt", valid_589037
  var valid_589038 = query.getOrDefault("oauth_token")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "oauth_token", valid_589038
  var valid_589039 = query.getOrDefault("userIp")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "userIp", valid_589039
  var valid_589040 = query.getOrDefault("key")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "key", valid_589040
  var valid_589041 = query.getOrDefault("clientOperationId")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "clientOperationId", valid_589041
  var valid_589042 = query.getOrDefault("prettyPrint")
  valid_589042 = validateParameter(valid_589042, JBool, required = false,
                                 default = newJBool(true))
  if valid_589042 != nil:
    section.add "prettyPrint", valid_589042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589043: Call_DnsManagedZonesGet_589030; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetch the representation of an existing ManagedZone.
  ## 
  let valid = call_589043.validator(path, query, header, formData, body)
  let scheme = call_589043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589043.url(scheme.get, call_589043.host, call_589043.base,
                         call_589043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589043, url, valid)

proc call*(call_589044: Call_DnsManagedZonesGet_589030; managedZone: string;
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
  var path_589045 = newJObject()
  var query_589046 = newJObject()
  add(query_589046, "fields", newJString(fields))
  add(query_589046, "quotaUser", newJString(quotaUser))
  add(query_589046, "alt", newJString(alt))
  add(query_589046, "oauth_token", newJString(oauthToken))
  add(path_589045, "managedZone", newJString(managedZone))
  add(query_589046, "userIp", newJString(userIp))
  add(query_589046, "key", newJString(key))
  add(query_589046, "clientOperationId", newJString(clientOperationId))
  add(path_589045, "project", newJString(project))
  add(query_589046, "prettyPrint", newJBool(prettyPrint))
  result = call_589044.call(path_589045, query_589046, nil, nil, nil)

var dnsManagedZonesGet* = Call_DnsManagedZonesGet_589030(
    name: "dnsManagedZonesGet", meth: HttpMethod.HttpGet,
    host: "dns.googleapis.com", route: "/{project}/managedZones/{managedZone}",
    validator: validate_DnsManagedZonesGet_589031, base: "/dns/v1/projects",
    url: url_DnsManagedZonesGet_589032, schemes: {Scheme.Https})
type
  Call_DnsManagedZonesPatch_589083 = ref object of OpenApiRestCall_588441
proc url_DnsManagedZonesPatch_589085(protocol: Scheme; host: string; base: string;
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

proc validate_DnsManagedZonesPatch_589084(path: JsonNode; query: JsonNode;
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
  var valid_589086 = path.getOrDefault("managedZone")
  valid_589086 = validateParameter(valid_589086, JString, required = true,
                                 default = nil)
  if valid_589086 != nil:
    section.add "managedZone", valid_589086
  var valid_589087 = path.getOrDefault("project")
  valid_589087 = validateParameter(valid_589087, JString, required = true,
                                 default = nil)
  if valid_589087 != nil:
    section.add "project", valid_589087
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
  var valid_589088 = query.getOrDefault("fields")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "fields", valid_589088
  var valid_589089 = query.getOrDefault("quotaUser")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "quotaUser", valid_589089
  var valid_589090 = query.getOrDefault("alt")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = newJString("json"))
  if valid_589090 != nil:
    section.add "alt", valid_589090
  var valid_589091 = query.getOrDefault("oauth_token")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "oauth_token", valid_589091
  var valid_589092 = query.getOrDefault("userIp")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "userIp", valid_589092
  var valid_589093 = query.getOrDefault("key")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "key", valid_589093
  var valid_589094 = query.getOrDefault("clientOperationId")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "clientOperationId", valid_589094
  var valid_589095 = query.getOrDefault("prettyPrint")
  valid_589095 = validateParameter(valid_589095, JBool, required = false,
                                 default = newJBool(true))
  if valid_589095 != nil:
    section.add "prettyPrint", valid_589095
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

proc call*(call_589097: Call_DnsManagedZonesPatch_589083; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Apply a partial update to an existing ManagedZone.
  ## 
  let valid = call_589097.validator(path, query, header, formData, body)
  let scheme = call_589097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589097.url(scheme.get, call_589097.host, call_589097.base,
                         call_589097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589097, url, valid)

proc call*(call_589098: Call_DnsManagedZonesPatch_589083; managedZone: string;
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
  var path_589099 = newJObject()
  var query_589100 = newJObject()
  var body_589101 = newJObject()
  add(query_589100, "fields", newJString(fields))
  add(query_589100, "quotaUser", newJString(quotaUser))
  add(query_589100, "alt", newJString(alt))
  add(query_589100, "oauth_token", newJString(oauthToken))
  add(path_589099, "managedZone", newJString(managedZone))
  add(query_589100, "userIp", newJString(userIp))
  add(query_589100, "key", newJString(key))
  add(query_589100, "clientOperationId", newJString(clientOperationId))
  add(path_589099, "project", newJString(project))
  if body != nil:
    body_589101 = body
  add(query_589100, "prettyPrint", newJBool(prettyPrint))
  result = call_589098.call(path_589099, query_589100, nil, nil, body_589101)

var dnsManagedZonesPatch* = Call_DnsManagedZonesPatch_589083(
    name: "dnsManagedZonesPatch", meth: HttpMethod.HttpPatch,
    host: "dns.googleapis.com", route: "/{project}/managedZones/{managedZone}",
    validator: validate_DnsManagedZonesPatch_589084, base: "/dns/v1/projects",
    url: url_DnsManagedZonesPatch_589085, schemes: {Scheme.Https})
type
  Call_DnsManagedZonesDelete_589066 = ref object of OpenApiRestCall_588441
proc url_DnsManagedZonesDelete_589068(protocol: Scheme; host: string; base: string;
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

proc validate_DnsManagedZonesDelete_589067(path: JsonNode; query: JsonNode;
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
  var valid_589069 = path.getOrDefault("managedZone")
  valid_589069 = validateParameter(valid_589069, JString, required = true,
                                 default = nil)
  if valid_589069 != nil:
    section.add "managedZone", valid_589069
  var valid_589070 = path.getOrDefault("project")
  valid_589070 = validateParameter(valid_589070, JString, required = true,
                                 default = nil)
  if valid_589070 != nil:
    section.add "project", valid_589070
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
  var valid_589071 = query.getOrDefault("fields")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "fields", valid_589071
  var valid_589072 = query.getOrDefault("quotaUser")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "quotaUser", valid_589072
  var valid_589073 = query.getOrDefault("alt")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = newJString("json"))
  if valid_589073 != nil:
    section.add "alt", valid_589073
  var valid_589074 = query.getOrDefault("oauth_token")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "oauth_token", valid_589074
  var valid_589075 = query.getOrDefault("userIp")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "userIp", valid_589075
  var valid_589076 = query.getOrDefault("key")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "key", valid_589076
  var valid_589077 = query.getOrDefault("clientOperationId")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "clientOperationId", valid_589077
  var valid_589078 = query.getOrDefault("prettyPrint")
  valid_589078 = validateParameter(valid_589078, JBool, required = false,
                                 default = newJBool(true))
  if valid_589078 != nil:
    section.add "prettyPrint", valid_589078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589079: Call_DnsManagedZonesDelete_589066; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a previously created ManagedZone.
  ## 
  let valid = call_589079.validator(path, query, header, formData, body)
  let scheme = call_589079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589079.url(scheme.get, call_589079.host, call_589079.base,
                         call_589079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589079, url, valid)

proc call*(call_589080: Call_DnsManagedZonesDelete_589066; managedZone: string;
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
  var path_589081 = newJObject()
  var query_589082 = newJObject()
  add(query_589082, "fields", newJString(fields))
  add(query_589082, "quotaUser", newJString(quotaUser))
  add(query_589082, "alt", newJString(alt))
  add(query_589082, "oauth_token", newJString(oauthToken))
  add(path_589081, "managedZone", newJString(managedZone))
  add(query_589082, "userIp", newJString(userIp))
  add(query_589082, "key", newJString(key))
  add(query_589082, "clientOperationId", newJString(clientOperationId))
  add(path_589081, "project", newJString(project))
  add(query_589082, "prettyPrint", newJBool(prettyPrint))
  result = call_589080.call(path_589081, query_589082, nil, nil, nil)

var dnsManagedZonesDelete* = Call_DnsManagedZonesDelete_589066(
    name: "dnsManagedZonesDelete", meth: HttpMethod.HttpDelete,
    host: "dns.googleapis.com", route: "/{project}/managedZones/{managedZone}",
    validator: validate_DnsManagedZonesDelete_589067, base: "/dns/v1/projects",
    url: url_DnsManagedZonesDelete_589068, schemes: {Scheme.Https})
type
  Call_DnsChangesCreate_589122 = ref object of OpenApiRestCall_588441
proc url_DnsChangesCreate_589124(protocol: Scheme; host: string; base: string;
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

proc validate_DnsChangesCreate_589123(path: JsonNode; query: JsonNode;
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
  var valid_589125 = path.getOrDefault("managedZone")
  valid_589125 = validateParameter(valid_589125, JString, required = true,
                                 default = nil)
  if valid_589125 != nil:
    section.add "managedZone", valid_589125
  var valid_589126 = path.getOrDefault("project")
  valid_589126 = validateParameter(valid_589126, JString, required = true,
                                 default = nil)
  if valid_589126 != nil:
    section.add "project", valid_589126
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
  var valid_589127 = query.getOrDefault("fields")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "fields", valid_589127
  var valid_589128 = query.getOrDefault("quotaUser")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "quotaUser", valid_589128
  var valid_589129 = query.getOrDefault("alt")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = newJString("json"))
  if valid_589129 != nil:
    section.add "alt", valid_589129
  var valid_589130 = query.getOrDefault("oauth_token")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "oauth_token", valid_589130
  var valid_589131 = query.getOrDefault("userIp")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "userIp", valid_589131
  var valid_589132 = query.getOrDefault("key")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "key", valid_589132
  var valid_589133 = query.getOrDefault("clientOperationId")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "clientOperationId", valid_589133
  var valid_589134 = query.getOrDefault("prettyPrint")
  valid_589134 = validateParameter(valid_589134, JBool, required = false,
                                 default = newJBool(true))
  if valid_589134 != nil:
    section.add "prettyPrint", valid_589134
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

proc call*(call_589136: Call_DnsChangesCreate_589122; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Atomically update the ResourceRecordSet collection.
  ## 
  let valid = call_589136.validator(path, query, header, formData, body)
  let scheme = call_589136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589136.url(scheme.get, call_589136.host, call_589136.base,
                         call_589136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589136, url, valid)

proc call*(call_589137: Call_DnsChangesCreate_589122; managedZone: string;
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
  var path_589138 = newJObject()
  var query_589139 = newJObject()
  var body_589140 = newJObject()
  add(query_589139, "fields", newJString(fields))
  add(query_589139, "quotaUser", newJString(quotaUser))
  add(query_589139, "alt", newJString(alt))
  add(query_589139, "oauth_token", newJString(oauthToken))
  add(path_589138, "managedZone", newJString(managedZone))
  add(query_589139, "userIp", newJString(userIp))
  add(query_589139, "key", newJString(key))
  add(query_589139, "clientOperationId", newJString(clientOperationId))
  add(path_589138, "project", newJString(project))
  if body != nil:
    body_589140 = body
  add(query_589139, "prettyPrint", newJBool(prettyPrint))
  result = call_589137.call(path_589138, query_589139, nil, nil, body_589140)

var dnsChangesCreate* = Call_DnsChangesCreate_589122(name: "dnsChangesCreate",
    meth: HttpMethod.HttpPost, host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/changes",
    validator: validate_DnsChangesCreate_589123, base: "/dns/v1/projects",
    url: url_DnsChangesCreate_589124, schemes: {Scheme.Https})
type
  Call_DnsChangesList_589102 = ref object of OpenApiRestCall_588441
proc url_DnsChangesList_589104(protocol: Scheme; host: string; base: string;
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

proc validate_DnsChangesList_589103(path: JsonNode; query: JsonNode;
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
  var valid_589105 = path.getOrDefault("managedZone")
  valid_589105 = validateParameter(valid_589105, JString, required = true,
                                 default = nil)
  if valid_589105 != nil:
    section.add "managedZone", valid_589105
  var valid_589106 = path.getOrDefault("project")
  valid_589106 = validateParameter(valid_589106, JString, required = true,
                                 default = nil)
  if valid_589106 != nil:
    section.add "project", valid_589106
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
  var valid_589107 = query.getOrDefault("fields")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "fields", valid_589107
  var valid_589108 = query.getOrDefault("pageToken")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "pageToken", valid_589108
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
  var valid_589113 = query.getOrDefault("sortBy")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = newJString("changeSequence"))
  if valid_589113 != nil:
    section.add "sortBy", valid_589113
  var valid_589114 = query.getOrDefault("maxResults")
  valid_589114 = validateParameter(valid_589114, JInt, required = false, default = nil)
  if valid_589114 != nil:
    section.add "maxResults", valid_589114
  var valid_589115 = query.getOrDefault("key")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "key", valid_589115
  var valid_589116 = query.getOrDefault("sortOrder")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "sortOrder", valid_589116
  var valid_589117 = query.getOrDefault("prettyPrint")
  valid_589117 = validateParameter(valid_589117, JBool, required = false,
                                 default = newJBool(true))
  if valid_589117 != nil:
    section.add "prettyPrint", valid_589117
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589118: Call_DnsChangesList_589102; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enumerate Changes to a ResourceRecordSet collection.
  ## 
  let valid = call_589118.validator(path, query, header, formData, body)
  let scheme = call_589118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589118.url(scheme.get, call_589118.host, call_589118.base,
                         call_589118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589118, url, valid)

proc call*(call_589119: Call_DnsChangesList_589102; managedZone: string;
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
  var path_589120 = newJObject()
  var query_589121 = newJObject()
  add(query_589121, "fields", newJString(fields))
  add(query_589121, "pageToken", newJString(pageToken))
  add(query_589121, "quotaUser", newJString(quotaUser))
  add(query_589121, "alt", newJString(alt))
  add(query_589121, "oauth_token", newJString(oauthToken))
  add(path_589120, "managedZone", newJString(managedZone))
  add(query_589121, "userIp", newJString(userIp))
  add(query_589121, "sortBy", newJString(sortBy))
  add(query_589121, "maxResults", newJInt(maxResults))
  add(query_589121, "key", newJString(key))
  add(query_589121, "sortOrder", newJString(sortOrder))
  add(path_589120, "project", newJString(project))
  add(query_589121, "prettyPrint", newJBool(prettyPrint))
  result = call_589119.call(path_589120, query_589121, nil, nil, nil)

var dnsChangesList* = Call_DnsChangesList_589102(name: "dnsChangesList",
    meth: HttpMethod.HttpGet, host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/changes",
    validator: validate_DnsChangesList_589103, base: "/dns/v1/projects",
    url: url_DnsChangesList_589104, schemes: {Scheme.Https})
type
  Call_DnsChangesGet_589141 = ref object of OpenApiRestCall_588441
proc url_DnsChangesGet_589143(protocol: Scheme; host: string; base: string;
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

proc validate_DnsChangesGet_589142(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_589144 = path.getOrDefault("changeId")
  valid_589144 = validateParameter(valid_589144, JString, required = true,
                                 default = nil)
  if valid_589144 != nil:
    section.add "changeId", valid_589144
  var valid_589145 = path.getOrDefault("managedZone")
  valid_589145 = validateParameter(valid_589145, JString, required = true,
                                 default = nil)
  if valid_589145 != nil:
    section.add "managedZone", valid_589145
  var valid_589146 = path.getOrDefault("project")
  valid_589146 = validateParameter(valid_589146, JString, required = true,
                                 default = nil)
  if valid_589146 != nil:
    section.add "project", valid_589146
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
  var valid_589147 = query.getOrDefault("fields")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "fields", valid_589147
  var valid_589148 = query.getOrDefault("quotaUser")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "quotaUser", valid_589148
  var valid_589149 = query.getOrDefault("alt")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = newJString("json"))
  if valid_589149 != nil:
    section.add "alt", valid_589149
  var valid_589150 = query.getOrDefault("oauth_token")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "oauth_token", valid_589150
  var valid_589151 = query.getOrDefault("userIp")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "userIp", valid_589151
  var valid_589152 = query.getOrDefault("key")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "key", valid_589152
  var valid_589153 = query.getOrDefault("clientOperationId")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "clientOperationId", valid_589153
  var valid_589154 = query.getOrDefault("prettyPrint")
  valid_589154 = validateParameter(valid_589154, JBool, required = false,
                                 default = newJBool(true))
  if valid_589154 != nil:
    section.add "prettyPrint", valid_589154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589155: Call_DnsChangesGet_589141; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetch the representation of an existing Change.
  ## 
  let valid = call_589155.validator(path, query, header, formData, body)
  let scheme = call_589155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589155.url(scheme.get, call_589155.host, call_589155.base,
                         call_589155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589155, url, valid)

proc call*(call_589156: Call_DnsChangesGet_589141; changeId: string;
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
  var path_589157 = newJObject()
  var query_589158 = newJObject()
  add(query_589158, "fields", newJString(fields))
  add(path_589157, "changeId", newJString(changeId))
  add(query_589158, "quotaUser", newJString(quotaUser))
  add(query_589158, "alt", newJString(alt))
  add(query_589158, "oauth_token", newJString(oauthToken))
  add(path_589157, "managedZone", newJString(managedZone))
  add(query_589158, "userIp", newJString(userIp))
  add(query_589158, "key", newJString(key))
  add(query_589158, "clientOperationId", newJString(clientOperationId))
  add(path_589157, "project", newJString(project))
  add(query_589158, "prettyPrint", newJBool(prettyPrint))
  result = call_589156.call(path_589157, query_589158, nil, nil, nil)

var dnsChangesGet* = Call_DnsChangesGet_589141(name: "dnsChangesGet",
    meth: HttpMethod.HttpGet, host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/changes/{changeId}",
    validator: validate_DnsChangesGet_589142, base: "/dns/v1/projects",
    url: url_DnsChangesGet_589143, schemes: {Scheme.Https})
type
  Call_DnsDnsKeysList_589159 = ref object of OpenApiRestCall_588441
proc url_DnsDnsKeysList_589161(protocol: Scheme; host: string; base: string;
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

proc validate_DnsDnsKeysList_589160(path: JsonNode; query: JsonNode;
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
  var valid_589162 = path.getOrDefault("managedZone")
  valid_589162 = validateParameter(valid_589162, JString, required = true,
                                 default = nil)
  if valid_589162 != nil:
    section.add "managedZone", valid_589162
  var valid_589163 = path.getOrDefault("project")
  valid_589163 = validateParameter(valid_589163, JString, required = true,
                                 default = nil)
  if valid_589163 != nil:
    section.add "project", valid_589163
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
  var valid_589164 = query.getOrDefault("fields")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "fields", valid_589164
  var valid_589165 = query.getOrDefault("pageToken")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "pageToken", valid_589165
  var valid_589166 = query.getOrDefault("quotaUser")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = nil)
  if valid_589166 != nil:
    section.add "quotaUser", valid_589166
  var valid_589167 = query.getOrDefault("alt")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = newJString("json"))
  if valid_589167 != nil:
    section.add "alt", valid_589167
  var valid_589168 = query.getOrDefault("digestType")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "digestType", valid_589168
  var valid_589169 = query.getOrDefault("oauth_token")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = nil)
  if valid_589169 != nil:
    section.add "oauth_token", valid_589169
  var valid_589170 = query.getOrDefault("userIp")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = nil)
  if valid_589170 != nil:
    section.add "userIp", valid_589170
  var valid_589171 = query.getOrDefault("maxResults")
  valid_589171 = validateParameter(valid_589171, JInt, required = false, default = nil)
  if valid_589171 != nil:
    section.add "maxResults", valid_589171
  var valid_589172 = query.getOrDefault("key")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "key", valid_589172
  var valid_589173 = query.getOrDefault("prettyPrint")
  valid_589173 = validateParameter(valid_589173, JBool, required = false,
                                 default = newJBool(true))
  if valid_589173 != nil:
    section.add "prettyPrint", valid_589173
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589174: Call_DnsDnsKeysList_589159; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enumerate DnsKeys to a ResourceRecordSet collection.
  ## 
  let valid = call_589174.validator(path, query, header, formData, body)
  let scheme = call_589174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589174.url(scheme.get, call_589174.host, call_589174.base,
                         call_589174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589174, url, valid)

proc call*(call_589175: Call_DnsDnsKeysList_589159; managedZone: string;
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
  var path_589176 = newJObject()
  var query_589177 = newJObject()
  add(query_589177, "fields", newJString(fields))
  add(query_589177, "pageToken", newJString(pageToken))
  add(query_589177, "quotaUser", newJString(quotaUser))
  add(query_589177, "alt", newJString(alt))
  add(query_589177, "digestType", newJString(digestType))
  add(query_589177, "oauth_token", newJString(oauthToken))
  add(path_589176, "managedZone", newJString(managedZone))
  add(query_589177, "userIp", newJString(userIp))
  add(query_589177, "maxResults", newJInt(maxResults))
  add(query_589177, "key", newJString(key))
  add(path_589176, "project", newJString(project))
  add(query_589177, "prettyPrint", newJBool(prettyPrint))
  result = call_589175.call(path_589176, query_589177, nil, nil, nil)

var dnsDnsKeysList* = Call_DnsDnsKeysList_589159(name: "dnsDnsKeysList",
    meth: HttpMethod.HttpGet, host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/dnsKeys",
    validator: validate_DnsDnsKeysList_589160, base: "/dns/v1/projects",
    url: url_DnsDnsKeysList_589161, schemes: {Scheme.Https})
type
  Call_DnsDnsKeysGet_589178 = ref object of OpenApiRestCall_588441
proc url_DnsDnsKeysGet_589180(protocol: Scheme; host: string; base: string;
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

proc validate_DnsDnsKeysGet_589179(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_589181 = path.getOrDefault("dnsKeyId")
  valid_589181 = validateParameter(valid_589181, JString, required = true,
                                 default = nil)
  if valid_589181 != nil:
    section.add "dnsKeyId", valid_589181
  var valid_589182 = path.getOrDefault("managedZone")
  valid_589182 = validateParameter(valid_589182, JString, required = true,
                                 default = nil)
  if valid_589182 != nil:
    section.add "managedZone", valid_589182
  var valid_589183 = path.getOrDefault("project")
  valid_589183 = validateParameter(valid_589183, JString, required = true,
                                 default = nil)
  if valid_589183 != nil:
    section.add "project", valid_589183
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
  var valid_589184 = query.getOrDefault("fields")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = nil)
  if valid_589184 != nil:
    section.add "fields", valid_589184
  var valid_589185 = query.getOrDefault("quotaUser")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = nil)
  if valid_589185 != nil:
    section.add "quotaUser", valid_589185
  var valid_589186 = query.getOrDefault("alt")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = newJString("json"))
  if valid_589186 != nil:
    section.add "alt", valid_589186
  var valid_589187 = query.getOrDefault("digestType")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = nil)
  if valid_589187 != nil:
    section.add "digestType", valid_589187
  var valid_589188 = query.getOrDefault("oauth_token")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = nil)
  if valid_589188 != nil:
    section.add "oauth_token", valid_589188
  var valid_589189 = query.getOrDefault("userIp")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "userIp", valid_589189
  var valid_589190 = query.getOrDefault("key")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = nil)
  if valid_589190 != nil:
    section.add "key", valid_589190
  var valid_589191 = query.getOrDefault("clientOperationId")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = nil)
  if valid_589191 != nil:
    section.add "clientOperationId", valid_589191
  var valid_589192 = query.getOrDefault("prettyPrint")
  valid_589192 = validateParameter(valid_589192, JBool, required = false,
                                 default = newJBool(true))
  if valid_589192 != nil:
    section.add "prettyPrint", valid_589192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589193: Call_DnsDnsKeysGet_589178; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetch the representation of an existing DnsKey.
  ## 
  let valid = call_589193.validator(path, query, header, formData, body)
  let scheme = call_589193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589193.url(scheme.get, call_589193.host, call_589193.base,
                         call_589193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589193, url, valid)

proc call*(call_589194: Call_DnsDnsKeysGet_589178; dnsKeyId: string;
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
  var path_589195 = newJObject()
  var query_589196 = newJObject()
  add(path_589195, "dnsKeyId", newJString(dnsKeyId))
  add(query_589196, "fields", newJString(fields))
  add(query_589196, "quotaUser", newJString(quotaUser))
  add(query_589196, "alt", newJString(alt))
  add(query_589196, "digestType", newJString(digestType))
  add(query_589196, "oauth_token", newJString(oauthToken))
  add(path_589195, "managedZone", newJString(managedZone))
  add(query_589196, "userIp", newJString(userIp))
  add(query_589196, "key", newJString(key))
  add(query_589196, "clientOperationId", newJString(clientOperationId))
  add(path_589195, "project", newJString(project))
  add(query_589196, "prettyPrint", newJBool(prettyPrint))
  result = call_589194.call(path_589195, query_589196, nil, nil, nil)

var dnsDnsKeysGet* = Call_DnsDnsKeysGet_589178(name: "dnsDnsKeysGet",
    meth: HttpMethod.HttpGet, host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/dnsKeys/{dnsKeyId}",
    validator: validate_DnsDnsKeysGet_589179, base: "/dns/v1/projects",
    url: url_DnsDnsKeysGet_589180, schemes: {Scheme.Https})
type
  Call_DnsManagedZoneOperationsList_589197 = ref object of OpenApiRestCall_588441
proc url_DnsManagedZoneOperationsList_589199(protocol: Scheme; host: string;
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

proc validate_DnsManagedZoneOperationsList_589198(path: JsonNode; query: JsonNode;
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
  var valid_589200 = path.getOrDefault("managedZone")
  valid_589200 = validateParameter(valid_589200, JString, required = true,
                                 default = nil)
  if valid_589200 != nil:
    section.add "managedZone", valid_589200
  var valid_589201 = path.getOrDefault("project")
  valid_589201 = validateParameter(valid_589201, JString, required = true,
                                 default = nil)
  if valid_589201 != nil:
    section.add "project", valid_589201
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
  var valid_589202 = query.getOrDefault("fields")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = nil)
  if valid_589202 != nil:
    section.add "fields", valid_589202
  var valid_589203 = query.getOrDefault("pageToken")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = nil)
  if valid_589203 != nil:
    section.add "pageToken", valid_589203
  var valid_589204 = query.getOrDefault("quotaUser")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "quotaUser", valid_589204
  var valid_589205 = query.getOrDefault("alt")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = newJString("json"))
  if valid_589205 != nil:
    section.add "alt", valid_589205
  var valid_589206 = query.getOrDefault("oauth_token")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "oauth_token", valid_589206
  var valid_589207 = query.getOrDefault("userIp")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "userIp", valid_589207
  var valid_589208 = query.getOrDefault("sortBy")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = newJString("startTime"))
  if valid_589208 != nil:
    section.add "sortBy", valid_589208
  var valid_589209 = query.getOrDefault("maxResults")
  valid_589209 = validateParameter(valid_589209, JInt, required = false, default = nil)
  if valid_589209 != nil:
    section.add "maxResults", valid_589209
  var valid_589210 = query.getOrDefault("key")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = nil)
  if valid_589210 != nil:
    section.add "key", valid_589210
  var valid_589211 = query.getOrDefault("prettyPrint")
  valid_589211 = validateParameter(valid_589211, JBool, required = false,
                                 default = newJBool(true))
  if valid_589211 != nil:
    section.add "prettyPrint", valid_589211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589212: Call_DnsManagedZoneOperationsList_589197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enumerate Operations for the given ManagedZone.
  ## 
  let valid = call_589212.validator(path, query, header, formData, body)
  let scheme = call_589212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589212.url(scheme.get, call_589212.host, call_589212.base,
                         call_589212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589212, url, valid)

proc call*(call_589213: Call_DnsManagedZoneOperationsList_589197;
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
  var path_589214 = newJObject()
  var query_589215 = newJObject()
  add(query_589215, "fields", newJString(fields))
  add(query_589215, "pageToken", newJString(pageToken))
  add(query_589215, "quotaUser", newJString(quotaUser))
  add(query_589215, "alt", newJString(alt))
  add(query_589215, "oauth_token", newJString(oauthToken))
  add(path_589214, "managedZone", newJString(managedZone))
  add(query_589215, "userIp", newJString(userIp))
  add(query_589215, "sortBy", newJString(sortBy))
  add(query_589215, "maxResults", newJInt(maxResults))
  add(query_589215, "key", newJString(key))
  add(path_589214, "project", newJString(project))
  add(query_589215, "prettyPrint", newJBool(prettyPrint))
  result = call_589213.call(path_589214, query_589215, nil, nil, nil)

var dnsManagedZoneOperationsList* = Call_DnsManagedZoneOperationsList_589197(
    name: "dnsManagedZoneOperationsList", meth: HttpMethod.HttpGet,
    host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/operations",
    validator: validate_DnsManagedZoneOperationsList_589198,
    base: "/dns/v1/projects", url: url_DnsManagedZoneOperationsList_589199,
    schemes: {Scheme.Https})
type
  Call_DnsManagedZoneOperationsGet_589216 = ref object of OpenApiRestCall_588441
proc url_DnsManagedZoneOperationsGet_589218(protocol: Scheme; host: string;
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

proc validate_DnsManagedZoneOperationsGet_589217(path: JsonNode; query: JsonNode;
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
  var valid_589219 = path.getOrDefault("operation")
  valid_589219 = validateParameter(valid_589219, JString, required = true,
                                 default = nil)
  if valid_589219 != nil:
    section.add "operation", valid_589219
  var valid_589220 = path.getOrDefault("managedZone")
  valid_589220 = validateParameter(valid_589220, JString, required = true,
                                 default = nil)
  if valid_589220 != nil:
    section.add "managedZone", valid_589220
  var valid_589221 = path.getOrDefault("project")
  valid_589221 = validateParameter(valid_589221, JString, required = true,
                                 default = nil)
  if valid_589221 != nil:
    section.add "project", valid_589221
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
  var valid_589222 = query.getOrDefault("fields")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "fields", valid_589222
  var valid_589223 = query.getOrDefault("quotaUser")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "quotaUser", valid_589223
  var valid_589224 = query.getOrDefault("alt")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = newJString("json"))
  if valid_589224 != nil:
    section.add "alt", valid_589224
  var valid_589225 = query.getOrDefault("oauth_token")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = nil)
  if valid_589225 != nil:
    section.add "oauth_token", valid_589225
  var valid_589226 = query.getOrDefault("userIp")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "userIp", valid_589226
  var valid_589227 = query.getOrDefault("key")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "key", valid_589227
  var valid_589228 = query.getOrDefault("clientOperationId")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = nil)
  if valid_589228 != nil:
    section.add "clientOperationId", valid_589228
  var valid_589229 = query.getOrDefault("prettyPrint")
  valid_589229 = validateParameter(valid_589229, JBool, required = false,
                                 default = newJBool(true))
  if valid_589229 != nil:
    section.add "prettyPrint", valid_589229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589230: Call_DnsManagedZoneOperationsGet_589216; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetch the representation of an existing Operation.
  ## 
  let valid = call_589230.validator(path, query, header, formData, body)
  let scheme = call_589230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589230.url(scheme.get, call_589230.host, call_589230.base,
                         call_589230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589230, url, valid)

proc call*(call_589231: Call_DnsManagedZoneOperationsGet_589216; operation: string;
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
  var path_589232 = newJObject()
  var query_589233 = newJObject()
  add(query_589233, "fields", newJString(fields))
  add(query_589233, "quotaUser", newJString(quotaUser))
  add(query_589233, "alt", newJString(alt))
  add(path_589232, "operation", newJString(operation))
  add(query_589233, "oauth_token", newJString(oauthToken))
  add(path_589232, "managedZone", newJString(managedZone))
  add(query_589233, "userIp", newJString(userIp))
  add(query_589233, "key", newJString(key))
  add(query_589233, "clientOperationId", newJString(clientOperationId))
  add(path_589232, "project", newJString(project))
  add(query_589233, "prettyPrint", newJBool(prettyPrint))
  result = call_589231.call(path_589232, query_589233, nil, nil, nil)

var dnsManagedZoneOperationsGet* = Call_DnsManagedZoneOperationsGet_589216(
    name: "dnsManagedZoneOperationsGet", meth: HttpMethod.HttpGet,
    host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/operations/{operation}",
    validator: validate_DnsManagedZoneOperationsGet_589217,
    base: "/dns/v1/projects", url: url_DnsManagedZoneOperationsGet_589218,
    schemes: {Scheme.Https})
type
  Call_DnsResourceRecordSetsList_589234 = ref object of OpenApiRestCall_588441
proc url_DnsResourceRecordSetsList_589236(protocol: Scheme; host: string;
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

proc validate_DnsResourceRecordSetsList_589235(path: JsonNode; query: JsonNode;
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
  var valid_589237 = path.getOrDefault("managedZone")
  valid_589237 = validateParameter(valid_589237, JString, required = true,
                                 default = nil)
  if valid_589237 != nil:
    section.add "managedZone", valid_589237
  var valid_589238 = path.getOrDefault("project")
  valid_589238 = validateParameter(valid_589238, JString, required = true,
                                 default = nil)
  if valid_589238 != nil:
    section.add "project", valid_589238
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
  var valid_589239 = query.getOrDefault("fields")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = nil)
  if valid_589239 != nil:
    section.add "fields", valid_589239
  var valid_589240 = query.getOrDefault("pageToken")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = nil)
  if valid_589240 != nil:
    section.add "pageToken", valid_589240
  var valid_589241 = query.getOrDefault("quotaUser")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = nil)
  if valid_589241 != nil:
    section.add "quotaUser", valid_589241
  var valid_589242 = query.getOrDefault("alt")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = newJString("json"))
  if valid_589242 != nil:
    section.add "alt", valid_589242
  var valid_589243 = query.getOrDefault("type")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "type", valid_589243
  var valid_589244 = query.getOrDefault("oauth_token")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = nil)
  if valid_589244 != nil:
    section.add "oauth_token", valid_589244
  var valid_589245 = query.getOrDefault("userIp")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = nil)
  if valid_589245 != nil:
    section.add "userIp", valid_589245
  var valid_589246 = query.getOrDefault("maxResults")
  valid_589246 = validateParameter(valid_589246, JInt, required = false, default = nil)
  if valid_589246 != nil:
    section.add "maxResults", valid_589246
  var valid_589247 = query.getOrDefault("key")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = nil)
  if valid_589247 != nil:
    section.add "key", valid_589247
  var valid_589248 = query.getOrDefault("name")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "name", valid_589248
  var valid_589249 = query.getOrDefault("prettyPrint")
  valid_589249 = validateParameter(valid_589249, JBool, required = false,
                                 default = newJBool(true))
  if valid_589249 != nil:
    section.add "prettyPrint", valid_589249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589250: Call_DnsResourceRecordSetsList_589234; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enumerate ResourceRecordSets that have been created but not yet deleted.
  ## 
  let valid = call_589250.validator(path, query, header, formData, body)
  let scheme = call_589250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589250.url(scheme.get, call_589250.host, call_589250.base,
                         call_589250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589250, url, valid)

proc call*(call_589251: Call_DnsResourceRecordSetsList_589234; managedZone: string;
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
  var path_589252 = newJObject()
  var query_589253 = newJObject()
  add(query_589253, "fields", newJString(fields))
  add(query_589253, "pageToken", newJString(pageToken))
  add(query_589253, "quotaUser", newJString(quotaUser))
  add(query_589253, "alt", newJString(alt))
  add(query_589253, "type", newJString(`type`))
  add(query_589253, "oauth_token", newJString(oauthToken))
  add(path_589252, "managedZone", newJString(managedZone))
  add(query_589253, "userIp", newJString(userIp))
  add(query_589253, "maxResults", newJInt(maxResults))
  add(query_589253, "key", newJString(key))
  add(query_589253, "name", newJString(name))
  add(path_589252, "project", newJString(project))
  add(query_589253, "prettyPrint", newJBool(prettyPrint))
  result = call_589251.call(path_589252, query_589253, nil, nil, nil)

var dnsResourceRecordSetsList* = Call_DnsResourceRecordSetsList_589234(
    name: "dnsResourceRecordSetsList", meth: HttpMethod.HttpGet,
    host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/rrsets",
    validator: validate_DnsResourceRecordSetsList_589235,
    base: "/dns/v1/projects", url: url_DnsResourceRecordSetsList_589236,
    schemes: {Scheme.Https})
type
  Call_DnsPoliciesCreate_589271 = ref object of OpenApiRestCall_588441
proc url_DnsPoliciesCreate_589273(protocol: Scheme; host: string; base: string;
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

proc validate_DnsPoliciesCreate_589272(path: JsonNode; query: JsonNode;
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
  var valid_589274 = path.getOrDefault("project")
  valid_589274 = validateParameter(valid_589274, JString, required = true,
                                 default = nil)
  if valid_589274 != nil:
    section.add "project", valid_589274
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
  var valid_589275 = query.getOrDefault("fields")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = nil)
  if valid_589275 != nil:
    section.add "fields", valid_589275
  var valid_589276 = query.getOrDefault("quotaUser")
  valid_589276 = validateParameter(valid_589276, JString, required = false,
                                 default = nil)
  if valid_589276 != nil:
    section.add "quotaUser", valid_589276
  var valid_589277 = query.getOrDefault("alt")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = newJString("json"))
  if valid_589277 != nil:
    section.add "alt", valid_589277
  var valid_589278 = query.getOrDefault("oauth_token")
  valid_589278 = validateParameter(valid_589278, JString, required = false,
                                 default = nil)
  if valid_589278 != nil:
    section.add "oauth_token", valid_589278
  var valid_589279 = query.getOrDefault("userIp")
  valid_589279 = validateParameter(valid_589279, JString, required = false,
                                 default = nil)
  if valid_589279 != nil:
    section.add "userIp", valid_589279
  var valid_589280 = query.getOrDefault("key")
  valid_589280 = validateParameter(valid_589280, JString, required = false,
                                 default = nil)
  if valid_589280 != nil:
    section.add "key", valid_589280
  var valid_589281 = query.getOrDefault("clientOperationId")
  valid_589281 = validateParameter(valid_589281, JString, required = false,
                                 default = nil)
  if valid_589281 != nil:
    section.add "clientOperationId", valid_589281
  var valid_589282 = query.getOrDefault("prettyPrint")
  valid_589282 = validateParameter(valid_589282, JBool, required = false,
                                 default = newJBool(true))
  if valid_589282 != nil:
    section.add "prettyPrint", valid_589282
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

proc call*(call_589284: Call_DnsPoliciesCreate_589271; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new Policy
  ## 
  let valid = call_589284.validator(path, query, header, formData, body)
  let scheme = call_589284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589284.url(scheme.get, call_589284.host, call_589284.base,
                         call_589284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589284, url, valid)

proc call*(call_589285: Call_DnsPoliciesCreate_589271; project: string;
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
  var path_589286 = newJObject()
  var query_589287 = newJObject()
  var body_589288 = newJObject()
  add(query_589287, "fields", newJString(fields))
  add(query_589287, "quotaUser", newJString(quotaUser))
  add(query_589287, "alt", newJString(alt))
  add(query_589287, "oauth_token", newJString(oauthToken))
  add(query_589287, "userIp", newJString(userIp))
  add(query_589287, "key", newJString(key))
  add(query_589287, "clientOperationId", newJString(clientOperationId))
  add(path_589286, "project", newJString(project))
  if body != nil:
    body_589288 = body
  add(query_589287, "prettyPrint", newJBool(prettyPrint))
  result = call_589285.call(path_589286, query_589287, nil, nil, body_589288)

var dnsPoliciesCreate* = Call_DnsPoliciesCreate_589271(name: "dnsPoliciesCreate",
    meth: HttpMethod.HttpPost, host: "dns.googleapis.com",
    route: "/{project}/policies", validator: validate_DnsPoliciesCreate_589272,
    base: "/dns/v1/projects", url: url_DnsPoliciesCreate_589273,
    schemes: {Scheme.Https})
type
  Call_DnsPoliciesList_589254 = ref object of OpenApiRestCall_588441
proc url_DnsPoliciesList_589256(protocol: Scheme; host: string; base: string;
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

proc validate_DnsPoliciesList_589255(path: JsonNode; query: JsonNode;
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
  var valid_589257 = path.getOrDefault("project")
  valid_589257 = validateParameter(valid_589257, JString, required = true,
                                 default = nil)
  if valid_589257 != nil:
    section.add "project", valid_589257
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
  var valid_589258 = query.getOrDefault("fields")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = nil)
  if valid_589258 != nil:
    section.add "fields", valid_589258
  var valid_589259 = query.getOrDefault("pageToken")
  valid_589259 = validateParameter(valid_589259, JString, required = false,
                                 default = nil)
  if valid_589259 != nil:
    section.add "pageToken", valid_589259
  var valid_589260 = query.getOrDefault("quotaUser")
  valid_589260 = validateParameter(valid_589260, JString, required = false,
                                 default = nil)
  if valid_589260 != nil:
    section.add "quotaUser", valid_589260
  var valid_589261 = query.getOrDefault("alt")
  valid_589261 = validateParameter(valid_589261, JString, required = false,
                                 default = newJString("json"))
  if valid_589261 != nil:
    section.add "alt", valid_589261
  var valid_589262 = query.getOrDefault("oauth_token")
  valid_589262 = validateParameter(valid_589262, JString, required = false,
                                 default = nil)
  if valid_589262 != nil:
    section.add "oauth_token", valid_589262
  var valid_589263 = query.getOrDefault("userIp")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = nil)
  if valid_589263 != nil:
    section.add "userIp", valid_589263
  var valid_589264 = query.getOrDefault("maxResults")
  valid_589264 = validateParameter(valid_589264, JInt, required = false, default = nil)
  if valid_589264 != nil:
    section.add "maxResults", valid_589264
  var valid_589265 = query.getOrDefault("key")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = nil)
  if valid_589265 != nil:
    section.add "key", valid_589265
  var valid_589266 = query.getOrDefault("prettyPrint")
  valid_589266 = validateParameter(valid_589266, JBool, required = false,
                                 default = newJBool(true))
  if valid_589266 != nil:
    section.add "prettyPrint", valid_589266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589267: Call_DnsPoliciesList_589254; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enumerate all Policies associated with a project.
  ## 
  let valid = call_589267.validator(path, query, header, formData, body)
  let scheme = call_589267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589267.url(scheme.get, call_589267.host, call_589267.base,
                         call_589267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589267, url, valid)

proc call*(call_589268: Call_DnsPoliciesList_589254; project: string;
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
  var path_589269 = newJObject()
  var query_589270 = newJObject()
  add(query_589270, "fields", newJString(fields))
  add(query_589270, "pageToken", newJString(pageToken))
  add(query_589270, "quotaUser", newJString(quotaUser))
  add(query_589270, "alt", newJString(alt))
  add(query_589270, "oauth_token", newJString(oauthToken))
  add(query_589270, "userIp", newJString(userIp))
  add(query_589270, "maxResults", newJInt(maxResults))
  add(query_589270, "key", newJString(key))
  add(path_589269, "project", newJString(project))
  add(query_589270, "prettyPrint", newJBool(prettyPrint))
  result = call_589268.call(path_589269, query_589270, nil, nil, nil)

var dnsPoliciesList* = Call_DnsPoliciesList_589254(name: "dnsPoliciesList",
    meth: HttpMethod.HttpGet, host: "dns.googleapis.com",
    route: "/{project}/policies", validator: validate_DnsPoliciesList_589255,
    base: "/dns/v1/projects", url: url_DnsPoliciesList_589256,
    schemes: {Scheme.Https})
type
  Call_DnsPoliciesUpdate_589306 = ref object of OpenApiRestCall_588441
proc url_DnsPoliciesUpdate_589308(protocol: Scheme; host: string; base: string;
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

proc validate_DnsPoliciesUpdate_589307(path: JsonNode; query: JsonNode;
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
  var valid_589309 = path.getOrDefault("policy")
  valid_589309 = validateParameter(valid_589309, JString, required = true,
                                 default = nil)
  if valid_589309 != nil:
    section.add "policy", valid_589309
  var valid_589310 = path.getOrDefault("project")
  valid_589310 = validateParameter(valid_589310, JString, required = true,
                                 default = nil)
  if valid_589310 != nil:
    section.add "project", valid_589310
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
  var valid_589311 = query.getOrDefault("fields")
  valid_589311 = validateParameter(valid_589311, JString, required = false,
                                 default = nil)
  if valid_589311 != nil:
    section.add "fields", valid_589311
  var valid_589312 = query.getOrDefault("quotaUser")
  valid_589312 = validateParameter(valid_589312, JString, required = false,
                                 default = nil)
  if valid_589312 != nil:
    section.add "quotaUser", valid_589312
  var valid_589313 = query.getOrDefault("alt")
  valid_589313 = validateParameter(valid_589313, JString, required = false,
                                 default = newJString("json"))
  if valid_589313 != nil:
    section.add "alt", valid_589313
  var valid_589314 = query.getOrDefault("oauth_token")
  valid_589314 = validateParameter(valid_589314, JString, required = false,
                                 default = nil)
  if valid_589314 != nil:
    section.add "oauth_token", valid_589314
  var valid_589315 = query.getOrDefault("userIp")
  valid_589315 = validateParameter(valid_589315, JString, required = false,
                                 default = nil)
  if valid_589315 != nil:
    section.add "userIp", valid_589315
  var valid_589316 = query.getOrDefault("key")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = nil)
  if valid_589316 != nil:
    section.add "key", valid_589316
  var valid_589317 = query.getOrDefault("clientOperationId")
  valid_589317 = validateParameter(valid_589317, JString, required = false,
                                 default = nil)
  if valid_589317 != nil:
    section.add "clientOperationId", valid_589317
  var valid_589318 = query.getOrDefault("prettyPrint")
  valid_589318 = validateParameter(valid_589318, JBool, required = false,
                                 default = newJBool(true))
  if valid_589318 != nil:
    section.add "prettyPrint", valid_589318
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

proc call*(call_589320: Call_DnsPoliciesUpdate_589306; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an existing Policy.
  ## 
  let valid = call_589320.validator(path, query, header, formData, body)
  let scheme = call_589320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589320.url(scheme.get, call_589320.host, call_589320.base,
                         call_589320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589320, url, valid)

proc call*(call_589321: Call_DnsPoliciesUpdate_589306; policy: string;
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
  var path_589322 = newJObject()
  var query_589323 = newJObject()
  var body_589324 = newJObject()
  add(query_589323, "fields", newJString(fields))
  add(path_589322, "policy", newJString(policy))
  add(query_589323, "quotaUser", newJString(quotaUser))
  add(query_589323, "alt", newJString(alt))
  add(query_589323, "oauth_token", newJString(oauthToken))
  add(query_589323, "userIp", newJString(userIp))
  add(query_589323, "key", newJString(key))
  add(query_589323, "clientOperationId", newJString(clientOperationId))
  add(path_589322, "project", newJString(project))
  if body != nil:
    body_589324 = body
  add(query_589323, "prettyPrint", newJBool(prettyPrint))
  result = call_589321.call(path_589322, query_589323, nil, nil, body_589324)

var dnsPoliciesUpdate* = Call_DnsPoliciesUpdate_589306(name: "dnsPoliciesUpdate",
    meth: HttpMethod.HttpPut, host: "dns.googleapis.com",
    route: "/{project}/policies/{policy}", validator: validate_DnsPoliciesUpdate_589307,
    base: "/dns/v1/projects", url: url_DnsPoliciesUpdate_589308,
    schemes: {Scheme.Https})
type
  Call_DnsPoliciesGet_589289 = ref object of OpenApiRestCall_588441
proc url_DnsPoliciesGet_589291(protocol: Scheme; host: string; base: string;
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

proc validate_DnsPoliciesGet_589290(path: JsonNode; query: JsonNode;
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
  var valid_589292 = path.getOrDefault("policy")
  valid_589292 = validateParameter(valid_589292, JString, required = true,
                                 default = nil)
  if valid_589292 != nil:
    section.add "policy", valid_589292
  var valid_589293 = path.getOrDefault("project")
  valid_589293 = validateParameter(valid_589293, JString, required = true,
                                 default = nil)
  if valid_589293 != nil:
    section.add "project", valid_589293
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
  var valid_589294 = query.getOrDefault("fields")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = nil)
  if valid_589294 != nil:
    section.add "fields", valid_589294
  var valid_589295 = query.getOrDefault("quotaUser")
  valid_589295 = validateParameter(valid_589295, JString, required = false,
                                 default = nil)
  if valid_589295 != nil:
    section.add "quotaUser", valid_589295
  var valid_589296 = query.getOrDefault("alt")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = newJString("json"))
  if valid_589296 != nil:
    section.add "alt", valid_589296
  var valid_589297 = query.getOrDefault("oauth_token")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = nil)
  if valid_589297 != nil:
    section.add "oauth_token", valid_589297
  var valid_589298 = query.getOrDefault("userIp")
  valid_589298 = validateParameter(valid_589298, JString, required = false,
                                 default = nil)
  if valid_589298 != nil:
    section.add "userIp", valid_589298
  var valid_589299 = query.getOrDefault("key")
  valid_589299 = validateParameter(valid_589299, JString, required = false,
                                 default = nil)
  if valid_589299 != nil:
    section.add "key", valid_589299
  var valid_589300 = query.getOrDefault("clientOperationId")
  valid_589300 = validateParameter(valid_589300, JString, required = false,
                                 default = nil)
  if valid_589300 != nil:
    section.add "clientOperationId", valid_589300
  var valid_589301 = query.getOrDefault("prettyPrint")
  valid_589301 = validateParameter(valid_589301, JBool, required = false,
                                 default = newJBool(true))
  if valid_589301 != nil:
    section.add "prettyPrint", valid_589301
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589302: Call_DnsPoliciesGet_589289; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetch the representation of an existing Policy.
  ## 
  let valid = call_589302.validator(path, query, header, formData, body)
  let scheme = call_589302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589302.url(scheme.get, call_589302.host, call_589302.base,
                         call_589302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589302, url, valid)

proc call*(call_589303: Call_DnsPoliciesGet_589289; policy: string; project: string;
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
  var path_589304 = newJObject()
  var query_589305 = newJObject()
  add(query_589305, "fields", newJString(fields))
  add(path_589304, "policy", newJString(policy))
  add(query_589305, "quotaUser", newJString(quotaUser))
  add(query_589305, "alt", newJString(alt))
  add(query_589305, "oauth_token", newJString(oauthToken))
  add(query_589305, "userIp", newJString(userIp))
  add(query_589305, "key", newJString(key))
  add(query_589305, "clientOperationId", newJString(clientOperationId))
  add(path_589304, "project", newJString(project))
  add(query_589305, "prettyPrint", newJBool(prettyPrint))
  result = call_589303.call(path_589304, query_589305, nil, nil, nil)

var dnsPoliciesGet* = Call_DnsPoliciesGet_589289(name: "dnsPoliciesGet",
    meth: HttpMethod.HttpGet, host: "dns.googleapis.com",
    route: "/{project}/policies/{policy}", validator: validate_DnsPoliciesGet_589290,
    base: "/dns/v1/projects", url: url_DnsPoliciesGet_589291,
    schemes: {Scheme.Https})
type
  Call_DnsPoliciesPatch_589342 = ref object of OpenApiRestCall_588441
proc url_DnsPoliciesPatch_589344(protocol: Scheme; host: string; base: string;
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

proc validate_DnsPoliciesPatch_589343(path: JsonNode; query: JsonNode;
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
  var valid_589345 = path.getOrDefault("policy")
  valid_589345 = validateParameter(valid_589345, JString, required = true,
                                 default = nil)
  if valid_589345 != nil:
    section.add "policy", valid_589345
  var valid_589346 = path.getOrDefault("project")
  valid_589346 = validateParameter(valid_589346, JString, required = true,
                                 default = nil)
  if valid_589346 != nil:
    section.add "project", valid_589346
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
  var valid_589347 = query.getOrDefault("fields")
  valid_589347 = validateParameter(valid_589347, JString, required = false,
                                 default = nil)
  if valid_589347 != nil:
    section.add "fields", valid_589347
  var valid_589348 = query.getOrDefault("quotaUser")
  valid_589348 = validateParameter(valid_589348, JString, required = false,
                                 default = nil)
  if valid_589348 != nil:
    section.add "quotaUser", valid_589348
  var valid_589349 = query.getOrDefault("alt")
  valid_589349 = validateParameter(valid_589349, JString, required = false,
                                 default = newJString("json"))
  if valid_589349 != nil:
    section.add "alt", valid_589349
  var valid_589350 = query.getOrDefault("oauth_token")
  valid_589350 = validateParameter(valid_589350, JString, required = false,
                                 default = nil)
  if valid_589350 != nil:
    section.add "oauth_token", valid_589350
  var valid_589351 = query.getOrDefault("userIp")
  valid_589351 = validateParameter(valid_589351, JString, required = false,
                                 default = nil)
  if valid_589351 != nil:
    section.add "userIp", valid_589351
  var valid_589352 = query.getOrDefault("key")
  valid_589352 = validateParameter(valid_589352, JString, required = false,
                                 default = nil)
  if valid_589352 != nil:
    section.add "key", valid_589352
  var valid_589353 = query.getOrDefault("clientOperationId")
  valid_589353 = validateParameter(valid_589353, JString, required = false,
                                 default = nil)
  if valid_589353 != nil:
    section.add "clientOperationId", valid_589353
  var valid_589354 = query.getOrDefault("prettyPrint")
  valid_589354 = validateParameter(valid_589354, JBool, required = false,
                                 default = newJBool(true))
  if valid_589354 != nil:
    section.add "prettyPrint", valid_589354
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

proc call*(call_589356: Call_DnsPoliciesPatch_589342; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Apply a partial update to an existing Policy.
  ## 
  let valid = call_589356.validator(path, query, header, formData, body)
  let scheme = call_589356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589356.url(scheme.get, call_589356.host, call_589356.base,
                         call_589356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589356, url, valid)

proc call*(call_589357: Call_DnsPoliciesPatch_589342; policy: string;
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
  var path_589358 = newJObject()
  var query_589359 = newJObject()
  var body_589360 = newJObject()
  add(query_589359, "fields", newJString(fields))
  add(path_589358, "policy", newJString(policy))
  add(query_589359, "quotaUser", newJString(quotaUser))
  add(query_589359, "alt", newJString(alt))
  add(query_589359, "oauth_token", newJString(oauthToken))
  add(query_589359, "userIp", newJString(userIp))
  add(query_589359, "key", newJString(key))
  add(query_589359, "clientOperationId", newJString(clientOperationId))
  add(path_589358, "project", newJString(project))
  if body != nil:
    body_589360 = body
  add(query_589359, "prettyPrint", newJBool(prettyPrint))
  result = call_589357.call(path_589358, query_589359, nil, nil, body_589360)

var dnsPoliciesPatch* = Call_DnsPoliciesPatch_589342(name: "dnsPoliciesPatch",
    meth: HttpMethod.HttpPatch, host: "dns.googleapis.com",
    route: "/{project}/policies/{policy}", validator: validate_DnsPoliciesPatch_589343,
    base: "/dns/v1/projects", url: url_DnsPoliciesPatch_589344,
    schemes: {Scheme.Https})
type
  Call_DnsPoliciesDelete_589325 = ref object of OpenApiRestCall_588441
proc url_DnsPoliciesDelete_589327(protocol: Scheme; host: string; base: string;
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

proc validate_DnsPoliciesDelete_589326(path: JsonNode; query: JsonNode;
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
  var valid_589328 = path.getOrDefault("policy")
  valid_589328 = validateParameter(valid_589328, JString, required = true,
                                 default = nil)
  if valid_589328 != nil:
    section.add "policy", valid_589328
  var valid_589329 = path.getOrDefault("project")
  valid_589329 = validateParameter(valid_589329, JString, required = true,
                                 default = nil)
  if valid_589329 != nil:
    section.add "project", valid_589329
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
  var valid_589330 = query.getOrDefault("fields")
  valid_589330 = validateParameter(valid_589330, JString, required = false,
                                 default = nil)
  if valid_589330 != nil:
    section.add "fields", valid_589330
  var valid_589331 = query.getOrDefault("quotaUser")
  valid_589331 = validateParameter(valid_589331, JString, required = false,
                                 default = nil)
  if valid_589331 != nil:
    section.add "quotaUser", valid_589331
  var valid_589332 = query.getOrDefault("alt")
  valid_589332 = validateParameter(valid_589332, JString, required = false,
                                 default = newJString("json"))
  if valid_589332 != nil:
    section.add "alt", valid_589332
  var valid_589333 = query.getOrDefault("oauth_token")
  valid_589333 = validateParameter(valid_589333, JString, required = false,
                                 default = nil)
  if valid_589333 != nil:
    section.add "oauth_token", valid_589333
  var valid_589334 = query.getOrDefault("userIp")
  valid_589334 = validateParameter(valid_589334, JString, required = false,
                                 default = nil)
  if valid_589334 != nil:
    section.add "userIp", valid_589334
  var valid_589335 = query.getOrDefault("key")
  valid_589335 = validateParameter(valid_589335, JString, required = false,
                                 default = nil)
  if valid_589335 != nil:
    section.add "key", valid_589335
  var valid_589336 = query.getOrDefault("clientOperationId")
  valid_589336 = validateParameter(valid_589336, JString, required = false,
                                 default = nil)
  if valid_589336 != nil:
    section.add "clientOperationId", valid_589336
  var valid_589337 = query.getOrDefault("prettyPrint")
  valid_589337 = validateParameter(valid_589337, JBool, required = false,
                                 default = newJBool(true))
  if valid_589337 != nil:
    section.add "prettyPrint", valid_589337
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589338: Call_DnsPoliciesDelete_589325; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a previously created Policy. Will fail if the policy is still being referenced by a network.
  ## 
  let valid = call_589338.validator(path, query, header, formData, body)
  let scheme = call_589338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589338.url(scheme.get, call_589338.host, call_589338.base,
                         call_589338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589338, url, valid)

proc call*(call_589339: Call_DnsPoliciesDelete_589325; policy: string;
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
  var path_589340 = newJObject()
  var query_589341 = newJObject()
  add(query_589341, "fields", newJString(fields))
  add(path_589340, "policy", newJString(policy))
  add(query_589341, "quotaUser", newJString(quotaUser))
  add(query_589341, "alt", newJString(alt))
  add(query_589341, "oauth_token", newJString(oauthToken))
  add(query_589341, "userIp", newJString(userIp))
  add(query_589341, "key", newJString(key))
  add(query_589341, "clientOperationId", newJString(clientOperationId))
  add(path_589340, "project", newJString(project))
  add(query_589341, "prettyPrint", newJBool(prettyPrint))
  result = call_589339.call(path_589340, query_589341, nil, nil, nil)

var dnsPoliciesDelete* = Call_DnsPoliciesDelete_589325(name: "dnsPoliciesDelete",
    meth: HttpMethod.HttpDelete, host: "dns.googleapis.com",
    route: "/{project}/policies/{policy}", validator: validate_DnsPoliciesDelete_589326,
    base: "/dns/v1/projects", url: url_DnsPoliciesDelete_589327,
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
