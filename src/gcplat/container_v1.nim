
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Kubernetes Engine
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Builds and manages container-based applications, powered by the open source Kubernetes technology.
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
  Call_ContainerProjectsZonesClustersCreate_593980 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersCreate_593982(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersCreate_593981(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a cluster, consisting of the specified number and type of Google
  ## Compute Engine instances.
  ## 
  ## By default, the cluster is created in the project's
  ## [default network](/compute/docs/networks-and-firewalls#networks).
  ## 
  ## One firewall is added for the cluster. After cluster creation,
  ## the Kubelet creates routes for each node to allow the containers
  ## on that node to communicate with all other instances in the
  ## cluster.
  ## 
  ## Finally, an entry is added to the project's global metadata indicating
  ## which CIDR range the cluster is using.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the parent field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the parent field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_593983 = path.getOrDefault("zone")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "zone", valid_593983
  var valid_593984 = path.getOrDefault("projectId")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "projectId", valid_593984
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
  section = newJObject()
  var valid_593985 = query.getOrDefault("upload_protocol")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = nil)
  if valid_593985 != nil:
    section.add "upload_protocol", valid_593985
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
  var valid_593990 = query.getOrDefault("callback")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "callback", valid_593990
  var valid_593991 = query.getOrDefault("access_token")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = nil)
  if valid_593991 != nil:
    section.add "access_token", valid_593991
  var valid_593992 = query.getOrDefault("uploadType")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "uploadType", valid_593992
  var valid_593993 = query.getOrDefault("key")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = nil)
  if valid_593993 != nil:
    section.add "key", valid_593993
  var valid_593994 = query.getOrDefault("$.xgafv")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = newJString("1"))
  if valid_593994 != nil:
    section.add "$.xgafv", valid_593994
  var valid_593995 = query.getOrDefault("prettyPrint")
  valid_593995 = validateParameter(valid_593995, JBool, required = false,
                                 default = newJBool(true))
  if valid_593995 != nil:
    section.add "prettyPrint", valid_593995
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

proc call*(call_593997: Call_ContainerProjectsZonesClustersCreate_593980;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a cluster, consisting of the specified number and type of Google
  ## Compute Engine instances.
  ## 
  ## By default, the cluster is created in the project's
  ## [default network](/compute/docs/networks-and-firewalls#networks).
  ## 
  ## One firewall is added for the cluster. After cluster creation,
  ## the Kubelet creates routes for each node to allow the containers
  ## on that node to communicate with all other instances in the
  ## cluster.
  ## 
  ## Finally, an entry is added to the project's global metadata indicating
  ## which CIDR range the cluster is using.
  ## 
  let valid = call_593997.validator(path, query, header, formData, body)
  let scheme = call_593997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593997.url(scheme.get, call_593997.host, call_593997.base,
                         call_593997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593997, url, valid)

proc call*(call_593998: Call_ContainerProjectsZonesClustersCreate_593980;
          zone: string; projectId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersCreate
  ## Creates a cluster, consisting of the specified number and type of Google
  ## Compute Engine instances.
  ## 
  ## By default, the cluster is created in the project's
  ## [default network](/compute/docs/networks-and-firewalls#networks).
  ## 
  ## One firewall is added for the cluster. After cluster creation,
  ## the Kubelet creates routes for each node to allow the containers
  ## on that node to communicate with all other instances in the
  ## cluster.
  ## 
  ## Finally, an entry is added to the project's global metadata indicating
  ## which CIDR range the cluster is using.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the parent field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the parent field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_593999 = newJObject()
  var query_594000 = newJObject()
  var body_594001 = newJObject()
  add(query_594000, "upload_protocol", newJString(uploadProtocol))
  add(path_593999, "zone", newJString(zone))
  add(query_594000, "fields", newJString(fields))
  add(query_594000, "quotaUser", newJString(quotaUser))
  add(query_594000, "alt", newJString(alt))
  add(query_594000, "oauth_token", newJString(oauthToken))
  add(query_594000, "callback", newJString(callback))
  add(query_594000, "access_token", newJString(accessToken))
  add(query_594000, "uploadType", newJString(uploadType))
  add(query_594000, "key", newJString(key))
  add(path_593999, "projectId", newJString(projectId))
  add(query_594000, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594001 = body
  add(query_594000, "prettyPrint", newJBool(prettyPrint))
  result = call_593998.call(path_593999, query_594000, nil, nil, body_594001)

var containerProjectsZonesClustersCreate* = Call_ContainerProjectsZonesClustersCreate_593980(
    name: "containerProjectsZonesClustersCreate", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/clusters",
    validator: validate_ContainerProjectsZonesClustersCreate_593981, base: "/",
    url: url_ContainerProjectsZonesClustersCreate_593982, schemes: {Scheme.Https})
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
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides, or "-" for all zones.
  ## This field has been deprecated and replaced by the parent field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the parent field.
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
  var valid_593837 = query.getOrDefault("oauth_token")
  valid_593837 = validateParameter(valid_593837, JString, required = false,
                                 default = nil)
  if valid_593837 != nil:
    section.add "oauth_token", valid_593837
  var valid_593838 = query.getOrDefault("callback")
  valid_593838 = validateParameter(valid_593838, JString, required = false,
                                 default = nil)
  if valid_593838 != nil:
    section.add "callback", valid_593838
  var valid_593839 = query.getOrDefault("access_token")
  valid_593839 = validateParameter(valid_593839, JString, required = false,
                                 default = nil)
  if valid_593839 != nil:
    section.add "access_token", valid_593839
  var valid_593840 = query.getOrDefault("uploadType")
  valid_593840 = validateParameter(valid_593840, JString, required = false,
                                 default = nil)
  if valid_593840 != nil:
    section.add "uploadType", valid_593840
  var valid_593841 = query.getOrDefault("parent")
  valid_593841 = validateParameter(valid_593841, JString, required = false,
                                 default = nil)
  if valid_593841 != nil:
    section.add "parent", valid_593841
  var valid_593842 = query.getOrDefault("key")
  valid_593842 = validateParameter(valid_593842, JString, required = false,
                                 default = nil)
  if valid_593842 != nil:
    section.add "key", valid_593842
  var valid_593843 = query.getOrDefault("$.xgafv")
  valid_593843 = validateParameter(valid_593843, JString, required = false,
                                 default = newJString("1"))
  if valid_593843 != nil:
    section.add "$.xgafv", valid_593843
  var valid_593844 = query.getOrDefault("prettyPrint")
  valid_593844 = validateParameter(valid_593844, JBool, required = false,
                                 default = newJBool(true))
  if valid_593844 != nil:
    section.add "prettyPrint", valid_593844
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593867: Call_ContainerProjectsZonesClustersList_593690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all clusters owned by a project in either the specified zone or all
  ## zones.
  ## 
  let valid = call_593867.validator(path, query, header, formData, body)
  let scheme = call_593867.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593867.url(scheme.get, call_593867.host, call_593867.base,
                         call_593867.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593867, url, valid)

proc call*(call_593938: Call_ContainerProjectsZonesClustersList_593690;
          zone: string; projectId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; parent: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersList
  ## Lists all clusters owned by a project in either the specified zone or all
  ## zones.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides, or "-" for all zones.
  ## This field has been deprecated and replaced by the parent field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the parent field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_593939 = newJObject()
  var query_593941 = newJObject()
  add(query_593941, "upload_protocol", newJString(uploadProtocol))
  add(path_593939, "zone", newJString(zone))
  add(query_593941, "fields", newJString(fields))
  add(query_593941, "quotaUser", newJString(quotaUser))
  add(query_593941, "alt", newJString(alt))
  add(query_593941, "oauth_token", newJString(oauthToken))
  add(query_593941, "callback", newJString(callback))
  add(query_593941, "access_token", newJString(accessToken))
  add(query_593941, "uploadType", newJString(uploadType))
  add(query_593941, "parent", newJString(parent))
  add(query_593941, "key", newJString(key))
  add(path_593939, "projectId", newJString(projectId))
  add(query_593941, "$.xgafv", newJString(Xgafv))
  add(query_593941, "prettyPrint", newJBool(prettyPrint))
  result = call_593938.call(path_593939, query_593941, nil, nil, nil)

var containerProjectsZonesClustersList* = Call_ContainerProjectsZonesClustersList_593690(
    name: "containerProjectsZonesClustersList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/clusters",
    validator: validate_ContainerProjectsZonesClustersList_593691, base: "/",
    url: url_ContainerProjectsZonesClustersList_593692, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersUpdate_594024 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersUpdate_594026(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersUpdate_594025(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the settings of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594027 = path.getOrDefault("zone")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "zone", valid_594027
  var valid_594028 = path.getOrDefault("projectId")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "projectId", valid_594028
  var valid_594029 = path.getOrDefault("clusterId")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "clusterId", valid_594029
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
  section = newJObject()
  var valid_594030 = query.getOrDefault("upload_protocol")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "upload_protocol", valid_594030
  var valid_594031 = query.getOrDefault("fields")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "fields", valid_594031
  var valid_594032 = query.getOrDefault("quotaUser")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "quotaUser", valid_594032
  var valid_594033 = query.getOrDefault("alt")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = newJString("json"))
  if valid_594033 != nil:
    section.add "alt", valid_594033
  var valid_594034 = query.getOrDefault("oauth_token")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = nil)
  if valid_594034 != nil:
    section.add "oauth_token", valid_594034
  var valid_594035 = query.getOrDefault("callback")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = nil)
  if valid_594035 != nil:
    section.add "callback", valid_594035
  var valid_594036 = query.getOrDefault("access_token")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = nil)
  if valid_594036 != nil:
    section.add "access_token", valid_594036
  var valid_594037 = query.getOrDefault("uploadType")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = nil)
  if valid_594037 != nil:
    section.add "uploadType", valid_594037
  var valid_594038 = query.getOrDefault("key")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "key", valid_594038
  var valid_594039 = query.getOrDefault("$.xgafv")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = newJString("1"))
  if valid_594039 != nil:
    section.add "$.xgafv", valid_594039
  var valid_594040 = query.getOrDefault("prettyPrint")
  valid_594040 = validateParameter(valid_594040, JBool, required = false,
                                 default = newJBool(true))
  if valid_594040 != nil:
    section.add "prettyPrint", valid_594040
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

proc call*(call_594042: Call_ContainerProjectsZonesClustersUpdate_594024;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the settings of a specific cluster.
  ## 
  let valid = call_594042.validator(path, query, header, formData, body)
  let scheme = call_594042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594042.url(scheme.get, call_594042.host, call_594042.base,
                         call_594042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594042, url, valid)

proc call*(call_594043: Call_ContainerProjectsZonesClustersUpdate_594024;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersUpdate
  ## Updates the settings of a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  var path_594044 = newJObject()
  var query_594045 = newJObject()
  var body_594046 = newJObject()
  add(query_594045, "upload_protocol", newJString(uploadProtocol))
  add(path_594044, "zone", newJString(zone))
  add(query_594045, "fields", newJString(fields))
  add(query_594045, "quotaUser", newJString(quotaUser))
  add(query_594045, "alt", newJString(alt))
  add(query_594045, "oauth_token", newJString(oauthToken))
  add(query_594045, "callback", newJString(callback))
  add(query_594045, "access_token", newJString(accessToken))
  add(query_594045, "uploadType", newJString(uploadType))
  add(query_594045, "key", newJString(key))
  add(path_594044, "projectId", newJString(projectId))
  add(query_594045, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594046 = body
  add(query_594045, "prettyPrint", newJBool(prettyPrint))
  add(path_594044, "clusterId", newJString(clusterId))
  result = call_594043.call(path_594044, query_594045, nil, nil, body_594046)

var containerProjectsZonesClustersUpdate* = Call_ContainerProjectsZonesClustersUpdate_594024(
    name: "containerProjectsZonesClustersUpdate", meth: HttpMethod.HttpPut,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}",
    validator: validate_ContainerProjectsZonesClustersUpdate_594025, base: "/",
    url: url_ContainerProjectsZonesClustersUpdate_594026, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersGet_594002 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersGet_594004(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersGet_594003(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to retrieve.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594005 = path.getOrDefault("zone")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "zone", valid_594005
  var valid_594006 = path.getOrDefault("projectId")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "projectId", valid_594006
  var valid_594007 = path.getOrDefault("clusterId")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "clusterId", valid_594007
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
  section = newJObject()
  var valid_594008 = query.getOrDefault("upload_protocol")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "upload_protocol", valid_594008
  var valid_594009 = query.getOrDefault("fields")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "fields", valid_594009
  var valid_594010 = query.getOrDefault("quotaUser")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "quotaUser", valid_594010
  var valid_594011 = query.getOrDefault("alt")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = newJString("json"))
  if valid_594011 != nil:
    section.add "alt", valid_594011
  var valid_594012 = query.getOrDefault("oauth_token")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "oauth_token", valid_594012
  var valid_594013 = query.getOrDefault("callback")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "callback", valid_594013
  var valid_594014 = query.getOrDefault("access_token")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "access_token", valid_594014
  var valid_594015 = query.getOrDefault("uploadType")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "uploadType", valid_594015
  var valid_594016 = query.getOrDefault("key")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "key", valid_594016
  var valid_594017 = query.getOrDefault("name")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "name", valid_594017
  var valid_594018 = query.getOrDefault("$.xgafv")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = newJString("1"))
  if valid_594018 != nil:
    section.add "$.xgafv", valid_594018
  var valid_594019 = query.getOrDefault("prettyPrint")
  valid_594019 = validateParameter(valid_594019, JBool, required = false,
                                 default = newJBool(true))
  if valid_594019 != nil:
    section.add "prettyPrint", valid_594019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594020: Call_ContainerProjectsZonesClustersGet_594002;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of a specific cluster.
  ## 
  let valid = call_594020.validator(path, query, header, formData, body)
  let scheme = call_594020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594020.url(scheme.get, call_594020.host, call_594020.base,
                         call_594020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594020, url, valid)

proc call*(call_594021: Call_ContainerProjectsZonesClustersGet_594002;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          name: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersGet
  ## Gets the details of a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to retrieve.
  ## This field has been deprecated and replaced by the name field.
  var path_594022 = newJObject()
  var query_594023 = newJObject()
  add(query_594023, "upload_protocol", newJString(uploadProtocol))
  add(path_594022, "zone", newJString(zone))
  add(query_594023, "fields", newJString(fields))
  add(query_594023, "quotaUser", newJString(quotaUser))
  add(query_594023, "alt", newJString(alt))
  add(query_594023, "oauth_token", newJString(oauthToken))
  add(query_594023, "callback", newJString(callback))
  add(query_594023, "access_token", newJString(accessToken))
  add(query_594023, "uploadType", newJString(uploadType))
  add(query_594023, "key", newJString(key))
  add(query_594023, "name", newJString(name))
  add(path_594022, "projectId", newJString(projectId))
  add(query_594023, "$.xgafv", newJString(Xgafv))
  add(query_594023, "prettyPrint", newJBool(prettyPrint))
  add(path_594022, "clusterId", newJString(clusterId))
  result = call_594021.call(path_594022, query_594023, nil, nil, nil)

var containerProjectsZonesClustersGet* = Call_ContainerProjectsZonesClustersGet_594002(
    name: "containerProjectsZonesClustersGet", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}",
    validator: validate_ContainerProjectsZonesClustersGet_594003, base: "/",
    url: url_ContainerProjectsZonesClustersGet_594004, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersDelete_594047 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersDelete_594049(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersDelete_594048(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the cluster, including the Kubernetes endpoint and all worker
  ## nodes.
  ## 
  ## Firewalls and routes that were configured during cluster creation
  ## are also deleted.
  ## 
  ## Other Google Compute Engine resources that might be in use by the cluster,
  ## such as load balancer resources, are not deleted if they weren't present
  ## when the cluster was initially created.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to delete.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594050 = path.getOrDefault("zone")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "zone", valid_594050
  var valid_594051 = path.getOrDefault("projectId")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "projectId", valid_594051
  var valid_594052 = path.getOrDefault("clusterId")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "clusterId", valid_594052
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
  section = newJObject()
  var valid_594053 = query.getOrDefault("upload_protocol")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = nil)
  if valid_594053 != nil:
    section.add "upload_protocol", valid_594053
  var valid_594054 = query.getOrDefault("fields")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "fields", valid_594054
  var valid_594055 = query.getOrDefault("quotaUser")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "quotaUser", valid_594055
  var valid_594056 = query.getOrDefault("alt")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = newJString("json"))
  if valid_594056 != nil:
    section.add "alt", valid_594056
  var valid_594057 = query.getOrDefault("oauth_token")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "oauth_token", valid_594057
  var valid_594058 = query.getOrDefault("callback")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "callback", valid_594058
  var valid_594059 = query.getOrDefault("access_token")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = nil)
  if valid_594059 != nil:
    section.add "access_token", valid_594059
  var valid_594060 = query.getOrDefault("uploadType")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "uploadType", valid_594060
  var valid_594061 = query.getOrDefault("key")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "key", valid_594061
  var valid_594062 = query.getOrDefault("name")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "name", valid_594062
  var valid_594063 = query.getOrDefault("$.xgafv")
  valid_594063 = validateParameter(valid_594063, JString, required = false,
                                 default = newJString("1"))
  if valid_594063 != nil:
    section.add "$.xgafv", valid_594063
  var valid_594064 = query.getOrDefault("prettyPrint")
  valid_594064 = validateParameter(valid_594064, JBool, required = false,
                                 default = newJBool(true))
  if valid_594064 != nil:
    section.add "prettyPrint", valid_594064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594065: Call_ContainerProjectsZonesClustersDelete_594047;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the cluster, including the Kubernetes endpoint and all worker
  ## nodes.
  ## 
  ## Firewalls and routes that were configured during cluster creation
  ## are also deleted.
  ## 
  ## Other Google Compute Engine resources that might be in use by the cluster,
  ## such as load balancer resources, are not deleted if they weren't present
  ## when the cluster was initially created.
  ## 
  let valid = call_594065.validator(path, query, header, formData, body)
  let scheme = call_594065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594065.url(scheme.get, call_594065.host, call_594065.base,
                         call_594065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594065, url, valid)

proc call*(call_594066: Call_ContainerProjectsZonesClustersDelete_594047;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          name: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersDelete
  ## Deletes the cluster, including the Kubernetes endpoint and all worker
  ## nodes.
  ## 
  ## Firewalls and routes that were configured during cluster creation
  ## are also deleted.
  ## 
  ## Other Google Compute Engine resources that might be in use by the cluster,
  ## such as load balancer resources, are not deleted if they weren't present
  ## when the cluster was initially created.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to delete.
  ## This field has been deprecated and replaced by the name field.
  var path_594067 = newJObject()
  var query_594068 = newJObject()
  add(query_594068, "upload_protocol", newJString(uploadProtocol))
  add(path_594067, "zone", newJString(zone))
  add(query_594068, "fields", newJString(fields))
  add(query_594068, "quotaUser", newJString(quotaUser))
  add(query_594068, "alt", newJString(alt))
  add(query_594068, "oauth_token", newJString(oauthToken))
  add(query_594068, "callback", newJString(callback))
  add(query_594068, "access_token", newJString(accessToken))
  add(query_594068, "uploadType", newJString(uploadType))
  add(query_594068, "key", newJString(key))
  add(query_594068, "name", newJString(name))
  add(path_594067, "projectId", newJString(projectId))
  add(query_594068, "$.xgafv", newJString(Xgafv))
  add(query_594068, "prettyPrint", newJBool(prettyPrint))
  add(path_594067, "clusterId", newJString(clusterId))
  result = call_594066.call(path_594067, query_594068, nil, nil, nil)

var containerProjectsZonesClustersDelete* = Call_ContainerProjectsZonesClustersDelete_594047(
    name: "containerProjectsZonesClustersDelete", meth: HttpMethod.HttpDelete,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}",
    validator: validate_ContainerProjectsZonesClustersDelete_594048, base: "/",
    url: url_ContainerProjectsZonesClustersDelete_594049, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersAddons_594069 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersAddons_594071(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersAddons_594070(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the addons for a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594072 = path.getOrDefault("zone")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "zone", valid_594072
  var valid_594073 = path.getOrDefault("projectId")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "projectId", valid_594073
  var valid_594074 = path.getOrDefault("clusterId")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "clusterId", valid_594074
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
  section = newJObject()
  var valid_594075 = query.getOrDefault("upload_protocol")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = nil)
  if valid_594075 != nil:
    section.add "upload_protocol", valid_594075
  var valid_594076 = query.getOrDefault("fields")
  valid_594076 = validateParameter(valid_594076, JString, required = false,
                                 default = nil)
  if valid_594076 != nil:
    section.add "fields", valid_594076
  var valid_594077 = query.getOrDefault("quotaUser")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = nil)
  if valid_594077 != nil:
    section.add "quotaUser", valid_594077
  var valid_594078 = query.getOrDefault("alt")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = newJString("json"))
  if valid_594078 != nil:
    section.add "alt", valid_594078
  var valid_594079 = query.getOrDefault("oauth_token")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = nil)
  if valid_594079 != nil:
    section.add "oauth_token", valid_594079
  var valid_594080 = query.getOrDefault("callback")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = nil)
  if valid_594080 != nil:
    section.add "callback", valid_594080
  var valid_594081 = query.getOrDefault("access_token")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = nil)
  if valid_594081 != nil:
    section.add "access_token", valid_594081
  var valid_594082 = query.getOrDefault("uploadType")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = nil)
  if valid_594082 != nil:
    section.add "uploadType", valid_594082
  var valid_594083 = query.getOrDefault("key")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = nil)
  if valid_594083 != nil:
    section.add "key", valid_594083
  var valid_594084 = query.getOrDefault("$.xgafv")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = newJString("1"))
  if valid_594084 != nil:
    section.add "$.xgafv", valid_594084
  var valid_594085 = query.getOrDefault("prettyPrint")
  valid_594085 = validateParameter(valid_594085, JBool, required = false,
                                 default = newJBool(true))
  if valid_594085 != nil:
    section.add "prettyPrint", valid_594085
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

