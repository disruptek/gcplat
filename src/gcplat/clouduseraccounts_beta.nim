
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
    base: "/clouduseraccounts/beta/projects",
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
    base: "/clouduseraccounts/beta/projects",
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
    base: "/clouduseraccounts/beta/projects", url: url_ClouduseraccountsGroupsGet_598000,
    schemes: {Scheme.Https})
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
    base: "/clouduseraccounts/beta/projects",
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
    base: "/clouduseraccounts/beta/projects",
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
    base: "/clouduseraccounts/beta/projects",
    url: url_ClouduseraccountsGroupsRemoveMember_598050, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGlobalAccountsOperationsList_598066 = ref object of OpenApiRestCall_597424
proc url_ClouduseraccountsGlobalAccountsOperationsList_598068(protocol: Scheme;
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

proc validate_ClouduseraccountsGlobalAccountsOperationsList_598067(
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
  var valid_598069 = path.getOrDefault("project")
  valid_598069 = validateParameter(valid_598069, JString, required = true,
                                 default = nil)
  if valid_598069 != nil:
    section.add "project", valid_598069
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
  var valid_598070 = query.getOrDefault("fields")
  valid_598070 = validateParameter(valid_598070, JString, required = false,
                                 default = nil)
  if valid_598070 != nil:
    section.add "fields", valid_598070
  var valid_598071 = query.getOrDefault("pageToken")
  valid_598071 = validateParameter(valid_598071, JString, required = false,
                                 default = nil)
  if valid_598071 != nil:
    section.add "pageToken", valid_598071
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
  var valid_598076 = query.getOrDefault("maxResults")
  valid_598076 = validateParameter(valid_598076, JInt, required = false,
                                 default = newJInt(500))
  if valid_598076 != nil:
    section.add "maxResults", valid_598076
  var valid_598077 = query.getOrDefault("orderBy")
  valid_598077 = validateParameter(valid_598077, JString, required = false,
                                 default = nil)
  if valid_598077 != nil:
    section.add "orderBy", valid_598077
  var valid_598078 = query.getOrDefault("key")
  valid_598078 = validateParameter(valid_598078, JString, required = false,
                                 default = nil)
  if valid_598078 != nil:
    section.add "key", valid_598078
  var valid_598079 = query.getOrDefault("prettyPrint")
  valid_598079 = validateParameter(valid_598079, JBool, required = false,
                                 default = newJBool(true))
  if valid_598079 != nil:
    section.add "prettyPrint", valid_598079
  var valid_598080 = query.getOrDefault("filter")
  valid_598080 = validateParameter(valid_598080, JString, required = false,
                                 default = nil)
  if valid_598080 != nil:
    section.add "filter", valid_598080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598081: Call_ClouduseraccountsGlobalAccountsOperationsList_598066;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of operation resources contained within the specified project.
  ## 
  let valid = call_598081.validator(path, query, header, formData, body)
  let scheme = call_598081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598081.url(scheme.get, call_598081.host, call_598081.base,
                         call_598081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598081, url, valid)

proc call*(call_598082: Call_ClouduseraccountsGlobalAccountsOperationsList_598066;
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
  var path_598083 = newJObject()
  var query_598084 = newJObject()
  add(query_598084, "fields", newJString(fields))
  add(query_598084, "pageToken", newJString(pageToken))
  add(query_598084, "quotaUser", newJString(quotaUser))
  add(query_598084, "alt", newJString(alt))
  add(query_598084, "oauth_token", newJString(oauthToken))
  add(query_598084, "userIp", newJString(userIp))
  add(query_598084, "maxResults", newJInt(maxResults))
  add(query_598084, "orderBy", newJString(orderBy))
  add(query_598084, "key", newJString(key))
  add(path_598083, "project", newJString(project))
  add(query_598084, "prettyPrint", newJBool(prettyPrint))
  add(query_598084, "filter", newJString(filter))
  result = call_598082.call(path_598083, query_598084, nil, nil, nil)

var clouduseraccountsGlobalAccountsOperationsList* = Call_ClouduseraccountsGlobalAccountsOperationsList_598066(
    name: "clouduseraccountsGlobalAccountsOperationsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{project}/global/operations",
    validator: validate_ClouduseraccountsGlobalAccountsOperationsList_598067,
    base: "/clouduseraccounts/beta/projects",
    url: url_ClouduseraccountsGlobalAccountsOperationsList_598068,
    schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGlobalAccountsOperationsGet_598085 = ref object of OpenApiRestCall_597424
proc url_ClouduseraccountsGlobalAccountsOperationsGet_598087(protocol: Scheme;
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

proc validate_ClouduseraccountsGlobalAccountsOperationsGet_598086(path: JsonNode;
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
  var valid_598088 = path.getOrDefault("operation")
  valid_598088 = validateParameter(valid_598088, JString, required = true,
                                 default = nil)
  if valid_598088 != nil:
    section.add "operation", valid_598088
  var valid_598089 = path.getOrDefault("project")
  valid_598089 = validateParameter(valid_598089, JString, required = true,
                                 default = nil)
  if valid_598089 != nil:
    section.add "project", valid_598089
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
  var valid_598090 = query.getOrDefault("fields")
  valid_598090 = validateParameter(valid_598090, JString, required = false,
                                 default = nil)
  if valid_598090 != nil:
    section.add "fields", valid_598090
  var valid_598091 = query.getOrDefault("quotaUser")
  valid_598091 = validateParameter(valid_598091, JString, required = false,
                                 default = nil)
  if valid_598091 != nil:
    section.add "quotaUser", valid_598091
  var valid_598092 = query.getOrDefault("alt")
  valid_598092 = validateParameter(valid_598092, JString, required = false,
                                 default = newJString("json"))
  if valid_598092 != nil:
    section.add "alt", valid_598092
  var valid_598093 = query.getOrDefault("oauth_token")
  valid_598093 = validateParameter(valid_598093, JString, required = false,
                                 default = nil)
  if valid_598093 != nil:
    section.add "oauth_token", valid_598093
  var valid_598094 = query.getOrDefault("userIp")
  valid_598094 = validateParameter(valid_598094, JString, required = false,
                                 default = nil)
  if valid_598094 != nil:
    section.add "userIp", valid_598094
  var valid_598095 = query.getOrDefault("key")
  valid_598095 = validateParameter(valid_598095, JString, required = false,
                                 default = nil)
  if valid_598095 != nil:
    section.add "key", valid_598095
  var valid_598096 = query.getOrDefault("prettyPrint")
  valid_598096 = validateParameter(valid_598096, JBool, required = false,
                                 default = newJBool(true))
  if valid_598096 != nil:
    section.add "prettyPrint", valid_598096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598097: Call_ClouduseraccountsGlobalAccountsOperationsGet_598085;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the specified operation resource.
  ## 
  let valid = call_598097.validator(path, query, header, formData, body)
  let scheme = call_598097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598097.url(scheme.get, call_598097.host, call_598097.base,
                         call_598097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598097, url, valid)

proc call*(call_598098: Call_ClouduseraccountsGlobalAccountsOperationsGet_598085;
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
  var path_598099 = newJObject()
  var query_598100 = newJObject()
  add(query_598100, "fields", newJString(fields))
  add(query_598100, "quotaUser", newJString(quotaUser))
  add(query_598100, "alt", newJString(alt))
  add(path_598099, "operation", newJString(operation))
  add(query_598100, "oauth_token", newJString(oauthToken))
  add(query_598100, "userIp", newJString(userIp))
  add(query_598100, "key", newJString(key))
  add(path_598099, "project", newJString(project))
  add(query_598100, "prettyPrint", newJBool(prettyPrint))
  result = call_598098.call(path_598099, query_598100, nil, nil, nil)

var clouduseraccountsGlobalAccountsOperationsGet* = Call_ClouduseraccountsGlobalAccountsOperationsGet_598085(
    name: "clouduseraccountsGlobalAccountsOperationsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{project}/global/operations/{operation}",
    validator: validate_ClouduseraccountsGlobalAccountsOperationsGet_598086,
    base: "/clouduseraccounts/beta/projects",
    url: url_ClouduseraccountsGlobalAccountsOperationsGet_598087,
    schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGlobalAccountsOperationsDelete_598101 = ref object of OpenApiRestCall_597424
proc url_ClouduseraccountsGlobalAccountsOperationsDelete_598103(protocol: Scheme;
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

proc validate_ClouduseraccountsGlobalAccountsOperationsDelete_598102(
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
  var valid_598104 = path.getOrDefault("operation")
  valid_598104 = validateParameter(valid_598104, JString, required = true,
                                 default = nil)
  if valid_598104 != nil:
    section.add "operation", valid_598104
  var valid_598105 = path.getOrDefault("project")
  valid_598105 = validateParameter(valid_598105, JString, required = true,
                                 default = nil)
  if valid_598105 != nil:
    section.add "project", valid_598105
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
  var valid_598106 = query.getOrDefault("fields")
  valid_598106 = validateParameter(valid_598106, JString, required = false,
                                 default = nil)
  if valid_598106 != nil:
    section.add "fields", valid_598106
  var valid_598107 = query.getOrDefault("quotaUser")
  valid_598107 = validateParameter(valid_598107, JString, required = false,
                                 default = nil)
  if valid_598107 != nil:
    section.add "quotaUser", valid_598107
  var valid_598108 = query.getOrDefault("alt")
  valid_598108 = validateParameter(valid_598108, JString, required = false,
                                 default = newJString("json"))
  if valid_598108 != nil:
    section.add "alt", valid_598108
  var valid_598109 = query.getOrDefault("oauth_token")
  valid_598109 = validateParameter(valid_598109, JString, required = false,
                                 default = nil)
  if valid_598109 != nil:
    section.add "oauth_token", valid_598109
  var valid_598110 = query.getOrDefault("userIp")
  valid_598110 = validateParameter(valid_598110, JString, required = false,
                                 default = nil)
  if valid_598110 != nil:
    section.add "userIp", valid_598110
  var valid_598111 = query.getOrDefault("key")
  valid_598111 = validateParameter(valid_598111, JString, required = false,
                                 default = nil)
  if valid_598111 != nil:
    section.add "key", valid_598111
  var valid_598112 = query.getOrDefault("prettyPrint")
  valid_598112 = validateParameter(valid_598112, JBool, required = false,
                                 default = newJBool(true))
  if valid_598112 != nil:
    section.add "prettyPrint", valid_598112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598113: Call_ClouduseraccountsGlobalAccountsOperationsDelete_598101;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified operation resource.
  ## 
  let valid = call_598113.validator(path, query, header, formData, body)
  let scheme = call_598113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598113.url(scheme.get, call_598113.host, call_598113.base,
                         call_598113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598113, url, valid)

proc call*(call_598114: Call_ClouduseraccountsGlobalAccountsOperationsDelete_598101;
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
  var path_598115 = newJObject()
  var query_598116 = newJObject()
  add(query_598116, "fields", newJString(fields))
  add(query_598116, "quotaUser", newJString(quotaUser))
  add(query_598116, "alt", newJString(alt))
  add(path_598115, "operation", newJString(operation))
  add(query_598116, "oauth_token", newJString(oauthToken))
  add(query_598116, "userIp", newJString(userIp))
  add(query_598116, "key", newJString(key))
  add(path_598115, "project", newJString(project))
  add(query_598116, "prettyPrint", newJBool(prettyPrint))
  result = call_598114.call(path_598115, query_598116, nil, nil, nil)

var clouduseraccountsGlobalAccountsOperationsDelete* = Call_ClouduseraccountsGlobalAccountsOperationsDelete_598101(
    name: "clouduseraccountsGlobalAccountsOperationsDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/{project}/global/operations/{operation}",
    validator: validate_ClouduseraccountsGlobalAccountsOperationsDelete_598102,
    base: "/clouduseraccounts/beta/projects",
    url: url_ClouduseraccountsGlobalAccountsOperationsDelete_598103,
    schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersInsert_598136 = ref object of OpenApiRestCall_597424
proc url_ClouduseraccountsUsersInsert_598138(protocol: Scheme; host: string;
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

proc validate_ClouduseraccountsUsersInsert_598137(path: JsonNode; query: JsonNode;
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
  var valid_598139 = path.getOrDefault("project")
  valid_598139 = validateParameter(valid_598139, JString, required = true,
                                 default = nil)
  if valid_598139 != nil:
    section.add "project", valid_598139
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
  var valid_598140 = query.getOrDefault("fields")
  valid_598140 = validateParameter(valid_598140, JString, required = false,
                                 default = nil)
  if valid_598140 != nil:
    section.add "fields", valid_598140
  var valid_598141 = query.getOrDefault("quotaUser")
  valid_598141 = validateParameter(valid_598141, JString, required = false,
                                 default = nil)
  if valid_598141 != nil:
    section.add "quotaUser", valid_598141
  var valid_598142 = query.getOrDefault("alt")
  valid_598142 = validateParameter(valid_598142, JString, required = false,
                                 default = newJString("json"))
  if valid_598142 != nil:
    section.add "alt", valid_598142
  var valid_598143 = query.getOrDefault("oauth_token")
  valid_598143 = validateParameter(valid_598143, JString, required = false,
                                 default = nil)
  if valid_598143 != nil:
    section.add "oauth_token", valid_598143
  var valid_598144 = query.getOrDefault("userIp")
  valid_598144 = validateParameter(valid_598144, JString, required = false,
                                 default = nil)
  if valid_598144 != nil:
    section.add "userIp", valid_598144
  var valid_598145 = query.getOrDefault("key")
  valid_598145 = validateParameter(valid_598145, JString, required = false,
                                 default = nil)
  if valid_598145 != nil:
    section.add "key", valid_598145
  var valid_598146 = query.getOrDefault("prettyPrint")
  valid_598146 = validateParameter(valid_598146, JBool, required = false,
                                 default = newJBool(true))
  if valid_598146 != nil:
    section.add "prettyPrint", valid_598146
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

proc call*(call_598148: Call_ClouduseraccountsUsersInsert_598136; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a User resource in the specified project using the data included in the request.
  ## 
  let valid = call_598148.validator(path, query, header, formData, body)
  let scheme = call_598148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598148.url(scheme.get, call_598148.host, call_598148.base,
                         call_598148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598148, url, valid)

proc call*(call_598149: Call_ClouduseraccountsUsersInsert_598136; project: string;
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
  var path_598150 = newJObject()
  var query_598151 = newJObject()
  var body_598152 = newJObject()
  add(query_598151, "fields", newJString(fields))
  add(query_598151, "quotaUser", newJString(quotaUser))
  add(query_598151, "alt", newJString(alt))
  add(query_598151, "oauth_token", newJString(oauthToken))
  add(query_598151, "userIp", newJString(userIp))
  add(query_598151, "key", newJString(key))
  add(path_598150, "project", newJString(project))
  if body != nil:
    body_598152 = body
  add(query_598151, "prettyPrint", newJBool(prettyPrint))
  result = call_598149.call(path_598150, query_598151, nil, nil, body_598152)

var clouduseraccountsUsersInsert* = Call_ClouduseraccountsUsersInsert_598136(
    name: "clouduseraccountsUsersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/global/users",
    validator: validate_ClouduseraccountsUsersInsert_598137,
    base: "/clouduseraccounts/beta/projects",
    url: url_ClouduseraccountsUsersInsert_598138, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersList_598117 = ref object of OpenApiRestCall_597424
proc url_ClouduseraccountsUsersList_598119(protocol: Scheme; host: string;
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

proc validate_ClouduseraccountsUsersList_598118(path: JsonNode; query: JsonNode;
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
  var valid_598120 = path.getOrDefault("project")
  valid_598120 = validateParameter(valid_598120, JString, required = true,
                                 default = nil)
  if valid_598120 != nil:
    section.add "project", valid_598120
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
  var valid_598121 = query.getOrDefault("fields")
  valid_598121 = validateParameter(valid_598121, JString, required = false,
                                 default = nil)
  if valid_598121 != nil:
    section.add "fields", valid_598121
  var valid_598122 = query.getOrDefault("pageToken")
  valid_598122 = validateParameter(valid_598122, JString, required = false,
                                 default = nil)
  if valid_598122 != nil:
    section.add "pageToken", valid_598122
  var valid_598123 = query.getOrDefault("quotaUser")
  valid_598123 = validateParameter(valid_598123, JString, required = false,
                                 default = nil)
  if valid_598123 != nil:
    section.add "quotaUser", valid_598123
  var valid_598124 = query.getOrDefault("alt")
  valid_598124 = validateParameter(valid_598124, JString, required = false,
                                 default = newJString("json"))
  if valid_598124 != nil:
    section.add "alt", valid_598124
  var valid_598125 = query.getOrDefault("oauth_token")
  valid_598125 = validateParameter(valid_598125, JString, required = false,
                                 default = nil)
  if valid_598125 != nil:
    section.add "oauth_token", valid_598125
  var valid_598126 = query.getOrDefault("userIp")
  valid_598126 = validateParameter(valid_598126, JString, required = false,
                                 default = nil)
  if valid_598126 != nil:
    section.add "userIp", valid_598126
  var valid_598127 = query.getOrDefault("maxResults")
  valid_598127 = validateParameter(valid_598127, JInt, required = false,
                                 default = newJInt(500))
  if valid_598127 != nil:
    section.add "maxResults", valid_598127
  var valid_598128 = query.getOrDefault("orderBy")
  valid_598128 = validateParameter(valid_598128, JString, required = false,
                                 default = nil)
  if valid_598128 != nil:
    section.add "orderBy", valid_598128
  var valid_598129 = query.getOrDefault("key")
  valid_598129 = validateParameter(valid_598129, JString, required = false,
                                 default = nil)
  if valid_598129 != nil:
    section.add "key", valid_598129
  var valid_598130 = query.getOrDefault("prettyPrint")
  valid_598130 = validateParameter(valid_598130, JBool, required = false,
                                 default = newJBool(true))
  if valid_598130 != nil:
    section.add "prettyPrint", valid_598130
  var valid_598131 = query.getOrDefault("filter")
  valid_598131 = validateParameter(valid_598131, JString, required = false,
                                 default = nil)
  if valid_598131 != nil:
    section.add "filter", valid_598131
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598132: Call_ClouduseraccountsUsersList_598117; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of users contained within the specified project.
  ## 
  let valid = call_598132.validator(path, query, header, formData, body)
  let scheme = call_598132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598132.url(scheme.get, call_598132.host, call_598132.base,
                         call_598132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598132, url, valid)

proc call*(call_598133: Call_ClouduseraccountsUsersList_598117; project: string;
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
  var path_598134 = newJObject()
  var query_598135 = newJObject()
  add(query_598135, "fields", newJString(fields))
  add(query_598135, "pageToken", newJString(pageToken))
  add(query_598135, "quotaUser", newJString(quotaUser))
  add(query_598135, "alt", newJString(alt))
  add(query_598135, "oauth_token", newJString(oauthToken))
  add(query_598135, "userIp", newJString(userIp))
  add(query_598135, "maxResults", newJInt(maxResults))
  add(query_598135, "orderBy", newJString(orderBy))
  add(query_598135, "key", newJString(key))
  add(path_598134, "project", newJString(project))
  add(query_598135, "prettyPrint", newJBool(prettyPrint))
  add(query_598135, "filter", newJString(filter))
  result = call_598133.call(path_598134, query_598135, nil, nil, nil)

var clouduseraccountsUsersList* = Call_ClouduseraccountsUsersList_598117(
    name: "clouduseraccountsUsersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/users",
    validator: validate_ClouduseraccountsUsersList_598118,
    base: "/clouduseraccounts/beta/projects", url: url_ClouduseraccountsUsersList_598119,
    schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersGet_598153 = ref object of OpenApiRestCall_597424
proc url_ClouduseraccountsUsersGet_598155(protocol: Scheme; host: string;
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

proc validate_ClouduseraccountsUsersGet_598154(path: JsonNode; query: JsonNode;
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
  var valid_598156 = path.getOrDefault("user")
  valid_598156 = validateParameter(valid_598156, JString, required = true,
                                 default = nil)
  if valid_598156 != nil:
    section.add "user", valid_598156
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

proc call*(call_598165: Call_ClouduseraccountsUsersGet_598153; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specified User resource.
  ## 
  let valid = call_598165.validator(path, query, header, formData, body)
  let scheme = call_598165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598165.url(scheme.get, call_598165.host, call_598165.base,
                         call_598165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598165, url, valid)

proc call*(call_598166: Call_ClouduseraccountsUsersGet_598153; user: string;
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
  var path_598167 = newJObject()
  var query_598168 = newJObject()
  add(query_598168, "fields", newJString(fields))
  add(query_598168, "quotaUser", newJString(quotaUser))
  add(query_598168, "alt", newJString(alt))
  add(path_598167, "user", newJString(user))
  add(query_598168, "oauth_token", newJString(oauthToken))
  add(query_598168, "userIp", newJString(userIp))
  add(query_598168, "key", newJString(key))
  add(path_598167, "project", newJString(project))
  add(query_598168, "prettyPrint", newJBool(prettyPrint))
  result = call_598166.call(path_598167, query_598168, nil, nil, nil)

var clouduseraccountsUsersGet* = Call_ClouduseraccountsUsersGet_598153(
    name: "clouduseraccountsUsersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/users/{user}",
    validator: validate_ClouduseraccountsUsersGet_598154,
    base: "/clouduseraccounts/beta/projects", url: url_ClouduseraccountsUsersGet_598155,
    schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersDelete_598169 = ref object of OpenApiRestCall_597424
proc url_ClouduseraccountsUsersDelete_598171(protocol: Scheme; host: string;
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

proc validate_ClouduseraccountsUsersDelete_598170(path: JsonNode; query: JsonNode;
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
  var valid_598172 = path.getOrDefault("user")
  valid_598172 = validateParameter(valid_598172, JString, required = true,
                                 default = nil)
  if valid_598172 != nil:
    section.add "user", valid_598172
  var valid_598173 = path.getOrDefault("project")
  valid_598173 = validateParameter(valid_598173, JString, required = true,
                                 default = nil)
  if valid_598173 != nil:
    section.add "project", valid_598173
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
  var valid_598174 = query.getOrDefault("fields")
  valid_598174 = validateParameter(valid_598174, JString, required = false,
                                 default = nil)
  if valid_598174 != nil:
    section.add "fields", valid_598174
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
  var valid_598179 = query.getOrDefault("key")
  valid_598179 = validateParameter(valid_598179, JString, required = false,
                                 default = nil)
  if valid_598179 != nil:
    section.add "key", valid_598179
  var valid_598180 = query.getOrDefault("prettyPrint")
  valid_598180 = validateParameter(valid_598180, JBool, required = false,
                                 default = newJBool(true))
  if valid_598180 != nil:
    section.add "prettyPrint", valid_598180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598181: Call_ClouduseraccountsUsersDelete_598169; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified User resource.
  ## 
  let valid = call_598181.validator(path, query, header, formData, body)
  let scheme = call_598181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598181.url(scheme.get, call_598181.host, call_598181.base,
                         call_598181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598181, url, valid)

proc call*(call_598182: Call_ClouduseraccountsUsersDelete_598169; user: string;
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
  var path_598183 = newJObject()
  var query_598184 = newJObject()
  add(query_598184, "fields", newJString(fields))
  add(query_598184, "quotaUser", newJString(quotaUser))
  add(query_598184, "alt", newJString(alt))
  add(path_598183, "user", newJString(user))
  add(query_598184, "oauth_token", newJString(oauthToken))
  add(query_598184, "userIp", newJString(userIp))
  add(query_598184, "key", newJString(key))
  add(path_598183, "project", newJString(project))
  add(query_598184, "prettyPrint", newJBool(prettyPrint))
  result = call_598182.call(path_598183, query_598184, nil, nil, nil)

var clouduseraccountsUsersDelete* = Call_ClouduseraccountsUsersDelete_598169(
    name: "clouduseraccountsUsersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{project}/global/users/{user}",
    validator: validate_ClouduseraccountsUsersDelete_598170,
    base: "/clouduseraccounts/beta/projects",
    url: url_ClouduseraccountsUsersDelete_598171, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersAddPublicKey_598185 = ref object of OpenApiRestCall_597424
proc url_ClouduseraccountsUsersAddPublicKey_598187(protocol: Scheme; host: string;
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

proc validate_ClouduseraccountsUsersAddPublicKey_598186(path: JsonNode;
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
  var valid_598188 = path.getOrDefault("user")
  valid_598188 = validateParameter(valid_598188, JString, required = true,
                                 default = nil)
  if valid_598188 != nil:
    section.add "user", valid_598188
  var valid_598189 = path.getOrDefault("project")
  valid_598189 = validateParameter(valid_598189, JString, required = true,
                                 default = nil)
  if valid_598189 != nil:
    section.add "project", valid_598189
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
  var valid_598190 = query.getOrDefault("fields")
  valid_598190 = validateParameter(valid_598190, JString, required = false,
                                 default = nil)
  if valid_598190 != nil:
    section.add "fields", valid_598190
  var valid_598191 = query.getOrDefault("quotaUser")
  valid_598191 = validateParameter(valid_598191, JString, required = false,
                                 default = nil)
  if valid_598191 != nil:
    section.add "quotaUser", valid_598191
  var valid_598192 = query.getOrDefault("alt")
  valid_598192 = validateParameter(valid_598192, JString, required = false,
                                 default = newJString("json"))
  if valid_598192 != nil:
    section.add "alt", valid_598192
  var valid_598193 = query.getOrDefault("oauth_token")
  valid_598193 = validateParameter(valid_598193, JString, required = false,
                                 default = nil)
  if valid_598193 != nil:
    section.add "oauth_token", valid_598193
  var valid_598194 = query.getOrDefault("userIp")
  valid_598194 = validateParameter(valid_598194, JString, required = false,
                                 default = nil)
  if valid_598194 != nil:
    section.add "userIp", valid_598194
  var valid_598195 = query.getOrDefault("key")
  valid_598195 = validateParameter(valid_598195, JString, required = false,
                                 default = nil)
  if valid_598195 != nil:
    section.add "key", valid_598195
  var valid_598196 = query.getOrDefault("prettyPrint")
  valid_598196 = validateParameter(valid_598196, JBool, required = false,
                                 default = newJBool(true))
  if valid_598196 != nil:
    section.add "prettyPrint", valid_598196
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

proc call*(call_598198: Call_ClouduseraccountsUsersAddPublicKey_598185;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a public key to the specified User resource with the data included in the request.
  ## 
  let valid = call_598198.validator(path, query, header, formData, body)
  let scheme = call_598198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598198.url(scheme.get, call_598198.host, call_598198.base,
                         call_598198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598198, url, valid)

proc call*(call_598199: Call_ClouduseraccountsUsersAddPublicKey_598185;
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
  var path_598200 = newJObject()
  var query_598201 = newJObject()
  var body_598202 = newJObject()
  add(query_598201, "fields", newJString(fields))
  add(query_598201, "quotaUser", newJString(quotaUser))
  add(query_598201, "alt", newJString(alt))
  add(path_598200, "user", newJString(user))
  add(query_598201, "oauth_token", newJString(oauthToken))
  add(query_598201, "userIp", newJString(userIp))
  add(query_598201, "key", newJString(key))
  add(path_598200, "project", newJString(project))
  if body != nil:
    body_598202 = body
  add(query_598201, "prettyPrint", newJBool(prettyPrint))
  result = call_598199.call(path_598200, query_598201, nil, nil, body_598202)

var clouduseraccountsUsersAddPublicKey* = Call_ClouduseraccountsUsersAddPublicKey_598185(
    name: "clouduseraccountsUsersAddPublicKey", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/users/{user}/addPublicKey",
    validator: validate_ClouduseraccountsUsersAddPublicKey_598186,
    base: "/clouduseraccounts/beta/projects",
    url: url_ClouduseraccountsUsersAddPublicKey_598187, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersRemovePublicKey_598203 = ref object of OpenApiRestCall_597424
proc url_ClouduseraccountsUsersRemovePublicKey_598205(protocol: Scheme;
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

proc validate_ClouduseraccountsUsersRemovePublicKey_598204(path: JsonNode;
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
  var valid_598206 = path.getOrDefault("user")
  valid_598206 = validateParameter(valid_598206, JString, required = true,
                                 default = nil)
  if valid_598206 != nil:
    section.add "user", valid_598206
  var valid_598207 = path.getOrDefault("project")
  valid_598207 = validateParameter(valid_598207, JString, required = true,
                                 default = nil)
  if valid_598207 != nil:
    section.add "project", valid_598207
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
  var valid_598208 = query.getOrDefault("fields")
  valid_598208 = validateParameter(valid_598208, JString, required = false,
                                 default = nil)
  if valid_598208 != nil:
    section.add "fields", valid_598208
  assert query != nil,
        "query argument is necessary due to required `fingerprint` field"
  var valid_598209 = query.getOrDefault("fingerprint")
  valid_598209 = validateParameter(valid_598209, JString, required = true,
                                 default = nil)
  if valid_598209 != nil:
    section.add "fingerprint", valid_598209
  var valid_598210 = query.getOrDefault("quotaUser")
  valid_598210 = validateParameter(valid_598210, JString, required = false,
                                 default = nil)
  if valid_598210 != nil:
    section.add "quotaUser", valid_598210
  var valid_598211 = query.getOrDefault("alt")
  valid_598211 = validateParameter(valid_598211, JString, required = false,
                                 default = newJString("json"))
  if valid_598211 != nil:
    section.add "alt", valid_598211
  var valid_598212 = query.getOrDefault("oauth_token")
  valid_598212 = validateParameter(valid_598212, JString, required = false,
                                 default = nil)
  if valid_598212 != nil:
    section.add "oauth_token", valid_598212
  var valid_598213 = query.getOrDefault("userIp")
  valid_598213 = validateParameter(valid_598213, JString, required = false,
                                 default = nil)
  if valid_598213 != nil:
    section.add "userIp", valid_598213
  var valid_598214 = query.getOrDefault("key")
  valid_598214 = validateParameter(valid_598214, JString, required = false,
                                 default = nil)
  if valid_598214 != nil:
    section.add "key", valid_598214
  var valid_598215 = query.getOrDefault("prettyPrint")
  valid_598215 = validateParameter(valid_598215, JBool, required = false,
                                 default = newJBool(true))
  if valid_598215 != nil:
    section.add "prettyPrint", valid_598215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598216: Call_ClouduseraccountsUsersRemovePublicKey_598203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes the specified public key from the user.
  ## 
  let valid = call_598216.validator(path, query, header, formData, body)
  let scheme = call_598216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598216.url(scheme.get, call_598216.host, call_598216.base,
                         call_598216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598216, url, valid)

proc call*(call_598217: Call_ClouduseraccountsUsersRemovePublicKey_598203;
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
  var path_598218 = newJObject()
  var query_598219 = newJObject()
  add(query_598219, "fields", newJString(fields))
  add(query_598219, "fingerprint", newJString(fingerprint))
  add(query_598219, "quotaUser", newJString(quotaUser))
  add(query_598219, "alt", newJString(alt))
  add(path_598218, "user", newJString(user))
  add(query_598219, "oauth_token", newJString(oauthToken))
  add(query_598219, "userIp", newJString(userIp))
  add(query_598219, "key", newJString(key))
  add(path_598218, "project", newJString(project))
  add(query_598219, "prettyPrint", newJBool(prettyPrint))
  result = call_598217.call(path_598218, query_598219, nil, nil, nil)

var clouduseraccountsUsersRemovePublicKey* = Call_ClouduseraccountsUsersRemovePublicKey_598203(
    name: "clouduseraccountsUsersRemovePublicKey", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/users/{user}/removePublicKey",
    validator: validate_ClouduseraccountsUsersRemovePublicKey_598204,
    base: "/clouduseraccounts/beta/projects",
    url: url_ClouduseraccountsUsersRemovePublicKey_598205, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsLinuxGetAuthorizedKeysView_598220 = ref object of OpenApiRestCall_597424
proc url_ClouduseraccountsLinuxGetAuthorizedKeysView_598222(protocol: Scheme;
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

proc validate_ClouduseraccountsLinuxGetAuthorizedKeysView_598221(path: JsonNode;
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
  var valid_598223 = path.getOrDefault("zone")
  valid_598223 = validateParameter(valid_598223, JString, required = true,
                                 default = nil)
  if valid_598223 != nil:
    section.add "zone", valid_598223
  var valid_598224 = path.getOrDefault("user")
  valid_598224 = validateParameter(valid_598224, JString, required = true,
                                 default = nil)
  if valid_598224 != nil:
    section.add "user", valid_598224
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
  var valid_598229 = query.getOrDefault("login")
  valid_598229 = validateParameter(valid_598229, JBool, required = false, default = nil)
  if valid_598229 != nil:
    section.add "login", valid_598229
  var valid_598230 = query.getOrDefault("oauth_token")
  valid_598230 = validateParameter(valid_598230, JString, required = false,
                                 default = nil)
  if valid_598230 != nil:
    section.add "oauth_token", valid_598230
  var valid_598231 = query.getOrDefault("userIp")
  valid_598231 = validateParameter(valid_598231, JString, required = false,
                                 default = nil)
  if valid_598231 != nil:
    section.add "userIp", valid_598231
  var valid_598232 = query.getOrDefault("key")
  valid_598232 = validateParameter(valid_598232, JString, required = false,
                                 default = nil)
  if valid_598232 != nil:
    section.add "key", valid_598232
  assert query != nil,
        "query argument is necessary due to required `instance` field"
  var valid_598233 = query.getOrDefault("instance")
  valid_598233 = validateParameter(valid_598233, JString, required = true,
                                 default = nil)
  if valid_598233 != nil:
    section.add "instance", valid_598233
  var valid_598234 = query.getOrDefault("prettyPrint")
  valid_598234 = validateParameter(valid_598234, JBool, required = false,
                                 default = newJBool(true))
  if valid_598234 != nil:
    section.add "prettyPrint", valid_598234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598235: Call_ClouduseraccountsLinuxGetAuthorizedKeysView_598220;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of authorized public keys for a specific user account.
  ## 
  let valid = call_598235.validator(path, query, header, formData, body)
  let scheme = call_598235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598235.url(scheme.get, call_598235.host, call_598235.base,
                         call_598235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598235, url, valid)

proc call*(call_598236: Call_ClouduseraccountsLinuxGetAuthorizedKeysView_598220;
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
  var path_598237 = newJObject()
  var query_598238 = newJObject()
  add(path_598237, "zone", newJString(zone))
  add(query_598238, "fields", newJString(fields))
  add(query_598238, "quotaUser", newJString(quotaUser))
  add(query_598238, "alt", newJString(alt))
  add(path_598237, "user", newJString(user))
  add(query_598238, "login", newJBool(login))
  add(query_598238, "oauth_token", newJString(oauthToken))
  add(query_598238, "userIp", newJString(userIp))
  add(query_598238, "key", newJString(key))
  add(query_598238, "instance", newJString(instance))
  add(path_598237, "project", newJString(project))
  add(query_598238, "prettyPrint", newJBool(prettyPrint))
  result = call_598236.call(path_598237, query_598238, nil, nil, nil)

var clouduseraccountsLinuxGetAuthorizedKeysView* = Call_ClouduseraccountsLinuxGetAuthorizedKeysView_598220(
    name: "clouduseraccountsLinuxGetAuthorizedKeysView",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/authorizedKeysView/{user}",
    validator: validate_ClouduseraccountsLinuxGetAuthorizedKeysView_598221,
    base: "/clouduseraccounts/beta/projects",
    url: url_ClouduseraccountsLinuxGetAuthorizedKeysView_598222,
    schemes: {Scheme.Https})
type
  Call_ClouduseraccountsLinuxGetLinuxAccountViews_598239 = ref object of OpenApiRestCall_597424
proc url_ClouduseraccountsLinuxGetLinuxAccountViews_598241(protocol: Scheme;
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

proc validate_ClouduseraccountsLinuxGetLinuxAccountViews_598240(path: JsonNode;
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
  var valid_598242 = path.getOrDefault("zone")
  valid_598242 = validateParameter(valid_598242, JString, required = true,
                                 default = nil)
  if valid_598242 != nil:
    section.add "zone", valid_598242
  var valid_598243 = path.getOrDefault("project")
  valid_598243 = validateParameter(valid_598243, JString, required = true,
                                 default = nil)
  if valid_598243 != nil:
    section.add "project", valid_598243
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
  var valid_598244 = query.getOrDefault("fields")
  valid_598244 = validateParameter(valid_598244, JString, required = false,
                                 default = nil)
  if valid_598244 != nil:
    section.add "fields", valid_598244
  var valid_598245 = query.getOrDefault("pageToken")
  valid_598245 = validateParameter(valid_598245, JString, required = false,
                                 default = nil)
  if valid_598245 != nil:
    section.add "pageToken", valid_598245
  var valid_598246 = query.getOrDefault("quotaUser")
  valid_598246 = validateParameter(valid_598246, JString, required = false,
                                 default = nil)
  if valid_598246 != nil:
    section.add "quotaUser", valid_598246
  var valid_598247 = query.getOrDefault("alt")
  valid_598247 = validateParameter(valid_598247, JString, required = false,
                                 default = newJString("json"))
  if valid_598247 != nil:
    section.add "alt", valid_598247
  var valid_598248 = query.getOrDefault("oauth_token")
  valid_598248 = validateParameter(valid_598248, JString, required = false,
                                 default = nil)
  if valid_598248 != nil:
    section.add "oauth_token", valid_598248
  var valid_598249 = query.getOrDefault("userIp")
  valid_598249 = validateParameter(valid_598249, JString, required = false,
                                 default = nil)
  if valid_598249 != nil:
    section.add "userIp", valid_598249
  var valid_598250 = query.getOrDefault("maxResults")
  valid_598250 = validateParameter(valid_598250, JInt, required = false,
                                 default = newJInt(500))
  if valid_598250 != nil:
    section.add "maxResults", valid_598250
  var valid_598251 = query.getOrDefault("orderBy")
  valid_598251 = validateParameter(valid_598251, JString, required = false,
                                 default = nil)
  if valid_598251 != nil:
    section.add "orderBy", valid_598251
  var valid_598252 = query.getOrDefault("key")
  valid_598252 = validateParameter(valid_598252, JString, required = false,
                                 default = nil)
  if valid_598252 != nil:
    section.add "key", valid_598252
  assert query != nil,
        "query argument is necessary due to required `instance` field"
  var valid_598253 = query.getOrDefault("instance")
  valid_598253 = validateParameter(valid_598253, JString, required = true,
                                 default = nil)
  if valid_598253 != nil:
    section.add "instance", valid_598253
  var valid_598254 = query.getOrDefault("prettyPrint")
  valid_598254 = validateParameter(valid_598254, JBool, required = false,
                                 default = newJBool(true))
  if valid_598254 != nil:
    section.add "prettyPrint", valid_598254
  var valid_598255 = query.getOrDefault("filter")
  valid_598255 = validateParameter(valid_598255, JString, required = false,
                                 default = nil)
  if valid_598255 != nil:
    section.add "filter", valid_598255
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598256: Call_ClouduseraccountsLinuxGetLinuxAccountViews_598239;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a list of user accounts for an instance within a specific project.
  ## 
  let valid = call_598256.validator(path, query, header, formData, body)
  let scheme = call_598256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598256.url(scheme.get, call_598256.host, call_598256.base,
                         call_598256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598256, url, valid)

proc call*(call_598257: Call_ClouduseraccountsLinuxGetLinuxAccountViews_598239;
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
  var path_598258 = newJObject()
  var query_598259 = newJObject()
  add(path_598258, "zone", newJString(zone))
  add(query_598259, "fields", newJString(fields))
  add(query_598259, "pageToken", newJString(pageToken))
  add(query_598259, "quotaUser", newJString(quotaUser))
  add(query_598259, "alt", newJString(alt))
  add(query_598259, "oauth_token", newJString(oauthToken))
  add(query_598259, "userIp", newJString(userIp))
  add(query_598259, "maxResults", newJInt(maxResults))
  add(query_598259, "orderBy", newJString(orderBy))
  add(query_598259, "key", newJString(key))
  add(query_598259, "instance", newJString(instance))
  add(path_598258, "project", newJString(project))
  add(query_598259, "prettyPrint", newJBool(prettyPrint))
  add(query_598259, "filter", newJString(filter))
  result = call_598257.call(path_598258, query_598259, nil, nil, nil)

var clouduseraccountsLinuxGetLinuxAccountViews* = Call_ClouduseraccountsLinuxGetLinuxAccountViews_598239(
    name: "clouduseraccountsLinuxGetLinuxAccountViews", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/linuxAccountViews",
    validator: validate_ClouduseraccountsLinuxGetLinuxAccountViews_598240,
    base: "/clouduseraccounts/beta/projects",
    url: url_ClouduseraccountsLinuxGetLinuxAccountViews_598241,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
