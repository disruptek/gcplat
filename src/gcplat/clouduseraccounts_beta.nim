
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud User Accounts
## version: beta
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Creates and manages users and groups for accessing Google Compute Engine virtual machines.
## 
## https://cloud.google.com/compute/docs/access/user-accounts/api/latest/
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

  OpenApiRestCall_578355 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578355](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578355): Option[Scheme] {.used.} =
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
  gcpServiceName = "clouduseraccounts"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ClouduseraccountsGroupsInsert_578914 = ref object of OpenApiRestCall_578355
proc url_ClouduseraccountsGroupsInsert_578916(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/groups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClouduseraccountsGroupsInsert_578915(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a Group resource in the specified project using the data included in the request.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : Project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_578917 = path.getOrDefault("project")
  valid_578917 = validateParameter(valid_578917, JString, required = true,
                                 default = nil)
  if valid_578917 != nil:
    section.add "project", valid_578917
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
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578918 = query.getOrDefault("key")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "key", valid_578918
  var valid_578919 = query.getOrDefault("prettyPrint")
  valid_578919 = validateParameter(valid_578919, JBool, required = false,
                                 default = newJBool(true))
  if valid_578919 != nil:
    section.add "prettyPrint", valid_578919
  var valid_578920 = query.getOrDefault("oauth_token")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "oauth_token", valid_578920
  var valid_578921 = query.getOrDefault("alt")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = newJString("json"))
  if valid_578921 != nil:
    section.add "alt", valid_578921
  var valid_578922 = query.getOrDefault("userIp")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "userIp", valid_578922
  var valid_578923 = query.getOrDefault("quotaUser")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "quotaUser", valid_578923
  var valid_578924 = query.getOrDefault("fields")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "fields", valid_578924
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

proc call*(call_578926: Call_ClouduseraccountsGroupsInsert_578914; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Group resource in the specified project using the data included in the request.
  ## 
  let valid = call_578926.validator(path, query, header, formData, body)
  let scheme = call_578926.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578926.url(scheme.get, call_578926.host, call_578926.base,
                         call_578926.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578926, url, valid)

proc call*(call_578927: Call_ClouduseraccountsGroupsInsert_578914; project: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## clouduseraccountsGroupsInsert
  ## Creates a Group resource in the specified project using the data included in the request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578928 = newJObject()
  var query_578929 = newJObject()
  var body_578930 = newJObject()
  add(query_578929, "key", newJString(key))
  add(query_578929, "prettyPrint", newJBool(prettyPrint))
  add(query_578929, "oauth_token", newJString(oauthToken))
  add(query_578929, "alt", newJString(alt))
  add(query_578929, "userIp", newJString(userIp))
  add(query_578929, "quotaUser", newJString(quotaUser))
  add(path_578928, "project", newJString(project))
  if body != nil:
    body_578930 = body
  add(query_578929, "fields", newJString(fields))
  result = call_578927.call(path_578928, query_578929, nil, nil, body_578930)

var clouduseraccountsGroupsInsert* = Call_ClouduseraccountsGroupsInsert_578914(
    name: "clouduseraccountsGroupsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/global/groups",
    validator: validate_ClouduseraccountsGroupsInsert_578915,
    base: "/clouduseraccounts/beta/projects",
    url: url_ClouduseraccountsGroupsInsert_578916, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGroupsList_578625 = ref object of OpenApiRestCall_578355
proc url_ClouduseraccountsGroupsList_578627(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/groups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClouduseraccountsGroupsList_578626(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of groups contained within the specified project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : Project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_578753 = path.getOrDefault("project")
  valid_578753 = validateParameter(valid_578753, JString, required = true,
                                 default = nil)
  if valid_578753 != nil:
    section.add "project", valid_578753
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
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   orderBy: JString
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   filter: JString
  ##         : Sets a filter expression for filtering listed resources, in the form filter={expression}. Your {expression} must be in the format: field_name comparison_string literal_string.
  ## 
  ## The field_name is the name of the field you want to compare. Only atomic field types are supported (string, number, boolean). The comparison_string must be either eq (equals) or ne (not equals). The literal_string is the string value to filter to. The literal value must be valid for the type of field you are filtering by (string, number, boolean). For string fields, the literal value is interpreted as a regular expression using RE2 syntax. The literal value must match the entire field.
  ## 
  ## For example, to filter for instances that do not have a name of example-instance, you would use filter=name ne example-instance.
  ## 
  ## Compute Engine Beta API Only: If you use filtering in the Beta API, you can also filter on nested fields. For example, you could filter on instances that have set the scheduling.automaticRestart field to true. In particular, use filtering on nested fields to take advantage of instance labels to organize and filter results based on label values.
  ## 
  ## The Beta API also supports filtering on multiple expressions by providing each separate expression within parentheses. For example, (scheduling.automaticRestart eq true) (zone eq us-central1-f). Multiple expressions are treated as AND expressions, meaning that resources must match all expressions to pass the filters.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests.
  section = newJObject()
  var valid_578754 = query.getOrDefault("key")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "key", valid_578754
  var valid_578768 = query.getOrDefault("prettyPrint")
  valid_578768 = validateParameter(valid_578768, JBool, required = false,
                                 default = newJBool(true))
  if valid_578768 != nil:
    section.add "prettyPrint", valid_578768
  var valid_578769 = query.getOrDefault("oauth_token")
  valid_578769 = validateParameter(valid_578769, JString, required = false,
                                 default = nil)
  if valid_578769 != nil:
    section.add "oauth_token", valid_578769
  var valid_578770 = query.getOrDefault("alt")
  valid_578770 = validateParameter(valid_578770, JString, required = false,
                                 default = newJString("json"))
  if valid_578770 != nil:
    section.add "alt", valid_578770
  var valid_578771 = query.getOrDefault("userIp")
  valid_578771 = validateParameter(valid_578771, JString, required = false,
                                 default = nil)
  if valid_578771 != nil:
    section.add "userIp", valid_578771
  var valid_578772 = query.getOrDefault("quotaUser")
  valid_578772 = validateParameter(valid_578772, JString, required = false,
                                 default = nil)
  if valid_578772 != nil:
    section.add "quotaUser", valid_578772
  var valid_578773 = query.getOrDefault("orderBy")
  valid_578773 = validateParameter(valid_578773, JString, required = false,
                                 default = nil)
  if valid_578773 != nil:
    section.add "orderBy", valid_578773
  var valid_578774 = query.getOrDefault("filter")
  valid_578774 = validateParameter(valid_578774, JString, required = false,
                                 default = nil)
  if valid_578774 != nil:
    section.add "filter", valid_578774
  var valid_578775 = query.getOrDefault("pageToken")
  valid_578775 = validateParameter(valid_578775, JString, required = false,
                                 default = nil)
  if valid_578775 != nil:
    section.add "pageToken", valid_578775
  var valid_578776 = query.getOrDefault("fields")
  valid_578776 = validateParameter(valid_578776, JString, required = false,
                                 default = nil)
  if valid_578776 != nil:
    section.add "fields", valid_578776
  var valid_578778 = query.getOrDefault("maxResults")
  valid_578778 = validateParameter(valid_578778, JInt, required = false,
                                 default = newJInt(500))
  if valid_578778 != nil:
    section.add "maxResults", valid_578778
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578801: Call_ClouduseraccountsGroupsList_578625; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of groups contained within the specified project.
  ## 
  let valid = call_578801.validator(path, query, header, formData, body)
  let scheme = call_578801.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578801.url(scheme.get, call_578801.host, call_578801.base,
                         call_578801.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578801, url, valid)

proc call*(call_578872: Call_ClouduseraccountsGroupsList_578625; project: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          orderBy: string = ""; filter: string = ""; pageToken: string = "";
          fields: string = ""; maxResults: int = 500): Recallable =
  ## clouduseraccountsGroupsList
  ## Retrieves the list of groups contained within the specified project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   orderBy: string
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   filter: string
  ##         : Sets a filter expression for filtering listed resources, in the form filter={expression}. Your {expression} must be in the format: field_name comparison_string literal_string.
  ## 
  ## The field_name is the name of the field you want to compare. Only atomic field types are supported (string, number, boolean). The comparison_string must be either eq (equals) or ne (not equals). The literal_string is the string value to filter to. The literal value must be valid for the type of field you are filtering by (string, number, boolean). For string fields, the literal value is interpreted as a regular expression using RE2 syntax. The literal value must match the entire field.
  ## 
  ## For example, to filter for instances that do not have a name of example-instance, you would use filter=name ne example-instance.
  ## 
  ## Compute Engine Beta API Only: If you use filtering in the Beta API, you can also filter on nested fields. For example, you could filter on instances that have set the scheduling.automaticRestart field to true. In particular, use filtering on nested fields to take advantage of instance labels to organize and filter results based on label values.
  ## 
  ## The Beta API also supports filtering on multiple expressions by providing each separate expression within parentheses. For example, (scheduling.automaticRestart eq true) (zone eq us-central1-f). Multiple expressions are treated as AND expressions, meaning that resources must match all expressions to pass the filters.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests.
  var path_578873 = newJObject()
  var query_578875 = newJObject()
  add(query_578875, "key", newJString(key))
  add(query_578875, "prettyPrint", newJBool(prettyPrint))
  add(query_578875, "oauth_token", newJString(oauthToken))
  add(query_578875, "alt", newJString(alt))
  add(query_578875, "userIp", newJString(userIp))
  add(query_578875, "quotaUser", newJString(quotaUser))
  add(query_578875, "orderBy", newJString(orderBy))
  add(query_578875, "filter", newJString(filter))
  add(query_578875, "pageToken", newJString(pageToken))
  add(path_578873, "project", newJString(project))
  add(query_578875, "fields", newJString(fields))
  add(query_578875, "maxResults", newJInt(maxResults))
  result = call_578872.call(path_578873, query_578875, nil, nil, nil)

var clouduseraccountsGroupsList* = Call_ClouduseraccountsGroupsList_578625(
    name: "clouduseraccountsGroupsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/groups",
    validator: validate_ClouduseraccountsGroupsList_578626,
    base: "/clouduseraccounts/beta/projects",
    url: url_ClouduseraccountsGroupsList_578627, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGroupsGet_578931 = ref object of OpenApiRestCall_578355
proc url_ClouduseraccountsGroupsGet_578933(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/groups/"),
               (kind: VariableSegment, value: "groupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClouduseraccountsGroupsGet_578932(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the specified Group resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : Project ID for this request.
  ##   groupName: JString (required)
  ##            : Name of the Group resource to return.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_578934 = path.getOrDefault("project")
  valid_578934 = validateParameter(valid_578934, JString, required = true,
                                 default = nil)
  if valid_578934 != nil:
    section.add "project", valid_578934
  var valid_578935 = path.getOrDefault("groupName")
  valid_578935 = validateParameter(valid_578935, JString, required = true,
                                 default = nil)
  if valid_578935 != nil:
    section.add "groupName", valid_578935
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
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578936 = query.getOrDefault("key")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "key", valid_578936
  var valid_578937 = query.getOrDefault("prettyPrint")
  valid_578937 = validateParameter(valid_578937, JBool, required = false,
                                 default = newJBool(true))
  if valid_578937 != nil:
    section.add "prettyPrint", valid_578937
  var valid_578938 = query.getOrDefault("oauth_token")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "oauth_token", valid_578938
  var valid_578939 = query.getOrDefault("alt")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = newJString("json"))
  if valid_578939 != nil:
    section.add "alt", valid_578939
  var valid_578940 = query.getOrDefault("userIp")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "userIp", valid_578940
  var valid_578941 = query.getOrDefault("quotaUser")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "quotaUser", valid_578941
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

proc call*(call_578943: Call_ClouduseraccountsGroupsGet_578931; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specified Group resource.
  ## 
  let valid = call_578943.validator(path, query, header, formData, body)
  let scheme = call_578943.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578943.url(scheme.get, call_578943.host, call_578943.base,
                         call_578943.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578943, url, valid)

proc call*(call_578944: Call_ClouduseraccountsGroupsGet_578931; project: string;
          groupName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## clouduseraccountsGroupsGet
  ## Returns the specified Group resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   groupName: string (required)
  ##            : Name of the Group resource to return.
  var path_578945 = newJObject()
  var query_578946 = newJObject()
  add(query_578946, "key", newJString(key))
  add(query_578946, "prettyPrint", newJBool(prettyPrint))
  add(query_578946, "oauth_token", newJString(oauthToken))
  add(query_578946, "alt", newJString(alt))
  add(query_578946, "userIp", newJString(userIp))
  add(query_578946, "quotaUser", newJString(quotaUser))
  add(path_578945, "project", newJString(project))
  add(query_578946, "fields", newJString(fields))
  add(path_578945, "groupName", newJString(groupName))
  result = call_578944.call(path_578945, query_578946, nil, nil, nil)

var clouduseraccountsGroupsGet* = Call_ClouduseraccountsGroupsGet_578931(
    name: "clouduseraccountsGroupsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/groups/{groupName}",
    validator: validate_ClouduseraccountsGroupsGet_578932,
    base: "/clouduseraccounts/beta/projects", url: url_ClouduseraccountsGroupsGet_578933,
    schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGroupsDelete_578947 = ref object of OpenApiRestCall_578355
proc url_ClouduseraccountsGroupsDelete_578949(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/groups/"),
               (kind: VariableSegment, value: "groupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClouduseraccountsGroupsDelete_578948(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified Group resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : Project ID for this request.
  ##   groupName: JString (required)
  ##            : Name of the Group resource to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_578950 = path.getOrDefault("project")
  valid_578950 = validateParameter(valid_578950, JString, required = true,
                                 default = nil)
  if valid_578950 != nil:
    section.add "project", valid_578950
  var valid_578951 = path.getOrDefault("groupName")
  valid_578951 = validateParameter(valid_578951, JString, required = true,
                                 default = nil)
  if valid_578951 != nil:
    section.add "groupName", valid_578951
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
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
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
  var valid_578958 = query.getOrDefault("fields")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "fields", valid_578958
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578959: Call_ClouduseraccountsGroupsDelete_578947; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified Group resource.
  ## 
  let valid = call_578959.validator(path, query, header, formData, body)
  let scheme = call_578959.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578959.url(scheme.get, call_578959.host, call_578959.base,
                         call_578959.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578959, url, valid)

proc call*(call_578960: Call_ClouduseraccountsGroupsDelete_578947; project: string;
          groupName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## clouduseraccountsGroupsDelete
  ## Deletes the specified Group resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   groupName: string (required)
  ##            : Name of the Group resource to delete.
  var path_578961 = newJObject()
  var query_578962 = newJObject()
  add(query_578962, "key", newJString(key))
  add(query_578962, "prettyPrint", newJBool(prettyPrint))
  add(query_578962, "oauth_token", newJString(oauthToken))
  add(query_578962, "alt", newJString(alt))
  add(query_578962, "userIp", newJString(userIp))
  add(query_578962, "quotaUser", newJString(quotaUser))
  add(path_578961, "project", newJString(project))
  add(query_578962, "fields", newJString(fields))
  add(path_578961, "groupName", newJString(groupName))
  result = call_578960.call(path_578961, query_578962, nil, nil, nil)

var clouduseraccountsGroupsDelete* = Call_ClouduseraccountsGroupsDelete_578947(
    name: "clouduseraccountsGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{project}/global/groups/{groupName}",
    validator: validate_ClouduseraccountsGroupsDelete_578948,
    base: "/clouduseraccounts/beta/projects",
    url: url_ClouduseraccountsGroupsDelete_578949, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGroupsAddMember_578963 = ref object of OpenApiRestCall_578355
proc url_ClouduseraccountsGroupsAddMember_578965(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/groups/"),
               (kind: VariableSegment, value: "groupName"),
               (kind: ConstantSegment, value: "/addMember")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClouduseraccountsGroupsAddMember_578964(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds users to the specified group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : Project ID for this request.
  ##   groupName: JString (required)
  ##            : Name of the group for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_578966 = path.getOrDefault("project")
  valid_578966 = validateParameter(valid_578966, JString, required = true,
                                 default = nil)
  if valid_578966 != nil:
    section.add "project", valid_578966
  var valid_578967 = path.getOrDefault("groupName")
  valid_578967 = validateParameter(valid_578967, JString, required = true,
                                 default = nil)
  if valid_578967 != nil:
    section.add "groupName", valid_578967
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
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578968 = query.getOrDefault("key")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "key", valid_578968
  var valid_578969 = query.getOrDefault("prettyPrint")
  valid_578969 = validateParameter(valid_578969, JBool, required = false,
                                 default = newJBool(true))
  if valid_578969 != nil:
    section.add "prettyPrint", valid_578969
  var valid_578970 = query.getOrDefault("oauth_token")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "oauth_token", valid_578970
  var valid_578971 = query.getOrDefault("alt")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = newJString("json"))
  if valid_578971 != nil:
    section.add "alt", valid_578971
  var valid_578972 = query.getOrDefault("userIp")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "userIp", valid_578972
  var valid_578973 = query.getOrDefault("quotaUser")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "quotaUser", valid_578973
  var valid_578974 = query.getOrDefault("fields")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "fields", valid_578974
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

proc call*(call_578976: Call_ClouduseraccountsGroupsAddMember_578963;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds users to the specified group.
  ## 
  let valid = call_578976.validator(path, query, header, formData, body)
  let scheme = call_578976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578976.url(scheme.get, call_578976.host, call_578976.base,
                         call_578976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578976, url, valid)

proc call*(call_578977: Call_ClouduseraccountsGroupsAddMember_578963;
          project: string; groupName: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## clouduseraccountsGroupsAddMember
  ## Adds users to the specified group.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   groupName: string (required)
  ##            : Name of the group for this request.
  var path_578978 = newJObject()
  var query_578979 = newJObject()
  var body_578980 = newJObject()
  add(query_578979, "key", newJString(key))
  add(query_578979, "prettyPrint", newJBool(prettyPrint))
  add(query_578979, "oauth_token", newJString(oauthToken))
  add(query_578979, "alt", newJString(alt))
  add(query_578979, "userIp", newJString(userIp))
  add(query_578979, "quotaUser", newJString(quotaUser))
  add(path_578978, "project", newJString(project))
  if body != nil:
    body_578980 = body
  add(query_578979, "fields", newJString(fields))
  add(path_578978, "groupName", newJString(groupName))
  result = call_578977.call(path_578978, query_578979, nil, nil, body_578980)

var clouduseraccountsGroupsAddMember* = Call_ClouduseraccountsGroupsAddMember_578963(
    name: "clouduseraccountsGroupsAddMember", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/groups/{groupName}/addMember",
    validator: validate_ClouduseraccountsGroupsAddMember_578964,
    base: "/clouduseraccounts/beta/projects",
    url: url_ClouduseraccountsGroupsAddMember_578965, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGroupsRemoveMember_578981 = ref object of OpenApiRestCall_578355
proc url_ClouduseraccountsGroupsRemoveMember_578983(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/groups/"),
               (kind: VariableSegment, value: "groupName"),
               (kind: ConstantSegment, value: "/removeMember")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClouduseraccountsGroupsRemoveMember_578982(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes users from the specified group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : Project ID for this request.
  ##   groupName: JString (required)
  ##            : Name of the group for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_578984 = path.getOrDefault("project")
  valid_578984 = validateParameter(valid_578984, JString, required = true,
                                 default = nil)
  if valid_578984 != nil:
    section.add "project", valid_578984
  var valid_578985 = path.getOrDefault("groupName")
  valid_578985 = validateParameter(valid_578985, JString, required = true,
                                 default = nil)
  if valid_578985 != nil:
    section.add "groupName", valid_578985
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
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578986 = query.getOrDefault("key")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "key", valid_578986
  var valid_578987 = query.getOrDefault("prettyPrint")
  valid_578987 = validateParameter(valid_578987, JBool, required = false,
                                 default = newJBool(true))
  if valid_578987 != nil:
    section.add "prettyPrint", valid_578987
  var valid_578988 = query.getOrDefault("oauth_token")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "oauth_token", valid_578988
  var valid_578989 = query.getOrDefault("alt")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = newJString("json"))
  if valid_578989 != nil:
    section.add "alt", valid_578989
  var valid_578990 = query.getOrDefault("userIp")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "userIp", valid_578990
  var valid_578991 = query.getOrDefault("quotaUser")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "quotaUser", valid_578991
  var valid_578992 = query.getOrDefault("fields")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "fields", valid_578992
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

proc call*(call_578994: Call_ClouduseraccountsGroupsRemoveMember_578981;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes users from the specified group.
  ## 
  let valid = call_578994.validator(path, query, header, formData, body)
  let scheme = call_578994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578994.url(scheme.get, call_578994.host, call_578994.base,
                         call_578994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578994, url, valid)

proc call*(call_578995: Call_ClouduseraccountsGroupsRemoveMember_578981;
          project: string; groupName: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## clouduseraccountsGroupsRemoveMember
  ## Removes users from the specified group.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   groupName: string (required)
  ##            : Name of the group for this request.
  var path_578996 = newJObject()
  var query_578997 = newJObject()
  var body_578998 = newJObject()
  add(query_578997, "key", newJString(key))
  add(query_578997, "prettyPrint", newJBool(prettyPrint))
  add(query_578997, "oauth_token", newJString(oauthToken))
  add(query_578997, "alt", newJString(alt))
  add(query_578997, "userIp", newJString(userIp))
  add(query_578997, "quotaUser", newJString(quotaUser))
  add(path_578996, "project", newJString(project))
  if body != nil:
    body_578998 = body
  add(query_578997, "fields", newJString(fields))
  add(path_578996, "groupName", newJString(groupName))
  result = call_578995.call(path_578996, query_578997, nil, nil, body_578998)

var clouduseraccountsGroupsRemoveMember* = Call_ClouduseraccountsGroupsRemoveMember_578981(
    name: "clouduseraccountsGroupsRemoveMember", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/groups/{groupName}/removeMember",
    validator: validate_ClouduseraccountsGroupsRemoveMember_578982,
    base: "/clouduseraccounts/beta/projects",
    url: url_ClouduseraccountsGroupsRemoveMember_578983, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGlobalAccountsOperationsList_578999 = ref object of OpenApiRestCall_578355
proc url_ClouduseraccountsGlobalAccountsOperationsList_579001(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_ClouduseraccountsGlobalAccountsOperationsList_579000(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieves the list of operation resources contained within the specified project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : Project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_579002 = path.getOrDefault("project")
  valid_579002 = validateParameter(valid_579002, JString, required = true,
                                 default = nil)
  if valid_579002 != nil:
    section.add "project", valid_579002
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
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   orderBy: JString
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   filter: JString
  ##         : Sets a filter expression for filtering listed resources, in the form filter={expression}. Your {expression} must be in the format: field_name comparison_string literal_string.
  ## 
  ## The field_name is the name of the field you want to compare. Only atomic field types are supported (string, number, boolean). The comparison_string must be either eq (equals) or ne (not equals). The literal_string is the string value to filter to. The literal value must be valid for the type of field you are filtering by (string, number, boolean). For string fields, the literal value is interpreted as a regular expression using RE2 syntax. The literal value must match the entire field.
  ## 
  ## For example, to filter for instances that do not have a name of example-instance, you would use filter=name ne example-instance.
  ## 
  ## Compute Engine Beta API Only: If you use filtering in the Beta API, you can also filter on nested fields. For example, you could filter on instances that have set the scheduling.automaticRestart field to true. In particular, use filtering on nested fields to take advantage of instance labels to organize and filter results based on label values.
  ## 
  ## The Beta API also supports filtering on multiple expressions by providing each separate expression within parentheses. For example, (scheduling.automaticRestart eq true) (zone eq us-central1-f). Multiple expressions are treated as AND expressions, meaning that resources must match all expressions to pass the filters.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests.
  section = newJObject()
  var valid_579003 = query.getOrDefault("key")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "key", valid_579003
  var valid_579004 = query.getOrDefault("prettyPrint")
  valid_579004 = validateParameter(valid_579004, JBool, required = false,
                                 default = newJBool(true))
  if valid_579004 != nil:
    section.add "prettyPrint", valid_579004
  var valid_579005 = query.getOrDefault("oauth_token")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "oauth_token", valid_579005
  var valid_579006 = query.getOrDefault("alt")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = newJString("json"))
  if valid_579006 != nil:
    section.add "alt", valid_579006
  var valid_579007 = query.getOrDefault("userIp")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "userIp", valid_579007
  var valid_579008 = query.getOrDefault("quotaUser")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "quotaUser", valid_579008
  var valid_579009 = query.getOrDefault("orderBy")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "orderBy", valid_579009
  var valid_579010 = query.getOrDefault("filter")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "filter", valid_579010
  var valid_579011 = query.getOrDefault("pageToken")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "pageToken", valid_579011
  var valid_579012 = query.getOrDefault("fields")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "fields", valid_579012
  var valid_579013 = query.getOrDefault("maxResults")
  valid_579013 = validateParameter(valid_579013, JInt, required = false,
                                 default = newJInt(500))
  if valid_579013 != nil:
    section.add "maxResults", valid_579013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579014: Call_ClouduseraccountsGlobalAccountsOperationsList_578999;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of operation resources contained within the specified project.
  ## 
  let valid = call_579014.validator(path, query, header, formData, body)
  let scheme = call_579014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579014.url(scheme.get, call_579014.host, call_579014.base,
                         call_579014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579014, url, valid)

proc call*(call_579015: Call_ClouduseraccountsGlobalAccountsOperationsList_578999;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; orderBy: string = ""; filter: string = "";
          pageToken: string = ""; fields: string = ""; maxResults: int = 500): Recallable =
  ## clouduseraccountsGlobalAccountsOperationsList
  ## Retrieves the list of operation resources contained within the specified project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   orderBy: string
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   filter: string
  ##         : Sets a filter expression for filtering listed resources, in the form filter={expression}. Your {expression} must be in the format: field_name comparison_string literal_string.
  ## 
  ## The field_name is the name of the field you want to compare. Only atomic field types are supported (string, number, boolean). The comparison_string must be either eq (equals) or ne (not equals). The literal_string is the string value to filter to. The literal value must be valid for the type of field you are filtering by (string, number, boolean). For string fields, the literal value is interpreted as a regular expression using RE2 syntax. The literal value must match the entire field.
  ## 
  ## For example, to filter for instances that do not have a name of example-instance, you would use filter=name ne example-instance.
  ## 
  ## Compute Engine Beta API Only: If you use filtering in the Beta API, you can also filter on nested fields. For example, you could filter on instances that have set the scheduling.automaticRestart field to true. In particular, use filtering on nested fields to take advantage of instance labels to organize and filter results based on label values.
  ## 
  ## The Beta API also supports filtering on multiple expressions by providing each separate expression within parentheses. For example, (scheduling.automaticRestart eq true) (zone eq us-central1-f). Multiple expressions are treated as AND expressions, meaning that resources must match all expressions to pass the filters.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests.
  var path_579016 = newJObject()
  var query_579017 = newJObject()
  add(query_579017, "key", newJString(key))
  add(query_579017, "prettyPrint", newJBool(prettyPrint))
  add(query_579017, "oauth_token", newJString(oauthToken))
  add(query_579017, "alt", newJString(alt))
  add(query_579017, "userIp", newJString(userIp))
  add(query_579017, "quotaUser", newJString(quotaUser))
  add(query_579017, "orderBy", newJString(orderBy))
  add(query_579017, "filter", newJString(filter))
  add(query_579017, "pageToken", newJString(pageToken))
  add(path_579016, "project", newJString(project))
  add(query_579017, "fields", newJString(fields))
  add(query_579017, "maxResults", newJInt(maxResults))
  result = call_579015.call(path_579016, query_579017, nil, nil, nil)

var clouduseraccountsGlobalAccountsOperationsList* = Call_ClouduseraccountsGlobalAccountsOperationsList_578999(
    name: "clouduseraccountsGlobalAccountsOperationsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{project}/global/operations",
    validator: validate_ClouduseraccountsGlobalAccountsOperationsList_579000,
    base: "/clouduseraccounts/beta/projects",
    url: url_ClouduseraccountsGlobalAccountsOperationsList_579001,
    schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGlobalAccountsOperationsGet_579018 = ref object of OpenApiRestCall_578355
proc url_ClouduseraccountsGlobalAccountsOperationsGet_579020(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_ClouduseraccountsGlobalAccountsOperationsGet_579019(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the specified operation resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operation: JString (required)
  ##            : Name of the Operations resource to return.
  ##   project: JString (required)
  ##          : Project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `operation` field"
  var valid_579021 = path.getOrDefault("operation")
  valid_579021 = validateParameter(valid_579021, JString, required = true,
                                 default = nil)
  if valid_579021 != nil:
    section.add "operation", valid_579021
  var valid_579022 = path.getOrDefault("project")
  valid_579022 = validateParameter(valid_579022, JString, required = true,
                                 default = nil)
  if valid_579022 != nil:
    section.add "project", valid_579022
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
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579023 = query.getOrDefault("key")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "key", valid_579023
  var valid_579024 = query.getOrDefault("prettyPrint")
  valid_579024 = validateParameter(valid_579024, JBool, required = false,
                                 default = newJBool(true))
  if valid_579024 != nil:
    section.add "prettyPrint", valid_579024
  var valid_579025 = query.getOrDefault("oauth_token")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "oauth_token", valid_579025
  var valid_579026 = query.getOrDefault("alt")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = newJString("json"))
  if valid_579026 != nil:
    section.add "alt", valid_579026
  var valid_579027 = query.getOrDefault("userIp")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "userIp", valid_579027
  var valid_579028 = query.getOrDefault("quotaUser")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "quotaUser", valid_579028
  var valid_579029 = query.getOrDefault("fields")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "fields", valid_579029
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579030: Call_ClouduseraccountsGlobalAccountsOperationsGet_579018;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the specified operation resource.
  ## 
  let valid = call_579030.validator(path, query, header, formData, body)
  let scheme = call_579030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579030.url(scheme.get, call_579030.host, call_579030.base,
                         call_579030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579030, url, valid)

proc call*(call_579031: Call_ClouduseraccountsGlobalAccountsOperationsGet_579018;
          operation: string; project: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## clouduseraccountsGlobalAccountsOperationsGet
  ## Retrieves the specified operation resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   operation: string (required)
  ##            : Name of the Operations resource to return.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579032 = newJObject()
  var query_579033 = newJObject()
  add(query_579033, "key", newJString(key))
  add(query_579033, "prettyPrint", newJBool(prettyPrint))
  add(query_579033, "oauth_token", newJString(oauthToken))
  add(path_579032, "operation", newJString(operation))
  add(query_579033, "alt", newJString(alt))
  add(query_579033, "userIp", newJString(userIp))
  add(query_579033, "quotaUser", newJString(quotaUser))
  add(path_579032, "project", newJString(project))
  add(query_579033, "fields", newJString(fields))
  result = call_579031.call(path_579032, query_579033, nil, nil, nil)

var clouduseraccountsGlobalAccountsOperationsGet* = Call_ClouduseraccountsGlobalAccountsOperationsGet_579018(
    name: "clouduseraccountsGlobalAccountsOperationsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{project}/global/operations/{operation}",
    validator: validate_ClouduseraccountsGlobalAccountsOperationsGet_579019,
    base: "/clouduseraccounts/beta/projects",
    url: url_ClouduseraccountsGlobalAccountsOperationsGet_579020,
    schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGlobalAccountsOperationsDelete_579034 = ref object of OpenApiRestCall_578355
proc url_ClouduseraccountsGlobalAccountsOperationsDelete_579036(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_ClouduseraccountsGlobalAccountsOperationsDelete_579035(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes the specified operation resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operation: JString (required)
  ##            : Name of the Operations resource to delete.
  ##   project: JString (required)
  ##          : Project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `operation` field"
  var valid_579037 = path.getOrDefault("operation")
  valid_579037 = validateParameter(valid_579037, JString, required = true,
                                 default = nil)
  if valid_579037 != nil:
    section.add "operation", valid_579037
  var valid_579038 = path.getOrDefault("project")
  valid_579038 = validateParameter(valid_579038, JString, required = true,
                                 default = nil)
  if valid_579038 != nil:
    section.add "project", valid_579038
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
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579039 = query.getOrDefault("key")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "key", valid_579039
  var valid_579040 = query.getOrDefault("prettyPrint")
  valid_579040 = validateParameter(valid_579040, JBool, required = false,
                                 default = newJBool(true))
  if valid_579040 != nil:
    section.add "prettyPrint", valid_579040
  var valid_579041 = query.getOrDefault("oauth_token")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "oauth_token", valid_579041
  var valid_579042 = query.getOrDefault("alt")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = newJString("json"))
  if valid_579042 != nil:
    section.add "alt", valid_579042
  var valid_579043 = query.getOrDefault("userIp")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "userIp", valid_579043
  var valid_579044 = query.getOrDefault("quotaUser")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = nil)
  if valid_579044 != nil:
    section.add "quotaUser", valid_579044
  var valid_579045 = query.getOrDefault("fields")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "fields", valid_579045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579046: Call_ClouduseraccountsGlobalAccountsOperationsDelete_579034;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified operation resource.
  ## 
  let valid = call_579046.validator(path, query, header, formData, body)
  let scheme = call_579046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579046.url(scheme.get, call_579046.host, call_579046.base,
                         call_579046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579046, url, valid)

proc call*(call_579047: Call_ClouduseraccountsGlobalAccountsOperationsDelete_579034;
          operation: string; project: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## clouduseraccountsGlobalAccountsOperationsDelete
  ## Deletes the specified operation resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   operation: string (required)
  ##            : Name of the Operations resource to delete.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579048 = newJObject()
  var query_579049 = newJObject()
  add(query_579049, "key", newJString(key))
  add(query_579049, "prettyPrint", newJBool(prettyPrint))
  add(query_579049, "oauth_token", newJString(oauthToken))
  add(path_579048, "operation", newJString(operation))
  add(query_579049, "alt", newJString(alt))
  add(query_579049, "userIp", newJString(userIp))
  add(query_579049, "quotaUser", newJString(quotaUser))
  add(path_579048, "project", newJString(project))
  add(query_579049, "fields", newJString(fields))
  result = call_579047.call(path_579048, query_579049, nil, nil, nil)

var clouduseraccountsGlobalAccountsOperationsDelete* = Call_ClouduseraccountsGlobalAccountsOperationsDelete_579034(
    name: "clouduseraccountsGlobalAccountsOperationsDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/{project}/global/operations/{operation}",
    validator: validate_ClouduseraccountsGlobalAccountsOperationsDelete_579035,
    base: "/clouduseraccounts/beta/projects",
    url: url_ClouduseraccountsGlobalAccountsOperationsDelete_579036,
    schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersInsert_579069 = ref object of OpenApiRestCall_578355
proc url_ClouduseraccountsUsersInsert_579071(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/users")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClouduseraccountsUsersInsert_579070(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a User resource in the specified project using the data included in the request.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : Project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_579072 = path.getOrDefault("project")
  valid_579072 = validateParameter(valid_579072, JString, required = true,
                                 default = nil)
  if valid_579072 != nil:
    section.add "project", valid_579072
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
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579073 = query.getOrDefault("key")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "key", valid_579073
  var valid_579074 = query.getOrDefault("prettyPrint")
  valid_579074 = validateParameter(valid_579074, JBool, required = false,
                                 default = newJBool(true))
  if valid_579074 != nil:
    section.add "prettyPrint", valid_579074
  var valid_579075 = query.getOrDefault("oauth_token")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "oauth_token", valid_579075
  var valid_579076 = query.getOrDefault("alt")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = newJString("json"))
  if valid_579076 != nil:
    section.add "alt", valid_579076
  var valid_579077 = query.getOrDefault("userIp")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "userIp", valid_579077
  var valid_579078 = query.getOrDefault("quotaUser")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "quotaUser", valid_579078
  var valid_579079 = query.getOrDefault("fields")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "fields", valid_579079
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

proc call*(call_579081: Call_ClouduseraccountsUsersInsert_579069; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a User resource in the specified project using the data included in the request.
  ## 
  let valid = call_579081.validator(path, query, header, formData, body)
  let scheme = call_579081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579081.url(scheme.get, call_579081.host, call_579081.base,
                         call_579081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579081, url, valid)

proc call*(call_579082: Call_ClouduseraccountsUsersInsert_579069; project: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## clouduseraccountsUsersInsert
  ## Creates a User resource in the specified project using the data included in the request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579083 = newJObject()
  var query_579084 = newJObject()
  var body_579085 = newJObject()
  add(query_579084, "key", newJString(key))
  add(query_579084, "prettyPrint", newJBool(prettyPrint))
  add(query_579084, "oauth_token", newJString(oauthToken))
  add(query_579084, "alt", newJString(alt))
  add(query_579084, "userIp", newJString(userIp))
  add(query_579084, "quotaUser", newJString(quotaUser))
  add(path_579083, "project", newJString(project))
  if body != nil:
    body_579085 = body
  add(query_579084, "fields", newJString(fields))
  result = call_579082.call(path_579083, query_579084, nil, nil, body_579085)

var clouduseraccountsUsersInsert* = Call_ClouduseraccountsUsersInsert_579069(
    name: "clouduseraccountsUsersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/global/users",
    validator: validate_ClouduseraccountsUsersInsert_579070,
    base: "/clouduseraccounts/beta/projects",
    url: url_ClouduseraccountsUsersInsert_579071, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersList_579050 = ref object of OpenApiRestCall_578355
proc url_ClouduseraccountsUsersList_579052(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/users")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClouduseraccountsUsersList_579051(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of users contained within the specified project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : Project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_579053 = path.getOrDefault("project")
  valid_579053 = validateParameter(valid_579053, JString, required = true,
                                 default = nil)
  if valid_579053 != nil:
    section.add "project", valid_579053
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
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   orderBy: JString
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   filter: JString
  ##         : Sets a filter expression for filtering listed resources, in the form filter={expression}. Your {expression} must be in the format: field_name comparison_string literal_string.
  ## 
  ## The field_name is the name of the field you want to compare. Only atomic field types are supported (string, number, boolean). The comparison_string must be either eq (equals) or ne (not equals). The literal_string is the string value to filter to. The literal value must be valid for the type of field you are filtering by (string, number, boolean). For string fields, the literal value is interpreted as a regular expression using RE2 syntax. The literal value must match the entire field.
  ## 
  ## For example, to filter for instances that do not have a name of example-instance, you would use filter=name ne example-instance.
  ## 
  ## Compute Engine Beta API Only: If you use filtering in the Beta API, you can also filter on nested fields. For example, you could filter on instances that have set the scheduling.automaticRestart field to true. In particular, use filtering on nested fields to take advantage of instance labels to organize and filter results based on label values.
  ## 
  ## The Beta API also supports filtering on multiple expressions by providing each separate expression within parentheses. For example, (scheduling.automaticRestart eq true) (zone eq us-central1-f). Multiple expressions are treated as AND expressions, meaning that resources must match all expressions to pass the filters.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests.
  section = newJObject()
  var valid_579054 = query.getOrDefault("key")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "key", valid_579054
  var valid_579055 = query.getOrDefault("prettyPrint")
  valid_579055 = validateParameter(valid_579055, JBool, required = false,
                                 default = newJBool(true))
  if valid_579055 != nil:
    section.add "prettyPrint", valid_579055
  var valid_579056 = query.getOrDefault("oauth_token")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "oauth_token", valid_579056
  var valid_579057 = query.getOrDefault("alt")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = newJString("json"))
  if valid_579057 != nil:
    section.add "alt", valid_579057
  var valid_579058 = query.getOrDefault("userIp")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "userIp", valid_579058
  var valid_579059 = query.getOrDefault("quotaUser")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "quotaUser", valid_579059
  var valid_579060 = query.getOrDefault("orderBy")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "orderBy", valid_579060
  var valid_579061 = query.getOrDefault("filter")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "filter", valid_579061
  var valid_579062 = query.getOrDefault("pageToken")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "pageToken", valid_579062
  var valid_579063 = query.getOrDefault("fields")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "fields", valid_579063
  var valid_579064 = query.getOrDefault("maxResults")
  valid_579064 = validateParameter(valid_579064, JInt, required = false,
                                 default = newJInt(500))
  if valid_579064 != nil:
    section.add "maxResults", valid_579064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579065: Call_ClouduseraccountsUsersList_579050; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of users contained within the specified project.
  ## 
  let valid = call_579065.validator(path, query, header, formData, body)
  let scheme = call_579065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579065.url(scheme.get, call_579065.host, call_579065.base,
                         call_579065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579065, url, valid)

proc call*(call_579066: Call_ClouduseraccountsUsersList_579050; project: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          orderBy: string = ""; filter: string = ""; pageToken: string = "";
          fields: string = ""; maxResults: int = 500): Recallable =
  ## clouduseraccountsUsersList
  ## Retrieves a list of users contained within the specified project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   orderBy: string
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   filter: string
  ##         : Sets a filter expression for filtering listed resources, in the form filter={expression}. Your {expression} must be in the format: field_name comparison_string literal_string.
  ## 
  ## The field_name is the name of the field you want to compare. Only atomic field types are supported (string, number, boolean). The comparison_string must be either eq (equals) or ne (not equals). The literal_string is the string value to filter to. The literal value must be valid for the type of field you are filtering by (string, number, boolean). For string fields, the literal value is interpreted as a regular expression using RE2 syntax. The literal value must match the entire field.
  ## 
  ## For example, to filter for instances that do not have a name of example-instance, you would use filter=name ne example-instance.
  ## 
  ## Compute Engine Beta API Only: If you use filtering in the Beta API, you can also filter on nested fields. For example, you could filter on instances that have set the scheduling.automaticRestart field to true. In particular, use filtering on nested fields to take advantage of instance labels to organize and filter results based on label values.
  ## 
  ## The Beta API also supports filtering on multiple expressions by providing each separate expression within parentheses. For example, (scheduling.automaticRestart eq true) (zone eq us-central1-f). Multiple expressions are treated as AND expressions, meaning that resources must match all expressions to pass the filters.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests.
  var path_579067 = newJObject()
  var query_579068 = newJObject()
  add(query_579068, "key", newJString(key))
  add(query_579068, "prettyPrint", newJBool(prettyPrint))
  add(query_579068, "oauth_token", newJString(oauthToken))
  add(query_579068, "alt", newJString(alt))
  add(query_579068, "userIp", newJString(userIp))
  add(query_579068, "quotaUser", newJString(quotaUser))
  add(query_579068, "orderBy", newJString(orderBy))
  add(query_579068, "filter", newJString(filter))
  add(query_579068, "pageToken", newJString(pageToken))
  add(path_579067, "project", newJString(project))
  add(query_579068, "fields", newJString(fields))
  add(query_579068, "maxResults", newJInt(maxResults))
  result = call_579066.call(path_579067, query_579068, nil, nil, nil)

var clouduseraccountsUsersList* = Call_ClouduseraccountsUsersList_579050(
    name: "clouduseraccountsUsersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/users",
    validator: validate_ClouduseraccountsUsersList_579051,
    base: "/clouduseraccounts/beta/projects", url: url_ClouduseraccountsUsersList_579052,
    schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersGet_579086 = ref object of OpenApiRestCall_578355
proc url_ClouduseraccountsUsersGet_579088(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "user" in path, "`user` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/users/"),
               (kind: VariableSegment, value: "user")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClouduseraccountsUsersGet_579087(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the specified User resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : Project ID for this request.
  ##   user: JString (required)
  ##       : Name of the user resource to return.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_579089 = path.getOrDefault("project")
  valid_579089 = validateParameter(valid_579089, JString, required = true,
                                 default = nil)
  if valid_579089 != nil:
    section.add "project", valid_579089
  var valid_579090 = path.getOrDefault("user")
  valid_579090 = validateParameter(valid_579090, JString, required = true,
                                 default = nil)
  if valid_579090 != nil:
    section.add "user", valid_579090
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
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579091 = query.getOrDefault("key")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "key", valid_579091
  var valid_579092 = query.getOrDefault("prettyPrint")
  valid_579092 = validateParameter(valid_579092, JBool, required = false,
                                 default = newJBool(true))
  if valid_579092 != nil:
    section.add "prettyPrint", valid_579092
  var valid_579093 = query.getOrDefault("oauth_token")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "oauth_token", valid_579093
  var valid_579094 = query.getOrDefault("alt")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = newJString("json"))
  if valid_579094 != nil:
    section.add "alt", valid_579094
  var valid_579095 = query.getOrDefault("userIp")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "userIp", valid_579095
  var valid_579096 = query.getOrDefault("quotaUser")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = nil)
  if valid_579096 != nil:
    section.add "quotaUser", valid_579096
  var valid_579097 = query.getOrDefault("fields")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "fields", valid_579097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579098: Call_ClouduseraccountsUsersGet_579086; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specified User resource.
  ## 
  let valid = call_579098.validator(path, query, header, formData, body)
  let scheme = call_579098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579098.url(scheme.get, call_579098.host, call_579098.base,
                         call_579098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579098, url, valid)

proc call*(call_579099: Call_ClouduseraccountsUsersGet_579086; project: string;
          user: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## clouduseraccountsUsersGet
  ## Returns the specified User resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   user: string (required)
  ##       : Name of the user resource to return.
  var path_579100 = newJObject()
  var query_579101 = newJObject()
  add(query_579101, "key", newJString(key))
  add(query_579101, "prettyPrint", newJBool(prettyPrint))
  add(query_579101, "oauth_token", newJString(oauthToken))
  add(query_579101, "alt", newJString(alt))
  add(query_579101, "userIp", newJString(userIp))
  add(query_579101, "quotaUser", newJString(quotaUser))
  add(path_579100, "project", newJString(project))
  add(query_579101, "fields", newJString(fields))
  add(path_579100, "user", newJString(user))
  result = call_579099.call(path_579100, query_579101, nil, nil, nil)

var clouduseraccountsUsersGet* = Call_ClouduseraccountsUsersGet_579086(
    name: "clouduseraccountsUsersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/users/{user}",
    validator: validate_ClouduseraccountsUsersGet_579087,
    base: "/clouduseraccounts/beta/projects", url: url_ClouduseraccountsUsersGet_579088,
    schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersDelete_579102 = ref object of OpenApiRestCall_578355
proc url_ClouduseraccountsUsersDelete_579104(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "user" in path, "`user` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/users/"),
               (kind: VariableSegment, value: "user")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClouduseraccountsUsersDelete_579103(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified User resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : Project ID for this request.
  ##   user: JString (required)
  ##       : Name of the user resource to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_579105 = path.getOrDefault("project")
  valid_579105 = validateParameter(valid_579105, JString, required = true,
                                 default = nil)
  if valid_579105 != nil:
    section.add "project", valid_579105
  var valid_579106 = path.getOrDefault("user")
  valid_579106 = validateParameter(valid_579106, JString, required = true,
                                 default = nil)
  if valid_579106 != nil:
    section.add "user", valid_579106
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
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579107 = query.getOrDefault("key")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "key", valid_579107
  var valid_579108 = query.getOrDefault("prettyPrint")
  valid_579108 = validateParameter(valid_579108, JBool, required = false,
                                 default = newJBool(true))
  if valid_579108 != nil:
    section.add "prettyPrint", valid_579108
  var valid_579109 = query.getOrDefault("oauth_token")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "oauth_token", valid_579109
  var valid_579110 = query.getOrDefault("alt")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = newJString("json"))
  if valid_579110 != nil:
    section.add "alt", valid_579110
  var valid_579111 = query.getOrDefault("userIp")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = nil)
  if valid_579111 != nil:
    section.add "userIp", valid_579111
  var valid_579112 = query.getOrDefault("quotaUser")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = nil)
  if valid_579112 != nil:
    section.add "quotaUser", valid_579112
  var valid_579113 = query.getOrDefault("fields")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = nil)
  if valid_579113 != nil:
    section.add "fields", valid_579113
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579114: Call_ClouduseraccountsUsersDelete_579102; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified User resource.
  ## 
  let valid = call_579114.validator(path, query, header, formData, body)
  let scheme = call_579114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579114.url(scheme.get, call_579114.host, call_579114.base,
                         call_579114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579114, url, valid)

proc call*(call_579115: Call_ClouduseraccountsUsersDelete_579102; project: string;
          user: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## clouduseraccountsUsersDelete
  ## Deletes the specified User resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   user: string (required)
  ##       : Name of the user resource to delete.
  var path_579116 = newJObject()
  var query_579117 = newJObject()
  add(query_579117, "key", newJString(key))
  add(query_579117, "prettyPrint", newJBool(prettyPrint))
  add(query_579117, "oauth_token", newJString(oauthToken))
  add(query_579117, "alt", newJString(alt))
  add(query_579117, "userIp", newJString(userIp))
  add(query_579117, "quotaUser", newJString(quotaUser))
  add(path_579116, "project", newJString(project))
  add(query_579117, "fields", newJString(fields))
  add(path_579116, "user", newJString(user))
  result = call_579115.call(path_579116, query_579117, nil, nil, nil)

var clouduseraccountsUsersDelete* = Call_ClouduseraccountsUsersDelete_579102(
    name: "clouduseraccountsUsersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{project}/global/users/{user}",
    validator: validate_ClouduseraccountsUsersDelete_579103,
    base: "/clouduseraccounts/beta/projects",
    url: url_ClouduseraccountsUsersDelete_579104, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersAddPublicKey_579118 = ref object of OpenApiRestCall_578355
proc url_ClouduseraccountsUsersAddPublicKey_579120(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "user" in path, "`user` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/users/"),
               (kind: VariableSegment, value: "user"),
               (kind: ConstantSegment, value: "/addPublicKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClouduseraccountsUsersAddPublicKey_579119(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a public key to the specified User resource with the data included in the request.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : Project ID for this request.
  ##   user: JString (required)
  ##       : Name of the user for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_579121 = path.getOrDefault("project")
  valid_579121 = validateParameter(valid_579121, JString, required = true,
                                 default = nil)
  if valid_579121 != nil:
    section.add "project", valid_579121
  var valid_579122 = path.getOrDefault("user")
  valid_579122 = validateParameter(valid_579122, JString, required = true,
                                 default = nil)
  if valid_579122 != nil:
    section.add "user", valid_579122
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
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579123 = query.getOrDefault("key")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "key", valid_579123
  var valid_579124 = query.getOrDefault("prettyPrint")
  valid_579124 = validateParameter(valid_579124, JBool, required = false,
                                 default = newJBool(true))
  if valid_579124 != nil:
    section.add "prettyPrint", valid_579124
  var valid_579125 = query.getOrDefault("oauth_token")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "oauth_token", valid_579125
  var valid_579126 = query.getOrDefault("alt")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = newJString("json"))
  if valid_579126 != nil:
    section.add "alt", valid_579126
  var valid_579127 = query.getOrDefault("userIp")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = nil)
  if valid_579127 != nil:
    section.add "userIp", valid_579127
  var valid_579128 = query.getOrDefault("quotaUser")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "quotaUser", valid_579128
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579131: Call_ClouduseraccountsUsersAddPublicKey_579118;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a public key to the specified User resource with the data included in the request.
  ## 
  let valid = call_579131.validator(path, query, header, formData, body)
  let scheme = call_579131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579131.url(scheme.get, call_579131.host, call_579131.base,
                         call_579131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579131, url, valid)

proc call*(call_579132: Call_ClouduseraccountsUsersAddPublicKey_579118;
          project: string; user: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## clouduseraccountsUsersAddPublicKey
  ## Adds a public key to the specified User resource with the data included in the request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   user: string (required)
  ##       : Name of the user for this request.
  var path_579133 = newJObject()
  var query_579134 = newJObject()
  var body_579135 = newJObject()
  add(query_579134, "key", newJString(key))
  add(query_579134, "prettyPrint", newJBool(prettyPrint))
  add(query_579134, "oauth_token", newJString(oauthToken))
  add(query_579134, "alt", newJString(alt))
  add(query_579134, "userIp", newJString(userIp))
  add(query_579134, "quotaUser", newJString(quotaUser))
  add(path_579133, "project", newJString(project))
  if body != nil:
    body_579135 = body
  add(query_579134, "fields", newJString(fields))
  add(path_579133, "user", newJString(user))
  result = call_579132.call(path_579133, query_579134, nil, nil, body_579135)

var clouduseraccountsUsersAddPublicKey* = Call_ClouduseraccountsUsersAddPublicKey_579118(
    name: "clouduseraccountsUsersAddPublicKey", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/users/{user}/addPublicKey",
    validator: validate_ClouduseraccountsUsersAddPublicKey_579119,
    base: "/clouduseraccounts/beta/projects",
    url: url_ClouduseraccountsUsersAddPublicKey_579120, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersRemovePublicKey_579136 = ref object of OpenApiRestCall_578355
proc url_ClouduseraccountsUsersRemovePublicKey_579138(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "user" in path, "`user` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/users/"),
               (kind: VariableSegment, value: "user"),
               (kind: ConstantSegment, value: "/removePublicKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClouduseraccountsUsersRemovePublicKey_579137(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes the specified public key from the user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : Project ID for this request.
  ##   user: JString (required)
  ##       : Name of the user for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_579139 = path.getOrDefault("project")
  valid_579139 = validateParameter(valid_579139, JString, required = true,
                                 default = nil)
  if valid_579139 != nil:
    section.add "project", valid_579139
  var valid_579140 = path.getOrDefault("user")
  valid_579140 = validateParameter(valid_579140, JString, required = true,
                                 default = nil)
  if valid_579140 != nil:
    section.add "user", valid_579140
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fingerprint: JString (required)
  ##              : The fingerprint of the public key to delete. Public keys are identified by their fingerprint, which is defined by RFC4716 to be the MD5 digest of the public key.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579141 = query.getOrDefault("key")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "key", valid_579141
  var valid_579142 = query.getOrDefault("prettyPrint")
  valid_579142 = validateParameter(valid_579142, JBool, required = false,
                                 default = newJBool(true))
  if valid_579142 != nil:
    section.add "prettyPrint", valid_579142
  var valid_579143 = query.getOrDefault("oauth_token")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = nil)
  if valid_579143 != nil:
    section.add "oauth_token", valid_579143
  assert query != nil,
        "query argument is necessary due to required `fingerprint` field"
  var valid_579144 = query.getOrDefault("fingerprint")
  valid_579144 = validateParameter(valid_579144, JString, required = true,
                                 default = nil)
  if valid_579144 != nil:
    section.add "fingerprint", valid_579144
  var valid_579145 = query.getOrDefault("alt")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = newJString("json"))
  if valid_579145 != nil:
    section.add "alt", valid_579145
  var valid_579146 = query.getOrDefault("userIp")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "userIp", valid_579146
  var valid_579147 = query.getOrDefault("quotaUser")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "quotaUser", valid_579147
  var valid_579148 = query.getOrDefault("fields")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "fields", valid_579148
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579149: Call_ClouduseraccountsUsersRemovePublicKey_579136;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes the specified public key from the user.
  ## 
  let valid = call_579149.validator(path, query, header, formData, body)
  let scheme = call_579149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579149.url(scheme.get, call_579149.host, call_579149.base,
                         call_579149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579149, url, valid)

proc call*(call_579150: Call_ClouduseraccountsUsersRemovePublicKey_579136;
          fingerprint: string; project: string; user: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## clouduseraccountsUsersRemovePublicKey
  ## Removes the specified public key from the user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   fingerprint: string (required)
  ##              : The fingerprint of the public key to delete. Public keys are identified by their fingerprint, which is defined by RFC4716 to be the MD5 digest of the public key.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   user: string (required)
  ##       : Name of the user for this request.
  var path_579151 = newJObject()
  var query_579152 = newJObject()
  add(query_579152, "key", newJString(key))
  add(query_579152, "prettyPrint", newJBool(prettyPrint))
  add(query_579152, "oauth_token", newJString(oauthToken))
  add(query_579152, "fingerprint", newJString(fingerprint))
  add(query_579152, "alt", newJString(alt))
  add(query_579152, "userIp", newJString(userIp))
  add(query_579152, "quotaUser", newJString(quotaUser))
  add(path_579151, "project", newJString(project))
  add(query_579152, "fields", newJString(fields))
  add(path_579151, "user", newJString(user))
  result = call_579150.call(path_579151, query_579152, nil, nil, nil)

var clouduseraccountsUsersRemovePublicKey* = Call_ClouduseraccountsUsersRemovePublicKey_579136(
    name: "clouduseraccountsUsersRemovePublicKey", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/users/{user}/removePublicKey",
    validator: validate_ClouduseraccountsUsersRemovePublicKey_579137,
    base: "/clouduseraccounts/beta/projects",
    url: url_ClouduseraccountsUsersRemovePublicKey_579138, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsLinuxGetAuthorizedKeysView_579153 = ref object of OpenApiRestCall_578355
proc url_ClouduseraccountsLinuxGetAuthorizedKeysView_579155(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "user" in path, "`user` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/authorizedKeysView/"),
               (kind: VariableSegment, value: "user")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClouduseraccountsLinuxGetAuthorizedKeysView_579154(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of authorized public keys for a specific user account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : Project ID for this request.
  ##   zone: JString (required)
  ##       : Name of the zone for this request.
  ##   user: JString (required)
  ##       : The user account for which you want to get a list of authorized public keys.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_579156 = path.getOrDefault("project")
  valid_579156 = validateParameter(valid_579156, JString, required = true,
                                 default = nil)
  if valid_579156 != nil:
    section.add "project", valid_579156
  var valid_579157 = path.getOrDefault("zone")
  valid_579157 = validateParameter(valid_579157, JString, required = true,
                                 default = nil)
  if valid_579157 != nil:
    section.add "zone", valid_579157
  var valid_579158 = path.getOrDefault("user")
  valid_579158 = validateParameter(valid_579158, JString, required = true,
                                 default = nil)
  if valid_579158 != nil:
    section.add "user", valid_579158
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
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   login: JBool
  ##        : Whether the view was requested as part of a user-initiated login.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   instance: JString (required)
  ##           : The fully-qualified URL of the virtual machine requesting the view.
  section = newJObject()
  var valid_579159 = query.getOrDefault("key")
  valid_579159 = validateParameter(valid_579159, JString, required = false,
                                 default = nil)
  if valid_579159 != nil:
    section.add "key", valid_579159
  var valid_579160 = query.getOrDefault("prettyPrint")
  valid_579160 = validateParameter(valid_579160, JBool, required = false,
                                 default = newJBool(true))
  if valid_579160 != nil:
    section.add "prettyPrint", valid_579160
  var valid_579161 = query.getOrDefault("oauth_token")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = nil)
  if valid_579161 != nil:
    section.add "oauth_token", valid_579161
  var valid_579162 = query.getOrDefault("alt")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = newJString("json"))
  if valid_579162 != nil:
    section.add "alt", valid_579162
  var valid_579163 = query.getOrDefault("userIp")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "userIp", valid_579163
  var valid_579164 = query.getOrDefault("login")
  valid_579164 = validateParameter(valid_579164, JBool, required = false, default = nil)
  if valid_579164 != nil:
    section.add "login", valid_579164
  var valid_579165 = query.getOrDefault("quotaUser")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "quotaUser", valid_579165
  var valid_579166 = query.getOrDefault("fields")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = nil)
  if valid_579166 != nil:
    section.add "fields", valid_579166
  assert query != nil,
        "query argument is necessary due to required `instance` field"
  var valid_579167 = query.getOrDefault("instance")
  valid_579167 = validateParameter(valid_579167, JString, required = true,
                                 default = nil)
  if valid_579167 != nil:
    section.add "instance", valid_579167
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579168: Call_ClouduseraccountsLinuxGetAuthorizedKeysView_579153;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of authorized public keys for a specific user account.
  ## 
  let valid = call_579168.validator(path, query, header, formData, body)
  let scheme = call_579168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579168.url(scheme.get, call_579168.host, call_579168.base,
                         call_579168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579168, url, valid)

proc call*(call_579169: Call_ClouduseraccountsLinuxGetAuthorizedKeysView_579153;
          project: string; zone: string; user: string; instance: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; login: bool = false;
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## clouduseraccountsLinuxGetAuthorizedKeysView
  ## Returns a list of authorized public keys for a specific user account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   login: bool
  ##        : Whether the view was requested as part of a user-initiated login.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   zone: string (required)
  ##       : Name of the zone for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   user: string (required)
  ##       : The user account for which you want to get a list of authorized public keys.
  ##   instance: string (required)
  ##           : The fully-qualified URL of the virtual machine requesting the view.
  var path_579170 = newJObject()
  var query_579171 = newJObject()
  add(query_579171, "key", newJString(key))
  add(query_579171, "prettyPrint", newJBool(prettyPrint))
  add(query_579171, "oauth_token", newJString(oauthToken))
  add(query_579171, "alt", newJString(alt))
  add(query_579171, "userIp", newJString(userIp))
  add(query_579171, "login", newJBool(login))
  add(query_579171, "quotaUser", newJString(quotaUser))
  add(path_579170, "project", newJString(project))
  add(path_579170, "zone", newJString(zone))
  add(query_579171, "fields", newJString(fields))
  add(path_579170, "user", newJString(user))
  add(query_579171, "instance", newJString(instance))
  result = call_579169.call(path_579170, query_579171, nil, nil, nil)

var clouduseraccountsLinuxGetAuthorizedKeysView* = Call_ClouduseraccountsLinuxGetAuthorizedKeysView_579153(
    name: "clouduseraccountsLinuxGetAuthorizedKeysView",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/authorizedKeysView/{user}",
    validator: validate_ClouduseraccountsLinuxGetAuthorizedKeysView_579154,
    base: "/clouduseraccounts/beta/projects",
    url: url_ClouduseraccountsLinuxGetAuthorizedKeysView_579155,
    schemes: {Scheme.Https})
type
  Call_ClouduseraccountsLinuxGetLinuxAccountViews_579172 = ref object of OpenApiRestCall_578355
proc url_ClouduseraccountsLinuxGetLinuxAccountViews_579174(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/linuxAccountViews")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClouduseraccountsLinuxGetLinuxAccountViews_579173(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of user accounts for an instance within a specific project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : Project ID for this request.
  ##   zone: JString (required)
  ##       : Name of the zone for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_579175 = path.getOrDefault("project")
  valid_579175 = validateParameter(valid_579175, JString, required = true,
                                 default = nil)
  if valid_579175 != nil:
    section.add "project", valid_579175
  var valid_579176 = path.getOrDefault("zone")
  valid_579176 = validateParameter(valid_579176, JString, required = true,
                                 default = nil)
  if valid_579176 != nil:
    section.add "zone", valid_579176
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
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   orderBy: JString
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   filter: JString
  ##         : Sets a filter expression for filtering listed resources, in the form filter={expression}. Your {expression} must be in the format: field_name comparison_string literal_string.
  ## 
  ## The field_name is the name of the field you want to compare. Only atomic field types are supported (string, number, boolean). The comparison_string must be either eq (equals) or ne (not equals). The literal_string is the string value to filter to. The literal value must be valid for the type of field you are filtering by (string, number, boolean). For string fields, the literal value is interpreted as a regular expression using RE2 syntax. The literal value must match the entire field.
  ## 
  ## For example, to filter for instances that do not have a name of example-instance, you would use filter=name ne example-instance.
  ## 
  ## Compute Engine Beta API Only: If you use filtering in the Beta API, you can also filter on nested fields. For example, you could filter on instances that have set the scheduling.automaticRestart field to true. In particular, use filtering on nested fields to take advantage of instance labels to organize and filter results based on label values.
  ## 
  ## The Beta API also supports filtering on multiple expressions by providing each separate expression within parentheses. For example, (scheduling.automaticRestart eq true) (zone eq us-central1-f). Multiple expressions are treated as AND expressions, meaning that resources must match all expressions to pass the filters.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   instance: JString (required)
  ##           : The fully-qualified URL of the virtual machine requesting the views.
  ##   maxResults: JInt
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests.
  section = newJObject()
  var valid_579177 = query.getOrDefault("key")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = nil)
  if valid_579177 != nil:
    section.add "key", valid_579177
  var valid_579178 = query.getOrDefault("prettyPrint")
  valid_579178 = validateParameter(valid_579178, JBool, required = false,
                                 default = newJBool(true))
  if valid_579178 != nil:
    section.add "prettyPrint", valid_579178
  var valid_579179 = query.getOrDefault("oauth_token")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = nil)
  if valid_579179 != nil:
    section.add "oauth_token", valid_579179
  var valid_579180 = query.getOrDefault("alt")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = newJString("json"))
  if valid_579180 != nil:
    section.add "alt", valid_579180
  var valid_579181 = query.getOrDefault("userIp")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = nil)
  if valid_579181 != nil:
    section.add "userIp", valid_579181
  var valid_579182 = query.getOrDefault("quotaUser")
  valid_579182 = validateParameter(valid_579182, JString, required = false,
                                 default = nil)
  if valid_579182 != nil:
    section.add "quotaUser", valid_579182
  var valid_579183 = query.getOrDefault("orderBy")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = nil)
  if valid_579183 != nil:
    section.add "orderBy", valid_579183
  var valid_579184 = query.getOrDefault("filter")
  valid_579184 = validateParameter(valid_579184, JString, required = false,
                                 default = nil)
  if valid_579184 != nil:
    section.add "filter", valid_579184
  var valid_579185 = query.getOrDefault("pageToken")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = nil)
  if valid_579185 != nil:
    section.add "pageToken", valid_579185
  var valid_579186 = query.getOrDefault("fields")
  valid_579186 = validateParameter(valid_579186, JString, required = false,
                                 default = nil)
  if valid_579186 != nil:
    section.add "fields", valid_579186
  assert query != nil,
        "query argument is necessary due to required `instance` field"
  var valid_579187 = query.getOrDefault("instance")
  valid_579187 = validateParameter(valid_579187, JString, required = true,
                                 default = nil)
  if valid_579187 != nil:
    section.add "instance", valid_579187
  var valid_579188 = query.getOrDefault("maxResults")
  valid_579188 = validateParameter(valid_579188, JInt, required = false,
                                 default = newJInt(500))
  if valid_579188 != nil:
    section.add "maxResults", valid_579188
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579189: Call_ClouduseraccountsLinuxGetLinuxAccountViews_579172;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a list of user accounts for an instance within a specific project.
  ## 
  let valid = call_579189.validator(path, query, header, formData, body)
  let scheme = call_579189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579189.url(scheme.get, call_579189.host, call_579189.base,
                         call_579189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579189, url, valid)

proc call*(call_579190: Call_ClouduseraccountsLinuxGetLinuxAccountViews_579172;
          project: string; zone: string; instance: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; orderBy: string = "";
          filter: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 500): Recallable =
  ## clouduseraccountsLinuxGetLinuxAccountViews
  ## Retrieves a list of user accounts for an instance within a specific project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   orderBy: string
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   filter: string
  ##         : Sets a filter expression for filtering listed resources, in the form filter={expression}. Your {expression} must be in the format: field_name comparison_string literal_string.
  ## 
  ## The field_name is the name of the field you want to compare. Only atomic field types are supported (string, number, boolean). The comparison_string must be either eq (equals) or ne (not equals). The literal_string is the string value to filter to. The literal value must be valid for the type of field you are filtering by (string, number, boolean). For string fields, the literal value is interpreted as a regular expression using RE2 syntax. The literal value must match the entire field.
  ## 
  ## For example, to filter for instances that do not have a name of example-instance, you would use filter=name ne example-instance.
  ## 
  ## Compute Engine Beta API Only: If you use filtering in the Beta API, you can also filter on nested fields. For example, you could filter on instances that have set the scheduling.automaticRestart field to true. In particular, use filtering on nested fields to take advantage of instance labels to organize and filter results based on label values.
  ## 
  ## The Beta API also supports filtering on multiple expressions by providing each separate expression within parentheses. For example, (scheduling.automaticRestart eq true) (zone eq us-central1-f). Multiple expressions are treated as AND expressions, meaning that resources must match all expressions to pass the filters.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   zone: string (required)
  ##       : Name of the zone for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   instance: string (required)
  ##           : The fully-qualified URL of the virtual machine requesting the views.
  ##   maxResults: int
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests.
  var path_579191 = newJObject()
  var query_579192 = newJObject()
  add(query_579192, "key", newJString(key))
  add(query_579192, "prettyPrint", newJBool(prettyPrint))
  add(query_579192, "oauth_token", newJString(oauthToken))
  add(query_579192, "alt", newJString(alt))
  add(query_579192, "userIp", newJString(userIp))
  add(query_579192, "quotaUser", newJString(quotaUser))
  add(query_579192, "orderBy", newJString(orderBy))
  add(query_579192, "filter", newJString(filter))
  add(query_579192, "pageToken", newJString(pageToken))
  add(path_579191, "project", newJString(project))
  add(path_579191, "zone", newJString(zone))
  add(query_579192, "fields", newJString(fields))
  add(query_579192, "instance", newJString(instance))
  add(query_579192, "maxResults", newJInt(maxResults))
  result = call_579190.call(path_579191, query_579192, nil, nil, nil)

var clouduseraccountsLinuxGetLinuxAccountViews* = Call_ClouduseraccountsLinuxGetLinuxAccountViews_579172(
    name: "clouduseraccountsLinuxGetLinuxAccountViews", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/linuxAccountViews",
    validator: validate_ClouduseraccountsLinuxGetLinuxAccountViews_579173,
    base: "/clouduseraccounts/beta/projects",
    url: url_ClouduseraccountsLinuxGetLinuxAccountViews_579174,
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
