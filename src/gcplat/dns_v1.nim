
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

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

  OpenApiRestCall_579364 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579364](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579364): Option[Scheme] {.used.} =
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
  Call_DnsProjectsGet_579634 = ref object of OpenApiRestCall_579364
proc url_DnsProjectsGet_579636(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DnsProjectsGet_579635(path: JsonNode; query: JsonNode;
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
  var valid_579762 = path.getOrDefault("project")
  valid_579762 = validateParameter(valid_579762, JString, required = true,
                                 default = nil)
  if valid_579762 != nil:
    section.add "project", valid_579762
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
  var valid_579763 = query.getOrDefault("key")
  valid_579763 = validateParameter(valid_579763, JString, required = false,
                                 default = nil)
  if valid_579763 != nil:
    section.add "key", valid_579763
  var valid_579777 = query.getOrDefault("prettyPrint")
  valid_579777 = validateParameter(valid_579777, JBool, required = false,
                                 default = newJBool(true))
  if valid_579777 != nil:
    section.add "prettyPrint", valid_579777
  var valid_579778 = query.getOrDefault("oauth_token")
  valid_579778 = validateParameter(valid_579778, JString, required = false,
                                 default = nil)
  if valid_579778 != nil:
    section.add "oauth_token", valid_579778
  var valid_579779 = query.getOrDefault("alt")
  valid_579779 = validateParameter(valid_579779, JString, required = false,
                                 default = newJString("json"))
  if valid_579779 != nil:
    section.add "alt", valid_579779
  var valid_579780 = query.getOrDefault("userIp")
  valid_579780 = validateParameter(valid_579780, JString, required = false,
                                 default = nil)
  if valid_579780 != nil:
    section.add "userIp", valid_579780
  var valid_579781 = query.getOrDefault("quotaUser")
  valid_579781 = validateParameter(valid_579781, JString, required = false,
                                 default = nil)
  if valid_579781 != nil:
    section.add "quotaUser", valid_579781
  var valid_579782 = query.getOrDefault("clientOperationId")
  valid_579782 = validateParameter(valid_579782, JString, required = false,
                                 default = nil)
  if valid_579782 != nil:
    section.add "clientOperationId", valid_579782
  var valid_579783 = query.getOrDefault("fields")
  valid_579783 = validateParameter(valid_579783, JString, required = false,
                                 default = nil)
  if valid_579783 != nil:
    section.add "fields", valid_579783
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579806: Call_DnsProjectsGet_579634; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetch the representation of an existing Project.
  ## 
  let valid = call_579806.validator(path, query, header, formData, body)
  let scheme = call_579806.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579806.url(scheme.get, call_579806.host, call_579806.base,
                         call_579806.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579806, url, valid)

proc call*(call_579877: Call_DnsProjectsGet_579634; project: string;
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
  var path_579878 = newJObject()
  var query_579880 = newJObject()
  add(query_579880, "key", newJString(key))
  add(query_579880, "prettyPrint", newJBool(prettyPrint))
  add(query_579880, "oauth_token", newJString(oauthToken))
  add(query_579880, "alt", newJString(alt))
  add(query_579880, "userIp", newJString(userIp))
  add(query_579880, "quotaUser", newJString(quotaUser))
  add(path_579878, "project", newJString(project))
  add(query_579880, "clientOperationId", newJString(clientOperationId))
  add(query_579880, "fields", newJString(fields))
  result = call_579877.call(path_579878, query_579880, nil, nil, nil)

var dnsProjectsGet* = Call_DnsProjectsGet_579634(name: "dnsProjectsGet",
    meth: HttpMethod.HttpGet, host: "dns.googleapis.com", route: "/{project}",
    validator: validate_DnsProjectsGet_579635, base: "/dns/v1/projects",
    url: url_DnsProjectsGet_579636, schemes: {Scheme.Https})
type
  Call_DnsManagedZonesCreate_579937 = ref object of OpenApiRestCall_579364
proc url_DnsManagedZonesCreate_579939(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DnsManagedZonesCreate_579938(path: JsonNode; query: JsonNode;
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
  var valid_579940 = path.getOrDefault("project")
  valid_579940 = validateParameter(valid_579940, JString, required = true,
                                 default = nil)
  if valid_579940 != nil:
    section.add "project", valid_579940
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
  var valid_579941 = query.getOrDefault("key")
  valid_579941 = validateParameter(valid_579941, JString, required = false,
                                 default = nil)
  if valid_579941 != nil:
    section.add "key", valid_579941
  var valid_579942 = query.getOrDefault("prettyPrint")
  valid_579942 = validateParameter(valid_579942, JBool, required = false,
                                 default = newJBool(true))
  if valid_579942 != nil:
    section.add "prettyPrint", valid_579942
  var valid_579943 = query.getOrDefault("oauth_token")
  valid_579943 = validateParameter(valid_579943, JString, required = false,
                                 default = nil)
  if valid_579943 != nil:
    section.add "oauth_token", valid_579943
  var valid_579944 = query.getOrDefault("alt")
  valid_579944 = validateParameter(valid_579944, JString, required = false,
                                 default = newJString("json"))
  if valid_579944 != nil:
    section.add "alt", valid_579944
  var valid_579945 = query.getOrDefault("userIp")
  valid_579945 = validateParameter(valid_579945, JString, required = false,
                                 default = nil)
  if valid_579945 != nil:
    section.add "userIp", valid_579945
  var valid_579946 = query.getOrDefault("quotaUser")
  valid_579946 = validateParameter(valid_579946, JString, required = false,
                                 default = nil)
  if valid_579946 != nil:
    section.add "quotaUser", valid_579946
  var valid_579947 = query.getOrDefault("clientOperationId")
  valid_579947 = validateParameter(valid_579947, JString, required = false,
                                 default = nil)
  if valid_579947 != nil:
    section.add "clientOperationId", valid_579947
  var valid_579948 = query.getOrDefault("fields")
  valid_579948 = validateParameter(valid_579948, JString, required = false,
                                 default = nil)
  if valid_579948 != nil:
    section.add "fields", valid_579948
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

proc call*(call_579950: Call_DnsManagedZonesCreate_579937; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new ManagedZone.
  ## 
  let valid = call_579950.validator(path, query, header, formData, body)
  let scheme = call_579950.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579950.url(scheme.get, call_579950.host, call_579950.base,
                         call_579950.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579950, url, valid)

proc call*(call_579951: Call_DnsManagedZonesCreate_579937; project: string;
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
  var path_579952 = newJObject()
  var query_579953 = newJObject()
  var body_579954 = newJObject()
  add(query_579953, "key", newJString(key))
  add(query_579953, "prettyPrint", newJBool(prettyPrint))
  add(query_579953, "oauth_token", newJString(oauthToken))
  add(query_579953, "alt", newJString(alt))
  add(query_579953, "userIp", newJString(userIp))
  add(query_579953, "quotaUser", newJString(quotaUser))
  add(path_579952, "project", newJString(project))
  add(query_579953, "clientOperationId", newJString(clientOperationId))
  if body != nil:
    body_579954 = body
  add(query_579953, "fields", newJString(fields))
  result = call_579951.call(path_579952, query_579953, nil, nil, body_579954)

var dnsManagedZonesCreate* = Call_DnsManagedZonesCreate_579937(
    name: "dnsManagedZonesCreate", meth: HttpMethod.HttpPost,
    host: "dns.googleapis.com", route: "/{project}/managedZones",
    validator: validate_DnsManagedZonesCreate_579938, base: "/dns/v1/projects",
    url: url_DnsManagedZonesCreate_579939, schemes: {Scheme.Https})
type
  Call_DnsManagedZonesList_579919 = ref object of OpenApiRestCall_579364
proc url_DnsManagedZonesList_579921(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DnsManagedZonesList_579920(path: JsonNode; query: JsonNode;
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
  var valid_579922 = path.getOrDefault("project")
  valid_579922 = validateParameter(valid_579922, JString, required = true,
                                 default = nil)
  if valid_579922 != nil:
    section.add "project", valid_579922
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
  var valid_579923 = query.getOrDefault("key")
  valid_579923 = validateParameter(valid_579923, JString, required = false,
                                 default = nil)
  if valid_579923 != nil:
    section.add "key", valid_579923
  var valid_579924 = query.getOrDefault("prettyPrint")
  valid_579924 = validateParameter(valid_579924, JBool, required = false,
                                 default = newJBool(true))
  if valid_579924 != nil:
    section.add "prettyPrint", valid_579924
  var valid_579925 = query.getOrDefault("oauth_token")
  valid_579925 = validateParameter(valid_579925, JString, required = false,
                                 default = nil)
  if valid_579925 != nil:
    section.add "oauth_token", valid_579925
  var valid_579926 = query.getOrDefault("alt")
  valid_579926 = validateParameter(valid_579926, JString, required = false,
                                 default = newJString("json"))
  if valid_579926 != nil:
    section.add "alt", valid_579926
  var valid_579927 = query.getOrDefault("userIp")
  valid_579927 = validateParameter(valid_579927, JString, required = false,
                                 default = nil)
  if valid_579927 != nil:
    section.add "userIp", valid_579927
  var valid_579928 = query.getOrDefault("dnsName")
  valid_579928 = validateParameter(valid_579928, JString, required = false,
                                 default = nil)
  if valid_579928 != nil:
    section.add "dnsName", valid_579928
  var valid_579929 = query.getOrDefault("quotaUser")
  valid_579929 = validateParameter(valid_579929, JString, required = false,
                                 default = nil)
  if valid_579929 != nil:
    section.add "quotaUser", valid_579929
  var valid_579930 = query.getOrDefault("pageToken")
  valid_579930 = validateParameter(valid_579930, JString, required = false,
                                 default = nil)
  if valid_579930 != nil:
    section.add "pageToken", valid_579930
  var valid_579931 = query.getOrDefault("fields")
  valid_579931 = validateParameter(valid_579931, JString, required = false,
                                 default = nil)
  if valid_579931 != nil:
    section.add "fields", valid_579931
  var valid_579932 = query.getOrDefault("maxResults")
  valid_579932 = validateParameter(valid_579932, JInt, required = false, default = nil)
  if valid_579932 != nil:
    section.add "maxResults", valid_579932
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579933: Call_DnsManagedZonesList_579919; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enumerate ManagedZones that have been created but not yet deleted.
  ## 
  let valid = call_579933.validator(path, query, header, formData, body)
  let scheme = call_579933.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579933.url(scheme.get, call_579933.host, call_579933.base,
                         call_579933.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579933, url, valid)

proc call*(call_579934: Call_DnsManagedZonesList_579919; project: string;
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
  var path_579935 = newJObject()
  var query_579936 = newJObject()
  add(query_579936, "key", newJString(key))
  add(query_579936, "prettyPrint", newJBool(prettyPrint))
  add(query_579936, "oauth_token", newJString(oauthToken))
  add(query_579936, "alt", newJString(alt))
  add(query_579936, "userIp", newJString(userIp))
  add(query_579936, "dnsName", newJString(dnsName))
  add(query_579936, "quotaUser", newJString(quotaUser))
  add(query_579936, "pageToken", newJString(pageToken))
  add(path_579935, "project", newJString(project))
  add(query_579936, "fields", newJString(fields))
  add(query_579936, "maxResults", newJInt(maxResults))
  result = call_579934.call(path_579935, query_579936, nil, nil, nil)

var dnsManagedZonesList* = Call_DnsManagedZonesList_579919(
    name: "dnsManagedZonesList", meth: HttpMethod.HttpGet,
    host: "dns.googleapis.com", route: "/{project}/managedZones",
    validator: validate_DnsManagedZonesList_579920, base: "/dns/v1/projects",
    url: url_DnsManagedZonesList_579921, schemes: {Scheme.Https})
type
  Call_DnsManagedZonesUpdate_579972 = ref object of OpenApiRestCall_579364
proc url_DnsManagedZonesUpdate_579974(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DnsManagedZonesUpdate_579973(path: JsonNode; query: JsonNode;
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
  var valid_579975 = path.getOrDefault("managedZone")
  valid_579975 = validateParameter(valid_579975, JString, required = true,
                                 default = nil)
  if valid_579975 != nil:
    section.add "managedZone", valid_579975
  var valid_579976 = path.getOrDefault("project")
  valid_579976 = validateParameter(valid_579976, JString, required = true,
                                 default = nil)
  if valid_579976 != nil:
    section.add "project", valid_579976
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
  var valid_579977 = query.getOrDefault("key")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "key", valid_579977
  var valid_579978 = query.getOrDefault("prettyPrint")
  valid_579978 = validateParameter(valid_579978, JBool, required = false,
                                 default = newJBool(true))
  if valid_579978 != nil:
    section.add "prettyPrint", valid_579978
  var valid_579979 = query.getOrDefault("oauth_token")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "oauth_token", valid_579979
  var valid_579980 = query.getOrDefault("alt")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = newJString("json"))
  if valid_579980 != nil:
    section.add "alt", valid_579980
  var valid_579981 = query.getOrDefault("userIp")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "userIp", valid_579981
  var valid_579982 = query.getOrDefault("quotaUser")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "quotaUser", valid_579982
  var valid_579983 = query.getOrDefault("clientOperationId")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "clientOperationId", valid_579983
  var valid_579984 = query.getOrDefault("fields")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "fields", valid_579984
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

proc call*(call_579986: Call_DnsManagedZonesUpdate_579972; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an existing ManagedZone.
  ## 
  let valid = call_579986.validator(path, query, header, formData, body)
  let scheme = call_579986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579986.url(scheme.get, call_579986.host, call_579986.base,
                         call_579986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579986, url, valid)

proc call*(call_579987: Call_DnsManagedZonesUpdate_579972; managedZone: string;
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
  var path_579988 = newJObject()
  var query_579989 = newJObject()
  var body_579990 = newJObject()
  add(query_579989, "key", newJString(key))
  add(query_579989, "prettyPrint", newJBool(prettyPrint))
  add(query_579989, "oauth_token", newJString(oauthToken))
  add(path_579988, "managedZone", newJString(managedZone))
  add(query_579989, "alt", newJString(alt))
  add(query_579989, "userIp", newJString(userIp))
  add(query_579989, "quotaUser", newJString(quotaUser))
  add(path_579988, "project", newJString(project))
  add(query_579989, "clientOperationId", newJString(clientOperationId))
  if body != nil:
    body_579990 = body
  add(query_579989, "fields", newJString(fields))
  result = call_579987.call(path_579988, query_579989, nil, nil, body_579990)

var dnsManagedZonesUpdate* = Call_DnsManagedZonesUpdate_579972(
    name: "dnsManagedZonesUpdate", meth: HttpMethod.HttpPut,
    host: "dns.googleapis.com", route: "/{project}/managedZones/{managedZone}",
    validator: validate_DnsManagedZonesUpdate_579973, base: "/dns/v1/projects",
    url: url_DnsManagedZonesUpdate_579974, schemes: {Scheme.Https})
type
  Call_DnsManagedZonesGet_579955 = ref object of OpenApiRestCall_579364
proc url_DnsManagedZonesGet_579957(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DnsManagedZonesGet_579956(path: JsonNode; query: JsonNode;
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
  var valid_579958 = path.getOrDefault("managedZone")
  valid_579958 = validateParameter(valid_579958, JString, required = true,
                                 default = nil)
  if valid_579958 != nil:
    section.add "managedZone", valid_579958
  var valid_579959 = path.getOrDefault("project")
  valid_579959 = validateParameter(valid_579959, JString, required = true,
                                 default = nil)
  if valid_579959 != nil:
    section.add "project", valid_579959
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
  var valid_579960 = query.getOrDefault("key")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = nil)
  if valid_579960 != nil:
    section.add "key", valid_579960
  var valid_579961 = query.getOrDefault("prettyPrint")
  valid_579961 = validateParameter(valid_579961, JBool, required = false,
                                 default = newJBool(true))
  if valid_579961 != nil:
    section.add "prettyPrint", valid_579961
  var valid_579962 = query.getOrDefault("oauth_token")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "oauth_token", valid_579962
  var valid_579963 = query.getOrDefault("alt")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = newJString("json"))
  if valid_579963 != nil:
    section.add "alt", valid_579963
  var valid_579964 = query.getOrDefault("userIp")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "userIp", valid_579964
  var valid_579965 = query.getOrDefault("quotaUser")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "quotaUser", valid_579965
  var valid_579966 = query.getOrDefault("clientOperationId")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "clientOperationId", valid_579966
  var valid_579967 = query.getOrDefault("fields")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "fields", valid_579967
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579968: Call_DnsManagedZonesGet_579955; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetch the representation of an existing ManagedZone.
  ## 
  let valid = call_579968.validator(path, query, header, formData, body)
  let scheme = call_579968.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579968.url(scheme.get, call_579968.host, call_579968.base,
                         call_579968.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579968, url, valid)

proc call*(call_579969: Call_DnsManagedZonesGet_579955; managedZone: string;
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
  var path_579970 = newJObject()
  var query_579971 = newJObject()
  add(query_579971, "key", newJString(key))
  add(query_579971, "prettyPrint", newJBool(prettyPrint))
  add(query_579971, "oauth_token", newJString(oauthToken))
  add(path_579970, "managedZone", newJString(managedZone))
  add(query_579971, "alt", newJString(alt))
  add(query_579971, "userIp", newJString(userIp))
  add(query_579971, "quotaUser", newJString(quotaUser))
  add(path_579970, "project", newJString(project))
  add(query_579971, "clientOperationId", newJString(clientOperationId))
  add(query_579971, "fields", newJString(fields))
  result = call_579969.call(path_579970, query_579971, nil, nil, nil)

var dnsManagedZonesGet* = Call_DnsManagedZonesGet_579955(
    name: "dnsManagedZonesGet", meth: HttpMethod.HttpGet,
    host: "dns.googleapis.com", route: "/{project}/managedZones/{managedZone}",
    validator: validate_DnsManagedZonesGet_579956, base: "/dns/v1/projects",
    url: url_DnsManagedZonesGet_579957, schemes: {Scheme.Https})
type
  Call_DnsManagedZonesPatch_580008 = ref object of OpenApiRestCall_579364
proc url_DnsManagedZonesPatch_580010(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DnsManagedZonesPatch_580009(path: JsonNode; query: JsonNode;
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
  var valid_580011 = path.getOrDefault("managedZone")
  valid_580011 = validateParameter(valid_580011, JString, required = true,
                                 default = nil)
  if valid_580011 != nil:
    section.add "managedZone", valid_580011
  var valid_580012 = path.getOrDefault("project")
  valid_580012 = validateParameter(valid_580012, JString, required = true,
                                 default = nil)
  if valid_580012 != nil:
    section.add "project", valid_580012
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
  var valid_580013 = query.getOrDefault("key")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "key", valid_580013
  var valid_580014 = query.getOrDefault("prettyPrint")
  valid_580014 = validateParameter(valid_580014, JBool, required = false,
                                 default = newJBool(true))
  if valid_580014 != nil:
    section.add "prettyPrint", valid_580014
  var valid_580015 = query.getOrDefault("oauth_token")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "oauth_token", valid_580015
  var valid_580016 = query.getOrDefault("alt")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = newJString("json"))
  if valid_580016 != nil:
    section.add "alt", valid_580016
  var valid_580017 = query.getOrDefault("userIp")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "userIp", valid_580017
  var valid_580018 = query.getOrDefault("quotaUser")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "quotaUser", valid_580018
  var valid_580019 = query.getOrDefault("clientOperationId")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "clientOperationId", valid_580019
  var valid_580020 = query.getOrDefault("fields")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "fields", valid_580020
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

proc call*(call_580022: Call_DnsManagedZonesPatch_580008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Apply a partial update to an existing ManagedZone.
  ## 
  let valid = call_580022.validator(path, query, header, formData, body)
  let scheme = call_580022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580022.url(scheme.get, call_580022.host, call_580022.base,
                         call_580022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580022, url, valid)

proc call*(call_580023: Call_DnsManagedZonesPatch_580008; managedZone: string;
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
  var path_580024 = newJObject()
  var query_580025 = newJObject()
  var body_580026 = newJObject()
  add(query_580025, "key", newJString(key))
  add(query_580025, "prettyPrint", newJBool(prettyPrint))
  add(query_580025, "oauth_token", newJString(oauthToken))
  add(path_580024, "managedZone", newJString(managedZone))
  add(query_580025, "alt", newJString(alt))
  add(query_580025, "userIp", newJString(userIp))
  add(query_580025, "quotaUser", newJString(quotaUser))
  add(path_580024, "project", newJString(project))
  add(query_580025, "clientOperationId", newJString(clientOperationId))
  if body != nil:
    body_580026 = body
  add(query_580025, "fields", newJString(fields))
  result = call_580023.call(path_580024, query_580025, nil, nil, body_580026)

var dnsManagedZonesPatch* = Call_DnsManagedZonesPatch_580008(
    name: "dnsManagedZonesPatch", meth: HttpMethod.HttpPatch,
    host: "dns.googleapis.com", route: "/{project}/managedZones/{managedZone}",
    validator: validate_DnsManagedZonesPatch_580009, base: "/dns/v1/projects",
    url: url_DnsManagedZonesPatch_580010, schemes: {Scheme.Https})
type
  Call_DnsManagedZonesDelete_579991 = ref object of OpenApiRestCall_579364
proc url_DnsManagedZonesDelete_579993(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DnsManagedZonesDelete_579992(path: JsonNode; query: JsonNode;
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
  var valid_579994 = path.getOrDefault("managedZone")
  valid_579994 = validateParameter(valid_579994, JString, required = true,
                                 default = nil)
  if valid_579994 != nil:
    section.add "managedZone", valid_579994
  var valid_579995 = path.getOrDefault("project")
  valid_579995 = validateParameter(valid_579995, JString, required = true,
                                 default = nil)
  if valid_579995 != nil:
    section.add "project", valid_579995
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
  var valid_579996 = query.getOrDefault("key")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "key", valid_579996
  var valid_579997 = query.getOrDefault("prettyPrint")
  valid_579997 = validateParameter(valid_579997, JBool, required = false,
                                 default = newJBool(true))
  if valid_579997 != nil:
    section.add "prettyPrint", valid_579997
  var valid_579998 = query.getOrDefault("oauth_token")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "oauth_token", valid_579998
  var valid_579999 = query.getOrDefault("alt")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = newJString("json"))
  if valid_579999 != nil:
    section.add "alt", valid_579999
  var valid_580000 = query.getOrDefault("userIp")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "userIp", valid_580000
  var valid_580001 = query.getOrDefault("quotaUser")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "quotaUser", valid_580001
  var valid_580002 = query.getOrDefault("clientOperationId")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "clientOperationId", valid_580002
  var valid_580003 = query.getOrDefault("fields")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "fields", valid_580003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580004: Call_DnsManagedZonesDelete_579991; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a previously created ManagedZone.
  ## 
  let valid = call_580004.validator(path, query, header, formData, body)
  let scheme = call_580004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580004.url(scheme.get, call_580004.host, call_580004.base,
                         call_580004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580004, url, valid)

proc call*(call_580005: Call_DnsManagedZonesDelete_579991; managedZone: string;
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
  var path_580006 = newJObject()
  var query_580007 = newJObject()
  add(query_580007, "key", newJString(key))
  add(query_580007, "prettyPrint", newJBool(prettyPrint))
  add(query_580007, "oauth_token", newJString(oauthToken))
  add(path_580006, "managedZone", newJString(managedZone))
  add(query_580007, "alt", newJString(alt))
  add(query_580007, "userIp", newJString(userIp))
  add(query_580007, "quotaUser", newJString(quotaUser))
  add(path_580006, "project", newJString(project))
  add(query_580007, "clientOperationId", newJString(clientOperationId))
  add(query_580007, "fields", newJString(fields))
  result = call_580005.call(path_580006, query_580007, nil, nil, nil)

var dnsManagedZonesDelete* = Call_DnsManagedZonesDelete_579991(
    name: "dnsManagedZonesDelete", meth: HttpMethod.HttpDelete,
    host: "dns.googleapis.com", route: "/{project}/managedZones/{managedZone}",
    validator: validate_DnsManagedZonesDelete_579992, base: "/dns/v1/projects",
    url: url_DnsManagedZonesDelete_579993, schemes: {Scheme.Https})
type
  Call_DnsChangesCreate_580047 = ref object of OpenApiRestCall_579364
proc url_DnsChangesCreate_580049(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DnsChangesCreate_580048(path: JsonNode; query: JsonNode;
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
  var valid_580050 = path.getOrDefault("managedZone")
  valid_580050 = validateParameter(valid_580050, JString, required = true,
                                 default = nil)
  if valid_580050 != nil:
    section.add "managedZone", valid_580050
  var valid_580051 = path.getOrDefault("project")
  valid_580051 = validateParameter(valid_580051, JString, required = true,
                                 default = nil)
  if valid_580051 != nil:
    section.add "project", valid_580051
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
  var valid_580052 = query.getOrDefault("key")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "key", valid_580052
  var valid_580053 = query.getOrDefault("prettyPrint")
  valid_580053 = validateParameter(valid_580053, JBool, required = false,
                                 default = newJBool(true))
  if valid_580053 != nil:
    section.add "prettyPrint", valid_580053
  var valid_580054 = query.getOrDefault("oauth_token")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "oauth_token", valid_580054
  var valid_580055 = query.getOrDefault("alt")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = newJString("json"))
  if valid_580055 != nil:
    section.add "alt", valid_580055
  var valid_580056 = query.getOrDefault("userIp")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "userIp", valid_580056
  var valid_580057 = query.getOrDefault("quotaUser")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "quotaUser", valid_580057
  var valid_580058 = query.getOrDefault("clientOperationId")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "clientOperationId", valid_580058
  var valid_580059 = query.getOrDefault("fields")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "fields", valid_580059
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

proc call*(call_580061: Call_DnsChangesCreate_580047; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Atomically update the ResourceRecordSet collection.
  ## 
  let valid = call_580061.validator(path, query, header, formData, body)
  let scheme = call_580061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580061.url(scheme.get, call_580061.host, call_580061.base,
                         call_580061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580061, url, valid)

proc call*(call_580062: Call_DnsChangesCreate_580047; managedZone: string;
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
  var path_580063 = newJObject()
  var query_580064 = newJObject()
  var body_580065 = newJObject()
  add(query_580064, "key", newJString(key))
  add(query_580064, "prettyPrint", newJBool(prettyPrint))
  add(query_580064, "oauth_token", newJString(oauthToken))
  add(path_580063, "managedZone", newJString(managedZone))
  add(query_580064, "alt", newJString(alt))
  add(query_580064, "userIp", newJString(userIp))
  add(query_580064, "quotaUser", newJString(quotaUser))
  add(path_580063, "project", newJString(project))
  add(query_580064, "clientOperationId", newJString(clientOperationId))
  if body != nil:
    body_580065 = body
  add(query_580064, "fields", newJString(fields))
  result = call_580062.call(path_580063, query_580064, nil, nil, body_580065)

var dnsChangesCreate* = Call_DnsChangesCreate_580047(name: "dnsChangesCreate",
    meth: HttpMethod.HttpPost, host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/changes",
    validator: validate_DnsChangesCreate_580048, base: "/dns/v1/projects",
    url: url_DnsChangesCreate_580049, schemes: {Scheme.Https})
type
  Call_DnsChangesList_580027 = ref object of OpenApiRestCall_579364
proc url_DnsChangesList_580029(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DnsChangesList_580028(path: JsonNode; query: JsonNode;
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
  var valid_580030 = path.getOrDefault("managedZone")
  valid_580030 = validateParameter(valid_580030, JString, required = true,
                                 default = nil)
  if valid_580030 != nil:
    section.add "managedZone", valid_580030
  var valid_580031 = path.getOrDefault("project")
  valid_580031 = validateParameter(valid_580031, JString, required = true,
                                 default = nil)
  if valid_580031 != nil:
    section.add "project", valid_580031
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
  var valid_580034 = query.getOrDefault("oauth_token")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "oauth_token", valid_580034
  var valid_580035 = query.getOrDefault("sortBy")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = newJString("changeSequence"))
  if valid_580035 != nil:
    section.add "sortBy", valid_580035
  var valid_580036 = query.getOrDefault("alt")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = newJString("json"))
  if valid_580036 != nil:
    section.add "alt", valid_580036
  var valid_580037 = query.getOrDefault("userIp")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "userIp", valid_580037
  var valid_580038 = query.getOrDefault("quotaUser")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "quotaUser", valid_580038
  var valid_580039 = query.getOrDefault("pageToken")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "pageToken", valid_580039
  var valid_580040 = query.getOrDefault("sortOrder")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "sortOrder", valid_580040
  var valid_580041 = query.getOrDefault("fields")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "fields", valid_580041
  var valid_580042 = query.getOrDefault("maxResults")
  valid_580042 = validateParameter(valid_580042, JInt, required = false, default = nil)
  if valid_580042 != nil:
    section.add "maxResults", valid_580042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580043: Call_DnsChangesList_580027; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enumerate Changes to a ResourceRecordSet collection.
  ## 
  let valid = call_580043.validator(path, query, header, formData, body)
  let scheme = call_580043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580043.url(scheme.get, call_580043.host, call_580043.base,
                         call_580043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580043, url, valid)

proc call*(call_580044: Call_DnsChangesList_580027; managedZone: string;
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
  var path_580045 = newJObject()
  var query_580046 = newJObject()
  add(query_580046, "key", newJString(key))
  add(query_580046, "prettyPrint", newJBool(prettyPrint))
  add(query_580046, "oauth_token", newJString(oauthToken))
  add(path_580045, "managedZone", newJString(managedZone))
  add(query_580046, "sortBy", newJString(sortBy))
  add(query_580046, "alt", newJString(alt))
  add(query_580046, "userIp", newJString(userIp))
  add(query_580046, "quotaUser", newJString(quotaUser))
  add(query_580046, "pageToken", newJString(pageToken))
  add(query_580046, "sortOrder", newJString(sortOrder))
  add(path_580045, "project", newJString(project))
  add(query_580046, "fields", newJString(fields))
  add(query_580046, "maxResults", newJInt(maxResults))
  result = call_580044.call(path_580045, query_580046, nil, nil, nil)

var dnsChangesList* = Call_DnsChangesList_580027(name: "dnsChangesList",
    meth: HttpMethod.HttpGet, host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/changes",
    validator: validate_DnsChangesList_580028, base: "/dns/v1/projects",
    url: url_DnsChangesList_580029, schemes: {Scheme.Https})
type
  Call_DnsChangesGet_580066 = ref object of OpenApiRestCall_579364
proc url_DnsChangesGet_580068(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DnsChangesGet_580067(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_580069 = path.getOrDefault("managedZone")
  valid_580069 = validateParameter(valid_580069, JString, required = true,
                                 default = nil)
  if valid_580069 != nil:
    section.add "managedZone", valid_580069
  var valid_580070 = path.getOrDefault("project")
  valid_580070 = validateParameter(valid_580070, JString, required = true,
                                 default = nil)
  if valid_580070 != nil:
    section.add "project", valid_580070
  var valid_580071 = path.getOrDefault("changeId")
  valid_580071 = validateParameter(valid_580071, JString, required = true,
                                 default = nil)
  if valid_580071 != nil:
    section.add "changeId", valid_580071
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
  var valid_580072 = query.getOrDefault("key")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "key", valid_580072
  var valid_580073 = query.getOrDefault("prettyPrint")
  valid_580073 = validateParameter(valid_580073, JBool, required = false,
                                 default = newJBool(true))
  if valid_580073 != nil:
    section.add "prettyPrint", valid_580073
  var valid_580074 = query.getOrDefault("oauth_token")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "oauth_token", valid_580074
  var valid_580075 = query.getOrDefault("alt")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = newJString("json"))
  if valid_580075 != nil:
    section.add "alt", valid_580075
  var valid_580076 = query.getOrDefault("userIp")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "userIp", valid_580076
  var valid_580077 = query.getOrDefault("quotaUser")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "quotaUser", valid_580077
  var valid_580078 = query.getOrDefault("clientOperationId")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "clientOperationId", valid_580078
  var valid_580079 = query.getOrDefault("fields")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "fields", valid_580079
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580080: Call_DnsChangesGet_580066; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetch the representation of an existing Change.
  ## 
  let valid = call_580080.validator(path, query, header, formData, body)
  let scheme = call_580080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580080.url(scheme.get, call_580080.host, call_580080.base,
                         call_580080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580080, url, valid)

proc call*(call_580081: Call_DnsChangesGet_580066; managedZone: string;
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
  var path_580082 = newJObject()
  var query_580083 = newJObject()
  add(query_580083, "key", newJString(key))
  add(query_580083, "prettyPrint", newJBool(prettyPrint))
  add(query_580083, "oauth_token", newJString(oauthToken))
  add(path_580082, "managedZone", newJString(managedZone))
  add(query_580083, "alt", newJString(alt))
  add(query_580083, "userIp", newJString(userIp))
  add(query_580083, "quotaUser", newJString(quotaUser))
  add(path_580082, "project", newJString(project))
  add(query_580083, "clientOperationId", newJString(clientOperationId))
  add(path_580082, "changeId", newJString(changeId))
  add(query_580083, "fields", newJString(fields))
  result = call_580081.call(path_580082, query_580083, nil, nil, nil)

var dnsChangesGet* = Call_DnsChangesGet_580066(name: "dnsChangesGet",
    meth: HttpMethod.HttpGet, host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/changes/{changeId}",
    validator: validate_DnsChangesGet_580067, base: "/dns/v1/projects",
    url: url_DnsChangesGet_580068, schemes: {Scheme.Https})
type
  Call_DnsDnsKeysList_580084 = ref object of OpenApiRestCall_579364
proc url_DnsDnsKeysList_580086(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DnsDnsKeysList_580085(path: JsonNode; query: JsonNode;
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
  var valid_580087 = path.getOrDefault("managedZone")
  valid_580087 = validateParameter(valid_580087, JString, required = true,
                                 default = nil)
  if valid_580087 != nil:
    section.add "managedZone", valid_580087
  var valid_580088 = path.getOrDefault("project")
  valid_580088 = validateParameter(valid_580088, JString, required = true,
                                 default = nil)
  if valid_580088 != nil:
    section.add "project", valid_580088
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
  var valid_580089 = query.getOrDefault("key")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "key", valid_580089
  var valid_580090 = query.getOrDefault("prettyPrint")
  valid_580090 = validateParameter(valid_580090, JBool, required = false,
                                 default = newJBool(true))
  if valid_580090 != nil:
    section.add "prettyPrint", valid_580090
  var valid_580091 = query.getOrDefault("oauth_token")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "oauth_token", valid_580091
  var valid_580092 = query.getOrDefault("digestType")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "digestType", valid_580092
  var valid_580093 = query.getOrDefault("alt")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = newJString("json"))
  if valid_580093 != nil:
    section.add "alt", valid_580093
  var valid_580094 = query.getOrDefault("userIp")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "userIp", valid_580094
  var valid_580095 = query.getOrDefault("quotaUser")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "quotaUser", valid_580095
  var valid_580096 = query.getOrDefault("pageToken")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "pageToken", valid_580096
  var valid_580097 = query.getOrDefault("fields")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "fields", valid_580097
  var valid_580098 = query.getOrDefault("maxResults")
  valid_580098 = validateParameter(valid_580098, JInt, required = false, default = nil)
  if valid_580098 != nil:
    section.add "maxResults", valid_580098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580099: Call_DnsDnsKeysList_580084; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enumerate DnsKeys to a ResourceRecordSet collection.
  ## 
  let valid = call_580099.validator(path, query, header, formData, body)
  let scheme = call_580099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580099.url(scheme.get, call_580099.host, call_580099.base,
                         call_580099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580099, url, valid)

proc call*(call_580100: Call_DnsDnsKeysList_580084; managedZone: string;
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
  var path_580101 = newJObject()
  var query_580102 = newJObject()
  add(query_580102, "key", newJString(key))
  add(query_580102, "prettyPrint", newJBool(prettyPrint))
  add(query_580102, "oauth_token", newJString(oauthToken))
  add(path_580101, "managedZone", newJString(managedZone))
  add(query_580102, "digestType", newJString(digestType))
  add(query_580102, "alt", newJString(alt))
  add(query_580102, "userIp", newJString(userIp))
  add(query_580102, "quotaUser", newJString(quotaUser))
  add(query_580102, "pageToken", newJString(pageToken))
  add(path_580101, "project", newJString(project))
  add(query_580102, "fields", newJString(fields))
  add(query_580102, "maxResults", newJInt(maxResults))
  result = call_580100.call(path_580101, query_580102, nil, nil, nil)

var dnsDnsKeysList* = Call_DnsDnsKeysList_580084(name: "dnsDnsKeysList",
    meth: HttpMethod.HttpGet, host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/dnsKeys",
    validator: validate_DnsDnsKeysList_580085, base: "/dns/v1/projects",
    url: url_DnsDnsKeysList_580086, schemes: {Scheme.Https})
type
  Call_DnsDnsKeysGet_580103 = ref object of OpenApiRestCall_579364
proc url_DnsDnsKeysGet_580105(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DnsDnsKeysGet_580104(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_580106 = path.getOrDefault("managedZone")
  valid_580106 = validateParameter(valid_580106, JString, required = true,
                                 default = nil)
  if valid_580106 != nil:
    section.add "managedZone", valid_580106
  var valid_580107 = path.getOrDefault("project")
  valid_580107 = validateParameter(valid_580107, JString, required = true,
                                 default = nil)
  if valid_580107 != nil:
    section.add "project", valid_580107
  var valid_580108 = path.getOrDefault("dnsKeyId")
  valid_580108 = validateParameter(valid_580108, JString, required = true,
                                 default = nil)
  if valid_580108 != nil:
    section.add "dnsKeyId", valid_580108
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
  var valid_580109 = query.getOrDefault("key")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "key", valid_580109
  var valid_580110 = query.getOrDefault("prettyPrint")
  valid_580110 = validateParameter(valid_580110, JBool, required = false,
                                 default = newJBool(true))
  if valid_580110 != nil:
    section.add "prettyPrint", valid_580110
  var valid_580111 = query.getOrDefault("oauth_token")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "oauth_token", valid_580111
  var valid_580112 = query.getOrDefault("digestType")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "digestType", valid_580112
  var valid_580113 = query.getOrDefault("alt")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = newJString("json"))
  if valid_580113 != nil:
    section.add "alt", valid_580113
  var valid_580114 = query.getOrDefault("userIp")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "userIp", valid_580114
  var valid_580115 = query.getOrDefault("quotaUser")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "quotaUser", valid_580115
  var valid_580116 = query.getOrDefault("clientOperationId")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "clientOperationId", valid_580116
  var valid_580117 = query.getOrDefault("fields")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "fields", valid_580117
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580118: Call_DnsDnsKeysGet_580103; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetch the representation of an existing DnsKey.
  ## 
  let valid = call_580118.validator(path, query, header, formData, body)
  let scheme = call_580118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580118.url(scheme.get, call_580118.host, call_580118.base,
                         call_580118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580118, url, valid)

proc call*(call_580119: Call_DnsDnsKeysGet_580103; managedZone: string;
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
  var path_580120 = newJObject()
  var query_580121 = newJObject()
  add(query_580121, "key", newJString(key))
  add(query_580121, "prettyPrint", newJBool(prettyPrint))
  add(query_580121, "oauth_token", newJString(oauthToken))
  add(path_580120, "managedZone", newJString(managedZone))
  add(query_580121, "digestType", newJString(digestType))
  add(query_580121, "alt", newJString(alt))
  add(query_580121, "userIp", newJString(userIp))
  add(query_580121, "quotaUser", newJString(quotaUser))
  add(path_580120, "project", newJString(project))
  add(query_580121, "clientOperationId", newJString(clientOperationId))
  add(path_580120, "dnsKeyId", newJString(dnsKeyId))
  add(query_580121, "fields", newJString(fields))
  result = call_580119.call(path_580120, query_580121, nil, nil, nil)

var dnsDnsKeysGet* = Call_DnsDnsKeysGet_580103(name: "dnsDnsKeysGet",
    meth: HttpMethod.HttpGet, host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/dnsKeys/{dnsKeyId}",
    validator: validate_DnsDnsKeysGet_580104, base: "/dns/v1/projects",
    url: url_DnsDnsKeysGet_580105, schemes: {Scheme.Https})
type
  Call_DnsManagedZoneOperationsList_580122 = ref object of OpenApiRestCall_579364
proc url_DnsManagedZoneOperationsList_580124(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DnsManagedZoneOperationsList_580123(path: JsonNode; query: JsonNode;
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
  var valid_580125 = path.getOrDefault("managedZone")
  valid_580125 = validateParameter(valid_580125, JString, required = true,
                                 default = nil)
  if valid_580125 != nil:
    section.add "managedZone", valid_580125
  var valid_580126 = path.getOrDefault("project")
  valid_580126 = validateParameter(valid_580126, JString, required = true,
                                 default = nil)
  if valid_580126 != nil:
    section.add "project", valid_580126
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
  var valid_580127 = query.getOrDefault("key")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "key", valid_580127
  var valid_580128 = query.getOrDefault("prettyPrint")
  valid_580128 = validateParameter(valid_580128, JBool, required = false,
                                 default = newJBool(true))
  if valid_580128 != nil:
    section.add "prettyPrint", valid_580128
  var valid_580129 = query.getOrDefault("oauth_token")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "oauth_token", valid_580129
  var valid_580130 = query.getOrDefault("sortBy")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = newJString("startTime"))
  if valid_580130 != nil:
    section.add "sortBy", valid_580130
  var valid_580131 = query.getOrDefault("alt")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = newJString("json"))
  if valid_580131 != nil:
    section.add "alt", valid_580131
  var valid_580132 = query.getOrDefault("userIp")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "userIp", valid_580132
  var valid_580133 = query.getOrDefault("quotaUser")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "quotaUser", valid_580133
  var valid_580134 = query.getOrDefault("pageToken")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "pageToken", valid_580134
  var valid_580135 = query.getOrDefault("fields")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "fields", valid_580135
  var valid_580136 = query.getOrDefault("maxResults")
  valid_580136 = validateParameter(valid_580136, JInt, required = false, default = nil)
  if valid_580136 != nil:
    section.add "maxResults", valid_580136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580137: Call_DnsManagedZoneOperationsList_580122; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enumerate Operations for the given ManagedZone.
  ## 
  let valid = call_580137.validator(path, query, header, formData, body)
  let scheme = call_580137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580137.url(scheme.get, call_580137.host, call_580137.base,
                         call_580137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580137, url, valid)

proc call*(call_580138: Call_DnsManagedZoneOperationsList_580122;
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
  var path_580139 = newJObject()
  var query_580140 = newJObject()
  add(query_580140, "key", newJString(key))
  add(query_580140, "prettyPrint", newJBool(prettyPrint))
  add(query_580140, "oauth_token", newJString(oauthToken))
  add(path_580139, "managedZone", newJString(managedZone))
  add(query_580140, "sortBy", newJString(sortBy))
  add(query_580140, "alt", newJString(alt))
  add(query_580140, "userIp", newJString(userIp))
  add(query_580140, "quotaUser", newJString(quotaUser))
  add(query_580140, "pageToken", newJString(pageToken))
  add(path_580139, "project", newJString(project))
  add(query_580140, "fields", newJString(fields))
  add(query_580140, "maxResults", newJInt(maxResults))
  result = call_580138.call(path_580139, query_580140, nil, nil, nil)

var dnsManagedZoneOperationsList* = Call_DnsManagedZoneOperationsList_580122(
    name: "dnsManagedZoneOperationsList", meth: HttpMethod.HttpGet,
    host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/operations",
    validator: validate_DnsManagedZoneOperationsList_580123,
    base: "/dns/v1/projects", url: url_DnsManagedZoneOperationsList_580124,
    schemes: {Scheme.Https})
type
  Call_DnsManagedZoneOperationsGet_580141 = ref object of OpenApiRestCall_579364
proc url_DnsManagedZoneOperationsGet_580143(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DnsManagedZoneOperationsGet_580142(path: JsonNode; query: JsonNode;
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
  var valid_580144 = path.getOrDefault("managedZone")
  valid_580144 = validateParameter(valid_580144, JString, required = true,
                                 default = nil)
  if valid_580144 != nil:
    section.add "managedZone", valid_580144
  var valid_580145 = path.getOrDefault("operation")
  valid_580145 = validateParameter(valid_580145, JString, required = true,
                                 default = nil)
  if valid_580145 != nil:
    section.add "operation", valid_580145
  var valid_580146 = path.getOrDefault("project")
  valid_580146 = validateParameter(valid_580146, JString, required = true,
                                 default = nil)
  if valid_580146 != nil:
    section.add "project", valid_580146
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
  var valid_580147 = query.getOrDefault("key")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "key", valid_580147
  var valid_580148 = query.getOrDefault("prettyPrint")
  valid_580148 = validateParameter(valid_580148, JBool, required = false,
                                 default = newJBool(true))
  if valid_580148 != nil:
    section.add "prettyPrint", valid_580148
  var valid_580149 = query.getOrDefault("oauth_token")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "oauth_token", valid_580149
  var valid_580150 = query.getOrDefault("alt")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = newJString("json"))
  if valid_580150 != nil:
    section.add "alt", valid_580150
  var valid_580151 = query.getOrDefault("userIp")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "userIp", valid_580151
  var valid_580152 = query.getOrDefault("quotaUser")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "quotaUser", valid_580152
  var valid_580153 = query.getOrDefault("clientOperationId")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "clientOperationId", valid_580153
  var valid_580154 = query.getOrDefault("fields")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "fields", valid_580154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580155: Call_DnsManagedZoneOperationsGet_580141; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetch the representation of an existing Operation.
  ## 
  let valid = call_580155.validator(path, query, header, formData, body)
  let scheme = call_580155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580155.url(scheme.get, call_580155.host, call_580155.base,
                         call_580155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580155, url, valid)

proc call*(call_580156: Call_DnsManagedZoneOperationsGet_580141;
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
  var path_580157 = newJObject()
  var query_580158 = newJObject()
  add(query_580158, "key", newJString(key))
  add(query_580158, "prettyPrint", newJBool(prettyPrint))
  add(query_580158, "oauth_token", newJString(oauthToken))
  add(path_580157, "managedZone", newJString(managedZone))
  add(path_580157, "operation", newJString(operation))
  add(query_580158, "alt", newJString(alt))
  add(query_580158, "userIp", newJString(userIp))
  add(query_580158, "quotaUser", newJString(quotaUser))
  add(path_580157, "project", newJString(project))
  add(query_580158, "clientOperationId", newJString(clientOperationId))
  add(query_580158, "fields", newJString(fields))
  result = call_580156.call(path_580157, query_580158, nil, nil, nil)

var dnsManagedZoneOperationsGet* = Call_DnsManagedZoneOperationsGet_580141(
    name: "dnsManagedZoneOperationsGet", meth: HttpMethod.HttpGet,
    host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/operations/{operation}",
    validator: validate_DnsManagedZoneOperationsGet_580142,
    base: "/dns/v1/projects", url: url_DnsManagedZoneOperationsGet_580143,
    schemes: {Scheme.Https})
type
  Call_DnsResourceRecordSetsList_580159 = ref object of OpenApiRestCall_579364
proc url_DnsResourceRecordSetsList_580161(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DnsResourceRecordSetsList_580160(path: JsonNode; query: JsonNode;
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
  var valid_580162 = path.getOrDefault("managedZone")
  valid_580162 = validateParameter(valid_580162, JString, required = true,
                                 default = nil)
  if valid_580162 != nil:
    section.add "managedZone", valid_580162
  var valid_580163 = path.getOrDefault("project")
  valid_580163 = validateParameter(valid_580163, JString, required = true,
                                 default = nil)
  if valid_580163 != nil:
    section.add "project", valid_580163
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
  var valid_580164 = query.getOrDefault("key")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "key", valid_580164
  var valid_580165 = query.getOrDefault("prettyPrint")
  valid_580165 = validateParameter(valid_580165, JBool, required = false,
                                 default = newJBool(true))
  if valid_580165 != nil:
    section.add "prettyPrint", valid_580165
  var valid_580166 = query.getOrDefault("oauth_token")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "oauth_token", valid_580166
  var valid_580167 = query.getOrDefault("name")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "name", valid_580167
  var valid_580168 = query.getOrDefault("alt")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = newJString("json"))
  if valid_580168 != nil:
    section.add "alt", valid_580168
  var valid_580169 = query.getOrDefault("userIp")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "userIp", valid_580169
  var valid_580170 = query.getOrDefault("quotaUser")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "quotaUser", valid_580170
  var valid_580171 = query.getOrDefault("type")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "type", valid_580171
  var valid_580172 = query.getOrDefault("pageToken")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "pageToken", valid_580172
  var valid_580173 = query.getOrDefault("fields")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "fields", valid_580173
  var valid_580174 = query.getOrDefault("maxResults")
  valid_580174 = validateParameter(valid_580174, JInt, required = false, default = nil)
  if valid_580174 != nil:
    section.add "maxResults", valid_580174
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580175: Call_DnsResourceRecordSetsList_580159; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enumerate ResourceRecordSets that have been created but not yet deleted.
  ## 
  let valid = call_580175.validator(path, query, header, formData, body)
  let scheme = call_580175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580175.url(scheme.get, call_580175.host, call_580175.base,
                         call_580175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580175, url, valid)

proc call*(call_580176: Call_DnsResourceRecordSetsList_580159; managedZone: string;
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
  var path_580177 = newJObject()
  var query_580178 = newJObject()
  add(query_580178, "key", newJString(key))
  add(query_580178, "prettyPrint", newJBool(prettyPrint))
  add(query_580178, "oauth_token", newJString(oauthToken))
  add(query_580178, "name", newJString(name))
  add(path_580177, "managedZone", newJString(managedZone))
  add(query_580178, "alt", newJString(alt))
  add(query_580178, "userIp", newJString(userIp))
  add(query_580178, "quotaUser", newJString(quotaUser))
  add(query_580178, "type", newJString(`type`))
  add(query_580178, "pageToken", newJString(pageToken))
  add(path_580177, "project", newJString(project))
  add(query_580178, "fields", newJString(fields))
  add(query_580178, "maxResults", newJInt(maxResults))
  result = call_580176.call(path_580177, query_580178, nil, nil, nil)

var dnsResourceRecordSetsList* = Call_DnsResourceRecordSetsList_580159(
    name: "dnsResourceRecordSetsList", meth: HttpMethod.HttpGet,
    host: "dns.googleapis.com",
    route: "/{project}/managedZones/{managedZone}/rrsets",
    validator: validate_DnsResourceRecordSetsList_580160,
    base: "/dns/v1/projects", url: url_DnsResourceRecordSetsList_580161,
    schemes: {Scheme.Https})
type
  Call_DnsPoliciesCreate_580196 = ref object of OpenApiRestCall_579364
proc url_DnsPoliciesCreate_580198(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DnsPoliciesCreate_580197(path: JsonNode; query: JsonNode;
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
  var valid_580199 = path.getOrDefault("project")
  valid_580199 = validateParameter(valid_580199, JString, required = true,
                                 default = nil)
  if valid_580199 != nil:
    section.add "project", valid_580199
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
  var valid_580200 = query.getOrDefault("key")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "key", valid_580200
  var valid_580201 = query.getOrDefault("prettyPrint")
  valid_580201 = validateParameter(valid_580201, JBool, required = false,
                                 default = newJBool(true))
  if valid_580201 != nil:
    section.add "prettyPrint", valid_580201
  var valid_580202 = query.getOrDefault("oauth_token")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "oauth_token", valid_580202
  var valid_580203 = query.getOrDefault("alt")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = newJString("json"))
  if valid_580203 != nil:
    section.add "alt", valid_580203
  var valid_580204 = query.getOrDefault("userIp")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "userIp", valid_580204
  var valid_580205 = query.getOrDefault("quotaUser")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "quotaUser", valid_580205
  var valid_580206 = query.getOrDefault("clientOperationId")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "clientOperationId", valid_580206
  var valid_580207 = query.getOrDefault("fields")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "fields", valid_580207
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

proc call*(call_580209: Call_DnsPoliciesCreate_580196; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new Policy
  ## 
  let valid = call_580209.validator(path, query, header, formData, body)
  let scheme = call_580209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580209.url(scheme.get, call_580209.host, call_580209.base,
                         call_580209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580209, url, valid)

proc call*(call_580210: Call_DnsPoliciesCreate_580196; project: string;
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
  var path_580211 = newJObject()
  var query_580212 = newJObject()
  var body_580213 = newJObject()
  add(query_580212, "key", newJString(key))
  add(query_580212, "prettyPrint", newJBool(prettyPrint))
  add(query_580212, "oauth_token", newJString(oauthToken))
  add(query_580212, "alt", newJString(alt))
  add(query_580212, "userIp", newJString(userIp))
  add(query_580212, "quotaUser", newJString(quotaUser))
  add(path_580211, "project", newJString(project))
  add(query_580212, "clientOperationId", newJString(clientOperationId))
  if body != nil:
    body_580213 = body
  add(query_580212, "fields", newJString(fields))
  result = call_580210.call(path_580211, query_580212, nil, nil, body_580213)

var dnsPoliciesCreate* = Call_DnsPoliciesCreate_580196(name: "dnsPoliciesCreate",
    meth: HttpMethod.HttpPost, host: "dns.googleapis.com",
    route: "/{project}/policies", validator: validate_DnsPoliciesCreate_580197,
    base: "/dns/v1/projects", url: url_DnsPoliciesCreate_580198,
    schemes: {Scheme.Https})
type
  Call_DnsPoliciesList_580179 = ref object of OpenApiRestCall_579364
proc url_DnsPoliciesList_580181(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DnsPoliciesList_580180(path: JsonNode; query: JsonNode;
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
  var valid_580182 = path.getOrDefault("project")
  valid_580182 = validateParameter(valid_580182, JString, required = true,
                                 default = nil)
  if valid_580182 != nil:
    section.add "project", valid_580182
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
  var valid_580183 = query.getOrDefault("key")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "key", valid_580183
  var valid_580184 = query.getOrDefault("prettyPrint")
  valid_580184 = validateParameter(valid_580184, JBool, required = false,
                                 default = newJBool(true))
  if valid_580184 != nil:
    section.add "prettyPrint", valid_580184
  var valid_580185 = query.getOrDefault("oauth_token")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "oauth_token", valid_580185
  var valid_580186 = query.getOrDefault("alt")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = newJString("json"))
  if valid_580186 != nil:
    section.add "alt", valid_580186
  var valid_580187 = query.getOrDefault("userIp")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "userIp", valid_580187
  var valid_580188 = query.getOrDefault("quotaUser")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "quotaUser", valid_580188
  var valid_580189 = query.getOrDefault("pageToken")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "pageToken", valid_580189
  var valid_580190 = query.getOrDefault("fields")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "fields", valid_580190
  var valid_580191 = query.getOrDefault("maxResults")
  valid_580191 = validateParameter(valid_580191, JInt, required = false, default = nil)
  if valid_580191 != nil:
    section.add "maxResults", valid_580191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580192: Call_DnsPoliciesList_580179; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enumerate all Policies associated with a project.
  ## 
  let valid = call_580192.validator(path, query, header, formData, body)
  let scheme = call_580192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580192.url(scheme.get, call_580192.host, call_580192.base,
                         call_580192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580192, url, valid)

proc call*(call_580193: Call_DnsPoliciesList_580179; project: string;
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
  var path_580194 = newJObject()
  var query_580195 = newJObject()
  add(query_580195, "key", newJString(key))
  add(query_580195, "prettyPrint", newJBool(prettyPrint))
  add(query_580195, "oauth_token", newJString(oauthToken))
  add(query_580195, "alt", newJString(alt))
  add(query_580195, "userIp", newJString(userIp))
  add(query_580195, "quotaUser", newJString(quotaUser))
  add(query_580195, "pageToken", newJString(pageToken))
  add(path_580194, "project", newJString(project))
  add(query_580195, "fields", newJString(fields))
  add(query_580195, "maxResults", newJInt(maxResults))
  result = call_580193.call(path_580194, query_580195, nil, nil, nil)

var dnsPoliciesList* = Call_DnsPoliciesList_580179(name: "dnsPoliciesList",
    meth: HttpMethod.HttpGet, host: "dns.googleapis.com",
    route: "/{project}/policies", validator: validate_DnsPoliciesList_580180,
    base: "/dns/v1/projects", url: url_DnsPoliciesList_580181,
    schemes: {Scheme.Https})
type
  Call_DnsPoliciesUpdate_580231 = ref object of OpenApiRestCall_579364
proc url_DnsPoliciesUpdate_580233(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DnsPoliciesUpdate_580232(path: JsonNode; query: JsonNode;
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
  var valid_580234 = path.getOrDefault("policy")
  valid_580234 = validateParameter(valid_580234, JString, required = true,
                                 default = nil)
  if valid_580234 != nil:
    section.add "policy", valid_580234
  var valid_580235 = path.getOrDefault("project")
  valid_580235 = validateParameter(valid_580235, JString, required = true,
                                 default = nil)
  if valid_580235 != nil:
    section.add "project", valid_580235
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
  var valid_580236 = query.getOrDefault("key")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "key", valid_580236
  var valid_580237 = query.getOrDefault("prettyPrint")
  valid_580237 = validateParameter(valid_580237, JBool, required = false,
                                 default = newJBool(true))
  if valid_580237 != nil:
    section.add "prettyPrint", valid_580237
  var valid_580238 = query.getOrDefault("oauth_token")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = nil)
  if valid_580238 != nil:
    section.add "oauth_token", valid_580238
  var valid_580239 = query.getOrDefault("alt")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = newJString("json"))
  if valid_580239 != nil:
    section.add "alt", valid_580239
  var valid_580240 = query.getOrDefault("userIp")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "userIp", valid_580240
  var valid_580241 = query.getOrDefault("quotaUser")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "quotaUser", valid_580241
  var valid_580242 = query.getOrDefault("clientOperationId")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "clientOperationId", valid_580242
  var valid_580243 = query.getOrDefault("fields")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "fields", valid_580243
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

proc call*(call_580245: Call_DnsPoliciesUpdate_580231; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an existing Policy.
  ## 
  let valid = call_580245.validator(path, query, header, formData, body)
  let scheme = call_580245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580245.url(scheme.get, call_580245.host, call_580245.base,
                         call_580245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580245, url, valid)

proc call*(call_580246: Call_DnsPoliciesUpdate_580231; policy: string;
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
  var path_580247 = newJObject()
  var query_580248 = newJObject()
  var body_580249 = newJObject()
  add(query_580248, "key", newJString(key))
  add(query_580248, "prettyPrint", newJBool(prettyPrint))
  add(query_580248, "oauth_token", newJString(oauthToken))
  add(path_580247, "policy", newJString(policy))
  add(query_580248, "alt", newJString(alt))
  add(query_580248, "userIp", newJString(userIp))
  add(query_580248, "quotaUser", newJString(quotaUser))
  add(path_580247, "project", newJString(project))
  add(query_580248, "clientOperationId", newJString(clientOperationId))
  if body != nil:
    body_580249 = body
  add(query_580248, "fields", newJString(fields))
  result = call_580246.call(path_580247, query_580248, nil, nil, body_580249)

var dnsPoliciesUpdate* = Call_DnsPoliciesUpdate_580231(name: "dnsPoliciesUpdate",
    meth: HttpMethod.HttpPut, host: "dns.googleapis.com",
    route: "/{project}/policies/{policy}", validator: validate_DnsPoliciesUpdate_580232,
    base: "/dns/v1/projects", url: url_DnsPoliciesUpdate_580233,
    schemes: {Scheme.Https})
type
  Call_DnsPoliciesGet_580214 = ref object of OpenApiRestCall_579364
proc url_DnsPoliciesGet_580216(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DnsPoliciesGet_580215(path: JsonNode; query: JsonNode;
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
  var valid_580217 = path.getOrDefault("policy")
  valid_580217 = validateParameter(valid_580217, JString, required = true,
                                 default = nil)
  if valid_580217 != nil:
    section.add "policy", valid_580217
  var valid_580218 = path.getOrDefault("project")
  valid_580218 = validateParameter(valid_580218, JString, required = true,
                                 default = nil)
  if valid_580218 != nil:
    section.add "project", valid_580218
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
  var valid_580219 = query.getOrDefault("key")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "key", valid_580219
  var valid_580220 = query.getOrDefault("prettyPrint")
  valid_580220 = validateParameter(valid_580220, JBool, required = false,
                                 default = newJBool(true))
  if valid_580220 != nil:
    section.add "prettyPrint", valid_580220
  var valid_580221 = query.getOrDefault("oauth_token")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "oauth_token", valid_580221
  var valid_580222 = query.getOrDefault("alt")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = newJString("json"))
  if valid_580222 != nil:
    section.add "alt", valid_580222
  var valid_580223 = query.getOrDefault("userIp")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "userIp", valid_580223
  var valid_580224 = query.getOrDefault("quotaUser")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "quotaUser", valid_580224
  var valid_580225 = query.getOrDefault("clientOperationId")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "clientOperationId", valid_580225
  var valid_580226 = query.getOrDefault("fields")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "fields", valid_580226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580227: Call_DnsPoliciesGet_580214; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fetch the representation of an existing Policy.
  ## 
  let valid = call_580227.validator(path, query, header, formData, body)
  let scheme = call_580227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580227.url(scheme.get, call_580227.host, call_580227.base,
                         call_580227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580227, url, valid)

proc call*(call_580228: Call_DnsPoliciesGet_580214; policy: string; project: string;
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
  var path_580229 = newJObject()
  var query_580230 = newJObject()
  add(query_580230, "key", newJString(key))
  add(query_580230, "prettyPrint", newJBool(prettyPrint))
  add(query_580230, "oauth_token", newJString(oauthToken))
  add(path_580229, "policy", newJString(policy))
  add(query_580230, "alt", newJString(alt))
  add(query_580230, "userIp", newJString(userIp))
  add(query_580230, "quotaUser", newJString(quotaUser))
  add(path_580229, "project", newJString(project))
  add(query_580230, "clientOperationId", newJString(clientOperationId))
  add(query_580230, "fields", newJString(fields))
  result = call_580228.call(path_580229, query_580230, nil, nil, nil)

var dnsPoliciesGet* = Call_DnsPoliciesGet_580214(name: "dnsPoliciesGet",
    meth: HttpMethod.HttpGet, host: "dns.googleapis.com",
    route: "/{project}/policies/{policy}", validator: validate_DnsPoliciesGet_580215,
    base: "/dns/v1/projects", url: url_DnsPoliciesGet_580216,
    schemes: {Scheme.Https})
type
  Call_DnsPoliciesPatch_580267 = ref object of OpenApiRestCall_579364
proc url_DnsPoliciesPatch_580269(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DnsPoliciesPatch_580268(path: JsonNode; query: JsonNode;
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
  var valid_580270 = path.getOrDefault("policy")
  valid_580270 = validateParameter(valid_580270, JString, required = true,
                                 default = nil)
  if valid_580270 != nil:
    section.add "policy", valid_580270
  var valid_580271 = path.getOrDefault("project")
  valid_580271 = validateParameter(valid_580271, JString, required = true,
                                 default = nil)
  if valid_580271 != nil:
    section.add "project", valid_580271
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
  var valid_580272 = query.getOrDefault("key")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "key", valid_580272
  var valid_580273 = query.getOrDefault("prettyPrint")
  valid_580273 = validateParameter(valid_580273, JBool, required = false,
                                 default = newJBool(true))
  if valid_580273 != nil:
    section.add "prettyPrint", valid_580273
  var valid_580274 = query.getOrDefault("oauth_token")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "oauth_token", valid_580274
  var valid_580275 = query.getOrDefault("alt")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = newJString("json"))
  if valid_580275 != nil:
    section.add "alt", valid_580275
  var valid_580276 = query.getOrDefault("userIp")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "userIp", valid_580276
  var valid_580277 = query.getOrDefault("quotaUser")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "quotaUser", valid_580277
  var valid_580278 = query.getOrDefault("clientOperationId")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "clientOperationId", valid_580278
  var valid_580279 = query.getOrDefault("fields")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "fields", valid_580279
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

proc call*(call_580281: Call_DnsPoliciesPatch_580267; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Apply a partial update to an existing Policy.
  ## 
  let valid = call_580281.validator(path, query, header, formData, body)
  let scheme = call_580281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580281.url(scheme.get, call_580281.host, call_580281.base,
                         call_580281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580281, url, valid)

proc call*(call_580282: Call_DnsPoliciesPatch_580267; policy: string;
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
  var path_580283 = newJObject()
  var query_580284 = newJObject()
  var body_580285 = newJObject()
  add(query_580284, "key", newJString(key))
  add(query_580284, "prettyPrint", newJBool(prettyPrint))
  add(query_580284, "oauth_token", newJString(oauthToken))
  add(path_580283, "policy", newJString(policy))
  add(query_580284, "alt", newJString(alt))
  add(query_580284, "userIp", newJString(userIp))
  add(query_580284, "quotaUser", newJString(quotaUser))
  add(path_580283, "project", newJString(project))
  add(query_580284, "clientOperationId", newJString(clientOperationId))
  if body != nil:
    body_580285 = body
  add(query_580284, "fields", newJString(fields))
  result = call_580282.call(path_580283, query_580284, nil, nil, body_580285)

var dnsPoliciesPatch* = Call_DnsPoliciesPatch_580267(name: "dnsPoliciesPatch",
    meth: HttpMethod.HttpPatch, host: "dns.googleapis.com",
    route: "/{project}/policies/{policy}", validator: validate_DnsPoliciesPatch_580268,
    base: "/dns/v1/projects", url: url_DnsPoliciesPatch_580269,
    schemes: {Scheme.Https})
type
  Call_DnsPoliciesDelete_580250 = ref object of OpenApiRestCall_579364
proc url_DnsPoliciesDelete_580252(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DnsPoliciesDelete_580251(path: JsonNode; query: JsonNode;
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
  var valid_580253 = path.getOrDefault("policy")
  valid_580253 = validateParameter(valid_580253, JString, required = true,
                                 default = nil)
  if valid_580253 != nil:
    section.add "policy", valid_580253
  var valid_580254 = path.getOrDefault("project")
  valid_580254 = validateParameter(valid_580254, JString, required = true,
                                 default = nil)
  if valid_580254 != nil:
    section.add "project", valid_580254
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
  var valid_580255 = query.getOrDefault("key")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "key", valid_580255
  var valid_580256 = query.getOrDefault("prettyPrint")
  valid_580256 = validateParameter(valid_580256, JBool, required = false,
                                 default = newJBool(true))
  if valid_580256 != nil:
    section.add "prettyPrint", valid_580256
  var valid_580257 = query.getOrDefault("oauth_token")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = nil)
  if valid_580257 != nil:
    section.add "oauth_token", valid_580257
  var valid_580258 = query.getOrDefault("alt")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = newJString("json"))
  if valid_580258 != nil:
    section.add "alt", valid_580258
  var valid_580259 = query.getOrDefault("userIp")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "userIp", valid_580259
  var valid_580260 = query.getOrDefault("quotaUser")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "quotaUser", valid_580260
  var valid_580261 = query.getOrDefault("clientOperationId")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "clientOperationId", valid_580261
  var valid_580262 = query.getOrDefault("fields")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "fields", valid_580262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580263: Call_DnsPoliciesDelete_580250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a previously created Policy. Will fail if the policy is still being referenced by a network.
  ## 
  let valid = call_580263.validator(path, query, header, formData, body)
  let scheme = call_580263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580263.url(scheme.get, call_580263.host, call_580263.base,
                         call_580263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580263, url, valid)

proc call*(call_580264: Call_DnsPoliciesDelete_580250; policy: string;
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
  var path_580265 = newJObject()
  var query_580266 = newJObject()
  add(query_580266, "key", newJString(key))
  add(query_580266, "prettyPrint", newJBool(prettyPrint))
  add(query_580266, "oauth_token", newJString(oauthToken))
  add(path_580265, "policy", newJString(policy))
  add(query_580266, "alt", newJString(alt))
  add(query_580266, "userIp", newJString(userIp))
  add(query_580266, "quotaUser", newJString(quotaUser))
  add(path_580265, "project", newJString(project))
  add(query_580266, "clientOperationId", newJString(clientOperationId))
  add(query_580266, "fields", newJString(fields))
  result = call_580264.call(path_580265, query_580266, nil, nil, nil)

var dnsPoliciesDelete* = Call_DnsPoliciesDelete_580250(name: "dnsPoliciesDelete",
    meth: HttpMethod.HttpDelete, host: "dns.googleapis.com",
    route: "/{project}/policies/{policy}", validator: validate_DnsPoliciesDelete_580251,
    base: "/dns/v1/projects", url: url_DnsPoliciesDelete_580252,
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
