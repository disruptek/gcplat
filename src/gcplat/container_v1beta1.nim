
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593421): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ContainerProjectsZonesClustersCreate_593982 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersCreate_593984(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsZonesClustersCreate_593983(path: JsonNode;
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
  var valid_593985 = path.getOrDefault("zone")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "zone", valid_593985
  var valid_593986 = path.getOrDefault("projectId")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "projectId", valid_593986
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
  var valid_593987 = query.getOrDefault("upload_protocol")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "upload_protocol", valid_593987
  var valid_593988 = query.getOrDefault("fields")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "fields", valid_593988
  var valid_593989 = query.getOrDefault("quotaUser")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "quotaUser", valid_593989
  var valid_593990 = query.getOrDefault("alt")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = newJString("json"))
  if valid_593990 != nil:
    section.add "alt", valid_593990
  var valid_593991 = query.getOrDefault("pp")
  valid_593991 = validateParameter(valid_593991, JBool, required = false,
                                 default = newJBool(true))
  if valid_593991 != nil:
    section.add "pp", valid_593991
  var valid_593992 = query.getOrDefault("oauth_token")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "oauth_token", valid_593992
  var valid_593993 = query.getOrDefault("callback")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = nil)
  if valid_593993 != nil:
    section.add "callback", valid_593993
  var valid_593994 = query.getOrDefault("access_token")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "access_token", valid_593994
  var valid_593995 = query.getOrDefault("uploadType")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "uploadType", valid_593995
  var valid_593996 = query.getOrDefault("key")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "key", valid_593996
  var valid_593997 = query.getOrDefault("$.xgafv")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = newJString("1"))
  if valid_593997 != nil:
    section.add "$.xgafv", valid_593997
  var valid_593998 = query.getOrDefault("prettyPrint")
  valid_593998 = validateParameter(valid_593998, JBool, required = false,
                                 default = newJBool(true))
  if valid_593998 != nil:
    section.add "prettyPrint", valid_593998
  var valid_593999 = query.getOrDefault("bearer_token")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = nil)
  if valid_593999 != nil:
    section.add "bearer_token", valid_593999
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

proc call*(call_594001: Call_ContainerProjectsZonesClustersCreate_593982;
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
  let valid = call_594001.validator(path, query, header, formData, body)
  let scheme = call_594001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594001.url(scheme.get, call_594001.host, call_594001.base,
                         call_594001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594001, url, valid)

proc call*(call_594002: Call_ContainerProjectsZonesClustersCreate_593982;
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
  var path_594003 = newJObject()
  var query_594004 = newJObject()
  var body_594005 = newJObject()
  add(query_594004, "upload_protocol", newJString(uploadProtocol))
  add(path_594003, "zone", newJString(zone))
  add(query_594004, "fields", newJString(fields))
  add(query_594004, "quotaUser", newJString(quotaUser))
  add(query_594004, "alt", newJString(alt))
  add(query_594004, "pp", newJBool(pp))
  add(query_594004, "oauth_token", newJString(oauthToken))
  add(query_594004, "callback", newJString(callback))
  add(query_594004, "access_token", newJString(accessToken))
  add(query_594004, "uploadType", newJString(uploadType))
  add(query_594004, "key", newJString(key))
  add(path_594003, "projectId", newJString(projectId))
  add(query_594004, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594005 = body
  add(query_594004, "prettyPrint", newJBool(prettyPrint))
  add(query_594004, "bearer_token", newJString(bearerToken))
  result = call_594002.call(path_594003, query_594004, nil, nil, body_594005)

var containerProjectsZonesClustersCreate* = Call_ContainerProjectsZonesClustersCreate_593982(
    name: "containerProjectsZonesClustersCreate", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com",
    route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters",
    validator: validate_ContainerProjectsZonesClustersCreate_593983, base: "/",
    url: url_ContainerProjectsZonesClustersCreate_593984, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersList_593690 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersList_593692(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsZonesClustersList_593691(path: JsonNode;
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
  var valid_593818 = path.getOrDefault("zone")
  valid_593818 = validateParameter(valid_593818, JString, required = true,
                                 default = nil)
  if valid_593818 != nil:
    section.add "zone", valid_593818
  var valid_593819 = path.getOrDefault("projectId")
  valid_593819 = validateParameter(valid_593819, JString, required = true,
                                 default = nil)
  if valid_593819 != nil:
    section.add "projectId", valid_593819
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
  var valid_593820 = query.getOrDefault("upload_protocol")
  valid_593820 = validateParameter(valid_593820, JString, required = false,
                                 default = nil)
  if valid_593820 != nil:
    section.add "upload_protocol", valid_593820
  var valid_593821 = query.getOrDefault("fields")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = nil)
  if valid_593821 != nil:
    section.add "fields", valid_593821
  var valid_593822 = query.getOrDefault("quotaUser")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = nil)
  if valid_593822 != nil:
    section.add "quotaUser", valid_593822
  var valid_593836 = query.getOrDefault("alt")
  valid_593836 = validateParameter(valid_593836, JString, required = false,
                                 default = newJString("json"))
  if valid_593836 != nil:
    section.add "alt", valid_593836
  var valid_593837 = query.getOrDefault("pp")
  valid_593837 = validateParameter(valid_593837, JBool, required = false,
                                 default = newJBool(true))
  if valid_593837 != nil:
    section.add "pp", valid_593837
  var valid_593838 = query.getOrDefault("oauth_token")
  valid_593838 = validateParameter(valid_593838, JString, required = false,
                                 default = nil)
  if valid_593838 != nil:
    section.add "oauth_token", valid_593838
  var valid_593839 = query.getOrDefault("callback")
  valid_593839 = validateParameter(valid_593839, JString, required = false,
                                 default = nil)
  if valid_593839 != nil:
    section.add "callback", valid_593839
  var valid_593840 = query.getOrDefault("access_token")
  valid_593840 = validateParameter(valid_593840, JString, required = false,
                                 default = nil)
  if valid_593840 != nil:
    section.add "access_token", valid_593840
  var valid_593841 = query.getOrDefault("uploadType")
  valid_593841 = validateParameter(valid_593841, JString, required = false,
                                 default = nil)
  if valid_593841 != nil:
    section.add "uploadType", valid_593841
  var valid_593842 = query.getOrDefault("parent")
  valid_593842 = validateParameter(valid_593842, JString, required = false,
                                 default = nil)
  if valid_593842 != nil:
    section.add "parent", valid_593842
  var valid_593843 = query.getOrDefault("key")
  valid_593843 = validateParameter(valid_593843, JString, required = false,
                                 default = nil)
  if valid_593843 != nil:
    section.add "key", valid_593843
  var valid_593844 = query.getOrDefault("$.xgafv")
  valid_593844 = validateParameter(valid_593844, JString, required = false,
                                 default = newJString("1"))
  if valid_593844 != nil:
    section.add "$.xgafv", valid_593844
  var valid_593845 = query.getOrDefault("prettyPrint")
  valid_593845 = validateParameter(valid_593845, JBool, required = false,
                                 default = newJBool(true))
  if valid_593845 != nil:
    section.add "prettyPrint", valid_593845
  var valid_593846 = query.getOrDefault("bearer_token")
  valid_593846 = validateParameter(valid_593846, JString, required = false,
                                 default = nil)
  if valid_593846 != nil:
    section.add "bearer_token", valid_593846
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593869: Call_ContainerProjectsZonesClustersList_593690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all clusters owned by a project in either the specified zone or all
  ## zones.
  ## 
  let valid = call_593869.validator(path, query, header, formData, body)
  let scheme = call_593869.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593869.url(scheme.get, call_593869.host, call_593869.base,
                         call_593869.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593869, url, valid)

proc call*(call_593940: Call_ContainerProjectsZonesClustersList_593690;
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
  var path_593941 = newJObject()
  var query_593943 = newJObject()
  add(query_593943, "upload_protocol", newJString(uploadProtocol))
  add(path_593941, "zone", newJString(zone))
  add(query_593943, "fields", newJString(fields))
  add(query_593943, "quotaUser", newJString(quotaUser))
  add(query_593943, "alt", newJString(alt))
  add(query_593943, "pp", newJBool(pp))
  add(query_593943, "oauth_token", newJString(oauthToken))
  add(query_593943, "callback", newJString(callback))
  add(query_593943, "access_token", newJString(accessToken))
  add(query_593943, "uploadType", newJString(uploadType))
  add(query_593943, "parent", newJString(parent))
  add(query_593943, "key", newJString(key))
  add(path_593941, "projectId", newJString(projectId))
  add(query_593943, "$.xgafv", newJString(Xgafv))
  add(query_593943, "prettyPrint", newJBool(prettyPrint))
  add(query_593943, "bearer_token", newJString(bearerToken))
  result = call_593940.call(path_593941, query_593943, nil, nil, nil)

var containerProjectsZonesClustersList* = Call_ContainerProjectsZonesClustersList_593690(
    name: "containerProjectsZonesClustersList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters",
    validator: validate_ContainerProjectsZonesClustersList_593691, base: "/",
    url: url_ContainerProjectsZonesClustersList_593692, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersUpdate_594030 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersUpdate_594032(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsZonesClustersUpdate_594031(path: JsonNode;
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
  var valid_594033 = path.getOrDefault("zone")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "zone", valid_594033
  var valid_594034 = path.getOrDefault("projectId")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "projectId", valid_594034
  var valid_594035 = path.getOrDefault("clusterId")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "clusterId", valid_594035
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
  var valid_594036 = query.getOrDefault("upload_protocol")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = nil)
  if valid_594036 != nil:
    section.add "upload_protocol", valid_594036
  var valid_594037 = query.getOrDefault("fields")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = nil)
  if valid_594037 != nil:
    section.add "fields", valid_594037
  var valid_594038 = query.getOrDefault("quotaUser")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "quotaUser", valid_594038
  var valid_594039 = query.getOrDefault("alt")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = newJString("json"))
  if valid_594039 != nil:
    section.add "alt", valid_594039
  var valid_594040 = query.getOrDefault("pp")
  valid_594040 = validateParameter(valid_594040, JBool, required = false,
                                 default = newJBool(true))
  if valid_594040 != nil:
    section.add "pp", valid_594040
  var valid_594041 = query.getOrDefault("oauth_token")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = nil)
  if valid_594041 != nil:
    section.add "oauth_token", valid_594041
  var valid_594042 = query.getOrDefault("callback")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = nil)
  if valid_594042 != nil:
    section.add "callback", valid_594042
  var valid_594043 = query.getOrDefault("access_token")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = nil)
  if valid_594043 != nil:
    section.add "access_token", valid_594043
  var valid_594044 = query.getOrDefault("uploadType")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = nil)
  if valid_594044 != nil:
    section.add "uploadType", valid_594044
  var valid_594045 = query.getOrDefault("key")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = nil)
  if valid_594045 != nil:
    section.add "key", valid_594045
  var valid_594046 = query.getOrDefault("$.xgafv")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = newJString("1"))
  if valid_594046 != nil:
    section.add "$.xgafv", valid_594046
  var valid_594047 = query.getOrDefault("prettyPrint")
  valid_594047 = validateParameter(valid_594047, JBool, required = false,
                                 default = newJBool(true))
  if valid_594047 != nil:
    section.add "prettyPrint", valid_594047
  var valid_594048 = query.getOrDefault("bearer_token")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "bearer_token", valid_594048
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

proc call*(call_594050: Call_ContainerProjectsZonesClustersUpdate_594030;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the settings of a specific cluster.
  ## 
  let valid = call_594050.validator(path, query, header, formData, body)
  let scheme = call_594050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594050.url(scheme.get, call_594050.host, call_594050.base,
                         call_594050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594050, url, valid)

proc call*(call_594051: Call_ContainerProjectsZonesClustersUpdate_594030;
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
  var path_594052 = newJObject()
  var query_594053 = newJObject()
  var body_594054 = newJObject()
  add(query_594053, "upload_protocol", newJString(uploadProtocol))
  add(path_594052, "zone", newJString(zone))
  add(query_594053, "fields", newJString(fields))
  add(query_594053, "quotaUser", newJString(quotaUser))
  add(query_594053, "alt", newJString(alt))
  add(query_594053, "pp", newJBool(pp))
  add(query_594053, "oauth_token", newJString(oauthToken))
  add(query_594053, "callback", newJString(callback))
  add(query_594053, "access_token", newJString(accessToken))
  add(query_594053, "uploadType", newJString(uploadType))
  add(query_594053, "key", newJString(key))
  add(path_594052, "projectId", newJString(projectId))
  add(query_594053, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594054 = body
  add(query_594053, "prettyPrint", newJBool(prettyPrint))
  add(path_594052, "clusterId", newJString(clusterId))
  add(query_594053, "bearer_token", newJString(bearerToken))
  result = call_594051.call(path_594052, query_594053, nil, nil, body_594054)

var containerProjectsZonesClustersUpdate* = Call_ContainerProjectsZonesClustersUpdate_594030(
    name: "containerProjectsZonesClustersUpdate", meth: HttpMethod.HttpPut,
    host: "container.googleapis.com",
    route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}",
    validator: validate_ContainerProjectsZonesClustersUpdate_594031, base: "/",
    url: url_ContainerProjectsZonesClustersUpdate_594032, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersGet_594006 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersGet_594008(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsZonesClustersGet_594007(path: JsonNode;
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
  var valid_594009 = path.getOrDefault("zone")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "zone", valid_594009
  var valid_594010 = path.getOrDefault("projectId")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "projectId", valid_594010
  var valid_594011 = path.getOrDefault("clusterId")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "clusterId", valid_594011
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
  var valid_594012 = query.getOrDefault("upload_protocol")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "upload_protocol", valid_594012
  var valid_594013 = query.getOrDefault("fields")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "fields", valid_594013
  var valid_594014 = query.getOrDefault("quotaUser")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "quotaUser", valid_594014
  var valid_594015 = query.getOrDefault("alt")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = newJString("json"))
  if valid_594015 != nil:
    section.add "alt", valid_594015
  var valid_594016 = query.getOrDefault("pp")
  valid_594016 = validateParameter(valid_594016, JBool, required = false,
                                 default = newJBool(true))
  if valid_594016 != nil:
    section.add "pp", valid_594016
  var valid_594017 = query.getOrDefault("oauth_token")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "oauth_token", valid_594017
  var valid_594018 = query.getOrDefault("callback")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = nil)
  if valid_594018 != nil:
    section.add "callback", valid_594018
  var valid_594019 = query.getOrDefault("access_token")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = nil)
  if valid_594019 != nil:
    section.add "access_token", valid_594019
  var valid_594020 = query.getOrDefault("uploadType")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = nil)
  if valid_594020 != nil:
    section.add "uploadType", valid_594020
  var valid_594021 = query.getOrDefault("key")
  valid_594021 = validateParameter(valid_594021, JString, required = false,
                                 default = nil)
  if valid_594021 != nil:
    section.add "key", valid_594021
  var valid_594022 = query.getOrDefault("name")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = nil)
  if valid_594022 != nil:
    section.add "name", valid_594022
  var valid_594023 = query.getOrDefault("$.xgafv")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = newJString("1"))
  if valid_594023 != nil:
    section.add "$.xgafv", valid_594023
  var valid_594024 = query.getOrDefault("prettyPrint")
  valid_594024 = validateParameter(valid_594024, JBool, required = false,
                                 default = newJBool(true))
  if valid_594024 != nil:
    section.add "prettyPrint", valid_594024
  var valid_594025 = query.getOrDefault("bearer_token")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "bearer_token", valid_594025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594026: Call_ContainerProjectsZonesClustersGet_594006;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of a specific cluster.
  ## 
  let valid = call_594026.validator(path, query, header, formData, body)
  let scheme = call_594026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594026.url(scheme.get, call_594026.host, call_594026.base,
                         call_594026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594026, url, valid)

proc call*(call_594027: Call_ContainerProjectsZonesClustersGet_594006;
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
  var path_594028 = newJObject()
  var query_594029 = newJObject()
  add(query_594029, "upload_protocol", newJString(uploadProtocol))
  add(path_594028, "zone", newJString(zone))
  add(query_594029, "fields", newJString(fields))
  add(query_594029, "quotaUser", newJString(quotaUser))
  add(query_594029, "alt", newJString(alt))
  add(query_594029, "pp", newJBool(pp))
  add(query_594029, "oauth_token", newJString(oauthToken))
  add(query_594029, "callback", newJString(callback))
  add(query_594029, "access_token", newJString(accessToken))
  add(query_594029, "uploadType", newJString(uploadType))
  add(query_594029, "key", newJString(key))
  add(query_594029, "name", newJString(name))
  add(path_594028, "projectId", newJString(projectId))
  add(query_594029, "$.xgafv", newJString(Xgafv))
  add(query_594029, "prettyPrint", newJBool(prettyPrint))
  add(path_594028, "clusterId", newJString(clusterId))
  add(query_594029, "bearer_token", newJString(bearerToken))
  result = call_594027.call(path_594028, query_594029, nil, nil, nil)

var containerProjectsZonesClustersGet* = Call_ContainerProjectsZonesClustersGet_594006(
    name: "containerProjectsZonesClustersGet", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}",
    validator: validate_ContainerProjectsZonesClustersGet_594007, base: "/",
    url: url_ContainerProjectsZonesClustersGet_594008, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersDelete_594055 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersDelete_594057(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsZonesClustersDelete_594056(path: JsonNode;
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
  var valid_594058 = path.getOrDefault("zone")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "zone", valid_594058
  var valid_594059 = path.getOrDefault("projectId")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "projectId", valid_594059
  var valid_594060 = path.getOrDefault("clusterId")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "clusterId", valid_594060
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
  var valid_594061 = query.getOrDefault("upload_protocol")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "upload_protocol", valid_594061
  var valid_594062 = query.getOrDefault("fields")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "fields", valid_594062
  var valid_594063 = query.getOrDefault("quotaUser")
  valid_594063 = validateParameter(valid_594063, JString, required = false,
                                 default = nil)
  if valid_594063 != nil:
    section.add "quotaUser", valid_594063
  var valid_594064 = query.getOrDefault("alt")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = newJString("json"))
  if valid_594064 != nil:
    section.add "alt", valid_594064
  var valid_594065 = query.getOrDefault("pp")
  valid_594065 = validateParameter(valid_594065, JBool, required = false,
                                 default = newJBool(true))
  if valid_594065 != nil:
    section.add "pp", valid_594065
  var valid_594066 = query.getOrDefault("oauth_token")
  valid_594066 = validateParameter(valid_594066, JString, required = false,
                                 default = nil)
  if valid_594066 != nil:
    section.add "oauth_token", valid_594066
  var valid_594067 = query.getOrDefault("callback")
  valid_594067 = validateParameter(valid_594067, JString, required = false,
                                 default = nil)
  if valid_594067 != nil:
    section.add "callback", valid_594067
  var valid_594068 = query.getOrDefault("access_token")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = nil)
  if valid_594068 != nil:
    section.add "access_token", valid_594068
  var valid_594069 = query.getOrDefault("uploadType")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = nil)
  if valid_594069 != nil:
    section.add "uploadType", valid_594069
  var valid_594070 = query.getOrDefault("key")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "key", valid_594070
  var valid_594071 = query.getOrDefault("name")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = nil)
  if valid_594071 != nil:
    section.add "name", valid_594071
  var valid_594072 = query.getOrDefault("$.xgafv")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = newJString("1"))
  if valid_594072 != nil:
    section.add "$.xgafv", valid_594072
  var valid_594073 = query.getOrDefault("prettyPrint")
  valid_594073 = validateParameter(valid_594073, JBool, required = false,
                                 default = newJBool(true))
  if valid_594073 != nil:
    section.add "prettyPrint", valid_594073
  var valid_594074 = query.getOrDefault("bearer_token")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = nil)
  if valid_594074 != nil:
    section.add "bearer_token", valid_594074
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594075: Call_ContainerProjectsZonesClustersDelete_594055;
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
  let valid = call_594075.validator(path, query, header, formData, body)
  let scheme = call_594075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594075.url(scheme.get, call_594075.host, call_594075.base,
                         call_594075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594075, url, valid)

proc call*(call_594076: Call_ContainerProjectsZonesClustersDelete_594055;
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
  var path_594077 = newJObject()
  var query_594078 = newJObject()
  add(query_594078, "upload_protocol", newJString(uploadProtocol))
  add(path_594077, "zone", newJString(zone))
  add(query_594078, "fields", newJString(fields))
  add(query_594078, "quotaUser", newJString(quotaUser))
  add(query_594078, "alt", newJString(alt))
  add(query_594078, "pp", newJBool(pp))
  add(query_594078, "oauth_token", newJString(oauthToken))
  add(query_594078, "callback", newJString(callback))
  add(query_594078, "access_token", newJString(accessToken))
  add(query_594078, "uploadType", newJString(uploadType))
  add(query_594078, "key", newJString(key))
  add(query_594078, "name", newJString(name))
  add(path_594077, "projectId", newJString(projectId))
  add(query_594078, "$.xgafv", newJString(Xgafv))
  add(query_594078, "prettyPrint", newJBool(prettyPrint))
  add(path_594077, "clusterId", newJString(clusterId))
  add(query_594078, "bearer_token", newJString(bearerToken))
  result = call_594076.call(path_594077, query_594078, nil, nil, nil)

var containerProjectsZonesClustersDelete* = Call_ContainerProjectsZonesClustersDelete_594055(
    name: "containerProjectsZonesClustersDelete", meth: HttpMethod.HttpDelete,
    host: "container.googleapis.com",
    route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}",
    validator: validate_ContainerProjectsZonesClustersDelete_594056, base: "/",
    url: url_ContainerProjectsZonesClustersDelete_594057, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersAddons_594079 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersAddons_594081(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsZonesClustersAddons_594080(path: JsonNode;
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
  var valid_594082 = path.getOrDefault("zone")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "zone", valid_594082
  var valid_594083 = path.getOrDefault("projectId")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "projectId", valid_594083
  var valid_594084 = path.getOrDefault("clusterId")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "clusterId", valid_594084
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
  var valid_594085 = query.getOrDefault("upload_protocol")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = nil)
  if valid_594085 != nil:
    section.add "upload_protocol", valid_594085
  var valid_594086 = query.getOrDefault("fields")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = nil)
  if valid_594086 != nil:
    section.add "fields", valid_594086
  var valid_594087 = query.getOrDefault("quotaUser")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = nil)
  if valid_594087 != nil:
    section.add "quotaUser", valid_594087
  var valid_594088 = query.getOrDefault("alt")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = newJString("json"))
  if valid_594088 != nil:
    section.add "alt", valid_594088
  var valid_594089 = query.getOrDefault("pp")
  valid_594089 = validateParameter(valid_594089, JBool, required = false,
                                 default = newJBool(true))
  if valid_594089 != nil:
    section.add "pp", valid_594089
  var valid_594090 = query.getOrDefault("oauth_token")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = nil)
  if valid_594090 != nil:
    section.add "oauth_token", valid_594090
  var valid_594091 = query.getOrDefault("callback")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = nil)
  if valid_594091 != nil:
    section.add "callback", valid_594091
  var valid_594092 = query.getOrDefault("access_token")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = nil)
  if valid_594092 != nil:
    section.add "access_token", valid_594092
  var valid_594093 = query.getOrDefault("uploadType")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "uploadType", valid_594093
  var valid_594094 = query.getOrDefault("key")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = nil)
  if valid_594094 != nil:
    section.add "key", valid_594094
  var valid_594095 = query.getOrDefault("$.xgafv")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = newJString("1"))
  if valid_594095 != nil:
    section.add "$.xgafv", valid_594095
  var valid_594096 = query.getOrDefault("prettyPrint")
  valid_594096 = validateParameter(valid_594096, JBool, required = false,
                                 default = newJBool(true))
  if valid_594096 != nil:
    section.add "prettyPrint", valid_594096
  var valid_594097 = query.getOrDefault("bearer_token")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = nil)
  if valid_594097 != nil:
    section.add "bearer_token", valid_594097
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

