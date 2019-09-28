
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Container Engine
## version: v1beta1
## termsOfService: (not provided)
## license: (not provided)
## 
## The Google Container Engine API is used for building and managing container based applications, powered by the open source Kubernetes technology.
## 
## https://cloud.google.com/container-engine/
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

  OpenApiRestCall_579421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579421): Option[Scheme] {.used.} =
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
  gcpServiceName = "container"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ContainerProjectsZonesClustersCreate_579982 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersCreate_579984(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersCreate_579983(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a cluster, consisting of the specified number and type of Google
  ## Compute Engine instances.
  ## 
  ## By default, the cluster is created in the project's
  ## [default network](/compute/docs/networks-and-firewalls#networks).
  ## 
  ## One firewall is added for the cluster. After cluster creation,
  ## the cluster creates routes for each node to allow the containers
  ## on that node to communicate with all other instances in the
  ## cluster.
  ## 
  ## Finally, an entry is added to the project's global metadata indicating
  ## which CIDR range is being used by the cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use parent instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use parent instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_579985 = path.getOrDefault("zone")
  valid_579985 = validateParameter(valid_579985, JString, required = true,
                                 default = nil)
  if valid_579985 != nil:
    section.add "zone", valid_579985
  var valid_579986 = path.getOrDefault("projectId")
  valid_579986 = validateParameter(valid_579986, JString, required = true,
                                 default = nil)
  if valid_579986 != nil:
    section.add "projectId", valid_579986
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_579987 = query.getOrDefault("upload_protocol")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "upload_protocol", valid_579987
  var valid_579988 = query.getOrDefault("fields")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "fields", valid_579988
  var valid_579989 = query.getOrDefault("quotaUser")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "quotaUser", valid_579989
  var valid_579990 = query.getOrDefault("alt")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = newJString("json"))
  if valid_579990 != nil:
    section.add "alt", valid_579990
  var valid_579991 = query.getOrDefault("pp")
  valid_579991 = validateParameter(valid_579991, JBool, required = false,
                                 default = newJBool(true))
  if valid_579991 != nil:
    section.add "pp", valid_579991
  var valid_579992 = query.getOrDefault("oauth_token")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "oauth_token", valid_579992
  var valid_579993 = query.getOrDefault("callback")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "callback", valid_579993
  var valid_579994 = query.getOrDefault("access_token")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "access_token", valid_579994
  var valid_579995 = query.getOrDefault("uploadType")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "uploadType", valid_579995
  var valid_579996 = query.getOrDefault("key")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "key", valid_579996
  var valid_579997 = query.getOrDefault("$.xgafv")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = newJString("1"))
  if valid_579997 != nil:
    section.add "$.xgafv", valid_579997
  var valid_579998 = query.getOrDefault("prettyPrint")
  valid_579998 = validateParameter(valid_579998, JBool, required = false,
                                 default = newJBool(true))
  if valid_579998 != nil:
    section.add "prettyPrint", valid_579998
  var valid_579999 = query.getOrDefault("bearer_token")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "bearer_token", valid_579999
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

