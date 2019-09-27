
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Cloud User Accounts
## version: alpha
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

  OpenApiRestCall_597424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597424): Option[Scheme] {.used.} =
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
  gcpServiceName = "clouduseraccounts"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ClouduseraccountsGroupsInsert_597981 = ref object of OpenApiRestCall_597424
proc url_ClouduseraccountsGroupsInsert_597983(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClouduseraccountsGroupsInsert_597982(path: JsonNode; query: JsonNode;
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
  var valid_597984 = path.getOrDefault("project")
  valid_597984 = validateParameter(valid_597984, JString, required = true,
                                 default = nil)
  if valid_597984 != nil:
    section.add "project", valid_597984
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_597985 = query.getOrDefault("fields")
  valid_597985 = validateParameter(valid_597985, JString, required = false,
                                 default = nil)
  if valid_597985 != nil:
    section.add "fields", valid_597985
  var valid_597986 = query.getOrDefault("quotaUser")
  valid_597986 = validateParameter(valid_597986, JString, required = false,
                                 default = nil)
  if valid_597986 != nil:
    section.add "quotaUser", valid_597986
  var valid_597987 = query.getOrDefault("alt")
  valid_597987 = validateParameter(valid_597987, JString, required = false,
                                 default = newJString("json"))
  if valid_597987 != nil:
    section.add "alt", valid_597987
  var valid_597988 = query.getOrDefault("oauth_token")
  valid_597988 = validateParameter(valid_597988, JString, required = false,
                                 default = nil)
  if valid_597988 != nil:
    section.add "oauth_token", valid_597988
  var valid_597989 = query.getOrDefault("userIp")
  valid_597989 = validateParameter(valid_597989, JString, required = false,
                                 default = nil)
  if valid_597989 != nil:
    section.add "userIp", valid_597989
  var valid_597990 = query.getOrDefault("key")
  valid_597990 = validateParameter(valid_597990, JString, required = false,
                                 default = nil)
  if valid_597990 != nil:
    section.add "key", valid_597990
  var valid_597991 = query.getOrDefault("prettyPrint")
  valid_597991 = validateParameter(valid_597991, JBool, required = false,
                                 default = newJBool(true))
  if valid_597991 != nil:
    section.add "prettyPrint", valid_597991
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

proc call*(call_597993: Call_ClouduseraccountsGroupsInsert_597981; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Group resource in the specified project using the data included in the request.
  ## 
  let valid = call_597993.validator(path, query, header, formData, body)
  let scheme = call_597993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597993.url(scheme.get, call_597993.host, call_597993.base,
                         call_597993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597993, url, valid)

proc call*(call_597994: Call_ClouduseraccountsGroupsInsert_597981; project: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## clouduseraccountsGroupsInsert
  ## Creates a Group resource in the specified project using the data included in the request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_597995 = newJObject()
  var query_597996 = newJObject()
  var body_597997 = newJObject()
  add(query_597996, "fields", newJString(fields))
  add(query_597996, "quotaUser", newJString(quotaUser))
  add(query_597996, "alt", newJString(alt))
  add(query_597996, "oauth_token", newJString(oauthToken))
  add(query_597996, "userIp", newJString(userIp))
  add(query_597996, "key", newJString(key))
  add(path_597995, "project", newJString(project))
  if body != nil:
    body_597997 = body
  add(query_597996, "prettyPrint", newJBool(prettyPrint))
  result = call_597994.call(path_597995, query_597996, nil, nil, body_597997)

var clouduseraccountsGroupsInsert* = Call_ClouduseraccountsGroupsInsert_597981(
    name: "clouduseraccountsGroupsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/global/groups",
    validator: validate_ClouduseraccountsGroupsInsert_597982,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsGroupsInsert_597983, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGroupsList_597692 = ref object of OpenApiRestCall_597424
proc url_ClouduseraccountsGroupsList_597694(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClouduseraccountsGroupsList_597693(path: JsonNode; query: JsonNode;
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
  var valid_597820 = path.getOrDefault("project")
  valid_597820 = validateParameter(valid_597820, JString, required = true,
                                 default = nil)
  if valid_597820 != nil:
    section.add "project", valid_597820
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests.
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
  ##         : Sets a filter expression for filtering listed resources, in the form filter={expression}. Your {expression} must be in the format: field_name comparison_string literal_string.
  ## 
  ## The field_name is the name of the field you want to compare. Only atomic field types are supported (string, number, boolean). The comparison_string must be either eq (equals) or ne (not equals). The literal_string is the string value to filter to. The literal value must be valid for the type of field you are filtering by (string, number, boolean). For string fields, the literal value is interpreted as a regular expression using RE2 syntax. The literal value must match the entire field.
  ## 
  ## For example, to filter for instances that do not have a name of example-instance, you would use filter=name ne example-instance.
  ## 
  ## Compute Engine Beta API Only: If you use filtering in the Beta API, you can also filter on nested fields. For example, you could filter on instances that have set the scheduling.automaticRestart field to true. In particular, use filtering on nested fields to take advantage of instance labels to organize and filter results based on label values.
  ## 
  ## The Beta API also supports filtering on multiple expressions by providing each separate expression within parentheses. For example, (scheduling.automaticRestart eq true) (zone eq us-central1-f). Multiple expressions are treated as AND expressions, meaning that resources must match all expressions to pass the filters.
  section = newJObject()
  var valid_597821 = query.getOrDefault("fields")
  valid_597821 = validateParameter(valid_597821, JString, required = false,
                                 default = nil)
  if valid_597821 != nil:
    section.add "fields", valid_597821
  var valid_597822 = query.getOrDefault("pageToken")
  valid_597822 = validateParameter(valid_597822, JString, required = false,
                                 default = nil)
  if valid_597822 != nil:
    section.add "pageToken", valid_597822
  var valid_597823 = query.getOrDefault("quotaUser")
  valid_597823 = validateParameter(valid_597823, JString, required = false,
                                 default = nil)
  if valid_597823 != nil:
    section.add "quotaUser", valid_597823
  var valid_597837 = query.getOrDefault("alt")
  valid_597837 = validateParameter(valid_597837, JString, required = false,
                                 default = newJString("json"))
  if valid_597837 != nil:
    section.add "alt", valid_597837
  var valid_597838 = query.getOrDefault("oauth_token")
  valid_597838 = validateParameter(valid_597838, JString, required = false,
                                 default = nil)
  if valid_597838 != nil:
    section.add "oauth_token", valid_597838
  var valid_597839 = query.getOrDefault("userIp")
  valid_597839 = validateParameter(valid_597839, JString, required = false,
                                 default = nil)
  if valid_597839 != nil:
    section.add "userIp", valid_597839
  var valid_597841 = query.getOrDefault("maxResults")
  valid_597841 = validateParameter(valid_597841, JInt, required = false,
                                 default = newJInt(500))
  if valid_597841 != nil:
    section.add "maxResults", valid_597841
  var valid_597842 = query.getOrDefault("orderBy")
  valid_597842 = validateParameter(valid_597842, JString, required = false,
                                 default = nil)
  if valid_597842 != nil:
    section.add "orderBy", valid_597842
  var valid_597843 = query.getOrDefault("key")
  valid_597843 = validateParameter(valid_597843, JString, required = false,
                                 default = nil)
  if valid_597843 != nil:
    section.add "key", valid_597843
  var valid_597844 = query.getOrDefault("prettyPrint")
  valid_597844 = validateParameter(valid_597844, JBool, required = false,
                                 default = newJBool(true))
  if valid_597844 != nil:
    section.add "prettyPrint", valid_597844
  var valid_597845 = query.getOrDefault("filter")
  valid_597845 = validateParameter(valid_597845, JString, required = false,
                                 default = nil)
  if valid_597845 != nil:
    section.add "filter", valid_597845
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597868: Call_ClouduseraccountsGroupsList_597692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of groups contained within the specified project.
  ## 
  let valid = call_597868.validator(path, query, header, formData, body)
  let scheme = call_597868.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597868.url(scheme.get, call_597868.host, call_597868.base,
                         call_597868.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597868, url, valid)

proc call*(call_597939: Call_ClouduseraccountsGroupsList_597692; project: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 500; orderBy: string = ""; key: string = "";
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## clouduseraccountsGroupsList
  ## Retrieves the list of groups contained within the specified project.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests.
  ##   orderBy: string
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
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
  var path_597940 = newJObject()
  var query_597942 = newJObject()
  add(query_597942, "fields", newJString(fields))
  add(query_597942, "pageToken", newJString(pageToken))
  add(query_597942, "quotaUser", newJString(quotaUser))
  add(query_597942, "alt", newJString(alt))
  add(query_597942, "oauth_token", newJString(oauthToken))
  add(query_597942, "userIp", newJString(userIp))
  add(query_597942, "maxResults", newJInt(maxResults))
  add(query_597942, "orderBy", newJString(orderBy))
  add(query_597942, "key", newJString(key))
  add(path_597940, "project", newJString(project))
  add(query_597942, "prettyPrint", newJBool(prettyPrint))
  add(query_597942, "filter", newJString(filter))
  result = call_597939.call(path_597940, query_597942, nil, nil, nil)

var clouduseraccountsGroupsList* = Call_ClouduseraccountsGroupsList_597692(
    name: "clouduseraccountsGroupsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/groups",
    validator: validate_ClouduseraccountsGroupsList_597693,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsGroupsList_597694, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGroupsGet_597998 = ref object of OpenApiRestCall_597424
proc url_ClouduseraccountsGroupsGet_598000(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClouduseraccountsGroupsGet_597999(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the specified Group resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupName: JString (required)
  ##            : Name of the Group resource to return.
  ##   project: JString (required)
  ##          : Project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupName` field"
  var valid_598001 = path.getOrDefault("groupName")
  valid_598001 = validateParameter(valid_598001, JString, required = true,
                                 default = nil)
  if valid_598001 != nil:
    section.add "groupName", valid_598001
  var valid_598002 = path.getOrDefault("project")
  valid_598002 = validateParameter(valid_598002, JString, required = true,
                                 default = nil)
  if valid_598002 != nil:
    section.add "project", valid_598002
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598003 = query.getOrDefault("fields")
  valid_598003 = validateParameter(valid_598003, JString, required = false,
                                 default = nil)
  if valid_598003 != nil:
    section.add "fields", valid_598003
  var valid_598004 = query.getOrDefault("quotaUser")
  valid_598004 = validateParameter(valid_598004, JString, required = false,
                                 default = nil)
  if valid_598004 != nil:
    section.add "quotaUser", valid_598004
  var valid_598005 = query.getOrDefault("alt")
  valid_598005 = validateParameter(valid_598005, JString, required = false,
                                 default = newJString("json"))
  if valid_598005 != nil:
    section.add "alt", valid_598005
  var valid_598006 = query.getOrDefault("oauth_token")
  valid_598006 = validateParameter(valid_598006, JString, required = false,
                                 default = nil)
  if valid_598006 != nil:
    section.add "oauth_token", valid_598006
  var valid_598007 = query.getOrDefault("userIp")
  valid_598007 = validateParameter(valid_598007, JString, required = false,
                                 default = nil)
  if valid_598007 != nil:
    section.add "userIp", valid_598007
  var valid_598008 = query.getOrDefault("key")
  valid_598008 = validateParameter(valid_598008, JString, required = false,
                                 default = nil)
  if valid_598008 != nil:
    section.add "key", valid_598008
  var valid_598009 = query.getOrDefault("prettyPrint")
  valid_598009 = validateParameter(valid_598009, JBool, required = false,
                                 default = newJBool(true))
  if valid_598009 != nil:
    section.add "prettyPrint", valid_598009
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598010: Call_ClouduseraccountsGroupsGet_597998; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specified Group resource.
  ## 
  let valid = call_598010.validator(path, query, header, formData, body)
  let scheme = call_598010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598010.url(scheme.get, call_598010.host, call_598010.base,
                         call_598010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598010, url, valid)

proc call*(call_598011: Call_ClouduseraccountsGroupsGet_597998; groupName: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## clouduseraccountsGroupsGet
  ## Returns the specified Group resource.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   groupName: string (required)
  ##            : Name of the Group resource to return.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598012 = newJObject()
  var query_598013 = newJObject()
  add(query_598013, "fields", newJString(fields))
  add(query_598013, "quotaUser", newJString(quotaUser))
  add(query_598013, "alt", newJString(alt))
  add(query_598013, "oauth_token", newJString(oauthToken))
  add(path_598012, "groupName", newJString(groupName))
  add(query_598013, "userIp", newJString(userIp))
  add(query_598013, "key", newJString(key))
  add(path_598012, "project", newJString(project))
  add(query_598013, "prettyPrint", newJBool(prettyPrint))
  result = call_598011.call(path_598012, query_598013, nil, nil, nil)

var clouduseraccountsGroupsGet* = Call_ClouduseraccountsGroupsGet_597998(
    name: "clouduseraccountsGroupsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/groups/{groupName}",
    validator: validate_ClouduseraccountsGroupsGet_597999,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsGroupsGet_598000, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGroupsDelete_598014 = ref object of OpenApiRestCall_597424
proc url_ClouduseraccountsGroupsDelete_598016(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClouduseraccountsGroupsDelete_598015(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified Group resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupName: JString (required)
  ##            : Name of the Group resource to delete.
  ##   project: JString (required)
  ##          : Project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupName` field"
  var valid_598017 = path.getOrDefault("groupName")
  valid_598017 = validateParameter(valid_598017, JString, required = true,
                                 default = nil)
  if valid_598017 != nil:
    section.add "groupName", valid_598017
  var valid_598018 = path.getOrDefault("project")
  valid_598018 = validateParameter(valid_598018, JString, required = true,
                                 default = nil)
  if valid_598018 != nil:
    section.add "project", valid_598018
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598019 = query.getOrDefault("fields")
  valid_598019 = validateParameter(valid_598019, JString, required = false,
                                 default = nil)
  if valid_598019 != nil:
    section.add "fields", valid_598019
  var valid_598020 = query.getOrDefault("quotaUser")
  valid_598020 = validateParameter(valid_598020, JString, required = false,
                                 default = nil)
  if valid_598020 != nil:
    section.add "quotaUser", valid_598020
  var valid_598021 = query.getOrDefault("alt")
  valid_598021 = validateParameter(valid_598021, JString, required = false,
                                 default = newJString("json"))
  if valid_598021 != nil:
    section.add "alt", valid_598021
  var valid_598022 = query.getOrDefault("oauth_token")
  valid_598022 = validateParameter(valid_598022, JString, required = false,
                                 default = nil)
  if valid_598022 != nil:
    section.add "oauth_token", valid_598022
  var valid_598023 = query.getOrDefault("userIp")
  valid_598023 = validateParameter(valid_598023, JString, required = false,
                                 default = nil)
  if valid_598023 != nil:
    section.add "userIp", valid_598023
  var valid_598024 = query.getOrDefault("key")
  valid_598024 = validateParameter(valid_598024, JString, required = false,
                                 default = nil)
  if valid_598024 != nil:
    section.add "key", valid_598024
  var valid_598025 = query.getOrDefault("prettyPrint")
  valid_598025 = validateParameter(valid_598025, JBool, required = false,
                                 default = newJBool(true))
  if valid_598025 != nil:
    section.add "prettyPrint", valid_598025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598026: Call_ClouduseraccountsGroupsDelete_598014; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified Group resource.
  ## 
  let valid = call_598026.validator(path, query, header, formData, body)
  let scheme = call_598026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598026.url(scheme.get, call_598026.host, call_598026.base,
                         call_598026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598026, url, valid)

proc call*(call_598027: Call_ClouduseraccountsGroupsDelete_598014;
          groupName: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## clouduseraccountsGroupsDelete
  ## Deletes the specified Group resource.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   groupName: string (required)
  ##            : Name of the Group resource to delete.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598028 = newJObject()
  var query_598029 = newJObject()
  add(query_598029, "fields", newJString(fields))
  add(query_598029, "quotaUser", newJString(quotaUser))
  add(query_598029, "alt", newJString(alt))
  add(query_598029, "oauth_token", newJString(oauthToken))
  add(path_598028, "groupName", newJString(groupName))
  add(query_598029, "userIp", newJString(userIp))
  add(query_598029, "key", newJString(key))
  add(path_598028, "project", newJString(project))
  add(query_598029, "prettyPrint", newJBool(prettyPrint))
  result = call_598027.call(path_598028, query_598029, nil, nil, nil)

var clouduseraccountsGroupsDelete* = Call_ClouduseraccountsGroupsDelete_598014(
    name: "clouduseraccountsGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{project}/global/groups/{groupName}",
    validator: validate_ClouduseraccountsGroupsDelete_598015,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsGroupsDelete_598016, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGroupsAddMember_598030 = ref object of OpenApiRestCall_597424
proc url_ClouduseraccountsGroupsAddMember_598032(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClouduseraccountsGroupsAddMember_598031(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds users to the specified group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupName: JString (required)
  ##            : Name of the group for this request.
  ##   project: JString (required)
  ##          : Project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupName` field"
  var valid_598033 = path.getOrDefault("groupName")
  valid_598033 = validateParameter(valid_598033, JString, required = true,
                                 default = nil)
  if valid_598033 != nil:
    section.add "groupName", valid_598033
  var valid_598034 = path.getOrDefault("project")
  valid_598034 = validateParameter(valid_598034, JString, required = true,
                                 default = nil)
  if valid_598034 != nil:
    section.add "project", valid_598034
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598035 = query.getOrDefault("fields")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = nil)
  if valid_598035 != nil:
    section.add "fields", valid_598035
  var valid_598036 = query.getOrDefault("quotaUser")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = nil)
  if valid_598036 != nil:
    section.add "quotaUser", valid_598036
  var valid_598037 = query.getOrDefault("alt")
  valid_598037 = validateParameter(valid_598037, JString, required = false,
                                 default = newJString("json"))
  if valid_598037 != nil:
    section.add "alt", valid_598037
  var valid_598038 = query.getOrDefault("oauth_token")
  valid_598038 = validateParameter(valid_598038, JString, required = false,
                                 default = nil)
  if valid_598038 != nil:
    section.add "oauth_token", valid_598038
  var valid_598039 = query.getOrDefault("userIp")
  valid_598039 = validateParameter(valid_598039, JString, required = false,
                                 default = nil)
  if valid_598039 != nil:
    section.add "userIp", valid_598039
  var valid_598040 = query.getOrDefault("key")
  valid_598040 = validateParameter(valid_598040, JString, required = false,
                                 default = nil)
  if valid_598040 != nil:
    section.add "key", valid_598040
  var valid_598041 = query.getOrDefault("prettyPrint")
  valid_598041 = validateParameter(valid_598041, JBool, required = false,
                                 default = newJBool(true))
  if valid_598041 != nil:
    section.add "prettyPrint", valid_598041
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

proc call*(call_598043: Call_ClouduseraccountsGroupsAddMember_598030;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds users to the specified group.
  ## 
  let valid = call_598043.validator(path, query, header, formData, body)
  let scheme = call_598043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598043.url(scheme.get, call_598043.host, call_598043.base,
                         call_598043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598043, url, valid)

proc call*(call_598044: Call_ClouduseraccountsGroupsAddMember_598030;
          groupName: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## clouduseraccountsGroupsAddMember
  ## Adds users to the specified group.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   groupName: string (required)
  ##            : Name of the group for this request.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598045 = newJObject()
  var query_598046 = newJObject()
  var body_598047 = newJObject()
  add(query_598046, "fields", newJString(fields))
  add(query_598046, "quotaUser", newJString(quotaUser))
  add(query_598046, "alt", newJString(alt))
  add(query_598046, "oauth_token", newJString(oauthToken))
  add(path_598045, "groupName", newJString(groupName))
  add(query_598046, "userIp", newJString(userIp))
  add(query_598046, "key", newJString(key))
  add(path_598045, "project", newJString(project))
  if body != nil:
    body_598047 = body
  add(query_598046, "prettyPrint", newJBool(prettyPrint))
  result = call_598044.call(path_598045, query_598046, nil, nil, body_598047)

var clouduseraccountsGroupsAddMember* = Call_ClouduseraccountsGroupsAddMember_598030(
    name: "clouduseraccountsGroupsAddMember", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/groups/{groupName}/addMember",
    validator: validate_ClouduseraccountsGroupsAddMember_598031,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsGroupsAddMember_598032, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGroupsRemoveMember_598048 = ref object of OpenApiRestCall_597424
proc url_ClouduseraccountsGroupsRemoveMember_598050(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClouduseraccountsGroupsRemoveMember_598049(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes users from the specified group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupName: JString (required)
  ##            : Name of the group for this request.
  ##   project: JString (required)
  ##          : Project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupName` field"
  var valid_598051 = path.getOrDefault("groupName")
  valid_598051 = validateParameter(valid_598051, JString, required = true,
                                 default = nil)
  if valid_598051 != nil:
    section.add "groupName", valid_598051
  var valid_598052 = path.getOrDefault("project")
  valid_598052 = validateParameter(valid_598052, JString, required = true,
                                 default = nil)
  if valid_598052 != nil:
    section.add "project", valid_598052
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598053 = query.getOrDefault("fields")
  valid_598053 = validateParameter(valid_598053, JString, required = false,
                                 default = nil)
  if valid_598053 != nil:
    section.add "fields", valid_598053
  var valid_598054 = query.getOrDefault("quotaUser")
  valid_598054 = validateParameter(valid_598054, JString, required = false,
                                 default = nil)
  if valid_598054 != nil:
    section.add "quotaUser", valid_598054
  var valid_598055 = query.getOrDefault("alt")
  valid_598055 = validateParameter(valid_598055, JString, required = false,
                                 default = newJString("json"))
  if valid_598055 != nil:
    section.add "alt", valid_598055
  var valid_598056 = query.getOrDefault("oauth_token")
  valid_598056 = validateParameter(valid_598056, JString, required = false,
                                 default = nil)
  if valid_598056 != nil:
    section.add "oauth_token", valid_598056
  var valid_598057 = query.getOrDefault("userIp")
  valid_598057 = validateParameter(valid_598057, JString, required = false,
                                 default = nil)
  if valid_598057 != nil:
    section.add "userIp", valid_598057
  var valid_598058 = query.getOrDefault("key")
  valid_598058 = validateParameter(valid_598058, JString, required = false,
                                 default = nil)
  if valid_598058 != nil:
    section.add "key", valid_598058
  var valid_598059 = query.getOrDefault("prettyPrint")
  valid_598059 = validateParameter(valid_598059, JBool, required = false,
                                 default = newJBool(true))
  if valid_598059 != nil:
    section.add "prettyPrint", valid_598059
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

proc call*(call_598061: Call_ClouduseraccountsGroupsRemoveMember_598048;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes users from the specified group.
  ## 
  let valid = call_598061.validator(path, query, header, formData, body)
  let scheme = call_598061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598061.url(scheme.get, call_598061.host, call_598061.base,
                         call_598061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598061, url, valid)

proc call*(call_598062: Call_ClouduseraccountsGroupsRemoveMember_598048;
          groupName: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## clouduseraccountsGroupsRemoveMember
  ## Removes users from the specified group.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   groupName: string (required)
  ##            : Name of the group for this request.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598063 = newJObject()
  var query_598064 = newJObject()
  var body_598065 = newJObject()
  add(query_598064, "fields", newJString(fields))
  add(query_598064, "quotaUser", newJString(quotaUser))
  add(query_598064, "alt", newJString(alt))
  add(query_598064, "oauth_token", newJString(oauthToken))
  add(path_598063, "groupName", newJString(groupName))
  add(query_598064, "userIp", newJString(userIp))
  add(query_598064, "key", newJString(key))
  add(path_598063, "project", newJString(project))
  if body != nil:
    body_598065 = body
  add(query_598064, "prettyPrint", newJBool(prettyPrint))
  result = call_598062.call(path_598063, query_598064, nil, nil, body_598065)

var clouduseraccountsGroupsRemoveMember* = Call_ClouduseraccountsGroupsRemoveMember_598048(
    name: "clouduseraccountsGroupsRemoveMember", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/groups/{groupName}/removeMember",
    validator: validate_ClouduseraccountsGroupsRemoveMember_598049,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsGroupsRemoveMember_598050, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGroupsGetIamPolicy_598066 = ref object of OpenApiRestCall_597424
proc url_ClouduseraccountsGroupsGetIamPolicy_598068(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/groups/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: "/getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClouduseraccountsGroupsGetIamPolicy_598067(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the access control policy for a resource. May be empty if no such policy or resource exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Name of the resource for this request.
  ##   project: JString (required)
  ##          : Project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_598069 = path.getOrDefault("resource")
  valid_598069 = validateParameter(valid_598069, JString, required = true,
                                 default = nil)
  if valid_598069 != nil:
    section.add "resource", valid_598069
  var valid_598070 = path.getOrDefault("project")
  valid_598070 = validateParameter(valid_598070, JString, required = true,
                                 default = nil)
  if valid_598070 != nil:
    section.add "project", valid_598070
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598071 = query.getOrDefault("fields")
  valid_598071 = validateParameter(valid_598071, JString, required = false,
                                 default = nil)
  if valid_598071 != nil:
    section.add "fields", valid_598071
  var valid_598072 = query.getOrDefault("quotaUser")
  valid_598072 = validateParameter(valid_598072, JString, required = false,
                                 default = nil)
  if valid_598072 != nil:
    section.add "quotaUser", valid_598072
  var valid_598073 = query.getOrDefault("alt")
  valid_598073 = validateParameter(valid_598073, JString, required = false,
                                 default = newJString("json"))
  if valid_598073 != nil:
    section.add "alt", valid_598073
  var valid_598074 = query.getOrDefault("oauth_token")
  valid_598074 = validateParameter(valid_598074, JString, required = false,
                                 default = nil)
  if valid_598074 != nil:
    section.add "oauth_token", valid_598074
  var valid_598075 = query.getOrDefault("userIp")
  valid_598075 = validateParameter(valid_598075, JString, required = false,
                                 default = nil)
  if valid_598075 != nil:
    section.add "userIp", valid_598075
  var valid_598076 = query.getOrDefault("key")
  valid_598076 = validateParameter(valid_598076, JString, required = false,
                                 default = nil)
  if valid_598076 != nil:
    section.add "key", valid_598076
  var valid_598077 = query.getOrDefault("prettyPrint")
  valid_598077 = validateParameter(valid_598077, JBool, required = false,
                                 default = newJBool(true))
  if valid_598077 != nil:
    section.add "prettyPrint", valid_598077
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598078: Call_ClouduseraccountsGroupsGetIamPolicy_598066;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource. May be empty if no such policy or resource exists.
  ## 
  let valid = call_598078.validator(path, query, header, formData, body)
  let scheme = call_598078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598078.url(scheme.get, call_598078.host, call_598078.base,
                         call_598078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598078, url, valid)

proc call*(call_598079: Call_ClouduseraccountsGroupsGetIamPolicy_598066;
          resource: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## clouduseraccountsGroupsGetIamPolicy
  ## Gets the access control policy for a resource. May be empty if no such policy or resource exists.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   resource: string (required)
  ##           : Name of the resource for this request.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598080 = newJObject()
  var query_598081 = newJObject()
  add(query_598081, "fields", newJString(fields))
  add(query_598081, "quotaUser", newJString(quotaUser))
  add(query_598081, "alt", newJString(alt))
  add(query_598081, "oauth_token", newJString(oauthToken))
  add(query_598081, "userIp", newJString(userIp))
  add(query_598081, "key", newJString(key))
  add(path_598080, "resource", newJString(resource))
  add(path_598080, "project", newJString(project))
  add(query_598081, "prettyPrint", newJBool(prettyPrint))
  result = call_598079.call(path_598080, query_598081, nil, nil, nil)

var clouduseraccountsGroupsGetIamPolicy* = Call_ClouduseraccountsGroupsGetIamPolicy_598066(
    name: "clouduseraccountsGroupsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/groups/{resource}/getIamPolicy",
    validator: validate_ClouduseraccountsGroupsGetIamPolicy_598067,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsGroupsGetIamPolicy_598068, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGroupsSetIamPolicy_598082 = ref object of OpenApiRestCall_597424
proc url_ClouduseraccountsGroupsSetIamPolicy_598084(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/groups/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: "/setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClouduseraccountsGroupsSetIamPolicy_598083(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the access control policy on the specified resource. Replaces any existing policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Name of the resource for this request.
  ##   project: JString (required)
  ##          : Project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_598085 = path.getOrDefault("resource")
  valid_598085 = validateParameter(valid_598085, JString, required = true,
                                 default = nil)
  if valid_598085 != nil:
    section.add "resource", valid_598085
  var valid_598086 = path.getOrDefault("project")
  valid_598086 = validateParameter(valid_598086, JString, required = true,
                                 default = nil)
  if valid_598086 != nil:
    section.add "project", valid_598086
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598087 = query.getOrDefault("fields")
  valid_598087 = validateParameter(valid_598087, JString, required = false,
                                 default = nil)
  if valid_598087 != nil:
    section.add "fields", valid_598087
  var valid_598088 = query.getOrDefault("quotaUser")
  valid_598088 = validateParameter(valid_598088, JString, required = false,
                                 default = nil)
  if valid_598088 != nil:
    section.add "quotaUser", valid_598088
  var valid_598089 = query.getOrDefault("alt")
  valid_598089 = validateParameter(valid_598089, JString, required = false,
                                 default = newJString("json"))
  if valid_598089 != nil:
    section.add "alt", valid_598089
  var valid_598090 = query.getOrDefault("oauth_token")
  valid_598090 = validateParameter(valid_598090, JString, required = false,
                                 default = nil)
  if valid_598090 != nil:
    section.add "oauth_token", valid_598090
  var valid_598091 = query.getOrDefault("userIp")
  valid_598091 = validateParameter(valid_598091, JString, required = false,
                                 default = nil)
  if valid_598091 != nil:
    section.add "userIp", valid_598091
  var valid_598092 = query.getOrDefault("key")
  valid_598092 = validateParameter(valid_598092, JString, required = false,
                                 default = nil)
  if valid_598092 != nil:
    section.add "key", valid_598092
  var valid_598093 = query.getOrDefault("prettyPrint")
  valid_598093 = validateParameter(valid_598093, JBool, required = false,
                                 default = newJBool(true))
  if valid_598093 != nil:
    section.add "prettyPrint", valid_598093
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

proc call*(call_598095: Call_ClouduseraccountsGroupsSetIamPolicy_598082;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any existing policy.
  ## 
  let valid = call_598095.validator(path, query, header, formData, body)
  let scheme = call_598095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598095.url(scheme.get, call_598095.host, call_598095.base,
                         call_598095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598095, url, valid)

proc call*(call_598096: Call_ClouduseraccountsGroupsSetIamPolicy_598082;
          resource: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## clouduseraccountsGroupsSetIamPolicy
  ## Sets the access control policy on the specified resource. Replaces any existing policy.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   resource: string (required)
  ##           : Name of the resource for this request.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598097 = newJObject()
  var query_598098 = newJObject()
  var body_598099 = newJObject()
  add(query_598098, "fields", newJString(fields))
  add(query_598098, "quotaUser", newJString(quotaUser))
  add(query_598098, "alt", newJString(alt))
  add(query_598098, "oauth_token", newJString(oauthToken))
  add(query_598098, "userIp", newJString(userIp))
  add(query_598098, "key", newJString(key))
  add(path_598097, "resource", newJString(resource))
  add(path_598097, "project", newJString(project))
  if body != nil:
    body_598099 = body
  add(query_598098, "prettyPrint", newJBool(prettyPrint))
  result = call_598096.call(path_598097, query_598098, nil, nil, body_598099)

var clouduseraccountsGroupsSetIamPolicy* = Call_ClouduseraccountsGroupsSetIamPolicy_598082(
    name: "clouduseraccountsGroupsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/groups/{resource}/setIamPolicy",
    validator: validate_ClouduseraccountsGroupsSetIamPolicy_598083,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsGroupsSetIamPolicy_598084, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGroupsTestIamPermissions_598100 = ref object of OpenApiRestCall_597424
proc url_ClouduseraccountsGroupsTestIamPermissions_598102(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/groups/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: "/testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClouduseraccountsGroupsTestIamPermissions_598101(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns permissions that a caller has on the specified resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Name of the resource for this request.
  ##   project: JString (required)
  ##          : Project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_598103 = path.getOrDefault("resource")
  valid_598103 = validateParameter(valid_598103, JString, required = true,
                                 default = nil)
  if valid_598103 != nil:
    section.add "resource", valid_598103
  var valid_598104 = path.getOrDefault("project")
  valid_598104 = validateParameter(valid_598104, JString, required = true,
                                 default = nil)
  if valid_598104 != nil:
    section.add "project", valid_598104
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598105 = query.getOrDefault("fields")
  valid_598105 = validateParameter(valid_598105, JString, required = false,
                                 default = nil)
  if valid_598105 != nil:
    section.add "fields", valid_598105
  var valid_598106 = query.getOrDefault("quotaUser")
  valid_598106 = validateParameter(valid_598106, JString, required = false,
                                 default = nil)
  if valid_598106 != nil:
    section.add "quotaUser", valid_598106
  var valid_598107 = query.getOrDefault("alt")
  valid_598107 = validateParameter(valid_598107, JString, required = false,
                                 default = newJString("json"))
  if valid_598107 != nil:
    section.add "alt", valid_598107
  var valid_598108 = query.getOrDefault("oauth_token")
  valid_598108 = validateParameter(valid_598108, JString, required = false,
                                 default = nil)
  if valid_598108 != nil:
    section.add "oauth_token", valid_598108
  var valid_598109 = query.getOrDefault("userIp")
  valid_598109 = validateParameter(valid_598109, JString, required = false,
                                 default = nil)
  if valid_598109 != nil:
    section.add "userIp", valid_598109
  var valid_598110 = query.getOrDefault("key")
  valid_598110 = validateParameter(valid_598110, JString, required = false,
                                 default = nil)
  if valid_598110 != nil:
    section.add "key", valid_598110
  var valid_598111 = query.getOrDefault("prettyPrint")
  valid_598111 = validateParameter(valid_598111, JBool, required = false,
                                 default = newJBool(true))
  if valid_598111 != nil:
    section.add "prettyPrint", valid_598111
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

proc call*(call_598113: Call_ClouduseraccountsGroupsTestIamPermissions_598100;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified resource.
  ## 
  let valid = call_598113.validator(path, query, header, formData, body)
  let scheme = call_598113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598113.url(scheme.get, call_598113.host, call_598113.base,
                         call_598113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598113, url, valid)

proc call*(call_598114: Call_ClouduseraccountsGroupsTestIamPermissions_598100;
          resource: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## clouduseraccountsGroupsTestIamPermissions
  ## Returns permissions that a caller has on the specified resource.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   resource: string (required)
  ##           : Name of the resource for this request.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598115 = newJObject()
  var query_598116 = newJObject()
  var body_598117 = newJObject()
  add(query_598116, "fields", newJString(fields))
  add(query_598116, "quotaUser", newJString(quotaUser))
  add(query_598116, "alt", newJString(alt))
  add(query_598116, "oauth_token", newJString(oauthToken))
  add(query_598116, "userIp", newJString(userIp))
  add(query_598116, "key", newJString(key))
  add(path_598115, "resource", newJString(resource))
  add(path_598115, "project", newJString(project))
  if body != nil:
    body_598117 = body
  add(query_598116, "prettyPrint", newJBool(prettyPrint))
  result = call_598114.call(path_598115, query_598116, nil, nil, body_598117)

var clouduseraccountsGroupsTestIamPermissions* = Call_ClouduseraccountsGroupsTestIamPermissions_598100(
    name: "clouduseraccountsGroupsTestIamPermissions", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/groups/{resource}/testIamPermissions",
    validator: validate_ClouduseraccountsGroupsTestIamPermissions_598101,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsGroupsTestIamPermissions_598102,
    schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGlobalAccountsOperationsList_598118 = ref object of OpenApiRestCall_597424
proc url_ClouduseraccountsGlobalAccountsOperationsList_598120(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClouduseraccountsGlobalAccountsOperationsList_598119(
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
  var valid_598121 = path.getOrDefault("project")
  valid_598121 = validateParameter(valid_598121, JString, required = true,
                                 default = nil)
  if valid_598121 != nil:
    section.add "project", valid_598121
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests.
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
  ##         : Sets a filter expression for filtering listed resources, in the form filter={expression}. Your {expression} must be in the format: field_name comparison_string literal_string.
  ## 
  ## The field_name is the name of the field you want to compare. Only atomic field types are supported (string, number, boolean). The comparison_string must be either eq (equals) or ne (not equals). The literal_string is the string value to filter to. The literal value must be valid for the type of field you are filtering by (string, number, boolean). For string fields, the literal value is interpreted as a regular expression using RE2 syntax. The literal value must match the entire field.
  ## 
  ## For example, to filter for instances that do not have a name of example-instance, you would use filter=name ne example-instance.
  ## 
  ## Compute Engine Beta API Only: If you use filtering in the Beta API, you can also filter on nested fields. For example, you could filter on instances that have set the scheduling.automaticRestart field to true. In particular, use filtering on nested fields to take advantage of instance labels to organize and filter results based on label values.
  ## 
  ## The Beta API also supports filtering on multiple expressions by providing each separate expression within parentheses. For example, (scheduling.automaticRestart eq true) (zone eq us-central1-f). Multiple expressions are treated as AND expressions, meaning that resources must match all expressions to pass the filters.
  section = newJObject()
  var valid_598122 = query.getOrDefault("fields")
  valid_598122 = validateParameter(valid_598122, JString, required = false,
                                 default = nil)
  if valid_598122 != nil:
    section.add "fields", valid_598122
  var valid_598123 = query.getOrDefault("pageToken")
  valid_598123 = validateParameter(valid_598123, JString, required = false,
                                 default = nil)
  if valid_598123 != nil:
    section.add "pageToken", valid_598123
  var valid_598124 = query.getOrDefault("quotaUser")
  valid_598124 = validateParameter(valid_598124, JString, required = false,
                                 default = nil)
  if valid_598124 != nil:
    section.add "quotaUser", valid_598124
  var valid_598125 = query.getOrDefault("alt")
  valid_598125 = validateParameter(valid_598125, JString, required = false,
                                 default = newJString("json"))
  if valid_598125 != nil:
    section.add "alt", valid_598125
  var valid_598126 = query.getOrDefault("oauth_token")
  valid_598126 = validateParameter(valid_598126, JString, required = false,
                                 default = nil)
  if valid_598126 != nil:
    section.add "oauth_token", valid_598126
  var valid_598127 = query.getOrDefault("userIp")
  valid_598127 = validateParameter(valid_598127, JString, required = false,
                                 default = nil)
  if valid_598127 != nil:
    section.add "userIp", valid_598127
  var valid_598128 = query.getOrDefault("maxResults")
  valid_598128 = validateParameter(valid_598128, JInt, required = false,
                                 default = newJInt(500))
  if valid_598128 != nil:
    section.add "maxResults", valid_598128
  var valid_598129 = query.getOrDefault("orderBy")
  valid_598129 = validateParameter(valid_598129, JString, required = false,
                                 default = nil)
  if valid_598129 != nil:
    section.add "orderBy", valid_598129
  var valid_598130 = query.getOrDefault("key")
  valid_598130 = validateParameter(valid_598130, JString, required = false,
                                 default = nil)
  if valid_598130 != nil:
    section.add "key", valid_598130
  var valid_598131 = query.getOrDefault("prettyPrint")
  valid_598131 = validateParameter(valid_598131, JBool, required = false,
                                 default = newJBool(true))
  if valid_598131 != nil:
    section.add "prettyPrint", valid_598131
  var valid_598132 = query.getOrDefault("filter")
  valid_598132 = validateParameter(valid_598132, JString, required = false,
                                 default = nil)
  if valid_598132 != nil:
    section.add "filter", valid_598132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598133: Call_ClouduseraccountsGlobalAccountsOperationsList_598118;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of operation resources contained within the specified project.
  ## 
  let valid = call_598133.validator(path, query, header, formData, body)
  let scheme = call_598133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598133.url(scheme.get, call_598133.host, call_598133.base,
                         call_598133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598133, url, valid)

proc call*(call_598134: Call_ClouduseraccountsGlobalAccountsOperationsList_598118;
          project: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 500; orderBy: string = "";
          key: string = ""; prettyPrint: bool = true; filter: string = ""): Recallable =
  ## clouduseraccountsGlobalAccountsOperationsList
  ## Retrieves the list of operation resources contained within the specified project.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests.
  ##   orderBy: string
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
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
  var path_598135 = newJObject()
  var query_598136 = newJObject()
  add(query_598136, "fields", newJString(fields))
  add(query_598136, "pageToken", newJString(pageToken))
  add(query_598136, "quotaUser", newJString(quotaUser))
  add(query_598136, "alt", newJString(alt))
  add(query_598136, "oauth_token", newJString(oauthToken))
  add(query_598136, "userIp", newJString(userIp))
  add(query_598136, "maxResults", newJInt(maxResults))
  add(query_598136, "orderBy", newJString(orderBy))
  add(query_598136, "key", newJString(key))
  add(path_598135, "project", newJString(project))
  add(query_598136, "prettyPrint", newJBool(prettyPrint))
  add(query_598136, "filter", newJString(filter))
  result = call_598134.call(path_598135, query_598136, nil, nil, nil)

var clouduseraccountsGlobalAccountsOperationsList* = Call_ClouduseraccountsGlobalAccountsOperationsList_598118(
    name: "clouduseraccountsGlobalAccountsOperationsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{project}/global/operations",
    validator: validate_ClouduseraccountsGlobalAccountsOperationsList_598119,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsGlobalAccountsOperationsList_598120,
    schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGlobalAccountsOperationsGet_598137 = ref object of OpenApiRestCall_597424
proc url_ClouduseraccountsGlobalAccountsOperationsGet_598139(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClouduseraccountsGlobalAccountsOperationsGet_598138(path: JsonNode;
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
  var valid_598140 = path.getOrDefault("operation")
  valid_598140 = validateParameter(valid_598140, JString, required = true,
                                 default = nil)
  if valid_598140 != nil:
    section.add "operation", valid_598140
  var valid_598141 = path.getOrDefault("project")
  valid_598141 = validateParameter(valid_598141, JString, required = true,
                                 default = nil)
  if valid_598141 != nil:
    section.add "project", valid_598141
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598142 = query.getOrDefault("fields")
  valid_598142 = validateParameter(valid_598142, JString, required = false,
                                 default = nil)
  if valid_598142 != nil:
    section.add "fields", valid_598142
  var valid_598143 = query.getOrDefault("quotaUser")
  valid_598143 = validateParameter(valid_598143, JString, required = false,
                                 default = nil)
  if valid_598143 != nil:
    section.add "quotaUser", valid_598143
  var valid_598144 = query.getOrDefault("alt")
  valid_598144 = validateParameter(valid_598144, JString, required = false,
                                 default = newJString("json"))
  if valid_598144 != nil:
    section.add "alt", valid_598144
  var valid_598145 = query.getOrDefault("oauth_token")
  valid_598145 = validateParameter(valid_598145, JString, required = false,
                                 default = nil)
  if valid_598145 != nil:
    section.add "oauth_token", valid_598145
  var valid_598146 = query.getOrDefault("userIp")
  valid_598146 = validateParameter(valid_598146, JString, required = false,
                                 default = nil)
  if valid_598146 != nil:
    section.add "userIp", valid_598146
  var valid_598147 = query.getOrDefault("key")
  valid_598147 = validateParameter(valid_598147, JString, required = false,
                                 default = nil)
  if valid_598147 != nil:
    section.add "key", valid_598147
  var valid_598148 = query.getOrDefault("prettyPrint")
  valid_598148 = validateParameter(valid_598148, JBool, required = false,
                                 default = newJBool(true))
  if valid_598148 != nil:
    section.add "prettyPrint", valid_598148
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598149: Call_ClouduseraccountsGlobalAccountsOperationsGet_598137;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the specified operation resource.
  ## 
  let valid = call_598149.validator(path, query, header, formData, body)
  let scheme = call_598149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598149.url(scheme.get, call_598149.host, call_598149.base,
                         call_598149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598149, url, valid)

proc call*(call_598150: Call_ClouduseraccountsGlobalAccountsOperationsGet_598137;
          operation: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## clouduseraccountsGlobalAccountsOperationsGet
  ## Retrieves the specified operation resource.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   operation: string (required)
  ##            : Name of the Operations resource to return.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598151 = newJObject()
  var query_598152 = newJObject()
  add(query_598152, "fields", newJString(fields))
  add(query_598152, "quotaUser", newJString(quotaUser))
  add(query_598152, "alt", newJString(alt))
  add(path_598151, "operation", newJString(operation))
  add(query_598152, "oauth_token", newJString(oauthToken))
  add(query_598152, "userIp", newJString(userIp))
  add(query_598152, "key", newJString(key))
  add(path_598151, "project", newJString(project))
  add(query_598152, "prettyPrint", newJBool(prettyPrint))
  result = call_598150.call(path_598151, query_598152, nil, nil, nil)

var clouduseraccountsGlobalAccountsOperationsGet* = Call_ClouduseraccountsGlobalAccountsOperationsGet_598137(
    name: "clouduseraccountsGlobalAccountsOperationsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{project}/global/operations/{operation}",
    validator: validate_ClouduseraccountsGlobalAccountsOperationsGet_598138,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsGlobalAccountsOperationsGet_598139,
    schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGlobalAccountsOperationsDelete_598153 = ref object of OpenApiRestCall_597424
proc url_ClouduseraccountsGlobalAccountsOperationsDelete_598155(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClouduseraccountsGlobalAccountsOperationsDelete_598154(
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
  var valid_598156 = path.getOrDefault("operation")
  valid_598156 = validateParameter(valid_598156, JString, required = true,
                                 default = nil)
  if valid_598156 != nil:
    section.add "operation", valid_598156
  var valid_598157 = path.getOrDefault("project")
  valid_598157 = validateParameter(valid_598157, JString, required = true,
                                 default = nil)
  if valid_598157 != nil:
    section.add "project", valid_598157
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598158 = query.getOrDefault("fields")
  valid_598158 = validateParameter(valid_598158, JString, required = false,
                                 default = nil)
  if valid_598158 != nil:
    section.add "fields", valid_598158
  var valid_598159 = query.getOrDefault("quotaUser")
  valid_598159 = validateParameter(valid_598159, JString, required = false,
                                 default = nil)
  if valid_598159 != nil:
    section.add "quotaUser", valid_598159
  var valid_598160 = query.getOrDefault("alt")
  valid_598160 = validateParameter(valid_598160, JString, required = false,
                                 default = newJString("json"))
  if valid_598160 != nil:
    section.add "alt", valid_598160
  var valid_598161 = query.getOrDefault("oauth_token")
  valid_598161 = validateParameter(valid_598161, JString, required = false,
                                 default = nil)
  if valid_598161 != nil:
    section.add "oauth_token", valid_598161
  var valid_598162 = query.getOrDefault("userIp")
  valid_598162 = validateParameter(valid_598162, JString, required = false,
                                 default = nil)
  if valid_598162 != nil:
    section.add "userIp", valid_598162
  var valid_598163 = query.getOrDefault("key")
  valid_598163 = validateParameter(valid_598163, JString, required = false,
                                 default = nil)
  if valid_598163 != nil:
    section.add "key", valid_598163
  var valid_598164 = query.getOrDefault("prettyPrint")
  valid_598164 = validateParameter(valid_598164, JBool, required = false,
                                 default = newJBool(true))
  if valid_598164 != nil:
    section.add "prettyPrint", valid_598164
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598165: Call_ClouduseraccountsGlobalAccountsOperationsDelete_598153;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified operation resource.
  ## 
  let valid = call_598165.validator(path, query, header, formData, body)
  let scheme = call_598165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598165.url(scheme.get, call_598165.host, call_598165.base,
                         call_598165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598165, url, valid)

proc call*(call_598166: Call_ClouduseraccountsGlobalAccountsOperationsDelete_598153;
          operation: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## clouduseraccountsGlobalAccountsOperationsDelete
  ## Deletes the specified operation resource.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   operation: string (required)
  ##            : Name of the Operations resource to delete.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598167 = newJObject()
  var query_598168 = newJObject()
  add(query_598168, "fields", newJString(fields))
  add(query_598168, "quotaUser", newJString(quotaUser))
  add(query_598168, "alt", newJString(alt))
  add(path_598167, "operation", newJString(operation))
  add(query_598168, "oauth_token", newJString(oauthToken))
  add(query_598168, "userIp", newJString(userIp))
  add(query_598168, "key", newJString(key))
  add(path_598167, "project", newJString(project))
  add(query_598168, "prettyPrint", newJBool(prettyPrint))
  result = call_598166.call(path_598167, query_598168, nil, nil, nil)

var clouduseraccountsGlobalAccountsOperationsDelete* = Call_ClouduseraccountsGlobalAccountsOperationsDelete_598153(
    name: "clouduseraccountsGlobalAccountsOperationsDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/{project}/global/operations/{operation}",
    validator: validate_ClouduseraccountsGlobalAccountsOperationsDelete_598154,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsGlobalAccountsOperationsDelete_598155,
    schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersInsert_598188 = ref object of OpenApiRestCall_597424
proc url_ClouduseraccountsUsersInsert_598190(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClouduseraccountsUsersInsert_598189(path: JsonNode; query: JsonNode;
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
  var valid_598191 = path.getOrDefault("project")
  valid_598191 = validateParameter(valid_598191, JString, required = true,
                                 default = nil)
  if valid_598191 != nil:
    section.add "project", valid_598191
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598192 = query.getOrDefault("fields")
  valid_598192 = validateParameter(valid_598192, JString, required = false,
                                 default = nil)
  if valid_598192 != nil:
    section.add "fields", valid_598192
  var valid_598193 = query.getOrDefault("quotaUser")
  valid_598193 = validateParameter(valid_598193, JString, required = false,
                                 default = nil)
  if valid_598193 != nil:
    section.add "quotaUser", valid_598193
  var valid_598194 = query.getOrDefault("alt")
  valid_598194 = validateParameter(valid_598194, JString, required = false,
                                 default = newJString("json"))
  if valid_598194 != nil:
    section.add "alt", valid_598194
  var valid_598195 = query.getOrDefault("oauth_token")
  valid_598195 = validateParameter(valid_598195, JString, required = false,
                                 default = nil)
  if valid_598195 != nil:
    section.add "oauth_token", valid_598195
  var valid_598196 = query.getOrDefault("userIp")
  valid_598196 = validateParameter(valid_598196, JString, required = false,
                                 default = nil)
  if valid_598196 != nil:
    section.add "userIp", valid_598196
  var valid_598197 = query.getOrDefault("key")
  valid_598197 = validateParameter(valid_598197, JString, required = false,
                                 default = nil)
  if valid_598197 != nil:
    section.add "key", valid_598197
  var valid_598198 = query.getOrDefault("prettyPrint")
  valid_598198 = validateParameter(valid_598198, JBool, required = false,
                                 default = newJBool(true))
  if valid_598198 != nil:
    section.add "prettyPrint", valid_598198
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

proc call*(call_598200: Call_ClouduseraccountsUsersInsert_598188; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a User resource in the specified project using the data included in the request.
  ## 
  let valid = call_598200.validator(path, query, header, formData, body)
  let scheme = call_598200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598200.url(scheme.get, call_598200.host, call_598200.base,
                         call_598200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598200, url, valid)

proc call*(call_598201: Call_ClouduseraccountsUsersInsert_598188; project: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## clouduseraccountsUsersInsert
  ## Creates a User resource in the specified project using the data included in the request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598202 = newJObject()
  var query_598203 = newJObject()
  var body_598204 = newJObject()
  add(query_598203, "fields", newJString(fields))
  add(query_598203, "quotaUser", newJString(quotaUser))
  add(query_598203, "alt", newJString(alt))
  add(query_598203, "oauth_token", newJString(oauthToken))
  add(query_598203, "userIp", newJString(userIp))
  add(query_598203, "key", newJString(key))
  add(path_598202, "project", newJString(project))
  if body != nil:
    body_598204 = body
  add(query_598203, "prettyPrint", newJBool(prettyPrint))
  result = call_598201.call(path_598202, query_598203, nil, nil, body_598204)

var clouduseraccountsUsersInsert* = Call_ClouduseraccountsUsersInsert_598188(
    name: "clouduseraccountsUsersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/global/users",
    validator: validate_ClouduseraccountsUsersInsert_598189,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsUsersInsert_598190, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersList_598169 = ref object of OpenApiRestCall_597424
proc url_ClouduseraccountsUsersList_598171(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClouduseraccountsUsersList_598170(path: JsonNode; query: JsonNode;
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
  var valid_598172 = path.getOrDefault("project")
  valid_598172 = validateParameter(valid_598172, JString, required = true,
                                 default = nil)
  if valid_598172 != nil:
    section.add "project", valid_598172
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests.
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
  ##         : Sets a filter expression for filtering listed resources, in the form filter={expression}. Your {expression} must be in the format: field_name comparison_string literal_string.
  ## 
  ## The field_name is the name of the field you want to compare. Only atomic field types are supported (string, number, boolean). The comparison_string must be either eq (equals) or ne (not equals). The literal_string is the string value to filter to. The literal value must be valid for the type of field you are filtering by (string, number, boolean). For string fields, the literal value is interpreted as a regular expression using RE2 syntax. The literal value must match the entire field.
  ## 
  ## For example, to filter for instances that do not have a name of example-instance, you would use filter=name ne example-instance.
  ## 
  ## Compute Engine Beta API Only: If you use filtering in the Beta API, you can also filter on nested fields. For example, you could filter on instances that have set the scheduling.automaticRestart field to true. In particular, use filtering on nested fields to take advantage of instance labels to organize and filter results based on label values.
  ## 
  ## The Beta API also supports filtering on multiple expressions by providing each separate expression within parentheses. For example, (scheduling.automaticRestart eq true) (zone eq us-central1-f). Multiple expressions are treated as AND expressions, meaning that resources must match all expressions to pass the filters.
  section = newJObject()
  var valid_598173 = query.getOrDefault("fields")
  valid_598173 = validateParameter(valid_598173, JString, required = false,
                                 default = nil)
  if valid_598173 != nil:
    section.add "fields", valid_598173
  var valid_598174 = query.getOrDefault("pageToken")
  valid_598174 = validateParameter(valid_598174, JString, required = false,
                                 default = nil)
  if valid_598174 != nil:
    section.add "pageToken", valid_598174
  var valid_598175 = query.getOrDefault("quotaUser")
  valid_598175 = validateParameter(valid_598175, JString, required = false,
                                 default = nil)
  if valid_598175 != nil:
    section.add "quotaUser", valid_598175
  var valid_598176 = query.getOrDefault("alt")
  valid_598176 = validateParameter(valid_598176, JString, required = false,
                                 default = newJString("json"))
  if valid_598176 != nil:
    section.add "alt", valid_598176
  var valid_598177 = query.getOrDefault("oauth_token")
  valid_598177 = validateParameter(valid_598177, JString, required = false,
                                 default = nil)
  if valid_598177 != nil:
    section.add "oauth_token", valid_598177
  var valid_598178 = query.getOrDefault("userIp")
  valid_598178 = validateParameter(valid_598178, JString, required = false,
                                 default = nil)
  if valid_598178 != nil:
    section.add "userIp", valid_598178
  var valid_598179 = query.getOrDefault("maxResults")
  valid_598179 = validateParameter(valid_598179, JInt, required = false,
                                 default = newJInt(500))
  if valid_598179 != nil:
    section.add "maxResults", valid_598179
  var valid_598180 = query.getOrDefault("orderBy")
  valid_598180 = validateParameter(valid_598180, JString, required = false,
                                 default = nil)
  if valid_598180 != nil:
    section.add "orderBy", valid_598180
  var valid_598181 = query.getOrDefault("key")
  valid_598181 = validateParameter(valid_598181, JString, required = false,
                                 default = nil)
  if valid_598181 != nil:
    section.add "key", valid_598181
  var valid_598182 = query.getOrDefault("prettyPrint")
  valid_598182 = validateParameter(valid_598182, JBool, required = false,
                                 default = newJBool(true))
  if valid_598182 != nil:
    section.add "prettyPrint", valid_598182
  var valid_598183 = query.getOrDefault("filter")
  valid_598183 = validateParameter(valid_598183, JString, required = false,
                                 default = nil)
  if valid_598183 != nil:
    section.add "filter", valid_598183
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598184: Call_ClouduseraccountsUsersList_598169; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of users contained within the specified project.
  ## 
  let valid = call_598184.validator(path, query, header, formData, body)
  let scheme = call_598184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598184.url(scheme.get, call_598184.host, call_598184.base,
                         call_598184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598184, url, valid)

proc call*(call_598185: Call_ClouduseraccountsUsersList_598169; project: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 500; orderBy: string = ""; key: string = "";
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## clouduseraccountsUsersList
  ## Retrieves a list of users contained within the specified project.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests.
  ##   orderBy: string
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
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
  var path_598186 = newJObject()
  var query_598187 = newJObject()
  add(query_598187, "fields", newJString(fields))
  add(query_598187, "pageToken", newJString(pageToken))
  add(query_598187, "quotaUser", newJString(quotaUser))
  add(query_598187, "alt", newJString(alt))
  add(query_598187, "oauth_token", newJString(oauthToken))
  add(query_598187, "userIp", newJString(userIp))
  add(query_598187, "maxResults", newJInt(maxResults))
  add(query_598187, "orderBy", newJString(orderBy))
  add(query_598187, "key", newJString(key))
  add(path_598186, "project", newJString(project))
  add(query_598187, "prettyPrint", newJBool(prettyPrint))
  add(query_598187, "filter", newJString(filter))
  result = call_598185.call(path_598186, query_598187, nil, nil, nil)

var clouduseraccountsUsersList* = Call_ClouduseraccountsUsersList_598169(
    name: "clouduseraccountsUsersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/users",
    validator: validate_ClouduseraccountsUsersList_598170,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsUsersList_598171, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersGetIamPolicy_598205 = ref object of OpenApiRestCall_597424
proc url_ClouduseraccountsUsersGetIamPolicy_598207(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/users/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: "/getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClouduseraccountsUsersGetIamPolicy_598206(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the access control policy for a resource. May be empty if no such policy or resource exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Name of the resource for this request.
  ##   project: JString (required)
  ##          : Project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_598208 = path.getOrDefault("resource")
  valid_598208 = validateParameter(valid_598208, JString, required = true,
                                 default = nil)
  if valid_598208 != nil:
    section.add "resource", valid_598208
  var valid_598209 = path.getOrDefault("project")
  valid_598209 = validateParameter(valid_598209, JString, required = true,
                                 default = nil)
  if valid_598209 != nil:
    section.add "project", valid_598209
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598210 = query.getOrDefault("fields")
  valid_598210 = validateParameter(valid_598210, JString, required = false,
                                 default = nil)
  if valid_598210 != nil:
    section.add "fields", valid_598210
  var valid_598211 = query.getOrDefault("quotaUser")
  valid_598211 = validateParameter(valid_598211, JString, required = false,
                                 default = nil)
  if valid_598211 != nil:
    section.add "quotaUser", valid_598211
  var valid_598212 = query.getOrDefault("alt")
  valid_598212 = validateParameter(valid_598212, JString, required = false,
                                 default = newJString("json"))
  if valid_598212 != nil:
    section.add "alt", valid_598212
  var valid_598213 = query.getOrDefault("oauth_token")
  valid_598213 = validateParameter(valid_598213, JString, required = false,
                                 default = nil)
  if valid_598213 != nil:
    section.add "oauth_token", valid_598213
  var valid_598214 = query.getOrDefault("userIp")
  valid_598214 = validateParameter(valid_598214, JString, required = false,
                                 default = nil)
  if valid_598214 != nil:
    section.add "userIp", valid_598214
  var valid_598215 = query.getOrDefault("key")
  valid_598215 = validateParameter(valid_598215, JString, required = false,
                                 default = nil)
  if valid_598215 != nil:
    section.add "key", valid_598215
  var valid_598216 = query.getOrDefault("prettyPrint")
  valid_598216 = validateParameter(valid_598216, JBool, required = false,
                                 default = newJBool(true))
  if valid_598216 != nil:
    section.add "prettyPrint", valid_598216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598217: Call_ClouduseraccountsUsersGetIamPolicy_598205;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource. May be empty if no such policy or resource exists.
  ## 
  let valid = call_598217.validator(path, query, header, formData, body)
  let scheme = call_598217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598217.url(scheme.get, call_598217.host, call_598217.base,
                         call_598217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598217, url, valid)

proc call*(call_598218: Call_ClouduseraccountsUsersGetIamPolicy_598205;
          resource: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## clouduseraccountsUsersGetIamPolicy
  ## Gets the access control policy for a resource. May be empty if no such policy or resource exists.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   resource: string (required)
  ##           : Name of the resource for this request.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598219 = newJObject()
  var query_598220 = newJObject()
  add(query_598220, "fields", newJString(fields))
  add(query_598220, "quotaUser", newJString(quotaUser))
  add(query_598220, "alt", newJString(alt))
  add(query_598220, "oauth_token", newJString(oauthToken))
  add(query_598220, "userIp", newJString(userIp))
  add(query_598220, "key", newJString(key))
  add(path_598219, "resource", newJString(resource))
  add(path_598219, "project", newJString(project))
  add(query_598220, "prettyPrint", newJBool(prettyPrint))
  result = call_598218.call(path_598219, query_598220, nil, nil, nil)

var clouduseraccountsUsersGetIamPolicy* = Call_ClouduseraccountsUsersGetIamPolicy_598205(
    name: "clouduseraccountsUsersGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/users/{resource}/getIamPolicy",
    validator: validate_ClouduseraccountsUsersGetIamPolicy_598206,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsUsersGetIamPolicy_598207, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersSetIamPolicy_598221 = ref object of OpenApiRestCall_597424
proc url_ClouduseraccountsUsersSetIamPolicy_598223(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/users/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: "/setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClouduseraccountsUsersSetIamPolicy_598222(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the access control policy on the specified resource. Replaces any existing policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Name of the resource for this request.
  ##   project: JString (required)
  ##          : Project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_598224 = path.getOrDefault("resource")
  valid_598224 = validateParameter(valid_598224, JString, required = true,
                                 default = nil)
  if valid_598224 != nil:
    section.add "resource", valid_598224
  var valid_598225 = path.getOrDefault("project")
  valid_598225 = validateParameter(valid_598225, JString, required = true,
                                 default = nil)
  if valid_598225 != nil:
    section.add "project", valid_598225
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598226 = query.getOrDefault("fields")
  valid_598226 = validateParameter(valid_598226, JString, required = false,
                                 default = nil)
  if valid_598226 != nil:
    section.add "fields", valid_598226
  var valid_598227 = query.getOrDefault("quotaUser")
  valid_598227 = validateParameter(valid_598227, JString, required = false,
                                 default = nil)
  if valid_598227 != nil:
    section.add "quotaUser", valid_598227
  var valid_598228 = query.getOrDefault("alt")
  valid_598228 = validateParameter(valid_598228, JString, required = false,
                                 default = newJString("json"))
  if valid_598228 != nil:
    section.add "alt", valid_598228
  var valid_598229 = query.getOrDefault("oauth_token")
  valid_598229 = validateParameter(valid_598229, JString, required = false,
                                 default = nil)
  if valid_598229 != nil:
    section.add "oauth_token", valid_598229
  var valid_598230 = query.getOrDefault("userIp")
  valid_598230 = validateParameter(valid_598230, JString, required = false,
                                 default = nil)
  if valid_598230 != nil:
    section.add "userIp", valid_598230
  var valid_598231 = query.getOrDefault("key")
  valid_598231 = validateParameter(valid_598231, JString, required = false,
                                 default = nil)
  if valid_598231 != nil:
    section.add "key", valid_598231
  var valid_598232 = query.getOrDefault("prettyPrint")
  valid_598232 = validateParameter(valid_598232, JBool, required = false,
                                 default = newJBool(true))
  if valid_598232 != nil:
    section.add "prettyPrint", valid_598232
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

proc call*(call_598234: Call_ClouduseraccountsUsersSetIamPolicy_598221;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any existing policy.
  ## 
  let valid = call_598234.validator(path, query, header, formData, body)
  let scheme = call_598234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598234.url(scheme.get, call_598234.host, call_598234.base,
                         call_598234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598234, url, valid)

proc call*(call_598235: Call_ClouduseraccountsUsersSetIamPolicy_598221;
          resource: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## clouduseraccountsUsersSetIamPolicy
  ## Sets the access control policy on the specified resource. Replaces any existing policy.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   resource: string (required)
  ##           : Name of the resource for this request.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598236 = newJObject()
  var query_598237 = newJObject()
  var body_598238 = newJObject()
  add(query_598237, "fields", newJString(fields))
  add(query_598237, "quotaUser", newJString(quotaUser))
  add(query_598237, "alt", newJString(alt))
  add(query_598237, "oauth_token", newJString(oauthToken))
  add(query_598237, "userIp", newJString(userIp))
  add(query_598237, "key", newJString(key))
  add(path_598236, "resource", newJString(resource))
  add(path_598236, "project", newJString(project))
  if body != nil:
    body_598238 = body
  add(query_598237, "prettyPrint", newJBool(prettyPrint))
  result = call_598235.call(path_598236, query_598237, nil, nil, body_598238)

var clouduseraccountsUsersSetIamPolicy* = Call_ClouduseraccountsUsersSetIamPolicy_598221(
    name: "clouduseraccountsUsersSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/users/{resource}/setIamPolicy",
    validator: validate_ClouduseraccountsUsersSetIamPolicy_598222,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsUsersSetIamPolicy_598223, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersTestIamPermissions_598239 = ref object of OpenApiRestCall_597424
proc url_ClouduseraccountsUsersTestIamPermissions_598241(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/users/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: "/testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClouduseraccountsUsersTestIamPermissions_598240(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns permissions that a caller has on the specified resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Name of the resource for this request.
  ##   project: JString (required)
  ##          : Project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_598242 = path.getOrDefault("resource")
  valid_598242 = validateParameter(valid_598242, JString, required = true,
                                 default = nil)
  if valid_598242 != nil:
    section.add "resource", valid_598242
  var valid_598243 = path.getOrDefault("project")
  valid_598243 = validateParameter(valid_598243, JString, required = true,
                                 default = nil)
  if valid_598243 != nil:
    section.add "project", valid_598243
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598244 = query.getOrDefault("fields")
  valid_598244 = validateParameter(valid_598244, JString, required = false,
                                 default = nil)
  if valid_598244 != nil:
    section.add "fields", valid_598244
  var valid_598245 = query.getOrDefault("quotaUser")
  valid_598245 = validateParameter(valid_598245, JString, required = false,
                                 default = nil)
  if valid_598245 != nil:
    section.add "quotaUser", valid_598245
  var valid_598246 = query.getOrDefault("alt")
  valid_598246 = validateParameter(valid_598246, JString, required = false,
                                 default = newJString("json"))
  if valid_598246 != nil:
    section.add "alt", valid_598246
  var valid_598247 = query.getOrDefault("oauth_token")
  valid_598247 = validateParameter(valid_598247, JString, required = false,
                                 default = nil)
  if valid_598247 != nil:
    section.add "oauth_token", valid_598247
  var valid_598248 = query.getOrDefault("userIp")
  valid_598248 = validateParameter(valid_598248, JString, required = false,
                                 default = nil)
  if valid_598248 != nil:
    section.add "userIp", valid_598248
  var valid_598249 = query.getOrDefault("key")
  valid_598249 = validateParameter(valid_598249, JString, required = false,
                                 default = nil)
  if valid_598249 != nil:
    section.add "key", valid_598249
  var valid_598250 = query.getOrDefault("prettyPrint")
  valid_598250 = validateParameter(valid_598250, JBool, required = false,
                                 default = newJBool(true))
  if valid_598250 != nil:
    section.add "prettyPrint", valid_598250
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

proc call*(call_598252: Call_ClouduseraccountsUsersTestIamPermissions_598239;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified resource.
  ## 
  let valid = call_598252.validator(path, query, header, formData, body)
  let scheme = call_598252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598252.url(scheme.get, call_598252.host, call_598252.base,
                         call_598252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598252, url, valid)

proc call*(call_598253: Call_ClouduseraccountsUsersTestIamPermissions_598239;
          resource: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## clouduseraccountsUsersTestIamPermissions
  ## Returns permissions that a caller has on the specified resource.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   resource: string (required)
  ##           : Name of the resource for this request.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598254 = newJObject()
  var query_598255 = newJObject()
  var body_598256 = newJObject()
  add(query_598255, "fields", newJString(fields))
  add(query_598255, "quotaUser", newJString(quotaUser))
  add(query_598255, "alt", newJString(alt))
  add(query_598255, "oauth_token", newJString(oauthToken))
  add(query_598255, "userIp", newJString(userIp))
  add(query_598255, "key", newJString(key))
  add(path_598254, "resource", newJString(resource))
  add(path_598254, "project", newJString(project))
  if body != nil:
    body_598256 = body
  add(query_598255, "prettyPrint", newJBool(prettyPrint))
  result = call_598253.call(path_598254, query_598255, nil, nil, body_598256)

var clouduseraccountsUsersTestIamPermissions* = Call_ClouduseraccountsUsersTestIamPermissions_598239(
    name: "clouduseraccountsUsersTestIamPermissions", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/users/{resource}/testIamPermissions",
    validator: validate_ClouduseraccountsUsersTestIamPermissions_598240,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsUsersTestIamPermissions_598241,
    schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersGet_598257 = ref object of OpenApiRestCall_597424
proc url_ClouduseraccountsUsersGet_598259(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClouduseraccountsUsersGet_598258(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the specified User resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   user: JString (required)
  ##       : Name of the user resource to return.
  ##   project: JString (required)
  ##          : Project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `user` field"
  var valid_598260 = path.getOrDefault("user")
  valid_598260 = validateParameter(valid_598260, JString, required = true,
                                 default = nil)
  if valid_598260 != nil:
    section.add "user", valid_598260
  var valid_598261 = path.getOrDefault("project")
  valid_598261 = validateParameter(valid_598261, JString, required = true,
                                 default = nil)
  if valid_598261 != nil:
    section.add "project", valid_598261
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598262 = query.getOrDefault("fields")
  valid_598262 = validateParameter(valid_598262, JString, required = false,
                                 default = nil)
  if valid_598262 != nil:
    section.add "fields", valid_598262
  var valid_598263 = query.getOrDefault("quotaUser")
  valid_598263 = validateParameter(valid_598263, JString, required = false,
                                 default = nil)
  if valid_598263 != nil:
    section.add "quotaUser", valid_598263
  var valid_598264 = query.getOrDefault("alt")
  valid_598264 = validateParameter(valid_598264, JString, required = false,
                                 default = newJString("json"))
  if valid_598264 != nil:
    section.add "alt", valid_598264
  var valid_598265 = query.getOrDefault("oauth_token")
  valid_598265 = validateParameter(valid_598265, JString, required = false,
                                 default = nil)
  if valid_598265 != nil:
    section.add "oauth_token", valid_598265
  var valid_598266 = query.getOrDefault("userIp")
  valid_598266 = validateParameter(valid_598266, JString, required = false,
                                 default = nil)
  if valid_598266 != nil:
    section.add "userIp", valid_598266
  var valid_598267 = query.getOrDefault("key")
  valid_598267 = validateParameter(valid_598267, JString, required = false,
                                 default = nil)
  if valid_598267 != nil:
    section.add "key", valid_598267
  var valid_598268 = query.getOrDefault("prettyPrint")
  valid_598268 = validateParameter(valid_598268, JBool, required = false,
                                 default = newJBool(true))
  if valid_598268 != nil:
    section.add "prettyPrint", valid_598268
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598269: Call_ClouduseraccountsUsersGet_598257; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specified User resource.
  ## 
  let valid = call_598269.validator(path, query, header, formData, body)
  let scheme = call_598269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598269.url(scheme.get, call_598269.host, call_598269.base,
                         call_598269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598269, url, valid)

proc call*(call_598270: Call_ClouduseraccountsUsersGet_598257; user: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## clouduseraccountsUsersGet
  ## Returns the specified User resource.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   user: string (required)
  ##       : Name of the user resource to return.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598271 = newJObject()
  var query_598272 = newJObject()
  add(query_598272, "fields", newJString(fields))
  add(query_598272, "quotaUser", newJString(quotaUser))
  add(query_598272, "alt", newJString(alt))
  add(path_598271, "user", newJString(user))
  add(query_598272, "oauth_token", newJString(oauthToken))
  add(query_598272, "userIp", newJString(userIp))
  add(query_598272, "key", newJString(key))
  add(path_598271, "project", newJString(project))
  add(query_598272, "prettyPrint", newJBool(prettyPrint))
  result = call_598270.call(path_598271, query_598272, nil, nil, nil)

var clouduseraccountsUsersGet* = Call_ClouduseraccountsUsersGet_598257(
    name: "clouduseraccountsUsersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/users/{user}",
    validator: validate_ClouduseraccountsUsersGet_598258,
    base: "/clouduseraccounts/alpha/projects", url: url_ClouduseraccountsUsersGet_598259,
    schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersDelete_598273 = ref object of OpenApiRestCall_597424
proc url_ClouduseraccountsUsersDelete_598275(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClouduseraccountsUsersDelete_598274(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified User resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   user: JString (required)
  ##       : Name of the user resource to delete.
  ##   project: JString (required)
  ##          : Project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `user` field"
  var valid_598276 = path.getOrDefault("user")
  valid_598276 = validateParameter(valid_598276, JString, required = true,
                                 default = nil)
  if valid_598276 != nil:
    section.add "user", valid_598276
  var valid_598277 = path.getOrDefault("project")
  valid_598277 = validateParameter(valid_598277, JString, required = true,
                                 default = nil)
  if valid_598277 != nil:
    section.add "project", valid_598277
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598278 = query.getOrDefault("fields")
  valid_598278 = validateParameter(valid_598278, JString, required = false,
                                 default = nil)
  if valid_598278 != nil:
    section.add "fields", valid_598278
  var valid_598279 = query.getOrDefault("quotaUser")
  valid_598279 = validateParameter(valid_598279, JString, required = false,
                                 default = nil)
  if valid_598279 != nil:
    section.add "quotaUser", valid_598279
  var valid_598280 = query.getOrDefault("alt")
  valid_598280 = validateParameter(valid_598280, JString, required = false,
                                 default = newJString("json"))
  if valid_598280 != nil:
    section.add "alt", valid_598280
  var valid_598281 = query.getOrDefault("oauth_token")
  valid_598281 = validateParameter(valid_598281, JString, required = false,
                                 default = nil)
  if valid_598281 != nil:
    section.add "oauth_token", valid_598281
  var valid_598282 = query.getOrDefault("userIp")
  valid_598282 = validateParameter(valid_598282, JString, required = false,
                                 default = nil)
  if valid_598282 != nil:
    section.add "userIp", valid_598282
  var valid_598283 = query.getOrDefault("key")
  valid_598283 = validateParameter(valid_598283, JString, required = false,
                                 default = nil)
  if valid_598283 != nil:
    section.add "key", valid_598283
  var valid_598284 = query.getOrDefault("prettyPrint")
  valid_598284 = validateParameter(valid_598284, JBool, required = false,
                                 default = newJBool(true))
  if valid_598284 != nil:
    section.add "prettyPrint", valid_598284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598285: Call_ClouduseraccountsUsersDelete_598273; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified User resource.
  ## 
  let valid = call_598285.validator(path, query, header, formData, body)
  let scheme = call_598285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598285.url(scheme.get, call_598285.host, call_598285.base,
                         call_598285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598285, url, valid)

proc call*(call_598286: Call_ClouduseraccountsUsersDelete_598273; user: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## clouduseraccountsUsersDelete
  ## Deletes the specified User resource.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   user: string (required)
  ##       : Name of the user resource to delete.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598287 = newJObject()
  var query_598288 = newJObject()
  add(query_598288, "fields", newJString(fields))
  add(query_598288, "quotaUser", newJString(quotaUser))
  add(query_598288, "alt", newJString(alt))
  add(path_598287, "user", newJString(user))
  add(query_598288, "oauth_token", newJString(oauthToken))
  add(query_598288, "userIp", newJString(userIp))
  add(query_598288, "key", newJString(key))
  add(path_598287, "project", newJString(project))
  add(query_598288, "prettyPrint", newJBool(prettyPrint))
  result = call_598286.call(path_598287, query_598288, nil, nil, nil)

var clouduseraccountsUsersDelete* = Call_ClouduseraccountsUsersDelete_598273(
    name: "clouduseraccountsUsersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{project}/global/users/{user}",
    validator: validate_ClouduseraccountsUsersDelete_598274,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsUsersDelete_598275, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersAddPublicKey_598289 = ref object of OpenApiRestCall_597424
proc url_ClouduseraccountsUsersAddPublicKey_598291(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClouduseraccountsUsersAddPublicKey_598290(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a public key to the specified User resource with the data included in the request.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   user: JString (required)
  ##       : Name of the user for this request.
  ##   project: JString (required)
  ##          : Project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `user` field"
  var valid_598292 = path.getOrDefault("user")
  valid_598292 = validateParameter(valid_598292, JString, required = true,
                                 default = nil)
  if valid_598292 != nil:
    section.add "user", valid_598292
  var valid_598293 = path.getOrDefault("project")
  valid_598293 = validateParameter(valid_598293, JString, required = true,
                                 default = nil)
  if valid_598293 != nil:
    section.add "project", valid_598293
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598294 = query.getOrDefault("fields")
  valid_598294 = validateParameter(valid_598294, JString, required = false,
                                 default = nil)
  if valid_598294 != nil:
    section.add "fields", valid_598294
  var valid_598295 = query.getOrDefault("quotaUser")
  valid_598295 = validateParameter(valid_598295, JString, required = false,
                                 default = nil)
  if valid_598295 != nil:
    section.add "quotaUser", valid_598295
  var valid_598296 = query.getOrDefault("alt")
  valid_598296 = validateParameter(valid_598296, JString, required = false,
                                 default = newJString("json"))
  if valid_598296 != nil:
    section.add "alt", valid_598296
  var valid_598297 = query.getOrDefault("oauth_token")
  valid_598297 = validateParameter(valid_598297, JString, required = false,
                                 default = nil)
  if valid_598297 != nil:
    section.add "oauth_token", valid_598297
  var valid_598298 = query.getOrDefault("userIp")
  valid_598298 = validateParameter(valid_598298, JString, required = false,
                                 default = nil)
  if valid_598298 != nil:
    section.add "userIp", valid_598298
  var valid_598299 = query.getOrDefault("key")
  valid_598299 = validateParameter(valid_598299, JString, required = false,
                                 default = nil)
  if valid_598299 != nil:
    section.add "key", valid_598299
  var valid_598300 = query.getOrDefault("prettyPrint")
  valid_598300 = validateParameter(valid_598300, JBool, required = false,
                                 default = newJBool(true))
  if valid_598300 != nil:
    section.add "prettyPrint", valid_598300
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

proc call*(call_598302: Call_ClouduseraccountsUsersAddPublicKey_598289;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a public key to the specified User resource with the data included in the request.
  ## 
  let valid = call_598302.validator(path, query, header, formData, body)
  let scheme = call_598302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598302.url(scheme.get, call_598302.host, call_598302.base,
                         call_598302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598302, url, valid)

proc call*(call_598303: Call_ClouduseraccountsUsersAddPublicKey_598289;
          user: string; project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## clouduseraccountsUsersAddPublicKey
  ## Adds a public key to the specified User resource with the data included in the request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   user: string (required)
  ##       : Name of the user for this request.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598304 = newJObject()
  var query_598305 = newJObject()
  var body_598306 = newJObject()
  add(query_598305, "fields", newJString(fields))
  add(query_598305, "quotaUser", newJString(quotaUser))
  add(query_598305, "alt", newJString(alt))
  add(path_598304, "user", newJString(user))
  add(query_598305, "oauth_token", newJString(oauthToken))
  add(query_598305, "userIp", newJString(userIp))
  add(query_598305, "key", newJString(key))
  add(path_598304, "project", newJString(project))
  if body != nil:
    body_598306 = body
  add(query_598305, "prettyPrint", newJBool(prettyPrint))
  result = call_598303.call(path_598304, query_598305, nil, nil, body_598306)

var clouduseraccountsUsersAddPublicKey* = Call_ClouduseraccountsUsersAddPublicKey_598289(
    name: "clouduseraccountsUsersAddPublicKey", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/users/{user}/addPublicKey",
    validator: validate_ClouduseraccountsUsersAddPublicKey_598290,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsUsersAddPublicKey_598291, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersRemovePublicKey_598307 = ref object of OpenApiRestCall_597424
proc url_ClouduseraccountsUsersRemovePublicKey_598309(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClouduseraccountsUsersRemovePublicKey_598308(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes the specified public key from the user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   user: JString (required)
  ##       : Name of the user for this request.
  ##   project: JString (required)
  ##          : Project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `user` field"
  var valid_598310 = path.getOrDefault("user")
  valid_598310 = validateParameter(valid_598310, JString, required = true,
                                 default = nil)
  if valid_598310 != nil:
    section.add "user", valid_598310
  var valid_598311 = path.getOrDefault("project")
  valid_598311 = validateParameter(valid_598311, JString, required = true,
                                 default = nil)
  if valid_598311 != nil:
    section.add "project", valid_598311
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   fingerprint: JString (required)
  ##              : The fingerprint of the public key to delete. Public keys are identified by their fingerprint, which is defined by RFC4716 to be the MD5 digest of the public key.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598312 = query.getOrDefault("fields")
  valid_598312 = validateParameter(valid_598312, JString, required = false,
                                 default = nil)
  if valid_598312 != nil:
    section.add "fields", valid_598312
  assert query != nil,
        "query argument is necessary due to required `fingerprint` field"
  var valid_598313 = query.getOrDefault("fingerprint")
  valid_598313 = validateParameter(valid_598313, JString, required = true,
                                 default = nil)
  if valid_598313 != nil:
    section.add "fingerprint", valid_598313
  var valid_598314 = query.getOrDefault("quotaUser")
  valid_598314 = validateParameter(valid_598314, JString, required = false,
                                 default = nil)
  if valid_598314 != nil:
    section.add "quotaUser", valid_598314
  var valid_598315 = query.getOrDefault("alt")
  valid_598315 = validateParameter(valid_598315, JString, required = false,
                                 default = newJString("json"))
  if valid_598315 != nil:
    section.add "alt", valid_598315
  var valid_598316 = query.getOrDefault("oauth_token")
  valid_598316 = validateParameter(valid_598316, JString, required = false,
                                 default = nil)
  if valid_598316 != nil:
    section.add "oauth_token", valid_598316
  var valid_598317 = query.getOrDefault("userIp")
  valid_598317 = validateParameter(valid_598317, JString, required = false,
                                 default = nil)
  if valid_598317 != nil:
    section.add "userIp", valid_598317
  var valid_598318 = query.getOrDefault("key")
  valid_598318 = validateParameter(valid_598318, JString, required = false,
                                 default = nil)
  if valid_598318 != nil:
    section.add "key", valid_598318
  var valid_598319 = query.getOrDefault("prettyPrint")
  valid_598319 = validateParameter(valid_598319, JBool, required = false,
                                 default = newJBool(true))
  if valid_598319 != nil:
    section.add "prettyPrint", valid_598319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598320: Call_ClouduseraccountsUsersRemovePublicKey_598307;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes the specified public key from the user.
  ## 
  let valid = call_598320.validator(path, query, header, formData, body)
  let scheme = call_598320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598320.url(scheme.get, call_598320.host, call_598320.base,
                         call_598320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598320, url, valid)

proc call*(call_598321: Call_ClouduseraccountsUsersRemovePublicKey_598307;
          fingerprint: string; user: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## clouduseraccountsUsersRemovePublicKey
  ## Removes the specified public key from the user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   fingerprint: string (required)
  ##              : The fingerprint of the public key to delete. Public keys are identified by their fingerprint, which is defined by RFC4716 to be the MD5 digest of the public key.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   user: string (required)
  ##       : Name of the user for this request.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598322 = newJObject()
  var query_598323 = newJObject()
  add(query_598323, "fields", newJString(fields))
  add(query_598323, "fingerprint", newJString(fingerprint))
  add(query_598323, "quotaUser", newJString(quotaUser))
  add(query_598323, "alt", newJString(alt))
  add(path_598322, "user", newJString(user))
  add(query_598323, "oauth_token", newJString(oauthToken))
  add(query_598323, "userIp", newJString(userIp))
  add(query_598323, "key", newJString(key))
  add(path_598322, "project", newJString(project))
  add(query_598323, "prettyPrint", newJBool(prettyPrint))
  result = call_598321.call(path_598322, query_598323, nil, nil, nil)

var clouduseraccountsUsersRemovePublicKey* = Call_ClouduseraccountsUsersRemovePublicKey_598307(
    name: "clouduseraccountsUsersRemovePublicKey", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/users/{user}/removePublicKey",
    validator: validate_ClouduseraccountsUsersRemovePublicKey_598308,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsUsersRemovePublicKey_598309, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsLinuxGetAuthorizedKeysView_598324 = ref object of OpenApiRestCall_597424
proc url_ClouduseraccountsLinuxGetAuthorizedKeysView_598326(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClouduseraccountsLinuxGetAuthorizedKeysView_598325(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of authorized public keys for a specific user account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Name of the zone for this request.
  ##   user: JString (required)
  ##       : The user account for which you want to get a list of authorized public keys.
  ##   project: JString (required)
  ##          : Project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_598327 = path.getOrDefault("zone")
  valid_598327 = validateParameter(valid_598327, JString, required = true,
                                 default = nil)
  if valid_598327 != nil:
    section.add "zone", valid_598327
  var valid_598328 = path.getOrDefault("user")
  valid_598328 = validateParameter(valid_598328, JString, required = true,
                                 default = nil)
  if valid_598328 != nil:
    section.add "user", valid_598328
  var valid_598329 = path.getOrDefault("project")
  valid_598329 = validateParameter(valid_598329, JString, required = true,
                                 default = nil)
  if valid_598329 != nil:
    section.add "project", valid_598329
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   login: JBool
  ##        : Whether the view was requested as part of a user-initiated login.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: JString (required)
  ##           : The fully-qualified URL of the virtual machine requesting the view.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598330 = query.getOrDefault("fields")
  valid_598330 = validateParameter(valid_598330, JString, required = false,
                                 default = nil)
  if valid_598330 != nil:
    section.add "fields", valid_598330
  var valid_598331 = query.getOrDefault("quotaUser")
  valid_598331 = validateParameter(valid_598331, JString, required = false,
                                 default = nil)
  if valid_598331 != nil:
    section.add "quotaUser", valid_598331
  var valid_598332 = query.getOrDefault("alt")
  valid_598332 = validateParameter(valid_598332, JString, required = false,
                                 default = newJString("json"))
  if valid_598332 != nil:
    section.add "alt", valid_598332
  var valid_598333 = query.getOrDefault("login")
  valid_598333 = validateParameter(valid_598333, JBool, required = false, default = nil)
  if valid_598333 != nil:
    section.add "login", valid_598333
  var valid_598334 = query.getOrDefault("oauth_token")
  valid_598334 = validateParameter(valid_598334, JString, required = false,
                                 default = nil)
  if valid_598334 != nil:
    section.add "oauth_token", valid_598334
  var valid_598335 = query.getOrDefault("userIp")
  valid_598335 = validateParameter(valid_598335, JString, required = false,
                                 default = nil)
  if valid_598335 != nil:
    section.add "userIp", valid_598335
  var valid_598336 = query.getOrDefault("key")
  valid_598336 = validateParameter(valid_598336, JString, required = false,
                                 default = nil)
  if valid_598336 != nil:
    section.add "key", valid_598336
  assert query != nil,
        "query argument is necessary due to required `instance` field"
  var valid_598337 = query.getOrDefault("instance")
  valid_598337 = validateParameter(valid_598337, JString, required = true,
                                 default = nil)
  if valid_598337 != nil:
    section.add "instance", valid_598337
  var valid_598338 = query.getOrDefault("prettyPrint")
  valid_598338 = validateParameter(valid_598338, JBool, required = false,
                                 default = newJBool(true))
  if valid_598338 != nil:
    section.add "prettyPrint", valid_598338
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598339: Call_ClouduseraccountsLinuxGetAuthorizedKeysView_598324;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of authorized public keys for a specific user account.
  ## 
  let valid = call_598339.validator(path, query, header, formData, body)
  let scheme = call_598339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598339.url(scheme.get, call_598339.host, call_598339.base,
                         call_598339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598339, url, valid)

proc call*(call_598340: Call_ClouduseraccountsLinuxGetAuthorizedKeysView_598324;
          zone: string; user: string; instance: string; project: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          login: bool = false; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## clouduseraccountsLinuxGetAuthorizedKeysView
  ## Returns a list of authorized public keys for a specific user account.
  ##   zone: string (required)
  ##       : Name of the zone for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   user: string (required)
  ##       : The user account for which you want to get a list of authorized public keys.
  ##   login: bool
  ##        : Whether the view was requested as part of a user-initiated login.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : The fully-qualified URL of the virtual machine requesting the view.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598341 = newJObject()
  var query_598342 = newJObject()
  add(path_598341, "zone", newJString(zone))
  add(query_598342, "fields", newJString(fields))
  add(query_598342, "quotaUser", newJString(quotaUser))
  add(query_598342, "alt", newJString(alt))
  add(path_598341, "user", newJString(user))
  add(query_598342, "login", newJBool(login))
  add(query_598342, "oauth_token", newJString(oauthToken))
  add(query_598342, "userIp", newJString(userIp))
  add(query_598342, "key", newJString(key))
  add(query_598342, "instance", newJString(instance))
  add(path_598341, "project", newJString(project))
  add(query_598342, "prettyPrint", newJBool(prettyPrint))
  result = call_598340.call(path_598341, query_598342, nil, nil, nil)

var clouduseraccountsLinuxGetAuthorizedKeysView* = Call_ClouduseraccountsLinuxGetAuthorizedKeysView_598324(
    name: "clouduseraccountsLinuxGetAuthorizedKeysView",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/authorizedKeysView/{user}",
    validator: validate_ClouduseraccountsLinuxGetAuthorizedKeysView_598325,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsLinuxGetAuthorizedKeysView_598326,
    schemes: {Scheme.Https})
type
  Call_ClouduseraccountsLinuxGetLinuxAccountViews_598343 = ref object of OpenApiRestCall_597424
proc url_ClouduseraccountsLinuxGetLinuxAccountViews_598345(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClouduseraccountsLinuxGetLinuxAccountViews_598344(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of user accounts for an instance within a specific project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Name of the zone for this request.
  ##   project: JString (required)
  ##          : Project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_598346 = path.getOrDefault("zone")
  valid_598346 = validateParameter(valid_598346, JString, required = true,
                                 default = nil)
  if valid_598346 != nil:
    section.add "zone", valid_598346
  var valid_598347 = path.getOrDefault("project")
  valid_598347 = validateParameter(valid_598347, JString, required = true,
                                 default = nil)
  if valid_598347 != nil:
    section.add "project", valid_598347
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests.
  ##   orderBy: JString
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: JString (required)
  ##           : The fully-qualified URL of the virtual machine requesting the views.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
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
  section = newJObject()
  var valid_598348 = query.getOrDefault("fields")
  valid_598348 = validateParameter(valid_598348, JString, required = false,
                                 default = nil)
  if valid_598348 != nil:
    section.add "fields", valid_598348
  var valid_598349 = query.getOrDefault("pageToken")
  valid_598349 = validateParameter(valid_598349, JString, required = false,
                                 default = nil)
  if valid_598349 != nil:
    section.add "pageToken", valid_598349
  var valid_598350 = query.getOrDefault("quotaUser")
  valid_598350 = validateParameter(valid_598350, JString, required = false,
                                 default = nil)
  if valid_598350 != nil:
    section.add "quotaUser", valid_598350
  var valid_598351 = query.getOrDefault("alt")
  valid_598351 = validateParameter(valid_598351, JString, required = false,
                                 default = newJString("json"))
  if valid_598351 != nil:
    section.add "alt", valid_598351
  var valid_598352 = query.getOrDefault("oauth_token")
  valid_598352 = validateParameter(valid_598352, JString, required = false,
                                 default = nil)
  if valid_598352 != nil:
    section.add "oauth_token", valid_598352
  var valid_598353 = query.getOrDefault("userIp")
  valid_598353 = validateParameter(valid_598353, JString, required = false,
                                 default = nil)
  if valid_598353 != nil:
    section.add "userIp", valid_598353
  var valid_598354 = query.getOrDefault("maxResults")
  valid_598354 = validateParameter(valid_598354, JInt, required = false,
                                 default = newJInt(500))
  if valid_598354 != nil:
    section.add "maxResults", valid_598354
  var valid_598355 = query.getOrDefault("orderBy")
  valid_598355 = validateParameter(valid_598355, JString, required = false,
                                 default = nil)
  if valid_598355 != nil:
    section.add "orderBy", valid_598355
  var valid_598356 = query.getOrDefault("key")
  valid_598356 = validateParameter(valid_598356, JString, required = false,
                                 default = nil)
  if valid_598356 != nil:
    section.add "key", valid_598356
  assert query != nil,
        "query argument is necessary due to required `instance` field"
  var valid_598357 = query.getOrDefault("instance")
  valid_598357 = validateParameter(valid_598357, JString, required = true,
                                 default = nil)
  if valid_598357 != nil:
    section.add "instance", valid_598357
  var valid_598358 = query.getOrDefault("prettyPrint")
  valid_598358 = validateParameter(valid_598358, JBool, required = false,
                                 default = newJBool(true))
  if valid_598358 != nil:
    section.add "prettyPrint", valid_598358
  var valid_598359 = query.getOrDefault("filter")
  valid_598359 = validateParameter(valid_598359, JString, required = false,
                                 default = nil)
  if valid_598359 != nil:
    section.add "filter", valid_598359
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598360: Call_ClouduseraccountsLinuxGetLinuxAccountViews_598343;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a list of user accounts for an instance within a specific project.
  ## 
  let valid = call_598360.validator(path, query, header, formData, body)
  let scheme = call_598360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598360.url(scheme.get, call_598360.host, call_598360.base,
                         call_598360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598360, url, valid)

proc call*(call_598361: Call_ClouduseraccountsLinuxGetLinuxAccountViews_598343;
          zone: string; instance: string; project: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 500;
          orderBy: string = ""; key: string = ""; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## clouduseraccountsLinuxGetLinuxAccountViews
  ## Retrieves a list of user accounts for an instance within a specific project.
  ##   zone: string (required)
  ##       : Name of the zone for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests.
  ##   orderBy: string
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : The fully-qualified URL of the virtual machine requesting the views.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
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
  var path_598362 = newJObject()
  var query_598363 = newJObject()
  add(path_598362, "zone", newJString(zone))
  add(query_598363, "fields", newJString(fields))
  add(query_598363, "pageToken", newJString(pageToken))
  add(query_598363, "quotaUser", newJString(quotaUser))
  add(query_598363, "alt", newJString(alt))
  add(query_598363, "oauth_token", newJString(oauthToken))
  add(query_598363, "userIp", newJString(userIp))
  add(query_598363, "maxResults", newJInt(maxResults))
  add(query_598363, "orderBy", newJString(orderBy))
  add(query_598363, "key", newJString(key))
  add(query_598363, "instance", newJString(instance))
  add(path_598362, "project", newJString(project))
  add(query_598363, "prettyPrint", newJBool(prettyPrint))
  add(query_598363, "filter", newJString(filter))
  result = call_598361.call(path_598362, query_598363, nil, nil, nil)

var clouduseraccountsLinuxGetLinuxAccountViews* = Call_ClouduseraccountsLinuxGetLinuxAccountViews_598343(
    name: "clouduseraccountsLinuxGetLinuxAccountViews", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/linuxAccountViews",
    validator: validate_ClouduseraccountsLinuxGetLinuxAccountViews_598344,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsLinuxGetLinuxAccountViews_598345,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