proc call*(call_594087: Call_ContainerProjectsZonesClustersAddons_594069;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the addons for a specific cluster.
  ## 
  let valid = call_594087.validator(path, query, header, formData, body)
  let scheme = call_594087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594087.url(scheme.get, call_594087.host, call_594087.base,
                         call_594087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594087, url, valid)

proc call*(call_594088: Call_ContainerProjectsZonesClustersAddons_594069;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersAddons
  ## Sets the addons for a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  var path_594089 = newJObject()
  var query_594090 = newJObject()
  var body_594091 = newJObject()
  add(query_594090, "upload_protocol", newJString(uploadProtocol))
  add(path_594089, "zone", newJString(zone))
  add(query_594090, "fields", newJString(fields))
  add(query_594090, "quotaUser", newJString(quotaUser))
  add(query_594090, "alt", newJString(alt))
  add(query_594090, "oauth_token", newJString(oauthToken))
  add(query_594090, "callback", newJString(callback))
  add(query_594090, "access_token", newJString(accessToken))
  add(query_594090, "uploadType", newJString(uploadType))
  add(query_594090, "key", newJString(key))
  add(path_594089, "projectId", newJString(projectId))
  add(query_594090, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594091 = body
  add(query_594090, "prettyPrint", newJBool(prettyPrint))
  add(path_594089, "clusterId", newJString(clusterId))
  result = call_594088.call(path_594089, query_594090, nil, nil, body_594091)

var containerProjectsZonesClustersAddons* = Call_ContainerProjectsZonesClustersAddons_594069(
    name: "containerProjectsZonesClustersAddons", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/addons",
    validator: validate_ContainerProjectsZonesClustersAddons_594070, base: "/",
    url: url_ContainerProjectsZonesClustersAddons_594071, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersLegacyAbac_594092 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersLegacyAbac_594094(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersLegacyAbac_594093(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to update.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594095 = path.getOrDefault("zone")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "zone", valid_594095
  var valid_594096 = path.getOrDefault("projectId")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "projectId", valid_594096
  var valid_594097 = path.getOrDefault("clusterId")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "clusterId", valid_594097
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
  section = newJObject()
  var valid_594098 = query.getOrDefault("upload_protocol")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "upload_protocol", valid_594098
  var valid_594099 = query.getOrDefault("fields")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "fields", valid_594099
  var valid_594100 = query.getOrDefault("quotaUser")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = nil)
  if valid_594100 != nil:
    section.add "quotaUser", valid_594100
  var valid_594101 = query.getOrDefault("alt")
  valid_594101 = validateParameter(valid_594101, JString, required = false,
                                 default = newJString("json"))
  if valid_594101 != nil:
    section.add "alt", valid_594101
  var valid_594102 = query.getOrDefault("oauth_token")
  valid_594102 = validateParameter(valid_594102, JString, required = false,
                                 default = nil)
  if valid_594102 != nil:
    section.add "oauth_token", valid_594102
  var valid_594103 = query.getOrDefault("callback")
  valid_594103 = validateParameter(valid_594103, JString, required = false,
                                 default = nil)
  if valid_594103 != nil:
    section.add "callback", valid_594103
  var valid_594104 = query.getOrDefault("access_token")
  valid_594104 = validateParameter(valid_594104, JString, required = false,
                                 default = nil)
  if valid_594104 != nil:
    section.add "access_token", valid_594104
  var valid_594105 = query.getOrDefault("uploadType")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = nil)
  if valid_594105 != nil:
    section.add "uploadType", valid_594105
  var valid_594106 = query.getOrDefault("key")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = nil)
  if valid_594106 != nil:
    section.add "key", valid_594106
  var valid_594107 = query.getOrDefault("$.xgafv")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = newJString("1"))
  if valid_594107 != nil:
    section.add "$.xgafv", valid_594107
  var valid_594108 = query.getOrDefault("prettyPrint")
  valid_594108 = validateParameter(valid_594108, JBool, required = false,
                                 default = newJBool(true))
  if valid_594108 != nil:
    section.add "prettyPrint", valid_594108
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

proc call*(call_594110: Call_ContainerProjectsZonesClustersLegacyAbac_594092;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ## 
  let valid = call_594110.validator(path, query, header, formData, body)
  let scheme = call_594110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594110.url(scheme.get, call_594110.host, call_594110.base,
                         call_594110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594110, url, valid)

proc call*(call_594111: Call_ContainerProjectsZonesClustersLegacyAbac_594092;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersLegacyAbac
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to update.
  ## This field has been deprecated and replaced by the name field.
  var path_594112 = newJObject()
  var query_594113 = newJObject()
  var body_594114 = newJObject()
  add(query_594113, "upload_protocol", newJString(uploadProtocol))
  add(path_594112, "zone", newJString(zone))
  add(query_594113, "fields", newJString(fields))
  add(query_594113, "quotaUser", newJString(quotaUser))
  add(query_594113, "alt", newJString(alt))
  add(query_594113, "oauth_token", newJString(oauthToken))
  add(query_594113, "callback", newJString(callback))
  add(query_594113, "access_token", newJString(accessToken))
  add(query_594113, "uploadType", newJString(uploadType))
  add(query_594113, "key", newJString(key))
  add(path_594112, "projectId", newJString(projectId))
  add(query_594113, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594114 = body
  add(query_594113, "prettyPrint", newJBool(prettyPrint))
  add(path_594112, "clusterId", newJString(clusterId))
  result = call_594111.call(path_594112, query_594113, nil, nil, body_594114)

var containerProjectsZonesClustersLegacyAbac* = Call_ContainerProjectsZonesClustersLegacyAbac_594092(
    name: "containerProjectsZonesClustersLegacyAbac", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/legacyAbac",
    validator: validate_ContainerProjectsZonesClustersLegacyAbac_594093,
    base: "/", url: url_ContainerProjectsZonesClustersLegacyAbac_594094,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersLocations_594115 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersLocations_594117(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersLocations_594116(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the locations for a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594118 = path.getOrDefault("zone")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "zone", valid_594118
  var valid_594119 = path.getOrDefault("projectId")
  valid_594119 = validateParameter(valid_594119, JString, required = true,
                                 default = nil)
  if valid_594119 != nil:
    section.add "projectId", valid_594119
  var valid_594120 = path.getOrDefault("clusterId")
  valid_594120 = validateParameter(valid_594120, JString, required = true,
                                 default = nil)
  if valid_594120 != nil:
    section.add "clusterId", valid_594120
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
  section = newJObject()
  var valid_594121 = query.getOrDefault("upload_protocol")
  valid_594121 = validateParameter(valid_594121, JString, required = false,
                                 default = nil)
  if valid_594121 != nil:
    section.add "upload_protocol", valid_594121
  var valid_594122 = query.getOrDefault("fields")
  valid_594122 = validateParameter(valid_594122, JString, required = false,
                                 default = nil)
  if valid_594122 != nil:
    section.add "fields", valid_594122
  var valid_594123 = query.getOrDefault("quotaUser")
  valid_594123 = validateParameter(valid_594123, JString, required = false,
                                 default = nil)
  if valid_594123 != nil:
    section.add "quotaUser", valid_594123
  var valid_594124 = query.getOrDefault("alt")
  valid_594124 = validateParameter(valid_594124, JString, required = false,
                                 default = newJString("json"))
  if valid_594124 != nil:
    section.add "alt", valid_594124
  var valid_594125 = query.getOrDefault("oauth_token")
  valid_594125 = validateParameter(valid_594125, JString, required = false,
                                 default = nil)
  if valid_594125 != nil:
    section.add "oauth_token", valid_594125
  var valid_594126 = query.getOrDefault("callback")
  valid_594126 = validateParameter(valid_594126, JString, required = false,
                                 default = nil)
  if valid_594126 != nil:
    section.add "callback", valid_594126
  var valid_594127 = query.getOrDefault("access_token")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "access_token", valid_594127
  var valid_594128 = query.getOrDefault("uploadType")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = nil)
  if valid_594128 != nil:
    section.add "uploadType", valid_594128
  var valid_594129 = query.getOrDefault("key")
  valid_594129 = validateParameter(valid_594129, JString, required = false,
                                 default = nil)
  if valid_594129 != nil:
    section.add "key", valid_594129
  var valid_594130 = query.getOrDefault("$.xgafv")
  valid_594130 = validateParameter(valid_594130, JString, required = false,
                                 default = newJString("1"))
  if valid_594130 != nil:
    section.add "$.xgafv", valid_594130
  var valid_594131 = query.getOrDefault("prettyPrint")
  valid_594131 = validateParameter(valid_594131, JBool, required = false,
                                 default = newJBool(true))
  if valid_594131 != nil:
    section.add "prettyPrint", valid_594131
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

proc call*(call_594133: Call_ContainerProjectsZonesClustersLocations_594115;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the locations for a specific cluster.
  ## 
  let valid = call_594133.validator(path, query, header, formData, body)
  let scheme = call_594133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594133.url(scheme.get, call_594133.host, call_594133.base,
                         call_594133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594133, url, valid)

proc call*(call_594134: Call_ContainerProjectsZonesClustersLocations_594115;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersLocations
  ## Sets the locations for a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  var path_594135 = newJObject()
  var query_594136 = newJObject()
  var body_594137 = newJObject()
  add(query_594136, "upload_protocol", newJString(uploadProtocol))
  add(path_594135, "zone", newJString(zone))
  add(query_594136, "fields", newJString(fields))
  add(query_594136, "quotaUser", newJString(quotaUser))
  add(query_594136, "alt", newJString(alt))
  add(query_594136, "oauth_token", newJString(oauthToken))
  add(query_594136, "callback", newJString(callback))
  add(query_594136, "access_token", newJString(accessToken))
  add(query_594136, "uploadType", newJString(uploadType))
  add(query_594136, "key", newJString(key))
  add(path_594135, "projectId", newJString(projectId))
  add(query_594136, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594137 = body
  add(query_594136, "prettyPrint", newJBool(prettyPrint))
  add(path_594135, "clusterId", newJString(clusterId))
  result = call_594134.call(path_594135, query_594136, nil, nil, body_594137)

var containerProjectsZonesClustersLocations* = Call_ContainerProjectsZonesClustersLocations_594115(
    name: "containerProjectsZonesClustersLocations", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/locations",
    validator: validate_ContainerProjectsZonesClustersLocations_594116, base: "/",
    url: url_ContainerProjectsZonesClustersLocations_594117,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersLogging_594138 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersLogging_594140(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersLogging_594139(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the logging service for a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594141 = path.getOrDefault("zone")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "zone", valid_594141
  var valid_594142 = path.getOrDefault("projectId")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "projectId", valid_594142
  var valid_594143 = path.getOrDefault("clusterId")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "clusterId", valid_594143
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
  section = newJObject()
  var valid_594144 = query.getOrDefault("upload_protocol")
  valid_594144 = validateParameter(valid_594144, JString, required = false,
                                 default = nil)
  if valid_594144 != nil:
    section.add "upload_protocol", valid_594144
  var valid_594145 = query.getOrDefault("fields")
  valid_594145 = validateParameter(valid_594145, JString, required = false,
                                 default = nil)
  if valid_594145 != nil:
    section.add "fields", valid_594145
  var valid_594146 = query.getOrDefault("quotaUser")
  valid_594146 = validateParameter(valid_594146, JString, required = false,
                                 default = nil)
  if valid_594146 != nil:
    section.add "quotaUser", valid_594146
  var valid_594147 = query.getOrDefault("alt")
  valid_594147 = validateParameter(valid_594147, JString, required = false,
                                 default = newJString("json"))
  if valid_594147 != nil:
    section.add "alt", valid_594147
  var valid_594148 = query.getOrDefault("oauth_token")
  valid_594148 = validateParameter(valid_594148, JString, required = false,
                                 default = nil)
  if valid_594148 != nil:
    section.add "oauth_token", valid_594148
  var valid_594149 = query.getOrDefault("callback")
  valid_594149 = validateParameter(valid_594149, JString, required = false,
                                 default = nil)
  if valid_594149 != nil:
    section.add "callback", valid_594149
  var valid_594150 = query.getOrDefault("access_token")
  valid_594150 = validateParameter(valid_594150, JString, required = false,
                                 default = nil)
  if valid_594150 != nil:
    section.add "access_token", valid_594150
  var valid_594151 = query.getOrDefault("uploadType")
  valid_594151 = validateParameter(valid_594151, JString, required = false,
                                 default = nil)
  if valid_594151 != nil:
    section.add "uploadType", valid_594151
  var valid_594152 = query.getOrDefault("key")
  valid_594152 = validateParameter(valid_594152, JString, required = false,
                                 default = nil)
  if valid_594152 != nil:
    section.add "key", valid_594152
  var valid_594153 = query.getOrDefault("$.xgafv")
  valid_594153 = validateParameter(valid_594153, JString, required = false,
                                 default = newJString("1"))
  if valid_594153 != nil:
    section.add "$.xgafv", valid_594153
  var valid_594154 = query.getOrDefault("prettyPrint")
  valid_594154 = validateParameter(valid_594154, JBool, required = false,
                                 default = newJBool(true))
  if valid_594154 != nil:
    section.add "prettyPrint", valid_594154
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

proc call*(call_594156: Call_ContainerProjectsZonesClustersLogging_594138;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the logging service for a specific cluster.
  ## 
  let valid = call_594156.validator(path, query, header, formData, body)
  let scheme = call_594156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594156.url(scheme.get, call_594156.host, call_594156.base,
                         call_594156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594156, url, valid)

proc call*(call_594157: Call_ContainerProjectsZonesClustersLogging_594138;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersLogging
  ## Sets the logging service for a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  var path_594158 = newJObject()
  var query_594159 = newJObject()
  var body_594160 = newJObject()
  add(query_594159, "upload_protocol", newJString(uploadProtocol))
  add(path_594158, "zone", newJString(zone))
  add(query_594159, "fields", newJString(fields))
  add(query_594159, "quotaUser", newJString(quotaUser))
  add(query_594159, "alt", newJString(alt))
  add(query_594159, "oauth_token", newJString(oauthToken))
  add(query_594159, "callback", newJString(callback))
  add(query_594159, "access_token", newJString(accessToken))
  add(query_594159, "uploadType", newJString(uploadType))
  add(query_594159, "key", newJString(key))
  add(path_594158, "projectId", newJString(projectId))
  add(query_594159, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594160 = body
  add(query_594159, "prettyPrint", newJBool(prettyPrint))
  add(path_594158, "clusterId", newJString(clusterId))
  result = call_594157.call(path_594158, query_594159, nil, nil, body_594160)

var containerProjectsZonesClustersLogging* = Call_ContainerProjectsZonesClustersLogging_594138(
    name: "containerProjectsZonesClustersLogging", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/logging",
    validator: validate_ContainerProjectsZonesClustersLogging_594139, base: "/",
    url: url_ContainerProjectsZonesClustersLogging_594140, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersMaster_594161 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersMaster_594163(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersMaster_594162(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the master for a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594164 = path.getOrDefault("zone")
  valid_594164 = validateParameter(valid_594164, JString, required = true,
                                 default = nil)
  if valid_594164 != nil:
    section.add "zone", valid_594164
  var valid_594165 = path.getOrDefault("projectId")
  valid_594165 = validateParameter(valid_594165, JString, required = true,
                                 default = nil)
  if valid_594165 != nil:
    section.add "projectId", valid_594165
  var valid_594166 = path.getOrDefault("clusterId")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "clusterId", valid_594166
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
  section = newJObject()
  var valid_594167 = query.getOrDefault("upload_protocol")
  valid_594167 = validateParameter(valid_594167, JString, required = false,
                                 default = nil)
  if valid_594167 != nil:
    section.add "upload_protocol", valid_594167
  var valid_594168 = query.getOrDefault("fields")
  valid_594168 = validateParameter(valid_594168, JString, required = false,
                                 default = nil)
  if valid_594168 != nil:
    section.add "fields", valid_594168
  var valid_594169 = query.getOrDefault("quotaUser")
  valid_594169 = validateParameter(valid_594169, JString, required = false,
                                 default = nil)
  if valid_594169 != nil:
    section.add "quotaUser", valid_594169
  var valid_594170 = query.getOrDefault("alt")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = newJString("json"))
  if valid_594170 != nil:
    section.add "alt", valid_594170
  var valid_594171 = query.getOrDefault("oauth_token")
  valid_594171 = validateParameter(valid_594171, JString, required = false,
                                 default = nil)
  if valid_594171 != nil:
    section.add "oauth_token", valid_594171
  var valid_594172 = query.getOrDefault("callback")
  valid_594172 = validateParameter(valid_594172, JString, required = false,
                                 default = nil)
  if valid_594172 != nil:
    section.add "callback", valid_594172
  var valid_594173 = query.getOrDefault("access_token")
  valid_594173 = validateParameter(valid_594173, JString, required = false,
                                 default = nil)
  if valid_594173 != nil:
    section.add "access_token", valid_594173
  var valid_594174 = query.getOrDefault("uploadType")
  valid_594174 = validateParameter(valid_594174, JString, required = false,
                                 default = nil)
  if valid_594174 != nil:
    section.add "uploadType", valid_594174
  var valid_594175 = query.getOrDefault("key")
  valid_594175 = validateParameter(valid_594175, JString, required = false,
                                 default = nil)
  if valid_594175 != nil:
    section.add "key", valid_594175
  var valid_594176 = query.getOrDefault("$.xgafv")
  valid_594176 = validateParameter(valid_594176, JString, required = false,
                                 default = newJString("1"))
  if valid_594176 != nil:
    section.add "$.xgafv", valid_594176
  var valid_594177 = query.getOrDefault("prettyPrint")
  valid_594177 = validateParameter(valid_594177, JBool, required = false,
                                 default = newJBool(true))
  if valid_594177 != nil:
    section.add "prettyPrint", valid_594177
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

proc call*(call_594179: Call_ContainerProjectsZonesClustersMaster_594161;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the master for a specific cluster.
  ## 
  let valid = call_594179.validator(path, query, header, formData, body)
  let scheme = call_594179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594179.url(scheme.get, call_594179.host, call_594179.base,
                         call_594179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594179, url, valid)

proc call*(call_594180: Call_ContainerProjectsZonesClustersMaster_594161;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersMaster
  ## Updates the master for a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  var path_594181 = newJObject()
  var query_594182 = newJObject()
  var body_594183 = newJObject()
  add(query_594182, "upload_protocol", newJString(uploadProtocol))
  add(path_594181, "zone", newJString(zone))
  add(query_594182, "fields", newJString(fields))
  add(query_594182, "quotaUser", newJString(quotaUser))
  add(query_594182, "alt", newJString(alt))
  add(query_594182, "oauth_token", newJString(oauthToken))
  add(query_594182, "callback", newJString(callback))
  add(query_594182, "access_token", newJString(accessToken))
  add(query_594182, "uploadType", newJString(uploadType))
  add(query_594182, "key", newJString(key))
  add(path_594181, "projectId", newJString(projectId))
  add(query_594182, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594183 = body
  add(query_594182, "prettyPrint", newJBool(prettyPrint))
  add(path_594181, "clusterId", newJString(clusterId))
  result = call_594180.call(path_594181, query_594182, nil, nil, body_594183)

var containerProjectsZonesClustersMaster* = Call_ContainerProjectsZonesClustersMaster_594161(
    name: "containerProjectsZonesClustersMaster", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/master",
    validator: validate_ContainerProjectsZonesClustersMaster_594162, base: "/",
    url: url_ContainerProjectsZonesClustersMaster_594163, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersMonitoring_594184 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersMonitoring_594186(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersMonitoring_594185(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the monitoring service for a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594187 = path.getOrDefault("zone")
  valid_594187 = validateParameter(valid_594187, JString, required = true,
                                 default = nil)
  if valid_594187 != nil:
    section.add "zone", valid_594187
  var valid_594188 = path.getOrDefault("projectId")
  valid_594188 = validateParameter(valid_594188, JString, required = true,
                                 default = nil)
  if valid_594188 != nil:
    section.add "projectId", valid_594188
  var valid_594189 = path.getOrDefault("clusterId")
  valid_594189 = validateParameter(valid_594189, JString, required = true,
                                 default = nil)
  if valid_594189 != nil:
    section.add "clusterId", valid_594189
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
  section = newJObject()
  var valid_594190 = query.getOrDefault("upload_protocol")
  valid_594190 = validateParameter(valid_594190, JString, required = false,
                                 default = nil)
  if valid_594190 != nil:
    section.add "upload_protocol", valid_594190
  var valid_594191 = query.getOrDefault("fields")
  valid_594191 = validateParameter(valid_594191, JString, required = false,
                                 default = nil)
  if valid_594191 != nil:
    section.add "fields", valid_594191
  var valid_594192 = query.getOrDefault("quotaUser")
  valid_594192 = validateParameter(valid_594192, JString, required = false,
                                 default = nil)
  if valid_594192 != nil:
    section.add "quotaUser", valid_594192
  var valid_594193 = query.getOrDefault("alt")
  valid_594193 = validateParameter(valid_594193, JString, required = false,
                                 default = newJString("json"))
  if valid_594193 != nil:
    section.add "alt", valid_594193
  var valid_594194 = query.getOrDefault("oauth_token")
  valid_594194 = validateParameter(valid_594194, JString, required = false,
                                 default = nil)
  if valid_594194 != nil:
    section.add "oauth_token", valid_594194
  var valid_594195 = query.getOrDefault("callback")
  valid_594195 = validateParameter(valid_594195, JString, required = false,
                                 default = nil)
  if valid_594195 != nil:
    section.add "callback", valid_594195
  var valid_594196 = query.getOrDefault("access_token")
  valid_594196 = validateParameter(valid_594196, JString, required = false,
                                 default = nil)
  if valid_594196 != nil:
    section.add "access_token", valid_594196
  var valid_594197 = query.getOrDefault("uploadType")
  valid_594197 = validateParameter(valid_594197, JString, required = false,
                                 default = nil)
  if valid_594197 != nil:
    section.add "uploadType", valid_594197
  var valid_594198 = query.getOrDefault("key")
  valid_594198 = validateParameter(valid_594198, JString, required = false,
                                 default = nil)
  if valid_594198 != nil:
    section.add "key", valid_594198
  var valid_594199 = query.getOrDefault("$.xgafv")
  valid_594199 = validateParameter(valid_594199, JString, required = false,
                                 default = newJString("1"))
  if valid_594199 != nil:
    section.add "$.xgafv", valid_594199
  var valid_594200 = query.getOrDefault("prettyPrint")
  valid_594200 = validateParameter(valid_594200, JBool, required = false,
                                 default = newJBool(true))
  if valid_594200 != nil:
    section.add "prettyPrint", valid_594200
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

proc call*(call_594202: Call_ContainerProjectsZonesClustersMonitoring_594184;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the monitoring service for a specific cluster.
  ## 
  let valid = call_594202.validator(path, query, header, formData, body)
  let scheme = call_594202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594202.url(scheme.get, call_594202.host, call_594202.base,
                         call_594202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594202, url, valid)

proc call*(call_594203: Call_ContainerProjectsZonesClustersMonitoring_594184;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersMonitoring
  ## Sets the monitoring service for a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  var path_594204 = newJObject()
  var query_594205 = newJObject()
  var body_594206 = newJObject()
  add(query_594205, "upload_protocol", newJString(uploadProtocol))
  add(path_594204, "zone", newJString(zone))
  add(query_594205, "fields", newJString(fields))
  add(query_594205, "quotaUser", newJString(quotaUser))
  add(query_594205, "alt", newJString(alt))
  add(query_594205, "oauth_token", newJString(oauthToken))
  add(query_594205, "callback", newJString(callback))
  add(query_594205, "access_token", newJString(accessToken))
  add(query_594205, "uploadType", newJString(uploadType))
  add(query_594205, "key", newJString(key))
  add(path_594204, "projectId", newJString(projectId))
  add(query_594205, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594206 = body
  add(query_594205, "prettyPrint", newJBool(prettyPrint))
  add(path_594204, "clusterId", newJString(clusterId))
  result = call_594203.call(path_594204, query_594205, nil, nil, body_594206)

var containerProjectsZonesClustersMonitoring* = Call_ContainerProjectsZonesClustersMonitoring_594184(
    name: "containerProjectsZonesClustersMonitoring", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/monitoring",
    validator: validate_ContainerProjectsZonesClustersMonitoring_594185,
    base: "/", url: url_ContainerProjectsZonesClustersMonitoring_594186,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsCreate_594229 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersNodePoolsCreate_594231(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersNodePoolsCreate_594230(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a node pool for a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the parent field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the parent field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the parent field.
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
  var valid_594239 = query.getOrDefault("oauth_token")
  valid_594239 = validateParameter(valid_594239, JString, required = false,
                                 default = nil)
  if valid_594239 != nil:
    section.add "oauth_token", valid_594239
  var valid_594240 = query.getOrDefault("callback")
  valid_594240 = validateParameter(valid_594240, JString, required = false,
                                 default = nil)
  if valid_594240 != nil:
    section.add "callback", valid_594240
  var valid_594241 = query.getOrDefault("access_token")
  valid_594241 = validateParameter(valid_594241, JString, required = false,
                                 default = nil)
  if valid_594241 != nil:
    section.add "access_token", valid_594241
  var valid_594242 = query.getOrDefault("uploadType")
  valid_594242 = validateParameter(valid_594242, JString, required = false,
                                 default = nil)
  if valid_594242 != nil:
    section.add "uploadType", valid_594242
  var valid_594243 = query.getOrDefault("key")
  valid_594243 = validateParameter(valid_594243, JString, required = false,
                                 default = nil)
  if valid_594243 != nil:
    section.add "key", valid_594243
  var valid_594244 = query.getOrDefault("$.xgafv")
  valid_594244 = validateParameter(valid_594244, JString, required = false,
                                 default = newJString("1"))
  if valid_594244 != nil:
    section.add "$.xgafv", valid_594244
  var valid_594245 = query.getOrDefault("prettyPrint")
  valid_594245 = validateParameter(valid_594245, JBool, required = false,
                                 default = newJBool(true))
  if valid_594245 != nil:
    section.add "prettyPrint", valid_594245
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

proc call*(call_594247: Call_ContainerProjectsZonesClustersNodePoolsCreate_594229;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a node pool for a cluster.
  ## 
  let valid = call_594247.validator(path, query, header, formData, body)
  let scheme = call_594247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594247.url(scheme.get, call_594247.host, call_594247.base,
                         call_594247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594247, url, valid)

proc call*(call_594248: Call_ContainerProjectsZonesClustersNodePoolsCreate_594229;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersNodePoolsCreate
  ## Creates a node pool for a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the parent field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the parent field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the parent field.
  var path_594249 = newJObject()
  var query_594250 = newJObject()
  var body_594251 = newJObject()
  add(query_594250, "upload_protocol", newJString(uploadProtocol))
  add(path_594249, "zone", newJString(zone))
  add(query_594250, "fields", newJString(fields))
  add(query_594250, "quotaUser", newJString(quotaUser))
  add(query_594250, "alt", newJString(alt))
  add(query_594250, "oauth_token", newJString(oauthToken))
  add(query_594250, "callback", newJString(callback))
  add(query_594250, "access_token", newJString(accessToken))
  add(query_594250, "uploadType", newJString(uploadType))
  add(query_594250, "key", newJString(key))
  add(path_594249, "projectId", newJString(projectId))
  add(query_594250, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594251 = body
  add(query_594250, "prettyPrint", newJBool(prettyPrint))
  add(path_594249, "clusterId", newJString(clusterId))
  result = call_594248.call(path_594249, query_594250, nil, nil, body_594251)

var containerProjectsZonesClustersNodePoolsCreate* = Call_ContainerProjectsZonesClustersNodePoolsCreate_594229(
    name: "containerProjectsZonesClustersNodePoolsCreate",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools",
    validator: validate_ContainerProjectsZonesClustersNodePoolsCreate_594230,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsCreate_594231,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsList_594207 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersNodePoolsList_594209(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersNodePoolsList_594208(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the node pools for a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the parent field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the parent field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the parent field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594210 = path.getOrDefault("zone")
  valid_594210 = validateParameter(valid_594210, JString, required = true,
                                 default = nil)
  if valid_594210 != nil:
    section.add "zone", valid_594210
  var valid_594211 = path.getOrDefault("projectId")
  valid_594211 = validateParameter(valid_594211, JString, required = true,
                                 default = nil)
  if valid_594211 != nil:
    section.add "projectId", valid_594211
  var valid_594212 = path.getOrDefault("clusterId")
  valid_594212 = validateParameter(valid_594212, JString, required = true,
                                 default = nil)
  if valid_594212 != nil:
    section.add "clusterId", valid_594212
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
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent (project, location, cluster id) where the node pools will be
  ## listed. Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594213 = query.getOrDefault("upload_protocol")
  valid_594213 = validateParameter(valid_594213, JString, required = false,
                                 default = nil)
  if valid_594213 != nil:
    section.add "upload_protocol", valid_594213
  var valid_594214 = query.getOrDefault("fields")
  valid_594214 = validateParameter(valid_594214, JString, required = false,
                                 default = nil)
  if valid_594214 != nil:
    section.add "fields", valid_594214
  var valid_594215 = query.getOrDefault("quotaUser")
  valid_594215 = validateParameter(valid_594215, JString, required = false,
                                 default = nil)
  if valid_594215 != nil:
    section.add "quotaUser", valid_594215
  var valid_594216 = query.getOrDefault("alt")
  valid_594216 = validateParameter(valid_594216, JString, required = false,
                                 default = newJString("json"))
  if valid_594216 != nil:
    section.add "alt", valid_594216
  var valid_594217 = query.getOrDefault("oauth_token")
  valid_594217 = validateParameter(valid_594217, JString, required = false,
                                 default = nil)
  if valid_594217 != nil:
    section.add "oauth_token", valid_594217
  var valid_594218 = query.getOrDefault("callback")
  valid_594218 = validateParameter(valid_594218, JString, required = false,
                                 default = nil)
  if valid_594218 != nil:
    section.add "callback", valid_594218
  var valid_594219 = query.getOrDefault("access_token")
  valid_594219 = validateParameter(valid_594219, JString, required = false,
                                 default = nil)
  if valid_594219 != nil:
    section.add "access_token", valid_594219
  var valid_594220 = query.getOrDefault("uploadType")
  valid_594220 = validateParameter(valid_594220, JString, required = false,
                                 default = nil)
  if valid_594220 != nil:
    section.add "uploadType", valid_594220
  var valid_594221 = query.getOrDefault("parent")
  valid_594221 = validateParameter(valid_594221, JString, required = false,
                                 default = nil)
  if valid_594221 != nil:
    section.add "parent", valid_594221
  var valid_594222 = query.getOrDefault("key")
  valid_594222 = validateParameter(valid_594222, JString, required = false,
                                 default = nil)
  if valid_594222 != nil:
    section.add "key", valid_594222
  var valid_594223 = query.getOrDefault("$.xgafv")
  valid_594223 = validateParameter(valid_594223, JString, required = false,
                                 default = newJString("1"))
  if valid_594223 != nil:
    section.add "$.xgafv", valid_594223
  var valid_594224 = query.getOrDefault("prettyPrint")
  valid_594224 = validateParameter(valid_594224, JBool, required = false,
                                 default = newJBool(true))
  if valid_594224 != nil:
    section.add "prettyPrint", valid_594224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594225: Call_ContainerProjectsZonesClustersNodePoolsList_594207;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the node pools for a cluster.
  ## 
  let valid = call_594225.validator(path, query, header, formData, body)
  let scheme = call_594225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594225.url(scheme.get, call_594225.host, call_594225.base,
                         call_594225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594225, url, valid)

proc call*(call_594226: Call_ContainerProjectsZonesClustersNodePoolsList_594207;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; parent: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersNodePoolsList
  ## Lists the node pools for a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the parent field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent (project, location, cluster id) where the node pools will be
  ## listed. Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the parent field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the parent field.
  var path_594227 = newJObject()
  var query_594228 = newJObject()
  add(query_594228, "upload_protocol", newJString(uploadProtocol))
  add(path_594227, "zone", newJString(zone))
  add(query_594228, "fields", newJString(fields))
  add(query_594228, "quotaUser", newJString(quotaUser))
  add(query_594228, "alt", newJString(alt))
  add(query_594228, "oauth_token", newJString(oauthToken))
  add(query_594228, "callback", newJString(callback))
  add(query_594228, "access_token", newJString(accessToken))
  add(query_594228, "uploadType", newJString(uploadType))
  add(query_594228, "parent", newJString(parent))
  add(query_594228, "key", newJString(key))
  add(path_594227, "projectId", newJString(projectId))
  add(query_594228, "$.xgafv", newJString(Xgafv))
  add(query_594228, "prettyPrint", newJBool(prettyPrint))
  add(path_594227, "clusterId", newJString(clusterId))
  result = call_594226.call(path_594227, query_594228, nil, nil, nil)

var containerProjectsZonesClustersNodePoolsList* = Call_ContainerProjectsZonesClustersNodePoolsList_594207(
    name: "containerProjectsZonesClustersNodePoolsList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools",
    validator: validate_ContainerProjectsZonesClustersNodePoolsList_594208,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsList_594209,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsGet_594252 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersNodePoolsGet_594254(protocol: Scheme;
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
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersNodePoolsGet_594253(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the requested node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   nodePoolId: JString (required)
  ##             : Deprecated. The name of the node pool.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594255 = path.getOrDefault("zone")
  valid_594255 = validateParameter(valid_594255, JString, required = true,
                                 default = nil)
  if valid_594255 != nil:
    section.add "zone", valid_594255
  var valid_594256 = path.getOrDefault("nodePoolId")
  valid_594256 = validateParameter(valid_594256, JString, required = true,
                                 default = nil)
  if valid_594256 != nil:
    section.add "nodePoolId", valid_594256
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
  ##       : The name (project, location, cluster, node pool id) of the node pool to
  ## get. Specified in the format
  ## 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
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
  var valid_594263 = query.getOrDefault("oauth_token")
  valid_594263 = validateParameter(valid_594263, JString, required = false,
                                 default = nil)
  if valid_594263 != nil:
    section.add "oauth_token", valid_594263
  var valid_594264 = query.getOrDefault("callback")
  valid_594264 = validateParameter(valid_594264, JString, required = false,
                                 default = nil)
  if valid_594264 != nil:
    section.add "callback", valid_594264
  var valid_594265 = query.getOrDefault("access_token")
  valid_594265 = validateParameter(valid_594265, JString, required = false,
                                 default = nil)
  if valid_594265 != nil:
    section.add "access_token", valid_594265
  var valid_594266 = query.getOrDefault("uploadType")
  valid_594266 = validateParameter(valid_594266, JString, required = false,
                                 default = nil)
  if valid_594266 != nil:
    section.add "uploadType", valid_594266
  var valid_594267 = query.getOrDefault("key")
  valid_594267 = validateParameter(valid_594267, JString, required = false,
                                 default = nil)
  if valid_594267 != nil:
    section.add "key", valid_594267
  var valid_594268 = query.getOrDefault("name")
  valid_594268 = validateParameter(valid_594268, JString, required = false,
                                 default = nil)
  if valid_594268 != nil:
    section.add "name", valid_594268
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594271: Call_ContainerProjectsZonesClustersNodePoolsGet_594252;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the requested node pool.
  ## 
  let valid = call_594271.validator(path, query, header, formData, body)
  let scheme = call_594271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594271.url(scheme.get, call_594271.host, call_594271.base,
                         call_594271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594271, url, valid)

proc call*(call_594272: Call_ContainerProjectsZonesClustersNodePoolsGet_594252;
          zone: string; nodePoolId: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          name: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersNodePoolsGet
  ## Retrieves the requested node pool.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: string (required)
  ##             : Deprecated. The name of the node pool.
  ## This field has been deprecated and replaced by the name field.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : The name (project, location, cluster, node pool id) of the node pool to
  ## get. Specified in the format
  ## 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  var path_594273 = newJObject()
  var query_594274 = newJObject()
  add(query_594274, "upload_protocol", newJString(uploadProtocol))
  add(path_594273, "zone", newJString(zone))
  add(query_594274, "fields", newJString(fields))
  add(query_594274, "quotaUser", newJString(quotaUser))
  add(query_594274, "alt", newJString(alt))
  add(query_594274, "oauth_token", newJString(oauthToken))
  add(query_594274, "callback", newJString(callback))
  add(query_594274, "access_token", newJString(accessToken))
  add(query_594274, "uploadType", newJString(uploadType))
  add(path_594273, "nodePoolId", newJString(nodePoolId))
  add(query_594274, "key", newJString(key))
  add(query_594274, "name", newJString(name))
  add(path_594273, "projectId", newJString(projectId))
  add(query_594274, "$.xgafv", newJString(Xgafv))
  add(query_594274, "prettyPrint", newJBool(prettyPrint))
  add(path_594273, "clusterId", newJString(clusterId))
  result = call_594272.call(path_594273, query_594274, nil, nil, nil)

var containerProjectsZonesClustersNodePoolsGet* = Call_ContainerProjectsZonesClustersNodePoolsGet_594252(
    name: "containerProjectsZonesClustersNodePoolsGet", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}",
    validator: validate_ContainerProjectsZonesClustersNodePoolsGet_594253,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsGet_594254,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsDelete_594275 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersNodePoolsDelete_594277(protocol: Scheme;
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
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersNodePoolsDelete_594276(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes a node pool from a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   nodePoolId: JString (required)
  ##             : Deprecated. The name of the node pool to delete.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594278 = path.getOrDefault("zone")
  valid_594278 = validateParameter(valid_594278, JString, required = true,
                                 default = nil)
  if valid_594278 != nil:
    section.add "zone", valid_594278
  var valid_594279 = path.getOrDefault("nodePoolId")
  valid_594279 = validateParameter(valid_594279, JString, required = true,
                                 default = nil)
  if valid_594279 != nil:
    section.add "nodePoolId", valid_594279
  var valid_594280 = path.getOrDefault("projectId")
  valid_594280 = validateParameter(valid_594280, JString, required = true,
                                 default = nil)
  if valid_594280 != nil:
    section.add "projectId", valid_594280
  var valid_594281 = path.getOrDefault("clusterId")
  valid_594281 = validateParameter(valid_594281, JString, required = true,
                                 default = nil)
  if valid_594281 != nil:
    section.add "clusterId", valid_594281
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
  ##       : The name (project, location, cluster, node pool id) of the node pool to
  ## delete. Specified in the format
  ## 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594282 = query.getOrDefault("upload_protocol")
  valid_594282 = validateParameter(valid_594282, JString, required = false,
                                 default = nil)
  if valid_594282 != nil:
    section.add "upload_protocol", valid_594282
  var valid_594283 = query.getOrDefault("fields")
  valid_594283 = validateParameter(valid_594283, JString, required = false,
                                 default = nil)
  if valid_594283 != nil:
    section.add "fields", valid_594283
  var valid_594284 = query.getOrDefault("quotaUser")
  valid_594284 = validateParameter(valid_594284, JString, required = false,
                                 default = nil)
  if valid_594284 != nil:
    section.add "quotaUser", valid_594284
  var valid_594285 = query.getOrDefault("alt")
  valid_594285 = validateParameter(valid_594285, JString, required = false,
                                 default = newJString("json"))
  if valid_594285 != nil:
    section.add "alt", valid_594285
  var valid_594286 = query.getOrDefault("oauth_token")
  valid_594286 = validateParameter(valid_594286, JString, required = false,
                                 default = nil)
  if valid_594286 != nil:
    section.add "oauth_token", valid_594286
  var valid_594287 = query.getOrDefault("callback")
  valid_594287 = validateParameter(valid_594287, JString, required = false,
                                 default = nil)
  if valid_594287 != nil:
    section.add "callback", valid_594287
  var valid_594288 = query.getOrDefault("access_token")
  valid_594288 = validateParameter(valid_594288, JString, required = false,
                                 default = nil)
  if valid_594288 != nil:
    section.add "access_token", valid_594288
  var valid_594289 = query.getOrDefault("uploadType")
  valid_594289 = validateParameter(valid_594289, JString, required = false,
                                 default = nil)
  if valid_594289 != nil:
    section.add "uploadType", valid_594289
  var valid_594290 = query.getOrDefault("key")
  valid_594290 = validateParameter(valid_594290, JString, required = false,
                                 default = nil)
  if valid_594290 != nil:
    section.add "key", valid_594290
  var valid_594291 = query.getOrDefault("name")
  valid_594291 = validateParameter(valid_594291, JString, required = false,
                                 default = nil)
  if valid_594291 != nil:
    section.add "name", valid_594291
  var valid_594292 = query.getOrDefault("$.xgafv")
  valid_594292 = validateParameter(valid_594292, JString, required = false,
                                 default = newJString("1"))
  if valid_594292 != nil:
    section.add "$.xgafv", valid_594292
  var valid_594293 = query.getOrDefault("prettyPrint")
  valid_594293 = validateParameter(valid_594293, JBool, required = false,
                                 default = newJBool(true))
  if valid_594293 != nil:
    section.add "prettyPrint", valid_594293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594294: Call_ContainerProjectsZonesClustersNodePoolsDelete_594275;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a node pool from a cluster.
  ## 
  let valid = call_594294.validator(path, query, header, formData, body)
  let scheme = call_594294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594294.url(scheme.get, call_594294.host, call_594294.base,
                         call_594294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594294, url, valid)

proc call*(call_594295: Call_ContainerProjectsZonesClustersNodePoolsDelete_594275;
          zone: string; nodePoolId: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          name: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersNodePoolsDelete
  ## Deletes a node pool from a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: string (required)
  ##             : Deprecated. The name of the node pool to delete.
  ## This field has been deprecated and replaced by the name field.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : The name (project, location, cluster, node pool id) of the node pool to
  ## delete. Specified in the format
  ## 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  var path_594296 = newJObject()
  var query_594297 = newJObject()
  add(query_594297, "upload_protocol", newJString(uploadProtocol))
  add(path_594296, "zone", newJString(zone))
  add(query_594297, "fields", newJString(fields))
  add(query_594297, "quotaUser", newJString(quotaUser))
  add(query_594297, "alt", newJString(alt))
  add(query_594297, "oauth_token", newJString(oauthToken))
  add(query_594297, "callback", newJString(callback))
  add(query_594297, "access_token", newJString(accessToken))
  add(query_594297, "uploadType", newJString(uploadType))
  add(path_594296, "nodePoolId", newJString(nodePoolId))
  add(query_594297, "key", newJString(key))
  add(query_594297, "name", newJString(name))
  add(path_594296, "projectId", newJString(projectId))
  add(query_594297, "$.xgafv", newJString(Xgafv))
  add(query_594297, "prettyPrint", newJBool(prettyPrint))
  add(path_594296, "clusterId", newJString(clusterId))
  result = call_594295.call(path_594296, query_594297, nil, nil, nil)

var containerProjectsZonesClustersNodePoolsDelete* = Call_ContainerProjectsZonesClustersNodePoolsDelete_594275(
    name: "containerProjectsZonesClustersNodePoolsDelete",
    meth: HttpMethod.HttpDelete, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}",
    validator: validate_ContainerProjectsZonesClustersNodePoolsDelete_594276,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsDelete_594277,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_594298 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersNodePoolsAutoscaling_594300(
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
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersNodePoolsAutoscaling_594299(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the autoscaling settings for the specified node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   nodePoolId: JString (required)
  ##             : Deprecated. The name of the node pool to upgrade.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594301 = path.getOrDefault("zone")
  valid_594301 = validateParameter(valid_594301, JString, required = true,
                                 default = nil)
  if valid_594301 != nil:
    section.add "zone", valid_594301
  var valid_594302 = path.getOrDefault("nodePoolId")
  valid_594302 = validateParameter(valid_594302, JString, required = true,
                                 default = nil)
  if valid_594302 != nil:
    section.add "nodePoolId", valid_594302
  var valid_594303 = path.getOrDefault("projectId")
  valid_594303 = validateParameter(valid_594303, JString, required = true,
                                 default = nil)
  if valid_594303 != nil:
    section.add "projectId", valid_594303
  var valid_594304 = path.getOrDefault("clusterId")
  valid_594304 = validateParameter(valid_594304, JString, required = true,
                                 default = nil)
  if valid_594304 != nil:
    section.add "clusterId", valid_594304
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
  section = newJObject()
  var valid_594305 = query.getOrDefault("upload_protocol")
  valid_594305 = validateParameter(valid_594305, JString, required = false,
                                 default = nil)
  if valid_594305 != nil:
    section.add "upload_protocol", valid_594305
  var valid_594306 = query.getOrDefault("fields")
  valid_594306 = validateParameter(valid_594306, JString, required = false,
                                 default = nil)
  if valid_594306 != nil:
    section.add "fields", valid_594306
  var valid_594307 = query.getOrDefault("quotaUser")
  valid_594307 = validateParameter(valid_594307, JString, required = false,
                                 default = nil)
  if valid_594307 != nil:
    section.add "quotaUser", valid_594307
  var valid_594308 = query.getOrDefault("alt")
  valid_594308 = validateParameter(valid_594308, JString, required = false,
                                 default = newJString("json"))
  if valid_594308 != nil:
    section.add "alt", valid_594308
  var valid_594309 = query.getOrDefault("oauth_token")
  valid_594309 = validateParameter(valid_594309, JString, required = false,
                                 default = nil)
  if valid_594309 != nil:
    section.add "oauth_token", valid_594309
  var valid_594310 = query.getOrDefault("callback")
  valid_594310 = validateParameter(valid_594310, JString, required = false,
                                 default = nil)
  if valid_594310 != nil:
    section.add "callback", valid_594310
  var valid_594311 = query.getOrDefault("access_token")
  valid_594311 = validateParameter(valid_594311, JString, required = false,
                                 default = nil)
  if valid_594311 != nil:
    section.add "access_token", valid_594311
  var valid_594312 = query.getOrDefault("uploadType")
  valid_594312 = validateParameter(valid_594312, JString, required = false,
                                 default = nil)
  if valid_594312 != nil:
    section.add "uploadType", valid_594312
  var valid_594313 = query.getOrDefault("key")
  valid_594313 = validateParameter(valid_594313, JString, required = false,
                                 default = nil)
  if valid_594313 != nil:
    section.add "key", valid_594313
  var valid_594314 = query.getOrDefault("$.xgafv")
  valid_594314 = validateParameter(valid_594314, JString, required = false,
                                 default = newJString("1"))
  if valid_594314 != nil:
    section.add "$.xgafv", valid_594314
  var valid_594315 = query.getOrDefault("prettyPrint")
  valid_594315 = validateParameter(valid_594315, JBool, required = false,
                                 default = newJBool(true))
  if valid_594315 != nil:
    section.add "prettyPrint", valid_594315
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

proc call*(call_594317: Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_594298;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the autoscaling settings for the specified node pool.
  ## 
  let valid = call_594317.validator(path, query, header, formData, body)
  let scheme = call_594317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594317.url(scheme.get, call_594317.host, call_594317.base,
                         call_594317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594317, url, valid)

proc call*(call_594318: Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_594298;
          zone: string; nodePoolId: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersNodePoolsAutoscaling
  ## Sets the autoscaling settings for the specified node pool.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: string (required)
  ##             : Deprecated. The name of the node pool to upgrade.
  ## This field has been deprecated and replaced by the name field.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  var path_594319 = newJObject()
  var query_594320 = newJObject()
  var body_594321 = newJObject()
  add(query_594320, "upload_protocol", newJString(uploadProtocol))
  add(path_594319, "zone", newJString(zone))
  add(query_594320, "fields", newJString(fields))
  add(query_594320, "quotaUser", newJString(quotaUser))
  add(query_594320, "alt", newJString(alt))
  add(query_594320, "oauth_token", newJString(oauthToken))
  add(query_594320, "callback", newJString(callback))
  add(query_594320, "access_token", newJString(accessToken))
  add(query_594320, "uploadType", newJString(uploadType))
  add(path_594319, "nodePoolId", newJString(nodePoolId))
  add(query_594320, "key", newJString(key))
  add(path_594319, "projectId", newJString(projectId))
  add(query_594320, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594321 = body
  add(query_594320, "prettyPrint", newJBool(prettyPrint))
  add(path_594319, "clusterId", newJString(clusterId))
  result = call_594318.call(path_594319, query_594320, nil, nil, body_594321)

var containerProjectsZonesClustersNodePoolsAutoscaling* = Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_594298(
    name: "containerProjectsZonesClustersNodePoolsAutoscaling",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}/autoscaling",
    validator: validate_ContainerProjectsZonesClustersNodePoolsAutoscaling_594299,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsAutoscaling_594300,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsSetManagement_594322 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersNodePoolsSetManagement_594324(
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
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersNodePoolsSetManagement_594323(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the NodeManagement options for a node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   nodePoolId: JString (required)
  ##             : Deprecated. The name of the node pool to update.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to update.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594325 = path.getOrDefault("zone")
  valid_594325 = validateParameter(valid_594325, JString, required = true,
                                 default = nil)
  if valid_594325 != nil:
    section.add "zone", valid_594325
  var valid_594326 = path.getOrDefault("nodePoolId")
  valid_594326 = validateParameter(valid_594326, JString, required = true,
                                 default = nil)
  if valid_594326 != nil:
    section.add "nodePoolId", valid_594326
  var valid_594327 = path.getOrDefault("projectId")
  valid_594327 = validateParameter(valid_594327, JString, required = true,
                                 default = nil)
  if valid_594327 != nil:
    section.add "projectId", valid_594327
  var valid_594328 = path.getOrDefault("clusterId")
  valid_594328 = validateParameter(valid_594328, JString, required = true,
                                 default = nil)
  if valid_594328 != nil:
    section.add "clusterId", valid_594328
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
  section = newJObject()
  var valid_594329 = query.getOrDefault("upload_protocol")
  valid_594329 = validateParameter(valid_594329, JString, required = false,
                                 default = nil)
  if valid_594329 != nil:
    section.add "upload_protocol", valid_594329
  var valid_594330 = query.getOrDefault("fields")
  valid_594330 = validateParameter(valid_594330, JString, required = false,
                                 default = nil)
  if valid_594330 != nil:
    section.add "fields", valid_594330
  var valid_594331 = query.getOrDefault("quotaUser")
  valid_594331 = validateParameter(valid_594331, JString, required = false,
                                 default = nil)
  if valid_594331 != nil:
    section.add "quotaUser", valid_594331
  var valid_594332 = query.getOrDefault("alt")
  valid_594332 = validateParameter(valid_594332, JString, required = false,
                                 default = newJString("json"))
  if valid_594332 != nil:
    section.add "alt", valid_594332
  var valid_594333 = query.getOrDefault("oauth_token")
  valid_594333 = validateParameter(valid_594333, JString, required = false,
                                 default = nil)
  if valid_594333 != nil:
    section.add "oauth_token", valid_594333
  var valid_594334 = query.getOrDefault("callback")
  valid_594334 = validateParameter(valid_594334, JString, required = false,
                                 default = nil)
  if valid_594334 != nil:
    section.add "callback", valid_594334
  var valid_594335 = query.getOrDefault("access_token")
  valid_594335 = validateParameter(valid_594335, JString, required = false,
                                 default = nil)
  if valid_594335 != nil:
    section.add "access_token", valid_594335
  var valid_594336 = query.getOrDefault("uploadType")
  valid_594336 = validateParameter(valid_594336, JString, required = false,
                                 default = nil)
  if valid_594336 != nil:
    section.add "uploadType", valid_594336
  var valid_594337 = query.getOrDefault("key")
  valid_594337 = validateParameter(valid_594337, JString, required = false,
                                 default = nil)
  if valid_594337 != nil:
    section.add "key", valid_594337
  var valid_594338 = query.getOrDefault("$.xgafv")
  valid_594338 = validateParameter(valid_594338, JString, required = false,
                                 default = newJString("1"))
  if valid_594338 != nil:
    section.add "$.xgafv", valid_594338
  var valid_594339 = query.getOrDefault("prettyPrint")
  valid_594339 = validateParameter(valid_594339, JBool, required = false,
                                 default = newJBool(true))
  if valid_594339 != nil:
    section.add "prettyPrint", valid_594339
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

proc call*(call_594341: Call_ContainerProjectsZonesClustersNodePoolsSetManagement_594322;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the NodeManagement options for a node pool.
  ## 
  let valid = call_594341.validator(path, query, header, formData, body)
  let scheme = call_594341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594341.url(scheme.get, call_594341.host, call_594341.base,
                         call_594341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594341, url, valid)

proc call*(call_594342: Call_ContainerProjectsZonesClustersNodePoolsSetManagement_594322;
          zone: string; nodePoolId: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersNodePoolsSetManagement
  ## Sets the NodeManagement options for a node pool.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: string (required)
  ##             : Deprecated. The name of the node pool to update.
  ## This field has been deprecated and replaced by the name field.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to update.
  ## This field has been deprecated and replaced by the name field.
  var path_594343 = newJObject()
  var query_594344 = newJObject()
  var body_594345 = newJObject()
  add(query_594344, "upload_protocol", newJString(uploadProtocol))
  add(path_594343, "zone", newJString(zone))
  add(query_594344, "fields", newJString(fields))
  add(query_594344, "quotaUser", newJString(quotaUser))
  add(query_594344, "alt", newJString(alt))
  add(query_594344, "oauth_token", newJString(oauthToken))
  add(query_594344, "callback", newJString(callback))
  add(query_594344, "access_token", newJString(accessToken))
  add(query_594344, "uploadType", newJString(uploadType))
  add(path_594343, "nodePoolId", newJString(nodePoolId))
  add(query_594344, "key", newJString(key))
  add(path_594343, "projectId", newJString(projectId))
  add(query_594344, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594345 = body
  add(query_594344, "prettyPrint", newJBool(prettyPrint))
  add(path_594343, "clusterId", newJString(clusterId))
  result = call_594342.call(path_594343, query_594344, nil, nil, body_594345)

var containerProjectsZonesClustersNodePoolsSetManagement* = Call_ContainerProjectsZonesClustersNodePoolsSetManagement_594322(
    name: "containerProjectsZonesClustersNodePoolsSetManagement",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}/setManagement",
    validator: validate_ContainerProjectsZonesClustersNodePoolsSetManagement_594323,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsSetManagement_594324,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsSetSize_594346 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersNodePoolsSetSize_594348(protocol: Scheme;
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
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: "/nodePools/"),
               (kind: VariableSegment, value: "nodePoolId"),
               (kind: ConstantSegment, value: "/setSize")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersNodePoolsSetSize_594347(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the size for a specific node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   nodePoolId: JString (required)
  ##             : Deprecated. The name of the node pool to update.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to update.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594349 = path.getOrDefault("zone")
  valid_594349 = validateParameter(valid_594349, JString, required = true,
                                 default = nil)
  if valid_594349 != nil:
    section.add "zone", valid_594349
  var valid_594350 = path.getOrDefault("nodePoolId")
  valid_594350 = validateParameter(valid_594350, JString, required = true,
                                 default = nil)
  if valid_594350 != nil:
    section.add "nodePoolId", valid_594350
  var valid_594351 = path.getOrDefault("projectId")
  valid_594351 = validateParameter(valid_594351, JString, required = true,
                                 default = nil)
  if valid_594351 != nil:
    section.add "projectId", valid_594351
  var valid_594352 = path.getOrDefault("clusterId")
  valid_594352 = validateParameter(valid_594352, JString, required = true,
                                 default = nil)
  if valid_594352 != nil:
    section.add "clusterId", valid_594352
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
  section = newJObject()
  var valid_594353 = query.getOrDefault("upload_protocol")
  valid_594353 = validateParameter(valid_594353, JString, required = false,
                                 default = nil)
  if valid_594353 != nil:
    section.add "upload_protocol", valid_594353
  var valid_594354 = query.getOrDefault("fields")
  valid_594354 = validateParameter(valid_594354, JString, required = false,
                                 default = nil)
  if valid_594354 != nil:
    section.add "fields", valid_594354
  var valid_594355 = query.getOrDefault("quotaUser")
  valid_594355 = validateParameter(valid_594355, JString, required = false,
                                 default = nil)
  if valid_594355 != nil:
    section.add "quotaUser", valid_594355
  var valid_594356 = query.getOrDefault("alt")
  valid_594356 = validateParameter(valid_594356, JString, required = false,
                                 default = newJString("json"))
  if valid_594356 != nil:
    section.add "alt", valid_594356
  var valid_594357 = query.getOrDefault("oauth_token")
  valid_594357 = validateParameter(valid_594357, JString, required = false,
                                 default = nil)
  if valid_594357 != nil:
    section.add "oauth_token", valid_594357
  var valid_594358 = query.getOrDefault("callback")
  valid_594358 = validateParameter(valid_594358, JString, required = false,
                                 default = nil)
  if valid_594358 != nil:
    section.add "callback", valid_594358
  var valid_594359 = query.getOrDefault("access_token")
  valid_594359 = validateParameter(valid_594359, JString, required = false,
                                 default = nil)
  if valid_594359 != nil:
    section.add "access_token", valid_594359
  var valid_594360 = query.getOrDefault("uploadType")
  valid_594360 = validateParameter(valid_594360, JString, required = false,
                                 default = nil)
  if valid_594360 != nil:
    section.add "uploadType", valid_594360
  var valid_594361 = query.getOrDefault("key")
  valid_594361 = validateParameter(valid_594361, JString, required = false,
                                 default = nil)
  if valid_594361 != nil:
    section.add "key", valid_594361
  var valid_594362 = query.getOrDefault("$.xgafv")
  valid_594362 = validateParameter(valid_594362, JString, required = false,
                                 default = newJString("1"))
  if valid_594362 != nil:
    section.add "$.xgafv", valid_594362
  var valid_594363 = query.getOrDefault("prettyPrint")
  valid_594363 = validateParameter(valid_594363, JBool, required = false,
                                 default = newJBool(true))
  if valid_594363 != nil:
    section.add "prettyPrint", valid_594363
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

proc call*(call_594365: Call_ContainerProjectsZonesClustersNodePoolsSetSize_594346;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the size for a specific node pool.
  ## 
  let valid = call_594365.validator(path, query, header, formData, body)
  let scheme = call_594365.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594365.url(scheme.get, call_594365.host, call_594365.base,
                         call_594365.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594365, url, valid)

proc call*(call_594366: Call_ContainerProjectsZonesClustersNodePoolsSetSize_594346;
          zone: string; nodePoolId: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersNodePoolsSetSize
  ## Sets the size for a specific node pool.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: string (required)
  ##             : Deprecated. The name of the node pool to update.
  ## This field has been deprecated and replaced by the name field.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to update.
  ## This field has been deprecated and replaced by the name field.
  var path_594367 = newJObject()
  var query_594368 = newJObject()
  var body_594369 = newJObject()
  add(query_594368, "upload_protocol", newJString(uploadProtocol))
  add(path_594367, "zone", newJString(zone))
  add(query_594368, "fields", newJString(fields))
  add(query_594368, "quotaUser", newJString(quotaUser))
  add(query_594368, "alt", newJString(alt))
  add(query_594368, "oauth_token", newJString(oauthToken))
  add(query_594368, "callback", newJString(callback))
  add(query_594368, "access_token", newJString(accessToken))
  add(query_594368, "uploadType", newJString(uploadType))
  add(path_594367, "nodePoolId", newJString(nodePoolId))
  add(query_594368, "key", newJString(key))
  add(path_594367, "projectId", newJString(projectId))
  add(query_594368, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594369 = body
  add(query_594368, "prettyPrint", newJBool(prettyPrint))
  add(path_594367, "clusterId", newJString(clusterId))
  result = call_594366.call(path_594367, query_594368, nil, nil, body_594369)

var containerProjectsZonesClustersNodePoolsSetSize* = Call_ContainerProjectsZonesClustersNodePoolsSetSize_594346(
    name: "containerProjectsZonesClustersNodePoolsSetSize",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}/setSize",
    validator: validate_ContainerProjectsZonesClustersNodePoolsSetSize_594347,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsSetSize_594348,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsUpdate_594370 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersNodePoolsUpdate_594372(protocol: Scheme;
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
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersNodePoolsUpdate_594371(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates the version and/or image type for the specified node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   nodePoolId: JString (required)
  ##             : Deprecated. The name of the node pool to upgrade.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594373 = path.getOrDefault("zone")
  valid_594373 = validateParameter(valid_594373, JString, required = true,
                                 default = nil)
  if valid_594373 != nil:
    section.add "zone", valid_594373
  var valid_594374 = path.getOrDefault("nodePoolId")
  valid_594374 = validateParameter(valid_594374, JString, required = true,
                                 default = nil)
  if valid_594374 != nil:
    section.add "nodePoolId", valid_594374
  var valid_594375 = path.getOrDefault("projectId")
  valid_594375 = validateParameter(valid_594375, JString, required = true,
                                 default = nil)
  if valid_594375 != nil:
    section.add "projectId", valid_594375
  var valid_594376 = path.getOrDefault("clusterId")
  valid_594376 = validateParameter(valid_594376, JString, required = true,
                                 default = nil)
  if valid_594376 != nil:
    section.add "clusterId", valid_594376
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
  section = newJObject()
  var valid_594377 = query.getOrDefault("upload_protocol")
  valid_594377 = validateParameter(valid_594377, JString, required = false,
                                 default = nil)
  if valid_594377 != nil:
    section.add "upload_protocol", valid_594377
  var valid_594378 = query.getOrDefault("fields")
  valid_594378 = validateParameter(valid_594378, JString, required = false,
                                 default = nil)
  if valid_594378 != nil:
    section.add "fields", valid_594378
  var valid_594379 = query.getOrDefault("quotaUser")
  valid_594379 = validateParameter(valid_594379, JString, required = false,
                                 default = nil)
  if valid_594379 != nil:
    section.add "quotaUser", valid_594379
  var valid_594380 = query.getOrDefault("alt")
  valid_594380 = validateParameter(valid_594380, JString, required = false,
                                 default = newJString("json"))
  if valid_594380 != nil:
    section.add "alt", valid_594380
  var valid_594381 = query.getOrDefault("oauth_token")
  valid_594381 = validateParameter(valid_594381, JString, required = false,
                                 default = nil)
  if valid_594381 != nil:
    section.add "oauth_token", valid_594381
  var valid_594382 = query.getOrDefault("callback")
  valid_594382 = validateParameter(valid_594382, JString, required = false,
                                 default = nil)
  if valid_594382 != nil:
    section.add "callback", valid_594382
  var valid_594383 = query.getOrDefault("access_token")
  valid_594383 = validateParameter(valid_594383, JString, required = false,
                                 default = nil)
  if valid_594383 != nil:
    section.add "access_token", valid_594383
  var valid_594384 = query.getOrDefault("uploadType")
  valid_594384 = validateParameter(valid_594384, JString, required = false,
                                 default = nil)
  if valid_594384 != nil:
    section.add "uploadType", valid_594384
  var valid_594385 = query.getOrDefault("key")
  valid_594385 = validateParameter(valid_594385, JString, required = false,
                                 default = nil)
  if valid_594385 != nil:
    section.add "key", valid_594385
  var valid_594386 = query.getOrDefault("$.xgafv")
  valid_594386 = validateParameter(valid_594386, JString, required = false,
                                 default = newJString("1"))
  if valid_594386 != nil:
    section.add "$.xgafv", valid_594386
  var valid_594387 = query.getOrDefault("prettyPrint")
  valid_594387 = validateParameter(valid_594387, JBool, required = false,
                                 default = newJBool(true))
  if valid_594387 != nil:
    section.add "prettyPrint", valid_594387
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

proc call*(call_594389: Call_ContainerProjectsZonesClustersNodePoolsUpdate_594370;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the version and/or image type for the specified node pool.
  ## 
  let valid = call_594389.validator(path, query, header, formData, body)
  let scheme = call_594389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594389.url(scheme.get, call_594389.host, call_594389.base,
                         call_594389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594389, url, valid)

proc call*(call_594390: Call_ContainerProjectsZonesClustersNodePoolsUpdate_594370;
          zone: string; nodePoolId: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersNodePoolsUpdate
  ## Updates the version and/or image type for the specified node pool.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: string (required)
  ##             : Deprecated. The name of the node pool to upgrade.
  ## This field has been deprecated and replaced by the name field.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  var path_594391 = newJObject()
  var query_594392 = newJObject()
  var body_594393 = newJObject()
  add(query_594392, "upload_protocol", newJString(uploadProtocol))
  add(path_594391, "zone", newJString(zone))
  add(query_594392, "fields", newJString(fields))
  add(query_594392, "quotaUser", newJString(quotaUser))
  add(query_594392, "alt", newJString(alt))
  add(query_594392, "oauth_token", newJString(oauthToken))
  add(query_594392, "callback", newJString(callback))
  add(query_594392, "access_token", newJString(accessToken))
  add(query_594392, "uploadType", newJString(uploadType))
  add(path_594391, "nodePoolId", newJString(nodePoolId))
  add(query_594392, "key", newJString(key))
  add(path_594391, "projectId", newJString(projectId))
  add(query_594392, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594393 = body
  add(query_594392, "prettyPrint", newJBool(prettyPrint))
  add(path_594391, "clusterId", newJString(clusterId))
  result = call_594390.call(path_594391, query_594392, nil, nil, body_594393)

var containerProjectsZonesClustersNodePoolsUpdate* = Call_ContainerProjectsZonesClustersNodePoolsUpdate_594370(
    name: "containerProjectsZonesClustersNodePoolsUpdate",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}/update",
    validator: validate_ContainerProjectsZonesClustersNodePoolsUpdate_594371,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsUpdate_594372,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsRollback_594394 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersNodePoolsRollback_594396(protocol: Scheme;
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
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersNodePoolsRollback_594395(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Rolls back a previously Aborted or Failed NodePool upgrade.
  ## This makes no changes if the last upgrade successfully completed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   nodePoolId: JString (required)
  ##             : Deprecated. The name of the node pool to rollback.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to rollback.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594397 = path.getOrDefault("zone")
  valid_594397 = validateParameter(valid_594397, JString, required = true,
                                 default = nil)
  if valid_594397 != nil:
    section.add "zone", valid_594397
  var valid_594398 = path.getOrDefault("nodePoolId")
  valid_594398 = validateParameter(valid_594398, JString, required = true,
                                 default = nil)
  if valid_594398 != nil:
    section.add "nodePoolId", valid_594398
  var valid_594399 = path.getOrDefault("projectId")
  valid_594399 = validateParameter(valid_594399, JString, required = true,
                                 default = nil)
  if valid_594399 != nil:
    section.add "projectId", valid_594399
  var valid_594400 = path.getOrDefault("clusterId")
  valid_594400 = validateParameter(valid_594400, JString, required = true,
                                 default = nil)
  if valid_594400 != nil:
    section.add "clusterId", valid_594400
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
  section = newJObject()
  var valid_594401 = query.getOrDefault("upload_protocol")
  valid_594401 = validateParameter(valid_594401, JString, required = false,
                                 default = nil)
  if valid_594401 != nil:
    section.add "upload_protocol", valid_594401
  var valid_594402 = query.getOrDefault("fields")
  valid_594402 = validateParameter(valid_594402, JString, required = false,
                                 default = nil)
  if valid_594402 != nil:
    section.add "fields", valid_594402
  var valid_594403 = query.getOrDefault("quotaUser")
  valid_594403 = validateParameter(valid_594403, JString, required = false,
                                 default = nil)
  if valid_594403 != nil:
    section.add "quotaUser", valid_594403
  var valid_594404 = query.getOrDefault("alt")
  valid_594404 = validateParameter(valid_594404, JString, required = false,
                                 default = newJString("json"))
  if valid_594404 != nil:
    section.add "alt", valid_594404
  var valid_594405 = query.getOrDefault("oauth_token")
  valid_594405 = validateParameter(valid_594405, JString, required = false,
                                 default = nil)
  if valid_594405 != nil:
    section.add "oauth_token", valid_594405
  var valid_594406 = query.getOrDefault("callback")
  valid_594406 = validateParameter(valid_594406, JString, required = false,
                                 default = nil)
  if valid_594406 != nil:
    section.add "callback", valid_594406
  var valid_594407 = query.getOrDefault("access_token")
  valid_594407 = validateParameter(valid_594407, JString, required = false,
                                 default = nil)
  if valid_594407 != nil:
    section.add "access_token", valid_594407
  var valid_594408 = query.getOrDefault("uploadType")
  valid_594408 = validateParameter(valid_594408, JString, required = false,
                                 default = nil)
  if valid_594408 != nil:
    section.add "uploadType", valid_594408
  var valid_594409 = query.getOrDefault("key")
  valid_594409 = validateParameter(valid_594409, JString, required = false,
                                 default = nil)
  if valid_594409 != nil:
    section.add "key", valid_594409
  var valid_594410 = query.getOrDefault("$.xgafv")
  valid_594410 = validateParameter(valid_594410, JString, required = false,
                                 default = newJString("1"))
  if valid_594410 != nil:
    section.add "$.xgafv", valid_594410
  var valid_594411 = query.getOrDefault("prettyPrint")
  valid_594411 = validateParameter(valid_594411, JBool, required = false,
                                 default = newJBool(true))
  if valid_594411 != nil:
    section.add "prettyPrint", valid_594411
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

proc call*(call_594413: Call_ContainerProjectsZonesClustersNodePoolsRollback_594394;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rolls back a previously Aborted or Failed NodePool upgrade.
  ## This makes no changes if the last upgrade successfully completed.
  ## 
  let valid = call_594413.validator(path, query, header, formData, body)
  let scheme = call_594413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594413.url(scheme.get, call_594413.host, call_594413.base,
                         call_594413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594413, url, valid)

proc call*(call_594414: Call_ContainerProjectsZonesClustersNodePoolsRollback_594394;
          zone: string; nodePoolId: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersNodePoolsRollback
  ## Rolls back a previously Aborted or Failed NodePool upgrade.
  ## This makes no changes if the last upgrade successfully completed.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: string (required)
  ##             : Deprecated. The name of the node pool to rollback.
  ## This field has been deprecated and replaced by the name field.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to rollback.
  ## This field has been deprecated and replaced by the name field.
  var path_594415 = newJObject()
  var query_594416 = newJObject()
  var body_594417 = newJObject()
  add(query_594416, "upload_protocol", newJString(uploadProtocol))
  add(path_594415, "zone", newJString(zone))
  add(query_594416, "fields", newJString(fields))
  add(query_594416, "quotaUser", newJString(quotaUser))
  add(query_594416, "alt", newJString(alt))
  add(query_594416, "oauth_token", newJString(oauthToken))
  add(query_594416, "callback", newJString(callback))
  add(query_594416, "access_token", newJString(accessToken))
  add(query_594416, "uploadType", newJString(uploadType))
  add(path_594415, "nodePoolId", newJString(nodePoolId))
  add(query_594416, "key", newJString(key))
  add(path_594415, "projectId", newJString(projectId))
  add(query_594416, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594417 = body
  add(query_594416, "prettyPrint", newJBool(prettyPrint))
  add(path_594415, "clusterId", newJString(clusterId))
  result = call_594414.call(path_594415, query_594416, nil, nil, body_594417)

var containerProjectsZonesClustersNodePoolsRollback* = Call_ContainerProjectsZonesClustersNodePoolsRollback_594394(
    name: "containerProjectsZonesClustersNodePoolsRollback",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}:rollback",
    validator: validate_ContainerProjectsZonesClustersNodePoolsRollback_594395,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsRollback_594396,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersResourceLabels_594418 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersResourceLabels_594420(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersResourceLabels_594419(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets labels on a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594421 = path.getOrDefault("zone")
  valid_594421 = validateParameter(valid_594421, JString, required = true,
                                 default = nil)
  if valid_594421 != nil:
    section.add "zone", valid_594421
  var valid_594422 = path.getOrDefault("projectId")
  valid_594422 = validateParameter(valid_594422, JString, required = true,
                                 default = nil)
  if valid_594422 != nil:
    section.add "projectId", valid_594422
  var valid_594423 = path.getOrDefault("clusterId")
  valid_594423 = validateParameter(valid_594423, JString, required = true,
                                 default = nil)
  if valid_594423 != nil:
    section.add "clusterId", valid_594423
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
  section = newJObject()
  var valid_594424 = query.getOrDefault("upload_protocol")
  valid_594424 = validateParameter(valid_594424, JString, required = false,
                                 default = nil)
  if valid_594424 != nil:
    section.add "upload_protocol", valid_594424
  var valid_594425 = query.getOrDefault("fields")
  valid_594425 = validateParameter(valid_594425, JString, required = false,
                                 default = nil)
  if valid_594425 != nil:
    section.add "fields", valid_594425
  var valid_594426 = query.getOrDefault("quotaUser")
  valid_594426 = validateParameter(valid_594426, JString, required = false,
                                 default = nil)
  if valid_594426 != nil:
    section.add "quotaUser", valid_594426
  var valid_594427 = query.getOrDefault("alt")
  valid_594427 = validateParameter(valid_594427, JString, required = false,
                                 default = newJString("json"))
  if valid_594427 != nil:
    section.add "alt", valid_594427
  var valid_594428 = query.getOrDefault("oauth_token")
  valid_594428 = validateParameter(valid_594428, JString, required = false,
                                 default = nil)
  if valid_594428 != nil:
    section.add "oauth_token", valid_594428
  var valid_594429 = query.getOrDefault("callback")
  valid_594429 = validateParameter(valid_594429, JString, required = false,
                                 default = nil)
  if valid_594429 != nil:
    section.add "callback", valid_594429
  var valid_594430 = query.getOrDefault("access_token")
  valid_594430 = validateParameter(valid_594430, JString, required = false,
                                 default = nil)
  if valid_594430 != nil:
    section.add "access_token", valid_594430
  var valid_594431 = query.getOrDefault("uploadType")
  valid_594431 = validateParameter(valid_594431, JString, required = false,
                                 default = nil)
  if valid_594431 != nil:
    section.add "uploadType", valid_594431
  var valid_594432 = query.getOrDefault("key")
  valid_594432 = validateParameter(valid_594432, JString, required = false,
                                 default = nil)
  if valid_594432 != nil:
    section.add "key", valid_594432
  var valid_594433 = query.getOrDefault("$.xgafv")
  valid_594433 = validateParameter(valid_594433, JString, required = false,
                                 default = newJString("1"))
  if valid_594433 != nil:
    section.add "$.xgafv", valid_594433
  var valid_594434 = query.getOrDefault("prettyPrint")
  valid_594434 = validateParameter(valid_594434, JBool, required = false,
                                 default = newJBool(true))
  if valid_594434 != nil:
    section.add "prettyPrint", valid_594434
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

proc call*(call_594436: Call_ContainerProjectsZonesClustersResourceLabels_594418;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets labels on a cluster.
  ## 
  let valid = call_594436.validator(path, query, header, formData, body)
  let scheme = call_594436.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594436.url(scheme.get, call_594436.host, call_594436.base,
                         call_594436.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594436, url, valid)

proc call*(call_594437: Call_ContainerProjectsZonesClustersResourceLabels_594418;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersResourceLabels
  ## Sets labels on a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  var path_594438 = newJObject()
  var query_594439 = newJObject()
  var body_594440 = newJObject()
  add(query_594439, "upload_protocol", newJString(uploadProtocol))
  add(path_594438, "zone", newJString(zone))
  add(query_594439, "fields", newJString(fields))
  add(query_594439, "quotaUser", newJString(quotaUser))
  add(query_594439, "alt", newJString(alt))
  add(query_594439, "oauth_token", newJString(oauthToken))
  add(query_594439, "callback", newJString(callback))
  add(query_594439, "access_token", newJString(accessToken))
  add(query_594439, "uploadType", newJString(uploadType))
  add(query_594439, "key", newJString(key))
  add(path_594438, "projectId", newJString(projectId))
  add(query_594439, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594440 = body
  add(query_594439, "prettyPrint", newJBool(prettyPrint))
  add(path_594438, "clusterId", newJString(clusterId))
  result = call_594437.call(path_594438, query_594439, nil, nil, body_594440)

var containerProjectsZonesClustersResourceLabels* = Call_ContainerProjectsZonesClustersResourceLabels_594418(
    name: "containerProjectsZonesClustersResourceLabels",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/resourceLabels",
    validator: validate_ContainerProjectsZonesClustersResourceLabels_594419,
    base: "/", url: url_ContainerProjectsZonesClustersResourceLabels_594420,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersCompleteIpRotation_594441 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersCompleteIpRotation_594443(
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
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersCompleteIpRotation_594442(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Completes master IP rotation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594444 = path.getOrDefault("zone")
  valid_594444 = validateParameter(valid_594444, JString, required = true,
                                 default = nil)
  if valid_594444 != nil:
    section.add "zone", valid_594444
  var valid_594445 = path.getOrDefault("projectId")
  valid_594445 = validateParameter(valid_594445, JString, required = true,
                                 default = nil)
  if valid_594445 != nil:
    section.add "projectId", valid_594445
  var valid_594446 = path.getOrDefault("clusterId")
  valid_594446 = validateParameter(valid_594446, JString, required = true,
                                 default = nil)
  if valid_594446 != nil:
    section.add "clusterId", valid_594446
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
  section = newJObject()
  var valid_594447 = query.getOrDefault("upload_protocol")
  valid_594447 = validateParameter(valid_594447, JString, required = false,
                                 default = nil)
  if valid_594447 != nil:
    section.add "upload_protocol", valid_594447
  var valid_594448 = query.getOrDefault("fields")
  valid_594448 = validateParameter(valid_594448, JString, required = false,
                                 default = nil)
  if valid_594448 != nil:
    section.add "fields", valid_594448
  var valid_594449 = query.getOrDefault("quotaUser")
  valid_594449 = validateParameter(valid_594449, JString, required = false,
                                 default = nil)
  if valid_594449 != nil:
    section.add "quotaUser", valid_594449
  var valid_594450 = query.getOrDefault("alt")
  valid_594450 = validateParameter(valid_594450, JString, required = false,
                                 default = newJString("json"))
  if valid_594450 != nil:
    section.add "alt", valid_594450
  var valid_594451 = query.getOrDefault("oauth_token")
  valid_594451 = validateParameter(valid_594451, JString, required = false,
                                 default = nil)
  if valid_594451 != nil:
    section.add "oauth_token", valid_594451
  var valid_594452 = query.getOrDefault("callback")
  valid_594452 = validateParameter(valid_594452, JString, required = false,
                                 default = nil)
  if valid_594452 != nil:
    section.add "callback", valid_594452
  var valid_594453 = query.getOrDefault("access_token")
  valid_594453 = validateParameter(valid_594453, JString, required = false,
                                 default = nil)
  if valid_594453 != nil:
    section.add "access_token", valid_594453
  var valid_594454 = query.getOrDefault("uploadType")
  valid_594454 = validateParameter(valid_594454, JString, required = false,
                                 default = nil)
  if valid_594454 != nil:
    section.add "uploadType", valid_594454
  var valid_594455 = query.getOrDefault("key")
  valid_594455 = validateParameter(valid_594455, JString, required = false,
                                 default = nil)
  if valid_594455 != nil:
    section.add "key", valid_594455
  var valid_594456 = query.getOrDefault("$.xgafv")
  valid_594456 = validateParameter(valid_594456, JString, required = false,
                                 default = newJString("1"))
  if valid_594456 != nil:
    section.add "$.xgafv", valid_594456
  var valid_594457 = query.getOrDefault("prettyPrint")
  valid_594457 = validateParameter(valid_594457, JBool, required = false,
                                 default = newJBool(true))
  if valid_594457 != nil:
    section.add "prettyPrint", valid_594457
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

proc call*(call_594459: Call_ContainerProjectsZonesClustersCompleteIpRotation_594441;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Completes master IP rotation.
  ## 
  let valid = call_594459.validator(path, query, header, formData, body)
  let scheme = call_594459.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594459.url(scheme.get, call_594459.host, call_594459.base,
                         call_594459.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594459, url, valid)

proc call*(call_594460: Call_ContainerProjectsZonesClustersCompleteIpRotation_594441;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersCompleteIpRotation
  ## Completes master IP rotation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  var path_594461 = newJObject()
  var query_594462 = newJObject()
  var body_594463 = newJObject()
  add(query_594462, "upload_protocol", newJString(uploadProtocol))
  add(path_594461, "zone", newJString(zone))
  add(query_594462, "fields", newJString(fields))
  add(query_594462, "quotaUser", newJString(quotaUser))
  add(query_594462, "alt", newJString(alt))
  add(query_594462, "oauth_token", newJString(oauthToken))
  add(query_594462, "callback", newJString(callback))
  add(query_594462, "access_token", newJString(accessToken))
  add(query_594462, "uploadType", newJString(uploadType))
  add(query_594462, "key", newJString(key))
  add(path_594461, "projectId", newJString(projectId))
  add(query_594462, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594463 = body
  add(query_594462, "prettyPrint", newJBool(prettyPrint))
  add(path_594461, "clusterId", newJString(clusterId))
  result = call_594460.call(path_594461, query_594462, nil, nil, body_594463)

var containerProjectsZonesClustersCompleteIpRotation* = Call_ContainerProjectsZonesClustersCompleteIpRotation_594441(
    name: "containerProjectsZonesClustersCompleteIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:completeIpRotation",
    validator: validate_ContainerProjectsZonesClustersCompleteIpRotation_594442,
    base: "/", url: url_ContainerProjectsZonesClustersCompleteIpRotation_594443,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersSetMaintenancePolicy_594464 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersSetMaintenancePolicy_594466(
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
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersSetMaintenancePolicy_594465(
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
  var valid_594467 = path.getOrDefault("zone")
  valid_594467 = validateParameter(valid_594467, JString, required = true,
                                 default = nil)
  if valid_594467 != nil:
    section.add "zone", valid_594467
  var valid_594468 = path.getOrDefault("projectId")
  valid_594468 = validateParameter(valid_594468, JString, required = true,
                                 default = nil)
  if valid_594468 != nil:
    section.add "projectId", valid_594468
  var valid_594469 = path.getOrDefault("clusterId")
  valid_594469 = validateParameter(valid_594469, JString, required = true,
                                 default = nil)
  if valid_594469 != nil:
    section.add "clusterId", valid_594469
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
  section = newJObject()
  var valid_594470 = query.getOrDefault("upload_protocol")
  valid_594470 = validateParameter(valid_594470, JString, required = false,
                                 default = nil)
  if valid_594470 != nil:
    section.add "upload_protocol", valid_594470
  var valid_594471 = query.getOrDefault("fields")
  valid_594471 = validateParameter(valid_594471, JString, required = false,
                                 default = nil)
  if valid_594471 != nil:
    section.add "fields", valid_594471
  var valid_594472 = query.getOrDefault("quotaUser")
  valid_594472 = validateParameter(valid_594472, JString, required = false,
                                 default = nil)
  if valid_594472 != nil:
    section.add "quotaUser", valid_594472
  var valid_594473 = query.getOrDefault("alt")
  valid_594473 = validateParameter(valid_594473, JString, required = false,
                                 default = newJString("json"))
  if valid_594473 != nil:
    section.add "alt", valid_594473
  var valid_594474 = query.getOrDefault("oauth_token")
  valid_594474 = validateParameter(valid_594474, JString, required = false,
                                 default = nil)
  if valid_594474 != nil:
    section.add "oauth_token", valid_594474
  var valid_594475 = query.getOrDefault("callback")
  valid_594475 = validateParameter(valid_594475, JString, required = false,
                                 default = nil)
  if valid_594475 != nil:
    section.add "callback", valid_594475
  var valid_594476 = query.getOrDefault("access_token")
  valid_594476 = validateParameter(valid_594476, JString, required = false,
                                 default = nil)
  if valid_594476 != nil:
    section.add "access_token", valid_594476
  var valid_594477 = query.getOrDefault("uploadType")
  valid_594477 = validateParameter(valid_594477, JString, required = false,
                                 default = nil)
  if valid_594477 != nil:
    section.add "uploadType", valid_594477
  var valid_594478 = query.getOrDefault("key")
  valid_594478 = validateParameter(valid_594478, JString, required = false,
                                 default = nil)
  if valid_594478 != nil:
    section.add "key", valid_594478
  var valid_594479 = query.getOrDefault("$.xgafv")
  valid_594479 = validateParameter(valid_594479, JString, required = false,
                                 default = newJString("1"))
  if valid_594479 != nil:
    section.add "$.xgafv", valid_594479
  var valid_594480 = query.getOrDefault("prettyPrint")
  valid_594480 = validateParameter(valid_594480, JBool, required = false,
                                 default = newJBool(true))
  if valid_594480 != nil:
    section.add "prettyPrint", valid_594480
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

proc call*(call_594482: Call_ContainerProjectsZonesClustersSetMaintenancePolicy_594464;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the maintenance policy for a cluster.
  ## 
  let valid = call_594482.validator(path, query, header, formData, body)
  let scheme = call_594482.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594482.url(scheme.get, call_594482.host, call_594482.base,
                         call_594482.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594482, url, valid)

proc call*(call_594483: Call_ContainerProjectsZonesClustersSetMaintenancePolicy_594464;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
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
  var path_594484 = newJObject()
  var query_594485 = newJObject()
  var body_594486 = newJObject()
  add(query_594485, "upload_protocol", newJString(uploadProtocol))
  add(path_594484, "zone", newJString(zone))
  add(query_594485, "fields", newJString(fields))
  add(query_594485, "quotaUser", newJString(quotaUser))
  add(query_594485, "alt", newJString(alt))
  add(query_594485, "oauth_token", newJString(oauthToken))
  add(query_594485, "callback", newJString(callback))
  add(query_594485, "access_token", newJString(accessToken))
  add(query_594485, "uploadType", newJString(uploadType))
  add(query_594485, "key", newJString(key))
  add(path_594484, "projectId", newJString(projectId))
  add(query_594485, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594486 = body
  add(query_594485, "prettyPrint", newJBool(prettyPrint))
  add(path_594484, "clusterId", newJString(clusterId))
  result = call_594483.call(path_594484, query_594485, nil, nil, body_594486)

var containerProjectsZonesClustersSetMaintenancePolicy* = Call_ContainerProjectsZonesClustersSetMaintenancePolicy_594464(
    name: "containerProjectsZonesClustersSetMaintenancePolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:setMaintenancePolicy",
    validator: validate_ContainerProjectsZonesClustersSetMaintenancePolicy_594465,
    base: "/", url: url_ContainerProjectsZonesClustersSetMaintenancePolicy_594466,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersSetMasterAuth_594487 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersSetMasterAuth_594489(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersSetMasterAuth_594488(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets master auth materials. Currently supports changing the admin password
  ## or a specific cluster, either via password generation or explicitly setting
  ## the password.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594490 = path.getOrDefault("zone")
  valid_594490 = validateParameter(valid_594490, JString, required = true,
                                 default = nil)
  if valid_594490 != nil:
    section.add "zone", valid_594490
  var valid_594491 = path.getOrDefault("projectId")
  valid_594491 = validateParameter(valid_594491, JString, required = true,
                                 default = nil)
  if valid_594491 != nil:
    section.add "projectId", valid_594491
  var valid_594492 = path.getOrDefault("clusterId")
  valid_594492 = validateParameter(valid_594492, JString, required = true,
                                 default = nil)
  if valid_594492 != nil:
    section.add "clusterId", valid_594492
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
  section = newJObject()
  var valid_594493 = query.getOrDefault("upload_protocol")
  valid_594493 = validateParameter(valid_594493, JString, required = false,
                                 default = nil)
  if valid_594493 != nil:
    section.add "upload_protocol", valid_594493
  var valid_594494 = query.getOrDefault("fields")
  valid_594494 = validateParameter(valid_594494, JString, required = false,
                                 default = nil)
  if valid_594494 != nil:
    section.add "fields", valid_594494
  var valid_594495 = query.getOrDefault("quotaUser")
  valid_594495 = validateParameter(valid_594495, JString, required = false,
                                 default = nil)
  if valid_594495 != nil:
    section.add "quotaUser", valid_594495
  var valid_594496 = query.getOrDefault("alt")
  valid_594496 = validateParameter(valid_594496, JString, required = false,
                                 default = newJString("json"))
  if valid_594496 != nil:
    section.add "alt", valid_594496
  var valid_594497 = query.getOrDefault("oauth_token")
  valid_594497 = validateParameter(valid_594497, JString, required = false,
                                 default = nil)
  if valid_594497 != nil:
    section.add "oauth_token", valid_594497
  var valid_594498 = query.getOrDefault("callback")
  valid_594498 = validateParameter(valid_594498, JString, required = false,
                                 default = nil)
  if valid_594498 != nil:
    section.add "callback", valid_594498
  var valid_594499 = query.getOrDefault("access_token")
  valid_594499 = validateParameter(valid_594499, JString, required = false,
                                 default = nil)
  if valid_594499 != nil:
    section.add "access_token", valid_594499
  var valid_594500 = query.getOrDefault("uploadType")
  valid_594500 = validateParameter(valid_594500, JString, required = false,
                                 default = nil)
  if valid_594500 != nil:
    section.add "uploadType", valid_594500
  var valid_594501 = query.getOrDefault("key")
  valid_594501 = validateParameter(valid_594501, JString, required = false,
                                 default = nil)
  if valid_594501 != nil:
    section.add "key", valid_594501
  var valid_594502 = query.getOrDefault("$.xgafv")
  valid_594502 = validateParameter(valid_594502, JString, required = false,
                                 default = newJString("1"))
  if valid_594502 != nil:
    section.add "$.xgafv", valid_594502
  var valid_594503 = query.getOrDefault("prettyPrint")
  valid_594503 = validateParameter(valid_594503, JBool, required = false,
                                 default = newJBool(true))
  if valid_594503 != nil:
    section.add "prettyPrint", valid_594503
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

proc call*(call_594505: Call_ContainerProjectsZonesClustersSetMasterAuth_594487;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets master auth materials. Currently supports changing the admin password
  ## or a specific cluster, either via password generation or explicitly setting
  ## the password.
  ## 
  let valid = call_594505.validator(path, query, header, formData, body)
  let scheme = call_594505.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594505.url(scheme.get, call_594505.host, call_594505.base,
                         call_594505.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594505, url, valid)

proc call*(call_594506: Call_ContainerProjectsZonesClustersSetMasterAuth_594487;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersSetMasterAuth
  ## Sets master auth materials. Currently supports changing the admin password
  ## or a specific cluster, either via password generation or explicitly setting
  ## the password.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  var path_594507 = newJObject()
  var query_594508 = newJObject()
  var body_594509 = newJObject()
  add(query_594508, "upload_protocol", newJString(uploadProtocol))
  add(path_594507, "zone", newJString(zone))
  add(query_594508, "fields", newJString(fields))
  add(query_594508, "quotaUser", newJString(quotaUser))
  add(query_594508, "alt", newJString(alt))
  add(query_594508, "oauth_token", newJString(oauthToken))
  add(query_594508, "callback", newJString(callback))
  add(query_594508, "access_token", newJString(accessToken))
  add(query_594508, "uploadType", newJString(uploadType))
  add(query_594508, "key", newJString(key))
  add(path_594507, "projectId", newJString(projectId))
  add(query_594508, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594509 = body
  add(query_594508, "prettyPrint", newJBool(prettyPrint))
  add(path_594507, "clusterId", newJString(clusterId))
  result = call_594506.call(path_594507, query_594508, nil, nil, body_594509)

var containerProjectsZonesClustersSetMasterAuth* = Call_ContainerProjectsZonesClustersSetMasterAuth_594487(
    name: "containerProjectsZonesClustersSetMasterAuth",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:setMasterAuth",
    validator: validate_ContainerProjectsZonesClustersSetMasterAuth_594488,
    base: "/", url: url_ContainerProjectsZonesClustersSetMasterAuth_594489,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersSetNetworkPolicy_594510 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersSetNetworkPolicy_594512(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersSetNetworkPolicy_594511(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Enables or disables Network Policy for a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594513 = path.getOrDefault("zone")
  valid_594513 = validateParameter(valid_594513, JString, required = true,
                                 default = nil)
  if valid_594513 != nil:
    section.add "zone", valid_594513
  var valid_594514 = path.getOrDefault("projectId")
  valid_594514 = validateParameter(valid_594514, JString, required = true,
                                 default = nil)
  if valid_594514 != nil:
    section.add "projectId", valid_594514
  var valid_594515 = path.getOrDefault("clusterId")
  valid_594515 = validateParameter(valid_594515, JString, required = true,
                                 default = nil)
  if valid_594515 != nil:
    section.add "clusterId", valid_594515
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
  section = newJObject()
  var valid_594516 = query.getOrDefault("upload_protocol")
  valid_594516 = validateParameter(valid_594516, JString, required = false,
                                 default = nil)
  if valid_594516 != nil:
    section.add "upload_protocol", valid_594516
  var valid_594517 = query.getOrDefault("fields")
  valid_594517 = validateParameter(valid_594517, JString, required = false,
                                 default = nil)
  if valid_594517 != nil:
    section.add "fields", valid_594517
  var valid_594518 = query.getOrDefault("quotaUser")
  valid_594518 = validateParameter(valid_594518, JString, required = false,
                                 default = nil)
  if valid_594518 != nil:
    section.add "quotaUser", valid_594518
  var valid_594519 = query.getOrDefault("alt")
  valid_594519 = validateParameter(valid_594519, JString, required = false,
                                 default = newJString("json"))
  if valid_594519 != nil:
    section.add "alt", valid_594519
  var valid_594520 = query.getOrDefault("oauth_token")
  valid_594520 = validateParameter(valid_594520, JString, required = false,
                                 default = nil)
  if valid_594520 != nil:
    section.add "oauth_token", valid_594520
  var valid_594521 = query.getOrDefault("callback")
  valid_594521 = validateParameter(valid_594521, JString, required = false,
                                 default = nil)
  if valid_594521 != nil:
    section.add "callback", valid_594521
  var valid_594522 = query.getOrDefault("access_token")
  valid_594522 = validateParameter(valid_594522, JString, required = false,
                                 default = nil)
  if valid_594522 != nil:
    section.add "access_token", valid_594522
  var valid_594523 = query.getOrDefault("uploadType")
  valid_594523 = validateParameter(valid_594523, JString, required = false,
                                 default = nil)
  if valid_594523 != nil:
    section.add "uploadType", valid_594523
  var valid_594524 = query.getOrDefault("key")
  valid_594524 = validateParameter(valid_594524, JString, required = false,
                                 default = nil)
  if valid_594524 != nil:
    section.add "key", valid_594524
  var valid_594525 = query.getOrDefault("$.xgafv")
  valid_594525 = validateParameter(valid_594525, JString, required = false,
                                 default = newJString("1"))
  if valid_594525 != nil:
    section.add "$.xgafv", valid_594525
  var valid_594526 = query.getOrDefault("prettyPrint")
  valid_594526 = validateParameter(valid_594526, JBool, required = false,
                                 default = newJBool(true))
  if valid_594526 != nil:
    section.add "prettyPrint", valid_594526
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

proc call*(call_594528: Call_ContainerProjectsZonesClustersSetNetworkPolicy_594510;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables or disables Network Policy for a cluster.
  ## 
  let valid = call_594528.validator(path, query, header, formData, body)
  let scheme = call_594528.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594528.url(scheme.get, call_594528.host, call_594528.base,
                         call_594528.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594528, url, valid)

proc call*(call_594529: Call_ContainerProjectsZonesClustersSetNetworkPolicy_594510;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersSetNetworkPolicy
  ## Enables or disables Network Policy for a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  var path_594530 = newJObject()
  var query_594531 = newJObject()
  var body_594532 = newJObject()
  add(query_594531, "upload_protocol", newJString(uploadProtocol))
  add(path_594530, "zone", newJString(zone))
  add(query_594531, "fields", newJString(fields))
  add(query_594531, "quotaUser", newJString(quotaUser))
  add(query_594531, "alt", newJString(alt))
  add(query_594531, "oauth_token", newJString(oauthToken))
  add(query_594531, "callback", newJString(callback))
  add(query_594531, "access_token", newJString(accessToken))
  add(query_594531, "uploadType", newJString(uploadType))
  add(query_594531, "key", newJString(key))
  add(path_594530, "projectId", newJString(projectId))
  add(query_594531, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594532 = body
  add(query_594531, "prettyPrint", newJBool(prettyPrint))
  add(path_594530, "clusterId", newJString(clusterId))
  result = call_594529.call(path_594530, query_594531, nil, nil, body_594532)

var containerProjectsZonesClustersSetNetworkPolicy* = Call_ContainerProjectsZonesClustersSetNetworkPolicy_594510(
    name: "containerProjectsZonesClustersSetNetworkPolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:setNetworkPolicy",
    validator: validate_ContainerProjectsZonesClustersSetNetworkPolicy_594511,
    base: "/", url: url_ContainerProjectsZonesClustersSetNetworkPolicy_594512,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersStartIpRotation_594533 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesClustersStartIpRotation_594535(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersStartIpRotation_594534(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Starts master IP rotation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594536 = path.getOrDefault("zone")
  valid_594536 = validateParameter(valid_594536, JString, required = true,
                                 default = nil)
  if valid_594536 != nil:
    section.add "zone", valid_594536
  var valid_594537 = path.getOrDefault("projectId")
  valid_594537 = validateParameter(valid_594537, JString, required = true,
                                 default = nil)
  if valid_594537 != nil:
    section.add "projectId", valid_594537
  var valid_594538 = path.getOrDefault("clusterId")
  valid_594538 = validateParameter(valid_594538, JString, required = true,
                                 default = nil)
  if valid_594538 != nil:
    section.add "clusterId", valid_594538
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
  section = newJObject()
  var valid_594539 = query.getOrDefault("upload_protocol")
  valid_594539 = validateParameter(valid_594539, JString, required = false,
                                 default = nil)
  if valid_594539 != nil:
    section.add "upload_protocol", valid_594539
  var valid_594540 = query.getOrDefault("fields")
  valid_594540 = validateParameter(valid_594540, JString, required = false,
                                 default = nil)
  if valid_594540 != nil:
    section.add "fields", valid_594540
  var valid_594541 = query.getOrDefault("quotaUser")
  valid_594541 = validateParameter(valid_594541, JString, required = false,
                                 default = nil)
  if valid_594541 != nil:
    section.add "quotaUser", valid_594541
  var valid_594542 = query.getOrDefault("alt")
  valid_594542 = validateParameter(valid_594542, JString, required = false,
                                 default = newJString("json"))
  if valid_594542 != nil:
    section.add "alt", valid_594542
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

proc call*(call_594551: Call_ContainerProjectsZonesClustersStartIpRotation_594533;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts master IP rotation.
  ## 
  let valid = call_594551.validator(path, query, header, formData, body)
  let scheme = call_594551.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594551.url(scheme.get, call_594551.host, call_594551.base,
                         call_594551.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594551, url, valid)

proc call*(call_594552: Call_ContainerProjectsZonesClustersStartIpRotation_594533;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersStartIpRotation
  ## Starts master IP rotation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  var path_594553 = newJObject()
  var query_594554 = newJObject()
  var body_594555 = newJObject()
  add(query_594554, "upload_protocol", newJString(uploadProtocol))
  add(path_594553, "zone", newJString(zone))
  add(query_594554, "fields", newJString(fields))
  add(query_594554, "quotaUser", newJString(quotaUser))
  add(query_594554, "alt", newJString(alt))
  add(query_594554, "oauth_token", newJString(oauthToken))
  add(query_594554, "callback", newJString(callback))
  add(query_594554, "access_token", newJString(accessToken))
  add(query_594554, "uploadType", newJString(uploadType))
  add(query_594554, "key", newJString(key))
  add(path_594553, "projectId", newJString(projectId))
  add(query_594554, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594555 = body
  add(query_594554, "prettyPrint", newJBool(prettyPrint))
  add(path_594553, "clusterId", newJString(clusterId))
  result = call_594552.call(path_594553, query_594554, nil, nil, body_594555)

var containerProjectsZonesClustersStartIpRotation* = Call_ContainerProjectsZonesClustersStartIpRotation_594533(
    name: "containerProjectsZonesClustersStartIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:startIpRotation",
    validator: validate_ContainerProjectsZonesClustersStartIpRotation_594534,
    base: "/", url: url_ContainerProjectsZonesClustersStartIpRotation_594535,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesOperationsList_594556 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesOperationsList_594558(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesOperationsList_594557(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all operations in a project in a specific zone or all zones.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) to return operations for, or `-` for
  ## all zones. This field has been deprecated and replaced by the parent field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the parent field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594559 = path.getOrDefault("zone")
  valid_594559 = validateParameter(valid_594559, JString, required = true,
                                 default = nil)
  if valid_594559 != nil:
    section.add "zone", valid_594559
  var valid_594560 = path.getOrDefault("projectId")
  valid_594560 = validateParameter(valid_594560, JString, required = true,
                                 default = nil)
  if valid_594560 != nil:
    section.add "projectId", valid_594560
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
  section = newJObject()
  var valid_594561 = query.getOrDefault("upload_protocol")
  valid_594561 = validateParameter(valid_594561, JString, required = false,
                                 default = nil)
  if valid_594561 != nil:
    section.add "upload_protocol", valid_594561
  var valid_594562 = query.getOrDefault("fields")
  valid_594562 = validateParameter(valid_594562, JString, required = false,
                                 default = nil)
  if valid_594562 != nil:
    section.add "fields", valid_594562
  var valid_594563 = query.getOrDefault("quotaUser")
  valid_594563 = validateParameter(valid_594563, JString, required = false,
                                 default = nil)
  if valid_594563 != nil:
    section.add "quotaUser", valid_594563
  var valid_594564 = query.getOrDefault("alt")
  valid_594564 = validateParameter(valid_594564, JString, required = false,
                                 default = newJString("json"))
  if valid_594564 != nil:
    section.add "alt", valid_594564
  var valid_594565 = query.getOrDefault("oauth_token")
  valid_594565 = validateParameter(valid_594565, JString, required = false,
                                 default = nil)
  if valid_594565 != nil:
    section.add "oauth_token", valid_594565
  var valid_594566 = query.getOrDefault("callback")
  valid_594566 = validateParameter(valid_594566, JString, required = false,
                                 default = nil)
  if valid_594566 != nil:
    section.add "callback", valid_594566
  var valid_594567 = query.getOrDefault("access_token")
  valid_594567 = validateParameter(valid_594567, JString, required = false,
                                 default = nil)
  if valid_594567 != nil:
    section.add "access_token", valid_594567
  var valid_594568 = query.getOrDefault("uploadType")
  valid_594568 = validateParameter(valid_594568, JString, required = false,
                                 default = nil)
  if valid_594568 != nil:
    section.add "uploadType", valid_594568
  var valid_594569 = query.getOrDefault("parent")
  valid_594569 = validateParameter(valid_594569, JString, required = false,
                                 default = nil)
  if valid_594569 != nil:
    section.add "parent", valid_594569
  var valid_594570 = query.getOrDefault("key")
  valid_594570 = validateParameter(valid_594570, JString, required = false,
                                 default = nil)
  if valid_594570 != nil:
    section.add "key", valid_594570
  var valid_594571 = query.getOrDefault("$.xgafv")
  valid_594571 = validateParameter(valid_594571, JString, required = false,
                                 default = newJString("1"))
  if valid_594571 != nil:
    section.add "$.xgafv", valid_594571
  var valid_594572 = query.getOrDefault("prettyPrint")
  valid_594572 = validateParameter(valid_594572, JBool, required = false,
                                 default = newJBool(true))
  if valid_594572 != nil:
    section.add "prettyPrint", valid_594572
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594573: Call_ContainerProjectsZonesOperationsList_594556;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all operations in a project in a specific zone or all zones.
  ## 
  let valid = call_594573.validator(path, query, header, formData, body)
  let scheme = call_594573.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594573.url(scheme.get, call_594573.host, call_594573.base,
                         call_594573.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594573, url, valid)

proc call*(call_594574: Call_ContainerProjectsZonesOperationsList_594556;
          zone: string; projectId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; parent: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesOperationsList
  ## Lists all operations in a project in a specific zone or all zones.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) to return operations for, or `-` for
  ## all zones. This field has been deprecated and replaced by the parent field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the parent field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594575 = newJObject()
  var query_594576 = newJObject()
  add(query_594576, "upload_protocol", newJString(uploadProtocol))
  add(path_594575, "zone", newJString(zone))
  add(query_594576, "fields", newJString(fields))
  add(query_594576, "quotaUser", newJString(quotaUser))
  add(query_594576, "alt", newJString(alt))
  add(query_594576, "oauth_token", newJString(oauthToken))
  add(query_594576, "callback", newJString(callback))
  add(query_594576, "access_token", newJString(accessToken))
  add(query_594576, "uploadType", newJString(uploadType))
  add(query_594576, "parent", newJString(parent))
  add(query_594576, "key", newJString(key))
  add(path_594575, "projectId", newJString(projectId))
  add(query_594576, "$.xgafv", newJString(Xgafv))
  add(query_594576, "prettyPrint", newJBool(prettyPrint))
  result = call_594574.call(path_594575, query_594576, nil, nil, nil)

var containerProjectsZonesOperationsList* = Call_ContainerProjectsZonesOperationsList_594556(
    name: "containerProjectsZonesOperationsList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/operations",
    validator: validate_ContainerProjectsZonesOperationsList_594557, base: "/",
    url: url_ContainerProjectsZonesOperationsList_594558, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesOperationsGet_594577 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesOperationsGet_594579(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesOperationsGet_594578(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   operationId: JString (required)
  ##              : Deprecated. The server-assigned `name` of the operation.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594580 = path.getOrDefault("zone")
  valid_594580 = validateParameter(valid_594580, JString, required = true,
                                 default = nil)
  if valid_594580 != nil:
    section.add "zone", valid_594580
  var valid_594581 = path.getOrDefault("projectId")
  valid_594581 = validateParameter(valid_594581, JString, required = true,
                                 default = nil)
  if valid_594581 != nil:
    section.add "projectId", valid_594581
  var valid_594582 = path.getOrDefault("operationId")
  valid_594582 = validateParameter(valid_594582, JString, required = true,
                                 default = nil)
  if valid_594582 != nil:
    section.add "operationId", valid_594582
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
  section = newJObject()
  var valid_594583 = query.getOrDefault("upload_protocol")
  valid_594583 = validateParameter(valid_594583, JString, required = false,
                                 default = nil)
  if valid_594583 != nil:
    section.add "upload_protocol", valid_594583
  var valid_594584 = query.getOrDefault("fields")
  valid_594584 = validateParameter(valid_594584, JString, required = false,
                                 default = nil)
  if valid_594584 != nil:
    section.add "fields", valid_594584
  var valid_594585 = query.getOrDefault("quotaUser")
  valid_594585 = validateParameter(valid_594585, JString, required = false,
                                 default = nil)
  if valid_594585 != nil:
    section.add "quotaUser", valid_594585
  var valid_594586 = query.getOrDefault("alt")
  valid_594586 = validateParameter(valid_594586, JString, required = false,
                                 default = newJString("json"))
  if valid_594586 != nil:
    section.add "alt", valid_594586
  var valid_594587 = query.getOrDefault("oauth_token")
  valid_594587 = validateParameter(valid_594587, JString, required = false,
                                 default = nil)
  if valid_594587 != nil:
    section.add "oauth_token", valid_594587
  var valid_594588 = query.getOrDefault("callback")
  valid_594588 = validateParameter(valid_594588, JString, required = false,
                                 default = nil)
  if valid_594588 != nil:
    section.add "callback", valid_594588
  var valid_594589 = query.getOrDefault("access_token")
  valid_594589 = validateParameter(valid_594589, JString, required = false,
                                 default = nil)
  if valid_594589 != nil:
    section.add "access_token", valid_594589
  var valid_594590 = query.getOrDefault("uploadType")
  valid_594590 = validateParameter(valid_594590, JString, required = false,
                                 default = nil)
  if valid_594590 != nil:
    section.add "uploadType", valid_594590
  var valid_594591 = query.getOrDefault("key")
  valid_594591 = validateParameter(valid_594591, JString, required = false,
                                 default = nil)
  if valid_594591 != nil:
    section.add "key", valid_594591
  var valid_594592 = query.getOrDefault("name")
  valid_594592 = validateParameter(valid_594592, JString, required = false,
                                 default = nil)
  if valid_594592 != nil:
    section.add "name", valid_594592
  var valid_594593 = query.getOrDefault("$.xgafv")
  valid_594593 = validateParameter(valid_594593, JString, required = false,
                                 default = newJString("1"))
  if valid_594593 != nil:
    section.add "$.xgafv", valid_594593
  var valid_594594 = query.getOrDefault("prettyPrint")
  valid_594594 = validateParameter(valid_594594, JBool, required = false,
                                 default = newJBool(true))
  if valid_594594 != nil:
    section.add "prettyPrint", valid_594594
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594595: Call_ContainerProjectsZonesOperationsGet_594577;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified operation.
  ## 
  let valid = call_594595.validator(path, query, header, formData, body)
  let scheme = call_594595.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594595.url(scheme.get, call_594595.host, call_594595.base,
                         call_594595.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594595, url, valid)

proc call*(call_594596: Call_ContainerProjectsZonesOperationsGet_594577;
          zone: string; projectId: string; operationId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          name: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesOperationsGet
  ## Gets the specified operation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   operationId: string (required)
  ##              : Deprecated. The server-assigned `name` of the operation.
  ## This field has been deprecated and replaced by the name field.
  var path_594597 = newJObject()
  var query_594598 = newJObject()
  add(query_594598, "upload_protocol", newJString(uploadProtocol))
  add(path_594597, "zone", newJString(zone))
  add(query_594598, "fields", newJString(fields))
  add(query_594598, "quotaUser", newJString(quotaUser))
  add(query_594598, "alt", newJString(alt))
  add(query_594598, "oauth_token", newJString(oauthToken))
  add(query_594598, "callback", newJString(callback))
  add(query_594598, "access_token", newJString(accessToken))
  add(query_594598, "uploadType", newJString(uploadType))
  add(query_594598, "key", newJString(key))
  add(query_594598, "name", newJString(name))
  add(path_594597, "projectId", newJString(projectId))
  add(query_594598, "$.xgafv", newJString(Xgafv))
  add(query_594598, "prettyPrint", newJBool(prettyPrint))
  add(path_594597, "operationId", newJString(operationId))
  result = call_594596.call(path_594597, query_594598, nil, nil, nil)

var containerProjectsZonesOperationsGet* = Call_ContainerProjectsZonesOperationsGet_594577(
    name: "containerProjectsZonesOperationsGet", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/operations/{operationId}",
    validator: validate_ContainerProjectsZonesOperationsGet_594578, base: "/",
    url: url_ContainerProjectsZonesOperationsGet_594579, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesOperationsCancel_594599 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesOperationsCancel_594601(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesOperationsCancel_594600(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels the specified operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the operation resides.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   operationId: JString (required)
  ##              : Deprecated. The server-assigned `name` of the operation.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594602 = path.getOrDefault("zone")
  valid_594602 = validateParameter(valid_594602, JString, required = true,
                                 default = nil)
  if valid_594602 != nil:
    section.add "zone", valid_594602
  var valid_594603 = path.getOrDefault("projectId")
  valid_594603 = validateParameter(valid_594603, JString, required = true,
                                 default = nil)
  if valid_594603 != nil:
    section.add "projectId", valid_594603
  var valid_594604 = path.getOrDefault("operationId")
  valid_594604 = validateParameter(valid_594604, JString, required = true,
                                 default = nil)
  if valid_594604 != nil:
    section.add "operationId", valid_594604
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
  section = newJObject()
  var valid_594605 = query.getOrDefault("upload_protocol")
  valid_594605 = validateParameter(valid_594605, JString, required = false,
                                 default = nil)
  if valid_594605 != nil:
    section.add "upload_protocol", valid_594605
  var valid_594606 = query.getOrDefault("fields")
  valid_594606 = validateParameter(valid_594606, JString, required = false,
                                 default = nil)
  if valid_594606 != nil:
    section.add "fields", valid_594606
  var valid_594607 = query.getOrDefault("quotaUser")
  valid_594607 = validateParameter(valid_594607, JString, required = false,
                                 default = nil)
  if valid_594607 != nil:
    section.add "quotaUser", valid_594607
  var valid_594608 = query.getOrDefault("alt")
  valid_594608 = validateParameter(valid_594608, JString, required = false,
                                 default = newJString("json"))
  if valid_594608 != nil:
    section.add "alt", valid_594608
  var valid_594609 = query.getOrDefault("oauth_token")
  valid_594609 = validateParameter(valid_594609, JString, required = false,
                                 default = nil)
  if valid_594609 != nil:
    section.add "oauth_token", valid_594609
  var valid_594610 = query.getOrDefault("callback")
  valid_594610 = validateParameter(valid_594610, JString, required = false,
                                 default = nil)
  if valid_594610 != nil:
    section.add "callback", valid_594610
  var valid_594611 = query.getOrDefault("access_token")
  valid_594611 = validateParameter(valid_594611, JString, required = false,
                                 default = nil)
  if valid_594611 != nil:
    section.add "access_token", valid_594611
  var valid_594612 = query.getOrDefault("uploadType")
  valid_594612 = validateParameter(valid_594612, JString, required = false,
                                 default = nil)
  if valid_594612 != nil:
    section.add "uploadType", valid_594612
  var valid_594613 = query.getOrDefault("key")
  valid_594613 = validateParameter(valid_594613, JString, required = false,
                                 default = nil)
  if valid_594613 != nil:
    section.add "key", valid_594613
  var valid_594614 = query.getOrDefault("$.xgafv")
  valid_594614 = validateParameter(valid_594614, JString, required = false,
                                 default = newJString("1"))
  if valid_594614 != nil:
    section.add "$.xgafv", valid_594614
  var valid_594615 = query.getOrDefault("prettyPrint")
  valid_594615 = validateParameter(valid_594615, JBool, required = false,
                                 default = newJBool(true))
  if valid_594615 != nil:
    section.add "prettyPrint", valid_594615
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

proc call*(call_594617: Call_ContainerProjectsZonesOperationsCancel_594599;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels the specified operation.
  ## 
  let valid = call_594617.validator(path, query, header, formData, body)
  let scheme = call_594617.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594617.url(scheme.get, call_594617.host, call_594617.base,
                         call_594617.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594617, url, valid)

proc call*(call_594618: Call_ContainerProjectsZonesOperationsCancel_594599;
          zone: string; projectId: string; operationId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesOperationsCancel
  ## Cancels the specified operation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the operation resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   operationId: string (required)
  ##              : Deprecated. The server-assigned `name` of the operation.
  ## This field has been deprecated and replaced by the name field.
  var path_594619 = newJObject()
  var query_594620 = newJObject()
  var body_594621 = newJObject()
  add(query_594620, "upload_protocol", newJString(uploadProtocol))
  add(path_594619, "zone", newJString(zone))
  add(query_594620, "fields", newJString(fields))
  add(query_594620, "quotaUser", newJString(quotaUser))
  add(query_594620, "alt", newJString(alt))
  add(query_594620, "oauth_token", newJString(oauthToken))
  add(query_594620, "callback", newJString(callback))
  add(query_594620, "access_token", newJString(accessToken))
  add(query_594620, "uploadType", newJString(uploadType))
  add(query_594620, "key", newJString(key))
  add(path_594619, "projectId", newJString(projectId))
  add(query_594620, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594621 = body
  add(query_594620, "prettyPrint", newJBool(prettyPrint))
  add(path_594619, "operationId", newJString(operationId))
  result = call_594618.call(path_594619, query_594620, nil, nil, body_594621)

var containerProjectsZonesOperationsCancel* = Call_ContainerProjectsZonesOperationsCancel_594599(
    name: "containerProjectsZonesOperationsCancel", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/operations/{operationId}:cancel",
    validator: validate_ContainerProjectsZonesOperationsCancel_594600, base: "/",
    url: url_ContainerProjectsZonesOperationsCancel_594601,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesGetServerconfig_594622 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsZonesGetServerconfig_594624(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/serverconfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesGetServerconfig_594623(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns configuration info about the Google Kubernetes Engine service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) to return operations for.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594625 = path.getOrDefault("zone")
  valid_594625 = validateParameter(valid_594625, JString, required = true,
                                 default = nil)
  if valid_594625 != nil:
    section.add "zone", valid_594625
  var valid_594626 = path.getOrDefault("projectId")
  valid_594626 = validateParameter(valid_594626, JString, required = true,
                                 default = nil)
  if valid_594626 != nil:
    section.add "projectId", valid_594626
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
  ##       : The name (project and location) of the server config to get,
  ## specified in the format 'projects/*/locations/*'.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594627 = query.getOrDefault("upload_protocol")
  valid_594627 = validateParameter(valid_594627, JString, required = false,
                                 default = nil)
  if valid_594627 != nil:
    section.add "upload_protocol", valid_594627
  var valid_594628 = query.getOrDefault("fields")
  valid_594628 = validateParameter(valid_594628, JString, required = false,
                                 default = nil)
  if valid_594628 != nil:
    section.add "fields", valid_594628
  var valid_594629 = query.getOrDefault("quotaUser")
  valid_594629 = validateParameter(valid_594629, JString, required = false,
                                 default = nil)
  if valid_594629 != nil:
    section.add "quotaUser", valid_594629
  var valid_594630 = query.getOrDefault("alt")
  valid_594630 = validateParameter(valid_594630, JString, required = false,
                                 default = newJString("json"))
  if valid_594630 != nil:
    section.add "alt", valid_594630
  var valid_594631 = query.getOrDefault("oauth_token")
  valid_594631 = validateParameter(valid_594631, JString, required = false,
                                 default = nil)
  if valid_594631 != nil:
    section.add "oauth_token", valid_594631
  var valid_594632 = query.getOrDefault("callback")
  valid_594632 = validateParameter(valid_594632, JString, required = false,
                                 default = nil)
  if valid_594632 != nil:
    section.add "callback", valid_594632
  var valid_594633 = query.getOrDefault("access_token")
  valid_594633 = validateParameter(valid_594633, JString, required = false,
                                 default = nil)
  if valid_594633 != nil:
    section.add "access_token", valid_594633
  var valid_594634 = query.getOrDefault("uploadType")
  valid_594634 = validateParameter(valid_594634, JString, required = false,
                                 default = nil)
  if valid_594634 != nil:
    section.add "uploadType", valid_594634
  var valid_594635 = query.getOrDefault("key")
  valid_594635 = validateParameter(valid_594635, JString, required = false,
                                 default = nil)
  if valid_594635 != nil:
    section.add "key", valid_594635
  var valid_594636 = query.getOrDefault("name")
  valid_594636 = validateParameter(valid_594636, JString, required = false,
                                 default = nil)
  if valid_594636 != nil:
    section.add "name", valid_594636
  var valid_594637 = query.getOrDefault("$.xgafv")
  valid_594637 = validateParameter(valid_594637, JString, required = false,
                                 default = newJString("1"))
  if valid_594637 != nil:
    section.add "$.xgafv", valid_594637
  var valid_594638 = query.getOrDefault("prettyPrint")
  valid_594638 = validateParameter(valid_594638, JBool, required = false,
                                 default = newJBool(true))
  if valid_594638 != nil:
    section.add "prettyPrint", valid_594638
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594639: Call_ContainerProjectsZonesGetServerconfig_594622;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns configuration info about the Google Kubernetes Engine service.
  ## 
  let valid = call_594639.validator(path, query, header, formData, body)
  let scheme = call_594639.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594639.url(scheme.get, call_594639.host, call_594639.base,
                         call_594639.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594639, url, valid)

proc call*(call_594640: Call_ContainerProjectsZonesGetServerconfig_594622;
          zone: string; projectId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; name: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesGetServerconfig
  ## Returns configuration info about the Google Kubernetes Engine service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) to return operations for.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##       : The name (project and location) of the server config to get,
  ## specified in the format 'projects/*/locations/*'.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594641 = newJObject()
  var query_594642 = newJObject()
  add(query_594642, "upload_protocol", newJString(uploadProtocol))
  add(path_594641, "zone", newJString(zone))
  add(query_594642, "fields", newJString(fields))
  add(query_594642, "quotaUser", newJString(quotaUser))
  add(query_594642, "alt", newJString(alt))
  add(query_594642, "oauth_token", newJString(oauthToken))
  add(query_594642, "callback", newJString(callback))
  add(query_594642, "access_token", newJString(accessToken))
  add(query_594642, "uploadType", newJString(uploadType))
  add(query_594642, "key", newJString(key))
  add(query_594642, "name", newJString(name))
  add(path_594641, "projectId", newJString(projectId))
  add(query_594642, "$.xgafv", newJString(Xgafv))
  add(query_594642, "prettyPrint", newJBool(prettyPrint))
  result = call_594640.call(path_594641, query_594642, nil, nil, nil)

var containerProjectsZonesGetServerconfig* = Call_ContainerProjectsZonesGetServerconfig_594622(
    name: "containerProjectsZonesGetServerconfig", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/serverconfig",
    validator: validate_ContainerProjectsZonesGetServerconfig_594623, base: "/",
    url: url_ContainerProjectsZonesGetServerconfig_594624, schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsUpdate_594666 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersNodePoolsUpdate_594668(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsUpdate_594667(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates the version and/or image type for the specified node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster, node pool) of the node pool to
  ## update. Specified in the format
  ## 'projects/*/locations/*/clusters/*/nodePools/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594669 = path.getOrDefault("name")
  valid_594669 = validateParameter(valid_594669, JString, required = true,
                                 default = nil)
  if valid_594669 != nil:
    section.add "name", valid_594669
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
  section = newJObject()
  var valid_594670 = query.getOrDefault("upload_protocol")
  valid_594670 = validateParameter(valid_594670, JString, required = false,
                                 default = nil)
  if valid_594670 != nil:
    section.add "upload_protocol", valid_594670
  var valid_594671 = query.getOrDefault("fields")
  valid_594671 = validateParameter(valid_594671, JString, required = false,
                                 default = nil)
  if valid_594671 != nil:
    section.add "fields", valid_594671
  var valid_594672 = query.getOrDefault("quotaUser")
  valid_594672 = validateParameter(valid_594672, JString, required = false,
                                 default = nil)
  if valid_594672 != nil:
    section.add "quotaUser", valid_594672
  var valid_594673 = query.getOrDefault("alt")
  valid_594673 = validateParameter(valid_594673, JString, required = false,
                                 default = newJString("json"))
  if valid_594673 != nil:
    section.add "alt", valid_594673
  var valid_594674 = query.getOrDefault("oauth_token")
  valid_594674 = validateParameter(valid_594674, JString, required = false,
                                 default = nil)
  if valid_594674 != nil:
    section.add "oauth_token", valid_594674
  var valid_594675 = query.getOrDefault("callback")
  valid_594675 = validateParameter(valid_594675, JString, required = false,
                                 default = nil)
  if valid_594675 != nil:
    section.add "callback", valid_594675
  var valid_594676 = query.getOrDefault("access_token")
  valid_594676 = validateParameter(valid_594676, JString, required = false,
                                 default = nil)
  if valid_594676 != nil:
    section.add "access_token", valid_594676
  var valid_594677 = query.getOrDefault("uploadType")
  valid_594677 = validateParameter(valid_594677, JString, required = false,
                                 default = nil)
  if valid_594677 != nil:
    section.add "uploadType", valid_594677
  var valid_594678 = query.getOrDefault("key")
  valid_594678 = validateParameter(valid_594678, JString, required = false,
                                 default = nil)
  if valid_594678 != nil:
    section.add "key", valid_594678
  var valid_594679 = query.getOrDefault("$.xgafv")
  valid_594679 = validateParameter(valid_594679, JString, required = false,
                                 default = newJString("1"))
  if valid_594679 != nil:
    section.add "$.xgafv", valid_594679
  var valid_594680 = query.getOrDefault("prettyPrint")
  valid_594680 = validateParameter(valid_594680, JBool, required = false,
                                 default = newJBool(true))
  if valid_594680 != nil:
    section.add "prettyPrint", valid_594680
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

proc call*(call_594682: Call_ContainerProjectsLocationsClustersNodePoolsUpdate_594666;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the version and/or image type for the specified node pool.
  ## 
  let valid = call_594682.validator(path, query, header, formData, body)
  let scheme = call_594682.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594682.url(scheme.get, call_594682.host, call_594682.base,
                         call_594682.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594682, url, valid)

proc call*(call_594683: Call_ContainerProjectsLocationsClustersNodePoolsUpdate_594666;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containerProjectsLocationsClustersNodePoolsUpdate
  ## Updates the version and/or image type for the specified node pool.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster, node pool) of the node pool to
  ## update. Specified in the format
  ## 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   alt: string
  ##      : Data format for response.
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
  var path_594684 = newJObject()
  var query_594685 = newJObject()
  var body_594686 = newJObject()
  add(query_594685, "upload_protocol", newJString(uploadProtocol))
  add(query_594685, "fields", newJString(fields))
  add(query_594685, "quotaUser", newJString(quotaUser))
  add(path_594684, "name", newJString(name))
  add(query_594685, "alt", newJString(alt))
  add(query_594685, "oauth_token", newJString(oauthToken))
  add(query_594685, "callback", newJString(callback))
  add(query_594685, "access_token", newJString(accessToken))
  add(query_594685, "uploadType", newJString(uploadType))
  add(query_594685, "key", newJString(key))
  add(query_594685, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594686 = body
  add(query_594685, "prettyPrint", newJBool(prettyPrint))
  result = call_594683.call(path_594684, query_594685, nil, nil, body_594686)

var containerProjectsLocationsClustersNodePoolsUpdate* = Call_ContainerProjectsLocationsClustersNodePoolsUpdate_594666(
    name: "containerProjectsLocationsClustersNodePoolsUpdate",
    meth: HttpMethod.HttpPut, host: "container.googleapis.com", route: "/v1/{name}",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsUpdate_594667,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsUpdate_594668,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsGet_594643 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersNodePoolsGet_594645(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsGet_594644(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieves the requested node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster, node pool id) of the node pool to
  ## get. Specified in the format
  ## 'projects/*/locations/*/clusters/*/nodePools/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594646 = path.getOrDefault("name")
  valid_594646 = validateParameter(valid_594646, JString, required = true,
                                 default = nil)
  if valid_594646 != nil:
    section.add "name", valid_594646
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
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: JString
  ##             : Deprecated. The name of the node pool.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: JString
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: JString
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  var valid_594647 = query.getOrDefault("upload_protocol")
  valid_594647 = validateParameter(valid_594647, JString, required = false,
                                 default = nil)
  if valid_594647 != nil:
    section.add "upload_protocol", valid_594647
  var valid_594648 = query.getOrDefault("fields")
  valid_594648 = validateParameter(valid_594648, JString, required = false,
                                 default = nil)
  if valid_594648 != nil:
    section.add "fields", valid_594648
  var valid_594649 = query.getOrDefault("quotaUser")
  valid_594649 = validateParameter(valid_594649, JString, required = false,
                                 default = nil)
  if valid_594649 != nil:
    section.add "quotaUser", valid_594649
  var valid_594650 = query.getOrDefault("alt")
  valid_594650 = validateParameter(valid_594650, JString, required = false,
                                 default = newJString("json"))
  if valid_594650 != nil:
    section.add "alt", valid_594650
  var valid_594651 = query.getOrDefault("oauth_token")
  valid_594651 = validateParameter(valid_594651, JString, required = false,
                                 default = nil)
  if valid_594651 != nil:
    section.add "oauth_token", valid_594651
  var valid_594652 = query.getOrDefault("callback")
  valid_594652 = validateParameter(valid_594652, JString, required = false,
                                 default = nil)
  if valid_594652 != nil:
    section.add "callback", valid_594652
  var valid_594653 = query.getOrDefault("access_token")
  valid_594653 = validateParameter(valid_594653, JString, required = false,
                                 default = nil)
  if valid_594653 != nil:
    section.add "access_token", valid_594653
  var valid_594654 = query.getOrDefault("uploadType")
  valid_594654 = validateParameter(valid_594654, JString, required = false,
                                 default = nil)
  if valid_594654 != nil:
    section.add "uploadType", valid_594654
  var valid_594655 = query.getOrDefault("nodePoolId")
  valid_594655 = validateParameter(valid_594655, JString, required = false,
                                 default = nil)
  if valid_594655 != nil:
    section.add "nodePoolId", valid_594655
  var valid_594656 = query.getOrDefault("zone")
  valid_594656 = validateParameter(valid_594656, JString, required = false,
                                 default = nil)
  if valid_594656 != nil:
    section.add "zone", valid_594656
  var valid_594657 = query.getOrDefault("key")
  valid_594657 = validateParameter(valid_594657, JString, required = false,
                                 default = nil)
  if valid_594657 != nil:
    section.add "key", valid_594657
  var valid_594658 = query.getOrDefault("$.xgafv")
  valid_594658 = validateParameter(valid_594658, JString, required = false,
                                 default = newJString("1"))
  if valid_594658 != nil:
    section.add "$.xgafv", valid_594658
  var valid_594659 = query.getOrDefault("projectId")
  valid_594659 = validateParameter(valid_594659, JString, required = false,
                                 default = nil)
  if valid_594659 != nil:
    section.add "projectId", valid_594659
  var valid_594660 = query.getOrDefault("prettyPrint")
  valid_594660 = validateParameter(valid_594660, JBool, required = false,
                                 default = newJBool(true))
  if valid_594660 != nil:
    section.add "prettyPrint", valid_594660
  var valid_594661 = query.getOrDefault("clusterId")
  valid_594661 = validateParameter(valid_594661, JString, required = false,
                                 default = nil)
  if valid_594661 != nil:
    section.add "clusterId", valid_594661
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594662: Call_ContainerProjectsLocationsClustersNodePoolsGet_594643;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the requested node pool.
  ## 
  let valid = call_594662.validator(path, query, header, formData, body)
  let scheme = call_594662.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594662.url(scheme.get, call_594662.host, call_594662.base,
                         call_594662.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594662, url, valid)

proc call*(call_594663: Call_ContainerProjectsLocationsClustersNodePoolsGet_594643;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          nodePoolId: string = ""; zone: string = ""; key: string = ""; Xgafv: string = "1";
          projectId: string = ""; prettyPrint: bool = true; clusterId: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsGet
  ## Retrieves the requested node pool.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster, node pool id) of the node pool to
  ## get. Specified in the format
  ## 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: string
  ##             : Deprecated. The name of the node pool.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: string
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  var path_594664 = newJObject()
  var query_594665 = newJObject()
  add(query_594665, "upload_protocol", newJString(uploadProtocol))
  add(query_594665, "fields", newJString(fields))
  add(query_594665, "quotaUser", newJString(quotaUser))
  add(path_594664, "name", newJString(name))
  add(query_594665, "alt", newJString(alt))
  add(query_594665, "oauth_token", newJString(oauthToken))
  add(query_594665, "callback", newJString(callback))
  add(query_594665, "access_token", newJString(accessToken))
  add(query_594665, "uploadType", newJString(uploadType))
  add(query_594665, "nodePoolId", newJString(nodePoolId))
  add(query_594665, "zone", newJString(zone))
  add(query_594665, "key", newJString(key))
  add(query_594665, "$.xgafv", newJString(Xgafv))
  add(query_594665, "projectId", newJString(projectId))
  add(query_594665, "prettyPrint", newJBool(prettyPrint))
  add(query_594665, "clusterId", newJString(clusterId))
  result = call_594663.call(path_594664, query_594665, nil, nil, nil)

var containerProjectsLocationsClustersNodePoolsGet* = Call_ContainerProjectsLocationsClustersNodePoolsGet_594643(
    name: "containerProjectsLocationsClustersNodePoolsGet",
    meth: HttpMethod.HttpGet, host: "container.googleapis.com", route: "/v1/{name}",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsGet_594644,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsGet_594645,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsDelete_594687 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersNodePoolsDelete_594689(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsDelete_594688(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes a node pool from a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster, node pool id) of the node pool to
  ## delete. Specified in the format
  ## 'projects/*/locations/*/clusters/*/nodePools/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594690 = path.getOrDefault("name")
  valid_594690 = validateParameter(valid_594690, JString, required = true,
                                 default = nil)
  if valid_594690 != nil:
    section.add "name", valid_594690
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
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: JString
  ##             : Deprecated. The name of the node pool to delete.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: JString
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: JString
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  var valid_594691 = query.getOrDefault("upload_protocol")
  valid_594691 = validateParameter(valid_594691, JString, required = false,
                                 default = nil)
  if valid_594691 != nil:
    section.add "upload_protocol", valid_594691
  var valid_594692 = query.getOrDefault("fields")
  valid_594692 = validateParameter(valid_594692, JString, required = false,
                                 default = nil)
  if valid_594692 != nil:
    section.add "fields", valid_594692
  var valid_594693 = query.getOrDefault("quotaUser")
  valid_594693 = validateParameter(valid_594693, JString, required = false,
                                 default = nil)
  if valid_594693 != nil:
    section.add "quotaUser", valid_594693
  var valid_594694 = query.getOrDefault("alt")
  valid_594694 = validateParameter(valid_594694, JString, required = false,
                                 default = newJString("json"))
  if valid_594694 != nil:
    section.add "alt", valid_594694
  var valid_594695 = query.getOrDefault("oauth_token")
  valid_594695 = validateParameter(valid_594695, JString, required = false,
                                 default = nil)
  if valid_594695 != nil:
    section.add "oauth_token", valid_594695
  var valid_594696 = query.getOrDefault("callback")
  valid_594696 = validateParameter(valid_594696, JString, required = false,
                                 default = nil)
  if valid_594696 != nil:
    section.add "callback", valid_594696
  var valid_594697 = query.getOrDefault("access_token")
  valid_594697 = validateParameter(valid_594697, JString, required = false,
                                 default = nil)
  if valid_594697 != nil:
    section.add "access_token", valid_594697
  var valid_594698 = query.getOrDefault("uploadType")
  valid_594698 = validateParameter(valid_594698, JString, required = false,
                                 default = nil)
  if valid_594698 != nil:
    section.add "uploadType", valid_594698
  var valid_594699 = query.getOrDefault("nodePoolId")
  valid_594699 = validateParameter(valid_594699, JString, required = false,
                                 default = nil)
  if valid_594699 != nil:
    section.add "nodePoolId", valid_594699
  var valid_594700 = query.getOrDefault("zone")
  valid_594700 = validateParameter(valid_594700, JString, required = false,
                                 default = nil)
  if valid_594700 != nil:
    section.add "zone", valid_594700
  var valid_594701 = query.getOrDefault("key")
  valid_594701 = validateParameter(valid_594701, JString, required = false,
                                 default = nil)
  if valid_594701 != nil:
    section.add "key", valid_594701
  var valid_594702 = query.getOrDefault("$.xgafv")
  valid_594702 = validateParameter(valid_594702, JString, required = false,
                                 default = newJString("1"))
  if valid_594702 != nil:
    section.add "$.xgafv", valid_594702
  var valid_594703 = query.getOrDefault("projectId")
  valid_594703 = validateParameter(valid_594703, JString, required = false,
                                 default = nil)
  if valid_594703 != nil:
    section.add "projectId", valid_594703
  var valid_594704 = query.getOrDefault("prettyPrint")
  valid_594704 = validateParameter(valid_594704, JBool, required = false,
                                 default = newJBool(true))
  if valid_594704 != nil:
    section.add "prettyPrint", valid_594704
  var valid_594705 = query.getOrDefault("clusterId")
  valid_594705 = validateParameter(valid_594705, JString, required = false,
                                 default = nil)
  if valid_594705 != nil:
    section.add "clusterId", valid_594705
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594706: Call_ContainerProjectsLocationsClustersNodePoolsDelete_594687;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a node pool from a cluster.
  ## 
  let valid = call_594706.validator(path, query, header, formData, body)
  let scheme = call_594706.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594706.url(scheme.get, call_594706.host, call_594706.base,
                         call_594706.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594706, url, valid)

proc call*(call_594707: Call_ContainerProjectsLocationsClustersNodePoolsDelete_594687;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          nodePoolId: string = ""; zone: string = ""; key: string = ""; Xgafv: string = "1";
          projectId: string = ""; prettyPrint: bool = true; clusterId: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsDelete
  ## Deletes a node pool from a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster, node pool id) of the node pool to
  ## delete. Specified in the format
  ## 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: string
  ##             : Deprecated. The name of the node pool to delete.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: string
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  var path_594708 = newJObject()
  var query_594709 = newJObject()
  add(query_594709, "upload_protocol", newJString(uploadProtocol))
  add(query_594709, "fields", newJString(fields))
  add(query_594709, "quotaUser", newJString(quotaUser))
  add(path_594708, "name", newJString(name))
  add(query_594709, "alt", newJString(alt))
  add(query_594709, "oauth_token", newJString(oauthToken))
  add(query_594709, "callback", newJString(callback))
  add(query_594709, "access_token", newJString(accessToken))
  add(query_594709, "uploadType", newJString(uploadType))
  add(query_594709, "nodePoolId", newJString(nodePoolId))
  add(query_594709, "zone", newJString(zone))
  add(query_594709, "key", newJString(key))
  add(query_594709, "$.xgafv", newJString(Xgafv))
  add(query_594709, "projectId", newJString(projectId))
  add(query_594709, "prettyPrint", newJBool(prettyPrint))
  add(query_594709, "clusterId", newJString(clusterId))
  result = call_594707.call(path_594708, query_594709, nil, nil, nil)

var containerProjectsLocationsClustersNodePoolsDelete* = Call_ContainerProjectsLocationsClustersNodePoolsDelete_594687(
    name: "containerProjectsLocationsClustersNodePoolsDelete",
    meth: HttpMethod.HttpDelete, host: "container.googleapis.com",
    route: "/v1/{name}",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsDelete_594688,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsDelete_594689,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsGetServerConfig_594710 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsGetServerConfig_594712(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/serverConfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsGetServerConfig_594711(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns configuration info about the Google Kubernetes Engine service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project and location) of the server config to get,
  ## specified in the format 'projects/*/locations/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594713 = path.getOrDefault("name")
  valid_594713 = validateParameter(valid_594713, JString, required = true,
                                 default = nil)
  if valid_594713 != nil:
    section.add "name", valid_594713
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
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   zone: JString
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) to return operations for.
  ## This field has been deprecated and replaced by the name field.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594714 = query.getOrDefault("upload_protocol")
  valid_594714 = validateParameter(valid_594714, JString, required = false,
                                 default = nil)
  if valid_594714 != nil:
    section.add "upload_protocol", valid_594714
  var valid_594715 = query.getOrDefault("fields")
  valid_594715 = validateParameter(valid_594715, JString, required = false,
                                 default = nil)
  if valid_594715 != nil:
    section.add "fields", valid_594715
  var valid_594716 = query.getOrDefault("quotaUser")
  valid_594716 = validateParameter(valid_594716, JString, required = false,
                                 default = nil)
  if valid_594716 != nil:
    section.add "quotaUser", valid_594716
  var valid_594717 = query.getOrDefault("alt")
  valid_594717 = validateParameter(valid_594717, JString, required = false,
                                 default = newJString("json"))
  if valid_594717 != nil:
    section.add "alt", valid_594717
  var valid_594718 = query.getOrDefault("oauth_token")
  valid_594718 = validateParameter(valid_594718, JString, required = false,
                                 default = nil)
  if valid_594718 != nil:
    section.add "oauth_token", valid_594718
  var valid_594719 = query.getOrDefault("callback")
  valid_594719 = validateParameter(valid_594719, JString, required = false,
                                 default = nil)
  if valid_594719 != nil:
    section.add "callback", valid_594719
  var valid_594720 = query.getOrDefault("access_token")
  valid_594720 = validateParameter(valid_594720, JString, required = false,
                                 default = nil)
  if valid_594720 != nil:
    section.add "access_token", valid_594720
  var valid_594721 = query.getOrDefault("uploadType")
  valid_594721 = validateParameter(valid_594721, JString, required = false,
                                 default = nil)
  if valid_594721 != nil:
    section.add "uploadType", valid_594721
  var valid_594722 = query.getOrDefault("zone")
  valid_594722 = validateParameter(valid_594722, JString, required = false,
                                 default = nil)
  if valid_594722 != nil:
    section.add "zone", valid_594722
  var valid_594723 = query.getOrDefault("key")
  valid_594723 = validateParameter(valid_594723, JString, required = false,
                                 default = nil)
  if valid_594723 != nil:
    section.add "key", valid_594723
  var valid_594724 = query.getOrDefault("$.xgafv")
  valid_594724 = validateParameter(valid_594724, JString, required = false,
                                 default = newJString("1"))
  if valid_594724 != nil:
    section.add "$.xgafv", valid_594724
  var valid_594725 = query.getOrDefault("projectId")
  valid_594725 = validateParameter(valid_594725, JString, required = false,
                                 default = nil)
  if valid_594725 != nil:
    section.add "projectId", valid_594725
  var valid_594726 = query.getOrDefault("prettyPrint")
  valid_594726 = validateParameter(valid_594726, JBool, required = false,
                                 default = newJBool(true))
  if valid_594726 != nil:
    section.add "prettyPrint", valid_594726
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594727: Call_ContainerProjectsLocationsGetServerConfig_594710;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns configuration info about the Google Kubernetes Engine service.
  ## 
  let valid = call_594727.validator(path, query, header, formData, body)
  let scheme = call_594727.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594727.url(scheme.get, call_594727.host, call_594727.base,
                         call_594727.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594727, url, valid)

proc call*(call_594728: Call_ContainerProjectsLocationsGetServerConfig_594710;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          zone: string = ""; key: string = ""; Xgafv: string = "1"; projectId: string = "";
          prettyPrint: bool = true): Recallable =
  ## containerProjectsLocationsGetServerConfig
  ## Returns configuration info about the Google Kubernetes Engine service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project and location) of the server config to get,
  ## specified in the format 'projects/*/locations/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   zone: string
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) to return operations for.
  ## This field has been deprecated and replaced by the name field.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594729 = newJObject()
  var query_594730 = newJObject()
  add(query_594730, "upload_protocol", newJString(uploadProtocol))
  add(query_594730, "fields", newJString(fields))
  add(query_594730, "quotaUser", newJString(quotaUser))
  add(path_594729, "name", newJString(name))
  add(query_594730, "alt", newJString(alt))
  add(query_594730, "oauth_token", newJString(oauthToken))
  add(query_594730, "callback", newJString(callback))
  add(query_594730, "access_token", newJString(accessToken))
  add(query_594730, "uploadType", newJString(uploadType))
  add(query_594730, "zone", newJString(zone))
  add(query_594730, "key", newJString(key))
  add(query_594730, "$.xgafv", newJString(Xgafv))
  add(query_594730, "projectId", newJString(projectId))
  add(query_594730, "prettyPrint", newJBool(prettyPrint))
  result = call_594728.call(path_594729, query_594730, nil, nil, nil)

var containerProjectsLocationsGetServerConfig* = Call_ContainerProjectsLocationsGetServerConfig_594710(
    name: "containerProjectsLocationsGetServerConfig", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1/{name}/serverConfig",
    validator: validate_ContainerProjectsLocationsGetServerConfig_594711,
    base: "/", url: url_ContainerProjectsLocationsGetServerConfig_594712,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsOperationsCancel_594731 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsOperationsCancel_594733(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsOperationsCancel_594732(path: JsonNode;
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
  var valid_594734 = path.getOrDefault("name")
  valid_594734 = validateParameter(valid_594734, JString, required = true,
                                 default = nil)
  if valid_594734 != nil:
    section.add "name", valid_594734
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
  section = newJObject()
  var valid_594735 = query.getOrDefault("upload_protocol")
  valid_594735 = validateParameter(valid_594735, JString, required = false,
                                 default = nil)
  if valid_594735 != nil:
    section.add "upload_protocol", valid_594735
  var valid_594736 = query.getOrDefault("fields")
  valid_594736 = validateParameter(valid_594736, JString, required = false,
                                 default = nil)
  if valid_594736 != nil:
    section.add "fields", valid_594736
  var valid_594737 = query.getOrDefault("quotaUser")
  valid_594737 = validateParameter(valid_594737, JString, required = false,
                                 default = nil)
  if valid_594737 != nil:
    section.add "quotaUser", valid_594737
  var valid_594738 = query.getOrDefault("alt")
  valid_594738 = validateParameter(valid_594738, JString, required = false,
                                 default = newJString("json"))
  if valid_594738 != nil:
    section.add "alt", valid_594738
  var valid_594739 = query.getOrDefault("oauth_token")
  valid_594739 = validateParameter(valid_594739, JString, required = false,
                                 default = nil)
  if valid_594739 != nil:
    section.add "oauth_token", valid_594739
  var valid_594740 = query.getOrDefault("callback")
  valid_594740 = validateParameter(valid_594740, JString, required = false,
                                 default = nil)
  if valid_594740 != nil:
    section.add "callback", valid_594740
  var valid_594741 = query.getOrDefault("access_token")
  valid_594741 = validateParameter(valid_594741, JString, required = false,
                                 default = nil)
  if valid_594741 != nil:
    section.add "access_token", valid_594741
  var valid_594742 = query.getOrDefault("uploadType")
  valid_594742 = validateParameter(valid_594742, JString, required = false,
                                 default = nil)
  if valid_594742 != nil:
    section.add "uploadType", valid_594742
  var valid_594743 = query.getOrDefault("key")
  valid_594743 = validateParameter(valid_594743, JString, required = false,
                                 default = nil)
  if valid_594743 != nil:
    section.add "key", valid_594743
  var valid_594744 = query.getOrDefault("$.xgafv")
  valid_594744 = validateParameter(valid_594744, JString, required = false,
                                 default = newJString("1"))
  if valid_594744 != nil:
    section.add "$.xgafv", valid_594744
  var valid_594745 = query.getOrDefault("prettyPrint")
  valid_594745 = validateParameter(valid_594745, JBool, required = false,
                                 default = newJBool(true))
  if valid_594745 != nil:
    section.add "prettyPrint", valid_594745
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

proc call*(call_594747: Call_ContainerProjectsLocationsOperationsCancel_594731;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels the specified operation.
  ## 
  let valid = call_594747.validator(path, query, header, formData, body)
  let scheme = call_594747.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594747.url(scheme.get, call_594747.host, call_594747.base,
                         call_594747.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594747, url, valid)

proc call*(call_594748: Call_ContainerProjectsLocationsOperationsCancel_594731;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  var path_594749 = newJObject()
  var query_594750 = newJObject()
  var body_594751 = newJObject()
  add(query_594750, "upload_protocol", newJString(uploadProtocol))
  add(query_594750, "fields", newJString(fields))
  add(query_594750, "quotaUser", newJString(quotaUser))
  add(path_594749, "name", newJString(name))
  add(query_594750, "alt", newJString(alt))
  add(query_594750, "oauth_token", newJString(oauthToken))
  add(query_594750, "callback", newJString(callback))
  add(query_594750, "access_token", newJString(accessToken))
  add(query_594750, "uploadType", newJString(uploadType))
  add(query_594750, "key", newJString(key))
  add(query_594750, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594751 = body
  add(query_594750, "prettyPrint", newJBool(prettyPrint))
  result = call_594748.call(path_594749, query_594750, nil, nil, body_594751)

var containerProjectsLocationsOperationsCancel* = Call_ContainerProjectsLocationsOperationsCancel_594731(
    name: "containerProjectsLocationsOperationsCancel", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_ContainerProjectsLocationsOperationsCancel_594732,
    base: "/", url: url_ContainerProjectsLocationsOperationsCancel_594733,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersCompleteIpRotation_594752 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersCompleteIpRotation_594754(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":completeIpRotation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersCompleteIpRotation_594753(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Completes master IP rotation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster id) of the cluster to complete IP
  ## rotation. Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594755 = path.getOrDefault("name")
  valid_594755 = validateParameter(valid_594755, JString, required = true,
                                 default = nil)
  if valid_594755 != nil:
    section.add "name", valid_594755
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
  section = newJObject()
  var valid_594756 = query.getOrDefault("upload_protocol")
  valid_594756 = validateParameter(valid_594756, JString, required = false,
                                 default = nil)
  if valid_594756 != nil:
    section.add "upload_protocol", valid_594756
  var valid_594757 = query.getOrDefault("fields")
  valid_594757 = validateParameter(valid_594757, JString, required = false,
                                 default = nil)
  if valid_594757 != nil:
    section.add "fields", valid_594757
  var valid_594758 = query.getOrDefault("quotaUser")
  valid_594758 = validateParameter(valid_594758, JString, required = false,
                                 default = nil)
  if valid_594758 != nil:
    section.add "quotaUser", valid_594758
  var valid_594759 = query.getOrDefault("alt")
  valid_594759 = validateParameter(valid_594759, JString, required = false,
                                 default = newJString("json"))
  if valid_594759 != nil:
    section.add "alt", valid_594759
  var valid_594760 = query.getOrDefault("oauth_token")
  valid_594760 = validateParameter(valid_594760, JString, required = false,
                                 default = nil)
  if valid_594760 != nil:
    section.add "oauth_token", valid_594760
  var valid_594761 = query.getOrDefault("callback")
  valid_594761 = validateParameter(valid_594761, JString, required = false,
                                 default = nil)
  if valid_594761 != nil:
    section.add "callback", valid_594761
  var valid_594762 = query.getOrDefault("access_token")
  valid_594762 = validateParameter(valid_594762, JString, required = false,
                                 default = nil)
  if valid_594762 != nil:
    section.add "access_token", valid_594762
  var valid_594763 = query.getOrDefault("uploadType")
  valid_594763 = validateParameter(valid_594763, JString, required = false,
                                 default = nil)
  if valid_594763 != nil:
    section.add "uploadType", valid_594763
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
  var valid_594766 = query.getOrDefault("prettyPrint")
  valid_594766 = validateParameter(valid_594766, JBool, required = false,
                                 default = newJBool(true))
  if valid_594766 != nil:
    section.add "prettyPrint", valid_594766
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

proc call*(call_594768: Call_ContainerProjectsLocationsClustersCompleteIpRotation_594752;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Completes master IP rotation.
  ## 
  let valid = call_594768.validator(path, query, header, formData, body)
  let scheme = call_594768.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594768.url(scheme.get, call_594768.host, call_594768.base,
                         call_594768.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594768, url, valid)

proc call*(call_594769: Call_ContainerProjectsLocationsClustersCompleteIpRotation_594752;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containerProjectsLocationsClustersCompleteIpRotation
  ## Completes master IP rotation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster id) of the cluster to complete IP
  ## rotation. Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   alt: string
  ##      : Data format for response.
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
  var path_594770 = newJObject()
  var query_594771 = newJObject()
  var body_594772 = newJObject()
  add(query_594771, "upload_protocol", newJString(uploadProtocol))
  add(query_594771, "fields", newJString(fields))
  add(query_594771, "quotaUser", newJString(quotaUser))
  add(path_594770, "name", newJString(name))
  add(query_594771, "alt", newJString(alt))
  add(query_594771, "oauth_token", newJString(oauthToken))
  add(query_594771, "callback", newJString(callback))
  add(query_594771, "access_token", newJString(accessToken))
  add(query_594771, "uploadType", newJString(uploadType))
  add(query_594771, "key", newJString(key))
  add(query_594771, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594772 = body
  add(query_594771, "prettyPrint", newJBool(prettyPrint))
  result = call_594769.call(path_594770, query_594771, nil, nil, body_594772)

var containerProjectsLocationsClustersCompleteIpRotation* = Call_ContainerProjectsLocationsClustersCompleteIpRotation_594752(
    name: "containerProjectsLocationsClustersCompleteIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:completeIpRotation",
    validator: validate_ContainerProjectsLocationsClustersCompleteIpRotation_594753,
    base: "/", url: url_ContainerProjectsLocationsClustersCompleteIpRotation_594754,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsRollback_594773 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersNodePoolsRollback_594775(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":rollback")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsRollback_594774(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Rolls back a previously Aborted or Failed NodePool upgrade.
  ## This makes no changes if the last upgrade successfully completed.
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
  var valid_594781 = query.getOrDefault("oauth_token")
  valid_594781 = validateParameter(valid_594781, JString, required = false,
                                 default = nil)
  if valid_594781 != nil:
    section.add "oauth_token", valid_594781
  var valid_594782 = query.getOrDefault("callback")
  valid_594782 = validateParameter(valid_594782, JString, required = false,
                                 default = nil)
  if valid_594782 != nil:
    section.add "callback", valid_594782
  var valid_594783 = query.getOrDefault("access_token")
  valid_594783 = validateParameter(valid_594783, JString, required = false,
                                 default = nil)
  if valid_594783 != nil:
    section.add "access_token", valid_594783
  var valid_594784 = query.getOrDefault("uploadType")
  valid_594784 = validateParameter(valid_594784, JString, required = false,
                                 default = nil)
  if valid_594784 != nil:
    section.add "uploadType", valid_594784
  var valid_594785 = query.getOrDefault("key")
  valid_594785 = validateParameter(valid_594785, JString, required = false,
                                 default = nil)
  if valid_594785 != nil:
    section.add "key", valid_594785
  var valid_594786 = query.getOrDefault("$.xgafv")
  valid_594786 = validateParameter(valid_594786, JString, required = false,
                                 default = newJString("1"))
  if valid_594786 != nil:
    section.add "$.xgafv", valid_594786
  var valid_594787 = query.getOrDefault("prettyPrint")
  valid_594787 = validateParameter(valid_594787, JBool, required = false,
                                 default = newJBool(true))
  if valid_594787 != nil:
    section.add "prettyPrint", valid_594787
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

proc call*(call_594789: Call_ContainerProjectsLocationsClustersNodePoolsRollback_594773;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rolls back a previously Aborted or Failed NodePool upgrade.
  ## This makes no changes if the last upgrade successfully completed.
  ## 
  let valid = call_594789.validator(path, query, header, formData, body)
  let scheme = call_594789.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594789.url(scheme.get, call_594789.host, call_594789.base,
                         call_594789.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594789, url, valid)

proc call*(call_594790: Call_ContainerProjectsLocationsClustersNodePoolsRollback_594773;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containerProjectsLocationsClustersNodePoolsRollback
  ## Rolls back a previously Aborted or Failed NodePool upgrade.
  ## This makes no changes if the last upgrade successfully completed.
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
  var path_594791 = newJObject()
  var query_594792 = newJObject()
  var body_594793 = newJObject()
  add(query_594792, "upload_protocol", newJString(uploadProtocol))
  add(query_594792, "fields", newJString(fields))
  add(query_594792, "quotaUser", newJString(quotaUser))
  add(path_594791, "name", newJString(name))
  add(query_594792, "alt", newJString(alt))
  add(query_594792, "oauth_token", newJString(oauthToken))
  add(query_594792, "callback", newJString(callback))
  add(query_594792, "access_token", newJString(accessToken))
  add(query_594792, "uploadType", newJString(uploadType))
  add(query_594792, "key", newJString(key))
  add(query_594792, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594793 = body
  add(query_594792, "prettyPrint", newJBool(prettyPrint))
  result = call_594790.call(path_594791, query_594792, nil, nil, body_594793)

var containerProjectsLocationsClustersNodePoolsRollback* = Call_ContainerProjectsLocationsClustersNodePoolsRollback_594773(
    name: "containerProjectsLocationsClustersNodePoolsRollback",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:rollback",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsRollback_594774,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsRollback_594775,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetAddons_594794 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersSetAddons_594796(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setAddons")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetAddons_594795(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the addons for a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster) of the cluster to set addons.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594797 = path.getOrDefault("name")
  valid_594797 = validateParameter(valid_594797, JString, required = true,
                                 default = nil)
  if valid_594797 != nil:
    section.add "name", valid_594797
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
  section = newJObject()
  var valid_594798 = query.getOrDefault("upload_protocol")
  valid_594798 = validateParameter(valid_594798, JString, required = false,
                                 default = nil)
  if valid_594798 != nil:
    section.add "upload_protocol", valid_594798
  var valid_594799 = query.getOrDefault("fields")
  valid_594799 = validateParameter(valid_594799, JString, required = false,
                                 default = nil)
  if valid_594799 != nil:
    section.add "fields", valid_594799
  var valid_594800 = query.getOrDefault("quotaUser")
  valid_594800 = validateParameter(valid_594800, JString, required = false,
                                 default = nil)
  if valid_594800 != nil:
    section.add "quotaUser", valid_594800
  var valid_594801 = query.getOrDefault("alt")
  valid_594801 = validateParameter(valid_594801, JString, required = false,
                                 default = newJString("json"))
  if valid_594801 != nil:
    section.add "alt", valid_594801
  var valid_594802 = query.getOrDefault("oauth_token")
  valid_594802 = validateParameter(valid_594802, JString, required = false,
                                 default = nil)
  if valid_594802 != nil:
    section.add "oauth_token", valid_594802
  var valid_594803 = query.getOrDefault("callback")
  valid_594803 = validateParameter(valid_594803, JString, required = false,
                                 default = nil)
  if valid_594803 != nil:
    section.add "callback", valid_594803
  var valid_594804 = query.getOrDefault("access_token")
  valid_594804 = validateParameter(valid_594804, JString, required = false,
                                 default = nil)
  if valid_594804 != nil:
    section.add "access_token", valid_594804
  var valid_594805 = query.getOrDefault("uploadType")
  valid_594805 = validateParameter(valid_594805, JString, required = false,
                                 default = nil)
  if valid_594805 != nil:
    section.add "uploadType", valid_594805
  var valid_594806 = query.getOrDefault("key")
  valid_594806 = validateParameter(valid_594806, JString, required = false,
                                 default = nil)
  if valid_594806 != nil:
    section.add "key", valid_594806
  var valid_594807 = query.getOrDefault("$.xgafv")
  valid_594807 = validateParameter(valid_594807, JString, required = false,
                                 default = newJString("1"))
  if valid_594807 != nil:
    section.add "$.xgafv", valid_594807
  var valid_594808 = query.getOrDefault("prettyPrint")
  valid_594808 = validateParameter(valid_594808, JBool, required = false,
                                 default = newJBool(true))
  if valid_594808 != nil:
    section.add "prettyPrint", valid_594808
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

proc call*(call_594810: Call_ContainerProjectsLocationsClustersSetAddons_594794;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the addons for a specific cluster.
  ## 
  let valid = call_594810.validator(path, query, header, formData, body)
  let scheme = call_594810.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594810.url(scheme.get, call_594810.host, call_594810.base,
                         call_594810.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594810, url, valid)

proc call*(call_594811: Call_ContainerProjectsLocationsClustersSetAddons_594794;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containerProjectsLocationsClustersSetAddons
  ## Sets the addons for a specific cluster.
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
  var path_594812 = newJObject()
  var query_594813 = newJObject()
  var body_594814 = newJObject()
  add(query_594813, "upload_protocol", newJString(uploadProtocol))
  add(query_594813, "fields", newJString(fields))
  add(query_594813, "quotaUser", newJString(quotaUser))
  add(path_594812, "name", newJString(name))
  add(query_594813, "alt", newJString(alt))
  add(query_594813, "oauth_token", newJString(oauthToken))
  add(query_594813, "callback", newJString(callback))
  add(query_594813, "access_token", newJString(accessToken))
  add(query_594813, "uploadType", newJString(uploadType))
  add(query_594813, "key", newJString(key))
  add(query_594813, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594814 = body
  add(query_594813, "prettyPrint", newJBool(prettyPrint))
  result = call_594811.call(path_594812, query_594813, nil, nil, body_594814)

var containerProjectsLocationsClustersSetAddons* = Call_ContainerProjectsLocationsClustersSetAddons_594794(
    name: "containerProjectsLocationsClustersSetAddons",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setAddons",
    validator: validate_ContainerProjectsLocationsClustersSetAddons_594795,
    base: "/", url: url_ContainerProjectsLocationsClustersSetAddons_594796,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_594815 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_594817(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setAutoscaling")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_594816(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the autoscaling settings for the specified node pool.
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
  var valid_594818 = path.getOrDefault("name")
  valid_594818 = validateParameter(valid_594818, JString, required = true,
                                 default = nil)
  if valid_594818 != nil:
    section.add "name", valid_594818
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
  section = newJObject()
  var valid_594819 = query.getOrDefault("upload_protocol")
  valid_594819 = validateParameter(valid_594819, JString, required = false,
                                 default = nil)
  if valid_594819 != nil:
    section.add "upload_protocol", valid_594819
  var valid_594820 = query.getOrDefault("fields")
  valid_594820 = validateParameter(valid_594820, JString, required = false,
                                 default = nil)
  if valid_594820 != nil:
    section.add "fields", valid_594820
  var valid_594821 = query.getOrDefault("quotaUser")
  valid_594821 = validateParameter(valid_594821, JString, required = false,
                                 default = nil)
  if valid_594821 != nil:
    section.add "quotaUser", valid_594821
  var valid_594822 = query.getOrDefault("alt")
  valid_594822 = validateParameter(valid_594822, JString, required = false,
                                 default = newJString("json"))
  if valid_594822 != nil:
    section.add "alt", valid_594822
  var valid_594823 = query.getOrDefault("oauth_token")
  valid_594823 = validateParameter(valid_594823, JString, required = false,
                                 default = nil)
  if valid_594823 != nil:
    section.add "oauth_token", valid_594823
  var valid_594824 = query.getOrDefault("callback")
  valid_594824 = validateParameter(valid_594824, JString, required = false,
                                 default = nil)
  if valid_594824 != nil:
    section.add "callback", valid_594824
  var valid_594825 = query.getOrDefault("access_token")
  valid_594825 = validateParameter(valid_594825, JString, required = false,
                                 default = nil)
  if valid_594825 != nil:
    section.add "access_token", valid_594825
  var valid_594826 = query.getOrDefault("uploadType")
  valid_594826 = validateParameter(valid_594826, JString, required = false,
                                 default = nil)
  if valid_594826 != nil:
    section.add "uploadType", valid_594826
  var valid_594827 = query.getOrDefault("key")
  valid_594827 = validateParameter(valid_594827, JString, required = false,
                                 default = nil)
  if valid_594827 != nil:
    section.add "key", valid_594827
  var valid_594828 = query.getOrDefault("$.xgafv")
  valid_594828 = validateParameter(valid_594828, JString, required = false,
                                 default = newJString("1"))
  if valid_594828 != nil:
    section.add "$.xgafv", valid_594828
  var valid_594829 = query.getOrDefault("prettyPrint")
  valid_594829 = validateParameter(valid_594829, JBool, required = false,
                                 default = newJBool(true))
  if valid_594829 != nil:
    section.add "prettyPrint", valid_594829
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

proc call*(call_594831: Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_594815;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the autoscaling settings for the specified node pool.
  ## 
  let valid = call_594831.validator(path, query, header, formData, body)
  let scheme = call_594831.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594831.url(scheme.get, call_594831.host, call_594831.base,
                         call_594831.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594831, url, valid)

proc call*(call_594832: Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_594815;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containerProjectsLocationsClustersNodePoolsSetAutoscaling
  ## Sets the autoscaling settings for the specified node pool.
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
  var path_594833 = newJObject()
  var query_594834 = newJObject()
  var body_594835 = newJObject()
  add(query_594834, "upload_protocol", newJString(uploadProtocol))
  add(query_594834, "fields", newJString(fields))
  add(query_594834, "quotaUser", newJString(quotaUser))
  add(path_594833, "name", newJString(name))
  add(query_594834, "alt", newJString(alt))
  add(query_594834, "oauth_token", newJString(oauthToken))
  add(query_594834, "callback", newJString(callback))
  add(query_594834, "access_token", newJString(accessToken))
  add(query_594834, "uploadType", newJString(uploadType))
  add(query_594834, "key", newJString(key))
  add(query_594834, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594835 = body
  add(query_594834, "prettyPrint", newJBool(prettyPrint))
  result = call_594832.call(path_594833, query_594834, nil, nil, body_594835)

var containerProjectsLocationsClustersNodePoolsSetAutoscaling* = Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_594815(
    name: "containerProjectsLocationsClustersNodePoolsSetAutoscaling",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setAutoscaling", validator: validate_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_594816,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_594817,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetLegacyAbac_594836 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersSetLegacyAbac_594838(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setLegacyAbac")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetLegacyAbac_594837(
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
  var valid_594839 = path.getOrDefault("name")
  valid_594839 = validateParameter(valid_594839, JString, required = true,
                                 default = nil)
  if valid_594839 != nil:
    section.add "name", valid_594839
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
  section = newJObject()
  var valid_594840 = query.getOrDefault("upload_protocol")
  valid_594840 = validateParameter(valid_594840, JString, required = false,
                                 default = nil)
  if valid_594840 != nil:
    section.add "upload_protocol", valid_594840
  var valid_594841 = query.getOrDefault("fields")
  valid_594841 = validateParameter(valid_594841, JString, required = false,
                                 default = nil)
  if valid_594841 != nil:
    section.add "fields", valid_594841
  var valid_594842 = query.getOrDefault("quotaUser")
  valid_594842 = validateParameter(valid_594842, JString, required = false,
                                 default = nil)
  if valid_594842 != nil:
    section.add "quotaUser", valid_594842
  var valid_594843 = query.getOrDefault("alt")
  valid_594843 = validateParameter(valid_594843, JString, required = false,
                                 default = newJString("json"))
  if valid_594843 != nil:
    section.add "alt", valid_594843
  var valid_594844 = query.getOrDefault("oauth_token")
  valid_594844 = validateParameter(valid_594844, JString, required = false,
                                 default = nil)
  if valid_594844 != nil:
    section.add "oauth_token", valid_594844
  var valid_594845 = query.getOrDefault("callback")
  valid_594845 = validateParameter(valid_594845, JString, required = false,
                                 default = nil)
  if valid_594845 != nil:
    section.add "callback", valid_594845
  var valid_594846 = query.getOrDefault("access_token")
  valid_594846 = validateParameter(valid_594846, JString, required = false,
                                 default = nil)
  if valid_594846 != nil:
    section.add "access_token", valid_594846
  var valid_594847 = query.getOrDefault("uploadType")
  valid_594847 = validateParameter(valid_594847, JString, required = false,
                                 default = nil)
  if valid_594847 != nil:
    section.add "uploadType", valid_594847
  var valid_594848 = query.getOrDefault("key")
  valid_594848 = validateParameter(valid_594848, JString, required = false,
                                 default = nil)
  if valid_594848 != nil:
    section.add "key", valid_594848
  var valid_594849 = query.getOrDefault("$.xgafv")
  valid_594849 = validateParameter(valid_594849, JString, required = false,
                                 default = newJString("1"))
  if valid_594849 != nil:
    section.add "$.xgafv", valid_594849
  var valid_594850 = query.getOrDefault("prettyPrint")
  valid_594850 = validateParameter(valid_594850, JBool, required = false,
                                 default = newJBool(true))
  if valid_594850 != nil:
    section.add "prettyPrint", valid_594850
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

proc call*(call_594852: Call_ContainerProjectsLocationsClustersSetLegacyAbac_594836;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ## 
  let valid = call_594852.validator(path, query, header, formData, body)
  let scheme = call_594852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594852.url(scheme.get, call_594852.host, call_594852.base,
                         call_594852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594852, url, valid)

proc call*(call_594853: Call_ContainerProjectsLocationsClustersSetLegacyAbac_594836;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  var path_594854 = newJObject()
  var query_594855 = newJObject()
  var body_594856 = newJObject()
  add(query_594855, "upload_protocol", newJString(uploadProtocol))
  add(query_594855, "fields", newJString(fields))
  add(query_594855, "quotaUser", newJString(quotaUser))
  add(path_594854, "name", newJString(name))
  add(query_594855, "alt", newJString(alt))
  add(query_594855, "oauth_token", newJString(oauthToken))
  add(query_594855, "callback", newJString(callback))
  add(query_594855, "access_token", newJString(accessToken))
  add(query_594855, "uploadType", newJString(uploadType))
  add(query_594855, "key", newJString(key))
  add(query_594855, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594856 = body
  add(query_594855, "prettyPrint", newJBool(prettyPrint))
  result = call_594853.call(path_594854, query_594855, nil, nil, body_594856)

var containerProjectsLocationsClustersSetLegacyAbac* = Call_ContainerProjectsLocationsClustersSetLegacyAbac_594836(
    name: "containerProjectsLocationsClustersSetLegacyAbac",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setLegacyAbac",
    validator: validate_ContainerProjectsLocationsClustersSetLegacyAbac_594837,
    base: "/", url: url_ContainerProjectsLocationsClustersSetLegacyAbac_594838,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetLocations_594857 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersSetLocations_594859(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setLocations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetLocations_594858(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the locations for a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster) of the cluster to set locations.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594860 = path.getOrDefault("name")
  valid_594860 = validateParameter(valid_594860, JString, required = true,
                                 default = nil)
  if valid_594860 != nil:
    section.add "name", valid_594860
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
  section = newJObject()
  var valid_594861 = query.getOrDefault("upload_protocol")
  valid_594861 = validateParameter(valid_594861, JString, required = false,
                                 default = nil)
  if valid_594861 != nil:
    section.add "upload_protocol", valid_594861
  var valid_594862 = query.getOrDefault("fields")
  valid_594862 = validateParameter(valid_594862, JString, required = false,
                                 default = nil)
  if valid_594862 != nil:
    section.add "fields", valid_594862
  var valid_594863 = query.getOrDefault("quotaUser")
  valid_594863 = validateParameter(valid_594863, JString, required = false,
                                 default = nil)
  if valid_594863 != nil:
    section.add "quotaUser", valid_594863
  var valid_594864 = query.getOrDefault("alt")
  valid_594864 = validateParameter(valid_594864, JString, required = false,
                                 default = newJString("json"))
  if valid_594864 != nil:
    section.add "alt", valid_594864
  var valid_594865 = query.getOrDefault("oauth_token")
  valid_594865 = validateParameter(valid_594865, JString, required = false,
                                 default = nil)
  if valid_594865 != nil:
    section.add "oauth_token", valid_594865
  var valid_594866 = query.getOrDefault("callback")
  valid_594866 = validateParameter(valid_594866, JString, required = false,
                                 default = nil)
  if valid_594866 != nil:
    section.add "callback", valid_594866
  var valid_594867 = query.getOrDefault("access_token")
  valid_594867 = validateParameter(valid_594867, JString, required = false,
                                 default = nil)
  if valid_594867 != nil:
    section.add "access_token", valid_594867
  var valid_594868 = query.getOrDefault("uploadType")
  valid_594868 = validateParameter(valid_594868, JString, required = false,
                                 default = nil)
  if valid_594868 != nil:
    section.add "uploadType", valid_594868
  var valid_594869 = query.getOrDefault("key")
  valid_594869 = validateParameter(valid_594869, JString, required = false,
                                 default = nil)
  if valid_594869 != nil:
    section.add "key", valid_594869
  var valid_594870 = query.getOrDefault("$.xgafv")
  valid_594870 = validateParameter(valid_594870, JString, required = false,
                                 default = newJString("1"))
  if valid_594870 != nil:
    section.add "$.xgafv", valid_594870
  var valid_594871 = query.getOrDefault("prettyPrint")
  valid_594871 = validateParameter(valid_594871, JBool, required = false,
                                 default = newJBool(true))
  if valid_594871 != nil:
    section.add "prettyPrint", valid_594871
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

proc call*(call_594873: Call_ContainerProjectsLocationsClustersSetLocations_594857;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the locations for a specific cluster.
  ## 
  let valid = call_594873.validator(path, query, header, formData, body)
  let scheme = call_594873.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594873.url(scheme.get, call_594873.host, call_594873.base,
                         call_594873.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594873, url, valid)

proc call*(call_594874: Call_ContainerProjectsLocationsClustersSetLocations_594857;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containerProjectsLocationsClustersSetLocations
  ## Sets the locations for a specific cluster.
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
  var path_594875 = newJObject()
  var query_594876 = newJObject()
  var body_594877 = newJObject()
  add(query_594876, "upload_protocol", newJString(uploadProtocol))
  add(query_594876, "fields", newJString(fields))
  add(query_594876, "quotaUser", newJString(quotaUser))
  add(path_594875, "name", newJString(name))
  add(query_594876, "alt", newJString(alt))
  add(query_594876, "oauth_token", newJString(oauthToken))
  add(query_594876, "callback", newJString(callback))
  add(query_594876, "access_token", newJString(accessToken))
  add(query_594876, "uploadType", newJString(uploadType))
  add(query_594876, "key", newJString(key))
  add(query_594876, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594877 = body
  add(query_594876, "prettyPrint", newJBool(prettyPrint))
  result = call_594874.call(path_594875, query_594876, nil, nil, body_594877)

var containerProjectsLocationsClustersSetLocations* = Call_ContainerProjectsLocationsClustersSetLocations_594857(
    name: "containerProjectsLocationsClustersSetLocations",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setLocations",
    validator: validate_ContainerProjectsLocationsClustersSetLocations_594858,
    base: "/", url: url_ContainerProjectsLocationsClustersSetLocations_594859,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetLogging_594878 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersSetLogging_594880(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setLogging")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetLogging_594879(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the logging service for a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster) of the cluster to set logging.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594881 = path.getOrDefault("name")
  valid_594881 = validateParameter(valid_594881, JString, required = true,
                                 default = nil)
  if valid_594881 != nil:
    section.add "name", valid_594881
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
  section = newJObject()
  var valid_594882 = query.getOrDefault("upload_protocol")
  valid_594882 = validateParameter(valid_594882, JString, required = false,
                                 default = nil)
  if valid_594882 != nil:
    section.add "upload_protocol", valid_594882
  var valid_594883 = query.getOrDefault("fields")
  valid_594883 = validateParameter(valid_594883, JString, required = false,
                                 default = nil)
  if valid_594883 != nil:
    section.add "fields", valid_594883
  var valid_594884 = query.getOrDefault("quotaUser")
  valid_594884 = validateParameter(valid_594884, JString, required = false,
                                 default = nil)
  if valid_594884 != nil:
    section.add "quotaUser", valid_594884
  var valid_594885 = query.getOrDefault("alt")
  valid_594885 = validateParameter(valid_594885, JString, required = false,
                                 default = newJString("json"))
  if valid_594885 != nil:
    section.add "alt", valid_594885
  var valid_594886 = query.getOrDefault("oauth_token")
  valid_594886 = validateParameter(valid_594886, JString, required = false,
                                 default = nil)
  if valid_594886 != nil:
    section.add "oauth_token", valid_594886
  var valid_594887 = query.getOrDefault("callback")
  valid_594887 = validateParameter(valid_594887, JString, required = false,
                                 default = nil)
  if valid_594887 != nil:
    section.add "callback", valid_594887
  var valid_594888 = query.getOrDefault("access_token")
  valid_594888 = validateParameter(valid_594888, JString, required = false,
                                 default = nil)
  if valid_594888 != nil:
    section.add "access_token", valid_594888
  var valid_594889 = query.getOrDefault("uploadType")
  valid_594889 = validateParameter(valid_594889, JString, required = false,
                                 default = nil)
  if valid_594889 != nil:
    section.add "uploadType", valid_594889
  var valid_594890 = query.getOrDefault("key")
  valid_594890 = validateParameter(valid_594890, JString, required = false,
                                 default = nil)
  if valid_594890 != nil:
    section.add "key", valid_594890
  var valid_594891 = query.getOrDefault("$.xgafv")
  valid_594891 = validateParameter(valid_594891, JString, required = false,
                                 default = newJString("1"))
  if valid_594891 != nil:
    section.add "$.xgafv", valid_594891
  var valid_594892 = query.getOrDefault("prettyPrint")
  valid_594892 = validateParameter(valid_594892, JBool, required = false,
                                 default = newJBool(true))
  if valid_594892 != nil:
    section.add "prettyPrint", valid_594892
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

proc call*(call_594894: Call_ContainerProjectsLocationsClustersSetLogging_594878;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the logging service for a specific cluster.
  ## 
  let valid = call_594894.validator(path, query, header, formData, body)
  let scheme = call_594894.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594894.url(scheme.get, call_594894.host, call_594894.base,
                         call_594894.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594894, url, valid)

proc call*(call_594895: Call_ContainerProjectsLocationsClustersSetLogging_594878;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containerProjectsLocationsClustersSetLogging
  ## Sets the logging service for a specific cluster.
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
  var path_594896 = newJObject()
  var query_594897 = newJObject()
  var body_594898 = newJObject()
  add(query_594897, "upload_protocol", newJString(uploadProtocol))
  add(query_594897, "fields", newJString(fields))
  add(query_594897, "quotaUser", newJString(quotaUser))
  add(path_594896, "name", newJString(name))
  add(query_594897, "alt", newJString(alt))
  add(query_594897, "oauth_token", newJString(oauthToken))
  add(query_594897, "callback", newJString(callback))
  add(query_594897, "access_token", newJString(accessToken))
  add(query_594897, "uploadType", newJString(uploadType))
  add(query_594897, "key", newJString(key))
  add(query_594897, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594898 = body
  add(query_594897, "prettyPrint", newJBool(prettyPrint))
  result = call_594895.call(path_594896, query_594897, nil, nil, body_594898)

var containerProjectsLocationsClustersSetLogging* = Call_ContainerProjectsLocationsClustersSetLogging_594878(
    name: "containerProjectsLocationsClustersSetLogging",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setLogging",
    validator: validate_ContainerProjectsLocationsClustersSetLogging_594879,
    base: "/", url: url_ContainerProjectsLocationsClustersSetLogging_594880,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_594899 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersSetMaintenancePolicy_594901(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setMaintenancePolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetMaintenancePolicy_594900(
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
  var valid_594902 = path.getOrDefault("name")
  valid_594902 = validateParameter(valid_594902, JString, required = true,
                                 default = nil)
  if valid_594902 != nil:
    section.add "name", valid_594902
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
  section = newJObject()
  var valid_594903 = query.getOrDefault("upload_protocol")
  valid_594903 = validateParameter(valid_594903, JString, required = false,
                                 default = nil)
  if valid_594903 != nil:
    section.add "upload_protocol", valid_594903
  var valid_594904 = query.getOrDefault("fields")
  valid_594904 = validateParameter(valid_594904, JString, required = false,
                                 default = nil)
  if valid_594904 != nil:
    section.add "fields", valid_594904
  var valid_594905 = query.getOrDefault("quotaUser")
  valid_594905 = validateParameter(valid_594905, JString, required = false,
                                 default = nil)
  if valid_594905 != nil:
    section.add "quotaUser", valid_594905
  var valid_594906 = query.getOrDefault("alt")
  valid_594906 = validateParameter(valid_594906, JString, required = false,
                                 default = newJString("json"))
  if valid_594906 != nil:
    section.add "alt", valid_594906
  var valid_594907 = query.getOrDefault("oauth_token")
  valid_594907 = validateParameter(valid_594907, JString, required = false,
                                 default = nil)
  if valid_594907 != nil:
    section.add "oauth_token", valid_594907
  var valid_594908 = query.getOrDefault("callback")
  valid_594908 = validateParameter(valid_594908, JString, required = false,
                                 default = nil)
  if valid_594908 != nil:
    section.add "callback", valid_594908
  var valid_594909 = query.getOrDefault("access_token")
  valid_594909 = validateParameter(valid_594909, JString, required = false,
                                 default = nil)
  if valid_594909 != nil:
    section.add "access_token", valid_594909
  var valid_594910 = query.getOrDefault("uploadType")
  valid_594910 = validateParameter(valid_594910, JString, required = false,
                                 default = nil)
  if valid_594910 != nil:
    section.add "uploadType", valid_594910
  var valid_594911 = query.getOrDefault("key")
  valid_594911 = validateParameter(valid_594911, JString, required = false,
                                 default = nil)
  if valid_594911 != nil:
    section.add "key", valid_594911
  var valid_594912 = query.getOrDefault("$.xgafv")
  valid_594912 = validateParameter(valid_594912, JString, required = false,
                                 default = newJString("1"))
  if valid_594912 != nil:
    section.add "$.xgafv", valid_594912
  var valid_594913 = query.getOrDefault("prettyPrint")
  valid_594913 = validateParameter(valid_594913, JBool, required = false,
                                 default = newJBool(true))
  if valid_594913 != nil:
    section.add "prettyPrint", valid_594913
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

proc call*(call_594915: Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_594899;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the maintenance policy for a cluster.
  ## 
  let valid = call_594915.validator(path, query, header, formData, body)
  let scheme = call_594915.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594915.url(scheme.get, call_594915.host, call_594915.base,
                         call_594915.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594915, url, valid)

proc call*(call_594916: Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_594899;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  var path_594917 = newJObject()
  var query_594918 = newJObject()
  var body_594919 = newJObject()
  add(query_594918, "upload_protocol", newJString(uploadProtocol))
  add(query_594918, "fields", newJString(fields))
  add(query_594918, "quotaUser", newJString(quotaUser))
  add(path_594917, "name", newJString(name))
  add(query_594918, "alt", newJString(alt))
  add(query_594918, "oauth_token", newJString(oauthToken))
  add(query_594918, "callback", newJString(callback))
  add(query_594918, "access_token", newJString(accessToken))
  add(query_594918, "uploadType", newJString(uploadType))
  add(query_594918, "key", newJString(key))
  add(query_594918, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594919 = body
  add(query_594918, "prettyPrint", newJBool(prettyPrint))
  result = call_594916.call(path_594917, query_594918, nil, nil, body_594919)

var containerProjectsLocationsClustersSetMaintenancePolicy* = Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_594899(
    name: "containerProjectsLocationsClustersSetMaintenancePolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setMaintenancePolicy",
    validator: validate_ContainerProjectsLocationsClustersSetMaintenancePolicy_594900,
    base: "/", url: url_ContainerProjectsLocationsClustersSetMaintenancePolicy_594901,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_594920 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersNodePoolsSetManagement_594922(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setManagement")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsSetManagement_594921(
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
  var valid_594923 = path.getOrDefault("name")
  valid_594923 = validateParameter(valid_594923, JString, required = true,
                                 default = nil)
  if valid_594923 != nil:
    section.add "name", valid_594923
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
  section = newJObject()
  var valid_594924 = query.getOrDefault("upload_protocol")
  valid_594924 = validateParameter(valid_594924, JString, required = false,
                                 default = nil)
  if valid_594924 != nil:
    section.add "upload_protocol", valid_594924
  var valid_594925 = query.getOrDefault("fields")
  valid_594925 = validateParameter(valid_594925, JString, required = false,
                                 default = nil)
  if valid_594925 != nil:
    section.add "fields", valid_594925
  var valid_594926 = query.getOrDefault("quotaUser")
  valid_594926 = validateParameter(valid_594926, JString, required = false,
                                 default = nil)
  if valid_594926 != nil:
    section.add "quotaUser", valid_594926
  var valid_594927 = query.getOrDefault("alt")
  valid_594927 = validateParameter(valid_594927, JString, required = false,
                                 default = newJString("json"))
  if valid_594927 != nil:
    section.add "alt", valid_594927
  var valid_594928 = query.getOrDefault("oauth_token")
  valid_594928 = validateParameter(valid_594928, JString, required = false,
                                 default = nil)
  if valid_594928 != nil:
    section.add "oauth_token", valid_594928
  var valid_594929 = query.getOrDefault("callback")
  valid_594929 = validateParameter(valid_594929, JString, required = false,
                                 default = nil)
  if valid_594929 != nil:
    section.add "callback", valid_594929
  var valid_594930 = query.getOrDefault("access_token")
  valid_594930 = validateParameter(valid_594930, JString, required = false,
                                 default = nil)
  if valid_594930 != nil:
    section.add "access_token", valid_594930
  var valid_594931 = query.getOrDefault("uploadType")
  valid_594931 = validateParameter(valid_594931, JString, required = false,
                                 default = nil)
  if valid_594931 != nil:
    section.add "uploadType", valid_594931
  var valid_594932 = query.getOrDefault("key")
  valid_594932 = validateParameter(valid_594932, JString, required = false,
                                 default = nil)
  if valid_594932 != nil:
    section.add "key", valid_594932
  var valid_594933 = query.getOrDefault("$.xgafv")
  valid_594933 = validateParameter(valid_594933, JString, required = false,
                                 default = newJString("1"))
  if valid_594933 != nil:
    section.add "$.xgafv", valid_594933
  var valid_594934 = query.getOrDefault("prettyPrint")
  valid_594934 = validateParameter(valid_594934, JBool, required = false,
                                 default = newJBool(true))
  if valid_594934 != nil:
    section.add "prettyPrint", valid_594934
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

proc call*(call_594936: Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_594920;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the NodeManagement options for a node pool.
  ## 
  let valid = call_594936.validator(path, query, header, formData, body)
  let scheme = call_594936.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594936.url(scheme.get, call_594936.host, call_594936.base,
                         call_594936.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594936, url, valid)

proc call*(call_594937: Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_594920;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  var path_594938 = newJObject()
  var query_594939 = newJObject()
  var body_594940 = newJObject()
  add(query_594939, "upload_protocol", newJString(uploadProtocol))
  add(query_594939, "fields", newJString(fields))
  add(query_594939, "quotaUser", newJString(quotaUser))
  add(path_594938, "name", newJString(name))
  add(query_594939, "alt", newJString(alt))
  add(query_594939, "oauth_token", newJString(oauthToken))
  add(query_594939, "callback", newJString(callback))
  add(query_594939, "access_token", newJString(accessToken))
  add(query_594939, "uploadType", newJString(uploadType))
  add(query_594939, "key", newJString(key))
  add(query_594939, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594940 = body
  add(query_594939, "prettyPrint", newJBool(prettyPrint))
  result = call_594937.call(path_594938, query_594939, nil, nil, body_594940)

var containerProjectsLocationsClustersNodePoolsSetManagement* = Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_594920(
    name: "containerProjectsLocationsClustersNodePoolsSetManagement",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setManagement", validator: validate_ContainerProjectsLocationsClustersNodePoolsSetManagement_594921,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsSetManagement_594922,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetMasterAuth_594941 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersSetMasterAuth_594943(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setMasterAuth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetMasterAuth_594942(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets master auth materials. Currently supports changing the admin password
  ## or a specific cluster, either via password generation or explicitly setting
  ## the password.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster) of the cluster to set auth.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594944 = path.getOrDefault("name")
  valid_594944 = validateParameter(valid_594944, JString, required = true,
                                 default = nil)
  if valid_594944 != nil:
    section.add "name", valid_594944
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
  section = newJObject()
  var valid_594945 = query.getOrDefault("upload_protocol")
  valid_594945 = validateParameter(valid_594945, JString, required = false,
                                 default = nil)
  if valid_594945 != nil:
    section.add "upload_protocol", valid_594945
  var valid_594946 = query.getOrDefault("fields")
  valid_594946 = validateParameter(valid_594946, JString, required = false,
                                 default = nil)
  if valid_594946 != nil:
    section.add "fields", valid_594946
  var valid_594947 = query.getOrDefault("quotaUser")
  valid_594947 = validateParameter(valid_594947, JString, required = false,
                                 default = nil)
  if valid_594947 != nil:
    section.add "quotaUser", valid_594947
  var valid_594948 = query.getOrDefault("alt")
  valid_594948 = validateParameter(valid_594948, JString, required = false,
                                 default = newJString("json"))
  if valid_594948 != nil:
    section.add "alt", valid_594948
  var valid_594949 = query.getOrDefault("oauth_token")
  valid_594949 = validateParameter(valid_594949, JString, required = false,
                                 default = nil)
  if valid_594949 != nil:
    section.add "oauth_token", valid_594949
  var valid_594950 = query.getOrDefault("callback")
  valid_594950 = validateParameter(valid_594950, JString, required = false,
                                 default = nil)
  if valid_594950 != nil:
    section.add "callback", valid_594950
  var valid_594951 = query.getOrDefault("access_token")
  valid_594951 = validateParameter(valid_594951, JString, required = false,
                                 default = nil)
  if valid_594951 != nil:
    section.add "access_token", valid_594951
  var valid_594952 = query.getOrDefault("uploadType")
  valid_594952 = validateParameter(valid_594952, JString, required = false,
                                 default = nil)
  if valid_594952 != nil:
    section.add "uploadType", valid_594952
  var valid_594953 = query.getOrDefault("key")
  valid_594953 = validateParameter(valid_594953, JString, required = false,
                                 default = nil)
  if valid_594953 != nil:
    section.add "key", valid_594953
  var valid_594954 = query.getOrDefault("$.xgafv")
  valid_594954 = validateParameter(valid_594954, JString, required = false,
                                 default = newJString("1"))
  if valid_594954 != nil:
    section.add "$.xgafv", valid_594954
  var valid_594955 = query.getOrDefault("prettyPrint")
  valid_594955 = validateParameter(valid_594955, JBool, required = false,
                                 default = newJBool(true))
  if valid_594955 != nil:
    section.add "prettyPrint", valid_594955
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

proc call*(call_594957: Call_ContainerProjectsLocationsClustersSetMasterAuth_594941;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets master auth materials. Currently supports changing the admin password
  ## or a specific cluster, either via password generation or explicitly setting
  ## the password.
  ## 
  let valid = call_594957.validator(path, query, header, formData, body)
  let scheme = call_594957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594957.url(scheme.get, call_594957.host, call_594957.base,
                         call_594957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594957, url, valid)

proc call*(call_594958: Call_ContainerProjectsLocationsClustersSetMasterAuth_594941;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containerProjectsLocationsClustersSetMasterAuth
  ## Sets master auth materials. Currently supports changing the admin password
  ## or a specific cluster, either via password generation or explicitly setting
  ## the password.
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
  var path_594959 = newJObject()
  var query_594960 = newJObject()
  var body_594961 = newJObject()
  add(query_594960, "upload_protocol", newJString(uploadProtocol))
  add(query_594960, "fields", newJString(fields))
  add(query_594960, "quotaUser", newJString(quotaUser))
  add(path_594959, "name", newJString(name))
  add(query_594960, "alt", newJString(alt))
  add(query_594960, "oauth_token", newJString(oauthToken))
  add(query_594960, "callback", newJString(callback))
  add(query_594960, "access_token", newJString(accessToken))
  add(query_594960, "uploadType", newJString(uploadType))
  add(query_594960, "key", newJString(key))
  add(query_594960, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594961 = body
  add(query_594960, "prettyPrint", newJBool(prettyPrint))
  result = call_594958.call(path_594959, query_594960, nil, nil, body_594961)

var containerProjectsLocationsClustersSetMasterAuth* = Call_ContainerProjectsLocationsClustersSetMasterAuth_594941(
    name: "containerProjectsLocationsClustersSetMasterAuth",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setMasterAuth",
    validator: validate_ContainerProjectsLocationsClustersSetMasterAuth_594942,
    base: "/", url: url_ContainerProjectsLocationsClustersSetMasterAuth_594943,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetMonitoring_594962 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersSetMonitoring_594964(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setMonitoring")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetMonitoring_594963(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the monitoring service for a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster) of the cluster to set monitoring.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594965 = path.getOrDefault("name")
  valid_594965 = validateParameter(valid_594965, JString, required = true,
                                 default = nil)
  if valid_594965 != nil:
    section.add "name", valid_594965
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
  section = newJObject()
  var valid_594966 = query.getOrDefault("upload_protocol")
  valid_594966 = validateParameter(valid_594966, JString, required = false,
                                 default = nil)
  if valid_594966 != nil:
    section.add "upload_protocol", valid_594966
  var valid_594967 = query.getOrDefault("fields")
  valid_594967 = validateParameter(valid_594967, JString, required = false,
                                 default = nil)
  if valid_594967 != nil:
    section.add "fields", valid_594967
  var valid_594968 = query.getOrDefault("quotaUser")
  valid_594968 = validateParameter(valid_594968, JString, required = false,
                                 default = nil)
  if valid_594968 != nil:
    section.add "quotaUser", valid_594968
  var valid_594969 = query.getOrDefault("alt")
  valid_594969 = validateParameter(valid_594969, JString, required = false,
                                 default = newJString("json"))
  if valid_594969 != nil:
    section.add "alt", valid_594969
  var valid_594970 = query.getOrDefault("oauth_token")
  valid_594970 = validateParameter(valid_594970, JString, required = false,
                                 default = nil)
  if valid_594970 != nil:
    section.add "oauth_token", valid_594970
  var valid_594971 = query.getOrDefault("callback")
  valid_594971 = validateParameter(valid_594971, JString, required = false,
                                 default = nil)
  if valid_594971 != nil:
    section.add "callback", valid_594971
  var valid_594972 = query.getOrDefault("access_token")
  valid_594972 = validateParameter(valid_594972, JString, required = false,
                                 default = nil)
  if valid_594972 != nil:
    section.add "access_token", valid_594972
  var valid_594973 = query.getOrDefault("uploadType")
  valid_594973 = validateParameter(valid_594973, JString, required = false,
                                 default = nil)
  if valid_594973 != nil:
    section.add "uploadType", valid_594973
  var valid_594974 = query.getOrDefault("key")
  valid_594974 = validateParameter(valid_594974, JString, required = false,
                                 default = nil)
  if valid_594974 != nil:
    section.add "key", valid_594974
  var valid_594975 = query.getOrDefault("$.xgafv")
  valid_594975 = validateParameter(valid_594975, JString, required = false,
                                 default = newJString("1"))
  if valid_594975 != nil:
    section.add "$.xgafv", valid_594975
  var valid_594976 = query.getOrDefault("prettyPrint")
  valid_594976 = validateParameter(valid_594976, JBool, required = false,
                                 default = newJBool(true))
  if valid_594976 != nil:
    section.add "prettyPrint", valid_594976
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

proc call*(call_594978: Call_ContainerProjectsLocationsClustersSetMonitoring_594962;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the monitoring service for a specific cluster.
  ## 
  let valid = call_594978.validator(path, query, header, formData, body)
  let scheme = call_594978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594978.url(scheme.get, call_594978.host, call_594978.base,
                         call_594978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594978, url, valid)

proc call*(call_594979: Call_ContainerProjectsLocationsClustersSetMonitoring_594962;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containerProjectsLocationsClustersSetMonitoring
  ## Sets the monitoring service for a specific cluster.
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
  var path_594980 = newJObject()
  var query_594981 = newJObject()
  var body_594982 = newJObject()
  add(query_594981, "upload_protocol", newJString(uploadProtocol))
  add(query_594981, "fields", newJString(fields))
  add(query_594981, "quotaUser", newJString(quotaUser))
  add(path_594980, "name", newJString(name))
  add(query_594981, "alt", newJString(alt))
  add(query_594981, "oauth_token", newJString(oauthToken))
  add(query_594981, "callback", newJString(callback))
  add(query_594981, "access_token", newJString(accessToken))
  add(query_594981, "uploadType", newJString(uploadType))
  add(query_594981, "key", newJString(key))
  add(query_594981, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594982 = body
  add(query_594981, "prettyPrint", newJBool(prettyPrint))
  result = call_594979.call(path_594980, query_594981, nil, nil, body_594982)

var containerProjectsLocationsClustersSetMonitoring* = Call_ContainerProjectsLocationsClustersSetMonitoring_594962(
    name: "containerProjectsLocationsClustersSetMonitoring",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setMonitoring",
    validator: validate_ContainerProjectsLocationsClustersSetMonitoring_594963,
    base: "/", url: url_ContainerProjectsLocationsClustersSetMonitoring_594964,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetNetworkPolicy_594983 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersSetNetworkPolicy_594985(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setNetworkPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetNetworkPolicy_594984(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Enables or disables Network Policy for a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster id) of the cluster to set networking
  ## policy. Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594986 = path.getOrDefault("name")
  valid_594986 = validateParameter(valid_594986, JString, required = true,
                                 default = nil)
  if valid_594986 != nil:
    section.add "name", valid_594986
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
  section = newJObject()
  var valid_594987 = query.getOrDefault("upload_protocol")
  valid_594987 = validateParameter(valid_594987, JString, required = false,
                                 default = nil)
  if valid_594987 != nil:
    section.add "upload_protocol", valid_594987
  var valid_594988 = query.getOrDefault("fields")
  valid_594988 = validateParameter(valid_594988, JString, required = false,
                                 default = nil)
  if valid_594988 != nil:
    section.add "fields", valid_594988
  var valid_594989 = query.getOrDefault("quotaUser")
  valid_594989 = validateParameter(valid_594989, JString, required = false,
                                 default = nil)
  if valid_594989 != nil:
    section.add "quotaUser", valid_594989
  var valid_594990 = query.getOrDefault("alt")
  valid_594990 = validateParameter(valid_594990, JString, required = false,
                                 default = newJString("json"))
  if valid_594990 != nil:
    section.add "alt", valid_594990
  var valid_594991 = query.getOrDefault("oauth_token")
  valid_594991 = validateParameter(valid_594991, JString, required = false,
                                 default = nil)
  if valid_594991 != nil:
    section.add "oauth_token", valid_594991
  var valid_594992 = query.getOrDefault("callback")
  valid_594992 = validateParameter(valid_594992, JString, required = false,
                                 default = nil)
  if valid_594992 != nil:
    section.add "callback", valid_594992
  var valid_594993 = query.getOrDefault("access_token")
  valid_594993 = validateParameter(valid_594993, JString, required = false,
                                 default = nil)
  if valid_594993 != nil:
    section.add "access_token", valid_594993
  var valid_594994 = query.getOrDefault("uploadType")
  valid_594994 = validateParameter(valid_594994, JString, required = false,
                                 default = nil)
  if valid_594994 != nil:
    section.add "uploadType", valid_594994
  var valid_594995 = query.getOrDefault("key")
  valid_594995 = validateParameter(valid_594995, JString, required = false,
                                 default = nil)
  if valid_594995 != nil:
    section.add "key", valid_594995
  var valid_594996 = query.getOrDefault("$.xgafv")
  valid_594996 = validateParameter(valid_594996, JString, required = false,
                                 default = newJString("1"))
  if valid_594996 != nil:
    section.add "$.xgafv", valid_594996
  var valid_594997 = query.getOrDefault("prettyPrint")
  valid_594997 = validateParameter(valid_594997, JBool, required = false,
                                 default = newJBool(true))
  if valid_594997 != nil:
    section.add "prettyPrint", valid_594997
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

proc call*(call_594999: Call_ContainerProjectsLocationsClustersSetNetworkPolicy_594983;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables or disables Network Policy for a cluster.
  ## 
  let valid = call_594999.validator(path, query, header, formData, body)
  let scheme = call_594999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594999.url(scheme.get, call_594999.host, call_594999.base,
                         call_594999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594999, url, valid)

proc call*(call_595000: Call_ContainerProjectsLocationsClustersSetNetworkPolicy_594983;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containerProjectsLocationsClustersSetNetworkPolicy
  ## Enables or disables Network Policy for a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster id) of the cluster to set networking
  ## policy. Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   alt: string
  ##      : Data format for response.
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
  var path_595001 = newJObject()
  var query_595002 = newJObject()
  var body_595003 = newJObject()
  add(query_595002, "upload_protocol", newJString(uploadProtocol))
  add(query_595002, "fields", newJString(fields))
  add(query_595002, "quotaUser", newJString(quotaUser))
  add(path_595001, "name", newJString(name))
  add(query_595002, "alt", newJString(alt))
  add(query_595002, "oauth_token", newJString(oauthToken))
  add(query_595002, "callback", newJString(callback))
  add(query_595002, "access_token", newJString(accessToken))
  add(query_595002, "uploadType", newJString(uploadType))
  add(query_595002, "key", newJString(key))
  add(query_595002, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_595003 = body
  add(query_595002, "prettyPrint", newJBool(prettyPrint))
  result = call_595000.call(path_595001, query_595002, nil, nil, body_595003)

var containerProjectsLocationsClustersSetNetworkPolicy* = Call_ContainerProjectsLocationsClustersSetNetworkPolicy_594983(
    name: "containerProjectsLocationsClustersSetNetworkPolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setNetworkPolicy",
    validator: validate_ContainerProjectsLocationsClustersSetNetworkPolicy_594984,
    base: "/", url: url_ContainerProjectsLocationsClustersSetNetworkPolicy_594985,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetResourceLabels_595004 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersSetResourceLabels_595006(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setResourceLabels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetResourceLabels_595005(
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
  var valid_595007 = path.getOrDefault("name")
  valid_595007 = validateParameter(valid_595007, JString, required = true,
                                 default = nil)
  if valid_595007 != nil:
    section.add "name", valid_595007
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
  section = newJObject()
  var valid_595008 = query.getOrDefault("upload_protocol")
  valid_595008 = validateParameter(valid_595008, JString, required = false,
                                 default = nil)
  if valid_595008 != nil:
    section.add "upload_protocol", valid_595008
  var valid_595009 = query.getOrDefault("fields")
  valid_595009 = validateParameter(valid_595009, JString, required = false,
                                 default = nil)
  if valid_595009 != nil:
    section.add "fields", valid_595009
  var valid_595010 = query.getOrDefault("quotaUser")
  valid_595010 = validateParameter(valid_595010, JString, required = false,
                                 default = nil)
  if valid_595010 != nil:
    section.add "quotaUser", valid_595010
  var valid_595011 = query.getOrDefault("alt")
  valid_595011 = validateParameter(valid_595011, JString, required = false,
                                 default = newJString("json"))
  if valid_595011 != nil:
    section.add "alt", valid_595011
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

proc call*(call_595020: Call_ContainerProjectsLocationsClustersSetResourceLabels_595004;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets labels on a cluster.
  ## 
  let valid = call_595020.validator(path, query, header, formData, body)
  let scheme = call_595020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595020.url(scheme.get, call_595020.host, call_595020.base,
                         call_595020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595020, url, valid)

proc call*(call_595021: Call_ContainerProjectsLocationsClustersSetResourceLabels_595004;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  var path_595022 = newJObject()
  var query_595023 = newJObject()
  var body_595024 = newJObject()
  add(query_595023, "upload_protocol", newJString(uploadProtocol))
  add(query_595023, "fields", newJString(fields))
  add(query_595023, "quotaUser", newJString(quotaUser))
  add(path_595022, "name", newJString(name))
  add(query_595023, "alt", newJString(alt))
  add(query_595023, "oauth_token", newJString(oauthToken))
  add(query_595023, "callback", newJString(callback))
  add(query_595023, "access_token", newJString(accessToken))
  add(query_595023, "uploadType", newJString(uploadType))
  add(query_595023, "key", newJString(key))
  add(query_595023, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_595024 = body
  add(query_595023, "prettyPrint", newJBool(prettyPrint))
  result = call_595021.call(path_595022, query_595023, nil, nil, body_595024)

var containerProjectsLocationsClustersSetResourceLabels* = Call_ContainerProjectsLocationsClustersSetResourceLabels_595004(
    name: "containerProjectsLocationsClustersSetResourceLabels",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setResourceLabels",
    validator: validate_ContainerProjectsLocationsClustersSetResourceLabels_595005,
    base: "/", url: url_ContainerProjectsLocationsClustersSetResourceLabels_595006,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsSetSize_595025 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersNodePoolsSetSize_595027(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setSize")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsSetSize_595026(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the size for a specific node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster, node pool id) of the node pool to set
  ## size.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_595028 = path.getOrDefault("name")
  valid_595028 = validateParameter(valid_595028, JString, required = true,
                                 default = nil)
  if valid_595028 != nil:
    section.add "name", valid_595028
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
  section = newJObject()
  var valid_595029 = query.getOrDefault("upload_protocol")
  valid_595029 = validateParameter(valid_595029, JString, required = false,
                                 default = nil)
  if valid_595029 != nil:
    section.add "upload_protocol", valid_595029
  var valid_595030 = query.getOrDefault("fields")
  valid_595030 = validateParameter(valid_595030, JString, required = false,
                                 default = nil)
  if valid_595030 != nil:
    section.add "fields", valid_595030
  var valid_595031 = query.getOrDefault("quotaUser")
  valid_595031 = validateParameter(valid_595031, JString, required = false,
                                 default = nil)
  if valid_595031 != nil:
    section.add "quotaUser", valid_595031
  var valid_595032 = query.getOrDefault("alt")
  valid_595032 = validateParameter(valid_595032, JString, required = false,
                                 default = newJString("json"))
  if valid_595032 != nil:
    section.add "alt", valid_595032
  var valid_595033 = query.getOrDefault("oauth_token")
  valid_595033 = validateParameter(valid_595033, JString, required = false,
                                 default = nil)
  if valid_595033 != nil:
    section.add "oauth_token", valid_595033
  var valid_595034 = query.getOrDefault("callback")
  valid_595034 = validateParameter(valid_595034, JString, required = false,
                                 default = nil)
  if valid_595034 != nil:
    section.add "callback", valid_595034
  var valid_595035 = query.getOrDefault("access_token")
  valid_595035 = validateParameter(valid_595035, JString, required = false,
                                 default = nil)
  if valid_595035 != nil:
    section.add "access_token", valid_595035
  var valid_595036 = query.getOrDefault("uploadType")
  valid_595036 = validateParameter(valid_595036, JString, required = false,
                                 default = nil)
  if valid_595036 != nil:
    section.add "uploadType", valid_595036
  var valid_595037 = query.getOrDefault("key")
  valid_595037 = validateParameter(valid_595037, JString, required = false,
                                 default = nil)
  if valid_595037 != nil:
    section.add "key", valid_595037
  var valid_595038 = query.getOrDefault("$.xgafv")
  valid_595038 = validateParameter(valid_595038, JString, required = false,
                                 default = newJString("1"))
  if valid_595038 != nil:
    section.add "$.xgafv", valid_595038
  var valid_595039 = query.getOrDefault("prettyPrint")
  valid_595039 = validateParameter(valid_595039, JBool, required = false,
                                 default = newJBool(true))
  if valid_595039 != nil:
    section.add "prettyPrint", valid_595039
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

proc call*(call_595041: Call_ContainerProjectsLocationsClustersNodePoolsSetSize_595025;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the size for a specific node pool.
  ## 
  let valid = call_595041.validator(path, query, header, formData, body)
  let scheme = call_595041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595041.url(scheme.get, call_595041.host, call_595041.base,
                         call_595041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595041, url, valid)

proc call*(call_595042: Call_ContainerProjectsLocationsClustersNodePoolsSetSize_595025;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containerProjectsLocationsClustersNodePoolsSetSize
  ## Sets the size for a specific node pool.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster, node pool id) of the node pool to set
  ## size.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   alt: string
  ##      : Data format for response.
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
  var path_595043 = newJObject()
  var query_595044 = newJObject()
  var body_595045 = newJObject()
  add(query_595044, "upload_protocol", newJString(uploadProtocol))
  add(query_595044, "fields", newJString(fields))
  add(query_595044, "quotaUser", newJString(quotaUser))
  add(path_595043, "name", newJString(name))
  add(query_595044, "alt", newJString(alt))
  add(query_595044, "oauth_token", newJString(oauthToken))
  add(query_595044, "callback", newJString(callback))
  add(query_595044, "access_token", newJString(accessToken))
  add(query_595044, "uploadType", newJString(uploadType))
  add(query_595044, "key", newJString(key))
  add(query_595044, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_595045 = body
  add(query_595044, "prettyPrint", newJBool(prettyPrint))
  result = call_595042.call(path_595043, query_595044, nil, nil, body_595045)

var containerProjectsLocationsClustersNodePoolsSetSize* = Call_ContainerProjectsLocationsClustersNodePoolsSetSize_595025(
    name: "containerProjectsLocationsClustersNodePoolsSetSize",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setSize",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsSetSize_595026,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsSetSize_595027,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersStartIpRotation_595046 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersStartIpRotation_595048(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":startIpRotation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersStartIpRotation_595047(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Starts master IP rotation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster id) of the cluster to start IP
  ## rotation. Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_595049 = path.getOrDefault("name")
  valid_595049 = validateParameter(valid_595049, JString, required = true,
                                 default = nil)
  if valid_595049 != nil:
    section.add "name", valid_595049
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
  section = newJObject()
  var valid_595050 = query.getOrDefault("upload_protocol")
  valid_595050 = validateParameter(valid_595050, JString, required = false,
                                 default = nil)
  if valid_595050 != nil:
    section.add "upload_protocol", valid_595050
  var valid_595051 = query.getOrDefault("fields")
  valid_595051 = validateParameter(valid_595051, JString, required = false,
                                 default = nil)
  if valid_595051 != nil:
    section.add "fields", valid_595051
  var valid_595052 = query.getOrDefault("quotaUser")
  valid_595052 = validateParameter(valid_595052, JString, required = false,
                                 default = nil)
  if valid_595052 != nil:
    section.add "quotaUser", valid_595052
  var valid_595053 = query.getOrDefault("alt")
  valid_595053 = validateParameter(valid_595053, JString, required = false,
                                 default = newJString("json"))
  if valid_595053 != nil:
    section.add "alt", valid_595053
  var valid_595054 = query.getOrDefault("oauth_token")
  valid_595054 = validateParameter(valid_595054, JString, required = false,
                                 default = nil)
  if valid_595054 != nil:
    section.add "oauth_token", valid_595054
  var valid_595055 = query.getOrDefault("callback")
  valid_595055 = validateParameter(valid_595055, JString, required = false,
                                 default = nil)
  if valid_595055 != nil:
    section.add "callback", valid_595055
  var valid_595056 = query.getOrDefault("access_token")
  valid_595056 = validateParameter(valid_595056, JString, required = false,
                                 default = nil)
  if valid_595056 != nil:
    section.add "access_token", valid_595056
  var valid_595057 = query.getOrDefault("uploadType")
  valid_595057 = validateParameter(valid_595057, JString, required = false,
                                 default = nil)
  if valid_595057 != nil:
    section.add "uploadType", valid_595057
  var valid_595058 = query.getOrDefault("key")
  valid_595058 = validateParameter(valid_595058, JString, required = false,
                                 default = nil)
  if valid_595058 != nil:
    section.add "key", valid_595058
  var valid_595059 = query.getOrDefault("$.xgafv")
  valid_595059 = validateParameter(valid_595059, JString, required = false,
                                 default = newJString("1"))
  if valid_595059 != nil:
    section.add "$.xgafv", valid_595059
  var valid_595060 = query.getOrDefault("prettyPrint")
  valid_595060 = validateParameter(valid_595060, JBool, required = false,
                                 default = newJBool(true))
  if valid_595060 != nil:
    section.add "prettyPrint", valid_595060
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

proc call*(call_595062: Call_ContainerProjectsLocationsClustersStartIpRotation_595046;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts master IP rotation.
  ## 
  let valid = call_595062.validator(path, query, header, formData, body)
  let scheme = call_595062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595062.url(scheme.get, call_595062.host, call_595062.base,
                         call_595062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595062, url, valid)

proc call*(call_595063: Call_ContainerProjectsLocationsClustersStartIpRotation_595046;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containerProjectsLocationsClustersStartIpRotation
  ## Starts master IP rotation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster id) of the cluster to start IP
  ## rotation. Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   alt: string
  ##      : Data format for response.
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
  var path_595064 = newJObject()
  var query_595065 = newJObject()
  var body_595066 = newJObject()
  add(query_595065, "upload_protocol", newJString(uploadProtocol))
  add(query_595065, "fields", newJString(fields))
  add(query_595065, "quotaUser", newJString(quotaUser))
  add(path_595064, "name", newJString(name))
  add(query_595065, "alt", newJString(alt))
  add(query_595065, "oauth_token", newJString(oauthToken))
  add(query_595065, "callback", newJString(callback))
  add(query_595065, "access_token", newJString(accessToken))
  add(query_595065, "uploadType", newJString(uploadType))
  add(query_595065, "key", newJString(key))
  add(query_595065, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_595066 = body
  add(query_595065, "prettyPrint", newJBool(prettyPrint))
  result = call_595063.call(path_595064, query_595065, nil, nil, body_595066)

var containerProjectsLocationsClustersStartIpRotation* = Call_ContainerProjectsLocationsClustersStartIpRotation_595046(
    name: "containerProjectsLocationsClustersStartIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:startIpRotation",
    validator: validate_ContainerProjectsLocationsClustersStartIpRotation_595047,
    base: "/", url: url_ContainerProjectsLocationsClustersStartIpRotation_595048,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersUpdateMaster_595067 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersUpdateMaster_595069(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":updateMaster")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersUpdateMaster_595068(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates the master for a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster) of the cluster to update.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_595070 = path.getOrDefault("name")
  valid_595070 = validateParameter(valid_595070, JString, required = true,
                                 default = nil)
  if valid_595070 != nil:
    section.add "name", valid_595070
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
  section = newJObject()
  var valid_595071 = query.getOrDefault("upload_protocol")
  valid_595071 = validateParameter(valid_595071, JString, required = false,
                                 default = nil)
  if valid_595071 != nil:
    section.add "upload_protocol", valid_595071
  var valid_595072 = query.getOrDefault("fields")
  valid_595072 = validateParameter(valid_595072, JString, required = false,
                                 default = nil)
  if valid_595072 != nil:
    section.add "fields", valid_595072
  var valid_595073 = query.getOrDefault("quotaUser")
  valid_595073 = validateParameter(valid_595073, JString, required = false,
                                 default = nil)
  if valid_595073 != nil:
    section.add "quotaUser", valid_595073
  var valid_595074 = query.getOrDefault("alt")
  valid_595074 = validateParameter(valid_595074, JString, required = false,
                                 default = newJString("json"))
  if valid_595074 != nil:
    section.add "alt", valid_595074
  var valid_595075 = query.getOrDefault("oauth_token")
  valid_595075 = validateParameter(valid_595075, JString, required = false,
                                 default = nil)
  if valid_595075 != nil:
    section.add "oauth_token", valid_595075
  var valid_595076 = query.getOrDefault("callback")
  valid_595076 = validateParameter(valid_595076, JString, required = false,
                                 default = nil)
  if valid_595076 != nil:
    section.add "callback", valid_595076
  var valid_595077 = query.getOrDefault("access_token")
  valid_595077 = validateParameter(valid_595077, JString, required = false,
                                 default = nil)
  if valid_595077 != nil:
    section.add "access_token", valid_595077
  var valid_595078 = query.getOrDefault("uploadType")
  valid_595078 = validateParameter(valid_595078, JString, required = false,
                                 default = nil)
  if valid_595078 != nil:
    section.add "uploadType", valid_595078
  var valid_595079 = query.getOrDefault("key")
  valid_595079 = validateParameter(valid_595079, JString, required = false,
                                 default = nil)
  if valid_595079 != nil:
    section.add "key", valid_595079
  var valid_595080 = query.getOrDefault("$.xgafv")
  valid_595080 = validateParameter(valid_595080, JString, required = false,
                                 default = newJString("1"))
  if valid_595080 != nil:
    section.add "$.xgafv", valid_595080
  var valid_595081 = query.getOrDefault("prettyPrint")
  valid_595081 = validateParameter(valid_595081, JBool, required = false,
                                 default = newJBool(true))
  if valid_595081 != nil:
    section.add "prettyPrint", valid_595081
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

proc call*(call_595083: Call_ContainerProjectsLocationsClustersUpdateMaster_595067;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the master for a specific cluster.
  ## 
  let valid = call_595083.validator(path, query, header, formData, body)
  let scheme = call_595083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595083.url(scheme.get, call_595083.host, call_595083.base,
                         call_595083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595083, url, valid)

proc call*(call_595084: Call_ContainerProjectsLocationsClustersUpdateMaster_595067;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containerProjectsLocationsClustersUpdateMaster
  ## Updates the master for a specific cluster.
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
  var path_595085 = newJObject()
  var query_595086 = newJObject()
  var body_595087 = newJObject()
  add(query_595086, "upload_protocol", newJString(uploadProtocol))
  add(query_595086, "fields", newJString(fields))
  add(query_595086, "quotaUser", newJString(quotaUser))
  add(path_595085, "name", newJString(name))
  add(query_595086, "alt", newJString(alt))
  add(query_595086, "oauth_token", newJString(oauthToken))
  add(query_595086, "callback", newJString(callback))
  add(query_595086, "access_token", newJString(accessToken))
  add(query_595086, "uploadType", newJString(uploadType))
  add(query_595086, "key", newJString(key))
  add(query_595086, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_595087 = body
  add(query_595086, "prettyPrint", newJBool(prettyPrint))
  result = call_595084.call(path_595085, query_595086, nil, nil, body_595087)

var containerProjectsLocationsClustersUpdateMaster* = Call_ContainerProjectsLocationsClustersUpdateMaster_595067(
    name: "containerProjectsLocationsClustersUpdateMaster",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:updateMaster",
    validator: validate_ContainerProjectsLocationsClustersUpdateMaster_595068,
    base: "/", url: url_ContainerProjectsLocationsClustersUpdateMaster_595069,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_595088 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_595090(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"), (kind: ConstantSegment,
        value: "/.well-known/openid-configuration")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_595089(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the OIDC discovery document for the cluster.
  ## See the
  ## [OpenID Connect Discovery 1.0
  ## specification](https://openid.net/specs/openid-connect-discovery-1_0.html)
  ## for details.
  ## This API is not yet intended for general use, and is not available for all
  ## clusters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The cluster (project, location, cluster id) to get the discovery document
  ## for. Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_595091 = path.getOrDefault("parent")
  valid_595091 = validateParameter(valid_595091, JString, required = true,
                                 default = nil)
  if valid_595091 != nil:
    section.add "parent", valid_595091
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
  section = newJObject()
  var valid_595092 = query.getOrDefault("upload_protocol")
  valid_595092 = validateParameter(valid_595092, JString, required = false,
                                 default = nil)
  if valid_595092 != nil:
    section.add "upload_protocol", valid_595092
  var valid_595093 = query.getOrDefault("fields")
  valid_595093 = validateParameter(valid_595093, JString, required = false,
                                 default = nil)
  if valid_595093 != nil:
    section.add "fields", valid_595093
  var valid_595094 = query.getOrDefault("quotaUser")
  valid_595094 = validateParameter(valid_595094, JString, required = false,
                                 default = nil)
  if valid_595094 != nil:
    section.add "quotaUser", valid_595094
  var valid_595095 = query.getOrDefault("alt")
  valid_595095 = validateParameter(valid_595095, JString, required = false,
                                 default = newJString("json"))
  if valid_595095 != nil:
    section.add "alt", valid_595095
  var valid_595096 = query.getOrDefault("oauth_token")
  valid_595096 = validateParameter(valid_595096, JString, required = false,
                                 default = nil)
  if valid_595096 != nil:
    section.add "oauth_token", valid_595096
  var valid_595097 = query.getOrDefault("callback")
  valid_595097 = validateParameter(valid_595097, JString, required = false,
                                 default = nil)
  if valid_595097 != nil:
    section.add "callback", valid_595097
  var valid_595098 = query.getOrDefault("access_token")
  valid_595098 = validateParameter(valid_595098, JString, required = false,
                                 default = nil)
  if valid_595098 != nil:
    section.add "access_token", valid_595098
  var valid_595099 = query.getOrDefault("uploadType")
  valid_595099 = validateParameter(valid_595099, JString, required = false,
                                 default = nil)
  if valid_595099 != nil:
    section.add "uploadType", valid_595099
  var valid_595100 = query.getOrDefault("key")
  valid_595100 = validateParameter(valid_595100, JString, required = false,
                                 default = nil)
  if valid_595100 != nil:
    section.add "key", valid_595100
  var valid_595101 = query.getOrDefault("$.xgafv")
  valid_595101 = validateParameter(valid_595101, JString, required = false,
                                 default = newJString("1"))
  if valid_595101 != nil:
    section.add "$.xgafv", valid_595101
  var valid_595102 = query.getOrDefault("prettyPrint")
  valid_595102 = validateParameter(valid_595102, JBool, required = false,
                                 default = newJBool(true))
  if valid_595102 != nil:
    section.add "prettyPrint", valid_595102
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595103: Call_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_595088;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the OIDC discovery document for the cluster.
  ## See the
  ## [OpenID Connect Discovery 1.0
  ## specification](https://openid.net/specs/openid-connect-discovery-1_0.html)
  ## for details.
  ## This API is not yet intended for general use, and is not available for all
  ## clusters.
  ## 
  let valid = call_595103.validator(path, query, header, formData, body)
  let scheme = call_595103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595103.url(scheme.get, call_595103.host, call_595103.base,
                         call_595103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595103, url, valid)

proc call*(call_595104: Call_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_595088;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## containerProjectsLocationsClustersWellKnownGetOpenidConfiguration
  ## Gets the OIDC discovery document for the cluster.
  ## See the
  ## [OpenID Connect Discovery 1.0
  ## specification](https://openid.net/specs/openid-connect-discovery-1_0.html)
  ## for details.
  ## This API is not yet intended for general use, and is not available for all
  ## clusters.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The cluster (project, location, cluster id) to get the discovery document
  ## for. Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_595105 = newJObject()
  var query_595106 = newJObject()
  add(query_595106, "upload_protocol", newJString(uploadProtocol))
  add(query_595106, "fields", newJString(fields))
  add(query_595106, "quotaUser", newJString(quotaUser))
  add(query_595106, "alt", newJString(alt))
  add(query_595106, "oauth_token", newJString(oauthToken))
  add(query_595106, "callback", newJString(callback))
  add(query_595106, "access_token", newJString(accessToken))
  add(query_595106, "uploadType", newJString(uploadType))
  add(path_595105, "parent", newJString(parent))
  add(query_595106, "key", newJString(key))
  add(query_595106, "$.xgafv", newJString(Xgafv))
  add(query_595106, "prettyPrint", newJBool(prettyPrint))
  result = call_595104.call(path_595105, query_595106, nil, nil, nil)

var containerProjectsLocationsClustersWellKnownGetOpenidConfiguration* = Call_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_595088(
    name: "containerProjectsLocationsClustersWellKnownGetOpenidConfiguration",
    meth: HttpMethod.HttpGet, host: "container.googleapis.com",
    route: "/v1/{parent}/.well-known/openid-configuration", validator: validate_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_595089,
    base: "/",
    url: url_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_595090,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsAggregatedUsableSubnetworksList_595107 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsAggregatedUsableSubnetworksList_595109(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/aggregated/usableSubnetworks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsAggregatedUsableSubnetworksList_595108(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists subnetworks that are usable for creating clusters in a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent project where subnetworks are usable.
  ## Specified in the format 'projects/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_595110 = path.getOrDefault("parent")
  valid_595110 = validateParameter(valid_595110, JString, required = true,
                                 default = nil)
  if valid_595110 != nil:
    section.add "parent", valid_595110
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set this to the nextPageToken returned by
  ## previous list requests to get the next page of results.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
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
  ##   pageSize: JInt
  ##           : The max number of results per page that should be returned. If the number
  ## of available results is larger than `page_size`, a `next_page_token` is
  ## returned which can be used to get the next page of results in subsequent
  ## requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Filtering currently only supports equality on the networkProjectId and must
  ## be in the form: "networkProjectId=[PROJECTID]", where `networkProjectId`
  ## is the project which owns the listed subnetworks. This defaults to the
  ## parent project ID.
  section = newJObject()
  var valid_595111 = query.getOrDefault("upload_protocol")
  valid_595111 = validateParameter(valid_595111, JString, required = false,
                                 default = nil)
  if valid_595111 != nil:
    section.add "upload_protocol", valid_595111
  var valid_595112 = query.getOrDefault("fields")
  valid_595112 = validateParameter(valid_595112, JString, required = false,
                                 default = nil)
  if valid_595112 != nil:
    section.add "fields", valid_595112
  var valid_595113 = query.getOrDefault("pageToken")
  valid_595113 = validateParameter(valid_595113, JString, required = false,
                                 default = nil)
  if valid_595113 != nil:
    section.add "pageToken", valid_595113
  var valid_595114 = query.getOrDefault("quotaUser")
  valid_595114 = validateParameter(valid_595114, JString, required = false,
                                 default = nil)
  if valid_595114 != nil:
    section.add "quotaUser", valid_595114
  var valid_595115 = query.getOrDefault("alt")
  valid_595115 = validateParameter(valid_595115, JString, required = false,
                                 default = newJString("json"))
  if valid_595115 != nil:
    section.add "alt", valid_595115
  var valid_595116 = query.getOrDefault("oauth_token")
  valid_595116 = validateParameter(valid_595116, JString, required = false,
                                 default = nil)
  if valid_595116 != nil:
    section.add "oauth_token", valid_595116
  var valid_595117 = query.getOrDefault("callback")
  valid_595117 = validateParameter(valid_595117, JString, required = false,
                                 default = nil)
  if valid_595117 != nil:
    section.add "callback", valid_595117
  var valid_595118 = query.getOrDefault("access_token")
  valid_595118 = validateParameter(valid_595118, JString, required = false,
                                 default = nil)
  if valid_595118 != nil:
    section.add "access_token", valid_595118
  var valid_595119 = query.getOrDefault("uploadType")
  valid_595119 = validateParameter(valid_595119, JString, required = false,
                                 default = nil)
  if valid_595119 != nil:
    section.add "uploadType", valid_595119
  var valid_595120 = query.getOrDefault("key")
  valid_595120 = validateParameter(valid_595120, JString, required = false,
                                 default = nil)
  if valid_595120 != nil:
    section.add "key", valid_595120
  var valid_595121 = query.getOrDefault("$.xgafv")
  valid_595121 = validateParameter(valid_595121, JString, required = false,
                                 default = newJString("1"))
  if valid_595121 != nil:
    section.add "$.xgafv", valid_595121
  var valid_595122 = query.getOrDefault("pageSize")
  valid_595122 = validateParameter(valid_595122, JInt, required = false, default = nil)
  if valid_595122 != nil:
    section.add "pageSize", valid_595122
  var valid_595123 = query.getOrDefault("prettyPrint")
  valid_595123 = validateParameter(valid_595123, JBool, required = false,
                                 default = newJBool(true))
  if valid_595123 != nil:
    section.add "prettyPrint", valid_595123
  var valid_595124 = query.getOrDefault("filter")
  valid_595124 = validateParameter(valid_595124, JString, required = false,
                                 default = nil)
  if valid_595124 != nil:
    section.add "filter", valid_595124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595125: Call_ContainerProjectsAggregatedUsableSubnetworksList_595107;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists subnetworks that are usable for creating clusters in a project.
  ## 
  let valid = call_595125.validator(path, query, header, formData, body)
  let scheme = call_595125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595125.url(scheme.get, call_595125.host, call_595125.base,
                         call_595125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595125, url, valid)

proc call*(call_595126: Call_ContainerProjectsAggregatedUsableSubnetworksList_595107;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## containerProjectsAggregatedUsableSubnetworksList
  ## Lists subnetworks that are usable for creating clusters in a project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set this to the nextPageToken returned by
  ## previous list requests to get the next page of results.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent project where subnetworks are usable.
  ## Specified in the format 'projects/*'.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The max number of results per page that should be returned. If the number
  ## of available results is larger than `page_size`, a `next_page_token` is
  ## returned which can be used to get the next page of results in subsequent
  ## requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Filtering currently only supports equality on the networkProjectId and must
  ## be in the form: "networkProjectId=[PROJECTID]", where `networkProjectId`
  ## is the project which owns the listed subnetworks. This defaults to the
  ## parent project ID.
  var path_595127 = newJObject()
  var query_595128 = newJObject()
  add(query_595128, "upload_protocol", newJString(uploadProtocol))
  add(query_595128, "fields", newJString(fields))
  add(query_595128, "pageToken", newJString(pageToken))
  add(query_595128, "quotaUser", newJString(quotaUser))
  add(query_595128, "alt", newJString(alt))
  add(query_595128, "oauth_token", newJString(oauthToken))
  add(query_595128, "callback", newJString(callback))
  add(query_595128, "access_token", newJString(accessToken))
  add(query_595128, "uploadType", newJString(uploadType))
  add(path_595127, "parent", newJString(parent))
  add(query_595128, "key", newJString(key))
  add(query_595128, "$.xgafv", newJString(Xgafv))
  add(query_595128, "pageSize", newJInt(pageSize))
  add(query_595128, "prettyPrint", newJBool(prettyPrint))
  add(query_595128, "filter", newJString(filter))
  result = call_595126.call(path_595127, query_595128, nil, nil, nil)

var containerProjectsAggregatedUsableSubnetworksList* = Call_ContainerProjectsAggregatedUsableSubnetworksList_595107(
    name: "containerProjectsAggregatedUsableSubnetworksList",
    meth: HttpMethod.HttpGet, host: "container.googleapis.com",
    route: "/v1/{parent}/aggregated/usableSubnetworks",
    validator: validate_ContainerProjectsAggregatedUsableSubnetworksList_595108,
    base: "/", url: url_ContainerProjectsAggregatedUsableSubnetworksList_595109,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersCreate_595150 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersCreate_595152(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersCreate_595151(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a cluster, consisting of the specified number and type of Google
  ## Compute Engine instances.
  ## 
  ## By default, the cluster is created in the project's
  ## [default network](/compute/docs/networks-and-firewalls#networks).
  ## 
  ## One firewall is added for the cluster. After cluster creation,
  ## the Kubelet creates routes for each node to allow the containers
  ## on that node to communicate with all other instances in the
  ## cluster.
  ## 
  ## Finally, an entry is added to the project's global metadata indicating
  ## which CIDR range the cluster is using.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent (project and location) where the cluster will be created.
  ## Specified in the format 'projects/*/locations/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_595153 = path.getOrDefault("parent")
  valid_595153 = validateParameter(valid_595153, JString, required = true,
                                 default = nil)
  if valid_595153 != nil:
    section.add "parent", valid_595153
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
  section = newJObject()
  var valid_595154 = query.getOrDefault("upload_protocol")
  valid_595154 = validateParameter(valid_595154, JString, required = false,
                                 default = nil)
  if valid_595154 != nil:
    section.add "upload_protocol", valid_595154
  var valid_595155 = query.getOrDefault("fields")
  valid_595155 = validateParameter(valid_595155, JString, required = false,
                                 default = nil)
  if valid_595155 != nil:
    section.add "fields", valid_595155
  var valid_595156 = query.getOrDefault("quotaUser")
  valid_595156 = validateParameter(valid_595156, JString, required = false,
                                 default = nil)
  if valid_595156 != nil:
    section.add "quotaUser", valid_595156
  var valid_595157 = query.getOrDefault("alt")
  valid_595157 = validateParameter(valid_595157, JString, required = false,
                                 default = newJString("json"))
  if valid_595157 != nil:
    section.add "alt", valid_595157
  var valid_595158 = query.getOrDefault("oauth_token")
  valid_595158 = validateParameter(valid_595158, JString, required = false,
                                 default = nil)
  if valid_595158 != nil:
    section.add "oauth_token", valid_595158
  var valid_595159 = query.getOrDefault("callback")
  valid_595159 = validateParameter(valid_595159, JString, required = false,
                                 default = nil)
  if valid_595159 != nil:
    section.add "callback", valid_595159
  var valid_595160 = query.getOrDefault("access_token")
  valid_595160 = validateParameter(valid_595160, JString, required = false,
                                 default = nil)
  if valid_595160 != nil:
    section.add "access_token", valid_595160
  var valid_595161 = query.getOrDefault("uploadType")
  valid_595161 = validateParameter(valid_595161, JString, required = false,
                                 default = nil)
  if valid_595161 != nil:
    section.add "uploadType", valid_595161
  var valid_595162 = query.getOrDefault("key")
  valid_595162 = validateParameter(valid_595162, JString, required = false,
                                 default = nil)
  if valid_595162 != nil:
    section.add "key", valid_595162
  var valid_595163 = query.getOrDefault("$.xgafv")
  valid_595163 = validateParameter(valid_595163, JString, required = false,
                                 default = newJString("1"))
  if valid_595163 != nil:
    section.add "$.xgafv", valid_595163
  var valid_595164 = query.getOrDefault("prettyPrint")
  valid_595164 = validateParameter(valid_595164, JBool, required = false,
                                 default = newJBool(true))
  if valid_595164 != nil:
    section.add "prettyPrint", valid_595164
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

proc call*(call_595166: Call_ContainerProjectsLocationsClustersCreate_595150;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a cluster, consisting of the specified number and type of Google
  ## Compute Engine instances.
  ## 
  ## By default, the cluster is created in the project's
  ## [default network](/compute/docs/networks-and-firewalls#networks).
  ## 
  ## One firewall is added for the cluster. After cluster creation,
  ## the Kubelet creates routes for each node to allow the containers
  ## on that node to communicate with all other instances in the
  ## cluster.
  ## 
  ## Finally, an entry is added to the project's global metadata indicating
  ## which CIDR range the cluster is using.
  ## 
  let valid = call_595166.validator(path, query, header, formData, body)
  let scheme = call_595166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595166.url(scheme.get, call_595166.host, call_595166.base,
                         call_595166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595166, url, valid)

proc call*(call_595167: Call_ContainerProjectsLocationsClustersCreate_595150;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containerProjectsLocationsClustersCreate
  ## Creates a cluster, consisting of the specified number and type of Google
  ## Compute Engine instances.
  ## 
  ## By default, the cluster is created in the project's
  ## [default network](/compute/docs/networks-and-firewalls#networks).
  ## 
  ## One firewall is added for the cluster. After cluster creation,
  ## the Kubelet creates routes for each node to allow the containers
  ## on that node to communicate with all other instances in the
  ## cluster.
  ## 
  ## Finally, an entry is added to the project's global metadata indicating
  ## which CIDR range the cluster is using.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  var path_595168 = newJObject()
  var query_595169 = newJObject()
  var body_595170 = newJObject()
  add(query_595169, "upload_protocol", newJString(uploadProtocol))
  add(query_595169, "fields", newJString(fields))
  add(query_595169, "quotaUser", newJString(quotaUser))
  add(query_595169, "alt", newJString(alt))
  add(query_595169, "oauth_token", newJString(oauthToken))
  add(query_595169, "callback", newJString(callback))
  add(query_595169, "access_token", newJString(accessToken))
  add(query_595169, "uploadType", newJString(uploadType))
  add(path_595168, "parent", newJString(parent))
  add(query_595169, "key", newJString(key))
  add(query_595169, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_595170 = body
  add(query_595169, "prettyPrint", newJBool(prettyPrint))
  result = call_595167.call(path_595168, query_595169, nil, nil, body_595170)

var containerProjectsLocationsClustersCreate* = Call_ContainerProjectsLocationsClustersCreate_595150(
    name: "containerProjectsLocationsClustersCreate", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1/{parent}/clusters",
    validator: validate_ContainerProjectsLocationsClustersCreate_595151,
    base: "/", url: url_ContainerProjectsLocationsClustersCreate_595152,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersList_595129 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersList_595131(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersList_595130(path: JsonNode;
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
  var valid_595132 = path.getOrDefault("parent")
  valid_595132 = validateParameter(valid_595132, JString, required = true,
                                 default = nil)
  if valid_595132 != nil:
    section.add "parent", valid_595132
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
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   zone: JString
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides, or "-" for all zones.
  ## This field has been deprecated and replaced by the parent field.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the parent field.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_595133 = query.getOrDefault("upload_protocol")
  valid_595133 = validateParameter(valid_595133, JString, required = false,
                                 default = nil)
  if valid_595133 != nil:
    section.add "upload_protocol", valid_595133
  var valid_595134 = query.getOrDefault("fields")
  valid_595134 = validateParameter(valid_595134, JString, required = false,
                                 default = nil)
  if valid_595134 != nil:
    section.add "fields", valid_595134
  var valid_595135 = query.getOrDefault("quotaUser")
  valid_595135 = validateParameter(valid_595135, JString, required = false,
                                 default = nil)
  if valid_595135 != nil:
    section.add "quotaUser", valid_595135
  var valid_595136 = query.getOrDefault("alt")
  valid_595136 = validateParameter(valid_595136, JString, required = false,
                                 default = newJString("json"))
  if valid_595136 != nil:
    section.add "alt", valid_595136
  var valid_595137 = query.getOrDefault("oauth_token")
  valid_595137 = validateParameter(valid_595137, JString, required = false,
                                 default = nil)
  if valid_595137 != nil:
    section.add "oauth_token", valid_595137
  var valid_595138 = query.getOrDefault("callback")
  valid_595138 = validateParameter(valid_595138, JString, required = false,
                                 default = nil)
  if valid_595138 != nil:
    section.add "callback", valid_595138
  var valid_595139 = query.getOrDefault("access_token")
  valid_595139 = validateParameter(valid_595139, JString, required = false,
                                 default = nil)
  if valid_595139 != nil:
    section.add "access_token", valid_595139
  var valid_595140 = query.getOrDefault("uploadType")
  valid_595140 = validateParameter(valid_595140, JString, required = false,
                                 default = nil)
  if valid_595140 != nil:
    section.add "uploadType", valid_595140
  var valid_595141 = query.getOrDefault("zone")
  valid_595141 = validateParameter(valid_595141, JString, required = false,
                                 default = nil)
  if valid_595141 != nil:
    section.add "zone", valid_595141
  var valid_595142 = query.getOrDefault("key")
  valid_595142 = validateParameter(valid_595142, JString, required = false,
                                 default = nil)
  if valid_595142 != nil:
    section.add "key", valid_595142
  var valid_595143 = query.getOrDefault("$.xgafv")
  valid_595143 = validateParameter(valid_595143, JString, required = false,
                                 default = newJString("1"))
  if valid_595143 != nil:
    section.add "$.xgafv", valid_595143
  var valid_595144 = query.getOrDefault("projectId")
  valid_595144 = validateParameter(valid_595144, JString, required = false,
                                 default = nil)
  if valid_595144 != nil:
    section.add "projectId", valid_595144
  var valid_595145 = query.getOrDefault("prettyPrint")
  valid_595145 = validateParameter(valid_595145, JBool, required = false,
                                 default = newJBool(true))
  if valid_595145 != nil:
    section.add "prettyPrint", valid_595145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595146: Call_ContainerProjectsLocationsClustersList_595129;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all clusters owned by a project in either the specified zone or all
  ## zones.
  ## 
  let valid = call_595146.validator(path, query, header, formData, body)
  let scheme = call_595146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595146.url(scheme.get, call_595146.host, call_595146.base,
                         call_595146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595146, url, valid)

proc call*(call_595147: Call_ContainerProjectsLocationsClustersList_595129;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          zone: string = ""; key: string = ""; Xgafv: string = "1"; projectId: string = "";
          prettyPrint: bool = true): Recallable =
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
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides, or "-" for all zones.
  ## This field has been deprecated and replaced by the parent field.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the parent field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_595148 = newJObject()
  var query_595149 = newJObject()
  add(query_595149, "upload_protocol", newJString(uploadProtocol))
  add(query_595149, "fields", newJString(fields))
  add(query_595149, "quotaUser", newJString(quotaUser))
  add(query_595149, "alt", newJString(alt))
  add(query_595149, "oauth_token", newJString(oauthToken))
  add(query_595149, "callback", newJString(callback))
  add(query_595149, "access_token", newJString(accessToken))
  add(query_595149, "uploadType", newJString(uploadType))
  add(path_595148, "parent", newJString(parent))
  add(query_595149, "zone", newJString(zone))
  add(query_595149, "key", newJString(key))
  add(query_595149, "$.xgafv", newJString(Xgafv))
  add(query_595149, "projectId", newJString(projectId))
  add(query_595149, "prettyPrint", newJBool(prettyPrint))
  result = call_595147.call(path_595148, query_595149, nil, nil, nil)

var containerProjectsLocationsClustersList* = Call_ContainerProjectsLocationsClustersList_595129(
    name: "containerProjectsLocationsClustersList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1/{parent}/clusters",
    validator: validate_ContainerProjectsLocationsClustersList_595130, base: "/",
    url: url_ContainerProjectsLocationsClustersList_595131,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersGetJwks_595171 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersGetJwks_595173(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/jwks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersGetJwks_595172(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the public component of the cluster signing keys in
  ## JSON Web Key format.
  ## This API is not yet intended for general use, and is not available for all
  ## clusters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The cluster (project, location, cluster id) to get keys for. Specified in
  ## the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_595174 = path.getOrDefault("parent")
  valid_595174 = validateParameter(valid_595174, JString, required = true,
                                 default = nil)
  if valid_595174 != nil:
    section.add "parent", valid_595174
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
  section = newJObject()
  var valid_595175 = query.getOrDefault("upload_protocol")
  valid_595175 = validateParameter(valid_595175, JString, required = false,
                                 default = nil)
  if valid_595175 != nil:
    section.add "upload_protocol", valid_595175
  var valid_595176 = query.getOrDefault("fields")
  valid_595176 = validateParameter(valid_595176, JString, required = false,
                                 default = nil)
  if valid_595176 != nil:
    section.add "fields", valid_595176
  var valid_595177 = query.getOrDefault("quotaUser")
  valid_595177 = validateParameter(valid_595177, JString, required = false,
                                 default = nil)
  if valid_595177 != nil:
    section.add "quotaUser", valid_595177
  var valid_595178 = query.getOrDefault("alt")
  valid_595178 = validateParameter(valid_595178, JString, required = false,
                                 default = newJString("json"))
  if valid_595178 != nil:
    section.add "alt", valid_595178
  var valid_595179 = query.getOrDefault("oauth_token")
  valid_595179 = validateParameter(valid_595179, JString, required = false,
                                 default = nil)
  if valid_595179 != nil:
    section.add "oauth_token", valid_595179
  var valid_595180 = query.getOrDefault("callback")
  valid_595180 = validateParameter(valid_595180, JString, required = false,
                                 default = nil)
  if valid_595180 != nil:
    section.add "callback", valid_595180
  var valid_595181 = query.getOrDefault("access_token")
  valid_595181 = validateParameter(valid_595181, JString, required = false,
                                 default = nil)
  if valid_595181 != nil:
    section.add "access_token", valid_595181
  var valid_595182 = query.getOrDefault("uploadType")
  valid_595182 = validateParameter(valid_595182, JString, required = false,
                                 default = nil)
  if valid_595182 != nil:
    section.add "uploadType", valid_595182
  var valid_595183 = query.getOrDefault("key")
  valid_595183 = validateParameter(valid_595183, JString, required = false,
                                 default = nil)
  if valid_595183 != nil:
    section.add "key", valid_595183
  var valid_595184 = query.getOrDefault("$.xgafv")
  valid_595184 = validateParameter(valid_595184, JString, required = false,
                                 default = newJString("1"))
  if valid_595184 != nil:
    section.add "$.xgafv", valid_595184
  var valid_595185 = query.getOrDefault("prettyPrint")
  valid_595185 = validateParameter(valid_595185, JBool, required = false,
                                 default = newJBool(true))
  if valid_595185 != nil:
    section.add "prettyPrint", valid_595185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595186: Call_ContainerProjectsLocationsClustersGetJwks_595171;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the public component of the cluster signing keys in
  ## JSON Web Key format.
  ## This API is not yet intended for general use, and is not available for all
  ## clusters.
  ## 
  let valid = call_595186.validator(path, query, header, formData, body)
  let scheme = call_595186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595186.url(scheme.get, call_595186.host, call_595186.base,
                         call_595186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595186, url, valid)

proc call*(call_595187: Call_ContainerProjectsLocationsClustersGetJwks_595171;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## containerProjectsLocationsClustersGetJwks
  ## Gets the public component of the cluster signing keys in
  ## JSON Web Key format.
  ## This API is not yet intended for general use, and is not available for all
  ## clusters.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The cluster (project, location, cluster id) to get keys for. Specified in
  ## the format 'projects/*/locations/*/clusters/*'.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_595188 = newJObject()
  var query_595189 = newJObject()
  add(query_595189, "upload_protocol", newJString(uploadProtocol))
  add(query_595189, "fields", newJString(fields))
  add(query_595189, "quotaUser", newJString(quotaUser))
  add(query_595189, "alt", newJString(alt))
  add(query_595189, "oauth_token", newJString(oauthToken))
  add(query_595189, "callback", newJString(callback))
  add(query_595189, "access_token", newJString(accessToken))
  add(query_595189, "uploadType", newJString(uploadType))
  add(path_595188, "parent", newJString(parent))
  add(query_595189, "key", newJString(key))
  add(query_595189, "$.xgafv", newJString(Xgafv))
  add(query_595189, "prettyPrint", newJBool(prettyPrint))
  result = call_595187.call(path_595188, query_595189, nil, nil, nil)

var containerProjectsLocationsClustersGetJwks* = Call_ContainerProjectsLocationsClustersGetJwks_595171(
    name: "containerProjectsLocationsClustersGetJwks", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1/{parent}/jwks",
    validator: validate_ContainerProjectsLocationsClustersGetJwks_595172,
    base: "/", url: url_ContainerProjectsLocationsClustersGetJwks_595173,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsCreate_595212 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersNodePoolsCreate_595214(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/nodePools")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsCreate_595213(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a node pool for a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent (project, location, cluster id) where the node pool will be
  ## created. Specified in the format
  ## 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_595215 = path.getOrDefault("parent")
  valid_595215 = validateParameter(valid_595215, JString, required = true,
                                 default = nil)
  if valid_595215 != nil:
    section.add "parent", valid_595215
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
  section = newJObject()
  var valid_595216 = query.getOrDefault("upload_protocol")
  valid_595216 = validateParameter(valid_595216, JString, required = false,
                                 default = nil)
  if valid_595216 != nil:
    section.add "upload_protocol", valid_595216
  var valid_595217 = query.getOrDefault("fields")
  valid_595217 = validateParameter(valid_595217, JString, required = false,
                                 default = nil)
  if valid_595217 != nil:
    section.add "fields", valid_595217
  var valid_595218 = query.getOrDefault("quotaUser")
  valid_595218 = validateParameter(valid_595218, JString, required = false,
                                 default = nil)
  if valid_595218 != nil:
    section.add "quotaUser", valid_595218
  var valid_595219 = query.getOrDefault("alt")
  valid_595219 = validateParameter(valid_595219, JString, required = false,
                                 default = newJString("json"))
  if valid_595219 != nil:
    section.add "alt", valid_595219
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

proc call*(call_595228: Call_ContainerProjectsLocationsClustersNodePoolsCreate_595212;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a node pool for a cluster.
  ## 
  let valid = call_595228.validator(path, query, header, formData, body)
  let scheme = call_595228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595228.url(scheme.get, call_595228.host, call_595228.base,
                         call_595228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595228, url, valid)

proc call*(call_595229: Call_ContainerProjectsLocationsClustersNodePoolsCreate_595212;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent (project, location, cluster id) where the node pool will be
  ## created. Specified in the format
  ## 'projects/*/locations/*/clusters/*'.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_595230 = newJObject()
  var query_595231 = newJObject()
  var body_595232 = newJObject()
  add(query_595231, "upload_protocol", newJString(uploadProtocol))
  add(query_595231, "fields", newJString(fields))
  add(query_595231, "quotaUser", newJString(quotaUser))
  add(query_595231, "alt", newJString(alt))
  add(query_595231, "oauth_token", newJString(oauthToken))
  add(query_595231, "callback", newJString(callback))
  add(query_595231, "access_token", newJString(accessToken))
  add(query_595231, "uploadType", newJString(uploadType))
  add(path_595230, "parent", newJString(parent))
  add(query_595231, "key", newJString(key))
  add(query_595231, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_595232 = body
  add(query_595231, "prettyPrint", newJBool(prettyPrint))
  result = call_595229.call(path_595230, query_595231, nil, nil, body_595232)

var containerProjectsLocationsClustersNodePoolsCreate* = Call_ContainerProjectsLocationsClustersNodePoolsCreate_595212(
    name: "containerProjectsLocationsClustersNodePoolsCreate",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{parent}/nodePools",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsCreate_595213,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsCreate_595214,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsList_595190 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsClustersNodePoolsList_595192(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/nodePools")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsList_595191(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the node pools for a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent (project, location, cluster id) where the node pools will be
  ## listed. Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_595193 = path.getOrDefault("parent")
  valid_595193 = validateParameter(valid_595193, JString, required = true,
                                 default = nil)
  if valid_595193 != nil:
    section.add "parent", valid_595193
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
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   zone: JString
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the parent field.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the parent field.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: JString
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the parent field.
  section = newJObject()
  var valid_595194 = query.getOrDefault("upload_protocol")
  valid_595194 = validateParameter(valid_595194, JString, required = false,
                                 default = nil)
  if valid_595194 != nil:
    section.add "upload_protocol", valid_595194
  var valid_595195 = query.getOrDefault("fields")
  valid_595195 = validateParameter(valid_595195, JString, required = false,
                                 default = nil)
  if valid_595195 != nil:
    section.add "fields", valid_595195
  var valid_595196 = query.getOrDefault("quotaUser")
  valid_595196 = validateParameter(valid_595196, JString, required = false,
                                 default = nil)
  if valid_595196 != nil:
    section.add "quotaUser", valid_595196
  var valid_595197 = query.getOrDefault("alt")
  valid_595197 = validateParameter(valid_595197, JString, required = false,
                                 default = newJString("json"))
  if valid_595197 != nil:
    section.add "alt", valid_595197
  var valid_595198 = query.getOrDefault("oauth_token")
  valid_595198 = validateParameter(valid_595198, JString, required = false,
                                 default = nil)
  if valid_595198 != nil:
    section.add "oauth_token", valid_595198
  var valid_595199 = query.getOrDefault("callback")
  valid_595199 = validateParameter(valid_595199, JString, required = false,
                                 default = nil)
  if valid_595199 != nil:
    section.add "callback", valid_595199
  var valid_595200 = query.getOrDefault("access_token")
  valid_595200 = validateParameter(valid_595200, JString, required = false,
                                 default = nil)
  if valid_595200 != nil:
    section.add "access_token", valid_595200
  var valid_595201 = query.getOrDefault("uploadType")
  valid_595201 = validateParameter(valid_595201, JString, required = false,
                                 default = nil)
  if valid_595201 != nil:
    section.add "uploadType", valid_595201
  var valid_595202 = query.getOrDefault("zone")
  valid_595202 = validateParameter(valid_595202, JString, required = false,
                                 default = nil)
  if valid_595202 != nil:
    section.add "zone", valid_595202
  var valid_595203 = query.getOrDefault("key")
  valid_595203 = validateParameter(valid_595203, JString, required = false,
                                 default = nil)
  if valid_595203 != nil:
    section.add "key", valid_595203
  var valid_595204 = query.getOrDefault("$.xgafv")
  valid_595204 = validateParameter(valid_595204, JString, required = false,
                                 default = newJString("1"))
  if valid_595204 != nil:
    section.add "$.xgafv", valid_595204
  var valid_595205 = query.getOrDefault("projectId")
  valid_595205 = validateParameter(valid_595205, JString, required = false,
                                 default = nil)
  if valid_595205 != nil:
    section.add "projectId", valid_595205
  var valid_595206 = query.getOrDefault("prettyPrint")
  valid_595206 = validateParameter(valid_595206, JBool, required = false,
                                 default = newJBool(true))
  if valid_595206 != nil:
    section.add "prettyPrint", valid_595206
  var valid_595207 = query.getOrDefault("clusterId")
  valid_595207 = validateParameter(valid_595207, JString, required = false,
                                 default = nil)
  if valid_595207 != nil:
    section.add "clusterId", valid_595207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595208: Call_ContainerProjectsLocationsClustersNodePoolsList_595190;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the node pools for a cluster.
  ## 
  let valid = call_595208.validator(path, query, header, formData, body)
  let scheme = call_595208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595208.url(scheme.get, call_595208.host, call_595208.base,
                         call_595208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595208, url, valid)

proc call*(call_595209: Call_ContainerProjectsLocationsClustersNodePoolsList_595190;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          zone: string = ""; key: string = ""; Xgafv: string = "1"; projectId: string = "";
          prettyPrint: bool = true; clusterId: string = ""): Recallable =
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
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent (project, location, cluster id) where the node pools will be
  ## listed. Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   zone: string
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the parent field.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the parent field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the parent field.
  var path_595210 = newJObject()
  var query_595211 = newJObject()
  add(query_595211, "upload_protocol", newJString(uploadProtocol))
  add(query_595211, "fields", newJString(fields))
  add(query_595211, "quotaUser", newJString(quotaUser))
  add(query_595211, "alt", newJString(alt))
  add(query_595211, "oauth_token", newJString(oauthToken))
  add(query_595211, "callback", newJString(callback))
  add(query_595211, "access_token", newJString(accessToken))
  add(query_595211, "uploadType", newJString(uploadType))
  add(path_595210, "parent", newJString(parent))
  add(query_595211, "zone", newJString(zone))
  add(query_595211, "key", newJString(key))
  add(query_595211, "$.xgafv", newJString(Xgafv))
  add(query_595211, "projectId", newJString(projectId))
  add(query_595211, "prettyPrint", newJBool(prettyPrint))
  add(query_595211, "clusterId", newJString(clusterId))
  result = call_595209.call(path_595210, query_595211, nil, nil, nil)

var containerProjectsLocationsClustersNodePoolsList* = Call_ContainerProjectsLocationsClustersNodePoolsList_595190(
    name: "containerProjectsLocationsClustersNodePoolsList",
    meth: HttpMethod.HttpGet, host: "container.googleapis.com",
    route: "/v1/{parent}/nodePools",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsList_595191,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsList_595192,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsOperationsList_595233 = ref object of OpenApiRestCall_593421
proc url_ContainerProjectsLocationsOperationsList_595235(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsOperationsList_595234(path: JsonNode;
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
  var valid_595236 = path.getOrDefault("parent")
  valid_595236 = validateParameter(valid_595236, JString, required = true,
                                 default = nil)
  if valid_595236 != nil:
    section.add "parent", valid_595236
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
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   zone: JString
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) to return operations for, or `-` for
  ## all zones. This field has been deprecated and replaced by the parent field.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the parent field.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_595237 = query.getOrDefault("upload_protocol")
  valid_595237 = validateParameter(valid_595237, JString, required = false,
                                 default = nil)
  if valid_595237 != nil:
    section.add "upload_protocol", valid_595237
  var valid_595238 = query.getOrDefault("fields")
  valid_595238 = validateParameter(valid_595238, JString, required = false,
                                 default = nil)
  if valid_595238 != nil:
    section.add "fields", valid_595238
  var valid_595239 = query.getOrDefault("quotaUser")
  valid_595239 = validateParameter(valid_595239, JString, required = false,
                                 default = nil)
  if valid_595239 != nil:
    section.add "quotaUser", valid_595239
  var valid_595240 = query.getOrDefault("alt")
  valid_595240 = validateParameter(valid_595240, JString, required = false,
                                 default = newJString("json"))
  if valid_595240 != nil:
    section.add "alt", valid_595240
  var valid_595241 = query.getOrDefault("oauth_token")
  valid_595241 = validateParameter(valid_595241, JString, required = false,
                                 default = nil)
  if valid_595241 != nil:
    section.add "oauth_token", valid_595241
  var valid_595242 = query.getOrDefault("callback")
  valid_595242 = validateParameter(valid_595242, JString, required = false,
                                 default = nil)
  if valid_595242 != nil:
    section.add "callback", valid_595242
  var valid_595243 = query.getOrDefault("access_token")
  valid_595243 = validateParameter(valid_595243, JString, required = false,
                                 default = nil)
  if valid_595243 != nil:
    section.add "access_token", valid_595243
  var valid_595244 = query.getOrDefault("uploadType")
  valid_595244 = validateParameter(valid_595244, JString, required = false,
                                 default = nil)
  if valid_595244 != nil:
    section.add "uploadType", valid_595244
  var valid_595245 = query.getOrDefault("zone")
  valid_595245 = validateParameter(valid_595245, JString, required = false,
                                 default = nil)
  if valid_595245 != nil:
    section.add "zone", valid_595245
  var valid_595246 = query.getOrDefault("key")
  valid_595246 = validateParameter(valid_595246, JString, required = false,
                                 default = nil)
  if valid_595246 != nil:
    section.add "key", valid_595246
  var valid_595247 = query.getOrDefault("$.xgafv")
  valid_595247 = validateParameter(valid_595247, JString, required = false,
                                 default = newJString("1"))
  if valid_595247 != nil:
    section.add "$.xgafv", valid_595247
  var valid_595248 = query.getOrDefault("projectId")
  valid_595248 = validateParameter(valid_595248, JString, required = false,
                                 default = nil)
  if valid_595248 != nil:
    section.add "projectId", valid_595248
  var valid_595249 = query.getOrDefault("prettyPrint")
  valid_595249 = validateParameter(valid_595249, JBool, required = false,
                                 default = newJBool(true))
  if valid_595249 != nil:
    section.add "prettyPrint", valid_595249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595250: Call_ContainerProjectsLocationsOperationsList_595233;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all operations in a project in a specific zone or all zones.
  ## 
  let valid = call_595250.validator(path, query, header, formData, body)
  let scheme = call_595250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595250.url(scheme.get, call_595250.host, call_595250.base,
                         call_595250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595250, url, valid)

proc call*(call_595251: Call_ContainerProjectsLocationsOperationsList_595233;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          zone: string = ""; key: string = ""; Xgafv: string = "1"; projectId: string = "";
          prettyPrint: bool = true): Recallable =
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
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) to return operations for, or `-` for
  ## all zones. This field has been deprecated and replaced by the parent field.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the parent field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_595252 = newJObject()
  var query_595253 = newJObject()
  add(query_595253, "upload_protocol", newJString(uploadProtocol))
  add(query_595253, "fields", newJString(fields))
  add(query_595253, "quotaUser", newJString(quotaUser))
  add(query_595253, "alt", newJString(alt))
  add(query_595253, "oauth_token", newJString(oauthToken))
  add(query_595253, "callback", newJString(callback))
  add(query_595253, "access_token", newJString(accessToken))
  add(query_595253, "uploadType", newJString(uploadType))
  add(path_595252, "parent", newJString(parent))
  add(query_595253, "zone", newJString(zone))
  add(query_595253, "key", newJString(key))
  add(query_595253, "$.xgafv", newJString(Xgafv))
  add(query_595253, "projectId", newJString(projectId))
  add(query_595253, "prettyPrint", newJBool(prettyPrint))
  result = call_595251.call(path_595252, query_595253, nil, nil, nil)

var containerProjectsLocationsOperationsList* = Call_ContainerProjectsLocationsOperationsList_595233(
    name: "containerProjectsLocationsOperationsList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1/{parent}/operations",
    validator: validate_ContainerProjectsLocationsOperationsList_595234,
    base: "/", url: url_ContainerProjectsLocationsOperationsList_595235,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