proc call*(call_580001: Call_ContainerProjectsZonesClustersCreate_579982;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a cluster, consisting of the specified number and type of Google
  ## Compute Engine instances.
  ## 
  ## By default, the cluster is created in the project's
  ## [default network](/compute/docs/networks-and-firewalls#networks).
  ## 
  ## One firewall is added for the cluster. After cluster creation,
  ## the cluster creates routes for each node to allow the containers
  ## on that node to communicate with all other instances in the
  ## cluster.
  ## 
  ## Finally, an entry is added to the project's global metadata indicating
  ## which CIDR range is being used by the cluster.
  ## 
  let valid = call_580001.validator(path, query, header, formData, body)
  let scheme = call_580001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580001.url(scheme.get, call_580001.host, call_580001.base,
                         call_580001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580001, url, valid)

proc call*(call_580002: Call_ContainerProjectsZonesClustersCreate_579982;
          zone: string; projectId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersCreate
  ## Creates a cluster, consisting of the specified number and type of Google
  ## Compute Engine instances.
  ## 
  ## By default, the cluster is created in the project's
  ## [default network](/compute/docs/networks-and-firewalls#networks).
  ## 
  ## One firewall is added for the cluster. After cluster creation,
  ## the cluster creates routes for each node to allow the containers
  ## on that node to communicate with all other instances in the
  ## cluster.
  ## 
  ## Finally, an entry is added to the project's global metadata indicating
  ## which CIDR range is being used by the cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use parent instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use parent instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580003 = newJObject()
  var query_580004 = newJObject()
  var body_580005 = newJObject()
  add(query_580004, "upload_protocol", newJString(uploadProtocol))
  add(path_580003, "zone", newJString(zone))
  add(query_580004, "fields", newJString(fields))
  add(query_580004, "quotaUser", newJString(quotaUser))
  add(query_580004, "alt", newJString(alt))
  add(query_580004, "pp", newJBool(pp))
  add(query_580004, "oauth_token", newJString(oauthToken))
  add(query_580004, "callback", newJString(callback))
  add(query_580004, "access_token", newJString(accessToken))
  add(query_580004, "uploadType", newJString(uploadType))
  add(query_580004, "key", newJString(key))
  add(path_580003, "projectId", newJString(projectId))
  add(query_580004, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580005 = body
  add(query_580004, "prettyPrint", newJBool(prettyPrint))
  add(query_580004, "bearer_token", newJString(bearerToken))
  result = call_580002.call(path_580003, query_580004, nil, nil, body_580005)

var containerProjectsZonesClustersCreate* = Call_ContainerProjectsZonesClustersCreate_579982(
    name: "containerProjectsZonesClustersCreate", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com",
    route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters",
    validator: validate_ContainerProjectsZonesClustersCreate_579983, base: "/",
    url: url_ContainerProjectsZonesClustersCreate_579984, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersList_579690 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersList_579692(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersList_579691(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all clusters owned by a project in either the specified zone or all
  ## zones.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides, or "-" for all zones.
  ## This field is deprecated, use parent instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use parent instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_579818 = path.getOrDefault("zone")
  valid_579818 = validateParameter(valid_579818, JString, required = true,
                                 default = nil)
  if valid_579818 != nil:
    section.add "zone", valid_579818
  var valid_579819 = path.getOrDefault("projectId")
  valid_579819 = validateParameter(valid_579819, JString, required = true,
                                 default = nil)
  if valid_579819 != nil:
    section.add "projectId", valid_579819
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent (project and location) where the clusters will be listed.
  ## Specified in the format 'projects/*/locations/*'.
  ## Location "-" matches all zones and all regions.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_579820 = query.getOrDefault("upload_protocol")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = nil)
  if valid_579820 != nil:
    section.add "upload_protocol", valid_579820
  var valid_579821 = query.getOrDefault("fields")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "fields", valid_579821
  var valid_579822 = query.getOrDefault("quotaUser")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "quotaUser", valid_579822
  var valid_579836 = query.getOrDefault("alt")
  valid_579836 = validateParameter(valid_579836, JString, required = false,
                                 default = newJString("json"))
  if valid_579836 != nil:
    section.add "alt", valid_579836
  var valid_579837 = query.getOrDefault("pp")
  valid_579837 = validateParameter(valid_579837, JBool, required = false,
                                 default = newJBool(true))
  if valid_579837 != nil:
    section.add "pp", valid_579837
  var valid_579838 = query.getOrDefault("oauth_token")
  valid_579838 = validateParameter(valid_579838, JString, required = false,
                                 default = nil)
  if valid_579838 != nil:
    section.add "oauth_token", valid_579838
  var valid_579839 = query.getOrDefault("callback")
  valid_579839 = validateParameter(valid_579839, JString, required = false,
                                 default = nil)
  if valid_579839 != nil:
    section.add "callback", valid_579839
  var valid_579840 = query.getOrDefault("access_token")
  valid_579840 = validateParameter(valid_579840, JString, required = false,
                                 default = nil)
  if valid_579840 != nil:
    section.add "access_token", valid_579840
  var valid_579841 = query.getOrDefault("uploadType")
  valid_579841 = validateParameter(valid_579841, JString, required = false,
                                 default = nil)
  if valid_579841 != nil:
    section.add "uploadType", valid_579841
  var valid_579842 = query.getOrDefault("parent")
  valid_579842 = validateParameter(valid_579842, JString, required = false,
                                 default = nil)
  if valid_579842 != nil:
    section.add "parent", valid_579842
  var valid_579843 = query.getOrDefault("key")
  valid_579843 = validateParameter(valid_579843, JString, required = false,
                                 default = nil)
  if valid_579843 != nil:
    section.add "key", valid_579843
  var valid_579844 = query.getOrDefault("$.xgafv")
  valid_579844 = validateParameter(valid_579844, JString, required = false,
                                 default = newJString("1"))
  if valid_579844 != nil:
    section.add "$.xgafv", valid_579844
  var valid_579845 = query.getOrDefault("prettyPrint")
  valid_579845 = validateParameter(valid_579845, JBool, required = false,
                                 default = newJBool(true))
  if valid_579845 != nil:
    section.add "prettyPrint", valid_579845
  var valid_579846 = query.getOrDefault("bearer_token")
  valid_579846 = validateParameter(valid_579846, JString, required = false,
                                 default = nil)
  if valid_579846 != nil:
    section.add "bearer_token", valid_579846
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579869: Call_ContainerProjectsZonesClustersList_579690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all clusters owned by a project in either the specified zone or all
  ## zones.
  ## 
  let valid = call_579869.validator(path, query, header, formData, body)
  let scheme = call_579869.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579869.url(scheme.get, call_579869.host, call_579869.base,
                         call_579869.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579869, url, valid)

proc call*(call_579940: Call_ContainerProjectsZonesClustersList_579690;
          zone: string; projectId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; parent: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersList
  ## Lists all clusters owned by a project in either the specified zone or all
  ## zones.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides, or "-" for all zones.
  ## This field is deprecated, use parent instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent (project and location) where the clusters will be listed.
  ## Specified in the format 'projects/*/locations/*'.
  ## Location "-" matches all zones and all regions.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use parent instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_579941 = newJObject()
  var query_579943 = newJObject()
  add(query_579943, "upload_protocol", newJString(uploadProtocol))
  add(path_579941, "zone", newJString(zone))
  add(query_579943, "fields", newJString(fields))
  add(query_579943, "quotaUser", newJString(quotaUser))
  add(query_579943, "alt", newJString(alt))
  add(query_579943, "pp", newJBool(pp))
  add(query_579943, "oauth_token", newJString(oauthToken))
  add(query_579943, "callback", newJString(callback))
  add(query_579943, "access_token", newJString(accessToken))
  add(query_579943, "uploadType", newJString(uploadType))
  add(query_579943, "parent", newJString(parent))
  add(query_579943, "key", newJString(key))
  add(path_579941, "projectId", newJString(projectId))
  add(query_579943, "$.xgafv", newJString(Xgafv))
  add(query_579943, "prettyPrint", newJBool(prettyPrint))
  add(query_579943, "bearer_token", newJString(bearerToken))
  result = call_579940.call(path_579941, query_579943, nil, nil, nil)

var containerProjectsZonesClustersList* = Call_ContainerProjectsZonesClustersList_579690(
    name: "containerProjectsZonesClustersList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters",
    validator: validate_ContainerProjectsZonesClustersList_579691, base: "/",
    url: url_ContainerProjectsZonesClustersList_579692, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersUpdate_580030 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersUpdate_580032(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersUpdate_580031(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the settings of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580033 = path.getOrDefault("zone")
  valid_580033 = validateParameter(valid_580033, JString, required = true,
                                 default = nil)
  if valid_580033 != nil:
    section.add "zone", valid_580033
  var valid_580034 = path.getOrDefault("projectId")
  valid_580034 = validateParameter(valid_580034, JString, required = true,
                                 default = nil)
  if valid_580034 != nil:
    section.add "projectId", valid_580034
  var valid_580035 = path.getOrDefault("clusterId")
  valid_580035 = validateParameter(valid_580035, JString, required = true,
                                 default = nil)
  if valid_580035 != nil:
    section.add "clusterId", valid_580035
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580036 = query.getOrDefault("upload_protocol")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "upload_protocol", valid_580036
  var valid_580037 = query.getOrDefault("fields")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "fields", valid_580037
  var valid_580038 = query.getOrDefault("quotaUser")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "quotaUser", valid_580038
  var valid_580039 = query.getOrDefault("alt")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = newJString("json"))
  if valid_580039 != nil:
    section.add "alt", valid_580039
  var valid_580040 = query.getOrDefault("pp")
  valid_580040 = validateParameter(valid_580040, JBool, required = false,
                                 default = newJBool(true))
  if valid_580040 != nil:
    section.add "pp", valid_580040
  var valid_580041 = query.getOrDefault("oauth_token")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "oauth_token", valid_580041
  var valid_580042 = query.getOrDefault("callback")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "callback", valid_580042
  var valid_580043 = query.getOrDefault("access_token")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "access_token", valid_580043
  var valid_580044 = query.getOrDefault("uploadType")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "uploadType", valid_580044
  var valid_580045 = query.getOrDefault("key")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "key", valid_580045
  var valid_580046 = query.getOrDefault("$.xgafv")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = newJString("1"))
  if valid_580046 != nil:
    section.add "$.xgafv", valid_580046
  var valid_580047 = query.getOrDefault("prettyPrint")
  valid_580047 = validateParameter(valid_580047, JBool, required = false,
                                 default = newJBool(true))
  if valid_580047 != nil:
    section.add "prettyPrint", valid_580047
  var valid_580048 = query.getOrDefault("bearer_token")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "bearer_token", valid_580048
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

proc call*(call_580050: Call_ContainerProjectsZonesClustersUpdate_580030;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the settings of a specific cluster.
  ## 
  let valid = call_580050.validator(path, query, header, formData, body)
  let scheme = call_580050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580050.url(scheme.get, call_580050.host, call_580050.base,
                         call_580050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580050, url, valid)

proc call*(call_580051: Call_ContainerProjectsZonesClustersUpdate_580030;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersUpdate
  ## Updates the settings of a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580052 = newJObject()
  var query_580053 = newJObject()
  var body_580054 = newJObject()
  add(query_580053, "upload_protocol", newJString(uploadProtocol))
  add(path_580052, "zone", newJString(zone))
  add(query_580053, "fields", newJString(fields))
  add(query_580053, "quotaUser", newJString(quotaUser))
  add(query_580053, "alt", newJString(alt))
  add(query_580053, "pp", newJBool(pp))
  add(query_580053, "oauth_token", newJString(oauthToken))
  add(query_580053, "callback", newJString(callback))
  add(query_580053, "access_token", newJString(accessToken))
  add(query_580053, "uploadType", newJString(uploadType))
  add(query_580053, "key", newJString(key))
  add(path_580052, "projectId", newJString(projectId))
  add(query_580053, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580054 = body
  add(query_580053, "prettyPrint", newJBool(prettyPrint))
  add(path_580052, "clusterId", newJString(clusterId))
  add(query_580053, "bearer_token", newJString(bearerToken))
  result = call_580051.call(path_580052, query_580053, nil, nil, body_580054)

var containerProjectsZonesClustersUpdate* = Call_ContainerProjectsZonesClustersUpdate_580030(
    name: "containerProjectsZonesClustersUpdate", meth: HttpMethod.HttpPut,
    host: "container.googleapis.com",
    route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}",
    validator: validate_ContainerProjectsZonesClustersUpdate_580031, base: "/",
    url: url_ContainerProjectsZonesClustersUpdate_580032, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersGet_580006 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersGet_580008(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersGet_580007(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to retrieve.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580009 = path.getOrDefault("zone")
  valid_580009 = validateParameter(valid_580009, JString, required = true,
                                 default = nil)
  if valid_580009 != nil:
    section.add "zone", valid_580009
  var valid_580010 = path.getOrDefault("projectId")
  valid_580010 = validateParameter(valid_580010, JString, required = true,
                                 default = nil)
  if valid_580010 != nil:
    section.add "projectId", valid_580010
  var valid_580011 = path.getOrDefault("clusterId")
  valid_580011 = validateParameter(valid_580011, JString, required = true,
                                 default = nil)
  if valid_580011 != nil:
    section.add "clusterId", valid_580011
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: JString
  ##       : The name (project, location, cluster) of the cluster to retrieve.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580012 = query.getOrDefault("upload_protocol")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "upload_protocol", valid_580012
  var valid_580013 = query.getOrDefault("fields")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "fields", valid_580013
  var valid_580014 = query.getOrDefault("quotaUser")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "quotaUser", valid_580014
  var valid_580015 = query.getOrDefault("alt")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = newJString("json"))
  if valid_580015 != nil:
    section.add "alt", valid_580015
  var valid_580016 = query.getOrDefault("pp")
  valid_580016 = validateParameter(valid_580016, JBool, required = false,
                                 default = newJBool(true))
  if valid_580016 != nil:
    section.add "pp", valid_580016
  var valid_580017 = query.getOrDefault("oauth_token")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "oauth_token", valid_580017
  var valid_580018 = query.getOrDefault("callback")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "callback", valid_580018
  var valid_580019 = query.getOrDefault("access_token")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "access_token", valid_580019
  var valid_580020 = query.getOrDefault("uploadType")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "uploadType", valid_580020
  var valid_580021 = query.getOrDefault("key")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "key", valid_580021
  var valid_580022 = query.getOrDefault("name")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "name", valid_580022
  var valid_580023 = query.getOrDefault("$.xgafv")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = newJString("1"))
  if valid_580023 != nil:
    section.add "$.xgafv", valid_580023
  var valid_580024 = query.getOrDefault("prettyPrint")
  valid_580024 = validateParameter(valid_580024, JBool, required = false,
                                 default = newJBool(true))
  if valid_580024 != nil:
    section.add "prettyPrint", valid_580024
  var valid_580025 = query.getOrDefault("bearer_token")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "bearer_token", valid_580025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580026: Call_ContainerProjectsZonesClustersGet_580006;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of a specific cluster.
  ## 
  let valid = call_580026.validator(path, query, header, formData, body)
  let scheme = call_580026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580026.url(scheme.get, call_580026.host, call_580026.base,
                         call_580026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580026, url, valid)

proc call*(call_580027: Call_ContainerProjectsZonesClustersGet_580006;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; name: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersGet
  ## Gets the details of a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : The name (project, location, cluster) of the cluster to retrieve.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster to retrieve.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580028 = newJObject()
  var query_580029 = newJObject()
  add(query_580029, "upload_protocol", newJString(uploadProtocol))
  add(path_580028, "zone", newJString(zone))
  add(query_580029, "fields", newJString(fields))
  add(query_580029, "quotaUser", newJString(quotaUser))
  add(query_580029, "alt", newJString(alt))
  add(query_580029, "pp", newJBool(pp))
  add(query_580029, "oauth_token", newJString(oauthToken))
  add(query_580029, "callback", newJString(callback))
  add(query_580029, "access_token", newJString(accessToken))
  add(query_580029, "uploadType", newJString(uploadType))
  add(query_580029, "key", newJString(key))
  add(query_580029, "name", newJString(name))
  add(path_580028, "projectId", newJString(projectId))
  add(query_580029, "$.xgafv", newJString(Xgafv))
  add(query_580029, "prettyPrint", newJBool(prettyPrint))
  add(path_580028, "clusterId", newJString(clusterId))
  add(query_580029, "bearer_token", newJString(bearerToken))
  result = call_580027.call(path_580028, query_580029, nil, nil, nil)

var containerProjectsZonesClustersGet* = Call_ContainerProjectsZonesClustersGet_580006(
    name: "containerProjectsZonesClustersGet", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}",
    validator: validate_ContainerProjectsZonesClustersGet_580007, base: "/",
    url: url_ContainerProjectsZonesClustersGet_580008, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersDelete_580055 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersDelete_580057(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersDelete_580056(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the cluster, including the Kubernetes endpoint and all worker
  ## nodes.
  ## 
  ## Firewalls and routes that were configured during cluster creation
  ## are also deleted.
  ## 
  ## Other Google Compute Engine resources that might be in use by the cluster
  ## (e.g. load balancer resources) will not be deleted if they weren't present
  ## at the initial create time.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to delete.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580058 = path.getOrDefault("zone")
  valid_580058 = validateParameter(valid_580058, JString, required = true,
                                 default = nil)
  if valid_580058 != nil:
    section.add "zone", valid_580058
  var valid_580059 = path.getOrDefault("projectId")
  valid_580059 = validateParameter(valid_580059, JString, required = true,
                                 default = nil)
  if valid_580059 != nil:
    section.add "projectId", valid_580059
  var valid_580060 = path.getOrDefault("clusterId")
  valid_580060 = validateParameter(valid_580060, JString, required = true,
                                 default = nil)
  if valid_580060 != nil:
    section.add "clusterId", valid_580060
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: JString
  ##       : The name (project, location, cluster) of the cluster to delete.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580061 = query.getOrDefault("upload_protocol")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "upload_protocol", valid_580061
  var valid_580062 = query.getOrDefault("fields")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "fields", valid_580062
  var valid_580063 = query.getOrDefault("quotaUser")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "quotaUser", valid_580063
  var valid_580064 = query.getOrDefault("alt")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = newJString("json"))
  if valid_580064 != nil:
    section.add "alt", valid_580064
  var valid_580065 = query.getOrDefault("pp")
  valid_580065 = validateParameter(valid_580065, JBool, required = false,
                                 default = newJBool(true))
  if valid_580065 != nil:
    section.add "pp", valid_580065
  var valid_580066 = query.getOrDefault("oauth_token")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "oauth_token", valid_580066
  var valid_580067 = query.getOrDefault("callback")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "callback", valid_580067
  var valid_580068 = query.getOrDefault("access_token")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "access_token", valid_580068
  var valid_580069 = query.getOrDefault("uploadType")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "uploadType", valid_580069
  var valid_580070 = query.getOrDefault("key")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "key", valid_580070
  var valid_580071 = query.getOrDefault("name")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "name", valid_580071
  var valid_580072 = query.getOrDefault("$.xgafv")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = newJString("1"))
  if valid_580072 != nil:
    section.add "$.xgafv", valid_580072
  var valid_580073 = query.getOrDefault("prettyPrint")
  valid_580073 = validateParameter(valid_580073, JBool, required = false,
                                 default = newJBool(true))
  if valid_580073 != nil:
    section.add "prettyPrint", valid_580073
  var valid_580074 = query.getOrDefault("bearer_token")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "bearer_token", valid_580074
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580075: Call_ContainerProjectsZonesClustersDelete_580055;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the cluster, including the Kubernetes endpoint and all worker
  ## nodes.
  ## 
  ## Firewalls and routes that were configured during cluster creation
  ## are also deleted.
  ## 
  ## Other Google Compute Engine resources that might be in use by the cluster
  ## (e.g. load balancer resources) will not be deleted if they weren't present
  ## at the initial create time.
  ## 
  let valid = call_580075.validator(path, query, header, formData, body)
  let scheme = call_580075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580075.url(scheme.get, call_580075.host, call_580075.base,
                         call_580075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580075, url, valid)

proc call*(call_580076: Call_ContainerProjectsZonesClustersDelete_580055;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; name: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersDelete
  ## Deletes the cluster, including the Kubernetes endpoint and all worker
  ## nodes.
  ## 
  ## Firewalls and routes that were configured during cluster creation
  ## are also deleted.
  ## 
  ## Other Google Compute Engine resources that might be in use by the cluster
  ## (e.g. load balancer resources) will not be deleted if they weren't present
  ## at the initial create time.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : The name (project, location, cluster) of the cluster to delete.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster to delete.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580077 = newJObject()
  var query_580078 = newJObject()
  add(query_580078, "upload_protocol", newJString(uploadProtocol))
  add(path_580077, "zone", newJString(zone))
  add(query_580078, "fields", newJString(fields))
  add(query_580078, "quotaUser", newJString(quotaUser))
  add(query_580078, "alt", newJString(alt))
  add(query_580078, "pp", newJBool(pp))
  add(query_580078, "oauth_token", newJString(oauthToken))
  add(query_580078, "callback", newJString(callback))
  add(query_580078, "access_token", newJString(accessToken))
  add(query_580078, "uploadType", newJString(uploadType))
  add(query_580078, "key", newJString(key))
  add(query_580078, "name", newJString(name))
  add(path_580077, "projectId", newJString(projectId))
  add(query_580078, "$.xgafv", newJString(Xgafv))
  add(query_580078, "prettyPrint", newJBool(prettyPrint))
  add(path_580077, "clusterId", newJString(clusterId))
  add(query_580078, "bearer_token", newJString(bearerToken))
  result = call_580076.call(path_580077, query_580078, nil, nil, nil)

var containerProjectsZonesClustersDelete* = Call_ContainerProjectsZonesClustersDelete_580055(
    name: "containerProjectsZonesClustersDelete", meth: HttpMethod.HttpDelete,
    host: "container.googleapis.com",
    route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}",
    validator: validate_ContainerProjectsZonesClustersDelete_580056, base: "/",
    url: url_ContainerProjectsZonesClustersDelete_580057, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersAddons_580079 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersAddons_580081(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: "/addons")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersAddons_580080(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the addons of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580082 = path.getOrDefault("zone")
  valid_580082 = validateParameter(valid_580082, JString, required = true,
                                 default = nil)
  if valid_580082 != nil:
    section.add "zone", valid_580082
  var valid_580083 = path.getOrDefault("projectId")
  valid_580083 = validateParameter(valid_580083, JString, required = true,
                                 default = nil)
  if valid_580083 != nil:
    section.add "projectId", valid_580083
  var valid_580084 = path.getOrDefault("clusterId")
  valid_580084 = validateParameter(valid_580084, JString, required = true,
                                 default = nil)
  if valid_580084 != nil:
    section.add "clusterId", valid_580084
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580085 = query.getOrDefault("upload_protocol")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "upload_protocol", valid_580085
  var valid_580086 = query.getOrDefault("fields")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "fields", valid_580086
  var valid_580087 = query.getOrDefault("quotaUser")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "quotaUser", valid_580087
  var valid_580088 = query.getOrDefault("alt")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = newJString("json"))
  if valid_580088 != nil:
    section.add "alt", valid_580088
  var valid_580089 = query.getOrDefault("pp")
  valid_580089 = validateParameter(valid_580089, JBool, required = false,
                                 default = newJBool(true))
  if valid_580089 != nil:
    section.add "pp", valid_580089
  var valid_580090 = query.getOrDefault("oauth_token")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "oauth_token", valid_580090
  var valid_580091 = query.getOrDefault("callback")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "callback", valid_580091
  var valid_580092 = query.getOrDefault("access_token")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "access_token", valid_580092
  var valid_580093 = query.getOrDefault("uploadType")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "uploadType", valid_580093
  var valid_580094 = query.getOrDefault("key")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "key", valid_580094
  var valid_580095 = query.getOrDefault("$.xgafv")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = newJString("1"))
  if valid_580095 != nil:
    section.add "$.xgafv", valid_580095
  var valid_580096 = query.getOrDefault("prettyPrint")
  valid_580096 = validateParameter(valid_580096, JBool, required = false,
                                 default = newJBool(true))
  if valid_580096 != nil:
    section.add "prettyPrint", valid_580096
  var valid_580097 = query.getOrDefault("bearer_token")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "bearer_token", valid_580097
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

proc call*(call_580099: Call_ContainerProjectsZonesClustersAddons_580079;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the addons of a specific cluster.
  ## 
  let valid = call_580099.validator(path, query, header, formData, body)
  let scheme = call_580099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580099.url(scheme.get, call_580099.host, call_580099.base,
                         call_580099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580099, url, valid)

proc call*(call_580100: Call_ContainerProjectsZonesClustersAddons_580079;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersAddons
  ## Sets the addons of a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580101 = newJObject()
  var query_580102 = newJObject()
  var body_580103 = newJObject()
  add(query_580102, "upload_protocol", newJString(uploadProtocol))
  add(path_580101, "zone", newJString(zone))
  add(query_580102, "fields", newJString(fields))
  add(query_580102, "quotaUser", newJString(quotaUser))
  add(query_580102, "alt", newJString(alt))
  add(query_580102, "pp", newJBool(pp))
  add(query_580102, "oauth_token", newJString(oauthToken))
  add(query_580102, "callback", newJString(callback))
  add(query_580102, "access_token", newJString(accessToken))
  add(query_580102, "uploadType", newJString(uploadType))
  add(query_580102, "key", newJString(key))
  add(path_580101, "projectId", newJString(projectId))
  add(query_580102, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580103 = body
  add(query_580102, "prettyPrint", newJBool(prettyPrint))
  add(path_580101, "clusterId", newJString(clusterId))
  add(query_580102, "bearer_token", newJString(bearerToken))
  result = call_580100.call(path_580101, query_580102, nil, nil, body_580103)

var containerProjectsZonesClustersAddons* = Call_ContainerProjectsZonesClustersAddons_580079(
    name: "containerProjectsZonesClustersAddons", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/addons",
    validator: validate_ContainerProjectsZonesClustersAddons_580080, base: "/",
    url: url_ContainerProjectsZonesClustersAddons_580081, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersLegacyAbac_580104 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersLegacyAbac_580106(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: "/legacyAbac")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersLegacyAbac_580105(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to update.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580107 = path.getOrDefault("zone")
  valid_580107 = validateParameter(valid_580107, JString, required = true,
                                 default = nil)
  if valid_580107 != nil:
    section.add "zone", valid_580107
  var valid_580108 = path.getOrDefault("projectId")
  valid_580108 = validateParameter(valid_580108, JString, required = true,
                                 default = nil)
  if valid_580108 != nil:
    section.add "projectId", valid_580108
  var valid_580109 = path.getOrDefault("clusterId")
  valid_580109 = validateParameter(valid_580109, JString, required = true,
                                 default = nil)
  if valid_580109 != nil:
    section.add "clusterId", valid_580109
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580110 = query.getOrDefault("upload_protocol")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "upload_protocol", valid_580110
  var valid_580111 = query.getOrDefault("fields")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "fields", valid_580111
  var valid_580112 = query.getOrDefault("quotaUser")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "quotaUser", valid_580112
  var valid_580113 = query.getOrDefault("alt")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = newJString("json"))
  if valid_580113 != nil:
    section.add "alt", valid_580113
  var valid_580114 = query.getOrDefault("pp")
  valid_580114 = validateParameter(valid_580114, JBool, required = false,
                                 default = newJBool(true))
  if valid_580114 != nil:
    section.add "pp", valid_580114
  var valid_580115 = query.getOrDefault("oauth_token")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "oauth_token", valid_580115
  var valid_580116 = query.getOrDefault("callback")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "callback", valid_580116
  var valid_580117 = query.getOrDefault("access_token")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "access_token", valid_580117
  var valid_580118 = query.getOrDefault("uploadType")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "uploadType", valid_580118
  var valid_580119 = query.getOrDefault("key")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "key", valid_580119
  var valid_580120 = query.getOrDefault("$.xgafv")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = newJString("1"))
  if valid_580120 != nil:
    section.add "$.xgafv", valid_580120
  var valid_580121 = query.getOrDefault("prettyPrint")
  valid_580121 = validateParameter(valid_580121, JBool, required = false,
                                 default = newJBool(true))
  if valid_580121 != nil:
    section.add "prettyPrint", valid_580121
  var valid_580122 = query.getOrDefault("bearer_token")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "bearer_token", valid_580122
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

proc call*(call_580124: Call_ContainerProjectsZonesClustersLegacyAbac_580104;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ## 
  let valid = call_580124.validator(path, query, header, formData, body)
  let scheme = call_580124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580124.url(scheme.get, call_580124.host, call_580124.base,
                         call_580124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580124, url, valid)

proc call*(call_580125: Call_ContainerProjectsZonesClustersLegacyAbac_580104;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersLegacyAbac
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster to update.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580126 = newJObject()
  var query_580127 = newJObject()
  var body_580128 = newJObject()
  add(query_580127, "upload_protocol", newJString(uploadProtocol))
  add(path_580126, "zone", newJString(zone))
  add(query_580127, "fields", newJString(fields))
  add(query_580127, "quotaUser", newJString(quotaUser))
  add(query_580127, "alt", newJString(alt))
  add(query_580127, "pp", newJBool(pp))
  add(query_580127, "oauth_token", newJString(oauthToken))
  add(query_580127, "callback", newJString(callback))
  add(query_580127, "access_token", newJString(accessToken))
  add(query_580127, "uploadType", newJString(uploadType))
  add(query_580127, "key", newJString(key))
  add(path_580126, "projectId", newJString(projectId))
  add(query_580127, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580128 = body
  add(query_580127, "prettyPrint", newJBool(prettyPrint))
  add(path_580126, "clusterId", newJString(clusterId))
  add(query_580127, "bearer_token", newJString(bearerToken))
  result = call_580125.call(path_580126, query_580127, nil, nil, body_580128)

var containerProjectsZonesClustersLegacyAbac* = Call_ContainerProjectsZonesClustersLegacyAbac_580104(
    name: "containerProjectsZonesClustersLegacyAbac", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/legacyAbac",
    validator: validate_ContainerProjectsZonesClustersLegacyAbac_580105,
    base: "/", url: url_ContainerProjectsZonesClustersLegacyAbac_580106,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersLocations_580129 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersLocations_580131(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: "/locations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersLocations_580130(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the locations of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580132 = path.getOrDefault("zone")
  valid_580132 = validateParameter(valid_580132, JString, required = true,
                                 default = nil)
  if valid_580132 != nil:
    section.add "zone", valid_580132
  var valid_580133 = path.getOrDefault("projectId")
  valid_580133 = validateParameter(valid_580133, JString, required = true,
                                 default = nil)
  if valid_580133 != nil:
    section.add "projectId", valid_580133
  var valid_580134 = path.getOrDefault("clusterId")
  valid_580134 = validateParameter(valid_580134, JString, required = true,
                                 default = nil)
  if valid_580134 != nil:
    section.add "clusterId", valid_580134
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580135 = query.getOrDefault("upload_protocol")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "upload_protocol", valid_580135
  var valid_580136 = query.getOrDefault("fields")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "fields", valid_580136
  var valid_580137 = query.getOrDefault("quotaUser")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "quotaUser", valid_580137
  var valid_580138 = query.getOrDefault("alt")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = newJString("json"))
  if valid_580138 != nil:
    section.add "alt", valid_580138
  var valid_580139 = query.getOrDefault("pp")
  valid_580139 = validateParameter(valid_580139, JBool, required = false,
                                 default = newJBool(true))
  if valid_580139 != nil:
    section.add "pp", valid_580139
  var valid_580140 = query.getOrDefault("oauth_token")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "oauth_token", valid_580140
  var valid_580141 = query.getOrDefault("callback")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "callback", valid_580141
  var valid_580142 = query.getOrDefault("access_token")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "access_token", valid_580142
  var valid_580143 = query.getOrDefault("uploadType")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "uploadType", valid_580143
  var valid_580144 = query.getOrDefault("key")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "key", valid_580144
  var valid_580145 = query.getOrDefault("$.xgafv")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = newJString("1"))
  if valid_580145 != nil:
    section.add "$.xgafv", valid_580145
  var valid_580146 = query.getOrDefault("prettyPrint")
  valid_580146 = validateParameter(valid_580146, JBool, required = false,
                                 default = newJBool(true))
  if valid_580146 != nil:
    section.add "prettyPrint", valid_580146
  var valid_580147 = query.getOrDefault("bearer_token")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "bearer_token", valid_580147
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

proc call*(call_580149: Call_ContainerProjectsZonesClustersLocations_580129;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the locations of a specific cluster.
  ## 
  let valid = call_580149.validator(path, query, header, formData, body)
  let scheme = call_580149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580149.url(scheme.get, call_580149.host, call_580149.base,
                         call_580149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580149, url, valid)

proc call*(call_580150: Call_ContainerProjectsZonesClustersLocations_580129;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersLocations
  ## Sets the locations of a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580151 = newJObject()
  var query_580152 = newJObject()
  var body_580153 = newJObject()
  add(query_580152, "upload_protocol", newJString(uploadProtocol))
  add(path_580151, "zone", newJString(zone))
  add(query_580152, "fields", newJString(fields))
  add(query_580152, "quotaUser", newJString(quotaUser))
  add(query_580152, "alt", newJString(alt))
  add(query_580152, "pp", newJBool(pp))
  add(query_580152, "oauth_token", newJString(oauthToken))
  add(query_580152, "callback", newJString(callback))
  add(query_580152, "access_token", newJString(accessToken))
  add(query_580152, "uploadType", newJString(uploadType))
  add(query_580152, "key", newJString(key))
  add(path_580151, "projectId", newJString(projectId))
  add(query_580152, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580153 = body
  add(query_580152, "prettyPrint", newJBool(prettyPrint))
  add(path_580151, "clusterId", newJString(clusterId))
  add(query_580152, "bearer_token", newJString(bearerToken))
  result = call_580150.call(path_580151, query_580152, nil, nil, body_580153)

var containerProjectsZonesClustersLocations* = Call_ContainerProjectsZonesClustersLocations_580129(
    name: "containerProjectsZonesClustersLocations", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/locations",
    validator: validate_ContainerProjectsZonesClustersLocations_580130, base: "/",
    url: url_ContainerProjectsZonesClustersLocations_580131,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersLogging_580154 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersLogging_580156(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: "/logging")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersLogging_580155(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the logging service of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580157 = path.getOrDefault("zone")
  valid_580157 = validateParameter(valid_580157, JString, required = true,
                                 default = nil)
  if valid_580157 != nil:
    section.add "zone", valid_580157
  var valid_580158 = path.getOrDefault("projectId")
  valid_580158 = validateParameter(valid_580158, JString, required = true,
                                 default = nil)
  if valid_580158 != nil:
    section.add "projectId", valid_580158
  var valid_580159 = path.getOrDefault("clusterId")
  valid_580159 = validateParameter(valid_580159, JString, required = true,
                                 default = nil)
  if valid_580159 != nil:
    section.add "clusterId", valid_580159
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580160 = query.getOrDefault("upload_protocol")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "upload_protocol", valid_580160
  var valid_580161 = query.getOrDefault("fields")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "fields", valid_580161
  var valid_580162 = query.getOrDefault("quotaUser")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "quotaUser", valid_580162
  var valid_580163 = query.getOrDefault("alt")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = newJString("json"))
  if valid_580163 != nil:
    section.add "alt", valid_580163
  var valid_580164 = query.getOrDefault("pp")
  valid_580164 = validateParameter(valid_580164, JBool, required = false,
                                 default = newJBool(true))
  if valid_580164 != nil:
    section.add "pp", valid_580164
  var valid_580165 = query.getOrDefault("oauth_token")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "oauth_token", valid_580165
  var valid_580166 = query.getOrDefault("callback")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "callback", valid_580166
  var valid_580167 = query.getOrDefault("access_token")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "access_token", valid_580167
  var valid_580168 = query.getOrDefault("uploadType")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "uploadType", valid_580168
  var valid_580169 = query.getOrDefault("key")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "key", valid_580169
  var valid_580170 = query.getOrDefault("$.xgafv")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = newJString("1"))
  if valid_580170 != nil:
    section.add "$.xgafv", valid_580170
  var valid_580171 = query.getOrDefault("prettyPrint")
  valid_580171 = validateParameter(valid_580171, JBool, required = false,
                                 default = newJBool(true))
  if valid_580171 != nil:
    section.add "prettyPrint", valid_580171
  var valid_580172 = query.getOrDefault("bearer_token")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "bearer_token", valid_580172
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

proc call*(call_580174: Call_ContainerProjectsZonesClustersLogging_580154;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the logging service of a specific cluster.
  ## 
  let valid = call_580174.validator(path, query, header, formData, body)
  let scheme = call_580174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580174.url(scheme.get, call_580174.host, call_580174.base,
                         call_580174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580174, url, valid)

proc call*(call_580175: Call_ContainerProjectsZonesClustersLogging_580154;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersLogging
  ## Sets the logging service of a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580176 = newJObject()
  var query_580177 = newJObject()
  var body_580178 = newJObject()
  add(query_580177, "upload_protocol", newJString(uploadProtocol))
  add(path_580176, "zone", newJString(zone))
  add(query_580177, "fields", newJString(fields))
  add(query_580177, "quotaUser", newJString(quotaUser))
  add(query_580177, "alt", newJString(alt))
  add(query_580177, "pp", newJBool(pp))
  add(query_580177, "oauth_token", newJString(oauthToken))
  add(query_580177, "callback", newJString(callback))
  add(query_580177, "access_token", newJString(accessToken))
  add(query_580177, "uploadType", newJString(uploadType))
  add(query_580177, "key", newJString(key))
  add(path_580176, "projectId", newJString(projectId))
  add(query_580177, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580178 = body
  add(query_580177, "prettyPrint", newJBool(prettyPrint))
  add(path_580176, "clusterId", newJString(clusterId))
  add(query_580177, "bearer_token", newJString(bearerToken))
  result = call_580175.call(path_580176, query_580177, nil, nil, body_580178)

var containerProjectsZonesClustersLogging* = Call_ContainerProjectsZonesClustersLogging_580154(
    name: "containerProjectsZonesClustersLogging", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/logging",
    validator: validate_ContainerProjectsZonesClustersLogging_580155, base: "/",
    url: url_ContainerProjectsZonesClustersLogging_580156, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersMaster_580179 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersMaster_580181(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: "/master")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersMaster_580180(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the master of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ##   clusterId: JString (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580182 = path.getOrDefault("zone")
  valid_580182 = validateParameter(valid_580182, JString, required = true,
                                 default = nil)
  if valid_580182 != nil:
    section.add "zone", valid_580182
  var valid_580183 = path.getOrDefault("projectId")
  valid_580183 = validateParameter(valid_580183, JString, required = true,
                                 default = nil)
  if valid_580183 != nil:
    section.add "projectId", valid_580183
  var valid_580184 = path.getOrDefault("clusterId")
  valid_580184 = validateParameter(valid_580184, JString, required = true,
                                 default = nil)
  if valid_580184 != nil:
    section.add "clusterId", valid_580184
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580185 = query.getOrDefault("upload_protocol")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "upload_protocol", valid_580185
  var valid_580186 = query.getOrDefault("fields")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "fields", valid_580186
  var valid_580187 = query.getOrDefault("quotaUser")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "quotaUser", valid_580187
  var valid_580188 = query.getOrDefault("alt")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = newJString("json"))
  if valid_580188 != nil:
    section.add "alt", valid_580188
  var valid_580189 = query.getOrDefault("pp")
  valid_580189 = validateParameter(valid_580189, JBool, required = false,
                                 default = newJBool(true))
  if valid_580189 != nil:
    section.add "pp", valid_580189
  var valid_580190 = query.getOrDefault("oauth_token")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "oauth_token", valid_580190
  var valid_580191 = query.getOrDefault("callback")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "callback", valid_580191
  var valid_580192 = query.getOrDefault("access_token")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "access_token", valid_580192
  var valid_580193 = query.getOrDefault("uploadType")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "uploadType", valid_580193
  var valid_580194 = query.getOrDefault("key")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "key", valid_580194
  var valid_580195 = query.getOrDefault("$.xgafv")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = newJString("1"))
  if valid_580195 != nil:
    section.add "$.xgafv", valid_580195
  var valid_580196 = query.getOrDefault("prettyPrint")
  valid_580196 = validateParameter(valid_580196, JBool, required = false,
                                 default = newJBool(true))
  if valid_580196 != nil:
    section.add "prettyPrint", valid_580196
  var valid_580197 = query.getOrDefault("bearer_token")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "bearer_token", valid_580197
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

proc call*(call_580199: Call_ContainerProjectsZonesClustersMaster_580179;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the master of a specific cluster.
  ## 
  let valid = call_580199.validator(path, query, header, formData, body)
  let scheme = call_580199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580199.url(scheme.get, call_580199.host, call_580199.base,
                         call_580199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580199, url, valid)

proc call*(call_580200: Call_ContainerProjectsZonesClustersMaster_580179;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersMaster
  ## Updates the master of a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580201 = newJObject()
  var query_580202 = newJObject()
  var body_580203 = newJObject()
  add(query_580202, "upload_protocol", newJString(uploadProtocol))
  add(path_580201, "zone", newJString(zone))
  add(query_580202, "fields", newJString(fields))
  add(query_580202, "quotaUser", newJString(quotaUser))
  add(query_580202, "alt", newJString(alt))
  add(query_580202, "pp", newJBool(pp))
  add(query_580202, "oauth_token", newJString(oauthToken))
  add(query_580202, "callback", newJString(callback))
  add(query_580202, "access_token", newJString(accessToken))
  add(query_580202, "uploadType", newJString(uploadType))
  add(query_580202, "key", newJString(key))
  add(path_580201, "projectId", newJString(projectId))
  add(query_580202, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580203 = body
  add(query_580202, "prettyPrint", newJBool(prettyPrint))
  add(path_580201, "clusterId", newJString(clusterId))
  add(query_580202, "bearer_token", newJString(bearerToken))
  result = call_580200.call(path_580201, query_580202, nil, nil, body_580203)

var containerProjectsZonesClustersMaster* = Call_ContainerProjectsZonesClustersMaster_580179(
    name: "containerProjectsZonesClustersMaster", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/master",
    validator: validate_ContainerProjectsZonesClustersMaster_580180, base: "/",
    url: url_ContainerProjectsZonesClustersMaster_580181, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersMonitoring_580204 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersMonitoring_580206(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: "/monitoring")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersMonitoring_580205(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the monitoring service of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580207 = path.getOrDefault("zone")
  valid_580207 = validateParameter(valid_580207, JString, required = true,
                                 default = nil)
  if valid_580207 != nil:
    section.add "zone", valid_580207
  var valid_580208 = path.getOrDefault("projectId")
  valid_580208 = validateParameter(valid_580208, JString, required = true,
                                 default = nil)
  if valid_580208 != nil:
    section.add "projectId", valid_580208
  var valid_580209 = path.getOrDefault("clusterId")
  valid_580209 = validateParameter(valid_580209, JString, required = true,
                                 default = nil)
  if valid_580209 != nil:
    section.add "clusterId", valid_580209
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580210 = query.getOrDefault("upload_protocol")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "upload_protocol", valid_580210
  var valid_580211 = query.getOrDefault("fields")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "fields", valid_580211
  var valid_580212 = query.getOrDefault("quotaUser")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "quotaUser", valid_580212
  var valid_580213 = query.getOrDefault("alt")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = newJString("json"))
  if valid_580213 != nil:
    section.add "alt", valid_580213
  var valid_580214 = query.getOrDefault("pp")
  valid_580214 = validateParameter(valid_580214, JBool, required = false,
                                 default = newJBool(true))
  if valid_580214 != nil:
    section.add "pp", valid_580214
  var valid_580215 = query.getOrDefault("oauth_token")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "oauth_token", valid_580215
  var valid_580216 = query.getOrDefault("callback")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "callback", valid_580216
  var valid_580217 = query.getOrDefault("access_token")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "access_token", valid_580217
  var valid_580218 = query.getOrDefault("uploadType")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = nil)
  if valid_580218 != nil:
    section.add "uploadType", valid_580218
  var valid_580219 = query.getOrDefault("key")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "key", valid_580219
  var valid_580220 = query.getOrDefault("$.xgafv")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = newJString("1"))
  if valid_580220 != nil:
    section.add "$.xgafv", valid_580220
  var valid_580221 = query.getOrDefault("prettyPrint")
  valid_580221 = validateParameter(valid_580221, JBool, required = false,
                                 default = newJBool(true))
  if valid_580221 != nil:
    section.add "prettyPrint", valid_580221
  var valid_580222 = query.getOrDefault("bearer_token")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "bearer_token", valid_580222
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

proc call*(call_580224: Call_ContainerProjectsZonesClustersMonitoring_580204;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the monitoring service of a specific cluster.
  ## 
  let valid = call_580224.validator(path, query, header, formData, body)
  let scheme = call_580224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580224.url(scheme.get, call_580224.host, call_580224.base,
                         call_580224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580224, url, valid)

proc call*(call_580225: Call_ContainerProjectsZonesClustersMonitoring_580204;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersMonitoring
  ## Sets the monitoring service of a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580226 = newJObject()
  var query_580227 = newJObject()
  var body_580228 = newJObject()
  add(query_580227, "upload_protocol", newJString(uploadProtocol))
  add(path_580226, "zone", newJString(zone))
  add(query_580227, "fields", newJString(fields))
  add(query_580227, "quotaUser", newJString(quotaUser))
  add(query_580227, "alt", newJString(alt))
  add(query_580227, "pp", newJBool(pp))
  add(query_580227, "oauth_token", newJString(oauthToken))
  add(query_580227, "callback", newJString(callback))
  add(query_580227, "access_token", newJString(accessToken))
  add(query_580227, "uploadType", newJString(uploadType))
  add(query_580227, "key", newJString(key))
  add(path_580226, "projectId", newJString(projectId))
  add(query_580227, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580228 = body
  add(query_580227, "prettyPrint", newJBool(prettyPrint))
  add(path_580226, "clusterId", newJString(clusterId))
  add(query_580227, "bearer_token", newJString(bearerToken))
  result = call_580225.call(path_580226, query_580227, nil, nil, body_580228)

var containerProjectsZonesClustersMonitoring* = Call_ContainerProjectsZonesClustersMonitoring_580204(
    name: "containerProjectsZonesClustersMonitoring", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/monitoring",
    validator: validate_ContainerProjectsZonesClustersMonitoring_580205,
    base: "/", url: url_ContainerProjectsZonesClustersMonitoring_580206,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsCreate_580253 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersNodePoolsCreate_580255(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: "/nodePools")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersNodePoolsCreate_580254(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a node pool for a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use parent instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use parent instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use parent instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580256 = path.getOrDefault("zone")
  valid_580256 = validateParameter(valid_580256, JString, required = true,
                                 default = nil)
  if valid_580256 != nil:
    section.add "zone", valid_580256
  var valid_580257 = path.getOrDefault("projectId")
  valid_580257 = validateParameter(valid_580257, JString, required = true,
                                 default = nil)
  if valid_580257 != nil:
    section.add "projectId", valid_580257
  var valid_580258 = path.getOrDefault("clusterId")
  valid_580258 = validateParameter(valid_580258, JString, required = true,
                                 default = nil)
  if valid_580258 != nil:
    section.add "clusterId", valid_580258
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580259 = query.getOrDefault("upload_protocol")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "upload_protocol", valid_580259
  var valid_580260 = query.getOrDefault("fields")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "fields", valid_580260
  var valid_580261 = query.getOrDefault("quotaUser")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "quotaUser", valid_580261
  var valid_580262 = query.getOrDefault("alt")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = newJString("json"))
  if valid_580262 != nil:
    section.add "alt", valid_580262
  var valid_580263 = query.getOrDefault("pp")
  valid_580263 = validateParameter(valid_580263, JBool, required = false,
                                 default = newJBool(true))
  if valid_580263 != nil:
    section.add "pp", valid_580263
  var valid_580264 = query.getOrDefault("oauth_token")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = nil)
  if valid_580264 != nil:
    section.add "oauth_token", valid_580264
  var valid_580265 = query.getOrDefault("callback")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "callback", valid_580265
  var valid_580266 = query.getOrDefault("access_token")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "access_token", valid_580266
  var valid_580267 = query.getOrDefault("uploadType")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "uploadType", valid_580267
  var valid_580268 = query.getOrDefault("key")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = nil)
  if valid_580268 != nil:
    section.add "key", valid_580268
  var valid_580269 = query.getOrDefault("$.xgafv")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = newJString("1"))
  if valid_580269 != nil:
    section.add "$.xgafv", valid_580269
  var valid_580270 = query.getOrDefault("prettyPrint")
  valid_580270 = validateParameter(valid_580270, JBool, required = false,
                                 default = newJBool(true))
  if valid_580270 != nil:
    section.add "prettyPrint", valid_580270
  var valid_580271 = query.getOrDefault("bearer_token")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "bearer_token", valid_580271
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

proc call*(call_580273: Call_ContainerProjectsZonesClustersNodePoolsCreate_580253;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a node pool for a cluster.
  ## 
  let valid = call_580273.validator(path, query, header, formData, body)
  let scheme = call_580273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580273.url(scheme.get, call_580273.host, call_580273.base,
                         call_580273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580273, url, valid)

proc call*(call_580274: Call_ContainerProjectsZonesClustersNodePoolsCreate_580253;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersNodePoolsCreate
  ## Creates a node pool for a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use parent instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use parent instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use parent instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580275 = newJObject()
  var query_580276 = newJObject()
  var body_580277 = newJObject()
  add(query_580276, "upload_protocol", newJString(uploadProtocol))
  add(path_580275, "zone", newJString(zone))
  add(query_580276, "fields", newJString(fields))
  add(query_580276, "quotaUser", newJString(quotaUser))
  add(query_580276, "alt", newJString(alt))
  add(query_580276, "pp", newJBool(pp))
  add(query_580276, "oauth_token", newJString(oauthToken))
  add(query_580276, "callback", newJString(callback))
  add(query_580276, "access_token", newJString(accessToken))
  add(query_580276, "uploadType", newJString(uploadType))
  add(query_580276, "key", newJString(key))
  add(path_580275, "projectId", newJString(projectId))
  add(query_580276, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580277 = body
  add(query_580276, "prettyPrint", newJBool(prettyPrint))
  add(path_580275, "clusterId", newJString(clusterId))
  add(query_580276, "bearer_token", newJString(bearerToken))
  result = call_580274.call(path_580275, query_580276, nil, nil, body_580277)

var containerProjectsZonesClustersNodePoolsCreate* = Call_ContainerProjectsZonesClustersNodePoolsCreate_580253(
    name: "containerProjectsZonesClustersNodePoolsCreate",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools",
    validator: validate_ContainerProjectsZonesClustersNodePoolsCreate_580254,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsCreate_580255,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsList_580229 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersNodePoolsList_580231(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: "/nodePools")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersNodePoolsList_580230(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the node pools for a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use parent instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use parent instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use parent instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580232 = path.getOrDefault("zone")
  valid_580232 = validateParameter(valid_580232, JString, required = true,
                                 default = nil)
  if valid_580232 != nil:
    section.add "zone", valid_580232
  var valid_580233 = path.getOrDefault("projectId")
  valid_580233 = validateParameter(valid_580233, JString, required = true,
                                 default = nil)
  if valid_580233 != nil:
    section.add "projectId", valid_580233
  var valid_580234 = path.getOrDefault("clusterId")
  valid_580234 = validateParameter(valid_580234, JString, required = true,
                                 default = nil)
  if valid_580234 != nil:
    section.add "clusterId", valid_580234
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent (project, location, cluster id) where the node pools will be listed.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580235 = query.getOrDefault("upload_protocol")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "upload_protocol", valid_580235
  var valid_580236 = query.getOrDefault("fields")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "fields", valid_580236
  var valid_580237 = query.getOrDefault("quotaUser")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "quotaUser", valid_580237
  var valid_580238 = query.getOrDefault("alt")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = newJString("json"))
  if valid_580238 != nil:
    section.add "alt", valid_580238
  var valid_580239 = query.getOrDefault("pp")
  valid_580239 = validateParameter(valid_580239, JBool, required = false,
                                 default = newJBool(true))
  if valid_580239 != nil:
    section.add "pp", valid_580239
  var valid_580240 = query.getOrDefault("oauth_token")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "oauth_token", valid_580240
  var valid_580241 = query.getOrDefault("callback")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "callback", valid_580241
  var valid_580242 = query.getOrDefault("access_token")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "access_token", valid_580242
  var valid_580243 = query.getOrDefault("uploadType")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "uploadType", valid_580243
  var valid_580244 = query.getOrDefault("parent")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = nil)
  if valid_580244 != nil:
    section.add "parent", valid_580244
  var valid_580245 = query.getOrDefault("key")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "key", valid_580245
  var valid_580246 = query.getOrDefault("$.xgafv")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = newJString("1"))
  if valid_580246 != nil:
    section.add "$.xgafv", valid_580246
  var valid_580247 = query.getOrDefault("prettyPrint")
  valid_580247 = validateParameter(valid_580247, JBool, required = false,
                                 default = newJBool(true))
  if valid_580247 != nil:
    section.add "prettyPrint", valid_580247
  var valid_580248 = query.getOrDefault("bearer_token")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "bearer_token", valid_580248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580249: Call_ContainerProjectsZonesClustersNodePoolsList_580229;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the node pools for a cluster.
  ## 
  let valid = call_580249.validator(path, query, header, formData, body)
  let scheme = call_580249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580249.url(scheme.get, call_580249.host, call_580249.base,
                         call_580249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580249, url, valid)

proc call*(call_580250: Call_ContainerProjectsZonesClustersNodePoolsList_580229;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          parent: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersNodePoolsList
  ## Lists the node pools for a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use parent instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent (project, location, cluster id) where the node pools will be listed.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use parent instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use parent instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580251 = newJObject()
  var query_580252 = newJObject()
  add(query_580252, "upload_protocol", newJString(uploadProtocol))
  add(path_580251, "zone", newJString(zone))
  add(query_580252, "fields", newJString(fields))
  add(query_580252, "quotaUser", newJString(quotaUser))
  add(query_580252, "alt", newJString(alt))
  add(query_580252, "pp", newJBool(pp))
  add(query_580252, "oauth_token", newJString(oauthToken))
  add(query_580252, "callback", newJString(callback))
  add(query_580252, "access_token", newJString(accessToken))
  add(query_580252, "uploadType", newJString(uploadType))
  add(query_580252, "parent", newJString(parent))
  add(query_580252, "key", newJString(key))
  add(path_580251, "projectId", newJString(projectId))
  add(query_580252, "$.xgafv", newJString(Xgafv))
  add(query_580252, "prettyPrint", newJBool(prettyPrint))
  add(path_580251, "clusterId", newJString(clusterId))
  add(query_580252, "bearer_token", newJString(bearerToken))
  result = call_580250.call(path_580251, query_580252, nil, nil, nil)

var containerProjectsZonesClustersNodePoolsList* = Call_ContainerProjectsZonesClustersNodePoolsList_580229(
    name: "containerProjectsZonesClustersNodePoolsList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools",
    validator: validate_ContainerProjectsZonesClustersNodePoolsList_580230,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsList_580231,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsGet_580278 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersNodePoolsGet_580280(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  assert "nodePoolId" in path, "`nodePoolId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: "/nodePools/"),
               (kind: VariableSegment, value: "nodePoolId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersNodePoolsGet_580279(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the node pool requested.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   nodePoolId: JString (required)
  ##             : The name of the node pool.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580281 = path.getOrDefault("zone")
  valid_580281 = validateParameter(valid_580281, JString, required = true,
                                 default = nil)
  if valid_580281 != nil:
    section.add "zone", valid_580281
  var valid_580282 = path.getOrDefault("nodePoolId")
  valid_580282 = validateParameter(valid_580282, JString, required = true,
                                 default = nil)
  if valid_580282 != nil:
    section.add "nodePoolId", valid_580282
  var valid_580283 = path.getOrDefault("projectId")
  valid_580283 = validateParameter(valid_580283, JString, required = true,
                                 default = nil)
  if valid_580283 != nil:
    section.add "projectId", valid_580283
  var valid_580284 = path.getOrDefault("clusterId")
  valid_580284 = validateParameter(valid_580284, JString, required = true,
                                 default = nil)
  if valid_580284 != nil:
    section.add "clusterId", valid_580284
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: JString
  ##       : The name (project, location, cluster, node pool id) of the node pool to get.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580285 = query.getOrDefault("upload_protocol")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = nil)
  if valid_580285 != nil:
    section.add "upload_protocol", valid_580285
  var valid_580286 = query.getOrDefault("fields")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "fields", valid_580286
  var valid_580287 = query.getOrDefault("quotaUser")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "quotaUser", valid_580287
  var valid_580288 = query.getOrDefault("alt")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = newJString("json"))
  if valid_580288 != nil:
    section.add "alt", valid_580288
  var valid_580289 = query.getOrDefault("pp")
  valid_580289 = validateParameter(valid_580289, JBool, required = false,
                                 default = newJBool(true))
  if valid_580289 != nil:
    section.add "pp", valid_580289
  var valid_580290 = query.getOrDefault("oauth_token")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = nil)
  if valid_580290 != nil:
    section.add "oauth_token", valid_580290
  var valid_580291 = query.getOrDefault("callback")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "callback", valid_580291
  var valid_580292 = query.getOrDefault("access_token")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = nil)
  if valid_580292 != nil:
    section.add "access_token", valid_580292
  var valid_580293 = query.getOrDefault("uploadType")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "uploadType", valid_580293
  var valid_580294 = query.getOrDefault("key")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = nil)
  if valid_580294 != nil:
    section.add "key", valid_580294
  var valid_580295 = query.getOrDefault("name")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "name", valid_580295
  var valid_580296 = query.getOrDefault("$.xgafv")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = newJString("1"))
  if valid_580296 != nil:
    section.add "$.xgafv", valid_580296
  var valid_580297 = query.getOrDefault("prettyPrint")
  valid_580297 = validateParameter(valid_580297, JBool, required = false,
                                 default = newJBool(true))
  if valid_580297 != nil:
    section.add "prettyPrint", valid_580297
  var valid_580298 = query.getOrDefault("bearer_token")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = nil)
  if valid_580298 != nil:
    section.add "bearer_token", valid_580298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580299: Call_ContainerProjectsZonesClustersNodePoolsGet_580278;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the node pool requested.
  ## 
  let valid = call_580299.validator(path, query, header, formData, body)
  let scheme = call_580299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580299.url(scheme.get, call_580299.host, call_580299.base,
                         call_580299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580299, url, valid)

proc call*(call_580300: Call_ContainerProjectsZonesClustersNodePoolsGet_580278;
          zone: string; nodePoolId: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; name: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersNodePoolsGet
  ## Retrieves the node pool requested.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: string (required)
  ##             : The name of the node pool.
  ## This field is deprecated, use name instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : The name (project, location, cluster, node pool id) of the node pool to get.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580301 = newJObject()
  var query_580302 = newJObject()
  add(query_580302, "upload_protocol", newJString(uploadProtocol))
  add(path_580301, "zone", newJString(zone))
  add(query_580302, "fields", newJString(fields))
  add(query_580302, "quotaUser", newJString(quotaUser))
  add(query_580302, "alt", newJString(alt))
  add(query_580302, "pp", newJBool(pp))
  add(query_580302, "oauth_token", newJString(oauthToken))
  add(query_580302, "callback", newJString(callback))
  add(query_580302, "access_token", newJString(accessToken))
  add(query_580302, "uploadType", newJString(uploadType))
  add(path_580301, "nodePoolId", newJString(nodePoolId))
  add(query_580302, "key", newJString(key))
  add(query_580302, "name", newJString(name))
  add(path_580301, "projectId", newJString(projectId))
  add(query_580302, "$.xgafv", newJString(Xgafv))
  add(query_580302, "prettyPrint", newJBool(prettyPrint))
  add(path_580301, "clusterId", newJString(clusterId))
  add(query_580302, "bearer_token", newJString(bearerToken))
  result = call_580300.call(path_580301, query_580302, nil, nil, nil)

var containerProjectsZonesClustersNodePoolsGet* = Call_ContainerProjectsZonesClustersNodePoolsGet_580278(
    name: "containerProjectsZonesClustersNodePoolsGet", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}",
    validator: validate_ContainerProjectsZonesClustersNodePoolsGet_580279,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsGet_580280,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsDelete_580303 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersNodePoolsDelete_580305(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  assert "nodePoolId" in path, "`nodePoolId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: "/nodePools/"),
               (kind: VariableSegment, value: "nodePoolId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersNodePoolsDelete_580304(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes a node pool from a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   nodePoolId: JString (required)
  ##             : The name of the node pool to delete.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580306 = path.getOrDefault("zone")
  valid_580306 = validateParameter(valid_580306, JString, required = true,
                                 default = nil)
  if valid_580306 != nil:
    section.add "zone", valid_580306
  var valid_580307 = path.getOrDefault("nodePoolId")
  valid_580307 = validateParameter(valid_580307, JString, required = true,
                                 default = nil)
  if valid_580307 != nil:
    section.add "nodePoolId", valid_580307
  var valid_580308 = path.getOrDefault("projectId")
  valid_580308 = validateParameter(valid_580308, JString, required = true,
                                 default = nil)
  if valid_580308 != nil:
    section.add "projectId", valid_580308
  var valid_580309 = path.getOrDefault("clusterId")
  valid_580309 = validateParameter(valid_580309, JString, required = true,
                                 default = nil)
  if valid_580309 != nil:
    section.add "clusterId", valid_580309
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: JString
  ##       : The name (project, location, cluster, node pool id) of the node pool to delete.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580310 = query.getOrDefault("upload_protocol")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = nil)
  if valid_580310 != nil:
    section.add "upload_protocol", valid_580310
  var valid_580311 = query.getOrDefault("fields")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = nil)
  if valid_580311 != nil:
    section.add "fields", valid_580311
  var valid_580312 = query.getOrDefault("quotaUser")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = nil)
  if valid_580312 != nil:
    section.add "quotaUser", valid_580312
  var valid_580313 = query.getOrDefault("alt")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = newJString("json"))
  if valid_580313 != nil:
    section.add "alt", valid_580313
  var valid_580314 = query.getOrDefault("pp")
  valid_580314 = validateParameter(valid_580314, JBool, required = false,
                                 default = newJBool(true))
  if valid_580314 != nil:
    section.add "pp", valid_580314
  var valid_580315 = query.getOrDefault("oauth_token")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "oauth_token", valid_580315
  var valid_580316 = query.getOrDefault("callback")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "callback", valid_580316
  var valid_580317 = query.getOrDefault("access_token")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = nil)
  if valid_580317 != nil:
    section.add "access_token", valid_580317
  var valid_580318 = query.getOrDefault("uploadType")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = nil)
  if valid_580318 != nil:
    section.add "uploadType", valid_580318
  var valid_580319 = query.getOrDefault("key")
  valid_580319 = validateParameter(valid_580319, JString, required = false,
                                 default = nil)
  if valid_580319 != nil:
    section.add "key", valid_580319
  var valid_580320 = query.getOrDefault("name")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = nil)
  if valid_580320 != nil:
    section.add "name", valid_580320
  var valid_580321 = query.getOrDefault("$.xgafv")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = newJString("1"))
  if valid_580321 != nil:
    section.add "$.xgafv", valid_580321
  var valid_580322 = query.getOrDefault("prettyPrint")
  valid_580322 = validateParameter(valid_580322, JBool, required = false,
                                 default = newJBool(true))
  if valid_580322 != nil:
    section.add "prettyPrint", valid_580322
  var valid_580323 = query.getOrDefault("bearer_token")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "bearer_token", valid_580323
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580324: Call_ContainerProjectsZonesClustersNodePoolsDelete_580303;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a node pool from a cluster.
  ## 
  let valid = call_580324.validator(path, query, header, formData, body)
  let scheme = call_580324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580324.url(scheme.get, call_580324.host, call_580324.base,
                         call_580324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580324, url, valid)

proc call*(call_580325: Call_ContainerProjectsZonesClustersNodePoolsDelete_580303;
          zone: string; nodePoolId: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; name: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersNodePoolsDelete
  ## Deletes a node pool from a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: string (required)
  ##             : The name of the node pool to delete.
  ## This field is deprecated, use name instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : The name (project, location, cluster, node pool id) of the node pool to delete.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580326 = newJObject()
  var query_580327 = newJObject()
  add(query_580327, "upload_protocol", newJString(uploadProtocol))
  add(path_580326, "zone", newJString(zone))
  add(query_580327, "fields", newJString(fields))
  add(query_580327, "quotaUser", newJString(quotaUser))
  add(query_580327, "alt", newJString(alt))
  add(query_580327, "pp", newJBool(pp))
  add(query_580327, "oauth_token", newJString(oauthToken))
  add(query_580327, "callback", newJString(callback))
  add(query_580327, "access_token", newJString(accessToken))
  add(query_580327, "uploadType", newJString(uploadType))
  add(path_580326, "nodePoolId", newJString(nodePoolId))
  add(query_580327, "key", newJString(key))
  add(query_580327, "name", newJString(name))
  add(path_580326, "projectId", newJString(projectId))
  add(query_580327, "$.xgafv", newJString(Xgafv))
  add(query_580327, "prettyPrint", newJBool(prettyPrint))
  add(path_580326, "clusterId", newJString(clusterId))
  add(query_580327, "bearer_token", newJString(bearerToken))
  result = call_580325.call(path_580326, query_580327, nil, nil, nil)

var containerProjectsZonesClustersNodePoolsDelete* = Call_ContainerProjectsZonesClustersNodePoolsDelete_580303(
    name: "containerProjectsZonesClustersNodePoolsDelete",
    meth: HttpMethod.HttpDelete, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}",
    validator: validate_ContainerProjectsZonesClustersNodePoolsDelete_580304,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsDelete_580305,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_580328 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersNodePoolsAutoscaling_580330(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  assert "nodePoolId" in path, "`nodePoolId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: "/nodePools/"),
               (kind: VariableSegment, value: "nodePoolId"),
               (kind: ConstantSegment, value: "/autoscaling")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersNodePoolsAutoscaling_580329(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the autoscaling settings of a specific node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   nodePoolId: JString (required)
  ##             : The name of the node pool to upgrade.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580331 = path.getOrDefault("zone")
  valid_580331 = validateParameter(valid_580331, JString, required = true,
                                 default = nil)
  if valid_580331 != nil:
    section.add "zone", valid_580331
  var valid_580332 = path.getOrDefault("nodePoolId")
  valid_580332 = validateParameter(valid_580332, JString, required = true,
                                 default = nil)
  if valid_580332 != nil:
    section.add "nodePoolId", valid_580332
  var valid_580333 = path.getOrDefault("projectId")
  valid_580333 = validateParameter(valid_580333, JString, required = true,
                                 default = nil)
  if valid_580333 != nil:
    section.add "projectId", valid_580333
  var valid_580334 = path.getOrDefault("clusterId")
  valid_580334 = validateParameter(valid_580334, JString, required = true,
                                 default = nil)
  if valid_580334 != nil:
    section.add "clusterId", valid_580334
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580335 = query.getOrDefault("upload_protocol")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = nil)
  if valid_580335 != nil:
    section.add "upload_protocol", valid_580335
  var valid_580336 = query.getOrDefault("fields")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = nil)
  if valid_580336 != nil:
    section.add "fields", valid_580336
  var valid_580337 = query.getOrDefault("quotaUser")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = nil)
  if valid_580337 != nil:
    section.add "quotaUser", valid_580337
  var valid_580338 = query.getOrDefault("alt")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = newJString("json"))
  if valid_580338 != nil:
    section.add "alt", valid_580338
  var valid_580339 = query.getOrDefault("pp")
  valid_580339 = validateParameter(valid_580339, JBool, required = false,
                                 default = newJBool(true))
  if valid_580339 != nil:
    section.add "pp", valid_580339
  var valid_580340 = query.getOrDefault("oauth_token")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = nil)
  if valid_580340 != nil:
    section.add "oauth_token", valid_580340
  var valid_580341 = query.getOrDefault("callback")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = nil)
  if valid_580341 != nil:
    section.add "callback", valid_580341
  var valid_580342 = query.getOrDefault("access_token")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = nil)
  if valid_580342 != nil:
    section.add "access_token", valid_580342
  var valid_580343 = query.getOrDefault("uploadType")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = nil)
  if valid_580343 != nil:
    section.add "uploadType", valid_580343
  var valid_580344 = query.getOrDefault("key")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = nil)
  if valid_580344 != nil:
    section.add "key", valid_580344
  var valid_580345 = query.getOrDefault("$.xgafv")
  valid_580345 = validateParameter(valid_580345, JString, required = false,
                                 default = newJString("1"))
  if valid_580345 != nil:
    section.add "$.xgafv", valid_580345
  var valid_580346 = query.getOrDefault("prettyPrint")
  valid_580346 = validateParameter(valid_580346, JBool, required = false,
                                 default = newJBool(true))
  if valid_580346 != nil:
    section.add "prettyPrint", valid_580346
  var valid_580347 = query.getOrDefault("bearer_token")
  valid_580347 = validateParameter(valid_580347, JString, required = false,
                                 default = nil)
  if valid_580347 != nil:
    section.add "bearer_token", valid_580347
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

proc call*(call_580349: Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_580328;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the autoscaling settings of a specific node pool.
  ## 
  let valid = call_580349.validator(path, query, header, formData, body)
  let scheme = call_580349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580349.url(scheme.get, call_580349.host, call_580349.base,
                         call_580349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580349, url, valid)

proc call*(call_580350: Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_580328;
          zone: string; nodePoolId: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersNodePoolsAutoscaling
  ## Sets the autoscaling settings of a specific node pool.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: string (required)
  ##             : The name of the node pool to upgrade.
  ## This field is deprecated, use name instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580351 = newJObject()
  var query_580352 = newJObject()
  var body_580353 = newJObject()
  add(query_580352, "upload_protocol", newJString(uploadProtocol))
  add(path_580351, "zone", newJString(zone))
  add(query_580352, "fields", newJString(fields))
  add(query_580352, "quotaUser", newJString(quotaUser))
  add(query_580352, "alt", newJString(alt))
  add(query_580352, "pp", newJBool(pp))
  add(query_580352, "oauth_token", newJString(oauthToken))
  add(query_580352, "callback", newJString(callback))
  add(query_580352, "access_token", newJString(accessToken))
  add(query_580352, "uploadType", newJString(uploadType))
  add(path_580351, "nodePoolId", newJString(nodePoolId))
  add(query_580352, "key", newJString(key))
  add(path_580351, "projectId", newJString(projectId))
  add(query_580352, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580353 = body
  add(query_580352, "prettyPrint", newJBool(prettyPrint))
  add(path_580351, "clusterId", newJString(clusterId))
  add(query_580352, "bearer_token", newJString(bearerToken))
  result = call_580350.call(path_580351, query_580352, nil, nil, body_580353)

var containerProjectsZonesClustersNodePoolsAutoscaling* = Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_580328(
    name: "containerProjectsZonesClustersNodePoolsAutoscaling",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}/autoscaling",
    validator: validate_ContainerProjectsZonesClustersNodePoolsAutoscaling_580329,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsAutoscaling_580330,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsSetManagement_580354 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersNodePoolsSetManagement_580356(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  assert "nodePoolId" in path, "`nodePoolId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: "/nodePools/"),
               (kind: VariableSegment, value: "nodePoolId"),
               (kind: ConstantSegment, value: "/setManagement")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersNodePoolsSetManagement_580355(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the NodeManagement options for a node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   nodePoolId: JString (required)
  ##             : The name of the node pool to update.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to update.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580357 = path.getOrDefault("zone")
  valid_580357 = validateParameter(valid_580357, JString, required = true,
                                 default = nil)
  if valid_580357 != nil:
    section.add "zone", valid_580357
  var valid_580358 = path.getOrDefault("nodePoolId")
  valid_580358 = validateParameter(valid_580358, JString, required = true,
                                 default = nil)
  if valid_580358 != nil:
    section.add "nodePoolId", valid_580358
  var valid_580359 = path.getOrDefault("projectId")
  valid_580359 = validateParameter(valid_580359, JString, required = true,
                                 default = nil)
  if valid_580359 != nil:
    section.add "projectId", valid_580359
  var valid_580360 = path.getOrDefault("clusterId")
  valid_580360 = validateParameter(valid_580360, JString, required = true,
                                 default = nil)
  if valid_580360 != nil:
    section.add "clusterId", valid_580360
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580361 = query.getOrDefault("upload_protocol")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "upload_protocol", valid_580361
  var valid_580362 = query.getOrDefault("fields")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = nil)
  if valid_580362 != nil:
    section.add "fields", valid_580362
  var valid_580363 = query.getOrDefault("quotaUser")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = nil)
  if valid_580363 != nil:
    section.add "quotaUser", valid_580363
  var valid_580364 = query.getOrDefault("alt")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = newJString("json"))
  if valid_580364 != nil:
    section.add "alt", valid_580364
  var valid_580365 = query.getOrDefault("pp")
  valid_580365 = validateParameter(valid_580365, JBool, required = false,
                                 default = newJBool(true))
  if valid_580365 != nil:
    section.add "pp", valid_580365
  var valid_580366 = query.getOrDefault("oauth_token")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = nil)
  if valid_580366 != nil:
    section.add "oauth_token", valid_580366
  var valid_580367 = query.getOrDefault("callback")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = nil)
  if valid_580367 != nil:
    section.add "callback", valid_580367
  var valid_580368 = query.getOrDefault("access_token")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = nil)
  if valid_580368 != nil:
    section.add "access_token", valid_580368
  var valid_580369 = query.getOrDefault("uploadType")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = nil)
  if valid_580369 != nil:
    section.add "uploadType", valid_580369
  var valid_580370 = query.getOrDefault("key")
  valid_580370 = validateParameter(valid_580370, JString, required = false,
                                 default = nil)
  if valid_580370 != nil:
    section.add "key", valid_580370
  var valid_580371 = query.getOrDefault("$.xgafv")
  valid_580371 = validateParameter(valid_580371, JString, required = false,
                                 default = newJString("1"))
  if valid_580371 != nil:
    section.add "$.xgafv", valid_580371
  var valid_580372 = query.getOrDefault("prettyPrint")
  valid_580372 = validateParameter(valid_580372, JBool, required = false,
                                 default = newJBool(true))
  if valid_580372 != nil:
    section.add "prettyPrint", valid_580372
  var valid_580373 = query.getOrDefault("bearer_token")
  valid_580373 = validateParameter(valid_580373, JString, required = false,
                                 default = nil)
  if valid_580373 != nil:
    section.add "bearer_token", valid_580373
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

proc call*(call_580375: Call_ContainerProjectsZonesClustersNodePoolsSetManagement_580354;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the NodeManagement options for a node pool.
  ## 
  let valid = call_580375.validator(path, query, header, formData, body)
  let scheme = call_580375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580375.url(scheme.get, call_580375.host, call_580375.base,
                         call_580375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580375, url, valid)

proc call*(call_580376: Call_ContainerProjectsZonesClustersNodePoolsSetManagement_580354;
          zone: string; nodePoolId: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersNodePoolsSetManagement
  ## Sets the NodeManagement options for a node pool.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: string (required)
  ##             : The name of the node pool to update.
  ## This field is deprecated, use name instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster to update.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580377 = newJObject()
  var query_580378 = newJObject()
  var body_580379 = newJObject()
  add(query_580378, "upload_protocol", newJString(uploadProtocol))
  add(path_580377, "zone", newJString(zone))
  add(query_580378, "fields", newJString(fields))
  add(query_580378, "quotaUser", newJString(quotaUser))
  add(query_580378, "alt", newJString(alt))
  add(query_580378, "pp", newJBool(pp))
  add(query_580378, "oauth_token", newJString(oauthToken))
  add(query_580378, "callback", newJString(callback))
  add(query_580378, "access_token", newJString(accessToken))
  add(query_580378, "uploadType", newJString(uploadType))
  add(path_580377, "nodePoolId", newJString(nodePoolId))
  add(query_580378, "key", newJString(key))
  add(path_580377, "projectId", newJString(projectId))
  add(query_580378, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580379 = body
  add(query_580378, "prettyPrint", newJBool(prettyPrint))
  add(path_580377, "clusterId", newJString(clusterId))
  add(query_580378, "bearer_token", newJString(bearerToken))
  result = call_580376.call(path_580377, query_580378, nil, nil, body_580379)

var containerProjectsZonesClustersNodePoolsSetManagement* = Call_ContainerProjectsZonesClustersNodePoolsSetManagement_580354(
    name: "containerProjectsZonesClustersNodePoolsSetManagement",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}/setManagement",
    validator: validate_ContainerProjectsZonesClustersNodePoolsSetManagement_580355,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsSetManagement_580356,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsUpdate_580380 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersNodePoolsUpdate_580382(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  assert "nodePoolId" in path, "`nodePoolId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: "/nodePools/"),
               (kind: VariableSegment, value: "nodePoolId"),
               (kind: ConstantSegment, value: "/update")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersNodePoolsUpdate_580381(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates the version and/or iamge type of a specific node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   nodePoolId: JString (required)
  ##             : The name of the node pool to upgrade.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580383 = path.getOrDefault("zone")
  valid_580383 = validateParameter(valid_580383, JString, required = true,
                                 default = nil)
  if valid_580383 != nil:
    section.add "zone", valid_580383
  var valid_580384 = path.getOrDefault("nodePoolId")
  valid_580384 = validateParameter(valid_580384, JString, required = true,
                                 default = nil)
  if valid_580384 != nil:
    section.add "nodePoolId", valid_580384
  var valid_580385 = path.getOrDefault("projectId")
  valid_580385 = validateParameter(valid_580385, JString, required = true,
                                 default = nil)
  if valid_580385 != nil:
    section.add "projectId", valid_580385
  var valid_580386 = path.getOrDefault("clusterId")
  valid_580386 = validateParameter(valid_580386, JString, required = true,
                                 default = nil)
  if valid_580386 != nil:
    section.add "clusterId", valid_580386
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580387 = query.getOrDefault("upload_protocol")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = nil)
  if valid_580387 != nil:
    section.add "upload_protocol", valid_580387
  var valid_580388 = query.getOrDefault("fields")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = nil)
  if valid_580388 != nil:
    section.add "fields", valid_580388
  var valid_580389 = query.getOrDefault("quotaUser")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = nil)
  if valid_580389 != nil:
    section.add "quotaUser", valid_580389
  var valid_580390 = query.getOrDefault("alt")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = newJString("json"))
  if valid_580390 != nil:
    section.add "alt", valid_580390
  var valid_580391 = query.getOrDefault("pp")
  valid_580391 = validateParameter(valid_580391, JBool, required = false,
                                 default = newJBool(true))
  if valid_580391 != nil:
    section.add "pp", valid_580391
  var valid_580392 = query.getOrDefault("oauth_token")
  valid_580392 = validateParameter(valid_580392, JString, required = false,
                                 default = nil)
  if valid_580392 != nil:
    section.add "oauth_token", valid_580392
  var valid_580393 = query.getOrDefault("callback")
  valid_580393 = validateParameter(valid_580393, JString, required = false,
                                 default = nil)
  if valid_580393 != nil:
    section.add "callback", valid_580393
  var valid_580394 = query.getOrDefault("access_token")
  valid_580394 = validateParameter(valid_580394, JString, required = false,
                                 default = nil)
  if valid_580394 != nil:
    section.add "access_token", valid_580394
  var valid_580395 = query.getOrDefault("uploadType")
  valid_580395 = validateParameter(valid_580395, JString, required = false,
                                 default = nil)
  if valid_580395 != nil:
    section.add "uploadType", valid_580395
  var valid_580396 = query.getOrDefault("key")
  valid_580396 = validateParameter(valid_580396, JString, required = false,
                                 default = nil)
  if valid_580396 != nil:
    section.add "key", valid_580396
  var valid_580397 = query.getOrDefault("$.xgafv")
  valid_580397 = validateParameter(valid_580397, JString, required = false,
                                 default = newJString("1"))
  if valid_580397 != nil:
    section.add "$.xgafv", valid_580397
  var valid_580398 = query.getOrDefault("prettyPrint")
  valid_580398 = validateParameter(valid_580398, JBool, required = false,
                                 default = newJBool(true))
  if valid_580398 != nil:
    section.add "prettyPrint", valid_580398
  var valid_580399 = query.getOrDefault("bearer_token")
  valid_580399 = validateParameter(valid_580399, JString, required = false,
                                 default = nil)
  if valid_580399 != nil:
    section.add "bearer_token", valid_580399
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

proc call*(call_580401: Call_ContainerProjectsZonesClustersNodePoolsUpdate_580380;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the version and/or iamge type of a specific node pool.
  ## 
  let valid = call_580401.validator(path, query, header, formData, body)
  let scheme = call_580401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580401.url(scheme.get, call_580401.host, call_580401.base,
                         call_580401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580401, url, valid)

proc call*(call_580402: Call_ContainerProjectsZonesClustersNodePoolsUpdate_580380;
          zone: string; nodePoolId: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersNodePoolsUpdate
  ## Updates the version and/or iamge type of a specific node pool.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: string (required)
  ##             : The name of the node pool to upgrade.
  ## This field is deprecated, use name instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580403 = newJObject()
  var query_580404 = newJObject()
  var body_580405 = newJObject()
  add(query_580404, "upload_protocol", newJString(uploadProtocol))
  add(path_580403, "zone", newJString(zone))
  add(query_580404, "fields", newJString(fields))
  add(query_580404, "quotaUser", newJString(quotaUser))
  add(query_580404, "alt", newJString(alt))
  add(query_580404, "pp", newJBool(pp))
  add(query_580404, "oauth_token", newJString(oauthToken))
  add(query_580404, "callback", newJString(callback))
  add(query_580404, "access_token", newJString(accessToken))
  add(query_580404, "uploadType", newJString(uploadType))
  add(path_580403, "nodePoolId", newJString(nodePoolId))
  add(query_580404, "key", newJString(key))
  add(path_580403, "projectId", newJString(projectId))
  add(query_580404, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580405 = body
  add(query_580404, "prettyPrint", newJBool(prettyPrint))
  add(path_580403, "clusterId", newJString(clusterId))
  add(query_580404, "bearer_token", newJString(bearerToken))
  result = call_580402.call(path_580403, query_580404, nil, nil, body_580405)

var containerProjectsZonesClustersNodePoolsUpdate* = Call_ContainerProjectsZonesClustersNodePoolsUpdate_580380(
    name: "containerProjectsZonesClustersNodePoolsUpdate",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}/update",
    validator: validate_ContainerProjectsZonesClustersNodePoolsUpdate_580381,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsUpdate_580382,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsRollback_580406 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersNodePoolsRollback_580408(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  assert "nodePoolId" in path, "`nodePoolId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: "/nodePools/"),
               (kind: VariableSegment, value: "nodePoolId"),
               (kind: ConstantSegment, value: ":rollback")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersNodePoolsRollback_580407(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Roll back the previously Aborted or Failed NodePool upgrade.
  ## This will be an no-op if the last upgrade successfully completed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   nodePoolId: JString (required)
  ##             : The name of the node pool to rollback.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to rollback.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580409 = path.getOrDefault("zone")
  valid_580409 = validateParameter(valid_580409, JString, required = true,
                                 default = nil)
  if valid_580409 != nil:
    section.add "zone", valid_580409
  var valid_580410 = path.getOrDefault("nodePoolId")
  valid_580410 = validateParameter(valid_580410, JString, required = true,
                                 default = nil)
  if valid_580410 != nil:
    section.add "nodePoolId", valid_580410
  var valid_580411 = path.getOrDefault("projectId")
  valid_580411 = validateParameter(valid_580411, JString, required = true,
                                 default = nil)
  if valid_580411 != nil:
    section.add "projectId", valid_580411
  var valid_580412 = path.getOrDefault("clusterId")
  valid_580412 = validateParameter(valid_580412, JString, required = true,
                                 default = nil)
  if valid_580412 != nil:
    section.add "clusterId", valid_580412
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580413 = query.getOrDefault("upload_protocol")
  valid_580413 = validateParameter(valid_580413, JString, required = false,
                                 default = nil)
  if valid_580413 != nil:
    section.add "upload_protocol", valid_580413
  var valid_580414 = query.getOrDefault("fields")
  valid_580414 = validateParameter(valid_580414, JString, required = false,
                                 default = nil)
  if valid_580414 != nil:
    section.add "fields", valid_580414
  var valid_580415 = query.getOrDefault("quotaUser")
  valid_580415 = validateParameter(valid_580415, JString, required = false,
                                 default = nil)
  if valid_580415 != nil:
    section.add "quotaUser", valid_580415
  var valid_580416 = query.getOrDefault("alt")
  valid_580416 = validateParameter(valid_580416, JString, required = false,
                                 default = newJString("json"))
  if valid_580416 != nil:
    section.add "alt", valid_580416
  var valid_580417 = query.getOrDefault("pp")
  valid_580417 = validateParameter(valid_580417, JBool, required = false,
                                 default = newJBool(true))
  if valid_580417 != nil:
    section.add "pp", valid_580417
  var valid_580418 = query.getOrDefault("oauth_token")
  valid_580418 = validateParameter(valid_580418, JString, required = false,
                                 default = nil)
  if valid_580418 != nil:
    section.add "oauth_token", valid_580418
  var valid_580419 = query.getOrDefault("callback")
  valid_580419 = validateParameter(valid_580419, JString, required = false,
                                 default = nil)
  if valid_580419 != nil:
    section.add "callback", valid_580419
  var valid_580420 = query.getOrDefault("access_token")
  valid_580420 = validateParameter(valid_580420, JString, required = false,
                                 default = nil)
  if valid_580420 != nil:
    section.add "access_token", valid_580420
  var valid_580421 = query.getOrDefault("uploadType")
  valid_580421 = validateParameter(valid_580421, JString, required = false,
                                 default = nil)
  if valid_580421 != nil:
    section.add "uploadType", valid_580421
  var valid_580422 = query.getOrDefault("key")
  valid_580422 = validateParameter(valid_580422, JString, required = false,
                                 default = nil)
  if valid_580422 != nil:
    section.add "key", valid_580422
  var valid_580423 = query.getOrDefault("$.xgafv")
  valid_580423 = validateParameter(valid_580423, JString, required = false,
                                 default = newJString("1"))
  if valid_580423 != nil:
    section.add "$.xgafv", valid_580423
  var valid_580424 = query.getOrDefault("prettyPrint")
  valid_580424 = validateParameter(valid_580424, JBool, required = false,
                                 default = newJBool(true))
  if valid_580424 != nil:
    section.add "prettyPrint", valid_580424
  var valid_580425 = query.getOrDefault("bearer_token")
  valid_580425 = validateParameter(valid_580425, JString, required = false,
                                 default = nil)
  if valid_580425 != nil:
    section.add "bearer_token", valid_580425
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

proc call*(call_580427: Call_ContainerProjectsZonesClustersNodePoolsRollback_580406;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Roll back the previously Aborted or Failed NodePool upgrade.
  ## This will be an no-op if the last upgrade successfully completed.
  ## 
  let valid = call_580427.validator(path, query, header, formData, body)
  let scheme = call_580427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580427.url(scheme.get, call_580427.host, call_580427.base,
                         call_580427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580427, url, valid)

proc call*(call_580428: Call_ContainerProjectsZonesClustersNodePoolsRollback_580406;
          zone: string; nodePoolId: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersNodePoolsRollback
  ## Roll back the previously Aborted or Failed NodePool upgrade.
  ## This will be an no-op if the last upgrade successfully completed.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: string (required)
  ##             : The name of the node pool to rollback.
  ## This field is deprecated, use name instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster to rollback.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580429 = newJObject()
  var query_580430 = newJObject()
  var body_580431 = newJObject()
  add(query_580430, "upload_protocol", newJString(uploadProtocol))
  add(path_580429, "zone", newJString(zone))
  add(query_580430, "fields", newJString(fields))
  add(query_580430, "quotaUser", newJString(quotaUser))
  add(query_580430, "alt", newJString(alt))
  add(query_580430, "pp", newJBool(pp))
  add(query_580430, "oauth_token", newJString(oauthToken))
  add(query_580430, "callback", newJString(callback))
  add(query_580430, "access_token", newJString(accessToken))
  add(query_580430, "uploadType", newJString(uploadType))
  add(path_580429, "nodePoolId", newJString(nodePoolId))
  add(query_580430, "key", newJString(key))
  add(path_580429, "projectId", newJString(projectId))
  add(query_580430, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580431 = body
  add(query_580430, "prettyPrint", newJBool(prettyPrint))
  add(path_580429, "clusterId", newJString(clusterId))
  add(query_580430, "bearer_token", newJString(bearerToken))
  result = call_580428.call(path_580429, query_580430, nil, nil, body_580431)

var containerProjectsZonesClustersNodePoolsRollback* = Call_ContainerProjectsZonesClustersNodePoolsRollback_580406(
    name: "containerProjectsZonesClustersNodePoolsRollback",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}:rollback",
    validator: validate_ContainerProjectsZonesClustersNodePoolsRollback_580407,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsRollback_580408,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersResourceLabels_580432 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersResourceLabels_580434(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: "/resourceLabels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersResourceLabels_580433(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets labels on a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580435 = path.getOrDefault("zone")
  valid_580435 = validateParameter(valid_580435, JString, required = true,
                                 default = nil)
  if valid_580435 != nil:
    section.add "zone", valid_580435
  var valid_580436 = path.getOrDefault("projectId")
  valid_580436 = validateParameter(valid_580436, JString, required = true,
                                 default = nil)
  if valid_580436 != nil:
    section.add "projectId", valid_580436
  var valid_580437 = path.getOrDefault("clusterId")
  valid_580437 = validateParameter(valid_580437, JString, required = true,
                                 default = nil)
  if valid_580437 != nil:
    section.add "clusterId", valid_580437
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580438 = query.getOrDefault("upload_protocol")
  valid_580438 = validateParameter(valid_580438, JString, required = false,
                                 default = nil)
  if valid_580438 != nil:
    section.add "upload_protocol", valid_580438
  var valid_580439 = query.getOrDefault("fields")
  valid_580439 = validateParameter(valid_580439, JString, required = false,
                                 default = nil)
  if valid_580439 != nil:
    section.add "fields", valid_580439
  var valid_580440 = query.getOrDefault("quotaUser")
  valid_580440 = validateParameter(valid_580440, JString, required = false,
                                 default = nil)
  if valid_580440 != nil:
    section.add "quotaUser", valid_580440
  var valid_580441 = query.getOrDefault("alt")
  valid_580441 = validateParameter(valid_580441, JString, required = false,
                                 default = newJString("json"))
  if valid_580441 != nil:
    section.add "alt", valid_580441
  var valid_580442 = query.getOrDefault("pp")
  valid_580442 = validateParameter(valid_580442, JBool, required = false,
                                 default = newJBool(true))
  if valid_580442 != nil:
    section.add "pp", valid_580442
  var valid_580443 = query.getOrDefault("oauth_token")
  valid_580443 = validateParameter(valid_580443, JString, required = false,
                                 default = nil)
  if valid_580443 != nil:
    section.add "oauth_token", valid_580443
  var valid_580444 = query.getOrDefault("callback")
  valid_580444 = validateParameter(valid_580444, JString, required = false,
                                 default = nil)
  if valid_580444 != nil:
    section.add "callback", valid_580444
  var valid_580445 = query.getOrDefault("access_token")
  valid_580445 = validateParameter(valid_580445, JString, required = false,
                                 default = nil)
  if valid_580445 != nil:
    section.add "access_token", valid_580445
  var valid_580446 = query.getOrDefault("uploadType")
  valid_580446 = validateParameter(valid_580446, JString, required = false,
                                 default = nil)
  if valid_580446 != nil:
    section.add "uploadType", valid_580446
  var valid_580447 = query.getOrDefault("key")
  valid_580447 = validateParameter(valid_580447, JString, required = false,
                                 default = nil)
  if valid_580447 != nil:
    section.add "key", valid_580447
  var valid_580448 = query.getOrDefault("$.xgafv")
  valid_580448 = validateParameter(valid_580448, JString, required = false,
                                 default = newJString("1"))
  if valid_580448 != nil:
    section.add "$.xgafv", valid_580448
  var valid_580449 = query.getOrDefault("prettyPrint")
  valid_580449 = validateParameter(valid_580449, JBool, required = false,
                                 default = newJBool(true))
  if valid_580449 != nil:
    section.add "prettyPrint", valid_580449
  var valid_580450 = query.getOrDefault("bearer_token")
  valid_580450 = validateParameter(valid_580450, JString, required = false,
                                 default = nil)
  if valid_580450 != nil:
    section.add "bearer_token", valid_580450
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

proc call*(call_580452: Call_ContainerProjectsZonesClustersResourceLabels_580432;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets labels on a cluster.
  ## 
  let valid = call_580452.validator(path, query, header, formData, body)
  let scheme = call_580452.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580452.url(scheme.get, call_580452.host, call_580452.base,
                         call_580452.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580452, url, valid)

proc call*(call_580453: Call_ContainerProjectsZonesClustersResourceLabels_580432;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersResourceLabels
  ## Sets labels on a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580454 = newJObject()
  var query_580455 = newJObject()
  var body_580456 = newJObject()
  add(query_580455, "upload_protocol", newJString(uploadProtocol))
  add(path_580454, "zone", newJString(zone))
  add(query_580455, "fields", newJString(fields))
  add(query_580455, "quotaUser", newJString(quotaUser))
  add(query_580455, "alt", newJString(alt))
  add(query_580455, "pp", newJBool(pp))
  add(query_580455, "oauth_token", newJString(oauthToken))
  add(query_580455, "callback", newJString(callback))
  add(query_580455, "access_token", newJString(accessToken))
  add(query_580455, "uploadType", newJString(uploadType))
  add(query_580455, "key", newJString(key))
  add(path_580454, "projectId", newJString(projectId))
  add(query_580455, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580456 = body
  add(query_580455, "prettyPrint", newJBool(prettyPrint))
  add(path_580454, "clusterId", newJString(clusterId))
  add(query_580455, "bearer_token", newJString(bearerToken))
  result = call_580453.call(path_580454, query_580455, nil, nil, body_580456)

var containerProjectsZonesClustersResourceLabels* = Call_ContainerProjectsZonesClustersResourceLabels_580432(
    name: "containerProjectsZonesClustersResourceLabels",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/resourceLabels",
    validator: validate_ContainerProjectsZonesClustersResourceLabels_580433,
    base: "/", url: url_ContainerProjectsZonesClustersResourceLabels_580434,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersCompleteIpRotation_580457 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersCompleteIpRotation_580459(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: ":completeIpRotation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersCompleteIpRotation_580458(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Completes master IP rotation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580460 = path.getOrDefault("zone")
  valid_580460 = validateParameter(valid_580460, JString, required = true,
                                 default = nil)
  if valid_580460 != nil:
    section.add "zone", valid_580460
  var valid_580461 = path.getOrDefault("projectId")
  valid_580461 = validateParameter(valid_580461, JString, required = true,
                                 default = nil)
  if valid_580461 != nil:
    section.add "projectId", valid_580461
  var valid_580462 = path.getOrDefault("clusterId")
  valid_580462 = validateParameter(valid_580462, JString, required = true,
                                 default = nil)
  if valid_580462 != nil:
    section.add "clusterId", valid_580462
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580463 = query.getOrDefault("upload_protocol")
  valid_580463 = validateParameter(valid_580463, JString, required = false,
                                 default = nil)
  if valid_580463 != nil:
    section.add "upload_protocol", valid_580463
  var valid_580464 = query.getOrDefault("fields")
  valid_580464 = validateParameter(valid_580464, JString, required = false,
                                 default = nil)
  if valid_580464 != nil:
    section.add "fields", valid_580464
  var valid_580465 = query.getOrDefault("quotaUser")
  valid_580465 = validateParameter(valid_580465, JString, required = false,
                                 default = nil)
  if valid_580465 != nil:
    section.add "quotaUser", valid_580465
  var valid_580466 = query.getOrDefault("alt")
  valid_580466 = validateParameter(valid_580466, JString, required = false,
                                 default = newJString("json"))
  if valid_580466 != nil:
    section.add "alt", valid_580466
  var valid_580467 = query.getOrDefault("pp")
  valid_580467 = validateParameter(valid_580467, JBool, required = false,
                                 default = newJBool(true))
  if valid_580467 != nil:
    section.add "pp", valid_580467
  var valid_580468 = query.getOrDefault("oauth_token")
  valid_580468 = validateParameter(valid_580468, JString, required = false,
                                 default = nil)
  if valid_580468 != nil:
    section.add "oauth_token", valid_580468
  var valid_580469 = query.getOrDefault("callback")
  valid_580469 = validateParameter(valid_580469, JString, required = false,
                                 default = nil)
  if valid_580469 != nil:
    section.add "callback", valid_580469
  var valid_580470 = query.getOrDefault("access_token")
  valid_580470 = validateParameter(valid_580470, JString, required = false,
                                 default = nil)
  if valid_580470 != nil:
    section.add "access_token", valid_580470
  var valid_580471 = query.getOrDefault("uploadType")
  valid_580471 = validateParameter(valid_580471, JString, required = false,
                                 default = nil)
  if valid_580471 != nil:
    section.add "uploadType", valid_580471
  var valid_580472 = query.getOrDefault("key")
  valid_580472 = validateParameter(valid_580472, JString, required = false,
                                 default = nil)
  if valid_580472 != nil:
    section.add "key", valid_580472
  var valid_580473 = query.getOrDefault("$.xgafv")
  valid_580473 = validateParameter(valid_580473, JString, required = false,
                                 default = newJString("1"))
  if valid_580473 != nil:
    section.add "$.xgafv", valid_580473
  var valid_580474 = query.getOrDefault("prettyPrint")
  valid_580474 = validateParameter(valid_580474, JBool, required = false,
                                 default = newJBool(true))
  if valid_580474 != nil:
    section.add "prettyPrint", valid_580474
  var valid_580475 = query.getOrDefault("bearer_token")
  valid_580475 = validateParameter(valid_580475, JString, required = false,
                                 default = nil)
  if valid_580475 != nil:
    section.add "bearer_token", valid_580475
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

proc call*(call_580477: Call_ContainerProjectsZonesClustersCompleteIpRotation_580457;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Completes master IP rotation.
  ## 
  let valid = call_580477.validator(path, query, header, formData, body)
  let scheme = call_580477.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580477.url(scheme.get, call_580477.host, call_580477.base,
                         call_580477.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580477, url, valid)

proc call*(call_580478: Call_ContainerProjectsZonesClustersCompleteIpRotation_580457;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersCompleteIpRotation
  ## Completes master IP rotation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580479 = newJObject()
  var query_580480 = newJObject()
  var body_580481 = newJObject()
  add(query_580480, "upload_protocol", newJString(uploadProtocol))
  add(path_580479, "zone", newJString(zone))
  add(query_580480, "fields", newJString(fields))
  add(query_580480, "quotaUser", newJString(quotaUser))
  add(query_580480, "alt", newJString(alt))
  add(query_580480, "pp", newJBool(pp))
  add(query_580480, "oauth_token", newJString(oauthToken))
  add(query_580480, "callback", newJString(callback))
  add(query_580480, "access_token", newJString(accessToken))
  add(query_580480, "uploadType", newJString(uploadType))
  add(query_580480, "key", newJString(key))
  add(path_580479, "projectId", newJString(projectId))
  add(query_580480, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580481 = body
  add(query_580480, "prettyPrint", newJBool(prettyPrint))
  add(path_580479, "clusterId", newJString(clusterId))
  add(query_580480, "bearer_token", newJString(bearerToken))
  result = call_580478.call(path_580479, query_580480, nil, nil, body_580481)

var containerProjectsZonesClustersCompleteIpRotation* = Call_ContainerProjectsZonesClustersCompleteIpRotation_580457(
    name: "containerProjectsZonesClustersCompleteIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:completeIpRotation",
    validator: validate_ContainerProjectsZonesClustersCompleteIpRotation_580458,
    base: "/", url: url_ContainerProjectsZonesClustersCompleteIpRotation_580459,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersSetMaintenancePolicy_580482 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersSetMaintenancePolicy_580484(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: ":setMaintenancePolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersSetMaintenancePolicy_580483(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the maintenance policy for a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ##   clusterId: JString (required)
  ##            : The name of the cluster to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580485 = path.getOrDefault("zone")
  valid_580485 = validateParameter(valid_580485, JString, required = true,
                                 default = nil)
  if valid_580485 != nil:
    section.add "zone", valid_580485
  var valid_580486 = path.getOrDefault("projectId")
  valid_580486 = validateParameter(valid_580486, JString, required = true,
                                 default = nil)
  if valid_580486 != nil:
    section.add "projectId", valid_580486
  var valid_580487 = path.getOrDefault("clusterId")
  valid_580487 = validateParameter(valid_580487, JString, required = true,
                                 default = nil)
  if valid_580487 != nil:
    section.add "clusterId", valid_580487
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580488 = query.getOrDefault("upload_protocol")
  valid_580488 = validateParameter(valid_580488, JString, required = false,
                                 default = nil)
  if valid_580488 != nil:
    section.add "upload_protocol", valid_580488
  var valid_580489 = query.getOrDefault("fields")
  valid_580489 = validateParameter(valid_580489, JString, required = false,
                                 default = nil)
  if valid_580489 != nil:
    section.add "fields", valid_580489
  var valid_580490 = query.getOrDefault("quotaUser")
  valid_580490 = validateParameter(valid_580490, JString, required = false,
                                 default = nil)
  if valid_580490 != nil:
    section.add "quotaUser", valid_580490
  var valid_580491 = query.getOrDefault("alt")
  valid_580491 = validateParameter(valid_580491, JString, required = false,
                                 default = newJString("json"))
  if valid_580491 != nil:
    section.add "alt", valid_580491
  var valid_580492 = query.getOrDefault("pp")
  valid_580492 = validateParameter(valid_580492, JBool, required = false,
                                 default = newJBool(true))
  if valid_580492 != nil:
    section.add "pp", valid_580492
  var valid_580493 = query.getOrDefault("oauth_token")
  valid_580493 = validateParameter(valid_580493, JString, required = false,
                                 default = nil)
  if valid_580493 != nil:
    section.add "oauth_token", valid_580493
  var valid_580494 = query.getOrDefault("callback")
  valid_580494 = validateParameter(valid_580494, JString, required = false,
                                 default = nil)
  if valid_580494 != nil:
    section.add "callback", valid_580494
  var valid_580495 = query.getOrDefault("access_token")
  valid_580495 = validateParameter(valid_580495, JString, required = false,
                                 default = nil)
  if valid_580495 != nil:
    section.add "access_token", valid_580495
  var valid_580496 = query.getOrDefault("uploadType")
  valid_580496 = validateParameter(valid_580496, JString, required = false,
                                 default = nil)
  if valid_580496 != nil:
    section.add "uploadType", valid_580496
  var valid_580497 = query.getOrDefault("key")
  valid_580497 = validateParameter(valid_580497, JString, required = false,
                                 default = nil)
  if valid_580497 != nil:
    section.add "key", valid_580497
  var valid_580498 = query.getOrDefault("$.xgafv")
  valid_580498 = validateParameter(valid_580498, JString, required = false,
                                 default = newJString("1"))
  if valid_580498 != nil:
    section.add "$.xgafv", valid_580498
  var valid_580499 = query.getOrDefault("prettyPrint")
  valid_580499 = validateParameter(valid_580499, JBool, required = false,
                                 default = newJBool(true))
  if valid_580499 != nil:
    section.add "prettyPrint", valid_580499
  var valid_580500 = query.getOrDefault("bearer_token")
  valid_580500 = validateParameter(valid_580500, JString, required = false,
                                 default = nil)
  if valid_580500 != nil:
    section.add "bearer_token", valid_580500
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

proc call*(call_580502: Call_ContainerProjectsZonesClustersSetMaintenancePolicy_580482;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the maintenance policy for a cluster.
  ## 
  let valid = call_580502.validator(path, query, header, formData, body)
  let scheme = call_580502.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580502.url(scheme.get, call_580502.host, call_580502.base,
                         call_580502.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580502, url, valid)

proc call*(call_580503: Call_ContainerProjectsZonesClustersSetMaintenancePolicy_580482;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersSetMaintenancePolicy
  ## Sets the maintenance policy for a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster to update.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580504 = newJObject()
  var query_580505 = newJObject()
  var body_580506 = newJObject()
  add(query_580505, "upload_protocol", newJString(uploadProtocol))
  add(path_580504, "zone", newJString(zone))
  add(query_580505, "fields", newJString(fields))
  add(query_580505, "quotaUser", newJString(quotaUser))
  add(query_580505, "alt", newJString(alt))
  add(query_580505, "pp", newJBool(pp))
  add(query_580505, "oauth_token", newJString(oauthToken))
  add(query_580505, "callback", newJString(callback))
  add(query_580505, "access_token", newJString(accessToken))
  add(query_580505, "uploadType", newJString(uploadType))
  add(query_580505, "key", newJString(key))
  add(path_580504, "projectId", newJString(projectId))
  add(query_580505, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580506 = body
  add(query_580505, "prettyPrint", newJBool(prettyPrint))
  add(path_580504, "clusterId", newJString(clusterId))
  add(query_580505, "bearer_token", newJString(bearerToken))
  result = call_580503.call(path_580504, query_580505, nil, nil, body_580506)

var containerProjectsZonesClustersSetMaintenancePolicy* = Call_ContainerProjectsZonesClustersSetMaintenancePolicy_580482(
    name: "containerProjectsZonesClustersSetMaintenancePolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:setMaintenancePolicy",
    validator: validate_ContainerProjectsZonesClustersSetMaintenancePolicy_580483,
    base: "/", url: url_ContainerProjectsZonesClustersSetMaintenancePolicy_580484,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersSetMasterAuth_580507 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersSetMasterAuth_580509(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: ":setMasterAuth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersSetMasterAuth_580508(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Used to set master auth materials. Currently supports :-
  ## Changing the admin password of a specific cluster.
  ## This can be either via password generation or explicitly set.
  ## Modify basic_auth.csv and reset the K8S API server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580510 = path.getOrDefault("zone")
  valid_580510 = validateParameter(valid_580510, JString, required = true,
                                 default = nil)
  if valid_580510 != nil:
    section.add "zone", valid_580510
  var valid_580511 = path.getOrDefault("projectId")
  valid_580511 = validateParameter(valid_580511, JString, required = true,
                                 default = nil)
  if valid_580511 != nil:
    section.add "projectId", valid_580511
  var valid_580512 = path.getOrDefault("clusterId")
  valid_580512 = validateParameter(valid_580512, JString, required = true,
                                 default = nil)
  if valid_580512 != nil:
    section.add "clusterId", valid_580512
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580513 = query.getOrDefault("upload_protocol")
  valid_580513 = validateParameter(valid_580513, JString, required = false,
                                 default = nil)
  if valid_580513 != nil:
    section.add "upload_protocol", valid_580513
  var valid_580514 = query.getOrDefault("fields")
  valid_580514 = validateParameter(valid_580514, JString, required = false,
                                 default = nil)
  if valid_580514 != nil:
    section.add "fields", valid_580514
  var valid_580515 = query.getOrDefault("quotaUser")
  valid_580515 = validateParameter(valid_580515, JString, required = false,
                                 default = nil)
  if valid_580515 != nil:
    section.add "quotaUser", valid_580515
  var valid_580516 = query.getOrDefault("alt")
  valid_580516 = validateParameter(valid_580516, JString, required = false,
                                 default = newJString("json"))
  if valid_580516 != nil:
    section.add "alt", valid_580516
  var valid_580517 = query.getOrDefault("pp")
  valid_580517 = validateParameter(valid_580517, JBool, required = false,
                                 default = newJBool(true))
  if valid_580517 != nil:
    section.add "pp", valid_580517
  var valid_580518 = query.getOrDefault("oauth_token")
  valid_580518 = validateParameter(valid_580518, JString, required = false,
                                 default = nil)
  if valid_580518 != nil:
    section.add "oauth_token", valid_580518
  var valid_580519 = query.getOrDefault("callback")
  valid_580519 = validateParameter(valid_580519, JString, required = false,
                                 default = nil)
  if valid_580519 != nil:
    section.add "callback", valid_580519
  var valid_580520 = query.getOrDefault("access_token")
  valid_580520 = validateParameter(valid_580520, JString, required = false,
                                 default = nil)
  if valid_580520 != nil:
    section.add "access_token", valid_580520
  var valid_580521 = query.getOrDefault("uploadType")
  valid_580521 = validateParameter(valid_580521, JString, required = false,
                                 default = nil)
  if valid_580521 != nil:
    section.add "uploadType", valid_580521
  var valid_580522 = query.getOrDefault("key")
  valid_580522 = validateParameter(valid_580522, JString, required = false,
                                 default = nil)
  if valid_580522 != nil:
    section.add "key", valid_580522
  var valid_580523 = query.getOrDefault("$.xgafv")
  valid_580523 = validateParameter(valid_580523, JString, required = false,
                                 default = newJString("1"))
  if valid_580523 != nil:
    section.add "$.xgafv", valid_580523
  var valid_580524 = query.getOrDefault("prettyPrint")
  valid_580524 = validateParameter(valid_580524, JBool, required = false,
                                 default = newJBool(true))
  if valid_580524 != nil:
    section.add "prettyPrint", valid_580524
  var valid_580525 = query.getOrDefault("bearer_token")
  valid_580525 = validateParameter(valid_580525, JString, required = false,
                                 default = nil)
  if valid_580525 != nil:
    section.add "bearer_token", valid_580525
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

proc call*(call_580527: Call_ContainerProjectsZonesClustersSetMasterAuth_580507;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Used to set master auth materials. Currently supports :-
  ## Changing the admin password of a specific cluster.
  ## This can be either via password generation or explicitly set.
  ## Modify basic_auth.csv and reset the K8S API server.
  ## 
  let valid = call_580527.validator(path, query, header, formData, body)
  let scheme = call_580527.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580527.url(scheme.get, call_580527.host, call_580527.base,
                         call_580527.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580527, url, valid)

proc call*(call_580528: Call_ContainerProjectsZonesClustersSetMasterAuth_580507;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersSetMasterAuth
  ## Used to set master auth materials. Currently supports :-
  ## Changing the admin password of a specific cluster.
  ## This can be either via password generation or explicitly set.
  ## Modify basic_auth.csv and reset the K8S API server.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580529 = newJObject()
  var query_580530 = newJObject()
  var body_580531 = newJObject()
  add(query_580530, "upload_protocol", newJString(uploadProtocol))
  add(path_580529, "zone", newJString(zone))
  add(query_580530, "fields", newJString(fields))
  add(query_580530, "quotaUser", newJString(quotaUser))
  add(query_580530, "alt", newJString(alt))
  add(query_580530, "pp", newJBool(pp))
  add(query_580530, "oauth_token", newJString(oauthToken))
  add(query_580530, "callback", newJString(callback))
  add(query_580530, "access_token", newJString(accessToken))
  add(query_580530, "uploadType", newJString(uploadType))
  add(query_580530, "key", newJString(key))
  add(path_580529, "projectId", newJString(projectId))
  add(query_580530, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580531 = body
  add(query_580530, "prettyPrint", newJBool(prettyPrint))
  add(path_580529, "clusterId", newJString(clusterId))
  add(query_580530, "bearer_token", newJString(bearerToken))
  result = call_580528.call(path_580529, query_580530, nil, nil, body_580531)

var containerProjectsZonesClustersSetMasterAuth* = Call_ContainerProjectsZonesClustersSetMasterAuth_580507(
    name: "containerProjectsZonesClustersSetMasterAuth",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:setMasterAuth",
    validator: validate_ContainerProjectsZonesClustersSetMasterAuth_580508,
    base: "/", url: url_ContainerProjectsZonesClustersSetMasterAuth_580509,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersSetNetworkPolicy_580532 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersSetNetworkPolicy_580534(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: ":setNetworkPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersSetNetworkPolicy_580533(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Enables/Disables Network Policy for a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580535 = path.getOrDefault("zone")
  valid_580535 = validateParameter(valid_580535, JString, required = true,
                                 default = nil)
  if valid_580535 != nil:
    section.add "zone", valid_580535
  var valid_580536 = path.getOrDefault("projectId")
  valid_580536 = validateParameter(valid_580536, JString, required = true,
                                 default = nil)
  if valid_580536 != nil:
    section.add "projectId", valid_580536
  var valid_580537 = path.getOrDefault("clusterId")
  valid_580537 = validateParameter(valid_580537, JString, required = true,
                                 default = nil)
  if valid_580537 != nil:
    section.add "clusterId", valid_580537
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580538 = query.getOrDefault("upload_protocol")
  valid_580538 = validateParameter(valid_580538, JString, required = false,
                                 default = nil)
  if valid_580538 != nil:
    section.add "upload_protocol", valid_580538
  var valid_580539 = query.getOrDefault("fields")
  valid_580539 = validateParameter(valid_580539, JString, required = false,
                                 default = nil)
  if valid_580539 != nil:
    section.add "fields", valid_580539
  var valid_580540 = query.getOrDefault("quotaUser")
  valid_580540 = validateParameter(valid_580540, JString, required = false,
                                 default = nil)
  if valid_580540 != nil:
    section.add "quotaUser", valid_580540
  var valid_580541 = query.getOrDefault("alt")
  valid_580541 = validateParameter(valid_580541, JString, required = false,
                                 default = newJString("json"))
  if valid_580541 != nil:
    section.add "alt", valid_580541
  var valid_580542 = query.getOrDefault("pp")
  valid_580542 = validateParameter(valid_580542, JBool, required = false,
                                 default = newJBool(true))
  if valid_580542 != nil:
    section.add "pp", valid_580542
  var valid_580543 = query.getOrDefault("oauth_token")
  valid_580543 = validateParameter(valid_580543, JString, required = false,
                                 default = nil)
  if valid_580543 != nil:
    section.add "oauth_token", valid_580543
  var valid_580544 = query.getOrDefault("callback")
  valid_580544 = validateParameter(valid_580544, JString, required = false,
                                 default = nil)
  if valid_580544 != nil:
    section.add "callback", valid_580544
  var valid_580545 = query.getOrDefault("access_token")
  valid_580545 = validateParameter(valid_580545, JString, required = false,
                                 default = nil)
  if valid_580545 != nil:
    section.add "access_token", valid_580545
  var valid_580546 = query.getOrDefault("uploadType")
  valid_580546 = validateParameter(valid_580546, JString, required = false,
                                 default = nil)
  if valid_580546 != nil:
    section.add "uploadType", valid_580546
  var valid_580547 = query.getOrDefault("key")
  valid_580547 = validateParameter(valid_580547, JString, required = false,
                                 default = nil)
  if valid_580547 != nil:
    section.add "key", valid_580547
  var valid_580548 = query.getOrDefault("$.xgafv")
  valid_580548 = validateParameter(valid_580548, JString, required = false,
                                 default = newJString("1"))
  if valid_580548 != nil:
    section.add "$.xgafv", valid_580548
  var valid_580549 = query.getOrDefault("prettyPrint")
  valid_580549 = validateParameter(valid_580549, JBool, required = false,
                                 default = newJBool(true))
  if valid_580549 != nil:
    section.add "prettyPrint", valid_580549
  var valid_580550 = query.getOrDefault("bearer_token")
  valid_580550 = validateParameter(valid_580550, JString, required = false,
                                 default = nil)
  if valid_580550 != nil:
    section.add "bearer_token", valid_580550
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

proc call*(call_580552: Call_ContainerProjectsZonesClustersSetNetworkPolicy_580532;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables/Disables Network Policy for a cluster.
  ## 
  let valid = call_580552.validator(path, query, header, formData, body)
  let scheme = call_580552.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580552.url(scheme.get, call_580552.host, call_580552.base,
                         call_580552.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580552, url, valid)

proc call*(call_580553: Call_ContainerProjectsZonesClustersSetNetworkPolicy_580532;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersSetNetworkPolicy
  ## Enables/Disables Network Policy for a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580554 = newJObject()
  var query_580555 = newJObject()
  var body_580556 = newJObject()
  add(query_580555, "upload_protocol", newJString(uploadProtocol))
  add(path_580554, "zone", newJString(zone))
  add(query_580555, "fields", newJString(fields))
  add(query_580555, "quotaUser", newJString(quotaUser))
  add(query_580555, "alt", newJString(alt))
  add(query_580555, "pp", newJBool(pp))
  add(query_580555, "oauth_token", newJString(oauthToken))
  add(query_580555, "callback", newJString(callback))
  add(query_580555, "access_token", newJString(accessToken))
  add(query_580555, "uploadType", newJString(uploadType))
  add(query_580555, "key", newJString(key))
  add(path_580554, "projectId", newJString(projectId))
  add(query_580555, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580556 = body
  add(query_580555, "prettyPrint", newJBool(prettyPrint))
  add(path_580554, "clusterId", newJString(clusterId))
  add(query_580555, "bearer_token", newJString(bearerToken))
  result = call_580553.call(path_580554, query_580555, nil, nil, body_580556)

var containerProjectsZonesClustersSetNetworkPolicy* = Call_ContainerProjectsZonesClustersSetNetworkPolicy_580532(
    name: "containerProjectsZonesClustersSetNetworkPolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:setNetworkPolicy",
    validator: validate_ContainerProjectsZonesClustersSetNetworkPolicy_580533,
    base: "/", url: url_ContainerProjectsZonesClustersSetNetworkPolicy_580534,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersStartIpRotation_580557 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersStartIpRotation_580559(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: ":startIpRotation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersStartIpRotation_580558(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Start master IP rotation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580560 = path.getOrDefault("zone")
  valid_580560 = validateParameter(valid_580560, JString, required = true,
                                 default = nil)
  if valid_580560 != nil:
    section.add "zone", valid_580560
  var valid_580561 = path.getOrDefault("projectId")
  valid_580561 = validateParameter(valid_580561, JString, required = true,
                                 default = nil)
  if valid_580561 != nil:
    section.add "projectId", valid_580561
  var valid_580562 = path.getOrDefault("clusterId")
  valid_580562 = validateParameter(valid_580562, JString, required = true,
                                 default = nil)
  if valid_580562 != nil:
    section.add "clusterId", valid_580562
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580563 = query.getOrDefault("upload_protocol")
  valid_580563 = validateParameter(valid_580563, JString, required = false,
                                 default = nil)
  if valid_580563 != nil:
    section.add "upload_protocol", valid_580563
  var valid_580564 = query.getOrDefault("fields")
  valid_580564 = validateParameter(valid_580564, JString, required = false,
                                 default = nil)
  if valid_580564 != nil:
    section.add "fields", valid_580564
  var valid_580565 = query.getOrDefault("quotaUser")
  valid_580565 = validateParameter(valid_580565, JString, required = false,
                                 default = nil)
  if valid_580565 != nil:
    section.add "quotaUser", valid_580565
  var valid_580566 = query.getOrDefault("alt")
  valid_580566 = validateParameter(valid_580566, JString, required = false,
                                 default = newJString("json"))
  if valid_580566 != nil:
    section.add "alt", valid_580566
  var valid_580567 = query.getOrDefault("pp")
  valid_580567 = validateParameter(valid_580567, JBool, required = false,
                                 default = newJBool(true))
  if valid_580567 != nil:
    section.add "pp", valid_580567
  var valid_580568 = query.getOrDefault("oauth_token")
  valid_580568 = validateParameter(valid_580568, JString, required = false,
                                 default = nil)
  if valid_580568 != nil:
    section.add "oauth_token", valid_580568
  var valid_580569 = query.getOrDefault("callback")
  valid_580569 = validateParameter(valid_580569, JString, required = false,
                                 default = nil)
  if valid_580569 != nil:
    section.add "callback", valid_580569
  var valid_580570 = query.getOrDefault("access_token")
  valid_580570 = validateParameter(valid_580570, JString, required = false,
                                 default = nil)
  if valid_580570 != nil:
    section.add "access_token", valid_580570
  var valid_580571 = query.getOrDefault("uploadType")
  valid_580571 = validateParameter(valid_580571, JString, required = false,
                                 default = nil)
  if valid_580571 != nil:
    section.add "uploadType", valid_580571
  var valid_580572 = query.getOrDefault("key")
  valid_580572 = validateParameter(valid_580572, JString, required = false,
                                 default = nil)
  if valid_580572 != nil:
    section.add "key", valid_580572
  var valid_580573 = query.getOrDefault("$.xgafv")
  valid_580573 = validateParameter(valid_580573, JString, required = false,
                                 default = newJString("1"))
  if valid_580573 != nil:
    section.add "$.xgafv", valid_580573
  var valid_580574 = query.getOrDefault("prettyPrint")
  valid_580574 = validateParameter(valid_580574, JBool, required = false,
                                 default = newJBool(true))
  if valid_580574 != nil:
    section.add "prettyPrint", valid_580574
  var valid_580575 = query.getOrDefault("bearer_token")
  valid_580575 = validateParameter(valid_580575, JString, required = false,
                                 default = nil)
  if valid_580575 != nil:
    section.add "bearer_token", valid_580575
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

proc call*(call_580577: Call_ContainerProjectsZonesClustersStartIpRotation_580557;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Start master IP rotation.
  ## 
  let valid = call_580577.validator(path, query, header, formData, body)
  let scheme = call_580577.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580577.url(scheme.get, call_580577.host, call_580577.base,
                         call_580577.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580577, url, valid)

proc call*(call_580578: Call_ContainerProjectsZonesClustersStartIpRotation_580557;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesClustersStartIpRotation
  ## Start master IP rotation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580579 = newJObject()
  var query_580580 = newJObject()
  var body_580581 = newJObject()
  add(query_580580, "upload_protocol", newJString(uploadProtocol))
  add(path_580579, "zone", newJString(zone))
  add(query_580580, "fields", newJString(fields))
  add(query_580580, "quotaUser", newJString(quotaUser))
  add(query_580580, "alt", newJString(alt))
  add(query_580580, "pp", newJBool(pp))
  add(query_580580, "oauth_token", newJString(oauthToken))
  add(query_580580, "callback", newJString(callback))
  add(query_580580, "access_token", newJString(accessToken))
  add(query_580580, "uploadType", newJString(uploadType))
  add(query_580580, "key", newJString(key))
  add(path_580579, "projectId", newJString(projectId))
  add(query_580580, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580581 = body
  add(query_580580, "prettyPrint", newJBool(prettyPrint))
  add(path_580579, "clusterId", newJString(clusterId))
  add(query_580580, "bearer_token", newJString(bearerToken))
  result = call_580578.call(path_580579, query_580580, nil, nil, body_580581)

var containerProjectsZonesClustersStartIpRotation* = Call_ContainerProjectsZonesClustersStartIpRotation_580557(
    name: "containerProjectsZonesClustersStartIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:startIpRotation",
    validator: validate_ContainerProjectsZonesClustersStartIpRotation_580558,
    base: "/", url: url_ContainerProjectsZonesClustersStartIpRotation_580559,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesOperationsList_580582 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesOperationsList_580584(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesOperationsList_580583(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all operations in a project in a specific zone or all zones.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine [zone](/compute/docs/zones#available)
  ## to return operations for, or `-` for all zones.
  ## This field is deprecated, use parent instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use parent instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580585 = path.getOrDefault("zone")
  valid_580585 = validateParameter(valid_580585, JString, required = true,
                                 default = nil)
  if valid_580585 != nil:
    section.add "zone", valid_580585
  var valid_580586 = path.getOrDefault("projectId")
  valid_580586 = validateParameter(valid_580586, JString, required = true,
                                 default = nil)
  if valid_580586 != nil:
    section.add "projectId", valid_580586
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent (project and location) where the operations will be listed.
  ## Specified in the format 'projects/*/locations/*'.
  ## Location "-" matches all zones and all regions.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580587 = query.getOrDefault("upload_protocol")
  valid_580587 = validateParameter(valid_580587, JString, required = false,
                                 default = nil)
  if valid_580587 != nil:
    section.add "upload_protocol", valid_580587
  var valid_580588 = query.getOrDefault("fields")
  valid_580588 = validateParameter(valid_580588, JString, required = false,
                                 default = nil)
  if valid_580588 != nil:
    section.add "fields", valid_580588
  var valid_580589 = query.getOrDefault("quotaUser")
  valid_580589 = validateParameter(valid_580589, JString, required = false,
                                 default = nil)
  if valid_580589 != nil:
    section.add "quotaUser", valid_580589
  var valid_580590 = query.getOrDefault("alt")
  valid_580590 = validateParameter(valid_580590, JString, required = false,
                                 default = newJString("json"))
  if valid_580590 != nil:
    section.add "alt", valid_580590
  var valid_580591 = query.getOrDefault("pp")
  valid_580591 = validateParameter(valid_580591, JBool, required = false,
                                 default = newJBool(true))
  if valid_580591 != nil:
    section.add "pp", valid_580591
  var valid_580592 = query.getOrDefault("oauth_token")
  valid_580592 = validateParameter(valid_580592, JString, required = false,
                                 default = nil)
  if valid_580592 != nil:
    section.add "oauth_token", valid_580592
  var valid_580593 = query.getOrDefault("callback")
  valid_580593 = validateParameter(valid_580593, JString, required = false,
                                 default = nil)
  if valid_580593 != nil:
    section.add "callback", valid_580593
  var valid_580594 = query.getOrDefault("access_token")
  valid_580594 = validateParameter(valid_580594, JString, required = false,
                                 default = nil)
  if valid_580594 != nil:
    section.add "access_token", valid_580594
  var valid_580595 = query.getOrDefault("uploadType")
  valid_580595 = validateParameter(valid_580595, JString, required = false,
                                 default = nil)
  if valid_580595 != nil:
    section.add "uploadType", valid_580595
  var valid_580596 = query.getOrDefault("parent")
  valid_580596 = validateParameter(valid_580596, JString, required = false,
                                 default = nil)
  if valid_580596 != nil:
    section.add "parent", valid_580596
  var valid_580597 = query.getOrDefault("key")
  valid_580597 = validateParameter(valid_580597, JString, required = false,
                                 default = nil)
  if valid_580597 != nil:
    section.add "key", valid_580597
  var valid_580598 = query.getOrDefault("$.xgafv")
  valid_580598 = validateParameter(valid_580598, JString, required = false,
                                 default = newJString("1"))
  if valid_580598 != nil:
    section.add "$.xgafv", valid_580598
  var valid_580599 = query.getOrDefault("prettyPrint")
  valid_580599 = validateParameter(valid_580599, JBool, required = false,
                                 default = newJBool(true))
  if valid_580599 != nil:
    section.add "prettyPrint", valid_580599
  var valid_580600 = query.getOrDefault("bearer_token")
  valid_580600 = validateParameter(valid_580600, JString, required = false,
                                 default = nil)
  if valid_580600 != nil:
    section.add "bearer_token", valid_580600
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580601: Call_ContainerProjectsZonesOperationsList_580582;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all operations in a project in a specific zone or all zones.
  ## 
  let valid = call_580601.validator(path, query, header, formData, body)
  let scheme = call_580601.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580601.url(scheme.get, call_580601.host, call_580601.base,
                         call_580601.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580601, url, valid)

proc call*(call_580602: Call_ContainerProjectsZonesOperationsList_580582;
          zone: string; projectId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; parent: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## containerProjectsZonesOperationsList
  ## Lists all operations in a project in a specific zone or all zones.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine [zone](/compute/docs/zones#available)
  ## to return operations for, or `-` for all zones.
  ## This field is deprecated, use parent instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent (project and location) where the operations will be listed.
  ## Specified in the format 'projects/*/locations/*'.
  ## Location "-" matches all zones and all regions.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use parent instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580603 = newJObject()
  var query_580604 = newJObject()
  add(query_580604, "upload_protocol", newJString(uploadProtocol))
  add(path_580603, "zone", newJString(zone))
  add(query_580604, "fields", newJString(fields))
  add(query_580604, "quotaUser", newJString(quotaUser))
  add(query_580604, "alt", newJString(alt))
  add(query_580604, "pp", newJBool(pp))
  add(query_580604, "oauth_token", newJString(oauthToken))
  add(query_580604, "callback", newJString(callback))
  add(query_580604, "access_token", newJString(accessToken))
  add(query_580604, "uploadType", newJString(uploadType))
  add(query_580604, "parent", newJString(parent))
  add(query_580604, "key", newJString(key))
  add(path_580603, "projectId", newJString(projectId))
  add(query_580604, "$.xgafv", newJString(Xgafv))
  add(query_580604, "prettyPrint", newJBool(prettyPrint))
  add(query_580604, "bearer_token", newJString(bearerToken))
  result = call_580602.call(path_580603, query_580604, nil, nil, nil)

var containerProjectsZonesOperationsList* = Call_ContainerProjectsZonesOperationsList_580582(
    name: "containerProjectsZonesOperationsList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1beta1/projects/{projectId}/zones/{zone}/operations",
    validator: validate_ContainerProjectsZonesOperationsList_580583, base: "/",
    url: url_ContainerProjectsZonesOperationsList_580584, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesOperationsGet_580605 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesOperationsGet_580607(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesOperationsGet_580606(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   operationId: JString (required)
  ##              : The server-assigned `name` of the operation.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580608 = path.getOrDefault("zone")
  valid_580608 = validateParameter(valid_580608, JString, required = true,
                                 default = nil)
  if valid_580608 != nil:
    section.add "zone", valid_580608
  var valid_580609 = path.getOrDefault("projectId")
  valid_580609 = validateParameter(valid_580609, JString, required = true,
                                 default = nil)
  if valid_580609 != nil:
    section.add "projectId", valid_580609
  var valid_580610 = path.getOrDefault("operationId")
  valid_580610 = validateParameter(valid_580610, JString, required = true,
                                 default = nil)
  if valid_580610 != nil:
    section.add "operationId", valid_580610
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: JString
  ##       : The name (project, location, operation id) of the operation to get.
  ## Specified in the format 'projects/*/locations/*/operations/*'.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580611 = query.getOrDefault("upload_protocol")
  valid_580611 = validateParameter(valid_580611, JString, required = false,
                                 default = nil)
  if valid_580611 != nil:
    section.add "upload_protocol", valid_580611
  var valid_580612 = query.getOrDefault("fields")
  valid_580612 = validateParameter(valid_580612, JString, required = false,
                                 default = nil)
  if valid_580612 != nil:
    section.add "fields", valid_580612
  var valid_580613 = query.getOrDefault("quotaUser")
  valid_580613 = validateParameter(valid_580613, JString, required = false,
                                 default = nil)
  if valid_580613 != nil:
    section.add "quotaUser", valid_580613
  var valid_580614 = query.getOrDefault("alt")
  valid_580614 = validateParameter(valid_580614, JString, required = false,
                                 default = newJString("json"))
  if valid_580614 != nil:
    section.add "alt", valid_580614
  var valid_580615 = query.getOrDefault("pp")
  valid_580615 = validateParameter(valid_580615, JBool, required = false,
                                 default = newJBool(true))
  if valid_580615 != nil:
    section.add "pp", valid_580615
  var valid_580616 = query.getOrDefault("oauth_token")
  valid_580616 = validateParameter(valid_580616, JString, required = false,
                                 default = nil)
  if valid_580616 != nil:
    section.add "oauth_token", valid_580616
  var valid_580617 = query.getOrDefault("callback")
  valid_580617 = validateParameter(valid_580617, JString, required = false,
                                 default = nil)
  if valid_580617 != nil:
    section.add "callback", valid_580617
  var valid_580618 = query.getOrDefault("access_token")
  valid_580618 = validateParameter(valid_580618, JString, required = false,
                                 default = nil)
  if valid_580618 != nil:
    section.add "access_token", valid_580618
  var valid_580619 = query.getOrDefault("uploadType")
  valid_580619 = validateParameter(valid_580619, JString, required = false,
                                 default = nil)
  if valid_580619 != nil:
    section.add "uploadType", valid_580619
  var valid_580620 = query.getOrDefault("key")
  valid_580620 = validateParameter(valid_580620, JString, required = false,
                                 default = nil)
  if valid_580620 != nil:
    section.add "key", valid_580620
  var valid_580621 = query.getOrDefault("name")
  valid_580621 = validateParameter(valid_580621, JString, required = false,
                                 default = nil)
  if valid_580621 != nil:
    section.add "name", valid_580621
  var valid_580622 = query.getOrDefault("$.xgafv")
  valid_580622 = validateParameter(valid_580622, JString, required = false,
                                 default = newJString("1"))
  if valid_580622 != nil:
    section.add "$.xgafv", valid_580622
  var valid_580623 = query.getOrDefault("prettyPrint")
  valid_580623 = validateParameter(valid_580623, JBool, required = false,
                                 default = newJBool(true))
  if valid_580623 != nil:
    section.add "prettyPrint", valid_580623
  var valid_580624 = query.getOrDefault("bearer_token")
  valid_580624 = validateParameter(valid_580624, JString, required = false,
                                 default = nil)
  if valid_580624 != nil:
    section.add "bearer_token", valid_580624
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580625: Call_ContainerProjectsZonesOperationsGet_580605;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified operation.
  ## 
  let valid = call_580625.validator(path, query, header, formData, body)
  let scheme = call_580625.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580625.url(scheme.get, call_580625.host, call_580625.base,
                         call_580625.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580625, url, valid)

proc call*(call_580626: Call_ContainerProjectsZonesOperationsGet_580605;
          zone: string; projectId: string; operationId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; name: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesOperationsGet
  ## Gets the specified operation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : The name (project, location, operation id) of the operation to get.
  ## Specified in the format 'projects/*/locations/*/operations/*'.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   operationId: string (required)
  ##              : The server-assigned `name` of the operation.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580627 = newJObject()
  var query_580628 = newJObject()
  add(query_580628, "upload_protocol", newJString(uploadProtocol))
  add(path_580627, "zone", newJString(zone))
  add(query_580628, "fields", newJString(fields))
  add(query_580628, "quotaUser", newJString(quotaUser))
  add(query_580628, "alt", newJString(alt))
  add(query_580628, "pp", newJBool(pp))
  add(query_580628, "oauth_token", newJString(oauthToken))
  add(query_580628, "callback", newJString(callback))
  add(query_580628, "access_token", newJString(accessToken))
  add(query_580628, "uploadType", newJString(uploadType))
  add(query_580628, "key", newJString(key))
  add(query_580628, "name", newJString(name))
  add(path_580627, "projectId", newJString(projectId))
  add(query_580628, "$.xgafv", newJString(Xgafv))
  add(query_580628, "prettyPrint", newJBool(prettyPrint))
  add(path_580627, "operationId", newJString(operationId))
  add(query_580628, "bearer_token", newJString(bearerToken))
  result = call_580626.call(path_580627, query_580628, nil, nil, nil)

var containerProjectsZonesOperationsGet* = Call_ContainerProjectsZonesOperationsGet_580605(
    name: "containerProjectsZonesOperationsGet", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/operations/{operationId}",
    validator: validate_ContainerProjectsZonesOperationsGet_580606, base: "/",
    url: url_ContainerProjectsZonesOperationsGet_580607, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesOperationsCancel_580629 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesOperationsCancel_580631(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesOperationsCancel_580630(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels the specified operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the operation resides.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   operationId: JString (required)
  ##              : The server-assigned `name` of the operation.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580632 = path.getOrDefault("zone")
  valid_580632 = validateParameter(valid_580632, JString, required = true,
                                 default = nil)
  if valid_580632 != nil:
    section.add "zone", valid_580632
  var valid_580633 = path.getOrDefault("projectId")
  valid_580633 = validateParameter(valid_580633, JString, required = true,
                                 default = nil)
  if valid_580633 != nil:
    section.add "projectId", valid_580633
  var valid_580634 = path.getOrDefault("operationId")
  valid_580634 = validateParameter(valid_580634, JString, required = true,
                                 default = nil)
  if valid_580634 != nil:
    section.add "operationId", valid_580634
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580635 = query.getOrDefault("upload_protocol")
  valid_580635 = validateParameter(valid_580635, JString, required = false,
                                 default = nil)
  if valid_580635 != nil:
    section.add "upload_protocol", valid_580635
  var valid_580636 = query.getOrDefault("fields")
  valid_580636 = validateParameter(valid_580636, JString, required = false,
                                 default = nil)
  if valid_580636 != nil:
    section.add "fields", valid_580636
  var valid_580637 = query.getOrDefault("quotaUser")
  valid_580637 = validateParameter(valid_580637, JString, required = false,
                                 default = nil)
  if valid_580637 != nil:
    section.add "quotaUser", valid_580637
  var valid_580638 = query.getOrDefault("alt")
  valid_580638 = validateParameter(valid_580638, JString, required = false,
                                 default = newJString("json"))
  if valid_580638 != nil:
    section.add "alt", valid_580638
  var valid_580639 = query.getOrDefault("pp")
  valid_580639 = validateParameter(valid_580639, JBool, required = false,
                                 default = newJBool(true))
  if valid_580639 != nil:
    section.add "pp", valid_580639
  var valid_580640 = query.getOrDefault("oauth_token")
  valid_580640 = validateParameter(valid_580640, JString, required = false,
                                 default = nil)
  if valid_580640 != nil:
    section.add "oauth_token", valid_580640
  var valid_580641 = query.getOrDefault("callback")
  valid_580641 = validateParameter(valid_580641, JString, required = false,
                                 default = nil)
  if valid_580641 != nil:
    section.add "callback", valid_580641
  var valid_580642 = query.getOrDefault("access_token")
  valid_580642 = validateParameter(valid_580642, JString, required = false,
                                 default = nil)
  if valid_580642 != nil:
    section.add "access_token", valid_580642
  var valid_580643 = query.getOrDefault("uploadType")
  valid_580643 = validateParameter(valid_580643, JString, required = false,
                                 default = nil)
  if valid_580643 != nil:
    section.add "uploadType", valid_580643
  var valid_580644 = query.getOrDefault("key")
  valid_580644 = validateParameter(valid_580644, JString, required = false,
                                 default = nil)
  if valid_580644 != nil:
    section.add "key", valid_580644
  var valid_580645 = query.getOrDefault("$.xgafv")
  valid_580645 = validateParameter(valid_580645, JString, required = false,
                                 default = newJString("1"))
  if valid_580645 != nil:
    section.add "$.xgafv", valid_580645
  var valid_580646 = query.getOrDefault("prettyPrint")
  valid_580646 = validateParameter(valid_580646, JBool, required = false,
                                 default = newJBool(true))
  if valid_580646 != nil:
    section.add "prettyPrint", valid_580646
  var valid_580647 = query.getOrDefault("bearer_token")
  valid_580647 = validateParameter(valid_580647, JString, required = false,
                                 default = nil)
  if valid_580647 != nil:
    section.add "bearer_token", valid_580647
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

proc call*(call_580649: Call_ContainerProjectsZonesOperationsCancel_580629;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels the specified operation.
  ## 
  let valid = call_580649.validator(path, query, header, formData, body)
  let scheme = call_580649.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580649.url(scheme.get, call_580649.host, call_580649.base,
                         call_580649.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580649, url, valid)

proc call*(call_580650: Call_ContainerProjectsZonesOperationsCancel_580629;
          zone: string; projectId: string; operationId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsZonesOperationsCancel
  ## Cancels the specified operation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the operation resides.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   operationId: string (required)
  ##              : The server-assigned `name` of the operation.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580651 = newJObject()
  var query_580652 = newJObject()
  var body_580653 = newJObject()
  add(query_580652, "upload_protocol", newJString(uploadProtocol))
  add(path_580651, "zone", newJString(zone))
  add(query_580652, "fields", newJString(fields))
  add(query_580652, "quotaUser", newJString(quotaUser))
  add(query_580652, "alt", newJString(alt))
  add(query_580652, "pp", newJBool(pp))
  add(query_580652, "oauth_token", newJString(oauthToken))
  add(query_580652, "callback", newJString(callback))
  add(query_580652, "access_token", newJString(accessToken))
  add(query_580652, "uploadType", newJString(uploadType))
  add(query_580652, "key", newJString(key))
  add(path_580651, "projectId", newJString(projectId))
  add(query_580652, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580653 = body
  add(query_580652, "prettyPrint", newJBool(prettyPrint))
  add(path_580651, "operationId", newJString(operationId))
  add(query_580652, "bearer_token", newJString(bearerToken))
  result = call_580650.call(path_580651, query_580652, nil, nil, body_580653)

var containerProjectsZonesOperationsCancel* = Call_ContainerProjectsZonesOperationsCancel_580629(
    name: "containerProjectsZonesOperationsCancel", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/operations/{operationId}:cancel",
    validator: validate_ContainerProjectsZonesOperationsCancel_580630, base: "/",
    url: url_ContainerProjectsZonesOperationsCancel_580631,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesGetServerconfig_580654 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesGetServerconfig_580656(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/serverconfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesGetServerconfig_580655(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns configuration info about the Container Engine service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine [zone](/compute/docs/zones#available)
  ## to return operations for.
  ## This field is deprecated, use name instead.
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580657 = path.getOrDefault("zone")
  valid_580657 = validateParameter(valid_580657, JString, required = true,
                                 default = nil)
  if valid_580657 != nil:
    section.add "zone", valid_580657
  var valid_580658 = path.getOrDefault("projectId")
  valid_580658 = validateParameter(valid_580658, JString, required = true,
                                 default = nil)
  if valid_580658 != nil:
    section.add "projectId", valid_580658
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: JString
  ##       : The name (project and location) of the server config to get
  ## Specified in the format 'projects/*/locations/*'.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580659 = query.getOrDefault("upload_protocol")
  valid_580659 = validateParameter(valid_580659, JString, required = false,
                                 default = nil)
  if valid_580659 != nil:
    section.add "upload_protocol", valid_580659
  var valid_580660 = query.getOrDefault("fields")
  valid_580660 = validateParameter(valid_580660, JString, required = false,
                                 default = nil)
  if valid_580660 != nil:
    section.add "fields", valid_580660
  var valid_580661 = query.getOrDefault("quotaUser")
  valid_580661 = validateParameter(valid_580661, JString, required = false,
                                 default = nil)
  if valid_580661 != nil:
    section.add "quotaUser", valid_580661
  var valid_580662 = query.getOrDefault("alt")
  valid_580662 = validateParameter(valid_580662, JString, required = false,
                                 default = newJString("json"))
  if valid_580662 != nil:
    section.add "alt", valid_580662
  var valid_580663 = query.getOrDefault("pp")
  valid_580663 = validateParameter(valid_580663, JBool, required = false,
                                 default = newJBool(true))
  if valid_580663 != nil:
    section.add "pp", valid_580663
  var valid_580664 = query.getOrDefault("oauth_token")
  valid_580664 = validateParameter(valid_580664, JString, required = false,
                                 default = nil)
  if valid_580664 != nil:
    section.add "oauth_token", valid_580664
  var valid_580665 = query.getOrDefault("callback")
  valid_580665 = validateParameter(valid_580665, JString, required = false,
                                 default = nil)
  if valid_580665 != nil:
    section.add "callback", valid_580665
  var valid_580666 = query.getOrDefault("access_token")
  valid_580666 = validateParameter(valid_580666, JString, required = false,
                                 default = nil)
  if valid_580666 != nil:
    section.add "access_token", valid_580666
  var valid_580667 = query.getOrDefault("uploadType")
  valid_580667 = validateParameter(valid_580667, JString, required = false,
                                 default = nil)
  if valid_580667 != nil:
    section.add "uploadType", valid_580667
  var valid_580668 = query.getOrDefault("key")
  valid_580668 = validateParameter(valid_580668, JString, required = false,
                                 default = nil)
  if valid_580668 != nil:
    section.add "key", valid_580668
  var valid_580669 = query.getOrDefault("name")
  valid_580669 = validateParameter(valid_580669, JString, required = false,
                                 default = nil)
  if valid_580669 != nil:
    section.add "name", valid_580669
  var valid_580670 = query.getOrDefault("$.xgafv")
  valid_580670 = validateParameter(valid_580670, JString, required = false,
                                 default = newJString("1"))
  if valid_580670 != nil:
    section.add "$.xgafv", valid_580670
  var valid_580671 = query.getOrDefault("prettyPrint")
  valid_580671 = validateParameter(valid_580671, JBool, required = false,
                                 default = newJBool(true))
  if valid_580671 != nil:
    section.add "prettyPrint", valid_580671
  var valid_580672 = query.getOrDefault("bearer_token")
  valid_580672 = validateParameter(valid_580672, JString, required = false,
                                 default = nil)
  if valid_580672 != nil:
    section.add "bearer_token", valid_580672
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580673: Call_ContainerProjectsZonesGetServerconfig_580654;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns configuration info about the Container Engine service.
  ## 
  let valid = call_580673.validator(path, query, header, formData, body)
  let scheme = call_580673.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580673.url(scheme.get, call_580673.host, call_580673.base,
                         call_580673.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580673, url, valid)

proc call*(call_580674: Call_ContainerProjectsZonesGetServerconfig_580654;
          zone: string; projectId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          name: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## containerProjectsZonesGetServerconfig
  ## Returns configuration info about the Container Engine service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine [zone](/compute/docs/zones#available)
  ## to return operations for.
  ## This field is deprecated, use name instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : The name (project and location) of the server config to get
  ## Specified in the format 'projects/*/locations/*'.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580675 = newJObject()
  var query_580676 = newJObject()
  add(query_580676, "upload_protocol", newJString(uploadProtocol))
  add(path_580675, "zone", newJString(zone))
  add(query_580676, "fields", newJString(fields))
  add(query_580676, "quotaUser", newJString(quotaUser))
  add(query_580676, "alt", newJString(alt))
  add(query_580676, "pp", newJBool(pp))
  add(query_580676, "oauth_token", newJString(oauthToken))
  add(query_580676, "callback", newJString(callback))
  add(query_580676, "access_token", newJString(accessToken))
  add(query_580676, "uploadType", newJString(uploadType))
  add(query_580676, "key", newJString(key))
  add(query_580676, "name", newJString(name))
  add(path_580675, "projectId", newJString(projectId))
  add(query_580676, "$.xgafv", newJString(Xgafv))
  add(query_580676, "prettyPrint", newJBool(prettyPrint))
  add(query_580676, "bearer_token", newJString(bearerToken))
  result = call_580674.call(path_580675, query_580676, nil, nil, nil)

var containerProjectsZonesGetServerconfig* = Call_ContainerProjectsZonesGetServerconfig_580654(
    name: "containerProjectsZonesGetServerconfig", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1beta1/projects/{projectId}/zones/{zone}/serverconfig",
    validator: validate_ContainerProjectsZonesGetServerconfig_580655, base: "/",
    url: url_ContainerProjectsZonesGetServerconfig_580656, schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsUpdate_580702 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersNodePoolsUpdate_580704(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsUpdate_580703(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates the version and/or iamge type of a specific node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster, node pool) of the node pool to update.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580705 = path.getOrDefault("name")
  valid_580705 = validateParameter(valid_580705, JString, required = true,
                                 default = nil)
  if valid_580705 != nil:
    section.add "name", valid_580705
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580706 = query.getOrDefault("upload_protocol")
  valid_580706 = validateParameter(valid_580706, JString, required = false,
                                 default = nil)
  if valid_580706 != nil:
    section.add "upload_protocol", valid_580706
  var valid_580707 = query.getOrDefault("fields")
  valid_580707 = validateParameter(valid_580707, JString, required = false,
                                 default = nil)
  if valid_580707 != nil:
    section.add "fields", valid_580707
  var valid_580708 = query.getOrDefault("quotaUser")
  valid_580708 = validateParameter(valid_580708, JString, required = false,
                                 default = nil)
  if valid_580708 != nil:
    section.add "quotaUser", valid_580708
  var valid_580709 = query.getOrDefault("alt")
  valid_580709 = validateParameter(valid_580709, JString, required = false,
                                 default = newJString("json"))
  if valid_580709 != nil:
    section.add "alt", valid_580709
  var valid_580710 = query.getOrDefault("pp")
  valid_580710 = validateParameter(valid_580710, JBool, required = false,
                                 default = newJBool(true))
  if valid_580710 != nil:
    section.add "pp", valid_580710
  var valid_580711 = query.getOrDefault("oauth_token")
  valid_580711 = validateParameter(valid_580711, JString, required = false,
                                 default = nil)
  if valid_580711 != nil:
    section.add "oauth_token", valid_580711
  var valid_580712 = query.getOrDefault("callback")
  valid_580712 = validateParameter(valid_580712, JString, required = false,
                                 default = nil)
  if valid_580712 != nil:
    section.add "callback", valid_580712
  var valid_580713 = query.getOrDefault("access_token")
  valid_580713 = validateParameter(valid_580713, JString, required = false,
                                 default = nil)
  if valid_580713 != nil:
    section.add "access_token", valid_580713
  var valid_580714 = query.getOrDefault("uploadType")
  valid_580714 = validateParameter(valid_580714, JString, required = false,
                                 default = nil)
  if valid_580714 != nil:
    section.add "uploadType", valid_580714
  var valid_580715 = query.getOrDefault("key")
  valid_580715 = validateParameter(valid_580715, JString, required = false,
                                 default = nil)
  if valid_580715 != nil:
    section.add "key", valid_580715
  var valid_580716 = query.getOrDefault("$.xgafv")
  valid_580716 = validateParameter(valid_580716, JString, required = false,
                                 default = newJString("1"))
  if valid_580716 != nil:
    section.add "$.xgafv", valid_580716
  var valid_580717 = query.getOrDefault("prettyPrint")
  valid_580717 = validateParameter(valid_580717, JBool, required = false,
                                 default = newJBool(true))
  if valid_580717 != nil:
    section.add "prettyPrint", valid_580717
  var valid_580718 = query.getOrDefault("bearer_token")
  valid_580718 = validateParameter(valid_580718, JString, required = false,
                                 default = nil)
  if valid_580718 != nil:
    section.add "bearer_token", valid_580718
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

proc call*(call_580720: Call_ContainerProjectsLocationsClustersNodePoolsUpdate_580702;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the version and/or iamge type of a specific node pool.
  ## 
  let valid = call_580720.validator(path, query, header, formData, body)
  let scheme = call_580720.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580720.url(scheme.get, call_580720.host, call_580720.base,
                         call_580720.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580720, url, valid)

proc call*(call_580721: Call_ContainerProjectsLocationsClustersNodePoolsUpdate_580702;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsUpdate
  ## Updates the version and/or iamge type of a specific node pool.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster, node pool) of the node pool to update.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580722 = newJObject()
  var query_580723 = newJObject()
  var body_580724 = newJObject()
  add(query_580723, "upload_protocol", newJString(uploadProtocol))
  add(query_580723, "fields", newJString(fields))
  add(query_580723, "quotaUser", newJString(quotaUser))
  add(path_580722, "name", newJString(name))
  add(query_580723, "alt", newJString(alt))
  add(query_580723, "pp", newJBool(pp))
  add(query_580723, "oauth_token", newJString(oauthToken))
  add(query_580723, "callback", newJString(callback))
  add(query_580723, "access_token", newJString(accessToken))
  add(query_580723, "uploadType", newJString(uploadType))
  add(query_580723, "key", newJString(key))
  add(query_580723, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580724 = body
  add(query_580723, "prettyPrint", newJBool(prettyPrint))
  add(query_580723, "bearer_token", newJString(bearerToken))
  result = call_580721.call(path_580722, query_580723, nil, nil, body_580724)

var containerProjectsLocationsClustersNodePoolsUpdate* = Call_ContainerProjectsLocationsClustersNodePoolsUpdate_580702(
    name: "containerProjectsLocationsClustersNodePoolsUpdate",
    meth: HttpMethod.HttpPut, host: "container.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsUpdate_580703,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsUpdate_580704,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsGet_580677 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersNodePoolsGet_580679(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsGet_580678(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieves the node pool requested.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster, node pool id) of the node pool to get.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580680 = path.getOrDefault("name")
  valid_580680 = validateParameter(valid_580680, JString, required = true,
                                 default = nil)
  if valid_580680 != nil:
    section.add "name", valid_580680
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: JString
  ##             : The name of the node pool.
  ## This field is deprecated, use name instead.
  ##   zone: JString
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: JString
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580681 = query.getOrDefault("upload_protocol")
  valid_580681 = validateParameter(valid_580681, JString, required = false,
                                 default = nil)
  if valid_580681 != nil:
    section.add "upload_protocol", valid_580681
  var valid_580682 = query.getOrDefault("fields")
  valid_580682 = validateParameter(valid_580682, JString, required = false,
                                 default = nil)
  if valid_580682 != nil:
    section.add "fields", valid_580682
  var valid_580683 = query.getOrDefault("quotaUser")
  valid_580683 = validateParameter(valid_580683, JString, required = false,
                                 default = nil)
  if valid_580683 != nil:
    section.add "quotaUser", valid_580683
  var valid_580684 = query.getOrDefault("alt")
  valid_580684 = validateParameter(valid_580684, JString, required = false,
                                 default = newJString("json"))
  if valid_580684 != nil:
    section.add "alt", valid_580684
  var valid_580685 = query.getOrDefault("pp")
  valid_580685 = validateParameter(valid_580685, JBool, required = false,
                                 default = newJBool(true))
  if valid_580685 != nil:
    section.add "pp", valid_580685
  var valid_580686 = query.getOrDefault("oauth_token")
  valid_580686 = validateParameter(valid_580686, JString, required = false,
                                 default = nil)
  if valid_580686 != nil:
    section.add "oauth_token", valid_580686
  var valid_580687 = query.getOrDefault("callback")
  valid_580687 = validateParameter(valid_580687, JString, required = false,
                                 default = nil)
  if valid_580687 != nil:
    section.add "callback", valid_580687
  var valid_580688 = query.getOrDefault("access_token")
  valid_580688 = validateParameter(valid_580688, JString, required = false,
                                 default = nil)
  if valid_580688 != nil:
    section.add "access_token", valid_580688
  var valid_580689 = query.getOrDefault("uploadType")
  valid_580689 = validateParameter(valid_580689, JString, required = false,
                                 default = nil)
  if valid_580689 != nil:
    section.add "uploadType", valid_580689
  var valid_580690 = query.getOrDefault("nodePoolId")
  valid_580690 = validateParameter(valid_580690, JString, required = false,
                                 default = nil)
  if valid_580690 != nil:
    section.add "nodePoolId", valid_580690
  var valid_580691 = query.getOrDefault("zone")
  valid_580691 = validateParameter(valid_580691, JString, required = false,
                                 default = nil)
  if valid_580691 != nil:
    section.add "zone", valid_580691
  var valid_580692 = query.getOrDefault("key")
  valid_580692 = validateParameter(valid_580692, JString, required = false,
                                 default = nil)
  if valid_580692 != nil:
    section.add "key", valid_580692
  var valid_580693 = query.getOrDefault("$.xgafv")
  valid_580693 = validateParameter(valid_580693, JString, required = false,
                                 default = newJString("1"))
  if valid_580693 != nil:
    section.add "$.xgafv", valid_580693
  var valid_580694 = query.getOrDefault("projectId")
  valid_580694 = validateParameter(valid_580694, JString, required = false,
                                 default = nil)
  if valid_580694 != nil:
    section.add "projectId", valid_580694
  var valid_580695 = query.getOrDefault("prettyPrint")
  valid_580695 = validateParameter(valid_580695, JBool, required = false,
                                 default = newJBool(true))
  if valid_580695 != nil:
    section.add "prettyPrint", valid_580695
  var valid_580696 = query.getOrDefault("clusterId")
  valid_580696 = validateParameter(valid_580696, JString, required = false,
                                 default = nil)
  if valid_580696 != nil:
    section.add "clusterId", valid_580696
  var valid_580697 = query.getOrDefault("bearer_token")
  valid_580697 = validateParameter(valid_580697, JString, required = false,
                                 default = nil)
  if valid_580697 != nil:
    section.add "bearer_token", valid_580697
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580698: Call_ContainerProjectsLocationsClustersNodePoolsGet_580677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the node pool requested.
  ## 
  let valid = call_580698.validator(path, query, header, formData, body)
  let scheme = call_580698.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580698.url(scheme.get, call_580698.host, call_580698.base,
                         call_580698.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580698, url, valid)

proc call*(call_580699: Call_ContainerProjectsLocationsClustersNodePoolsGet_580677;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; nodePoolId: string = ""; zone: string = "";
          key: string = ""; Xgafv: string = "1"; projectId: string = "";
          prettyPrint: bool = true; clusterId: string = ""; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsGet
  ## Retrieves the node pool requested.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster, node pool id) of the node pool to get.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: string
  ##             : The name of the node pool.
  ## This field is deprecated, use name instead.
  ##   zone: string
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580700 = newJObject()
  var query_580701 = newJObject()
  add(query_580701, "upload_protocol", newJString(uploadProtocol))
  add(query_580701, "fields", newJString(fields))
  add(query_580701, "quotaUser", newJString(quotaUser))
  add(path_580700, "name", newJString(name))
  add(query_580701, "alt", newJString(alt))
  add(query_580701, "pp", newJBool(pp))
  add(query_580701, "oauth_token", newJString(oauthToken))
  add(query_580701, "callback", newJString(callback))
  add(query_580701, "access_token", newJString(accessToken))
  add(query_580701, "uploadType", newJString(uploadType))
  add(query_580701, "nodePoolId", newJString(nodePoolId))
  add(query_580701, "zone", newJString(zone))
  add(query_580701, "key", newJString(key))
  add(query_580701, "$.xgafv", newJString(Xgafv))
  add(query_580701, "projectId", newJString(projectId))
  add(query_580701, "prettyPrint", newJBool(prettyPrint))
  add(query_580701, "clusterId", newJString(clusterId))
  add(query_580701, "bearer_token", newJString(bearerToken))
  result = call_580699.call(path_580700, query_580701, nil, nil, nil)

var containerProjectsLocationsClustersNodePoolsGet* = Call_ContainerProjectsLocationsClustersNodePoolsGet_580677(
    name: "containerProjectsLocationsClustersNodePoolsGet",
    meth: HttpMethod.HttpGet, host: "container.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsGet_580678,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsGet_580679,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsDelete_580725 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersNodePoolsDelete_580727(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsDelete_580726(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes a node pool from a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster, node pool id) of the node pool to delete.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580728 = path.getOrDefault("name")
  valid_580728 = validateParameter(valid_580728, JString, required = true,
                                 default = nil)
  if valid_580728 != nil:
    section.add "name", valid_580728
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: JString
  ##             : The name of the node pool to delete.
  ## This field is deprecated, use name instead.
  ##   zone: JString
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: JString
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580729 = query.getOrDefault("upload_protocol")
  valid_580729 = validateParameter(valid_580729, JString, required = false,
                                 default = nil)
  if valid_580729 != nil:
    section.add "upload_protocol", valid_580729
  var valid_580730 = query.getOrDefault("fields")
  valid_580730 = validateParameter(valid_580730, JString, required = false,
                                 default = nil)
  if valid_580730 != nil:
    section.add "fields", valid_580730
  var valid_580731 = query.getOrDefault("quotaUser")
  valid_580731 = validateParameter(valid_580731, JString, required = false,
                                 default = nil)
  if valid_580731 != nil:
    section.add "quotaUser", valid_580731
  var valid_580732 = query.getOrDefault("alt")
  valid_580732 = validateParameter(valid_580732, JString, required = false,
                                 default = newJString("json"))
  if valid_580732 != nil:
    section.add "alt", valid_580732
  var valid_580733 = query.getOrDefault("pp")
  valid_580733 = validateParameter(valid_580733, JBool, required = false,
                                 default = newJBool(true))
  if valid_580733 != nil:
    section.add "pp", valid_580733
  var valid_580734 = query.getOrDefault("oauth_token")
  valid_580734 = validateParameter(valid_580734, JString, required = false,
                                 default = nil)
  if valid_580734 != nil:
    section.add "oauth_token", valid_580734
  var valid_580735 = query.getOrDefault("callback")
  valid_580735 = validateParameter(valid_580735, JString, required = false,
                                 default = nil)
  if valid_580735 != nil:
    section.add "callback", valid_580735
  var valid_580736 = query.getOrDefault("access_token")
  valid_580736 = validateParameter(valid_580736, JString, required = false,
                                 default = nil)
  if valid_580736 != nil:
    section.add "access_token", valid_580736
  var valid_580737 = query.getOrDefault("uploadType")
  valid_580737 = validateParameter(valid_580737, JString, required = false,
                                 default = nil)
  if valid_580737 != nil:
    section.add "uploadType", valid_580737
  var valid_580738 = query.getOrDefault("nodePoolId")
  valid_580738 = validateParameter(valid_580738, JString, required = false,
                                 default = nil)
  if valid_580738 != nil:
    section.add "nodePoolId", valid_580738
  var valid_580739 = query.getOrDefault("zone")
  valid_580739 = validateParameter(valid_580739, JString, required = false,
                                 default = nil)
  if valid_580739 != nil:
    section.add "zone", valid_580739
  var valid_580740 = query.getOrDefault("key")
  valid_580740 = validateParameter(valid_580740, JString, required = false,
                                 default = nil)
  if valid_580740 != nil:
    section.add "key", valid_580740
  var valid_580741 = query.getOrDefault("$.xgafv")
  valid_580741 = validateParameter(valid_580741, JString, required = false,
                                 default = newJString("1"))
  if valid_580741 != nil:
    section.add "$.xgafv", valid_580741
  var valid_580742 = query.getOrDefault("projectId")
  valid_580742 = validateParameter(valid_580742, JString, required = false,
                                 default = nil)
  if valid_580742 != nil:
    section.add "projectId", valid_580742
  var valid_580743 = query.getOrDefault("prettyPrint")
  valid_580743 = validateParameter(valid_580743, JBool, required = false,
                                 default = newJBool(true))
  if valid_580743 != nil:
    section.add "prettyPrint", valid_580743
  var valid_580744 = query.getOrDefault("clusterId")
  valid_580744 = validateParameter(valid_580744, JString, required = false,
                                 default = nil)
  if valid_580744 != nil:
    section.add "clusterId", valid_580744
  var valid_580745 = query.getOrDefault("bearer_token")
  valid_580745 = validateParameter(valid_580745, JString, required = false,
                                 default = nil)
  if valid_580745 != nil:
    section.add "bearer_token", valid_580745
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580746: Call_ContainerProjectsLocationsClustersNodePoolsDelete_580725;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a node pool from a cluster.
  ## 
  let valid = call_580746.validator(path, query, header, formData, body)
  let scheme = call_580746.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580746.url(scheme.get, call_580746.host, call_580746.base,
                         call_580746.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580746, url, valid)

proc call*(call_580747: Call_ContainerProjectsLocationsClustersNodePoolsDelete_580725;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; nodePoolId: string = ""; zone: string = "";
          key: string = ""; Xgafv: string = "1"; projectId: string = "";
          prettyPrint: bool = true; clusterId: string = ""; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsDelete
  ## Deletes a node pool from a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster, node pool id) of the node pool to delete.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: string
  ##             : The name of the node pool to delete.
  ## This field is deprecated, use name instead.
  ##   zone: string
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580748 = newJObject()
  var query_580749 = newJObject()
  add(query_580749, "upload_protocol", newJString(uploadProtocol))
  add(query_580749, "fields", newJString(fields))
  add(query_580749, "quotaUser", newJString(quotaUser))
  add(path_580748, "name", newJString(name))
  add(query_580749, "alt", newJString(alt))
  add(query_580749, "pp", newJBool(pp))
  add(query_580749, "oauth_token", newJString(oauthToken))
  add(query_580749, "callback", newJString(callback))
  add(query_580749, "access_token", newJString(accessToken))
  add(query_580749, "uploadType", newJString(uploadType))
  add(query_580749, "nodePoolId", newJString(nodePoolId))
  add(query_580749, "zone", newJString(zone))
  add(query_580749, "key", newJString(key))
  add(query_580749, "$.xgafv", newJString(Xgafv))
  add(query_580749, "projectId", newJString(projectId))
  add(query_580749, "prettyPrint", newJBool(prettyPrint))
  add(query_580749, "clusterId", newJString(clusterId))
  add(query_580749, "bearer_token", newJString(bearerToken))
  result = call_580747.call(path_580748, query_580749, nil, nil, nil)

var containerProjectsLocationsClustersNodePoolsDelete* = Call_ContainerProjectsLocationsClustersNodePoolsDelete_580725(
    name: "containerProjectsLocationsClustersNodePoolsDelete",
    meth: HttpMethod.HttpDelete, host: "container.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsDelete_580726,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsDelete_580727,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsGetServerConfig_580750 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsGetServerConfig_580752(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/serverConfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsGetServerConfig_580751(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns configuration info about the Container Engine service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project and location) of the server config to get
  ## Specified in the format 'projects/*/locations/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580753 = path.getOrDefault("name")
  valid_580753 = validateParameter(valid_580753, JString, required = true,
                                 default = nil)
  if valid_580753 != nil:
    section.add "name", valid_580753
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   zone: JString
  ##       : The name of the Google Compute Engine [zone](/compute/docs/zones#available)
  ## to return operations for.
  ## This field is deprecated, use name instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580754 = query.getOrDefault("upload_protocol")
  valid_580754 = validateParameter(valid_580754, JString, required = false,
                                 default = nil)
  if valid_580754 != nil:
    section.add "upload_protocol", valid_580754
  var valid_580755 = query.getOrDefault("fields")
  valid_580755 = validateParameter(valid_580755, JString, required = false,
                                 default = nil)
  if valid_580755 != nil:
    section.add "fields", valid_580755
  var valid_580756 = query.getOrDefault("quotaUser")
  valid_580756 = validateParameter(valid_580756, JString, required = false,
                                 default = nil)
  if valid_580756 != nil:
    section.add "quotaUser", valid_580756
  var valid_580757 = query.getOrDefault("alt")
  valid_580757 = validateParameter(valid_580757, JString, required = false,
                                 default = newJString("json"))
  if valid_580757 != nil:
    section.add "alt", valid_580757
  var valid_580758 = query.getOrDefault("pp")
  valid_580758 = validateParameter(valid_580758, JBool, required = false,
                                 default = newJBool(true))
  if valid_580758 != nil:
    section.add "pp", valid_580758
  var valid_580759 = query.getOrDefault("oauth_token")
  valid_580759 = validateParameter(valid_580759, JString, required = false,
                                 default = nil)
  if valid_580759 != nil:
    section.add "oauth_token", valid_580759
  var valid_580760 = query.getOrDefault("callback")
  valid_580760 = validateParameter(valid_580760, JString, required = false,
                                 default = nil)
  if valid_580760 != nil:
    section.add "callback", valid_580760
  var valid_580761 = query.getOrDefault("access_token")
  valid_580761 = validateParameter(valid_580761, JString, required = false,
                                 default = nil)
  if valid_580761 != nil:
    section.add "access_token", valid_580761
  var valid_580762 = query.getOrDefault("uploadType")
  valid_580762 = validateParameter(valid_580762, JString, required = false,
                                 default = nil)
  if valid_580762 != nil:
    section.add "uploadType", valid_580762
  var valid_580763 = query.getOrDefault("zone")
  valid_580763 = validateParameter(valid_580763, JString, required = false,
                                 default = nil)
  if valid_580763 != nil:
    section.add "zone", valid_580763
  var valid_580764 = query.getOrDefault("key")
  valid_580764 = validateParameter(valid_580764, JString, required = false,
                                 default = nil)
  if valid_580764 != nil:
    section.add "key", valid_580764
  var valid_580765 = query.getOrDefault("$.xgafv")
  valid_580765 = validateParameter(valid_580765, JString, required = false,
                                 default = newJString("1"))
  if valid_580765 != nil:
    section.add "$.xgafv", valid_580765
  var valid_580766 = query.getOrDefault("projectId")
  valid_580766 = validateParameter(valid_580766, JString, required = false,
                                 default = nil)
  if valid_580766 != nil:
    section.add "projectId", valid_580766
  var valid_580767 = query.getOrDefault("prettyPrint")
  valid_580767 = validateParameter(valid_580767, JBool, required = false,
                                 default = newJBool(true))
  if valid_580767 != nil:
    section.add "prettyPrint", valid_580767
  var valid_580768 = query.getOrDefault("bearer_token")
  valid_580768 = validateParameter(valid_580768, JString, required = false,
                                 default = nil)
  if valid_580768 != nil:
    section.add "bearer_token", valid_580768
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580769: Call_ContainerProjectsLocationsGetServerConfig_580750;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns configuration info about the Container Engine service.
  ## 
  let valid = call_580769.validator(path, query, header, formData, body)
  let scheme = call_580769.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580769.url(scheme.get, call_580769.host, call_580769.base,
                         call_580769.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580769, url, valid)

proc call*(call_580770: Call_ContainerProjectsLocationsGetServerConfig_580750;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; zone: string = ""; key: string = ""; Xgafv: string = "1";
          projectId: string = ""; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsGetServerConfig
  ## Returns configuration info about the Container Engine service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project and location) of the server config to get
  ## Specified in the format 'projects/*/locations/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   zone: string
  ##       : The name of the Google Compute Engine [zone](/compute/docs/zones#available)
  ## to return operations for.
  ## This field is deprecated, use name instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580771 = newJObject()
  var query_580772 = newJObject()
  add(query_580772, "upload_protocol", newJString(uploadProtocol))
  add(query_580772, "fields", newJString(fields))
  add(query_580772, "quotaUser", newJString(quotaUser))
  add(path_580771, "name", newJString(name))
  add(query_580772, "alt", newJString(alt))
  add(query_580772, "pp", newJBool(pp))
  add(query_580772, "oauth_token", newJString(oauthToken))
  add(query_580772, "callback", newJString(callback))
  add(query_580772, "access_token", newJString(accessToken))
  add(query_580772, "uploadType", newJString(uploadType))
  add(query_580772, "zone", newJString(zone))
  add(query_580772, "key", newJString(key))
  add(query_580772, "$.xgafv", newJString(Xgafv))
  add(query_580772, "projectId", newJString(projectId))
  add(query_580772, "prettyPrint", newJBool(prettyPrint))
  add(query_580772, "bearer_token", newJString(bearerToken))
  result = call_580770.call(path_580771, query_580772, nil, nil, nil)

var containerProjectsLocationsGetServerConfig* = Call_ContainerProjectsLocationsGetServerConfig_580750(
    name: "containerProjectsLocationsGetServerConfig", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1beta1/{name}/serverConfig",
    validator: validate_ContainerProjectsLocationsGetServerConfig_580751,
    base: "/", url: url_ContainerProjectsLocationsGetServerConfig_580752,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsOperationsCancel_580773 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsOperationsCancel_580775(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsOperationsCancel_580774(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels the specified operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, operation id) of the operation to cancel.
  ## Specified in the format 'projects/*/locations/*/operations/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580776 = path.getOrDefault("name")
  valid_580776 = validateParameter(valid_580776, JString, required = true,
                                 default = nil)
  if valid_580776 != nil:
    section.add "name", valid_580776
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580777 = query.getOrDefault("upload_protocol")
  valid_580777 = validateParameter(valid_580777, JString, required = false,
                                 default = nil)
  if valid_580777 != nil:
    section.add "upload_protocol", valid_580777
  var valid_580778 = query.getOrDefault("fields")
  valid_580778 = validateParameter(valid_580778, JString, required = false,
                                 default = nil)
  if valid_580778 != nil:
    section.add "fields", valid_580778
  var valid_580779 = query.getOrDefault("quotaUser")
  valid_580779 = validateParameter(valid_580779, JString, required = false,
                                 default = nil)
  if valid_580779 != nil:
    section.add "quotaUser", valid_580779
  var valid_580780 = query.getOrDefault("alt")
  valid_580780 = validateParameter(valid_580780, JString, required = false,
                                 default = newJString("json"))
  if valid_580780 != nil:
    section.add "alt", valid_580780
  var valid_580781 = query.getOrDefault("pp")
  valid_580781 = validateParameter(valid_580781, JBool, required = false,
                                 default = newJBool(true))
  if valid_580781 != nil:
    section.add "pp", valid_580781
  var valid_580782 = query.getOrDefault("oauth_token")
  valid_580782 = validateParameter(valid_580782, JString, required = false,
                                 default = nil)
  if valid_580782 != nil:
    section.add "oauth_token", valid_580782
  var valid_580783 = query.getOrDefault("callback")
  valid_580783 = validateParameter(valid_580783, JString, required = false,
                                 default = nil)
  if valid_580783 != nil:
    section.add "callback", valid_580783
  var valid_580784 = query.getOrDefault("access_token")
  valid_580784 = validateParameter(valid_580784, JString, required = false,
                                 default = nil)
  if valid_580784 != nil:
    section.add "access_token", valid_580784
  var valid_580785 = query.getOrDefault("uploadType")
  valid_580785 = validateParameter(valid_580785, JString, required = false,
                                 default = nil)
  if valid_580785 != nil:
    section.add "uploadType", valid_580785
  var valid_580786 = query.getOrDefault("key")
  valid_580786 = validateParameter(valid_580786, JString, required = false,
                                 default = nil)
  if valid_580786 != nil:
    section.add "key", valid_580786
  var valid_580787 = query.getOrDefault("$.xgafv")
  valid_580787 = validateParameter(valid_580787, JString, required = false,
                                 default = newJString("1"))
  if valid_580787 != nil:
    section.add "$.xgafv", valid_580787
  var valid_580788 = query.getOrDefault("prettyPrint")
  valid_580788 = validateParameter(valid_580788, JBool, required = false,
                                 default = newJBool(true))
  if valid_580788 != nil:
    section.add "prettyPrint", valid_580788
  var valid_580789 = query.getOrDefault("bearer_token")
  valid_580789 = validateParameter(valid_580789, JString, required = false,
                                 default = nil)
  if valid_580789 != nil:
    section.add "bearer_token", valid_580789
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

proc call*(call_580791: Call_ContainerProjectsLocationsOperationsCancel_580773;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels the specified operation.
  ## 
  let valid = call_580791.validator(path, query, header, formData, body)
  let scheme = call_580791.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580791.url(scheme.get, call_580791.host, call_580791.base,
                         call_580791.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580791, url, valid)

proc call*(call_580792: Call_ContainerProjectsLocationsOperationsCancel_580773;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsOperationsCancel
  ## Cancels the specified operation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, operation id) of the operation to cancel.
  ## Specified in the format 'projects/*/locations/*/operations/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580793 = newJObject()
  var query_580794 = newJObject()
  var body_580795 = newJObject()
  add(query_580794, "upload_protocol", newJString(uploadProtocol))
  add(query_580794, "fields", newJString(fields))
  add(query_580794, "quotaUser", newJString(quotaUser))
  add(path_580793, "name", newJString(name))
  add(query_580794, "alt", newJString(alt))
  add(query_580794, "pp", newJBool(pp))
  add(query_580794, "oauth_token", newJString(oauthToken))
  add(query_580794, "callback", newJString(callback))
  add(query_580794, "access_token", newJString(accessToken))
  add(query_580794, "uploadType", newJString(uploadType))
  add(query_580794, "key", newJString(key))
  add(query_580794, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580795 = body
  add(query_580794, "prettyPrint", newJBool(prettyPrint))
  add(query_580794, "bearer_token", newJString(bearerToken))
  result = call_580792.call(path_580793, query_580794, nil, nil, body_580795)

var containerProjectsLocationsOperationsCancel* = Call_ContainerProjectsLocationsOperationsCancel_580773(
    name: "containerProjectsLocationsOperationsCancel", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/{name}:cancel",
    validator: validate_ContainerProjectsLocationsOperationsCancel_580774,
    base: "/", url: url_ContainerProjectsLocationsOperationsCancel_580775,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersCompleteIpRotation_580796 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersCompleteIpRotation_580798(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":completeIpRotation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersCompleteIpRotation_580797(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Completes master IP rotation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster id) of the cluster to complete IP rotation.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580799 = path.getOrDefault("name")
  valid_580799 = validateParameter(valid_580799, JString, required = true,
                                 default = nil)
  if valid_580799 != nil:
    section.add "name", valid_580799
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580800 = query.getOrDefault("upload_protocol")
  valid_580800 = validateParameter(valid_580800, JString, required = false,
                                 default = nil)
  if valid_580800 != nil:
    section.add "upload_protocol", valid_580800
  var valid_580801 = query.getOrDefault("fields")
  valid_580801 = validateParameter(valid_580801, JString, required = false,
                                 default = nil)
  if valid_580801 != nil:
    section.add "fields", valid_580801
  var valid_580802 = query.getOrDefault("quotaUser")
  valid_580802 = validateParameter(valid_580802, JString, required = false,
                                 default = nil)
  if valid_580802 != nil:
    section.add "quotaUser", valid_580802
  var valid_580803 = query.getOrDefault("alt")
  valid_580803 = validateParameter(valid_580803, JString, required = false,
                                 default = newJString("json"))
  if valid_580803 != nil:
    section.add "alt", valid_580803
  var valid_580804 = query.getOrDefault("pp")
  valid_580804 = validateParameter(valid_580804, JBool, required = false,
                                 default = newJBool(true))
  if valid_580804 != nil:
    section.add "pp", valid_580804
  var valid_580805 = query.getOrDefault("oauth_token")
  valid_580805 = validateParameter(valid_580805, JString, required = false,
                                 default = nil)
  if valid_580805 != nil:
    section.add "oauth_token", valid_580805
  var valid_580806 = query.getOrDefault("callback")
  valid_580806 = validateParameter(valid_580806, JString, required = false,
                                 default = nil)
  if valid_580806 != nil:
    section.add "callback", valid_580806
  var valid_580807 = query.getOrDefault("access_token")
  valid_580807 = validateParameter(valid_580807, JString, required = false,
                                 default = nil)
  if valid_580807 != nil:
    section.add "access_token", valid_580807
  var valid_580808 = query.getOrDefault("uploadType")
  valid_580808 = validateParameter(valid_580808, JString, required = false,
                                 default = nil)
  if valid_580808 != nil:
    section.add "uploadType", valid_580808
  var valid_580809 = query.getOrDefault("key")
  valid_580809 = validateParameter(valid_580809, JString, required = false,
                                 default = nil)
  if valid_580809 != nil:
    section.add "key", valid_580809
  var valid_580810 = query.getOrDefault("$.xgafv")
  valid_580810 = validateParameter(valid_580810, JString, required = false,
                                 default = newJString("1"))
  if valid_580810 != nil:
    section.add "$.xgafv", valid_580810
  var valid_580811 = query.getOrDefault("prettyPrint")
  valid_580811 = validateParameter(valid_580811, JBool, required = false,
                                 default = newJBool(true))
  if valid_580811 != nil:
    section.add "prettyPrint", valid_580811
  var valid_580812 = query.getOrDefault("bearer_token")
  valid_580812 = validateParameter(valid_580812, JString, required = false,
                                 default = nil)
  if valid_580812 != nil:
    section.add "bearer_token", valid_580812
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

proc call*(call_580814: Call_ContainerProjectsLocationsClustersCompleteIpRotation_580796;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Completes master IP rotation.
  ## 
  let valid = call_580814.validator(path, query, header, formData, body)
  let scheme = call_580814.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580814.url(scheme.get, call_580814.host, call_580814.base,
                         call_580814.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580814, url, valid)

proc call*(call_580815: Call_ContainerProjectsLocationsClustersCompleteIpRotation_580796;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersCompleteIpRotation
  ## Completes master IP rotation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster id) of the cluster to complete IP rotation.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580816 = newJObject()
  var query_580817 = newJObject()
  var body_580818 = newJObject()
  add(query_580817, "upload_protocol", newJString(uploadProtocol))
  add(query_580817, "fields", newJString(fields))
  add(query_580817, "quotaUser", newJString(quotaUser))
  add(path_580816, "name", newJString(name))
  add(query_580817, "alt", newJString(alt))
  add(query_580817, "pp", newJBool(pp))
  add(query_580817, "oauth_token", newJString(oauthToken))
  add(query_580817, "callback", newJString(callback))
  add(query_580817, "access_token", newJString(accessToken))
  add(query_580817, "uploadType", newJString(uploadType))
  add(query_580817, "key", newJString(key))
  add(query_580817, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580818 = body
  add(query_580817, "prettyPrint", newJBool(prettyPrint))
  add(query_580817, "bearer_token", newJString(bearerToken))
  result = call_580815.call(path_580816, query_580817, nil, nil, body_580818)

var containerProjectsLocationsClustersCompleteIpRotation* = Call_ContainerProjectsLocationsClustersCompleteIpRotation_580796(
    name: "containerProjectsLocationsClustersCompleteIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:completeIpRotation",
    validator: validate_ContainerProjectsLocationsClustersCompleteIpRotation_580797,
    base: "/", url: url_ContainerProjectsLocationsClustersCompleteIpRotation_580798,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsRollback_580819 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersNodePoolsRollback_580821(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":rollback")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsRollback_580820(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Roll back the previously Aborted or Failed NodePool upgrade.
  ## This will be an no-op if the last upgrade successfully completed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster, node pool id) of the node poll to
  ## rollback upgrade.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580822 = path.getOrDefault("name")
  valid_580822 = validateParameter(valid_580822, JString, required = true,
                                 default = nil)
  if valid_580822 != nil:
    section.add "name", valid_580822
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580823 = query.getOrDefault("upload_protocol")
  valid_580823 = validateParameter(valid_580823, JString, required = false,
                                 default = nil)
  if valid_580823 != nil:
    section.add "upload_protocol", valid_580823
  var valid_580824 = query.getOrDefault("fields")
  valid_580824 = validateParameter(valid_580824, JString, required = false,
                                 default = nil)
  if valid_580824 != nil:
    section.add "fields", valid_580824
  var valid_580825 = query.getOrDefault("quotaUser")
  valid_580825 = validateParameter(valid_580825, JString, required = false,
                                 default = nil)
  if valid_580825 != nil:
    section.add "quotaUser", valid_580825
  var valid_580826 = query.getOrDefault("alt")
  valid_580826 = validateParameter(valid_580826, JString, required = false,
                                 default = newJString("json"))
  if valid_580826 != nil:
    section.add "alt", valid_580826
  var valid_580827 = query.getOrDefault("pp")
  valid_580827 = validateParameter(valid_580827, JBool, required = false,
                                 default = newJBool(true))
  if valid_580827 != nil:
    section.add "pp", valid_580827
  var valid_580828 = query.getOrDefault("oauth_token")
  valid_580828 = validateParameter(valid_580828, JString, required = false,
                                 default = nil)
  if valid_580828 != nil:
    section.add "oauth_token", valid_580828
  var valid_580829 = query.getOrDefault("callback")
  valid_580829 = validateParameter(valid_580829, JString, required = false,
                                 default = nil)
  if valid_580829 != nil:
    section.add "callback", valid_580829
  var valid_580830 = query.getOrDefault("access_token")
  valid_580830 = validateParameter(valid_580830, JString, required = false,
                                 default = nil)
  if valid_580830 != nil:
    section.add "access_token", valid_580830
  var valid_580831 = query.getOrDefault("uploadType")
  valid_580831 = validateParameter(valid_580831, JString, required = false,
                                 default = nil)
  if valid_580831 != nil:
    section.add "uploadType", valid_580831
  var valid_580832 = query.getOrDefault("key")
  valid_580832 = validateParameter(valid_580832, JString, required = false,
                                 default = nil)
  if valid_580832 != nil:
    section.add "key", valid_580832
  var valid_580833 = query.getOrDefault("$.xgafv")
  valid_580833 = validateParameter(valid_580833, JString, required = false,
                                 default = newJString("1"))
  if valid_580833 != nil:
    section.add "$.xgafv", valid_580833
  var valid_580834 = query.getOrDefault("prettyPrint")
  valid_580834 = validateParameter(valid_580834, JBool, required = false,
                                 default = newJBool(true))
  if valid_580834 != nil:
    section.add "prettyPrint", valid_580834
  var valid_580835 = query.getOrDefault("bearer_token")
  valid_580835 = validateParameter(valid_580835, JString, required = false,
                                 default = nil)
  if valid_580835 != nil:
    section.add "bearer_token", valid_580835
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

proc call*(call_580837: Call_ContainerProjectsLocationsClustersNodePoolsRollback_580819;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Roll back the previously Aborted or Failed NodePool upgrade.
  ## This will be an no-op if the last upgrade successfully completed.
  ## 
  let valid = call_580837.validator(path, query, header, formData, body)
  let scheme = call_580837.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580837.url(scheme.get, call_580837.host, call_580837.base,
                         call_580837.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580837, url, valid)

proc call*(call_580838: Call_ContainerProjectsLocationsClustersNodePoolsRollback_580819;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsRollback
  ## Roll back the previously Aborted or Failed NodePool upgrade.
  ## This will be an no-op if the last upgrade successfully completed.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster, node pool id) of the node poll to
  ## rollback upgrade.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580839 = newJObject()
  var query_580840 = newJObject()
  var body_580841 = newJObject()
  add(query_580840, "upload_protocol", newJString(uploadProtocol))
  add(query_580840, "fields", newJString(fields))
  add(query_580840, "quotaUser", newJString(quotaUser))
  add(path_580839, "name", newJString(name))
  add(query_580840, "alt", newJString(alt))
  add(query_580840, "pp", newJBool(pp))
  add(query_580840, "oauth_token", newJString(oauthToken))
  add(query_580840, "callback", newJString(callback))
  add(query_580840, "access_token", newJString(accessToken))
  add(query_580840, "uploadType", newJString(uploadType))
  add(query_580840, "key", newJString(key))
  add(query_580840, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580841 = body
  add(query_580840, "prettyPrint", newJBool(prettyPrint))
  add(query_580840, "bearer_token", newJString(bearerToken))
  result = call_580838.call(path_580839, query_580840, nil, nil, body_580841)

var containerProjectsLocationsClustersNodePoolsRollback* = Call_ContainerProjectsLocationsClustersNodePoolsRollback_580819(
    name: "containerProjectsLocationsClustersNodePoolsRollback",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:rollback",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsRollback_580820,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsRollback_580821,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetAddons_580842 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersSetAddons_580844(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setAddons")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetAddons_580843(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the addons of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster) of the cluster to set addons.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580845 = path.getOrDefault("name")
  valid_580845 = validateParameter(valid_580845, JString, required = true,
                                 default = nil)
  if valid_580845 != nil:
    section.add "name", valid_580845
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580846 = query.getOrDefault("upload_protocol")
  valid_580846 = validateParameter(valid_580846, JString, required = false,
                                 default = nil)
  if valid_580846 != nil:
    section.add "upload_protocol", valid_580846
  var valid_580847 = query.getOrDefault("fields")
  valid_580847 = validateParameter(valid_580847, JString, required = false,
                                 default = nil)
  if valid_580847 != nil:
    section.add "fields", valid_580847
  var valid_580848 = query.getOrDefault("quotaUser")
  valid_580848 = validateParameter(valid_580848, JString, required = false,
                                 default = nil)
  if valid_580848 != nil:
    section.add "quotaUser", valid_580848
  var valid_580849 = query.getOrDefault("alt")
  valid_580849 = validateParameter(valid_580849, JString, required = false,
                                 default = newJString("json"))
  if valid_580849 != nil:
    section.add "alt", valid_580849
  var valid_580850 = query.getOrDefault("pp")
  valid_580850 = validateParameter(valid_580850, JBool, required = false,
                                 default = newJBool(true))
  if valid_580850 != nil:
    section.add "pp", valid_580850
  var valid_580851 = query.getOrDefault("oauth_token")
  valid_580851 = validateParameter(valid_580851, JString, required = false,
                                 default = nil)
  if valid_580851 != nil:
    section.add "oauth_token", valid_580851
  var valid_580852 = query.getOrDefault("callback")
  valid_580852 = validateParameter(valid_580852, JString, required = false,
                                 default = nil)
  if valid_580852 != nil:
    section.add "callback", valid_580852
  var valid_580853 = query.getOrDefault("access_token")
  valid_580853 = validateParameter(valid_580853, JString, required = false,
                                 default = nil)
  if valid_580853 != nil:
    section.add "access_token", valid_580853
  var valid_580854 = query.getOrDefault("uploadType")
  valid_580854 = validateParameter(valid_580854, JString, required = false,
                                 default = nil)
  if valid_580854 != nil:
    section.add "uploadType", valid_580854
  var valid_580855 = query.getOrDefault("key")
  valid_580855 = validateParameter(valid_580855, JString, required = false,
                                 default = nil)
  if valid_580855 != nil:
    section.add "key", valid_580855
  var valid_580856 = query.getOrDefault("$.xgafv")
  valid_580856 = validateParameter(valid_580856, JString, required = false,
                                 default = newJString("1"))
  if valid_580856 != nil:
    section.add "$.xgafv", valid_580856
  var valid_580857 = query.getOrDefault("prettyPrint")
  valid_580857 = validateParameter(valid_580857, JBool, required = false,
                                 default = newJBool(true))
  if valid_580857 != nil:
    section.add "prettyPrint", valid_580857
  var valid_580858 = query.getOrDefault("bearer_token")
  valid_580858 = validateParameter(valid_580858, JString, required = false,
                                 default = nil)
  if valid_580858 != nil:
    section.add "bearer_token", valid_580858
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

proc call*(call_580860: Call_ContainerProjectsLocationsClustersSetAddons_580842;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the addons of a specific cluster.
  ## 
  let valid = call_580860.validator(path, query, header, formData, body)
  let scheme = call_580860.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580860.url(scheme.get, call_580860.host, call_580860.base,
                         call_580860.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580860, url, valid)

proc call*(call_580861: Call_ContainerProjectsLocationsClustersSetAddons_580842;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetAddons
  ## Sets the addons of a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster) of the cluster to set addons.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580862 = newJObject()
  var query_580863 = newJObject()
  var body_580864 = newJObject()
  add(query_580863, "upload_protocol", newJString(uploadProtocol))
  add(query_580863, "fields", newJString(fields))
  add(query_580863, "quotaUser", newJString(quotaUser))
  add(path_580862, "name", newJString(name))
  add(query_580863, "alt", newJString(alt))
  add(query_580863, "pp", newJBool(pp))
  add(query_580863, "oauth_token", newJString(oauthToken))
  add(query_580863, "callback", newJString(callback))
  add(query_580863, "access_token", newJString(accessToken))
  add(query_580863, "uploadType", newJString(uploadType))
  add(query_580863, "key", newJString(key))
  add(query_580863, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580864 = body
  add(query_580863, "prettyPrint", newJBool(prettyPrint))
  add(query_580863, "bearer_token", newJString(bearerToken))
  result = call_580861.call(path_580862, query_580863, nil, nil, body_580864)

var containerProjectsLocationsClustersSetAddons* = Call_ContainerProjectsLocationsClustersSetAddons_580842(
    name: "containerProjectsLocationsClustersSetAddons",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setAddons",
    validator: validate_ContainerProjectsLocationsClustersSetAddons_580843,
    base: "/", url: url_ContainerProjectsLocationsClustersSetAddons_580844,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_580865 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_580867(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setAutoscaling")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_580866(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the autoscaling settings of a specific node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster, node pool) of the node pool to set
  ## autoscaler settings. Specified in the format
  ## 'projects/*/locations/*/clusters/*/nodePools/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580868 = path.getOrDefault("name")
  valid_580868 = validateParameter(valid_580868, JString, required = true,
                                 default = nil)
  if valid_580868 != nil:
    section.add "name", valid_580868
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580869 = query.getOrDefault("upload_protocol")
  valid_580869 = validateParameter(valid_580869, JString, required = false,
                                 default = nil)
  if valid_580869 != nil:
    section.add "upload_protocol", valid_580869
  var valid_580870 = query.getOrDefault("fields")
  valid_580870 = validateParameter(valid_580870, JString, required = false,
                                 default = nil)
  if valid_580870 != nil:
    section.add "fields", valid_580870
  var valid_580871 = query.getOrDefault("quotaUser")
  valid_580871 = validateParameter(valid_580871, JString, required = false,
                                 default = nil)
  if valid_580871 != nil:
    section.add "quotaUser", valid_580871
  var valid_580872 = query.getOrDefault("alt")
  valid_580872 = validateParameter(valid_580872, JString, required = false,
                                 default = newJString("json"))
  if valid_580872 != nil:
    section.add "alt", valid_580872
  var valid_580873 = query.getOrDefault("pp")
  valid_580873 = validateParameter(valid_580873, JBool, required = false,
                                 default = newJBool(true))
  if valid_580873 != nil:
    section.add "pp", valid_580873
  var valid_580874 = query.getOrDefault("oauth_token")
  valid_580874 = validateParameter(valid_580874, JString, required = false,
                                 default = nil)
  if valid_580874 != nil:
    section.add "oauth_token", valid_580874
  var valid_580875 = query.getOrDefault("callback")
  valid_580875 = validateParameter(valid_580875, JString, required = false,
                                 default = nil)
  if valid_580875 != nil:
    section.add "callback", valid_580875
  var valid_580876 = query.getOrDefault("access_token")
  valid_580876 = validateParameter(valid_580876, JString, required = false,
                                 default = nil)
  if valid_580876 != nil:
    section.add "access_token", valid_580876
  var valid_580877 = query.getOrDefault("uploadType")
  valid_580877 = validateParameter(valid_580877, JString, required = false,
                                 default = nil)
  if valid_580877 != nil:
    section.add "uploadType", valid_580877
  var valid_580878 = query.getOrDefault("key")
  valid_580878 = validateParameter(valid_580878, JString, required = false,
                                 default = nil)
  if valid_580878 != nil:
    section.add "key", valid_580878
  var valid_580879 = query.getOrDefault("$.xgafv")
  valid_580879 = validateParameter(valid_580879, JString, required = false,
                                 default = newJString("1"))
  if valid_580879 != nil:
    section.add "$.xgafv", valid_580879
  var valid_580880 = query.getOrDefault("prettyPrint")
  valid_580880 = validateParameter(valid_580880, JBool, required = false,
                                 default = newJBool(true))
  if valid_580880 != nil:
    section.add "prettyPrint", valid_580880
  var valid_580881 = query.getOrDefault("bearer_token")
  valid_580881 = validateParameter(valid_580881, JString, required = false,
                                 default = nil)
  if valid_580881 != nil:
    section.add "bearer_token", valid_580881
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

proc call*(call_580883: Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_580865;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the autoscaling settings of a specific node pool.
  ## 
  let valid = call_580883.validator(path, query, header, formData, body)
  let scheme = call_580883.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580883.url(scheme.get, call_580883.host, call_580883.base,
                         call_580883.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580883, url, valid)

proc call*(call_580884: Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_580865;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsSetAutoscaling
  ## Sets the autoscaling settings of a specific node pool.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster, node pool) of the node pool to set
  ## autoscaler settings. Specified in the format
  ## 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580885 = newJObject()
  var query_580886 = newJObject()
  var body_580887 = newJObject()
  add(query_580886, "upload_protocol", newJString(uploadProtocol))
  add(query_580886, "fields", newJString(fields))
  add(query_580886, "quotaUser", newJString(quotaUser))
  add(path_580885, "name", newJString(name))
  add(query_580886, "alt", newJString(alt))
  add(query_580886, "pp", newJBool(pp))
  add(query_580886, "oauth_token", newJString(oauthToken))
  add(query_580886, "callback", newJString(callback))
  add(query_580886, "access_token", newJString(accessToken))
  add(query_580886, "uploadType", newJString(uploadType))
  add(query_580886, "key", newJString(key))
  add(query_580886, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580887 = body
  add(query_580886, "prettyPrint", newJBool(prettyPrint))
  add(query_580886, "bearer_token", newJString(bearerToken))
  result = call_580884.call(path_580885, query_580886, nil, nil, body_580887)

var containerProjectsLocationsClustersNodePoolsSetAutoscaling* = Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_580865(
    name: "containerProjectsLocationsClustersNodePoolsSetAutoscaling",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setAutoscaling", validator: validate_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_580866,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_580867,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetLegacyAbac_580888 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersSetLegacyAbac_580890(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setLegacyAbac")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetLegacyAbac_580889(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster id) of the cluster to set legacy abac.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580891 = path.getOrDefault("name")
  valid_580891 = validateParameter(valid_580891, JString, required = true,
                                 default = nil)
  if valid_580891 != nil:
    section.add "name", valid_580891
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580892 = query.getOrDefault("upload_protocol")
  valid_580892 = validateParameter(valid_580892, JString, required = false,
                                 default = nil)
  if valid_580892 != nil:
    section.add "upload_protocol", valid_580892
  var valid_580893 = query.getOrDefault("fields")
  valid_580893 = validateParameter(valid_580893, JString, required = false,
                                 default = nil)
  if valid_580893 != nil:
    section.add "fields", valid_580893
  var valid_580894 = query.getOrDefault("quotaUser")
  valid_580894 = validateParameter(valid_580894, JString, required = false,
                                 default = nil)
  if valid_580894 != nil:
    section.add "quotaUser", valid_580894
  var valid_580895 = query.getOrDefault("alt")
  valid_580895 = validateParameter(valid_580895, JString, required = false,
                                 default = newJString("json"))
  if valid_580895 != nil:
    section.add "alt", valid_580895
  var valid_580896 = query.getOrDefault("pp")
  valid_580896 = validateParameter(valid_580896, JBool, required = false,
                                 default = newJBool(true))
  if valid_580896 != nil:
    section.add "pp", valid_580896
  var valid_580897 = query.getOrDefault("oauth_token")
  valid_580897 = validateParameter(valid_580897, JString, required = false,
                                 default = nil)
  if valid_580897 != nil:
    section.add "oauth_token", valid_580897
  var valid_580898 = query.getOrDefault("callback")
  valid_580898 = validateParameter(valid_580898, JString, required = false,
                                 default = nil)
  if valid_580898 != nil:
    section.add "callback", valid_580898
  var valid_580899 = query.getOrDefault("access_token")
  valid_580899 = validateParameter(valid_580899, JString, required = false,
                                 default = nil)
  if valid_580899 != nil:
    section.add "access_token", valid_580899
  var valid_580900 = query.getOrDefault("uploadType")
  valid_580900 = validateParameter(valid_580900, JString, required = false,
                                 default = nil)
  if valid_580900 != nil:
    section.add "uploadType", valid_580900
  var valid_580901 = query.getOrDefault("key")
  valid_580901 = validateParameter(valid_580901, JString, required = false,
                                 default = nil)
  if valid_580901 != nil:
    section.add "key", valid_580901
  var valid_580902 = query.getOrDefault("$.xgafv")
  valid_580902 = validateParameter(valid_580902, JString, required = false,
                                 default = newJString("1"))
  if valid_580902 != nil:
    section.add "$.xgafv", valid_580902
  var valid_580903 = query.getOrDefault("prettyPrint")
  valid_580903 = validateParameter(valid_580903, JBool, required = false,
                                 default = newJBool(true))
  if valid_580903 != nil:
    section.add "prettyPrint", valid_580903
  var valid_580904 = query.getOrDefault("bearer_token")
  valid_580904 = validateParameter(valid_580904, JString, required = false,
                                 default = nil)
  if valid_580904 != nil:
    section.add "bearer_token", valid_580904
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

proc call*(call_580906: Call_ContainerProjectsLocationsClustersSetLegacyAbac_580888;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ## 
  let valid = call_580906.validator(path, query, header, formData, body)
  let scheme = call_580906.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580906.url(scheme.get, call_580906.host, call_580906.base,
                         call_580906.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580906, url, valid)

proc call*(call_580907: Call_ContainerProjectsLocationsClustersSetLegacyAbac_580888;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetLegacyAbac
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster id) of the cluster to set legacy abac.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580908 = newJObject()
  var query_580909 = newJObject()
  var body_580910 = newJObject()
  add(query_580909, "upload_protocol", newJString(uploadProtocol))
  add(query_580909, "fields", newJString(fields))
  add(query_580909, "quotaUser", newJString(quotaUser))
  add(path_580908, "name", newJString(name))
  add(query_580909, "alt", newJString(alt))
  add(query_580909, "pp", newJBool(pp))
  add(query_580909, "oauth_token", newJString(oauthToken))
  add(query_580909, "callback", newJString(callback))
  add(query_580909, "access_token", newJString(accessToken))
  add(query_580909, "uploadType", newJString(uploadType))
  add(query_580909, "key", newJString(key))
  add(query_580909, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580910 = body
  add(query_580909, "prettyPrint", newJBool(prettyPrint))
  add(query_580909, "bearer_token", newJString(bearerToken))
  result = call_580907.call(path_580908, query_580909, nil, nil, body_580910)

var containerProjectsLocationsClustersSetLegacyAbac* = Call_ContainerProjectsLocationsClustersSetLegacyAbac_580888(
    name: "containerProjectsLocationsClustersSetLegacyAbac",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setLegacyAbac",
    validator: validate_ContainerProjectsLocationsClustersSetLegacyAbac_580889,
    base: "/", url: url_ContainerProjectsLocationsClustersSetLegacyAbac_580890,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetLocations_580911 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersSetLocations_580913(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setLocations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetLocations_580912(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the locations of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster) of the cluster to set locations.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580914 = path.getOrDefault("name")
  valid_580914 = validateParameter(valid_580914, JString, required = true,
                                 default = nil)
  if valid_580914 != nil:
    section.add "name", valid_580914
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580915 = query.getOrDefault("upload_protocol")
  valid_580915 = validateParameter(valid_580915, JString, required = false,
                                 default = nil)
  if valid_580915 != nil:
    section.add "upload_protocol", valid_580915
  var valid_580916 = query.getOrDefault("fields")
  valid_580916 = validateParameter(valid_580916, JString, required = false,
                                 default = nil)
  if valid_580916 != nil:
    section.add "fields", valid_580916
  var valid_580917 = query.getOrDefault("quotaUser")
  valid_580917 = validateParameter(valid_580917, JString, required = false,
                                 default = nil)
  if valid_580917 != nil:
    section.add "quotaUser", valid_580917
  var valid_580918 = query.getOrDefault("alt")
  valid_580918 = validateParameter(valid_580918, JString, required = false,
                                 default = newJString("json"))
  if valid_580918 != nil:
    section.add "alt", valid_580918
  var valid_580919 = query.getOrDefault("pp")
  valid_580919 = validateParameter(valid_580919, JBool, required = false,
                                 default = newJBool(true))
  if valid_580919 != nil:
    section.add "pp", valid_580919
  var valid_580920 = query.getOrDefault("oauth_token")
  valid_580920 = validateParameter(valid_580920, JString, required = false,
                                 default = nil)
  if valid_580920 != nil:
    section.add "oauth_token", valid_580920
  var valid_580921 = query.getOrDefault("callback")
  valid_580921 = validateParameter(valid_580921, JString, required = false,
                                 default = nil)
  if valid_580921 != nil:
    section.add "callback", valid_580921
  var valid_580922 = query.getOrDefault("access_token")
  valid_580922 = validateParameter(valid_580922, JString, required = false,
                                 default = nil)
  if valid_580922 != nil:
    section.add "access_token", valid_580922
  var valid_580923 = query.getOrDefault("uploadType")
  valid_580923 = validateParameter(valid_580923, JString, required = false,
                                 default = nil)
  if valid_580923 != nil:
    section.add "uploadType", valid_580923
  var valid_580924 = query.getOrDefault("key")
  valid_580924 = validateParameter(valid_580924, JString, required = false,
                                 default = nil)
  if valid_580924 != nil:
    section.add "key", valid_580924
  var valid_580925 = query.getOrDefault("$.xgafv")
  valid_580925 = validateParameter(valid_580925, JString, required = false,
                                 default = newJString("1"))
  if valid_580925 != nil:
    section.add "$.xgafv", valid_580925
  var valid_580926 = query.getOrDefault("prettyPrint")
  valid_580926 = validateParameter(valid_580926, JBool, required = false,
                                 default = newJBool(true))
  if valid_580926 != nil:
    section.add "prettyPrint", valid_580926
  var valid_580927 = query.getOrDefault("bearer_token")
  valid_580927 = validateParameter(valid_580927, JString, required = false,
                                 default = nil)
  if valid_580927 != nil:
    section.add "bearer_token", valid_580927
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

proc call*(call_580929: Call_ContainerProjectsLocationsClustersSetLocations_580911;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the locations of a specific cluster.
  ## 
  let valid = call_580929.validator(path, query, header, formData, body)
  let scheme = call_580929.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580929.url(scheme.get, call_580929.host, call_580929.base,
                         call_580929.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580929, url, valid)

proc call*(call_580930: Call_ContainerProjectsLocationsClustersSetLocations_580911;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetLocations
  ## Sets the locations of a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster) of the cluster to set locations.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580931 = newJObject()
  var query_580932 = newJObject()
  var body_580933 = newJObject()
  add(query_580932, "upload_protocol", newJString(uploadProtocol))
  add(query_580932, "fields", newJString(fields))
  add(query_580932, "quotaUser", newJString(quotaUser))
  add(path_580931, "name", newJString(name))
  add(query_580932, "alt", newJString(alt))
  add(query_580932, "pp", newJBool(pp))
  add(query_580932, "oauth_token", newJString(oauthToken))
  add(query_580932, "callback", newJString(callback))
  add(query_580932, "access_token", newJString(accessToken))
  add(query_580932, "uploadType", newJString(uploadType))
  add(query_580932, "key", newJString(key))
  add(query_580932, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580933 = body
  add(query_580932, "prettyPrint", newJBool(prettyPrint))
  add(query_580932, "bearer_token", newJString(bearerToken))
  result = call_580930.call(path_580931, query_580932, nil, nil, body_580933)

var containerProjectsLocationsClustersSetLocations* = Call_ContainerProjectsLocationsClustersSetLocations_580911(
    name: "containerProjectsLocationsClustersSetLocations",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setLocations",
    validator: validate_ContainerProjectsLocationsClustersSetLocations_580912,
    base: "/", url: url_ContainerProjectsLocationsClustersSetLocations_580913,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetLogging_580934 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersSetLogging_580936(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setLogging")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetLogging_580935(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the logging service of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster) of the cluster to set logging.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580937 = path.getOrDefault("name")
  valid_580937 = validateParameter(valid_580937, JString, required = true,
                                 default = nil)
  if valid_580937 != nil:
    section.add "name", valid_580937
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580938 = query.getOrDefault("upload_protocol")
  valid_580938 = validateParameter(valid_580938, JString, required = false,
                                 default = nil)
  if valid_580938 != nil:
    section.add "upload_protocol", valid_580938
  var valid_580939 = query.getOrDefault("fields")
  valid_580939 = validateParameter(valid_580939, JString, required = false,
                                 default = nil)
  if valid_580939 != nil:
    section.add "fields", valid_580939
  var valid_580940 = query.getOrDefault("quotaUser")
  valid_580940 = validateParameter(valid_580940, JString, required = false,
                                 default = nil)
  if valid_580940 != nil:
    section.add "quotaUser", valid_580940
  var valid_580941 = query.getOrDefault("alt")
  valid_580941 = validateParameter(valid_580941, JString, required = false,
                                 default = newJString("json"))
  if valid_580941 != nil:
    section.add "alt", valid_580941
  var valid_580942 = query.getOrDefault("pp")
  valid_580942 = validateParameter(valid_580942, JBool, required = false,
                                 default = newJBool(true))
  if valid_580942 != nil:
    section.add "pp", valid_580942
  var valid_580943 = query.getOrDefault("oauth_token")
  valid_580943 = validateParameter(valid_580943, JString, required = false,
                                 default = nil)
  if valid_580943 != nil:
    section.add "oauth_token", valid_580943
  var valid_580944 = query.getOrDefault("callback")
  valid_580944 = validateParameter(valid_580944, JString, required = false,
                                 default = nil)
  if valid_580944 != nil:
    section.add "callback", valid_580944
  var valid_580945 = query.getOrDefault("access_token")
  valid_580945 = validateParameter(valid_580945, JString, required = false,
                                 default = nil)
  if valid_580945 != nil:
    section.add "access_token", valid_580945
  var valid_580946 = query.getOrDefault("uploadType")
  valid_580946 = validateParameter(valid_580946, JString, required = false,
                                 default = nil)
  if valid_580946 != nil:
    section.add "uploadType", valid_580946
  var valid_580947 = query.getOrDefault("key")
  valid_580947 = validateParameter(valid_580947, JString, required = false,
                                 default = nil)
  if valid_580947 != nil:
    section.add "key", valid_580947
  var valid_580948 = query.getOrDefault("$.xgafv")
  valid_580948 = validateParameter(valid_580948, JString, required = false,
                                 default = newJString("1"))
  if valid_580948 != nil:
    section.add "$.xgafv", valid_580948
  var valid_580949 = query.getOrDefault("prettyPrint")
  valid_580949 = validateParameter(valid_580949, JBool, required = false,
                                 default = newJBool(true))
  if valid_580949 != nil:
    section.add "prettyPrint", valid_580949
  var valid_580950 = query.getOrDefault("bearer_token")
  valid_580950 = validateParameter(valid_580950, JString, required = false,
                                 default = nil)
  if valid_580950 != nil:
    section.add "bearer_token", valid_580950
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

proc call*(call_580952: Call_ContainerProjectsLocationsClustersSetLogging_580934;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the logging service of a specific cluster.
  ## 
  let valid = call_580952.validator(path, query, header, formData, body)
  let scheme = call_580952.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580952.url(scheme.get, call_580952.host, call_580952.base,
                         call_580952.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580952, url, valid)

proc call*(call_580953: Call_ContainerProjectsLocationsClustersSetLogging_580934;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetLogging
  ## Sets the logging service of a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster) of the cluster to set logging.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580954 = newJObject()
  var query_580955 = newJObject()
  var body_580956 = newJObject()
  add(query_580955, "upload_protocol", newJString(uploadProtocol))
  add(query_580955, "fields", newJString(fields))
  add(query_580955, "quotaUser", newJString(quotaUser))
  add(path_580954, "name", newJString(name))
  add(query_580955, "alt", newJString(alt))
  add(query_580955, "pp", newJBool(pp))
  add(query_580955, "oauth_token", newJString(oauthToken))
  add(query_580955, "callback", newJString(callback))
  add(query_580955, "access_token", newJString(accessToken))
  add(query_580955, "uploadType", newJString(uploadType))
  add(query_580955, "key", newJString(key))
  add(query_580955, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580956 = body
  add(query_580955, "prettyPrint", newJBool(prettyPrint))
  add(query_580955, "bearer_token", newJString(bearerToken))
  result = call_580953.call(path_580954, query_580955, nil, nil, body_580956)

var containerProjectsLocationsClustersSetLogging* = Call_ContainerProjectsLocationsClustersSetLogging_580934(
    name: "containerProjectsLocationsClustersSetLogging",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setLogging",
    validator: validate_ContainerProjectsLocationsClustersSetLogging_580935,
    base: "/", url: url_ContainerProjectsLocationsClustersSetLogging_580936,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_580957 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersSetMaintenancePolicy_580959(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setMaintenancePolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetMaintenancePolicy_580958(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the maintenance policy for a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster id) of the cluster to set maintenance
  ## policy.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580960 = path.getOrDefault("name")
  valid_580960 = validateParameter(valid_580960, JString, required = true,
                                 default = nil)
  if valid_580960 != nil:
    section.add "name", valid_580960
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580961 = query.getOrDefault("upload_protocol")
  valid_580961 = validateParameter(valid_580961, JString, required = false,
                                 default = nil)
  if valid_580961 != nil:
    section.add "upload_protocol", valid_580961
  var valid_580962 = query.getOrDefault("fields")
  valid_580962 = validateParameter(valid_580962, JString, required = false,
                                 default = nil)
  if valid_580962 != nil:
    section.add "fields", valid_580962
  var valid_580963 = query.getOrDefault("quotaUser")
  valid_580963 = validateParameter(valid_580963, JString, required = false,
                                 default = nil)
  if valid_580963 != nil:
    section.add "quotaUser", valid_580963
  var valid_580964 = query.getOrDefault("alt")
  valid_580964 = validateParameter(valid_580964, JString, required = false,
                                 default = newJString("json"))
  if valid_580964 != nil:
    section.add "alt", valid_580964
  var valid_580965 = query.getOrDefault("pp")
  valid_580965 = validateParameter(valid_580965, JBool, required = false,
                                 default = newJBool(true))
  if valid_580965 != nil:
    section.add "pp", valid_580965
  var valid_580966 = query.getOrDefault("oauth_token")
  valid_580966 = validateParameter(valid_580966, JString, required = false,
                                 default = nil)
  if valid_580966 != nil:
    section.add "oauth_token", valid_580966
  var valid_580967 = query.getOrDefault("callback")
  valid_580967 = validateParameter(valid_580967, JString, required = false,
                                 default = nil)
  if valid_580967 != nil:
    section.add "callback", valid_580967
  var valid_580968 = query.getOrDefault("access_token")
  valid_580968 = validateParameter(valid_580968, JString, required = false,
                                 default = nil)
  if valid_580968 != nil:
    section.add "access_token", valid_580968
  var valid_580969 = query.getOrDefault("uploadType")
  valid_580969 = validateParameter(valid_580969, JString, required = false,
                                 default = nil)
  if valid_580969 != nil:
    section.add "uploadType", valid_580969
  var valid_580970 = query.getOrDefault("key")
  valid_580970 = validateParameter(valid_580970, JString, required = false,
                                 default = nil)
  if valid_580970 != nil:
    section.add "key", valid_580970
  var valid_580971 = query.getOrDefault("$.xgafv")
  valid_580971 = validateParameter(valid_580971, JString, required = false,
                                 default = newJString("1"))
  if valid_580971 != nil:
    section.add "$.xgafv", valid_580971
  var valid_580972 = query.getOrDefault("prettyPrint")
  valid_580972 = validateParameter(valid_580972, JBool, required = false,
                                 default = newJBool(true))
  if valid_580972 != nil:
    section.add "prettyPrint", valid_580972
  var valid_580973 = query.getOrDefault("bearer_token")
  valid_580973 = validateParameter(valid_580973, JString, required = false,
                                 default = nil)
  if valid_580973 != nil:
    section.add "bearer_token", valid_580973
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

proc call*(call_580975: Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_580957;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the maintenance policy for a cluster.
  ## 
  let valid = call_580975.validator(path, query, header, formData, body)
  let scheme = call_580975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580975.url(scheme.get, call_580975.host, call_580975.base,
                         call_580975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580975, url, valid)

proc call*(call_580976: Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_580957;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetMaintenancePolicy
  ## Sets the maintenance policy for a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster id) of the cluster to set maintenance
  ## policy.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_580977 = newJObject()
  var query_580978 = newJObject()
  var body_580979 = newJObject()
  add(query_580978, "upload_protocol", newJString(uploadProtocol))
  add(query_580978, "fields", newJString(fields))
  add(query_580978, "quotaUser", newJString(quotaUser))
  add(path_580977, "name", newJString(name))
  add(query_580978, "alt", newJString(alt))
  add(query_580978, "pp", newJBool(pp))
  add(query_580978, "oauth_token", newJString(oauthToken))
  add(query_580978, "callback", newJString(callback))
  add(query_580978, "access_token", newJString(accessToken))
  add(query_580978, "uploadType", newJString(uploadType))
  add(query_580978, "key", newJString(key))
  add(query_580978, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580979 = body
  add(query_580978, "prettyPrint", newJBool(prettyPrint))
  add(query_580978, "bearer_token", newJString(bearerToken))
  result = call_580976.call(path_580977, query_580978, nil, nil, body_580979)

var containerProjectsLocationsClustersSetMaintenancePolicy* = Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_580957(
    name: "containerProjectsLocationsClustersSetMaintenancePolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setMaintenancePolicy",
    validator: validate_ContainerProjectsLocationsClustersSetMaintenancePolicy_580958,
    base: "/", url: url_ContainerProjectsLocationsClustersSetMaintenancePolicy_580959,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_580980 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersNodePoolsSetManagement_580982(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setManagement")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsSetManagement_580981(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the NodeManagement options for a node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster, node pool id) of the node pool to set
  ## management properties. Specified in the format
  ## 'projects/*/locations/*/clusters/*/nodePools/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580983 = path.getOrDefault("name")
  valid_580983 = validateParameter(valid_580983, JString, required = true,
                                 default = nil)
  if valid_580983 != nil:
    section.add "name", valid_580983
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_580984 = query.getOrDefault("upload_protocol")
  valid_580984 = validateParameter(valid_580984, JString, required = false,
                                 default = nil)
  if valid_580984 != nil:
    section.add "upload_protocol", valid_580984
  var valid_580985 = query.getOrDefault("fields")
  valid_580985 = validateParameter(valid_580985, JString, required = false,
                                 default = nil)
  if valid_580985 != nil:
    section.add "fields", valid_580985
  var valid_580986 = query.getOrDefault("quotaUser")
  valid_580986 = validateParameter(valid_580986, JString, required = false,
                                 default = nil)
  if valid_580986 != nil:
    section.add "quotaUser", valid_580986
  var valid_580987 = query.getOrDefault("alt")
  valid_580987 = validateParameter(valid_580987, JString, required = false,
                                 default = newJString("json"))
  if valid_580987 != nil:
    section.add "alt", valid_580987
  var valid_580988 = query.getOrDefault("pp")
  valid_580988 = validateParameter(valid_580988, JBool, required = false,
                                 default = newJBool(true))
  if valid_580988 != nil:
    section.add "pp", valid_580988
  var valid_580989 = query.getOrDefault("oauth_token")
  valid_580989 = validateParameter(valid_580989, JString, required = false,
                                 default = nil)
  if valid_580989 != nil:
    section.add "oauth_token", valid_580989
  var valid_580990 = query.getOrDefault("callback")
  valid_580990 = validateParameter(valid_580990, JString, required = false,
                                 default = nil)
  if valid_580990 != nil:
    section.add "callback", valid_580990
  var valid_580991 = query.getOrDefault("access_token")
  valid_580991 = validateParameter(valid_580991, JString, required = false,
                                 default = nil)
  if valid_580991 != nil:
    section.add "access_token", valid_580991
  var valid_580992 = query.getOrDefault("uploadType")
  valid_580992 = validateParameter(valid_580992, JString, required = false,
                                 default = nil)
  if valid_580992 != nil:
    section.add "uploadType", valid_580992
  var valid_580993 = query.getOrDefault("key")
  valid_580993 = validateParameter(valid_580993, JString, required = false,
                                 default = nil)
  if valid_580993 != nil:
    section.add "key", valid_580993
  var valid_580994 = query.getOrDefault("$.xgafv")
  valid_580994 = validateParameter(valid_580994, JString, required = false,
                                 default = newJString("1"))
  if valid_580994 != nil:
    section.add "$.xgafv", valid_580994
  var valid_580995 = query.getOrDefault("prettyPrint")
  valid_580995 = validateParameter(valid_580995, JBool, required = false,
                                 default = newJBool(true))
  if valid_580995 != nil:
    section.add "prettyPrint", valid_580995
  var valid_580996 = query.getOrDefault("bearer_token")
  valid_580996 = validateParameter(valid_580996, JString, required = false,
                                 default = nil)
  if valid_580996 != nil:
    section.add "bearer_token", valid_580996
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

proc call*(call_580998: Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_580980;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the NodeManagement options for a node pool.
  ## 
  let valid = call_580998.validator(path, query, header, formData, body)
  let scheme = call_580998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580998.url(scheme.get, call_580998.host, call_580998.base,
                         call_580998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580998, url, valid)

proc call*(call_580999: Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_580980;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsSetManagement
  ## Sets the NodeManagement options for a node pool.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster, node pool id) of the node pool to set
  ## management properties. Specified in the format
  ## 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_581000 = newJObject()
  var query_581001 = newJObject()
  var body_581002 = newJObject()
  add(query_581001, "upload_protocol", newJString(uploadProtocol))
  add(query_581001, "fields", newJString(fields))
  add(query_581001, "quotaUser", newJString(quotaUser))
  add(path_581000, "name", newJString(name))
  add(query_581001, "alt", newJString(alt))
  add(query_581001, "pp", newJBool(pp))
  add(query_581001, "oauth_token", newJString(oauthToken))
  add(query_581001, "callback", newJString(callback))
  add(query_581001, "access_token", newJString(accessToken))
  add(query_581001, "uploadType", newJString(uploadType))
  add(query_581001, "key", newJString(key))
  add(query_581001, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_581002 = body
  add(query_581001, "prettyPrint", newJBool(prettyPrint))
  add(query_581001, "bearer_token", newJString(bearerToken))
  result = call_580999.call(path_581000, query_581001, nil, nil, body_581002)

var containerProjectsLocationsClustersNodePoolsSetManagement* = Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_580980(
    name: "containerProjectsLocationsClustersNodePoolsSetManagement",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setManagement", validator: validate_ContainerProjectsLocationsClustersNodePoolsSetManagement_580981,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsSetManagement_580982,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetMasterAuth_581003 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersSetMasterAuth_581005(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setMasterAuth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetMasterAuth_581004(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Used to set master auth materials. Currently supports :-
  ## Changing the admin password of a specific cluster.
  ## This can be either via password generation or explicitly set.
  ## Modify basic_auth.csv and reset the K8S API server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster) of the cluster to set auth.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_581006 = path.getOrDefault("name")
  valid_581006 = validateParameter(valid_581006, JString, required = true,
                                 default = nil)
  if valid_581006 != nil:
    section.add "name", valid_581006
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_581007 = query.getOrDefault("upload_protocol")
  valid_581007 = validateParameter(valid_581007, JString, required = false,
                                 default = nil)
  if valid_581007 != nil:
    section.add "upload_protocol", valid_581007
  var valid_581008 = query.getOrDefault("fields")
  valid_581008 = validateParameter(valid_581008, JString, required = false,
                                 default = nil)
  if valid_581008 != nil:
    section.add "fields", valid_581008
  var valid_581009 = query.getOrDefault("quotaUser")
  valid_581009 = validateParameter(valid_581009, JString, required = false,
                                 default = nil)
  if valid_581009 != nil:
    section.add "quotaUser", valid_581009
  var valid_581010 = query.getOrDefault("alt")
  valid_581010 = validateParameter(valid_581010, JString, required = false,
                                 default = newJString("json"))
  if valid_581010 != nil:
    section.add "alt", valid_581010
  var valid_581011 = query.getOrDefault("pp")
  valid_581011 = validateParameter(valid_581011, JBool, required = false,
                                 default = newJBool(true))
  if valid_581011 != nil:
    section.add "pp", valid_581011
  var valid_581012 = query.getOrDefault("oauth_token")
  valid_581012 = validateParameter(valid_581012, JString, required = false,
                                 default = nil)
  if valid_581012 != nil:
    section.add "oauth_token", valid_581012
  var valid_581013 = query.getOrDefault("callback")
  valid_581013 = validateParameter(valid_581013, JString, required = false,
                                 default = nil)
  if valid_581013 != nil:
    section.add "callback", valid_581013
  var valid_581014 = query.getOrDefault("access_token")
  valid_581014 = validateParameter(valid_581014, JString, required = false,
                                 default = nil)
  if valid_581014 != nil:
    section.add "access_token", valid_581014
  var valid_581015 = query.getOrDefault("uploadType")
  valid_581015 = validateParameter(valid_581015, JString, required = false,
                                 default = nil)
  if valid_581015 != nil:
    section.add "uploadType", valid_581015
  var valid_581016 = query.getOrDefault("key")
  valid_581016 = validateParameter(valid_581016, JString, required = false,
                                 default = nil)
  if valid_581016 != nil:
    section.add "key", valid_581016
  var valid_581017 = query.getOrDefault("$.xgafv")
  valid_581017 = validateParameter(valid_581017, JString, required = false,
                                 default = newJString("1"))
  if valid_581017 != nil:
    section.add "$.xgafv", valid_581017
  var valid_581018 = query.getOrDefault("prettyPrint")
  valid_581018 = validateParameter(valid_581018, JBool, required = false,
                                 default = newJBool(true))
  if valid_581018 != nil:
    section.add "prettyPrint", valid_581018
  var valid_581019 = query.getOrDefault("bearer_token")
  valid_581019 = validateParameter(valid_581019, JString, required = false,
                                 default = nil)
  if valid_581019 != nil:
    section.add "bearer_token", valid_581019
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

proc call*(call_581021: Call_ContainerProjectsLocationsClustersSetMasterAuth_581003;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Used to set master auth materials. Currently supports :-
  ## Changing the admin password of a specific cluster.
  ## This can be either via password generation or explicitly set.
  ## Modify basic_auth.csv and reset the K8S API server.
  ## 
  let valid = call_581021.validator(path, query, header, formData, body)
  let scheme = call_581021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581021.url(scheme.get, call_581021.host, call_581021.base,
                         call_581021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581021, url, valid)

proc call*(call_581022: Call_ContainerProjectsLocationsClustersSetMasterAuth_581003;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetMasterAuth
  ## Used to set master auth materials. Currently supports :-
  ## Changing the admin password of a specific cluster.
  ## This can be either via password generation or explicitly set.
  ## Modify basic_auth.csv and reset the K8S API server.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster) of the cluster to set auth.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_581023 = newJObject()
  var query_581024 = newJObject()
  var body_581025 = newJObject()
  add(query_581024, "upload_protocol", newJString(uploadProtocol))
  add(query_581024, "fields", newJString(fields))
  add(query_581024, "quotaUser", newJString(quotaUser))
  add(path_581023, "name", newJString(name))
  add(query_581024, "alt", newJString(alt))
  add(query_581024, "pp", newJBool(pp))
  add(query_581024, "oauth_token", newJString(oauthToken))
  add(query_581024, "callback", newJString(callback))
  add(query_581024, "access_token", newJString(accessToken))
  add(query_581024, "uploadType", newJString(uploadType))
  add(query_581024, "key", newJString(key))
  add(query_581024, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_581025 = body
  add(query_581024, "prettyPrint", newJBool(prettyPrint))
  add(query_581024, "bearer_token", newJString(bearerToken))
  result = call_581022.call(path_581023, query_581024, nil, nil, body_581025)

var containerProjectsLocationsClustersSetMasterAuth* = Call_ContainerProjectsLocationsClustersSetMasterAuth_581003(
    name: "containerProjectsLocationsClustersSetMasterAuth",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setMasterAuth",
    validator: validate_ContainerProjectsLocationsClustersSetMasterAuth_581004,
    base: "/", url: url_ContainerProjectsLocationsClustersSetMasterAuth_581005,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetMonitoring_581026 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersSetMonitoring_581028(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setMonitoring")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetMonitoring_581027(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the monitoring service of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster) of the cluster to set monitoring.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_581029 = path.getOrDefault("name")
  valid_581029 = validateParameter(valid_581029, JString, required = true,
                                 default = nil)
  if valid_581029 != nil:
    section.add "name", valid_581029
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_581030 = query.getOrDefault("upload_protocol")
  valid_581030 = validateParameter(valid_581030, JString, required = false,
                                 default = nil)
  if valid_581030 != nil:
    section.add "upload_protocol", valid_581030
  var valid_581031 = query.getOrDefault("fields")
  valid_581031 = validateParameter(valid_581031, JString, required = false,
                                 default = nil)
  if valid_581031 != nil:
    section.add "fields", valid_581031
  var valid_581032 = query.getOrDefault("quotaUser")
  valid_581032 = validateParameter(valid_581032, JString, required = false,
                                 default = nil)
  if valid_581032 != nil:
    section.add "quotaUser", valid_581032
  var valid_581033 = query.getOrDefault("alt")
  valid_581033 = validateParameter(valid_581033, JString, required = false,
                                 default = newJString("json"))
  if valid_581033 != nil:
    section.add "alt", valid_581033
  var valid_581034 = query.getOrDefault("pp")
  valid_581034 = validateParameter(valid_581034, JBool, required = false,
                                 default = newJBool(true))
  if valid_581034 != nil:
    section.add "pp", valid_581034
  var valid_581035 = query.getOrDefault("oauth_token")
  valid_581035 = validateParameter(valid_581035, JString, required = false,
                                 default = nil)
  if valid_581035 != nil:
    section.add "oauth_token", valid_581035
  var valid_581036 = query.getOrDefault("callback")
  valid_581036 = validateParameter(valid_581036, JString, required = false,
                                 default = nil)
  if valid_581036 != nil:
    section.add "callback", valid_581036
  var valid_581037 = query.getOrDefault("access_token")
  valid_581037 = validateParameter(valid_581037, JString, required = false,
                                 default = nil)
  if valid_581037 != nil:
    section.add "access_token", valid_581037
  var valid_581038 = query.getOrDefault("uploadType")
  valid_581038 = validateParameter(valid_581038, JString, required = false,
                                 default = nil)
  if valid_581038 != nil:
    section.add "uploadType", valid_581038
  var valid_581039 = query.getOrDefault("key")
  valid_581039 = validateParameter(valid_581039, JString, required = false,
                                 default = nil)
  if valid_581039 != nil:
    section.add "key", valid_581039
  var valid_581040 = query.getOrDefault("$.xgafv")
  valid_581040 = validateParameter(valid_581040, JString, required = false,
                                 default = newJString("1"))
  if valid_581040 != nil:
    section.add "$.xgafv", valid_581040
  var valid_581041 = query.getOrDefault("prettyPrint")
  valid_581041 = validateParameter(valid_581041, JBool, required = false,
                                 default = newJBool(true))
  if valid_581041 != nil:
    section.add "prettyPrint", valid_581041
  var valid_581042 = query.getOrDefault("bearer_token")
  valid_581042 = validateParameter(valid_581042, JString, required = false,
                                 default = nil)
  if valid_581042 != nil:
    section.add "bearer_token", valid_581042
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

proc call*(call_581044: Call_ContainerProjectsLocationsClustersSetMonitoring_581026;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the monitoring service of a specific cluster.
  ## 
  let valid = call_581044.validator(path, query, header, formData, body)
  let scheme = call_581044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581044.url(scheme.get, call_581044.host, call_581044.base,
                         call_581044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581044, url, valid)

proc call*(call_581045: Call_ContainerProjectsLocationsClustersSetMonitoring_581026;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetMonitoring
  ## Sets the monitoring service of a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster) of the cluster to set monitoring.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_581046 = newJObject()
  var query_581047 = newJObject()
  var body_581048 = newJObject()
  add(query_581047, "upload_protocol", newJString(uploadProtocol))
  add(query_581047, "fields", newJString(fields))
  add(query_581047, "quotaUser", newJString(quotaUser))
  add(path_581046, "name", newJString(name))
  add(query_581047, "alt", newJString(alt))
  add(query_581047, "pp", newJBool(pp))
  add(query_581047, "oauth_token", newJString(oauthToken))
  add(query_581047, "callback", newJString(callback))
  add(query_581047, "access_token", newJString(accessToken))
  add(query_581047, "uploadType", newJString(uploadType))
  add(query_581047, "key", newJString(key))
  add(query_581047, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_581048 = body
  add(query_581047, "prettyPrint", newJBool(prettyPrint))
  add(query_581047, "bearer_token", newJString(bearerToken))
  result = call_581045.call(path_581046, query_581047, nil, nil, body_581048)

var containerProjectsLocationsClustersSetMonitoring* = Call_ContainerProjectsLocationsClustersSetMonitoring_581026(
    name: "containerProjectsLocationsClustersSetMonitoring",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setMonitoring",
    validator: validate_ContainerProjectsLocationsClustersSetMonitoring_581027,
    base: "/", url: url_ContainerProjectsLocationsClustersSetMonitoring_581028,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetNetworkPolicy_581049 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersSetNetworkPolicy_581051(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setNetworkPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetNetworkPolicy_581050(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Enables/Disables Network Policy for a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster id) of the cluster to set networking policy.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_581052 = path.getOrDefault("name")
  valid_581052 = validateParameter(valid_581052, JString, required = true,
                                 default = nil)
  if valid_581052 != nil:
    section.add "name", valid_581052
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_581053 = query.getOrDefault("upload_protocol")
  valid_581053 = validateParameter(valid_581053, JString, required = false,
                                 default = nil)
  if valid_581053 != nil:
    section.add "upload_protocol", valid_581053
  var valid_581054 = query.getOrDefault("fields")
  valid_581054 = validateParameter(valid_581054, JString, required = false,
                                 default = nil)
  if valid_581054 != nil:
    section.add "fields", valid_581054
  var valid_581055 = query.getOrDefault("quotaUser")
  valid_581055 = validateParameter(valid_581055, JString, required = false,
                                 default = nil)
  if valid_581055 != nil:
    section.add "quotaUser", valid_581055
  var valid_581056 = query.getOrDefault("alt")
  valid_581056 = validateParameter(valid_581056, JString, required = false,
                                 default = newJString("json"))
  if valid_581056 != nil:
    section.add "alt", valid_581056
  var valid_581057 = query.getOrDefault("pp")
  valid_581057 = validateParameter(valid_581057, JBool, required = false,
                                 default = newJBool(true))
  if valid_581057 != nil:
    section.add "pp", valid_581057
  var valid_581058 = query.getOrDefault("oauth_token")
  valid_581058 = validateParameter(valid_581058, JString, required = false,
                                 default = nil)
  if valid_581058 != nil:
    section.add "oauth_token", valid_581058
  var valid_581059 = query.getOrDefault("callback")
  valid_581059 = validateParameter(valid_581059, JString, required = false,
                                 default = nil)
  if valid_581059 != nil:
    section.add "callback", valid_581059
  var valid_581060 = query.getOrDefault("access_token")
  valid_581060 = validateParameter(valid_581060, JString, required = false,
                                 default = nil)
  if valid_581060 != nil:
    section.add "access_token", valid_581060
  var valid_581061 = query.getOrDefault("uploadType")
  valid_581061 = validateParameter(valid_581061, JString, required = false,
                                 default = nil)
  if valid_581061 != nil:
    section.add "uploadType", valid_581061
  var valid_581062 = query.getOrDefault("key")
  valid_581062 = validateParameter(valid_581062, JString, required = false,
                                 default = nil)
  if valid_581062 != nil:
    section.add "key", valid_581062
  var valid_581063 = query.getOrDefault("$.xgafv")
  valid_581063 = validateParameter(valid_581063, JString, required = false,
                                 default = newJString("1"))
  if valid_581063 != nil:
    section.add "$.xgafv", valid_581063
  var valid_581064 = query.getOrDefault("prettyPrint")
  valid_581064 = validateParameter(valid_581064, JBool, required = false,
                                 default = newJBool(true))
  if valid_581064 != nil:
    section.add "prettyPrint", valid_581064
  var valid_581065 = query.getOrDefault("bearer_token")
  valid_581065 = validateParameter(valid_581065, JString, required = false,
                                 default = nil)
  if valid_581065 != nil:
    section.add "bearer_token", valid_581065
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

proc call*(call_581067: Call_ContainerProjectsLocationsClustersSetNetworkPolicy_581049;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables/Disables Network Policy for a cluster.
  ## 
  let valid = call_581067.validator(path, query, header, formData, body)
  let scheme = call_581067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581067.url(scheme.get, call_581067.host, call_581067.base,
                         call_581067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581067, url, valid)

proc call*(call_581068: Call_ContainerProjectsLocationsClustersSetNetworkPolicy_581049;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetNetworkPolicy
  ## Enables/Disables Network Policy for a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster id) of the cluster to set networking policy.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_581069 = newJObject()
  var query_581070 = newJObject()
  var body_581071 = newJObject()
  add(query_581070, "upload_protocol", newJString(uploadProtocol))
  add(query_581070, "fields", newJString(fields))
  add(query_581070, "quotaUser", newJString(quotaUser))
  add(path_581069, "name", newJString(name))
  add(query_581070, "alt", newJString(alt))
  add(query_581070, "pp", newJBool(pp))
  add(query_581070, "oauth_token", newJString(oauthToken))
  add(query_581070, "callback", newJString(callback))
  add(query_581070, "access_token", newJString(accessToken))
  add(query_581070, "uploadType", newJString(uploadType))
  add(query_581070, "key", newJString(key))
  add(query_581070, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_581071 = body
  add(query_581070, "prettyPrint", newJBool(prettyPrint))
  add(query_581070, "bearer_token", newJString(bearerToken))
  result = call_581068.call(path_581069, query_581070, nil, nil, body_581071)

var containerProjectsLocationsClustersSetNetworkPolicy* = Call_ContainerProjectsLocationsClustersSetNetworkPolicy_581049(
    name: "containerProjectsLocationsClustersSetNetworkPolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setNetworkPolicy",
    validator: validate_ContainerProjectsLocationsClustersSetNetworkPolicy_581050,
    base: "/", url: url_ContainerProjectsLocationsClustersSetNetworkPolicy_581051,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetResourceLabels_581072 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersSetResourceLabels_581074(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setResourceLabels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetResourceLabels_581073(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets labels on a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster id) of the cluster to set labels.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_581075 = path.getOrDefault("name")
  valid_581075 = validateParameter(valid_581075, JString, required = true,
                                 default = nil)
  if valid_581075 != nil:
    section.add "name", valid_581075
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_581076 = query.getOrDefault("upload_protocol")
  valid_581076 = validateParameter(valid_581076, JString, required = false,
                                 default = nil)
  if valid_581076 != nil:
    section.add "upload_protocol", valid_581076
  var valid_581077 = query.getOrDefault("fields")
  valid_581077 = validateParameter(valid_581077, JString, required = false,
                                 default = nil)
  if valid_581077 != nil:
    section.add "fields", valid_581077
  var valid_581078 = query.getOrDefault("quotaUser")
  valid_581078 = validateParameter(valid_581078, JString, required = false,
                                 default = nil)
  if valid_581078 != nil:
    section.add "quotaUser", valid_581078
  var valid_581079 = query.getOrDefault("alt")
  valid_581079 = validateParameter(valid_581079, JString, required = false,
                                 default = newJString("json"))
  if valid_581079 != nil:
    section.add "alt", valid_581079
  var valid_581080 = query.getOrDefault("pp")
  valid_581080 = validateParameter(valid_581080, JBool, required = false,
                                 default = newJBool(true))
  if valid_581080 != nil:
    section.add "pp", valid_581080
  var valid_581081 = query.getOrDefault("oauth_token")
  valid_581081 = validateParameter(valid_581081, JString, required = false,
                                 default = nil)
  if valid_581081 != nil:
    section.add "oauth_token", valid_581081
  var valid_581082 = query.getOrDefault("callback")
  valid_581082 = validateParameter(valid_581082, JString, required = false,
                                 default = nil)
  if valid_581082 != nil:
    section.add "callback", valid_581082
  var valid_581083 = query.getOrDefault("access_token")
  valid_581083 = validateParameter(valid_581083, JString, required = false,
                                 default = nil)
  if valid_581083 != nil:
    section.add "access_token", valid_581083
  var valid_581084 = query.getOrDefault("uploadType")
  valid_581084 = validateParameter(valid_581084, JString, required = false,
                                 default = nil)
  if valid_581084 != nil:
    section.add "uploadType", valid_581084
  var valid_581085 = query.getOrDefault("key")
  valid_581085 = validateParameter(valid_581085, JString, required = false,
                                 default = nil)
  if valid_581085 != nil:
    section.add "key", valid_581085
  var valid_581086 = query.getOrDefault("$.xgafv")
  valid_581086 = validateParameter(valid_581086, JString, required = false,
                                 default = newJString("1"))
  if valid_581086 != nil:
    section.add "$.xgafv", valid_581086
  var valid_581087 = query.getOrDefault("prettyPrint")
  valid_581087 = validateParameter(valid_581087, JBool, required = false,
                                 default = newJBool(true))
  if valid_581087 != nil:
    section.add "prettyPrint", valid_581087
  var valid_581088 = query.getOrDefault("bearer_token")
  valid_581088 = validateParameter(valid_581088, JString, required = false,
                                 default = nil)
  if valid_581088 != nil:
    section.add "bearer_token", valid_581088
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

proc call*(call_581090: Call_ContainerProjectsLocationsClustersSetResourceLabels_581072;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets labels on a cluster.
  ## 
  let valid = call_581090.validator(path, query, header, formData, body)
  let scheme = call_581090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581090.url(scheme.get, call_581090.host, call_581090.base,
                         call_581090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581090, url, valid)

proc call*(call_581091: Call_ContainerProjectsLocationsClustersSetResourceLabels_581072;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetResourceLabels
  ## Sets labels on a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster id) of the cluster to set labels.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_581092 = newJObject()
  var query_581093 = newJObject()
  var body_581094 = newJObject()
  add(query_581093, "upload_protocol", newJString(uploadProtocol))
  add(query_581093, "fields", newJString(fields))
  add(query_581093, "quotaUser", newJString(quotaUser))
  add(path_581092, "name", newJString(name))
  add(query_581093, "alt", newJString(alt))
  add(query_581093, "pp", newJBool(pp))
  add(query_581093, "oauth_token", newJString(oauthToken))
  add(query_581093, "callback", newJString(callback))
  add(query_581093, "access_token", newJString(accessToken))
  add(query_581093, "uploadType", newJString(uploadType))
  add(query_581093, "key", newJString(key))
  add(query_581093, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_581094 = body
  add(query_581093, "prettyPrint", newJBool(prettyPrint))
  add(query_581093, "bearer_token", newJString(bearerToken))
  result = call_581091.call(path_581092, query_581093, nil, nil, body_581094)

var containerProjectsLocationsClustersSetResourceLabels* = Call_ContainerProjectsLocationsClustersSetResourceLabels_581072(
    name: "containerProjectsLocationsClustersSetResourceLabels",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setResourceLabels",
    validator: validate_ContainerProjectsLocationsClustersSetResourceLabels_581073,
    base: "/", url: url_ContainerProjectsLocationsClustersSetResourceLabels_581074,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersStartIpRotation_581095 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersStartIpRotation_581097(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":startIpRotation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersStartIpRotation_581096(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Start master IP rotation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster id) of the cluster to start IP rotation.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_581098 = path.getOrDefault("name")
  valid_581098 = validateParameter(valid_581098, JString, required = true,
                                 default = nil)
  if valid_581098 != nil:
    section.add "name", valid_581098
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_581099 = query.getOrDefault("upload_protocol")
  valid_581099 = validateParameter(valid_581099, JString, required = false,
                                 default = nil)
  if valid_581099 != nil:
    section.add "upload_protocol", valid_581099
  var valid_581100 = query.getOrDefault("fields")
  valid_581100 = validateParameter(valid_581100, JString, required = false,
                                 default = nil)
  if valid_581100 != nil:
    section.add "fields", valid_581100
  var valid_581101 = query.getOrDefault("quotaUser")
  valid_581101 = validateParameter(valid_581101, JString, required = false,
                                 default = nil)
  if valid_581101 != nil:
    section.add "quotaUser", valid_581101
  var valid_581102 = query.getOrDefault("alt")
  valid_581102 = validateParameter(valid_581102, JString, required = false,
                                 default = newJString("json"))
  if valid_581102 != nil:
    section.add "alt", valid_581102
  var valid_581103 = query.getOrDefault("pp")
  valid_581103 = validateParameter(valid_581103, JBool, required = false,
                                 default = newJBool(true))
  if valid_581103 != nil:
    section.add "pp", valid_581103
  var valid_581104 = query.getOrDefault("oauth_token")
  valid_581104 = validateParameter(valid_581104, JString, required = false,
                                 default = nil)
  if valid_581104 != nil:
    section.add "oauth_token", valid_581104
  var valid_581105 = query.getOrDefault("callback")
  valid_581105 = validateParameter(valid_581105, JString, required = false,
                                 default = nil)
  if valid_581105 != nil:
    section.add "callback", valid_581105
  var valid_581106 = query.getOrDefault("access_token")
  valid_581106 = validateParameter(valid_581106, JString, required = false,
                                 default = nil)
  if valid_581106 != nil:
    section.add "access_token", valid_581106
  var valid_581107 = query.getOrDefault("uploadType")
  valid_581107 = validateParameter(valid_581107, JString, required = false,
                                 default = nil)
  if valid_581107 != nil:
    section.add "uploadType", valid_581107
  var valid_581108 = query.getOrDefault("key")
  valid_581108 = validateParameter(valid_581108, JString, required = false,
                                 default = nil)
  if valid_581108 != nil:
    section.add "key", valid_581108
  var valid_581109 = query.getOrDefault("$.xgafv")
  valid_581109 = validateParameter(valid_581109, JString, required = false,
                                 default = newJString("1"))
  if valid_581109 != nil:
    section.add "$.xgafv", valid_581109
  var valid_581110 = query.getOrDefault("prettyPrint")
  valid_581110 = validateParameter(valid_581110, JBool, required = false,
                                 default = newJBool(true))
  if valid_581110 != nil:
    section.add "prettyPrint", valid_581110
  var valid_581111 = query.getOrDefault("bearer_token")
  valid_581111 = validateParameter(valid_581111, JString, required = false,
                                 default = nil)
  if valid_581111 != nil:
    section.add "bearer_token", valid_581111
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

proc call*(call_581113: Call_ContainerProjectsLocationsClustersStartIpRotation_581095;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Start master IP rotation.
  ## 
  let valid = call_581113.validator(path, query, header, formData, body)
  let scheme = call_581113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581113.url(scheme.get, call_581113.host, call_581113.base,
                         call_581113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581113, url, valid)

proc call*(call_581114: Call_ContainerProjectsLocationsClustersStartIpRotation_581095;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersStartIpRotation
  ## Start master IP rotation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster id) of the cluster to start IP rotation.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_581115 = newJObject()
  var query_581116 = newJObject()
  var body_581117 = newJObject()
  add(query_581116, "upload_protocol", newJString(uploadProtocol))
  add(query_581116, "fields", newJString(fields))
  add(query_581116, "quotaUser", newJString(quotaUser))
  add(path_581115, "name", newJString(name))
  add(query_581116, "alt", newJString(alt))
  add(query_581116, "pp", newJBool(pp))
  add(query_581116, "oauth_token", newJString(oauthToken))
  add(query_581116, "callback", newJString(callback))
  add(query_581116, "access_token", newJString(accessToken))
  add(query_581116, "uploadType", newJString(uploadType))
  add(query_581116, "key", newJString(key))
  add(query_581116, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_581117 = body
  add(query_581116, "prettyPrint", newJBool(prettyPrint))
  add(query_581116, "bearer_token", newJString(bearerToken))
  result = call_581114.call(path_581115, query_581116, nil, nil, body_581117)

var containerProjectsLocationsClustersStartIpRotation* = Call_ContainerProjectsLocationsClustersStartIpRotation_581095(
    name: "containerProjectsLocationsClustersStartIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:startIpRotation",
    validator: validate_ContainerProjectsLocationsClustersStartIpRotation_581096,
    base: "/", url: url_ContainerProjectsLocationsClustersStartIpRotation_581097,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersUpdateMaster_581118 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersUpdateMaster_581120(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":updateMaster")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersUpdateMaster_581119(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates the master of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster) of the cluster to update.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_581121 = path.getOrDefault("name")
  valid_581121 = validateParameter(valid_581121, JString, required = true,
                                 default = nil)
  if valid_581121 != nil:
    section.add "name", valid_581121
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_581122 = query.getOrDefault("upload_protocol")
  valid_581122 = validateParameter(valid_581122, JString, required = false,
                                 default = nil)
  if valid_581122 != nil:
    section.add "upload_protocol", valid_581122
  var valid_581123 = query.getOrDefault("fields")
  valid_581123 = validateParameter(valid_581123, JString, required = false,
                                 default = nil)
  if valid_581123 != nil:
    section.add "fields", valid_581123
  var valid_581124 = query.getOrDefault("quotaUser")
  valid_581124 = validateParameter(valid_581124, JString, required = false,
                                 default = nil)
  if valid_581124 != nil:
    section.add "quotaUser", valid_581124
  var valid_581125 = query.getOrDefault("alt")
  valid_581125 = validateParameter(valid_581125, JString, required = false,
                                 default = newJString("json"))
  if valid_581125 != nil:
    section.add "alt", valid_581125
  var valid_581126 = query.getOrDefault("pp")
  valid_581126 = validateParameter(valid_581126, JBool, required = false,
                                 default = newJBool(true))
  if valid_581126 != nil:
    section.add "pp", valid_581126
  var valid_581127 = query.getOrDefault("oauth_token")
  valid_581127 = validateParameter(valid_581127, JString, required = false,
                                 default = nil)
  if valid_581127 != nil:
    section.add "oauth_token", valid_581127
  var valid_581128 = query.getOrDefault("callback")
  valid_581128 = validateParameter(valid_581128, JString, required = false,
                                 default = nil)
  if valid_581128 != nil:
    section.add "callback", valid_581128
  var valid_581129 = query.getOrDefault("access_token")
  valid_581129 = validateParameter(valid_581129, JString, required = false,
                                 default = nil)
  if valid_581129 != nil:
    section.add "access_token", valid_581129
  var valid_581130 = query.getOrDefault("uploadType")
  valid_581130 = validateParameter(valid_581130, JString, required = false,
                                 default = nil)
  if valid_581130 != nil:
    section.add "uploadType", valid_581130
  var valid_581131 = query.getOrDefault("key")
  valid_581131 = validateParameter(valid_581131, JString, required = false,
                                 default = nil)
  if valid_581131 != nil:
    section.add "key", valid_581131
  var valid_581132 = query.getOrDefault("$.xgafv")
  valid_581132 = validateParameter(valid_581132, JString, required = false,
                                 default = newJString("1"))
  if valid_581132 != nil:
    section.add "$.xgafv", valid_581132
  var valid_581133 = query.getOrDefault("prettyPrint")
  valid_581133 = validateParameter(valid_581133, JBool, required = false,
                                 default = newJBool(true))
  if valid_581133 != nil:
    section.add "prettyPrint", valid_581133
  var valid_581134 = query.getOrDefault("bearer_token")
  valid_581134 = validateParameter(valid_581134, JString, required = false,
                                 default = nil)
  if valid_581134 != nil:
    section.add "bearer_token", valid_581134
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

proc call*(call_581136: Call_ContainerProjectsLocationsClustersUpdateMaster_581118;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the master of a specific cluster.
  ## 
  let valid = call_581136.validator(path, query, header, formData, body)
  let scheme = call_581136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581136.url(scheme.get, call_581136.host, call_581136.base,
                         call_581136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581136, url, valid)

proc call*(call_581137: Call_ContainerProjectsLocationsClustersUpdateMaster_581118;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersUpdateMaster
  ## Updates the master of a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster) of the cluster to update.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_581138 = newJObject()
  var query_581139 = newJObject()
  var body_581140 = newJObject()
  add(query_581139, "upload_protocol", newJString(uploadProtocol))
  add(query_581139, "fields", newJString(fields))
  add(query_581139, "quotaUser", newJString(quotaUser))
  add(path_581138, "name", newJString(name))
  add(query_581139, "alt", newJString(alt))
  add(query_581139, "pp", newJBool(pp))
  add(query_581139, "oauth_token", newJString(oauthToken))
  add(query_581139, "callback", newJString(callback))
  add(query_581139, "access_token", newJString(accessToken))
  add(query_581139, "uploadType", newJString(uploadType))
  add(query_581139, "key", newJString(key))
  add(query_581139, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_581140 = body
  add(query_581139, "prettyPrint", newJBool(prettyPrint))
  add(query_581139, "bearer_token", newJString(bearerToken))
  result = call_581137.call(path_581138, query_581139, nil, nil, body_581140)

var containerProjectsLocationsClustersUpdateMaster* = Call_ContainerProjectsLocationsClustersUpdateMaster_581118(
    name: "containerProjectsLocationsClustersUpdateMaster",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:updateMaster",
    validator: validate_ContainerProjectsLocationsClustersUpdateMaster_581119,
    base: "/", url: url_ContainerProjectsLocationsClustersUpdateMaster_581120,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersCreate_581164 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersCreate_581166(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersCreate_581165(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a cluster, consisting of the specified number and type of Google
  ## Compute Engine instances.
  ## 
  ## By default, the cluster is created in the project's
  ## [default network](/compute/docs/networks-and-firewalls#networks).
  ## 
  ## One firewall is added for the cluster. After cluster creation,
  ## the cluster creates routes for each node to allow the containers
  ## on that node to communicate with all other instances in the
  ## cluster.
  ## 
  ## Finally, an entry is added to the project's global metadata indicating
  ## which CIDR range is being used by the cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent (project and location) where the cluster will be created.
  ## Specified in the format 'projects/*/locations/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_581167 = path.getOrDefault("parent")
  valid_581167 = validateParameter(valid_581167, JString, required = true,
                                 default = nil)
  if valid_581167 != nil:
    section.add "parent", valid_581167
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_581168 = query.getOrDefault("upload_protocol")
  valid_581168 = validateParameter(valid_581168, JString, required = false,
                                 default = nil)
  if valid_581168 != nil:
    section.add "upload_protocol", valid_581168
  var valid_581169 = query.getOrDefault("fields")
  valid_581169 = validateParameter(valid_581169, JString, required = false,
                                 default = nil)
  if valid_581169 != nil:
    section.add "fields", valid_581169
  var valid_581170 = query.getOrDefault("quotaUser")
  valid_581170 = validateParameter(valid_581170, JString, required = false,
                                 default = nil)
  if valid_581170 != nil:
    section.add "quotaUser", valid_581170
  var valid_581171 = query.getOrDefault("alt")
  valid_581171 = validateParameter(valid_581171, JString, required = false,
                                 default = newJString("json"))
  if valid_581171 != nil:
    section.add "alt", valid_581171
  var valid_581172 = query.getOrDefault("pp")
  valid_581172 = validateParameter(valid_581172, JBool, required = false,
                                 default = newJBool(true))
  if valid_581172 != nil:
    section.add "pp", valid_581172
  var valid_581173 = query.getOrDefault("oauth_token")
  valid_581173 = validateParameter(valid_581173, JString, required = false,
                                 default = nil)
  if valid_581173 != nil:
    section.add "oauth_token", valid_581173
  var valid_581174 = query.getOrDefault("callback")
  valid_581174 = validateParameter(valid_581174, JString, required = false,
                                 default = nil)
  if valid_581174 != nil:
    section.add "callback", valid_581174
  var valid_581175 = query.getOrDefault("access_token")
  valid_581175 = validateParameter(valid_581175, JString, required = false,
                                 default = nil)
  if valid_581175 != nil:
    section.add "access_token", valid_581175
  var valid_581176 = query.getOrDefault("uploadType")
  valid_581176 = validateParameter(valid_581176, JString, required = false,
                                 default = nil)
  if valid_581176 != nil:
    section.add "uploadType", valid_581176
  var valid_581177 = query.getOrDefault("key")
  valid_581177 = validateParameter(valid_581177, JString, required = false,
                                 default = nil)
  if valid_581177 != nil:
    section.add "key", valid_581177
  var valid_581178 = query.getOrDefault("$.xgafv")
  valid_581178 = validateParameter(valid_581178, JString, required = false,
                                 default = newJString("1"))
  if valid_581178 != nil:
    section.add "$.xgafv", valid_581178
  var valid_581179 = query.getOrDefault("prettyPrint")
  valid_581179 = validateParameter(valid_581179, JBool, required = false,
                                 default = newJBool(true))
  if valid_581179 != nil:
    section.add "prettyPrint", valid_581179
  var valid_581180 = query.getOrDefault("bearer_token")
  valid_581180 = validateParameter(valid_581180, JString, required = false,
                                 default = nil)
  if valid_581180 != nil:
    section.add "bearer_token", valid_581180
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

proc call*(call_581182: Call_ContainerProjectsLocationsClustersCreate_581164;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a cluster, consisting of the specified number and type of Google
  ## Compute Engine instances.
  ## 
  ## By default, the cluster is created in the project's
  ## [default network](/compute/docs/networks-and-firewalls#networks).
  ## 
  ## One firewall is added for the cluster. After cluster creation,
  ## the cluster creates routes for each node to allow the containers
  ## on that node to communicate with all other instances in the
  ## cluster.
  ## 
  ## Finally, an entry is added to the project's global metadata indicating
  ## which CIDR range is being used by the cluster.
  ## 
  let valid = call_581182.validator(path, query, header, formData, body)
  let scheme = call_581182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581182.url(scheme.get, call_581182.host, call_581182.base,
                         call_581182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581182, url, valid)

proc call*(call_581183: Call_ContainerProjectsLocationsClustersCreate_581164;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersCreate
  ## Creates a cluster, consisting of the specified number and type of Google
  ## Compute Engine instances.
  ## 
  ## By default, the cluster is created in the project's
  ## [default network](/compute/docs/networks-and-firewalls#networks).
  ## 
  ## One firewall is added for the cluster. After cluster creation,
  ## the cluster creates routes for each node to allow the containers
  ## on that node to communicate with all other instances in the
  ## cluster.
  ## 
  ## Finally, an entry is added to the project's global metadata indicating
  ## which CIDR range is being used by the cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent (project and location) where the cluster will be created.
  ## Specified in the format 'projects/*/locations/*'.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_581184 = newJObject()
  var query_581185 = newJObject()
  var body_581186 = newJObject()
  add(query_581185, "upload_protocol", newJString(uploadProtocol))
  add(query_581185, "fields", newJString(fields))
  add(query_581185, "quotaUser", newJString(quotaUser))
  add(query_581185, "alt", newJString(alt))
  add(query_581185, "pp", newJBool(pp))
  add(query_581185, "oauth_token", newJString(oauthToken))
  add(query_581185, "callback", newJString(callback))
  add(query_581185, "access_token", newJString(accessToken))
  add(query_581185, "uploadType", newJString(uploadType))
  add(path_581184, "parent", newJString(parent))
  add(query_581185, "key", newJString(key))
  add(query_581185, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_581186 = body
  add(query_581185, "prettyPrint", newJBool(prettyPrint))
  add(query_581185, "bearer_token", newJString(bearerToken))
  result = call_581183.call(path_581184, query_581185, nil, nil, body_581186)

var containerProjectsLocationsClustersCreate* = Call_ContainerProjectsLocationsClustersCreate_581164(
    name: "containerProjectsLocationsClustersCreate", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/{parent}/clusters",
    validator: validate_ContainerProjectsLocationsClustersCreate_581165,
    base: "/", url: url_ContainerProjectsLocationsClustersCreate_581166,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersList_581141 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersList_581143(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersList_581142(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all clusters owned by a project in either the specified zone or all
  ## zones.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent (project and location) where the clusters will be listed.
  ## Specified in the format 'projects/*/locations/*'.
  ## Location "-" matches all zones and all regions.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_581144 = path.getOrDefault("parent")
  valid_581144 = validateParameter(valid_581144, JString, required = true,
                                 default = nil)
  if valid_581144 != nil:
    section.add "parent", valid_581144
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   zone: JString
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides, or "-" for all zones.
  ## This field is deprecated, use parent instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use parent instead.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_581145 = query.getOrDefault("upload_protocol")
  valid_581145 = validateParameter(valid_581145, JString, required = false,
                                 default = nil)
  if valid_581145 != nil:
    section.add "upload_protocol", valid_581145
  var valid_581146 = query.getOrDefault("fields")
  valid_581146 = validateParameter(valid_581146, JString, required = false,
                                 default = nil)
  if valid_581146 != nil:
    section.add "fields", valid_581146
  var valid_581147 = query.getOrDefault("quotaUser")
  valid_581147 = validateParameter(valid_581147, JString, required = false,
                                 default = nil)
  if valid_581147 != nil:
    section.add "quotaUser", valid_581147
  var valid_581148 = query.getOrDefault("alt")
  valid_581148 = validateParameter(valid_581148, JString, required = false,
                                 default = newJString("json"))
  if valid_581148 != nil:
    section.add "alt", valid_581148
  var valid_581149 = query.getOrDefault("pp")
  valid_581149 = validateParameter(valid_581149, JBool, required = false,
                                 default = newJBool(true))
  if valid_581149 != nil:
    section.add "pp", valid_581149
  var valid_581150 = query.getOrDefault("oauth_token")
  valid_581150 = validateParameter(valid_581150, JString, required = false,
                                 default = nil)
  if valid_581150 != nil:
    section.add "oauth_token", valid_581150
  var valid_581151 = query.getOrDefault("callback")
  valid_581151 = validateParameter(valid_581151, JString, required = false,
                                 default = nil)
  if valid_581151 != nil:
    section.add "callback", valid_581151
  var valid_581152 = query.getOrDefault("access_token")
  valid_581152 = validateParameter(valid_581152, JString, required = false,
                                 default = nil)
  if valid_581152 != nil:
    section.add "access_token", valid_581152
  var valid_581153 = query.getOrDefault("uploadType")
  valid_581153 = validateParameter(valid_581153, JString, required = false,
                                 default = nil)
  if valid_581153 != nil:
    section.add "uploadType", valid_581153
  var valid_581154 = query.getOrDefault("zone")
  valid_581154 = validateParameter(valid_581154, JString, required = false,
                                 default = nil)
  if valid_581154 != nil:
    section.add "zone", valid_581154
  var valid_581155 = query.getOrDefault("key")
  valid_581155 = validateParameter(valid_581155, JString, required = false,
                                 default = nil)
  if valid_581155 != nil:
    section.add "key", valid_581155
  var valid_581156 = query.getOrDefault("$.xgafv")
  valid_581156 = validateParameter(valid_581156, JString, required = false,
                                 default = newJString("1"))
  if valid_581156 != nil:
    section.add "$.xgafv", valid_581156
  var valid_581157 = query.getOrDefault("projectId")
  valid_581157 = validateParameter(valid_581157, JString, required = false,
                                 default = nil)
  if valid_581157 != nil:
    section.add "projectId", valid_581157
  var valid_581158 = query.getOrDefault("prettyPrint")
  valid_581158 = validateParameter(valid_581158, JBool, required = false,
                                 default = newJBool(true))
  if valid_581158 != nil:
    section.add "prettyPrint", valid_581158
  var valid_581159 = query.getOrDefault("bearer_token")
  valid_581159 = validateParameter(valid_581159, JString, required = false,
                                 default = nil)
  if valid_581159 != nil:
    section.add "bearer_token", valid_581159
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581160: Call_ContainerProjectsLocationsClustersList_581141;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all clusters owned by a project in either the specified zone or all
  ## zones.
  ## 
  let valid = call_581160.validator(path, query, header, formData, body)
  let scheme = call_581160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581160.url(scheme.get, call_581160.host, call_581160.base,
                         call_581160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581160, url, valid)

proc call*(call_581161: Call_ContainerProjectsLocationsClustersList_581141;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; zone: string = ""; key: string = ""; Xgafv: string = "1";
          projectId: string = ""; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersList
  ## Lists all clusters owned by a project in either the specified zone or all
  ## zones.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent (project and location) where the clusters will be listed.
  ## Specified in the format 'projects/*/locations/*'.
  ## Location "-" matches all zones and all regions.
  ##   zone: string
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides, or "-" for all zones.
  ## This field is deprecated, use parent instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use parent instead.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_581162 = newJObject()
  var query_581163 = newJObject()
  add(query_581163, "upload_protocol", newJString(uploadProtocol))
  add(query_581163, "fields", newJString(fields))
  add(query_581163, "quotaUser", newJString(quotaUser))
  add(query_581163, "alt", newJString(alt))
  add(query_581163, "pp", newJBool(pp))
  add(query_581163, "oauth_token", newJString(oauthToken))
  add(query_581163, "callback", newJString(callback))
  add(query_581163, "access_token", newJString(accessToken))
  add(query_581163, "uploadType", newJString(uploadType))
  add(path_581162, "parent", newJString(parent))
  add(query_581163, "zone", newJString(zone))
  add(query_581163, "key", newJString(key))
  add(query_581163, "$.xgafv", newJString(Xgafv))
  add(query_581163, "projectId", newJString(projectId))
  add(query_581163, "prettyPrint", newJBool(prettyPrint))
  add(query_581163, "bearer_token", newJString(bearerToken))
  result = call_581161.call(path_581162, query_581163, nil, nil, nil)

var containerProjectsLocationsClustersList* = Call_ContainerProjectsLocationsClustersList_581141(
    name: "containerProjectsLocationsClustersList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1beta1/{parent}/clusters",
    validator: validate_ContainerProjectsLocationsClustersList_581142, base: "/",
    url: url_ContainerProjectsLocationsClustersList_581143,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsCreate_581211 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersNodePoolsCreate_581213(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/nodePools")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsCreate_581212(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a node pool for a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent (project, location, cluster id) where the node pool will be created.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_581214 = path.getOrDefault("parent")
  valid_581214 = validateParameter(valid_581214, JString, required = true,
                                 default = nil)
  if valid_581214 != nil:
    section.add "parent", valid_581214
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_581215 = query.getOrDefault("upload_protocol")
  valid_581215 = validateParameter(valid_581215, JString, required = false,
                                 default = nil)
  if valid_581215 != nil:
    section.add "upload_protocol", valid_581215
  var valid_581216 = query.getOrDefault("fields")
  valid_581216 = validateParameter(valid_581216, JString, required = false,
                                 default = nil)
  if valid_581216 != nil:
    section.add "fields", valid_581216
  var valid_581217 = query.getOrDefault("quotaUser")
  valid_581217 = validateParameter(valid_581217, JString, required = false,
                                 default = nil)
  if valid_581217 != nil:
    section.add "quotaUser", valid_581217
  var valid_581218 = query.getOrDefault("alt")
  valid_581218 = validateParameter(valid_581218, JString, required = false,
                                 default = newJString("json"))
  if valid_581218 != nil:
    section.add "alt", valid_581218
  var valid_581219 = query.getOrDefault("pp")
  valid_581219 = validateParameter(valid_581219, JBool, required = false,
                                 default = newJBool(true))
  if valid_581219 != nil:
    section.add "pp", valid_581219
  var valid_581220 = query.getOrDefault("oauth_token")
  valid_581220 = validateParameter(valid_581220, JString, required = false,
                                 default = nil)
  if valid_581220 != nil:
    section.add "oauth_token", valid_581220
  var valid_581221 = query.getOrDefault("callback")
  valid_581221 = validateParameter(valid_581221, JString, required = false,
                                 default = nil)
  if valid_581221 != nil:
    section.add "callback", valid_581221
  var valid_581222 = query.getOrDefault("access_token")
  valid_581222 = validateParameter(valid_581222, JString, required = false,
                                 default = nil)
  if valid_581222 != nil:
    section.add "access_token", valid_581222
  var valid_581223 = query.getOrDefault("uploadType")
  valid_581223 = validateParameter(valid_581223, JString, required = false,
                                 default = nil)
  if valid_581223 != nil:
    section.add "uploadType", valid_581223
  var valid_581224 = query.getOrDefault("key")
  valid_581224 = validateParameter(valid_581224, JString, required = false,
                                 default = nil)
  if valid_581224 != nil:
    section.add "key", valid_581224
  var valid_581225 = query.getOrDefault("$.xgafv")
  valid_581225 = validateParameter(valid_581225, JString, required = false,
                                 default = newJString("1"))
  if valid_581225 != nil:
    section.add "$.xgafv", valid_581225
  var valid_581226 = query.getOrDefault("prettyPrint")
  valid_581226 = validateParameter(valid_581226, JBool, required = false,
                                 default = newJBool(true))
  if valid_581226 != nil:
    section.add "prettyPrint", valid_581226
  var valid_581227 = query.getOrDefault("bearer_token")
  valid_581227 = validateParameter(valid_581227, JString, required = false,
                                 default = nil)
  if valid_581227 != nil:
    section.add "bearer_token", valid_581227
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

proc call*(call_581229: Call_ContainerProjectsLocationsClustersNodePoolsCreate_581211;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a node pool for a cluster.
  ## 
  let valid = call_581229.validator(path, query, header, formData, body)
  let scheme = call_581229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581229.url(scheme.get, call_581229.host, call_581229.base,
                         call_581229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581229, url, valid)

proc call*(call_581230: Call_ContainerProjectsLocationsClustersNodePoolsCreate_581211;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsCreate
  ## Creates a node pool for a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent (project, location, cluster id) where the node pool will be created.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_581231 = newJObject()
  var query_581232 = newJObject()
  var body_581233 = newJObject()
  add(query_581232, "upload_protocol", newJString(uploadProtocol))
  add(query_581232, "fields", newJString(fields))
  add(query_581232, "quotaUser", newJString(quotaUser))
  add(query_581232, "alt", newJString(alt))
  add(query_581232, "pp", newJBool(pp))
  add(query_581232, "oauth_token", newJString(oauthToken))
  add(query_581232, "callback", newJString(callback))
  add(query_581232, "access_token", newJString(accessToken))
  add(query_581232, "uploadType", newJString(uploadType))
  add(path_581231, "parent", newJString(parent))
  add(query_581232, "key", newJString(key))
  add(query_581232, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_581233 = body
  add(query_581232, "prettyPrint", newJBool(prettyPrint))
  add(query_581232, "bearer_token", newJString(bearerToken))
  result = call_581230.call(path_581231, query_581232, nil, nil, body_581233)

var containerProjectsLocationsClustersNodePoolsCreate* = Call_ContainerProjectsLocationsClustersNodePoolsCreate_581211(
    name: "containerProjectsLocationsClustersNodePoolsCreate",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{parent}/nodePools",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsCreate_581212,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsCreate_581213,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsList_581187 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersNodePoolsList_581189(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/nodePools")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsList_581188(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the node pools for a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent (project, location, cluster id) where the node pools will be listed.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_581190 = path.getOrDefault("parent")
  valid_581190 = validateParameter(valid_581190, JString, required = true,
                                 default = nil)
  if valid_581190 != nil:
    section.add "parent", valid_581190
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   zone: JString
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use parent instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use parent instead.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: JString
  ##            : The name of the cluster.
  ## This field is deprecated, use parent instead.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_581191 = query.getOrDefault("upload_protocol")
  valid_581191 = validateParameter(valid_581191, JString, required = false,
                                 default = nil)
  if valid_581191 != nil:
    section.add "upload_protocol", valid_581191
  var valid_581192 = query.getOrDefault("fields")
  valid_581192 = validateParameter(valid_581192, JString, required = false,
                                 default = nil)
  if valid_581192 != nil:
    section.add "fields", valid_581192
  var valid_581193 = query.getOrDefault("quotaUser")
  valid_581193 = validateParameter(valid_581193, JString, required = false,
                                 default = nil)
  if valid_581193 != nil:
    section.add "quotaUser", valid_581193
  var valid_581194 = query.getOrDefault("alt")
  valid_581194 = validateParameter(valid_581194, JString, required = false,
                                 default = newJString("json"))
  if valid_581194 != nil:
    section.add "alt", valid_581194
  var valid_581195 = query.getOrDefault("pp")
  valid_581195 = validateParameter(valid_581195, JBool, required = false,
                                 default = newJBool(true))
  if valid_581195 != nil:
    section.add "pp", valid_581195
  var valid_581196 = query.getOrDefault("oauth_token")
  valid_581196 = validateParameter(valid_581196, JString, required = false,
                                 default = nil)
  if valid_581196 != nil:
    section.add "oauth_token", valid_581196
  var valid_581197 = query.getOrDefault("callback")
  valid_581197 = validateParameter(valid_581197, JString, required = false,
                                 default = nil)
  if valid_581197 != nil:
    section.add "callback", valid_581197
  var valid_581198 = query.getOrDefault("access_token")
  valid_581198 = validateParameter(valid_581198, JString, required = false,
                                 default = nil)
  if valid_581198 != nil:
    section.add "access_token", valid_581198
  var valid_581199 = query.getOrDefault("uploadType")
  valid_581199 = validateParameter(valid_581199, JString, required = false,
                                 default = nil)
  if valid_581199 != nil:
    section.add "uploadType", valid_581199
  var valid_581200 = query.getOrDefault("zone")
  valid_581200 = validateParameter(valid_581200, JString, required = false,
                                 default = nil)
  if valid_581200 != nil:
    section.add "zone", valid_581200
  var valid_581201 = query.getOrDefault("key")
  valid_581201 = validateParameter(valid_581201, JString, required = false,
                                 default = nil)
  if valid_581201 != nil:
    section.add "key", valid_581201
  var valid_581202 = query.getOrDefault("$.xgafv")
  valid_581202 = validateParameter(valid_581202, JString, required = false,
                                 default = newJString("1"))
  if valid_581202 != nil:
    section.add "$.xgafv", valid_581202
  var valid_581203 = query.getOrDefault("projectId")
  valid_581203 = validateParameter(valid_581203, JString, required = false,
                                 default = nil)
  if valid_581203 != nil:
    section.add "projectId", valid_581203
  var valid_581204 = query.getOrDefault("prettyPrint")
  valid_581204 = validateParameter(valid_581204, JBool, required = false,
                                 default = newJBool(true))
  if valid_581204 != nil:
    section.add "prettyPrint", valid_581204
  var valid_581205 = query.getOrDefault("clusterId")
  valid_581205 = validateParameter(valid_581205, JString, required = false,
                                 default = nil)
  if valid_581205 != nil:
    section.add "clusterId", valid_581205
  var valid_581206 = query.getOrDefault("bearer_token")
  valid_581206 = validateParameter(valid_581206, JString, required = false,
                                 default = nil)
  if valid_581206 != nil:
    section.add "bearer_token", valid_581206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581207: Call_ContainerProjectsLocationsClustersNodePoolsList_581187;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the node pools for a cluster.
  ## 
  let valid = call_581207.validator(path, query, header, formData, body)
  let scheme = call_581207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581207.url(scheme.get, call_581207.host, call_581207.base,
                         call_581207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581207, url, valid)

proc call*(call_581208: Call_ContainerProjectsLocationsClustersNodePoolsList_581187;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; zone: string = ""; key: string = ""; Xgafv: string = "1";
          projectId: string = ""; prettyPrint: bool = true; clusterId: string = "";
          bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsList
  ## Lists the node pools for a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent (project, location, cluster id) where the node pools will be listed.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   zone: string
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use parent instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use parent instead.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string
  ##            : The name of the cluster.
  ## This field is deprecated, use parent instead.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_581209 = newJObject()
  var query_581210 = newJObject()
  add(query_581210, "upload_protocol", newJString(uploadProtocol))
  add(query_581210, "fields", newJString(fields))
  add(query_581210, "quotaUser", newJString(quotaUser))
  add(query_581210, "alt", newJString(alt))
  add(query_581210, "pp", newJBool(pp))
  add(query_581210, "oauth_token", newJString(oauthToken))
  add(query_581210, "callback", newJString(callback))
  add(query_581210, "access_token", newJString(accessToken))
  add(query_581210, "uploadType", newJString(uploadType))
  add(path_581209, "parent", newJString(parent))
  add(query_581210, "zone", newJString(zone))
  add(query_581210, "key", newJString(key))
  add(query_581210, "$.xgafv", newJString(Xgafv))
  add(query_581210, "projectId", newJString(projectId))
  add(query_581210, "prettyPrint", newJBool(prettyPrint))
  add(query_581210, "clusterId", newJString(clusterId))
  add(query_581210, "bearer_token", newJString(bearerToken))
  result = call_581208.call(path_581209, query_581210, nil, nil, nil)

var containerProjectsLocationsClustersNodePoolsList* = Call_ContainerProjectsLocationsClustersNodePoolsList_581187(
    name: "containerProjectsLocationsClustersNodePoolsList",
    meth: HttpMethod.HttpGet, host: "container.googleapis.com",
    route: "/v1beta1/{parent}/nodePools",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsList_581188,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsList_581189,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsOperationsList_581234 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsOperationsList_581236(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsOperationsList_581235(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all operations in a project in a specific zone or all zones.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent (project and location) where the operations will be listed.
  ## Specified in the format 'projects/*/locations/*'.
  ## Location "-" matches all zones and all regions.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_581237 = path.getOrDefault("parent")
  valid_581237 = validateParameter(valid_581237, JString, required = true,
                                 default = nil)
  if valid_581237 != nil:
    section.add "parent", valid_581237
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   zone: JString
  ##       : The name of the Google Compute Engine [zone](/compute/docs/zones#available)
  ## to return operations for, or `-` for all zones.
  ## This field is deprecated, use parent instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use parent instead.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_581238 = query.getOrDefault("upload_protocol")
  valid_581238 = validateParameter(valid_581238, JString, required = false,
                                 default = nil)
  if valid_581238 != nil:
    section.add "upload_protocol", valid_581238
  var valid_581239 = query.getOrDefault("fields")
  valid_581239 = validateParameter(valid_581239, JString, required = false,
                                 default = nil)
  if valid_581239 != nil:
    section.add "fields", valid_581239
  var valid_581240 = query.getOrDefault("quotaUser")
  valid_581240 = validateParameter(valid_581240, JString, required = false,
                                 default = nil)
  if valid_581240 != nil:
    section.add "quotaUser", valid_581240
  var valid_581241 = query.getOrDefault("alt")
  valid_581241 = validateParameter(valid_581241, JString, required = false,
                                 default = newJString("json"))
  if valid_581241 != nil:
    section.add "alt", valid_581241
  var valid_581242 = query.getOrDefault("pp")
  valid_581242 = validateParameter(valid_581242, JBool, required = false,
                                 default = newJBool(true))
  if valid_581242 != nil:
    section.add "pp", valid_581242
  var valid_581243 = query.getOrDefault("oauth_token")
  valid_581243 = validateParameter(valid_581243, JString, required = false,
                                 default = nil)
  if valid_581243 != nil:
    section.add "oauth_token", valid_581243
  var valid_581244 = query.getOrDefault("callback")
  valid_581244 = validateParameter(valid_581244, JString, required = false,
                                 default = nil)
  if valid_581244 != nil:
    section.add "callback", valid_581244
  var valid_581245 = query.getOrDefault("access_token")
  valid_581245 = validateParameter(valid_581245, JString, required = false,
                                 default = nil)
  if valid_581245 != nil:
    section.add "access_token", valid_581245
  var valid_581246 = query.getOrDefault("uploadType")
  valid_581246 = validateParameter(valid_581246, JString, required = false,
                                 default = nil)
  if valid_581246 != nil:
    section.add "uploadType", valid_581246
  var valid_581247 = query.getOrDefault("zone")
  valid_581247 = validateParameter(valid_581247, JString, required = false,
                                 default = nil)
  if valid_581247 != nil:
    section.add "zone", valid_581247
  var valid_581248 = query.getOrDefault("key")
  valid_581248 = validateParameter(valid_581248, JString, required = false,
                                 default = nil)
  if valid_581248 != nil:
    section.add "key", valid_581248
  var valid_581249 = query.getOrDefault("$.xgafv")
  valid_581249 = validateParameter(valid_581249, JString, required = false,
                                 default = newJString("1"))
  if valid_581249 != nil:
    section.add "$.xgafv", valid_581249
  var valid_581250 = query.getOrDefault("projectId")
  valid_581250 = validateParameter(valid_581250, JString, required = false,
                                 default = nil)
  if valid_581250 != nil:
    section.add "projectId", valid_581250
  var valid_581251 = query.getOrDefault("prettyPrint")
  valid_581251 = validateParameter(valid_581251, JBool, required = false,
                                 default = newJBool(true))
  if valid_581251 != nil:
    section.add "prettyPrint", valid_581251
  var valid_581252 = query.getOrDefault("bearer_token")
  valid_581252 = validateParameter(valid_581252, JString, required = false,
                                 default = nil)
  if valid_581252 != nil:
    section.add "bearer_token", valid_581252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581253: Call_ContainerProjectsLocationsOperationsList_581234;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all operations in a project in a specific zone or all zones.
  ## 
  let valid = call_581253.validator(path, query, header, formData, body)
  let scheme = call_581253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581253.url(scheme.get, call_581253.host, call_581253.base,
                         call_581253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581253, url, valid)

proc call*(call_581254: Call_ContainerProjectsLocationsOperationsList_581234;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; zone: string = ""; key: string = ""; Xgafv: string = "1";
          projectId: string = ""; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## containerProjectsLocationsOperationsList
  ## Lists all operations in a project in a specific zone or all zones.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent (project and location) where the operations will be listed.
  ## Specified in the format 'projects/*/locations/*'.
  ## Location "-" matches all zones and all regions.
  ##   zone: string
  ##       : The name of the Google Compute Engine [zone](/compute/docs/zones#available)
  ## to return operations for, or `-` for all zones.
  ## This field is deprecated, use parent instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use parent instead.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_581255 = newJObject()
  var query_581256 = newJObject()
  add(query_581256, "upload_protocol", newJString(uploadProtocol))
  add(query_581256, "fields", newJString(fields))
  add(query_581256, "quotaUser", newJString(quotaUser))
  add(query_581256, "alt", newJString(alt))
  add(query_581256, "pp", newJBool(pp))
  add(query_581256, "oauth_token", newJString(oauthToken))
  add(query_581256, "callback", newJString(callback))
  add(query_581256, "access_token", newJString(accessToken))
  add(query_581256, "uploadType", newJString(uploadType))
  add(path_581255, "parent", newJString(parent))
  add(query_581256, "zone", newJString(zone))
  add(query_581256, "key", newJString(key))
  add(query_581256, "$.xgafv", newJString(Xgafv))
  add(query_581256, "projectId", newJString(projectId))
  add(query_581256, "prettyPrint", newJBool(prettyPrint))
  add(query_581256, "bearer_token", newJString(bearerToken))
  result = call_581254.call(path_581255, query_581256, nil, nil, nil)

var containerProjectsLocationsOperationsList* = Call_ContainerProjectsLocationsOperationsList_581234(
    name: "containerProjectsLocationsOperationsList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1beta1/{parent}/operations",
    validator: validate_ContainerProjectsLocationsOperationsList_581235,
    base: "/", url: url_ContainerProjectsLocationsOperationsList_581236,
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