proc call*(call_594099: Call_ContainerProjectsZonesClustersAddons_594079;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the addons of a specific cluster.
  ## 
  let valid = call_594099.validator(path, query, header, formData, body)
  let scheme = call_594099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594099.url(scheme.get, call_594099.host, call_594099.base,
                         call_594099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594099, url, valid)

proc call*(call_594100: Call_ContainerProjectsZonesClustersAddons_594079;
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
  var path_594101 = newJObject()
  var query_594102 = newJObject()
  var body_594103 = newJObject()
  add(query_594102, "upload_protocol", newJString(uploadProtocol))
  add(path_594101, "zone", newJString(zone))
  add(query_594102, "fields", newJString(fields))
  add(query_594102, "quotaUser", newJString(quotaUser))
  add(query_594102, "alt", newJString(alt))
  add(query_594102, "pp", newJBool(pp))
  add(query_594102, "oauth_token", newJString(oauthToken))
  add(query_594102, "callback", newJString(callback))
  add(query_594102, "access_token", newJString(accessToken))
  add(query_594102, "uploadType", newJString(uploadType))
  add(query_594102, "key", newJString(key))
  add(path_594101, "projectId", newJString(projectId))
  add(query_594102, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594103 = body
  add(query_594102, "prettyPrint", newJBool(prettyPrint))
  add(path_594101, "clusterId", newJString(clusterId))
  add(query_594102, "bearer_token", newJString(bearerToken))
  result = call_594100.call(path_594101, query_594102, nil, nil, body_594103)

var containerProjectsZonesClustersAddons* = Call_ContainerProjectsZonesClustersAddons_594079(
    name: "containerProjectsZonesClustersAddons", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/addons",
    validator: validate_ContainerProjectsZonesClustersAddons_594080, base: "/",
    url: url_ContainerProjectsZonesClustersAddons_594081, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersLegacyAbac_594104 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersLegacyAbac_594106(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsZonesClustersLegacyAbac_594105(path: JsonNode;
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
  var valid_594107 = path.getOrDefault("zone")
  valid_594107 = validateParameter(valid_594107, JString, required = true,
                                 default = nil)
  if valid_594107 != nil:
    section.add "zone", valid_594107
  var valid_594108 = path.getOrDefault("projectId")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "projectId", valid_594108
  var valid_594109 = path.getOrDefault("clusterId")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "clusterId", valid_594109
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
  var valid_594110 = query.getOrDefault("upload_protocol")
  valid_594110 = validateParameter(valid_594110, JString, required = false,
                                 default = nil)
  if valid_594110 != nil:
    section.add "upload_protocol", valid_594110
  var valid_594111 = query.getOrDefault("fields")
  valid_594111 = validateParameter(valid_594111, JString, required = false,
                                 default = nil)
  if valid_594111 != nil:
    section.add "fields", valid_594111
  var valid_594112 = query.getOrDefault("quotaUser")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = nil)
  if valid_594112 != nil:
    section.add "quotaUser", valid_594112
  var valid_594113 = query.getOrDefault("alt")
  valid_594113 = validateParameter(valid_594113, JString, required = false,
                                 default = newJString("json"))
  if valid_594113 != nil:
    section.add "alt", valid_594113
  var valid_594114 = query.getOrDefault("pp")
  valid_594114 = validateParameter(valid_594114, JBool, required = false,
                                 default = newJBool(true))
  if valid_594114 != nil:
    section.add "pp", valid_594114
  var valid_594115 = query.getOrDefault("oauth_token")
  valid_594115 = validateParameter(valid_594115, JString, required = false,
                                 default = nil)
  if valid_594115 != nil:
    section.add "oauth_token", valid_594115
  var valid_594116 = query.getOrDefault("callback")
  valid_594116 = validateParameter(valid_594116, JString, required = false,
                                 default = nil)
  if valid_594116 != nil:
    section.add "callback", valid_594116
  var valid_594117 = query.getOrDefault("access_token")
  valid_594117 = validateParameter(valid_594117, JString, required = false,
                                 default = nil)
  if valid_594117 != nil:
    section.add "access_token", valid_594117
  var valid_594118 = query.getOrDefault("uploadType")
  valid_594118 = validateParameter(valid_594118, JString, required = false,
                                 default = nil)
  if valid_594118 != nil:
    section.add "uploadType", valid_594118
  var valid_594119 = query.getOrDefault("key")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "key", valid_594119
  var valid_594120 = query.getOrDefault("$.xgafv")
  valid_594120 = validateParameter(valid_594120, JString, required = false,
                                 default = newJString("1"))
  if valid_594120 != nil:
    section.add "$.xgafv", valid_594120
  var valid_594121 = query.getOrDefault("prettyPrint")
  valid_594121 = validateParameter(valid_594121, JBool, required = false,
                                 default = newJBool(true))
  if valid_594121 != nil:
    section.add "prettyPrint", valid_594121
  var valid_594122 = query.getOrDefault("bearer_token")
  valid_594122 = validateParameter(valid_594122, JString, required = false,
                                 default = nil)
  if valid_594122 != nil:
    section.add "bearer_token", valid_594122
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

proc call*(call_594124: Call_ContainerProjectsZonesClustersLegacyAbac_594104;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ## 
  let valid = call_594124.validator(path, query, header, formData, body)
  let scheme = call_594124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594124.url(scheme.get, call_594124.host, call_594124.base,
                         call_594124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594124, url, valid)

proc call*(call_594125: Call_ContainerProjectsZonesClustersLegacyAbac_594104;
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
  var path_594126 = newJObject()
  var query_594127 = newJObject()
  var body_594128 = newJObject()
  add(query_594127, "upload_protocol", newJString(uploadProtocol))
  add(path_594126, "zone", newJString(zone))
  add(query_594127, "fields", newJString(fields))
  add(query_594127, "quotaUser", newJString(quotaUser))
  add(query_594127, "alt", newJString(alt))
  add(query_594127, "pp", newJBool(pp))
  add(query_594127, "oauth_token", newJString(oauthToken))
  add(query_594127, "callback", newJString(callback))
  add(query_594127, "access_token", newJString(accessToken))
  add(query_594127, "uploadType", newJString(uploadType))
  add(query_594127, "key", newJString(key))
  add(path_594126, "projectId", newJString(projectId))
  add(query_594127, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594128 = body
  add(query_594127, "prettyPrint", newJBool(prettyPrint))
  add(path_594126, "clusterId", newJString(clusterId))
  add(query_594127, "bearer_token", newJString(bearerToken))
  result = call_594125.call(path_594126, query_594127, nil, nil, body_594128)

var containerProjectsZonesClustersLegacyAbac* = Call_ContainerProjectsZonesClustersLegacyAbac_594104(
    name: "containerProjectsZonesClustersLegacyAbac", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/legacyAbac",
    validator: validate_ContainerProjectsZonesClustersLegacyAbac_594105,
    base: "/", url: url_ContainerProjectsZonesClustersLegacyAbac_594106,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersLocations_594129 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersLocations_594131(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsZonesClustersLocations_594130(path: JsonNode;
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
  var valid_594132 = path.getOrDefault("zone")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "zone", valid_594132
  var valid_594133 = path.getOrDefault("projectId")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = nil)
  if valid_594133 != nil:
    section.add "projectId", valid_594133
  var valid_594134 = path.getOrDefault("clusterId")
  valid_594134 = validateParameter(valid_594134, JString, required = true,
                                 default = nil)
  if valid_594134 != nil:
    section.add "clusterId", valid_594134
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
  var valid_594135 = query.getOrDefault("upload_protocol")
  valid_594135 = validateParameter(valid_594135, JString, required = false,
                                 default = nil)
  if valid_594135 != nil:
    section.add "upload_protocol", valid_594135
  var valid_594136 = query.getOrDefault("fields")
  valid_594136 = validateParameter(valid_594136, JString, required = false,
                                 default = nil)
  if valid_594136 != nil:
    section.add "fields", valid_594136
  var valid_594137 = query.getOrDefault("quotaUser")
  valid_594137 = validateParameter(valid_594137, JString, required = false,
                                 default = nil)
  if valid_594137 != nil:
    section.add "quotaUser", valid_594137
  var valid_594138 = query.getOrDefault("alt")
  valid_594138 = validateParameter(valid_594138, JString, required = false,
                                 default = newJString("json"))
  if valid_594138 != nil:
    section.add "alt", valid_594138
  var valid_594139 = query.getOrDefault("pp")
  valid_594139 = validateParameter(valid_594139, JBool, required = false,
                                 default = newJBool(true))
  if valid_594139 != nil:
    section.add "pp", valid_594139
  var valid_594140 = query.getOrDefault("oauth_token")
  valid_594140 = validateParameter(valid_594140, JString, required = false,
                                 default = nil)
  if valid_594140 != nil:
    section.add "oauth_token", valid_594140
  var valid_594141 = query.getOrDefault("callback")
  valid_594141 = validateParameter(valid_594141, JString, required = false,
                                 default = nil)
  if valid_594141 != nil:
    section.add "callback", valid_594141
  var valid_594142 = query.getOrDefault("access_token")
  valid_594142 = validateParameter(valid_594142, JString, required = false,
                                 default = nil)
  if valid_594142 != nil:
    section.add "access_token", valid_594142
  var valid_594143 = query.getOrDefault("uploadType")
  valid_594143 = validateParameter(valid_594143, JString, required = false,
                                 default = nil)
  if valid_594143 != nil:
    section.add "uploadType", valid_594143
  var valid_594144 = query.getOrDefault("key")
  valid_594144 = validateParameter(valid_594144, JString, required = false,
                                 default = nil)
  if valid_594144 != nil:
    section.add "key", valid_594144
  var valid_594145 = query.getOrDefault("$.xgafv")
  valid_594145 = validateParameter(valid_594145, JString, required = false,
                                 default = newJString("1"))
  if valid_594145 != nil:
    section.add "$.xgafv", valid_594145
  var valid_594146 = query.getOrDefault("prettyPrint")
  valid_594146 = validateParameter(valid_594146, JBool, required = false,
                                 default = newJBool(true))
  if valid_594146 != nil:
    section.add "prettyPrint", valid_594146
  var valid_594147 = query.getOrDefault("bearer_token")
  valid_594147 = validateParameter(valid_594147, JString, required = false,
                                 default = nil)
  if valid_594147 != nil:
    section.add "bearer_token", valid_594147
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

proc call*(call_594149: Call_ContainerProjectsZonesClustersLocations_594129;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the locations of a specific cluster.
  ## 
  let valid = call_594149.validator(path, query, header, formData, body)
  let scheme = call_594149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594149.url(scheme.get, call_594149.host, call_594149.base,
                         call_594149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594149, url, valid)

proc call*(call_594150: Call_ContainerProjectsZonesClustersLocations_594129;
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
  var path_594151 = newJObject()
  var query_594152 = newJObject()
  var body_594153 = newJObject()
  add(query_594152, "upload_protocol", newJString(uploadProtocol))
  add(path_594151, "zone", newJString(zone))
  add(query_594152, "fields", newJString(fields))
  add(query_594152, "quotaUser", newJString(quotaUser))
  add(query_594152, "alt", newJString(alt))
  add(query_594152, "pp", newJBool(pp))
  add(query_594152, "oauth_token", newJString(oauthToken))
  add(query_594152, "callback", newJString(callback))
  add(query_594152, "access_token", newJString(accessToken))
  add(query_594152, "uploadType", newJString(uploadType))
  add(query_594152, "key", newJString(key))
  add(path_594151, "projectId", newJString(projectId))
  add(query_594152, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594153 = body
  add(query_594152, "prettyPrint", newJBool(prettyPrint))
  add(path_594151, "clusterId", newJString(clusterId))
  add(query_594152, "bearer_token", newJString(bearerToken))
  result = call_594150.call(path_594151, query_594152, nil, nil, body_594153)

var containerProjectsZonesClustersLocations* = Call_ContainerProjectsZonesClustersLocations_594129(
    name: "containerProjectsZonesClustersLocations", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/locations",
    validator: validate_ContainerProjectsZonesClustersLocations_594130, base: "/",
    url: url_ContainerProjectsZonesClustersLocations_594131,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersLogging_594154 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersLogging_594156(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsZonesClustersLogging_594155(path: JsonNode;
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
  var valid_594157 = path.getOrDefault("zone")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = nil)
  if valid_594157 != nil:
    section.add "zone", valid_594157
  var valid_594158 = path.getOrDefault("projectId")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "projectId", valid_594158
  var valid_594159 = path.getOrDefault("clusterId")
  valid_594159 = validateParameter(valid_594159, JString, required = true,
                                 default = nil)
  if valid_594159 != nil:
    section.add "clusterId", valid_594159
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
  var valid_594160 = query.getOrDefault("upload_protocol")
  valid_594160 = validateParameter(valid_594160, JString, required = false,
                                 default = nil)
  if valid_594160 != nil:
    section.add "upload_protocol", valid_594160
  var valid_594161 = query.getOrDefault("fields")
  valid_594161 = validateParameter(valid_594161, JString, required = false,
                                 default = nil)
  if valid_594161 != nil:
    section.add "fields", valid_594161
  var valid_594162 = query.getOrDefault("quotaUser")
  valid_594162 = validateParameter(valid_594162, JString, required = false,
                                 default = nil)
  if valid_594162 != nil:
    section.add "quotaUser", valid_594162
  var valid_594163 = query.getOrDefault("alt")
  valid_594163 = validateParameter(valid_594163, JString, required = false,
                                 default = newJString("json"))
  if valid_594163 != nil:
    section.add "alt", valid_594163
  var valid_594164 = query.getOrDefault("pp")
  valid_594164 = validateParameter(valid_594164, JBool, required = false,
                                 default = newJBool(true))
  if valid_594164 != nil:
    section.add "pp", valid_594164
  var valid_594165 = query.getOrDefault("oauth_token")
  valid_594165 = validateParameter(valid_594165, JString, required = false,
                                 default = nil)
  if valid_594165 != nil:
    section.add "oauth_token", valid_594165
  var valid_594166 = query.getOrDefault("callback")
  valid_594166 = validateParameter(valid_594166, JString, required = false,
                                 default = nil)
  if valid_594166 != nil:
    section.add "callback", valid_594166
  var valid_594167 = query.getOrDefault("access_token")
  valid_594167 = validateParameter(valid_594167, JString, required = false,
                                 default = nil)
  if valid_594167 != nil:
    section.add "access_token", valid_594167
  var valid_594168 = query.getOrDefault("uploadType")
  valid_594168 = validateParameter(valid_594168, JString, required = false,
                                 default = nil)
  if valid_594168 != nil:
    section.add "uploadType", valid_594168
  var valid_594169 = query.getOrDefault("key")
  valid_594169 = validateParameter(valid_594169, JString, required = false,
                                 default = nil)
  if valid_594169 != nil:
    section.add "key", valid_594169
  var valid_594170 = query.getOrDefault("$.xgafv")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = newJString("1"))
  if valid_594170 != nil:
    section.add "$.xgafv", valid_594170
  var valid_594171 = query.getOrDefault("prettyPrint")
  valid_594171 = validateParameter(valid_594171, JBool, required = false,
                                 default = newJBool(true))
  if valid_594171 != nil:
    section.add "prettyPrint", valid_594171
  var valid_594172 = query.getOrDefault("bearer_token")
  valid_594172 = validateParameter(valid_594172, JString, required = false,
                                 default = nil)
  if valid_594172 != nil:
    section.add "bearer_token", valid_594172
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

proc call*(call_594174: Call_ContainerProjectsZonesClustersLogging_594154;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the logging service of a specific cluster.
  ## 
  let valid = call_594174.validator(path, query, header, formData, body)
  let scheme = call_594174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594174.url(scheme.get, call_594174.host, call_594174.base,
                         call_594174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594174, url, valid)

proc call*(call_594175: Call_ContainerProjectsZonesClustersLogging_594154;
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
  var path_594176 = newJObject()
  var query_594177 = newJObject()
  var body_594178 = newJObject()
  add(query_594177, "upload_protocol", newJString(uploadProtocol))
  add(path_594176, "zone", newJString(zone))
  add(query_594177, "fields", newJString(fields))
  add(query_594177, "quotaUser", newJString(quotaUser))
  add(query_594177, "alt", newJString(alt))
  add(query_594177, "pp", newJBool(pp))
  add(query_594177, "oauth_token", newJString(oauthToken))
  add(query_594177, "callback", newJString(callback))
  add(query_594177, "access_token", newJString(accessToken))
  add(query_594177, "uploadType", newJString(uploadType))
  add(query_594177, "key", newJString(key))
  add(path_594176, "projectId", newJString(projectId))
  add(query_594177, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594178 = body
  add(query_594177, "prettyPrint", newJBool(prettyPrint))
  add(path_594176, "clusterId", newJString(clusterId))
  add(query_594177, "bearer_token", newJString(bearerToken))
  result = call_594175.call(path_594176, query_594177, nil, nil, body_594178)

var containerProjectsZonesClustersLogging* = Call_ContainerProjectsZonesClustersLogging_594154(
    name: "containerProjectsZonesClustersLogging", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/logging",
    validator: validate_ContainerProjectsZonesClustersLogging_594155, base: "/",
    url: url_ContainerProjectsZonesClustersLogging_594156, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersMaster_594179 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersMaster_594181(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsZonesClustersMaster_594180(path: JsonNode;
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
  var valid_594182 = path.getOrDefault("zone")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "zone", valid_594182
  var valid_594183 = path.getOrDefault("projectId")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "projectId", valid_594183
  var valid_594184 = path.getOrDefault("clusterId")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "clusterId", valid_594184
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
  var valid_594185 = query.getOrDefault("upload_protocol")
  valid_594185 = validateParameter(valid_594185, JString, required = false,
                                 default = nil)
  if valid_594185 != nil:
    section.add "upload_protocol", valid_594185
  var valid_594186 = query.getOrDefault("fields")
  valid_594186 = validateParameter(valid_594186, JString, required = false,
                                 default = nil)
  if valid_594186 != nil:
    section.add "fields", valid_594186
  var valid_594187 = query.getOrDefault("quotaUser")
  valid_594187 = validateParameter(valid_594187, JString, required = false,
                                 default = nil)
  if valid_594187 != nil:
    section.add "quotaUser", valid_594187
  var valid_594188 = query.getOrDefault("alt")
  valid_594188 = validateParameter(valid_594188, JString, required = false,
                                 default = newJString("json"))
  if valid_594188 != nil:
    section.add "alt", valid_594188
  var valid_594189 = query.getOrDefault("pp")
  valid_594189 = validateParameter(valid_594189, JBool, required = false,
                                 default = newJBool(true))
  if valid_594189 != nil:
    section.add "pp", valid_594189
  var valid_594190 = query.getOrDefault("oauth_token")
  valid_594190 = validateParameter(valid_594190, JString, required = false,
                                 default = nil)
  if valid_594190 != nil:
    section.add "oauth_token", valid_594190
  var valid_594191 = query.getOrDefault("callback")
  valid_594191 = validateParameter(valid_594191, JString, required = false,
                                 default = nil)
  if valid_594191 != nil:
    section.add "callback", valid_594191
  var valid_594192 = query.getOrDefault("access_token")
  valid_594192 = validateParameter(valid_594192, JString, required = false,
                                 default = nil)
  if valid_594192 != nil:
    section.add "access_token", valid_594192
  var valid_594193 = query.getOrDefault("uploadType")
  valid_594193 = validateParameter(valid_594193, JString, required = false,
                                 default = nil)
  if valid_594193 != nil:
    section.add "uploadType", valid_594193
  var valid_594194 = query.getOrDefault("key")
  valid_594194 = validateParameter(valid_594194, JString, required = false,
                                 default = nil)
  if valid_594194 != nil:
    section.add "key", valid_594194
  var valid_594195 = query.getOrDefault("$.xgafv")
  valid_594195 = validateParameter(valid_594195, JString, required = false,
                                 default = newJString("1"))
  if valid_594195 != nil:
    section.add "$.xgafv", valid_594195
  var valid_594196 = query.getOrDefault("prettyPrint")
  valid_594196 = validateParameter(valid_594196, JBool, required = false,
                                 default = newJBool(true))
  if valid_594196 != nil:
    section.add "prettyPrint", valid_594196
  var valid_594197 = query.getOrDefault("bearer_token")
  valid_594197 = validateParameter(valid_594197, JString, required = false,
                                 default = nil)
  if valid_594197 != nil:
    section.add "bearer_token", valid_594197
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

proc call*(call_594199: Call_ContainerProjectsZonesClustersMaster_594179;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the master of a specific cluster.
  ## 
  let valid = call_594199.validator(path, query, header, formData, body)
  let scheme = call_594199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594199.url(scheme.get, call_594199.host, call_594199.base,
                         call_594199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594199, url, valid)

proc call*(call_594200: Call_ContainerProjectsZonesClustersMaster_594179;
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
  var path_594201 = newJObject()
  var query_594202 = newJObject()
  var body_594203 = newJObject()
  add(query_594202, "upload_protocol", newJString(uploadProtocol))
  add(path_594201, "zone", newJString(zone))
  add(query_594202, "fields", newJString(fields))
  add(query_594202, "quotaUser", newJString(quotaUser))
  add(query_594202, "alt", newJString(alt))
  add(query_594202, "pp", newJBool(pp))
  add(query_594202, "oauth_token", newJString(oauthToken))
  add(query_594202, "callback", newJString(callback))
  add(query_594202, "access_token", newJString(accessToken))
  add(query_594202, "uploadType", newJString(uploadType))
  add(query_594202, "key", newJString(key))
  add(path_594201, "projectId", newJString(projectId))
  add(query_594202, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594203 = body
  add(query_594202, "prettyPrint", newJBool(prettyPrint))
  add(path_594201, "clusterId", newJString(clusterId))
  add(query_594202, "bearer_token", newJString(bearerToken))
  result = call_594200.call(path_594201, query_594202, nil, nil, body_594203)

var containerProjectsZonesClustersMaster* = Call_ContainerProjectsZonesClustersMaster_594179(
    name: "containerProjectsZonesClustersMaster", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/master",
    validator: validate_ContainerProjectsZonesClustersMaster_594180, base: "/",
    url: url_ContainerProjectsZonesClustersMaster_594181, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersMonitoring_594204 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersMonitoring_594206(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsZonesClustersMonitoring_594205(path: JsonNode;
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
  var valid_594207 = path.getOrDefault("zone")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "zone", valid_594207
  var valid_594208 = path.getOrDefault("projectId")
  valid_594208 = validateParameter(valid_594208, JString, required = true,
                                 default = nil)
  if valid_594208 != nil:
    section.add "projectId", valid_594208
  var valid_594209 = path.getOrDefault("clusterId")
  valid_594209 = validateParameter(valid_594209, JString, required = true,
                                 default = nil)
  if valid_594209 != nil:
    section.add "clusterId", valid_594209
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
  var valid_594210 = query.getOrDefault("upload_protocol")
  valid_594210 = validateParameter(valid_594210, JString, required = false,
                                 default = nil)
  if valid_594210 != nil:
    section.add "upload_protocol", valid_594210
  var valid_594211 = query.getOrDefault("fields")
  valid_594211 = validateParameter(valid_594211, JString, required = false,
                                 default = nil)
  if valid_594211 != nil:
    section.add "fields", valid_594211
  var valid_594212 = query.getOrDefault("quotaUser")
  valid_594212 = validateParameter(valid_594212, JString, required = false,
                                 default = nil)
  if valid_594212 != nil:
    section.add "quotaUser", valid_594212
  var valid_594213 = query.getOrDefault("alt")
  valid_594213 = validateParameter(valid_594213, JString, required = false,
                                 default = newJString("json"))
  if valid_594213 != nil:
    section.add "alt", valid_594213
  var valid_594214 = query.getOrDefault("pp")
  valid_594214 = validateParameter(valid_594214, JBool, required = false,
                                 default = newJBool(true))
  if valid_594214 != nil:
    section.add "pp", valid_594214
  var valid_594215 = query.getOrDefault("oauth_token")
  valid_594215 = validateParameter(valid_594215, JString, required = false,
                                 default = nil)
  if valid_594215 != nil:
    section.add "oauth_token", valid_594215
  var valid_594216 = query.getOrDefault("callback")
  valid_594216 = validateParameter(valid_594216, JString, required = false,
                                 default = nil)
  if valid_594216 != nil:
    section.add "callback", valid_594216
  var valid_594217 = query.getOrDefault("access_token")
  valid_594217 = validateParameter(valid_594217, JString, required = false,
                                 default = nil)
  if valid_594217 != nil:
    section.add "access_token", valid_594217
  var valid_594218 = query.getOrDefault("uploadType")
  valid_594218 = validateParameter(valid_594218, JString, required = false,
                                 default = nil)
  if valid_594218 != nil:
    section.add "uploadType", valid_594218
  var valid_594219 = query.getOrDefault("key")
  valid_594219 = validateParameter(valid_594219, JString, required = false,
                                 default = nil)
  if valid_594219 != nil:
    section.add "key", valid_594219
  var valid_594220 = query.getOrDefault("$.xgafv")
  valid_594220 = validateParameter(valid_594220, JString, required = false,
                                 default = newJString("1"))
  if valid_594220 != nil:
    section.add "$.xgafv", valid_594220
  var valid_594221 = query.getOrDefault("prettyPrint")
  valid_594221 = validateParameter(valid_594221, JBool, required = false,
                                 default = newJBool(true))
  if valid_594221 != nil:
    section.add "prettyPrint", valid_594221
  var valid_594222 = query.getOrDefault("bearer_token")
  valid_594222 = validateParameter(valid_594222, JString, required = false,
                                 default = nil)
  if valid_594222 != nil:
    section.add "bearer_token", valid_594222
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

proc call*(call_594224: Call_ContainerProjectsZonesClustersMonitoring_594204;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the monitoring service of a specific cluster.
  ## 
  let valid = call_594224.validator(path, query, header, formData, body)
  let scheme = call_594224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594224.url(scheme.get, call_594224.host, call_594224.base,
                         call_594224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594224, url, valid)

proc call*(call_594225: Call_ContainerProjectsZonesClustersMonitoring_594204;
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
  var path_594226 = newJObject()
  var query_594227 = newJObject()
  var body_594228 = newJObject()
  add(query_594227, "upload_protocol", newJString(uploadProtocol))
  add(path_594226, "zone", newJString(zone))
  add(query_594227, "fields", newJString(fields))
  add(query_594227, "quotaUser", newJString(quotaUser))
  add(query_594227, "alt", newJString(alt))
  add(query_594227, "pp", newJBool(pp))
  add(query_594227, "oauth_token", newJString(oauthToken))
  add(query_594227, "callback", newJString(callback))
  add(query_594227, "access_token", newJString(accessToken))
  add(query_594227, "uploadType", newJString(uploadType))
  add(query_594227, "key", newJString(key))
  add(path_594226, "projectId", newJString(projectId))
  add(query_594227, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594228 = body
  add(query_594227, "prettyPrint", newJBool(prettyPrint))
  add(path_594226, "clusterId", newJString(clusterId))
  add(query_594227, "bearer_token", newJString(bearerToken))
  result = call_594225.call(path_594226, query_594227, nil, nil, body_594228)

var containerProjectsZonesClustersMonitoring* = Call_ContainerProjectsZonesClustersMonitoring_594204(
    name: "containerProjectsZonesClustersMonitoring", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/monitoring",
    validator: validate_ContainerProjectsZonesClustersMonitoring_594205,
    base: "/", url: url_ContainerProjectsZonesClustersMonitoring_594206,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsCreate_594253 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersNodePoolsCreate_594255(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsZonesClustersNodePoolsCreate_594254(
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
  var valid_594256 = path.getOrDefault("zone")
  valid_594256 = validateParameter(valid_594256, JString, required = true,
                                 default = nil)
  if valid_594256 != nil:
    section.add "zone", valid_594256
  var valid_594257 = path.getOrDefault("projectId")
  valid_594257 = validateParameter(valid_594257, JString, required = true,
                                 default = nil)
  if valid_594257 != nil:
    section.add "projectId", valid_594257
  var valid_594258 = path.getOrDefault("clusterId")
  valid_594258 = validateParameter(valid_594258, JString, required = true,
                                 default = nil)
  if valid_594258 != nil:
    section.add "clusterId", valid_594258
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
  var valid_594259 = query.getOrDefault("upload_protocol")
  valid_594259 = validateParameter(valid_594259, JString, required = false,
                                 default = nil)
  if valid_594259 != nil:
    section.add "upload_protocol", valid_594259
  var valid_594260 = query.getOrDefault("fields")
  valid_594260 = validateParameter(valid_594260, JString, required = false,
                                 default = nil)
  if valid_594260 != nil:
    section.add "fields", valid_594260
  var valid_594261 = query.getOrDefault("quotaUser")
  valid_594261 = validateParameter(valid_594261, JString, required = false,
                                 default = nil)
  if valid_594261 != nil:
    section.add "quotaUser", valid_594261
  var valid_594262 = query.getOrDefault("alt")
  valid_594262 = validateParameter(valid_594262, JString, required = false,
                                 default = newJString("json"))
  if valid_594262 != nil:
    section.add "alt", valid_594262
  var valid_594263 = query.getOrDefault("pp")
  valid_594263 = validateParameter(valid_594263, JBool, required = false,
                                 default = newJBool(true))
  if valid_594263 != nil:
    section.add "pp", valid_594263
  var valid_594264 = query.getOrDefault("oauth_token")
  valid_594264 = validateParameter(valid_594264, JString, required = false,
                                 default = nil)
  if valid_594264 != nil:
    section.add "oauth_token", valid_594264
  var valid_594265 = query.getOrDefault("callback")
  valid_594265 = validateParameter(valid_594265, JString, required = false,
                                 default = nil)
  if valid_594265 != nil:
    section.add "callback", valid_594265
  var valid_594266 = query.getOrDefault("access_token")
  valid_594266 = validateParameter(valid_594266, JString, required = false,
                                 default = nil)
  if valid_594266 != nil:
    section.add "access_token", valid_594266
  var valid_594267 = query.getOrDefault("uploadType")
  valid_594267 = validateParameter(valid_594267, JString, required = false,
                                 default = nil)
  if valid_594267 != nil:
    section.add "uploadType", valid_594267
  var valid_594268 = query.getOrDefault("key")
  valid_594268 = validateParameter(valid_594268, JString, required = false,
                                 default = nil)
  if valid_594268 != nil:
    section.add "key", valid_594268
  var valid_594269 = query.getOrDefault("$.xgafv")
  valid_594269 = validateParameter(valid_594269, JString, required = false,
                                 default = newJString("1"))
  if valid_594269 != nil:
    section.add "$.xgafv", valid_594269
  var valid_594270 = query.getOrDefault("prettyPrint")
  valid_594270 = validateParameter(valid_594270, JBool, required = false,
                                 default = newJBool(true))
  if valid_594270 != nil:
    section.add "prettyPrint", valid_594270
  var valid_594271 = query.getOrDefault("bearer_token")
  valid_594271 = validateParameter(valid_594271, JString, required = false,
                                 default = nil)
  if valid_594271 != nil:
    section.add "bearer_token", valid_594271
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

proc call*(call_594273: Call_ContainerProjectsZonesClustersNodePoolsCreate_594253;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a node pool for a cluster.
  ## 
  let valid = call_594273.validator(path, query, header, formData, body)
  let scheme = call_594273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594273.url(scheme.get, call_594273.host, call_594273.base,
                         call_594273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594273, url, valid)

proc call*(call_594274: Call_ContainerProjectsZonesClustersNodePoolsCreate_594253;
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
  var path_594275 = newJObject()
  var query_594276 = newJObject()
  var body_594277 = newJObject()
  add(query_594276, "upload_protocol", newJString(uploadProtocol))
  add(path_594275, "zone", newJString(zone))
  add(query_594276, "fields", newJString(fields))
  add(query_594276, "quotaUser", newJString(quotaUser))
  add(query_594276, "alt", newJString(alt))
  add(query_594276, "pp", newJBool(pp))
  add(query_594276, "oauth_token", newJString(oauthToken))
  add(query_594276, "callback", newJString(callback))
  add(query_594276, "access_token", newJString(accessToken))
  add(query_594276, "uploadType", newJString(uploadType))
  add(query_594276, "key", newJString(key))
  add(path_594275, "projectId", newJString(projectId))
  add(query_594276, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594277 = body
  add(query_594276, "prettyPrint", newJBool(prettyPrint))
  add(path_594275, "clusterId", newJString(clusterId))
  add(query_594276, "bearer_token", newJString(bearerToken))
  result = call_594274.call(path_594275, query_594276, nil, nil, body_594277)

var containerProjectsZonesClustersNodePoolsCreate* = Call_ContainerProjectsZonesClustersNodePoolsCreate_594253(
    name: "containerProjectsZonesClustersNodePoolsCreate",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools",
    validator: validate_ContainerProjectsZonesClustersNodePoolsCreate_594254,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsCreate_594255,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsList_594229 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersNodePoolsList_594231(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsZonesClustersNodePoolsList_594230(path: JsonNode;
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
  var valid_594232 = path.getOrDefault("zone")
  valid_594232 = validateParameter(valid_594232, JString, required = true,
                                 default = nil)
  if valid_594232 != nil:
    section.add "zone", valid_594232
  var valid_594233 = path.getOrDefault("projectId")
  valid_594233 = validateParameter(valid_594233, JString, required = true,
                                 default = nil)
  if valid_594233 != nil:
    section.add "projectId", valid_594233
  var valid_594234 = path.getOrDefault("clusterId")
  valid_594234 = validateParameter(valid_594234, JString, required = true,
                                 default = nil)
  if valid_594234 != nil:
    section.add "clusterId", valid_594234
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
  var valid_594235 = query.getOrDefault("upload_protocol")
  valid_594235 = validateParameter(valid_594235, JString, required = false,
                                 default = nil)
  if valid_594235 != nil:
    section.add "upload_protocol", valid_594235
  var valid_594236 = query.getOrDefault("fields")
  valid_594236 = validateParameter(valid_594236, JString, required = false,
                                 default = nil)
  if valid_594236 != nil:
    section.add "fields", valid_594236
  var valid_594237 = query.getOrDefault("quotaUser")
  valid_594237 = validateParameter(valid_594237, JString, required = false,
                                 default = nil)
  if valid_594237 != nil:
    section.add "quotaUser", valid_594237
  var valid_594238 = query.getOrDefault("alt")
  valid_594238 = validateParameter(valid_594238, JString, required = false,
                                 default = newJString("json"))
  if valid_594238 != nil:
    section.add "alt", valid_594238
  var valid_594239 = query.getOrDefault("pp")
  valid_594239 = validateParameter(valid_594239, JBool, required = false,
                                 default = newJBool(true))
  if valid_594239 != nil:
    section.add "pp", valid_594239
  var valid_594240 = query.getOrDefault("oauth_token")
  valid_594240 = validateParameter(valid_594240, JString, required = false,
                                 default = nil)
  if valid_594240 != nil:
    section.add "oauth_token", valid_594240
  var valid_594241 = query.getOrDefault("callback")
  valid_594241 = validateParameter(valid_594241, JString, required = false,
                                 default = nil)
  if valid_594241 != nil:
    section.add "callback", valid_594241
  var valid_594242 = query.getOrDefault("access_token")
  valid_594242 = validateParameter(valid_594242, JString, required = false,
                                 default = nil)
  if valid_594242 != nil:
    section.add "access_token", valid_594242
  var valid_594243 = query.getOrDefault("uploadType")
  valid_594243 = validateParameter(valid_594243, JString, required = false,
                                 default = nil)
  if valid_594243 != nil:
    section.add "uploadType", valid_594243
  var valid_594244 = query.getOrDefault("parent")
  valid_594244 = validateParameter(valid_594244, JString, required = false,
                                 default = nil)
  if valid_594244 != nil:
    section.add "parent", valid_594244
  var valid_594245 = query.getOrDefault("key")
  valid_594245 = validateParameter(valid_594245, JString, required = false,
                                 default = nil)
  if valid_594245 != nil:
    section.add "key", valid_594245
  var valid_594246 = query.getOrDefault("$.xgafv")
  valid_594246 = validateParameter(valid_594246, JString, required = false,
                                 default = newJString("1"))
  if valid_594246 != nil:
    section.add "$.xgafv", valid_594246
  var valid_594247 = query.getOrDefault("prettyPrint")
  valid_594247 = validateParameter(valid_594247, JBool, required = false,
                                 default = newJBool(true))
  if valid_594247 != nil:
    section.add "prettyPrint", valid_594247
  var valid_594248 = query.getOrDefault("bearer_token")
  valid_594248 = validateParameter(valid_594248, JString, required = false,
                                 default = nil)
  if valid_594248 != nil:
    section.add "bearer_token", valid_594248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594249: Call_ContainerProjectsZonesClustersNodePoolsList_594229;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the node pools for a cluster.
  ## 
  let valid = call_594249.validator(path, query, header, formData, body)
  let scheme = call_594249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594249.url(scheme.get, call_594249.host, call_594249.base,
                         call_594249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594249, url, valid)

proc call*(call_594250: Call_ContainerProjectsZonesClustersNodePoolsList_594229;
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
  var path_594251 = newJObject()
  var query_594252 = newJObject()
  add(query_594252, "upload_protocol", newJString(uploadProtocol))
  add(path_594251, "zone", newJString(zone))
  add(query_594252, "fields", newJString(fields))
  add(query_594252, "quotaUser", newJString(quotaUser))
  add(query_594252, "alt", newJString(alt))
  add(query_594252, "pp", newJBool(pp))
  add(query_594252, "oauth_token", newJString(oauthToken))
  add(query_594252, "callback", newJString(callback))
  add(query_594252, "access_token", newJString(accessToken))
  add(query_594252, "uploadType", newJString(uploadType))
  add(query_594252, "parent", newJString(parent))
  add(query_594252, "key", newJString(key))
  add(path_594251, "projectId", newJString(projectId))
  add(query_594252, "$.xgafv", newJString(Xgafv))
  add(query_594252, "prettyPrint", newJBool(prettyPrint))
  add(path_594251, "clusterId", newJString(clusterId))
  add(query_594252, "bearer_token", newJString(bearerToken))
  result = call_594250.call(path_594251, query_594252, nil, nil, nil)

var containerProjectsZonesClustersNodePoolsList* = Call_ContainerProjectsZonesClustersNodePoolsList_594229(
    name: "containerProjectsZonesClustersNodePoolsList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools",
    validator: validate_ContainerProjectsZonesClustersNodePoolsList_594230,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsList_594231,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsGet_594278 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersNodePoolsGet_594280(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsZonesClustersNodePoolsGet_594279(path: JsonNode;
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
  var valid_594281 = path.getOrDefault("zone")
  valid_594281 = validateParameter(valid_594281, JString, required = true,
                                 default = nil)
  if valid_594281 != nil:
    section.add "zone", valid_594281
  var valid_594282 = path.getOrDefault("nodePoolId")
  valid_594282 = validateParameter(valid_594282, JString, required = true,
                                 default = nil)
  if valid_594282 != nil:
    section.add "nodePoolId", valid_594282
  var valid_594283 = path.getOrDefault("projectId")
  valid_594283 = validateParameter(valid_594283, JString, required = true,
                                 default = nil)
  if valid_594283 != nil:
    section.add "projectId", valid_594283
  var valid_594284 = path.getOrDefault("clusterId")
  valid_594284 = validateParameter(valid_594284, JString, required = true,
                                 default = nil)
  if valid_594284 != nil:
    section.add "clusterId", valid_594284
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
  var valid_594285 = query.getOrDefault("upload_protocol")
  valid_594285 = validateParameter(valid_594285, JString, required = false,
                                 default = nil)
  if valid_594285 != nil:
    section.add "upload_protocol", valid_594285
  var valid_594286 = query.getOrDefault("fields")
  valid_594286 = validateParameter(valid_594286, JString, required = false,
                                 default = nil)
  if valid_594286 != nil:
    section.add "fields", valid_594286
  var valid_594287 = query.getOrDefault("quotaUser")
  valid_594287 = validateParameter(valid_594287, JString, required = false,
                                 default = nil)
  if valid_594287 != nil:
    section.add "quotaUser", valid_594287
  var valid_594288 = query.getOrDefault("alt")
  valid_594288 = validateParameter(valid_594288, JString, required = false,
                                 default = newJString("json"))
  if valid_594288 != nil:
    section.add "alt", valid_594288
  var valid_594289 = query.getOrDefault("pp")
  valid_594289 = validateParameter(valid_594289, JBool, required = false,
                                 default = newJBool(true))
  if valid_594289 != nil:
    section.add "pp", valid_594289
  var valid_594290 = query.getOrDefault("oauth_token")
  valid_594290 = validateParameter(valid_594290, JString, required = false,
                                 default = nil)
  if valid_594290 != nil:
    section.add "oauth_token", valid_594290
  var valid_594291 = query.getOrDefault("callback")
  valid_594291 = validateParameter(valid_594291, JString, required = false,
                                 default = nil)
  if valid_594291 != nil:
    section.add "callback", valid_594291
  var valid_594292 = query.getOrDefault("access_token")
  valid_594292 = validateParameter(valid_594292, JString, required = false,
                                 default = nil)
  if valid_594292 != nil:
    section.add "access_token", valid_594292
  var valid_594293 = query.getOrDefault("uploadType")
  valid_594293 = validateParameter(valid_594293, JString, required = false,
                                 default = nil)
  if valid_594293 != nil:
    section.add "uploadType", valid_594293
  var valid_594294 = query.getOrDefault("key")
  valid_594294 = validateParameter(valid_594294, JString, required = false,
                                 default = nil)
  if valid_594294 != nil:
    section.add "key", valid_594294
  var valid_594295 = query.getOrDefault("name")
  valid_594295 = validateParameter(valid_594295, JString, required = false,
                                 default = nil)
  if valid_594295 != nil:
    section.add "name", valid_594295
  var valid_594296 = query.getOrDefault("$.xgafv")
  valid_594296 = validateParameter(valid_594296, JString, required = false,
                                 default = newJString("1"))
  if valid_594296 != nil:
    section.add "$.xgafv", valid_594296
  var valid_594297 = query.getOrDefault("prettyPrint")
  valid_594297 = validateParameter(valid_594297, JBool, required = false,
                                 default = newJBool(true))
  if valid_594297 != nil:
    section.add "prettyPrint", valid_594297
  var valid_594298 = query.getOrDefault("bearer_token")
  valid_594298 = validateParameter(valid_594298, JString, required = false,
                                 default = nil)
  if valid_594298 != nil:
    section.add "bearer_token", valid_594298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594299: Call_ContainerProjectsZonesClustersNodePoolsGet_594278;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the node pool requested.
  ## 
  let valid = call_594299.validator(path, query, header, formData, body)
  let scheme = call_594299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594299.url(scheme.get, call_594299.host, call_594299.base,
                         call_594299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594299, url, valid)

proc call*(call_594300: Call_ContainerProjectsZonesClustersNodePoolsGet_594278;
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
  var path_594301 = newJObject()
  var query_594302 = newJObject()
  add(query_594302, "upload_protocol", newJString(uploadProtocol))
  add(path_594301, "zone", newJString(zone))
  add(query_594302, "fields", newJString(fields))
  add(query_594302, "quotaUser", newJString(quotaUser))
  add(query_594302, "alt", newJString(alt))
  add(query_594302, "pp", newJBool(pp))
  add(query_594302, "oauth_token", newJString(oauthToken))
  add(query_594302, "callback", newJString(callback))
  add(query_594302, "access_token", newJString(accessToken))
  add(query_594302, "uploadType", newJString(uploadType))
  add(path_594301, "nodePoolId", newJString(nodePoolId))
  add(query_594302, "key", newJString(key))
  add(query_594302, "name", newJString(name))
  add(path_594301, "projectId", newJString(projectId))
  add(query_594302, "$.xgafv", newJString(Xgafv))
  add(query_594302, "prettyPrint", newJBool(prettyPrint))
  add(path_594301, "clusterId", newJString(clusterId))
  add(query_594302, "bearer_token", newJString(bearerToken))
  result = call_594300.call(path_594301, query_594302, nil, nil, nil)

var containerProjectsZonesClustersNodePoolsGet* = Call_ContainerProjectsZonesClustersNodePoolsGet_594278(
    name: "containerProjectsZonesClustersNodePoolsGet", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}",
    validator: validate_ContainerProjectsZonesClustersNodePoolsGet_594279,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsGet_594280,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsDelete_594303 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersNodePoolsDelete_594305(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsZonesClustersNodePoolsDelete_594304(
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
  var valid_594306 = path.getOrDefault("zone")
  valid_594306 = validateParameter(valid_594306, JString, required = true,
                                 default = nil)
  if valid_594306 != nil:
    section.add "zone", valid_594306
  var valid_594307 = path.getOrDefault("nodePoolId")
  valid_594307 = validateParameter(valid_594307, JString, required = true,
                                 default = nil)
  if valid_594307 != nil:
    section.add "nodePoolId", valid_594307
  var valid_594308 = path.getOrDefault("projectId")
  valid_594308 = validateParameter(valid_594308, JString, required = true,
                                 default = nil)
  if valid_594308 != nil:
    section.add "projectId", valid_594308
  var valid_594309 = path.getOrDefault("clusterId")
  valid_594309 = validateParameter(valid_594309, JString, required = true,
                                 default = nil)
  if valid_594309 != nil:
    section.add "clusterId", valid_594309
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
  var valid_594310 = query.getOrDefault("upload_protocol")
  valid_594310 = validateParameter(valid_594310, JString, required = false,
                                 default = nil)
  if valid_594310 != nil:
    section.add "upload_protocol", valid_594310
  var valid_594311 = query.getOrDefault("fields")
  valid_594311 = validateParameter(valid_594311, JString, required = false,
                                 default = nil)
  if valid_594311 != nil:
    section.add "fields", valid_594311
  var valid_594312 = query.getOrDefault("quotaUser")
  valid_594312 = validateParameter(valid_594312, JString, required = false,
                                 default = nil)
  if valid_594312 != nil:
    section.add "quotaUser", valid_594312
  var valid_594313 = query.getOrDefault("alt")
  valid_594313 = validateParameter(valid_594313, JString, required = false,
                                 default = newJString("json"))
  if valid_594313 != nil:
    section.add "alt", valid_594313
  var valid_594314 = query.getOrDefault("pp")
  valid_594314 = validateParameter(valid_594314, JBool, required = false,
                                 default = newJBool(true))
  if valid_594314 != nil:
    section.add "pp", valid_594314
  var valid_594315 = query.getOrDefault("oauth_token")
  valid_594315 = validateParameter(valid_594315, JString, required = false,
                                 default = nil)
  if valid_594315 != nil:
    section.add "oauth_token", valid_594315
  var valid_594316 = query.getOrDefault("callback")
  valid_594316 = validateParameter(valid_594316, JString, required = false,
                                 default = nil)
  if valid_594316 != nil:
    section.add "callback", valid_594316
  var valid_594317 = query.getOrDefault("access_token")
  valid_594317 = validateParameter(valid_594317, JString, required = false,
                                 default = nil)
  if valid_594317 != nil:
    section.add "access_token", valid_594317
  var valid_594318 = query.getOrDefault("uploadType")
  valid_594318 = validateParameter(valid_594318, JString, required = false,
                                 default = nil)
  if valid_594318 != nil:
    section.add "uploadType", valid_594318
  var valid_594319 = query.getOrDefault("key")
  valid_594319 = validateParameter(valid_594319, JString, required = false,
                                 default = nil)
  if valid_594319 != nil:
    section.add "key", valid_594319
  var valid_594320 = query.getOrDefault("name")
  valid_594320 = validateParameter(valid_594320, JString, required = false,
                                 default = nil)
  if valid_594320 != nil:
    section.add "name", valid_594320
  var valid_594321 = query.getOrDefault("$.xgafv")
  valid_594321 = validateParameter(valid_594321, JString, required = false,
                                 default = newJString("1"))
  if valid_594321 != nil:
    section.add "$.xgafv", valid_594321
  var valid_594322 = query.getOrDefault("prettyPrint")
  valid_594322 = validateParameter(valid_594322, JBool, required = false,
                                 default = newJBool(true))
  if valid_594322 != nil:
    section.add "prettyPrint", valid_594322
  var valid_594323 = query.getOrDefault("bearer_token")
  valid_594323 = validateParameter(valid_594323, JString, required = false,
                                 default = nil)
  if valid_594323 != nil:
    section.add "bearer_token", valid_594323
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594324: Call_ContainerProjectsZonesClustersNodePoolsDelete_594303;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a node pool from a cluster.
  ## 
  let valid = call_594324.validator(path, query, header, formData, body)
  let scheme = call_594324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594324.url(scheme.get, call_594324.host, call_594324.base,
                         call_594324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594324, url, valid)

proc call*(call_594325: Call_ContainerProjectsZonesClustersNodePoolsDelete_594303;
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
  var path_594326 = newJObject()
  var query_594327 = newJObject()
  add(query_594327, "upload_protocol", newJString(uploadProtocol))
  add(path_594326, "zone", newJString(zone))
  add(query_594327, "fields", newJString(fields))
  add(query_594327, "quotaUser", newJString(quotaUser))
  add(query_594327, "alt", newJString(alt))
  add(query_594327, "pp", newJBool(pp))
  add(query_594327, "oauth_token", newJString(oauthToken))
  add(query_594327, "callback", newJString(callback))
  add(query_594327, "access_token", newJString(accessToken))
  add(query_594327, "uploadType", newJString(uploadType))
  add(path_594326, "nodePoolId", newJString(nodePoolId))
  add(query_594327, "key", newJString(key))
  add(query_594327, "name", newJString(name))
  add(path_594326, "projectId", newJString(projectId))
  add(query_594327, "$.xgafv", newJString(Xgafv))
  add(query_594327, "prettyPrint", newJBool(prettyPrint))
  add(path_594326, "clusterId", newJString(clusterId))
  add(query_594327, "bearer_token", newJString(bearerToken))
  result = call_594325.call(path_594326, query_594327, nil, nil, nil)

var containerProjectsZonesClustersNodePoolsDelete* = Call_ContainerProjectsZonesClustersNodePoolsDelete_594303(
    name: "containerProjectsZonesClustersNodePoolsDelete",
    meth: HttpMethod.HttpDelete, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}",
    validator: validate_ContainerProjectsZonesClustersNodePoolsDelete_594304,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsDelete_594305,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_594328 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersNodePoolsAutoscaling_594330(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsZonesClustersNodePoolsAutoscaling_594329(
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
  var valid_594331 = path.getOrDefault("zone")
  valid_594331 = validateParameter(valid_594331, JString, required = true,
                                 default = nil)
  if valid_594331 != nil:
    section.add "zone", valid_594331
  var valid_594332 = path.getOrDefault("nodePoolId")
  valid_594332 = validateParameter(valid_594332, JString, required = true,
                                 default = nil)
  if valid_594332 != nil:
    section.add "nodePoolId", valid_594332
  var valid_594333 = path.getOrDefault("projectId")
  valid_594333 = validateParameter(valid_594333, JString, required = true,
                                 default = nil)
  if valid_594333 != nil:
    section.add "projectId", valid_594333
  var valid_594334 = path.getOrDefault("clusterId")
  valid_594334 = validateParameter(valid_594334, JString, required = true,
                                 default = nil)
  if valid_594334 != nil:
    section.add "clusterId", valid_594334
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
  var valid_594335 = query.getOrDefault("upload_protocol")
  valid_594335 = validateParameter(valid_594335, JString, required = false,
                                 default = nil)
  if valid_594335 != nil:
    section.add "upload_protocol", valid_594335
  var valid_594336 = query.getOrDefault("fields")
  valid_594336 = validateParameter(valid_594336, JString, required = false,
                                 default = nil)
  if valid_594336 != nil:
    section.add "fields", valid_594336
  var valid_594337 = query.getOrDefault("quotaUser")
  valid_594337 = validateParameter(valid_594337, JString, required = false,
                                 default = nil)
  if valid_594337 != nil:
    section.add "quotaUser", valid_594337
  var valid_594338 = query.getOrDefault("alt")
  valid_594338 = validateParameter(valid_594338, JString, required = false,
                                 default = newJString("json"))
  if valid_594338 != nil:
    section.add "alt", valid_594338
  var valid_594339 = query.getOrDefault("pp")
  valid_594339 = validateParameter(valid_594339, JBool, required = false,
                                 default = newJBool(true))
  if valid_594339 != nil:
    section.add "pp", valid_594339
  var valid_594340 = query.getOrDefault("oauth_token")
  valid_594340 = validateParameter(valid_594340, JString, required = false,
                                 default = nil)
  if valid_594340 != nil:
    section.add "oauth_token", valid_594340
  var valid_594341 = query.getOrDefault("callback")
  valid_594341 = validateParameter(valid_594341, JString, required = false,
                                 default = nil)
  if valid_594341 != nil:
    section.add "callback", valid_594341
  var valid_594342 = query.getOrDefault("access_token")
  valid_594342 = validateParameter(valid_594342, JString, required = false,
                                 default = nil)
  if valid_594342 != nil:
    section.add "access_token", valid_594342
  var valid_594343 = query.getOrDefault("uploadType")
  valid_594343 = validateParameter(valid_594343, JString, required = false,
                                 default = nil)
  if valid_594343 != nil:
    section.add "uploadType", valid_594343
  var valid_594344 = query.getOrDefault("key")
  valid_594344 = validateParameter(valid_594344, JString, required = false,
                                 default = nil)
  if valid_594344 != nil:
    section.add "key", valid_594344
  var valid_594345 = query.getOrDefault("$.xgafv")
  valid_594345 = validateParameter(valid_594345, JString, required = false,
                                 default = newJString("1"))
  if valid_594345 != nil:
    section.add "$.xgafv", valid_594345
  var valid_594346 = query.getOrDefault("prettyPrint")
  valid_594346 = validateParameter(valid_594346, JBool, required = false,
                                 default = newJBool(true))
  if valid_594346 != nil:
    section.add "prettyPrint", valid_594346
  var valid_594347 = query.getOrDefault("bearer_token")
  valid_594347 = validateParameter(valid_594347, JString, required = false,
                                 default = nil)
  if valid_594347 != nil:
    section.add "bearer_token", valid_594347
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

proc call*(call_594349: Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_594328;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the autoscaling settings of a specific node pool.
  ## 
  let valid = call_594349.validator(path, query, header, formData, body)
  let scheme = call_594349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594349.url(scheme.get, call_594349.host, call_594349.base,
                         call_594349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594349, url, valid)

proc call*(call_594350: Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_594328;
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
  var path_594351 = newJObject()
  var query_594352 = newJObject()
  var body_594353 = newJObject()
  add(query_594352, "upload_protocol", newJString(uploadProtocol))
  add(path_594351, "zone", newJString(zone))
  add(query_594352, "fields", newJString(fields))
  add(query_594352, "quotaUser", newJString(quotaUser))
  add(query_594352, "alt", newJString(alt))
  add(query_594352, "pp", newJBool(pp))
  add(query_594352, "oauth_token", newJString(oauthToken))
  add(query_594352, "callback", newJString(callback))
  add(query_594352, "access_token", newJString(accessToken))
  add(query_594352, "uploadType", newJString(uploadType))
  add(path_594351, "nodePoolId", newJString(nodePoolId))
  add(query_594352, "key", newJString(key))
  add(path_594351, "projectId", newJString(projectId))
  add(query_594352, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594353 = body
  add(query_594352, "prettyPrint", newJBool(prettyPrint))
  add(path_594351, "clusterId", newJString(clusterId))
  add(query_594352, "bearer_token", newJString(bearerToken))
  result = call_594350.call(path_594351, query_594352, nil, nil, body_594353)

var containerProjectsZonesClustersNodePoolsAutoscaling* = Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_594328(
    name: "containerProjectsZonesClustersNodePoolsAutoscaling",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}/autoscaling",
    validator: validate_ContainerProjectsZonesClustersNodePoolsAutoscaling_594329,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsAutoscaling_594330,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsSetManagement_594354 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersNodePoolsSetManagement_594356(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsZonesClustersNodePoolsSetManagement_594355(
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
  var valid_594357 = path.getOrDefault("zone")
  valid_594357 = validateParameter(valid_594357, JString, required = true,
                                 default = nil)
  if valid_594357 != nil:
    section.add "zone", valid_594357
  var valid_594358 = path.getOrDefault("nodePoolId")
  valid_594358 = validateParameter(valid_594358, JString, required = true,
                                 default = nil)
  if valid_594358 != nil:
    section.add "nodePoolId", valid_594358
  var valid_594359 = path.getOrDefault("projectId")
  valid_594359 = validateParameter(valid_594359, JString, required = true,
                                 default = nil)
  if valid_594359 != nil:
    section.add "projectId", valid_594359
  var valid_594360 = path.getOrDefault("clusterId")
  valid_594360 = validateParameter(valid_594360, JString, required = true,
                                 default = nil)
  if valid_594360 != nil:
    section.add "clusterId", valid_594360
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
  var valid_594361 = query.getOrDefault("upload_protocol")
  valid_594361 = validateParameter(valid_594361, JString, required = false,
                                 default = nil)
  if valid_594361 != nil:
    section.add "upload_protocol", valid_594361
  var valid_594362 = query.getOrDefault("fields")
  valid_594362 = validateParameter(valid_594362, JString, required = false,
                                 default = nil)
  if valid_594362 != nil:
    section.add "fields", valid_594362
  var valid_594363 = query.getOrDefault("quotaUser")
  valid_594363 = validateParameter(valid_594363, JString, required = false,
                                 default = nil)
  if valid_594363 != nil:
    section.add "quotaUser", valid_594363
  var valid_594364 = query.getOrDefault("alt")
  valid_594364 = validateParameter(valid_594364, JString, required = false,
                                 default = newJString("json"))
  if valid_594364 != nil:
    section.add "alt", valid_594364
  var valid_594365 = query.getOrDefault("pp")
  valid_594365 = validateParameter(valid_594365, JBool, required = false,
                                 default = newJBool(true))
  if valid_594365 != nil:
    section.add "pp", valid_594365
  var valid_594366 = query.getOrDefault("oauth_token")
  valid_594366 = validateParameter(valid_594366, JString, required = false,
                                 default = nil)
  if valid_594366 != nil:
    section.add "oauth_token", valid_594366
  var valid_594367 = query.getOrDefault("callback")
  valid_594367 = validateParameter(valid_594367, JString, required = false,
                                 default = nil)
  if valid_594367 != nil:
    section.add "callback", valid_594367
  var valid_594368 = query.getOrDefault("access_token")
  valid_594368 = validateParameter(valid_594368, JString, required = false,
                                 default = nil)
  if valid_594368 != nil:
    section.add "access_token", valid_594368
  var valid_594369 = query.getOrDefault("uploadType")
  valid_594369 = validateParameter(valid_594369, JString, required = false,
                                 default = nil)
  if valid_594369 != nil:
    section.add "uploadType", valid_594369
  var valid_594370 = query.getOrDefault("key")
  valid_594370 = validateParameter(valid_594370, JString, required = false,
                                 default = nil)
  if valid_594370 != nil:
    section.add "key", valid_594370
  var valid_594371 = query.getOrDefault("$.xgafv")
  valid_594371 = validateParameter(valid_594371, JString, required = false,
                                 default = newJString("1"))
  if valid_594371 != nil:
    section.add "$.xgafv", valid_594371
  var valid_594372 = query.getOrDefault("prettyPrint")
  valid_594372 = validateParameter(valid_594372, JBool, required = false,
                                 default = newJBool(true))
  if valid_594372 != nil:
    section.add "prettyPrint", valid_594372
  var valid_594373 = query.getOrDefault("bearer_token")
  valid_594373 = validateParameter(valid_594373, JString, required = false,
                                 default = nil)
  if valid_594373 != nil:
    section.add "bearer_token", valid_594373
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

proc call*(call_594375: Call_ContainerProjectsZonesClustersNodePoolsSetManagement_594354;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the NodeManagement options for a node pool.
  ## 
  let valid = call_594375.validator(path, query, header, formData, body)
  let scheme = call_594375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594375.url(scheme.get, call_594375.host, call_594375.base,
                         call_594375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594375, url, valid)

proc call*(call_594376: Call_ContainerProjectsZonesClustersNodePoolsSetManagement_594354;
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
  var path_594377 = newJObject()
  var query_594378 = newJObject()
  var body_594379 = newJObject()
  add(query_594378, "upload_protocol", newJString(uploadProtocol))
  add(path_594377, "zone", newJString(zone))
  add(query_594378, "fields", newJString(fields))
  add(query_594378, "quotaUser", newJString(quotaUser))
  add(query_594378, "alt", newJString(alt))
  add(query_594378, "pp", newJBool(pp))
  add(query_594378, "oauth_token", newJString(oauthToken))
  add(query_594378, "callback", newJString(callback))
  add(query_594378, "access_token", newJString(accessToken))
  add(query_594378, "uploadType", newJString(uploadType))
  add(path_594377, "nodePoolId", newJString(nodePoolId))
  add(query_594378, "key", newJString(key))
  add(path_594377, "projectId", newJString(projectId))
  add(query_594378, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594379 = body
  add(query_594378, "prettyPrint", newJBool(prettyPrint))
  add(path_594377, "clusterId", newJString(clusterId))
  add(query_594378, "bearer_token", newJString(bearerToken))
  result = call_594376.call(path_594377, query_594378, nil, nil, body_594379)

var containerProjectsZonesClustersNodePoolsSetManagement* = Call_ContainerProjectsZonesClustersNodePoolsSetManagement_594354(
    name: "containerProjectsZonesClustersNodePoolsSetManagement",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}/setManagement",
    validator: validate_ContainerProjectsZonesClustersNodePoolsSetManagement_594355,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsSetManagement_594356,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsUpdate_594380 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersNodePoolsUpdate_594382(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsZonesClustersNodePoolsUpdate_594381(
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
  var valid_594383 = path.getOrDefault("zone")
  valid_594383 = validateParameter(valid_594383, JString, required = true,
                                 default = nil)
  if valid_594383 != nil:
    section.add "zone", valid_594383
  var valid_594384 = path.getOrDefault("nodePoolId")
  valid_594384 = validateParameter(valid_594384, JString, required = true,
                                 default = nil)
  if valid_594384 != nil:
    section.add "nodePoolId", valid_594384
  var valid_594385 = path.getOrDefault("projectId")
  valid_594385 = validateParameter(valid_594385, JString, required = true,
                                 default = nil)
  if valid_594385 != nil:
    section.add "projectId", valid_594385
  var valid_594386 = path.getOrDefault("clusterId")
  valid_594386 = validateParameter(valid_594386, JString, required = true,
                                 default = nil)
  if valid_594386 != nil:
    section.add "clusterId", valid_594386
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
  var valid_594387 = query.getOrDefault("upload_protocol")
  valid_594387 = validateParameter(valid_594387, JString, required = false,
                                 default = nil)
  if valid_594387 != nil:
    section.add "upload_protocol", valid_594387
  var valid_594388 = query.getOrDefault("fields")
  valid_594388 = validateParameter(valid_594388, JString, required = false,
                                 default = nil)
  if valid_594388 != nil:
    section.add "fields", valid_594388
  var valid_594389 = query.getOrDefault("quotaUser")
  valid_594389 = validateParameter(valid_594389, JString, required = false,
                                 default = nil)
  if valid_594389 != nil:
    section.add "quotaUser", valid_594389
  var valid_594390 = query.getOrDefault("alt")
  valid_594390 = validateParameter(valid_594390, JString, required = false,
                                 default = newJString("json"))
  if valid_594390 != nil:
    section.add "alt", valid_594390
  var valid_594391 = query.getOrDefault("pp")
  valid_594391 = validateParameter(valid_594391, JBool, required = false,
                                 default = newJBool(true))
  if valid_594391 != nil:
    section.add "pp", valid_594391
  var valid_594392 = query.getOrDefault("oauth_token")
  valid_594392 = validateParameter(valid_594392, JString, required = false,
                                 default = nil)
  if valid_594392 != nil:
    section.add "oauth_token", valid_594392
  var valid_594393 = query.getOrDefault("callback")
  valid_594393 = validateParameter(valid_594393, JString, required = false,
                                 default = nil)
  if valid_594393 != nil:
    section.add "callback", valid_594393
  var valid_594394 = query.getOrDefault("access_token")
  valid_594394 = validateParameter(valid_594394, JString, required = false,
                                 default = nil)
  if valid_594394 != nil:
    section.add "access_token", valid_594394
  var valid_594395 = query.getOrDefault("uploadType")
  valid_594395 = validateParameter(valid_594395, JString, required = false,
                                 default = nil)
  if valid_594395 != nil:
    section.add "uploadType", valid_594395
  var valid_594396 = query.getOrDefault("key")
  valid_594396 = validateParameter(valid_594396, JString, required = false,
                                 default = nil)
  if valid_594396 != nil:
    section.add "key", valid_594396
  var valid_594397 = query.getOrDefault("$.xgafv")
  valid_594397 = validateParameter(valid_594397, JString, required = false,
                                 default = newJString("1"))
  if valid_594397 != nil:
    section.add "$.xgafv", valid_594397
  var valid_594398 = query.getOrDefault("prettyPrint")
  valid_594398 = validateParameter(valid_594398, JBool, required = false,
                                 default = newJBool(true))
  if valid_594398 != nil:
    section.add "prettyPrint", valid_594398
  var valid_594399 = query.getOrDefault("bearer_token")
  valid_594399 = validateParameter(valid_594399, JString, required = false,
                                 default = nil)
  if valid_594399 != nil:
    section.add "bearer_token", valid_594399
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

proc call*(call_594401: Call_ContainerProjectsZonesClustersNodePoolsUpdate_594380;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the version and/or iamge type of a specific node pool.
  ## 
  let valid = call_594401.validator(path, query, header, formData, body)
  let scheme = call_594401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594401.url(scheme.get, call_594401.host, call_594401.base,
                         call_594401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594401, url, valid)

proc call*(call_594402: Call_ContainerProjectsZonesClustersNodePoolsUpdate_594380;
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
  var path_594403 = newJObject()
  var query_594404 = newJObject()
  var body_594405 = newJObject()
  add(query_594404, "upload_protocol", newJString(uploadProtocol))
  add(path_594403, "zone", newJString(zone))
  add(query_594404, "fields", newJString(fields))
  add(query_594404, "quotaUser", newJString(quotaUser))
  add(query_594404, "alt", newJString(alt))
  add(query_594404, "pp", newJBool(pp))
  add(query_594404, "oauth_token", newJString(oauthToken))
  add(query_594404, "callback", newJString(callback))
  add(query_594404, "access_token", newJString(accessToken))
  add(query_594404, "uploadType", newJString(uploadType))
  add(path_594403, "nodePoolId", newJString(nodePoolId))
  add(query_594404, "key", newJString(key))
  add(path_594403, "projectId", newJString(projectId))
  add(query_594404, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594405 = body
  add(query_594404, "prettyPrint", newJBool(prettyPrint))
  add(path_594403, "clusterId", newJString(clusterId))
  add(query_594404, "bearer_token", newJString(bearerToken))
  result = call_594402.call(path_594403, query_594404, nil, nil, body_594405)

var containerProjectsZonesClustersNodePoolsUpdate* = Call_ContainerProjectsZonesClustersNodePoolsUpdate_594380(
    name: "containerProjectsZonesClustersNodePoolsUpdate",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}/update",
    validator: validate_ContainerProjectsZonesClustersNodePoolsUpdate_594381,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsUpdate_594382,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsRollback_594406 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersNodePoolsRollback_594408(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsZonesClustersNodePoolsRollback_594407(
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
  var valid_594409 = path.getOrDefault("zone")
  valid_594409 = validateParameter(valid_594409, JString, required = true,
                                 default = nil)
  if valid_594409 != nil:
    section.add "zone", valid_594409
  var valid_594410 = path.getOrDefault("nodePoolId")
  valid_594410 = validateParameter(valid_594410, JString, required = true,
                                 default = nil)
  if valid_594410 != nil:
    section.add "nodePoolId", valid_594410
  var valid_594411 = path.getOrDefault("projectId")
  valid_594411 = validateParameter(valid_594411, JString, required = true,
                                 default = nil)
  if valid_594411 != nil:
    section.add "projectId", valid_594411
  var valid_594412 = path.getOrDefault("clusterId")
  valid_594412 = validateParameter(valid_594412, JString, required = true,
                                 default = nil)
  if valid_594412 != nil:
    section.add "clusterId", valid_594412
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
  var valid_594413 = query.getOrDefault("upload_protocol")
  valid_594413 = validateParameter(valid_594413, JString, required = false,
                                 default = nil)
  if valid_594413 != nil:
    section.add "upload_protocol", valid_594413
  var valid_594414 = query.getOrDefault("fields")
  valid_594414 = validateParameter(valid_594414, JString, required = false,
                                 default = nil)
  if valid_594414 != nil:
    section.add "fields", valid_594414
  var valid_594415 = query.getOrDefault("quotaUser")
  valid_594415 = validateParameter(valid_594415, JString, required = false,
                                 default = nil)
  if valid_594415 != nil:
    section.add "quotaUser", valid_594415
  var valid_594416 = query.getOrDefault("alt")
  valid_594416 = validateParameter(valid_594416, JString, required = false,
                                 default = newJString("json"))
  if valid_594416 != nil:
    section.add "alt", valid_594416
  var valid_594417 = query.getOrDefault("pp")
  valid_594417 = validateParameter(valid_594417, JBool, required = false,
                                 default = newJBool(true))
  if valid_594417 != nil:
    section.add "pp", valid_594417
  var valid_594418 = query.getOrDefault("oauth_token")
  valid_594418 = validateParameter(valid_594418, JString, required = false,
                                 default = nil)
  if valid_594418 != nil:
    section.add "oauth_token", valid_594418
  var valid_594419 = query.getOrDefault("callback")
  valid_594419 = validateParameter(valid_594419, JString, required = false,
                                 default = nil)
  if valid_594419 != nil:
    section.add "callback", valid_594419
  var valid_594420 = query.getOrDefault("access_token")
  valid_594420 = validateParameter(valid_594420, JString, required = false,
                                 default = nil)
  if valid_594420 != nil:
    section.add "access_token", valid_594420
  var valid_594421 = query.getOrDefault("uploadType")
  valid_594421 = validateParameter(valid_594421, JString, required = false,
                                 default = nil)
  if valid_594421 != nil:
    section.add "uploadType", valid_594421
  var valid_594422 = query.getOrDefault("key")
  valid_594422 = validateParameter(valid_594422, JString, required = false,
                                 default = nil)
  if valid_594422 != nil:
    section.add "key", valid_594422
  var valid_594423 = query.getOrDefault("$.xgafv")
  valid_594423 = validateParameter(valid_594423, JString, required = false,
                                 default = newJString("1"))
  if valid_594423 != nil:
    section.add "$.xgafv", valid_594423
  var valid_594424 = query.getOrDefault("prettyPrint")
  valid_594424 = validateParameter(valid_594424, JBool, required = false,
                                 default = newJBool(true))
  if valid_594424 != nil:
    section.add "prettyPrint", valid_594424
  var valid_594425 = query.getOrDefault("bearer_token")
  valid_594425 = validateParameter(valid_594425, JString, required = false,
                                 default = nil)
  if valid_594425 != nil:
    section.add "bearer_token", valid_594425
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

proc call*(call_594427: Call_ContainerProjectsZonesClustersNodePoolsRollback_594406;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Roll back the previously Aborted or Failed NodePool upgrade.
  ## This will be an no-op if the last upgrade successfully completed.
  ## 
  let valid = call_594427.validator(path, query, header, formData, body)
  let scheme = call_594427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594427.url(scheme.get, call_594427.host, call_594427.base,
                         call_594427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594427, url, valid)

proc call*(call_594428: Call_ContainerProjectsZonesClustersNodePoolsRollback_594406;
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
  var path_594429 = newJObject()
  var query_594430 = newJObject()
  var body_594431 = newJObject()
  add(query_594430, "upload_protocol", newJString(uploadProtocol))
  add(path_594429, "zone", newJString(zone))
  add(query_594430, "fields", newJString(fields))
  add(query_594430, "quotaUser", newJString(quotaUser))
  add(query_594430, "alt", newJString(alt))
  add(query_594430, "pp", newJBool(pp))
  add(query_594430, "oauth_token", newJString(oauthToken))
  add(query_594430, "callback", newJString(callback))
  add(query_594430, "access_token", newJString(accessToken))
  add(query_594430, "uploadType", newJString(uploadType))
  add(path_594429, "nodePoolId", newJString(nodePoolId))
  add(query_594430, "key", newJString(key))
  add(path_594429, "projectId", newJString(projectId))
  add(query_594430, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594431 = body
  add(query_594430, "prettyPrint", newJBool(prettyPrint))
  add(path_594429, "clusterId", newJString(clusterId))
  add(query_594430, "bearer_token", newJString(bearerToken))
  result = call_594428.call(path_594429, query_594430, nil, nil, body_594431)

var containerProjectsZonesClustersNodePoolsRollback* = Call_ContainerProjectsZonesClustersNodePoolsRollback_594406(
    name: "containerProjectsZonesClustersNodePoolsRollback",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}:rollback",
    validator: validate_ContainerProjectsZonesClustersNodePoolsRollback_594407,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsRollback_594408,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersResourceLabels_594432 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersResourceLabels_594434(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsZonesClustersResourceLabels_594433(path: JsonNode;
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
  var valid_594435 = path.getOrDefault("zone")
  valid_594435 = validateParameter(valid_594435, JString, required = true,
                                 default = nil)
  if valid_594435 != nil:
    section.add "zone", valid_594435
  var valid_594436 = path.getOrDefault("projectId")
  valid_594436 = validateParameter(valid_594436, JString, required = true,
                                 default = nil)
  if valid_594436 != nil:
    section.add "projectId", valid_594436
  var valid_594437 = path.getOrDefault("clusterId")
  valid_594437 = validateParameter(valid_594437, JString, required = true,
                                 default = nil)
  if valid_594437 != nil:
    section.add "clusterId", valid_594437
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
  var valid_594438 = query.getOrDefault("upload_protocol")
  valid_594438 = validateParameter(valid_594438, JString, required = false,
                                 default = nil)
  if valid_594438 != nil:
    section.add "upload_protocol", valid_594438
  var valid_594439 = query.getOrDefault("fields")
  valid_594439 = validateParameter(valid_594439, JString, required = false,
                                 default = nil)
  if valid_594439 != nil:
    section.add "fields", valid_594439
  var valid_594440 = query.getOrDefault("quotaUser")
  valid_594440 = validateParameter(valid_594440, JString, required = false,
                                 default = nil)
  if valid_594440 != nil:
    section.add "quotaUser", valid_594440
  var valid_594441 = query.getOrDefault("alt")
  valid_594441 = validateParameter(valid_594441, JString, required = false,
                                 default = newJString("json"))
  if valid_594441 != nil:
    section.add "alt", valid_594441
  var valid_594442 = query.getOrDefault("pp")
  valid_594442 = validateParameter(valid_594442, JBool, required = false,
                                 default = newJBool(true))
  if valid_594442 != nil:
    section.add "pp", valid_594442
  var valid_594443 = query.getOrDefault("oauth_token")
  valid_594443 = validateParameter(valid_594443, JString, required = false,
                                 default = nil)
  if valid_594443 != nil:
    section.add "oauth_token", valid_594443
  var valid_594444 = query.getOrDefault("callback")
  valid_594444 = validateParameter(valid_594444, JString, required = false,
                                 default = nil)
  if valid_594444 != nil:
    section.add "callback", valid_594444
  var valid_594445 = query.getOrDefault("access_token")
  valid_594445 = validateParameter(valid_594445, JString, required = false,
                                 default = nil)
  if valid_594445 != nil:
    section.add "access_token", valid_594445
  var valid_594446 = query.getOrDefault("uploadType")
  valid_594446 = validateParameter(valid_594446, JString, required = false,
                                 default = nil)
  if valid_594446 != nil:
    section.add "uploadType", valid_594446
  var valid_594447 = query.getOrDefault("key")
  valid_594447 = validateParameter(valid_594447, JString, required = false,
                                 default = nil)
  if valid_594447 != nil:
    section.add "key", valid_594447
  var valid_594448 = query.getOrDefault("$.xgafv")
  valid_594448 = validateParameter(valid_594448, JString, required = false,
                                 default = newJString("1"))
  if valid_594448 != nil:
    section.add "$.xgafv", valid_594448
  var valid_594449 = query.getOrDefault("prettyPrint")
  valid_594449 = validateParameter(valid_594449, JBool, required = false,
                                 default = newJBool(true))
  if valid_594449 != nil:
    section.add "prettyPrint", valid_594449
  var valid_594450 = query.getOrDefault("bearer_token")
  valid_594450 = validateParameter(valid_594450, JString, required = false,
                                 default = nil)
  if valid_594450 != nil:
    section.add "bearer_token", valid_594450
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

proc call*(call_594452: Call_ContainerProjectsZonesClustersResourceLabels_594432;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets labels on a cluster.
  ## 
  let valid = call_594452.validator(path, query, header, formData, body)
  let scheme = call_594452.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594452.url(scheme.get, call_594452.host, call_594452.base,
                         call_594452.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594452, url, valid)

proc call*(call_594453: Call_ContainerProjectsZonesClustersResourceLabels_594432;
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
  var path_594454 = newJObject()
  var query_594455 = newJObject()
  var body_594456 = newJObject()
  add(query_594455, "upload_protocol", newJString(uploadProtocol))
  add(path_594454, "zone", newJString(zone))
  add(query_594455, "fields", newJString(fields))
  add(query_594455, "quotaUser", newJString(quotaUser))
  add(query_594455, "alt", newJString(alt))
  add(query_594455, "pp", newJBool(pp))
  add(query_594455, "oauth_token", newJString(oauthToken))
  add(query_594455, "callback", newJString(callback))
  add(query_594455, "access_token", newJString(accessToken))
  add(query_594455, "uploadType", newJString(uploadType))
  add(query_594455, "key", newJString(key))
  add(path_594454, "projectId", newJString(projectId))
  add(query_594455, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594456 = body
  add(query_594455, "prettyPrint", newJBool(prettyPrint))
  add(path_594454, "clusterId", newJString(clusterId))
  add(query_594455, "bearer_token", newJString(bearerToken))
  result = call_594453.call(path_594454, query_594455, nil, nil, body_594456)

var containerProjectsZonesClustersResourceLabels* = Call_ContainerProjectsZonesClustersResourceLabels_594432(
    name: "containerProjectsZonesClustersResourceLabels",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/resourceLabels",
    validator: validate_ContainerProjectsZonesClustersResourceLabels_594433,
    base: "/", url: url_ContainerProjectsZonesClustersResourceLabels_594434,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersCompleteIpRotation_594457 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersCompleteIpRotation_594459(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsZonesClustersCompleteIpRotation_594458(
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
  var valid_594460 = path.getOrDefault("zone")
  valid_594460 = validateParameter(valid_594460, JString, required = true,
                                 default = nil)
  if valid_594460 != nil:
    section.add "zone", valid_594460
  var valid_594461 = path.getOrDefault("projectId")
  valid_594461 = validateParameter(valid_594461, JString, required = true,
                                 default = nil)
  if valid_594461 != nil:
    section.add "projectId", valid_594461
  var valid_594462 = path.getOrDefault("clusterId")
  valid_594462 = validateParameter(valid_594462, JString, required = true,
                                 default = nil)
  if valid_594462 != nil:
    section.add "clusterId", valid_594462
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
  var valid_594463 = query.getOrDefault("upload_protocol")
  valid_594463 = validateParameter(valid_594463, JString, required = false,
                                 default = nil)
  if valid_594463 != nil:
    section.add "upload_protocol", valid_594463
  var valid_594464 = query.getOrDefault("fields")
  valid_594464 = validateParameter(valid_594464, JString, required = false,
                                 default = nil)
  if valid_594464 != nil:
    section.add "fields", valid_594464
  var valid_594465 = query.getOrDefault("quotaUser")
  valid_594465 = validateParameter(valid_594465, JString, required = false,
                                 default = nil)
  if valid_594465 != nil:
    section.add "quotaUser", valid_594465
  var valid_594466 = query.getOrDefault("alt")
  valid_594466 = validateParameter(valid_594466, JString, required = false,
                                 default = newJString("json"))
  if valid_594466 != nil:
    section.add "alt", valid_594466
  var valid_594467 = query.getOrDefault("pp")
  valid_594467 = validateParameter(valid_594467, JBool, required = false,
                                 default = newJBool(true))
  if valid_594467 != nil:
    section.add "pp", valid_594467
  var valid_594468 = query.getOrDefault("oauth_token")
  valid_594468 = validateParameter(valid_594468, JString, required = false,
                                 default = nil)
  if valid_594468 != nil:
    section.add "oauth_token", valid_594468
  var valid_594469 = query.getOrDefault("callback")
  valid_594469 = validateParameter(valid_594469, JString, required = false,
                                 default = nil)
  if valid_594469 != nil:
    section.add "callback", valid_594469
  var valid_594470 = query.getOrDefault("access_token")
  valid_594470 = validateParameter(valid_594470, JString, required = false,
                                 default = nil)
  if valid_594470 != nil:
    section.add "access_token", valid_594470
  var valid_594471 = query.getOrDefault("uploadType")
  valid_594471 = validateParameter(valid_594471, JString, required = false,
                                 default = nil)
  if valid_594471 != nil:
    section.add "uploadType", valid_594471
  var valid_594472 = query.getOrDefault("key")
  valid_594472 = validateParameter(valid_594472, JString, required = false,
                                 default = nil)
  if valid_594472 != nil:
    section.add "key", valid_594472
  var valid_594473 = query.getOrDefault("$.xgafv")
  valid_594473 = validateParameter(valid_594473, JString, required = false,
                                 default = newJString("1"))
  if valid_594473 != nil:
    section.add "$.xgafv", valid_594473
  var valid_594474 = query.getOrDefault("prettyPrint")
  valid_594474 = validateParameter(valid_594474, JBool, required = false,
                                 default = newJBool(true))
  if valid_594474 != nil:
    section.add "prettyPrint", valid_594474
  var valid_594475 = query.getOrDefault("bearer_token")
  valid_594475 = validateParameter(valid_594475, JString, required = false,
                                 default = nil)
  if valid_594475 != nil:
    section.add "bearer_token", valid_594475
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

proc call*(call_594477: Call_ContainerProjectsZonesClustersCompleteIpRotation_594457;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Completes master IP rotation.
  ## 
  let valid = call_594477.validator(path, query, header, formData, body)
  let scheme = call_594477.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594477.url(scheme.get, call_594477.host, call_594477.base,
                         call_594477.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594477, url, valid)

proc call*(call_594478: Call_ContainerProjectsZonesClustersCompleteIpRotation_594457;
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
  var path_594479 = newJObject()
  var query_594480 = newJObject()
  var body_594481 = newJObject()
  add(query_594480, "upload_protocol", newJString(uploadProtocol))
  add(path_594479, "zone", newJString(zone))
  add(query_594480, "fields", newJString(fields))
  add(query_594480, "quotaUser", newJString(quotaUser))
  add(query_594480, "alt", newJString(alt))
  add(query_594480, "pp", newJBool(pp))
  add(query_594480, "oauth_token", newJString(oauthToken))
  add(query_594480, "callback", newJString(callback))
  add(query_594480, "access_token", newJString(accessToken))
  add(query_594480, "uploadType", newJString(uploadType))
  add(query_594480, "key", newJString(key))
  add(path_594479, "projectId", newJString(projectId))
  add(query_594480, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594481 = body
  add(query_594480, "prettyPrint", newJBool(prettyPrint))
  add(path_594479, "clusterId", newJString(clusterId))
  add(query_594480, "bearer_token", newJString(bearerToken))
  result = call_594478.call(path_594479, query_594480, nil, nil, body_594481)

var containerProjectsZonesClustersCompleteIpRotation* = Call_ContainerProjectsZonesClustersCompleteIpRotation_594457(
    name: "containerProjectsZonesClustersCompleteIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:completeIpRotation",
    validator: validate_ContainerProjectsZonesClustersCompleteIpRotation_594458,
    base: "/", url: url_ContainerProjectsZonesClustersCompleteIpRotation_594459,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersSetMaintenancePolicy_594482 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersSetMaintenancePolicy_594484(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsZonesClustersSetMaintenancePolicy_594483(
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
  var valid_594485 = path.getOrDefault("zone")
  valid_594485 = validateParameter(valid_594485, JString, required = true,
                                 default = nil)
  if valid_594485 != nil:
    section.add "zone", valid_594485
  var valid_594486 = path.getOrDefault("projectId")
  valid_594486 = validateParameter(valid_594486, JString, required = true,
                                 default = nil)
  if valid_594486 != nil:
    section.add "projectId", valid_594486
  var valid_594487 = path.getOrDefault("clusterId")
  valid_594487 = validateParameter(valid_594487, JString, required = true,
                                 default = nil)
  if valid_594487 != nil:
    section.add "clusterId", valid_594487
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
  var valid_594488 = query.getOrDefault("upload_protocol")
  valid_594488 = validateParameter(valid_594488, JString, required = false,
                                 default = nil)
  if valid_594488 != nil:
    section.add "upload_protocol", valid_594488
  var valid_594489 = query.getOrDefault("fields")
  valid_594489 = validateParameter(valid_594489, JString, required = false,
                                 default = nil)
  if valid_594489 != nil:
    section.add "fields", valid_594489
  var valid_594490 = query.getOrDefault("quotaUser")
  valid_594490 = validateParameter(valid_594490, JString, required = false,
                                 default = nil)
  if valid_594490 != nil:
    section.add "quotaUser", valid_594490
  var valid_594491 = query.getOrDefault("alt")
  valid_594491 = validateParameter(valid_594491, JString, required = false,
                                 default = newJString("json"))
  if valid_594491 != nil:
    section.add "alt", valid_594491
  var valid_594492 = query.getOrDefault("pp")
  valid_594492 = validateParameter(valid_594492, JBool, required = false,
                                 default = newJBool(true))
  if valid_594492 != nil:
    section.add "pp", valid_594492
  var valid_594493 = query.getOrDefault("oauth_token")
  valid_594493 = validateParameter(valid_594493, JString, required = false,
                                 default = nil)
  if valid_594493 != nil:
    section.add "oauth_token", valid_594493
  var valid_594494 = query.getOrDefault("callback")
  valid_594494 = validateParameter(valid_594494, JString, required = false,
                                 default = nil)
  if valid_594494 != nil:
    section.add "callback", valid_594494
  var valid_594495 = query.getOrDefault("access_token")
  valid_594495 = validateParameter(valid_594495, JString, required = false,
                                 default = nil)
  if valid_594495 != nil:
    section.add "access_token", valid_594495
  var valid_594496 = query.getOrDefault("uploadType")
  valid_594496 = validateParameter(valid_594496, JString, required = false,
                                 default = nil)
  if valid_594496 != nil:
    section.add "uploadType", valid_594496
  var valid_594497 = query.getOrDefault("key")
  valid_594497 = validateParameter(valid_594497, JString, required = false,
                                 default = nil)
  if valid_594497 != nil:
    section.add "key", valid_594497
  var valid_594498 = query.getOrDefault("$.xgafv")
  valid_594498 = validateParameter(valid_594498, JString, required = false,
                                 default = newJString("1"))
  if valid_594498 != nil:
    section.add "$.xgafv", valid_594498
  var valid_594499 = query.getOrDefault("prettyPrint")
  valid_594499 = validateParameter(valid_594499, JBool, required = false,
                                 default = newJBool(true))
  if valid_594499 != nil:
    section.add "prettyPrint", valid_594499
  var valid_594500 = query.getOrDefault("bearer_token")
  valid_594500 = validateParameter(valid_594500, JString, required = false,
                                 default = nil)
  if valid_594500 != nil:
    section.add "bearer_token", valid_594500
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

proc call*(call_594502: Call_ContainerProjectsZonesClustersSetMaintenancePolicy_594482;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the maintenance policy for a cluster.
  ## 
  let valid = call_594502.validator(path, query, header, formData, body)
  let scheme = call_594502.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594502.url(scheme.get, call_594502.host, call_594502.base,
                         call_594502.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594502, url, valid)

proc call*(call_594503: Call_ContainerProjectsZonesClustersSetMaintenancePolicy_594482;
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
  var path_594504 = newJObject()
  var query_594505 = newJObject()
  var body_594506 = newJObject()
  add(query_594505, "upload_protocol", newJString(uploadProtocol))
  add(path_594504, "zone", newJString(zone))
  add(query_594505, "fields", newJString(fields))
  add(query_594505, "quotaUser", newJString(quotaUser))
  add(query_594505, "alt", newJString(alt))
  add(query_594505, "pp", newJBool(pp))
  add(query_594505, "oauth_token", newJString(oauthToken))
  add(query_594505, "callback", newJString(callback))
  add(query_594505, "access_token", newJString(accessToken))
  add(query_594505, "uploadType", newJString(uploadType))
  add(query_594505, "key", newJString(key))
  add(path_594504, "projectId", newJString(projectId))
  add(query_594505, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594506 = body
  add(query_594505, "prettyPrint", newJBool(prettyPrint))
  add(path_594504, "clusterId", newJString(clusterId))
  add(query_594505, "bearer_token", newJString(bearerToken))
  result = call_594503.call(path_594504, query_594505, nil, nil, body_594506)

var containerProjectsZonesClustersSetMaintenancePolicy* = Call_ContainerProjectsZonesClustersSetMaintenancePolicy_594482(
    name: "containerProjectsZonesClustersSetMaintenancePolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:setMaintenancePolicy",
    validator: validate_ContainerProjectsZonesClustersSetMaintenancePolicy_594483,
    base: "/", url: url_ContainerProjectsZonesClustersSetMaintenancePolicy_594484,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersSetMasterAuth_594507 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersSetMasterAuth_594509(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsZonesClustersSetMasterAuth_594508(path: JsonNode;
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
  var valid_594510 = path.getOrDefault("zone")
  valid_594510 = validateParameter(valid_594510, JString, required = true,
                                 default = nil)
  if valid_594510 != nil:
    section.add "zone", valid_594510
  var valid_594511 = path.getOrDefault("projectId")
  valid_594511 = validateParameter(valid_594511, JString, required = true,
                                 default = nil)
  if valid_594511 != nil:
    section.add "projectId", valid_594511
  var valid_594512 = path.getOrDefault("clusterId")
  valid_594512 = validateParameter(valid_594512, JString, required = true,
                                 default = nil)
  if valid_594512 != nil:
    section.add "clusterId", valid_594512
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
  var valid_594513 = query.getOrDefault("upload_protocol")
  valid_594513 = validateParameter(valid_594513, JString, required = false,
                                 default = nil)
  if valid_594513 != nil:
    section.add "upload_protocol", valid_594513
  var valid_594514 = query.getOrDefault("fields")
  valid_594514 = validateParameter(valid_594514, JString, required = false,
                                 default = nil)
  if valid_594514 != nil:
    section.add "fields", valid_594514
  var valid_594515 = query.getOrDefault("quotaUser")
  valid_594515 = validateParameter(valid_594515, JString, required = false,
                                 default = nil)
  if valid_594515 != nil:
    section.add "quotaUser", valid_594515
  var valid_594516 = query.getOrDefault("alt")
  valid_594516 = validateParameter(valid_594516, JString, required = false,
                                 default = newJString("json"))
  if valid_594516 != nil:
    section.add "alt", valid_594516
  var valid_594517 = query.getOrDefault("pp")
  valid_594517 = validateParameter(valid_594517, JBool, required = false,
                                 default = newJBool(true))
  if valid_594517 != nil:
    section.add "pp", valid_594517
  var valid_594518 = query.getOrDefault("oauth_token")
  valid_594518 = validateParameter(valid_594518, JString, required = false,
                                 default = nil)
  if valid_594518 != nil:
    section.add "oauth_token", valid_594518
  var valid_594519 = query.getOrDefault("callback")
  valid_594519 = validateParameter(valid_594519, JString, required = false,
                                 default = nil)
  if valid_594519 != nil:
    section.add "callback", valid_594519
  var valid_594520 = query.getOrDefault("access_token")
  valid_594520 = validateParameter(valid_594520, JString, required = false,
                                 default = nil)
  if valid_594520 != nil:
    section.add "access_token", valid_594520
  var valid_594521 = query.getOrDefault("uploadType")
  valid_594521 = validateParameter(valid_594521, JString, required = false,
                                 default = nil)
  if valid_594521 != nil:
    section.add "uploadType", valid_594521
  var valid_594522 = query.getOrDefault("key")
  valid_594522 = validateParameter(valid_594522, JString, required = false,
                                 default = nil)
  if valid_594522 != nil:
    section.add "key", valid_594522
  var valid_594523 = query.getOrDefault("$.xgafv")
  valid_594523 = validateParameter(valid_594523, JString, required = false,
                                 default = newJString("1"))
  if valid_594523 != nil:
    section.add "$.xgafv", valid_594523
  var valid_594524 = query.getOrDefault("prettyPrint")
  valid_594524 = validateParameter(valid_594524, JBool, required = false,
                                 default = newJBool(true))
  if valid_594524 != nil:
    section.add "prettyPrint", valid_594524
  var valid_594525 = query.getOrDefault("bearer_token")
  valid_594525 = validateParameter(valid_594525, JString, required = false,
                                 default = nil)
  if valid_594525 != nil:
    section.add "bearer_token", valid_594525
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

proc call*(call_594527: Call_ContainerProjectsZonesClustersSetMasterAuth_594507;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Used to set master auth materials. Currently supports :-
  ## Changing the admin password of a specific cluster.
  ## This can be either via password generation or explicitly set.
  ## Modify basic_auth.csv and reset the K8S API server.
  ## 
  let valid = call_594527.validator(path, query, header, formData, body)
  let scheme = call_594527.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594527.url(scheme.get, call_594527.host, call_594527.base,
                         call_594527.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594527, url, valid)

proc call*(call_594528: Call_ContainerProjectsZonesClustersSetMasterAuth_594507;
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
  var path_594529 = newJObject()
  var query_594530 = newJObject()
  var body_594531 = newJObject()
  add(query_594530, "upload_protocol", newJString(uploadProtocol))
  add(path_594529, "zone", newJString(zone))
  add(query_594530, "fields", newJString(fields))
  add(query_594530, "quotaUser", newJString(quotaUser))
  add(query_594530, "alt", newJString(alt))
  add(query_594530, "pp", newJBool(pp))
  add(query_594530, "oauth_token", newJString(oauthToken))
  add(query_594530, "callback", newJString(callback))
  add(query_594530, "access_token", newJString(accessToken))
  add(query_594530, "uploadType", newJString(uploadType))
  add(query_594530, "key", newJString(key))
  add(path_594529, "projectId", newJString(projectId))
  add(query_594530, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594531 = body
  add(query_594530, "prettyPrint", newJBool(prettyPrint))
  add(path_594529, "clusterId", newJString(clusterId))
  add(query_594530, "bearer_token", newJString(bearerToken))
  result = call_594528.call(path_594529, query_594530, nil, nil, body_594531)

var containerProjectsZonesClustersSetMasterAuth* = Call_ContainerProjectsZonesClustersSetMasterAuth_594507(
    name: "containerProjectsZonesClustersSetMasterAuth",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:setMasterAuth",
    validator: validate_ContainerProjectsZonesClustersSetMasterAuth_594508,
    base: "/", url: url_ContainerProjectsZonesClustersSetMasterAuth_594509,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersSetNetworkPolicy_594532 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersSetNetworkPolicy_594534(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsZonesClustersSetNetworkPolicy_594533(
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
  var valid_594535 = path.getOrDefault("zone")
  valid_594535 = validateParameter(valid_594535, JString, required = true,
                                 default = nil)
  if valid_594535 != nil:
    section.add "zone", valid_594535
  var valid_594536 = path.getOrDefault("projectId")
  valid_594536 = validateParameter(valid_594536, JString, required = true,
                                 default = nil)
  if valid_594536 != nil:
    section.add "projectId", valid_594536
  var valid_594537 = path.getOrDefault("clusterId")
  valid_594537 = validateParameter(valid_594537, JString, required = true,
                                 default = nil)
  if valid_594537 != nil:
    section.add "clusterId", valid_594537
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
  var valid_594538 = query.getOrDefault("upload_protocol")
  valid_594538 = validateParameter(valid_594538, JString, required = false,
                                 default = nil)
  if valid_594538 != nil:
    section.add "upload_protocol", valid_594538
  var valid_594539 = query.getOrDefault("fields")
  valid_594539 = validateParameter(valid_594539, JString, required = false,
                                 default = nil)
  if valid_594539 != nil:
    section.add "fields", valid_594539
  var valid_594540 = query.getOrDefault("quotaUser")
  valid_594540 = validateParameter(valid_594540, JString, required = false,
                                 default = nil)
  if valid_594540 != nil:
    section.add "quotaUser", valid_594540
  var valid_594541 = query.getOrDefault("alt")
  valid_594541 = validateParameter(valid_594541, JString, required = false,
                                 default = newJString("json"))
  if valid_594541 != nil:
    section.add "alt", valid_594541
  var valid_594542 = query.getOrDefault("pp")
  valid_594542 = validateParameter(valid_594542, JBool, required = false,
                                 default = newJBool(true))
  if valid_594542 != nil:
    section.add "pp", valid_594542
  var valid_594543 = query.getOrDefault("oauth_token")
  valid_594543 = validateParameter(valid_594543, JString, required = false,
                                 default = nil)
  if valid_594543 != nil:
    section.add "oauth_token", valid_594543
  var valid_594544 = query.getOrDefault("callback")
  valid_594544 = validateParameter(valid_594544, JString, required = false,
                                 default = nil)
  if valid_594544 != nil:
    section.add "callback", valid_594544
  var valid_594545 = query.getOrDefault("access_token")
  valid_594545 = validateParameter(valid_594545, JString, required = false,
                                 default = nil)
  if valid_594545 != nil:
    section.add "access_token", valid_594545
  var valid_594546 = query.getOrDefault("uploadType")
  valid_594546 = validateParameter(valid_594546, JString, required = false,
                                 default = nil)
  if valid_594546 != nil:
    section.add "uploadType", valid_594546
  var valid_594547 = query.getOrDefault("key")
  valid_594547 = validateParameter(valid_594547, JString, required = false,
                                 default = nil)
  if valid_594547 != nil:
    section.add "key", valid_594547
  var valid_594548 = query.getOrDefault("$.xgafv")
  valid_594548 = validateParameter(valid_594548, JString, required = false,
                                 default = newJString("1"))
  if valid_594548 != nil:
    section.add "$.xgafv", valid_594548
  var valid_594549 = query.getOrDefault("prettyPrint")
  valid_594549 = validateParameter(valid_594549, JBool, required = false,
                                 default = newJBool(true))
  if valid_594549 != nil:
    section.add "prettyPrint", valid_594549
  var valid_594550 = query.getOrDefault("bearer_token")
  valid_594550 = validateParameter(valid_594550, JString, required = false,
                                 default = nil)
  if valid_594550 != nil:
    section.add "bearer_token", valid_594550
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

proc call*(call_594552: Call_ContainerProjectsZonesClustersSetNetworkPolicy_594532;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables/Disables Network Policy for a cluster.
  ## 
  let valid = call_594552.validator(path, query, header, formData, body)
  let scheme = call_594552.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594552.url(scheme.get, call_594552.host, call_594552.base,
                         call_594552.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594552, url, valid)

proc call*(call_594553: Call_ContainerProjectsZonesClustersSetNetworkPolicy_594532;
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
  var path_594554 = newJObject()
  var query_594555 = newJObject()
  var body_594556 = newJObject()
  add(query_594555, "upload_protocol", newJString(uploadProtocol))
  add(path_594554, "zone", newJString(zone))
  add(query_594555, "fields", newJString(fields))
  add(query_594555, "quotaUser", newJString(quotaUser))
  add(query_594555, "alt", newJString(alt))
  add(query_594555, "pp", newJBool(pp))
  add(query_594555, "oauth_token", newJString(oauthToken))
  add(query_594555, "callback", newJString(callback))
  add(query_594555, "access_token", newJString(accessToken))
  add(query_594555, "uploadType", newJString(uploadType))
  add(query_594555, "key", newJString(key))
  add(path_594554, "projectId", newJString(projectId))
  add(query_594555, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594556 = body
  add(query_594555, "prettyPrint", newJBool(prettyPrint))
  add(path_594554, "clusterId", newJString(clusterId))
  add(query_594555, "bearer_token", newJString(bearerToken))
  result = call_594553.call(path_594554, query_594555, nil, nil, body_594556)

var containerProjectsZonesClustersSetNetworkPolicy* = Call_ContainerProjectsZonesClustersSetNetworkPolicy_594532(
    name: "containerProjectsZonesClustersSetNetworkPolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:setNetworkPolicy",
    validator: validate_ContainerProjectsZonesClustersSetNetworkPolicy_594533,
    base: "/", url: url_ContainerProjectsZonesClustersSetNetworkPolicy_594534,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersStartIpRotation_594557 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersStartIpRotation_594559(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsZonesClustersStartIpRotation_594558(
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
  var valid_594560 = path.getOrDefault("zone")
  valid_594560 = validateParameter(valid_594560, JString, required = true,
                                 default = nil)
  if valid_594560 != nil:
    section.add "zone", valid_594560
  var valid_594561 = path.getOrDefault("projectId")
  valid_594561 = validateParameter(valid_594561, JString, required = true,
                                 default = nil)
  if valid_594561 != nil:
    section.add "projectId", valid_594561
  var valid_594562 = path.getOrDefault("clusterId")
  valid_594562 = validateParameter(valid_594562, JString, required = true,
                                 default = nil)
  if valid_594562 != nil:
    section.add "clusterId", valid_594562
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
  var valid_594563 = query.getOrDefault("upload_protocol")
  valid_594563 = validateParameter(valid_594563, JString, required = false,
                                 default = nil)
  if valid_594563 != nil:
    section.add "upload_protocol", valid_594563
  var valid_594564 = query.getOrDefault("fields")
  valid_594564 = validateParameter(valid_594564, JString, required = false,
                                 default = nil)
  if valid_594564 != nil:
    section.add "fields", valid_594564
  var valid_594565 = query.getOrDefault("quotaUser")
  valid_594565 = validateParameter(valid_594565, JString, required = false,
                                 default = nil)
  if valid_594565 != nil:
    section.add "quotaUser", valid_594565
  var valid_594566 = query.getOrDefault("alt")
  valid_594566 = validateParameter(valid_594566, JString, required = false,
                                 default = newJString("json"))
  if valid_594566 != nil:
    section.add "alt", valid_594566
  var valid_594567 = query.getOrDefault("pp")
  valid_594567 = validateParameter(valid_594567, JBool, required = false,
                                 default = newJBool(true))
  if valid_594567 != nil:
    section.add "pp", valid_594567
  var valid_594568 = query.getOrDefault("oauth_token")
  valid_594568 = validateParameter(valid_594568, JString, required = false,
                                 default = nil)
  if valid_594568 != nil:
    section.add "oauth_token", valid_594568
  var valid_594569 = query.getOrDefault("callback")
  valid_594569 = validateParameter(valid_594569, JString, required = false,
                                 default = nil)
  if valid_594569 != nil:
    section.add "callback", valid_594569
  var valid_594570 = query.getOrDefault("access_token")
  valid_594570 = validateParameter(valid_594570, JString, required = false,
                                 default = nil)
  if valid_594570 != nil:
    section.add "access_token", valid_594570
  var valid_594571 = query.getOrDefault("uploadType")
  valid_594571 = validateParameter(valid_594571, JString, required = false,
                                 default = nil)
  if valid_594571 != nil:
    section.add "uploadType", valid_594571
  var valid_594572 = query.getOrDefault("key")
  valid_594572 = validateParameter(valid_594572, JString, required = false,
                                 default = nil)
  if valid_594572 != nil:
    section.add "key", valid_594572
  var valid_594573 = query.getOrDefault("$.xgafv")
  valid_594573 = validateParameter(valid_594573, JString, required = false,
                                 default = newJString("1"))
  if valid_594573 != nil:
    section.add "$.xgafv", valid_594573
  var valid_594574 = query.getOrDefault("prettyPrint")
  valid_594574 = validateParameter(valid_594574, JBool, required = false,
                                 default = newJBool(true))
  if valid_594574 != nil:
    section.add "prettyPrint", valid_594574
  var valid_594575 = query.getOrDefault("bearer_token")
  valid_594575 = validateParameter(valid_594575, JString, required = false,
                                 default = nil)
  if valid_594575 != nil:
    section.add "bearer_token", valid_594575
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

proc call*(call_594577: Call_ContainerProjectsZonesClustersStartIpRotation_594557;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Start master IP rotation.
  ## 
  let valid = call_594577.validator(path, query, header, formData, body)
  let scheme = call_594577.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594577.url(scheme.get, call_594577.host, call_594577.base,
                         call_594577.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594577, url, valid)

proc call*(call_594578: Call_ContainerProjectsZonesClustersStartIpRotation_594557;
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
  var path_594579 = newJObject()
  var query_594580 = newJObject()
  var body_594581 = newJObject()
  add(query_594580, "upload_protocol", newJString(uploadProtocol))
  add(path_594579, "zone", newJString(zone))
  add(query_594580, "fields", newJString(fields))
  add(query_594580, "quotaUser", newJString(quotaUser))
  add(query_594580, "alt", newJString(alt))
  add(query_594580, "pp", newJBool(pp))
  add(query_594580, "oauth_token", newJString(oauthToken))
  add(query_594580, "callback", newJString(callback))
  add(query_594580, "access_token", newJString(accessToken))
  add(query_594580, "uploadType", newJString(uploadType))
  add(query_594580, "key", newJString(key))
  add(path_594579, "projectId", newJString(projectId))
  add(query_594580, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594581 = body
  add(query_594580, "prettyPrint", newJBool(prettyPrint))
  add(path_594579, "clusterId", newJString(clusterId))
  add(query_594580, "bearer_token", newJString(bearerToken))
  result = call_594578.call(path_594579, query_594580, nil, nil, body_594581)

var containerProjectsZonesClustersStartIpRotation* = Call_ContainerProjectsZonesClustersStartIpRotation_594557(
    name: "containerProjectsZonesClustersStartIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:startIpRotation",
    validator: validate_ContainerProjectsZonesClustersStartIpRotation_594558,
    base: "/", url: url_ContainerProjectsZonesClustersStartIpRotation_594559,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesOperationsList_594582 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesOperationsList_594584(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsZonesOperationsList_594583(path: JsonNode;
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
  var valid_594585 = path.getOrDefault("zone")
  valid_594585 = validateParameter(valid_594585, JString, required = true,
                                 default = nil)
  if valid_594585 != nil:
    section.add "zone", valid_594585
  var valid_594586 = path.getOrDefault("projectId")
  valid_594586 = validateParameter(valid_594586, JString, required = true,
                                 default = nil)
  if valid_594586 != nil:
    section.add "projectId", valid_594586
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
  var valid_594587 = query.getOrDefault("upload_protocol")
  valid_594587 = validateParameter(valid_594587, JString, required = false,
                                 default = nil)
  if valid_594587 != nil:
    section.add "upload_protocol", valid_594587
  var valid_594588 = query.getOrDefault("fields")
  valid_594588 = validateParameter(valid_594588, JString, required = false,
                                 default = nil)
  if valid_594588 != nil:
    section.add "fields", valid_594588
  var valid_594589 = query.getOrDefault("quotaUser")
  valid_594589 = validateParameter(valid_594589, JString, required = false,
                                 default = nil)
  if valid_594589 != nil:
    section.add "quotaUser", valid_594589
  var valid_594590 = query.getOrDefault("alt")
  valid_594590 = validateParameter(valid_594590, JString, required = false,
                                 default = newJString("json"))
  if valid_594590 != nil:
    section.add "alt", valid_594590
  var valid_594591 = query.getOrDefault("pp")
  valid_594591 = validateParameter(valid_594591, JBool, required = false,
                                 default = newJBool(true))
  if valid_594591 != nil:
    section.add "pp", valid_594591
  var valid_594592 = query.getOrDefault("oauth_token")
  valid_594592 = validateParameter(valid_594592, JString, required = false,
                                 default = nil)
  if valid_594592 != nil:
    section.add "oauth_token", valid_594592
  var valid_594593 = query.getOrDefault("callback")
  valid_594593 = validateParameter(valid_594593, JString, required = false,
                                 default = nil)
  if valid_594593 != nil:
    section.add "callback", valid_594593
  var valid_594594 = query.getOrDefault("access_token")
  valid_594594 = validateParameter(valid_594594, JString, required = false,
                                 default = nil)
  if valid_594594 != nil:
    section.add "access_token", valid_594594
  var valid_594595 = query.getOrDefault("uploadType")
  valid_594595 = validateParameter(valid_594595, JString, required = false,
                                 default = nil)
  if valid_594595 != nil:
    section.add "uploadType", valid_594595
  var valid_594596 = query.getOrDefault("parent")
  valid_594596 = validateParameter(valid_594596, JString, required = false,
                                 default = nil)
  if valid_594596 != nil:
    section.add "parent", valid_594596
  var valid_594597 = query.getOrDefault("key")
  valid_594597 = validateParameter(valid_594597, JString, required = false,
                                 default = nil)
  if valid_594597 != nil:
    section.add "key", valid_594597
  var valid_594598 = query.getOrDefault("$.xgafv")
  valid_594598 = validateParameter(valid_594598, JString, required = false,
                                 default = newJString("1"))
  if valid_594598 != nil:
    section.add "$.xgafv", valid_594598
  var valid_594599 = query.getOrDefault("prettyPrint")
  valid_594599 = validateParameter(valid_594599, JBool, required = false,
                                 default = newJBool(true))
  if valid_594599 != nil:
    section.add "prettyPrint", valid_594599
  var valid_594600 = query.getOrDefault("bearer_token")
  valid_594600 = validateParameter(valid_594600, JString, required = false,
                                 default = nil)
  if valid_594600 != nil:
    section.add "bearer_token", valid_594600
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594601: Call_ContainerProjectsZonesOperationsList_594582;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all operations in a project in a specific zone or all zones.
  ## 
  let valid = call_594601.validator(path, query, header, formData, body)
  let scheme = call_594601.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594601.url(scheme.get, call_594601.host, call_594601.base,
                         call_594601.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594601, url, valid)

proc call*(call_594602: Call_ContainerProjectsZonesOperationsList_594582;
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
  var path_594603 = newJObject()
  var query_594604 = newJObject()
  add(query_594604, "upload_protocol", newJString(uploadProtocol))
  add(path_594603, "zone", newJString(zone))
  add(query_594604, "fields", newJString(fields))
  add(query_594604, "quotaUser", newJString(quotaUser))
  add(query_594604, "alt", newJString(alt))
  add(query_594604, "pp", newJBool(pp))
  add(query_594604, "oauth_token", newJString(oauthToken))
  add(query_594604, "callback", newJString(callback))
  add(query_594604, "access_token", newJString(accessToken))
  add(query_594604, "uploadType", newJString(uploadType))
  add(query_594604, "parent", newJString(parent))
  add(query_594604, "key", newJString(key))
  add(path_594603, "projectId", newJString(projectId))
  add(query_594604, "$.xgafv", newJString(Xgafv))
  add(query_594604, "prettyPrint", newJBool(prettyPrint))
  add(query_594604, "bearer_token", newJString(bearerToken))
  result = call_594602.call(path_594603, query_594604, nil, nil, nil)

var containerProjectsZonesOperationsList* = Call_ContainerProjectsZonesOperationsList_594582(
    name: "containerProjectsZonesOperationsList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1beta1/projects/{projectId}/zones/{zone}/operations",
    validator: validate_ContainerProjectsZonesOperationsList_594583, base: "/",
    url: url_ContainerProjectsZonesOperationsList_594584, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesOperationsGet_594605 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesOperationsGet_594607(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsZonesOperationsGet_594606(path: JsonNode;
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
  var valid_594608 = path.getOrDefault("zone")
  valid_594608 = validateParameter(valid_594608, JString, required = true,
                                 default = nil)
  if valid_594608 != nil:
    section.add "zone", valid_594608
  var valid_594609 = path.getOrDefault("projectId")
  valid_594609 = validateParameter(valid_594609, JString, required = true,
                                 default = nil)
  if valid_594609 != nil:
    section.add "projectId", valid_594609
  var valid_594610 = path.getOrDefault("operationId")
  valid_594610 = validateParameter(valid_594610, JString, required = true,
                                 default = nil)
  if valid_594610 != nil:
    section.add "operationId", valid_594610
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
  var valid_594611 = query.getOrDefault("upload_protocol")
  valid_594611 = validateParameter(valid_594611, JString, required = false,
                                 default = nil)
  if valid_594611 != nil:
    section.add "upload_protocol", valid_594611
  var valid_594612 = query.getOrDefault("fields")
  valid_594612 = validateParameter(valid_594612, JString, required = false,
                                 default = nil)
  if valid_594612 != nil:
    section.add "fields", valid_594612
  var valid_594613 = query.getOrDefault("quotaUser")
  valid_594613 = validateParameter(valid_594613, JString, required = false,
                                 default = nil)
  if valid_594613 != nil:
    section.add "quotaUser", valid_594613
  var valid_594614 = query.getOrDefault("alt")
  valid_594614 = validateParameter(valid_594614, JString, required = false,
                                 default = newJString("json"))
  if valid_594614 != nil:
    section.add "alt", valid_594614
  var valid_594615 = query.getOrDefault("pp")
  valid_594615 = validateParameter(valid_594615, JBool, required = false,
                                 default = newJBool(true))
  if valid_594615 != nil:
    section.add "pp", valid_594615
  var valid_594616 = query.getOrDefault("oauth_token")
  valid_594616 = validateParameter(valid_594616, JString, required = false,
                                 default = nil)
  if valid_594616 != nil:
    section.add "oauth_token", valid_594616
  var valid_594617 = query.getOrDefault("callback")
  valid_594617 = validateParameter(valid_594617, JString, required = false,
                                 default = nil)
  if valid_594617 != nil:
    section.add "callback", valid_594617
  var valid_594618 = query.getOrDefault("access_token")
  valid_594618 = validateParameter(valid_594618, JString, required = false,
                                 default = nil)
  if valid_594618 != nil:
    section.add "access_token", valid_594618
  var valid_594619 = query.getOrDefault("uploadType")
  valid_594619 = validateParameter(valid_594619, JString, required = false,
                                 default = nil)
  if valid_594619 != nil:
    section.add "uploadType", valid_594619
  var valid_594620 = query.getOrDefault("key")
  valid_594620 = validateParameter(valid_594620, JString, required = false,
                                 default = nil)
  if valid_594620 != nil:
    section.add "key", valid_594620
  var valid_594621 = query.getOrDefault("name")
  valid_594621 = validateParameter(valid_594621, JString, required = false,
                                 default = nil)
  if valid_594621 != nil:
    section.add "name", valid_594621
  var valid_594622 = query.getOrDefault("$.xgafv")
  valid_594622 = validateParameter(valid_594622, JString, required = false,
                                 default = newJString("1"))
  if valid_594622 != nil:
    section.add "$.xgafv", valid_594622
  var valid_594623 = query.getOrDefault("prettyPrint")
  valid_594623 = validateParameter(valid_594623, JBool, required = false,
                                 default = newJBool(true))
  if valid_594623 != nil:
    section.add "prettyPrint", valid_594623
  var valid_594624 = query.getOrDefault("bearer_token")
  valid_594624 = validateParameter(valid_594624, JString, required = false,
                                 default = nil)
  if valid_594624 != nil:
    section.add "bearer_token", valid_594624
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594625: Call_ContainerProjectsZonesOperationsGet_594605;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified operation.
  ## 
  let valid = call_594625.validator(path, query, header, formData, body)
  let scheme = call_594625.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594625.url(scheme.get, call_594625.host, call_594625.base,
                         call_594625.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594625, url, valid)

proc call*(call_594626: Call_ContainerProjectsZonesOperationsGet_594605;
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
  var path_594627 = newJObject()
  var query_594628 = newJObject()
  add(query_594628, "upload_protocol", newJString(uploadProtocol))
  add(path_594627, "zone", newJString(zone))
  add(query_594628, "fields", newJString(fields))
  add(query_594628, "quotaUser", newJString(quotaUser))
  add(query_594628, "alt", newJString(alt))
  add(query_594628, "pp", newJBool(pp))
  add(query_594628, "oauth_token", newJString(oauthToken))
  add(query_594628, "callback", newJString(callback))
  add(query_594628, "access_token", newJString(accessToken))
  add(query_594628, "uploadType", newJString(uploadType))
  add(query_594628, "key", newJString(key))
  add(query_594628, "name", newJString(name))
  add(path_594627, "projectId", newJString(projectId))
  add(query_594628, "$.xgafv", newJString(Xgafv))
  add(query_594628, "prettyPrint", newJBool(prettyPrint))
  add(path_594627, "operationId", newJString(operationId))
  add(query_594628, "bearer_token", newJString(bearerToken))
  result = call_594626.call(path_594627, query_594628, nil, nil, nil)

var containerProjectsZonesOperationsGet* = Call_ContainerProjectsZonesOperationsGet_594605(
    name: "containerProjectsZonesOperationsGet", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/operations/{operationId}",
    validator: validate_ContainerProjectsZonesOperationsGet_594606, base: "/",
    url: url_ContainerProjectsZonesOperationsGet_594607, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesOperationsCancel_594629 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesOperationsCancel_594631(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsZonesOperationsCancel_594630(path: JsonNode;
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
  var valid_594632 = path.getOrDefault("zone")
  valid_594632 = validateParameter(valid_594632, JString, required = true,
                                 default = nil)
  if valid_594632 != nil:
    section.add "zone", valid_594632
  var valid_594633 = path.getOrDefault("projectId")
  valid_594633 = validateParameter(valid_594633, JString, required = true,
                                 default = nil)
  if valid_594633 != nil:
    section.add "projectId", valid_594633
  var valid_594634 = path.getOrDefault("operationId")
  valid_594634 = validateParameter(valid_594634, JString, required = true,
                                 default = nil)
  if valid_594634 != nil:
    section.add "operationId", valid_594634
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
  var valid_594635 = query.getOrDefault("upload_protocol")
  valid_594635 = validateParameter(valid_594635, JString, required = false,
                                 default = nil)
  if valid_594635 != nil:
    section.add "upload_protocol", valid_594635
  var valid_594636 = query.getOrDefault("fields")
  valid_594636 = validateParameter(valid_594636, JString, required = false,
                                 default = nil)
  if valid_594636 != nil:
    section.add "fields", valid_594636
  var valid_594637 = query.getOrDefault("quotaUser")
  valid_594637 = validateParameter(valid_594637, JString, required = false,
                                 default = nil)
  if valid_594637 != nil:
    section.add "quotaUser", valid_594637
  var valid_594638 = query.getOrDefault("alt")
  valid_594638 = validateParameter(valid_594638, JString, required = false,
                                 default = newJString("json"))
  if valid_594638 != nil:
    section.add "alt", valid_594638
  var valid_594639 = query.getOrDefault("pp")
  valid_594639 = validateParameter(valid_594639, JBool, required = false,
                                 default = newJBool(true))
  if valid_594639 != nil:
    section.add "pp", valid_594639
  var valid_594640 = query.getOrDefault("oauth_token")
  valid_594640 = validateParameter(valid_594640, JString, required = false,
                                 default = nil)
  if valid_594640 != nil:
    section.add "oauth_token", valid_594640
  var valid_594641 = query.getOrDefault("callback")
  valid_594641 = validateParameter(valid_594641, JString, required = false,
                                 default = nil)
  if valid_594641 != nil:
    section.add "callback", valid_594641
  var valid_594642 = query.getOrDefault("access_token")
  valid_594642 = validateParameter(valid_594642, JString, required = false,
                                 default = nil)
  if valid_594642 != nil:
    section.add "access_token", valid_594642
  var valid_594643 = query.getOrDefault("uploadType")
  valid_594643 = validateParameter(valid_594643, JString, required = false,
                                 default = nil)
  if valid_594643 != nil:
    section.add "uploadType", valid_594643
  var valid_594644 = query.getOrDefault("key")
  valid_594644 = validateParameter(valid_594644, JString, required = false,
                                 default = nil)
  if valid_594644 != nil:
    section.add "key", valid_594644
  var valid_594645 = query.getOrDefault("$.xgafv")
  valid_594645 = validateParameter(valid_594645, JString, required = false,
                                 default = newJString("1"))
  if valid_594645 != nil:
    section.add "$.xgafv", valid_594645
  var valid_594646 = query.getOrDefault("prettyPrint")
  valid_594646 = validateParameter(valid_594646, JBool, required = false,
                                 default = newJBool(true))
  if valid_594646 != nil:
    section.add "prettyPrint", valid_594646
  var valid_594647 = query.getOrDefault("bearer_token")
  valid_594647 = validateParameter(valid_594647, JString, required = false,
                                 default = nil)
  if valid_594647 != nil:
    section.add "bearer_token", valid_594647
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

proc call*(call_594649: Call_ContainerProjectsZonesOperationsCancel_594629;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels the specified operation.
  ## 
  let valid = call_594649.validator(path, query, header, formData, body)
  let scheme = call_594649.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594649.url(scheme.get, call_594649.host, call_594649.base,
                         call_594649.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594649, url, valid)

proc call*(call_594650: Call_ContainerProjectsZonesOperationsCancel_594629;
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
  var path_594651 = newJObject()
  var query_594652 = newJObject()
  var body_594653 = newJObject()
  add(query_594652, "upload_protocol", newJString(uploadProtocol))
  add(path_594651, "zone", newJString(zone))
  add(query_594652, "fields", newJString(fields))
  add(query_594652, "quotaUser", newJString(quotaUser))
  add(query_594652, "alt", newJString(alt))
  add(query_594652, "pp", newJBool(pp))
  add(query_594652, "oauth_token", newJString(oauthToken))
  add(query_594652, "callback", newJString(callback))
  add(query_594652, "access_token", newJString(accessToken))
  add(query_594652, "uploadType", newJString(uploadType))
  add(query_594652, "key", newJString(key))
  add(path_594651, "projectId", newJString(projectId))
  add(query_594652, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594653 = body
  add(query_594652, "prettyPrint", newJBool(prettyPrint))
  add(path_594651, "operationId", newJString(operationId))
  add(query_594652, "bearer_token", newJString(bearerToken))
  result = call_594650.call(path_594651, query_594652, nil, nil, body_594653)

var containerProjectsZonesOperationsCancel* = Call_ContainerProjectsZonesOperationsCancel_594629(
    name: "containerProjectsZonesOperationsCancel", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/operations/{operationId}:cancel",
    validator: validate_ContainerProjectsZonesOperationsCancel_594630, base: "/",
    url: url_ContainerProjectsZonesOperationsCancel_594631,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesGetServerconfig_594654 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesGetServerconfig_594656(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsZonesGetServerconfig_594655(path: JsonNode;
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
  var valid_594657 = path.getOrDefault("zone")
  valid_594657 = validateParameter(valid_594657, JString, required = true,
                                 default = nil)
  if valid_594657 != nil:
    section.add "zone", valid_594657
  var valid_594658 = path.getOrDefault("projectId")
  valid_594658 = validateParameter(valid_594658, JString, required = true,
                                 default = nil)
  if valid_594658 != nil:
    section.add "projectId", valid_594658
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
  var valid_594659 = query.getOrDefault("upload_protocol")
  valid_594659 = validateParameter(valid_594659, JString, required = false,
                                 default = nil)
  if valid_594659 != nil:
    section.add "upload_protocol", valid_594659
  var valid_594660 = query.getOrDefault("fields")
  valid_594660 = validateParameter(valid_594660, JString, required = false,
                                 default = nil)
  if valid_594660 != nil:
    section.add "fields", valid_594660
  var valid_594661 = query.getOrDefault("quotaUser")
  valid_594661 = validateParameter(valid_594661, JString, required = false,
                                 default = nil)
  if valid_594661 != nil:
    section.add "quotaUser", valid_594661
  var valid_594662 = query.getOrDefault("alt")
  valid_594662 = validateParameter(valid_594662, JString, required = false,
                                 default = newJString("json"))
  if valid_594662 != nil:
    section.add "alt", valid_594662
  var valid_594663 = query.getOrDefault("pp")
  valid_594663 = validateParameter(valid_594663, JBool, required = false,
                                 default = newJBool(true))
  if valid_594663 != nil:
    section.add "pp", valid_594663
  var valid_594664 = query.getOrDefault("oauth_token")
  valid_594664 = validateParameter(valid_594664, JString, required = false,
                                 default = nil)
  if valid_594664 != nil:
    section.add "oauth_token", valid_594664
  var valid_594665 = query.getOrDefault("callback")
  valid_594665 = validateParameter(valid_594665, JString, required = false,
                                 default = nil)
  if valid_594665 != nil:
    section.add "callback", valid_594665
  var valid_594666 = query.getOrDefault("access_token")
  valid_594666 = validateParameter(valid_594666, JString, required = false,
                                 default = nil)
  if valid_594666 != nil:
    section.add "access_token", valid_594666
  var valid_594667 = query.getOrDefault("uploadType")
  valid_594667 = validateParameter(valid_594667, JString, required = false,
                                 default = nil)
  if valid_594667 != nil:
    section.add "uploadType", valid_594667
  var valid_594668 = query.getOrDefault("key")
  valid_594668 = validateParameter(valid_594668, JString, required = false,
                                 default = nil)
  if valid_594668 != nil:
    section.add "key", valid_594668
  var valid_594669 = query.getOrDefault("name")
  valid_594669 = validateParameter(valid_594669, JString, required = false,
                                 default = nil)
  if valid_594669 != nil:
    section.add "name", valid_594669
  var valid_594670 = query.getOrDefault("$.xgafv")
  valid_594670 = validateParameter(valid_594670, JString, required = false,
                                 default = newJString("1"))
  if valid_594670 != nil:
    section.add "$.xgafv", valid_594670
  var valid_594671 = query.getOrDefault("prettyPrint")
  valid_594671 = validateParameter(valid_594671, JBool, required = false,
                                 default = newJBool(true))
  if valid_594671 != nil:
    section.add "prettyPrint", valid_594671
  var valid_594672 = query.getOrDefault("bearer_token")
  valid_594672 = validateParameter(valid_594672, JString, required = false,
                                 default = nil)
  if valid_594672 != nil:
    section.add "bearer_token", valid_594672
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594673: Call_ContainerProjectsZonesGetServerconfig_594654;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns configuration info about the Container Engine service.
  ## 
  let valid = call_594673.validator(path, query, header, formData, body)
  let scheme = call_594673.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594673.url(scheme.get, call_594673.host, call_594673.base,
                         call_594673.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594673, url, valid)

proc call*(call_594674: Call_ContainerProjectsZonesGetServerconfig_594654;
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
  var path_594675 = newJObject()
  var query_594676 = newJObject()
  add(query_594676, "upload_protocol", newJString(uploadProtocol))
  add(path_594675, "zone", newJString(zone))
  add(query_594676, "fields", newJString(fields))
  add(query_594676, "quotaUser", newJString(quotaUser))
  add(query_594676, "alt", newJString(alt))
  add(query_594676, "pp", newJBool(pp))
  add(query_594676, "oauth_token", newJString(oauthToken))
  add(query_594676, "callback", newJString(callback))
  add(query_594676, "access_token", newJString(accessToken))
  add(query_594676, "uploadType", newJString(uploadType))
  add(query_594676, "key", newJString(key))
  add(query_594676, "name", newJString(name))
  add(path_594675, "projectId", newJString(projectId))
  add(query_594676, "$.xgafv", newJString(Xgafv))
  add(query_594676, "prettyPrint", newJBool(prettyPrint))
  add(query_594676, "bearer_token", newJString(bearerToken))
  result = call_594674.call(path_594675, query_594676, nil, nil, nil)

var containerProjectsZonesGetServerconfig* = Call_ContainerProjectsZonesGetServerconfig_594654(
    name: "containerProjectsZonesGetServerconfig", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1beta1/projects/{projectId}/zones/{zone}/serverconfig",
    validator: validate_ContainerProjectsZonesGetServerconfig_594655, base: "/",
    url: url_ContainerProjectsZonesGetServerconfig_594656, schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsUpdate_594702 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersNodePoolsUpdate_594704(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsUpdate_594703(
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
  var valid_594705 = path.getOrDefault("name")
  valid_594705 = validateParameter(valid_594705, JString, required = true,
                                 default = nil)
  if valid_594705 != nil:
    section.add "name", valid_594705
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
  var valid_594706 = query.getOrDefault("upload_protocol")
  valid_594706 = validateParameter(valid_594706, JString, required = false,
                                 default = nil)
  if valid_594706 != nil:
    section.add "upload_protocol", valid_594706
  var valid_594707 = query.getOrDefault("fields")
  valid_594707 = validateParameter(valid_594707, JString, required = false,
                                 default = nil)
  if valid_594707 != nil:
    section.add "fields", valid_594707
  var valid_594708 = query.getOrDefault("quotaUser")
  valid_594708 = validateParameter(valid_594708, JString, required = false,
                                 default = nil)
  if valid_594708 != nil:
    section.add "quotaUser", valid_594708
  var valid_594709 = query.getOrDefault("alt")
  valid_594709 = validateParameter(valid_594709, JString, required = false,
                                 default = newJString("json"))
  if valid_594709 != nil:
    section.add "alt", valid_594709
  var valid_594710 = query.getOrDefault("pp")
  valid_594710 = validateParameter(valid_594710, JBool, required = false,
                                 default = newJBool(true))
  if valid_594710 != nil:
    section.add "pp", valid_594710
  var valid_594711 = query.getOrDefault("oauth_token")
  valid_594711 = validateParameter(valid_594711, JString, required = false,
                                 default = nil)
  if valid_594711 != nil:
    section.add "oauth_token", valid_594711
  var valid_594712 = query.getOrDefault("callback")
  valid_594712 = validateParameter(valid_594712, JString, required = false,
                                 default = nil)
  if valid_594712 != nil:
    section.add "callback", valid_594712
  var valid_594713 = query.getOrDefault("access_token")
  valid_594713 = validateParameter(valid_594713, JString, required = false,
                                 default = nil)
  if valid_594713 != nil:
    section.add "access_token", valid_594713
  var valid_594714 = query.getOrDefault("uploadType")
  valid_594714 = validateParameter(valid_594714, JString, required = false,
                                 default = nil)
  if valid_594714 != nil:
    section.add "uploadType", valid_594714
  var valid_594715 = query.getOrDefault("key")
  valid_594715 = validateParameter(valid_594715, JString, required = false,
                                 default = nil)
  if valid_594715 != nil:
    section.add "key", valid_594715
  var valid_594716 = query.getOrDefault("$.xgafv")
  valid_594716 = validateParameter(valid_594716, JString, required = false,
                                 default = newJString("1"))
  if valid_594716 != nil:
    section.add "$.xgafv", valid_594716
  var valid_594717 = query.getOrDefault("prettyPrint")
  valid_594717 = validateParameter(valid_594717, JBool, required = false,
                                 default = newJBool(true))
  if valid_594717 != nil:
    section.add "prettyPrint", valid_594717
  var valid_594718 = query.getOrDefault("bearer_token")
  valid_594718 = validateParameter(valid_594718, JString, required = false,
                                 default = nil)
  if valid_594718 != nil:
    section.add "bearer_token", valid_594718
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

proc call*(call_594720: Call_ContainerProjectsLocationsClustersNodePoolsUpdate_594702;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the version and/or iamge type of a specific node pool.
  ## 
  let valid = call_594720.validator(path, query, header, formData, body)
  let scheme = call_594720.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594720.url(scheme.get, call_594720.host, call_594720.base,
                         call_594720.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594720, url, valid)

proc call*(call_594721: Call_ContainerProjectsLocationsClustersNodePoolsUpdate_594702;
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
  var path_594722 = newJObject()
  var query_594723 = newJObject()
  var body_594724 = newJObject()
  add(query_594723, "upload_protocol", newJString(uploadProtocol))
  add(query_594723, "fields", newJString(fields))
  add(query_594723, "quotaUser", newJString(quotaUser))
  add(path_594722, "name", newJString(name))
  add(query_594723, "alt", newJString(alt))
  add(query_594723, "pp", newJBool(pp))
  add(query_594723, "oauth_token", newJString(oauthToken))
  add(query_594723, "callback", newJString(callback))
  add(query_594723, "access_token", newJString(accessToken))
  add(query_594723, "uploadType", newJString(uploadType))
  add(query_594723, "key", newJString(key))
  add(query_594723, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594724 = body
  add(query_594723, "prettyPrint", newJBool(prettyPrint))
  add(query_594723, "bearer_token", newJString(bearerToken))
  result = call_594721.call(path_594722, query_594723, nil, nil, body_594724)

var containerProjectsLocationsClustersNodePoolsUpdate* = Call_ContainerProjectsLocationsClustersNodePoolsUpdate_594702(
    name: "containerProjectsLocationsClustersNodePoolsUpdate",
    meth: HttpMethod.HttpPut, host: "container.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsUpdate_594703,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsUpdate_594704,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsGet_594677 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersNodePoolsGet_594679(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsGet_594678(
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
  var valid_594680 = path.getOrDefault("name")
  valid_594680 = validateParameter(valid_594680, JString, required = true,
                                 default = nil)
  if valid_594680 != nil:
    section.add "name", valid_594680
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
  var valid_594681 = query.getOrDefault("upload_protocol")
  valid_594681 = validateParameter(valid_594681, JString, required = false,
                                 default = nil)
  if valid_594681 != nil:
    section.add "upload_protocol", valid_594681
  var valid_594682 = query.getOrDefault("fields")
  valid_594682 = validateParameter(valid_594682, JString, required = false,
                                 default = nil)
  if valid_594682 != nil:
    section.add "fields", valid_594682
  var valid_594683 = query.getOrDefault("quotaUser")
  valid_594683 = validateParameter(valid_594683, JString, required = false,
                                 default = nil)
  if valid_594683 != nil:
    section.add "quotaUser", valid_594683
  var valid_594684 = query.getOrDefault("alt")
  valid_594684 = validateParameter(valid_594684, JString, required = false,
                                 default = newJString("json"))
  if valid_594684 != nil:
    section.add "alt", valid_594684
  var valid_594685 = query.getOrDefault("pp")
  valid_594685 = validateParameter(valid_594685, JBool, required = false,
                                 default = newJBool(true))
  if valid_594685 != nil:
    section.add "pp", valid_594685
  var valid_594686 = query.getOrDefault("oauth_token")
  valid_594686 = validateParameter(valid_594686, JString, required = false,
                                 default = nil)
  if valid_594686 != nil:
    section.add "oauth_token", valid_594686
  var valid_594687 = query.getOrDefault("callback")
  valid_594687 = validateParameter(valid_594687, JString, required = false,
                                 default = nil)
  if valid_594687 != nil:
    section.add "callback", valid_594687
  var valid_594688 = query.getOrDefault("access_token")
  valid_594688 = validateParameter(valid_594688, JString, required = false,
                                 default = nil)
  if valid_594688 != nil:
    section.add "access_token", valid_594688
  var valid_594689 = query.getOrDefault("uploadType")
  valid_594689 = validateParameter(valid_594689, JString, required = false,
                                 default = nil)
  if valid_594689 != nil:
    section.add "uploadType", valid_594689
  var valid_594690 = query.getOrDefault("nodePoolId")
  valid_594690 = validateParameter(valid_594690, JString, required = false,
                                 default = nil)
  if valid_594690 != nil:
    section.add "nodePoolId", valid_594690
  var valid_594691 = query.getOrDefault("zone")
  valid_594691 = validateParameter(valid_594691, JString, required = false,
                                 default = nil)
  if valid_594691 != nil:
    section.add "zone", valid_594691
  var valid_594692 = query.getOrDefault("key")
  valid_594692 = validateParameter(valid_594692, JString, required = false,
                                 default = nil)
  if valid_594692 != nil:
    section.add "key", valid_594692
  var valid_594693 = query.getOrDefault("$.xgafv")
  valid_594693 = validateParameter(valid_594693, JString, required = false,
                                 default = newJString("1"))
  if valid_594693 != nil:
    section.add "$.xgafv", valid_594693
  var valid_594694 = query.getOrDefault("projectId")
  valid_594694 = validateParameter(valid_594694, JString, required = false,
                                 default = nil)
  if valid_594694 != nil:
    section.add "projectId", valid_594694
  var valid_594695 = query.getOrDefault("prettyPrint")
  valid_594695 = validateParameter(valid_594695, JBool, required = false,
                                 default = newJBool(true))
  if valid_594695 != nil:
    section.add "prettyPrint", valid_594695
  var valid_594696 = query.getOrDefault("clusterId")
  valid_594696 = validateParameter(valid_594696, JString, required = false,
                                 default = nil)
  if valid_594696 != nil:
    section.add "clusterId", valid_594696
  var valid_594697 = query.getOrDefault("bearer_token")
  valid_594697 = validateParameter(valid_594697, JString, required = false,
                                 default = nil)
  if valid_594697 != nil:
    section.add "bearer_token", valid_594697
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594698: Call_ContainerProjectsLocationsClustersNodePoolsGet_594677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the node pool requested.
  ## 
  let valid = call_594698.validator(path, query, header, formData, body)
  let scheme = call_594698.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594698.url(scheme.get, call_594698.host, call_594698.base,
                         call_594698.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594698, url, valid)

proc call*(call_594699: Call_ContainerProjectsLocationsClustersNodePoolsGet_594677;
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
  var path_594700 = newJObject()
  var query_594701 = newJObject()
  add(query_594701, "upload_protocol", newJString(uploadProtocol))
  add(query_594701, "fields", newJString(fields))
  add(query_594701, "quotaUser", newJString(quotaUser))
  add(path_594700, "name", newJString(name))
  add(query_594701, "alt", newJString(alt))
  add(query_594701, "pp", newJBool(pp))
  add(query_594701, "oauth_token", newJString(oauthToken))
  add(query_594701, "callback", newJString(callback))
  add(query_594701, "access_token", newJString(accessToken))
  add(query_594701, "uploadType", newJString(uploadType))
  add(query_594701, "nodePoolId", newJString(nodePoolId))
  add(query_594701, "zone", newJString(zone))
  add(query_594701, "key", newJString(key))
  add(query_594701, "$.xgafv", newJString(Xgafv))
  add(query_594701, "projectId", newJString(projectId))
  add(query_594701, "prettyPrint", newJBool(prettyPrint))
  add(query_594701, "clusterId", newJString(clusterId))
  add(query_594701, "bearer_token", newJString(bearerToken))
  result = call_594699.call(path_594700, query_594701, nil, nil, nil)

var containerProjectsLocationsClustersNodePoolsGet* = Call_ContainerProjectsLocationsClustersNodePoolsGet_594677(
    name: "containerProjectsLocationsClustersNodePoolsGet",
    meth: HttpMethod.HttpGet, host: "container.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsGet_594678,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsGet_594679,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsDelete_594725 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersNodePoolsDelete_594727(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsDelete_594726(
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
  var valid_594728 = path.getOrDefault("name")
  valid_594728 = validateParameter(valid_594728, JString, required = true,
                                 default = nil)
  if valid_594728 != nil:
    section.add "name", valid_594728
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
  var valid_594729 = query.getOrDefault("upload_protocol")
  valid_594729 = validateParameter(valid_594729, JString, required = false,
                                 default = nil)
  if valid_594729 != nil:
    section.add "upload_protocol", valid_594729
  var valid_594730 = query.getOrDefault("fields")
  valid_594730 = validateParameter(valid_594730, JString, required = false,
                                 default = nil)
  if valid_594730 != nil:
    section.add "fields", valid_594730
  var valid_594731 = query.getOrDefault("quotaUser")
  valid_594731 = validateParameter(valid_594731, JString, required = false,
                                 default = nil)
  if valid_594731 != nil:
    section.add "quotaUser", valid_594731
  var valid_594732 = query.getOrDefault("alt")
  valid_594732 = validateParameter(valid_594732, JString, required = false,
                                 default = newJString("json"))
  if valid_594732 != nil:
    section.add "alt", valid_594732
  var valid_594733 = query.getOrDefault("pp")
  valid_594733 = validateParameter(valid_594733, JBool, required = false,
                                 default = newJBool(true))
  if valid_594733 != nil:
    section.add "pp", valid_594733
  var valid_594734 = query.getOrDefault("oauth_token")
  valid_594734 = validateParameter(valid_594734, JString, required = false,
                                 default = nil)
  if valid_594734 != nil:
    section.add "oauth_token", valid_594734
  var valid_594735 = query.getOrDefault("callback")
  valid_594735 = validateParameter(valid_594735, JString, required = false,
                                 default = nil)
  if valid_594735 != nil:
    section.add "callback", valid_594735
  var valid_594736 = query.getOrDefault("access_token")
  valid_594736 = validateParameter(valid_594736, JString, required = false,
                                 default = nil)
  if valid_594736 != nil:
    section.add "access_token", valid_594736
  var valid_594737 = query.getOrDefault("uploadType")
  valid_594737 = validateParameter(valid_594737, JString, required = false,
                                 default = nil)
  if valid_594737 != nil:
    section.add "uploadType", valid_594737
  var valid_594738 = query.getOrDefault("nodePoolId")
  valid_594738 = validateParameter(valid_594738, JString, required = false,
                                 default = nil)
  if valid_594738 != nil:
    section.add "nodePoolId", valid_594738
  var valid_594739 = query.getOrDefault("zone")
  valid_594739 = validateParameter(valid_594739, JString, required = false,
                                 default = nil)
  if valid_594739 != nil:
    section.add "zone", valid_594739
  var valid_594740 = query.getOrDefault("key")
  valid_594740 = validateParameter(valid_594740, JString, required = false,
                                 default = nil)
  if valid_594740 != nil:
    section.add "key", valid_594740
  var valid_594741 = query.getOrDefault("$.xgafv")
  valid_594741 = validateParameter(valid_594741, JString, required = false,
                                 default = newJString("1"))
  if valid_594741 != nil:
    section.add "$.xgafv", valid_594741
  var valid_594742 = query.getOrDefault("projectId")
  valid_594742 = validateParameter(valid_594742, JString, required = false,
                                 default = nil)
  if valid_594742 != nil:
    section.add "projectId", valid_594742
  var valid_594743 = query.getOrDefault("prettyPrint")
  valid_594743 = validateParameter(valid_594743, JBool, required = false,
                                 default = newJBool(true))
  if valid_594743 != nil:
    section.add "prettyPrint", valid_594743
  var valid_594744 = query.getOrDefault("clusterId")
  valid_594744 = validateParameter(valid_594744, JString, required = false,
                                 default = nil)
  if valid_594744 != nil:
    section.add "clusterId", valid_594744
  var valid_594745 = query.getOrDefault("bearer_token")
  valid_594745 = validateParameter(valid_594745, JString, required = false,
                                 default = nil)
  if valid_594745 != nil:
    section.add "bearer_token", valid_594745
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594746: Call_ContainerProjectsLocationsClustersNodePoolsDelete_594725;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a node pool from a cluster.
  ## 
  let valid = call_594746.validator(path, query, header, formData, body)
  let scheme = call_594746.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594746.url(scheme.get, call_594746.host, call_594746.base,
                         call_594746.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594746, url, valid)

proc call*(call_594747: Call_ContainerProjectsLocationsClustersNodePoolsDelete_594725;
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
  var path_594748 = newJObject()
  var query_594749 = newJObject()
  add(query_594749, "upload_protocol", newJString(uploadProtocol))
  add(query_594749, "fields", newJString(fields))
  add(query_594749, "quotaUser", newJString(quotaUser))
  add(path_594748, "name", newJString(name))
  add(query_594749, "alt", newJString(alt))
  add(query_594749, "pp", newJBool(pp))
  add(query_594749, "oauth_token", newJString(oauthToken))
  add(query_594749, "callback", newJString(callback))
  add(query_594749, "access_token", newJString(accessToken))
  add(query_594749, "uploadType", newJString(uploadType))
  add(query_594749, "nodePoolId", newJString(nodePoolId))
  add(query_594749, "zone", newJString(zone))
  add(query_594749, "key", newJString(key))
  add(query_594749, "$.xgafv", newJString(Xgafv))
  add(query_594749, "projectId", newJString(projectId))
  add(query_594749, "prettyPrint", newJBool(prettyPrint))
  add(query_594749, "clusterId", newJString(clusterId))
  add(query_594749, "bearer_token", newJString(bearerToken))
  result = call_594747.call(path_594748, query_594749, nil, nil, nil)

var containerProjectsLocationsClustersNodePoolsDelete* = Call_ContainerProjectsLocationsClustersNodePoolsDelete_594725(
    name: "containerProjectsLocationsClustersNodePoolsDelete",
    meth: HttpMethod.HttpDelete, host: "container.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsDelete_594726,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsDelete_594727,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsGetServerConfig_594750 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsGetServerConfig_594752(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsLocationsGetServerConfig_594751(path: JsonNode;
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
  var valid_594753 = path.getOrDefault("name")
  valid_594753 = validateParameter(valid_594753, JString, required = true,
                                 default = nil)
  if valid_594753 != nil:
    section.add "name", valid_594753
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
  var valid_594754 = query.getOrDefault("upload_protocol")
  valid_594754 = validateParameter(valid_594754, JString, required = false,
                                 default = nil)
  if valid_594754 != nil:
    section.add "upload_protocol", valid_594754
  var valid_594755 = query.getOrDefault("fields")
  valid_594755 = validateParameter(valid_594755, JString, required = false,
                                 default = nil)
  if valid_594755 != nil:
    section.add "fields", valid_594755
  var valid_594756 = query.getOrDefault("quotaUser")
  valid_594756 = validateParameter(valid_594756, JString, required = false,
                                 default = nil)
  if valid_594756 != nil:
    section.add "quotaUser", valid_594756
  var valid_594757 = query.getOrDefault("alt")
  valid_594757 = validateParameter(valid_594757, JString, required = false,
                                 default = newJString("json"))
  if valid_594757 != nil:
    section.add "alt", valid_594757
  var valid_594758 = query.getOrDefault("pp")
  valid_594758 = validateParameter(valid_594758, JBool, required = false,
                                 default = newJBool(true))
  if valid_594758 != nil:
    section.add "pp", valid_594758
  var valid_594759 = query.getOrDefault("oauth_token")
  valid_594759 = validateParameter(valid_594759, JString, required = false,
                                 default = nil)
  if valid_594759 != nil:
    section.add "oauth_token", valid_594759
  var valid_594760 = query.getOrDefault("callback")
  valid_594760 = validateParameter(valid_594760, JString, required = false,
                                 default = nil)
  if valid_594760 != nil:
    section.add "callback", valid_594760
  var valid_594761 = query.getOrDefault("access_token")
  valid_594761 = validateParameter(valid_594761, JString, required = false,
                                 default = nil)
  if valid_594761 != nil:
    section.add "access_token", valid_594761
  var valid_594762 = query.getOrDefault("uploadType")
  valid_594762 = validateParameter(valid_594762, JString, required = false,
                                 default = nil)
  if valid_594762 != nil:
    section.add "uploadType", valid_594762
  var valid_594763 = query.getOrDefault("zone")
  valid_594763 = validateParameter(valid_594763, JString, required = false,
                                 default = nil)
  if valid_594763 != nil:
    section.add "zone", valid_594763
  var valid_594764 = query.getOrDefault("key")
  valid_594764 = validateParameter(valid_594764, JString, required = false,
                                 default = nil)
  if valid_594764 != nil:
    section.add "key", valid_594764
  var valid_594765 = query.getOrDefault("$.xgafv")
  valid_594765 = validateParameter(valid_594765, JString, required = false,
                                 default = newJString("1"))
  if valid_594765 != nil:
    section.add "$.xgafv", valid_594765
  var valid_594766 = query.getOrDefault("projectId")
  valid_594766 = validateParameter(valid_594766, JString, required = false,
                                 default = nil)
  if valid_594766 != nil:
    section.add "projectId", valid_594766
  var valid_594767 = query.getOrDefault("prettyPrint")
  valid_594767 = validateParameter(valid_594767, JBool, required = false,
                                 default = newJBool(true))
  if valid_594767 != nil:
    section.add "prettyPrint", valid_594767
  var valid_594768 = query.getOrDefault("bearer_token")
  valid_594768 = validateParameter(valid_594768, JString, required = false,
                                 default = nil)
  if valid_594768 != nil:
    section.add "bearer_token", valid_594768
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594769: Call_ContainerProjectsLocationsGetServerConfig_594750;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns configuration info about the Container Engine service.
  ## 
  let valid = call_594769.validator(path, query, header, formData, body)
  let scheme = call_594769.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594769.url(scheme.get, call_594769.host, call_594769.base,
                         call_594769.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594769, url, valid)

proc call*(call_594770: Call_ContainerProjectsLocationsGetServerConfig_594750;
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
  var path_594771 = newJObject()
  var query_594772 = newJObject()
  add(query_594772, "upload_protocol", newJString(uploadProtocol))
  add(query_594772, "fields", newJString(fields))
  add(query_594772, "quotaUser", newJString(quotaUser))
  add(path_594771, "name", newJString(name))
  add(query_594772, "alt", newJString(alt))
  add(query_594772, "pp", newJBool(pp))
  add(query_594772, "oauth_token", newJString(oauthToken))
  add(query_594772, "callback", newJString(callback))
  add(query_594772, "access_token", newJString(accessToken))
  add(query_594772, "uploadType", newJString(uploadType))
  add(query_594772, "zone", newJString(zone))
  add(query_594772, "key", newJString(key))
  add(query_594772, "$.xgafv", newJString(Xgafv))
  add(query_594772, "projectId", newJString(projectId))
  add(query_594772, "prettyPrint", newJBool(prettyPrint))
  add(query_594772, "bearer_token", newJString(bearerToken))
  result = call_594770.call(path_594771, query_594772, nil, nil, nil)

var containerProjectsLocationsGetServerConfig* = Call_ContainerProjectsLocationsGetServerConfig_594750(
    name: "containerProjectsLocationsGetServerConfig", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1beta1/{name}/serverConfig",
    validator: validate_ContainerProjectsLocationsGetServerConfig_594751,
    base: "/", url: url_ContainerProjectsLocationsGetServerConfig_594752,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsOperationsCancel_594773 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsOperationsCancel_594775(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsLocationsOperationsCancel_594774(path: JsonNode;
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
  var valid_594776 = path.getOrDefault("name")
  valid_594776 = validateParameter(valid_594776, JString, required = true,
                                 default = nil)
  if valid_594776 != nil:
    section.add "name", valid_594776
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
  var valid_594777 = query.getOrDefault("upload_protocol")
  valid_594777 = validateParameter(valid_594777, JString, required = false,
                                 default = nil)
  if valid_594777 != nil:
    section.add "upload_protocol", valid_594777
  var valid_594778 = query.getOrDefault("fields")
  valid_594778 = validateParameter(valid_594778, JString, required = false,
                                 default = nil)
  if valid_594778 != nil:
    section.add "fields", valid_594778
  var valid_594779 = query.getOrDefault("quotaUser")
  valid_594779 = validateParameter(valid_594779, JString, required = false,
                                 default = nil)
  if valid_594779 != nil:
    section.add "quotaUser", valid_594779
  var valid_594780 = query.getOrDefault("alt")
  valid_594780 = validateParameter(valid_594780, JString, required = false,
                                 default = newJString("json"))
  if valid_594780 != nil:
    section.add "alt", valid_594780
  var valid_594781 = query.getOrDefault("pp")
  valid_594781 = validateParameter(valid_594781, JBool, required = false,
                                 default = newJBool(true))
  if valid_594781 != nil:
    section.add "pp", valid_594781
  var valid_594782 = query.getOrDefault("oauth_token")
  valid_594782 = validateParameter(valid_594782, JString, required = false,
                                 default = nil)
  if valid_594782 != nil:
    section.add "oauth_token", valid_594782
  var valid_594783 = query.getOrDefault("callback")
  valid_594783 = validateParameter(valid_594783, JString, required = false,
                                 default = nil)
  if valid_594783 != nil:
    section.add "callback", valid_594783
  var valid_594784 = query.getOrDefault("access_token")
  valid_594784 = validateParameter(valid_594784, JString, required = false,
                                 default = nil)
  if valid_594784 != nil:
    section.add "access_token", valid_594784
  var valid_594785 = query.getOrDefault("uploadType")
  valid_594785 = validateParameter(valid_594785, JString, required = false,
                                 default = nil)
  if valid_594785 != nil:
    section.add "uploadType", valid_594785
  var valid_594786 = query.getOrDefault("key")
  valid_594786 = validateParameter(valid_594786, JString, required = false,
                                 default = nil)
  if valid_594786 != nil:
    section.add "key", valid_594786
  var valid_594787 = query.getOrDefault("$.xgafv")
  valid_594787 = validateParameter(valid_594787, JString, required = false,
                                 default = newJString("1"))
  if valid_594787 != nil:
    section.add "$.xgafv", valid_594787
  var valid_594788 = query.getOrDefault("prettyPrint")
  valid_594788 = validateParameter(valid_594788, JBool, required = false,
                                 default = newJBool(true))
  if valid_594788 != nil:
    section.add "prettyPrint", valid_594788
  var valid_594789 = query.getOrDefault("bearer_token")
  valid_594789 = validateParameter(valid_594789, JString, required = false,
                                 default = nil)
  if valid_594789 != nil:
    section.add "bearer_token", valid_594789
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

proc call*(call_594791: Call_ContainerProjectsLocationsOperationsCancel_594773;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels the specified operation.
  ## 
  let valid = call_594791.validator(path, query, header, formData, body)
  let scheme = call_594791.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594791.url(scheme.get, call_594791.host, call_594791.base,
                         call_594791.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594791, url, valid)

proc call*(call_594792: Call_ContainerProjectsLocationsOperationsCancel_594773;
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
  var path_594793 = newJObject()
  var query_594794 = newJObject()
  var body_594795 = newJObject()
  add(query_594794, "upload_protocol", newJString(uploadProtocol))
  add(query_594794, "fields", newJString(fields))
  add(query_594794, "quotaUser", newJString(quotaUser))
  add(path_594793, "name", newJString(name))
  add(query_594794, "alt", newJString(alt))
  add(query_594794, "pp", newJBool(pp))
  add(query_594794, "oauth_token", newJString(oauthToken))
  add(query_594794, "callback", newJString(callback))
  add(query_594794, "access_token", newJString(accessToken))
  add(query_594794, "uploadType", newJString(uploadType))
  add(query_594794, "key", newJString(key))
  add(query_594794, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594795 = body
  add(query_594794, "prettyPrint", newJBool(prettyPrint))
  add(query_594794, "bearer_token", newJString(bearerToken))
  result = call_594792.call(path_594793, query_594794, nil, nil, body_594795)

var containerProjectsLocationsOperationsCancel* = Call_ContainerProjectsLocationsOperationsCancel_594773(
    name: "containerProjectsLocationsOperationsCancel", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/{name}:cancel",
    validator: validate_ContainerProjectsLocationsOperationsCancel_594774,
    base: "/", url: url_ContainerProjectsLocationsOperationsCancel_594775,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersCompleteIpRotation_594796 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersCompleteIpRotation_594798(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsLocationsClustersCompleteIpRotation_594797(
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
  var valid_594799 = path.getOrDefault("name")
  valid_594799 = validateParameter(valid_594799, JString, required = true,
                                 default = nil)
  if valid_594799 != nil:
    section.add "name", valid_594799
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
  var valid_594800 = query.getOrDefault("upload_protocol")
  valid_594800 = validateParameter(valid_594800, JString, required = false,
                                 default = nil)
  if valid_594800 != nil:
    section.add "upload_protocol", valid_594800
  var valid_594801 = query.getOrDefault("fields")
  valid_594801 = validateParameter(valid_594801, JString, required = false,
                                 default = nil)
  if valid_594801 != nil:
    section.add "fields", valid_594801
  var valid_594802 = query.getOrDefault("quotaUser")
  valid_594802 = validateParameter(valid_594802, JString, required = false,
                                 default = nil)
  if valid_594802 != nil:
    section.add "quotaUser", valid_594802
  var valid_594803 = query.getOrDefault("alt")
  valid_594803 = validateParameter(valid_594803, JString, required = false,
                                 default = newJString("json"))
  if valid_594803 != nil:
    section.add "alt", valid_594803
  var valid_594804 = query.getOrDefault("pp")
  valid_594804 = validateParameter(valid_594804, JBool, required = false,
                                 default = newJBool(true))
  if valid_594804 != nil:
    section.add "pp", valid_594804
  var valid_594805 = query.getOrDefault("oauth_token")
  valid_594805 = validateParameter(valid_594805, JString, required = false,
                                 default = nil)
  if valid_594805 != nil:
    section.add "oauth_token", valid_594805
  var valid_594806 = query.getOrDefault("callback")
  valid_594806 = validateParameter(valid_594806, JString, required = false,
                                 default = nil)
  if valid_594806 != nil:
    section.add "callback", valid_594806
  var valid_594807 = query.getOrDefault("access_token")
  valid_594807 = validateParameter(valid_594807, JString, required = false,
                                 default = nil)
  if valid_594807 != nil:
    section.add "access_token", valid_594807
  var valid_594808 = query.getOrDefault("uploadType")
  valid_594808 = validateParameter(valid_594808, JString, required = false,
                                 default = nil)
  if valid_594808 != nil:
    section.add "uploadType", valid_594808
  var valid_594809 = query.getOrDefault("key")
  valid_594809 = validateParameter(valid_594809, JString, required = false,
                                 default = nil)
  if valid_594809 != nil:
    section.add "key", valid_594809
  var valid_594810 = query.getOrDefault("$.xgafv")
  valid_594810 = validateParameter(valid_594810, JString, required = false,
                                 default = newJString("1"))
  if valid_594810 != nil:
    section.add "$.xgafv", valid_594810
  var valid_594811 = query.getOrDefault("prettyPrint")
  valid_594811 = validateParameter(valid_594811, JBool, required = false,
                                 default = newJBool(true))
  if valid_594811 != nil:
    section.add "prettyPrint", valid_594811
  var valid_594812 = query.getOrDefault("bearer_token")
  valid_594812 = validateParameter(valid_594812, JString, required = false,
                                 default = nil)
  if valid_594812 != nil:
    section.add "bearer_token", valid_594812
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

proc call*(call_594814: Call_ContainerProjectsLocationsClustersCompleteIpRotation_594796;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Completes master IP rotation.
  ## 
  let valid = call_594814.validator(path, query, header, formData, body)
  let scheme = call_594814.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594814.url(scheme.get, call_594814.host, call_594814.base,
                         call_594814.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594814, url, valid)

proc call*(call_594815: Call_ContainerProjectsLocationsClustersCompleteIpRotation_594796;
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
  var path_594816 = newJObject()
  var query_594817 = newJObject()
  var body_594818 = newJObject()
  add(query_594817, "upload_protocol", newJString(uploadProtocol))
  add(query_594817, "fields", newJString(fields))
  add(query_594817, "quotaUser", newJString(quotaUser))
  add(path_594816, "name", newJString(name))
  add(query_594817, "alt", newJString(alt))
  add(query_594817, "pp", newJBool(pp))
  add(query_594817, "oauth_token", newJString(oauthToken))
  add(query_594817, "callback", newJString(callback))
  add(query_594817, "access_token", newJString(accessToken))
  add(query_594817, "uploadType", newJString(uploadType))
  add(query_594817, "key", newJString(key))
  add(query_594817, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594818 = body
  add(query_594817, "prettyPrint", newJBool(prettyPrint))
  add(query_594817, "bearer_token", newJString(bearerToken))
  result = call_594815.call(path_594816, query_594817, nil, nil, body_594818)

var containerProjectsLocationsClustersCompleteIpRotation* = Call_ContainerProjectsLocationsClustersCompleteIpRotation_594796(
    name: "containerProjectsLocationsClustersCompleteIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:completeIpRotation",
    validator: validate_ContainerProjectsLocationsClustersCompleteIpRotation_594797,
    base: "/", url: url_ContainerProjectsLocationsClustersCompleteIpRotation_594798,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsRollback_594819 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersNodePoolsRollback_594821(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsLocationsClustersNodePoolsRollback_594820(
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
  var valid_594822 = path.getOrDefault("name")
  valid_594822 = validateParameter(valid_594822, JString, required = true,
                                 default = nil)
  if valid_594822 != nil:
    section.add "name", valid_594822
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
  var valid_594823 = query.getOrDefault("upload_protocol")
  valid_594823 = validateParameter(valid_594823, JString, required = false,
                                 default = nil)
  if valid_594823 != nil:
    section.add "upload_protocol", valid_594823
  var valid_594824 = query.getOrDefault("fields")
  valid_594824 = validateParameter(valid_594824, JString, required = false,
                                 default = nil)
  if valid_594824 != nil:
    section.add "fields", valid_594824
  var valid_594825 = query.getOrDefault("quotaUser")
  valid_594825 = validateParameter(valid_594825, JString, required = false,
                                 default = nil)
  if valid_594825 != nil:
    section.add "quotaUser", valid_594825
  var valid_594826 = query.getOrDefault("alt")
  valid_594826 = validateParameter(valid_594826, JString, required = false,
                                 default = newJString("json"))
  if valid_594826 != nil:
    section.add "alt", valid_594826
  var valid_594827 = query.getOrDefault("pp")
  valid_594827 = validateParameter(valid_594827, JBool, required = false,
                                 default = newJBool(true))
  if valid_594827 != nil:
    section.add "pp", valid_594827
  var valid_594828 = query.getOrDefault("oauth_token")
  valid_594828 = validateParameter(valid_594828, JString, required = false,
                                 default = nil)
  if valid_594828 != nil:
    section.add "oauth_token", valid_594828
  var valid_594829 = query.getOrDefault("callback")
  valid_594829 = validateParameter(valid_594829, JString, required = false,
                                 default = nil)
  if valid_594829 != nil:
    section.add "callback", valid_594829
  var valid_594830 = query.getOrDefault("access_token")
  valid_594830 = validateParameter(valid_594830, JString, required = false,
                                 default = nil)
  if valid_594830 != nil:
    section.add "access_token", valid_594830
  var valid_594831 = query.getOrDefault("uploadType")
  valid_594831 = validateParameter(valid_594831, JString, required = false,
                                 default = nil)
  if valid_594831 != nil:
    section.add "uploadType", valid_594831
  var valid_594832 = query.getOrDefault("key")
  valid_594832 = validateParameter(valid_594832, JString, required = false,
                                 default = nil)
  if valid_594832 != nil:
    section.add "key", valid_594832
  var valid_594833 = query.getOrDefault("$.xgafv")
  valid_594833 = validateParameter(valid_594833, JString, required = false,
                                 default = newJString("1"))
  if valid_594833 != nil:
    section.add "$.xgafv", valid_594833
  var valid_594834 = query.getOrDefault("prettyPrint")
  valid_594834 = validateParameter(valid_594834, JBool, required = false,
                                 default = newJBool(true))
  if valid_594834 != nil:
    section.add "prettyPrint", valid_594834
  var valid_594835 = query.getOrDefault("bearer_token")
  valid_594835 = validateParameter(valid_594835, JString, required = false,
                                 default = nil)
  if valid_594835 != nil:
    section.add "bearer_token", valid_594835
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

proc call*(call_594837: Call_ContainerProjectsLocationsClustersNodePoolsRollback_594819;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Roll back the previously Aborted or Failed NodePool upgrade.
  ## This will be an no-op if the last upgrade successfully completed.
  ## 
  let valid = call_594837.validator(path, query, header, formData, body)
  let scheme = call_594837.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594837.url(scheme.get, call_594837.host, call_594837.base,
                         call_594837.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594837, url, valid)

proc call*(call_594838: Call_ContainerProjectsLocationsClustersNodePoolsRollback_594819;
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
  var path_594839 = newJObject()
  var query_594840 = newJObject()
  var body_594841 = newJObject()
  add(query_594840, "upload_protocol", newJString(uploadProtocol))
  add(query_594840, "fields", newJString(fields))
  add(query_594840, "quotaUser", newJString(quotaUser))
  add(path_594839, "name", newJString(name))
  add(query_594840, "alt", newJString(alt))
  add(query_594840, "pp", newJBool(pp))
  add(query_594840, "oauth_token", newJString(oauthToken))
  add(query_594840, "callback", newJString(callback))
  add(query_594840, "access_token", newJString(accessToken))
  add(query_594840, "uploadType", newJString(uploadType))
  add(query_594840, "key", newJString(key))
  add(query_594840, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594841 = body
  add(query_594840, "prettyPrint", newJBool(prettyPrint))
  add(query_594840, "bearer_token", newJString(bearerToken))
  result = call_594838.call(path_594839, query_594840, nil, nil, body_594841)

var containerProjectsLocationsClustersNodePoolsRollback* = Call_ContainerProjectsLocationsClustersNodePoolsRollback_594819(
    name: "containerProjectsLocationsClustersNodePoolsRollback",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:rollback",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsRollback_594820,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsRollback_594821,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetAddons_594842 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersSetAddons_594844(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsLocationsClustersSetAddons_594843(path: JsonNode;
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
  var valid_594845 = path.getOrDefault("name")
  valid_594845 = validateParameter(valid_594845, JString, required = true,
                                 default = nil)
  if valid_594845 != nil:
    section.add "name", valid_594845
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
  var valid_594846 = query.getOrDefault("upload_protocol")
  valid_594846 = validateParameter(valid_594846, JString, required = false,
                                 default = nil)
  if valid_594846 != nil:
    section.add "upload_protocol", valid_594846
  var valid_594847 = query.getOrDefault("fields")
  valid_594847 = validateParameter(valid_594847, JString, required = false,
                                 default = nil)
  if valid_594847 != nil:
    section.add "fields", valid_594847
  var valid_594848 = query.getOrDefault("quotaUser")
  valid_594848 = validateParameter(valid_594848, JString, required = false,
                                 default = nil)
  if valid_594848 != nil:
    section.add "quotaUser", valid_594848
  var valid_594849 = query.getOrDefault("alt")
  valid_594849 = validateParameter(valid_594849, JString, required = false,
                                 default = newJString("json"))
  if valid_594849 != nil:
    section.add "alt", valid_594849
  var valid_594850 = query.getOrDefault("pp")
  valid_594850 = validateParameter(valid_594850, JBool, required = false,
                                 default = newJBool(true))
  if valid_594850 != nil:
    section.add "pp", valid_594850
  var valid_594851 = query.getOrDefault("oauth_token")
  valid_594851 = validateParameter(valid_594851, JString, required = false,
                                 default = nil)
  if valid_594851 != nil:
    section.add "oauth_token", valid_594851
  var valid_594852 = query.getOrDefault("callback")
  valid_594852 = validateParameter(valid_594852, JString, required = false,
                                 default = nil)
  if valid_594852 != nil:
    section.add "callback", valid_594852
  var valid_594853 = query.getOrDefault("access_token")
  valid_594853 = validateParameter(valid_594853, JString, required = false,
                                 default = nil)
  if valid_594853 != nil:
    section.add "access_token", valid_594853
  var valid_594854 = query.getOrDefault("uploadType")
  valid_594854 = validateParameter(valid_594854, JString, required = false,
                                 default = nil)
  if valid_594854 != nil:
    section.add "uploadType", valid_594854
  var valid_594855 = query.getOrDefault("key")
  valid_594855 = validateParameter(valid_594855, JString, required = false,
                                 default = nil)
  if valid_594855 != nil:
    section.add "key", valid_594855
  var valid_594856 = query.getOrDefault("$.xgafv")
  valid_594856 = validateParameter(valid_594856, JString, required = false,
                                 default = newJString("1"))
  if valid_594856 != nil:
    section.add "$.xgafv", valid_594856
  var valid_594857 = query.getOrDefault("prettyPrint")
  valid_594857 = validateParameter(valid_594857, JBool, required = false,
                                 default = newJBool(true))
  if valid_594857 != nil:
    section.add "prettyPrint", valid_594857
  var valid_594858 = query.getOrDefault("bearer_token")
  valid_594858 = validateParameter(valid_594858, JString, required = false,
                                 default = nil)
  if valid_594858 != nil:
    section.add "bearer_token", valid_594858
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

proc call*(call_594860: Call_ContainerProjectsLocationsClustersSetAddons_594842;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the addons of a specific cluster.
  ## 
  let valid = call_594860.validator(path, query, header, formData, body)
  let scheme = call_594860.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594860.url(scheme.get, call_594860.host, call_594860.base,
                         call_594860.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594860, url, valid)

proc call*(call_594861: Call_ContainerProjectsLocationsClustersSetAddons_594842;
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
  var path_594862 = newJObject()
  var query_594863 = newJObject()
  var body_594864 = newJObject()
  add(query_594863, "upload_protocol", newJString(uploadProtocol))
  add(query_594863, "fields", newJString(fields))
  add(query_594863, "quotaUser", newJString(quotaUser))
  add(path_594862, "name", newJString(name))
  add(query_594863, "alt", newJString(alt))
  add(query_594863, "pp", newJBool(pp))
  add(query_594863, "oauth_token", newJString(oauthToken))
  add(query_594863, "callback", newJString(callback))
  add(query_594863, "access_token", newJString(accessToken))
  add(query_594863, "uploadType", newJString(uploadType))
  add(query_594863, "key", newJString(key))
  add(query_594863, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594864 = body
  add(query_594863, "prettyPrint", newJBool(prettyPrint))
  add(query_594863, "bearer_token", newJString(bearerToken))
  result = call_594861.call(path_594862, query_594863, nil, nil, body_594864)

var containerProjectsLocationsClustersSetAddons* = Call_ContainerProjectsLocationsClustersSetAddons_594842(
    name: "containerProjectsLocationsClustersSetAddons",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setAddons",
    validator: validate_ContainerProjectsLocationsClustersSetAddons_594843,
    base: "/", url: url_ContainerProjectsLocationsClustersSetAddons_594844,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_594865 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_594867(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_594866(
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
  var valid_594868 = path.getOrDefault("name")
  valid_594868 = validateParameter(valid_594868, JString, required = true,
                                 default = nil)
  if valid_594868 != nil:
    section.add "name", valid_594868
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
  var valid_594869 = query.getOrDefault("upload_protocol")
  valid_594869 = validateParameter(valid_594869, JString, required = false,
                                 default = nil)
  if valid_594869 != nil:
    section.add "upload_protocol", valid_594869
  var valid_594870 = query.getOrDefault("fields")
  valid_594870 = validateParameter(valid_594870, JString, required = false,
                                 default = nil)
  if valid_594870 != nil:
    section.add "fields", valid_594870
  var valid_594871 = query.getOrDefault("quotaUser")
  valid_594871 = validateParameter(valid_594871, JString, required = false,
                                 default = nil)
  if valid_594871 != nil:
    section.add "quotaUser", valid_594871
  var valid_594872 = query.getOrDefault("alt")
  valid_594872 = validateParameter(valid_594872, JString, required = false,
                                 default = newJString("json"))
  if valid_594872 != nil:
    section.add "alt", valid_594872
  var valid_594873 = query.getOrDefault("pp")
  valid_594873 = validateParameter(valid_594873, JBool, required = false,
                                 default = newJBool(true))
  if valid_594873 != nil:
    section.add "pp", valid_594873
  var valid_594874 = query.getOrDefault("oauth_token")
  valid_594874 = validateParameter(valid_594874, JString, required = false,
                                 default = nil)
  if valid_594874 != nil:
    section.add "oauth_token", valid_594874
  var valid_594875 = query.getOrDefault("callback")
  valid_594875 = validateParameter(valid_594875, JString, required = false,
                                 default = nil)
  if valid_594875 != nil:
    section.add "callback", valid_594875
  var valid_594876 = query.getOrDefault("access_token")
  valid_594876 = validateParameter(valid_594876, JString, required = false,
                                 default = nil)
  if valid_594876 != nil:
    section.add "access_token", valid_594876
  var valid_594877 = query.getOrDefault("uploadType")
  valid_594877 = validateParameter(valid_594877, JString, required = false,
                                 default = nil)
  if valid_594877 != nil:
    section.add "uploadType", valid_594877
  var valid_594878 = query.getOrDefault("key")
  valid_594878 = validateParameter(valid_594878, JString, required = false,
                                 default = nil)
  if valid_594878 != nil:
    section.add "key", valid_594878
  var valid_594879 = query.getOrDefault("$.xgafv")
  valid_594879 = validateParameter(valid_594879, JString, required = false,
                                 default = newJString("1"))
  if valid_594879 != nil:
    section.add "$.xgafv", valid_594879
  var valid_594880 = query.getOrDefault("prettyPrint")
  valid_594880 = validateParameter(valid_594880, JBool, required = false,
                                 default = newJBool(true))
  if valid_594880 != nil:
    section.add "prettyPrint", valid_594880
  var valid_594881 = query.getOrDefault("bearer_token")
  valid_594881 = validateParameter(valid_594881, JString, required = false,
                                 default = nil)
  if valid_594881 != nil:
    section.add "bearer_token", valid_594881
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

proc call*(call_594883: Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_594865;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the autoscaling settings of a specific node pool.
  ## 
  let valid = call_594883.validator(path, query, header, formData, body)
  let scheme = call_594883.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594883.url(scheme.get, call_594883.host, call_594883.base,
                         call_594883.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594883, url, valid)

proc call*(call_594884: Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_594865;
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
  var path_594885 = newJObject()
  var query_594886 = newJObject()
  var body_594887 = newJObject()
  add(query_594886, "upload_protocol", newJString(uploadProtocol))
  add(query_594886, "fields", newJString(fields))
  add(query_594886, "quotaUser", newJString(quotaUser))
  add(path_594885, "name", newJString(name))
  add(query_594886, "alt", newJString(alt))
  add(query_594886, "pp", newJBool(pp))
  add(query_594886, "oauth_token", newJString(oauthToken))
  add(query_594886, "callback", newJString(callback))
  add(query_594886, "access_token", newJString(accessToken))
  add(query_594886, "uploadType", newJString(uploadType))
  add(query_594886, "key", newJString(key))
  add(query_594886, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594887 = body
  add(query_594886, "prettyPrint", newJBool(prettyPrint))
  add(query_594886, "bearer_token", newJString(bearerToken))
  result = call_594884.call(path_594885, query_594886, nil, nil, body_594887)

var containerProjectsLocationsClustersNodePoolsSetAutoscaling* = Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_594865(
    name: "containerProjectsLocationsClustersNodePoolsSetAutoscaling",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setAutoscaling", validator: validate_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_594866,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_594867,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetLegacyAbac_594888 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersSetLegacyAbac_594890(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsLocationsClustersSetLegacyAbac_594889(
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
  var valid_594891 = path.getOrDefault("name")
  valid_594891 = validateParameter(valid_594891, JString, required = true,
                                 default = nil)
  if valid_594891 != nil:
    section.add "name", valid_594891
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
  var valid_594892 = query.getOrDefault("upload_protocol")
  valid_594892 = validateParameter(valid_594892, JString, required = false,
                                 default = nil)
  if valid_594892 != nil:
    section.add "upload_protocol", valid_594892
  var valid_594893 = query.getOrDefault("fields")
  valid_594893 = validateParameter(valid_594893, JString, required = false,
                                 default = nil)
  if valid_594893 != nil:
    section.add "fields", valid_594893
  var valid_594894 = query.getOrDefault("quotaUser")
  valid_594894 = validateParameter(valid_594894, JString, required = false,
                                 default = nil)
  if valid_594894 != nil:
    section.add "quotaUser", valid_594894
  var valid_594895 = query.getOrDefault("alt")
  valid_594895 = validateParameter(valid_594895, JString, required = false,
                                 default = newJString("json"))
  if valid_594895 != nil:
    section.add "alt", valid_594895
  var valid_594896 = query.getOrDefault("pp")
  valid_594896 = validateParameter(valid_594896, JBool, required = false,
                                 default = newJBool(true))
  if valid_594896 != nil:
    section.add "pp", valid_594896
  var valid_594897 = query.getOrDefault("oauth_token")
  valid_594897 = validateParameter(valid_594897, JString, required = false,
                                 default = nil)
  if valid_594897 != nil:
    section.add "oauth_token", valid_594897
  var valid_594898 = query.getOrDefault("callback")
  valid_594898 = validateParameter(valid_594898, JString, required = false,
                                 default = nil)
  if valid_594898 != nil:
    section.add "callback", valid_594898
  var valid_594899 = query.getOrDefault("access_token")
  valid_594899 = validateParameter(valid_594899, JString, required = false,
                                 default = nil)
  if valid_594899 != nil:
    section.add "access_token", valid_594899
  var valid_594900 = query.getOrDefault("uploadType")
  valid_594900 = validateParameter(valid_594900, JString, required = false,
                                 default = nil)
  if valid_594900 != nil:
    section.add "uploadType", valid_594900
  var valid_594901 = query.getOrDefault("key")
  valid_594901 = validateParameter(valid_594901, JString, required = false,
                                 default = nil)
  if valid_594901 != nil:
    section.add "key", valid_594901
  var valid_594902 = query.getOrDefault("$.xgafv")
  valid_594902 = validateParameter(valid_594902, JString, required = false,
                                 default = newJString("1"))
  if valid_594902 != nil:
    section.add "$.xgafv", valid_594902
  var valid_594903 = query.getOrDefault("prettyPrint")
  valid_594903 = validateParameter(valid_594903, JBool, required = false,
                                 default = newJBool(true))
  if valid_594903 != nil:
    section.add "prettyPrint", valid_594903
  var valid_594904 = query.getOrDefault("bearer_token")
  valid_594904 = validateParameter(valid_594904, JString, required = false,
                                 default = nil)
  if valid_594904 != nil:
    section.add "bearer_token", valid_594904
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

proc call*(call_594906: Call_ContainerProjectsLocationsClustersSetLegacyAbac_594888;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ## 
  let valid = call_594906.validator(path, query, header, formData, body)
  let scheme = call_594906.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594906.url(scheme.get, call_594906.host, call_594906.base,
                         call_594906.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594906, url, valid)

proc call*(call_594907: Call_ContainerProjectsLocationsClustersSetLegacyAbac_594888;
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
  var path_594908 = newJObject()
  var query_594909 = newJObject()
  var body_594910 = newJObject()
  add(query_594909, "upload_protocol", newJString(uploadProtocol))
  add(query_594909, "fields", newJString(fields))
  add(query_594909, "quotaUser", newJString(quotaUser))
  add(path_594908, "name", newJString(name))
  add(query_594909, "alt", newJString(alt))
  add(query_594909, "pp", newJBool(pp))
  add(query_594909, "oauth_token", newJString(oauthToken))
  add(query_594909, "callback", newJString(callback))
  add(query_594909, "access_token", newJString(accessToken))
  add(query_594909, "uploadType", newJString(uploadType))
  add(query_594909, "key", newJString(key))
  add(query_594909, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594910 = body
  add(query_594909, "prettyPrint", newJBool(prettyPrint))
  add(query_594909, "bearer_token", newJString(bearerToken))
  result = call_594907.call(path_594908, query_594909, nil, nil, body_594910)

var containerProjectsLocationsClustersSetLegacyAbac* = Call_ContainerProjectsLocationsClustersSetLegacyAbac_594888(
    name: "containerProjectsLocationsClustersSetLegacyAbac",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setLegacyAbac",
    validator: validate_ContainerProjectsLocationsClustersSetLegacyAbac_594889,
    base: "/", url: url_ContainerProjectsLocationsClustersSetLegacyAbac_594890,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetLocations_594911 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersSetLocations_594913(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsLocationsClustersSetLocations_594912(
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
  var valid_594914 = path.getOrDefault("name")
  valid_594914 = validateParameter(valid_594914, JString, required = true,
                                 default = nil)
  if valid_594914 != nil:
    section.add "name", valid_594914
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
  var valid_594915 = query.getOrDefault("upload_protocol")
  valid_594915 = validateParameter(valid_594915, JString, required = false,
                                 default = nil)
  if valid_594915 != nil:
    section.add "upload_protocol", valid_594915
  var valid_594916 = query.getOrDefault("fields")
  valid_594916 = validateParameter(valid_594916, JString, required = false,
                                 default = nil)
  if valid_594916 != nil:
    section.add "fields", valid_594916
  var valid_594917 = query.getOrDefault("quotaUser")
  valid_594917 = validateParameter(valid_594917, JString, required = false,
                                 default = nil)
  if valid_594917 != nil:
    section.add "quotaUser", valid_594917
  var valid_594918 = query.getOrDefault("alt")
  valid_594918 = validateParameter(valid_594918, JString, required = false,
                                 default = newJString("json"))
  if valid_594918 != nil:
    section.add "alt", valid_594918
  var valid_594919 = query.getOrDefault("pp")
  valid_594919 = validateParameter(valid_594919, JBool, required = false,
                                 default = newJBool(true))
  if valid_594919 != nil:
    section.add "pp", valid_594919
  var valid_594920 = query.getOrDefault("oauth_token")
  valid_594920 = validateParameter(valid_594920, JString, required = false,
                                 default = nil)
  if valid_594920 != nil:
    section.add "oauth_token", valid_594920
  var valid_594921 = query.getOrDefault("callback")
  valid_594921 = validateParameter(valid_594921, JString, required = false,
                                 default = nil)
  if valid_594921 != nil:
    section.add "callback", valid_594921
  var valid_594922 = query.getOrDefault("access_token")
  valid_594922 = validateParameter(valid_594922, JString, required = false,
                                 default = nil)
  if valid_594922 != nil:
    section.add "access_token", valid_594922
  var valid_594923 = query.getOrDefault("uploadType")
  valid_594923 = validateParameter(valid_594923, JString, required = false,
                                 default = nil)
  if valid_594923 != nil:
    section.add "uploadType", valid_594923
  var valid_594924 = query.getOrDefault("key")
  valid_594924 = validateParameter(valid_594924, JString, required = false,
                                 default = nil)
  if valid_594924 != nil:
    section.add "key", valid_594924
  var valid_594925 = query.getOrDefault("$.xgafv")
  valid_594925 = validateParameter(valid_594925, JString, required = false,
                                 default = newJString("1"))
  if valid_594925 != nil:
    section.add "$.xgafv", valid_594925
  var valid_594926 = query.getOrDefault("prettyPrint")
  valid_594926 = validateParameter(valid_594926, JBool, required = false,
                                 default = newJBool(true))
  if valid_594926 != nil:
    section.add "prettyPrint", valid_594926
  var valid_594927 = query.getOrDefault("bearer_token")
  valid_594927 = validateParameter(valid_594927, JString, required = false,
                                 default = nil)
  if valid_594927 != nil:
    section.add "bearer_token", valid_594927
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

proc call*(call_594929: Call_ContainerProjectsLocationsClustersSetLocations_594911;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the locations of a specific cluster.
  ## 
  let valid = call_594929.validator(path, query, header, formData, body)
  let scheme = call_594929.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594929.url(scheme.get, call_594929.host, call_594929.base,
                         call_594929.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594929, url, valid)

proc call*(call_594930: Call_ContainerProjectsLocationsClustersSetLocations_594911;
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
  var path_594931 = newJObject()
  var query_594932 = newJObject()
  var body_594933 = newJObject()
  add(query_594932, "upload_protocol", newJString(uploadProtocol))
  add(query_594932, "fields", newJString(fields))
  add(query_594932, "quotaUser", newJString(quotaUser))
  add(path_594931, "name", newJString(name))
  add(query_594932, "alt", newJString(alt))
  add(query_594932, "pp", newJBool(pp))
  add(query_594932, "oauth_token", newJString(oauthToken))
  add(query_594932, "callback", newJString(callback))
  add(query_594932, "access_token", newJString(accessToken))
  add(query_594932, "uploadType", newJString(uploadType))
  add(query_594932, "key", newJString(key))
  add(query_594932, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594933 = body
  add(query_594932, "prettyPrint", newJBool(prettyPrint))
  add(query_594932, "bearer_token", newJString(bearerToken))
  result = call_594930.call(path_594931, query_594932, nil, nil, body_594933)

var containerProjectsLocationsClustersSetLocations* = Call_ContainerProjectsLocationsClustersSetLocations_594911(
    name: "containerProjectsLocationsClustersSetLocations",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setLocations",
    validator: validate_ContainerProjectsLocationsClustersSetLocations_594912,
    base: "/", url: url_ContainerProjectsLocationsClustersSetLocations_594913,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetLogging_594934 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersSetLogging_594936(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsLocationsClustersSetLogging_594935(path: JsonNode;
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
  var valid_594937 = path.getOrDefault("name")
  valid_594937 = validateParameter(valid_594937, JString, required = true,
                                 default = nil)
  if valid_594937 != nil:
    section.add "name", valid_594937
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
  var valid_594938 = query.getOrDefault("upload_protocol")
  valid_594938 = validateParameter(valid_594938, JString, required = false,
                                 default = nil)
  if valid_594938 != nil:
    section.add "upload_protocol", valid_594938
  var valid_594939 = query.getOrDefault("fields")
  valid_594939 = validateParameter(valid_594939, JString, required = false,
                                 default = nil)
  if valid_594939 != nil:
    section.add "fields", valid_594939
  var valid_594940 = query.getOrDefault("quotaUser")
  valid_594940 = validateParameter(valid_594940, JString, required = false,
                                 default = nil)
  if valid_594940 != nil:
    section.add "quotaUser", valid_594940
  var valid_594941 = query.getOrDefault("alt")
  valid_594941 = validateParameter(valid_594941, JString, required = false,
                                 default = newJString("json"))
  if valid_594941 != nil:
    section.add "alt", valid_594941
  var valid_594942 = query.getOrDefault("pp")
  valid_594942 = validateParameter(valid_594942, JBool, required = false,
                                 default = newJBool(true))
  if valid_594942 != nil:
    section.add "pp", valid_594942
  var valid_594943 = query.getOrDefault("oauth_token")
  valid_594943 = validateParameter(valid_594943, JString, required = false,
                                 default = nil)
  if valid_594943 != nil:
    section.add "oauth_token", valid_594943
  var valid_594944 = query.getOrDefault("callback")
  valid_594944 = validateParameter(valid_594944, JString, required = false,
                                 default = nil)
  if valid_594944 != nil:
    section.add "callback", valid_594944
  var valid_594945 = query.getOrDefault("access_token")
  valid_594945 = validateParameter(valid_594945, JString, required = false,
                                 default = nil)
  if valid_594945 != nil:
    section.add "access_token", valid_594945
  var valid_594946 = query.getOrDefault("uploadType")
  valid_594946 = validateParameter(valid_594946, JString, required = false,
                                 default = nil)
  if valid_594946 != nil:
    section.add "uploadType", valid_594946
  var valid_594947 = query.getOrDefault("key")
  valid_594947 = validateParameter(valid_594947, JString, required = false,
                                 default = nil)
  if valid_594947 != nil:
    section.add "key", valid_594947
  var valid_594948 = query.getOrDefault("$.xgafv")
  valid_594948 = validateParameter(valid_594948, JString, required = false,
                                 default = newJString("1"))
  if valid_594948 != nil:
    section.add "$.xgafv", valid_594948
  var valid_594949 = query.getOrDefault("prettyPrint")
  valid_594949 = validateParameter(valid_594949, JBool, required = false,
                                 default = newJBool(true))
  if valid_594949 != nil:
    section.add "prettyPrint", valid_594949
  var valid_594950 = query.getOrDefault("bearer_token")
  valid_594950 = validateParameter(valid_594950, JString, required = false,
                                 default = nil)
  if valid_594950 != nil:
    section.add "bearer_token", valid_594950
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

proc call*(call_594952: Call_ContainerProjectsLocationsClustersSetLogging_594934;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the logging service of a specific cluster.
  ## 
  let valid = call_594952.validator(path, query, header, formData, body)
  let scheme = call_594952.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594952.url(scheme.get, call_594952.host, call_594952.base,
                         call_594952.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594952, url, valid)

proc call*(call_594953: Call_ContainerProjectsLocationsClustersSetLogging_594934;
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
  var path_594954 = newJObject()
  var query_594955 = newJObject()
  var body_594956 = newJObject()
  add(query_594955, "upload_protocol", newJString(uploadProtocol))
  add(query_594955, "fields", newJString(fields))
  add(query_594955, "quotaUser", newJString(quotaUser))
  add(path_594954, "name", newJString(name))
  add(query_594955, "alt", newJString(alt))
  add(query_594955, "pp", newJBool(pp))
  add(query_594955, "oauth_token", newJString(oauthToken))
  add(query_594955, "callback", newJString(callback))
  add(query_594955, "access_token", newJString(accessToken))
  add(query_594955, "uploadType", newJString(uploadType))
  add(query_594955, "key", newJString(key))
  add(query_594955, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594956 = body
  add(query_594955, "prettyPrint", newJBool(prettyPrint))
  add(query_594955, "bearer_token", newJString(bearerToken))
  result = call_594953.call(path_594954, query_594955, nil, nil, body_594956)

var containerProjectsLocationsClustersSetLogging* = Call_ContainerProjectsLocationsClustersSetLogging_594934(
    name: "containerProjectsLocationsClustersSetLogging",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setLogging",
    validator: validate_ContainerProjectsLocationsClustersSetLogging_594935,
    base: "/", url: url_ContainerProjectsLocationsClustersSetLogging_594936,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_594957 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersSetMaintenancePolicy_594959(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsLocationsClustersSetMaintenancePolicy_594958(
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
  var valid_594960 = path.getOrDefault("name")
  valid_594960 = validateParameter(valid_594960, JString, required = true,
                                 default = nil)
  if valid_594960 != nil:
    section.add "name", valid_594960
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
  var valid_594961 = query.getOrDefault("upload_protocol")
  valid_594961 = validateParameter(valid_594961, JString, required = false,
                                 default = nil)
  if valid_594961 != nil:
    section.add "upload_protocol", valid_594961
  var valid_594962 = query.getOrDefault("fields")
  valid_594962 = validateParameter(valid_594962, JString, required = false,
                                 default = nil)
  if valid_594962 != nil:
    section.add "fields", valid_594962
  var valid_594963 = query.getOrDefault("quotaUser")
  valid_594963 = validateParameter(valid_594963, JString, required = false,
                                 default = nil)
  if valid_594963 != nil:
    section.add "quotaUser", valid_594963
  var valid_594964 = query.getOrDefault("alt")
  valid_594964 = validateParameter(valid_594964, JString, required = false,
                                 default = newJString("json"))
  if valid_594964 != nil:
    section.add "alt", valid_594964
  var valid_594965 = query.getOrDefault("pp")
  valid_594965 = validateParameter(valid_594965, JBool, required = false,
                                 default = newJBool(true))
  if valid_594965 != nil:
    section.add "pp", valid_594965
  var valid_594966 = query.getOrDefault("oauth_token")
  valid_594966 = validateParameter(valid_594966, JString, required = false,
                                 default = nil)
  if valid_594966 != nil:
    section.add "oauth_token", valid_594966
  var valid_594967 = query.getOrDefault("callback")
  valid_594967 = validateParameter(valid_594967, JString, required = false,
                                 default = nil)
  if valid_594967 != nil:
    section.add "callback", valid_594967
  var valid_594968 = query.getOrDefault("access_token")
  valid_594968 = validateParameter(valid_594968, JString, required = false,
                                 default = nil)
  if valid_594968 != nil:
    section.add "access_token", valid_594968
  var valid_594969 = query.getOrDefault("uploadType")
  valid_594969 = validateParameter(valid_594969, JString, required = false,
                                 default = nil)
  if valid_594969 != nil:
    section.add "uploadType", valid_594969
  var valid_594970 = query.getOrDefault("key")
  valid_594970 = validateParameter(valid_594970, JString, required = false,
                                 default = nil)
  if valid_594970 != nil:
    section.add "key", valid_594970
  var valid_594971 = query.getOrDefault("$.xgafv")
  valid_594971 = validateParameter(valid_594971, JString, required = false,
                                 default = newJString("1"))
  if valid_594971 != nil:
    section.add "$.xgafv", valid_594971
  var valid_594972 = query.getOrDefault("prettyPrint")
  valid_594972 = validateParameter(valid_594972, JBool, required = false,
                                 default = newJBool(true))
  if valid_594972 != nil:
    section.add "prettyPrint", valid_594972
  var valid_594973 = query.getOrDefault("bearer_token")
  valid_594973 = validateParameter(valid_594973, JString, required = false,
                                 default = nil)
  if valid_594973 != nil:
    section.add "bearer_token", valid_594973
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

proc call*(call_594975: Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_594957;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the maintenance policy for a cluster.
  ## 
  let valid = call_594975.validator(path, query, header, formData, body)
  let scheme = call_594975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594975.url(scheme.get, call_594975.host, call_594975.base,
                         call_594975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594975, url, valid)

proc call*(call_594976: Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_594957;
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
  var path_594977 = newJObject()
  var query_594978 = newJObject()
  var body_594979 = newJObject()
  add(query_594978, "upload_protocol", newJString(uploadProtocol))
  add(query_594978, "fields", newJString(fields))
  add(query_594978, "quotaUser", newJString(quotaUser))
  add(path_594977, "name", newJString(name))
  add(query_594978, "alt", newJString(alt))
  add(query_594978, "pp", newJBool(pp))
  add(query_594978, "oauth_token", newJString(oauthToken))
  add(query_594978, "callback", newJString(callback))
  add(query_594978, "access_token", newJString(accessToken))
  add(query_594978, "uploadType", newJString(uploadType))
  add(query_594978, "key", newJString(key))
  add(query_594978, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594979 = body
  add(query_594978, "prettyPrint", newJBool(prettyPrint))
  add(query_594978, "bearer_token", newJString(bearerToken))
  result = call_594976.call(path_594977, query_594978, nil, nil, body_594979)

var containerProjectsLocationsClustersSetMaintenancePolicy* = Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_594957(
    name: "containerProjectsLocationsClustersSetMaintenancePolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setMaintenancePolicy",
    validator: validate_ContainerProjectsLocationsClustersSetMaintenancePolicy_594958,
    base: "/", url: url_ContainerProjectsLocationsClustersSetMaintenancePolicy_594959,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_594980 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersNodePoolsSetManagement_594982(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsLocationsClustersNodePoolsSetManagement_594981(
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
  var valid_594983 = path.getOrDefault("name")
  valid_594983 = validateParameter(valid_594983, JString, required = true,
                                 default = nil)
  if valid_594983 != nil:
    section.add "name", valid_594983
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
  var valid_594984 = query.getOrDefault("upload_protocol")
  valid_594984 = validateParameter(valid_594984, JString, required = false,
                                 default = nil)
  if valid_594984 != nil:
    section.add "upload_protocol", valid_594984
  var valid_594985 = query.getOrDefault("fields")
  valid_594985 = validateParameter(valid_594985, JString, required = false,
                                 default = nil)
  if valid_594985 != nil:
    section.add "fields", valid_594985
  var valid_594986 = query.getOrDefault("quotaUser")
  valid_594986 = validateParameter(valid_594986, JString, required = false,
                                 default = nil)
  if valid_594986 != nil:
    section.add "quotaUser", valid_594986
  var valid_594987 = query.getOrDefault("alt")
  valid_594987 = validateParameter(valid_594987, JString, required = false,
                                 default = newJString("json"))
  if valid_594987 != nil:
    section.add "alt", valid_594987
  var valid_594988 = query.getOrDefault("pp")
  valid_594988 = validateParameter(valid_594988, JBool, required = false,
                                 default = newJBool(true))
  if valid_594988 != nil:
    section.add "pp", valid_594988
  var valid_594989 = query.getOrDefault("oauth_token")
  valid_594989 = validateParameter(valid_594989, JString, required = false,
                                 default = nil)
  if valid_594989 != nil:
    section.add "oauth_token", valid_594989
  var valid_594990 = query.getOrDefault("callback")
  valid_594990 = validateParameter(valid_594990, JString, required = false,
                                 default = nil)
  if valid_594990 != nil:
    section.add "callback", valid_594990
  var valid_594991 = query.getOrDefault("access_token")
  valid_594991 = validateParameter(valid_594991, JString, required = false,
                                 default = nil)
  if valid_594991 != nil:
    section.add "access_token", valid_594991
  var valid_594992 = query.getOrDefault("uploadType")
  valid_594992 = validateParameter(valid_594992, JString, required = false,
                                 default = nil)
  if valid_594992 != nil:
    section.add "uploadType", valid_594992
  var valid_594993 = query.getOrDefault("key")
  valid_594993 = validateParameter(valid_594993, JString, required = false,
                                 default = nil)
  if valid_594993 != nil:
    section.add "key", valid_594993
  var valid_594994 = query.getOrDefault("$.xgafv")
  valid_594994 = validateParameter(valid_594994, JString, required = false,
                                 default = newJString("1"))
  if valid_594994 != nil:
    section.add "$.xgafv", valid_594994
  var valid_594995 = query.getOrDefault("prettyPrint")
  valid_594995 = validateParameter(valid_594995, JBool, required = false,
                                 default = newJBool(true))
  if valid_594995 != nil:
    section.add "prettyPrint", valid_594995
  var valid_594996 = query.getOrDefault("bearer_token")
  valid_594996 = validateParameter(valid_594996, JString, required = false,
                                 default = nil)
  if valid_594996 != nil:
    section.add "bearer_token", valid_594996
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

proc call*(call_594998: Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_594980;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the NodeManagement options for a node pool.
  ## 
  let valid = call_594998.validator(path, query, header, formData, body)
  let scheme = call_594998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594998.url(scheme.get, call_594998.host, call_594998.base,
                         call_594998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594998, url, valid)

proc call*(call_594999: Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_594980;
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
  var path_595000 = newJObject()
  var query_595001 = newJObject()
  var body_595002 = newJObject()
  add(query_595001, "upload_protocol", newJString(uploadProtocol))
  add(query_595001, "fields", newJString(fields))
  add(query_595001, "quotaUser", newJString(quotaUser))
  add(path_595000, "name", newJString(name))
  add(query_595001, "alt", newJString(alt))
  add(query_595001, "pp", newJBool(pp))
  add(query_595001, "oauth_token", newJString(oauthToken))
  add(query_595001, "callback", newJString(callback))
  add(query_595001, "access_token", newJString(accessToken))
  add(query_595001, "uploadType", newJString(uploadType))
  add(query_595001, "key", newJString(key))
  add(query_595001, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_595002 = body
  add(query_595001, "prettyPrint", newJBool(prettyPrint))
  add(query_595001, "bearer_token", newJString(bearerToken))
  result = call_594999.call(path_595000, query_595001, nil, nil, body_595002)

var containerProjectsLocationsClustersNodePoolsSetManagement* = Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_594980(
    name: "containerProjectsLocationsClustersNodePoolsSetManagement",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setManagement", validator: validate_ContainerProjectsLocationsClustersNodePoolsSetManagement_594981,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsSetManagement_594982,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetMasterAuth_595003 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersSetMasterAuth_595005(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsLocationsClustersSetMasterAuth_595004(
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
  var valid_595006 = path.getOrDefault("name")
  valid_595006 = validateParameter(valid_595006, JString, required = true,
                                 default = nil)
  if valid_595006 != nil:
    section.add "name", valid_595006
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
  var valid_595007 = query.getOrDefault("upload_protocol")
  valid_595007 = validateParameter(valid_595007, JString, required = false,
                                 default = nil)
  if valid_595007 != nil:
    section.add "upload_protocol", valid_595007
  var valid_595008 = query.getOrDefault("fields")
  valid_595008 = validateParameter(valid_595008, JString, required = false,
                                 default = nil)
  if valid_595008 != nil:
    section.add "fields", valid_595008
  var valid_595009 = query.getOrDefault("quotaUser")
  valid_595009 = validateParameter(valid_595009, JString, required = false,
                                 default = nil)
  if valid_595009 != nil:
    section.add "quotaUser", valid_595009
  var valid_595010 = query.getOrDefault("alt")
  valid_595010 = validateParameter(valid_595010, JString, required = false,
                                 default = newJString("json"))
  if valid_595010 != nil:
    section.add "alt", valid_595010
  var valid_595011 = query.getOrDefault("pp")
  valid_595011 = validateParameter(valid_595011, JBool, required = false,
                                 default = newJBool(true))
  if valid_595011 != nil:
    section.add "pp", valid_595011
  var valid_595012 = query.getOrDefault("oauth_token")
  valid_595012 = validateParameter(valid_595012, JString, required = false,
                                 default = nil)
  if valid_595012 != nil:
    section.add "oauth_token", valid_595012
  var valid_595013 = query.getOrDefault("callback")
  valid_595013 = validateParameter(valid_595013, JString, required = false,
                                 default = nil)
  if valid_595013 != nil:
    section.add "callback", valid_595013
  var valid_595014 = query.getOrDefault("access_token")
  valid_595014 = validateParameter(valid_595014, JString, required = false,
                                 default = nil)
  if valid_595014 != nil:
    section.add "access_token", valid_595014
  var valid_595015 = query.getOrDefault("uploadType")
  valid_595015 = validateParameter(valid_595015, JString, required = false,
                                 default = nil)
  if valid_595015 != nil:
    section.add "uploadType", valid_595015
  var valid_595016 = query.getOrDefault("key")
  valid_595016 = validateParameter(valid_595016, JString, required = false,
                                 default = nil)
  if valid_595016 != nil:
    section.add "key", valid_595016
  var valid_595017 = query.getOrDefault("$.xgafv")
  valid_595017 = validateParameter(valid_595017, JString, required = false,
                                 default = newJString("1"))
  if valid_595017 != nil:
    section.add "$.xgafv", valid_595017
  var valid_595018 = query.getOrDefault("prettyPrint")
  valid_595018 = validateParameter(valid_595018, JBool, required = false,
                                 default = newJBool(true))
  if valid_595018 != nil:
    section.add "prettyPrint", valid_595018
  var valid_595019 = query.getOrDefault("bearer_token")
  valid_595019 = validateParameter(valid_595019, JString, required = false,
                                 default = nil)
  if valid_595019 != nil:
    section.add "bearer_token", valid_595019
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

proc call*(call_595021: Call_ContainerProjectsLocationsClustersSetMasterAuth_595003;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Used to set master auth materials. Currently supports :-
  ## Changing the admin password of a specific cluster.
  ## This can be either via password generation or explicitly set.
  ## Modify basic_auth.csv and reset the K8S API server.
  ## 
  let valid = call_595021.validator(path, query, header, formData, body)
  let scheme = call_595021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595021.url(scheme.get, call_595021.host, call_595021.base,
                         call_595021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595021, url, valid)

proc call*(call_595022: Call_ContainerProjectsLocationsClustersSetMasterAuth_595003;
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
  var path_595023 = newJObject()
  var query_595024 = newJObject()
  var body_595025 = newJObject()
  add(query_595024, "upload_protocol", newJString(uploadProtocol))
  add(query_595024, "fields", newJString(fields))
  add(query_595024, "quotaUser", newJString(quotaUser))
  add(path_595023, "name", newJString(name))
  add(query_595024, "alt", newJString(alt))
  add(query_595024, "pp", newJBool(pp))
  add(query_595024, "oauth_token", newJString(oauthToken))
  add(query_595024, "callback", newJString(callback))
  add(query_595024, "access_token", newJString(accessToken))
  add(query_595024, "uploadType", newJString(uploadType))
  add(query_595024, "key", newJString(key))
  add(query_595024, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_595025 = body
  add(query_595024, "prettyPrint", newJBool(prettyPrint))
  add(query_595024, "bearer_token", newJString(bearerToken))
  result = call_595022.call(path_595023, query_595024, nil, nil, body_595025)

var containerProjectsLocationsClustersSetMasterAuth* = Call_ContainerProjectsLocationsClustersSetMasterAuth_595003(
    name: "containerProjectsLocationsClustersSetMasterAuth",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setMasterAuth",
    validator: validate_ContainerProjectsLocationsClustersSetMasterAuth_595004,
    base: "/", url: url_ContainerProjectsLocationsClustersSetMasterAuth_595005,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetMonitoring_595026 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersSetMonitoring_595028(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsLocationsClustersSetMonitoring_595027(
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
  var valid_595029 = path.getOrDefault("name")
  valid_595029 = validateParameter(valid_595029, JString, required = true,
                                 default = nil)
  if valid_595029 != nil:
    section.add "name", valid_595029
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
  var valid_595030 = query.getOrDefault("upload_protocol")
  valid_595030 = validateParameter(valid_595030, JString, required = false,
                                 default = nil)
  if valid_595030 != nil:
    section.add "upload_protocol", valid_595030
  var valid_595031 = query.getOrDefault("fields")
  valid_595031 = validateParameter(valid_595031, JString, required = false,
                                 default = nil)
  if valid_595031 != nil:
    section.add "fields", valid_595031
  var valid_595032 = query.getOrDefault("quotaUser")
  valid_595032 = validateParameter(valid_595032, JString, required = false,
                                 default = nil)
  if valid_595032 != nil:
    section.add "quotaUser", valid_595032
  var valid_595033 = query.getOrDefault("alt")
  valid_595033 = validateParameter(valid_595033, JString, required = false,
                                 default = newJString("json"))
  if valid_595033 != nil:
    section.add "alt", valid_595033
  var valid_595034 = query.getOrDefault("pp")
  valid_595034 = validateParameter(valid_595034, JBool, required = false,
                                 default = newJBool(true))
  if valid_595034 != nil:
    section.add "pp", valid_595034
  var valid_595035 = query.getOrDefault("oauth_token")
  valid_595035 = validateParameter(valid_595035, JString, required = false,
                                 default = nil)
  if valid_595035 != nil:
    section.add "oauth_token", valid_595035
  var valid_595036 = query.getOrDefault("callback")
  valid_595036 = validateParameter(valid_595036, JString, required = false,
                                 default = nil)
  if valid_595036 != nil:
    section.add "callback", valid_595036
  var valid_595037 = query.getOrDefault("access_token")
  valid_595037 = validateParameter(valid_595037, JString, required = false,
                                 default = nil)
  if valid_595037 != nil:
    section.add "access_token", valid_595037
  var valid_595038 = query.getOrDefault("uploadType")
  valid_595038 = validateParameter(valid_595038, JString, required = false,
                                 default = nil)
  if valid_595038 != nil:
    section.add "uploadType", valid_595038
  var valid_595039 = query.getOrDefault("key")
  valid_595039 = validateParameter(valid_595039, JString, required = false,
                                 default = nil)
  if valid_595039 != nil:
    section.add "key", valid_595039
  var valid_595040 = query.getOrDefault("$.xgafv")
  valid_595040 = validateParameter(valid_595040, JString, required = false,
                                 default = newJString("1"))
  if valid_595040 != nil:
    section.add "$.xgafv", valid_595040
  var valid_595041 = query.getOrDefault("prettyPrint")
  valid_595041 = validateParameter(valid_595041, JBool, required = false,
                                 default = newJBool(true))
  if valid_595041 != nil:
    section.add "prettyPrint", valid_595041
  var valid_595042 = query.getOrDefault("bearer_token")
  valid_595042 = validateParameter(valid_595042, JString, required = false,
                                 default = nil)
  if valid_595042 != nil:
    section.add "bearer_token", valid_595042
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

proc call*(call_595044: Call_ContainerProjectsLocationsClustersSetMonitoring_595026;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the monitoring service of a specific cluster.
  ## 
  let valid = call_595044.validator(path, query, header, formData, body)
  let scheme = call_595044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595044.url(scheme.get, call_595044.host, call_595044.base,
                         call_595044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595044, url, valid)

proc call*(call_595045: Call_ContainerProjectsLocationsClustersSetMonitoring_595026;
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
  var path_595046 = newJObject()
  var query_595047 = newJObject()
  var body_595048 = newJObject()
  add(query_595047, "upload_protocol", newJString(uploadProtocol))
  add(query_595047, "fields", newJString(fields))
  add(query_595047, "quotaUser", newJString(quotaUser))
  add(path_595046, "name", newJString(name))
  add(query_595047, "alt", newJString(alt))
  add(query_595047, "pp", newJBool(pp))
  add(query_595047, "oauth_token", newJString(oauthToken))
  add(query_595047, "callback", newJString(callback))
  add(query_595047, "access_token", newJString(accessToken))
  add(query_595047, "uploadType", newJString(uploadType))
  add(query_595047, "key", newJString(key))
  add(query_595047, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_595048 = body
  add(query_595047, "prettyPrint", newJBool(prettyPrint))
  add(query_595047, "bearer_token", newJString(bearerToken))
  result = call_595045.call(path_595046, query_595047, nil, nil, body_595048)

var containerProjectsLocationsClustersSetMonitoring* = Call_ContainerProjectsLocationsClustersSetMonitoring_595026(
    name: "containerProjectsLocationsClustersSetMonitoring",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setMonitoring",
    validator: validate_ContainerProjectsLocationsClustersSetMonitoring_595027,
    base: "/", url: url_ContainerProjectsLocationsClustersSetMonitoring_595028,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetNetworkPolicy_595049 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersSetNetworkPolicy_595051(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsLocationsClustersSetNetworkPolicy_595050(
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
  var valid_595052 = path.getOrDefault("name")
  valid_595052 = validateParameter(valid_595052, JString, required = true,
                                 default = nil)
  if valid_595052 != nil:
    section.add "name", valid_595052
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
  var valid_595053 = query.getOrDefault("upload_protocol")
  valid_595053 = validateParameter(valid_595053, JString, required = false,
                                 default = nil)
  if valid_595053 != nil:
    section.add "upload_protocol", valid_595053
  var valid_595054 = query.getOrDefault("fields")
  valid_595054 = validateParameter(valid_595054, JString, required = false,
                                 default = nil)
  if valid_595054 != nil:
    section.add "fields", valid_595054
  var valid_595055 = query.getOrDefault("quotaUser")
  valid_595055 = validateParameter(valid_595055, JString, required = false,
                                 default = nil)
  if valid_595055 != nil:
    section.add "quotaUser", valid_595055
  var valid_595056 = query.getOrDefault("alt")
  valid_595056 = validateParameter(valid_595056, JString, required = false,
                                 default = newJString("json"))
  if valid_595056 != nil:
    section.add "alt", valid_595056
  var valid_595057 = query.getOrDefault("pp")
  valid_595057 = validateParameter(valid_595057, JBool, required = false,
                                 default = newJBool(true))
  if valid_595057 != nil:
    section.add "pp", valid_595057
  var valid_595058 = query.getOrDefault("oauth_token")
  valid_595058 = validateParameter(valid_595058, JString, required = false,
                                 default = nil)
  if valid_595058 != nil:
    section.add "oauth_token", valid_595058
  var valid_595059 = query.getOrDefault("callback")
  valid_595059 = validateParameter(valid_595059, JString, required = false,
                                 default = nil)
  if valid_595059 != nil:
    section.add "callback", valid_595059
  var valid_595060 = query.getOrDefault("access_token")
  valid_595060 = validateParameter(valid_595060, JString, required = false,
                                 default = nil)
  if valid_595060 != nil:
    section.add "access_token", valid_595060
  var valid_595061 = query.getOrDefault("uploadType")
  valid_595061 = validateParameter(valid_595061, JString, required = false,
                                 default = nil)
  if valid_595061 != nil:
    section.add "uploadType", valid_595061
  var valid_595062 = query.getOrDefault("key")
  valid_595062 = validateParameter(valid_595062, JString, required = false,
                                 default = nil)
  if valid_595062 != nil:
    section.add "key", valid_595062
  var valid_595063 = query.getOrDefault("$.xgafv")
  valid_595063 = validateParameter(valid_595063, JString, required = false,
                                 default = newJString("1"))
  if valid_595063 != nil:
    section.add "$.xgafv", valid_595063
  var valid_595064 = query.getOrDefault("prettyPrint")
  valid_595064 = validateParameter(valid_595064, JBool, required = false,
                                 default = newJBool(true))
  if valid_595064 != nil:
    section.add "prettyPrint", valid_595064
  var valid_595065 = query.getOrDefault("bearer_token")
  valid_595065 = validateParameter(valid_595065, JString, required = false,
                                 default = nil)
  if valid_595065 != nil:
    section.add "bearer_token", valid_595065
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

proc call*(call_595067: Call_ContainerProjectsLocationsClustersSetNetworkPolicy_595049;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables/Disables Network Policy for a cluster.
  ## 
  let valid = call_595067.validator(path, query, header, formData, body)
  let scheme = call_595067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595067.url(scheme.get, call_595067.host, call_595067.base,
                         call_595067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595067, url, valid)

proc call*(call_595068: Call_ContainerProjectsLocationsClustersSetNetworkPolicy_595049;
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
  var path_595069 = newJObject()
  var query_595070 = newJObject()
  var body_595071 = newJObject()
  add(query_595070, "upload_protocol", newJString(uploadProtocol))
  add(query_595070, "fields", newJString(fields))
  add(query_595070, "quotaUser", newJString(quotaUser))
  add(path_595069, "name", newJString(name))
  add(query_595070, "alt", newJString(alt))
  add(query_595070, "pp", newJBool(pp))
  add(query_595070, "oauth_token", newJString(oauthToken))
  add(query_595070, "callback", newJString(callback))
  add(query_595070, "access_token", newJString(accessToken))
  add(query_595070, "uploadType", newJString(uploadType))
  add(query_595070, "key", newJString(key))
  add(query_595070, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_595071 = body
  add(query_595070, "prettyPrint", newJBool(prettyPrint))
  add(query_595070, "bearer_token", newJString(bearerToken))
  result = call_595068.call(path_595069, query_595070, nil, nil, body_595071)

var containerProjectsLocationsClustersSetNetworkPolicy* = Call_ContainerProjectsLocationsClustersSetNetworkPolicy_595049(
    name: "containerProjectsLocationsClustersSetNetworkPolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setNetworkPolicy",
    validator: validate_ContainerProjectsLocationsClustersSetNetworkPolicy_595050,
    base: "/", url: url_ContainerProjectsLocationsClustersSetNetworkPolicy_595051,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetResourceLabels_595072 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersSetResourceLabels_595074(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsLocationsClustersSetResourceLabels_595073(
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
  var valid_595075 = path.getOrDefault("name")
  valid_595075 = validateParameter(valid_595075, JString, required = true,
                                 default = nil)
  if valid_595075 != nil:
    section.add "name", valid_595075
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
  var valid_595076 = query.getOrDefault("upload_protocol")
  valid_595076 = validateParameter(valid_595076, JString, required = false,
                                 default = nil)
  if valid_595076 != nil:
    section.add "upload_protocol", valid_595076
  var valid_595077 = query.getOrDefault("fields")
  valid_595077 = validateParameter(valid_595077, JString, required = false,
                                 default = nil)
  if valid_595077 != nil:
    section.add "fields", valid_595077
  var valid_595078 = query.getOrDefault("quotaUser")
  valid_595078 = validateParameter(valid_595078, JString, required = false,
                                 default = nil)
  if valid_595078 != nil:
    section.add "quotaUser", valid_595078
  var valid_595079 = query.getOrDefault("alt")
  valid_595079 = validateParameter(valid_595079, JString, required = false,
                                 default = newJString("json"))
  if valid_595079 != nil:
    section.add "alt", valid_595079
  var valid_595080 = query.getOrDefault("pp")
  valid_595080 = validateParameter(valid_595080, JBool, required = false,
                                 default = newJBool(true))
  if valid_595080 != nil:
    section.add "pp", valid_595080
  var valid_595081 = query.getOrDefault("oauth_token")
  valid_595081 = validateParameter(valid_595081, JString, required = false,
                                 default = nil)
  if valid_595081 != nil:
    section.add "oauth_token", valid_595081
  var valid_595082 = query.getOrDefault("callback")
  valid_595082 = validateParameter(valid_595082, JString, required = false,
                                 default = nil)
  if valid_595082 != nil:
    section.add "callback", valid_595082
  var valid_595083 = query.getOrDefault("access_token")
  valid_595083 = validateParameter(valid_595083, JString, required = false,
                                 default = nil)
  if valid_595083 != nil:
    section.add "access_token", valid_595083
  var valid_595084 = query.getOrDefault("uploadType")
  valid_595084 = validateParameter(valid_595084, JString, required = false,
                                 default = nil)
  if valid_595084 != nil:
    section.add "uploadType", valid_595084
  var valid_595085 = query.getOrDefault("key")
  valid_595085 = validateParameter(valid_595085, JString, required = false,
                                 default = nil)
  if valid_595085 != nil:
    section.add "key", valid_595085
  var valid_595086 = query.getOrDefault("$.xgafv")
  valid_595086 = validateParameter(valid_595086, JString, required = false,
                                 default = newJString("1"))
  if valid_595086 != nil:
    section.add "$.xgafv", valid_595086
  var valid_595087 = query.getOrDefault("prettyPrint")
  valid_595087 = validateParameter(valid_595087, JBool, required = false,
                                 default = newJBool(true))
  if valid_595087 != nil:
    section.add "prettyPrint", valid_595087
  var valid_595088 = query.getOrDefault("bearer_token")
  valid_595088 = validateParameter(valid_595088, JString, required = false,
                                 default = nil)
  if valid_595088 != nil:
    section.add "bearer_token", valid_595088
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

proc call*(call_595090: Call_ContainerProjectsLocationsClustersSetResourceLabels_595072;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets labels on a cluster.
  ## 
  let valid = call_595090.validator(path, query, header, formData, body)
  let scheme = call_595090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595090.url(scheme.get, call_595090.host, call_595090.base,
                         call_595090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595090, url, valid)

proc call*(call_595091: Call_ContainerProjectsLocationsClustersSetResourceLabels_595072;
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
  var path_595092 = newJObject()
  var query_595093 = newJObject()
  var body_595094 = newJObject()
  add(query_595093, "upload_protocol", newJString(uploadProtocol))
  add(query_595093, "fields", newJString(fields))
  add(query_595093, "quotaUser", newJString(quotaUser))
  add(path_595092, "name", newJString(name))
  add(query_595093, "alt", newJString(alt))
  add(query_595093, "pp", newJBool(pp))
  add(query_595093, "oauth_token", newJString(oauthToken))
  add(query_595093, "callback", newJString(callback))
  add(query_595093, "access_token", newJString(accessToken))
  add(query_595093, "uploadType", newJString(uploadType))
  add(query_595093, "key", newJString(key))
  add(query_595093, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_595094 = body
  add(query_595093, "prettyPrint", newJBool(prettyPrint))
  add(query_595093, "bearer_token", newJString(bearerToken))
  result = call_595091.call(path_595092, query_595093, nil, nil, body_595094)

var containerProjectsLocationsClustersSetResourceLabels* = Call_ContainerProjectsLocationsClustersSetResourceLabels_595072(
    name: "containerProjectsLocationsClustersSetResourceLabels",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setResourceLabels",
    validator: validate_ContainerProjectsLocationsClustersSetResourceLabels_595073,
    base: "/", url: url_ContainerProjectsLocationsClustersSetResourceLabels_595074,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersStartIpRotation_595095 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersStartIpRotation_595097(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsLocationsClustersStartIpRotation_595096(
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
  var valid_595098 = path.getOrDefault("name")
  valid_595098 = validateParameter(valid_595098, JString, required = true,
                                 default = nil)
  if valid_595098 != nil:
    section.add "name", valid_595098
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
  var valid_595099 = query.getOrDefault("upload_protocol")
  valid_595099 = validateParameter(valid_595099, JString, required = false,
                                 default = nil)
  if valid_595099 != nil:
    section.add "upload_protocol", valid_595099
  var valid_595100 = query.getOrDefault("fields")
  valid_595100 = validateParameter(valid_595100, JString, required = false,
                                 default = nil)
  if valid_595100 != nil:
    section.add "fields", valid_595100
  var valid_595101 = query.getOrDefault("quotaUser")
  valid_595101 = validateParameter(valid_595101, JString, required = false,
                                 default = nil)
  if valid_595101 != nil:
    section.add "quotaUser", valid_595101
  var valid_595102 = query.getOrDefault("alt")
  valid_595102 = validateParameter(valid_595102, JString, required = false,
                                 default = newJString("json"))
  if valid_595102 != nil:
    section.add "alt", valid_595102
  var valid_595103 = query.getOrDefault("pp")
  valid_595103 = validateParameter(valid_595103, JBool, required = false,
                                 default = newJBool(true))
  if valid_595103 != nil:
    section.add "pp", valid_595103
  var valid_595104 = query.getOrDefault("oauth_token")
  valid_595104 = validateParameter(valid_595104, JString, required = false,
                                 default = nil)
  if valid_595104 != nil:
    section.add "oauth_token", valid_595104
  var valid_595105 = query.getOrDefault("callback")
  valid_595105 = validateParameter(valid_595105, JString, required = false,
                                 default = nil)
  if valid_595105 != nil:
    section.add "callback", valid_595105
  var valid_595106 = query.getOrDefault("access_token")
  valid_595106 = validateParameter(valid_595106, JString, required = false,
                                 default = nil)
  if valid_595106 != nil:
    section.add "access_token", valid_595106
  var valid_595107 = query.getOrDefault("uploadType")
  valid_595107 = validateParameter(valid_595107, JString, required = false,
                                 default = nil)
  if valid_595107 != nil:
    section.add "uploadType", valid_595107
  var valid_595108 = query.getOrDefault("key")
  valid_595108 = validateParameter(valid_595108, JString, required = false,
                                 default = nil)
  if valid_595108 != nil:
    section.add "key", valid_595108
  var valid_595109 = query.getOrDefault("$.xgafv")
  valid_595109 = validateParameter(valid_595109, JString, required = false,
                                 default = newJString("1"))
  if valid_595109 != nil:
    section.add "$.xgafv", valid_595109
  var valid_595110 = query.getOrDefault("prettyPrint")
  valid_595110 = validateParameter(valid_595110, JBool, required = false,
                                 default = newJBool(true))
  if valid_595110 != nil:
    section.add "prettyPrint", valid_595110
  var valid_595111 = query.getOrDefault("bearer_token")
  valid_595111 = validateParameter(valid_595111, JString, required = false,
                                 default = nil)
  if valid_595111 != nil:
    section.add "bearer_token", valid_595111
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

proc call*(call_595113: Call_ContainerProjectsLocationsClustersStartIpRotation_595095;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Start master IP rotation.
  ## 
  let valid = call_595113.validator(path, query, header, formData, body)
  let scheme = call_595113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595113.url(scheme.get, call_595113.host, call_595113.base,
                         call_595113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595113, url, valid)

proc call*(call_595114: Call_ContainerProjectsLocationsClustersStartIpRotation_595095;
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
  var path_595115 = newJObject()
  var query_595116 = newJObject()
  var body_595117 = newJObject()
  add(query_595116, "upload_protocol", newJString(uploadProtocol))
  add(query_595116, "fields", newJString(fields))
  add(query_595116, "quotaUser", newJString(quotaUser))
  add(path_595115, "name", newJString(name))
  add(query_595116, "alt", newJString(alt))
  add(query_595116, "pp", newJBool(pp))
  add(query_595116, "oauth_token", newJString(oauthToken))
  add(query_595116, "callback", newJString(callback))
  add(query_595116, "access_token", newJString(accessToken))
  add(query_595116, "uploadType", newJString(uploadType))
  add(query_595116, "key", newJString(key))
  add(query_595116, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_595117 = body
  add(query_595116, "prettyPrint", newJBool(prettyPrint))
  add(query_595116, "bearer_token", newJString(bearerToken))
  result = call_595114.call(path_595115, query_595116, nil, nil, body_595117)

var containerProjectsLocationsClustersStartIpRotation* = Call_ContainerProjectsLocationsClustersStartIpRotation_595095(
    name: "containerProjectsLocationsClustersStartIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:startIpRotation",
    validator: validate_ContainerProjectsLocationsClustersStartIpRotation_595096,
    base: "/", url: url_ContainerProjectsLocationsClustersStartIpRotation_595097,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersUpdateMaster_595118 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersUpdateMaster_595120(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsLocationsClustersUpdateMaster_595119(
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
  var valid_595121 = path.getOrDefault("name")
  valid_595121 = validateParameter(valid_595121, JString, required = true,
                                 default = nil)
  if valid_595121 != nil:
    section.add "name", valid_595121
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
  var valid_595122 = query.getOrDefault("upload_protocol")
  valid_595122 = validateParameter(valid_595122, JString, required = false,
                                 default = nil)
  if valid_595122 != nil:
    section.add "upload_protocol", valid_595122
  var valid_595123 = query.getOrDefault("fields")
  valid_595123 = validateParameter(valid_595123, JString, required = false,
                                 default = nil)
  if valid_595123 != nil:
    section.add "fields", valid_595123
  var valid_595124 = query.getOrDefault("quotaUser")
  valid_595124 = validateParameter(valid_595124, JString, required = false,
                                 default = nil)
  if valid_595124 != nil:
    section.add "quotaUser", valid_595124
  var valid_595125 = query.getOrDefault("alt")
  valid_595125 = validateParameter(valid_595125, JString, required = false,
                                 default = newJString("json"))
  if valid_595125 != nil:
    section.add "alt", valid_595125
  var valid_595126 = query.getOrDefault("pp")
  valid_595126 = validateParameter(valid_595126, JBool, required = false,
                                 default = newJBool(true))
  if valid_595126 != nil:
    section.add "pp", valid_595126
  var valid_595127 = query.getOrDefault("oauth_token")
  valid_595127 = validateParameter(valid_595127, JString, required = false,
                                 default = nil)
  if valid_595127 != nil:
    section.add "oauth_token", valid_595127
  var valid_595128 = query.getOrDefault("callback")
  valid_595128 = validateParameter(valid_595128, JString, required = false,
                                 default = nil)
  if valid_595128 != nil:
    section.add "callback", valid_595128
  var valid_595129 = query.getOrDefault("access_token")
  valid_595129 = validateParameter(valid_595129, JString, required = false,
                                 default = nil)
  if valid_595129 != nil:
    section.add "access_token", valid_595129
  var valid_595130 = query.getOrDefault("uploadType")
  valid_595130 = validateParameter(valid_595130, JString, required = false,
                                 default = nil)
  if valid_595130 != nil:
    section.add "uploadType", valid_595130
  var valid_595131 = query.getOrDefault("key")
  valid_595131 = validateParameter(valid_595131, JString, required = false,
                                 default = nil)
  if valid_595131 != nil:
    section.add "key", valid_595131
  var valid_595132 = query.getOrDefault("$.xgafv")
  valid_595132 = validateParameter(valid_595132, JString, required = false,
                                 default = newJString("1"))
  if valid_595132 != nil:
    section.add "$.xgafv", valid_595132
  var valid_595133 = query.getOrDefault("prettyPrint")
  valid_595133 = validateParameter(valid_595133, JBool, required = false,
                                 default = newJBool(true))
  if valid_595133 != nil:
    section.add "prettyPrint", valid_595133
  var valid_595134 = query.getOrDefault("bearer_token")
  valid_595134 = validateParameter(valid_595134, JString, required = false,
                                 default = nil)
  if valid_595134 != nil:
    section.add "bearer_token", valid_595134
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

proc call*(call_595136: Call_ContainerProjectsLocationsClustersUpdateMaster_595118;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the master of a specific cluster.
  ## 
  let valid = call_595136.validator(path, query, header, formData, body)
  let scheme = call_595136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595136.url(scheme.get, call_595136.host, call_595136.base,
                         call_595136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595136, url, valid)

proc call*(call_595137: Call_ContainerProjectsLocationsClustersUpdateMaster_595118;
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
  var path_595138 = newJObject()
  var query_595139 = newJObject()
  var body_595140 = newJObject()
  add(query_595139, "upload_protocol", newJString(uploadProtocol))
  add(query_595139, "fields", newJString(fields))
  add(query_595139, "quotaUser", newJString(quotaUser))
  add(path_595138, "name", newJString(name))
  add(query_595139, "alt", newJString(alt))
  add(query_595139, "pp", newJBool(pp))
  add(query_595139, "oauth_token", newJString(oauthToken))
  add(query_595139, "callback", newJString(callback))
  add(query_595139, "access_token", newJString(accessToken))
  add(query_595139, "uploadType", newJString(uploadType))
  add(query_595139, "key", newJString(key))
  add(query_595139, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_595140 = body
  add(query_595139, "prettyPrint", newJBool(prettyPrint))
  add(query_595139, "bearer_token", newJString(bearerToken))
  result = call_595137.call(path_595138, query_595139, nil, nil, body_595140)

var containerProjectsLocationsClustersUpdateMaster* = Call_ContainerProjectsLocationsClustersUpdateMaster_595118(
    name: "containerProjectsLocationsClustersUpdateMaster",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:updateMaster",
    validator: validate_ContainerProjectsLocationsClustersUpdateMaster_595119,
    base: "/", url: url_ContainerProjectsLocationsClustersUpdateMaster_595120,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersCreate_595164 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersCreate_595166(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsLocationsClustersCreate_595165(path: JsonNode;
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
  var valid_595167 = path.getOrDefault("parent")
  valid_595167 = validateParameter(valid_595167, JString, required = true,
                                 default = nil)
  if valid_595167 != nil:
    section.add "parent", valid_595167
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
  var valid_595168 = query.getOrDefault("upload_protocol")
  valid_595168 = validateParameter(valid_595168, JString, required = false,
                                 default = nil)
  if valid_595168 != nil:
    section.add "upload_protocol", valid_595168
  var valid_595169 = query.getOrDefault("fields")
  valid_595169 = validateParameter(valid_595169, JString, required = false,
                                 default = nil)
  if valid_595169 != nil:
    section.add "fields", valid_595169
  var valid_595170 = query.getOrDefault("quotaUser")
  valid_595170 = validateParameter(valid_595170, JString, required = false,
                                 default = nil)
  if valid_595170 != nil:
    section.add "quotaUser", valid_595170
  var valid_595171 = query.getOrDefault("alt")
  valid_595171 = validateParameter(valid_595171, JString, required = false,
                                 default = newJString("json"))
  if valid_595171 != nil:
    section.add "alt", valid_595171
  var valid_595172 = query.getOrDefault("pp")
  valid_595172 = validateParameter(valid_595172, JBool, required = false,
                                 default = newJBool(true))
  if valid_595172 != nil:
    section.add "pp", valid_595172
  var valid_595173 = query.getOrDefault("oauth_token")
  valid_595173 = validateParameter(valid_595173, JString, required = false,
                                 default = nil)
  if valid_595173 != nil:
    section.add "oauth_token", valid_595173
  var valid_595174 = query.getOrDefault("callback")
  valid_595174 = validateParameter(valid_595174, JString, required = false,
                                 default = nil)
  if valid_595174 != nil:
    section.add "callback", valid_595174
  var valid_595175 = query.getOrDefault("access_token")
  valid_595175 = validateParameter(valid_595175, JString, required = false,
                                 default = nil)
  if valid_595175 != nil:
    section.add "access_token", valid_595175
  var valid_595176 = query.getOrDefault("uploadType")
  valid_595176 = validateParameter(valid_595176, JString, required = false,
                                 default = nil)
  if valid_595176 != nil:
    section.add "uploadType", valid_595176
  var valid_595177 = query.getOrDefault("key")
  valid_595177 = validateParameter(valid_595177, JString, required = false,
                                 default = nil)
  if valid_595177 != nil:
    section.add "key", valid_595177
  var valid_595178 = query.getOrDefault("$.xgafv")
  valid_595178 = validateParameter(valid_595178, JString, required = false,
                                 default = newJString("1"))
  if valid_595178 != nil:
    section.add "$.xgafv", valid_595178
  var valid_595179 = query.getOrDefault("prettyPrint")
  valid_595179 = validateParameter(valid_595179, JBool, required = false,
                                 default = newJBool(true))
  if valid_595179 != nil:
    section.add "prettyPrint", valid_595179
  var valid_595180 = query.getOrDefault("bearer_token")
  valid_595180 = validateParameter(valid_595180, JString, required = false,
                                 default = nil)
  if valid_595180 != nil:
    section.add "bearer_token", valid_595180
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

proc call*(call_595182: Call_ContainerProjectsLocationsClustersCreate_595164;
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
  let valid = call_595182.validator(path, query, header, formData, body)
  let scheme = call_595182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595182.url(scheme.get, call_595182.host, call_595182.base,
                         call_595182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595182, url, valid)

proc call*(call_595183: Call_ContainerProjectsLocationsClustersCreate_595164;
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
  var path_595184 = newJObject()
  var query_595185 = newJObject()
  var body_595186 = newJObject()
  add(query_595185, "upload_protocol", newJString(uploadProtocol))
  add(query_595185, "fields", newJString(fields))
  add(query_595185, "quotaUser", newJString(quotaUser))
  add(query_595185, "alt", newJString(alt))
  add(query_595185, "pp", newJBool(pp))
  add(query_595185, "oauth_token", newJString(oauthToken))
  add(query_595185, "callback", newJString(callback))
  add(query_595185, "access_token", newJString(accessToken))
  add(query_595185, "uploadType", newJString(uploadType))
  add(path_595184, "parent", newJString(parent))
  add(query_595185, "key", newJString(key))
  add(query_595185, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_595186 = body
  add(query_595185, "prettyPrint", newJBool(prettyPrint))
  add(query_595185, "bearer_token", newJString(bearerToken))
  result = call_595183.call(path_595184, query_595185, nil, nil, body_595186)

var containerProjectsLocationsClustersCreate* = Call_ContainerProjectsLocationsClustersCreate_595164(
    name: "containerProjectsLocationsClustersCreate", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/{parent}/clusters",
    validator: validate_ContainerProjectsLocationsClustersCreate_595165,
    base: "/", url: url_ContainerProjectsLocationsClustersCreate_595166,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersList_595141 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersList_595143(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsLocationsClustersList_595142(path: JsonNode;
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
  var valid_595144 = path.getOrDefault("parent")
  valid_595144 = validateParameter(valid_595144, JString, required = true,
                                 default = nil)
  if valid_595144 != nil:
    section.add "parent", valid_595144
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
  var valid_595145 = query.getOrDefault("upload_protocol")
  valid_595145 = validateParameter(valid_595145, JString, required = false,
                                 default = nil)
  if valid_595145 != nil:
    section.add "upload_protocol", valid_595145
  var valid_595146 = query.getOrDefault("fields")
  valid_595146 = validateParameter(valid_595146, JString, required = false,
                                 default = nil)
  if valid_595146 != nil:
    section.add "fields", valid_595146
  var valid_595147 = query.getOrDefault("quotaUser")
  valid_595147 = validateParameter(valid_595147, JString, required = false,
                                 default = nil)
  if valid_595147 != nil:
    section.add "quotaUser", valid_595147
  var valid_595148 = query.getOrDefault("alt")
  valid_595148 = validateParameter(valid_595148, JString, required = false,
                                 default = newJString("json"))
  if valid_595148 != nil:
    section.add "alt", valid_595148
  var valid_595149 = query.getOrDefault("pp")
  valid_595149 = validateParameter(valid_595149, JBool, required = false,
                                 default = newJBool(true))
  if valid_595149 != nil:
    section.add "pp", valid_595149
  var valid_595150 = query.getOrDefault("oauth_token")
  valid_595150 = validateParameter(valid_595150, JString, required = false,
                                 default = nil)
  if valid_595150 != nil:
    section.add "oauth_token", valid_595150
  var valid_595151 = query.getOrDefault("callback")
  valid_595151 = validateParameter(valid_595151, JString, required = false,
                                 default = nil)
  if valid_595151 != nil:
    section.add "callback", valid_595151
  var valid_595152 = query.getOrDefault("access_token")
  valid_595152 = validateParameter(valid_595152, JString, required = false,
                                 default = nil)
  if valid_595152 != nil:
    section.add "access_token", valid_595152
  var valid_595153 = query.getOrDefault("uploadType")
  valid_595153 = validateParameter(valid_595153, JString, required = false,
                                 default = nil)
  if valid_595153 != nil:
    section.add "uploadType", valid_595153
  var valid_595154 = query.getOrDefault("zone")
  valid_595154 = validateParameter(valid_595154, JString, required = false,
                                 default = nil)
  if valid_595154 != nil:
    section.add "zone", valid_595154
  var valid_595155 = query.getOrDefault("key")
  valid_595155 = validateParameter(valid_595155, JString, required = false,
                                 default = nil)
  if valid_595155 != nil:
    section.add "key", valid_595155
  var valid_595156 = query.getOrDefault("$.xgafv")
  valid_595156 = validateParameter(valid_595156, JString, required = false,
                                 default = newJString("1"))
  if valid_595156 != nil:
    section.add "$.xgafv", valid_595156
  var valid_595157 = query.getOrDefault("projectId")
  valid_595157 = validateParameter(valid_595157, JString, required = false,
                                 default = nil)
  if valid_595157 != nil:
    section.add "projectId", valid_595157
  var valid_595158 = query.getOrDefault("prettyPrint")
  valid_595158 = validateParameter(valid_595158, JBool, required = false,
                                 default = newJBool(true))
  if valid_595158 != nil:
    section.add "prettyPrint", valid_595158
  var valid_595159 = query.getOrDefault("bearer_token")
  valid_595159 = validateParameter(valid_595159, JString, required = false,
                                 default = nil)
  if valid_595159 != nil:
    section.add "bearer_token", valid_595159
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595160: Call_ContainerProjectsLocationsClustersList_595141;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all clusters owned by a project in either the specified zone or all
  ## zones.
  ## 
  let valid = call_595160.validator(path, query, header, formData, body)
  let scheme = call_595160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595160.url(scheme.get, call_595160.host, call_595160.base,
                         call_595160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595160, url, valid)

proc call*(call_595161: Call_ContainerProjectsLocationsClustersList_595141;
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
  var path_595162 = newJObject()
  var query_595163 = newJObject()
  add(query_595163, "upload_protocol", newJString(uploadProtocol))
  add(query_595163, "fields", newJString(fields))
  add(query_595163, "quotaUser", newJString(quotaUser))
  add(query_595163, "alt", newJString(alt))
  add(query_595163, "pp", newJBool(pp))
  add(query_595163, "oauth_token", newJString(oauthToken))
  add(query_595163, "callback", newJString(callback))
  add(query_595163, "access_token", newJString(accessToken))
  add(query_595163, "uploadType", newJString(uploadType))
  add(path_595162, "parent", newJString(parent))
  add(query_595163, "zone", newJString(zone))
  add(query_595163, "key", newJString(key))
  add(query_595163, "$.xgafv", newJString(Xgafv))
  add(query_595163, "projectId", newJString(projectId))
  add(query_595163, "prettyPrint", newJBool(prettyPrint))
  add(query_595163, "bearer_token", newJString(bearerToken))
  result = call_595161.call(path_595162, query_595163, nil, nil, nil)

var containerProjectsLocationsClustersList* = Call_ContainerProjectsLocationsClustersList_595141(
    name: "containerProjectsLocationsClustersList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1beta1/{parent}/clusters",
    validator: validate_ContainerProjectsLocationsClustersList_595142, base: "/",
    url: url_ContainerProjectsLocationsClustersList_595143,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsCreate_595211 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersNodePoolsCreate_595213(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsLocationsClustersNodePoolsCreate_595212(
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
  var valid_595214 = path.getOrDefault("parent")
  valid_595214 = validateParameter(valid_595214, JString, required = true,
                                 default = nil)
  if valid_595214 != nil:
    section.add "parent", valid_595214
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
  var valid_595215 = query.getOrDefault("upload_protocol")
  valid_595215 = validateParameter(valid_595215, JString, required = false,
                                 default = nil)
  if valid_595215 != nil:
    section.add "upload_protocol", valid_595215
  var valid_595216 = query.getOrDefault("fields")
  valid_595216 = validateParameter(valid_595216, JString, required = false,
                                 default = nil)
  if valid_595216 != nil:
    section.add "fields", valid_595216
  var valid_595217 = query.getOrDefault("quotaUser")
  valid_595217 = validateParameter(valid_595217, JString, required = false,
                                 default = nil)
  if valid_595217 != nil:
    section.add "quotaUser", valid_595217
  var valid_595218 = query.getOrDefault("alt")
  valid_595218 = validateParameter(valid_595218, JString, required = false,
                                 default = newJString("json"))
  if valid_595218 != nil:
    section.add "alt", valid_595218
  var valid_595219 = query.getOrDefault("pp")
  valid_595219 = validateParameter(valid_595219, JBool, required = false,
                                 default = newJBool(true))
  if valid_595219 != nil:
    section.add "pp", valid_595219
  var valid_595220 = query.getOrDefault("oauth_token")
  valid_595220 = validateParameter(valid_595220, JString, required = false,
                                 default = nil)
  if valid_595220 != nil:
    section.add "oauth_token", valid_595220
  var valid_595221 = query.getOrDefault("callback")
  valid_595221 = validateParameter(valid_595221, JString, required = false,
                                 default = nil)
  if valid_595221 != nil:
    section.add "callback", valid_595221
  var valid_595222 = query.getOrDefault("access_token")
  valid_595222 = validateParameter(valid_595222, JString, required = false,
                                 default = nil)
  if valid_595222 != nil:
    section.add "access_token", valid_595222
  var valid_595223 = query.getOrDefault("uploadType")
  valid_595223 = validateParameter(valid_595223, JString, required = false,
                                 default = nil)
  if valid_595223 != nil:
    section.add "uploadType", valid_595223
  var valid_595224 = query.getOrDefault("key")
  valid_595224 = validateParameter(valid_595224, JString, required = false,
                                 default = nil)
  if valid_595224 != nil:
    section.add "key", valid_595224
  var valid_595225 = query.getOrDefault("$.xgafv")
  valid_595225 = validateParameter(valid_595225, JString, required = false,
                                 default = newJString("1"))
  if valid_595225 != nil:
    section.add "$.xgafv", valid_595225
  var valid_595226 = query.getOrDefault("prettyPrint")
  valid_595226 = validateParameter(valid_595226, JBool, required = false,
                                 default = newJBool(true))
  if valid_595226 != nil:
    section.add "prettyPrint", valid_595226
  var valid_595227 = query.getOrDefault("bearer_token")
  valid_595227 = validateParameter(valid_595227, JString, required = false,
                                 default = nil)
  if valid_595227 != nil:
    section.add "bearer_token", valid_595227
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

proc call*(call_595229: Call_ContainerProjectsLocationsClustersNodePoolsCreate_595211;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a node pool for a cluster.
  ## 
  let valid = call_595229.validator(path, query, header, formData, body)
  let scheme = call_595229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595229.url(scheme.get, call_595229.host, call_595229.base,
                         call_595229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595229, url, valid)

proc call*(call_595230: Call_ContainerProjectsLocationsClustersNodePoolsCreate_595211;
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
  var path_595231 = newJObject()
  var query_595232 = newJObject()
  var body_595233 = newJObject()
  add(query_595232, "upload_protocol", newJString(uploadProtocol))
  add(query_595232, "fields", newJString(fields))
  add(query_595232, "quotaUser", newJString(quotaUser))
  add(query_595232, "alt", newJString(alt))
  add(query_595232, "pp", newJBool(pp))
  add(query_595232, "oauth_token", newJString(oauthToken))
  add(query_595232, "callback", newJString(callback))
  add(query_595232, "access_token", newJString(accessToken))
  add(query_595232, "uploadType", newJString(uploadType))
  add(path_595231, "parent", newJString(parent))
  add(query_595232, "key", newJString(key))
  add(query_595232, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_595233 = body
  add(query_595232, "prettyPrint", newJBool(prettyPrint))
  add(query_595232, "bearer_token", newJString(bearerToken))
  result = call_595230.call(path_595231, query_595232, nil, nil, body_595233)

var containerProjectsLocationsClustersNodePoolsCreate* = Call_ContainerProjectsLocationsClustersNodePoolsCreate_595211(
    name: "containerProjectsLocationsClustersNodePoolsCreate",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{parent}/nodePools",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsCreate_595212,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsCreate_595213,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsList_595187 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersNodePoolsList_595189(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsLocationsClustersNodePoolsList_595188(
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
  var valid_595190 = path.getOrDefault("parent")
  valid_595190 = validateParameter(valid_595190, JString, required = true,
                                 default = nil)
  if valid_595190 != nil:
    section.add "parent", valid_595190
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
  var valid_595191 = query.getOrDefault("upload_protocol")
  valid_595191 = validateParameter(valid_595191, JString, required = false,
                                 default = nil)
  if valid_595191 != nil:
    section.add "upload_protocol", valid_595191
  var valid_595192 = query.getOrDefault("fields")
  valid_595192 = validateParameter(valid_595192, JString, required = false,
                                 default = nil)
  if valid_595192 != nil:
    section.add "fields", valid_595192
  var valid_595193 = query.getOrDefault("quotaUser")
  valid_595193 = validateParameter(valid_595193, JString, required = false,
                                 default = nil)
  if valid_595193 != nil:
    section.add "quotaUser", valid_595193
  var valid_595194 = query.getOrDefault("alt")
  valid_595194 = validateParameter(valid_595194, JString, required = false,
                                 default = newJString("json"))
  if valid_595194 != nil:
    section.add "alt", valid_595194
  var valid_595195 = query.getOrDefault("pp")
  valid_595195 = validateParameter(valid_595195, JBool, required = false,
                                 default = newJBool(true))
  if valid_595195 != nil:
    section.add "pp", valid_595195
  var valid_595196 = query.getOrDefault("oauth_token")
  valid_595196 = validateParameter(valid_595196, JString, required = false,
                                 default = nil)
  if valid_595196 != nil:
    section.add "oauth_token", valid_595196
  var valid_595197 = query.getOrDefault("callback")
  valid_595197 = validateParameter(valid_595197, JString, required = false,
                                 default = nil)
  if valid_595197 != nil:
    section.add "callback", valid_595197
  var valid_595198 = query.getOrDefault("access_token")
  valid_595198 = validateParameter(valid_595198, JString, required = false,
                                 default = nil)
  if valid_595198 != nil:
    section.add "access_token", valid_595198
  var valid_595199 = query.getOrDefault("uploadType")
  valid_595199 = validateParameter(valid_595199, JString, required = false,
                                 default = nil)
  if valid_595199 != nil:
    section.add "uploadType", valid_595199
  var valid_595200 = query.getOrDefault("zone")
  valid_595200 = validateParameter(valid_595200, JString, required = false,
                                 default = nil)
  if valid_595200 != nil:
    section.add "zone", valid_595200
  var valid_595201 = query.getOrDefault("key")
  valid_595201 = validateParameter(valid_595201, JString, required = false,
                                 default = nil)
  if valid_595201 != nil:
    section.add "key", valid_595201
  var valid_595202 = query.getOrDefault("$.xgafv")
  valid_595202 = validateParameter(valid_595202, JString, required = false,
                                 default = newJString("1"))
  if valid_595202 != nil:
    section.add "$.xgafv", valid_595202
  var valid_595203 = query.getOrDefault("projectId")
  valid_595203 = validateParameter(valid_595203, JString, required = false,
                                 default = nil)
  if valid_595203 != nil:
    section.add "projectId", valid_595203
  var valid_595204 = query.getOrDefault("prettyPrint")
  valid_595204 = validateParameter(valid_595204, JBool, required = false,
                                 default = newJBool(true))
  if valid_595204 != nil:
    section.add "prettyPrint", valid_595204
  var valid_595205 = query.getOrDefault("clusterId")
  valid_595205 = validateParameter(valid_595205, JString, required = false,
                                 default = nil)
  if valid_595205 != nil:
    section.add "clusterId", valid_595205
  var valid_595206 = query.getOrDefault("bearer_token")
  valid_595206 = validateParameter(valid_595206, JString, required = false,
                                 default = nil)
  if valid_595206 != nil:
    section.add "bearer_token", valid_595206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595207: Call_ContainerProjectsLocationsClustersNodePoolsList_595187;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the node pools for a cluster.
  ## 
  let valid = call_595207.validator(path, query, header, formData, body)
  let scheme = call_595207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595207.url(scheme.get, call_595207.host, call_595207.base,
                         call_595207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595207, url, valid)

proc call*(call_595208: Call_ContainerProjectsLocationsClustersNodePoolsList_595187;
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
  var path_595209 = newJObject()
  var query_595210 = newJObject()
  add(query_595210, "upload_protocol", newJString(uploadProtocol))
  add(query_595210, "fields", newJString(fields))
  add(query_595210, "quotaUser", newJString(quotaUser))
  add(query_595210, "alt", newJString(alt))
  add(query_595210, "pp", newJBool(pp))
  add(query_595210, "oauth_token", newJString(oauthToken))
  add(query_595210, "callback", newJString(callback))
  add(query_595210, "access_token", newJString(accessToken))
  add(query_595210, "uploadType", newJString(uploadType))
  add(path_595209, "parent", newJString(parent))
  add(query_595210, "zone", newJString(zone))
  add(query_595210, "key", newJString(key))
  add(query_595210, "$.xgafv", newJString(Xgafv))
  add(query_595210, "projectId", newJString(projectId))
  add(query_595210, "prettyPrint", newJBool(prettyPrint))
  add(query_595210, "clusterId", newJString(clusterId))
  add(query_595210, "bearer_token", newJString(bearerToken))
  result = call_595208.call(path_595209, query_595210, nil, nil, nil)

var containerProjectsLocationsClustersNodePoolsList* = Call_ContainerProjectsLocationsClustersNodePoolsList_595187(
    name: "containerProjectsLocationsClustersNodePoolsList",
    meth: HttpMethod.HttpGet, host: "container.googleapis.com",
    route: "/v1beta1/{parent}/nodePools",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsList_595188,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsList_595189,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsOperationsList_595234 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsOperationsList_595236(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ContainerProjectsLocationsOperationsList_595235(path: JsonNode;
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
  var valid_595237 = path.getOrDefault("parent")
  valid_595237 = validateParameter(valid_595237, JString, required = true,
                                 default = nil)
  if valid_595237 != nil:
    section.add "parent", valid_595237
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
  var valid_595238 = query.getOrDefault("upload_protocol")
  valid_595238 = validateParameter(valid_595238, JString, required = false,
                                 default = nil)
  if valid_595238 != nil:
    section.add "upload_protocol", valid_595238
  var valid_595239 = query.getOrDefault("fields")
  valid_595239 = validateParameter(valid_595239, JString, required = false,
                                 default = nil)
  if valid_595239 != nil:
    section.add "fields", valid_595239
  var valid_595240 = query.getOrDefault("quotaUser")
  valid_595240 = validateParameter(valid_595240, JString, required = false,
                                 default = nil)
  if valid_595240 != nil:
    section.add "quotaUser", valid_595240
  var valid_595241 = query.getOrDefault("alt")
  valid_595241 = validateParameter(valid_595241, JString, required = false,
                                 default = newJString("json"))
  if valid_595241 != nil:
    section.add "alt", valid_595241
  var valid_595242 = query.getOrDefault("pp")
  valid_595242 = validateParameter(valid_595242, JBool, required = false,
                                 default = newJBool(true))
  if valid_595242 != nil:
    section.add "pp", valid_595242
  var valid_595243 = query.getOrDefault("oauth_token")
  valid_595243 = validateParameter(valid_595243, JString, required = false,
                                 default = nil)
  if valid_595243 != nil:
    section.add "oauth_token", valid_595243
  var valid_595244 = query.getOrDefault("callback")
  valid_595244 = validateParameter(valid_595244, JString, required = false,
                                 default = nil)
  if valid_595244 != nil:
    section.add "callback", valid_595244
  var valid_595245 = query.getOrDefault("access_token")
  valid_595245 = validateParameter(valid_595245, JString, required = false,
                                 default = nil)
  if valid_595245 != nil:
    section.add "access_token", valid_595245
  var valid_595246 = query.getOrDefault("uploadType")
  valid_595246 = validateParameter(valid_595246, JString, required = false,
                                 default = nil)
  if valid_595246 != nil:
    section.add "uploadType", valid_595246
  var valid_595247 = query.getOrDefault("zone")
  valid_595247 = validateParameter(valid_595247, JString, required = false,
                                 default = nil)
  if valid_595247 != nil:
    section.add "zone", valid_595247
  var valid_595248 = query.getOrDefault("key")
  valid_595248 = validateParameter(valid_595248, JString, required = false,
                                 default = nil)
  if valid_595248 != nil:
    section.add "key", valid_595248
  var valid_595249 = query.getOrDefault("$.xgafv")
  valid_595249 = validateParameter(valid_595249, JString, required = false,
                                 default = newJString("1"))
  if valid_595249 != nil:
    section.add "$.xgafv", valid_595249
  var valid_595250 = query.getOrDefault("projectId")
  valid_595250 = validateParameter(valid_595250, JString, required = false,
                                 default = nil)
  if valid_595250 != nil:
    section.add "projectId", valid_595250
  var valid_595251 = query.getOrDefault("prettyPrint")
  valid_595251 = validateParameter(valid_595251, JBool, required = false,
                                 default = newJBool(true))
  if valid_595251 != nil:
    section.add "prettyPrint", valid_595251
  var valid_595252 = query.getOrDefault("bearer_token")
  valid_595252 = validateParameter(valid_595252, JString, required = false,
                                 default = nil)
  if valid_595252 != nil:
    section.add "bearer_token", valid_595252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595253: Call_ContainerProjectsLocationsOperationsList_595234;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all operations in a project in a specific zone or all zones.
  ## 
  let valid = call_595253.validator(path, query, header, formData, body)
  let scheme = call_595253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595253.url(scheme.get, call_595253.host, call_595253.base,
                         call_595253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595253, url, valid)

proc call*(call_595254: Call_ContainerProjectsLocationsOperationsList_595234;
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
  var path_595255 = newJObject()
  var query_595256 = newJObject()
  add(query_595256, "upload_protocol", newJString(uploadProtocol))
  add(query_595256, "fields", newJString(fields))
  add(query_595256, "quotaUser", newJString(quotaUser))
  add(query_595256, "alt", newJString(alt))
  add(query_595256, "pp", newJBool(pp))
  add(query_595256, "oauth_token", newJString(oauthToken))
  add(query_595256, "callback", newJString(callback))
  add(query_595256, "access_token", newJString(accessToken))
  add(query_595256, "uploadType", newJString(uploadType))
  add(path_595255, "parent", newJString(parent))
  add(query_595256, "zone", newJString(zone))
  add(query_595256, "key", newJString(key))
  add(query_595256, "$.xgafv", newJString(Xgafv))
  add(query_595256, "projectId", newJString(projectId))
  add(query_595256, "prettyPrint", newJBool(prettyPrint))
  add(query_595256, "bearer_token", newJString(bearerToken))
  result = call_595254.call(path_595255, query_595256, nil, nil, nil)

var containerProjectsLocationsOperationsList* = Call_ContainerProjectsLocationsOperationsList_595234(
    name: "containerProjectsLocationsOperationsList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1beta1/{parent}/operations",
    validator: validate_ContainerProjectsLocationsOperationsList_595235,
    base: "/", url: url_ContainerProjectsLocationsOperationsList_595236,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
