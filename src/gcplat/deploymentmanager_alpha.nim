
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

  OpenApiRestCall_578364 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578364](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578364): Option[Scheme] {.used.} =
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
  gcpServiceName = "deploymentmanager"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DeploymentmanagerCompositeTypesInsert_578923 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerCompositeTypesInsert_578925(protocol: Scheme;
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

proc validate_DeploymentmanagerCompositeTypesInsert_578924(path: JsonNode;
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
  var valid_578926 = path.getOrDefault("project")
  valid_578926 = validateParameter(valid_578926, JString, required = true,
                                 default = nil)
  if valid_578926 != nil:
    section.add "project", valid_578926
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578927 = query.getOrDefault("key")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "key", valid_578927
  var valid_578928 = query.getOrDefault("prettyPrint")
  valid_578928 = validateParameter(valid_578928, JBool, required = false,
                                 default = newJBool(true))
  if valid_578928 != nil:
    section.add "prettyPrint", valid_578928
  var valid_578929 = query.getOrDefault("oauth_token")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "oauth_token", valid_578929
  var valid_578930 = query.getOrDefault("alt")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = newJString("json"))
  if valid_578930 != nil:
    section.add "alt", valid_578930
  var valid_578931 = query.getOrDefault("userIp")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "userIp", valid_578931
  var valid_578932 = query.getOrDefault("quotaUser")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "quotaUser", valid_578932
  var valid_578933 = query.getOrDefault("fields")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "fields", valid_578933
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

proc call*(call_578935: Call_DeploymentmanagerCompositeTypesInsert_578923;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a composite type.
  ## 
  let valid = call_578935.validator(path, query, header, formData, body)
  let scheme = call_578935.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578935.url(scheme.get, call_578935.host, call_578935.base,
                         call_578935.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578935, url, valid)

proc call*(call_578936: Call_DeploymentmanagerCompositeTypesInsert_578923;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## deploymentmanagerCompositeTypesInsert
  ## Creates a composite type.
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
  ##          : The project ID for this request.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578937 = newJObject()
  var query_578938 = newJObject()
  var body_578939 = newJObject()
  add(query_578938, "key", newJString(key))
  add(query_578938, "prettyPrint", newJBool(prettyPrint))
  add(query_578938, "oauth_token", newJString(oauthToken))
  add(query_578938, "alt", newJString(alt))
  add(query_578938, "userIp", newJString(userIp))
  add(query_578938, "quotaUser", newJString(quotaUser))
  add(path_578937, "project", newJString(project))
  if body != nil:
    body_578939 = body
  add(query_578938, "fields", newJString(fields))
  result = call_578936.call(path_578937, query_578938, nil, nil, body_578939)

var deploymentmanagerCompositeTypesInsert* = Call_DeploymentmanagerCompositeTypesInsert_578923(
    name: "deploymentmanagerCompositeTypesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/global/compositeTypes",
    validator: validate_DeploymentmanagerCompositeTypesInsert_578924,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerCompositeTypesInsert_578925, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerCompositeTypesList_578634 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerCompositeTypesList_578636(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerCompositeTypesList_578635(path: JsonNode;
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
  var valid_578762 = path.getOrDefault("project")
  valid_578762 = validateParameter(valid_578762, JString, required = true,
                                 default = nil)
  if valid_578762 != nil:
    section.add "project", valid_578762
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
  ##   orderBy: JString
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   filter: JString
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  section = newJObject()
  var valid_578763 = query.getOrDefault("key")
  valid_578763 = validateParameter(valid_578763, JString, required = false,
                                 default = nil)
  if valid_578763 != nil:
    section.add "key", valid_578763
  var valid_578777 = query.getOrDefault("prettyPrint")
  valid_578777 = validateParameter(valid_578777, JBool, required = false,
                                 default = newJBool(true))
  if valid_578777 != nil:
    section.add "prettyPrint", valid_578777
  var valid_578778 = query.getOrDefault("oauth_token")
  valid_578778 = validateParameter(valid_578778, JString, required = false,
                                 default = nil)
  if valid_578778 != nil:
    section.add "oauth_token", valid_578778
  var valid_578779 = query.getOrDefault("alt")
  valid_578779 = validateParameter(valid_578779, JString, required = false,
                                 default = newJString("json"))
  if valid_578779 != nil:
    section.add "alt", valid_578779
  var valid_578780 = query.getOrDefault("userIp")
  valid_578780 = validateParameter(valid_578780, JString, required = false,
                                 default = nil)
  if valid_578780 != nil:
    section.add "userIp", valid_578780
  var valid_578781 = query.getOrDefault("quotaUser")
  valid_578781 = validateParameter(valid_578781, JString, required = false,
                                 default = nil)
  if valid_578781 != nil:
    section.add "quotaUser", valid_578781
  var valid_578782 = query.getOrDefault("orderBy")
  valid_578782 = validateParameter(valid_578782, JString, required = false,
                                 default = nil)
  if valid_578782 != nil:
    section.add "orderBy", valid_578782
  var valid_578783 = query.getOrDefault("filter")
  valid_578783 = validateParameter(valid_578783, JString, required = false,
                                 default = nil)
  if valid_578783 != nil:
    section.add "filter", valid_578783
  var valid_578784 = query.getOrDefault("pageToken")
  valid_578784 = validateParameter(valid_578784, JString, required = false,
                                 default = nil)
  if valid_578784 != nil:
    section.add "pageToken", valid_578784
  var valid_578785 = query.getOrDefault("fields")
  valid_578785 = validateParameter(valid_578785, JString, required = false,
                                 default = nil)
  if valid_578785 != nil:
    section.add "fields", valid_578785
  var valid_578787 = query.getOrDefault("maxResults")
  valid_578787 = validateParameter(valid_578787, JInt, required = false,
                                 default = newJInt(500))
  if valid_578787 != nil:
    section.add "maxResults", valid_578787
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578810: Call_DeploymentmanagerCompositeTypesList_578634;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all composite types for Deployment Manager.
  ## 
  let valid = call_578810.validator(path, query, header, formData, body)
  let scheme = call_578810.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578810.url(scheme.get, call_578810.host, call_578810.base,
                         call_578810.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578810, url, valid)

proc call*(call_578881: Call_DeploymentmanagerCompositeTypesList_578634;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; orderBy: string = ""; filter: string = "";
          pageToken: string = ""; fields: string = ""; maxResults: int = 500): Recallable =
  ## deploymentmanagerCompositeTypesList
  ## Lists all composite types for Deployment Manager.
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
  ##   orderBy: string
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   filter: string
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  ##   pageToken: string
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  var path_578882 = newJObject()
  var query_578884 = newJObject()
  add(query_578884, "key", newJString(key))
  add(query_578884, "prettyPrint", newJBool(prettyPrint))
  add(query_578884, "oauth_token", newJString(oauthToken))
  add(query_578884, "alt", newJString(alt))
  add(query_578884, "userIp", newJString(userIp))
  add(query_578884, "quotaUser", newJString(quotaUser))
  add(query_578884, "orderBy", newJString(orderBy))
  add(query_578884, "filter", newJString(filter))
  add(query_578884, "pageToken", newJString(pageToken))
  add(path_578882, "project", newJString(project))
  add(query_578884, "fields", newJString(fields))
  add(query_578884, "maxResults", newJInt(maxResults))
  result = call_578881.call(path_578882, query_578884, nil, nil, nil)

var deploymentmanagerCompositeTypesList* = Call_DeploymentmanagerCompositeTypesList_578634(
    name: "deploymentmanagerCompositeTypesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/compositeTypes",
    validator: validate_DeploymentmanagerCompositeTypesList_578635,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerCompositeTypesList_578636, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerCompositeTypesUpdate_578956 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerCompositeTypesUpdate_578958(protocol: Scheme;
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

proc validate_DeploymentmanagerCompositeTypesUpdate_578957(path: JsonNode;
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
  var valid_578959 = path.getOrDefault("project")
  valid_578959 = validateParameter(valid_578959, JString, required = true,
                                 default = nil)
  if valid_578959 != nil:
    section.add "project", valid_578959
  var valid_578960 = path.getOrDefault("compositeType")
  valid_578960 = validateParameter(valid_578960, JString, required = true,
                                 default = nil)
  if valid_578960 != nil:
    section.add "compositeType", valid_578960
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578961 = query.getOrDefault("key")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "key", valid_578961
  var valid_578962 = query.getOrDefault("prettyPrint")
  valid_578962 = validateParameter(valid_578962, JBool, required = false,
                                 default = newJBool(true))
  if valid_578962 != nil:
    section.add "prettyPrint", valid_578962
  var valid_578963 = query.getOrDefault("oauth_token")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "oauth_token", valid_578963
  var valid_578964 = query.getOrDefault("alt")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = newJString("json"))
  if valid_578964 != nil:
    section.add "alt", valid_578964
  var valid_578965 = query.getOrDefault("userIp")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "userIp", valid_578965
  var valid_578966 = query.getOrDefault("quotaUser")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "quotaUser", valid_578966
  var valid_578967 = query.getOrDefault("fields")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "fields", valid_578967
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

proc call*(call_578969: Call_DeploymentmanagerCompositeTypesUpdate_578956;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a composite type.
  ## 
  let valid = call_578969.validator(path, query, header, formData, body)
  let scheme = call_578969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578969.url(scheme.get, call_578969.host, call_578969.base,
                         call_578969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578969, url, valid)

proc call*(call_578970: Call_DeploymentmanagerCompositeTypesUpdate_578956;
          project: string; compositeType: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## deploymentmanagerCompositeTypesUpdate
  ## Updates a composite type.
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
  ##          : The project ID for this request.
  ##   compositeType: string (required)
  ##                : The name of the composite type for this request.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578971 = newJObject()
  var query_578972 = newJObject()
  var body_578973 = newJObject()
  add(query_578972, "key", newJString(key))
  add(query_578972, "prettyPrint", newJBool(prettyPrint))
  add(query_578972, "oauth_token", newJString(oauthToken))
  add(query_578972, "alt", newJString(alt))
  add(query_578972, "userIp", newJString(userIp))
  add(query_578972, "quotaUser", newJString(quotaUser))
  add(path_578971, "project", newJString(project))
  add(path_578971, "compositeType", newJString(compositeType))
  if body != nil:
    body_578973 = body
  add(query_578972, "fields", newJString(fields))
  result = call_578970.call(path_578971, query_578972, nil, nil, body_578973)

var deploymentmanagerCompositeTypesUpdate* = Call_DeploymentmanagerCompositeTypesUpdate_578956(
    name: "deploymentmanagerCompositeTypesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{project}/global/compositeTypes/{compositeType}",
    validator: validate_DeploymentmanagerCompositeTypesUpdate_578957,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerCompositeTypesUpdate_578958, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerCompositeTypesGet_578940 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerCompositeTypesGet_578942(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerCompositeTypesGet_578941(path: JsonNode;
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
  var valid_578943 = path.getOrDefault("project")
  valid_578943 = validateParameter(valid_578943, JString, required = true,
                                 default = nil)
  if valid_578943 != nil:
    section.add "project", valid_578943
  var valid_578944 = path.getOrDefault("compositeType")
  valid_578944 = validateParameter(valid_578944, JString, required = true,
                                 default = nil)
  if valid_578944 != nil:
    section.add "compositeType", valid_578944
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578945 = query.getOrDefault("key")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "key", valid_578945
  var valid_578946 = query.getOrDefault("prettyPrint")
  valid_578946 = validateParameter(valid_578946, JBool, required = false,
                                 default = newJBool(true))
  if valid_578946 != nil:
    section.add "prettyPrint", valid_578946
  var valid_578947 = query.getOrDefault("oauth_token")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "oauth_token", valid_578947
  var valid_578948 = query.getOrDefault("alt")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = newJString("json"))
  if valid_578948 != nil:
    section.add "alt", valid_578948
  var valid_578949 = query.getOrDefault("userIp")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "userIp", valid_578949
  var valid_578950 = query.getOrDefault("quotaUser")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "quotaUser", valid_578950
  var valid_578951 = query.getOrDefault("fields")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "fields", valid_578951
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578952: Call_DeploymentmanagerCompositeTypesGet_578940;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about a specific composite type.
  ## 
  let valid = call_578952.validator(path, query, header, formData, body)
  let scheme = call_578952.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578952.url(scheme.get, call_578952.host, call_578952.base,
                         call_578952.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578952, url, valid)

proc call*(call_578953: Call_DeploymentmanagerCompositeTypesGet_578940;
          project: string; compositeType: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## deploymentmanagerCompositeTypesGet
  ## Gets information about a specific composite type.
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
  ##          : The project ID for this request.
  ##   compositeType: string (required)
  ##                : The name of the composite type for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578954 = newJObject()
  var query_578955 = newJObject()
  add(query_578955, "key", newJString(key))
  add(query_578955, "prettyPrint", newJBool(prettyPrint))
  add(query_578955, "oauth_token", newJString(oauthToken))
  add(query_578955, "alt", newJString(alt))
  add(query_578955, "userIp", newJString(userIp))
  add(query_578955, "quotaUser", newJString(quotaUser))
  add(path_578954, "project", newJString(project))
  add(path_578954, "compositeType", newJString(compositeType))
  add(query_578955, "fields", newJString(fields))
  result = call_578953.call(path_578954, query_578955, nil, nil, nil)

var deploymentmanagerCompositeTypesGet* = Call_DeploymentmanagerCompositeTypesGet_578940(
    name: "deploymentmanagerCompositeTypesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/compositeTypes/{compositeType}",
    validator: validate_DeploymentmanagerCompositeTypesGet_578941,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerCompositeTypesGet_578942, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerCompositeTypesPatch_578990 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerCompositeTypesPatch_578992(protocol: Scheme;
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

proc validate_DeploymentmanagerCompositeTypesPatch_578991(path: JsonNode;
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
  var valid_578993 = path.getOrDefault("project")
  valid_578993 = validateParameter(valid_578993, JString, required = true,
                                 default = nil)
  if valid_578993 != nil:
    section.add "project", valid_578993
  var valid_578994 = path.getOrDefault("compositeType")
  valid_578994 = validateParameter(valid_578994, JString, required = true,
                                 default = nil)
  if valid_578994 != nil:
    section.add "compositeType", valid_578994
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578995 = query.getOrDefault("key")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "key", valid_578995
  var valid_578996 = query.getOrDefault("prettyPrint")
  valid_578996 = validateParameter(valid_578996, JBool, required = false,
                                 default = newJBool(true))
  if valid_578996 != nil:
    section.add "prettyPrint", valid_578996
  var valid_578997 = query.getOrDefault("oauth_token")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "oauth_token", valid_578997
  var valid_578998 = query.getOrDefault("alt")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = newJString("json"))
  if valid_578998 != nil:
    section.add "alt", valid_578998
  var valid_578999 = query.getOrDefault("userIp")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "userIp", valid_578999
  var valid_579000 = query.getOrDefault("quotaUser")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "quotaUser", valid_579000
  var valid_579001 = query.getOrDefault("fields")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "fields", valid_579001
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

proc call*(call_579003: Call_DeploymentmanagerCompositeTypesPatch_578990;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a composite type. This method supports patch semantics.
  ## 
  let valid = call_579003.validator(path, query, header, formData, body)
  let scheme = call_579003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579003.url(scheme.get, call_579003.host, call_579003.base,
                         call_579003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579003, url, valid)

proc call*(call_579004: Call_DeploymentmanagerCompositeTypesPatch_578990;
          project: string; compositeType: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## deploymentmanagerCompositeTypesPatch
  ## Updates a composite type. This method supports patch semantics.
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
  ##          : The project ID for this request.
  ##   compositeType: string (required)
  ##                : The name of the composite type for this request.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579005 = newJObject()
  var query_579006 = newJObject()
  var body_579007 = newJObject()
  add(query_579006, "key", newJString(key))
  add(query_579006, "prettyPrint", newJBool(prettyPrint))
  add(query_579006, "oauth_token", newJString(oauthToken))
  add(query_579006, "alt", newJString(alt))
  add(query_579006, "userIp", newJString(userIp))
  add(query_579006, "quotaUser", newJString(quotaUser))
  add(path_579005, "project", newJString(project))
  add(path_579005, "compositeType", newJString(compositeType))
  if body != nil:
    body_579007 = body
  add(query_579006, "fields", newJString(fields))
  result = call_579004.call(path_579005, query_579006, nil, nil, body_579007)

var deploymentmanagerCompositeTypesPatch* = Call_DeploymentmanagerCompositeTypesPatch_578990(
    name: "deploymentmanagerCompositeTypesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{project}/global/compositeTypes/{compositeType}",
    validator: validate_DeploymentmanagerCompositeTypesPatch_578991,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerCompositeTypesPatch_578992, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerCompositeTypesDelete_578974 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerCompositeTypesDelete_578976(protocol: Scheme;
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

proc validate_DeploymentmanagerCompositeTypesDelete_578975(path: JsonNode;
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
  var valid_578977 = path.getOrDefault("project")
  valid_578977 = validateParameter(valid_578977, JString, required = true,
                                 default = nil)
  if valid_578977 != nil:
    section.add "project", valid_578977
  var valid_578978 = path.getOrDefault("compositeType")
  valid_578978 = validateParameter(valid_578978, JString, required = true,
                                 default = nil)
  if valid_578978 != nil:
    section.add "compositeType", valid_578978
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578979 = query.getOrDefault("key")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "key", valid_578979
  var valid_578980 = query.getOrDefault("prettyPrint")
  valid_578980 = validateParameter(valid_578980, JBool, required = false,
                                 default = newJBool(true))
  if valid_578980 != nil:
    section.add "prettyPrint", valid_578980
  var valid_578981 = query.getOrDefault("oauth_token")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "oauth_token", valid_578981
  var valid_578982 = query.getOrDefault("alt")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = newJString("json"))
  if valid_578982 != nil:
    section.add "alt", valid_578982
  var valid_578983 = query.getOrDefault("userIp")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "userIp", valid_578983
  var valid_578984 = query.getOrDefault("quotaUser")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "quotaUser", valid_578984
  var valid_578985 = query.getOrDefault("fields")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "fields", valid_578985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578986: Call_DeploymentmanagerCompositeTypesDelete_578974;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a composite type.
  ## 
  let valid = call_578986.validator(path, query, header, formData, body)
  let scheme = call_578986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578986.url(scheme.get, call_578986.host, call_578986.base,
                         call_578986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578986, url, valid)

proc call*(call_578987: Call_DeploymentmanagerCompositeTypesDelete_578974;
          project: string; compositeType: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## deploymentmanagerCompositeTypesDelete
  ## Deletes a composite type.
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
  ##          : The project ID for this request.
  ##   compositeType: string (required)
  ##                : The name of the type for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578988 = newJObject()
  var query_578989 = newJObject()
  add(query_578989, "key", newJString(key))
  add(query_578989, "prettyPrint", newJBool(prettyPrint))
  add(query_578989, "oauth_token", newJString(oauthToken))
  add(query_578989, "alt", newJString(alt))
  add(query_578989, "userIp", newJString(userIp))
  add(query_578989, "quotaUser", newJString(quotaUser))
  add(path_578988, "project", newJString(project))
  add(path_578988, "compositeType", newJString(compositeType))
  add(query_578989, "fields", newJString(fields))
  result = call_578987.call(path_578988, query_578989, nil, nil, nil)

var deploymentmanagerCompositeTypesDelete* = Call_DeploymentmanagerCompositeTypesDelete_578974(
    name: "deploymentmanagerCompositeTypesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{project}/global/compositeTypes/{compositeType}",
    validator: validate_DeploymentmanagerCompositeTypesDelete_578975,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerCompositeTypesDelete_578976, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsInsert_579027 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerDeploymentsInsert_579029(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerDeploymentsInsert_579028(path: JsonNode;
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
  var valid_579030 = path.getOrDefault("project")
  valid_579030 = validateParameter(valid_579030, JString, required = true,
                                 default = nil)
  if valid_579030 != nil:
    section.add "project", valid_579030
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
  ##   createPolicy: JString
  ##               : Sets the policy to use for creating new resources.
  ##   preview: JBool
  ##          : If set to true, creates a deployment and creates "shell" resources but does not actually instantiate these resources. This allows you to preview what your deployment looks like. After previewing a deployment, you can deploy your resources by making a request with the update() method or you can use the cancelPreview() method to cancel the preview altogether. Note that the deployment will still exist after you cancel the preview and you must separately delete this deployment if you want to remove it.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579031 = query.getOrDefault("key")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "key", valid_579031
  var valid_579032 = query.getOrDefault("prettyPrint")
  valid_579032 = validateParameter(valid_579032, JBool, required = false,
                                 default = newJBool(true))
  if valid_579032 != nil:
    section.add "prettyPrint", valid_579032
  var valid_579033 = query.getOrDefault("oauth_token")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "oauth_token", valid_579033
  var valid_579034 = query.getOrDefault("alt")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = newJString("json"))
  if valid_579034 != nil:
    section.add "alt", valid_579034
  var valid_579035 = query.getOrDefault("userIp")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "userIp", valid_579035
  var valid_579036 = query.getOrDefault("quotaUser")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "quotaUser", valid_579036
  var valid_579037 = query.getOrDefault("createPolicy")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = newJString("CREATE_OR_ACQUIRE"))
  if valid_579037 != nil:
    section.add "createPolicy", valid_579037
  var valid_579038 = query.getOrDefault("preview")
  valid_579038 = validateParameter(valid_579038, JBool, required = false, default = nil)
  if valid_579038 != nil:
    section.add "preview", valid_579038
  var valid_579039 = query.getOrDefault("fields")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "fields", valid_579039
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

proc call*(call_579041: Call_DeploymentmanagerDeploymentsInsert_579027;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a deployment and all of the resources described by the deployment manifest.
  ## 
  let valid = call_579041.validator(path, query, header, formData, body)
  let scheme = call_579041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579041.url(scheme.get, call_579041.host, call_579041.base,
                         call_579041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579041, url, valid)

proc call*(call_579042: Call_DeploymentmanagerDeploymentsInsert_579027;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; createPolicy: string = "CREATE_OR_ACQUIRE";
          body: JsonNode = nil; preview: bool = false; fields: string = ""): Recallable =
  ## deploymentmanagerDeploymentsInsert
  ## Creates a deployment and all of the resources described by the deployment manifest.
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
  ##   createPolicy: string
  ##               : Sets the policy to use for creating new resources.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   body: JObject
  ##   preview: bool
  ##          : If set to true, creates a deployment and creates "shell" resources but does not actually instantiate these resources. This allows you to preview what your deployment looks like. After previewing a deployment, you can deploy your resources by making a request with the update() method or you can use the cancelPreview() method to cancel the preview altogether. Note that the deployment will still exist after you cancel the preview and you must separately delete this deployment if you want to remove it.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579043 = newJObject()
  var query_579044 = newJObject()
  var body_579045 = newJObject()
  add(query_579044, "key", newJString(key))
  add(query_579044, "prettyPrint", newJBool(prettyPrint))
  add(query_579044, "oauth_token", newJString(oauthToken))
  add(query_579044, "alt", newJString(alt))
  add(query_579044, "userIp", newJString(userIp))
  add(query_579044, "quotaUser", newJString(quotaUser))
  add(query_579044, "createPolicy", newJString(createPolicy))
  add(path_579043, "project", newJString(project))
  if body != nil:
    body_579045 = body
  add(query_579044, "preview", newJBool(preview))
  add(query_579044, "fields", newJString(fields))
  result = call_579042.call(path_579043, query_579044, nil, nil, body_579045)

var deploymentmanagerDeploymentsInsert* = Call_DeploymentmanagerDeploymentsInsert_579027(
    name: "deploymentmanagerDeploymentsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/global/deployments",
    validator: validate_DeploymentmanagerDeploymentsInsert_579028,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerDeploymentsInsert_579029, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsList_579008 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerDeploymentsList_579010(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerDeploymentsList_579009(path: JsonNode;
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
  var valid_579011 = path.getOrDefault("project")
  valid_579011 = validateParameter(valid_579011, JString, required = true,
                                 default = nil)
  if valid_579011 != nil:
    section.add "project", valid_579011
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
  ##   orderBy: JString
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   filter: JString
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  section = newJObject()
  var valid_579012 = query.getOrDefault("key")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "key", valid_579012
  var valid_579013 = query.getOrDefault("prettyPrint")
  valid_579013 = validateParameter(valid_579013, JBool, required = false,
                                 default = newJBool(true))
  if valid_579013 != nil:
    section.add "prettyPrint", valid_579013
  var valid_579014 = query.getOrDefault("oauth_token")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "oauth_token", valid_579014
  var valid_579015 = query.getOrDefault("alt")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = newJString("json"))
  if valid_579015 != nil:
    section.add "alt", valid_579015
  var valid_579016 = query.getOrDefault("userIp")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "userIp", valid_579016
  var valid_579017 = query.getOrDefault("quotaUser")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "quotaUser", valid_579017
  var valid_579018 = query.getOrDefault("orderBy")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "orderBy", valid_579018
  var valid_579019 = query.getOrDefault("filter")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "filter", valid_579019
  var valid_579020 = query.getOrDefault("pageToken")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "pageToken", valid_579020
  var valid_579021 = query.getOrDefault("fields")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "fields", valid_579021
  var valid_579022 = query.getOrDefault("maxResults")
  valid_579022 = validateParameter(valid_579022, JInt, required = false,
                                 default = newJInt(500))
  if valid_579022 != nil:
    section.add "maxResults", valid_579022
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579023: Call_DeploymentmanagerDeploymentsList_579008;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all deployments for a given project.
  ## 
  let valid = call_579023.validator(path, query, header, formData, body)
  let scheme = call_579023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579023.url(scheme.get, call_579023.host, call_579023.base,
                         call_579023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579023, url, valid)

proc call*(call_579024: Call_DeploymentmanagerDeploymentsList_579008;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; orderBy: string = ""; filter: string = "";
          pageToken: string = ""; fields: string = ""; maxResults: int = 500): Recallable =
  ## deploymentmanagerDeploymentsList
  ## Lists all deployments for a given project.
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
  ##   orderBy: string
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   filter: string
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  ##   pageToken: string
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  var path_579025 = newJObject()
  var query_579026 = newJObject()
  add(query_579026, "key", newJString(key))
  add(query_579026, "prettyPrint", newJBool(prettyPrint))
  add(query_579026, "oauth_token", newJString(oauthToken))
  add(query_579026, "alt", newJString(alt))
  add(query_579026, "userIp", newJString(userIp))
  add(query_579026, "quotaUser", newJString(quotaUser))
  add(query_579026, "orderBy", newJString(orderBy))
  add(query_579026, "filter", newJString(filter))
  add(query_579026, "pageToken", newJString(pageToken))
  add(path_579025, "project", newJString(project))
  add(query_579026, "fields", newJString(fields))
  add(query_579026, "maxResults", newJInt(maxResults))
  result = call_579024.call(path_579025, query_579026, nil, nil, nil)

var deploymentmanagerDeploymentsList* = Call_DeploymentmanagerDeploymentsList_579008(
    name: "deploymentmanagerDeploymentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/deployments",
    validator: validate_DeploymentmanagerDeploymentsList_579009,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerDeploymentsList_579010, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsUpdate_579062 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerDeploymentsUpdate_579064(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerDeploymentsUpdate_579063(path: JsonNode;
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
  var valid_579065 = path.getOrDefault("deployment")
  valid_579065 = validateParameter(valid_579065, JString, required = true,
                                 default = nil)
  if valid_579065 != nil:
    section.add "deployment", valid_579065
  var valid_579066 = path.getOrDefault("project")
  valid_579066 = validateParameter(valid_579066, JString, required = true,
                                 default = nil)
  if valid_579066 != nil:
    section.add "project", valid_579066
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
  ##   createPolicy: JString
  ##               : Sets the policy to use for creating new resources.
  ##   deletePolicy: JString
  ##               : Sets the policy to use for deleting resources.
  ##   preview: JBool
  ##          : If set to true, updates the deployment and creates and updates the "shell" resources but does not actually alter or instantiate these resources. This allows you to preview what your deployment will look like. You can use this intent to preview how an update would affect your deployment. You must provide a target.config with a configuration if this is set to true. After previewing a deployment, you can deploy your resources by making a request with the update() or you can cancelPreview() to remove the preview altogether. Note that the deployment will still exist after you cancel the preview and you must separately delete this deployment if you want to remove it.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579067 = query.getOrDefault("key")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "key", valid_579067
  var valid_579068 = query.getOrDefault("prettyPrint")
  valid_579068 = validateParameter(valid_579068, JBool, required = false,
                                 default = newJBool(true))
  if valid_579068 != nil:
    section.add "prettyPrint", valid_579068
  var valid_579069 = query.getOrDefault("oauth_token")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "oauth_token", valid_579069
  var valid_579070 = query.getOrDefault("alt")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = newJString("json"))
  if valid_579070 != nil:
    section.add "alt", valid_579070
  var valid_579071 = query.getOrDefault("userIp")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "userIp", valid_579071
  var valid_579072 = query.getOrDefault("quotaUser")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "quotaUser", valid_579072
  var valid_579073 = query.getOrDefault("createPolicy")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = newJString("CREATE_OR_ACQUIRE"))
  if valid_579073 != nil:
    section.add "createPolicy", valid_579073
  var valid_579074 = query.getOrDefault("deletePolicy")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = newJString("DELETE"))
  if valid_579074 != nil:
    section.add "deletePolicy", valid_579074
  var valid_579075 = query.getOrDefault("preview")
  valid_579075 = validateParameter(valid_579075, JBool, required = false,
                                 default = newJBool(false))
  if valid_579075 != nil:
    section.add "preview", valid_579075
  var valid_579076 = query.getOrDefault("fields")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "fields", valid_579076
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

proc call*(call_579078: Call_DeploymentmanagerDeploymentsUpdate_579062;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a deployment and all of the resources described by the deployment manifest.
  ## 
  let valid = call_579078.validator(path, query, header, formData, body)
  let scheme = call_579078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579078.url(scheme.get, call_579078.host, call_579078.base,
                         call_579078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579078, url, valid)

proc call*(call_579079: Call_DeploymentmanagerDeploymentsUpdate_579062;
          deployment: string; project: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = "";
          createPolicy: string = "CREATE_OR_ACQUIRE";
          deletePolicy: string = "DELETE"; body: JsonNode = nil; preview: bool = false;
          fields: string = ""): Recallable =
  ## deploymentmanagerDeploymentsUpdate
  ## Updates a deployment and all of the resources described by the deployment manifest.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   createPolicy: string
  ##               : Sets the policy to use for creating new resources.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   deletePolicy: string
  ##               : Sets the policy to use for deleting resources.
  ##   body: JObject
  ##   preview: bool
  ##          : If set to true, updates the deployment and creates and updates the "shell" resources but does not actually alter or instantiate these resources. This allows you to preview what your deployment will look like. You can use this intent to preview how an update would affect your deployment. You must provide a target.config with a configuration if this is set to true. After previewing a deployment, you can deploy your resources by making a request with the update() or you can cancelPreview() to remove the preview altogether. Note that the deployment will still exist after you cancel the preview and you must separately delete this deployment if you want to remove it.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579080 = newJObject()
  var query_579081 = newJObject()
  var body_579082 = newJObject()
  add(query_579081, "key", newJString(key))
  add(query_579081, "prettyPrint", newJBool(prettyPrint))
  add(query_579081, "oauth_token", newJString(oauthToken))
  add(path_579080, "deployment", newJString(deployment))
  add(query_579081, "alt", newJString(alt))
  add(query_579081, "userIp", newJString(userIp))
  add(query_579081, "quotaUser", newJString(quotaUser))
  add(query_579081, "createPolicy", newJString(createPolicy))
  add(path_579080, "project", newJString(project))
  add(query_579081, "deletePolicy", newJString(deletePolicy))
  if body != nil:
    body_579082 = body
  add(query_579081, "preview", newJBool(preview))
  add(query_579081, "fields", newJString(fields))
  result = call_579079.call(path_579080, query_579081, nil, nil, body_579082)

var deploymentmanagerDeploymentsUpdate* = Call_DeploymentmanagerDeploymentsUpdate_579062(
    name: "deploymentmanagerDeploymentsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}",
    validator: validate_DeploymentmanagerDeploymentsUpdate_579063,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerDeploymentsUpdate_579064, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsGet_579046 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerDeploymentsGet_579048(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerDeploymentsGet_579047(path: JsonNode;
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
  var valid_579049 = path.getOrDefault("deployment")
  valid_579049 = validateParameter(valid_579049, JString, required = true,
                                 default = nil)
  if valid_579049 != nil:
    section.add "deployment", valid_579049
  var valid_579050 = path.getOrDefault("project")
  valid_579050 = validateParameter(valid_579050, JString, required = true,
                                 default = nil)
  if valid_579050 != nil:
    section.add "project", valid_579050
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579051 = query.getOrDefault("key")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "key", valid_579051
  var valid_579052 = query.getOrDefault("prettyPrint")
  valid_579052 = validateParameter(valid_579052, JBool, required = false,
                                 default = newJBool(true))
  if valid_579052 != nil:
    section.add "prettyPrint", valid_579052
  var valid_579053 = query.getOrDefault("oauth_token")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "oauth_token", valid_579053
  var valid_579054 = query.getOrDefault("alt")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = newJString("json"))
  if valid_579054 != nil:
    section.add "alt", valid_579054
  var valid_579055 = query.getOrDefault("userIp")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "userIp", valid_579055
  var valid_579056 = query.getOrDefault("quotaUser")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "quotaUser", valid_579056
  var valid_579057 = query.getOrDefault("fields")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "fields", valid_579057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579058: Call_DeploymentmanagerDeploymentsGet_579046;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about a specific deployment.
  ## 
  let valid = call_579058.validator(path, query, header, formData, body)
  let scheme = call_579058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579058.url(scheme.get, call_579058.host, call_579058.base,
                         call_579058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579058, url, valid)

proc call*(call_579059: Call_DeploymentmanagerDeploymentsGet_579046;
          deployment: string; project: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## deploymentmanagerDeploymentsGet
  ## Gets information about a specific deployment.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579060 = newJObject()
  var query_579061 = newJObject()
  add(query_579061, "key", newJString(key))
  add(query_579061, "prettyPrint", newJBool(prettyPrint))
  add(query_579061, "oauth_token", newJString(oauthToken))
  add(path_579060, "deployment", newJString(deployment))
  add(query_579061, "alt", newJString(alt))
  add(query_579061, "userIp", newJString(userIp))
  add(query_579061, "quotaUser", newJString(quotaUser))
  add(path_579060, "project", newJString(project))
  add(query_579061, "fields", newJString(fields))
  result = call_579059.call(path_579060, query_579061, nil, nil, nil)

var deploymentmanagerDeploymentsGet* = Call_DeploymentmanagerDeploymentsGet_579046(
    name: "deploymentmanagerDeploymentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}",
    validator: validate_DeploymentmanagerDeploymentsGet_579047,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerDeploymentsGet_579048, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsPatch_579100 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerDeploymentsPatch_579102(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerDeploymentsPatch_579101(path: JsonNode;
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
  var valid_579103 = path.getOrDefault("deployment")
  valid_579103 = validateParameter(valid_579103, JString, required = true,
                                 default = nil)
  if valid_579103 != nil:
    section.add "deployment", valid_579103
  var valid_579104 = path.getOrDefault("project")
  valid_579104 = validateParameter(valid_579104, JString, required = true,
                                 default = nil)
  if valid_579104 != nil:
    section.add "project", valid_579104
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
  ##   createPolicy: JString
  ##               : Sets the policy to use for creating new resources.
  ##   deletePolicy: JString
  ##               : Sets the policy to use for deleting resources.
  ##   preview: JBool
  ##          : If set to true, updates the deployment and creates and updates the "shell" resources but does not actually alter or instantiate these resources. This allows you to preview what your deployment will look like. You can use this intent to preview how an update would affect your deployment. You must provide a target.config with a configuration if this is set to true. After previewing a deployment, you can deploy your resources by making a request with the update() or you can cancelPreview() to remove the preview altogether. Note that the deployment will still exist after you cancel the preview and you must separately delete this deployment if you want to remove it.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579105 = query.getOrDefault("key")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "key", valid_579105
  var valid_579106 = query.getOrDefault("prettyPrint")
  valid_579106 = validateParameter(valid_579106, JBool, required = false,
                                 default = newJBool(true))
  if valid_579106 != nil:
    section.add "prettyPrint", valid_579106
  var valid_579107 = query.getOrDefault("oauth_token")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "oauth_token", valid_579107
  var valid_579108 = query.getOrDefault("alt")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = newJString("json"))
  if valid_579108 != nil:
    section.add "alt", valid_579108
  var valid_579109 = query.getOrDefault("userIp")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "userIp", valid_579109
  var valid_579110 = query.getOrDefault("quotaUser")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "quotaUser", valid_579110
  var valid_579111 = query.getOrDefault("createPolicy")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = newJString("CREATE_OR_ACQUIRE"))
  if valid_579111 != nil:
    section.add "createPolicy", valid_579111
  var valid_579112 = query.getOrDefault("deletePolicy")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = newJString("DELETE"))
  if valid_579112 != nil:
    section.add "deletePolicy", valid_579112
  var valid_579113 = query.getOrDefault("preview")
  valid_579113 = validateParameter(valid_579113, JBool, required = false,
                                 default = newJBool(false))
  if valid_579113 != nil:
    section.add "preview", valid_579113
  var valid_579114 = query.getOrDefault("fields")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = nil)
  if valid_579114 != nil:
    section.add "fields", valid_579114
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

proc call*(call_579116: Call_DeploymentmanagerDeploymentsPatch_579100;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a deployment and all of the resources described by the deployment manifest. This method supports patch semantics.
  ## 
  let valid = call_579116.validator(path, query, header, formData, body)
  let scheme = call_579116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579116.url(scheme.get, call_579116.host, call_579116.base,
                         call_579116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579116, url, valid)

proc call*(call_579117: Call_DeploymentmanagerDeploymentsPatch_579100;
          deployment: string; project: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = "";
          createPolicy: string = "CREATE_OR_ACQUIRE";
          deletePolicy: string = "DELETE"; body: JsonNode = nil; preview: bool = false;
          fields: string = ""): Recallable =
  ## deploymentmanagerDeploymentsPatch
  ## Updates a deployment and all of the resources described by the deployment manifest. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   createPolicy: string
  ##               : Sets the policy to use for creating new resources.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   deletePolicy: string
  ##               : Sets the policy to use for deleting resources.
  ##   body: JObject
  ##   preview: bool
  ##          : If set to true, updates the deployment and creates and updates the "shell" resources but does not actually alter or instantiate these resources. This allows you to preview what your deployment will look like. You can use this intent to preview how an update would affect your deployment. You must provide a target.config with a configuration if this is set to true. After previewing a deployment, you can deploy your resources by making a request with the update() or you can cancelPreview() to remove the preview altogether. Note that the deployment will still exist after you cancel the preview and you must separately delete this deployment if you want to remove it.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579118 = newJObject()
  var query_579119 = newJObject()
  var body_579120 = newJObject()
  add(query_579119, "key", newJString(key))
  add(query_579119, "prettyPrint", newJBool(prettyPrint))
  add(query_579119, "oauth_token", newJString(oauthToken))
  add(path_579118, "deployment", newJString(deployment))
  add(query_579119, "alt", newJString(alt))
  add(query_579119, "userIp", newJString(userIp))
  add(query_579119, "quotaUser", newJString(quotaUser))
  add(query_579119, "createPolicy", newJString(createPolicy))
  add(path_579118, "project", newJString(project))
  add(query_579119, "deletePolicy", newJString(deletePolicy))
  if body != nil:
    body_579120 = body
  add(query_579119, "preview", newJBool(preview))
  add(query_579119, "fields", newJString(fields))
  result = call_579117.call(path_579118, query_579119, nil, nil, body_579120)

var deploymentmanagerDeploymentsPatch* = Call_DeploymentmanagerDeploymentsPatch_579100(
    name: "deploymentmanagerDeploymentsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}",
    validator: validate_DeploymentmanagerDeploymentsPatch_579101,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerDeploymentsPatch_579102, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsDelete_579083 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerDeploymentsDelete_579085(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerDeploymentsDelete_579084(path: JsonNode;
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
  var valid_579086 = path.getOrDefault("deployment")
  valid_579086 = validateParameter(valid_579086, JString, required = true,
                                 default = nil)
  if valid_579086 != nil:
    section.add "deployment", valid_579086
  var valid_579087 = path.getOrDefault("project")
  valid_579087 = validateParameter(valid_579087, JString, required = true,
                                 default = nil)
  if valid_579087 != nil:
    section.add "project", valid_579087
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
  ##   deletePolicy: JString
  ##               : Sets the policy to use for deleting resources.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579088 = query.getOrDefault("key")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = nil)
  if valid_579088 != nil:
    section.add "key", valid_579088
  var valid_579089 = query.getOrDefault("prettyPrint")
  valid_579089 = validateParameter(valid_579089, JBool, required = false,
                                 default = newJBool(true))
  if valid_579089 != nil:
    section.add "prettyPrint", valid_579089
  var valid_579090 = query.getOrDefault("oauth_token")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "oauth_token", valid_579090
  var valid_579091 = query.getOrDefault("alt")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = newJString("json"))
  if valid_579091 != nil:
    section.add "alt", valid_579091
  var valid_579092 = query.getOrDefault("userIp")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "userIp", valid_579092
  var valid_579093 = query.getOrDefault("quotaUser")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "quotaUser", valid_579093
  var valid_579094 = query.getOrDefault("deletePolicy")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = newJString("DELETE"))
  if valid_579094 != nil:
    section.add "deletePolicy", valid_579094
  var valid_579095 = query.getOrDefault("fields")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "fields", valid_579095
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579096: Call_DeploymentmanagerDeploymentsDelete_579083;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a deployment and all of the resources in the deployment.
  ## 
  let valid = call_579096.validator(path, query, header, formData, body)
  let scheme = call_579096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579096.url(scheme.get, call_579096.host, call_579096.base,
                         call_579096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579096, url, valid)

proc call*(call_579097: Call_DeploymentmanagerDeploymentsDelete_579083;
          deployment: string; project: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; deletePolicy: string = "DELETE";
          fields: string = ""): Recallable =
  ## deploymentmanagerDeploymentsDelete
  ## Deletes a deployment and all of the resources in the deployment.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   deletePolicy: string
  ##               : Sets the policy to use for deleting resources.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579098 = newJObject()
  var query_579099 = newJObject()
  add(query_579099, "key", newJString(key))
  add(query_579099, "prettyPrint", newJBool(prettyPrint))
  add(query_579099, "oauth_token", newJString(oauthToken))
  add(path_579098, "deployment", newJString(deployment))
  add(query_579099, "alt", newJString(alt))
  add(query_579099, "userIp", newJString(userIp))
  add(query_579099, "quotaUser", newJString(quotaUser))
  add(path_579098, "project", newJString(project))
  add(query_579099, "deletePolicy", newJString(deletePolicy))
  add(query_579099, "fields", newJString(fields))
  result = call_579097.call(path_579098, query_579099, nil, nil, nil)

var deploymentmanagerDeploymentsDelete* = Call_DeploymentmanagerDeploymentsDelete_579083(
    name: "deploymentmanagerDeploymentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}",
    validator: validate_DeploymentmanagerDeploymentsDelete_579084,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerDeploymentsDelete_579085, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsCancelPreview_579121 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerDeploymentsCancelPreview_579123(protocol: Scheme;
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

proc validate_DeploymentmanagerDeploymentsCancelPreview_579122(path: JsonNode;
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
  var valid_579124 = path.getOrDefault("deployment")
  valid_579124 = validateParameter(valid_579124, JString, required = true,
                                 default = nil)
  if valid_579124 != nil:
    section.add "deployment", valid_579124
  var valid_579125 = path.getOrDefault("project")
  valid_579125 = validateParameter(valid_579125, JString, required = true,
                                 default = nil)
  if valid_579125 != nil:
    section.add "project", valid_579125
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579126 = query.getOrDefault("key")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "key", valid_579126
  var valid_579127 = query.getOrDefault("prettyPrint")
  valid_579127 = validateParameter(valid_579127, JBool, required = false,
                                 default = newJBool(true))
  if valid_579127 != nil:
    section.add "prettyPrint", valid_579127
  var valid_579128 = query.getOrDefault("oauth_token")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "oauth_token", valid_579128
  var valid_579129 = query.getOrDefault("alt")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = newJString("json"))
  if valid_579129 != nil:
    section.add "alt", valid_579129
  var valid_579130 = query.getOrDefault("userIp")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = nil)
  if valid_579130 != nil:
    section.add "userIp", valid_579130
  var valid_579131 = query.getOrDefault("quotaUser")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "quotaUser", valid_579131
  var valid_579132 = query.getOrDefault("fields")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = nil)
  if valid_579132 != nil:
    section.add "fields", valid_579132
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

proc call*(call_579134: Call_DeploymentmanagerDeploymentsCancelPreview_579121;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels and removes the preview currently associated with the deployment.
  ## 
  let valid = call_579134.validator(path, query, header, formData, body)
  let scheme = call_579134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579134.url(scheme.get, call_579134.host, call_579134.base,
                         call_579134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579134, url, valid)

proc call*(call_579135: Call_DeploymentmanagerDeploymentsCancelPreview_579121;
          deployment: string; project: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## deploymentmanagerDeploymentsCancelPreview
  ## Cancels and removes the preview currently associated with the deployment.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579136 = newJObject()
  var query_579137 = newJObject()
  var body_579138 = newJObject()
  add(query_579137, "key", newJString(key))
  add(query_579137, "prettyPrint", newJBool(prettyPrint))
  add(query_579137, "oauth_token", newJString(oauthToken))
  add(path_579136, "deployment", newJString(deployment))
  add(query_579137, "alt", newJString(alt))
  add(query_579137, "userIp", newJString(userIp))
  add(query_579137, "quotaUser", newJString(quotaUser))
  add(path_579136, "project", newJString(project))
  if body != nil:
    body_579138 = body
  add(query_579137, "fields", newJString(fields))
  result = call_579135.call(path_579136, query_579137, nil, nil, body_579138)

var deploymentmanagerDeploymentsCancelPreview* = Call_DeploymentmanagerDeploymentsCancelPreview_579121(
    name: "deploymentmanagerDeploymentsCancelPreview", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}/cancelPreview",
    validator: validate_DeploymentmanagerDeploymentsCancelPreview_579122,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerDeploymentsCancelPreview_579123,
    schemes: {Scheme.Https})
type
  Call_DeploymentmanagerManifestsList_579139 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerManifestsList_579141(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerManifestsList_579140(path: JsonNode;
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
  var valid_579142 = path.getOrDefault("deployment")
  valid_579142 = validateParameter(valid_579142, JString, required = true,
                                 default = nil)
  if valid_579142 != nil:
    section.add "deployment", valid_579142
  var valid_579143 = path.getOrDefault("project")
  valid_579143 = validateParameter(valid_579143, JString, required = true,
                                 default = nil)
  if valid_579143 != nil:
    section.add "project", valid_579143
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
  ##   orderBy: JString
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   filter: JString
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  section = newJObject()
  var valid_579144 = query.getOrDefault("key")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "key", valid_579144
  var valid_579145 = query.getOrDefault("prettyPrint")
  valid_579145 = validateParameter(valid_579145, JBool, required = false,
                                 default = newJBool(true))
  if valid_579145 != nil:
    section.add "prettyPrint", valid_579145
  var valid_579146 = query.getOrDefault("oauth_token")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "oauth_token", valid_579146
  var valid_579147 = query.getOrDefault("alt")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = newJString("json"))
  if valid_579147 != nil:
    section.add "alt", valid_579147
  var valid_579148 = query.getOrDefault("userIp")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "userIp", valid_579148
  var valid_579149 = query.getOrDefault("quotaUser")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = nil)
  if valid_579149 != nil:
    section.add "quotaUser", valid_579149
  var valid_579150 = query.getOrDefault("orderBy")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = nil)
  if valid_579150 != nil:
    section.add "orderBy", valid_579150
  var valid_579151 = query.getOrDefault("filter")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = nil)
  if valid_579151 != nil:
    section.add "filter", valid_579151
  var valid_579152 = query.getOrDefault("pageToken")
  valid_579152 = validateParameter(valid_579152, JString, required = false,
                                 default = nil)
  if valid_579152 != nil:
    section.add "pageToken", valid_579152
  var valid_579153 = query.getOrDefault("fields")
  valid_579153 = validateParameter(valid_579153, JString, required = false,
                                 default = nil)
  if valid_579153 != nil:
    section.add "fields", valid_579153
  var valid_579154 = query.getOrDefault("maxResults")
  valid_579154 = validateParameter(valid_579154, JInt, required = false,
                                 default = newJInt(500))
  if valid_579154 != nil:
    section.add "maxResults", valid_579154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579155: Call_DeploymentmanagerManifestsList_579139; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all manifests for a given deployment.
  ## 
  let valid = call_579155.validator(path, query, header, formData, body)
  let scheme = call_579155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579155.url(scheme.get, call_579155.host, call_579155.base,
                         call_579155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579155, url, valid)

proc call*(call_579156: Call_DeploymentmanagerManifestsList_579139;
          deployment: string; project: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; orderBy: string = "";
          filter: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 500): Recallable =
  ## deploymentmanagerManifestsList
  ## Lists all manifests for a given deployment.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   orderBy: string
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   filter: string
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  ##   pageToken: string
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  var path_579157 = newJObject()
  var query_579158 = newJObject()
  add(query_579158, "key", newJString(key))
  add(query_579158, "prettyPrint", newJBool(prettyPrint))
  add(query_579158, "oauth_token", newJString(oauthToken))
  add(path_579157, "deployment", newJString(deployment))
  add(query_579158, "alt", newJString(alt))
  add(query_579158, "userIp", newJString(userIp))
  add(query_579158, "quotaUser", newJString(quotaUser))
  add(query_579158, "orderBy", newJString(orderBy))
  add(query_579158, "filter", newJString(filter))
  add(query_579158, "pageToken", newJString(pageToken))
  add(path_579157, "project", newJString(project))
  add(query_579158, "fields", newJString(fields))
  add(query_579158, "maxResults", newJInt(maxResults))
  result = call_579156.call(path_579157, query_579158, nil, nil, nil)

var deploymentmanagerManifestsList* = Call_DeploymentmanagerManifestsList_579139(
    name: "deploymentmanagerManifestsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}/manifests",
    validator: validate_DeploymentmanagerManifestsList_579140,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerManifestsList_579141, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerManifestsGet_579159 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerManifestsGet_579161(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerManifestsGet_579160(path: JsonNode; query: JsonNode;
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
  var valid_579162 = path.getOrDefault("deployment")
  valid_579162 = validateParameter(valid_579162, JString, required = true,
                                 default = nil)
  if valid_579162 != nil:
    section.add "deployment", valid_579162
  var valid_579163 = path.getOrDefault("project")
  valid_579163 = validateParameter(valid_579163, JString, required = true,
                                 default = nil)
  if valid_579163 != nil:
    section.add "project", valid_579163
  var valid_579164 = path.getOrDefault("manifest")
  valid_579164 = validateParameter(valid_579164, JString, required = true,
                                 default = nil)
  if valid_579164 != nil:
    section.add "manifest", valid_579164
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579165 = query.getOrDefault("key")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "key", valid_579165
  var valid_579166 = query.getOrDefault("prettyPrint")
  valid_579166 = validateParameter(valid_579166, JBool, required = false,
                                 default = newJBool(true))
  if valid_579166 != nil:
    section.add "prettyPrint", valid_579166
  var valid_579167 = query.getOrDefault("oauth_token")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = nil)
  if valid_579167 != nil:
    section.add "oauth_token", valid_579167
  var valid_579168 = query.getOrDefault("alt")
  valid_579168 = validateParameter(valid_579168, JString, required = false,
                                 default = newJString("json"))
  if valid_579168 != nil:
    section.add "alt", valid_579168
  var valid_579169 = query.getOrDefault("userIp")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = nil)
  if valid_579169 != nil:
    section.add "userIp", valid_579169
  var valid_579170 = query.getOrDefault("quotaUser")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = nil)
  if valid_579170 != nil:
    section.add "quotaUser", valid_579170
  var valid_579171 = query.getOrDefault("fields")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = nil)
  if valid_579171 != nil:
    section.add "fields", valid_579171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579172: Call_DeploymentmanagerManifestsGet_579159; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a specific manifest.
  ## 
  let valid = call_579172.validator(path, query, header, formData, body)
  let scheme = call_579172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579172.url(scheme.get, call_579172.host, call_579172.base,
                         call_579172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579172, url, valid)

proc call*(call_579173: Call_DeploymentmanagerManifestsGet_579159;
          deployment: string; project: string; manifest: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## deploymentmanagerManifestsGet
  ## Gets information about a specific manifest.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   manifest: string (required)
  ##           : The name of the manifest for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579174 = newJObject()
  var query_579175 = newJObject()
  add(query_579175, "key", newJString(key))
  add(query_579175, "prettyPrint", newJBool(prettyPrint))
  add(query_579175, "oauth_token", newJString(oauthToken))
  add(path_579174, "deployment", newJString(deployment))
  add(query_579175, "alt", newJString(alt))
  add(query_579175, "userIp", newJString(userIp))
  add(query_579175, "quotaUser", newJString(quotaUser))
  add(path_579174, "project", newJString(project))
  add(path_579174, "manifest", newJString(manifest))
  add(query_579175, "fields", newJString(fields))
  result = call_579173.call(path_579174, query_579175, nil, nil, nil)

var deploymentmanagerManifestsGet* = Call_DeploymentmanagerManifestsGet_579159(
    name: "deploymentmanagerManifestsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}/manifests/{manifest}",
    validator: validate_DeploymentmanagerManifestsGet_579160,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerManifestsGet_579161, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerResourcesList_579176 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerResourcesList_579178(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerResourcesList_579177(path: JsonNode;
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
  var valid_579179 = path.getOrDefault("deployment")
  valid_579179 = validateParameter(valid_579179, JString, required = true,
                                 default = nil)
  if valid_579179 != nil:
    section.add "deployment", valid_579179
  var valid_579180 = path.getOrDefault("project")
  valid_579180 = validateParameter(valid_579180, JString, required = true,
                                 default = nil)
  if valid_579180 != nil:
    section.add "project", valid_579180
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
  ##   orderBy: JString
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   filter: JString
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  section = newJObject()
  var valid_579181 = query.getOrDefault("key")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = nil)
  if valid_579181 != nil:
    section.add "key", valid_579181
  var valid_579182 = query.getOrDefault("prettyPrint")
  valid_579182 = validateParameter(valid_579182, JBool, required = false,
                                 default = newJBool(true))
  if valid_579182 != nil:
    section.add "prettyPrint", valid_579182
  var valid_579183 = query.getOrDefault("oauth_token")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = nil)
  if valid_579183 != nil:
    section.add "oauth_token", valid_579183
  var valid_579184 = query.getOrDefault("alt")
  valid_579184 = validateParameter(valid_579184, JString, required = false,
                                 default = newJString("json"))
  if valid_579184 != nil:
    section.add "alt", valid_579184
  var valid_579185 = query.getOrDefault("userIp")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = nil)
  if valid_579185 != nil:
    section.add "userIp", valid_579185
  var valid_579186 = query.getOrDefault("quotaUser")
  valid_579186 = validateParameter(valid_579186, JString, required = false,
                                 default = nil)
  if valid_579186 != nil:
    section.add "quotaUser", valid_579186
  var valid_579187 = query.getOrDefault("orderBy")
  valid_579187 = validateParameter(valid_579187, JString, required = false,
                                 default = nil)
  if valid_579187 != nil:
    section.add "orderBy", valid_579187
  var valid_579188 = query.getOrDefault("filter")
  valid_579188 = validateParameter(valid_579188, JString, required = false,
                                 default = nil)
  if valid_579188 != nil:
    section.add "filter", valid_579188
  var valid_579189 = query.getOrDefault("pageToken")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = nil)
  if valid_579189 != nil:
    section.add "pageToken", valid_579189
  var valid_579190 = query.getOrDefault("fields")
  valid_579190 = validateParameter(valid_579190, JString, required = false,
                                 default = nil)
  if valid_579190 != nil:
    section.add "fields", valid_579190
  var valid_579191 = query.getOrDefault("maxResults")
  valid_579191 = validateParameter(valid_579191, JInt, required = false,
                                 default = newJInt(500))
  if valid_579191 != nil:
    section.add "maxResults", valid_579191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579192: Call_DeploymentmanagerResourcesList_579176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all resources in a given deployment.
  ## 
  let valid = call_579192.validator(path, query, header, formData, body)
  let scheme = call_579192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579192.url(scheme.get, call_579192.host, call_579192.base,
                         call_579192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579192, url, valid)

proc call*(call_579193: Call_DeploymentmanagerResourcesList_579176;
          deployment: string; project: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; orderBy: string = "";
          filter: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 500): Recallable =
  ## deploymentmanagerResourcesList
  ## Lists all resources in a given deployment.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   orderBy: string
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   filter: string
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  ##   pageToken: string
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  var path_579194 = newJObject()
  var query_579195 = newJObject()
  add(query_579195, "key", newJString(key))
  add(query_579195, "prettyPrint", newJBool(prettyPrint))
  add(query_579195, "oauth_token", newJString(oauthToken))
  add(path_579194, "deployment", newJString(deployment))
  add(query_579195, "alt", newJString(alt))
  add(query_579195, "userIp", newJString(userIp))
  add(query_579195, "quotaUser", newJString(quotaUser))
  add(query_579195, "orderBy", newJString(orderBy))
  add(query_579195, "filter", newJString(filter))
  add(query_579195, "pageToken", newJString(pageToken))
  add(path_579194, "project", newJString(project))
  add(query_579195, "fields", newJString(fields))
  add(query_579195, "maxResults", newJInt(maxResults))
  result = call_579193.call(path_579194, query_579195, nil, nil, nil)

var deploymentmanagerResourcesList* = Call_DeploymentmanagerResourcesList_579176(
    name: "deploymentmanagerResourcesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}/resources",
    validator: validate_DeploymentmanagerResourcesList_579177,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerResourcesList_579178, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerResourcesGet_579196 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerResourcesGet_579198(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerResourcesGet_579197(path: JsonNode; query: JsonNode;
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
  var valid_579199 = path.getOrDefault("deployment")
  valid_579199 = validateParameter(valid_579199, JString, required = true,
                                 default = nil)
  if valid_579199 != nil:
    section.add "deployment", valid_579199
  var valid_579200 = path.getOrDefault("resource")
  valid_579200 = validateParameter(valid_579200, JString, required = true,
                                 default = nil)
  if valid_579200 != nil:
    section.add "resource", valid_579200
  var valid_579201 = path.getOrDefault("project")
  valid_579201 = validateParameter(valid_579201, JString, required = true,
                                 default = nil)
  if valid_579201 != nil:
    section.add "project", valid_579201
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579202 = query.getOrDefault("key")
  valid_579202 = validateParameter(valid_579202, JString, required = false,
                                 default = nil)
  if valid_579202 != nil:
    section.add "key", valid_579202
  var valid_579203 = query.getOrDefault("prettyPrint")
  valid_579203 = validateParameter(valid_579203, JBool, required = false,
                                 default = newJBool(true))
  if valid_579203 != nil:
    section.add "prettyPrint", valid_579203
  var valid_579204 = query.getOrDefault("oauth_token")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = nil)
  if valid_579204 != nil:
    section.add "oauth_token", valid_579204
  var valid_579205 = query.getOrDefault("alt")
  valid_579205 = validateParameter(valid_579205, JString, required = false,
                                 default = newJString("json"))
  if valid_579205 != nil:
    section.add "alt", valid_579205
  var valid_579206 = query.getOrDefault("userIp")
  valid_579206 = validateParameter(valid_579206, JString, required = false,
                                 default = nil)
  if valid_579206 != nil:
    section.add "userIp", valid_579206
  var valid_579207 = query.getOrDefault("quotaUser")
  valid_579207 = validateParameter(valid_579207, JString, required = false,
                                 default = nil)
  if valid_579207 != nil:
    section.add "quotaUser", valid_579207
  var valid_579208 = query.getOrDefault("fields")
  valid_579208 = validateParameter(valid_579208, JString, required = false,
                                 default = nil)
  if valid_579208 != nil:
    section.add "fields", valid_579208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579209: Call_DeploymentmanagerResourcesGet_579196; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a single resource.
  ## 
  let valid = call_579209.validator(path, query, header, formData, body)
  let scheme = call_579209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579209.url(scheme.get, call_579209.host, call_579209.base,
                         call_579209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579209, url, valid)

proc call*(call_579210: Call_DeploymentmanagerResourcesGet_579196;
          deployment: string; resource: string; project: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## deploymentmanagerResourcesGet
  ## Gets information about a single resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   resource: string (required)
  ##           : The name of the resource for this request.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579211 = newJObject()
  var query_579212 = newJObject()
  add(query_579212, "key", newJString(key))
  add(query_579212, "prettyPrint", newJBool(prettyPrint))
  add(query_579212, "oauth_token", newJString(oauthToken))
  add(path_579211, "deployment", newJString(deployment))
  add(query_579212, "alt", newJString(alt))
  add(query_579212, "userIp", newJString(userIp))
  add(query_579212, "quotaUser", newJString(quotaUser))
  add(path_579211, "resource", newJString(resource))
  add(path_579211, "project", newJString(project))
  add(query_579212, "fields", newJString(fields))
  result = call_579210.call(path_579211, query_579212, nil, nil, nil)

var deploymentmanagerResourcesGet* = Call_DeploymentmanagerResourcesGet_579196(
    name: "deploymentmanagerResourcesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}/resources/{resource}",
    validator: validate_DeploymentmanagerResourcesGet_579197,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerResourcesGet_579198, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsStop_579213 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerDeploymentsStop_579215(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerDeploymentsStop_579214(path: JsonNode;
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
  var valid_579216 = path.getOrDefault("deployment")
  valid_579216 = validateParameter(valid_579216, JString, required = true,
                                 default = nil)
  if valid_579216 != nil:
    section.add "deployment", valid_579216
  var valid_579217 = path.getOrDefault("project")
  valid_579217 = validateParameter(valid_579217, JString, required = true,
                                 default = nil)
  if valid_579217 != nil:
    section.add "project", valid_579217
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579218 = query.getOrDefault("key")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = nil)
  if valid_579218 != nil:
    section.add "key", valid_579218
  var valid_579219 = query.getOrDefault("prettyPrint")
  valid_579219 = validateParameter(valid_579219, JBool, required = false,
                                 default = newJBool(true))
  if valid_579219 != nil:
    section.add "prettyPrint", valid_579219
  var valid_579220 = query.getOrDefault("oauth_token")
  valid_579220 = validateParameter(valid_579220, JString, required = false,
                                 default = nil)
  if valid_579220 != nil:
    section.add "oauth_token", valid_579220
  var valid_579221 = query.getOrDefault("alt")
  valid_579221 = validateParameter(valid_579221, JString, required = false,
                                 default = newJString("json"))
  if valid_579221 != nil:
    section.add "alt", valid_579221
  var valid_579222 = query.getOrDefault("userIp")
  valid_579222 = validateParameter(valid_579222, JString, required = false,
                                 default = nil)
  if valid_579222 != nil:
    section.add "userIp", valid_579222
  var valid_579223 = query.getOrDefault("quotaUser")
  valid_579223 = validateParameter(valid_579223, JString, required = false,
                                 default = nil)
  if valid_579223 != nil:
    section.add "quotaUser", valid_579223
  var valid_579224 = query.getOrDefault("fields")
  valid_579224 = validateParameter(valid_579224, JString, required = false,
                                 default = nil)
  if valid_579224 != nil:
    section.add "fields", valid_579224
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

proc call*(call_579226: Call_DeploymentmanagerDeploymentsStop_579213;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Stops an ongoing operation. This does not roll back any work that has already been completed, but prevents any new work from being started.
  ## 
  let valid = call_579226.validator(path, query, header, formData, body)
  let scheme = call_579226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579226.url(scheme.get, call_579226.host, call_579226.base,
                         call_579226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579226, url, valid)

proc call*(call_579227: Call_DeploymentmanagerDeploymentsStop_579213;
          deployment: string; project: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## deploymentmanagerDeploymentsStop
  ## Stops an ongoing operation. This does not roll back any work that has already been completed, but prevents any new work from being started.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579228 = newJObject()
  var query_579229 = newJObject()
  var body_579230 = newJObject()
  add(query_579229, "key", newJString(key))
  add(query_579229, "prettyPrint", newJBool(prettyPrint))
  add(query_579229, "oauth_token", newJString(oauthToken))
  add(path_579228, "deployment", newJString(deployment))
  add(query_579229, "alt", newJString(alt))
  add(query_579229, "userIp", newJString(userIp))
  add(query_579229, "quotaUser", newJString(quotaUser))
  add(path_579228, "project", newJString(project))
  if body != nil:
    body_579230 = body
  add(query_579229, "fields", newJString(fields))
  result = call_579227.call(path_579228, query_579229, nil, nil, body_579230)

var deploymentmanagerDeploymentsStop* = Call_DeploymentmanagerDeploymentsStop_579213(
    name: "deploymentmanagerDeploymentsStop", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}/stop",
    validator: validate_DeploymentmanagerDeploymentsStop_579214,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerDeploymentsStop_579215, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsGetIamPolicy_579231 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerDeploymentsGetIamPolicy_579233(protocol: Scheme;
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

proc validate_DeploymentmanagerDeploymentsGetIamPolicy_579232(path: JsonNode;
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
  var valid_579234 = path.getOrDefault("resource")
  valid_579234 = validateParameter(valid_579234, JString, required = true,
                                 default = nil)
  if valid_579234 != nil:
    section.add "resource", valid_579234
  var valid_579235 = path.getOrDefault("project")
  valid_579235 = validateParameter(valid_579235, JString, required = true,
                                 default = nil)
  if valid_579235 != nil:
    section.add "project", valid_579235
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579236 = query.getOrDefault("key")
  valid_579236 = validateParameter(valid_579236, JString, required = false,
                                 default = nil)
  if valid_579236 != nil:
    section.add "key", valid_579236
  var valid_579237 = query.getOrDefault("prettyPrint")
  valid_579237 = validateParameter(valid_579237, JBool, required = false,
                                 default = newJBool(true))
  if valid_579237 != nil:
    section.add "prettyPrint", valid_579237
  var valid_579238 = query.getOrDefault("oauth_token")
  valid_579238 = validateParameter(valid_579238, JString, required = false,
                                 default = nil)
  if valid_579238 != nil:
    section.add "oauth_token", valid_579238
  var valid_579239 = query.getOrDefault("alt")
  valid_579239 = validateParameter(valid_579239, JString, required = false,
                                 default = newJString("json"))
  if valid_579239 != nil:
    section.add "alt", valid_579239
  var valid_579240 = query.getOrDefault("userIp")
  valid_579240 = validateParameter(valid_579240, JString, required = false,
                                 default = nil)
  if valid_579240 != nil:
    section.add "userIp", valid_579240
  var valid_579241 = query.getOrDefault("quotaUser")
  valid_579241 = validateParameter(valid_579241, JString, required = false,
                                 default = nil)
  if valid_579241 != nil:
    section.add "quotaUser", valid_579241
  var valid_579242 = query.getOrDefault("fields")
  valid_579242 = validateParameter(valid_579242, JString, required = false,
                                 default = nil)
  if valid_579242 != nil:
    section.add "fields", valid_579242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579243: Call_DeploymentmanagerDeploymentsGetIamPolicy_579231;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource. May be empty if no such policy or resource exists.
  ## 
  let valid = call_579243.validator(path, query, header, formData, body)
  let scheme = call_579243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579243.url(scheme.get, call_579243.host, call_579243.base,
                         call_579243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579243, url, valid)

proc call*(call_579244: Call_DeploymentmanagerDeploymentsGetIamPolicy_579231;
          resource: string; project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## deploymentmanagerDeploymentsGetIamPolicy
  ## Gets the access control policy for a resource. May be empty if no such policy or resource exists.
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
  ##   resource: string (required)
  ##           : Name or id of the resource for this request.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579245 = newJObject()
  var query_579246 = newJObject()
  add(query_579246, "key", newJString(key))
  add(query_579246, "prettyPrint", newJBool(prettyPrint))
  add(query_579246, "oauth_token", newJString(oauthToken))
  add(query_579246, "alt", newJString(alt))
  add(query_579246, "userIp", newJString(userIp))
  add(query_579246, "quotaUser", newJString(quotaUser))
  add(path_579245, "resource", newJString(resource))
  add(path_579245, "project", newJString(project))
  add(query_579246, "fields", newJString(fields))
  result = call_579244.call(path_579245, query_579246, nil, nil, nil)

var deploymentmanagerDeploymentsGetIamPolicy* = Call_DeploymentmanagerDeploymentsGetIamPolicy_579231(
    name: "deploymentmanagerDeploymentsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{resource}/getIamPolicy",
    validator: validate_DeploymentmanagerDeploymentsGetIamPolicy_579232,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerDeploymentsGetIamPolicy_579233,
    schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsSetIamPolicy_579247 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerDeploymentsSetIamPolicy_579249(protocol: Scheme;
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

proc validate_DeploymentmanagerDeploymentsSetIamPolicy_579248(path: JsonNode;
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
  var valid_579250 = path.getOrDefault("resource")
  valid_579250 = validateParameter(valid_579250, JString, required = true,
                                 default = nil)
  if valid_579250 != nil:
    section.add "resource", valid_579250
  var valid_579251 = path.getOrDefault("project")
  valid_579251 = validateParameter(valid_579251, JString, required = true,
                                 default = nil)
  if valid_579251 != nil:
    section.add "project", valid_579251
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579252 = query.getOrDefault("key")
  valid_579252 = validateParameter(valid_579252, JString, required = false,
                                 default = nil)
  if valid_579252 != nil:
    section.add "key", valid_579252
  var valid_579253 = query.getOrDefault("prettyPrint")
  valid_579253 = validateParameter(valid_579253, JBool, required = false,
                                 default = newJBool(true))
  if valid_579253 != nil:
    section.add "prettyPrint", valid_579253
  var valid_579254 = query.getOrDefault("oauth_token")
  valid_579254 = validateParameter(valid_579254, JString, required = false,
                                 default = nil)
  if valid_579254 != nil:
    section.add "oauth_token", valid_579254
  var valid_579255 = query.getOrDefault("alt")
  valid_579255 = validateParameter(valid_579255, JString, required = false,
                                 default = newJString("json"))
  if valid_579255 != nil:
    section.add "alt", valid_579255
  var valid_579256 = query.getOrDefault("userIp")
  valid_579256 = validateParameter(valid_579256, JString, required = false,
                                 default = nil)
  if valid_579256 != nil:
    section.add "userIp", valid_579256
  var valid_579257 = query.getOrDefault("quotaUser")
  valid_579257 = validateParameter(valid_579257, JString, required = false,
                                 default = nil)
  if valid_579257 != nil:
    section.add "quotaUser", valid_579257
  var valid_579258 = query.getOrDefault("fields")
  valid_579258 = validateParameter(valid_579258, JString, required = false,
                                 default = nil)
  if valid_579258 != nil:
    section.add "fields", valid_579258
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

proc call*(call_579260: Call_DeploymentmanagerDeploymentsSetIamPolicy_579247;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any existing policy.
  ## 
  let valid = call_579260.validator(path, query, header, formData, body)
  let scheme = call_579260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579260.url(scheme.get, call_579260.host, call_579260.base,
                         call_579260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579260, url, valid)

proc call*(call_579261: Call_DeploymentmanagerDeploymentsSetIamPolicy_579247;
          resource: string; project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## deploymentmanagerDeploymentsSetIamPolicy
  ## Sets the access control policy on the specified resource. Replaces any existing policy.
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
  ##   resource: string (required)
  ##           : Name or id of the resource for this request.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579262 = newJObject()
  var query_579263 = newJObject()
  var body_579264 = newJObject()
  add(query_579263, "key", newJString(key))
  add(query_579263, "prettyPrint", newJBool(prettyPrint))
  add(query_579263, "oauth_token", newJString(oauthToken))
  add(query_579263, "alt", newJString(alt))
  add(query_579263, "userIp", newJString(userIp))
  add(query_579263, "quotaUser", newJString(quotaUser))
  add(path_579262, "resource", newJString(resource))
  add(path_579262, "project", newJString(project))
  if body != nil:
    body_579264 = body
  add(query_579263, "fields", newJString(fields))
  result = call_579261.call(path_579262, query_579263, nil, nil, body_579264)

var deploymentmanagerDeploymentsSetIamPolicy* = Call_DeploymentmanagerDeploymentsSetIamPolicy_579247(
    name: "deploymentmanagerDeploymentsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{resource}/setIamPolicy",
    validator: validate_DeploymentmanagerDeploymentsSetIamPolicy_579248,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerDeploymentsSetIamPolicy_579249,
    schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsTestIamPermissions_579265 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerDeploymentsTestIamPermissions_579267(protocol: Scheme;
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

proc validate_DeploymentmanagerDeploymentsTestIamPermissions_579266(
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
  var valid_579268 = path.getOrDefault("resource")
  valid_579268 = validateParameter(valid_579268, JString, required = true,
                                 default = nil)
  if valid_579268 != nil:
    section.add "resource", valid_579268
  var valid_579269 = path.getOrDefault("project")
  valid_579269 = validateParameter(valid_579269, JString, required = true,
                                 default = nil)
  if valid_579269 != nil:
    section.add "project", valid_579269
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579270 = query.getOrDefault("key")
  valid_579270 = validateParameter(valid_579270, JString, required = false,
                                 default = nil)
  if valid_579270 != nil:
    section.add "key", valid_579270
  var valid_579271 = query.getOrDefault("prettyPrint")
  valid_579271 = validateParameter(valid_579271, JBool, required = false,
                                 default = newJBool(true))
  if valid_579271 != nil:
    section.add "prettyPrint", valid_579271
  var valid_579272 = query.getOrDefault("oauth_token")
  valid_579272 = validateParameter(valid_579272, JString, required = false,
                                 default = nil)
  if valid_579272 != nil:
    section.add "oauth_token", valid_579272
  var valid_579273 = query.getOrDefault("alt")
  valid_579273 = validateParameter(valid_579273, JString, required = false,
                                 default = newJString("json"))
  if valid_579273 != nil:
    section.add "alt", valid_579273
  var valid_579274 = query.getOrDefault("userIp")
  valid_579274 = validateParameter(valid_579274, JString, required = false,
                                 default = nil)
  if valid_579274 != nil:
    section.add "userIp", valid_579274
  var valid_579275 = query.getOrDefault("quotaUser")
  valid_579275 = validateParameter(valid_579275, JString, required = false,
                                 default = nil)
  if valid_579275 != nil:
    section.add "quotaUser", valid_579275
  var valid_579276 = query.getOrDefault("fields")
  valid_579276 = validateParameter(valid_579276, JString, required = false,
                                 default = nil)
  if valid_579276 != nil:
    section.add "fields", valid_579276
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

proc call*(call_579278: Call_DeploymentmanagerDeploymentsTestIamPermissions_579265;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified resource.
  ## 
  let valid = call_579278.validator(path, query, header, formData, body)
  let scheme = call_579278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579278.url(scheme.get, call_579278.host, call_579278.base,
                         call_579278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579278, url, valid)

proc call*(call_579279: Call_DeploymentmanagerDeploymentsTestIamPermissions_579265;
          resource: string; project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## deploymentmanagerDeploymentsTestIamPermissions
  ## Returns permissions that a caller has on the specified resource.
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
  ##   resource: string (required)
  ##           : Name or id of the resource for this request.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579280 = newJObject()
  var query_579281 = newJObject()
  var body_579282 = newJObject()
  add(query_579281, "key", newJString(key))
  add(query_579281, "prettyPrint", newJBool(prettyPrint))
  add(query_579281, "oauth_token", newJString(oauthToken))
  add(query_579281, "alt", newJString(alt))
  add(query_579281, "userIp", newJString(userIp))
  add(query_579281, "quotaUser", newJString(quotaUser))
  add(path_579280, "resource", newJString(resource))
  add(path_579280, "project", newJString(project))
  if body != nil:
    body_579282 = body
  add(query_579281, "fields", newJString(fields))
  result = call_579279.call(path_579280, query_579281, nil, nil, body_579282)

var deploymentmanagerDeploymentsTestIamPermissions* = Call_DeploymentmanagerDeploymentsTestIamPermissions_579265(
    name: "deploymentmanagerDeploymentsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{project}/global/deployments/{resource}/testIamPermissions",
    validator: validate_DeploymentmanagerDeploymentsTestIamPermissions_579266,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerDeploymentsTestIamPermissions_579267,
    schemes: {Scheme.Https})
type
  Call_DeploymentmanagerOperationsList_579283 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerOperationsList_579285(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerOperationsList_579284(path: JsonNode;
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
  var valid_579286 = path.getOrDefault("project")
  valid_579286 = validateParameter(valid_579286, JString, required = true,
                                 default = nil)
  if valid_579286 != nil:
    section.add "project", valid_579286
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
  ##   orderBy: JString
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   filter: JString
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  section = newJObject()
  var valid_579287 = query.getOrDefault("key")
  valid_579287 = validateParameter(valid_579287, JString, required = false,
                                 default = nil)
  if valid_579287 != nil:
    section.add "key", valid_579287
  var valid_579288 = query.getOrDefault("prettyPrint")
  valid_579288 = validateParameter(valid_579288, JBool, required = false,
                                 default = newJBool(true))
  if valid_579288 != nil:
    section.add "prettyPrint", valid_579288
  var valid_579289 = query.getOrDefault("oauth_token")
  valid_579289 = validateParameter(valid_579289, JString, required = false,
                                 default = nil)
  if valid_579289 != nil:
    section.add "oauth_token", valid_579289
  var valid_579290 = query.getOrDefault("alt")
  valid_579290 = validateParameter(valid_579290, JString, required = false,
                                 default = newJString("json"))
  if valid_579290 != nil:
    section.add "alt", valid_579290
  var valid_579291 = query.getOrDefault("userIp")
  valid_579291 = validateParameter(valid_579291, JString, required = false,
                                 default = nil)
  if valid_579291 != nil:
    section.add "userIp", valid_579291
  var valid_579292 = query.getOrDefault("quotaUser")
  valid_579292 = validateParameter(valid_579292, JString, required = false,
                                 default = nil)
  if valid_579292 != nil:
    section.add "quotaUser", valid_579292
  var valid_579293 = query.getOrDefault("orderBy")
  valid_579293 = validateParameter(valid_579293, JString, required = false,
                                 default = nil)
  if valid_579293 != nil:
    section.add "orderBy", valid_579293
  var valid_579294 = query.getOrDefault("filter")
  valid_579294 = validateParameter(valid_579294, JString, required = false,
                                 default = nil)
  if valid_579294 != nil:
    section.add "filter", valid_579294
  var valid_579295 = query.getOrDefault("pageToken")
  valid_579295 = validateParameter(valid_579295, JString, required = false,
                                 default = nil)
  if valid_579295 != nil:
    section.add "pageToken", valid_579295
  var valid_579296 = query.getOrDefault("fields")
  valid_579296 = validateParameter(valid_579296, JString, required = false,
                                 default = nil)
  if valid_579296 != nil:
    section.add "fields", valid_579296
  var valid_579297 = query.getOrDefault("maxResults")
  valid_579297 = validateParameter(valid_579297, JInt, required = false,
                                 default = newJInt(500))
  if valid_579297 != nil:
    section.add "maxResults", valid_579297
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579298: Call_DeploymentmanagerOperationsList_579283;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all operations for a project.
  ## 
  let valid = call_579298.validator(path, query, header, formData, body)
  let scheme = call_579298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579298.url(scheme.get, call_579298.host, call_579298.base,
                         call_579298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579298, url, valid)

proc call*(call_579299: Call_DeploymentmanagerOperationsList_579283;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; orderBy: string = ""; filter: string = "";
          pageToken: string = ""; fields: string = ""; maxResults: int = 500): Recallable =
  ## deploymentmanagerOperationsList
  ## Lists all operations for a project.
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
  ##   orderBy: string
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   filter: string
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  ##   pageToken: string
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  var path_579300 = newJObject()
  var query_579301 = newJObject()
  add(query_579301, "key", newJString(key))
  add(query_579301, "prettyPrint", newJBool(prettyPrint))
  add(query_579301, "oauth_token", newJString(oauthToken))
  add(query_579301, "alt", newJString(alt))
  add(query_579301, "userIp", newJString(userIp))
  add(query_579301, "quotaUser", newJString(quotaUser))
  add(query_579301, "orderBy", newJString(orderBy))
  add(query_579301, "filter", newJString(filter))
  add(query_579301, "pageToken", newJString(pageToken))
  add(path_579300, "project", newJString(project))
  add(query_579301, "fields", newJString(fields))
  add(query_579301, "maxResults", newJInt(maxResults))
  result = call_579299.call(path_579300, query_579301, nil, nil, nil)

var deploymentmanagerOperationsList* = Call_DeploymentmanagerOperationsList_579283(
    name: "deploymentmanagerOperationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/operations",
    validator: validate_DeploymentmanagerOperationsList_579284,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerOperationsList_579285, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerOperationsGet_579302 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerOperationsGet_579304(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerOperationsGet_579303(path: JsonNode;
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
  var valid_579305 = path.getOrDefault("operation")
  valid_579305 = validateParameter(valid_579305, JString, required = true,
                                 default = nil)
  if valid_579305 != nil:
    section.add "operation", valid_579305
  var valid_579306 = path.getOrDefault("project")
  valid_579306 = validateParameter(valid_579306, JString, required = true,
                                 default = nil)
  if valid_579306 != nil:
    section.add "project", valid_579306
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579307 = query.getOrDefault("key")
  valid_579307 = validateParameter(valid_579307, JString, required = false,
                                 default = nil)
  if valid_579307 != nil:
    section.add "key", valid_579307
  var valid_579308 = query.getOrDefault("prettyPrint")
  valid_579308 = validateParameter(valid_579308, JBool, required = false,
                                 default = newJBool(true))
  if valid_579308 != nil:
    section.add "prettyPrint", valid_579308
  var valid_579309 = query.getOrDefault("oauth_token")
  valid_579309 = validateParameter(valid_579309, JString, required = false,
                                 default = nil)
  if valid_579309 != nil:
    section.add "oauth_token", valid_579309
  var valid_579310 = query.getOrDefault("alt")
  valid_579310 = validateParameter(valid_579310, JString, required = false,
                                 default = newJString("json"))
  if valid_579310 != nil:
    section.add "alt", valid_579310
  var valid_579311 = query.getOrDefault("userIp")
  valid_579311 = validateParameter(valid_579311, JString, required = false,
                                 default = nil)
  if valid_579311 != nil:
    section.add "userIp", valid_579311
  var valid_579312 = query.getOrDefault("quotaUser")
  valid_579312 = validateParameter(valid_579312, JString, required = false,
                                 default = nil)
  if valid_579312 != nil:
    section.add "quotaUser", valid_579312
  var valid_579313 = query.getOrDefault("fields")
  valid_579313 = validateParameter(valid_579313, JString, required = false,
                                 default = nil)
  if valid_579313 != nil:
    section.add "fields", valid_579313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579314: Call_DeploymentmanagerOperationsGet_579302; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a specific operation.
  ## 
  let valid = call_579314.validator(path, query, header, formData, body)
  let scheme = call_579314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579314.url(scheme.get, call_579314.host, call_579314.base,
                         call_579314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579314, url, valid)

proc call*(call_579315: Call_DeploymentmanagerOperationsGet_579302;
          operation: string; project: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## deploymentmanagerOperationsGet
  ## Gets information about a specific operation.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   operation: string (required)
  ##            : The name of the operation for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579316 = newJObject()
  var query_579317 = newJObject()
  add(query_579317, "key", newJString(key))
  add(query_579317, "prettyPrint", newJBool(prettyPrint))
  add(query_579317, "oauth_token", newJString(oauthToken))
  add(path_579316, "operation", newJString(operation))
  add(query_579317, "alt", newJString(alt))
  add(query_579317, "userIp", newJString(userIp))
  add(query_579317, "quotaUser", newJString(quotaUser))
  add(path_579316, "project", newJString(project))
  add(query_579317, "fields", newJString(fields))
  result = call_579315.call(path_579316, query_579317, nil, nil, nil)

var deploymentmanagerOperationsGet* = Call_DeploymentmanagerOperationsGet_579302(
    name: "deploymentmanagerOperationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/operations/{operation}",
    validator: validate_DeploymentmanagerOperationsGet_579303,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerOperationsGet_579304, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypeProvidersInsert_579337 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerTypeProvidersInsert_579339(protocol: Scheme;
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

proc validate_DeploymentmanagerTypeProvidersInsert_579338(path: JsonNode;
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
  var valid_579340 = path.getOrDefault("project")
  valid_579340 = validateParameter(valid_579340, JString, required = true,
                                 default = nil)
  if valid_579340 != nil:
    section.add "project", valid_579340
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579341 = query.getOrDefault("key")
  valid_579341 = validateParameter(valid_579341, JString, required = false,
                                 default = nil)
  if valid_579341 != nil:
    section.add "key", valid_579341
  var valid_579342 = query.getOrDefault("prettyPrint")
  valid_579342 = validateParameter(valid_579342, JBool, required = false,
                                 default = newJBool(true))
  if valid_579342 != nil:
    section.add "prettyPrint", valid_579342
  var valid_579343 = query.getOrDefault("oauth_token")
  valid_579343 = validateParameter(valid_579343, JString, required = false,
                                 default = nil)
  if valid_579343 != nil:
    section.add "oauth_token", valid_579343
  var valid_579344 = query.getOrDefault("alt")
  valid_579344 = validateParameter(valid_579344, JString, required = false,
                                 default = newJString("json"))
  if valid_579344 != nil:
    section.add "alt", valid_579344
  var valid_579345 = query.getOrDefault("userIp")
  valid_579345 = validateParameter(valid_579345, JString, required = false,
                                 default = nil)
  if valid_579345 != nil:
    section.add "userIp", valid_579345
  var valid_579346 = query.getOrDefault("quotaUser")
  valid_579346 = validateParameter(valid_579346, JString, required = false,
                                 default = nil)
  if valid_579346 != nil:
    section.add "quotaUser", valid_579346
  var valid_579347 = query.getOrDefault("fields")
  valid_579347 = validateParameter(valid_579347, JString, required = false,
                                 default = nil)
  if valid_579347 != nil:
    section.add "fields", valid_579347
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

proc call*(call_579349: Call_DeploymentmanagerTypeProvidersInsert_579337;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a type provider.
  ## 
  let valid = call_579349.validator(path, query, header, formData, body)
  let scheme = call_579349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579349.url(scheme.get, call_579349.host, call_579349.base,
                         call_579349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579349, url, valid)

proc call*(call_579350: Call_DeploymentmanagerTypeProvidersInsert_579337;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## deploymentmanagerTypeProvidersInsert
  ## Creates a type provider.
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
  ##          : The project ID for this request.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579351 = newJObject()
  var query_579352 = newJObject()
  var body_579353 = newJObject()
  add(query_579352, "key", newJString(key))
  add(query_579352, "prettyPrint", newJBool(prettyPrint))
  add(query_579352, "oauth_token", newJString(oauthToken))
  add(query_579352, "alt", newJString(alt))
  add(query_579352, "userIp", newJString(userIp))
  add(query_579352, "quotaUser", newJString(quotaUser))
  add(path_579351, "project", newJString(project))
  if body != nil:
    body_579353 = body
  add(query_579352, "fields", newJString(fields))
  result = call_579350.call(path_579351, query_579352, nil, nil, body_579353)

var deploymentmanagerTypeProvidersInsert* = Call_DeploymentmanagerTypeProvidersInsert_579337(
    name: "deploymentmanagerTypeProvidersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/global/typeProviders",
    validator: validate_DeploymentmanagerTypeProvidersInsert_579338,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerTypeProvidersInsert_579339, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypeProvidersList_579318 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerTypeProvidersList_579320(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerTypeProvidersList_579319(path: JsonNode;
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
  var valid_579321 = path.getOrDefault("project")
  valid_579321 = validateParameter(valid_579321, JString, required = true,
                                 default = nil)
  if valid_579321 != nil:
    section.add "project", valid_579321
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
  ##   orderBy: JString
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   filter: JString
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  section = newJObject()
  var valid_579322 = query.getOrDefault("key")
  valid_579322 = validateParameter(valid_579322, JString, required = false,
                                 default = nil)
  if valid_579322 != nil:
    section.add "key", valid_579322
  var valid_579323 = query.getOrDefault("prettyPrint")
  valid_579323 = validateParameter(valid_579323, JBool, required = false,
                                 default = newJBool(true))
  if valid_579323 != nil:
    section.add "prettyPrint", valid_579323
  var valid_579324 = query.getOrDefault("oauth_token")
  valid_579324 = validateParameter(valid_579324, JString, required = false,
                                 default = nil)
  if valid_579324 != nil:
    section.add "oauth_token", valid_579324
  var valid_579325 = query.getOrDefault("alt")
  valid_579325 = validateParameter(valid_579325, JString, required = false,
                                 default = newJString("json"))
  if valid_579325 != nil:
    section.add "alt", valid_579325
  var valid_579326 = query.getOrDefault("userIp")
  valid_579326 = validateParameter(valid_579326, JString, required = false,
                                 default = nil)
  if valid_579326 != nil:
    section.add "userIp", valid_579326
  var valid_579327 = query.getOrDefault("quotaUser")
  valid_579327 = validateParameter(valid_579327, JString, required = false,
                                 default = nil)
  if valid_579327 != nil:
    section.add "quotaUser", valid_579327
  var valid_579328 = query.getOrDefault("orderBy")
  valid_579328 = validateParameter(valid_579328, JString, required = false,
                                 default = nil)
  if valid_579328 != nil:
    section.add "orderBy", valid_579328
  var valid_579329 = query.getOrDefault("filter")
  valid_579329 = validateParameter(valid_579329, JString, required = false,
                                 default = nil)
  if valid_579329 != nil:
    section.add "filter", valid_579329
  var valid_579330 = query.getOrDefault("pageToken")
  valid_579330 = validateParameter(valid_579330, JString, required = false,
                                 default = nil)
  if valid_579330 != nil:
    section.add "pageToken", valid_579330
  var valid_579331 = query.getOrDefault("fields")
  valid_579331 = validateParameter(valid_579331, JString, required = false,
                                 default = nil)
  if valid_579331 != nil:
    section.add "fields", valid_579331
  var valid_579332 = query.getOrDefault("maxResults")
  valid_579332 = validateParameter(valid_579332, JInt, required = false,
                                 default = newJInt(500))
  if valid_579332 != nil:
    section.add "maxResults", valid_579332
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579333: Call_DeploymentmanagerTypeProvidersList_579318;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all resource type providers for Deployment Manager.
  ## 
  let valid = call_579333.validator(path, query, header, formData, body)
  let scheme = call_579333.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579333.url(scheme.get, call_579333.host, call_579333.base,
                         call_579333.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579333, url, valid)

proc call*(call_579334: Call_DeploymentmanagerTypeProvidersList_579318;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; orderBy: string = ""; filter: string = "";
          pageToken: string = ""; fields: string = ""; maxResults: int = 500): Recallable =
  ## deploymentmanagerTypeProvidersList
  ## Lists all resource type providers for Deployment Manager.
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
  ##   orderBy: string
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   filter: string
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  ##   pageToken: string
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  var path_579335 = newJObject()
  var query_579336 = newJObject()
  add(query_579336, "key", newJString(key))
  add(query_579336, "prettyPrint", newJBool(prettyPrint))
  add(query_579336, "oauth_token", newJString(oauthToken))
  add(query_579336, "alt", newJString(alt))
  add(query_579336, "userIp", newJString(userIp))
  add(query_579336, "quotaUser", newJString(quotaUser))
  add(query_579336, "orderBy", newJString(orderBy))
  add(query_579336, "filter", newJString(filter))
  add(query_579336, "pageToken", newJString(pageToken))
  add(path_579335, "project", newJString(project))
  add(query_579336, "fields", newJString(fields))
  add(query_579336, "maxResults", newJInt(maxResults))
  result = call_579334.call(path_579335, query_579336, nil, nil, nil)

var deploymentmanagerTypeProvidersList* = Call_DeploymentmanagerTypeProvidersList_579318(
    name: "deploymentmanagerTypeProvidersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/typeProviders",
    validator: validate_DeploymentmanagerTypeProvidersList_579319,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerTypeProvidersList_579320, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypeProvidersUpdate_579370 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerTypeProvidersUpdate_579372(protocol: Scheme;
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

proc validate_DeploymentmanagerTypeProvidersUpdate_579371(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a type provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project ID for this request.
  ##   typeProvider: JString (required)
  ##               : The name of the type provider for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_579373 = path.getOrDefault("project")
  valid_579373 = validateParameter(valid_579373, JString, required = true,
                                 default = nil)
  if valid_579373 != nil:
    section.add "project", valid_579373
  var valid_579374 = path.getOrDefault("typeProvider")
  valid_579374 = validateParameter(valid_579374, JString, required = true,
                                 default = nil)
  if valid_579374 != nil:
    section.add "typeProvider", valid_579374
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579375 = query.getOrDefault("key")
  valid_579375 = validateParameter(valid_579375, JString, required = false,
                                 default = nil)
  if valid_579375 != nil:
    section.add "key", valid_579375
  var valid_579376 = query.getOrDefault("prettyPrint")
  valid_579376 = validateParameter(valid_579376, JBool, required = false,
                                 default = newJBool(true))
  if valid_579376 != nil:
    section.add "prettyPrint", valid_579376
  var valid_579377 = query.getOrDefault("oauth_token")
  valid_579377 = validateParameter(valid_579377, JString, required = false,
                                 default = nil)
  if valid_579377 != nil:
    section.add "oauth_token", valid_579377
  var valid_579378 = query.getOrDefault("alt")
  valid_579378 = validateParameter(valid_579378, JString, required = false,
                                 default = newJString("json"))
  if valid_579378 != nil:
    section.add "alt", valid_579378
  var valid_579379 = query.getOrDefault("userIp")
  valid_579379 = validateParameter(valid_579379, JString, required = false,
                                 default = nil)
  if valid_579379 != nil:
    section.add "userIp", valid_579379
  var valid_579380 = query.getOrDefault("quotaUser")
  valid_579380 = validateParameter(valid_579380, JString, required = false,
                                 default = nil)
  if valid_579380 != nil:
    section.add "quotaUser", valid_579380
  var valid_579381 = query.getOrDefault("fields")
  valid_579381 = validateParameter(valid_579381, JString, required = false,
                                 default = nil)
  if valid_579381 != nil:
    section.add "fields", valid_579381
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

proc call*(call_579383: Call_DeploymentmanagerTypeProvidersUpdate_579370;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a type provider.
  ## 
  let valid = call_579383.validator(path, query, header, formData, body)
  let scheme = call_579383.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579383.url(scheme.get, call_579383.host, call_579383.base,
                         call_579383.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579383, url, valid)

proc call*(call_579384: Call_DeploymentmanagerTypeProvidersUpdate_579370;
          project: string; typeProvider: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## deploymentmanagerTypeProvidersUpdate
  ## Updates a type provider.
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
  ##          : The project ID for this request.
  ##   body: JObject
  ##   typeProvider: string (required)
  ##               : The name of the type provider for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579385 = newJObject()
  var query_579386 = newJObject()
  var body_579387 = newJObject()
  add(query_579386, "key", newJString(key))
  add(query_579386, "prettyPrint", newJBool(prettyPrint))
  add(query_579386, "oauth_token", newJString(oauthToken))
  add(query_579386, "alt", newJString(alt))
  add(query_579386, "userIp", newJString(userIp))
  add(query_579386, "quotaUser", newJString(quotaUser))
  add(path_579385, "project", newJString(project))
  if body != nil:
    body_579387 = body
  add(path_579385, "typeProvider", newJString(typeProvider))
  add(query_579386, "fields", newJString(fields))
  result = call_579384.call(path_579385, query_579386, nil, nil, body_579387)

var deploymentmanagerTypeProvidersUpdate* = Call_DeploymentmanagerTypeProvidersUpdate_579370(
    name: "deploymentmanagerTypeProvidersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{project}/global/typeProviders/{typeProvider}",
    validator: validate_DeploymentmanagerTypeProvidersUpdate_579371,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerTypeProvidersUpdate_579372, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypeProvidersGet_579354 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerTypeProvidersGet_579356(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerTypeProvidersGet_579355(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about a specific type provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project ID for this request.
  ##   typeProvider: JString (required)
  ##               : The name of the type provider for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_579357 = path.getOrDefault("project")
  valid_579357 = validateParameter(valid_579357, JString, required = true,
                                 default = nil)
  if valid_579357 != nil:
    section.add "project", valid_579357
  var valid_579358 = path.getOrDefault("typeProvider")
  valid_579358 = validateParameter(valid_579358, JString, required = true,
                                 default = nil)
  if valid_579358 != nil:
    section.add "typeProvider", valid_579358
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579359 = query.getOrDefault("key")
  valid_579359 = validateParameter(valid_579359, JString, required = false,
                                 default = nil)
  if valid_579359 != nil:
    section.add "key", valid_579359
  var valid_579360 = query.getOrDefault("prettyPrint")
  valid_579360 = validateParameter(valid_579360, JBool, required = false,
                                 default = newJBool(true))
  if valid_579360 != nil:
    section.add "prettyPrint", valid_579360
  var valid_579361 = query.getOrDefault("oauth_token")
  valid_579361 = validateParameter(valid_579361, JString, required = false,
                                 default = nil)
  if valid_579361 != nil:
    section.add "oauth_token", valid_579361
  var valid_579362 = query.getOrDefault("alt")
  valid_579362 = validateParameter(valid_579362, JString, required = false,
                                 default = newJString("json"))
  if valid_579362 != nil:
    section.add "alt", valid_579362
  var valid_579363 = query.getOrDefault("userIp")
  valid_579363 = validateParameter(valid_579363, JString, required = false,
                                 default = nil)
  if valid_579363 != nil:
    section.add "userIp", valid_579363
  var valid_579364 = query.getOrDefault("quotaUser")
  valid_579364 = validateParameter(valid_579364, JString, required = false,
                                 default = nil)
  if valid_579364 != nil:
    section.add "quotaUser", valid_579364
  var valid_579365 = query.getOrDefault("fields")
  valid_579365 = validateParameter(valid_579365, JString, required = false,
                                 default = nil)
  if valid_579365 != nil:
    section.add "fields", valid_579365
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579366: Call_DeploymentmanagerTypeProvidersGet_579354;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about a specific type provider.
  ## 
  let valid = call_579366.validator(path, query, header, formData, body)
  let scheme = call_579366.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579366.url(scheme.get, call_579366.host, call_579366.base,
                         call_579366.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579366, url, valid)

proc call*(call_579367: Call_DeploymentmanagerTypeProvidersGet_579354;
          project: string; typeProvider: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## deploymentmanagerTypeProvidersGet
  ## Gets information about a specific type provider.
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
  ##          : The project ID for this request.
  ##   typeProvider: string (required)
  ##               : The name of the type provider for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579368 = newJObject()
  var query_579369 = newJObject()
  add(query_579369, "key", newJString(key))
  add(query_579369, "prettyPrint", newJBool(prettyPrint))
  add(query_579369, "oauth_token", newJString(oauthToken))
  add(query_579369, "alt", newJString(alt))
  add(query_579369, "userIp", newJString(userIp))
  add(query_579369, "quotaUser", newJString(quotaUser))
  add(path_579368, "project", newJString(project))
  add(path_579368, "typeProvider", newJString(typeProvider))
  add(query_579369, "fields", newJString(fields))
  result = call_579367.call(path_579368, query_579369, nil, nil, nil)

var deploymentmanagerTypeProvidersGet* = Call_DeploymentmanagerTypeProvidersGet_579354(
    name: "deploymentmanagerTypeProvidersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/typeProviders/{typeProvider}",
    validator: validate_DeploymentmanagerTypeProvidersGet_579355,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerTypeProvidersGet_579356, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypeProvidersPatch_579404 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerTypeProvidersPatch_579406(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerTypeProvidersPatch_579405(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a type provider. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project ID for this request.
  ##   typeProvider: JString (required)
  ##               : The name of the type provider for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_579407 = path.getOrDefault("project")
  valid_579407 = validateParameter(valid_579407, JString, required = true,
                                 default = nil)
  if valid_579407 != nil:
    section.add "project", valid_579407
  var valid_579408 = path.getOrDefault("typeProvider")
  valid_579408 = validateParameter(valid_579408, JString, required = true,
                                 default = nil)
  if valid_579408 != nil:
    section.add "typeProvider", valid_579408
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579409 = query.getOrDefault("key")
  valid_579409 = validateParameter(valid_579409, JString, required = false,
                                 default = nil)
  if valid_579409 != nil:
    section.add "key", valid_579409
  var valid_579410 = query.getOrDefault("prettyPrint")
  valid_579410 = validateParameter(valid_579410, JBool, required = false,
                                 default = newJBool(true))
  if valid_579410 != nil:
    section.add "prettyPrint", valid_579410
  var valid_579411 = query.getOrDefault("oauth_token")
  valid_579411 = validateParameter(valid_579411, JString, required = false,
                                 default = nil)
  if valid_579411 != nil:
    section.add "oauth_token", valid_579411
  var valid_579412 = query.getOrDefault("alt")
  valid_579412 = validateParameter(valid_579412, JString, required = false,
                                 default = newJString("json"))
  if valid_579412 != nil:
    section.add "alt", valid_579412
  var valid_579413 = query.getOrDefault("userIp")
  valid_579413 = validateParameter(valid_579413, JString, required = false,
                                 default = nil)
  if valid_579413 != nil:
    section.add "userIp", valid_579413
  var valid_579414 = query.getOrDefault("quotaUser")
  valid_579414 = validateParameter(valid_579414, JString, required = false,
                                 default = nil)
  if valid_579414 != nil:
    section.add "quotaUser", valid_579414
  var valid_579415 = query.getOrDefault("fields")
  valid_579415 = validateParameter(valid_579415, JString, required = false,
                                 default = nil)
  if valid_579415 != nil:
    section.add "fields", valid_579415
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

proc call*(call_579417: Call_DeploymentmanagerTypeProvidersPatch_579404;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a type provider. This method supports patch semantics.
  ## 
  let valid = call_579417.validator(path, query, header, formData, body)
  let scheme = call_579417.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579417.url(scheme.get, call_579417.host, call_579417.base,
                         call_579417.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579417, url, valid)

proc call*(call_579418: Call_DeploymentmanagerTypeProvidersPatch_579404;
          project: string; typeProvider: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## deploymentmanagerTypeProvidersPatch
  ## Updates a type provider. This method supports patch semantics.
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
  ##          : The project ID for this request.
  ##   body: JObject
  ##   typeProvider: string (required)
  ##               : The name of the type provider for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579419 = newJObject()
  var query_579420 = newJObject()
  var body_579421 = newJObject()
  add(query_579420, "key", newJString(key))
  add(query_579420, "prettyPrint", newJBool(prettyPrint))
  add(query_579420, "oauth_token", newJString(oauthToken))
  add(query_579420, "alt", newJString(alt))
  add(query_579420, "userIp", newJString(userIp))
  add(query_579420, "quotaUser", newJString(quotaUser))
  add(path_579419, "project", newJString(project))
  if body != nil:
    body_579421 = body
  add(path_579419, "typeProvider", newJString(typeProvider))
  add(query_579420, "fields", newJString(fields))
  result = call_579418.call(path_579419, query_579420, nil, nil, body_579421)

var deploymentmanagerTypeProvidersPatch* = Call_DeploymentmanagerTypeProvidersPatch_579404(
    name: "deploymentmanagerTypeProvidersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{project}/global/typeProviders/{typeProvider}",
    validator: validate_DeploymentmanagerTypeProvidersPatch_579405,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerTypeProvidersPatch_579406, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypeProvidersDelete_579388 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerTypeProvidersDelete_579390(protocol: Scheme;
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

proc validate_DeploymentmanagerTypeProvidersDelete_579389(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a type provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project ID for this request.
  ##   typeProvider: JString (required)
  ##               : The name of the type provider for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_579391 = path.getOrDefault("project")
  valid_579391 = validateParameter(valid_579391, JString, required = true,
                                 default = nil)
  if valid_579391 != nil:
    section.add "project", valid_579391
  var valid_579392 = path.getOrDefault("typeProvider")
  valid_579392 = validateParameter(valid_579392, JString, required = true,
                                 default = nil)
  if valid_579392 != nil:
    section.add "typeProvider", valid_579392
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579393 = query.getOrDefault("key")
  valid_579393 = validateParameter(valid_579393, JString, required = false,
                                 default = nil)
  if valid_579393 != nil:
    section.add "key", valid_579393
  var valid_579394 = query.getOrDefault("prettyPrint")
  valid_579394 = validateParameter(valid_579394, JBool, required = false,
                                 default = newJBool(true))
  if valid_579394 != nil:
    section.add "prettyPrint", valid_579394
  var valid_579395 = query.getOrDefault("oauth_token")
  valid_579395 = validateParameter(valid_579395, JString, required = false,
                                 default = nil)
  if valid_579395 != nil:
    section.add "oauth_token", valid_579395
  var valid_579396 = query.getOrDefault("alt")
  valid_579396 = validateParameter(valid_579396, JString, required = false,
                                 default = newJString("json"))
  if valid_579396 != nil:
    section.add "alt", valid_579396
  var valid_579397 = query.getOrDefault("userIp")
  valid_579397 = validateParameter(valid_579397, JString, required = false,
                                 default = nil)
  if valid_579397 != nil:
    section.add "userIp", valid_579397
  var valid_579398 = query.getOrDefault("quotaUser")
  valid_579398 = validateParameter(valid_579398, JString, required = false,
                                 default = nil)
  if valid_579398 != nil:
    section.add "quotaUser", valid_579398
  var valid_579399 = query.getOrDefault("fields")
  valid_579399 = validateParameter(valid_579399, JString, required = false,
                                 default = nil)
  if valid_579399 != nil:
    section.add "fields", valid_579399
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579400: Call_DeploymentmanagerTypeProvidersDelete_579388;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a type provider.
  ## 
  let valid = call_579400.validator(path, query, header, formData, body)
  let scheme = call_579400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579400.url(scheme.get, call_579400.host, call_579400.base,
                         call_579400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579400, url, valid)

proc call*(call_579401: Call_DeploymentmanagerTypeProvidersDelete_579388;
          project: string; typeProvider: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## deploymentmanagerTypeProvidersDelete
  ## Deletes a type provider.
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
  ##          : The project ID for this request.
  ##   typeProvider: string (required)
  ##               : The name of the type provider for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579402 = newJObject()
  var query_579403 = newJObject()
  add(query_579403, "key", newJString(key))
  add(query_579403, "prettyPrint", newJBool(prettyPrint))
  add(query_579403, "oauth_token", newJString(oauthToken))
  add(query_579403, "alt", newJString(alt))
  add(query_579403, "userIp", newJString(userIp))
  add(query_579403, "quotaUser", newJString(quotaUser))
  add(path_579402, "project", newJString(project))
  add(path_579402, "typeProvider", newJString(typeProvider))
  add(query_579403, "fields", newJString(fields))
  result = call_579401.call(path_579402, query_579403, nil, nil, nil)

var deploymentmanagerTypeProvidersDelete* = Call_DeploymentmanagerTypeProvidersDelete_579388(
    name: "deploymentmanagerTypeProvidersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{project}/global/typeProviders/{typeProvider}",
    validator: validate_DeploymentmanagerTypeProvidersDelete_579389,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerTypeProvidersDelete_579390, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypeProvidersListTypes_579422 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerTypeProvidersListTypes_579424(protocol: Scheme;
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

proc validate_DeploymentmanagerTypeProvidersListTypes_579423(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the type info for a TypeProvider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project ID for this request.
  ##   typeProvider: JString (required)
  ##               : The name of the type provider for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_579425 = path.getOrDefault("project")
  valid_579425 = validateParameter(valid_579425, JString, required = true,
                                 default = nil)
  if valid_579425 != nil:
    section.add "project", valid_579425
  var valid_579426 = path.getOrDefault("typeProvider")
  valid_579426 = validateParameter(valid_579426, JString, required = true,
                                 default = nil)
  if valid_579426 != nil:
    section.add "typeProvider", valid_579426
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
  ##   orderBy: JString
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   filter: JString
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  section = newJObject()
  var valid_579427 = query.getOrDefault("key")
  valid_579427 = validateParameter(valid_579427, JString, required = false,
                                 default = nil)
  if valid_579427 != nil:
    section.add "key", valid_579427
  var valid_579428 = query.getOrDefault("prettyPrint")
  valid_579428 = validateParameter(valid_579428, JBool, required = false,
                                 default = newJBool(true))
  if valid_579428 != nil:
    section.add "prettyPrint", valid_579428
  var valid_579429 = query.getOrDefault("oauth_token")
  valid_579429 = validateParameter(valid_579429, JString, required = false,
                                 default = nil)
  if valid_579429 != nil:
    section.add "oauth_token", valid_579429
  var valid_579430 = query.getOrDefault("alt")
  valid_579430 = validateParameter(valid_579430, JString, required = false,
                                 default = newJString("json"))
  if valid_579430 != nil:
    section.add "alt", valid_579430
  var valid_579431 = query.getOrDefault("userIp")
  valid_579431 = validateParameter(valid_579431, JString, required = false,
                                 default = nil)
  if valid_579431 != nil:
    section.add "userIp", valid_579431
  var valid_579432 = query.getOrDefault("quotaUser")
  valid_579432 = validateParameter(valid_579432, JString, required = false,
                                 default = nil)
  if valid_579432 != nil:
    section.add "quotaUser", valid_579432
  var valid_579433 = query.getOrDefault("orderBy")
  valid_579433 = validateParameter(valid_579433, JString, required = false,
                                 default = nil)
  if valid_579433 != nil:
    section.add "orderBy", valid_579433
  var valid_579434 = query.getOrDefault("filter")
  valid_579434 = validateParameter(valid_579434, JString, required = false,
                                 default = nil)
  if valid_579434 != nil:
    section.add "filter", valid_579434
  var valid_579435 = query.getOrDefault("pageToken")
  valid_579435 = validateParameter(valid_579435, JString, required = false,
                                 default = nil)
  if valid_579435 != nil:
    section.add "pageToken", valid_579435
  var valid_579436 = query.getOrDefault("fields")
  valid_579436 = validateParameter(valid_579436, JString, required = false,
                                 default = nil)
  if valid_579436 != nil:
    section.add "fields", valid_579436
  var valid_579437 = query.getOrDefault("maxResults")
  valid_579437 = validateParameter(valid_579437, JInt, required = false,
                                 default = newJInt(500))
  if valid_579437 != nil:
    section.add "maxResults", valid_579437
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579438: Call_DeploymentmanagerTypeProvidersListTypes_579422;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the type info for a TypeProvider.
  ## 
  let valid = call_579438.validator(path, query, header, formData, body)
  let scheme = call_579438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579438.url(scheme.get, call_579438.host, call_579438.base,
                         call_579438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579438, url, valid)

proc call*(call_579439: Call_DeploymentmanagerTypeProvidersListTypes_579422;
          project: string; typeProvider: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; orderBy: string = "";
          filter: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 500): Recallable =
  ## deploymentmanagerTypeProvidersListTypes
  ## Lists all the type info for a TypeProvider.
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
  ##   orderBy: string
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   filter: string
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  ##   pageToken: string
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   typeProvider: string (required)
  ##               : The name of the type provider for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  var path_579440 = newJObject()
  var query_579441 = newJObject()
  add(query_579441, "key", newJString(key))
  add(query_579441, "prettyPrint", newJBool(prettyPrint))
  add(query_579441, "oauth_token", newJString(oauthToken))
  add(query_579441, "alt", newJString(alt))
  add(query_579441, "userIp", newJString(userIp))
  add(query_579441, "quotaUser", newJString(quotaUser))
  add(query_579441, "orderBy", newJString(orderBy))
  add(query_579441, "filter", newJString(filter))
  add(query_579441, "pageToken", newJString(pageToken))
  add(path_579440, "project", newJString(project))
  add(path_579440, "typeProvider", newJString(typeProvider))
  add(query_579441, "fields", newJString(fields))
  add(query_579441, "maxResults", newJInt(maxResults))
  result = call_579439.call(path_579440, query_579441, nil, nil, nil)

var deploymentmanagerTypeProvidersListTypes* = Call_DeploymentmanagerTypeProvidersListTypes_579422(
    name: "deploymentmanagerTypeProvidersListTypes", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/typeProviders/{typeProvider}/types",
    validator: validate_DeploymentmanagerTypeProvidersListTypes_579423,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerTypeProvidersListTypes_579424,
    schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypeProvidersGetType_579442 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerTypeProvidersGetType_579444(protocol: Scheme;
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

proc validate_DeploymentmanagerTypeProvidersGetType_579443(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a type info for a type provided by a TypeProvider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   type: JString (required)
  ##       : The name of the type provider type for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  ##   typeProvider: JString (required)
  ##               : The name of the type provider for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `type` field"
  var valid_579445 = path.getOrDefault("type")
  valid_579445 = validateParameter(valid_579445, JString, required = true,
                                 default = nil)
  if valid_579445 != nil:
    section.add "type", valid_579445
  var valid_579446 = path.getOrDefault("project")
  valid_579446 = validateParameter(valid_579446, JString, required = true,
                                 default = nil)
  if valid_579446 != nil:
    section.add "project", valid_579446
  var valid_579447 = path.getOrDefault("typeProvider")
  valid_579447 = validateParameter(valid_579447, JString, required = true,
                                 default = nil)
  if valid_579447 != nil:
    section.add "typeProvider", valid_579447
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579448 = query.getOrDefault("key")
  valid_579448 = validateParameter(valid_579448, JString, required = false,
                                 default = nil)
  if valid_579448 != nil:
    section.add "key", valid_579448
  var valid_579449 = query.getOrDefault("prettyPrint")
  valid_579449 = validateParameter(valid_579449, JBool, required = false,
                                 default = newJBool(true))
  if valid_579449 != nil:
    section.add "prettyPrint", valid_579449
  var valid_579450 = query.getOrDefault("oauth_token")
  valid_579450 = validateParameter(valid_579450, JString, required = false,
                                 default = nil)
  if valid_579450 != nil:
    section.add "oauth_token", valid_579450
  var valid_579451 = query.getOrDefault("alt")
  valid_579451 = validateParameter(valid_579451, JString, required = false,
                                 default = newJString("json"))
  if valid_579451 != nil:
    section.add "alt", valid_579451
  var valid_579452 = query.getOrDefault("userIp")
  valid_579452 = validateParameter(valid_579452, JString, required = false,
                                 default = nil)
  if valid_579452 != nil:
    section.add "userIp", valid_579452
  var valid_579453 = query.getOrDefault("quotaUser")
  valid_579453 = validateParameter(valid_579453, JString, required = false,
                                 default = nil)
  if valid_579453 != nil:
    section.add "quotaUser", valid_579453
  var valid_579454 = query.getOrDefault("fields")
  valid_579454 = validateParameter(valid_579454, JString, required = false,
                                 default = nil)
  if valid_579454 != nil:
    section.add "fields", valid_579454
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579455: Call_DeploymentmanagerTypeProvidersGetType_579442;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a type info for a type provided by a TypeProvider.
  ## 
  let valid = call_579455.validator(path, query, header, formData, body)
  let scheme = call_579455.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579455.url(scheme.get, call_579455.host, call_579455.base,
                         call_579455.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579455, url, valid)

proc call*(call_579456: Call_DeploymentmanagerTypeProvidersGetType_579442;
          `type`: string; project: string; typeProvider: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## deploymentmanagerTypeProvidersGetType
  ## Gets a type info for a type provided by a TypeProvider.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   type: string (required)
  ##       : The name of the type provider type for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   typeProvider: string (required)
  ##               : The name of the type provider for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579457 = newJObject()
  var query_579458 = newJObject()
  add(query_579458, "key", newJString(key))
  add(query_579458, "prettyPrint", newJBool(prettyPrint))
  add(query_579458, "oauth_token", newJString(oauthToken))
  add(path_579457, "type", newJString(`type`))
  add(query_579458, "alt", newJString(alt))
  add(query_579458, "userIp", newJString(userIp))
  add(query_579458, "quotaUser", newJString(quotaUser))
  add(path_579457, "project", newJString(project))
  add(path_579457, "typeProvider", newJString(typeProvider))
  add(query_579458, "fields", newJString(fields))
  result = call_579456.call(path_579457, query_579458, nil, nil, nil)

var deploymentmanagerTypeProvidersGetType* = Call_DeploymentmanagerTypeProvidersGetType_579442(
    name: "deploymentmanagerTypeProvidersGetType", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/typeProviders/{typeProvider}/types/{type}",
    validator: validate_DeploymentmanagerTypeProvidersGetType_579443,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerTypeProvidersGetType_579444, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypesInsert_579478 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerTypesInsert_579480(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerTypesInsert_579479(path: JsonNode; query: JsonNode;
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
  var valid_579481 = path.getOrDefault("project")
  valid_579481 = validateParameter(valid_579481, JString, required = true,
                                 default = nil)
  if valid_579481 != nil:
    section.add "project", valid_579481
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579482 = query.getOrDefault("key")
  valid_579482 = validateParameter(valid_579482, JString, required = false,
                                 default = nil)
  if valid_579482 != nil:
    section.add "key", valid_579482
  var valid_579483 = query.getOrDefault("prettyPrint")
  valid_579483 = validateParameter(valid_579483, JBool, required = false,
                                 default = newJBool(true))
  if valid_579483 != nil:
    section.add "prettyPrint", valid_579483
  var valid_579484 = query.getOrDefault("oauth_token")
  valid_579484 = validateParameter(valid_579484, JString, required = false,
                                 default = nil)
  if valid_579484 != nil:
    section.add "oauth_token", valid_579484
  var valid_579485 = query.getOrDefault("alt")
  valid_579485 = validateParameter(valid_579485, JString, required = false,
                                 default = newJString("json"))
  if valid_579485 != nil:
    section.add "alt", valid_579485
  var valid_579486 = query.getOrDefault("userIp")
  valid_579486 = validateParameter(valid_579486, JString, required = false,
                                 default = nil)
  if valid_579486 != nil:
    section.add "userIp", valid_579486
  var valid_579487 = query.getOrDefault("quotaUser")
  valid_579487 = validateParameter(valid_579487, JString, required = false,
                                 default = nil)
  if valid_579487 != nil:
    section.add "quotaUser", valid_579487
  var valid_579488 = query.getOrDefault("fields")
  valid_579488 = validateParameter(valid_579488, JString, required = false,
                                 default = nil)
  if valid_579488 != nil:
    section.add "fields", valid_579488
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

proc call*(call_579490: Call_DeploymentmanagerTypesInsert_579478; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a type.
  ## 
  let valid = call_579490.validator(path, query, header, formData, body)
  let scheme = call_579490.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579490.url(scheme.get, call_579490.host, call_579490.base,
                         call_579490.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579490, url, valid)

proc call*(call_579491: Call_DeploymentmanagerTypesInsert_579478; project: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## deploymentmanagerTypesInsert
  ## Creates a type.
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
  ##          : The project ID for this request.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579492 = newJObject()
  var query_579493 = newJObject()
  var body_579494 = newJObject()
  add(query_579493, "key", newJString(key))
  add(query_579493, "prettyPrint", newJBool(prettyPrint))
  add(query_579493, "oauth_token", newJString(oauthToken))
  add(query_579493, "alt", newJString(alt))
  add(query_579493, "userIp", newJString(userIp))
  add(query_579493, "quotaUser", newJString(quotaUser))
  add(path_579492, "project", newJString(project))
  if body != nil:
    body_579494 = body
  add(query_579493, "fields", newJString(fields))
  result = call_579491.call(path_579492, query_579493, nil, nil, body_579494)

var deploymentmanagerTypesInsert* = Call_DeploymentmanagerTypesInsert_579478(
    name: "deploymentmanagerTypesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/global/types",
    validator: validate_DeploymentmanagerTypesInsert_579479,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerTypesInsert_579480, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypesList_579459 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerTypesList_579461(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerTypesList_579460(path: JsonNode; query: JsonNode;
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
  var valid_579462 = path.getOrDefault("project")
  valid_579462 = validateParameter(valid_579462, JString, required = true,
                                 default = nil)
  if valid_579462 != nil:
    section.add "project", valid_579462
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
  ##   orderBy: JString
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   filter: JString
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  section = newJObject()
  var valid_579463 = query.getOrDefault("key")
  valid_579463 = validateParameter(valid_579463, JString, required = false,
                                 default = nil)
  if valid_579463 != nil:
    section.add "key", valid_579463
  var valid_579464 = query.getOrDefault("prettyPrint")
  valid_579464 = validateParameter(valid_579464, JBool, required = false,
                                 default = newJBool(true))
  if valid_579464 != nil:
    section.add "prettyPrint", valid_579464
  var valid_579465 = query.getOrDefault("oauth_token")
  valid_579465 = validateParameter(valid_579465, JString, required = false,
                                 default = nil)
  if valid_579465 != nil:
    section.add "oauth_token", valid_579465
  var valid_579466 = query.getOrDefault("alt")
  valid_579466 = validateParameter(valid_579466, JString, required = false,
                                 default = newJString("json"))
  if valid_579466 != nil:
    section.add "alt", valid_579466
  var valid_579467 = query.getOrDefault("userIp")
  valid_579467 = validateParameter(valid_579467, JString, required = false,
                                 default = nil)
  if valid_579467 != nil:
    section.add "userIp", valid_579467
  var valid_579468 = query.getOrDefault("quotaUser")
  valid_579468 = validateParameter(valid_579468, JString, required = false,
                                 default = nil)
  if valid_579468 != nil:
    section.add "quotaUser", valid_579468
  var valid_579469 = query.getOrDefault("orderBy")
  valid_579469 = validateParameter(valid_579469, JString, required = false,
                                 default = nil)
  if valid_579469 != nil:
    section.add "orderBy", valid_579469
  var valid_579470 = query.getOrDefault("filter")
  valid_579470 = validateParameter(valid_579470, JString, required = false,
                                 default = nil)
  if valid_579470 != nil:
    section.add "filter", valid_579470
  var valid_579471 = query.getOrDefault("pageToken")
  valid_579471 = validateParameter(valid_579471, JString, required = false,
                                 default = nil)
  if valid_579471 != nil:
    section.add "pageToken", valid_579471
  var valid_579472 = query.getOrDefault("fields")
  valid_579472 = validateParameter(valid_579472, JString, required = false,
                                 default = nil)
  if valid_579472 != nil:
    section.add "fields", valid_579472
  var valid_579473 = query.getOrDefault("maxResults")
  valid_579473 = validateParameter(valid_579473, JInt, required = false,
                                 default = newJInt(500))
  if valid_579473 != nil:
    section.add "maxResults", valid_579473
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579474: Call_DeploymentmanagerTypesList_579459; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all resource types for Deployment Manager.
  ## 
  let valid = call_579474.validator(path, query, header, formData, body)
  let scheme = call_579474.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579474.url(scheme.get, call_579474.host, call_579474.base,
                         call_579474.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579474, url, valid)

proc call*(call_579475: Call_DeploymentmanagerTypesList_579459; project: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          orderBy: string = ""; filter: string = ""; pageToken: string = "";
          fields: string = ""; maxResults: int = 500): Recallable =
  ## deploymentmanagerTypesList
  ## Lists all resource types for Deployment Manager.
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
  ##   orderBy: string
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   filter: string
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  ##   pageToken: string
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  var path_579476 = newJObject()
  var query_579477 = newJObject()
  add(query_579477, "key", newJString(key))
  add(query_579477, "prettyPrint", newJBool(prettyPrint))
  add(query_579477, "oauth_token", newJString(oauthToken))
  add(query_579477, "alt", newJString(alt))
  add(query_579477, "userIp", newJString(userIp))
  add(query_579477, "quotaUser", newJString(quotaUser))
  add(query_579477, "orderBy", newJString(orderBy))
  add(query_579477, "filter", newJString(filter))
  add(query_579477, "pageToken", newJString(pageToken))
  add(path_579476, "project", newJString(project))
  add(query_579477, "fields", newJString(fields))
  add(query_579477, "maxResults", newJInt(maxResults))
  result = call_579475.call(path_579476, query_579477, nil, nil, nil)

var deploymentmanagerTypesList* = Call_DeploymentmanagerTypesList_579459(
    name: "deploymentmanagerTypesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/types",
    validator: validate_DeploymentmanagerTypesList_579460,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerTypesList_579461, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypesUpdate_579511 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerTypesUpdate_579513(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerTypesUpdate_579512(path: JsonNode; query: JsonNode;
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
  var valid_579514 = path.getOrDefault("type")
  valid_579514 = validateParameter(valid_579514, JString, required = true,
                                 default = nil)
  if valid_579514 != nil:
    section.add "type", valid_579514
  var valid_579515 = path.getOrDefault("project")
  valid_579515 = validateParameter(valid_579515, JString, required = true,
                                 default = nil)
  if valid_579515 != nil:
    section.add "project", valid_579515
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579516 = query.getOrDefault("key")
  valid_579516 = validateParameter(valid_579516, JString, required = false,
                                 default = nil)
  if valid_579516 != nil:
    section.add "key", valid_579516
  var valid_579517 = query.getOrDefault("prettyPrint")
  valid_579517 = validateParameter(valid_579517, JBool, required = false,
                                 default = newJBool(true))
  if valid_579517 != nil:
    section.add "prettyPrint", valid_579517
  var valid_579518 = query.getOrDefault("oauth_token")
  valid_579518 = validateParameter(valid_579518, JString, required = false,
                                 default = nil)
  if valid_579518 != nil:
    section.add "oauth_token", valid_579518
  var valid_579519 = query.getOrDefault("alt")
  valid_579519 = validateParameter(valid_579519, JString, required = false,
                                 default = newJString("json"))
  if valid_579519 != nil:
    section.add "alt", valid_579519
  var valid_579520 = query.getOrDefault("userIp")
  valid_579520 = validateParameter(valid_579520, JString, required = false,
                                 default = nil)
  if valid_579520 != nil:
    section.add "userIp", valid_579520
  var valid_579521 = query.getOrDefault("quotaUser")
  valid_579521 = validateParameter(valid_579521, JString, required = false,
                                 default = nil)
  if valid_579521 != nil:
    section.add "quotaUser", valid_579521
  var valid_579522 = query.getOrDefault("fields")
  valid_579522 = validateParameter(valid_579522, JString, required = false,
                                 default = nil)
  if valid_579522 != nil:
    section.add "fields", valid_579522
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

proc call*(call_579524: Call_DeploymentmanagerTypesUpdate_579511; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a type.
  ## 
  let valid = call_579524.validator(path, query, header, formData, body)
  let scheme = call_579524.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579524.url(scheme.get, call_579524.host, call_579524.base,
                         call_579524.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579524, url, valid)

proc call*(call_579525: Call_DeploymentmanagerTypesUpdate_579511; `type`: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## deploymentmanagerTypesUpdate
  ## Updates a type.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   type: string (required)
  ##       : The name of the type for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579526 = newJObject()
  var query_579527 = newJObject()
  var body_579528 = newJObject()
  add(query_579527, "key", newJString(key))
  add(query_579527, "prettyPrint", newJBool(prettyPrint))
  add(query_579527, "oauth_token", newJString(oauthToken))
  add(path_579526, "type", newJString(`type`))
  add(query_579527, "alt", newJString(alt))
  add(query_579527, "userIp", newJString(userIp))
  add(query_579527, "quotaUser", newJString(quotaUser))
  add(path_579526, "project", newJString(project))
  if body != nil:
    body_579528 = body
  add(query_579527, "fields", newJString(fields))
  result = call_579525.call(path_579526, query_579527, nil, nil, body_579528)

var deploymentmanagerTypesUpdate* = Call_DeploymentmanagerTypesUpdate_579511(
    name: "deploymentmanagerTypesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/{project}/global/types/{type}",
    validator: validate_DeploymentmanagerTypesUpdate_579512,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerTypesUpdate_579513, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypesGet_579495 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerTypesGet_579497(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerTypesGet_579496(path: JsonNode; query: JsonNode;
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
  var valid_579498 = path.getOrDefault("type")
  valid_579498 = validateParameter(valid_579498, JString, required = true,
                                 default = nil)
  if valid_579498 != nil:
    section.add "type", valid_579498
  var valid_579499 = path.getOrDefault("project")
  valid_579499 = validateParameter(valid_579499, JString, required = true,
                                 default = nil)
  if valid_579499 != nil:
    section.add "project", valid_579499
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579500 = query.getOrDefault("key")
  valid_579500 = validateParameter(valid_579500, JString, required = false,
                                 default = nil)
  if valid_579500 != nil:
    section.add "key", valid_579500
  var valid_579501 = query.getOrDefault("prettyPrint")
  valid_579501 = validateParameter(valid_579501, JBool, required = false,
                                 default = newJBool(true))
  if valid_579501 != nil:
    section.add "prettyPrint", valid_579501
  var valid_579502 = query.getOrDefault("oauth_token")
  valid_579502 = validateParameter(valid_579502, JString, required = false,
                                 default = nil)
  if valid_579502 != nil:
    section.add "oauth_token", valid_579502
  var valid_579503 = query.getOrDefault("alt")
  valid_579503 = validateParameter(valid_579503, JString, required = false,
                                 default = newJString("json"))
  if valid_579503 != nil:
    section.add "alt", valid_579503
  var valid_579504 = query.getOrDefault("userIp")
  valid_579504 = validateParameter(valid_579504, JString, required = false,
                                 default = nil)
  if valid_579504 != nil:
    section.add "userIp", valid_579504
  var valid_579505 = query.getOrDefault("quotaUser")
  valid_579505 = validateParameter(valid_579505, JString, required = false,
                                 default = nil)
  if valid_579505 != nil:
    section.add "quotaUser", valid_579505
  var valid_579506 = query.getOrDefault("fields")
  valid_579506 = validateParameter(valid_579506, JString, required = false,
                                 default = nil)
  if valid_579506 != nil:
    section.add "fields", valid_579506
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579507: Call_DeploymentmanagerTypesGet_579495; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a specific type.
  ## 
  let valid = call_579507.validator(path, query, header, formData, body)
  let scheme = call_579507.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579507.url(scheme.get, call_579507.host, call_579507.base,
                         call_579507.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579507, url, valid)

proc call*(call_579508: Call_DeploymentmanagerTypesGet_579495; `type`: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## deploymentmanagerTypesGet
  ## Gets information about a specific type.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   type: string (required)
  ##       : The name of the type for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579509 = newJObject()
  var query_579510 = newJObject()
  add(query_579510, "key", newJString(key))
  add(query_579510, "prettyPrint", newJBool(prettyPrint))
  add(query_579510, "oauth_token", newJString(oauthToken))
  add(path_579509, "type", newJString(`type`))
  add(query_579510, "alt", newJString(alt))
  add(query_579510, "userIp", newJString(userIp))
  add(query_579510, "quotaUser", newJString(quotaUser))
  add(path_579509, "project", newJString(project))
  add(query_579510, "fields", newJString(fields))
  result = call_579508.call(path_579509, query_579510, nil, nil, nil)

var deploymentmanagerTypesGet* = Call_DeploymentmanagerTypesGet_579495(
    name: "deploymentmanagerTypesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/types/{type}",
    validator: validate_DeploymentmanagerTypesGet_579496,
    base: "/deploymentmanager/alpha/projects", url: url_DeploymentmanagerTypesGet_579497,
    schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypesPatch_579545 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerTypesPatch_579547(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerTypesPatch_579546(path: JsonNode; query: JsonNode;
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
  var valid_579548 = path.getOrDefault("type")
  valid_579548 = validateParameter(valid_579548, JString, required = true,
                                 default = nil)
  if valid_579548 != nil:
    section.add "type", valid_579548
  var valid_579549 = path.getOrDefault("project")
  valid_579549 = validateParameter(valid_579549, JString, required = true,
                                 default = nil)
  if valid_579549 != nil:
    section.add "project", valid_579549
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579550 = query.getOrDefault("key")
  valid_579550 = validateParameter(valid_579550, JString, required = false,
                                 default = nil)
  if valid_579550 != nil:
    section.add "key", valid_579550
  var valid_579551 = query.getOrDefault("prettyPrint")
  valid_579551 = validateParameter(valid_579551, JBool, required = false,
                                 default = newJBool(true))
  if valid_579551 != nil:
    section.add "prettyPrint", valid_579551
  var valid_579552 = query.getOrDefault("oauth_token")
  valid_579552 = validateParameter(valid_579552, JString, required = false,
                                 default = nil)
  if valid_579552 != nil:
    section.add "oauth_token", valid_579552
  var valid_579553 = query.getOrDefault("alt")
  valid_579553 = validateParameter(valid_579553, JString, required = false,
                                 default = newJString("json"))
  if valid_579553 != nil:
    section.add "alt", valid_579553
  var valid_579554 = query.getOrDefault("userIp")
  valid_579554 = validateParameter(valid_579554, JString, required = false,
                                 default = nil)
  if valid_579554 != nil:
    section.add "userIp", valid_579554
  var valid_579555 = query.getOrDefault("quotaUser")
  valid_579555 = validateParameter(valid_579555, JString, required = false,
                                 default = nil)
  if valid_579555 != nil:
    section.add "quotaUser", valid_579555
  var valid_579556 = query.getOrDefault("fields")
  valid_579556 = validateParameter(valid_579556, JString, required = false,
                                 default = nil)
  if valid_579556 != nil:
    section.add "fields", valid_579556
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

proc call*(call_579558: Call_DeploymentmanagerTypesPatch_579545; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a type. This method supports patch semantics.
  ## 
  let valid = call_579558.validator(path, query, header, formData, body)
  let scheme = call_579558.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579558.url(scheme.get, call_579558.host, call_579558.base,
                         call_579558.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579558, url, valid)

proc call*(call_579559: Call_DeploymentmanagerTypesPatch_579545; `type`: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## deploymentmanagerTypesPatch
  ## Updates a type. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   type: string (required)
  ##       : The name of the type for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579560 = newJObject()
  var query_579561 = newJObject()
  var body_579562 = newJObject()
  add(query_579561, "key", newJString(key))
  add(query_579561, "prettyPrint", newJBool(prettyPrint))
  add(query_579561, "oauth_token", newJString(oauthToken))
  add(path_579560, "type", newJString(`type`))
  add(query_579561, "alt", newJString(alt))
  add(query_579561, "userIp", newJString(userIp))
  add(query_579561, "quotaUser", newJString(quotaUser))
  add(path_579560, "project", newJString(project))
  if body != nil:
    body_579562 = body
  add(query_579561, "fields", newJString(fields))
  result = call_579559.call(path_579560, query_579561, nil, nil, body_579562)

var deploymentmanagerTypesPatch* = Call_DeploymentmanagerTypesPatch_579545(
    name: "deploymentmanagerTypesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/{project}/global/types/{type}",
    validator: validate_DeploymentmanagerTypesPatch_579546,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerTypesPatch_579547, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypesDelete_579529 = ref object of OpenApiRestCall_578364
proc url_DeploymentmanagerTypesDelete_579531(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerTypesDelete_579530(path: JsonNode; query: JsonNode;
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
  var valid_579532 = path.getOrDefault("type")
  valid_579532 = validateParameter(valid_579532, JString, required = true,
                                 default = nil)
  if valid_579532 != nil:
    section.add "type", valid_579532
  var valid_579533 = path.getOrDefault("project")
  valid_579533 = validateParameter(valid_579533, JString, required = true,
                                 default = nil)
  if valid_579533 != nil:
    section.add "project", valid_579533
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579534 = query.getOrDefault("key")
  valid_579534 = validateParameter(valid_579534, JString, required = false,
                                 default = nil)
  if valid_579534 != nil:
    section.add "key", valid_579534
  var valid_579535 = query.getOrDefault("prettyPrint")
  valid_579535 = validateParameter(valid_579535, JBool, required = false,
                                 default = newJBool(true))
  if valid_579535 != nil:
    section.add "prettyPrint", valid_579535
  var valid_579536 = query.getOrDefault("oauth_token")
  valid_579536 = validateParameter(valid_579536, JString, required = false,
                                 default = nil)
  if valid_579536 != nil:
    section.add "oauth_token", valid_579536
  var valid_579537 = query.getOrDefault("alt")
  valid_579537 = validateParameter(valid_579537, JString, required = false,
                                 default = newJString("json"))
  if valid_579537 != nil:
    section.add "alt", valid_579537
  var valid_579538 = query.getOrDefault("userIp")
  valid_579538 = validateParameter(valid_579538, JString, required = false,
                                 default = nil)
  if valid_579538 != nil:
    section.add "userIp", valid_579538
  var valid_579539 = query.getOrDefault("quotaUser")
  valid_579539 = validateParameter(valid_579539, JString, required = false,
                                 default = nil)
  if valid_579539 != nil:
    section.add "quotaUser", valid_579539
  var valid_579540 = query.getOrDefault("fields")
  valid_579540 = validateParameter(valid_579540, JString, required = false,
                                 default = nil)
  if valid_579540 != nil:
    section.add "fields", valid_579540
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579541: Call_DeploymentmanagerTypesDelete_579529; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a type and all of the resources in the type.
  ## 
  let valid = call_579541.validator(path, query, header, formData, body)
  let scheme = call_579541.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579541.url(scheme.get, call_579541.host, call_579541.base,
                         call_579541.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579541, url, valid)

proc call*(call_579542: Call_DeploymentmanagerTypesDelete_579529; `type`: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## deploymentmanagerTypesDelete
  ## Deletes a type and all of the resources in the type.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   type: string (required)
  ##       : The name of the type for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579543 = newJObject()
  var query_579544 = newJObject()
  add(query_579544, "key", newJString(key))
  add(query_579544, "prettyPrint", newJBool(prettyPrint))
  add(query_579544, "oauth_token", newJString(oauthToken))
  add(path_579543, "type", newJString(`type`))
  add(query_579544, "alt", newJString(alt))
  add(query_579544, "userIp", newJString(userIp))
  add(query_579544, "quotaUser", newJString(quotaUser))
  add(path_579543, "project", newJString(project))
  add(query_579544, "fields", newJString(fields))
  result = call_579542.call(path_579543, query_579544, nil, nil, nil)

var deploymentmanagerTypesDelete* = Call_DeploymentmanagerTypesDelete_579529(
    name: "deploymentmanagerTypesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{project}/global/types/{type}",
    validator: validate_DeploymentmanagerTypesDelete_579530,
    base: "/deploymentmanager/alpha/projects",
    url: url_DeploymentmanagerTypesDelete_579531, schemes: {Scheme.Https})
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
