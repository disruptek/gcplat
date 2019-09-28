
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud User Accounts
## version: vm_alpha
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

  OpenApiRestCall_579424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579424): Option[Scheme] {.used.} =
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
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ClouduseraccountsGroupsInsert_579981 = ref object of OpenApiRestCall_579424
proc url_ClouduseraccountsGroupsInsert_579983(protocol: Scheme; host: string;
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

proc validate_ClouduseraccountsGroupsInsert_579982(path: JsonNode; query: JsonNode;
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
  var valid_579984 = path.getOrDefault("project")
  valid_579984 = validateParameter(valid_579984, JString, required = true,
                                 default = nil)
  if valid_579984 != nil:
    section.add "project", valid_579984
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
  var valid_579985 = query.getOrDefault("fields")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "fields", valid_579985
  var valid_579986 = query.getOrDefault("quotaUser")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "quotaUser", valid_579986
  var valid_579987 = query.getOrDefault("alt")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = newJString("json"))
  if valid_579987 != nil:
    section.add "alt", valid_579987
  var valid_579988 = query.getOrDefault("oauth_token")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "oauth_token", valid_579988
  var valid_579989 = query.getOrDefault("userIp")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "userIp", valid_579989
  var valid_579990 = query.getOrDefault("key")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "key", valid_579990
  var valid_579991 = query.getOrDefault("prettyPrint")
  valid_579991 = validateParameter(valid_579991, JBool, required = false,
                                 default = newJBool(true))
  if valid_579991 != nil:
    section.add "prettyPrint", valid_579991
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

proc call*(call_579993: Call_ClouduseraccountsGroupsInsert_579981; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Group resource in the specified project using the data included in the request.
  ## 
  let valid = call_579993.validator(path, query, header, formData, body)
  let scheme = call_579993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579993.url(scheme.get, call_579993.host, call_579993.base,
                         call_579993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579993, url, valid)

proc call*(call_579994: Call_ClouduseraccountsGroupsInsert_579981; project: string;
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
  var path_579995 = newJObject()
  var query_579996 = newJObject()
  var body_579997 = newJObject()
  add(query_579996, "fields", newJString(fields))
  add(query_579996, "quotaUser", newJString(quotaUser))
  add(query_579996, "alt", newJString(alt))
  add(query_579996, "oauth_token", newJString(oauthToken))
  add(query_579996, "userIp", newJString(userIp))
  add(query_579996, "key", newJString(key))
  add(path_579995, "project", newJString(project))
  if body != nil:
    body_579997 = body
  add(query_579996, "prettyPrint", newJBool(prettyPrint))
  result = call_579994.call(path_579995, query_579996, nil, nil, body_579997)

var clouduseraccountsGroupsInsert* = Call_ClouduseraccountsGroupsInsert_579981(
    name: "clouduseraccountsGroupsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/global/groups",
    validator: validate_ClouduseraccountsGroupsInsert_579982,
    base: "/clouduseraccounts/vm_alpha/projects",
    url: url_ClouduseraccountsGroupsInsert_579983, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGroupsList_579692 = ref object of OpenApiRestCall_579424
proc url_ClouduseraccountsGroupsList_579694(protocol: Scheme; host: string;
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

proc validate_ClouduseraccountsGroupsList_579693(path: JsonNode; query: JsonNode;
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
  var valid_579820 = path.getOrDefault("project")
  valid_579820 = validateParameter(valid_579820, JString, required = true,
                                 default = nil)
  if valid_579820 != nil:
    section.add "project", valid_579820
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
  var valid_579821 = query.getOrDefault("fields")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "fields", valid_579821
  var valid_579822 = query.getOrDefault("pageToken")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "pageToken", valid_579822
  var valid_579823 = query.getOrDefault("quotaUser")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "quotaUser", valid_579823
  var valid_579837 = query.getOrDefault("alt")
  valid_579837 = validateParameter(valid_579837, JString, required = false,
                                 default = newJString("json"))
  if valid_579837 != nil:
    section.add "alt", valid_579837
  var valid_579838 = query.getOrDefault("oauth_token")
  valid_579838 = validateParameter(valid_579838, JString, required = false,
                                 default = nil)
  if valid_579838 != nil:
    section.add "oauth_token", valid_579838
  var valid_579839 = query.getOrDefault("userIp")
  valid_579839 = validateParameter(valid_579839, JString, required = false,
                                 default = nil)
  if valid_579839 != nil:
    section.add "userIp", valid_579839
  var valid_579841 = query.getOrDefault("maxResults")
  valid_579841 = validateParameter(valid_579841, JInt, required = false,
                                 default = newJInt(500))
  if valid_579841 != nil:
    section.add "maxResults", valid_579841
  var valid_579842 = query.getOrDefault("orderBy")
  valid_579842 = validateParameter(valid_579842, JString, required = false,
                                 default = nil)
  if valid_579842 != nil:
    section.add "orderBy", valid_579842
  var valid_579843 = query.getOrDefault("key")
  valid_579843 = validateParameter(valid_579843, JString, required = false,
                                 default = nil)
  if valid_579843 != nil:
    section.add "key", valid_579843
  var valid_579844 = query.getOrDefault("prettyPrint")
  valid_579844 = validateParameter(valid_579844, JBool, required = false,
                                 default = newJBool(true))
  if valid_579844 != nil:
    section.add "prettyPrint", valid_579844
  var valid_579845 = query.getOrDefault("filter")
  valid_579845 = validateParameter(valid_579845, JString, required = false,
                                 default = nil)
  if valid_579845 != nil:
    section.add "filter", valid_579845
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579868: Call_ClouduseraccountsGroupsList_579692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of groups contained within the specified project.
  ## 
  let valid = call_579868.validator(path, query, header, formData, body)
  let scheme = call_579868.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579868.url(scheme.get, call_579868.host, call_579868.base,
                         call_579868.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579868, url, valid)

proc call*(call_579939: Call_ClouduseraccountsGroupsList_579692; project: string;
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
  var path_579940 = newJObject()
  var query_579942 = newJObject()
  add(query_579942, "fields", newJString(fields))
  add(query_579942, "pageToken", newJString(pageToken))
  add(query_579942, "quotaUser", newJString(quotaUser))
  add(query_579942, "alt", newJString(alt))
  add(query_579942, "oauth_token", newJString(oauthToken))
  add(query_579942, "userIp", newJString(userIp))
  add(query_579942, "maxResults", newJInt(maxResults))
  add(query_579942, "orderBy", newJString(orderBy))
  add(query_579942, "key", newJString(key))
  add(path_579940, "project", newJString(project))
  add(query_579942, "prettyPrint", newJBool(prettyPrint))
  add(query_579942, "filter", newJString(filter))
  result = call_579939.call(path_579940, query_579942, nil, nil, nil)

var clouduseraccountsGroupsList* = Call_ClouduseraccountsGroupsList_579692(
    name: "clouduseraccountsGroupsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/groups",
    validator: validate_ClouduseraccountsGroupsList_579693,
    base: "/clouduseraccounts/vm_alpha/projects",
    url: url_ClouduseraccountsGroupsList_579694, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGroupsGet_579998 = ref object of OpenApiRestCall_579424
proc url_ClouduseraccountsGroupsGet_580000(protocol: Scheme; host: string;
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

proc validate_ClouduseraccountsGroupsGet_579999(path: JsonNode; query: JsonNode;
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
  var valid_580001 = path.getOrDefault("groupName")
  valid_580001 = validateParameter(valid_580001, JString, required = true,
                                 default = nil)
  if valid_580001 != nil:
    section.add "groupName", valid_580001
  var valid_580002 = path.getOrDefault("project")
  valid_580002 = validateParameter(valid_580002, JString, required = true,
                                 default = nil)
  if valid_580002 != nil:
    section.add "project", valid_580002
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
  var valid_580003 = query.getOrDefault("fields")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "fields", valid_580003
  var valid_580004 = query.getOrDefault("quotaUser")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "quotaUser", valid_580004
  var valid_580005 = query.getOrDefault("alt")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = newJString("json"))
  if valid_580005 != nil:
    section.add "alt", valid_580005
  var valid_580006 = query.getOrDefault("oauth_token")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "oauth_token", valid_580006
  var valid_580007 = query.getOrDefault("userIp")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "userIp", valid_580007
  var valid_580008 = query.getOrDefault("key")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "key", valid_580008
  var valid_580009 = query.getOrDefault("prettyPrint")
  valid_580009 = validateParameter(valid_580009, JBool, required = false,
                                 default = newJBool(true))
  if valid_580009 != nil:
    section.add "prettyPrint", valid_580009
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580010: Call_ClouduseraccountsGroupsGet_579998; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specified Group resource.
  ## 
  let valid = call_580010.validator(path, query, header, formData, body)
  let scheme = call_580010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580010.url(scheme.get, call_580010.host, call_580010.base,
                         call_580010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580010, url, valid)

proc call*(call_580011: Call_ClouduseraccountsGroupsGet_579998; groupName: string;
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
  var path_580012 = newJObject()
  var query_580013 = newJObject()
  add(query_580013, "fields", newJString(fields))
  add(query_580013, "quotaUser", newJString(quotaUser))
  add(query_580013, "alt", newJString(alt))
  add(query_580013, "oauth_token", newJString(oauthToken))
  add(path_580012, "groupName", newJString(groupName))
  add(query_580013, "userIp", newJString(userIp))
  add(query_580013, "key", newJString(key))
  add(path_580012, "project", newJString(project))
  add(query_580013, "prettyPrint", newJBool(prettyPrint))
  result = call_580011.call(path_580012, query_580013, nil, nil, nil)

var clouduseraccountsGroupsGet* = Call_ClouduseraccountsGroupsGet_579998(
    name: "clouduseraccountsGroupsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/groups/{groupName}",
    validator: validate_ClouduseraccountsGroupsGet_579999,
    base: "/clouduseraccounts/vm_alpha/projects",
    url: url_ClouduseraccountsGroupsGet_580000, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGroupsDelete_580014 = ref object of OpenApiRestCall_579424
proc url_ClouduseraccountsGroupsDelete_580016(protocol: Scheme; host: string;
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

proc validate_ClouduseraccountsGroupsDelete_580015(path: JsonNode; query: JsonNode;
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
  var valid_580017 = path.getOrDefault("groupName")
  valid_580017 = validateParameter(valid_580017, JString, required = true,
                                 default = nil)
  if valid_580017 != nil:
    section.add "groupName", valid_580017
  var valid_580018 = path.getOrDefault("project")
  valid_580018 = validateParameter(valid_580018, JString, required = true,
                                 default = nil)
  if valid_580018 != nil:
    section.add "project", valid_580018
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
  var valid_580019 = query.getOrDefault("fields")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "fields", valid_580019
  var valid_580020 = query.getOrDefault("quotaUser")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "quotaUser", valid_580020
  var valid_580021 = query.getOrDefault("alt")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = newJString("json"))
  if valid_580021 != nil:
    section.add "alt", valid_580021
  var valid_580022 = query.getOrDefault("oauth_token")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "oauth_token", valid_580022
  var valid_580023 = query.getOrDefault("userIp")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "userIp", valid_580023
  var valid_580024 = query.getOrDefault("key")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "key", valid_580024
  var valid_580025 = query.getOrDefault("prettyPrint")
  valid_580025 = validateParameter(valid_580025, JBool, required = false,
                                 default = newJBool(true))
  if valid_580025 != nil:
    section.add "prettyPrint", valid_580025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580026: Call_ClouduseraccountsGroupsDelete_580014; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified Group resource.
  ## 
  let valid = call_580026.validator(path, query, header, formData, body)
  let scheme = call_580026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580026.url(scheme.get, call_580026.host, call_580026.base,
                         call_580026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580026, url, valid)

proc call*(call_580027: Call_ClouduseraccountsGroupsDelete_580014;
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
  var path_580028 = newJObject()
  var query_580029 = newJObject()
  add(query_580029, "fields", newJString(fields))
  add(query_580029, "quotaUser", newJString(quotaUser))
  add(query_580029, "alt", newJString(alt))
  add(query_580029, "oauth_token", newJString(oauthToken))
  add(path_580028, "groupName", newJString(groupName))
  add(query_580029, "userIp", newJString(userIp))
  add(query_580029, "key", newJString(key))
  add(path_580028, "project", newJString(project))
  add(query_580029, "prettyPrint", newJBool(prettyPrint))
  result = call_580027.call(path_580028, query_580029, nil, nil, nil)

var clouduseraccountsGroupsDelete* = Call_ClouduseraccountsGroupsDelete_580014(
    name: "clouduseraccountsGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{project}/global/groups/{groupName}",
    validator: validate_ClouduseraccountsGroupsDelete_580015,
    base: "/clouduseraccounts/vm_alpha/projects",
    url: url_ClouduseraccountsGroupsDelete_580016, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGroupsAddMember_580030 = ref object of OpenApiRestCall_579424
proc url_ClouduseraccountsGroupsAddMember_580032(protocol: Scheme; host: string;
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

proc validate_ClouduseraccountsGroupsAddMember_580031(path: JsonNode;
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
  var valid_580033 = path.getOrDefault("groupName")
  valid_580033 = validateParameter(valid_580033, JString, required = true,
                                 default = nil)
  if valid_580033 != nil:
    section.add "groupName", valid_580033
  var valid_580034 = path.getOrDefault("project")
  valid_580034 = validateParameter(valid_580034, JString, required = true,
                                 default = nil)
  if valid_580034 != nil:
    section.add "project", valid_580034
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
  var valid_580035 = query.getOrDefault("fields")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "fields", valid_580035
  var valid_580036 = query.getOrDefault("quotaUser")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "quotaUser", valid_580036
  var valid_580037 = query.getOrDefault("alt")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = newJString("json"))
  if valid_580037 != nil:
    section.add "alt", valid_580037
  var valid_580038 = query.getOrDefault("oauth_token")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "oauth_token", valid_580038
  var valid_580039 = query.getOrDefault("userIp")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "userIp", valid_580039
  var valid_580040 = query.getOrDefault("key")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "key", valid_580040
  var valid_580041 = query.getOrDefault("prettyPrint")
  valid_580041 = validateParameter(valid_580041, JBool, required = false,
                                 default = newJBool(true))
  if valid_580041 != nil:
    section.add "prettyPrint", valid_580041
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

proc call*(call_580043: Call_ClouduseraccountsGroupsAddMember_580030;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds users to the specified group.
  ## 
  let valid = call_580043.validator(path, query, header, formData, body)
  let scheme = call_580043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580043.url(scheme.get, call_580043.host, call_580043.base,
                         call_580043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580043, url, valid)

proc call*(call_580044: Call_ClouduseraccountsGroupsAddMember_580030;
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
  var path_580045 = newJObject()
  var query_580046 = newJObject()
  var body_580047 = newJObject()
  add(query_580046, "fields", newJString(fields))
  add(query_580046, "quotaUser", newJString(quotaUser))
  add(query_580046, "alt", newJString(alt))
  add(query_580046, "oauth_token", newJString(oauthToken))
  add(path_580045, "groupName", newJString(groupName))
  add(query_580046, "userIp", newJString(userIp))
  add(query_580046, "key", newJString(key))
  add(path_580045, "project", newJString(project))
  if body != nil:
    body_580047 = body
  add(query_580046, "prettyPrint", newJBool(prettyPrint))
  result = call_580044.call(path_580045, query_580046, nil, nil, body_580047)

var clouduseraccountsGroupsAddMember* = Call_ClouduseraccountsGroupsAddMember_580030(
    name: "clouduseraccountsGroupsAddMember", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/groups/{groupName}/addMember",
    validator: validate_ClouduseraccountsGroupsAddMember_580031,
    base: "/clouduseraccounts/vm_alpha/projects",
    url: url_ClouduseraccountsGroupsAddMember_580032, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGroupsRemoveMember_580048 = ref object of OpenApiRestCall_579424
proc url_ClouduseraccountsGroupsRemoveMember_580050(protocol: Scheme; host: string;
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

proc validate_ClouduseraccountsGroupsRemoveMember_580049(path: JsonNode;
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
  var valid_580051 = path.getOrDefault("groupName")
  valid_580051 = validateParameter(valid_580051, JString, required = true,
                                 default = nil)
  if valid_580051 != nil:
    section.add "groupName", valid_580051
  var valid_580052 = path.getOrDefault("project")
  valid_580052 = validateParameter(valid_580052, JString, required = true,
                                 default = nil)
  if valid_580052 != nil:
    section.add "project", valid_580052
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
  var valid_580053 = query.getOrDefault("fields")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "fields", valid_580053
  var valid_580054 = query.getOrDefault("quotaUser")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "quotaUser", valid_580054
  var valid_580055 = query.getOrDefault("alt")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = newJString("json"))
  if valid_580055 != nil:
    section.add "alt", valid_580055
  var valid_580056 = query.getOrDefault("oauth_token")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "oauth_token", valid_580056
  var valid_580057 = query.getOrDefault("userIp")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "userIp", valid_580057
  var valid_580058 = query.getOrDefault("key")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "key", valid_580058
  var valid_580059 = query.getOrDefault("prettyPrint")
  valid_580059 = validateParameter(valid_580059, JBool, required = false,
                                 default = newJBool(true))
  if valid_580059 != nil:
    section.add "prettyPrint", valid_580059
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

proc call*(call_580061: Call_ClouduseraccountsGroupsRemoveMember_580048;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes users from the specified group.
  ## 
  let valid = call_580061.validator(path, query, header, formData, body)
  let scheme = call_580061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580061.url(scheme.get, call_580061.host, call_580061.base,
                         call_580061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580061, url, valid)

proc call*(call_580062: Call_ClouduseraccountsGroupsRemoveMember_580048;
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
  var path_580063 = newJObject()
  var query_580064 = newJObject()
  var body_580065 = newJObject()
  add(query_580064, "fields", newJString(fields))
  add(query_580064, "quotaUser", newJString(quotaUser))
  add(query_580064, "alt", newJString(alt))
  add(query_580064, "oauth_token", newJString(oauthToken))
  add(path_580063, "groupName", newJString(groupName))
  add(query_580064, "userIp", newJString(userIp))
  add(query_580064, "key", newJString(key))
  add(path_580063, "project", newJString(project))
  if body != nil:
    body_580065 = body
  add(query_580064, "prettyPrint", newJBool(prettyPrint))
  result = call_580062.call(path_580063, query_580064, nil, nil, body_580065)

var clouduseraccountsGroupsRemoveMember* = Call_ClouduseraccountsGroupsRemoveMember_580048(
    name: "clouduseraccountsGroupsRemoveMember", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/groups/{groupName}/removeMember",
    validator: validate_ClouduseraccountsGroupsRemoveMember_580049,
    base: "/clouduseraccounts/vm_alpha/projects",
    url: url_ClouduseraccountsGroupsRemoveMember_580050, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGroupsGetIamPolicy_580066 = ref object of OpenApiRestCall_579424
proc url_ClouduseraccountsGroupsGetIamPolicy_580068(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ClouduseraccountsGroupsGetIamPolicy_580067(path: JsonNode;
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
  var valid_580069 = path.getOrDefault("resource")
  valid_580069 = validateParameter(valid_580069, JString, required = true,
                                 default = nil)
  if valid_580069 != nil:
    section.add "resource", valid_580069
  var valid_580070 = path.getOrDefault("project")
  valid_580070 = validateParameter(valid_580070, JString, required = true,
                                 default = nil)
  if valid_580070 != nil:
    section.add "project", valid_580070
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
  var valid_580071 = query.getOrDefault("fields")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "fields", valid_580071
  var valid_580072 = query.getOrDefault("quotaUser")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "quotaUser", valid_580072
  var valid_580073 = query.getOrDefault("alt")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = newJString("json"))
  if valid_580073 != nil:
    section.add "alt", valid_580073
  var valid_580074 = query.getOrDefault("oauth_token")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "oauth_token", valid_580074
  var valid_580075 = query.getOrDefault("userIp")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "userIp", valid_580075
  var valid_580076 = query.getOrDefault("key")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "key", valid_580076
  var valid_580077 = query.getOrDefault("prettyPrint")
  valid_580077 = validateParameter(valid_580077, JBool, required = false,
                                 default = newJBool(true))
  if valid_580077 != nil:
    section.add "prettyPrint", valid_580077
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580078: Call_ClouduseraccountsGroupsGetIamPolicy_580066;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource. May be empty if no such policy or resource exists.
  ## 
  let valid = call_580078.validator(path, query, header, formData, body)
  let scheme = call_580078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580078.url(scheme.get, call_580078.host, call_580078.base,
                         call_580078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580078, url, valid)

proc call*(call_580079: Call_ClouduseraccountsGroupsGetIamPolicy_580066;
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
  var path_580080 = newJObject()
  var query_580081 = newJObject()
  add(query_580081, "fields", newJString(fields))
  add(query_580081, "quotaUser", newJString(quotaUser))
  add(query_580081, "alt", newJString(alt))
  add(query_580081, "oauth_token", newJString(oauthToken))
  add(query_580081, "userIp", newJString(userIp))
  add(query_580081, "key", newJString(key))
  add(path_580080, "resource", newJString(resource))
  add(path_580080, "project", newJString(project))
  add(query_580081, "prettyPrint", newJBool(prettyPrint))
  result = call_580079.call(path_580080, query_580081, nil, nil, nil)

var clouduseraccountsGroupsGetIamPolicy* = Call_ClouduseraccountsGroupsGetIamPolicy_580066(
    name: "clouduseraccountsGroupsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/groups/{resource}/getIamPolicy",
    validator: validate_ClouduseraccountsGroupsGetIamPolicy_580067,
    base: "/clouduseraccounts/vm_alpha/projects",
    url: url_ClouduseraccountsGroupsGetIamPolicy_580068, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGroupsSetIamPolicy_580082 = ref object of OpenApiRestCall_579424
proc url_ClouduseraccountsGroupsSetIamPolicy_580084(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ClouduseraccountsGroupsSetIamPolicy_580083(path: JsonNode;
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
  var valid_580085 = path.getOrDefault("resource")
  valid_580085 = validateParameter(valid_580085, JString, required = true,
                                 default = nil)
  if valid_580085 != nil:
    section.add "resource", valid_580085
  var valid_580086 = path.getOrDefault("project")
  valid_580086 = validateParameter(valid_580086, JString, required = true,
                                 default = nil)
  if valid_580086 != nil:
    section.add "project", valid_580086
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
  var valid_580087 = query.getOrDefault("fields")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "fields", valid_580087
  var valid_580088 = query.getOrDefault("quotaUser")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "quotaUser", valid_580088
  var valid_580089 = query.getOrDefault("alt")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = newJString("json"))
  if valid_580089 != nil:
    section.add "alt", valid_580089
  var valid_580090 = query.getOrDefault("oauth_token")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "oauth_token", valid_580090
  var valid_580091 = query.getOrDefault("userIp")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "userIp", valid_580091
  var valid_580092 = query.getOrDefault("key")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "key", valid_580092
  var valid_580093 = query.getOrDefault("prettyPrint")
  valid_580093 = validateParameter(valid_580093, JBool, required = false,
                                 default = newJBool(true))
  if valid_580093 != nil:
    section.add "prettyPrint", valid_580093
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

proc call*(call_580095: Call_ClouduseraccountsGroupsSetIamPolicy_580082;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any existing policy.
  ## 
  let valid = call_580095.validator(path, query, header, formData, body)
  let scheme = call_580095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580095.url(scheme.get, call_580095.host, call_580095.base,
                         call_580095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580095, url, valid)

proc call*(call_580096: Call_ClouduseraccountsGroupsSetIamPolicy_580082;
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
  var path_580097 = newJObject()
  var query_580098 = newJObject()
  var body_580099 = newJObject()
  add(query_580098, "fields", newJString(fields))
  add(query_580098, "quotaUser", newJString(quotaUser))
  add(query_580098, "alt", newJString(alt))
  add(query_580098, "oauth_token", newJString(oauthToken))
  add(query_580098, "userIp", newJString(userIp))
  add(query_580098, "key", newJString(key))
  add(path_580097, "resource", newJString(resource))
  add(path_580097, "project", newJString(project))
  if body != nil:
    body_580099 = body
  add(query_580098, "prettyPrint", newJBool(prettyPrint))
  result = call_580096.call(path_580097, query_580098, nil, nil, body_580099)

var clouduseraccountsGroupsSetIamPolicy* = Call_ClouduseraccountsGroupsSetIamPolicy_580082(
    name: "clouduseraccountsGroupsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/groups/{resource}/setIamPolicy",
    validator: validate_ClouduseraccountsGroupsSetIamPolicy_580083,
    base: "/clouduseraccounts/vm_alpha/projects",
    url: url_ClouduseraccountsGroupsSetIamPolicy_580084, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGroupsTestIamPermissions_580100 = ref object of OpenApiRestCall_579424
proc url_ClouduseraccountsGroupsTestIamPermissions_580102(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/global/groups/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: "/testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClouduseraccountsGroupsTestIamPermissions_580101(path: JsonNode;
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
  var valid_580103 = path.getOrDefault("resource")
  valid_580103 = validateParameter(valid_580103, JString, required = true,
                                 default = nil)
  if valid_580103 != nil:
    section.add "resource", valid_580103
  var valid_580104 = path.getOrDefault("project")
  valid_580104 = validateParameter(valid_580104, JString, required = true,
                                 default = nil)
  if valid_580104 != nil:
    section.add "project", valid_580104
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
  var valid_580105 = query.getOrDefault("fields")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "fields", valid_580105
  var valid_580106 = query.getOrDefault("quotaUser")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "quotaUser", valid_580106
  var valid_580107 = query.getOrDefault("alt")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = newJString("json"))
  if valid_580107 != nil:
    section.add "alt", valid_580107
  var valid_580108 = query.getOrDefault("oauth_token")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "oauth_token", valid_580108
  var valid_580109 = query.getOrDefault("userIp")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "userIp", valid_580109
  var valid_580110 = query.getOrDefault("key")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "key", valid_580110
  var valid_580111 = query.getOrDefault("prettyPrint")
  valid_580111 = validateParameter(valid_580111, JBool, required = false,
                                 default = newJBool(true))
  if valid_580111 != nil:
    section.add "prettyPrint", valid_580111
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

proc call*(call_580113: Call_ClouduseraccountsGroupsTestIamPermissions_580100;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified resource.
  ## 
  let valid = call_580113.validator(path, query, header, formData, body)
  let scheme = call_580113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580113.url(scheme.get, call_580113.host, call_580113.base,
                         call_580113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580113, url, valid)

proc call*(call_580114: Call_ClouduseraccountsGroupsTestIamPermissions_580100;
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
  var path_580115 = newJObject()
  var query_580116 = newJObject()
  var body_580117 = newJObject()
  add(query_580116, "fields", newJString(fields))
  add(query_580116, "quotaUser", newJString(quotaUser))
  add(query_580116, "alt", newJString(alt))
  add(query_580116, "oauth_token", newJString(oauthToken))
  add(query_580116, "userIp", newJString(userIp))
  add(query_580116, "key", newJString(key))
  add(path_580115, "resource", newJString(resource))
  add(path_580115, "project", newJString(project))
  if body != nil:
    body_580117 = body
  add(query_580116, "prettyPrint", newJBool(prettyPrint))
  result = call_580114.call(path_580115, query_580116, nil, nil, body_580117)

var clouduseraccountsGroupsTestIamPermissions* = Call_ClouduseraccountsGroupsTestIamPermissions_580100(
    name: "clouduseraccountsGroupsTestIamPermissions", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/groups/{resource}/testIamPermissions",
    validator: validate_ClouduseraccountsGroupsTestIamPermissions_580101,
    base: "/clouduseraccounts/vm_alpha/projects",
    url: url_ClouduseraccountsGroupsTestIamPermissions_580102,
    schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGlobalAccountsOperationsList_580118 = ref object of OpenApiRestCall_579424
proc url_ClouduseraccountsGlobalAccountsOperationsList_580120(protocol: Scheme;
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

proc validate_ClouduseraccountsGlobalAccountsOperationsList_580119(
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
  var valid_580121 = path.getOrDefault("project")
  valid_580121 = validateParameter(valid_580121, JString, required = true,
                                 default = nil)
  if valid_580121 != nil:
    section.add "project", valid_580121
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
  var valid_580122 = query.getOrDefault("fields")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "fields", valid_580122
  var valid_580123 = query.getOrDefault("pageToken")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "pageToken", valid_580123
  var valid_580124 = query.getOrDefault("quotaUser")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "quotaUser", valid_580124
  var valid_580125 = query.getOrDefault("alt")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = newJString("json"))
  if valid_580125 != nil:
    section.add "alt", valid_580125
  var valid_580126 = query.getOrDefault("oauth_token")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "oauth_token", valid_580126
  var valid_580127 = query.getOrDefault("userIp")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "userIp", valid_580127
  var valid_580128 = query.getOrDefault("maxResults")
  valid_580128 = validateParameter(valid_580128, JInt, required = false,
                                 default = newJInt(500))
  if valid_580128 != nil:
    section.add "maxResults", valid_580128
  var valid_580129 = query.getOrDefault("orderBy")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "orderBy", valid_580129
  var valid_580130 = query.getOrDefault("key")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "key", valid_580130
  var valid_580131 = query.getOrDefault("prettyPrint")
  valid_580131 = validateParameter(valid_580131, JBool, required = false,
                                 default = newJBool(true))
  if valid_580131 != nil:
    section.add "prettyPrint", valid_580131
  var valid_580132 = query.getOrDefault("filter")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "filter", valid_580132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580133: Call_ClouduseraccountsGlobalAccountsOperationsList_580118;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of operation resources contained within the specified project.
  ## 
  let valid = call_580133.validator(path, query, header, formData, body)
  let scheme = call_580133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580133.url(scheme.get, call_580133.host, call_580133.base,
                         call_580133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580133, url, valid)

proc call*(call_580134: Call_ClouduseraccountsGlobalAccountsOperationsList_580118;
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
  var path_580135 = newJObject()
  var query_580136 = newJObject()
  add(query_580136, "fields", newJString(fields))
  add(query_580136, "pageToken", newJString(pageToken))
  add(query_580136, "quotaUser", newJString(quotaUser))
  add(query_580136, "alt", newJString(alt))
  add(query_580136, "oauth_token", newJString(oauthToken))
  add(query_580136, "userIp", newJString(userIp))
  add(query_580136, "maxResults", newJInt(maxResults))
  add(query_580136, "orderBy", newJString(orderBy))
  add(query_580136, "key", newJString(key))
  add(path_580135, "project", newJString(project))
  add(query_580136, "prettyPrint", newJBool(prettyPrint))
  add(query_580136, "filter", newJString(filter))
  result = call_580134.call(path_580135, query_580136, nil, nil, nil)

var clouduseraccountsGlobalAccountsOperationsList* = Call_ClouduseraccountsGlobalAccountsOperationsList_580118(
    name: "clouduseraccountsGlobalAccountsOperationsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{project}/global/operations",
    validator: validate_ClouduseraccountsGlobalAccountsOperationsList_580119,
    base: "/clouduseraccounts/vm_alpha/projects",
    url: url_ClouduseraccountsGlobalAccountsOperationsList_580120,
    schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGlobalAccountsOperationsGet_580137 = ref object of OpenApiRestCall_579424
proc url_ClouduseraccountsGlobalAccountsOperationsGet_580139(protocol: Scheme;
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

proc validate_ClouduseraccountsGlobalAccountsOperationsGet_580138(path: JsonNode;
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
  var valid_580140 = path.getOrDefault("operation")
  valid_580140 = validateParameter(valid_580140, JString, required = true,
                                 default = nil)
  if valid_580140 != nil:
    section.add "operation", valid_580140
  var valid_580141 = path.getOrDefault("project")
  valid_580141 = validateParameter(valid_580141, JString, required = true,
                                 default = nil)
  if valid_580141 != nil:
    section.add "project", valid_580141
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
  var valid_580142 = query.getOrDefault("fields")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "fields", valid_580142
  var valid_580143 = query.getOrDefault("quotaUser")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "quotaUser", valid_580143
  var valid_580144 = query.getOrDefault("alt")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = newJString("json"))
  if valid_580144 != nil:
    section.add "alt", valid_580144
  var valid_580145 = query.getOrDefault("oauth_token")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "oauth_token", valid_580145
  var valid_580146 = query.getOrDefault("userIp")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "userIp", valid_580146
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580149: Call_ClouduseraccountsGlobalAccountsOperationsGet_580137;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the specified operation resource.
  ## 
  let valid = call_580149.validator(path, query, header, formData, body)
  let scheme = call_580149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580149.url(scheme.get, call_580149.host, call_580149.base,
                         call_580149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580149, url, valid)

proc call*(call_580150: Call_ClouduseraccountsGlobalAccountsOperationsGet_580137;
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
  var path_580151 = newJObject()
  var query_580152 = newJObject()
  add(query_580152, "fields", newJString(fields))
  add(query_580152, "quotaUser", newJString(quotaUser))
  add(query_580152, "alt", newJString(alt))
  add(path_580151, "operation", newJString(operation))
  add(query_580152, "oauth_token", newJString(oauthToken))
  add(query_580152, "userIp", newJString(userIp))
  add(query_580152, "key", newJString(key))
  add(path_580151, "project", newJString(project))
  add(query_580152, "prettyPrint", newJBool(prettyPrint))
  result = call_580150.call(path_580151, query_580152, nil, nil, nil)

var clouduseraccountsGlobalAccountsOperationsGet* = Call_ClouduseraccountsGlobalAccountsOperationsGet_580137(
    name: "clouduseraccountsGlobalAccountsOperationsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{project}/global/operations/{operation}",
    validator: validate_ClouduseraccountsGlobalAccountsOperationsGet_580138,
    base: "/clouduseraccounts/vm_alpha/projects",
    url: url_ClouduseraccountsGlobalAccountsOperationsGet_580139,
    schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGlobalAccountsOperationsDelete_580153 = ref object of OpenApiRestCall_579424
proc url_ClouduseraccountsGlobalAccountsOperationsDelete_580155(protocol: Scheme;
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

proc validate_ClouduseraccountsGlobalAccountsOperationsDelete_580154(
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
  var valid_580156 = path.getOrDefault("operation")
  valid_580156 = validateParameter(valid_580156, JString, required = true,
                                 default = nil)
  if valid_580156 != nil:
    section.add "operation", valid_580156
  var valid_580157 = path.getOrDefault("project")
  valid_580157 = validateParameter(valid_580157, JString, required = true,
                                 default = nil)
  if valid_580157 != nil:
    section.add "project", valid_580157
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
  var valid_580158 = query.getOrDefault("fields")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "fields", valid_580158
  var valid_580159 = query.getOrDefault("quotaUser")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "quotaUser", valid_580159
  var valid_580160 = query.getOrDefault("alt")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = newJString("json"))
  if valid_580160 != nil:
    section.add "alt", valid_580160
  var valid_580161 = query.getOrDefault("oauth_token")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "oauth_token", valid_580161
  var valid_580162 = query.getOrDefault("userIp")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "userIp", valid_580162
  var valid_580163 = query.getOrDefault("key")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "key", valid_580163
  var valid_580164 = query.getOrDefault("prettyPrint")
  valid_580164 = validateParameter(valid_580164, JBool, required = false,
                                 default = newJBool(true))
  if valid_580164 != nil:
    section.add "prettyPrint", valid_580164
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580165: Call_ClouduseraccountsGlobalAccountsOperationsDelete_580153;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified operation resource.
  ## 
  let valid = call_580165.validator(path, query, header, formData, body)
  let scheme = call_580165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580165.url(scheme.get, call_580165.host, call_580165.base,
                         call_580165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580165, url, valid)

proc call*(call_580166: Call_ClouduseraccountsGlobalAccountsOperationsDelete_580153;
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
  var path_580167 = newJObject()
  var query_580168 = newJObject()
  add(query_580168, "fields", newJString(fields))
  add(query_580168, "quotaUser", newJString(quotaUser))
  add(query_580168, "alt", newJString(alt))
  add(path_580167, "operation", newJString(operation))
  add(query_580168, "oauth_token", newJString(oauthToken))
  add(query_580168, "userIp", newJString(userIp))
  add(query_580168, "key", newJString(key))
  add(path_580167, "project", newJString(project))
  add(query_580168, "prettyPrint", newJBool(prettyPrint))
  result = call_580166.call(path_580167, query_580168, nil, nil, nil)

var clouduseraccountsGlobalAccountsOperationsDelete* = Call_ClouduseraccountsGlobalAccountsOperationsDelete_580153(
    name: "clouduseraccountsGlobalAccountsOperationsDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/{project}/global/operations/{operation}",
    validator: validate_ClouduseraccountsGlobalAccountsOperationsDelete_580154,
    base: "/clouduseraccounts/vm_alpha/projects",
    url: url_ClouduseraccountsGlobalAccountsOperationsDelete_580155,
    schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersInsert_580188 = ref object of OpenApiRestCall_579424
proc url_ClouduseraccountsUsersInsert_580190(protocol: Scheme; host: string;
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

proc validate_ClouduseraccountsUsersInsert_580189(path: JsonNode; query: JsonNode;
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
  var valid_580191 = path.getOrDefault("project")
  valid_580191 = validateParameter(valid_580191, JString, required = true,
                                 default = nil)
  if valid_580191 != nil:
    section.add "project", valid_580191
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
  var valid_580192 = query.getOrDefault("fields")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "fields", valid_580192
  var valid_580193 = query.getOrDefault("quotaUser")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "quotaUser", valid_580193
  var valid_580194 = query.getOrDefault("alt")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = newJString("json"))
  if valid_580194 != nil:
    section.add "alt", valid_580194
  var valid_580195 = query.getOrDefault("oauth_token")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "oauth_token", valid_580195
  var valid_580196 = query.getOrDefault("userIp")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "userIp", valid_580196
  var valid_580197 = query.getOrDefault("key")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "key", valid_580197
  var valid_580198 = query.getOrDefault("prettyPrint")
  valid_580198 = validateParameter(valid_580198, JBool, required = false,
                                 default = newJBool(true))
  if valid_580198 != nil:
    section.add "prettyPrint", valid_580198
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

proc call*(call_580200: Call_ClouduseraccountsUsersInsert_580188; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a User resource in the specified project using the data included in the request.
  ## 
  let valid = call_580200.validator(path, query, header, formData, body)
  let scheme = call_580200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580200.url(scheme.get, call_580200.host, call_580200.base,
                         call_580200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580200, url, valid)

proc call*(call_580201: Call_ClouduseraccountsUsersInsert_580188; project: string;
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
  var path_580202 = newJObject()
  var query_580203 = newJObject()
  var body_580204 = newJObject()
  add(query_580203, "fields", newJString(fields))
  add(query_580203, "quotaUser", newJString(quotaUser))
  add(query_580203, "alt", newJString(alt))
  add(query_580203, "oauth_token", newJString(oauthToken))
  add(query_580203, "userIp", newJString(userIp))
  add(query_580203, "key", newJString(key))
  add(path_580202, "project", newJString(project))
  if body != nil:
    body_580204 = body
  add(query_580203, "prettyPrint", newJBool(prettyPrint))
  result = call_580201.call(path_580202, query_580203, nil, nil, body_580204)

var clouduseraccountsUsersInsert* = Call_ClouduseraccountsUsersInsert_580188(
    name: "clouduseraccountsUsersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/global/users",
    validator: validate_ClouduseraccountsUsersInsert_580189,
    base: "/clouduseraccounts/vm_alpha/projects",
    url: url_ClouduseraccountsUsersInsert_580190, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersList_580169 = ref object of OpenApiRestCall_579424
proc url_ClouduseraccountsUsersList_580171(protocol: Scheme; host: string;
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

proc validate_ClouduseraccountsUsersList_580170(path: JsonNode; query: JsonNode;
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
  var valid_580172 = path.getOrDefault("project")
  valid_580172 = validateParameter(valid_580172, JString, required = true,
                                 default = nil)
  if valid_580172 != nil:
    section.add "project", valid_580172
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
  var valid_580173 = query.getOrDefault("fields")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "fields", valid_580173
  var valid_580174 = query.getOrDefault("pageToken")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "pageToken", valid_580174
  var valid_580175 = query.getOrDefault("quotaUser")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "quotaUser", valid_580175
  var valid_580176 = query.getOrDefault("alt")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = newJString("json"))
  if valid_580176 != nil:
    section.add "alt", valid_580176
  var valid_580177 = query.getOrDefault("oauth_token")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "oauth_token", valid_580177
  var valid_580178 = query.getOrDefault("userIp")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "userIp", valid_580178
  var valid_580179 = query.getOrDefault("maxResults")
  valid_580179 = validateParameter(valid_580179, JInt, required = false,
                                 default = newJInt(500))
  if valid_580179 != nil:
    section.add "maxResults", valid_580179
  var valid_580180 = query.getOrDefault("orderBy")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = nil)
  if valid_580180 != nil:
    section.add "orderBy", valid_580180
  var valid_580181 = query.getOrDefault("key")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = nil)
  if valid_580181 != nil:
    section.add "key", valid_580181
  var valid_580182 = query.getOrDefault("prettyPrint")
  valid_580182 = validateParameter(valid_580182, JBool, required = false,
                                 default = newJBool(true))
  if valid_580182 != nil:
    section.add "prettyPrint", valid_580182
  var valid_580183 = query.getOrDefault("filter")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "filter", valid_580183
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580184: Call_ClouduseraccountsUsersList_580169; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of users contained within the specified project.
  ## 
  let valid = call_580184.validator(path, query, header, formData, body)
  let scheme = call_580184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580184.url(scheme.get, call_580184.host, call_580184.base,
                         call_580184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580184, url, valid)

proc call*(call_580185: Call_ClouduseraccountsUsersList_580169; project: string;
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
  var path_580186 = newJObject()
  var query_580187 = newJObject()
  add(query_580187, "fields", newJString(fields))
  add(query_580187, "pageToken", newJString(pageToken))
  add(query_580187, "quotaUser", newJString(quotaUser))
  add(query_580187, "alt", newJString(alt))
  add(query_580187, "oauth_token", newJString(oauthToken))
  add(query_580187, "userIp", newJString(userIp))
  add(query_580187, "maxResults", newJInt(maxResults))
  add(query_580187, "orderBy", newJString(orderBy))
  add(query_580187, "key", newJString(key))
  add(path_580186, "project", newJString(project))
  add(query_580187, "prettyPrint", newJBool(prettyPrint))
  add(query_580187, "filter", newJString(filter))
  result = call_580185.call(path_580186, query_580187, nil, nil, nil)

var clouduseraccountsUsersList* = Call_ClouduseraccountsUsersList_580169(
    name: "clouduseraccountsUsersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/users",
    validator: validate_ClouduseraccountsUsersList_580170,
    base: "/clouduseraccounts/vm_alpha/projects",
    url: url_ClouduseraccountsUsersList_580171, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersGetIamPolicy_580205 = ref object of OpenApiRestCall_579424
proc url_ClouduseraccountsUsersGetIamPolicy_580207(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ClouduseraccountsUsersGetIamPolicy_580206(path: JsonNode;
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
  var valid_580208 = path.getOrDefault("resource")
  valid_580208 = validateParameter(valid_580208, JString, required = true,
                                 default = nil)
  if valid_580208 != nil:
    section.add "resource", valid_580208
  var valid_580209 = path.getOrDefault("project")
  valid_580209 = validateParameter(valid_580209, JString, required = true,
                                 default = nil)
  if valid_580209 != nil:
    section.add "project", valid_580209
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
  var valid_580210 = query.getOrDefault("fields")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "fields", valid_580210
  var valid_580211 = query.getOrDefault("quotaUser")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "quotaUser", valid_580211
  var valid_580212 = query.getOrDefault("alt")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = newJString("json"))
  if valid_580212 != nil:
    section.add "alt", valid_580212
  var valid_580213 = query.getOrDefault("oauth_token")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "oauth_token", valid_580213
  var valid_580214 = query.getOrDefault("userIp")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "userIp", valid_580214
  var valid_580215 = query.getOrDefault("key")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "key", valid_580215
  var valid_580216 = query.getOrDefault("prettyPrint")
  valid_580216 = validateParameter(valid_580216, JBool, required = false,
                                 default = newJBool(true))
  if valid_580216 != nil:
    section.add "prettyPrint", valid_580216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580217: Call_ClouduseraccountsUsersGetIamPolicy_580205;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource. May be empty if no such policy or resource exists.
  ## 
  let valid = call_580217.validator(path, query, header, formData, body)
  let scheme = call_580217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580217.url(scheme.get, call_580217.host, call_580217.base,
                         call_580217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580217, url, valid)

proc call*(call_580218: Call_ClouduseraccountsUsersGetIamPolicy_580205;
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
  var path_580219 = newJObject()
  var query_580220 = newJObject()
  add(query_580220, "fields", newJString(fields))
  add(query_580220, "quotaUser", newJString(quotaUser))
  add(query_580220, "alt", newJString(alt))
  add(query_580220, "oauth_token", newJString(oauthToken))
  add(query_580220, "userIp", newJString(userIp))
  add(query_580220, "key", newJString(key))
  add(path_580219, "resource", newJString(resource))
  add(path_580219, "project", newJString(project))
  add(query_580220, "prettyPrint", newJBool(prettyPrint))
  result = call_580218.call(path_580219, query_580220, nil, nil, nil)

var clouduseraccountsUsersGetIamPolicy* = Call_ClouduseraccountsUsersGetIamPolicy_580205(
    name: "clouduseraccountsUsersGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/users/{resource}/getIamPolicy",
    validator: validate_ClouduseraccountsUsersGetIamPolicy_580206,
    base: "/clouduseraccounts/vm_alpha/projects",
    url: url_ClouduseraccountsUsersGetIamPolicy_580207, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersSetIamPolicy_580221 = ref object of OpenApiRestCall_579424
proc url_ClouduseraccountsUsersSetIamPolicy_580223(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ClouduseraccountsUsersSetIamPolicy_580222(path: JsonNode;
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
  var valid_580224 = path.getOrDefault("resource")
  valid_580224 = validateParameter(valid_580224, JString, required = true,
                                 default = nil)
  if valid_580224 != nil:
    section.add "resource", valid_580224
  var valid_580225 = path.getOrDefault("project")
  valid_580225 = validateParameter(valid_580225, JString, required = true,
                                 default = nil)
  if valid_580225 != nil:
    section.add "project", valid_580225
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
  var valid_580226 = query.getOrDefault("fields")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "fields", valid_580226
  var valid_580227 = query.getOrDefault("quotaUser")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "quotaUser", valid_580227
  var valid_580228 = query.getOrDefault("alt")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = newJString("json"))
  if valid_580228 != nil:
    section.add "alt", valid_580228
  var valid_580229 = query.getOrDefault("oauth_token")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "oauth_token", valid_580229
  var valid_580230 = query.getOrDefault("userIp")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "userIp", valid_580230
  var valid_580231 = query.getOrDefault("key")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "key", valid_580231
  var valid_580232 = query.getOrDefault("prettyPrint")
  valid_580232 = validateParameter(valid_580232, JBool, required = false,
                                 default = newJBool(true))
  if valid_580232 != nil:
    section.add "prettyPrint", valid_580232
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

proc call*(call_580234: Call_ClouduseraccountsUsersSetIamPolicy_580221;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any existing policy.
  ## 
  let valid = call_580234.validator(path, query, header, formData, body)
  let scheme = call_580234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580234.url(scheme.get, call_580234.host, call_580234.base,
                         call_580234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580234, url, valid)

proc call*(call_580235: Call_ClouduseraccountsUsersSetIamPolicy_580221;
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
  var path_580236 = newJObject()
  var query_580237 = newJObject()
  var body_580238 = newJObject()
  add(query_580237, "fields", newJString(fields))
  add(query_580237, "quotaUser", newJString(quotaUser))
  add(query_580237, "alt", newJString(alt))
  add(query_580237, "oauth_token", newJString(oauthToken))
  add(query_580237, "userIp", newJString(userIp))
  add(query_580237, "key", newJString(key))
  add(path_580236, "resource", newJString(resource))
  add(path_580236, "project", newJString(project))
  if body != nil:
    body_580238 = body
  add(query_580237, "prettyPrint", newJBool(prettyPrint))
  result = call_580235.call(path_580236, query_580237, nil, nil, body_580238)

var clouduseraccountsUsersSetIamPolicy* = Call_ClouduseraccountsUsersSetIamPolicy_580221(
    name: "clouduseraccountsUsersSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/users/{resource}/setIamPolicy",
    validator: validate_ClouduseraccountsUsersSetIamPolicy_580222,
    base: "/clouduseraccounts/vm_alpha/projects",
    url: url_ClouduseraccountsUsersSetIamPolicy_580223, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersTestIamPermissions_580239 = ref object of OpenApiRestCall_579424
proc url_ClouduseraccountsUsersTestIamPermissions_580241(protocol: Scheme;
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
               (kind: ConstantSegment, value: "/global/users/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: "/testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClouduseraccountsUsersTestIamPermissions_580240(path: JsonNode;
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
  var valid_580242 = path.getOrDefault("resource")
  valid_580242 = validateParameter(valid_580242, JString, required = true,
                                 default = nil)
  if valid_580242 != nil:
    section.add "resource", valid_580242
  var valid_580243 = path.getOrDefault("project")
  valid_580243 = validateParameter(valid_580243, JString, required = true,
                                 default = nil)
  if valid_580243 != nil:
    section.add "project", valid_580243
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
  var valid_580244 = query.getOrDefault("fields")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = nil)
  if valid_580244 != nil:
    section.add "fields", valid_580244
  var valid_580245 = query.getOrDefault("quotaUser")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "quotaUser", valid_580245
  var valid_580246 = query.getOrDefault("alt")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = newJString("json"))
  if valid_580246 != nil:
    section.add "alt", valid_580246
  var valid_580247 = query.getOrDefault("oauth_token")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "oauth_token", valid_580247
  var valid_580248 = query.getOrDefault("userIp")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "userIp", valid_580248
  var valid_580249 = query.getOrDefault("key")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "key", valid_580249
  var valid_580250 = query.getOrDefault("prettyPrint")
  valid_580250 = validateParameter(valid_580250, JBool, required = false,
                                 default = newJBool(true))
  if valid_580250 != nil:
    section.add "prettyPrint", valid_580250
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

proc call*(call_580252: Call_ClouduseraccountsUsersTestIamPermissions_580239;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified resource.
  ## 
  let valid = call_580252.validator(path, query, header, formData, body)
  let scheme = call_580252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580252.url(scheme.get, call_580252.host, call_580252.base,
                         call_580252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580252, url, valid)

proc call*(call_580253: Call_ClouduseraccountsUsersTestIamPermissions_580239;
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
  var path_580254 = newJObject()
  var query_580255 = newJObject()
  var body_580256 = newJObject()
  add(query_580255, "fields", newJString(fields))
  add(query_580255, "quotaUser", newJString(quotaUser))
  add(query_580255, "alt", newJString(alt))
  add(query_580255, "oauth_token", newJString(oauthToken))
  add(query_580255, "userIp", newJString(userIp))
  add(query_580255, "key", newJString(key))
  add(path_580254, "resource", newJString(resource))
  add(path_580254, "project", newJString(project))
  if body != nil:
    body_580256 = body
  add(query_580255, "prettyPrint", newJBool(prettyPrint))
  result = call_580253.call(path_580254, query_580255, nil, nil, body_580256)

var clouduseraccountsUsersTestIamPermissions* = Call_ClouduseraccountsUsersTestIamPermissions_580239(
    name: "clouduseraccountsUsersTestIamPermissions", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/users/{resource}/testIamPermissions",
    validator: validate_ClouduseraccountsUsersTestIamPermissions_580240,
    base: "/clouduseraccounts/vm_alpha/projects",
    url: url_ClouduseraccountsUsersTestIamPermissions_580241,
    schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersGet_580257 = ref object of OpenApiRestCall_579424
proc url_ClouduseraccountsUsersGet_580259(protocol: Scheme; host: string;
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

proc validate_ClouduseraccountsUsersGet_580258(path: JsonNode; query: JsonNode;
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
  var valid_580260 = path.getOrDefault("user")
  valid_580260 = validateParameter(valid_580260, JString, required = true,
                                 default = nil)
  if valid_580260 != nil:
    section.add "user", valid_580260
  var valid_580261 = path.getOrDefault("project")
  valid_580261 = validateParameter(valid_580261, JString, required = true,
                                 default = nil)
  if valid_580261 != nil:
    section.add "project", valid_580261
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
  var valid_580262 = query.getOrDefault("fields")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "fields", valid_580262
  var valid_580263 = query.getOrDefault("quotaUser")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = nil)
  if valid_580263 != nil:
    section.add "quotaUser", valid_580263
  var valid_580264 = query.getOrDefault("alt")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = newJString("json"))
  if valid_580264 != nil:
    section.add "alt", valid_580264
  var valid_580265 = query.getOrDefault("oauth_token")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "oauth_token", valid_580265
  var valid_580266 = query.getOrDefault("userIp")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "userIp", valid_580266
  var valid_580267 = query.getOrDefault("key")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "key", valid_580267
  var valid_580268 = query.getOrDefault("prettyPrint")
  valid_580268 = validateParameter(valid_580268, JBool, required = false,
                                 default = newJBool(true))
  if valid_580268 != nil:
    section.add "prettyPrint", valid_580268
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580269: Call_ClouduseraccountsUsersGet_580257; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specified User resource.
  ## 
  let valid = call_580269.validator(path, query, header, formData, body)
  let scheme = call_580269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580269.url(scheme.get, call_580269.host, call_580269.base,
                         call_580269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580269, url, valid)

proc call*(call_580270: Call_ClouduseraccountsUsersGet_580257; user: string;
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
  var path_580271 = newJObject()
  var query_580272 = newJObject()
  add(query_580272, "fields", newJString(fields))
  add(query_580272, "quotaUser", newJString(quotaUser))
  add(query_580272, "alt", newJString(alt))
  add(path_580271, "user", newJString(user))
  add(query_580272, "oauth_token", newJString(oauthToken))
  add(query_580272, "userIp", newJString(userIp))
  add(query_580272, "key", newJString(key))
  add(path_580271, "project", newJString(project))
  add(query_580272, "prettyPrint", newJBool(prettyPrint))
  result = call_580270.call(path_580271, query_580272, nil, nil, nil)

var clouduseraccountsUsersGet* = Call_ClouduseraccountsUsersGet_580257(
    name: "clouduseraccountsUsersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/users/{user}",
    validator: validate_ClouduseraccountsUsersGet_580258,
    base: "/clouduseraccounts/vm_alpha/projects",
    url: url_ClouduseraccountsUsersGet_580259, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersDelete_580273 = ref object of OpenApiRestCall_579424
proc url_ClouduseraccountsUsersDelete_580275(protocol: Scheme; host: string;
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

proc validate_ClouduseraccountsUsersDelete_580274(path: JsonNode; query: JsonNode;
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
  var valid_580276 = path.getOrDefault("user")
  valid_580276 = validateParameter(valid_580276, JString, required = true,
                                 default = nil)
  if valid_580276 != nil:
    section.add "user", valid_580276
  var valid_580277 = path.getOrDefault("project")
  valid_580277 = validateParameter(valid_580277, JString, required = true,
                                 default = nil)
  if valid_580277 != nil:
    section.add "project", valid_580277
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
  var valid_580278 = query.getOrDefault("fields")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "fields", valid_580278
  var valid_580279 = query.getOrDefault("quotaUser")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "quotaUser", valid_580279
  var valid_580280 = query.getOrDefault("alt")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = newJString("json"))
  if valid_580280 != nil:
    section.add "alt", valid_580280
  var valid_580281 = query.getOrDefault("oauth_token")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "oauth_token", valid_580281
  var valid_580282 = query.getOrDefault("userIp")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = nil)
  if valid_580282 != nil:
    section.add "userIp", valid_580282
  var valid_580283 = query.getOrDefault("key")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = nil)
  if valid_580283 != nil:
    section.add "key", valid_580283
  var valid_580284 = query.getOrDefault("prettyPrint")
  valid_580284 = validateParameter(valid_580284, JBool, required = false,
                                 default = newJBool(true))
  if valid_580284 != nil:
    section.add "prettyPrint", valid_580284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580285: Call_ClouduseraccountsUsersDelete_580273; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified User resource.
  ## 
  let valid = call_580285.validator(path, query, header, formData, body)
  let scheme = call_580285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580285.url(scheme.get, call_580285.host, call_580285.base,
                         call_580285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580285, url, valid)

proc call*(call_580286: Call_ClouduseraccountsUsersDelete_580273; user: string;
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
  var path_580287 = newJObject()
  var query_580288 = newJObject()
  add(query_580288, "fields", newJString(fields))
  add(query_580288, "quotaUser", newJString(quotaUser))
  add(query_580288, "alt", newJString(alt))
  add(path_580287, "user", newJString(user))
  add(query_580288, "oauth_token", newJString(oauthToken))
  add(query_580288, "userIp", newJString(userIp))
  add(query_580288, "key", newJString(key))
  add(path_580287, "project", newJString(project))
  add(query_580288, "prettyPrint", newJBool(prettyPrint))
  result = call_580286.call(path_580287, query_580288, nil, nil, nil)

var clouduseraccountsUsersDelete* = Call_ClouduseraccountsUsersDelete_580273(
    name: "clouduseraccountsUsersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{project}/global/users/{user}",
    validator: validate_ClouduseraccountsUsersDelete_580274,
    base: "/clouduseraccounts/vm_alpha/projects",
    url: url_ClouduseraccountsUsersDelete_580275, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersAddPublicKey_580289 = ref object of OpenApiRestCall_579424
proc url_ClouduseraccountsUsersAddPublicKey_580291(protocol: Scheme; host: string;
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

proc validate_ClouduseraccountsUsersAddPublicKey_580290(path: JsonNode;
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
  var valid_580292 = path.getOrDefault("user")
  valid_580292 = validateParameter(valid_580292, JString, required = true,
                                 default = nil)
  if valid_580292 != nil:
    section.add "user", valid_580292
  var valid_580293 = path.getOrDefault("project")
  valid_580293 = validateParameter(valid_580293, JString, required = true,
                                 default = nil)
  if valid_580293 != nil:
    section.add "project", valid_580293
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
  var valid_580294 = query.getOrDefault("fields")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = nil)
  if valid_580294 != nil:
    section.add "fields", valid_580294
  var valid_580295 = query.getOrDefault("quotaUser")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "quotaUser", valid_580295
  var valid_580296 = query.getOrDefault("alt")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = newJString("json"))
  if valid_580296 != nil:
    section.add "alt", valid_580296
  var valid_580297 = query.getOrDefault("oauth_token")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = nil)
  if valid_580297 != nil:
    section.add "oauth_token", valid_580297
  var valid_580298 = query.getOrDefault("userIp")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = nil)
  if valid_580298 != nil:
    section.add "userIp", valid_580298
  var valid_580299 = query.getOrDefault("key")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = nil)
  if valid_580299 != nil:
    section.add "key", valid_580299
  var valid_580300 = query.getOrDefault("prettyPrint")
  valid_580300 = validateParameter(valid_580300, JBool, required = false,
                                 default = newJBool(true))
  if valid_580300 != nil:
    section.add "prettyPrint", valid_580300
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

proc call*(call_580302: Call_ClouduseraccountsUsersAddPublicKey_580289;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a public key to the specified User resource with the data included in the request.
  ## 
  let valid = call_580302.validator(path, query, header, formData, body)
  let scheme = call_580302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580302.url(scheme.get, call_580302.host, call_580302.base,
                         call_580302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580302, url, valid)

proc call*(call_580303: Call_ClouduseraccountsUsersAddPublicKey_580289;
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
  var path_580304 = newJObject()
  var query_580305 = newJObject()
  var body_580306 = newJObject()
  add(query_580305, "fields", newJString(fields))
  add(query_580305, "quotaUser", newJString(quotaUser))
  add(query_580305, "alt", newJString(alt))
  add(path_580304, "user", newJString(user))
  add(query_580305, "oauth_token", newJString(oauthToken))
  add(query_580305, "userIp", newJString(userIp))
  add(query_580305, "key", newJString(key))
  add(path_580304, "project", newJString(project))
  if body != nil:
    body_580306 = body
  add(query_580305, "prettyPrint", newJBool(prettyPrint))
  result = call_580303.call(path_580304, query_580305, nil, nil, body_580306)

var clouduseraccountsUsersAddPublicKey* = Call_ClouduseraccountsUsersAddPublicKey_580289(
    name: "clouduseraccountsUsersAddPublicKey", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/users/{user}/addPublicKey",
    validator: validate_ClouduseraccountsUsersAddPublicKey_580290,
    base: "/clouduseraccounts/vm_alpha/projects",
    url: url_ClouduseraccountsUsersAddPublicKey_580291, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersRemovePublicKey_580307 = ref object of OpenApiRestCall_579424
proc url_ClouduseraccountsUsersRemovePublicKey_580309(protocol: Scheme;
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

proc validate_ClouduseraccountsUsersRemovePublicKey_580308(path: JsonNode;
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
  var valid_580310 = path.getOrDefault("user")
  valid_580310 = validateParameter(valid_580310, JString, required = true,
                                 default = nil)
  if valid_580310 != nil:
    section.add "user", valid_580310
  var valid_580311 = path.getOrDefault("project")
  valid_580311 = validateParameter(valid_580311, JString, required = true,
                                 default = nil)
  if valid_580311 != nil:
    section.add "project", valid_580311
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
  var valid_580312 = query.getOrDefault("fields")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = nil)
  if valid_580312 != nil:
    section.add "fields", valid_580312
  assert query != nil,
        "query argument is necessary due to required `fingerprint` field"
  var valid_580313 = query.getOrDefault("fingerprint")
  valid_580313 = validateParameter(valid_580313, JString, required = true,
                                 default = nil)
  if valid_580313 != nil:
    section.add "fingerprint", valid_580313
  var valid_580314 = query.getOrDefault("quotaUser")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = nil)
  if valid_580314 != nil:
    section.add "quotaUser", valid_580314
  var valid_580315 = query.getOrDefault("alt")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = newJString("json"))
  if valid_580315 != nil:
    section.add "alt", valid_580315
  var valid_580316 = query.getOrDefault("oauth_token")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "oauth_token", valid_580316
  var valid_580317 = query.getOrDefault("userIp")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = nil)
  if valid_580317 != nil:
    section.add "userIp", valid_580317
  var valid_580318 = query.getOrDefault("key")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = nil)
  if valid_580318 != nil:
    section.add "key", valid_580318
  var valid_580319 = query.getOrDefault("prettyPrint")
  valid_580319 = validateParameter(valid_580319, JBool, required = false,
                                 default = newJBool(true))
  if valid_580319 != nil:
    section.add "prettyPrint", valid_580319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580320: Call_ClouduseraccountsUsersRemovePublicKey_580307;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes the specified public key from the user.
  ## 
  let valid = call_580320.validator(path, query, header, formData, body)
  let scheme = call_580320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580320.url(scheme.get, call_580320.host, call_580320.base,
                         call_580320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580320, url, valid)

proc call*(call_580321: Call_ClouduseraccountsUsersRemovePublicKey_580307;
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
  var path_580322 = newJObject()
  var query_580323 = newJObject()
  add(query_580323, "fields", newJString(fields))
  add(query_580323, "fingerprint", newJString(fingerprint))
  add(query_580323, "quotaUser", newJString(quotaUser))
  add(query_580323, "alt", newJString(alt))
  add(path_580322, "user", newJString(user))
  add(query_580323, "oauth_token", newJString(oauthToken))
  add(query_580323, "userIp", newJString(userIp))
  add(query_580323, "key", newJString(key))
  add(path_580322, "project", newJString(project))
  add(query_580323, "prettyPrint", newJBool(prettyPrint))
  result = call_580321.call(path_580322, query_580323, nil, nil, nil)

var clouduseraccountsUsersRemovePublicKey* = Call_ClouduseraccountsUsersRemovePublicKey_580307(
    name: "clouduseraccountsUsersRemovePublicKey", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/users/{user}/removePublicKey",
    validator: validate_ClouduseraccountsUsersRemovePublicKey_580308,
    base: "/clouduseraccounts/vm_alpha/projects",
    url: url_ClouduseraccountsUsersRemovePublicKey_580309, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsLinuxGetAuthorizedKeysView_580324 = ref object of OpenApiRestCall_579424
proc url_ClouduseraccountsLinuxGetAuthorizedKeysView_580326(protocol: Scheme;
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

proc validate_ClouduseraccountsLinuxGetAuthorizedKeysView_580325(path: JsonNode;
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
  var valid_580327 = path.getOrDefault("zone")
  valid_580327 = validateParameter(valid_580327, JString, required = true,
                                 default = nil)
  if valid_580327 != nil:
    section.add "zone", valid_580327
  var valid_580328 = path.getOrDefault("user")
  valid_580328 = validateParameter(valid_580328, JString, required = true,
                                 default = nil)
  if valid_580328 != nil:
    section.add "user", valid_580328
  var valid_580329 = path.getOrDefault("project")
  valid_580329 = validateParameter(valid_580329, JString, required = true,
                                 default = nil)
  if valid_580329 != nil:
    section.add "project", valid_580329
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
  var valid_580330 = query.getOrDefault("fields")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = nil)
  if valid_580330 != nil:
    section.add "fields", valid_580330
  var valid_580331 = query.getOrDefault("quotaUser")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = nil)
  if valid_580331 != nil:
    section.add "quotaUser", valid_580331
  var valid_580332 = query.getOrDefault("alt")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = newJString("json"))
  if valid_580332 != nil:
    section.add "alt", valid_580332
  var valid_580333 = query.getOrDefault("login")
  valid_580333 = validateParameter(valid_580333, JBool, required = false, default = nil)
  if valid_580333 != nil:
    section.add "login", valid_580333
  var valid_580334 = query.getOrDefault("oauth_token")
  valid_580334 = validateParameter(valid_580334, JString, required = false,
                                 default = nil)
  if valid_580334 != nil:
    section.add "oauth_token", valid_580334
  var valid_580335 = query.getOrDefault("userIp")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = nil)
  if valid_580335 != nil:
    section.add "userIp", valid_580335
  var valid_580336 = query.getOrDefault("key")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = nil)
  if valid_580336 != nil:
    section.add "key", valid_580336
  assert query != nil,
        "query argument is necessary due to required `instance` field"
  var valid_580337 = query.getOrDefault("instance")
  valid_580337 = validateParameter(valid_580337, JString, required = true,
                                 default = nil)
  if valid_580337 != nil:
    section.add "instance", valid_580337
  var valid_580338 = query.getOrDefault("prettyPrint")
  valid_580338 = validateParameter(valid_580338, JBool, required = false,
                                 default = newJBool(true))
  if valid_580338 != nil:
    section.add "prettyPrint", valid_580338
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580339: Call_ClouduseraccountsLinuxGetAuthorizedKeysView_580324;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of authorized public keys for a specific user account.
  ## 
  let valid = call_580339.validator(path, query, header, formData, body)
  let scheme = call_580339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580339.url(scheme.get, call_580339.host, call_580339.base,
                         call_580339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580339, url, valid)

proc call*(call_580340: Call_ClouduseraccountsLinuxGetAuthorizedKeysView_580324;
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
  var path_580341 = newJObject()
  var query_580342 = newJObject()
  add(path_580341, "zone", newJString(zone))
  add(query_580342, "fields", newJString(fields))
  add(query_580342, "quotaUser", newJString(quotaUser))
  add(query_580342, "alt", newJString(alt))
  add(path_580341, "user", newJString(user))
  add(query_580342, "login", newJBool(login))
  add(query_580342, "oauth_token", newJString(oauthToken))
  add(query_580342, "userIp", newJString(userIp))
  add(query_580342, "key", newJString(key))
  add(query_580342, "instance", newJString(instance))
  add(path_580341, "project", newJString(project))
  add(query_580342, "prettyPrint", newJBool(prettyPrint))
  result = call_580340.call(path_580341, query_580342, nil, nil, nil)

var clouduseraccountsLinuxGetAuthorizedKeysView* = Call_ClouduseraccountsLinuxGetAuthorizedKeysView_580324(
    name: "clouduseraccountsLinuxGetAuthorizedKeysView",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/authorizedKeysView/{user}",
    validator: validate_ClouduseraccountsLinuxGetAuthorizedKeysView_580325,
    base: "/clouduseraccounts/vm_alpha/projects",
    url: url_ClouduseraccountsLinuxGetAuthorizedKeysView_580326,
    schemes: {Scheme.Https})
type
  Call_ClouduseraccountsLinuxGetLinuxAccountViews_580343 = ref object of OpenApiRestCall_579424
proc url_ClouduseraccountsLinuxGetLinuxAccountViews_580345(protocol: Scheme;
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

proc validate_ClouduseraccountsLinuxGetLinuxAccountViews_580344(path: JsonNode;
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
  var valid_580346 = path.getOrDefault("zone")
  valid_580346 = validateParameter(valid_580346, JString, required = true,
                                 default = nil)
  if valid_580346 != nil:
    section.add "zone", valid_580346
  var valid_580347 = path.getOrDefault("project")
  valid_580347 = validateParameter(valid_580347, JString, required = true,
                                 default = nil)
  if valid_580347 != nil:
    section.add "project", valid_580347
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
  var valid_580348 = query.getOrDefault("fields")
  valid_580348 = validateParameter(valid_580348, JString, required = false,
                                 default = nil)
  if valid_580348 != nil:
    section.add "fields", valid_580348
  var valid_580349 = query.getOrDefault("pageToken")
  valid_580349 = validateParameter(valid_580349, JString, required = false,
                                 default = nil)
  if valid_580349 != nil:
    section.add "pageToken", valid_580349
  var valid_580350 = query.getOrDefault("quotaUser")
  valid_580350 = validateParameter(valid_580350, JString, required = false,
                                 default = nil)
  if valid_580350 != nil:
    section.add "quotaUser", valid_580350
  var valid_580351 = query.getOrDefault("alt")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = newJString("json"))
  if valid_580351 != nil:
    section.add "alt", valid_580351
  var valid_580352 = query.getOrDefault("oauth_token")
  valid_580352 = validateParameter(valid_580352, JString, required = false,
                                 default = nil)
  if valid_580352 != nil:
    section.add "oauth_token", valid_580352
  var valid_580353 = query.getOrDefault("userIp")
  valid_580353 = validateParameter(valid_580353, JString, required = false,
                                 default = nil)
  if valid_580353 != nil:
    section.add "userIp", valid_580353
  var valid_580354 = query.getOrDefault("maxResults")
  valid_580354 = validateParameter(valid_580354, JInt, required = false,
                                 default = newJInt(500))
  if valid_580354 != nil:
    section.add "maxResults", valid_580354
  var valid_580355 = query.getOrDefault("orderBy")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = nil)
  if valid_580355 != nil:
    section.add "orderBy", valid_580355
  var valid_580356 = query.getOrDefault("key")
  valid_580356 = validateParameter(valid_580356, JString, required = false,
                                 default = nil)
  if valid_580356 != nil:
    section.add "key", valid_580356
  assert query != nil,
        "query argument is necessary due to required `instance` field"
  var valid_580357 = query.getOrDefault("instance")
  valid_580357 = validateParameter(valid_580357, JString, required = true,
                                 default = nil)
  if valid_580357 != nil:
    section.add "instance", valid_580357
  var valid_580358 = query.getOrDefault("prettyPrint")
  valid_580358 = validateParameter(valid_580358, JBool, required = false,
                                 default = newJBool(true))
  if valid_580358 != nil:
    section.add "prettyPrint", valid_580358
  var valid_580359 = query.getOrDefault("filter")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = nil)
  if valid_580359 != nil:
    section.add "filter", valid_580359
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580360: Call_ClouduseraccountsLinuxGetLinuxAccountViews_580343;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a list of user accounts for an instance within a specific project.
  ## 
  let valid = call_580360.validator(path, query, header, formData, body)
  let scheme = call_580360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580360.url(scheme.get, call_580360.host, call_580360.base,
                         call_580360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580360, url, valid)

proc call*(call_580361: Call_ClouduseraccountsLinuxGetLinuxAccountViews_580343;
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
  var path_580362 = newJObject()
  var query_580363 = newJObject()
  add(path_580362, "zone", newJString(zone))
  add(query_580363, "fields", newJString(fields))
  add(query_580363, "pageToken", newJString(pageToken))
  add(query_580363, "quotaUser", newJString(quotaUser))
  add(query_580363, "alt", newJString(alt))
  add(query_580363, "oauth_token", newJString(oauthToken))
  add(query_580363, "userIp", newJString(userIp))
  add(query_580363, "maxResults", newJInt(maxResults))
  add(query_580363, "orderBy", newJString(orderBy))
  add(query_580363, "key", newJString(key))
  add(query_580363, "instance", newJString(instance))
  add(path_580362, "project", newJString(project))
  add(query_580363, "prettyPrint", newJBool(prettyPrint))
  add(query_580363, "filter", newJString(filter))
  result = call_580361.call(path_580362, query_580363, nil, nil, nil)

var clouduseraccountsLinuxGetLinuxAccountViews* = Call_ClouduseraccountsLinuxGetLinuxAccountViews_580343(
    name: "clouduseraccountsLinuxGetLinuxAccountViews", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/linuxAccountViews",
    validator: validate_ClouduseraccountsLinuxGetLinuxAccountViews_580344,
    base: "/clouduseraccounts/vm_alpha/projects",
    url: url_ClouduseraccountsLinuxGetLinuxAccountViews_580345,
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
