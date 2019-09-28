
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Cloud Deployment Manager Alpha
## version: alpha
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## The Deployment Manager API allows users to declaratively configure, deploy and run complex solutions on the Google Cloud Platform.
## 
## https://cloud.google.com/deployment-manager/
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

  OpenApiRestCall_579437 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579437](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579437): Option[Scheme] {.used.} =
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
  gcpServiceName = "deploymentmanager"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DeploymentmanagerCompositeTypesInsert_579994 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerCompositeTypesInsert_579996(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/compositeTypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerCompositeTypesInsert_579995(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a composite type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_579997 = path.getOrDefault("project")
  valid_579997 = validateParameter(valid_579997, JString, required = true,
                                 default = nil)
  if valid_579997 != nil:
    section.add "project", valid_579997
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
  var valid_579998 = query.getOrDefault("fields")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "fields", valid_579998
  var valid_579999 = query.getOrDefault("quotaUser")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "quotaUser", valid_579999
  var valid_580000 = query.getOrDefault("alt")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = newJString("json"))
  if valid_580000 != nil:
    section.add "alt", valid_580000
  var valid_580001 = query.getOrDefault("oauth_token")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "oauth_token", valid_580001
  var valid_580002 = query.getOrDefault("userIp")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "userIp", valid_580002
  var valid_580003 = query.getOrDefault("key")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "key", valid_580003
  var valid_580004 = query.getOrDefault("prettyPrint")
  valid_580004 = validateParameter(valid_580004, JBool, required = false,
                                 default = newJBool(true))
  if valid_580004 != nil:
    section.add "prettyPrint", valid_580004
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

proc call*(call_580006: Call_DeploymentmanagerCompositeTypesInsert_579994;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a composite type.
  ## 
  let valid = call_580006.validator(path, query, header, formData, body)
  let scheme = call_580006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580006.url(scheme.get, call_580006.host, call_580006.base,
                         call_580006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580006, url, valid)

proc call*(call_580007: Call_DeploymentmanagerCompositeTypesInsert_579994;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## deploymentmanagerCompositeTypesInsert
  ## Creates a composite type.
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
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580008 = newJObject()
  var query_580009 = newJObject()
  var body_580010 = newJObject()
  add(query_580009, "fields", newJString(fields))
  add(query_580009, "quotaUser", newJString(quotaUser))
  add(query_580009, "alt", newJString(alt))
  add(query_580009, "oauth_token", newJString(oauthToken))
  add(query_580009, "userIp", newJString(userIp))
  add(query_580009, "key", newJString(key))
  add(path_580008, "project", newJString(project))
  if body != nil:
    body_580010 = body
  add(query_580009, "prettyPrint", newJBool(prettyPrint))
  result = call_580007.call(path_580008, query_580009, nil, nil, body_580010)

var deploymentmanagerCompositeTypesInsert* = Call_DeploymentmanagerCompositeTypesInsert_579994(
    name: "deploymentmanagerCompositeTypesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/global/compositeTypes",
    validator: validate_DeploymentmanagerCompositeTypesInsert_579995,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerCompositeTypesInsert_579996, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerCompositeTypesList_579705 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerCompositeTypesList_579707(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/compositeTypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerCompositeTypesList_579706(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all composite types for Deployment Manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_579833 = path.getOrDefault("project")
  valid_579833 = validateParameter(valid_579833, JString, required = true,
                                 default = nil)
  if valid_579833 != nil:
    section.add "project", valid_579833
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  ##   orderBy: JString
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  section = newJObject()
  var valid_579834 = query.getOrDefault("fields")
  valid_579834 = validateParameter(valid_579834, JString, required = false,
                                 default = nil)
  if valid_579834 != nil:
    section.add "fields", valid_579834
  var valid_579835 = query.getOrDefault("pageToken")
  valid_579835 = validateParameter(valid_579835, JString, required = false,
                                 default = nil)
  if valid_579835 != nil:
    section.add "pageToken", valid_579835
  var valid_579836 = query.getOrDefault("quotaUser")
  valid_579836 = validateParameter(valid_579836, JString, required = false,
                                 default = nil)
  if valid_579836 != nil:
    section.add "quotaUser", valid_579836
  var valid_579850 = query.getOrDefault("alt")
  valid_579850 = validateParameter(valid_579850, JString, required = false,
                                 default = newJString("json"))
  if valid_579850 != nil:
    section.add "alt", valid_579850
  var valid_579851 = query.getOrDefault("oauth_token")
  valid_579851 = validateParameter(valid_579851, JString, required = false,
                                 default = nil)
  if valid_579851 != nil:
    section.add "oauth_token", valid_579851
  var valid_579852 = query.getOrDefault("userIp")
  valid_579852 = validateParameter(valid_579852, JString, required = false,
                                 default = nil)
  if valid_579852 != nil:
    section.add "userIp", valid_579852
  var valid_579854 = query.getOrDefault("maxResults")
  valid_579854 = validateParameter(valid_579854, JInt, required = false,
                                 default = newJInt(500))
  if valid_579854 != nil:
    section.add "maxResults", valid_579854
  var valid_579855 = query.getOrDefault("orderBy")
  valid_579855 = validateParameter(valid_579855, JString, required = false,
                                 default = nil)
  if valid_579855 != nil:
    section.add "orderBy", valid_579855
  var valid_579856 = query.getOrDefault("key")
  valid_579856 = validateParameter(valid_579856, JString, required = false,
                                 default = nil)
  if valid_579856 != nil:
    section.add "key", valid_579856
  var valid_579857 = query.getOrDefault("prettyPrint")
  valid_579857 = validateParameter(valid_579857, JBool, required = false,
                                 default = newJBool(true))
  if valid_579857 != nil:
    section.add "prettyPrint", valid_579857
  var valid_579858 = query.getOrDefault("filter")
  valid_579858 = validateParameter(valid_579858, JString, required = false,
                                 default = nil)
  if valid_579858 != nil:
    section.add "filter", valid_579858
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579881: Call_DeploymentmanagerCompositeTypesList_579705;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all composite types for Deployment Manager.
  ## 
  let valid = call_579881.validator(path, query, header, formData, body)
  let scheme = call_579881.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579881.url(scheme.get, call_579881.host, call_579881.base,
                         call_579881.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579881, url, valid)

proc call*(call_579952: Call_DeploymentmanagerCompositeTypesList_579705;
          project: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 500; orderBy: string = "";
          key: string = ""; prettyPrint: bool = true; filter: string = ""): Recallable =
  ## deploymentmanagerCompositeTypesList
  ## Lists all composite types for Deployment Manager.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  ##   orderBy: string
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  var path_579953 = newJObject()
  var query_579955 = newJObject()
  add(query_579955, "fields", newJString(fields))
  add(query_579955, "pageToken", newJString(pageToken))
  add(query_579955, "quotaUser", newJString(quotaUser))
  add(query_579955, "alt", newJString(alt))
  add(query_579955, "oauth_token", newJString(oauthToken))
  add(query_579955, "userIp", newJString(userIp))
  add(query_579955, "maxResults", newJInt(maxResults))
  add(query_579955, "orderBy", newJString(orderBy))
  add(query_579955, "key", newJString(key))
  add(path_579953, "project", newJString(project))
  add(query_579955, "prettyPrint", newJBool(prettyPrint))
  add(query_579955, "filter", newJString(filter))
  result = call_579952.call(path_579953, query_579955, nil, nil, nil)

var deploymentmanagerCompositeTypesList* = Call_DeploymentmanagerCompositeTypesList_579705(
    name: "deploymentmanagerCompositeTypesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/compositeTypes",
    validator: validate_DeploymentmanagerCompositeTypesList_579706,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerCompositeTypesList_579707, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerCompositeTypesUpdate_580027 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerCompositeTypesUpdate_580029(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "compositeType" in path, "`compositeType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/compositeTypes/"),
               (kind: VariableSegment, value: "compositeType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerCompositeTypesUpdate_580028(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a composite type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project ID for this request.
  ##   compositeType: JString (required)
  ##                : The name of the composite type for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_580030 = path.getOrDefault("project")
  valid_580030 = validateParameter(valid_580030, JString, required = true,
                                 default = nil)
  if valid_580030 != nil:
    section.add "project", valid_580030
  var valid_580031 = path.getOrDefault("compositeType")
  valid_580031 = validateParameter(valid_580031, JString, required = true,
                                 default = nil)
  if valid_580031 != nil:
    section.add "compositeType", valid_580031
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
  var valid_580032 = query.getOrDefault("fields")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "fields", valid_580032
  var valid_580033 = query.getOrDefault("quotaUser")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "quotaUser", valid_580033
  var valid_580034 = query.getOrDefault("alt")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = newJString("json"))
  if valid_580034 != nil:
    section.add "alt", valid_580034
  var valid_580035 = query.getOrDefault("oauth_token")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "oauth_token", valid_580035
  var valid_580036 = query.getOrDefault("userIp")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "userIp", valid_580036
  var valid_580037 = query.getOrDefault("key")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "key", valid_580037
  var valid_580038 = query.getOrDefault("prettyPrint")
  valid_580038 = validateParameter(valid_580038, JBool, required = false,
                                 default = newJBool(true))
  if valid_580038 != nil:
    section.add "prettyPrint", valid_580038
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

proc call*(call_580040: Call_DeploymentmanagerCompositeTypesUpdate_580027;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a composite type.
  ## 
  let valid = call_580040.validator(path, query, header, formData, body)
  let scheme = call_580040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580040.url(scheme.get, call_580040.host, call_580040.base,
                         call_580040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580040, url, valid)

proc call*(call_580041: Call_DeploymentmanagerCompositeTypesUpdate_580027;
          project: string; compositeType: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## deploymentmanagerCompositeTypesUpdate
  ## Updates a composite type.
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
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   compositeType: string (required)
  ##                : The name of the composite type for this request.
  var path_580042 = newJObject()
  var query_580043 = newJObject()
  var body_580044 = newJObject()
  add(query_580043, "fields", newJString(fields))
  add(query_580043, "quotaUser", newJString(quotaUser))
  add(query_580043, "alt", newJString(alt))
  add(query_580043, "oauth_token", newJString(oauthToken))
  add(query_580043, "userIp", newJString(userIp))
  add(query_580043, "key", newJString(key))
  add(path_580042, "project", newJString(project))
  if body != nil:
    body_580044 = body
  add(query_580043, "prettyPrint", newJBool(prettyPrint))
  add(path_580042, "compositeType", newJString(compositeType))
  result = call_580041.call(path_580042, query_580043, nil, nil, body_580044)

var deploymentmanagerCompositeTypesUpdate* = Call_DeploymentmanagerCompositeTypesUpdate_580027(
    name: "deploymentmanagerCompositeTypesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{project}/global/compositeTypes/{compositeType}",
    validator: validate_DeploymentmanagerCompositeTypesUpdate_580028,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerCompositeTypesUpdate_580029, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerCompositeTypesGet_580011 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerCompositeTypesGet_580013(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "compositeType" in path, "`compositeType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/compositeTypes/"),
               (kind: VariableSegment, value: "compositeType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerCompositeTypesGet_580012(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about a specific composite type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project ID for this request.
  ##   compositeType: JString (required)
  ##                : The name of the composite type for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_580014 = path.getOrDefault("project")
  valid_580014 = validateParameter(valid_580014, JString, required = true,
                                 default = nil)
  if valid_580014 != nil:
    section.add "project", valid_580014
  var valid_580015 = path.getOrDefault("compositeType")
  valid_580015 = validateParameter(valid_580015, JString, required = true,
                                 default = nil)
  if valid_580015 != nil:
    section.add "compositeType", valid_580015
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
  var valid_580016 = query.getOrDefault("fields")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "fields", valid_580016
  var valid_580017 = query.getOrDefault("quotaUser")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "quotaUser", valid_580017
  var valid_580018 = query.getOrDefault("alt")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = newJString("json"))
  if valid_580018 != nil:
    section.add "alt", valid_580018
  var valid_580019 = query.getOrDefault("oauth_token")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "oauth_token", valid_580019
  var valid_580020 = query.getOrDefault("userIp")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "userIp", valid_580020
  var valid_580021 = query.getOrDefault("key")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "key", valid_580021
  var valid_580022 = query.getOrDefault("prettyPrint")
  valid_580022 = validateParameter(valid_580022, JBool, required = false,
                                 default = newJBool(true))
  if valid_580022 != nil:
    section.add "prettyPrint", valid_580022
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580023: Call_DeploymentmanagerCompositeTypesGet_580011;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about a specific composite type.
  ## 
  let valid = call_580023.validator(path, query, header, formData, body)
  let scheme = call_580023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580023.url(scheme.get, call_580023.host, call_580023.base,
                         call_580023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580023, url, valid)

proc call*(call_580024: Call_DeploymentmanagerCompositeTypesGet_580011;
          project: string; compositeType: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## deploymentmanagerCompositeTypesGet
  ## Gets information about a specific composite type.
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
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   compositeType: string (required)
  ##                : The name of the composite type for this request.
  var path_580025 = newJObject()
  var query_580026 = newJObject()
  add(query_580026, "fields", newJString(fields))
  add(query_580026, "quotaUser", newJString(quotaUser))
  add(query_580026, "alt", newJString(alt))
  add(query_580026, "oauth_token", newJString(oauthToken))
  add(query_580026, "userIp", newJString(userIp))
  add(query_580026, "key", newJString(key))
  add(path_580025, "project", newJString(project))
  add(query_580026, "prettyPrint", newJBool(prettyPrint))
  add(path_580025, "compositeType", newJString(compositeType))
  result = call_580024.call(path_580025, query_580026, nil, nil, nil)

var deploymentmanagerCompositeTypesGet* = Call_DeploymentmanagerCompositeTypesGet_580011(
    name: "deploymentmanagerCompositeTypesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/compositeTypes/{compositeType}",
    validator: validate_DeploymentmanagerCompositeTypesGet_580012,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerCompositeTypesGet_580013, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerCompositeTypesPatch_580061 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerCompositeTypesPatch_580063(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "compositeType" in path, "`compositeType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/compositeTypes/"),
               (kind: VariableSegment, value: "compositeType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerCompositeTypesPatch_580062(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a composite type. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project ID for this request.
  ##   compositeType: JString (required)
  ##                : The name of the composite type for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_580064 = path.getOrDefault("project")
  valid_580064 = validateParameter(valid_580064, JString, required = true,
                                 default = nil)
  if valid_580064 != nil:
    section.add "project", valid_580064
  var valid_580065 = path.getOrDefault("compositeType")
  valid_580065 = validateParameter(valid_580065, JString, required = true,
                                 default = nil)
  if valid_580065 != nil:
    section.add "compositeType", valid_580065
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
  var valid_580066 = query.getOrDefault("fields")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "fields", valid_580066
  var valid_580067 = query.getOrDefault("quotaUser")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "quotaUser", valid_580067
  var valid_580068 = query.getOrDefault("alt")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = newJString("json"))
  if valid_580068 != nil:
    section.add "alt", valid_580068
  var valid_580069 = query.getOrDefault("oauth_token")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "oauth_token", valid_580069
  var valid_580070 = query.getOrDefault("userIp")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "userIp", valid_580070
  var valid_580071 = query.getOrDefault("key")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "key", valid_580071
  var valid_580072 = query.getOrDefault("prettyPrint")
  valid_580072 = validateParameter(valid_580072, JBool, required = false,
                                 default = newJBool(true))
  if valid_580072 != nil:
    section.add "prettyPrint", valid_580072
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

proc call*(call_580074: Call_DeploymentmanagerCompositeTypesPatch_580061;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a composite type. This method supports patch semantics.
  ## 
  let valid = call_580074.validator(path, query, header, formData, body)
  let scheme = call_580074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580074.url(scheme.get, call_580074.host, call_580074.base,
                         call_580074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580074, url, valid)

proc call*(call_580075: Call_DeploymentmanagerCompositeTypesPatch_580061;
          project: string; compositeType: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## deploymentmanagerCompositeTypesPatch
  ## Updates a composite type. This method supports patch semantics.
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
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   compositeType: string (required)
  ##                : The name of the composite type for this request.
  var path_580076 = newJObject()
  var query_580077 = newJObject()
  var body_580078 = newJObject()
  add(query_580077, "fields", newJString(fields))
  add(query_580077, "quotaUser", newJString(quotaUser))
  add(query_580077, "alt", newJString(alt))
  add(query_580077, "oauth_token", newJString(oauthToken))
  add(query_580077, "userIp", newJString(userIp))
  add(query_580077, "key", newJString(key))
  add(path_580076, "project", newJString(project))
  if body != nil:
    body_580078 = body
  add(query_580077, "prettyPrint", newJBool(prettyPrint))
  add(path_580076, "compositeType", newJString(compositeType))
  result = call_580075.call(path_580076, query_580077, nil, nil, body_580078)

var deploymentmanagerCompositeTypesPatch* = Call_DeploymentmanagerCompositeTypesPatch_580061(
    name: "deploymentmanagerCompositeTypesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{project}/global/compositeTypes/{compositeType}",
    validator: validate_DeploymentmanagerCompositeTypesPatch_580062,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerCompositeTypesPatch_580063, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerCompositeTypesDelete_580045 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerCompositeTypesDelete_580047(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "compositeType" in path, "`compositeType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/compositeTypes/"),
               (kind: VariableSegment, value: "compositeType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerCompositeTypesDelete_580046(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a composite type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project ID for this request.
  ##   compositeType: JString (required)
  ##                : The name of the type for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_580048 = path.getOrDefault("project")
  valid_580048 = validateParameter(valid_580048, JString, required = true,
                                 default = nil)
  if valid_580048 != nil:
    section.add "project", valid_580048
  var valid_580049 = path.getOrDefault("compositeType")
  valid_580049 = validateParameter(valid_580049, JString, required = true,
                                 default = nil)
  if valid_580049 != nil:
    section.add "compositeType", valid_580049
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
  var valid_580050 = query.getOrDefault("fields")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "fields", valid_580050
  var valid_580051 = query.getOrDefault("quotaUser")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "quotaUser", valid_580051
  var valid_580052 = query.getOrDefault("alt")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = newJString("json"))
  if valid_580052 != nil:
    section.add "alt", valid_580052
  var valid_580053 = query.getOrDefault("oauth_token")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "oauth_token", valid_580053
  var valid_580054 = query.getOrDefault("userIp")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "userIp", valid_580054
  var valid_580055 = query.getOrDefault("key")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "key", valid_580055
  var valid_580056 = query.getOrDefault("prettyPrint")
  valid_580056 = validateParameter(valid_580056, JBool, required = false,
                                 default = newJBool(true))
  if valid_580056 != nil:
    section.add "prettyPrint", valid_580056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580057: Call_DeploymentmanagerCompositeTypesDelete_580045;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a composite type.
  ## 
  let valid = call_580057.validator(path, query, header, formData, body)
  let scheme = call_580057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580057.url(scheme.get, call_580057.host, call_580057.base,
                         call_580057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580057, url, valid)

proc call*(call_580058: Call_DeploymentmanagerCompositeTypesDelete_580045;
          project: string; compositeType: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## deploymentmanagerCompositeTypesDelete
  ## Deletes a composite type.
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
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   compositeType: string (required)
  ##                : The name of the type for this request.
  var path_580059 = newJObject()
  var query_580060 = newJObject()
  add(query_580060, "fields", newJString(fields))
  add(query_580060, "quotaUser", newJString(quotaUser))
  add(query_580060, "alt", newJString(alt))
  add(query_580060, "oauth_token", newJString(oauthToken))
  add(query_580060, "userIp", newJString(userIp))
  add(query_580060, "key", newJString(key))
  add(path_580059, "project", newJString(project))
  add(query_580060, "prettyPrint", newJBool(prettyPrint))
  add(path_580059, "compositeType", newJString(compositeType))
  result = call_580058.call(path_580059, query_580060, nil, nil, nil)

var deploymentmanagerCompositeTypesDelete* = Call_DeploymentmanagerCompositeTypesDelete_580045(
    name: "deploymentmanagerCompositeTypesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{project}/global/compositeTypes/{compositeType}",
    validator: validate_DeploymentmanagerCompositeTypesDelete_580046,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerCompositeTypesDelete_580047, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsInsert_580098 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerDeploymentsInsert_580100(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/deployments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerDeploymentsInsert_580099(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a deployment and all of the resources described by the deployment manifest.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_580101 = path.getOrDefault("project")
  valid_580101 = validateParameter(valid_580101, JString, required = true,
                                 default = nil)
  if valid_580101 != nil:
    section.add "project", valid_580101
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   createPolicy: JString
  ##               : Sets the policy to use for creating new resources.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   preview: JBool
  ##          : If set to true, creates a deployment and creates "shell" resources but does not actually instantiate these resources. This allows you to preview what your deployment looks like. After previewing a deployment, you can deploy your resources by making a request with the update() method or you can use the cancelPreview() method to cancel the preview altogether. Note that the deployment will still exist after you cancel the preview and you must separately delete this deployment if you want to remove it.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580102 = query.getOrDefault("fields")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "fields", valid_580102
  var valid_580103 = query.getOrDefault("quotaUser")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "quotaUser", valid_580103
  var valid_580104 = query.getOrDefault("alt")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = newJString("json"))
  if valid_580104 != nil:
    section.add "alt", valid_580104
  var valid_580105 = query.getOrDefault("createPolicy")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = newJString("CREATE_OR_ACQUIRE"))
  if valid_580105 != nil:
    section.add "createPolicy", valid_580105
  var valid_580106 = query.getOrDefault("oauth_token")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "oauth_token", valid_580106
  var valid_580107 = query.getOrDefault("userIp")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "userIp", valid_580107
  var valid_580108 = query.getOrDefault("key")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "key", valid_580108
  var valid_580109 = query.getOrDefault("preview")
  valid_580109 = validateParameter(valid_580109, JBool, required = false, default = nil)
  if valid_580109 != nil:
    section.add "preview", valid_580109
  var valid_580110 = query.getOrDefault("prettyPrint")
  valid_580110 = validateParameter(valid_580110, JBool, required = false,
                                 default = newJBool(true))
  if valid_580110 != nil:
    section.add "prettyPrint", valid_580110
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

proc call*(call_580112: Call_DeploymentmanagerDeploymentsInsert_580098;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a deployment and all of the resources described by the deployment manifest.
  ## 
  let valid = call_580112.validator(path, query, header, formData, body)
  let scheme = call_580112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580112.url(scheme.get, call_580112.host, call_580112.base,
                         call_580112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580112, url, valid)

proc call*(call_580113: Call_DeploymentmanagerDeploymentsInsert_580098;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; createPolicy: string = "CREATE_OR_ACQUIRE";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          preview: bool = false; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## deploymentmanagerDeploymentsInsert
  ## Creates a deployment and all of the resources described by the deployment manifest.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   createPolicy: string
  ##               : Sets the policy to use for creating new resources.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   preview: bool
  ##          : If set to true, creates a deployment and creates "shell" resources but does not actually instantiate these resources. This allows you to preview what your deployment looks like. After previewing a deployment, you can deploy your resources by making a request with the update() method or you can use the cancelPreview() method to cancel the preview altogether. Note that the deployment will still exist after you cancel the preview and you must separately delete this deployment if you want to remove it.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580114 = newJObject()
  var query_580115 = newJObject()
  var body_580116 = newJObject()
  add(query_580115, "fields", newJString(fields))
  add(query_580115, "quotaUser", newJString(quotaUser))
  add(query_580115, "alt", newJString(alt))
  add(query_580115, "createPolicy", newJString(createPolicy))
  add(query_580115, "oauth_token", newJString(oauthToken))
  add(query_580115, "userIp", newJString(userIp))
  add(query_580115, "key", newJString(key))
  add(query_580115, "preview", newJBool(preview))
  add(path_580114, "project", newJString(project))
  if body != nil:
    body_580116 = body
  add(query_580115, "prettyPrint", newJBool(prettyPrint))
  result = call_580113.call(path_580114, query_580115, nil, nil, body_580116)

var deploymentmanagerDeploymentsInsert* = Call_DeploymentmanagerDeploymentsInsert_580098(
    name: "deploymentmanagerDeploymentsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/global/deployments",
    validator: validate_DeploymentmanagerDeploymentsInsert_580099,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerDeploymentsInsert_580100, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsList_580079 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerDeploymentsList_580081(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/deployments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerDeploymentsList_580080(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all deployments for a given project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_580082 = path.getOrDefault("project")
  valid_580082 = validateParameter(valid_580082, JString, required = true,
                                 default = nil)
  if valid_580082 != nil:
    section.add "project", valid_580082
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  ##   orderBy: JString
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  section = newJObject()
  var valid_580083 = query.getOrDefault("fields")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "fields", valid_580083
  var valid_580084 = query.getOrDefault("pageToken")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "pageToken", valid_580084
  var valid_580085 = query.getOrDefault("quotaUser")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "quotaUser", valid_580085
  var valid_580086 = query.getOrDefault("alt")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = newJString("json"))
  if valid_580086 != nil:
    section.add "alt", valid_580086
  var valid_580087 = query.getOrDefault("oauth_token")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "oauth_token", valid_580087
  var valid_580088 = query.getOrDefault("userIp")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "userIp", valid_580088
  var valid_580089 = query.getOrDefault("maxResults")
  valid_580089 = validateParameter(valid_580089, JInt, required = false,
                                 default = newJInt(500))
  if valid_580089 != nil:
    section.add "maxResults", valid_580089
  var valid_580090 = query.getOrDefault("orderBy")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "orderBy", valid_580090
  var valid_580091 = query.getOrDefault("key")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "key", valid_580091
  var valid_580092 = query.getOrDefault("prettyPrint")
  valid_580092 = validateParameter(valid_580092, JBool, required = false,
                                 default = newJBool(true))
  if valid_580092 != nil:
    section.add "prettyPrint", valid_580092
  var valid_580093 = query.getOrDefault("filter")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "filter", valid_580093
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580094: Call_DeploymentmanagerDeploymentsList_580079;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all deployments for a given project.
  ## 
  let valid = call_580094.validator(path, query, header, formData, body)
  let scheme = call_580094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580094.url(scheme.get, call_580094.host, call_580094.base,
                         call_580094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580094, url, valid)

proc call*(call_580095: Call_DeploymentmanagerDeploymentsList_580079;
          project: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 500; orderBy: string = "";
          key: string = ""; prettyPrint: bool = true; filter: string = ""): Recallable =
  ## deploymentmanagerDeploymentsList
  ## Lists all deployments for a given project.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  ##   orderBy: string
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  var path_580096 = newJObject()
  var query_580097 = newJObject()
  add(query_580097, "fields", newJString(fields))
  add(query_580097, "pageToken", newJString(pageToken))
  add(query_580097, "quotaUser", newJString(quotaUser))
  add(query_580097, "alt", newJString(alt))
  add(query_580097, "oauth_token", newJString(oauthToken))
  add(query_580097, "userIp", newJString(userIp))
  add(query_580097, "maxResults", newJInt(maxResults))
  add(query_580097, "orderBy", newJString(orderBy))
  add(query_580097, "key", newJString(key))
  add(path_580096, "project", newJString(project))
  add(query_580097, "prettyPrint", newJBool(prettyPrint))
  add(query_580097, "filter", newJString(filter))
  result = call_580095.call(path_580096, query_580097, nil, nil, nil)

var deploymentmanagerDeploymentsList* = Call_DeploymentmanagerDeploymentsList_580079(
    name: "deploymentmanagerDeploymentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/deployments",
    validator: validate_DeploymentmanagerDeploymentsList_580080,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerDeploymentsList_580081, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsUpdate_580133 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerDeploymentsUpdate_580135(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "deployment" in path, "`deployment` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/deployments/"),
               (kind: VariableSegment, value: "deployment")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerDeploymentsUpdate_580134(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a deployment and all of the resources described by the deployment manifest.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deployment: JString (required)
  ##             : The name of the deployment for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deployment` field"
  var valid_580136 = path.getOrDefault("deployment")
  valid_580136 = validateParameter(valid_580136, JString, required = true,
                                 default = nil)
  if valid_580136 != nil:
    section.add "deployment", valid_580136
  var valid_580137 = path.getOrDefault("project")
  valid_580137 = validateParameter(valid_580137, JString, required = true,
                                 default = nil)
  if valid_580137 != nil:
    section.add "project", valid_580137
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   createPolicy: JString
  ##               : Sets the policy to use for creating new resources.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   preview: JBool
  ##          : If set to true, updates the deployment and creates and updates the "shell" resources but does not actually alter or instantiate these resources. This allows you to preview what your deployment will look like. You can use this intent to preview how an update would affect your deployment. You must provide a target.config with a configuration if this is set to true. After previewing a deployment, you can deploy your resources by making a request with the update() or you can cancelPreview() to remove the preview altogether. Note that the deployment will still exist after you cancel the preview and you must separately delete this deployment if you want to remove it.
  ##   deletePolicy: JString
  ##               : Sets the policy to use for deleting resources.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580138 = query.getOrDefault("fields")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "fields", valid_580138
  var valid_580139 = query.getOrDefault("quotaUser")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "quotaUser", valid_580139
  var valid_580140 = query.getOrDefault("alt")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = newJString("json"))
  if valid_580140 != nil:
    section.add "alt", valid_580140
  var valid_580141 = query.getOrDefault("createPolicy")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = newJString("CREATE_OR_ACQUIRE"))
  if valid_580141 != nil:
    section.add "createPolicy", valid_580141
  var valid_580142 = query.getOrDefault("oauth_token")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "oauth_token", valid_580142
  var valid_580143 = query.getOrDefault("userIp")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "userIp", valid_580143
  var valid_580144 = query.getOrDefault("key")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "key", valid_580144
  var valid_580145 = query.getOrDefault("preview")
  valid_580145 = validateParameter(valid_580145, JBool, required = false,
                                 default = newJBool(false))
  if valid_580145 != nil:
    section.add "preview", valid_580145
  var valid_580146 = query.getOrDefault("deletePolicy")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = newJString("DELETE"))
  if valid_580146 != nil:
    section.add "deletePolicy", valid_580146
  var valid_580147 = query.getOrDefault("prettyPrint")
  valid_580147 = validateParameter(valid_580147, JBool, required = false,
                                 default = newJBool(true))
  if valid_580147 != nil:
    section.add "prettyPrint", valid_580147
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

proc call*(call_580149: Call_DeploymentmanagerDeploymentsUpdate_580133;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a deployment and all of the resources described by the deployment manifest.
  ## 
  let valid = call_580149.validator(path, query, header, formData, body)
  let scheme = call_580149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580149.url(scheme.get, call_580149.host, call_580149.base,
                         call_580149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580149, url, valid)

proc call*(call_580150: Call_DeploymentmanagerDeploymentsUpdate_580133;
          deployment: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json";
          createPolicy: string = "CREATE_OR_ACQUIRE"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; preview: bool = false;
          deletePolicy: string = "DELETE"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## deploymentmanagerDeploymentsUpdate
  ## Updates a deployment and all of the resources described by the deployment manifest.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   createPolicy: string
  ##               : Sets the policy to use for creating new resources.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   preview: bool
  ##          : If set to true, updates the deployment and creates and updates the "shell" resources but does not actually alter or instantiate these resources. This allows you to preview what your deployment will look like. You can use this intent to preview how an update would affect your deployment. You must provide a target.config with a configuration if this is set to true. After previewing a deployment, you can deploy your resources by making a request with the update() or you can cancelPreview() to remove the preview altogether. Note that the deployment will still exist after you cancel the preview and you must separately delete this deployment if you want to remove it.
  ##   deletePolicy: string
  ##               : Sets the policy to use for deleting resources.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580151 = newJObject()
  var query_580152 = newJObject()
  var body_580153 = newJObject()
  add(path_580151, "deployment", newJString(deployment))
  add(query_580152, "fields", newJString(fields))
  add(query_580152, "quotaUser", newJString(quotaUser))
  add(query_580152, "alt", newJString(alt))
  add(query_580152, "createPolicy", newJString(createPolicy))
  add(query_580152, "oauth_token", newJString(oauthToken))
  add(query_580152, "userIp", newJString(userIp))
  add(query_580152, "key", newJString(key))
  add(query_580152, "preview", newJBool(preview))
  add(query_580152, "deletePolicy", newJString(deletePolicy))
  add(path_580151, "project", newJString(project))
  if body != nil:
    body_580153 = body
  add(query_580152, "prettyPrint", newJBool(prettyPrint))
  result = call_580150.call(path_580151, query_580152, nil, nil, body_580153)

var deploymentmanagerDeploymentsUpdate* = Call_DeploymentmanagerDeploymentsUpdate_580133(
    name: "deploymentmanagerDeploymentsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}",
    validator: validate_DeploymentmanagerDeploymentsUpdate_580134,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerDeploymentsUpdate_580135, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsGet_580117 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerDeploymentsGet_580119(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "deployment" in path, "`deployment` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/deployments/"),
               (kind: VariableSegment, value: "deployment")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerDeploymentsGet_580118(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about a specific deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deployment: JString (required)
  ##             : The name of the deployment for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deployment` field"
  var valid_580120 = path.getOrDefault("deployment")
  valid_580120 = validateParameter(valid_580120, JString, required = true,
                                 default = nil)
  if valid_580120 != nil:
    section.add "deployment", valid_580120
  var valid_580121 = path.getOrDefault("project")
  valid_580121 = validateParameter(valid_580121, JString, required = true,
                                 default = nil)
  if valid_580121 != nil:
    section.add "project", valid_580121
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
  var valid_580122 = query.getOrDefault("fields")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "fields", valid_580122
  var valid_580123 = query.getOrDefault("quotaUser")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "quotaUser", valid_580123
  var valid_580124 = query.getOrDefault("alt")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = newJString("json"))
  if valid_580124 != nil:
    section.add "alt", valid_580124
  var valid_580125 = query.getOrDefault("oauth_token")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "oauth_token", valid_580125
  var valid_580126 = query.getOrDefault("userIp")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "userIp", valid_580126
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580129: Call_DeploymentmanagerDeploymentsGet_580117;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about a specific deployment.
  ## 
  let valid = call_580129.validator(path, query, header, formData, body)
  let scheme = call_580129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580129.url(scheme.get, call_580129.host, call_580129.base,
                         call_580129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580129, url, valid)

proc call*(call_580130: Call_DeploymentmanagerDeploymentsGet_580117;
          deployment: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## deploymentmanagerDeploymentsGet
  ## Gets information about a specific deployment.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
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
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580131 = newJObject()
  var query_580132 = newJObject()
  add(path_580131, "deployment", newJString(deployment))
  add(query_580132, "fields", newJString(fields))
  add(query_580132, "quotaUser", newJString(quotaUser))
  add(query_580132, "alt", newJString(alt))
  add(query_580132, "oauth_token", newJString(oauthToken))
  add(query_580132, "userIp", newJString(userIp))
  add(query_580132, "key", newJString(key))
  add(path_580131, "project", newJString(project))
  add(query_580132, "prettyPrint", newJBool(prettyPrint))
  result = call_580130.call(path_580131, query_580132, nil, nil, nil)

var deploymentmanagerDeploymentsGet* = Call_DeploymentmanagerDeploymentsGet_580117(
    name: "deploymentmanagerDeploymentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}",
    validator: validate_DeploymentmanagerDeploymentsGet_580118,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerDeploymentsGet_580119, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsPatch_580171 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerDeploymentsPatch_580173(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "deployment" in path, "`deployment` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/deployments/"),
               (kind: VariableSegment, value: "deployment")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerDeploymentsPatch_580172(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a deployment and all of the resources described by the deployment manifest. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deployment: JString (required)
  ##             : The name of the deployment for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deployment` field"
  var valid_580174 = path.getOrDefault("deployment")
  valid_580174 = validateParameter(valid_580174, JString, required = true,
                                 default = nil)
  if valid_580174 != nil:
    section.add "deployment", valid_580174
  var valid_580175 = path.getOrDefault("project")
  valid_580175 = validateParameter(valid_580175, JString, required = true,
                                 default = nil)
  if valid_580175 != nil:
    section.add "project", valid_580175
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   createPolicy: JString
  ##               : Sets the policy to use for creating new resources.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   preview: JBool
  ##          : If set to true, updates the deployment and creates and updates the "shell" resources but does not actually alter or instantiate these resources. This allows you to preview what your deployment will look like. You can use this intent to preview how an update would affect your deployment. You must provide a target.config with a configuration if this is set to true. After previewing a deployment, you can deploy your resources by making a request with the update() or you can cancelPreview() to remove the preview altogether. Note that the deployment will still exist after you cancel the preview and you must separately delete this deployment if you want to remove it.
  ##   deletePolicy: JString
  ##               : Sets the policy to use for deleting resources.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580176 = query.getOrDefault("fields")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "fields", valid_580176
  var valid_580177 = query.getOrDefault("quotaUser")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "quotaUser", valid_580177
  var valid_580178 = query.getOrDefault("alt")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = newJString("json"))
  if valid_580178 != nil:
    section.add "alt", valid_580178
  var valid_580179 = query.getOrDefault("createPolicy")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = newJString("CREATE_OR_ACQUIRE"))
  if valid_580179 != nil:
    section.add "createPolicy", valid_580179
  var valid_580180 = query.getOrDefault("oauth_token")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = nil)
  if valid_580180 != nil:
    section.add "oauth_token", valid_580180
  var valid_580181 = query.getOrDefault("userIp")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = nil)
  if valid_580181 != nil:
    section.add "userIp", valid_580181
  var valid_580182 = query.getOrDefault("key")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "key", valid_580182
  var valid_580183 = query.getOrDefault("preview")
  valid_580183 = validateParameter(valid_580183, JBool, required = false,
                                 default = newJBool(false))
  if valid_580183 != nil:
    section.add "preview", valid_580183
  var valid_580184 = query.getOrDefault("deletePolicy")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = newJString("DELETE"))
  if valid_580184 != nil:
    section.add "deletePolicy", valid_580184
  var valid_580185 = query.getOrDefault("prettyPrint")
  valid_580185 = validateParameter(valid_580185, JBool, required = false,
                                 default = newJBool(true))
  if valid_580185 != nil:
    section.add "prettyPrint", valid_580185
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

proc call*(call_580187: Call_DeploymentmanagerDeploymentsPatch_580171;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a deployment and all of the resources described by the deployment manifest. This method supports patch semantics.
  ## 
  let valid = call_580187.validator(path, query, header, formData, body)
  let scheme = call_580187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580187.url(scheme.get, call_580187.host, call_580187.base,
                         call_580187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580187, url, valid)

proc call*(call_580188: Call_DeploymentmanagerDeploymentsPatch_580171;
          deployment: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json";
          createPolicy: string = "CREATE_OR_ACQUIRE"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; preview: bool = false;
          deletePolicy: string = "DELETE"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## deploymentmanagerDeploymentsPatch
  ## Updates a deployment and all of the resources described by the deployment manifest. This method supports patch semantics.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   createPolicy: string
  ##               : Sets the policy to use for creating new resources.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   preview: bool
  ##          : If set to true, updates the deployment and creates and updates the "shell" resources but does not actually alter or instantiate these resources. This allows you to preview what your deployment will look like. You can use this intent to preview how an update would affect your deployment. You must provide a target.config with a configuration if this is set to true. After previewing a deployment, you can deploy your resources by making a request with the update() or you can cancelPreview() to remove the preview altogether. Note that the deployment will still exist after you cancel the preview and you must separately delete this deployment if you want to remove it.
  ##   deletePolicy: string
  ##               : Sets the policy to use for deleting resources.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580189 = newJObject()
  var query_580190 = newJObject()
  var body_580191 = newJObject()
  add(path_580189, "deployment", newJString(deployment))
  add(query_580190, "fields", newJString(fields))
  add(query_580190, "quotaUser", newJString(quotaUser))
  add(query_580190, "alt", newJString(alt))
  add(query_580190, "createPolicy", newJString(createPolicy))
  add(query_580190, "oauth_token", newJString(oauthToken))
  add(query_580190, "userIp", newJString(userIp))
  add(query_580190, "key", newJString(key))
  add(query_580190, "preview", newJBool(preview))
  add(query_580190, "deletePolicy", newJString(deletePolicy))
  add(path_580189, "project", newJString(project))
  if body != nil:
    body_580191 = body
  add(query_580190, "prettyPrint", newJBool(prettyPrint))
  result = call_580188.call(path_580189, query_580190, nil, nil, body_580191)

var deploymentmanagerDeploymentsPatch* = Call_DeploymentmanagerDeploymentsPatch_580171(
    name: "deploymentmanagerDeploymentsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}",
    validator: validate_DeploymentmanagerDeploymentsPatch_580172,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerDeploymentsPatch_580173, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsDelete_580154 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerDeploymentsDelete_580156(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "deployment" in path, "`deployment` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/deployments/"),
               (kind: VariableSegment, value: "deployment")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerDeploymentsDelete_580155(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a deployment and all of the resources in the deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deployment: JString (required)
  ##             : The name of the deployment for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deployment` field"
  var valid_580157 = path.getOrDefault("deployment")
  valid_580157 = validateParameter(valid_580157, JString, required = true,
                                 default = nil)
  if valid_580157 != nil:
    section.add "deployment", valid_580157
  var valid_580158 = path.getOrDefault("project")
  valid_580158 = validateParameter(valid_580158, JString, required = true,
                                 default = nil)
  if valid_580158 != nil:
    section.add "project", valid_580158
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
  ##   deletePolicy: JString
  ##               : Sets the policy to use for deleting resources.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580159 = query.getOrDefault("fields")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "fields", valid_580159
  var valid_580160 = query.getOrDefault("quotaUser")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "quotaUser", valid_580160
  var valid_580161 = query.getOrDefault("alt")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = newJString("json"))
  if valid_580161 != nil:
    section.add "alt", valid_580161
  var valid_580162 = query.getOrDefault("oauth_token")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "oauth_token", valid_580162
  var valid_580163 = query.getOrDefault("userIp")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "userIp", valid_580163
  var valid_580164 = query.getOrDefault("key")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "key", valid_580164
  var valid_580165 = query.getOrDefault("deletePolicy")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = newJString("DELETE"))
  if valid_580165 != nil:
    section.add "deletePolicy", valid_580165
  var valid_580166 = query.getOrDefault("prettyPrint")
  valid_580166 = validateParameter(valid_580166, JBool, required = false,
                                 default = newJBool(true))
  if valid_580166 != nil:
    section.add "prettyPrint", valid_580166
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580167: Call_DeploymentmanagerDeploymentsDelete_580154;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a deployment and all of the resources in the deployment.
  ## 
  let valid = call_580167.validator(path, query, header, formData, body)
  let scheme = call_580167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580167.url(scheme.get, call_580167.host, call_580167.base,
                         call_580167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580167, url, valid)

proc call*(call_580168: Call_DeploymentmanagerDeploymentsDelete_580154;
          deployment: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; deletePolicy: string = "DELETE";
          prettyPrint: bool = true): Recallable =
  ## deploymentmanagerDeploymentsDelete
  ## Deletes a deployment and all of the resources in the deployment.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
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
  ##   deletePolicy: string
  ##               : Sets the policy to use for deleting resources.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580169 = newJObject()
  var query_580170 = newJObject()
  add(path_580169, "deployment", newJString(deployment))
  add(query_580170, "fields", newJString(fields))
  add(query_580170, "quotaUser", newJString(quotaUser))
  add(query_580170, "alt", newJString(alt))
  add(query_580170, "oauth_token", newJString(oauthToken))
  add(query_580170, "userIp", newJString(userIp))
  add(query_580170, "key", newJString(key))
  add(query_580170, "deletePolicy", newJString(deletePolicy))
  add(path_580169, "project", newJString(project))
  add(query_580170, "prettyPrint", newJBool(prettyPrint))
  result = call_580168.call(path_580169, query_580170, nil, nil, nil)

var deploymentmanagerDeploymentsDelete* = Call_DeploymentmanagerDeploymentsDelete_580154(
    name: "deploymentmanagerDeploymentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}",
    validator: validate_DeploymentmanagerDeploymentsDelete_580155,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerDeploymentsDelete_580156, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsCancelPreview_580192 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerDeploymentsCancelPreview_580194(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "deployment" in path, "`deployment` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/deployments/"),
               (kind: VariableSegment, value: "deployment"),
               (kind: ConstantSegment, value: "/cancelPreview")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerDeploymentsCancelPreview_580193(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels and removes the preview currently associated with the deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deployment: JString (required)
  ##             : The name of the deployment for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deployment` field"
  var valid_580195 = path.getOrDefault("deployment")
  valid_580195 = validateParameter(valid_580195, JString, required = true,
                                 default = nil)
  if valid_580195 != nil:
    section.add "deployment", valid_580195
  var valid_580196 = path.getOrDefault("project")
  valid_580196 = validateParameter(valid_580196, JString, required = true,
                                 default = nil)
  if valid_580196 != nil:
    section.add "project", valid_580196
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
  var valid_580197 = query.getOrDefault("fields")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "fields", valid_580197
  var valid_580198 = query.getOrDefault("quotaUser")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "quotaUser", valid_580198
  var valid_580199 = query.getOrDefault("alt")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = newJString("json"))
  if valid_580199 != nil:
    section.add "alt", valid_580199
  var valid_580200 = query.getOrDefault("oauth_token")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "oauth_token", valid_580200
  var valid_580201 = query.getOrDefault("userIp")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "userIp", valid_580201
  var valid_580202 = query.getOrDefault("key")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "key", valid_580202
  var valid_580203 = query.getOrDefault("prettyPrint")
  valid_580203 = validateParameter(valid_580203, JBool, required = false,
                                 default = newJBool(true))
  if valid_580203 != nil:
    section.add "prettyPrint", valid_580203
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

proc call*(call_580205: Call_DeploymentmanagerDeploymentsCancelPreview_580192;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels and removes the preview currently associated with the deployment.
  ## 
  let valid = call_580205.validator(path, query, header, formData, body)
  let scheme = call_580205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580205.url(scheme.get, call_580205.host, call_580205.base,
                         call_580205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580205, url, valid)

proc call*(call_580206: Call_DeploymentmanagerDeploymentsCancelPreview_580192;
          deployment: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## deploymentmanagerDeploymentsCancelPreview
  ## Cancels and removes the preview currently associated with the deployment.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
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
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580207 = newJObject()
  var query_580208 = newJObject()
  var body_580209 = newJObject()
  add(path_580207, "deployment", newJString(deployment))
  add(query_580208, "fields", newJString(fields))
  add(query_580208, "quotaUser", newJString(quotaUser))
  add(query_580208, "alt", newJString(alt))
  add(query_580208, "oauth_token", newJString(oauthToken))
  add(query_580208, "userIp", newJString(userIp))
  add(query_580208, "key", newJString(key))
  add(path_580207, "project", newJString(project))
  if body != nil:
    body_580209 = body
  add(query_580208, "prettyPrint", newJBool(prettyPrint))
  result = call_580206.call(path_580207, query_580208, nil, nil, body_580209)

var deploymentmanagerDeploymentsCancelPreview* = Call_DeploymentmanagerDeploymentsCancelPreview_580192(
    name: "deploymentmanagerDeploymentsCancelPreview", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}/cancelPreview",
    validator: validate_DeploymentmanagerDeploymentsCancelPreview_580193,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerDeploymentsCancelPreview_580194,
    schemes: {Scheme.Https})
type
  Call_DeploymentmanagerManifestsList_580210 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerManifestsList_580212(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "deployment" in path, "`deployment` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/deployments/"),
               (kind: VariableSegment, value: "deployment"),
               (kind: ConstantSegment, value: "/manifests")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerManifestsList_580211(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all manifests for a given deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deployment: JString (required)
  ##             : The name of the deployment for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deployment` field"
  var valid_580213 = path.getOrDefault("deployment")
  valid_580213 = validateParameter(valid_580213, JString, required = true,
                                 default = nil)
  if valid_580213 != nil:
    section.add "deployment", valid_580213
  var valid_580214 = path.getOrDefault("project")
  valid_580214 = validateParameter(valid_580214, JString, required = true,
                                 default = nil)
  if valid_580214 != nil:
    section.add "project", valid_580214
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  ##   orderBy: JString
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  section = newJObject()
  var valid_580215 = query.getOrDefault("fields")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "fields", valid_580215
  var valid_580216 = query.getOrDefault("pageToken")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "pageToken", valid_580216
  var valid_580217 = query.getOrDefault("quotaUser")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "quotaUser", valid_580217
  var valid_580218 = query.getOrDefault("alt")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = newJString("json"))
  if valid_580218 != nil:
    section.add "alt", valid_580218
  var valid_580219 = query.getOrDefault("oauth_token")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "oauth_token", valid_580219
  var valid_580220 = query.getOrDefault("userIp")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = nil)
  if valid_580220 != nil:
    section.add "userIp", valid_580220
  var valid_580221 = query.getOrDefault("maxResults")
  valid_580221 = validateParameter(valid_580221, JInt, required = false,
                                 default = newJInt(500))
  if valid_580221 != nil:
    section.add "maxResults", valid_580221
  var valid_580222 = query.getOrDefault("orderBy")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "orderBy", valid_580222
  var valid_580223 = query.getOrDefault("key")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "key", valid_580223
  var valid_580224 = query.getOrDefault("prettyPrint")
  valid_580224 = validateParameter(valid_580224, JBool, required = false,
                                 default = newJBool(true))
  if valid_580224 != nil:
    section.add "prettyPrint", valid_580224
  var valid_580225 = query.getOrDefault("filter")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "filter", valid_580225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580226: Call_DeploymentmanagerManifestsList_580210; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all manifests for a given deployment.
  ## 
  let valid = call_580226.validator(path, query, header, formData, body)
  let scheme = call_580226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580226.url(scheme.get, call_580226.host, call_580226.base,
                         call_580226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580226, url, valid)

proc call*(call_580227: Call_DeploymentmanagerManifestsList_580210;
          deployment: string; project: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 500;
          orderBy: string = ""; key: string = ""; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## deploymentmanagerManifestsList
  ## Lists all manifests for a given deployment.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  ##   orderBy: string
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  var path_580228 = newJObject()
  var query_580229 = newJObject()
  add(path_580228, "deployment", newJString(deployment))
  add(query_580229, "fields", newJString(fields))
  add(query_580229, "pageToken", newJString(pageToken))
  add(query_580229, "quotaUser", newJString(quotaUser))
  add(query_580229, "alt", newJString(alt))
  add(query_580229, "oauth_token", newJString(oauthToken))
  add(query_580229, "userIp", newJString(userIp))
  add(query_580229, "maxResults", newJInt(maxResults))
  add(query_580229, "orderBy", newJString(orderBy))
  add(query_580229, "key", newJString(key))
  add(path_580228, "project", newJString(project))
  add(query_580229, "prettyPrint", newJBool(prettyPrint))
  add(query_580229, "filter", newJString(filter))
  result = call_580227.call(path_580228, query_580229, nil, nil, nil)

var deploymentmanagerManifestsList* = Call_DeploymentmanagerManifestsList_580210(
    name: "deploymentmanagerManifestsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}/manifests",
    validator: validate_DeploymentmanagerManifestsList_580211,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerManifestsList_580212, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerManifestsGet_580230 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerManifestsGet_580232(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "deployment" in path, "`deployment` is a required path parameter"
  assert "manifest" in path, "`manifest` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/deployments/"),
               (kind: VariableSegment, value: "deployment"),
               (kind: ConstantSegment, value: "/manifests/"),
               (kind: VariableSegment, value: "manifest")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerManifestsGet_580231(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about a specific manifest.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deployment: JString (required)
  ##             : The name of the deployment for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  ##   manifest: JString (required)
  ##           : The name of the manifest for this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deployment` field"
  var valid_580233 = path.getOrDefault("deployment")
  valid_580233 = validateParameter(valid_580233, JString, required = true,
                                 default = nil)
  if valid_580233 != nil:
    section.add "deployment", valid_580233
  var valid_580234 = path.getOrDefault("project")
  valid_580234 = validateParameter(valid_580234, JString, required = true,
                                 default = nil)
  if valid_580234 != nil:
    section.add "project", valid_580234
  var valid_580235 = path.getOrDefault("manifest")
  valid_580235 = validateParameter(valid_580235, JString, required = true,
                                 default = nil)
  if valid_580235 != nil:
    section.add "manifest", valid_580235
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
  var valid_580239 = query.getOrDefault("oauth_token")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = nil)
  if valid_580239 != nil:
    section.add "oauth_token", valid_580239
  var valid_580240 = query.getOrDefault("userIp")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "userIp", valid_580240
  var valid_580241 = query.getOrDefault("key")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "key", valid_580241
  var valid_580242 = query.getOrDefault("prettyPrint")
  valid_580242 = validateParameter(valid_580242, JBool, required = false,
                                 default = newJBool(true))
  if valid_580242 != nil:
    section.add "prettyPrint", valid_580242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580243: Call_DeploymentmanagerManifestsGet_580230; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a specific manifest.
  ## 
  let valid = call_580243.validator(path, query, header, formData, body)
  let scheme = call_580243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580243.url(scheme.get, call_580243.host, call_580243.base,
                         call_580243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580243, url, valid)

proc call*(call_580244: Call_DeploymentmanagerManifestsGet_580230;
          deployment: string; project: string; manifest: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## deploymentmanagerManifestsGet
  ## Gets information about a specific manifest.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
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
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   manifest: string (required)
  ##           : The name of the manifest for this request.
  var path_580245 = newJObject()
  var query_580246 = newJObject()
  add(path_580245, "deployment", newJString(deployment))
  add(query_580246, "fields", newJString(fields))
  add(query_580246, "quotaUser", newJString(quotaUser))
  add(query_580246, "alt", newJString(alt))
  add(query_580246, "oauth_token", newJString(oauthToken))
  add(query_580246, "userIp", newJString(userIp))
  add(query_580246, "key", newJString(key))
  add(path_580245, "project", newJString(project))
  add(query_580246, "prettyPrint", newJBool(prettyPrint))
  add(path_580245, "manifest", newJString(manifest))
  result = call_580244.call(path_580245, query_580246, nil, nil, nil)

var deploymentmanagerManifestsGet* = Call_DeploymentmanagerManifestsGet_580230(
    name: "deploymentmanagerManifestsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}/manifests/{manifest}",
    validator: validate_DeploymentmanagerManifestsGet_580231,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerManifestsGet_580232, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerResourcesList_580247 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerResourcesList_580249(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "deployment" in path, "`deployment` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/deployments/"),
               (kind: VariableSegment, value: "deployment"),
               (kind: ConstantSegment, value: "/resources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerResourcesList_580248(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all resources in a given deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deployment: JString (required)
  ##             : The name of the deployment for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deployment` field"
  var valid_580250 = path.getOrDefault("deployment")
  valid_580250 = validateParameter(valid_580250, JString, required = true,
                                 default = nil)
  if valid_580250 != nil:
    section.add "deployment", valid_580250
  var valid_580251 = path.getOrDefault("project")
  valid_580251 = validateParameter(valid_580251, JString, required = true,
                                 default = nil)
  if valid_580251 != nil:
    section.add "project", valid_580251
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  ##   orderBy: JString
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  section = newJObject()
  var valid_580252 = query.getOrDefault("fields")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "fields", valid_580252
  var valid_580253 = query.getOrDefault("pageToken")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = nil)
  if valid_580253 != nil:
    section.add "pageToken", valid_580253
  var valid_580254 = query.getOrDefault("quotaUser")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = nil)
  if valid_580254 != nil:
    section.add "quotaUser", valid_580254
  var valid_580255 = query.getOrDefault("alt")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = newJString("json"))
  if valid_580255 != nil:
    section.add "alt", valid_580255
  var valid_580256 = query.getOrDefault("oauth_token")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "oauth_token", valid_580256
  var valid_580257 = query.getOrDefault("userIp")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = nil)
  if valid_580257 != nil:
    section.add "userIp", valid_580257
  var valid_580258 = query.getOrDefault("maxResults")
  valid_580258 = validateParameter(valid_580258, JInt, required = false,
                                 default = newJInt(500))
  if valid_580258 != nil:
    section.add "maxResults", valid_580258
  var valid_580259 = query.getOrDefault("orderBy")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "orderBy", valid_580259
  var valid_580260 = query.getOrDefault("key")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "key", valid_580260
  var valid_580261 = query.getOrDefault("prettyPrint")
  valid_580261 = validateParameter(valid_580261, JBool, required = false,
                                 default = newJBool(true))
  if valid_580261 != nil:
    section.add "prettyPrint", valid_580261
  var valid_580262 = query.getOrDefault("filter")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "filter", valid_580262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580263: Call_DeploymentmanagerResourcesList_580247; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all resources in a given deployment.
  ## 
  let valid = call_580263.validator(path, query, header, formData, body)
  let scheme = call_580263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580263.url(scheme.get, call_580263.host, call_580263.base,
                         call_580263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580263, url, valid)

proc call*(call_580264: Call_DeploymentmanagerResourcesList_580247;
          deployment: string; project: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 500;
          orderBy: string = ""; key: string = ""; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## deploymentmanagerResourcesList
  ## Lists all resources in a given deployment.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  ##   orderBy: string
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  var path_580265 = newJObject()
  var query_580266 = newJObject()
  add(path_580265, "deployment", newJString(deployment))
  add(query_580266, "fields", newJString(fields))
  add(query_580266, "pageToken", newJString(pageToken))
  add(query_580266, "quotaUser", newJString(quotaUser))
  add(query_580266, "alt", newJString(alt))
  add(query_580266, "oauth_token", newJString(oauthToken))
  add(query_580266, "userIp", newJString(userIp))
  add(query_580266, "maxResults", newJInt(maxResults))
  add(query_580266, "orderBy", newJString(orderBy))
  add(query_580266, "key", newJString(key))
  add(path_580265, "project", newJString(project))
  add(query_580266, "prettyPrint", newJBool(prettyPrint))
  add(query_580266, "filter", newJString(filter))
  result = call_580264.call(path_580265, query_580266, nil, nil, nil)

var deploymentmanagerResourcesList* = Call_DeploymentmanagerResourcesList_580247(
    name: "deploymentmanagerResourcesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}/resources",
    validator: validate_DeploymentmanagerResourcesList_580248,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerResourcesList_580249, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerResourcesGet_580267 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerResourcesGet_580269(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "deployment" in path, "`deployment` is a required path parameter"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/deployments/"),
               (kind: VariableSegment, value: "deployment"),
               (kind: ConstantSegment, value: "/resources/"),
               (kind: VariableSegment, value: "resource")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerResourcesGet_580268(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about a single resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deployment: JString (required)
  ##             : The name of the deployment for this request.
  ##   resource: JString (required)
  ##           : The name of the resource for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deployment` field"
  var valid_580270 = path.getOrDefault("deployment")
  valid_580270 = validateParameter(valid_580270, JString, required = true,
                                 default = nil)
  if valid_580270 != nil:
    section.add "deployment", valid_580270
  var valid_580271 = path.getOrDefault("resource")
  valid_580271 = validateParameter(valid_580271, JString, required = true,
                                 default = nil)
  if valid_580271 != nil:
    section.add "resource", valid_580271
  var valid_580272 = path.getOrDefault("project")
  valid_580272 = validateParameter(valid_580272, JString, required = true,
                                 default = nil)
  if valid_580272 != nil:
    section.add "project", valid_580272
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
  var valid_580273 = query.getOrDefault("fields")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "fields", valid_580273
  var valid_580274 = query.getOrDefault("quotaUser")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "quotaUser", valid_580274
  var valid_580275 = query.getOrDefault("alt")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = newJString("json"))
  if valid_580275 != nil:
    section.add "alt", valid_580275
  var valid_580276 = query.getOrDefault("oauth_token")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "oauth_token", valid_580276
  var valid_580277 = query.getOrDefault("userIp")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "userIp", valid_580277
  var valid_580278 = query.getOrDefault("key")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "key", valid_580278
  var valid_580279 = query.getOrDefault("prettyPrint")
  valid_580279 = validateParameter(valid_580279, JBool, required = false,
                                 default = newJBool(true))
  if valid_580279 != nil:
    section.add "prettyPrint", valid_580279
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580280: Call_DeploymentmanagerResourcesGet_580267; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a single resource.
  ## 
  let valid = call_580280.validator(path, query, header, formData, body)
  let scheme = call_580280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580280.url(scheme.get, call_580280.host, call_580280.base,
                         call_580280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580280, url, valid)

proc call*(call_580281: Call_DeploymentmanagerResourcesGet_580267;
          deployment: string; resource: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## deploymentmanagerResourcesGet
  ## Gets information about a single resource.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
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
  ##   resource: string (required)
  ##           : The name of the resource for this request.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580282 = newJObject()
  var query_580283 = newJObject()
  add(path_580282, "deployment", newJString(deployment))
  add(query_580283, "fields", newJString(fields))
  add(query_580283, "quotaUser", newJString(quotaUser))
  add(query_580283, "alt", newJString(alt))
  add(query_580283, "oauth_token", newJString(oauthToken))
  add(query_580283, "userIp", newJString(userIp))
  add(query_580283, "key", newJString(key))
  add(path_580282, "resource", newJString(resource))
  add(path_580282, "project", newJString(project))
  add(query_580283, "prettyPrint", newJBool(prettyPrint))
  result = call_580281.call(path_580282, query_580283, nil, nil, nil)

var deploymentmanagerResourcesGet* = Call_DeploymentmanagerResourcesGet_580267(
    name: "deploymentmanagerResourcesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}/resources/{resource}",
    validator: validate_DeploymentmanagerResourcesGet_580268,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerResourcesGet_580269, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsStop_580284 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerDeploymentsStop_580286(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "deployment" in path, "`deployment` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/deployments/"),
               (kind: VariableSegment, value: "deployment"),
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerDeploymentsStop_580285(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Stops an ongoing operation. This does not roll back any work that has already been completed, but prevents any new work from being started.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deployment: JString (required)
  ##             : The name of the deployment for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deployment` field"
  var valid_580287 = path.getOrDefault("deployment")
  valid_580287 = validateParameter(valid_580287, JString, required = true,
                                 default = nil)
  if valid_580287 != nil:
    section.add "deployment", valid_580287
  var valid_580288 = path.getOrDefault("project")
  valid_580288 = validateParameter(valid_580288, JString, required = true,
                                 default = nil)
  if valid_580288 != nil:
    section.add "project", valid_580288
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
  var valid_580289 = query.getOrDefault("fields")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = nil)
  if valid_580289 != nil:
    section.add "fields", valid_580289
  var valid_580290 = query.getOrDefault("quotaUser")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = nil)
  if valid_580290 != nil:
    section.add "quotaUser", valid_580290
  var valid_580291 = query.getOrDefault("alt")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = newJString("json"))
  if valid_580291 != nil:
    section.add "alt", valid_580291
  var valid_580292 = query.getOrDefault("oauth_token")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = nil)
  if valid_580292 != nil:
    section.add "oauth_token", valid_580292
  var valid_580293 = query.getOrDefault("userIp")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "userIp", valid_580293
  var valid_580294 = query.getOrDefault("key")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = nil)
  if valid_580294 != nil:
    section.add "key", valid_580294
  var valid_580295 = query.getOrDefault("prettyPrint")
  valid_580295 = validateParameter(valid_580295, JBool, required = false,
                                 default = newJBool(true))
  if valid_580295 != nil:
    section.add "prettyPrint", valid_580295
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

proc call*(call_580297: Call_DeploymentmanagerDeploymentsStop_580284;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Stops an ongoing operation. This does not roll back any work that has already been completed, but prevents any new work from being started.
  ## 
  let valid = call_580297.validator(path, query, header, formData, body)
  let scheme = call_580297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580297.url(scheme.get, call_580297.host, call_580297.base,
                         call_580297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580297, url, valid)

proc call*(call_580298: Call_DeploymentmanagerDeploymentsStop_580284;
          deployment: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## deploymentmanagerDeploymentsStop
  ## Stops an ongoing operation. This does not roll back any work that has already been completed, but prevents any new work from being started.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
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
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580299 = newJObject()
  var query_580300 = newJObject()
  var body_580301 = newJObject()
  add(path_580299, "deployment", newJString(deployment))
  add(query_580300, "fields", newJString(fields))
  add(query_580300, "quotaUser", newJString(quotaUser))
  add(query_580300, "alt", newJString(alt))
  add(query_580300, "oauth_token", newJString(oauthToken))
  add(query_580300, "userIp", newJString(userIp))
  add(query_580300, "key", newJString(key))
  add(path_580299, "project", newJString(project))
  if body != nil:
    body_580301 = body
  add(query_580300, "prettyPrint", newJBool(prettyPrint))
  result = call_580298.call(path_580299, query_580300, nil, nil, body_580301)

var deploymentmanagerDeploymentsStop* = Call_DeploymentmanagerDeploymentsStop_580284(
    name: "deploymentmanagerDeploymentsStop", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}/stop",
    validator: validate_DeploymentmanagerDeploymentsStop_580285,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerDeploymentsStop_580286, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsGetIamPolicy_580302 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerDeploymentsGetIamPolicy_580304(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/deployments/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: "/getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerDeploymentsGetIamPolicy_580303(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the access control policy for a resource. May be empty if no such policy or resource exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Name or id of the resource for this request.
  ##   project: JString (required)
  ##          : Project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580305 = path.getOrDefault("resource")
  valid_580305 = validateParameter(valid_580305, JString, required = true,
                                 default = nil)
  if valid_580305 != nil:
    section.add "resource", valid_580305
  var valid_580306 = path.getOrDefault("project")
  valid_580306 = validateParameter(valid_580306, JString, required = true,
                                 default = nil)
  if valid_580306 != nil:
    section.add "project", valid_580306
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
  var valid_580307 = query.getOrDefault("fields")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = nil)
  if valid_580307 != nil:
    section.add "fields", valid_580307
  var valid_580308 = query.getOrDefault("quotaUser")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = nil)
  if valid_580308 != nil:
    section.add "quotaUser", valid_580308
  var valid_580309 = query.getOrDefault("alt")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = newJString("json"))
  if valid_580309 != nil:
    section.add "alt", valid_580309
  var valid_580310 = query.getOrDefault("oauth_token")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = nil)
  if valid_580310 != nil:
    section.add "oauth_token", valid_580310
  var valid_580311 = query.getOrDefault("userIp")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = nil)
  if valid_580311 != nil:
    section.add "userIp", valid_580311
  var valid_580312 = query.getOrDefault("key")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = nil)
  if valid_580312 != nil:
    section.add "key", valid_580312
  var valid_580313 = query.getOrDefault("prettyPrint")
  valid_580313 = validateParameter(valid_580313, JBool, required = false,
                                 default = newJBool(true))
  if valid_580313 != nil:
    section.add "prettyPrint", valid_580313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580314: Call_DeploymentmanagerDeploymentsGetIamPolicy_580302;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource. May be empty if no such policy or resource exists.
  ## 
  let valid = call_580314.validator(path, query, header, formData, body)
  let scheme = call_580314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580314.url(scheme.get, call_580314.host, call_580314.base,
                         call_580314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580314, url, valid)

proc call*(call_580315: Call_DeploymentmanagerDeploymentsGetIamPolicy_580302;
          resource: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## deploymentmanagerDeploymentsGetIamPolicy
  ## Gets the access control policy for a resource. May be empty if no such policy or resource exists.
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
  ##   resource: string (required)
  ##           : Name or id of the resource for this request.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580316 = newJObject()
  var query_580317 = newJObject()
  add(query_580317, "fields", newJString(fields))
  add(query_580317, "quotaUser", newJString(quotaUser))
  add(query_580317, "alt", newJString(alt))
  add(query_580317, "oauth_token", newJString(oauthToken))
  add(query_580317, "userIp", newJString(userIp))
  add(query_580317, "key", newJString(key))
  add(path_580316, "resource", newJString(resource))
  add(path_580316, "project", newJString(project))
  add(query_580317, "prettyPrint", newJBool(prettyPrint))
  result = call_580315.call(path_580316, query_580317, nil, nil, nil)

var deploymentmanagerDeploymentsGetIamPolicy* = Call_DeploymentmanagerDeploymentsGetIamPolicy_580302(
    name: "deploymentmanagerDeploymentsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{resource}/getIamPolicy",
    validator: validate_DeploymentmanagerDeploymentsGetIamPolicy_580303,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerDeploymentsGetIamPolicy_580304,
    schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsSetIamPolicy_580318 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerDeploymentsSetIamPolicy_580320(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/deployments/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: "/setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerDeploymentsSetIamPolicy_580319(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the access control policy on the specified resource. Replaces any existing policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Name or id of the resource for this request.
  ##   project: JString (required)
  ##          : Project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580321 = path.getOrDefault("resource")
  valid_580321 = validateParameter(valid_580321, JString, required = true,
                                 default = nil)
  if valid_580321 != nil:
    section.add "resource", valid_580321
  var valid_580322 = path.getOrDefault("project")
  valid_580322 = validateParameter(valid_580322, JString, required = true,
                                 default = nil)
  if valid_580322 != nil:
    section.add "project", valid_580322
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
  var valid_580323 = query.getOrDefault("fields")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "fields", valid_580323
  var valid_580324 = query.getOrDefault("quotaUser")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "quotaUser", valid_580324
  var valid_580325 = query.getOrDefault("alt")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = newJString("json"))
  if valid_580325 != nil:
    section.add "alt", valid_580325
  var valid_580326 = query.getOrDefault("oauth_token")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = nil)
  if valid_580326 != nil:
    section.add "oauth_token", valid_580326
  var valid_580327 = query.getOrDefault("userIp")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = nil)
  if valid_580327 != nil:
    section.add "userIp", valid_580327
  var valid_580328 = query.getOrDefault("key")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = nil)
  if valid_580328 != nil:
    section.add "key", valid_580328
  var valid_580329 = query.getOrDefault("prettyPrint")
  valid_580329 = validateParameter(valid_580329, JBool, required = false,
                                 default = newJBool(true))
  if valid_580329 != nil:
    section.add "prettyPrint", valid_580329
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

proc call*(call_580331: Call_DeploymentmanagerDeploymentsSetIamPolicy_580318;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any existing policy.
  ## 
  let valid = call_580331.validator(path, query, header, formData, body)
  let scheme = call_580331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580331.url(scheme.get, call_580331.host, call_580331.base,
                         call_580331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580331, url, valid)

proc call*(call_580332: Call_DeploymentmanagerDeploymentsSetIamPolicy_580318;
          resource: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## deploymentmanagerDeploymentsSetIamPolicy
  ## Sets the access control policy on the specified resource. Replaces any existing policy.
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
  ##   resource: string (required)
  ##           : Name or id of the resource for this request.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580333 = newJObject()
  var query_580334 = newJObject()
  var body_580335 = newJObject()
  add(query_580334, "fields", newJString(fields))
  add(query_580334, "quotaUser", newJString(quotaUser))
  add(query_580334, "alt", newJString(alt))
  add(query_580334, "oauth_token", newJString(oauthToken))
  add(query_580334, "userIp", newJString(userIp))
  add(query_580334, "key", newJString(key))
  add(path_580333, "resource", newJString(resource))
  add(path_580333, "project", newJString(project))
  if body != nil:
    body_580335 = body
  add(query_580334, "prettyPrint", newJBool(prettyPrint))
  result = call_580332.call(path_580333, query_580334, nil, nil, body_580335)

var deploymentmanagerDeploymentsSetIamPolicy* = Call_DeploymentmanagerDeploymentsSetIamPolicy_580318(
    name: "deploymentmanagerDeploymentsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{resource}/setIamPolicy",
    validator: validate_DeploymentmanagerDeploymentsSetIamPolicy_580319,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerDeploymentsSetIamPolicy_580320,
    schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsTestIamPermissions_580336 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerDeploymentsTestIamPermissions_580338(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/deployments/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: "/testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerDeploymentsTestIamPermissions_580337(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns permissions that a caller has on the specified resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Name or id of the resource for this request.
  ##   project: JString (required)
  ##          : Project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580339 = path.getOrDefault("resource")
  valid_580339 = validateParameter(valid_580339, JString, required = true,
                                 default = nil)
  if valid_580339 != nil:
    section.add "resource", valid_580339
  var valid_580340 = path.getOrDefault("project")
  valid_580340 = validateParameter(valid_580340, JString, required = true,
                                 default = nil)
  if valid_580340 != nil:
    section.add "project", valid_580340
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
  var valid_580341 = query.getOrDefault("fields")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = nil)
  if valid_580341 != nil:
    section.add "fields", valid_580341
  var valid_580342 = query.getOrDefault("quotaUser")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = nil)
  if valid_580342 != nil:
    section.add "quotaUser", valid_580342
  var valid_580343 = query.getOrDefault("alt")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = newJString("json"))
  if valid_580343 != nil:
    section.add "alt", valid_580343
  var valid_580344 = query.getOrDefault("oauth_token")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = nil)
  if valid_580344 != nil:
    section.add "oauth_token", valid_580344
  var valid_580345 = query.getOrDefault("userIp")
  valid_580345 = validateParameter(valid_580345, JString, required = false,
                                 default = nil)
  if valid_580345 != nil:
    section.add "userIp", valid_580345
  var valid_580346 = query.getOrDefault("key")
  valid_580346 = validateParameter(valid_580346, JString, required = false,
                                 default = nil)
  if valid_580346 != nil:
    section.add "key", valid_580346
  var valid_580347 = query.getOrDefault("prettyPrint")
  valid_580347 = validateParameter(valid_580347, JBool, required = false,
                                 default = newJBool(true))
  if valid_580347 != nil:
    section.add "prettyPrint", valid_580347
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

proc call*(call_580349: Call_DeploymentmanagerDeploymentsTestIamPermissions_580336;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified resource.
  ## 
  let valid = call_580349.validator(path, query, header, formData, body)
  let scheme = call_580349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580349.url(scheme.get, call_580349.host, call_580349.base,
                         call_580349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580349, url, valid)

proc call*(call_580350: Call_DeploymentmanagerDeploymentsTestIamPermissions_580336;
          resource: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## deploymentmanagerDeploymentsTestIamPermissions
  ## Returns permissions that a caller has on the specified resource.
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
  ##   resource: string (required)
  ##           : Name or id of the resource for this request.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580351 = newJObject()
  var query_580352 = newJObject()
  var body_580353 = newJObject()
  add(query_580352, "fields", newJString(fields))
  add(query_580352, "quotaUser", newJString(quotaUser))
  add(query_580352, "alt", newJString(alt))
  add(query_580352, "oauth_token", newJString(oauthToken))
  add(query_580352, "userIp", newJString(userIp))
  add(query_580352, "key", newJString(key))
  add(path_580351, "resource", newJString(resource))
  add(path_580351, "project", newJString(project))
  if body != nil:
    body_580353 = body
  add(query_580352, "prettyPrint", newJBool(prettyPrint))
  result = call_580350.call(path_580351, query_580352, nil, nil, body_580353)

var deploymentmanagerDeploymentsTestIamPermissions* = Call_DeploymentmanagerDeploymentsTestIamPermissions_580336(
    name: "deploymentmanagerDeploymentsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{project}/global/deployments/{resource}/testIamPermissions",
    validator: validate_DeploymentmanagerDeploymentsTestIamPermissions_580337,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerDeploymentsTestIamPermissions_580338,
    schemes: {Scheme.Https})
type
  Call_DeploymentmanagerOperationsList_580354 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerOperationsList_580356(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerOperationsList_580355(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all operations for a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_580357 = path.getOrDefault("project")
  valid_580357 = validateParameter(valid_580357, JString, required = true,
                                 default = nil)
  if valid_580357 != nil:
    section.add "project", valid_580357
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  ##   orderBy: JString
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  section = newJObject()
  var valid_580358 = query.getOrDefault("fields")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = nil)
  if valid_580358 != nil:
    section.add "fields", valid_580358
  var valid_580359 = query.getOrDefault("pageToken")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = nil)
  if valid_580359 != nil:
    section.add "pageToken", valid_580359
  var valid_580360 = query.getOrDefault("quotaUser")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = nil)
  if valid_580360 != nil:
    section.add "quotaUser", valid_580360
  var valid_580361 = query.getOrDefault("alt")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = newJString("json"))
  if valid_580361 != nil:
    section.add "alt", valid_580361
  var valid_580362 = query.getOrDefault("oauth_token")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = nil)
  if valid_580362 != nil:
    section.add "oauth_token", valid_580362
  var valid_580363 = query.getOrDefault("userIp")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = nil)
  if valid_580363 != nil:
    section.add "userIp", valid_580363
  var valid_580364 = query.getOrDefault("maxResults")
  valid_580364 = validateParameter(valid_580364, JInt, required = false,
                                 default = newJInt(500))
  if valid_580364 != nil:
    section.add "maxResults", valid_580364
  var valid_580365 = query.getOrDefault("orderBy")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "orderBy", valid_580365
  var valid_580366 = query.getOrDefault("key")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = nil)
  if valid_580366 != nil:
    section.add "key", valid_580366
  var valid_580367 = query.getOrDefault("prettyPrint")
  valid_580367 = validateParameter(valid_580367, JBool, required = false,
                                 default = newJBool(true))
  if valid_580367 != nil:
    section.add "prettyPrint", valid_580367
  var valid_580368 = query.getOrDefault("filter")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = nil)
  if valid_580368 != nil:
    section.add "filter", valid_580368
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580369: Call_DeploymentmanagerOperationsList_580354;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all operations for a project.
  ## 
  let valid = call_580369.validator(path, query, header, formData, body)
  let scheme = call_580369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580369.url(scheme.get, call_580369.host, call_580369.base,
                         call_580369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580369, url, valid)

proc call*(call_580370: Call_DeploymentmanagerOperationsList_580354;
          project: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 500; orderBy: string = "";
          key: string = ""; prettyPrint: bool = true; filter: string = ""): Recallable =
  ## deploymentmanagerOperationsList
  ## Lists all operations for a project.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  ##   orderBy: string
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  var path_580371 = newJObject()
  var query_580372 = newJObject()
  add(query_580372, "fields", newJString(fields))
  add(query_580372, "pageToken", newJString(pageToken))
  add(query_580372, "quotaUser", newJString(quotaUser))
  add(query_580372, "alt", newJString(alt))
  add(query_580372, "oauth_token", newJString(oauthToken))
  add(query_580372, "userIp", newJString(userIp))
  add(query_580372, "maxResults", newJInt(maxResults))
  add(query_580372, "orderBy", newJString(orderBy))
  add(query_580372, "key", newJString(key))
  add(path_580371, "project", newJString(project))
  add(query_580372, "prettyPrint", newJBool(prettyPrint))
  add(query_580372, "filter", newJString(filter))
  result = call_580370.call(path_580371, query_580372, nil, nil, nil)

var deploymentmanagerOperationsList* = Call_DeploymentmanagerOperationsList_580354(
    name: "deploymentmanagerOperationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/operations",
    validator: validate_DeploymentmanagerOperationsList_580355,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerOperationsList_580356, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerOperationsGet_580373 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerOperationsGet_580375(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "operation" in path, "`operation` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/operations/"),
               (kind: VariableSegment, value: "operation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerOperationsGet_580374(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about a specific operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operation: JString (required)
  ##            : The name of the operation for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `operation` field"
  var valid_580376 = path.getOrDefault("operation")
  valid_580376 = validateParameter(valid_580376, JString, required = true,
                                 default = nil)
  if valid_580376 != nil:
    section.add "operation", valid_580376
  var valid_580377 = path.getOrDefault("project")
  valid_580377 = validateParameter(valid_580377, JString, required = true,
                                 default = nil)
  if valid_580377 != nil:
    section.add "project", valid_580377
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
  var valid_580378 = query.getOrDefault("fields")
  valid_580378 = validateParameter(valid_580378, JString, required = false,
                                 default = nil)
  if valid_580378 != nil:
    section.add "fields", valid_580378
  var valid_580379 = query.getOrDefault("quotaUser")
  valid_580379 = validateParameter(valid_580379, JString, required = false,
                                 default = nil)
  if valid_580379 != nil:
    section.add "quotaUser", valid_580379
  var valid_580380 = query.getOrDefault("alt")
  valid_580380 = validateParameter(valid_580380, JString, required = false,
                                 default = newJString("json"))
  if valid_580380 != nil:
    section.add "alt", valid_580380
  var valid_580381 = query.getOrDefault("oauth_token")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = nil)
  if valid_580381 != nil:
    section.add "oauth_token", valid_580381
  var valid_580382 = query.getOrDefault("userIp")
  valid_580382 = validateParameter(valid_580382, JString, required = false,
                                 default = nil)
  if valid_580382 != nil:
    section.add "userIp", valid_580382
  var valid_580383 = query.getOrDefault("key")
  valid_580383 = validateParameter(valid_580383, JString, required = false,
                                 default = nil)
  if valid_580383 != nil:
    section.add "key", valid_580383
  var valid_580384 = query.getOrDefault("prettyPrint")
  valid_580384 = validateParameter(valid_580384, JBool, required = false,
                                 default = newJBool(true))
  if valid_580384 != nil:
    section.add "prettyPrint", valid_580384
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580385: Call_DeploymentmanagerOperationsGet_580373; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a specific operation.
  ## 
  let valid = call_580385.validator(path, query, header, formData, body)
  let scheme = call_580385.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580385.url(scheme.get, call_580385.host, call_580385.base,
                         call_580385.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580385, url, valid)

proc call*(call_580386: Call_DeploymentmanagerOperationsGet_580373;
          operation: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## deploymentmanagerOperationsGet
  ## Gets information about a specific operation.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   operation: string (required)
  ##            : The name of the operation for this request.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580387 = newJObject()
  var query_580388 = newJObject()
  add(query_580388, "fields", newJString(fields))
  add(query_580388, "quotaUser", newJString(quotaUser))
  add(query_580388, "alt", newJString(alt))
  add(path_580387, "operation", newJString(operation))
  add(query_580388, "oauth_token", newJString(oauthToken))
  add(query_580388, "userIp", newJString(userIp))
  add(query_580388, "key", newJString(key))
  add(path_580387, "project", newJString(project))
  add(query_580388, "prettyPrint", newJBool(prettyPrint))
  result = call_580386.call(path_580387, query_580388, nil, nil, nil)

var deploymentmanagerOperationsGet* = Call_DeploymentmanagerOperationsGet_580373(
    name: "deploymentmanagerOperationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/operations/{operation}",
    validator: validate_DeploymentmanagerOperationsGet_580374,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerOperationsGet_580375, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypeProvidersInsert_580408 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerTypeProvidersInsert_580410(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/typeProviders")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerTypeProvidersInsert_580409(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a type provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_580411 = path.getOrDefault("project")
  valid_580411 = validateParameter(valid_580411, JString, required = true,
                                 default = nil)
  if valid_580411 != nil:
    section.add "project", valid_580411
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
  var valid_580412 = query.getOrDefault("fields")
  valid_580412 = validateParameter(valid_580412, JString, required = false,
                                 default = nil)
  if valid_580412 != nil:
    section.add "fields", valid_580412
  var valid_580413 = query.getOrDefault("quotaUser")
  valid_580413 = validateParameter(valid_580413, JString, required = false,
                                 default = nil)
  if valid_580413 != nil:
    section.add "quotaUser", valid_580413
  var valid_580414 = query.getOrDefault("alt")
  valid_580414 = validateParameter(valid_580414, JString, required = false,
                                 default = newJString("json"))
  if valid_580414 != nil:
    section.add "alt", valid_580414
  var valid_580415 = query.getOrDefault("oauth_token")
  valid_580415 = validateParameter(valid_580415, JString, required = false,
                                 default = nil)
  if valid_580415 != nil:
    section.add "oauth_token", valid_580415
  var valid_580416 = query.getOrDefault("userIp")
  valid_580416 = validateParameter(valid_580416, JString, required = false,
                                 default = nil)
  if valid_580416 != nil:
    section.add "userIp", valid_580416
  var valid_580417 = query.getOrDefault("key")
  valid_580417 = validateParameter(valid_580417, JString, required = false,
                                 default = nil)
  if valid_580417 != nil:
    section.add "key", valid_580417
  var valid_580418 = query.getOrDefault("prettyPrint")
  valid_580418 = validateParameter(valid_580418, JBool, required = false,
                                 default = newJBool(true))
  if valid_580418 != nil:
    section.add "prettyPrint", valid_580418
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

proc call*(call_580420: Call_DeploymentmanagerTypeProvidersInsert_580408;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a type provider.
  ## 
  let valid = call_580420.validator(path, query, header, formData, body)
  let scheme = call_580420.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580420.url(scheme.get, call_580420.host, call_580420.base,
                         call_580420.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580420, url, valid)

proc call*(call_580421: Call_DeploymentmanagerTypeProvidersInsert_580408;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## deploymentmanagerTypeProvidersInsert
  ## Creates a type provider.
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
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580422 = newJObject()
  var query_580423 = newJObject()
  var body_580424 = newJObject()
  add(query_580423, "fields", newJString(fields))
  add(query_580423, "quotaUser", newJString(quotaUser))
  add(query_580423, "alt", newJString(alt))
  add(query_580423, "oauth_token", newJString(oauthToken))
  add(query_580423, "userIp", newJString(userIp))
  add(query_580423, "key", newJString(key))
  add(path_580422, "project", newJString(project))
  if body != nil:
    body_580424 = body
  add(query_580423, "prettyPrint", newJBool(prettyPrint))
  result = call_580421.call(path_580422, query_580423, nil, nil, body_580424)

var deploymentmanagerTypeProvidersInsert* = Call_DeploymentmanagerTypeProvidersInsert_580408(
    name: "deploymentmanagerTypeProvidersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/global/typeProviders",
    validator: validate_DeploymentmanagerTypeProvidersInsert_580409,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerTypeProvidersInsert_580410, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypeProvidersList_580389 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerTypeProvidersList_580391(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/typeProviders")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerTypeProvidersList_580390(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all resource type providers for Deployment Manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_580392 = path.getOrDefault("project")
  valid_580392 = validateParameter(valid_580392, JString, required = true,
                                 default = nil)
  if valid_580392 != nil:
    section.add "project", valid_580392
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  ##   orderBy: JString
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  section = newJObject()
  var valid_580393 = query.getOrDefault("fields")
  valid_580393 = validateParameter(valid_580393, JString, required = false,
                                 default = nil)
  if valid_580393 != nil:
    section.add "fields", valid_580393
  var valid_580394 = query.getOrDefault("pageToken")
  valid_580394 = validateParameter(valid_580394, JString, required = false,
                                 default = nil)
  if valid_580394 != nil:
    section.add "pageToken", valid_580394
  var valid_580395 = query.getOrDefault("quotaUser")
  valid_580395 = validateParameter(valid_580395, JString, required = false,
                                 default = nil)
  if valid_580395 != nil:
    section.add "quotaUser", valid_580395
  var valid_580396 = query.getOrDefault("alt")
  valid_580396 = validateParameter(valid_580396, JString, required = false,
                                 default = newJString("json"))
  if valid_580396 != nil:
    section.add "alt", valid_580396
  var valid_580397 = query.getOrDefault("oauth_token")
  valid_580397 = validateParameter(valid_580397, JString, required = false,
                                 default = nil)
  if valid_580397 != nil:
    section.add "oauth_token", valid_580397
  var valid_580398 = query.getOrDefault("userIp")
  valid_580398 = validateParameter(valid_580398, JString, required = false,
                                 default = nil)
  if valid_580398 != nil:
    section.add "userIp", valid_580398
  var valid_580399 = query.getOrDefault("maxResults")
  valid_580399 = validateParameter(valid_580399, JInt, required = false,
                                 default = newJInt(500))
  if valid_580399 != nil:
    section.add "maxResults", valid_580399
  var valid_580400 = query.getOrDefault("orderBy")
  valid_580400 = validateParameter(valid_580400, JString, required = false,
                                 default = nil)
  if valid_580400 != nil:
    section.add "orderBy", valid_580400
  var valid_580401 = query.getOrDefault("key")
  valid_580401 = validateParameter(valid_580401, JString, required = false,
                                 default = nil)
  if valid_580401 != nil:
    section.add "key", valid_580401
  var valid_580402 = query.getOrDefault("prettyPrint")
  valid_580402 = validateParameter(valid_580402, JBool, required = false,
                                 default = newJBool(true))
  if valid_580402 != nil:
    section.add "prettyPrint", valid_580402
  var valid_580403 = query.getOrDefault("filter")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = nil)
  if valid_580403 != nil:
    section.add "filter", valid_580403
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580404: Call_DeploymentmanagerTypeProvidersList_580389;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all resource type providers for Deployment Manager.
  ## 
  let valid = call_580404.validator(path, query, header, formData, body)
  let scheme = call_580404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580404.url(scheme.get, call_580404.host, call_580404.base,
                         call_580404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580404, url, valid)

proc call*(call_580405: Call_DeploymentmanagerTypeProvidersList_580389;
          project: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 500; orderBy: string = "";
          key: string = ""; prettyPrint: bool = true; filter: string = ""): Recallable =
  ## deploymentmanagerTypeProvidersList
  ## Lists all resource type providers for Deployment Manager.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  ##   orderBy: string
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  var path_580406 = newJObject()
  var query_580407 = newJObject()
  add(query_580407, "fields", newJString(fields))
  add(query_580407, "pageToken", newJString(pageToken))
  add(query_580407, "quotaUser", newJString(quotaUser))
  add(query_580407, "alt", newJString(alt))
  add(query_580407, "oauth_token", newJString(oauthToken))
  add(query_580407, "userIp", newJString(userIp))
  add(query_580407, "maxResults", newJInt(maxResults))
  add(query_580407, "orderBy", newJString(orderBy))
  add(query_580407, "key", newJString(key))
  add(path_580406, "project", newJString(project))
  add(query_580407, "prettyPrint", newJBool(prettyPrint))
  add(query_580407, "filter", newJString(filter))
  result = call_580405.call(path_580406, query_580407, nil, nil, nil)

var deploymentmanagerTypeProvidersList* = Call_DeploymentmanagerTypeProvidersList_580389(
    name: "deploymentmanagerTypeProvidersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/typeProviders",
    validator: validate_DeploymentmanagerTypeProvidersList_580390,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerTypeProvidersList_580391, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypeProvidersUpdate_580441 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerTypeProvidersUpdate_580443(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "typeProvider" in path, "`typeProvider` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/typeProviders/"),
               (kind: VariableSegment, value: "typeProvider")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerTypeProvidersUpdate_580442(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a type provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   typeProvider: JString (required)
  ##               : The name of the type provider for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `typeProvider` field"
  var valid_580444 = path.getOrDefault("typeProvider")
  valid_580444 = validateParameter(valid_580444, JString, required = true,
                                 default = nil)
  if valid_580444 != nil:
    section.add "typeProvider", valid_580444
  var valid_580445 = path.getOrDefault("project")
  valid_580445 = validateParameter(valid_580445, JString, required = true,
                                 default = nil)
  if valid_580445 != nil:
    section.add "project", valid_580445
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
  var valid_580446 = query.getOrDefault("fields")
  valid_580446 = validateParameter(valid_580446, JString, required = false,
                                 default = nil)
  if valid_580446 != nil:
    section.add "fields", valid_580446
  var valid_580447 = query.getOrDefault("quotaUser")
  valid_580447 = validateParameter(valid_580447, JString, required = false,
                                 default = nil)
  if valid_580447 != nil:
    section.add "quotaUser", valid_580447
  var valid_580448 = query.getOrDefault("alt")
  valid_580448 = validateParameter(valid_580448, JString, required = false,
                                 default = newJString("json"))
  if valid_580448 != nil:
    section.add "alt", valid_580448
  var valid_580449 = query.getOrDefault("oauth_token")
  valid_580449 = validateParameter(valid_580449, JString, required = false,
                                 default = nil)
  if valid_580449 != nil:
    section.add "oauth_token", valid_580449
  var valid_580450 = query.getOrDefault("userIp")
  valid_580450 = validateParameter(valid_580450, JString, required = false,
                                 default = nil)
  if valid_580450 != nil:
    section.add "userIp", valid_580450
  var valid_580451 = query.getOrDefault("key")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = nil)
  if valid_580451 != nil:
    section.add "key", valid_580451
  var valid_580452 = query.getOrDefault("prettyPrint")
  valid_580452 = validateParameter(valid_580452, JBool, required = false,
                                 default = newJBool(true))
  if valid_580452 != nil:
    section.add "prettyPrint", valid_580452
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

proc call*(call_580454: Call_DeploymentmanagerTypeProvidersUpdate_580441;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a type provider.
  ## 
  let valid = call_580454.validator(path, query, header, formData, body)
  let scheme = call_580454.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580454.url(scheme.get, call_580454.host, call_580454.base,
                         call_580454.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580454, url, valid)

proc call*(call_580455: Call_DeploymentmanagerTypeProvidersUpdate_580441;
          typeProvider: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## deploymentmanagerTypeProvidersUpdate
  ## Updates a type provider.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   typeProvider: string (required)
  ##               : The name of the type provider for this request.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580456 = newJObject()
  var query_580457 = newJObject()
  var body_580458 = newJObject()
  add(query_580457, "fields", newJString(fields))
  add(query_580457, "quotaUser", newJString(quotaUser))
  add(query_580457, "alt", newJString(alt))
  add(path_580456, "typeProvider", newJString(typeProvider))
  add(query_580457, "oauth_token", newJString(oauthToken))
  add(query_580457, "userIp", newJString(userIp))
  add(query_580457, "key", newJString(key))
  add(path_580456, "project", newJString(project))
  if body != nil:
    body_580458 = body
  add(query_580457, "prettyPrint", newJBool(prettyPrint))
  result = call_580455.call(path_580456, query_580457, nil, nil, body_580458)

var deploymentmanagerTypeProvidersUpdate* = Call_DeploymentmanagerTypeProvidersUpdate_580441(
    name: "deploymentmanagerTypeProvidersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{project}/global/typeProviders/{typeProvider}",
    validator: validate_DeploymentmanagerTypeProvidersUpdate_580442,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerTypeProvidersUpdate_580443, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypeProvidersGet_580425 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerTypeProvidersGet_580427(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "typeProvider" in path, "`typeProvider` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/typeProviders/"),
               (kind: VariableSegment, value: "typeProvider")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerTypeProvidersGet_580426(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about a specific type provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   typeProvider: JString (required)
  ##               : The name of the type provider for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `typeProvider` field"
  var valid_580428 = path.getOrDefault("typeProvider")
  valid_580428 = validateParameter(valid_580428, JString, required = true,
                                 default = nil)
  if valid_580428 != nil:
    section.add "typeProvider", valid_580428
  var valid_580429 = path.getOrDefault("project")
  valid_580429 = validateParameter(valid_580429, JString, required = true,
                                 default = nil)
  if valid_580429 != nil:
    section.add "project", valid_580429
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
  var valid_580430 = query.getOrDefault("fields")
  valid_580430 = validateParameter(valid_580430, JString, required = false,
                                 default = nil)
  if valid_580430 != nil:
    section.add "fields", valid_580430
  var valid_580431 = query.getOrDefault("quotaUser")
  valid_580431 = validateParameter(valid_580431, JString, required = false,
                                 default = nil)
  if valid_580431 != nil:
    section.add "quotaUser", valid_580431
  var valid_580432 = query.getOrDefault("alt")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = newJString("json"))
  if valid_580432 != nil:
    section.add "alt", valid_580432
  var valid_580433 = query.getOrDefault("oauth_token")
  valid_580433 = validateParameter(valid_580433, JString, required = false,
                                 default = nil)
  if valid_580433 != nil:
    section.add "oauth_token", valid_580433
  var valid_580434 = query.getOrDefault("userIp")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = nil)
  if valid_580434 != nil:
    section.add "userIp", valid_580434
  var valid_580435 = query.getOrDefault("key")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = nil)
  if valid_580435 != nil:
    section.add "key", valid_580435
  var valid_580436 = query.getOrDefault("prettyPrint")
  valid_580436 = validateParameter(valid_580436, JBool, required = false,
                                 default = newJBool(true))
  if valid_580436 != nil:
    section.add "prettyPrint", valid_580436
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580437: Call_DeploymentmanagerTypeProvidersGet_580425;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about a specific type provider.
  ## 
  let valid = call_580437.validator(path, query, header, formData, body)
  let scheme = call_580437.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580437.url(scheme.get, call_580437.host, call_580437.base,
                         call_580437.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580437, url, valid)

proc call*(call_580438: Call_DeploymentmanagerTypeProvidersGet_580425;
          typeProvider: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## deploymentmanagerTypeProvidersGet
  ## Gets information about a specific type provider.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   typeProvider: string (required)
  ##               : The name of the type provider for this request.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580439 = newJObject()
  var query_580440 = newJObject()
  add(query_580440, "fields", newJString(fields))
  add(query_580440, "quotaUser", newJString(quotaUser))
  add(query_580440, "alt", newJString(alt))
  add(path_580439, "typeProvider", newJString(typeProvider))
  add(query_580440, "oauth_token", newJString(oauthToken))
  add(query_580440, "userIp", newJString(userIp))
  add(query_580440, "key", newJString(key))
  add(path_580439, "project", newJString(project))
  add(query_580440, "prettyPrint", newJBool(prettyPrint))
  result = call_580438.call(path_580439, query_580440, nil, nil, nil)

var deploymentmanagerTypeProvidersGet* = Call_DeploymentmanagerTypeProvidersGet_580425(
    name: "deploymentmanagerTypeProvidersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/typeProviders/{typeProvider}",
    validator: validate_DeploymentmanagerTypeProvidersGet_580426,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerTypeProvidersGet_580427, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypeProvidersPatch_580475 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerTypeProvidersPatch_580477(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "typeProvider" in path, "`typeProvider` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/typeProviders/"),
               (kind: VariableSegment, value: "typeProvider")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerTypeProvidersPatch_580476(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a type provider. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   typeProvider: JString (required)
  ##               : The name of the type provider for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `typeProvider` field"
  var valid_580478 = path.getOrDefault("typeProvider")
  valid_580478 = validateParameter(valid_580478, JString, required = true,
                                 default = nil)
  if valid_580478 != nil:
    section.add "typeProvider", valid_580478
  var valid_580479 = path.getOrDefault("project")
  valid_580479 = validateParameter(valid_580479, JString, required = true,
                                 default = nil)
  if valid_580479 != nil:
    section.add "project", valid_580479
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
  var valid_580480 = query.getOrDefault("fields")
  valid_580480 = validateParameter(valid_580480, JString, required = false,
                                 default = nil)
  if valid_580480 != nil:
    section.add "fields", valid_580480
  var valid_580481 = query.getOrDefault("quotaUser")
  valid_580481 = validateParameter(valid_580481, JString, required = false,
                                 default = nil)
  if valid_580481 != nil:
    section.add "quotaUser", valid_580481
  var valid_580482 = query.getOrDefault("alt")
  valid_580482 = validateParameter(valid_580482, JString, required = false,
                                 default = newJString("json"))
  if valid_580482 != nil:
    section.add "alt", valid_580482
  var valid_580483 = query.getOrDefault("oauth_token")
  valid_580483 = validateParameter(valid_580483, JString, required = false,
                                 default = nil)
  if valid_580483 != nil:
    section.add "oauth_token", valid_580483
  var valid_580484 = query.getOrDefault("userIp")
  valid_580484 = validateParameter(valid_580484, JString, required = false,
                                 default = nil)
  if valid_580484 != nil:
    section.add "userIp", valid_580484
  var valid_580485 = query.getOrDefault("key")
  valid_580485 = validateParameter(valid_580485, JString, required = false,
                                 default = nil)
  if valid_580485 != nil:
    section.add "key", valid_580485
  var valid_580486 = query.getOrDefault("prettyPrint")
  valid_580486 = validateParameter(valid_580486, JBool, required = false,
                                 default = newJBool(true))
  if valid_580486 != nil:
    section.add "prettyPrint", valid_580486
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

proc call*(call_580488: Call_DeploymentmanagerTypeProvidersPatch_580475;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a type provider. This method supports patch semantics.
  ## 
  let valid = call_580488.validator(path, query, header, formData, body)
  let scheme = call_580488.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580488.url(scheme.get, call_580488.host, call_580488.base,
                         call_580488.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580488, url, valid)

proc call*(call_580489: Call_DeploymentmanagerTypeProvidersPatch_580475;
          typeProvider: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## deploymentmanagerTypeProvidersPatch
  ## Updates a type provider. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   typeProvider: string (required)
  ##               : The name of the type provider for this request.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580490 = newJObject()
  var query_580491 = newJObject()
  var body_580492 = newJObject()
  add(query_580491, "fields", newJString(fields))
  add(query_580491, "quotaUser", newJString(quotaUser))
  add(query_580491, "alt", newJString(alt))
  add(path_580490, "typeProvider", newJString(typeProvider))
  add(query_580491, "oauth_token", newJString(oauthToken))
  add(query_580491, "userIp", newJString(userIp))
  add(query_580491, "key", newJString(key))
  add(path_580490, "project", newJString(project))
  if body != nil:
    body_580492 = body
  add(query_580491, "prettyPrint", newJBool(prettyPrint))
  result = call_580489.call(path_580490, query_580491, nil, nil, body_580492)

var deploymentmanagerTypeProvidersPatch* = Call_DeploymentmanagerTypeProvidersPatch_580475(
    name: "deploymentmanagerTypeProvidersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{project}/global/typeProviders/{typeProvider}",
    validator: validate_DeploymentmanagerTypeProvidersPatch_580476,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerTypeProvidersPatch_580477, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypeProvidersDelete_580459 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerTypeProvidersDelete_580461(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "typeProvider" in path, "`typeProvider` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/typeProviders/"),
               (kind: VariableSegment, value: "typeProvider")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerTypeProvidersDelete_580460(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a type provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   typeProvider: JString (required)
  ##               : The name of the type provider for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `typeProvider` field"
  var valid_580462 = path.getOrDefault("typeProvider")
  valid_580462 = validateParameter(valid_580462, JString, required = true,
                                 default = nil)
  if valid_580462 != nil:
    section.add "typeProvider", valid_580462
  var valid_580463 = path.getOrDefault("project")
  valid_580463 = validateParameter(valid_580463, JString, required = true,
                                 default = nil)
  if valid_580463 != nil:
    section.add "project", valid_580463
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
  var valid_580467 = query.getOrDefault("oauth_token")
  valid_580467 = validateParameter(valid_580467, JString, required = false,
                                 default = nil)
  if valid_580467 != nil:
    section.add "oauth_token", valid_580467
  var valid_580468 = query.getOrDefault("userIp")
  valid_580468 = validateParameter(valid_580468, JString, required = false,
                                 default = nil)
  if valid_580468 != nil:
    section.add "userIp", valid_580468
  var valid_580469 = query.getOrDefault("key")
  valid_580469 = validateParameter(valid_580469, JString, required = false,
                                 default = nil)
  if valid_580469 != nil:
    section.add "key", valid_580469
  var valid_580470 = query.getOrDefault("prettyPrint")
  valid_580470 = validateParameter(valid_580470, JBool, required = false,
                                 default = newJBool(true))
  if valid_580470 != nil:
    section.add "prettyPrint", valid_580470
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580471: Call_DeploymentmanagerTypeProvidersDelete_580459;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a type provider.
  ## 
  let valid = call_580471.validator(path, query, header, formData, body)
  let scheme = call_580471.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580471.url(scheme.get, call_580471.host, call_580471.base,
                         call_580471.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580471, url, valid)

proc call*(call_580472: Call_DeploymentmanagerTypeProvidersDelete_580459;
          typeProvider: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## deploymentmanagerTypeProvidersDelete
  ## Deletes a type provider.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   typeProvider: string (required)
  ##               : The name of the type provider for this request.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580473 = newJObject()
  var query_580474 = newJObject()
  add(query_580474, "fields", newJString(fields))
  add(query_580474, "quotaUser", newJString(quotaUser))
  add(query_580474, "alt", newJString(alt))
  add(path_580473, "typeProvider", newJString(typeProvider))
  add(query_580474, "oauth_token", newJString(oauthToken))
  add(query_580474, "userIp", newJString(userIp))
  add(query_580474, "key", newJString(key))
  add(path_580473, "project", newJString(project))
  add(query_580474, "prettyPrint", newJBool(prettyPrint))
  result = call_580472.call(path_580473, query_580474, nil, nil, nil)

var deploymentmanagerTypeProvidersDelete* = Call_DeploymentmanagerTypeProvidersDelete_580459(
    name: "deploymentmanagerTypeProvidersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{project}/global/typeProviders/{typeProvider}",
    validator: validate_DeploymentmanagerTypeProvidersDelete_580460,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerTypeProvidersDelete_580461, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypeProvidersListTypes_580493 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerTypeProvidersListTypes_580495(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "typeProvider" in path, "`typeProvider` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/typeProviders/"),
               (kind: VariableSegment, value: "typeProvider"),
               (kind: ConstantSegment, value: "/types")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerTypeProvidersListTypes_580494(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the type info for a TypeProvider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   typeProvider: JString (required)
  ##               : The name of the type provider for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `typeProvider` field"
  var valid_580496 = path.getOrDefault("typeProvider")
  valid_580496 = validateParameter(valid_580496, JString, required = true,
                                 default = nil)
  if valid_580496 != nil:
    section.add "typeProvider", valid_580496
  var valid_580497 = path.getOrDefault("project")
  valid_580497 = validateParameter(valid_580497, JString, required = true,
                                 default = nil)
  if valid_580497 != nil:
    section.add "project", valid_580497
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  ##   orderBy: JString
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  section = newJObject()
  var valid_580498 = query.getOrDefault("fields")
  valid_580498 = validateParameter(valid_580498, JString, required = false,
                                 default = nil)
  if valid_580498 != nil:
    section.add "fields", valid_580498
  var valid_580499 = query.getOrDefault("pageToken")
  valid_580499 = validateParameter(valid_580499, JString, required = false,
                                 default = nil)
  if valid_580499 != nil:
    section.add "pageToken", valid_580499
  var valid_580500 = query.getOrDefault("quotaUser")
  valid_580500 = validateParameter(valid_580500, JString, required = false,
                                 default = nil)
  if valid_580500 != nil:
    section.add "quotaUser", valid_580500
  var valid_580501 = query.getOrDefault("alt")
  valid_580501 = validateParameter(valid_580501, JString, required = false,
                                 default = newJString("json"))
  if valid_580501 != nil:
    section.add "alt", valid_580501
  var valid_580502 = query.getOrDefault("oauth_token")
  valid_580502 = validateParameter(valid_580502, JString, required = false,
                                 default = nil)
  if valid_580502 != nil:
    section.add "oauth_token", valid_580502
  var valid_580503 = query.getOrDefault("userIp")
  valid_580503 = validateParameter(valid_580503, JString, required = false,
                                 default = nil)
  if valid_580503 != nil:
    section.add "userIp", valid_580503
  var valid_580504 = query.getOrDefault("maxResults")
  valid_580504 = validateParameter(valid_580504, JInt, required = false,
                                 default = newJInt(500))
  if valid_580504 != nil:
    section.add "maxResults", valid_580504
  var valid_580505 = query.getOrDefault("orderBy")
  valid_580505 = validateParameter(valid_580505, JString, required = false,
                                 default = nil)
  if valid_580505 != nil:
    section.add "orderBy", valid_580505
  var valid_580506 = query.getOrDefault("key")
  valid_580506 = validateParameter(valid_580506, JString, required = false,
                                 default = nil)
  if valid_580506 != nil:
    section.add "key", valid_580506
  var valid_580507 = query.getOrDefault("prettyPrint")
  valid_580507 = validateParameter(valid_580507, JBool, required = false,
                                 default = newJBool(true))
  if valid_580507 != nil:
    section.add "prettyPrint", valid_580507
  var valid_580508 = query.getOrDefault("filter")
  valid_580508 = validateParameter(valid_580508, JString, required = false,
                                 default = nil)
  if valid_580508 != nil:
    section.add "filter", valid_580508
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580509: Call_DeploymentmanagerTypeProvidersListTypes_580493;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the type info for a TypeProvider.
  ## 
  let valid = call_580509.validator(path, query, header, formData, body)
  let scheme = call_580509.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580509.url(scheme.get, call_580509.host, call_580509.base,
                         call_580509.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580509, url, valid)

proc call*(call_580510: Call_DeploymentmanagerTypeProvidersListTypes_580493;
          typeProvider: string; project: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 500;
          orderBy: string = ""; key: string = ""; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## deploymentmanagerTypeProvidersListTypes
  ## Lists all the type info for a TypeProvider.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   typeProvider: string (required)
  ##               : The name of the type provider for this request.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  ##   orderBy: string
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  var path_580511 = newJObject()
  var query_580512 = newJObject()
  add(query_580512, "fields", newJString(fields))
  add(query_580512, "pageToken", newJString(pageToken))
  add(query_580512, "quotaUser", newJString(quotaUser))
  add(query_580512, "alt", newJString(alt))
  add(path_580511, "typeProvider", newJString(typeProvider))
  add(query_580512, "oauth_token", newJString(oauthToken))
  add(query_580512, "userIp", newJString(userIp))
  add(query_580512, "maxResults", newJInt(maxResults))
  add(query_580512, "orderBy", newJString(orderBy))
  add(query_580512, "key", newJString(key))
  add(path_580511, "project", newJString(project))
  add(query_580512, "prettyPrint", newJBool(prettyPrint))
  add(query_580512, "filter", newJString(filter))
  result = call_580510.call(path_580511, query_580512, nil, nil, nil)

var deploymentmanagerTypeProvidersListTypes* = Call_DeploymentmanagerTypeProvidersListTypes_580493(
    name: "deploymentmanagerTypeProvidersListTypes", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/typeProviders/{typeProvider}/types",
    validator: validate_DeploymentmanagerTypeProvidersListTypes_580494,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerTypeProvidersListTypes_580495,
    schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypeProvidersGetType_580513 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerTypeProvidersGetType_580515(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "typeProvider" in path, "`typeProvider` is a required path parameter"
  assert "type" in path, "`type` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/typeProviders/"),
               (kind: VariableSegment, value: "typeProvider"),
               (kind: ConstantSegment, value: "/types/"),
               (kind: VariableSegment, value: "type")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerTypeProvidersGetType_580514(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a type info for a type provided by a TypeProvider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   type: JString (required)
  ##       : The name of the type provider type for this request.
  ##   typeProvider: JString (required)
  ##               : The name of the type provider for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `type` field"
  var valid_580516 = path.getOrDefault("type")
  valid_580516 = validateParameter(valid_580516, JString, required = true,
                                 default = nil)
  if valid_580516 != nil:
    section.add "type", valid_580516
  var valid_580517 = path.getOrDefault("typeProvider")
  valid_580517 = validateParameter(valid_580517, JString, required = true,
                                 default = nil)
  if valid_580517 != nil:
    section.add "typeProvider", valid_580517
  var valid_580518 = path.getOrDefault("project")
  valid_580518 = validateParameter(valid_580518, JString, required = true,
                                 default = nil)
  if valid_580518 != nil:
    section.add "project", valid_580518
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
  var valid_580519 = query.getOrDefault("fields")
  valid_580519 = validateParameter(valid_580519, JString, required = false,
                                 default = nil)
  if valid_580519 != nil:
    section.add "fields", valid_580519
  var valid_580520 = query.getOrDefault("quotaUser")
  valid_580520 = validateParameter(valid_580520, JString, required = false,
                                 default = nil)
  if valid_580520 != nil:
    section.add "quotaUser", valid_580520
  var valid_580521 = query.getOrDefault("alt")
  valid_580521 = validateParameter(valid_580521, JString, required = false,
                                 default = newJString("json"))
  if valid_580521 != nil:
    section.add "alt", valid_580521
  var valid_580522 = query.getOrDefault("oauth_token")
  valid_580522 = validateParameter(valid_580522, JString, required = false,
                                 default = nil)
  if valid_580522 != nil:
    section.add "oauth_token", valid_580522
  var valid_580523 = query.getOrDefault("userIp")
  valid_580523 = validateParameter(valid_580523, JString, required = false,
                                 default = nil)
  if valid_580523 != nil:
    section.add "userIp", valid_580523
  var valid_580524 = query.getOrDefault("key")
  valid_580524 = validateParameter(valid_580524, JString, required = false,
                                 default = nil)
  if valid_580524 != nil:
    section.add "key", valid_580524
  var valid_580525 = query.getOrDefault("prettyPrint")
  valid_580525 = validateParameter(valid_580525, JBool, required = false,
                                 default = newJBool(true))
  if valid_580525 != nil:
    section.add "prettyPrint", valid_580525
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580526: Call_DeploymentmanagerTypeProvidersGetType_580513;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a type info for a type provided by a TypeProvider.
  ## 
  let valid = call_580526.validator(path, query, header, formData, body)
  let scheme = call_580526.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580526.url(scheme.get, call_580526.host, call_580526.base,
                         call_580526.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580526, url, valid)

proc call*(call_580527: Call_DeploymentmanagerTypeProvidersGetType_580513;
          `type`: string; typeProvider: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## deploymentmanagerTypeProvidersGetType
  ## Gets a type info for a type provided by a TypeProvider.
  ##   type: string (required)
  ##       : The name of the type provider type for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   typeProvider: string (required)
  ##               : The name of the type provider for this request.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580528 = newJObject()
  var query_580529 = newJObject()
  add(path_580528, "type", newJString(`type`))
  add(query_580529, "fields", newJString(fields))
  add(query_580529, "quotaUser", newJString(quotaUser))
  add(query_580529, "alt", newJString(alt))
  add(path_580528, "typeProvider", newJString(typeProvider))
  add(query_580529, "oauth_token", newJString(oauthToken))
  add(query_580529, "userIp", newJString(userIp))
  add(query_580529, "key", newJString(key))
  add(path_580528, "project", newJString(project))
  add(query_580529, "prettyPrint", newJBool(prettyPrint))
  result = call_580527.call(path_580528, query_580529, nil, nil, nil)

var deploymentmanagerTypeProvidersGetType* = Call_DeploymentmanagerTypeProvidersGetType_580513(
    name: "deploymentmanagerTypeProvidersGetType", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/typeProviders/{typeProvider}/types/{type}",
    validator: validate_DeploymentmanagerTypeProvidersGetType_580514,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerTypeProvidersGetType_580515, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypesInsert_580549 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerTypesInsert_580551(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/types")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerTypesInsert_580550(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_580552 = path.getOrDefault("project")
  valid_580552 = validateParameter(valid_580552, JString, required = true,
                                 default = nil)
  if valid_580552 != nil:
    section.add "project", valid_580552
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
  var valid_580553 = query.getOrDefault("fields")
  valid_580553 = validateParameter(valid_580553, JString, required = false,
                                 default = nil)
  if valid_580553 != nil:
    section.add "fields", valid_580553
  var valid_580554 = query.getOrDefault("quotaUser")
  valid_580554 = validateParameter(valid_580554, JString, required = false,
                                 default = nil)
  if valid_580554 != nil:
    section.add "quotaUser", valid_580554
  var valid_580555 = query.getOrDefault("alt")
  valid_580555 = validateParameter(valid_580555, JString, required = false,
                                 default = newJString("json"))
  if valid_580555 != nil:
    section.add "alt", valid_580555
  var valid_580556 = query.getOrDefault("oauth_token")
  valid_580556 = validateParameter(valid_580556, JString, required = false,
                                 default = nil)
  if valid_580556 != nil:
    section.add "oauth_token", valid_580556
  var valid_580557 = query.getOrDefault("userIp")
  valid_580557 = validateParameter(valid_580557, JString, required = false,
                                 default = nil)
  if valid_580557 != nil:
    section.add "userIp", valid_580557
  var valid_580558 = query.getOrDefault("key")
  valid_580558 = validateParameter(valid_580558, JString, required = false,
                                 default = nil)
  if valid_580558 != nil:
    section.add "key", valid_580558
  var valid_580559 = query.getOrDefault("prettyPrint")
  valid_580559 = validateParameter(valid_580559, JBool, required = false,
                                 default = newJBool(true))
  if valid_580559 != nil:
    section.add "prettyPrint", valid_580559
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

proc call*(call_580561: Call_DeploymentmanagerTypesInsert_580549; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a type.
  ## 
  let valid = call_580561.validator(path, query, header, formData, body)
  let scheme = call_580561.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580561.url(scheme.get, call_580561.host, call_580561.base,
                         call_580561.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580561, url, valid)

proc call*(call_580562: Call_DeploymentmanagerTypesInsert_580549; project: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## deploymentmanagerTypesInsert
  ## Creates a type.
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
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580563 = newJObject()
  var query_580564 = newJObject()
  var body_580565 = newJObject()
  add(query_580564, "fields", newJString(fields))
  add(query_580564, "quotaUser", newJString(quotaUser))
  add(query_580564, "alt", newJString(alt))
  add(query_580564, "oauth_token", newJString(oauthToken))
  add(query_580564, "userIp", newJString(userIp))
  add(query_580564, "key", newJString(key))
  add(path_580563, "project", newJString(project))
  if body != nil:
    body_580565 = body
  add(query_580564, "prettyPrint", newJBool(prettyPrint))
  result = call_580562.call(path_580563, query_580564, nil, nil, body_580565)

var deploymentmanagerTypesInsert* = Call_DeploymentmanagerTypesInsert_580549(
    name: "deploymentmanagerTypesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/global/types",
    validator: validate_DeploymentmanagerTypesInsert_580550,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerTypesInsert_580551, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypesList_580530 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerTypesList_580532(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/types")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerTypesList_580531(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all resource types for Deployment Manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_580533 = path.getOrDefault("project")
  valid_580533 = validateParameter(valid_580533, JString, required = true,
                                 default = nil)
  if valid_580533 != nil:
    section.add "project", valid_580533
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  ##   orderBy: JString
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  section = newJObject()
  var valid_580534 = query.getOrDefault("fields")
  valid_580534 = validateParameter(valid_580534, JString, required = false,
                                 default = nil)
  if valid_580534 != nil:
    section.add "fields", valid_580534
  var valid_580535 = query.getOrDefault("pageToken")
  valid_580535 = validateParameter(valid_580535, JString, required = false,
                                 default = nil)
  if valid_580535 != nil:
    section.add "pageToken", valid_580535
  var valid_580536 = query.getOrDefault("quotaUser")
  valid_580536 = validateParameter(valid_580536, JString, required = false,
                                 default = nil)
  if valid_580536 != nil:
    section.add "quotaUser", valid_580536
  var valid_580537 = query.getOrDefault("alt")
  valid_580537 = validateParameter(valid_580537, JString, required = false,
                                 default = newJString("json"))
  if valid_580537 != nil:
    section.add "alt", valid_580537
  var valid_580538 = query.getOrDefault("oauth_token")
  valid_580538 = validateParameter(valid_580538, JString, required = false,
                                 default = nil)
  if valid_580538 != nil:
    section.add "oauth_token", valid_580538
  var valid_580539 = query.getOrDefault("userIp")
  valid_580539 = validateParameter(valid_580539, JString, required = false,
                                 default = nil)
  if valid_580539 != nil:
    section.add "userIp", valid_580539
  var valid_580540 = query.getOrDefault("maxResults")
  valid_580540 = validateParameter(valid_580540, JInt, required = false,
                                 default = newJInt(500))
  if valid_580540 != nil:
    section.add "maxResults", valid_580540
  var valid_580541 = query.getOrDefault("orderBy")
  valid_580541 = validateParameter(valid_580541, JString, required = false,
                                 default = nil)
  if valid_580541 != nil:
    section.add "orderBy", valid_580541
  var valid_580542 = query.getOrDefault("key")
  valid_580542 = validateParameter(valid_580542, JString, required = false,
                                 default = nil)
  if valid_580542 != nil:
    section.add "key", valid_580542
  var valid_580543 = query.getOrDefault("prettyPrint")
  valid_580543 = validateParameter(valid_580543, JBool, required = false,
                                 default = newJBool(true))
  if valid_580543 != nil:
    section.add "prettyPrint", valid_580543
  var valid_580544 = query.getOrDefault("filter")
  valid_580544 = validateParameter(valid_580544, JString, required = false,
                                 default = nil)
  if valid_580544 != nil:
    section.add "filter", valid_580544
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580545: Call_DeploymentmanagerTypesList_580530; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all resource types for Deployment Manager.
  ## 
  let valid = call_580545.validator(path, query, header, formData, body)
  let scheme = call_580545.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580545.url(scheme.get, call_580545.host, call_580545.base,
                         call_580545.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580545, url, valid)

proc call*(call_580546: Call_DeploymentmanagerTypesList_580530; project: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 500; orderBy: string = ""; key: string = "";
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## deploymentmanagerTypesList
  ## Lists all resource types for Deployment Manager.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  ##   orderBy: string
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  var path_580547 = newJObject()
  var query_580548 = newJObject()
  add(query_580548, "fields", newJString(fields))
  add(query_580548, "pageToken", newJString(pageToken))
  add(query_580548, "quotaUser", newJString(quotaUser))
  add(query_580548, "alt", newJString(alt))
  add(query_580548, "oauth_token", newJString(oauthToken))
  add(query_580548, "userIp", newJString(userIp))
  add(query_580548, "maxResults", newJInt(maxResults))
  add(query_580548, "orderBy", newJString(orderBy))
  add(query_580548, "key", newJString(key))
  add(path_580547, "project", newJString(project))
  add(query_580548, "prettyPrint", newJBool(prettyPrint))
  add(query_580548, "filter", newJString(filter))
  result = call_580546.call(path_580547, query_580548, nil, nil, nil)

var deploymentmanagerTypesList* = Call_DeploymentmanagerTypesList_580530(
    name: "deploymentmanagerTypesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/types",
    validator: validate_DeploymentmanagerTypesList_580531,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerTypesList_580532, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypesUpdate_580582 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerTypesUpdate_580584(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "type" in path, "`type` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/types/"),
               (kind: VariableSegment, value: "type")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerTypesUpdate_580583(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   type: JString (required)
  ##       : The name of the type for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `type` field"
  var valid_580585 = path.getOrDefault("type")
  valid_580585 = validateParameter(valid_580585, JString, required = true,
                                 default = nil)
  if valid_580585 != nil:
    section.add "type", valid_580585
  var valid_580586 = path.getOrDefault("project")
  valid_580586 = validateParameter(valid_580586, JString, required = true,
                                 default = nil)
  if valid_580586 != nil:
    section.add "project", valid_580586
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
  var valid_580587 = query.getOrDefault("fields")
  valid_580587 = validateParameter(valid_580587, JString, required = false,
                                 default = nil)
  if valid_580587 != nil:
    section.add "fields", valid_580587
  var valid_580588 = query.getOrDefault("quotaUser")
  valid_580588 = validateParameter(valid_580588, JString, required = false,
                                 default = nil)
  if valid_580588 != nil:
    section.add "quotaUser", valid_580588
  var valid_580589 = query.getOrDefault("alt")
  valid_580589 = validateParameter(valid_580589, JString, required = false,
                                 default = newJString("json"))
  if valid_580589 != nil:
    section.add "alt", valid_580589
  var valid_580590 = query.getOrDefault("oauth_token")
  valid_580590 = validateParameter(valid_580590, JString, required = false,
                                 default = nil)
  if valid_580590 != nil:
    section.add "oauth_token", valid_580590
  var valid_580591 = query.getOrDefault("userIp")
  valid_580591 = validateParameter(valid_580591, JString, required = false,
                                 default = nil)
  if valid_580591 != nil:
    section.add "userIp", valid_580591
  var valid_580592 = query.getOrDefault("key")
  valid_580592 = validateParameter(valid_580592, JString, required = false,
                                 default = nil)
  if valid_580592 != nil:
    section.add "key", valid_580592
  var valid_580593 = query.getOrDefault("prettyPrint")
  valid_580593 = validateParameter(valid_580593, JBool, required = false,
                                 default = newJBool(true))
  if valid_580593 != nil:
    section.add "prettyPrint", valid_580593
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

proc call*(call_580595: Call_DeploymentmanagerTypesUpdate_580582; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a type.
  ## 
  let valid = call_580595.validator(path, query, header, formData, body)
  let scheme = call_580595.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580595.url(scheme.get, call_580595.host, call_580595.base,
                         call_580595.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580595, url, valid)

proc call*(call_580596: Call_DeploymentmanagerTypesUpdate_580582; `type`: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## deploymentmanagerTypesUpdate
  ## Updates a type.
  ##   type: string (required)
  ##       : The name of the type for this request.
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
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580597 = newJObject()
  var query_580598 = newJObject()
  var body_580599 = newJObject()
  add(path_580597, "type", newJString(`type`))
  add(query_580598, "fields", newJString(fields))
  add(query_580598, "quotaUser", newJString(quotaUser))
  add(query_580598, "alt", newJString(alt))
  add(query_580598, "oauth_token", newJString(oauthToken))
  add(query_580598, "userIp", newJString(userIp))
  add(query_580598, "key", newJString(key))
  add(path_580597, "project", newJString(project))
  if body != nil:
    body_580599 = body
  add(query_580598, "prettyPrint", newJBool(prettyPrint))
  result = call_580596.call(path_580597, query_580598, nil, nil, body_580599)

var deploymentmanagerTypesUpdate* = Call_DeploymentmanagerTypesUpdate_580582(
    name: "deploymentmanagerTypesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{project}/global/types/{type}",
    validator: validate_DeploymentmanagerTypesUpdate_580583,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerTypesUpdate_580584, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypesGet_580566 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerTypesGet_580568(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "type" in path, "`type` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/types/"),
               (kind: VariableSegment, value: "type")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerTypesGet_580567(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about a specific type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   type: JString (required)
  ##       : The name of the type for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `type` field"
  var valid_580569 = path.getOrDefault("type")
  valid_580569 = validateParameter(valid_580569, JString, required = true,
                                 default = nil)
  if valid_580569 != nil:
    section.add "type", valid_580569
  var valid_580570 = path.getOrDefault("project")
  valid_580570 = validateParameter(valid_580570, JString, required = true,
                                 default = nil)
  if valid_580570 != nil:
    section.add "project", valid_580570
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
  var valid_580571 = query.getOrDefault("fields")
  valid_580571 = validateParameter(valid_580571, JString, required = false,
                                 default = nil)
  if valid_580571 != nil:
    section.add "fields", valid_580571
  var valid_580572 = query.getOrDefault("quotaUser")
  valid_580572 = validateParameter(valid_580572, JString, required = false,
                                 default = nil)
  if valid_580572 != nil:
    section.add "quotaUser", valid_580572
  var valid_580573 = query.getOrDefault("alt")
  valid_580573 = validateParameter(valid_580573, JString, required = false,
                                 default = newJString("json"))
  if valid_580573 != nil:
    section.add "alt", valid_580573
  var valid_580574 = query.getOrDefault("oauth_token")
  valid_580574 = validateParameter(valid_580574, JString, required = false,
                                 default = nil)
  if valid_580574 != nil:
    section.add "oauth_token", valid_580574
  var valid_580575 = query.getOrDefault("userIp")
  valid_580575 = validateParameter(valid_580575, JString, required = false,
                                 default = nil)
  if valid_580575 != nil:
    section.add "userIp", valid_580575
  var valid_580576 = query.getOrDefault("key")
  valid_580576 = validateParameter(valid_580576, JString, required = false,
                                 default = nil)
  if valid_580576 != nil:
    section.add "key", valid_580576
  var valid_580577 = query.getOrDefault("prettyPrint")
  valid_580577 = validateParameter(valid_580577, JBool, required = false,
                                 default = newJBool(true))
  if valid_580577 != nil:
    section.add "prettyPrint", valid_580577
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580578: Call_DeploymentmanagerTypesGet_580566; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a specific type.
  ## 
  let valid = call_580578.validator(path, query, header, formData, body)
  let scheme = call_580578.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580578.url(scheme.get, call_580578.host, call_580578.base,
                         call_580578.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580578, url, valid)

proc call*(call_580579: Call_DeploymentmanagerTypesGet_580566; `type`: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## deploymentmanagerTypesGet
  ## Gets information about a specific type.
  ##   type: string (required)
  ##       : The name of the type for this request.
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
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580580 = newJObject()
  var query_580581 = newJObject()
  add(path_580580, "type", newJString(`type`))
  add(query_580581, "fields", newJString(fields))
  add(query_580581, "quotaUser", newJString(quotaUser))
  add(query_580581, "alt", newJString(alt))
  add(query_580581, "oauth_token", newJString(oauthToken))
  add(query_580581, "userIp", newJString(userIp))
  add(query_580581, "key", newJString(key))
  add(path_580580, "project", newJString(project))
  add(query_580581, "prettyPrint", newJBool(prettyPrint))
  result = call_580579.call(path_580580, query_580581, nil, nil, nil)

var deploymentmanagerTypesGet* = Call_DeploymentmanagerTypesGet_580566(
    name: "deploymentmanagerTypesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/types/{type}",
    validator: validate_DeploymentmanagerTypesGet_580567,
    base: "/deploymentmanager/alpha/projects", url: url_DeploymentmanagerTypesGet_580568,
    schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypesPatch_580616 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerTypesPatch_580618(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "type" in path, "`type` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/types/"),
               (kind: VariableSegment, value: "type")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerTypesPatch_580617(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a type. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   type: JString (required)
  ##       : The name of the type for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `type` field"
  var valid_580619 = path.getOrDefault("type")
  valid_580619 = validateParameter(valid_580619, JString, required = true,
                                 default = nil)
  if valid_580619 != nil:
    section.add "type", valid_580619
  var valid_580620 = path.getOrDefault("project")
  valid_580620 = validateParameter(valid_580620, JString, required = true,
                                 default = nil)
  if valid_580620 != nil:
    section.add "project", valid_580620
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
  var valid_580621 = query.getOrDefault("fields")
  valid_580621 = validateParameter(valid_580621, JString, required = false,
                                 default = nil)
  if valid_580621 != nil:
    section.add "fields", valid_580621
  var valid_580622 = query.getOrDefault("quotaUser")
  valid_580622 = validateParameter(valid_580622, JString, required = false,
                                 default = nil)
  if valid_580622 != nil:
    section.add "quotaUser", valid_580622
  var valid_580623 = query.getOrDefault("alt")
  valid_580623 = validateParameter(valid_580623, JString, required = false,
                                 default = newJString("json"))
  if valid_580623 != nil:
    section.add "alt", valid_580623
  var valid_580624 = query.getOrDefault("oauth_token")
  valid_580624 = validateParameter(valid_580624, JString, required = false,
                                 default = nil)
  if valid_580624 != nil:
    section.add "oauth_token", valid_580624
  var valid_580625 = query.getOrDefault("userIp")
  valid_580625 = validateParameter(valid_580625, JString, required = false,
                                 default = nil)
  if valid_580625 != nil:
    section.add "userIp", valid_580625
  var valid_580626 = query.getOrDefault("key")
  valid_580626 = validateParameter(valid_580626, JString, required = false,
                                 default = nil)
  if valid_580626 != nil:
    section.add "key", valid_580626
  var valid_580627 = query.getOrDefault("prettyPrint")
  valid_580627 = validateParameter(valid_580627, JBool, required = false,
                                 default = newJBool(true))
  if valid_580627 != nil:
    section.add "prettyPrint", valid_580627
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

proc call*(call_580629: Call_DeploymentmanagerTypesPatch_580616; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a type. This method supports patch semantics.
  ## 
  let valid = call_580629.validator(path, query, header, formData, body)
  let scheme = call_580629.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580629.url(scheme.get, call_580629.host, call_580629.base,
                         call_580629.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580629, url, valid)

proc call*(call_580630: Call_DeploymentmanagerTypesPatch_580616; `type`: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## deploymentmanagerTypesPatch
  ## Updates a type. This method supports patch semantics.
  ##   type: string (required)
  ##       : The name of the type for this request.
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
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580631 = newJObject()
  var query_580632 = newJObject()
  var body_580633 = newJObject()
  add(path_580631, "type", newJString(`type`))
  add(query_580632, "fields", newJString(fields))
  add(query_580632, "quotaUser", newJString(quotaUser))
  add(query_580632, "alt", newJString(alt))
  add(query_580632, "oauth_token", newJString(oauthToken))
  add(query_580632, "userIp", newJString(userIp))
  add(query_580632, "key", newJString(key))
  add(path_580631, "project", newJString(project))
  if body != nil:
    body_580633 = body
  add(query_580632, "prettyPrint", newJBool(prettyPrint))
  result = call_580630.call(path_580631, query_580632, nil, nil, body_580633)

var deploymentmanagerTypesPatch* = Call_DeploymentmanagerTypesPatch_580616(
    name: "deploymentmanagerTypesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{project}/global/types/{type}",
    validator: validate_DeploymentmanagerTypesPatch_580617,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerTypesPatch_580618, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypesDelete_580600 = ref object of OpenApiRestCall_579437
proc url_DeploymentmanagerTypesDelete_580602(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "type" in path, "`type` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/types/"),
               (kind: VariableSegment, value: "type")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerTypesDelete_580601(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a type and all of the resources in the type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   type: JString (required)
  ##       : The name of the type for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `type` field"
  var valid_580603 = path.getOrDefault("type")
  valid_580603 = validateParameter(valid_580603, JString, required = true,
                                 default = nil)
  if valid_580603 != nil:
    section.add "type", valid_580603
  var valid_580604 = path.getOrDefault("project")
  valid_580604 = validateParameter(valid_580604, JString, required = true,
                                 default = nil)
  if valid_580604 != nil:
    section.add "project", valid_580604
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
  var valid_580605 = query.getOrDefault("fields")
  valid_580605 = validateParameter(valid_580605, JString, required = false,
                                 default = nil)
  if valid_580605 != nil:
    section.add "fields", valid_580605
  var valid_580606 = query.getOrDefault("quotaUser")
  valid_580606 = validateParameter(valid_580606, JString, required = false,
                                 default = nil)
  if valid_580606 != nil:
    section.add "quotaUser", valid_580606
  var valid_580607 = query.getOrDefault("alt")
  valid_580607 = validateParameter(valid_580607, JString, required = false,
                                 default = newJString("json"))
  if valid_580607 != nil:
    section.add "alt", valid_580607
  var valid_580608 = query.getOrDefault("oauth_token")
  valid_580608 = validateParameter(valid_580608, JString, required = false,
                                 default = nil)
  if valid_580608 != nil:
    section.add "oauth_token", valid_580608
  var valid_580609 = query.getOrDefault("userIp")
  valid_580609 = validateParameter(valid_580609, JString, required = false,
                                 default = nil)
  if valid_580609 != nil:
    section.add "userIp", valid_580609
  var valid_580610 = query.getOrDefault("key")
  valid_580610 = validateParameter(valid_580610, JString, required = false,
                                 default = nil)
  if valid_580610 != nil:
    section.add "key", valid_580610
  var valid_580611 = query.getOrDefault("prettyPrint")
  valid_580611 = validateParameter(valid_580611, JBool, required = false,
                                 default = newJBool(true))
  if valid_580611 != nil:
    section.add "prettyPrint", valid_580611
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580612: Call_DeploymentmanagerTypesDelete_580600; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a type and all of the resources in the type.
  ## 
  let valid = call_580612.validator(path, query, header, formData, body)
  let scheme = call_580612.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580612.url(scheme.get, call_580612.host, call_580612.base,
                         call_580612.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580612, url, valid)

proc call*(call_580613: Call_DeploymentmanagerTypesDelete_580600; `type`: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## deploymentmanagerTypesDelete
  ## Deletes a type and all of the resources in the type.
  ##   type: string (required)
  ##       : The name of the type for this request.
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
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580614 = newJObject()
  var query_580615 = newJObject()
  add(path_580614, "type", newJString(`type`))
  add(query_580615, "fields", newJString(fields))
  add(query_580615, "quotaUser", newJString(quotaUser))
  add(query_580615, "alt", newJString(alt))
  add(query_580615, "oauth_token", newJString(oauthToken))
  add(query_580615, "userIp", newJString(userIp))
  add(query_580615, "key", newJString(key))
  add(path_580614, "project", newJString(project))
  add(query_580615, "prettyPrint", newJBool(prettyPrint))
  result = call_580613.call(path_580614, query_580615, nil, nil, nil)

var deploymentmanagerTypesDelete* = Call_DeploymentmanagerTypesDelete_580600(
    name: "deploymentmanagerTypesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{project}/global/types/{type}",
    validator: validate_DeploymentmanagerTypesDelete_580601,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerTypesDelete_580602, schemes: {Scheme.Https})
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
