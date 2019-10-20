
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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

  OpenApiRestCall_578339 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578339](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578339): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "dns"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DnsProjectsGet_578609 = ref object of OpenApiRestCall_578339
proc url_DnsProjectsGet_578611(protocol: Scheme; host: string; base: string;
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

proc validate_DnsProjectsGet_578610(path: JsonNode; query: JsonNode;
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
  var valid_578737 = path.getOrDefault("project")
  valid_578737 = validateParameter(valid_578737, JString, required = true,
                                 default = nil)
  if valid_578737 != nil:
    section.add "project", valid_578737
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   clientOperationId: JString
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578738 = query.getOrDefault("key")
  valid_578738 = validateParameter(valid_578738, JString, required = false,
                                 default = nil)
  if valid_578738 != nil:
    section.add "key", valid_578738
  var valid_578752 = query.getOrDefault("prettyPrint")
  valid_578752 = validateParameter(valid_578752, JBool, required = false,
                                 default = newJBool(true))
  if valid_578752 != nil:
    section.add "prettyPrint", valid_578752
  var valid_578753 = query.getOrDefault("oauth_token")
  valid_578753 = validateParameter(valid_578753, JString, required = false,
                                 default = nil)
  if valid_578753 != nil:
    section.add "oauth_token", valid_578753
  var valid_578754 = query.getOrDefault("alt")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = newJString("json"))
  if valid_578754 != nil:
    section.add "alt", valid_578754
  var valid_578755 = query.getOrDefault("userIp")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "userIp", valid_578755
  var valid_578756 = query.getOrDefault("quotaUser")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "quotaUser", valid_578756
  var valid_578757 = query.getOrDefault("clientOperationId")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "clientOperationId", valid_578757
  var valid_578758 = query.getOrDefault("fields")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "fields", valid_578758
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578781: Call_DnsProjectsGet_578609; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetch the representation of an existing Project.
  ## 
  let valid = call_578781.validator(path, query, header, formData, body)
  let scheme = call_578781.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578781.url(scheme.get, call_578781.host, call_578781.base,
                         call_578781.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578781, url, valid)

proc call*(call_578852: Call_DnsProjectsGet_578609; project: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          clientOperationId: string = ""; fields: string = ""): Recallable =
  ## dnsProjectsGet
  ## Fetch the representation of an existing Project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   clientOperationId: string
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578853 = newJObject()
  var query_578855 = newJObject()
  add(query_578855, "key", newJString(key))
  add(query_578855, "prettyPrint", newJBool(prettyPrint))
  add(query_578855, "oauth_token", newJString(oauthToken))
  add(query_578855, "alt", newJString(alt))
  add(query_578855, "userIp", newJString(userIp))
  add(query_578855, "quotaUser", newJString(quotaUser))
  add(path_578853, "project", newJString(project))
  add(query_578855, "clientOperationId", newJString(clientOperationId))
  add(query_578855, "fields", newJString(fields))
  result = call_578852.call(path_578853, query_578855, nil, nil, nil)

var dnsProjectsGet* = Call_DnsProjectsGet_578609(name: "dnsProjectsGet",
    meth: HttpMethod.HttpGet, host: "dns.googleapis.com", route: "/{project}",
    validator: validate_DnsProjectsGet_578610, base: "/dns/v1beta2/projects",
    url: url_DnsProjectsGet_578611, schemes: {Scheme.Https})
type
  Call_DnsManagedZonesCreate_578912 = ref object of OpenApiRestCall_578339
proc url_DnsManagedZonesCreate_578914(protocol: Scheme; host: string; base: string;
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

proc validate_DnsManagedZonesCreate_578913(path: JsonNode; query: JsonNode;
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
  var valid_578915 = path.getOrDefault("project")
  valid_578915 = validateParameter(valid_578915, JString, required = true,
                                 default = nil)
  if valid_578915 != nil:
    section.add "project", valid_578915
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   clientOperationId: JString
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578916 = query.getOrDefault("key")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "key", valid_578916
  var valid_578917 = query.getOrDefault("prettyPrint")
  valid_578917 = validateParameter(valid_578917, JBool, required = false,
                                 default = newJBool(true))
  if valid_578917 != nil:
    section.add "prettyPrint", valid_578917
  var valid_578918 = query.getOrDefault("oauth_token")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "oauth_token", valid_578918
  var valid_578919 = query.getOrDefault("alt")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = newJString("json"))
  if valid_578919 != nil:
    section.add "alt", valid_578919
  var valid_578920 = query.getOrDefault("userIp")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "userIp", valid_578920
  var valid_578921 = query.getOrDefault("quotaUser")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "quotaUser", valid_578921
  var valid_578922 = query.getOrDefault("clientOperationId")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "clientOperationId", valid_578922
  var valid_578923 = query.getOrDefault("fields")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "fields", valid_578923
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

proc call*(call_578925: Call_DnsManagedZonesCreate_578912; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new ManagedZone.
  ## 
  let valid = call_578925.validator(path, query, header, formData, body)
  let scheme = call_578925.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578925.url(scheme.get, call_578925.host, call_578925.base,
                         call_578925.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578925, url, valid)

proc call*(call_578926: Call_DnsManagedZonesCreate_578912; project: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          clientOperationId: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## dnsManagedZonesCreate
  ## Create a new ManagedZone.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   clientOperationId: string
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578927 = newJObject()
  var query_578928 = newJObject()
  var body_578929 = newJObject()
  add(query_578928, "key", newJString(key))
  add(query_578928, "prettyPrint", newJBool(prettyPrint))
  add(query_578928, "oauth_token", newJString(oauthToken))
  add(query_578928, "alt", newJString(alt))
  add(query_578928, "userIp", newJString(userIp))
  add(query_578928, "quotaUser", newJString(quotaUser))
  add(path_578927, "project", newJString(project))
  add(query_578928, "clientOperationId", newJString(clientOperationId))
  if body != nil:
    body_578929 = body
  add(query_578928, "fields", newJString(fields))
  result = call_578926.call(path_578927, query_578928, nil, nil, body_578929)

var dnsManagedZonesCreate* = Call_DnsManagedZonesCreate_578912(
    name: "dnsManagedZonesCreate", meth: HttpMethod.HttpPost,
    host: "dns.googleapis.com", route: "/{project}/managedZones",
    validator: validate_DnsManagedZonesCreate_578913,
    base: "/dns/v1beta2/projects", url: url_DnsManagedZonesCreate_578914,
    schemes: {Scheme.Https})
type
  Call_DnsManagedZonesList_578894 = ref object of OpenApiRestCall_578339
proc url_DnsManagedZonesList_578896(protocol: Scheme; host: string; base: string;
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

proc validate_DnsManagedZonesList_578895(path: JsonNode; query: JsonNode;
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
  var valid_578897 = path.getOrDefault("project")
  valid_578897 = validateParameter(valid_578897, JString, required = true,
                                 default = nil)
  if valid_578897 != nil:
    section.add "project", valid_578897
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   dnsName: JString
  ##          : Restricts the list to return only zones with this domain name.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : Optional. A tag returned by a previous list request that was truncated. Use this parameter to continue a previous list request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Optional. Maximum number of results to be returned. If unspecified, the server will decide how many results to return.
  section = newJObject()
  var valid_578898 = query.getOrDefault("key")
  valid_578898 = validateParameter(valid_578898, JString, required = false,
                                 default = nil)
  if valid_578898 != nil:
    section.add "key", valid_578898
  var valid_578899 = query.getOrDefault("prettyPrint")
  valid_578899 = validateParameter(valid_578899, JBool, required = false,
                                 default = newJBool(true))
  if valid_578899 != nil:
    section.add "prettyPrint", valid_578899
  var valid_578900 = query.getOrDefault("oauth_token")
  valid_578900 = validateParameter(valid_578900, JString, required = false,
                                 default = nil)
  if valid_578900 != nil:
    section.add "oauth_token", valid_578900
  var valid_578901 = query.getOrDefault("alt")
  valid_578901 = validateParameter(valid_578901, JString, required = false,
                                 default = newJString("json"))
  if valid_578901 != nil:
    section.add "alt", valid_578901
  var valid_578902 = query.getOrDefault("userIp")
  valid_578902 = validateParameter(valid_578902, JString, required = false,
                                 default = nil)
  if valid_578902 != nil:
    section.add "userIp", valid_578902
  var valid_578903 = query.getOrDefault("dnsName")
  valid_578903 = validateParameter(valid_578903, JString, required = false,
                                 default = nil)
  if valid_578903 != nil:
    section.add "dnsName", valid_578903
  var valid_578904 = query.getOrDefault("quotaUser")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "quotaUser", valid_578904
  var valid_578905 = query.getOrDefault("pageToken")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = nil)
  if valid_578905 != nil:
    section.add "pageToken", valid_578905
  var valid_578906 = query.getOrDefault("fields")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = nil)
  if valid_578906 != nil:
    section.add "fields", valid_578906
  var valid_578907 = query.getOrDefault("maxResults")
  valid_578907 = validateParameter(valid_578907, JInt, required = false, default = nil)
  if valid_578907 != nil:
    section.add "maxResults", valid_578907
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578908: Call_DnsManagedZonesList_578894; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enumerate ManagedZones that have been created but not yet deleted.
  ## 
  let valid = call_578908.validator(path, query, header, formData, body)
  let scheme = call_578908.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578908.url(scheme.get, call_578908.host, call_578908.base,
                         call_578908.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578908, url, valid)

proc call*(call_578909: Call_DnsManagedZonesList_578894; project: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; dnsName: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## dnsManagedZonesList
  ## Enumerate ManagedZones that have been created but not yet deleted.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   dnsName: string
  ##          : Restricts the list to return only zones with this domain name.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Optional. A tag returned by a previous list request that was truncated. Use this parameter to continue a previous list request.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Optional. Maximum number of results to be returned. If unspecified, the server will decide how many results to return.
  var path_578910 = newJObject()
  var query_578911 = newJObject()
  add(query_578911, "key", newJString(key))
  add(query_578911, "prettyPrint", newJBool(prettyPrint))
  add(query_578911, "oauth_token", newJString(oauthToken))
  add(query_578911, "alt", newJString(alt))
  add(query_578911, "userIp", newJString(userIp))
  add(query_578911, "dnsName", newJString(dnsName))
  add(query_578911, "quotaUser", newJString(quotaUser))
  add(query_578911, "pageToken", newJString(pageToken))
  add(path_578910, "project", newJString(project))
  add(query_578911, "fields", newJString(fields))
  add(query_578911, "maxResults", newJInt(maxResults))
  result = call_578909.call(path_578910, query_578911, nil, nil, nil)

var dnsManagedZonesList* = Call_DnsManagedZonesList_578894(
    name: "dnsManagedZonesList", meth: HttpMethod.HttpGet,
    host: "dns.googleapis.com", route: "/{project}/managedZones",
    validator: validate_DnsManagedZonesList_578895, base: "/dns/v1beta2/projects",
    url: url_DnsManagedZonesList_578896, schemes: {Scheme.Https})
type
  Call_DnsManagedZonesUpdate_578947 = ref object of OpenApiRestCall_578339
proc url_DnsManagedZonesUpdate_578949(protocol: Scheme; host: string; base: string;
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

proc validate_DnsManagedZonesUpdate_578948(path: JsonNode; query: JsonNode;
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
  var valid_578950 = path.getOrDefault("managedZone")
  valid_578950 = validateParameter(valid_578950, JString, required = true,
                                 default = nil)
  if valid_578950 != nil:
    section.add "managedZone", valid_578950
  var valid_578951 = path.getOrDefault("project")
  valid_578951 = validateParameter(valid_578951, JString, required = true,
                                 default = nil)
  if valid_578951 != nil:
    section.add "project", valid_578951
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   clientOperationId: JString
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578952 = query.getOrDefault("key")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "key", valid_578952
  var valid_578953 = query.getOrDefault("prettyPrint")
  valid_578953 = validateParameter(valid_578953, JBool, required = false,
                                 default = newJBool(true))
  if valid_578953 != nil:
    section.add "prettyPrint", valid_578953
  var valid_578954 = query.getOrDefault("oauth_token")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "oauth_token", valid_578954
  var valid_578955 = query.getOrDefault("alt")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = newJString("json"))
  if valid_578955 != nil:
    section.add "alt", valid_578955
  var valid_578956 = query.getOrDefault("userIp")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "userIp", valid_578956
  var valid_578957 = query.getOrDefault("quotaUser")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "quotaUser", valid_578957
  var valid_578958 = query.getOrDefault("clientOperationId")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "clientOperationId", valid_578958
  var valid_578959 = query.getOrDefault("fields")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "fields", valid_578959
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

proc call*(call_578961: Call_DnsManagedZonesUpdate_578947; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an existing ManagedZone.
  ## 
  let valid = call_578961.validator(path, query, header, formData, body)
  let scheme = call_578961.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578961.url(scheme.get, call_578961.host, call_578961.base,
                         call_578961.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578961, url, valid)

proc call*(call_578962: Call_DnsManagedZonesUpdate_578947; managedZone: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; clientOperationId: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## dnsManagedZonesUpdate
  ## Update an existing ManagedZone.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   managedZone: string (required)
  ##              : Identifies the managed zone addressed by this request. Can be the managed zone name or id.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   clientOperationId: string
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578963 = newJObject()
  var query_578964 = newJObject()
  var body_578965 = newJObject()
  add(query_578964, "key", newJString(key))
  add(query_578964, "prettyPrint", newJBool(prettyPrint))
  add(query_578964, "oauth_token", newJString(oauthToken))
  add(path_578963, "managedZone", newJString(managedZone))
  add(query_578964, "alt", newJString(alt))
  add(query_578964, "userIp", newJString(userIp))
  add(query_578964, "quotaUser", newJString(quotaUser))
  add(path_578963, "project", newJString(project))
  add(query_578964, "clientOperationId", newJString(clientOperationId))
  if body != nil:
    body_578965 = body
  add(query_578964, "fields", newJString(fields))
  result = call_578962.call(path_578963, query_578964, nil, nil, body_578965)

var dnsManagedZonesUpdate* = Call_DnsManagedZonesUpdate_578947(
    name: "dnsManagedZonesUpdate", meth: HttpMethod.HttpPut,
    host: "dns.googleapis.com", route: "/{project}/managedZones/{managedZone}",
    validator: validate_DnsManagedZonesUpdate_578948,
    base: "/dns/v1beta2/projects", url: url_DnsManagedZonesUpdate_578949,
    schemes: {Scheme.Https})
type
  Call_DnsManagedZonesGet_578930 = ref object of OpenApiRestCall_578339
proc url_DnsManagedZonesGet_578932(protocol: Scheme; host: string; base: string;
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

proc validate_DnsManagedZonesGet_578931(path: JsonNode; query: JsonNode;
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
  var valid_578933 = path.getOrDefault("managedZone")
  valid_578933 = validateParameter(valid_578933, JString, required = true,
                                 default = nil)
  if valid_578933 != nil:
    section.add "managedZone", valid_578933
  var valid_578934 = path.getOrDefault("project")
  valid_578934 = validateParameter(valid_578934, JString, required = true,
                                 default = nil)
  if valid_578934 != nil:
    section.add "project", valid_578934
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   clientOperationId: JString
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578935 = query.getOrDefault("key")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "key", valid_578935
  var valid_578936 = query.getOrDefault("prettyPrint")
  valid_578936 = validateParameter(valid_578936, JBool, required = false,
                                 default = newJBool(true))
  if valid_578936 != nil:
    section.add "prettyPrint", valid_578936
  var valid_578937 = query.getOrDefault("oauth_token")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "oauth_token", valid_578937
  var valid_578938 = query.getOrDefault("alt")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = newJString("json"))
  if valid_578938 != nil:
    section.add "alt", valid_578938
  var valid_578939 = query.getOrDefault("userIp")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "userIp", valid_578939
  var valid_578940 = query.getOrDefault("quotaUser")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "quotaUser", valid_578940
  var valid_578941 = query.getOrDefault("clientOperationId")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "clientOperationId", valid_578941
  var valid_578942 = query.getOrDefault("fields")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "fields", valid_578942
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578943: Call_DnsManagedZonesGet_578930; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetch the representation of an existing ManagedZone.
  ## 
  let valid = call_578943.validator(path, query, header, formData, body)
  let scheme = call_578943.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578943.url(scheme.get, call_578943.host, call_578943.base,
                         call_578943.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578943, url, valid)

proc call*(call_578944: Call_DnsManagedZonesGet_578930; managedZone: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; clientOperationId: string = ""; fields: string = ""): Recallable =
  ## dnsManagedZonesGet
  ## Fetch the representation of an existing ManagedZone.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   managedZone: string (required)
  ##              : Identifies the managed zone addressed by this request. Can be the managed zone name or id.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   clientOperationId: string
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578945 = newJObject()
  var query_578946 = newJObject()
  add(query_578946, "key", newJString(key))
  add(query_578946, "prettyPrint", newJBool(prettyPrint))
  add(query_578946, "oauth_token", newJString(oauthToken))
  add(path_578945, "managedZone", newJString(managedZone))
  add(query_578946, "alt", newJString(alt))
  add(query_578946, "userIp", newJString(userIp))
  add(query_578946, "quotaUser", newJString(quotaUser))
  add(path_578945, "project", newJString(project))
  add(query_578946, "clientOperationId", newJString(clientOperationId))
  add(query_578946, "fields", newJString(fields))
  result = call_578944.call(path_578945, query_578946, nil, nil, nil)

var dnsManagedZonesGet* = Call_DnsManagedZonesGet_578930(
    name: "dnsManagedZonesGet", meth: HttpMethod.HttpGet,
    host: "dns.googleapis.com", route: "/{project}/managedZones/{managedZone}",
    validator: validate_DnsManagedZonesGet_578931, base: "/dns/v1beta2/projects",
    url: url_DnsManagedZonesGet_578932, schemes: {Scheme.Https})
type
  Call_DnsManagedZonesPatch_578983 = ref object of OpenApiRestCall_578339
proc url_DnsManagedZonesPatch_578985(protocol: Scheme; host: string; base: string;
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

proc validate_DnsManagedZonesPatch_578984(path: JsonNode; query: JsonNode;
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
  var valid_578986 = path.getOrDefault("managedZone")
  valid_578986 = validateParameter(valid_578986, JString, required = true,
                                 default = nil)
  if valid_578986 != nil:
    section.add "managedZone", valid_578986
  var valid_578987 = path.getOrDefault("project")
  valid_578987 = validateParameter(valid_578987, JString, required = true,
                                 default = nil)
  if valid_578987 != nil:
    section.add "project", valid_578987
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   clientOperationId: JString
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578988 = query.getOrDefault("key")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "key", valid_578988
  var valid_578989 = query.getOrDefault("prettyPrint")
  valid_578989 = validateParameter(valid_578989, JBool, required = false,
                                 default = newJBool(true))
  if valid_578989 != nil:
    section.add "prettyPrint", valid_578989
  var valid_578990 = query.getOrDefault("oauth_token")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "oauth_token", valid_578990
  var valid_578991 = query.getOrDefault("alt")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = newJString("json"))
  if valid_578991 != nil:
    section.add "alt", valid_578991
  var valid_578992 = query.getOrDefault("userIp")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "userIp", valid_578992
  var valid_578993 = query.getOrDefault("quotaUser")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "quotaUser", valid_578993
  var valid_578994 = query.getOrDefault("clientOperationId")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "clientOperationId", valid_578994
  var valid_578995 = query.getOrDefault("fields")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "fields", valid_578995
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

proc call*(call_578997: Call_DnsManagedZonesPatch_578983; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Apply a partial update to an existing ManagedZone.
  ## 
  let valid = call_578997.validator(path, query, header, formData, body)
  let scheme = call_578997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578997.url(scheme.get, call_578997.host, call_578997.base,
                         call_578997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578997, url, valid)

proc call*(call_578998: Call_DnsManagedZonesPatch_578983; managedZone: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; clientOperationId: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## dnsManagedZonesPatch
  ## Apply a partial update to an existing ManagedZone.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   managedZone: string (required)
  ##              : Identifies the managed zone addressed by this request. Can be the managed zone name or id.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   clientOperationId: string
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578999 = newJObject()
  var query_579000 = newJObject()
  var body_579001 = newJObject()
  add(query_579000, "key", newJString(key))
  add(query_579000, "prettyPrint", newJBool(prettyPrint))
  add(query_579000, "oauth_token", newJString(oauthToken))
  add(path_578999, "managedZone", newJString(managedZone))
  add(query_579000, "alt", newJString(alt))
  add(query_579000, "userIp", newJString(userIp))
  add(query_579000, "quotaUser", newJString(quotaUser))
  add(path_578999, "project", newJString(project))
  add(query_579000, "clientOperationId", newJString(clientOperationId))
  if body != nil:
    body_579001 = body
  add(query_579000, "fields", newJString(fields))
  result = call_578998.call(path_578999, query_579000, nil, nil, body_579001)

var dnsManagedZonesPatch* = Call_DnsManagedZonesPatch_578983(
    name: "dnsManagedZonesPatch", meth: HttpMethod.HttpPatch,
    host: "dns.googleapis.com", route: "/{project}/managedZones/{managedZone}",
    validator: validate_DnsManagedZonesPatch_578984,
    base: "/dns/v1beta2/projects", url: url_DnsManagedZonesPatch_578985,
    schemes: {Scheme.Https})
type
  Call_DnsManagedZonesDelete_578966 = ref object of OpenApiRestCall_578339
proc url_DnsManagedZonesDelete_578968(protocol: Scheme; host: string; base: string;
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

proc validate_DnsManagedZonesDelete_578967(path: JsonNode; query: JsonNode;
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
  var valid_578969 = path.getOrDefault("managedZone")
  valid_578969 = validateParameter(valid_578969, JString, required = true,
                                 default = nil)
  if valid_578969 != nil:
    section.add "managedZone", valid_578969
  var valid_578970 = path.getOrDefault("project")
  valid_578970 = validateParameter(valid_578970, JString, required = true,
                                 default = nil)
  if valid_578970 != nil:
    section.add "project", valid_578970
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   clientOperationId: JString
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578971 = query.getOrDefault("key")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "key", valid_578971
  var valid_578972 = query.getOrDefault("prettyPrint")
  valid_578972 = validateParameter(valid_578972, JBool, required = false,
                                 default = newJBool(true))
  if valid_578972 != nil:
    section.add "prettyPrint", valid_578972
  var valid_578973 = query.getOrDefault("oauth_token")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "oauth_token", valid_578973
  var valid_578974 = query.getOrDefault("alt")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = newJString("json"))
  if valid_578974 != nil:
    section.add "alt", valid_578974
  var valid_578975 = query.getOrDefault("userIp")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "userIp", valid_578975
  var valid_578976 = query.getOrDefault("quotaUser")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "quotaUser", valid_578976
  var valid_578977 = query.getOrDefault("clientOperationId")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "clientOperationId", valid_578977
  var valid_578978 = query.getOrDefault("fields")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "fields", valid_578978
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578979: Call_DnsManagedZonesDelete_578966; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a previously created ManagedZone.
  ## 
  let valid = call_578979.validator(path, query, header, formData, body)
  let scheme = call_578979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578979.url(scheme.get, call_578979.host, call_578979.base,
                         call_578979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578979, url, valid)

proc call*(call_578980: Call_DnsManagedZonesDelete_578966; managedZone: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; clientOperationId: string = ""; fields: string = ""): Recallable =
  ## dnsManagedZonesDelete
  ## Delete a previously created ManagedZone.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   managedZone: string (required)
  ##              : Identifies the managed zone addressed by this request. Can be the managed zone name or id.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   clientOperationId: string
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578981 = newJObject()
  var query_578982 = newJObject()
  add(query_578982, "key", newJString(key))
  add(query_578982, "prettyPrint", newJBool(prettyPrint))
  add(query_578982, "oauth_token", newJString(oauthToken))
  add(path_578981, "managedZone", newJString(managedZone))
  add(query_578982, "alt", newJString(alt))
  add(query_578982, "userIp", newJString(userIp))
  add(query_578982, "quotaUser", newJString(quotaUser))
  add(path_578981, "project", newJString(project))
  add(query_578982, "clientOperationId", newJString(clientOperationId))
  add(query_578982, "fields", newJString(fields))
  result = call_578980.call(path_578981, query_578982, nil, nil, nil)

var dnsManagedZonesDelete* = Call_DnsManagedZonesDelete_578966(
    name: "dnsManagedZonesDelete", meth: HttpMethod.HttpDelete,
    host: "dns.googleapis.com", route: "/{project}/managedZones/{managedZone}",
    validator: validate_DnsManagedZonesDelete_578967,
    base: "/dns/v1beta2/projects", url: url_DnsManagedZonesDelete_578968,
    schemes: {Scheme.Https})
type
  Call_DnsChangesCreate_579022 = ref object of OpenApiRestCall_578339
proc url_DnsChangesCreate_579024(protocol: Scheme; host: string; base: string;
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

proc validate_DnsChangesCreate_579023(path: JsonNode; query: JsonNode;
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
  var valid_579025 = path.getOrDefault("managedZone")
  valid_579025 = validateParameter(valid_579025, JString, required = true,
                                 default = nil)
  if valid_579025 != nil:
    section.add "managedZone", valid_579025
  var valid_579026 = path.getOrDefault("project")
  valid_579026 = validateParameter(valid_579026, JString, required = true,
                                 default = nil)
  if valid_579026 != nil:
    section.add "project", valid_579026
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   clientOperationId: JString
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579027 = query.getOrDefault("key")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "key", valid_579027
  var valid_579028 = query.getOrDefault("prettyPrint")
  valid_579028 = validateParameter(valid_579028, JBool, required = false,
                                 default = newJBool(true))
  if valid_579028 != nil:
    section.add "prettyPrint", valid_579028
  var valid_579029 = query.getOrDefault("oauth_token")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "oauth_token", valid_579029
  var valid_579030 = query.getOrDefault("alt")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = newJString("json"))
  if valid_579030 != nil:
    section.add "alt", valid_579030
  var valid_579031 = query.getOrDefault("userIp")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "userIp", valid_579031
  var valid_579032 = query.getOrDefault("quotaUser")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "quotaUser", valid_579032
  var valid_579033 = query.getOrDefault("clientOperationId")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "clientOperationId", valid_579033
  var valid_579034 = query.getOrDefault("fields")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "fields", valid_579034
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

proc call*(call_579036: Call_DnsChangesCreate_579022; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Atomically update the ResourceRecordSet collection.
  ## 
  let valid = call_579036.validator(path, query, header, formData, body)
  let scheme = call_579036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579036.url(scheme.get, call_579036.host, call_579036.base,
                         call_579036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579036, url, valid)

proc call*(call_579037: Call_DnsChangesCreate_579022; managedZone: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; clientOperationId: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## dnsChangesCreate
  ## Atomically update the ResourceRecordSet collection.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   managedZone: string (required)
  ##              : Identifies the managed zone addressed by this request. Can be the managed zone name or id.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   clientOperationId: string
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579038 = newJObject()
  var query_579039 = newJObject()
  var body_579040 = newJObject()
  add(query_579039, "key", newJString(key))
  add(query_579039, "prettyPrint", newJBool(prettyPrint))
  add(query_579039, "oauth_token", newJString(oauthToken))
  add(path_579038, "managedZone", newJString(managedZone))
  add(query_579039, "alt", newJString(alt))
  add(query_579039, "userIp", newJString(userIp))
  add(query_579039, "quotaUser", newJString(quotaUser))
  add(path_579038, "project", newJString(project))
  add(query_579039, "clientOperationId", newJString(clientOperationId))
  if body != nil:
    body_579040 = body
  add(query_579039, "fields", newJString(fields))
  result = call_579037.call(path_579038, query_579039, nil, nil, body_579040)

var dnsChangesCreate* = Call_DnsChangesCreate_579022(name: "dnsChangesCreate",
    meth: HttpMethod.HttpPost, host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/changes",
    validator: validate_DnsChangesCreate_579023, base: "/dns/v1beta2/projects",
    url: url_DnsChangesCreate_579024, schemes: {Scheme.Https})
type
  Call_DnsChangesList_579002 = ref object of OpenApiRestCall_578339
proc url_DnsChangesList_579004(protocol: Scheme; host: string; base: string;
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

proc validate_DnsChangesList_579003(path: JsonNode; query: JsonNode;
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
  var valid_579005 = path.getOrDefault("managedZone")
  valid_579005 = validateParameter(valid_579005, JString, required = true,
                                 default = nil)
  if valid_579005 != nil:
    section.add "managedZone", valid_579005
  var valid_579006 = path.getOrDefault("project")
  valid_579006 = validateParameter(valid_579006, JString, required = true,
                                 default = nil)
  if valid_579006 != nil:
    section.add "project", valid_579006
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   sortBy: JString
  ##         : Sorting criterion. The only supported value is change sequence.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : Optional. A tag returned by a previous list request that was truncated. Use this parameter to continue a previous list request.
  ##   sortOrder: JString
  ##            : Sorting order direction: 'ascending' or 'descending'.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Optional. Maximum number of results to be returned. If unspecified, the server will decide how many results to return.
  section = newJObject()
  var valid_579007 = query.getOrDefault("key")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "key", valid_579007
  var valid_579008 = query.getOrDefault("prettyPrint")
  valid_579008 = validateParameter(valid_579008, JBool, required = false,
                                 default = newJBool(true))
  if valid_579008 != nil:
    section.add "prettyPrint", valid_579008
  var valid_579009 = query.getOrDefault("oauth_token")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "oauth_token", valid_579009
  var valid_579010 = query.getOrDefault("sortBy")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = newJString("changeSequence"))
  if valid_579010 != nil:
    section.add "sortBy", valid_579010
  var valid_579011 = query.getOrDefault("alt")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = newJString("json"))
  if valid_579011 != nil:
    section.add "alt", valid_579011
  var valid_579012 = query.getOrDefault("userIp")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "userIp", valid_579012
  var valid_579013 = query.getOrDefault("quotaUser")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "quotaUser", valid_579013
  var valid_579014 = query.getOrDefault("pageToken")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "pageToken", valid_579014
  var valid_579015 = query.getOrDefault("sortOrder")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "sortOrder", valid_579015
  var valid_579016 = query.getOrDefault("fields")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "fields", valid_579016
  var valid_579017 = query.getOrDefault("maxResults")
  valid_579017 = validateParameter(valid_579017, JInt, required = false, default = nil)
  if valid_579017 != nil:
    section.add "maxResults", valid_579017
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579018: Call_DnsChangesList_579002; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enumerate Changes to a ResourceRecordSet collection.
  ## 
  let valid = call_579018.validator(path, query, header, formData, body)
  let scheme = call_579018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579018.url(scheme.get, call_579018.host, call_579018.base,
                         call_579018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579018, url, valid)

proc call*(call_579019: Call_DnsChangesList_579002; managedZone: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; sortBy: string = "changeSequence";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; sortOrder: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## dnsChangesList
  ## Enumerate Changes to a ResourceRecordSet collection.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   managedZone: string (required)
  ##              : Identifies the managed zone addressed by this request. Can be the managed zone name or id.
  ##   sortBy: string
  ##         : Sorting criterion. The only supported value is change sequence.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Optional. A tag returned by a previous list request that was truncated. Use this parameter to continue a previous list request.
  ##   sortOrder: string
  ##            : Sorting order direction: 'ascending' or 'descending'.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Optional. Maximum number of results to be returned. If unspecified, the server will decide how many results to return.
  var path_579020 = newJObject()
  var query_579021 = newJObject()
  add(query_579021, "key", newJString(key))
  add(query_579021, "prettyPrint", newJBool(prettyPrint))
  add(query_579021, "oauth_token", newJString(oauthToken))
  add(path_579020, "managedZone", newJString(managedZone))
  add(query_579021, "sortBy", newJString(sortBy))
  add(query_579021, "alt", newJString(alt))
  add(query_579021, "userIp", newJString(userIp))
  add(query_579021, "quotaUser", newJString(quotaUser))
  add(query_579021, "pageToken", newJString(pageToken))
  add(query_579021, "sortOrder", newJString(sortOrder))
  add(path_579020, "project", newJString(project))
  add(query_579021, "fields", newJString(fields))
  add(query_579021, "maxResults", newJInt(maxResults))
  result = call_579019.call(path_579020, query_579021, nil, nil, nil)

var dnsChangesList* = Call_DnsChangesList_579002(name: "dnsChangesList",
    meth: HttpMethod.HttpGet, host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/changes",
    validator: validate_DnsChangesList_579003, base: "/dns/v1beta2/projects",
    url: url_DnsChangesList_579004, schemes: {Scheme.Https})
type
  Call_DnsChangesGet_579041 = ref object of OpenApiRestCall_578339
proc url_DnsChangesGet_579043(protocol: Scheme; host: string; base: string;
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

proc validate_DnsChangesGet_579042(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetch the representation of an existing Change.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managedZone: JString (required)
  ##              : Identifies the managed zone addressed by this request. Can be the managed zone name or id.
  ##   project: JString (required)
  ##          : Identifies the project addressed by this request.
  ##   changeId: JString (required)
  ##           : The identifier of the requested change, from a previous ResourceRecordSetsChangeResponse.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managedZone` field"
  var valid_579044 = path.getOrDefault("managedZone")
  valid_579044 = validateParameter(valid_579044, JString, required = true,
                                 default = nil)
  if valid_579044 != nil:
    section.add "managedZone", valid_579044
  var valid_579045 = path.getOrDefault("project")
  valid_579045 = validateParameter(valid_579045, JString, required = true,
                                 default = nil)
  if valid_579045 != nil:
    section.add "project", valid_579045
  var valid_579046 = path.getOrDefault("changeId")
  valid_579046 = validateParameter(valid_579046, JString, required = true,
                                 default = nil)
  if valid_579046 != nil:
    section.add "changeId", valid_579046
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   clientOperationId: JString
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579047 = query.getOrDefault("key")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "key", valid_579047
  var valid_579048 = query.getOrDefault("prettyPrint")
  valid_579048 = validateParameter(valid_579048, JBool, required = false,
                                 default = newJBool(true))
  if valid_579048 != nil:
    section.add "prettyPrint", valid_579048
  var valid_579049 = query.getOrDefault("oauth_token")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "oauth_token", valid_579049
  var valid_579050 = query.getOrDefault("alt")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = newJString("json"))
  if valid_579050 != nil:
    section.add "alt", valid_579050
  var valid_579051 = query.getOrDefault("userIp")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "userIp", valid_579051
  var valid_579052 = query.getOrDefault("quotaUser")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "quotaUser", valid_579052
  var valid_579053 = query.getOrDefault("clientOperationId")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "clientOperationId", valid_579053
  var valid_579054 = query.getOrDefault("fields")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "fields", valid_579054
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579055: Call_DnsChangesGet_579041; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetch the representation of an existing Change.
  ## 
  let valid = call_579055.validator(path, query, header, formData, body)
  let scheme = call_579055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579055.url(scheme.get, call_579055.host, call_579055.base,
                         call_579055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579055, url, valid)

proc call*(call_579056: Call_DnsChangesGet_579041; managedZone: string;
          project: string; changeId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; clientOperationId: string = ""; fields: string = ""): Recallable =
  ## dnsChangesGet
  ## Fetch the representation of an existing Change.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   managedZone: string (required)
  ##              : Identifies the managed zone addressed by this request. Can be the managed zone name or id.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   clientOperationId: string
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   changeId: string (required)
  ##           : The identifier of the requested change, from a previous ResourceRecordSetsChangeResponse.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579057 = newJObject()
  var query_579058 = newJObject()
  add(query_579058, "key", newJString(key))
  add(query_579058, "prettyPrint", newJBool(prettyPrint))
  add(query_579058, "oauth_token", newJString(oauthToken))
  add(path_579057, "managedZone", newJString(managedZone))
  add(query_579058, "alt", newJString(alt))
  add(query_579058, "userIp", newJString(userIp))
  add(query_579058, "quotaUser", newJString(quotaUser))
  add(path_579057, "project", newJString(project))
  add(query_579058, "clientOperationId", newJString(clientOperationId))
  add(path_579057, "changeId", newJString(changeId))
  add(query_579058, "fields", newJString(fields))
  result = call_579056.call(path_579057, query_579058, nil, nil, nil)

var dnsChangesGet* = Call_DnsChangesGet_579041(name: "dnsChangesGet",
    meth: HttpMethod.HttpGet, host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/changes/{changeId}",
    validator: validate_DnsChangesGet_579042, base: "/dns/v1beta2/projects",
    url: url_DnsChangesGet_579043, schemes: {Scheme.Https})
type
  Call_DnsDnsKeysList_579059 = ref object of OpenApiRestCall_578339
proc url_DnsDnsKeysList_579061(protocol: Scheme; host: string; base: string;
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

proc validate_DnsDnsKeysList_579060(path: JsonNode; query: JsonNode;
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
  var valid_579062 = path.getOrDefault("managedZone")
  valid_579062 = validateParameter(valid_579062, JString, required = true,
                                 default = nil)
  if valid_579062 != nil:
    section.add "managedZone", valid_579062
  var valid_579063 = path.getOrDefault("project")
  valid_579063 = validateParameter(valid_579063, JString, required = true,
                                 default = nil)
  if valid_579063 != nil:
    section.add "project", valid_579063
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   digestType: JString
  ##             : An optional comma-separated list of digest types to compute and display for key signing keys. If omitted, the recommended digest type will be computed and displayed.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : Optional. A tag returned by a previous list request that was truncated. Use this parameter to continue a previous list request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Optional. Maximum number of results to be returned. If unspecified, the server will decide how many results to return.
  section = newJObject()
  var valid_579064 = query.getOrDefault("key")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "key", valid_579064
  var valid_579065 = query.getOrDefault("prettyPrint")
  valid_579065 = validateParameter(valid_579065, JBool, required = false,
                                 default = newJBool(true))
  if valid_579065 != nil:
    section.add "prettyPrint", valid_579065
  var valid_579066 = query.getOrDefault("oauth_token")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "oauth_token", valid_579066
  var valid_579067 = query.getOrDefault("digestType")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "digestType", valid_579067
  var valid_579068 = query.getOrDefault("alt")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = newJString("json"))
  if valid_579068 != nil:
    section.add "alt", valid_579068
  var valid_579069 = query.getOrDefault("userIp")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "userIp", valid_579069
  var valid_579070 = query.getOrDefault("quotaUser")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = nil)
  if valid_579070 != nil:
    section.add "quotaUser", valid_579070
  var valid_579071 = query.getOrDefault("pageToken")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "pageToken", valid_579071
  var valid_579072 = query.getOrDefault("fields")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "fields", valid_579072
  var valid_579073 = query.getOrDefault("maxResults")
  valid_579073 = validateParameter(valid_579073, JInt, required = false, default = nil)
  if valid_579073 != nil:
    section.add "maxResults", valid_579073
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579074: Call_DnsDnsKeysList_579059; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enumerate DnsKeys to a ResourceRecordSet collection.
  ## 
  let valid = call_579074.validator(path, query, header, formData, body)
  let scheme = call_579074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579074.url(scheme.get, call_579074.host, call_579074.base,
                         call_579074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579074, url, valid)

proc call*(call_579075: Call_DnsDnsKeysList_579059; managedZone: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; digestType: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          fields: string = ""; maxResults: int = 0): Recallable =
  ## dnsDnsKeysList
  ## Enumerate DnsKeys to a ResourceRecordSet collection.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   managedZone: string (required)
  ##              : Identifies the managed zone addressed by this request. Can be the managed zone name or id.
  ##   digestType: string
  ##             : An optional comma-separated list of digest types to compute and display for key signing keys. If omitted, the recommended digest type will be computed and displayed.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Optional. A tag returned by a previous list request that was truncated. Use this parameter to continue a previous list request.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Optional. Maximum number of results to be returned. If unspecified, the server will decide how many results to return.
  var path_579076 = newJObject()
  var query_579077 = newJObject()
  add(query_579077, "key", newJString(key))
  add(query_579077, "prettyPrint", newJBool(prettyPrint))
  add(query_579077, "oauth_token", newJString(oauthToken))
  add(path_579076, "managedZone", newJString(managedZone))
  add(query_579077, "digestType", newJString(digestType))
  add(query_579077, "alt", newJString(alt))
  add(query_579077, "userIp", newJString(userIp))
  add(query_579077, "quotaUser", newJString(quotaUser))
  add(query_579077, "pageToken", newJString(pageToken))
  add(path_579076, "project", newJString(project))
  add(query_579077, "fields", newJString(fields))
  add(query_579077, "maxResults", newJInt(maxResults))
  result = call_579075.call(path_579076, query_579077, nil, nil, nil)

var dnsDnsKeysList* = Call_DnsDnsKeysList_579059(name: "dnsDnsKeysList",
    meth: HttpMethod.HttpGet, host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/dnsKeys",
    validator: validate_DnsDnsKeysList_579060, base: "/dns/v1beta2/projects",
    url: url_DnsDnsKeysList_579061, schemes: {Scheme.Https})
type
  Call_DnsDnsKeysGet_579078 = ref object of OpenApiRestCall_578339
proc url_DnsDnsKeysGet_579080(protocol: Scheme; host: string; base: string;
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

proc validate_DnsDnsKeysGet_579079(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetch the representation of an existing DnsKey.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managedZone: JString (required)
  ##              : Identifies the managed zone addressed by this request. Can be the managed zone name or id.
  ##   project: JString (required)
  ##          : Identifies the project addressed by this request.
  ##   dnsKeyId: JString (required)
  ##           : The identifier of the requested DnsKey.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managedZone` field"
  var valid_579081 = path.getOrDefault("managedZone")
  valid_579081 = validateParameter(valid_579081, JString, required = true,
                                 default = nil)
  if valid_579081 != nil:
    section.add "managedZone", valid_579081
  var valid_579082 = path.getOrDefault("project")
  valid_579082 = validateParameter(valid_579082, JString, required = true,
                                 default = nil)
  if valid_579082 != nil:
    section.add "project", valid_579082
  var valid_579083 = path.getOrDefault("dnsKeyId")
  valid_579083 = validateParameter(valid_579083, JString, required = true,
                                 default = nil)
  if valid_579083 != nil:
    section.add "dnsKeyId", valid_579083
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   digestType: JString
  ##             : An optional comma-separated list of digest types to compute and display for key signing keys. If omitted, the recommended digest type will be computed and displayed.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   clientOperationId: JString
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579084 = query.getOrDefault("key")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "key", valid_579084
  var valid_579085 = query.getOrDefault("prettyPrint")
  valid_579085 = validateParameter(valid_579085, JBool, required = false,
                                 default = newJBool(true))
  if valid_579085 != nil:
    section.add "prettyPrint", valid_579085
  var valid_579086 = query.getOrDefault("oauth_token")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "oauth_token", valid_579086
  var valid_579087 = query.getOrDefault("digestType")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "digestType", valid_579087
  var valid_579088 = query.getOrDefault("alt")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = newJString("json"))
  if valid_579088 != nil:
    section.add "alt", valid_579088
  var valid_579089 = query.getOrDefault("userIp")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "userIp", valid_579089
  var valid_579090 = query.getOrDefault("quotaUser")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "quotaUser", valid_579090
  var valid_579091 = query.getOrDefault("clientOperationId")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "clientOperationId", valid_579091
  var valid_579092 = query.getOrDefault("fields")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "fields", valid_579092
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579093: Call_DnsDnsKeysGet_579078; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetch the representation of an existing DnsKey.
  ## 
  let valid = call_579093.validator(path, query, header, formData, body)
  let scheme = call_579093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579093.url(scheme.get, call_579093.host, call_579093.base,
                         call_579093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579093, url, valid)

proc call*(call_579094: Call_DnsDnsKeysGet_579078; managedZone: string;
          project: string; dnsKeyId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; digestType: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; clientOperationId: string = "";
          fields: string = ""): Recallable =
  ## dnsDnsKeysGet
  ## Fetch the representation of an existing DnsKey.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   managedZone: string (required)
  ##              : Identifies the managed zone addressed by this request. Can be the managed zone name or id.
  ##   digestType: string
  ##             : An optional comma-separated list of digest types to compute and display for key signing keys. If omitted, the recommended digest type will be computed and displayed.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   clientOperationId: string
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   dnsKeyId: string (required)
  ##           : The identifier of the requested DnsKey.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579095 = newJObject()
  var query_579096 = newJObject()
  add(query_579096, "key", newJString(key))
  add(query_579096, "prettyPrint", newJBool(prettyPrint))
  add(query_579096, "oauth_token", newJString(oauthToken))
  add(path_579095, "managedZone", newJString(managedZone))
  add(query_579096, "digestType", newJString(digestType))
  add(query_579096, "alt", newJString(alt))
  add(query_579096, "userIp", newJString(userIp))
  add(query_579096, "quotaUser", newJString(quotaUser))
  add(path_579095, "project", newJString(project))
  add(query_579096, "clientOperationId", newJString(clientOperationId))
  add(path_579095, "dnsKeyId", newJString(dnsKeyId))
  add(query_579096, "fields", newJString(fields))
  result = call_579094.call(path_579095, query_579096, nil, nil, nil)

var dnsDnsKeysGet* = Call_DnsDnsKeysGet_579078(name: "dnsDnsKeysGet",
    meth: HttpMethod.HttpGet, host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/dnsKeys/{dnsKeyId}",
    validator: validate_DnsDnsKeysGet_579079, base: "/dns/v1beta2/projects",
    url: url_DnsDnsKeysGet_579080, schemes: {Scheme.Https})
type
  Call_DnsManagedZoneOperationsList_579097 = ref object of OpenApiRestCall_578339
proc url_DnsManagedZoneOperationsList_579099(protocol: Scheme; host: string;
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

proc validate_DnsManagedZoneOperationsList_579098(path: JsonNode; query: JsonNode;
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
  var valid_579100 = path.getOrDefault("managedZone")
  valid_579100 = validateParameter(valid_579100, JString, required = true,
                                 default = nil)
  if valid_579100 != nil:
    section.add "managedZone", valid_579100
  var valid_579101 = path.getOrDefault("project")
  valid_579101 = validateParameter(valid_579101, JString, required = true,
                                 default = nil)
  if valid_579101 != nil:
    section.add "project", valid_579101
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   sortBy: JString
  ##         : Sorting criterion. The only supported values are START_TIME and ID.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : Optional. A tag returned by a previous list request that was truncated. Use this parameter to continue a previous list request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Optional. Maximum number of results to be returned. If unspecified, the server will decide how many results to return.
  section = newJObject()
  var valid_579102 = query.getOrDefault("key")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "key", valid_579102
  var valid_579103 = query.getOrDefault("prettyPrint")
  valid_579103 = validateParameter(valid_579103, JBool, required = false,
                                 default = newJBool(true))
  if valid_579103 != nil:
    section.add "prettyPrint", valid_579103
  var valid_579104 = query.getOrDefault("oauth_token")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = nil)
  if valid_579104 != nil:
    section.add "oauth_token", valid_579104
  var valid_579105 = query.getOrDefault("sortBy")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = newJString("startTime"))
  if valid_579105 != nil:
    section.add "sortBy", valid_579105
  var valid_579106 = query.getOrDefault("alt")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = newJString("json"))
  if valid_579106 != nil:
    section.add "alt", valid_579106
  var valid_579107 = query.getOrDefault("userIp")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "userIp", valid_579107
  var valid_579108 = query.getOrDefault("quotaUser")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "quotaUser", valid_579108
  var valid_579109 = query.getOrDefault("pageToken")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "pageToken", valid_579109
  var valid_579110 = query.getOrDefault("fields")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "fields", valid_579110
  var valid_579111 = query.getOrDefault("maxResults")
  valid_579111 = validateParameter(valid_579111, JInt, required = false, default = nil)
  if valid_579111 != nil:
    section.add "maxResults", valid_579111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579112: Call_DnsManagedZoneOperationsList_579097; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enumerate Operations for the given ManagedZone.
  ## 
  let valid = call_579112.validator(path, query, header, formData, body)
  let scheme = call_579112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579112.url(scheme.get, call_579112.host, call_579112.base,
                         call_579112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579112, url, valid)

proc call*(call_579113: Call_DnsManagedZoneOperationsList_579097;
          managedZone: string; project: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = "";
          sortBy: string = "startTime"; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## dnsManagedZoneOperationsList
  ## Enumerate Operations for the given ManagedZone.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   managedZone: string (required)
  ##              : Identifies the managed zone addressed by this request.
  ##   sortBy: string
  ##         : Sorting criterion. The only supported values are START_TIME and ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Optional. A tag returned by a previous list request that was truncated. Use this parameter to continue a previous list request.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Optional. Maximum number of results to be returned. If unspecified, the server will decide how many results to return.
  var path_579114 = newJObject()
  var query_579115 = newJObject()
  add(query_579115, "key", newJString(key))
  add(query_579115, "prettyPrint", newJBool(prettyPrint))
  add(query_579115, "oauth_token", newJString(oauthToken))
  add(path_579114, "managedZone", newJString(managedZone))
  add(query_579115, "sortBy", newJString(sortBy))
  add(query_579115, "alt", newJString(alt))
  add(query_579115, "userIp", newJString(userIp))
  add(query_579115, "quotaUser", newJString(quotaUser))
  add(query_579115, "pageToken", newJString(pageToken))
  add(path_579114, "project", newJString(project))
  add(query_579115, "fields", newJString(fields))
  add(query_579115, "maxResults", newJInt(maxResults))
  result = call_579113.call(path_579114, query_579115, nil, nil, nil)

var dnsManagedZoneOperationsList* = Call_DnsManagedZoneOperationsList_579097(
    name: "dnsManagedZoneOperationsList", meth: HttpMethod.HttpGet,
    host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/operations",
    validator: validate_DnsManagedZoneOperationsList_579098,
    base: "/dns/v1beta2/projects", url: url_DnsManagedZoneOperationsList_579099,
    schemes: {Scheme.Https})
type
  Call_DnsManagedZoneOperationsGet_579116 = ref object of OpenApiRestCall_578339
proc url_DnsManagedZoneOperationsGet_579118(protocol: Scheme; host: string;
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

proc validate_DnsManagedZoneOperationsGet_579117(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fetch the representation of an existing Operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managedZone: JString (required)
  ##              : Identifies the managed zone addressed by this request.
  ##   operation: JString (required)
  ##            : Identifies the operation addressed by this request.
  ##   project: JString (required)
  ##          : Identifies the project addressed by this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `managedZone` field"
  var valid_579119 = path.getOrDefault("managedZone")
  valid_579119 = validateParameter(valid_579119, JString, required = true,
                                 default = nil)
  if valid_579119 != nil:
    section.add "managedZone", valid_579119
  var valid_579120 = path.getOrDefault("operation")
  valid_579120 = validateParameter(valid_579120, JString, required = true,
                                 default = nil)
  if valid_579120 != nil:
    section.add "operation", valid_579120
  var valid_579121 = path.getOrDefault("project")
  valid_579121 = validateParameter(valid_579121, JString, required = true,
                                 default = nil)
  if valid_579121 != nil:
    section.add "project", valid_579121
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   clientOperationId: JString
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579122 = query.getOrDefault("key")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "key", valid_579122
  var valid_579123 = query.getOrDefault("prettyPrint")
  valid_579123 = validateParameter(valid_579123, JBool, required = false,
                                 default = newJBool(true))
  if valid_579123 != nil:
    section.add "prettyPrint", valid_579123
  var valid_579124 = query.getOrDefault("oauth_token")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "oauth_token", valid_579124
  var valid_579125 = query.getOrDefault("alt")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = newJString("json"))
  if valid_579125 != nil:
    section.add "alt", valid_579125
  var valid_579126 = query.getOrDefault("userIp")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "userIp", valid_579126
  var valid_579127 = query.getOrDefault("quotaUser")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = nil)
  if valid_579127 != nil:
    section.add "quotaUser", valid_579127
  var valid_579128 = query.getOrDefault("clientOperationId")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "clientOperationId", valid_579128
  var valid_579129 = query.getOrDefault("fields")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "fields", valid_579129
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579130: Call_DnsManagedZoneOperationsGet_579116; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetch the representation of an existing Operation.
  ## 
  let valid = call_579130.validator(path, query, header, formData, body)
  let scheme = call_579130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579130.url(scheme.get, call_579130.host, call_579130.base,
                         call_579130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579130, url, valid)

proc call*(call_579131: Call_DnsManagedZoneOperationsGet_579116;
          managedZone: string; operation: string; project: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; clientOperationId: string = "";
          fields: string = ""): Recallable =
  ## dnsManagedZoneOperationsGet
  ## Fetch the representation of an existing Operation.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   managedZone: string (required)
  ##              : Identifies the managed zone addressed by this request.
  ##   operation: string (required)
  ##            : Identifies the operation addressed by this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   clientOperationId: string
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579132 = newJObject()
  var query_579133 = newJObject()
  add(query_579133, "key", newJString(key))
  add(query_579133, "prettyPrint", newJBool(prettyPrint))
  add(query_579133, "oauth_token", newJString(oauthToken))
  add(path_579132, "managedZone", newJString(managedZone))
  add(path_579132, "operation", newJString(operation))
  add(query_579133, "alt", newJString(alt))
  add(query_579133, "userIp", newJString(userIp))
  add(query_579133, "quotaUser", newJString(quotaUser))
  add(path_579132, "project", newJString(project))
  add(query_579133, "clientOperationId", newJString(clientOperationId))
  add(query_579133, "fields", newJString(fields))
  result = call_579131.call(path_579132, query_579133, nil, nil, nil)

var dnsManagedZoneOperationsGet* = Call_DnsManagedZoneOperationsGet_579116(
    name: "dnsManagedZoneOperationsGet", meth: HttpMethod.HttpGet,
    host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/operations/{operation}",
    validator: validate_DnsManagedZoneOperationsGet_579117,
    base: "/dns/v1beta2/projects", url: url_DnsManagedZoneOperationsGet_579118,
    schemes: {Scheme.Https})
type
  Call_DnsResourceRecordSetsList_579134 = ref object of OpenApiRestCall_578339
proc url_DnsResourceRecordSetsList_579136(protocol: Scheme; host: string;
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

proc validate_DnsResourceRecordSetsList_579135(path: JsonNode; query: JsonNode;
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
  var valid_579137 = path.getOrDefault("managedZone")
  valid_579137 = validateParameter(valid_579137, JString, required = true,
                                 default = nil)
  if valid_579137 != nil:
    section.add "managedZone", valid_579137
  var valid_579138 = path.getOrDefault("project")
  valid_579138 = validateParameter(valid_579138, JString, required = true,
                                 default = nil)
  if valid_579138 != nil:
    section.add "project", valid_579138
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   name: JString
  ##       : Restricts the list to return only records with this fully qualified domain name.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   type: JString
  ##       : Restricts the list to return only records of this type. If present, the "name" parameter must also be present.
  ##   pageToken: JString
  ##            : Optional. A tag returned by a previous list request that was truncated. Use this parameter to continue a previous list request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Optional. Maximum number of results to be returned. If unspecified, the server will decide how many results to return.
  section = newJObject()
  var valid_579139 = query.getOrDefault("key")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = nil)
  if valid_579139 != nil:
    section.add "key", valid_579139
  var valid_579140 = query.getOrDefault("prettyPrint")
  valid_579140 = validateParameter(valid_579140, JBool, required = false,
                                 default = newJBool(true))
  if valid_579140 != nil:
    section.add "prettyPrint", valid_579140
  var valid_579141 = query.getOrDefault("oauth_token")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "oauth_token", valid_579141
  var valid_579142 = query.getOrDefault("name")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "name", valid_579142
  var valid_579143 = query.getOrDefault("alt")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = newJString("json"))
  if valid_579143 != nil:
    section.add "alt", valid_579143
  var valid_579144 = query.getOrDefault("userIp")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "userIp", valid_579144
  var valid_579145 = query.getOrDefault("quotaUser")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = nil)
  if valid_579145 != nil:
    section.add "quotaUser", valid_579145
  var valid_579146 = query.getOrDefault("type")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "type", valid_579146
  var valid_579147 = query.getOrDefault("pageToken")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "pageToken", valid_579147
  var valid_579148 = query.getOrDefault("fields")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "fields", valid_579148
  var valid_579149 = query.getOrDefault("maxResults")
  valid_579149 = validateParameter(valid_579149, JInt, required = false, default = nil)
  if valid_579149 != nil:
    section.add "maxResults", valid_579149
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579150: Call_DnsResourceRecordSetsList_579134; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enumerate ResourceRecordSets that have been created but not yet deleted.
  ## 
  let valid = call_579150.validator(path, query, header, formData, body)
  let scheme = call_579150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579150.url(scheme.get, call_579150.host, call_579150.base,
                         call_579150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579150, url, valid)

proc call*(call_579151: Call_DnsResourceRecordSetsList_579134; managedZone: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; name: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; `type`: string = "";
          pageToken: string = ""; fields: string = ""; maxResults: int = 0): Recallable =
  ## dnsResourceRecordSetsList
  ## Enumerate ResourceRecordSets that have been created but not yet deleted.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   name: string
  ##       : Restricts the list to return only records with this fully qualified domain name.
  ##   managedZone: string (required)
  ##              : Identifies the managed zone addressed by this request. Can be the managed zone name or id.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   type: string
  ##       : Restricts the list to return only records of this type. If present, the "name" parameter must also be present.
  ##   pageToken: string
  ##            : Optional. A tag returned by a previous list request that was truncated. Use this parameter to continue a previous list request.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Optional. Maximum number of results to be returned. If unspecified, the server will decide how many results to return.
  var path_579152 = newJObject()
  var query_579153 = newJObject()
  add(query_579153, "key", newJString(key))
  add(query_579153, "prettyPrint", newJBool(prettyPrint))
  add(query_579153, "oauth_token", newJString(oauthToken))
  add(query_579153, "name", newJString(name))
  add(path_579152, "managedZone", newJString(managedZone))
  add(query_579153, "alt", newJString(alt))
  add(query_579153, "userIp", newJString(userIp))
  add(query_579153, "quotaUser", newJString(quotaUser))
  add(query_579153, "type", newJString(`type`))
  add(query_579153, "pageToken", newJString(pageToken))
  add(path_579152, "project", newJString(project))
  add(query_579153, "fields", newJString(fields))
  add(query_579153, "maxResults", newJInt(maxResults))
  result = call_579151.call(path_579152, query_579153, nil, nil, nil)

var dnsResourceRecordSetsList* = Call_DnsResourceRecordSetsList_579134(
    name: "dnsResourceRecordSetsList", meth: HttpMethod.HttpGet,
    host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/rrsets",
    validator: validate_DnsResourceRecordSetsList_579135,
    base: "/dns/v1beta2/projects", url: url_DnsResourceRecordSetsList_579136,
    schemes: {Scheme.Https})
type
  Call_DnsPoliciesCreate_579171 = ref object of OpenApiRestCall_578339
proc url_DnsPoliciesCreate_579173(protocol: Scheme; host: string; base: string;
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

proc validate_DnsPoliciesCreate_579172(path: JsonNode; query: JsonNode;
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
  var valid_579174 = path.getOrDefault("project")
  valid_579174 = validateParameter(valid_579174, JString, required = true,
                                 default = nil)
  if valid_579174 != nil:
    section.add "project", valid_579174
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   clientOperationId: JString
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579175 = query.getOrDefault("key")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = nil)
  if valid_579175 != nil:
    section.add "key", valid_579175
  var valid_579176 = query.getOrDefault("prettyPrint")
  valid_579176 = validateParameter(valid_579176, JBool, required = false,
                                 default = newJBool(true))
  if valid_579176 != nil:
    section.add "prettyPrint", valid_579176
  var valid_579177 = query.getOrDefault("oauth_token")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = nil)
  if valid_579177 != nil:
    section.add "oauth_token", valid_579177
  var valid_579178 = query.getOrDefault("alt")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = newJString("json"))
  if valid_579178 != nil:
    section.add "alt", valid_579178
  var valid_579179 = query.getOrDefault("userIp")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = nil)
  if valid_579179 != nil:
    section.add "userIp", valid_579179
  var valid_579180 = query.getOrDefault("quotaUser")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = nil)
  if valid_579180 != nil:
    section.add "quotaUser", valid_579180
  var valid_579181 = query.getOrDefault("clientOperationId")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = nil)
  if valid_579181 != nil:
    section.add "clientOperationId", valid_579181
  var valid_579182 = query.getOrDefault("fields")
  valid_579182 = validateParameter(valid_579182, JString, required = false,
                                 default = nil)
  if valid_579182 != nil:
    section.add "fields", valid_579182
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

proc call*(call_579184: Call_DnsPoliciesCreate_579171; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new Policy
  ## 
  let valid = call_579184.validator(path, query, header, formData, body)
  let scheme = call_579184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579184.url(scheme.get, call_579184.host, call_579184.base,
                         call_579184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579184, url, valid)

proc call*(call_579185: Call_DnsPoliciesCreate_579171; project: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          clientOperationId: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## dnsPoliciesCreate
  ## Create a new Policy
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   clientOperationId: string
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579186 = newJObject()
  var query_579187 = newJObject()
  var body_579188 = newJObject()
  add(query_579187, "key", newJString(key))
  add(query_579187, "prettyPrint", newJBool(prettyPrint))
  add(query_579187, "oauth_token", newJString(oauthToken))
  add(query_579187, "alt", newJString(alt))
  add(query_579187, "userIp", newJString(userIp))
  add(query_579187, "quotaUser", newJString(quotaUser))
  add(path_579186, "project", newJString(project))
  add(query_579187, "clientOperationId", newJString(clientOperationId))
  if body != nil:
    body_579188 = body
  add(query_579187, "fields", newJString(fields))
  result = call_579185.call(path_579186, query_579187, nil, nil, body_579188)

var dnsPoliciesCreate* = Call_DnsPoliciesCreate_579171(name: "dnsPoliciesCreate",
    meth: HttpMethod.HttpPost, host: "dns.googleapis.com",
    route: "/{project}/policies", validator: validate_DnsPoliciesCreate_579172,
    base: "/dns/v1beta2/projects", url: url_DnsPoliciesCreate_579173,
    schemes: {Scheme.Https})
type
  Call_DnsPoliciesList_579154 = ref object of OpenApiRestCall_578339
proc url_DnsPoliciesList_579156(protocol: Scheme; host: string; base: string;
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

proc validate_DnsPoliciesList_579155(path: JsonNode; query: JsonNode;
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
  var valid_579157 = path.getOrDefault("project")
  valid_579157 = validateParameter(valid_579157, JString, required = true,
                                 default = nil)
  if valid_579157 != nil:
    section.add "project", valid_579157
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : Optional. A tag returned by a previous list request that was truncated. Use this parameter to continue a previous list request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Optional. Maximum number of results to be returned. If unspecified, the server will decide how many results to return.
  section = newJObject()
  var valid_579158 = query.getOrDefault("key")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = nil)
  if valid_579158 != nil:
    section.add "key", valid_579158
  var valid_579159 = query.getOrDefault("prettyPrint")
  valid_579159 = validateParameter(valid_579159, JBool, required = false,
                                 default = newJBool(true))
  if valid_579159 != nil:
    section.add "prettyPrint", valid_579159
  var valid_579160 = query.getOrDefault("oauth_token")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = nil)
  if valid_579160 != nil:
    section.add "oauth_token", valid_579160
  var valid_579161 = query.getOrDefault("alt")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = newJString("json"))
  if valid_579161 != nil:
    section.add "alt", valid_579161
  var valid_579162 = query.getOrDefault("userIp")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "userIp", valid_579162
  var valid_579163 = query.getOrDefault("quotaUser")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "quotaUser", valid_579163
  var valid_579164 = query.getOrDefault("pageToken")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "pageToken", valid_579164
  var valid_579165 = query.getOrDefault("fields")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "fields", valid_579165
  var valid_579166 = query.getOrDefault("maxResults")
  valid_579166 = validateParameter(valid_579166, JInt, required = false, default = nil)
  if valid_579166 != nil:
    section.add "maxResults", valid_579166
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579167: Call_DnsPoliciesList_579154; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enumerate all Policies associated with a project.
  ## 
  let valid = call_579167.validator(path, query, header, formData, body)
  let scheme = call_579167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579167.url(scheme.get, call_579167.host, call_579167.base,
                         call_579167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579167, url, valid)

proc call*(call_579168: Call_DnsPoliciesList_579154; project: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""; maxResults: int = 0): Recallable =
  ## dnsPoliciesList
  ## Enumerate all Policies associated with a project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Optional. A tag returned by a previous list request that was truncated. Use this parameter to continue a previous list request.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Optional. Maximum number of results to be returned. If unspecified, the server will decide how many results to return.
  var path_579169 = newJObject()
  var query_579170 = newJObject()
  add(query_579170, "key", newJString(key))
  add(query_579170, "prettyPrint", newJBool(prettyPrint))
  add(query_579170, "oauth_token", newJString(oauthToken))
  add(query_579170, "alt", newJString(alt))
  add(query_579170, "userIp", newJString(userIp))
  add(query_579170, "quotaUser", newJString(quotaUser))
  add(query_579170, "pageToken", newJString(pageToken))
  add(path_579169, "project", newJString(project))
  add(query_579170, "fields", newJString(fields))
  add(query_579170, "maxResults", newJInt(maxResults))
  result = call_579168.call(path_579169, query_579170, nil, nil, nil)

var dnsPoliciesList* = Call_DnsPoliciesList_579154(name: "dnsPoliciesList",
    meth: HttpMethod.HttpGet, host: "dns.googleapis.com",
    route: "/{project}/policies", validator: validate_DnsPoliciesList_579155,
    base: "/dns/v1beta2/projects", url: url_DnsPoliciesList_579156,
    schemes: {Scheme.Https})
type
  Call_DnsPoliciesUpdate_579206 = ref object of OpenApiRestCall_578339
proc url_DnsPoliciesUpdate_579208(protocol: Scheme; host: string; base: string;
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

proc validate_DnsPoliciesUpdate_579207(path: JsonNode; query: JsonNode;
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
  var valid_579209 = path.getOrDefault("policy")
  valid_579209 = validateParameter(valid_579209, JString, required = true,
                                 default = nil)
  if valid_579209 != nil:
    section.add "policy", valid_579209
  var valid_579210 = path.getOrDefault("project")
  valid_579210 = validateParameter(valid_579210, JString, required = true,
                                 default = nil)
  if valid_579210 != nil:
    section.add "project", valid_579210
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   clientOperationId: JString
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579211 = query.getOrDefault("key")
  valid_579211 = validateParameter(valid_579211, JString, required = false,
                                 default = nil)
  if valid_579211 != nil:
    section.add "key", valid_579211
  var valid_579212 = query.getOrDefault("prettyPrint")
  valid_579212 = validateParameter(valid_579212, JBool, required = false,
                                 default = newJBool(true))
  if valid_579212 != nil:
    section.add "prettyPrint", valid_579212
  var valid_579213 = query.getOrDefault("oauth_token")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = nil)
  if valid_579213 != nil:
    section.add "oauth_token", valid_579213
  var valid_579214 = query.getOrDefault("alt")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = newJString("json"))
  if valid_579214 != nil:
    section.add "alt", valid_579214
  var valid_579215 = query.getOrDefault("userIp")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = nil)
  if valid_579215 != nil:
    section.add "userIp", valid_579215
  var valid_579216 = query.getOrDefault("quotaUser")
  valid_579216 = validateParameter(valid_579216, JString, required = false,
                                 default = nil)
  if valid_579216 != nil:
    section.add "quotaUser", valid_579216
  var valid_579217 = query.getOrDefault("clientOperationId")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = nil)
  if valid_579217 != nil:
    section.add "clientOperationId", valid_579217
  var valid_579218 = query.getOrDefault("fields")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = nil)
  if valid_579218 != nil:
    section.add "fields", valid_579218
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

proc call*(call_579220: Call_DnsPoliciesUpdate_579206; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an existing Policy.
  ## 
  let valid = call_579220.validator(path, query, header, formData, body)
  let scheme = call_579220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579220.url(scheme.get, call_579220.host, call_579220.base,
                         call_579220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579220, url, valid)

proc call*(call_579221: Call_DnsPoliciesUpdate_579206; policy: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; clientOperationId: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## dnsPoliciesUpdate
  ## Update an existing Policy.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   policy: string (required)
  ##         : User given friendly name of the policy addressed by this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   clientOperationId: string
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579222 = newJObject()
  var query_579223 = newJObject()
  var body_579224 = newJObject()
  add(query_579223, "key", newJString(key))
  add(query_579223, "prettyPrint", newJBool(prettyPrint))
  add(query_579223, "oauth_token", newJString(oauthToken))
  add(path_579222, "policy", newJString(policy))
  add(query_579223, "alt", newJString(alt))
  add(query_579223, "userIp", newJString(userIp))
  add(query_579223, "quotaUser", newJString(quotaUser))
  add(path_579222, "project", newJString(project))
  add(query_579223, "clientOperationId", newJString(clientOperationId))
  if body != nil:
    body_579224 = body
  add(query_579223, "fields", newJString(fields))
  result = call_579221.call(path_579222, query_579223, nil, nil, body_579224)

var dnsPoliciesUpdate* = Call_DnsPoliciesUpdate_579206(name: "dnsPoliciesUpdate",
    meth: HttpMethod.HttpPut, host: "dns.googleapis.com",
    route: "/{project}/policies/{policy}", validator: validate_DnsPoliciesUpdate_579207,
    base: "/dns/v1beta2/projects", url: url_DnsPoliciesUpdate_579208,
    schemes: {Scheme.Https})
type
  Call_DnsPoliciesGet_579189 = ref object of OpenApiRestCall_578339
proc url_DnsPoliciesGet_579191(protocol: Scheme; host: string; base: string;
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

proc validate_DnsPoliciesGet_579190(path: JsonNode; query: JsonNode;
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
  var valid_579192 = path.getOrDefault("policy")
  valid_579192 = validateParameter(valid_579192, JString, required = true,
                                 default = nil)
  if valid_579192 != nil:
    section.add "policy", valid_579192
  var valid_579193 = path.getOrDefault("project")
  valid_579193 = validateParameter(valid_579193, JString, required = true,
                                 default = nil)
  if valid_579193 != nil:
    section.add "project", valid_579193
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   clientOperationId: JString
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579194 = query.getOrDefault("key")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "key", valid_579194
  var valid_579195 = query.getOrDefault("prettyPrint")
  valid_579195 = validateParameter(valid_579195, JBool, required = false,
                                 default = newJBool(true))
  if valid_579195 != nil:
    section.add "prettyPrint", valid_579195
  var valid_579196 = query.getOrDefault("oauth_token")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = nil)
  if valid_579196 != nil:
    section.add "oauth_token", valid_579196
  var valid_579197 = query.getOrDefault("alt")
  valid_579197 = validateParameter(valid_579197, JString, required = false,
                                 default = newJString("json"))
  if valid_579197 != nil:
    section.add "alt", valid_579197
  var valid_579198 = query.getOrDefault("userIp")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = nil)
  if valid_579198 != nil:
    section.add "userIp", valid_579198
  var valid_579199 = query.getOrDefault("quotaUser")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = nil)
  if valid_579199 != nil:
    section.add "quotaUser", valid_579199
  var valid_579200 = query.getOrDefault("clientOperationId")
  valid_579200 = validateParameter(valid_579200, JString, required = false,
                                 default = nil)
  if valid_579200 != nil:
    section.add "clientOperationId", valid_579200
  var valid_579201 = query.getOrDefault("fields")
  valid_579201 = validateParameter(valid_579201, JString, required = false,
                                 default = nil)
  if valid_579201 != nil:
    section.add "fields", valid_579201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579202: Call_DnsPoliciesGet_579189; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetch the representation of an existing Policy.
  ## 
  let valid = call_579202.validator(path, query, header, formData, body)
  let scheme = call_579202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579202.url(scheme.get, call_579202.host, call_579202.base,
                         call_579202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579202, url, valid)

proc call*(call_579203: Call_DnsPoliciesGet_579189; policy: string; project: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          clientOperationId: string = ""; fields: string = ""): Recallable =
  ## dnsPoliciesGet
  ## Fetch the representation of an existing Policy.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   policy: string (required)
  ##         : User given friendly name of the policy addressed by this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   clientOperationId: string
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579204 = newJObject()
  var query_579205 = newJObject()
  add(query_579205, "key", newJString(key))
  add(query_579205, "prettyPrint", newJBool(prettyPrint))
  add(query_579205, "oauth_token", newJString(oauthToken))
  add(path_579204, "policy", newJString(policy))
  add(query_579205, "alt", newJString(alt))
  add(query_579205, "userIp", newJString(userIp))
  add(query_579205, "quotaUser", newJString(quotaUser))
  add(path_579204, "project", newJString(project))
  add(query_579205, "clientOperationId", newJString(clientOperationId))
  add(query_579205, "fields", newJString(fields))
  result = call_579203.call(path_579204, query_579205, nil, nil, nil)

var dnsPoliciesGet* = Call_DnsPoliciesGet_579189(name: "dnsPoliciesGet",
    meth: HttpMethod.HttpGet, host: "dns.googleapis.com",
    route: "/{project}/policies/{policy}", validator: validate_DnsPoliciesGet_579190,
    base: "/dns/v1beta2/projects", url: url_DnsPoliciesGet_579191,
    schemes: {Scheme.Https})
type
  Call_DnsPoliciesPatch_579242 = ref object of OpenApiRestCall_578339
proc url_DnsPoliciesPatch_579244(protocol: Scheme; host: string; base: string;
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

proc validate_DnsPoliciesPatch_579243(path: JsonNode; query: JsonNode;
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
  var valid_579245 = path.getOrDefault("policy")
  valid_579245 = validateParameter(valid_579245, JString, required = true,
                                 default = nil)
  if valid_579245 != nil:
    section.add "policy", valid_579245
  var valid_579246 = path.getOrDefault("project")
  valid_579246 = validateParameter(valid_579246, JString, required = true,
                                 default = nil)
  if valid_579246 != nil:
    section.add "project", valid_579246
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   clientOperationId: JString
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579247 = query.getOrDefault("key")
  valid_579247 = validateParameter(valid_579247, JString, required = false,
                                 default = nil)
  if valid_579247 != nil:
    section.add "key", valid_579247
  var valid_579248 = query.getOrDefault("prettyPrint")
  valid_579248 = validateParameter(valid_579248, JBool, required = false,
                                 default = newJBool(true))
  if valid_579248 != nil:
    section.add "prettyPrint", valid_579248
  var valid_579249 = query.getOrDefault("oauth_token")
  valid_579249 = validateParameter(valid_579249, JString, required = false,
                                 default = nil)
  if valid_579249 != nil:
    section.add "oauth_token", valid_579249
  var valid_579250 = query.getOrDefault("alt")
  valid_579250 = validateParameter(valid_579250, JString, required = false,
                                 default = newJString("json"))
  if valid_579250 != nil:
    section.add "alt", valid_579250
  var valid_579251 = query.getOrDefault("userIp")
  valid_579251 = validateParameter(valid_579251, JString, required = false,
                                 default = nil)
  if valid_579251 != nil:
    section.add "userIp", valid_579251
  var valid_579252 = query.getOrDefault("quotaUser")
  valid_579252 = validateParameter(valid_579252, JString, required = false,
                                 default = nil)
  if valid_579252 != nil:
    section.add "quotaUser", valid_579252
  var valid_579253 = query.getOrDefault("clientOperationId")
  valid_579253 = validateParameter(valid_579253, JString, required = false,
                                 default = nil)
  if valid_579253 != nil:
    section.add "clientOperationId", valid_579253
  var valid_579254 = query.getOrDefault("fields")
  valid_579254 = validateParameter(valid_579254, JString, required = false,
                                 default = nil)
  if valid_579254 != nil:
    section.add "fields", valid_579254
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

proc call*(call_579256: Call_DnsPoliciesPatch_579242; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Apply a partial update to an existing Policy.
  ## 
  let valid = call_579256.validator(path, query, header, formData, body)
  let scheme = call_579256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579256.url(scheme.get, call_579256.host, call_579256.base,
                         call_579256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579256, url, valid)

proc call*(call_579257: Call_DnsPoliciesPatch_579242; policy: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; clientOperationId: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## dnsPoliciesPatch
  ## Apply a partial update to an existing Policy.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   policy: string (required)
  ##         : User given friendly name of the policy addressed by this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   clientOperationId: string
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579258 = newJObject()
  var query_579259 = newJObject()
  var body_579260 = newJObject()
  add(query_579259, "key", newJString(key))
  add(query_579259, "prettyPrint", newJBool(prettyPrint))
  add(query_579259, "oauth_token", newJString(oauthToken))
  add(path_579258, "policy", newJString(policy))
  add(query_579259, "alt", newJString(alt))
  add(query_579259, "userIp", newJString(userIp))
  add(query_579259, "quotaUser", newJString(quotaUser))
  add(path_579258, "project", newJString(project))
  add(query_579259, "clientOperationId", newJString(clientOperationId))
  if body != nil:
    body_579260 = body
  add(query_579259, "fields", newJString(fields))
  result = call_579257.call(path_579258, query_579259, nil, nil, body_579260)

var dnsPoliciesPatch* = Call_DnsPoliciesPatch_579242(name: "dnsPoliciesPatch",
    meth: HttpMethod.HttpPatch, host: "dns.googleapis.com",
    route: "/{project}/policies/{policy}", validator: validate_DnsPoliciesPatch_579243,
    base: "/dns/v1beta2/projects", url: url_DnsPoliciesPatch_579244,
    schemes: {Scheme.Https})
type
  Call_DnsPoliciesDelete_579225 = ref object of OpenApiRestCall_578339
proc url_DnsPoliciesDelete_579227(protocol: Scheme; host: string; base: string;
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

proc validate_DnsPoliciesDelete_579226(path: JsonNode; query: JsonNode;
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
  var valid_579228 = path.getOrDefault("policy")
  valid_579228 = validateParameter(valid_579228, JString, required = true,
                                 default = nil)
  if valid_579228 != nil:
    section.add "policy", valid_579228
  var valid_579229 = path.getOrDefault("project")
  valid_579229 = validateParameter(valid_579229, JString, required = true,
                                 default = nil)
  if valid_579229 != nil:
    section.add "project", valid_579229
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   clientOperationId: JString
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579230 = query.getOrDefault("key")
  valid_579230 = validateParameter(valid_579230, JString, required = false,
                                 default = nil)
  if valid_579230 != nil:
    section.add "key", valid_579230
  var valid_579231 = query.getOrDefault("prettyPrint")
  valid_579231 = validateParameter(valid_579231, JBool, required = false,
                                 default = newJBool(true))
  if valid_579231 != nil:
    section.add "prettyPrint", valid_579231
  var valid_579232 = query.getOrDefault("oauth_token")
  valid_579232 = validateParameter(valid_579232, JString, required = false,
                                 default = nil)
  if valid_579232 != nil:
    section.add "oauth_token", valid_579232
  var valid_579233 = query.getOrDefault("alt")
  valid_579233 = validateParameter(valid_579233, JString, required = false,
                                 default = newJString("json"))
  if valid_579233 != nil:
    section.add "alt", valid_579233
  var valid_579234 = query.getOrDefault("userIp")
  valid_579234 = validateParameter(valid_579234, JString, required = false,
                                 default = nil)
  if valid_579234 != nil:
    section.add "userIp", valid_579234
  var valid_579235 = query.getOrDefault("quotaUser")
  valid_579235 = validateParameter(valid_579235, JString, required = false,
                                 default = nil)
  if valid_579235 != nil:
    section.add "quotaUser", valid_579235
  var valid_579236 = query.getOrDefault("clientOperationId")
  valid_579236 = validateParameter(valid_579236, JString, required = false,
                                 default = nil)
  if valid_579236 != nil:
    section.add "clientOperationId", valid_579236
  var valid_579237 = query.getOrDefault("fields")
  valid_579237 = validateParameter(valid_579237, JString, required = false,
                                 default = nil)
  if valid_579237 != nil:
    section.add "fields", valid_579237
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579238: Call_DnsPoliciesDelete_579225; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a previously created Policy. Will fail if the policy is still being referenced by a network.
  ## 
  let valid = call_579238.validator(path, query, header, formData, body)
  let scheme = call_579238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579238.url(scheme.get, call_579238.host, call_579238.base,
                         call_579238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579238, url, valid)

proc call*(call_579239: Call_DnsPoliciesDelete_579225; policy: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; clientOperationId: string = ""; fields: string = ""): Recallable =
  ## dnsPoliciesDelete
  ## Delete a previously created Policy. Will fail if the policy is still being referenced by a network.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   policy: string (required)
  ##         : User given friendly name of the policy addressed by this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : Identifies the project addressed by this request.
  ##   clientOperationId: string
  ##                    : For mutating operation requests only. An optional identifier specified by the client. Must be unique for operation resources in the Operations collection.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579240 = newJObject()
  var query_579241 = newJObject()
  add(query_579241, "key", newJString(key))
  add(query_579241, "prettyPrint", newJBool(prettyPrint))
  add(query_579241, "oauth_token", newJString(oauthToken))
  add(path_579240, "policy", newJString(policy))
  add(query_579241, "alt", newJString(alt))
  add(query_579241, "userIp", newJString(userIp))
  add(query_579241, "quotaUser", newJString(quotaUser))
  add(path_579240, "project", newJString(project))
  add(query_579241, "clientOperationId", newJString(clientOperationId))
  add(query_579241, "fields", newJString(fields))
  result = call_579239.call(path_579240, query_579241, nil, nil, nil)

var dnsPoliciesDelete* = Call_DnsPoliciesDelete_579225(name: "dnsPoliciesDelete",
    meth: HttpMethod.HttpDelete, host: "dns.googleapis.com",
    route: "/{project}/policies/{policy}", validator: validate_DnsPoliciesDelete_579226,
    base: "/dns/v1beta2/projects", url: url_DnsPoliciesDelete_579227,
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
