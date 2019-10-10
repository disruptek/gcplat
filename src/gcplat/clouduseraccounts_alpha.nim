
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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

  OpenApiRestCall_588457 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588457](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588457): Option[Scheme] {.used.} =
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
  Call_ClouduseraccountsGroupsInsert_589014 = ref object of OpenApiRestCall_588457
proc url_ClouduseraccountsGroupsInsert_589016(protocol: Scheme; host: string;
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

proc validate_ClouduseraccountsGroupsInsert_589015(path: JsonNode; query: JsonNode;
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
  var valid_589017 = path.getOrDefault("project")
  valid_589017 = validateParameter(valid_589017, JString, required = true,
                                 default = nil)
  if valid_589017 != nil:
    section.add "project", valid_589017
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
  var valid_589018 = query.getOrDefault("fields")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "fields", valid_589018
  var valid_589019 = query.getOrDefault("quotaUser")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "quotaUser", valid_589019
  var valid_589020 = query.getOrDefault("alt")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = newJString("json"))
  if valid_589020 != nil:
    section.add "alt", valid_589020
  var valid_589021 = query.getOrDefault("oauth_token")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "oauth_token", valid_589021
  var valid_589022 = query.getOrDefault("userIp")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "userIp", valid_589022
  var valid_589023 = query.getOrDefault("key")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "key", valid_589023
  var valid_589024 = query.getOrDefault("prettyPrint")
  valid_589024 = validateParameter(valid_589024, JBool, required = false,
                                 default = newJBool(true))
  if valid_589024 != nil:
    section.add "prettyPrint", valid_589024
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

proc call*(call_589026: Call_ClouduseraccountsGroupsInsert_589014; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Group resource in the specified project using the data included in the request.
  ## 
  let valid = call_589026.validator(path, query, header, formData, body)
  let scheme = call_589026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589026.url(scheme.get, call_589026.host, call_589026.base,
                         call_589026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589026, url, valid)

proc call*(call_589027: Call_ClouduseraccountsGroupsInsert_589014; project: string;
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
  var path_589028 = newJObject()
  var query_589029 = newJObject()
  var body_589030 = newJObject()
  add(query_589029, "fields", newJString(fields))
  add(query_589029, "quotaUser", newJString(quotaUser))
  add(query_589029, "alt", newJString(alt))
  add(query_589029, "oauth_token", newJString(oauthToken))
  add(query_589029, "userIp", newJString(userIp))
  add(query_589029, "key", newJString(key))
  add(path_589028, "project", newJString(project))
  if body != nil:
    body_589030 = body
  add(query_589029, "prettyPrint", newJBool(prettyPrint))
  result = call_589027.call(path_589028, query_589029, nil, nil, body_589030)

var clouduseraccountsGroupsInsert* = Call_ClouduseraccountsGroupsInsert_589014(
    name: "clouduseraccountsGroupsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/global/groups",
    validator: validate_ClouduseraccountsGroupsInsert_589015,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsGroupsInsert_589016, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGroupsList_588725 = ref object of OpenApiRestCall_588457
proc url_ClouduseraccountsGroupsList_588727(protocol: Scheme; host: string;
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

proc validate_ClouduseraccountsGroupsList_588726(path: JsonNode; query: JsonNode;
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
  var valid_588853 = path.getOrDefault("project")
  valid_588853 = validateParameter(valid_588853, JString, required = true,
                                 default = nil)
  if valid_588853 != nil:
    section.add "project", valid_588853
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
  var valid_588854 = query.getOrDefault("fields")
  valid_588854 = validateParameter(valid_588854, JString, required = false,
                                 default = nil)
  if valid_588854 != nil:
    section.add "fields", valid_588854
  var valid_588855 = query.getOrDefault("pageToken")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = nil)
  if valid_588855 != nil:
    section.add "pageToken", valid_588855
  var valid_588856 = query.getOrDefault("quotaUser")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "quotaUser", valid_588856
  var valid_588870 = query.getOrDefault("alt")
  valid_588870 = validateParameter(valid_588870, JString, required = false,
                                 default = newJString("json"))
  if valid_588870 != nil:
    section.add "alt", valid_588870
  var valid_588871 = query.getOrDefault("oauth_token")
  valid_588871 = validateParameter(valid_588871, JString, required = false,
                                 default = nil)
  if valid_588871 != nil:
    section.add "oauth_token", valid_588871
  var valid_588872 = query.getOrDefault("userIp")
  valid_588872 = validateParameter(valid_588872, JString, required = false,
                                 default = nil)
  if valid_588872 != nil:
    section.add "userIp", valid_588872
  var valid_588874 = query.getOrDefault("maxResults")
  valid_588874 = validateParameter(valid_588874, JInt, required = false,
                                 default = newJInt(500))
  if valid_588874 != nil:
    section.add "maxResults", valid_588874
  var valid_588875 = query.getOrDefault("orderBy")
  valid_588875 = validateParameter(valid_588875, JString, required = false,
                                 default = nil)
  if valid_588875 != nil:
    section.add "orderBy", valid_588875
  var valid_588876 = query.getOrDefault("key")
  valid_588876 = validateParameter(valid_588876, JString, required = false,
                                 default = nil)
  if valid_588876 != nil:
    section.add "key", valid_588876
  var valid_588877 = query.getOrDefault("prettyPrint")
  valid_588877 = validateParameter(valid_588877, JBool, required = false,
                                 default = newJBool(true))
  if valid_588877 != nil:
    section.add "prettyPrint", valid_588877
  var valid_588878 = query.getOrDefault("filter")
  valid_588878 = validateParameter(valid_588878, JString, required = false,
                                 default = nil)
  if valid_588878 != nil:
    section.add "filter", valid_588878
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588901: Call_ClouduseraccountsGroupsList_588725; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of groups contained within the specified project.
  ## 
  let valid = call_588901.validator(path, query, header, formData, body)
  let scheme = call_588901.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588901.url(scheme.get, call_588901.host, call_588901.base,
                         call_588901.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588901, url, valid)

proc call*(call_588972: Call_ClouduseraccountsGroupsList_588725; project: string;
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
  var path_588973 = newJObject()
  var query_588975 = newJObject()
  add(query_588975, "fields", newJString(fields))
  add(query_588975, "pageToken", newJString(pageToken))
  add(query_588975, "quotaUser", newJString(quotaUser))
  add(query_588975, "alt", newJString(alt))
  add(query_588975, "oauth_token", newJString(oauthToken))
  add(query_588975, "userIp", newJString(userIp))
  add(query_588975, "maxResults", newJInt(maxResults))
  add(query_588975, "orderBy", newJString(orderBy))
  add(query_588975, "key", newJString(key))
  add(path_588973, "project", newJString(project))
  add(query_588975, "prettyPrint", newJBool(prettyPrint))
  add(query_588975, "filter", newJString(filter))
  result = call_588972.call(path_588973, query_588975, nil, nil, nil)

var clouduseraccountsGroupsList* = Call_ClouduseraccountsGroupsList_588725(
    name: "clouduseraccountsGroupsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/groups",
    validator: validate_ClouduseraccountsGroupsList_588726,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsGroupsList_588727, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGroupsGet_589031 = ref object of OpenApiRestCall_588457
proc url_ClouduseraccountsGroupsGet_589033(protocol: Scheme; host: string;
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

proc validate_ClouduseraccountsGroupsGet_589032(path: JsonNode; query: JsonNode;
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
  var valid_589034 = path.getOrDefault("groupName")
  valid_589034 = validateParameter(valid_589034, JString, required = true,
                                 default = nil)
  if valid_589034 != nil:
    section.add "groupName", valid_589034
  var valid_589035 = path.getOrDefault("project")
  valid_589035 = validateParameter(valid_589035, JString, required = true,
                                 default = nil)
  if valid_589035 != nil:
    section.add "project", valid_589035
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
  var valid_589036 = query.getOrDefault("fields")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "fields", valid_589036
  var valid_589037 = query.getOrDefault("quotaUser")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "quotaUser", valid_589037
  var valid_589038 = query.getOrDefault("alt")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = newJString("json"))
  if valid_589038 != nil:
    section.add "alt", valid_589038
  var valid_589039 = query.getOrDefault("oauth_token")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "oauth_token", valid_589039
  var valid_589040 = query.getOrDefault("userIp")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "userIp", valid_589040
  var valid_589041 = query.getOrDefault("key")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "key", valid_589041
  var valid_589042 = query.getOrDefault("prettyPrint")
  valid_589042 = validateParameter(valid_589042, JBool, required = false,
                                 default = newJBool(true))
  if valid_589042 != nil:
    section.add "prettyPrint", valid_589042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589043: Call_ClouduseraccountsGroupsGet_589031; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specified Group resource.
  ## 
  let valid = call_589043.validator(path, query, header, formData, body)
  let scheme = call_589043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589043.url(scheme.get, call_589043.host, call_589043.base,
                         call_589043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589043, url, valid)

proc call*(call_589044: Call_ClouduseraccountsGroupsGet_589031; groupName: string;
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
  var path_589045 = newJObject()
  var query_589046 = newJObject()
  add(query_589046, "fields", newJString(fields))
  add(query_589046, "quotaUser", newJString(quotaUser))
  add(query_589046, "alt", newJString(alt))
  add(query_589046, "oauth_token", newJString(oauthToken))
  add(path_589045, "groupName", newJString(groupName))
  add(query_589046, "userIp", newJString(userIp))
  add(query_589046, "key", newJString(key))
  add(path_589045, "project", newJString(project))
  add(query_589046, "prettyPrint", newJBool(prettyPrint))
  result = call_589044.call(path_589045, query_589046, nil, nil, nil)

var clouduseraccountsGroupsGet* = Call_ClouduseraccountsGroupsGet_589031(
    name: "clouduseraccountsGroupsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/groups/{groupName}",
    validator: validate_ClouduseraccountsGroupsGet_589032,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsGroupsGet_589033, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGroupsDelete_589047 = ref object of OpenApiRestCall_588457
proc url_ClouduseraccountsGroupsDelete_589049(protocol: Scheme; host: string;
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

proc validate_ClouduseraccountsGroupsDelete_589048(path: JsonNode; query: JsonNode;
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
  var valid_589050 = path.getOrDefault("groupName")
  valid_589050 = validateParameter(valid_589050, JString, required = true,
                                 default = nil)
  if valid_589050 != nil:
    section.add "groupName", valid_589050
  var valid_589051 = path.getOrDefault("project")
  valid_589051 = validateParameter(valid_589051, JString, required = true,
                                 default = nil)
  if valid_589051 != nil:
    section.add "project", valid_589051
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
  var valid_589052 = query.getOrDefault("fields")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "fields", valid_589052
  var valid_589053 = query.getOrDefault("quotaUser")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "quotaUser", valid_589053
  var valid_589054 = query.getOrDefault("alt")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = newJString("json"))
  if valid_589054 != nil:
    section.add "alt", valid_589054
  var valid_589055 = query.getOrDefault("oauth_token")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "oauth_token", valid_589055
  var valid_589056 = query.getOrDefault("userIp")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "userIp", valid_589056
  var valid_589057 = query.getOrDefault("key")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "key", valid_589057
  var valid_589058 = query.getOrDefault("prettyPrint")
  valid_589058 = validateParameter(valid_589058, JBool, required = false,
                                 default = newJBool(true))
  if valid_589058 != nil:
    section.add "prettyPrint", valid_589058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589059: Call_ClouduseraccountsGroupsDelete_589047; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified Group resource.
  ## 
  let valid = call_589059.validator(path, query, header, formData, body)
  let scheme = call_589059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589059.url(scheme.get, call_589059.host, call_589059.base,
                         call_589059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589059, url, valid)

proc call*(call_589060: Call_ClouduseraccountsGroupsDelete_589047;
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
  var path_589061 = newJObject()
  var query_589062 = newJObject()
  add(query_589062, "fields", newJString(fields))
  add(query_589062, "quotaUser", newJString(quotaUser))
  add(query_589062, "alt", newJString(alt))
  add(query_589062, "oauth_token", newJString(oauthToken))
  add(path_589061, "groupName", newJString(groupName))
  add(query_589062, "userIp", newJString(userIp))
  add(query_589062, "key", newJString(key))
  add(path_589061, "project", newJString(project))
  add(query_589062, "prettyPrint", newJBool(prettyPrint))
  result = call_589060.call(path_589061, query_589062, nil, nil, nil)

var clouduseraccountsGroupsDelete* = Call_ClouduseraccountsGroupsDelete_589047(
    name: "clouduseraccountsGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{project}/global/groups/{groupName}",
    validator: validate_ClouduseraccountsGroupsDelete_589048,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsGroupsDelete_589049, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGroupsAddMember_589063 = ref object of OpenApiRestCall_588457
proc url_ClouduseraccountsGroupsAddMember_589065(protocol: Scheme; host: string;
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

proc validate_ClouduseraccountsGroupsAddMember_589064(path: JsonNode;
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
  var valid_589066 = path.getOrDefault("groupName")
  valid_589066 = validateParameter(valid_589066, JString, required = true,
                                 default = nil)
  if valid_589066 != nil:
    section.add "groupName", valid_589066
  var valid_589067 = path.getOrDefault("project")
  valid_589067 = validateParameter(valid_589067, JString, required = true,
                                 default = nil)
  if valid_589067 != nil:
    section.add "project", valid_589067
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
  var valid_589068 = query.getOrDefault("fields")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "fields", valid_589068
  var valid_589069 = query.getOrDefault("quotaUser")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "quotaUser", valid_589069
  var valid_589070 = query.getOrDefault("alt")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = newJString("json"))
  if valid_589070 != nil:
    section.add "alt", valid_589070
  var valid_589071 = query.getOrDefault("oauth_token")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "oauth_token", valid_589071
  var valid_589072 = query.getOrDefault("userIp")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "userIp", valid_589072
  var valid_589073 = query.getOrDefault("key")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "key", valid_589073
  var valid_589074 = query.getOrDefault("prettyPrint")
  valid_589074 = validateParameter(valid_589074, JBool, required = false,
                                 default = newJBool(true))
  if valid_589074 != nil:
    section.add "prettyPrint", valid_589074
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

proc call*(call_589076: Call_ClouduseraccountsGroupsAddMember_589063;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds users to the specified group.
  ## 
  let valid = call_589076.validator(path, query, header, formData, body)
  let scheme = call_589076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589076.url(scheme.get, call_589076.host, call_589076.base,
                         call_589076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589076, url, valid)

proc call*(call_589077: Call_ClouduseraccountsGroupsAddMember_589063;
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
  var path_589078 = newJObject()
  var query_589079 = newJObject()
  var body_589080 = newJObject()
  add(query_589079, "fields", newJString(fields))
  add(query_589079, "quotaUser", newJString(quotaUser))
  add(query_589079, "alt", newJString(alt))
  add(query_589079, "oauth_token", newJString(oauthToken))
  add(path_589078, "groupName", newJString(groupName))
  add(query_589079, "userIp", newJString(userIp))
  add(query_589079, "key", newJString(key))
  add(path_589078, "project", newJString(project))
  if body != nil:
    body_589080 = body
  add(query_589079, "prettyPrint", newJBool(prettyPrint))
  result = call_589077.call(path_589078, query_589079, nil, nil, body_589080)

var clouduseraccountsGroupsAddMember* = Call_ClouduseraccountsGroupsAddMember_589063(
    name: "clouduseraccountsGroupsAddMember", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/groups/{groupName}/addMember",
    validator: validate_ClouduseraccountsGroupsAddMember_589064,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsGroupsAddMember_589065, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGroupsRemoveMember_589081 = ref object of OpenApiRestCall_588457
proc url_ClouduseraccountsGroupsRemoveMember_589083(protocol: Scheme; host: string;
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

proc validate_ClouduseraccountsGroupsRemoveMember_589082(path: JsonNode;
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
  var valid_589084 = path.getOrDefault("groupName")
  valid_589084 = validateParameter(valid_589084, JString, required = true,
                                 default = nil)
  if valid_589084 != nil:
    section.add "groupName", valid_589084
  var valid_589085 = path.getOrDefault("project")
  valid_589085 = validateParameter(valid_589085, JString, required = true,
                                 default = nil)
  if valid_589085 != nil:
    section.add "project", valid_589085
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
  var valid_589086 = query.getOrDefault("fields")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "fields", valid_589086
  var valid_589087 = query.getOrDefault("quotaUser")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "quotaUser", valid_589087
  var valid_589088 = query.getOrDefault("alt")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = newJString("json"))
  if valid_589088 != nil:
    section.add "alt", valid_589088
  var valid_589089 = query.getOrDefault("oauth_token")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "oauth_token", valid_589089
  var valid_589090 = query.getOrDefault("userIp")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "userIp", valid_589090
  var valid_589091 = query.getOrDefault("key")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "key", valid_589091
  var valid_589092 = query.getOrDefault("prettyPrint")
  valid_589092 = validateParameter(valid_589092, JBool, required = false,
                                 default = newJBool(true))
  if valid_589092 != nil:
    section.add "prettyPrint", valid_589092
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

proc call*(call_589094: Call_ClouduseraccountsGroupsRemoveMember_589081;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes users from the specified group.
  ## 
  let valid = call_589094.validator(path, query, header, formData, body)
  let scheme = call_589094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589094.url(scheme.get, call_589094.host, call_589094.base,
                         call_589094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589094, url, valid)

proc call*(call_589095: Call_ClouduseraccountsGroupsRemoveMember_589081;
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
  var path_589096 = newJObject()
  var query_589097 = newJObject()
  var body_589098 = newJObject()
  add(query_589097, "fields", newJString(fields))
  add(query_589097, "quotaUser", newJString(quotaUser))
  add(query_589097, "alt", newJString(alt))
  add(query_589097, "oauth_token", newJString(oauthToken))
  add(path_589096, "groupName", newJString(groupName))
  add(query_589097, "userIp", newJString(userIp))
  add(query_589097, "key", newJString(key))
  add(path_589096, "project", newJString(project))
  if body != nil:
    body_589098 = body
  add(query_589097, "prettyPrint", newJBool(prettyPrint))
  result = call_589095.call(path_589096, query_589097, nil, nil, body_589098)

var clouduseraccountsGroupsRemoveMember* = Call_ClouduseraccountsGroupsRemoveMember_589081(
    name: "clouduseraccountsGroupsRemoveMember", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/groups/{groupName}/removeMember",
    validator: validate_ClouduseraccountsGroupsRemoveMember_589082,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsGroupsRemoveMember_589083, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGroupsGetIamPolicy_589099 = ref object of OpenApiRestCall_588457
proc url_ClouduseraccountsGroupsGetIamPolicy_589101(protocol: Scheme; host: string;
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

proc validate_ClouduseraccountsGroupsGetIamPolicy_589100(path: JsonNode;
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
  var valid_589102 = path.getOrDefault("resource")
  valid_589102 = validateParameter(valid_589102, JString, required = true,
                                 default = nil)
  if valid_589102 != nil:
    section.add "resource", valid_589102
  var valid_589103 = path.getOrDefault("project")
  valid_589103 = validateParameter(valid_589103, JString, required = true,
                                 default = nil)
  if valid_589103 != nil:
    section.add "project", valid_589103
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
  var valid_589104 = query.getOrDefault("fields")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "fields", valid_589104
  var valid_589105 = query.getOrDefault("quotaUser")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "quotaUser", valid_589105
  var valid_589106 = query.getOrDefault("alt")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = newJString("json"))
  if valid_589106 != nil:
    section.add "alt", valid_589106
  var valid_589107 = query.getOrDefault("oauth_token")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "oauth_token", valid_589107
  var valid_589108 = query.getOrDefault("userIp")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "userIp", valid_589108
  var valid_589109 = query.getOrDefault("key")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "key", valid_589109
  var valid_589110 = query.getOrDefault("prettyPrint")
  valid_589110 = validateParameter(valid_589110, JBool, required = false,
                                 default = newJBool(true))
  if valid_589110 != nil:
    section.add "prettyPrint", valid_589110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589111: Call_ClouduseraccountsGroupsGetIamPolicy_589099;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource. May be empty if no such policy or resource exists.
  ## 
  let valid = call_589111.validator(path, query, header, formData, body)
  let scheme = call_589111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589111.url(scheme.get, call_589111.host, call_589111.base,
                         call_589111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589111, url, valid)

proc call*(call_589112: Call_ClouduseraccountsGroupsGetIamPolicy_589099;
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
  var path_589113 = newJObject()
  var query_589114 = newJObject()
  add(query_589114, "fields", newJString(fields))
  add(query_589114, "quotaUser", newJString(quotaUser))
  add(query_589114, "alt", newJString(alt))
  add(query_589114, "oauth_token", newJString(oauthToken))
  add(query_589114, "userIp", newJString(userIp))
  add(query_589114, "key", newJString(key))
  add(path_589113, "resource", newJString(resource))
  add(path_589113, "project", newJString(project))
  add(query_589114, "prettyPrint", newJBool(prettyPrint))
  result = call_589112.call(path_589113, query_589114, nil, nil, nil)

var clouduseraccountsGroupsGetIamPolicy* = Call_ClouduseraccountsGroupsGetIamPolicy_589099(
    name: "clouduseraccountsGroupsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/groups/{resource}/getIamPolicy",
    validator: validate_ClouduseraccountsGroupsGetIamPolicy_589100,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsGroupsGetIamPolicy_589101, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGroupsSetIamPolicy_589115 = ref object of OpenApiRestCall_588457
proc url_ClouduseraccountsGroupsSetIamPolicy_589117(protocol: Scheme; host: string;
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

proc validate_ClouduseraccountsGroupsSetIamPolicy_589116(path: JsonNode;
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
  var valid_589118 = path.getOrDefault("resource")
  valid_589118 = validateParameter(valid_589118, JString, required = true,
                                 default = nil)
  if valid_589118 != nil:
    section.add "resource", valid_589118
  var valid_589119 = path.getOrDefault("project")
  valid_589119 = validateParameter(valid_589119, JString, required = true,
                                 default = nil)
  if valid_589119 != nil:
    section.add "project", valid_589119
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
  var valid_589120 = query.getOrDefault("fields")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "fields", valid_589120
  var valid_589121 = query.getOrDefault("quotaUser")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "quotaUser", valid_589121
  var valid_589122 = query.getOrDefault("alt")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = newJString("json"))
  if valid_589122 != nil:
    section.add "alt", valid_589122
  var valid_589123 = query.getOrDefault("oauth_token")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "oauth_token", valid_589123
  var valid_589124 = query.getOrDefault("userIp")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "userIp", valid_589124
  var valid_589125 = query.getOrDefault("key")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "key", valid_589125
  var valid_589126 = query.getOrDefault("prettyPrint")
  valid_589126 = validateParameter(valid_589126, JBool, required = false,
                                 default = newJBool(true))
  if valid_589126 != nil:
    section.add "prettyPrint", valid_589126
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

proc call*(call_589128: Call_ClouduseraccountsGroupsSetIamPolicy_589115;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any existing policy.
  ## 
  let valid = call_589128.validator(path, query, header, formData, body)
  let scheme = call_589128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589128.url(scheme.get, call_589128.host, call_589128.base,
                         call_589128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589128, url, valid)

proc call*(call_589129: Call_ClouduseraccountsGroupsSetIamPolicy_589115;
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
  var path_589130 = newJObject()
  var query_589131 = newJObject()
  var body_589132 = newJObject()
  add(query_589131, "fields", newJString(fields))
  add(query_589131, "quotaUser", newJString(quotaUser))
  add(query_589131, "alt", newJString(alt))
  add(query_589131, "oauth_token", newJString(oauthToken))
  add(query_589131, "userIp", newJString(userIp))
  add(query_589131, "key", newJString(key))
  add(path_589130, "resource", newJString(resource))
  add(path_589130, "project", newJString(project))
  if body != nil:
    body_589132 = body
  add(query_589131, "prettyPrint", newJBool(prettyPrint))
  result = call_589129.call(path_589130, query_589131, nil, nil, body_589132)

var clouduseraccountsGroupsSetIamPolicy* = Call_ClouduseraccountsGroupsSetIamPolicy_589115(
    name: "clouduseraccountsGroupsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/groups/{resource}/setIamPolicy",
    validator: validate_ClouduseraccountsGroupsSetIamPolicy_589116,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsGroupsSetIamPolicy_589117, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGroupsTestIamPermissions_589133 = ref object of OpenApiRestCall_588457
proc url_ClouduseraccountsGroupsTestIamPermissions_589135(protocol: Scheme;
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

proc validate_ClouduseraccountsGroupsTestIamPermissions_589134(path: JsonNode;
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
  var valid_589136 = path.getOrDefault("resource")
  valid_589136 = validateParameter(valid_589136, JString, required = true,
                                 default = nil)
  if valid_589136 != nil:
    section.add "resource", valid_589136
  var valid_589137 = path.getOrDefault("project")
  valid_589137 = validateParameter(valid_589137, JString, required = true,
                                 default = nil)
  if valid_589137 != nil:
    section.add "project", valid_589137
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
  var valid_589138 = query.getOrDefault("fields")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "fields", valid_589138
  var valid_589139 = query.getOrDefault("quotaUser")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "quotaUser", valid_589139
  var valid_589140 = query.getOrDefault("alt")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = newJString("json"))
  if valid_589140 != nil:
    section.add "alt", valid_589140
  var valid_589141 = query.getOrDefault("oauth_token")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "oauth_token", valid_589141
  var valid_589142 = query.getOrDefault("userIp")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = nil)
  if valid_589142 != nil:
    section.add "userIp", valid_589142
  var valid_589143 = query.getOrDefault("key")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = nil)
  if valid_589143 != nil:
    section.add "key", valid_589143
  var valid_589144 = query.getOrDefault("prettyPrint")
  valid_589144 = validateParameter(valid_589144, JBool, required = false,
                                 default = newJBool(true))
  if valid_589144 != nil:
    section.add "prettyPrint", valid_589144
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

proc call*(call_589146: Call_ClouduseraccountsGroupsTestIamPermissions_589133;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified resource.
  ## 
  let valid = call_589146.validator(path, query, header, formData, body)
  let scheme = call_589146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589146.url(scheme.get, call_589146.host, call_589146.base,
                         call_589146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589146, url, valid)

proc call*(call_589147: Call_ClouduseraccountsGroupsTestIamPermissions_589133;
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
  var path_589148 = newJObject()
  var query_589149 = newJObject()
  var body_589150 = newJObject()
  add(query_589149, "fields", newJString(fields))
  add(query_589149, "quotaUser", newJString(quotaUser))
  add(query_589149, "alt", newJString(alt))
  add(query_589149, "oauth_token", newJString(oauthToken))
  add(query_589149, "userIp", newJString(userIp))
  add(query_589149, "key", newJString(key))
  add(path_589148, "resource", newJString(resource))
  add(path_589148, "project", newJString(project))
  if body != nil:
    body_589150 = body
  add(query_589149, "prettyPrint", newJBool(prettyPrint))
  result = call_589147.call(path_589148, query_589149, nil, nil, body_589150)

var clouduseraccountsGroupsTestIamPermissions* = Call_ClouduseraccountsGroupsTestIamPermissions_589133(
    name: "clouduseraccountsGroupsTestIamPermissions", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/groups/{resource}/testIamPermissions",
    validator: validate_ClouduseraccountsGroupsTestIamPermissions_589134,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsGroupsTestIamPermissions_589135,
    schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGlobalAccountsOperationsList_589151 = ref object of OpenApiRestCall_588457
proc url_ClouduseraccountsGlobalAccountsOperationsList_589153(protocol: Scheme;
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

proc validate_ClouduseraccountsGlobalAccountsOperationsList_589152(
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
  var valid_589154 = path.getOrDefault("project")
  valid_589154 = validateParameter(valid_589154, JString, required = true,
                                 default = nil)
  if valid_589154 != nil:
    section.add "project", valid_589154
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
  var valid_589155 = query.getOrDefault("fields")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "fields", valid_589155
  var valid_589156 = query.getOrDefault("pageToken")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "pageToken", valid_589156
  var valid_589157 = query.getOrDefault("quotaUser")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "quotaUser", valid_589157
  var valid_589158 = query.getOrDefault("alt")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = newJString("json"))
  if valid_589158 != nil:
    section.add "alt", valid_589158
  var valid_589159 = query.getOrDefault("oauth_token")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "oauth_token", valid_589159
  var valid_589160 = query.getOrDefault("userIp")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "userIp", valid_589160
  var valid_589161 = query.getOrDefault("maxResults")
  valid_589161 = validateParameter(valid_589161, JInt, required = false,
                                 default = newJInt(500))
  if valid_589161 != nil:
    section.add "maxResults", valid_589161
  var valid_589162 = query.getOrDefault("orderBy")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "orderBy", valid_589162
  var valid_589163 = query.getOrDefault("key")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = nil)
  if valid_589163 != nil:
    section.add "key", valid_589163
  var valid_589164 = query.getOrDefault("prettyPrint")
  valid_589164 = validateParameter(valid_589164, JBool, required = false,
                                 default = newJBool(true))
  if valid_589164 != nil:
    section.add "prettyPrint", valid_589164
  var valid_589165 = query.getOrDefault("filter")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "filter", valid_589165
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589166: Call_ClouduseraccountsGlobalAccountsOperationsList_589151;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of operation resources contained within the specified project.
  ## 
  let valid = call_589166.validator(path, query, header, formData, body)
  let scheme = call_589166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589166.url(scheme.get, call_589166.host, call_589166.base,
                         call_589166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589166, url, valid)

proc call*(call_589167: Call_ClouduseraccountsGlobalAccountsOperationsList_589151;
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
  var path_589168 = newJObject()
  var query_589169 = newJObject()
  add(query_589169, "fields", newJString(fields))
  add(query_589169, "pageToken", newJString(pageToken))
  add(query_589169, "quotaUser", newJString(quotaUser))
  add(query_589169, "alt", newJString(alt))
  add(query_589169, "oauth_token", newJString(oauthToken))
  add(query_589169, "userIp", newJString(userIp))
  add(query_589169, "maxResults", newJInt(maxResults))
  add(query_589169, "orderBy", newJString(orderBy))
  add(query_589169, "key", newJString(key))
  add(path_589168, "project", newJString(project))
  add(query_589169, "prettyPrint", newJBool(prettyPrint))
  add(query_589169, "filter", newJString(filter))
  result = call_589167.call(path_589168, query_589169, nil, nil, nil)

var clouduseraccountsGlobalAccountsOperationsList* = Call_ClouduseraccountsGlobalAccountsOperationsList_589151(
    name: "clouduseraccountsGlobalAccountsOperationsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{project}/global/operations",
    validator: validate_ClouduseraccountsGlobalAccountsOperationsList_589152,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsGlobalAccountsOperationsList_589153,
    schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGlobalAccountsOperationsGet_589170 = ref object of OpenApiRestCall_588457
proc url_ClouduseraccountsGlobalAccountsOperationsGet_589172(protocol: Scheme;
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

proc validate_ClouduseraccountsGlobalAccountsOperationsGet_589171(path: JsonNode;
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
  var valid_589173 = path.getOrDefault("operation")
  valid_589173 = validateParameter(valid_589173, JString, required = true,
                                 default = nil)
  if valid_589173 != nil:
    section.add "operation", valid_589173
  var valid_589174 = path.getOrDefault("project")
  valid_589174 = validateParameter(valid_589174, JString, required = true,
                                 default = nil)
  if valid_589174 != nil:
    section.add "project", valid_589174
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
  var valid_589175 = query.getOrDefault("fields")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "fields", valid_589175
  var valid_589176 = query.getOrDefault("quotaUser")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "quotaUser", valid_589176
  var valid_589177 = query.getOrDefault("alt")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = newJString("json"))
  if valid_589177 != nil:
    section.add "alt", valid_589177
  var valid_589178 = query.getOrDefault("oauth_token")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "oauth_token", valid_589178
  var valid_589179 = query.getOrDefault("userIp")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "userIp", valid_589179
  var valid_589180 = query.getOrDefault("key")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "key", valid_589180
  var valid_589181 = query.getOrDefault("prettyPrint")
  valid_589181 = validateParameter(valid_589181, JBool, required = false,
                                 default = newJBool(true))
  if valid_589181 != nil:
    section.add "prettyPrint", valid_589181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589182: Call_ClouduseraccountsGlobalAccountsOperationsGet_589170;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the specified operation resource.
  ## 
  let valid = call_589182.validator(path, query, header, formData, body)
  let scheme = call_589182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589182.url(scheme.get, call_589182.host, call_589182.base,
                         call_589182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589182, url, valid)

proc call*(call_589183: Call_ClouduseraccountsGlobalAccountsOperationsGet_589170;
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
  var path_589184 = newJObject()
  var query_589185 = newJObject()
  add(query_589185, "fields", newJString(fields))
  add(query_589185, "quotaUser", newJString(quotaUser))
  add(query_589185, "alt", newJString(alt))
  add(path_589184, "operation", newJString(operation))
  add(query_589185, "oauth_token", newJString(oauthToken))
  add(query_589185, "userIp", newJString(userIp))
  add(query_589185, "key", newJString(key))
  add(path_589184, "project", newJString(project))
  add(query_589185, "prettyPrint", newJBool(prettyPrint))
  result = call_589183.call(path_589184, query_589185, nil, nil, nil)

var clouduseraccountsGlobalAccountsOperationsGet* = Call_ClouduseraccountsGlobalAccountsOperationsGet_589170(
    name: "clouduseraccountsGlobalAccountsOperationsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/{project}/global/operations/{operation}",
    validator: validate_ClouduseraccountsGlobalAccountsOperationsGet_589171,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsGlobalAccountsOperationsGet_589172,
    schemes: {Scheme.Https})
type
  Call_ClouduseraccountsGlobalAccountsOperationsDelete_589186 = ref object of OpenApiRestCall_588457
proc url_ClouduseraccountsGlobalAccountsOperationsDelete_589188(protocol: Scheme;
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

proc validate_ClouduseraccountsGlobalAccountsOperationsDelete_589187(
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
  var valid_589189 = path.getOrDefault("operation")
  valid_589189 = validateParameter(valid_589189, JString, required = true,
                                 default = nil)
  if valid_589189 != nil:
    section.add "operation", valid_589189
  var valid_589190 = path.getOrDefault("project")
  valid_589190 = validateParameter(valid_589190, JString, required = true,
                                 default = nil)
  if valid_589190 != nil:
    section.add "project", valid_589190
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
  var valid_589191 = query.getOrDefault("fields")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = nil)
  if valid_589191 != nil:
    section.add "fields", valid_589191
  var valid_589192 = query.getOrDefault("quotaUser")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "quotaUser", valid_589192
  var valid_589193 = query.getOrDefault("alt")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = newJString("json"))
  if valid_589193 != nil:
    section.add "alt", valid_589193
  var valid_589194 = query.getOrDefault("oauth_token")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "oauth_token", valid_589194
  var valid_589195 = query.getOrDefault("userIp")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "userIp", valid_589195
  var valid_589196 = query.getOrDefault("key")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "key", valid_589196
  var valid_589197 = query.getOrDefault("prettyPrint")
  valid_589197 = validateParameter(valid_589197, JBool, required = false,
                                 default = newJBool(true))
  if valid_589197 != nil:
    section.add "prettyPrint", valid_589197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589198: Call_ClouduseraccountsGlobalAccountsOperationsDelete_589186;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified operation resource.
  ## 
  let valid = call_589198.validator(path, query, header, formData, body)
  let scheme = call_589198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589198.url(scheme.get, call_589198.host, call_589198.base,
                         call_589198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589198, url, valid)

proc call*(call_589199: Call_ClouduseraccountsGlobalAccountsOperationsDelete_589186;
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
  var path_589200 = newJObject()
  var query_589201 = newJObject()
  add(query_589201, "fields", newJString(fields))
  add(query_589201, "quotaUser", newJString(quotaUser))
  add(query_589201, "alt", newJString(alt))
  add(path_589200, "operation", newJString(operation))
  add(query_589201, "oauth_token", newJString(oauthToken))
  add(query_589201, "userIp", newJString(userIp))
  add(query_589201, "key", newJString(key))
  add(path_589200, "project", newJString(project))
  add(query_589201, "prettyPrint", newJBool(prettyPrint))
  result = call_589199.call(path_589200, query_589201, nil, nil, nil)

var clouduseraccountsGlobalAccountsOperationsDelete* = Call_ClouduseraccountsGlobalAccountsOperationsDelete_589186(
    name: "clouduseraccountsGlobalAccountsOperationsDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/{project}/global/operations/{operation}",
    validator: validate_ClouduseraccountsGlobalAccountsOperationsDelete_589187,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsGlobalAccountsOperationsDelete_589188,
    schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersInsert_589221 = ref object of OpenApiRestCall_588457
proc url_ClouduseraccountsUsersInsert_589223(protocol: Scheme; host: string;
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

proc validate_ClouduseraccountsUsersInsert_589222(path: JsonNode; query: JsonNode;
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
  var valid_589224 = path.getOrDefault("project")
  valid_589224 = validateParameter(valid_589224, JString, required = true,
                                 default = nil)
  if valid_589224 != nil:
    section.add "project", valid_589224
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
  var valid_589225 = query.getOrDefault("fields")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = nil)
  if valid_589225 != nil:
    section.add "fields", valid_589225
  var valid_589226 = query.getOrDefault("quotaUser")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "quotaUser", valid_589226
  var valid_589227 = query.getOrDefault("alt")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = newJString("json"))
  if valid_589227 != nil:
    section.add "alt", valid_589227
  var valid_589228 = query.getOrDefault("oauth_token")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = nil)
  if valid_589228 != nil:
    section.add "oauth_token", valid_589228
  var valid_589229 = query.getOrDefault("userIp")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = nil)
  if valid_589229 != nil:
    section.add "userIp", valid_589229
  var valid_589230 = query.getOrDefault("key")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = nil)
  if valid_589230 != nil:
    section.add "key", valid_589230
  var valid_589231 = query.getOrDefault("prettyPrint")
  valid_589231 = validateParameter(valid_589231, JBool, required = false,
                                 default = newJBool(true))
  if valid_589231 != nil:
    section.add "prettyPrint", valid_589231
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

proc call*(call_589233: Call_ClouduseraccountsUsersInsert_589221; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a User resource in the specified project using the data included in the request.
  ## 
  let valid = call_589233.validator(path, query, header, formData, body)
  let scheme = call_589233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589233.url(scheme.get, call_589233.host, call_589233.base,
                         call_589233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589233, url, valid)

proc call*(call_589234: Call_ClouduseraccountsUsersInsert_589221; project: string;
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
  var path_589235 = newJObject()
  var query_589236 = newJObject()
  var body_589237 = newJObject()
  add(query_589236, "fields", newJString(fields))
  add(query_589236, "quotaUser", newJString(quotaUser))
  add(query_589236, "alt", newJString(alt))
  add(query_589236, "oauth_token", newJString(oauthToken))
  add(query_589236, "userIp", newJString(userIp))
  add(query_589236, "key", newJString(key))
  add(path_589235, "project", newJString(project))
  if body != nil:
    body_589237 = body
  add(query_589236, "prettyPrint", newJBool(prettyPrint))
  result = call_589234.call(path_589235, query_589236, nil, nil, body_589237)

var clouduseraccountsUsersInsert* = Call_ClouduseraccountsUsersInsert_589221(
    name: "clouduseraccountsUsersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/global/users",
    validator: validate_ClouduseraccountsUsersInsert_589222,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsUsersInsert_589223, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersList_589202 = ref object of OpenApiRestCall_588457
proc url_ClouduseraccountsUsersList_589204(protocol: Scheme; host: string;
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

proc validate_ClouduseraccountsUsersList_589203(path: JsonNode; query: JsonNode;
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
  var valid_589205 = path.getOrDefault("project")
  valid_589205 = validateParameter(valid_589205, JString, required = true,
                                 default = nil)
  if valid_589205 != nil:
    section.add "project", valid_589205
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
  var valid_589206 = query.getOrDefault("fields")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "fields", valid_589206
  var valid_589207 = query.getOrDefault("pageToken")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "pageToken", valid_589207
  var valid_589208 = query.getOrDefault("quotaUser")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "quotaUser", valid_589208
  var valid_589209 = query.getOrDefault("alt")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = newJString("json"))
  if valid_589209 != nil:
    section.add "alt", valid_589209
  var valid_589210 = query.getOrDefault("oauth_token")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = nil)
  if valid_589210 != nil:
    section.add "oauth_token", valid_589210
  var valid_589211 = query.getOrDefault("userIp")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = nil)
  if valid_589211 != nil:
    section.add "userIp", valid_589211
  var valid_589212 = query.getOrDefault("maxResults")
  valid_589212 = validateParameter(valid_589212, JInt, required = false,
                                 default = newJInt(500))
  if valid_589212 != nil:
    section.add "maxResults", valid_589212
  var valid_589213 = query.getOrDefault("orderBy")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "orderBy", valid_589213
  var valid_589214 = query.getOrDefault("key")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "key", valid_589214
  var valid_589215 = query.getOrDefault("prettyPrint")
  valid_589215 = validateParameter(valid_589215, JBool, required = false,
                                 default = newJBool(true))
  if valid_589215 != nil:
    section.add "prettyPrint", valid_589215
  var valid_589216 = query.getOrDefault("filter")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = nil)
  if valid_589216 != nil:
    section.add "filter", valid_589216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589217: Call_ClouduseraccountsUsersList_589202; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of users contained within the specified project.
  ## 
  let valid = call_589217.validator(path, query, header, formData, body)
  let scheme = call_589217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589217.url(scheme.get, call_589217.host, call_589217.base,
                         call_589217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589217, url, valid)

proc call*(call_589218: Call_ClouduseraccountsUsersList_589202; project: string;
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
  var path_589219 = newJObject()
  var query_589220 = newJObject()
  add(query_589220, "fields", newJString(fields))
  add(query_589220, "pageToken", newJString(pageToken))
  add(query_589220, "quotaUser", newJString(quotaUser))
  add(query_589220, "alt", newJString(alt))
  add(query_589220, "oauth_token", newJString(oauthToken))
  add(query_589220, "userIp", newJString(userIp))
  add(query_589220, "maxResults", newJInt(maxResults))
  add(query_589220, "orderBy", newJString(orderBy))
  add(query_589220, "key", newJString(key))
  add(path_589219, "project", newJString(project))
  add(query_589220, "prettyPrint", newJBool(prettyPrint))
  add(query_589220, "filter", newJString(filter))
  result = call_589218.call(path_589219, query_589220, nil, nil, nil)

var clouduseraccountsUsersList* = Call_ClouduseraccountsUsersList_589202(
    name: "clouduseraccountsUsersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/users",
    validator: validate_ClouduseraccountsUsersList_589203,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsUsersList_589204, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersGetIamPolicy_589238 = ref object of OpenApiRestCall_588457
proc url_ClouduseraccountsUsersGetIamPolicy_589240(protocol: Scheme; host: string;
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

proc validate_ClouduseraccountsUsersGetIamPolicy_589239(path: JsonNode;
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
  var valid_589241 = path.getOrDefault("resource")
  valid_589241 = validateParameter(valid_589241, JString, required = true,
                                 default = nil)
  if valid_589241 != nil:
    section.add "resource", valid_589241
  var valid_589242 = path.getOrDefault("project")
  valid_589242 = validateParameter(valid_589242, JString, required = true,
                                 default = nil)
  if valid_589242 != nil:
    section.add "project", valid_589242
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
  var valid_589243 = query.getOrDefault("fields")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "fields", valid_589243
  var valid_589244 = query.getOrDefault("quotaUser")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = nil)
  if valid_589244 != nil:
    section.add "quotaUser", valid_589244
  var valid_589245 = query.getOrDefault("alt")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = newJString("json"))
  if valid_589245 != nil:
    section.add "alt", valid_589245
  var valid_589246 = query.getOrDefault("oauth_token")
  valid_589246 = validateParameter(valid_589246, JString, required = false,
                                 default = nil)
  if valid_589246 != nil:
    section.add "oauth_token", valid_589246
  var valid_589247 = query.getOrDefault("userIp")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = nil)
  if valid_589247 != nil:
    section.add "userIp", valid_589247
  var valid_589248 = query.getOrDefault("key")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "key", valid_589248
  var valid_589249 = query.getOrDefault("prettyPrint")
  valid_589249 = validateParameter(valid_589249, JBool, required = false,
                                 default = newJBool(true))
  if valid_589249 != nil:
    section.add "prettyPrint", valid_589249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589250: Call_ClouduseraccountsUsersGetIamPolicy_589238;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource. May be empty if no such policy or resource exists.
  ## 
  let valid = call_589250.validator(path, query, header, formData, body)
  let scheme = call_589250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589250.url(scheme.get, call_589250.host, call_589250.base,
                         call_589250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589250, url, valid)

proc call*(call_589251: Call_ClouduseraccountsUsersGetIamPolicy_589238;
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
  var path_589252 = newJObject()
  var query_589253 = newJObject()
  add(query_589253, "fields", newJString(fields))
  add(query_589253, "quotaUser", newJString(quotaUser))
  add(query_589253, "alt", newJString(alt))
  add(query_589253, "oauth_token", newJString(oauthToken))
  add(query_589253, "userIp", newJString(userIp))
  add(query_589253, "key", newJString(key))
  add(path_589252, "resource", newJString(resource))
  add(path_589252, "project", newJString(project))
  add(query_589253, "prettyPrint", newJBool(prettyPrint))
  result = call_589251.call(path_589252, query_589253, nil, nil, nil)

var clouduseraccountsUsersGetIamPolicy* = Call_ClouduseraccountsUsersGetIamPolicy_589238(
    name: "clouduseraccountsUsersGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/users/{resource}/getIamPolicy",
    validator: validate_ClouduseraccountsUsersGetIamPolicy_589239,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsUsersGetIamPolicy_589240, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersSetIamPolicy_589254 = ref object of OpenApiRestCall_588457
proc url_ClouduseraccountsUsersSetIamPolicy_589256(protocol: Scheme; host: string;
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

proc validate_ClouduseraccountsUsersSetIamPolicy_589255(path: JsonNode;
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
  var valid_589257 = path.getOrDefault("resource")
  valid_589257 = validateParameter(valid_589257, JString, required = true,
                                 default = nil)
  if valid_589257 != nil:
    section.add "resource", valid_589257
  var valid_589258 = path.getOrDefault("project")
  valid_589258 = validateParameter(valid_589258, JString, required = true,
                                 default = nil)
  if valid_589258 != nil:
    section.add "project", valid_589258
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
  var valid_589259 = query.getOrDefault("fields")
  valid_589259 = validateParameter(valid_589259, JString, required = false,
                                 default = nil)
  if valid_589259 != nil:
    section.add "fields", valid_589259
  var valid_589260 = query.getOrDefault("quotaUser")
  valid_589260 = validateParameter(valid_589260, JString, required = false,
                                 default = nil)
  if valid_589260 != nil:
    section.add "quotaUser", valid_589260
  var valid_589261 = query.getOrDefault("alt")
  valid_589261 = validateParameter(valid_589261, JString, required = false,
                                 default = newJString("json"))
  if valid_589261 != nil:
    section.add "alt", valid_589261
  var valid_589262 = query.getOrDefault("oauth_token")
  valid_589262 = validateParameter(valid_589262, JString, required = false,
                                 default = nil)
  if valid_589262 != nil:
    section.add "oauth_token", valid_589262
  var valid_589263 = query.getOrDefault("userIp")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = nil)
  if valid_589263 != nil:
    section.add "userIp", valid_589263
  var valid_589264 = query.getOrDefault("key")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "key", valid_589264
  var valid_589265 = query.getOrDefault("prettyPrint")
  valid_589265 = validateParameter(valid_589265, JBool, required = false,
                                 default = newJBool(true))
  if valid_589265 != nil:
    section.add "prettyPrint", valid_589265
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

proc call*(call_589267: Call_ClouduseraccountsUsersSetIamPolicy_589254;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any existing policy.
  ## 
  let valid = call_589267.validator(path, query, header, formData, body)
  let scheme = call_589267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589267.url(scheme.get, call_589267.host, call_589267.base,
                         call_589267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589267, url, valid)

proc call*(call_589268: Call_ClouduseraccountsUsersSetIamPolicy_589254;
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
  var path_589269 = newJObject()
  var query_589270 = newJObject()
  var body_589271 = newJObject()
  add(query_589270, "fields", newJString(fields))
  add(query_589270, "quotaUser", newJString(quotaUser))
  add(query_589270, "alt", newJString(alt))
  add(query_589270, "oauth_token", newJString(oauthToken))
  add(query_589270, "userIp", newJString(userIp))
  add(query_589270, "key", newJString(key))
  add(path_589269, "resource", newJString(resource))
  add(path_589269, "project", newJString(project))
  if body != nil:
    body_589271 = body
  add(query_589270, "prettyPrint", newJBool(prettyPrint))
  result = call_589268.call(path_589269, query_589270, nil, nil, body_589271)

var clouduseraccountsUsersSetIamPolicy* = Call_ClouduseraccountsUsersSetIamPolicy_589254(
    name: "clouduseraccountsUsersSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/users/{resource}/setIamPolicy",
    validator: validate_ClouduseraccountsUsersSetIamPolicy_589255,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsUsersSetIamPolicy_589256, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersTestIamPermissions_589272 = ref object of OpenApiRestCall_588457
proc url_ClouduseraccountsUsersTestIamPermissions_589274(protocol: Scheme;
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

proc validate_ClouduseraccountsUsersTestIamPermissions_589273(path: JsonNode;
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
  var valid_589275 = path.getOrDefault("resource")
  valid_589275 = validateParameter(valid_589275, JString, required = true,
                                 default = nil)
  if valid_589275 != nil:
    section.add "resource", valid_589275
  var valid_589276 = path.getOrDefault("project")
  valid_589276 = validateParameter(valid_589276, JString, required = true,
                                 default = nil)
  if valid_589276 != nil:
    section.add "project", valid_589276
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
  var valid_589277 = query.getOrDefault("fields")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = nil)
  if valid_589277 != nil:
    section.add "fields", valid_589277
  var valid_589278 = query.getOrDefault("quotaUser")
  valid_589278 = validateParameter(valid_589278, JString, required = false,
                                 default = nil)
  if valid_589278 != nil:
    section.add "quotaUser", valid_589278
  var valid_589279 = query.getOrDefault("alt")
  valid_589279 = validateParameter(valid_589279, JString, required = false,
                                 default = newJString("json"))
  if valid_589279 != nil:
    section.add "alt", valid_589279
  var valid_589280 = query.getOrDefault("oauth_token")
  valid_589280 = validateParameter(valid_589280, JString, required = false,
                                 default = nil)
  if valid_589280 != nil:
    section.add "oauth_token", valid_589280
  var valid_589281 = query.getOrDefault("userIp")
  valid_589281 = validateParameter(valid_589281, JString, required = false,
                                 default = nil)
  if valid_589281 != nil:
    section.add "userIp", valid_589281
  var valid_589282 = query.getOrDefault("key")
  valid_589282 = validateParameter(valid_589282, JString, required = false,
                                 default = nil)
  if valid_589282 != nil:
    section.add "key", valid_589282
  var valid_589283 = query.getOrDefault("prettyPrint")
  valid_589283 = validateParameter(valid_589283, JBool, required = false,
                                 default = newJBool(true))
  if valid_589283 != nil:
    section.add "prettyPrint", valid_589283
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

proc call*(call_589285: Call_ClouduseraccountsUsersTestIamPermissions_589272;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified resource.
  ## 
  let valid = call_589285.validator(path, query, header, formData, body)
  let scheme = call_589285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589285.url(scheme.get, call_589285.host, call_589285.base,
                         call_589285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589285, url, valid)

proc call*(call_589286: Call_ClouduseraccountsUsersTestIamPermissions_589272;
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
  var path_589287 = newJObject()
  var query_589288 = newJObject()
  var body_589289 = newJObject()
  add(query_589288, "fields", newJString(fields))
  add(query_589288, "quotaUser", newJString(quotaUser))
  add(query_589288, "alt", newJString(alt))
  add(query_589288, "oauth_token", newJString(oauthToken))
  add(query_589288, "userIp", newJString(userIp))
  add(query_589288, "key", newJString(key))
  add(path_589287, "resource", newJString(resource))
  add(path_589287, "project", newJString(project))
  if body != nil:
    body_589289 = body
  add(query_589288, "prettyPrint", newJBool(prettyPrint))
  result = call_589286.call(path_589287, query_589288, nil, nil, body_589289)

var clouduseraccountsUsersTestIamPermissions* = Call_ClouduseraccountsUsersTestIamPermissions_589272(
    name: "clouduseraccountsUsersTestIamPermissions", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/users/{resource}/testIamPermissions",
    validator: validate_ClouduseraccountsUsersTestIamPermissions_589273,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsUsersTestIamPermissions_589274,
    schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersGet_589290 = ref object of OpenApiRestCall_588457
proc url_ClouduseraccountsUsersGet_589292(protocol: Scheme; host: string;
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

proc validate_ClouduseraccountsUsersGet_589291(path: JsonNode; query: JsonNode;
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
  var valid_589293 = path.getOrDefault("user")
  valid_589293 = validateParameter(valid_589293, JString, required = true,
                                 default = nil)
  if valid_589293 != nil:
    section.add "user", valid_589293
  var valid_589294 = path.getOrDefault("project")
  valid_589294 = validateParameter(valid_589294, JString, required = true,
                                 default = nil)
  if valid_589294 != nil:
    section.add "project", valid_589294
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
  var valid_589295 = query.getOrDefault("fields")
  valid_589295 = validateParameter(valid_589295, JString, required = false,
                                 default = nil)
  if valid_589295 != nil:
    section.add "fields", valid_589295
  var valid_589296 = query.getOrDefault("quotaUser")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = nil)
  if valid_589296 != nil:
    section.add "quotaUser", valid_589296
  var valid_589297 = query.getOrDefault("alt")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = newJString("json"))
  if valid_589297 != nil:
    section.add "alt", valid_589297
  var valid_589298 = query.getOrDefault("oauth_token")
  valid_589298 = validateParameter(valid_589298, JString, required = false,
                                 default = nil)
  if valid_589298 != nil:
    section.add "oauth_token", valid_589298
  var valid_589299 = query.getOrDefault("userIp")
  valid_589299 = validateParameter(valid_589299, JString, required = false,
                                 default = nil)
  if valid_589299 != nil:
    section.add "userIp", valid_589299
  var valid_589300 = query.getOrDefault("key")
  valid_589300 = validateParameter(valid_589300, JString, required = false,
                                 default = nil)
  if valid_589300 != nil:
    section.add "key", valid_589300
  var valid_589301 = query.getOrDefault("prettyPrint")
  valid_589301 = validateParameter(valid_589301, JBool, required = false,
                                 default = newJBool(true))
  if valid_589301 != nil:
    section.add "prettyPrint", valid_589301
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589302: Call_ClouduseraccountsUsersGet_589290; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specified User resource.
  ## 
  let valid = call_589302.validator(path, query, header, formData, body)
  let scheme = call_589302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589302.url(scheme.get, call_589302.host, call_589302.base,
                         call_589302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589302, url, valid)

proc call*(call_589303: Call_ClouduseraccountsUsersGet_589290; user: string;
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
  var path_589304 = newJObject()
  var query_589305 = newJObject()
  add(query_589305, "fields", newJString(fields))
  add(query_589305, "quotaUser", newJString(quotaUser))
  add(query_589305, "alt", newJString(alt))
  add(path_589304, "user", newJString(user))
  add(query_589305, "oauth_token", newJString(oauthToken))
  add(query_589305, "userIp", newJString(userIp))
  add(query_589305, "key", newJString(key))
  add(path_589304, "project", newJString(project))
  add(query_589305, "prettyPrint", newJBool(prettyPrint))
  result = call_589303.call(path_589304, query_589305, nil, nil, nil)

var clouduseraccountsUsersGet* = Call_ClouduseraccountsUsersGet_589290(
    name: "clouduseraccountsUsersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/users/{user}",
    validator: validate_ClouduseraccountsUsersGet_589291,
    base: "/clouduseraccounts/alpha/projects", url: url_ClouduseraccountsUsersGet_589292,
    schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersDelete_589306 = ref object of OpenApiRestCall_588457
proc url_ClouduseraccountsUsersDelete_589308(protocol: Scheme; host: string;
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

proc validate_ClouduseraccountsUsersDelete_589307(path: JsonNode; query: JsonNode;
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
  var valid_589309 = path.getOrDefault("user")
  valid_589309 = validateParameter(valid_589309, JString, required = true,
                                 default = nil)
  if valid_589309 != nil:
    section.add "user", valid_589309
  var valid_589310 = path.getOrDefault("project")
  valid_589310 = validateParameter(valid_589310, JString, required = true,
                                 default = nil)
  if valid_589310 != nil:
    section.add "project", valid_589310
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
  var valid_589311 = query.getOrDefault("fields")
  valid_589311 = validateParameter(valid_589311, JString, required = false,
                                 default = nil)
  if valid_589311 != nil:
    section.add "fields", valid_589311
  var valid_589312 = query.getOrDefault("quotaUser")
  valid_589312 = validateParameter(valid_589312, JString, required = false,
                                 default = nil)
  if valid_589312 != nil:
    section.add "quotaUser", valid_589312
  var valid_589313 = query.getOrDefault("alt")
  valid_589313 = validateParameter(valid_589313, JString, required = false,
                                 default = newJString("json"))
  if valid_589313 != nil:
    section.add "alt", valid_589313
  var valid_589314 = query.getOrDefault("oauth_token")
  valid_589314 = validateParameter(valid_589314, JString, required = false,
                                 default = nil)
  if valid_589314 != nil:
    section.add "oauth_token", valid_589314
  var valid_589315 = query.getOrDefault("userIp")
  valid_589315 = validateParameter(valid_589315, JString, required = false,
                                 default = nil)
  if valid_589315 != nil:
    section.add "userIp", valid_589315
  var valid_589316 = query.getOrDefault("key")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = nil)
  if valid_589316 != nil:
    section.add "key", valid_589316
  var valid_589317 = query.getOrDefault("prettyPrint")
  valid_589317 = validateParameter(valid_589317, JBool, required = false,
                                 default = newJBool(true))
  if valid_589317 != nil:
    section.add "prettyPrint", valid_589317
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589318: Call_ClouduseraccountsUsersDelete_589306; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified User resource.
  ## 
  let valid = call_589318.validator(path, query, header, formData, body)
  let scheme = call_589318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589318.url(scheme.get, call_589318.host, call_589318.base,
                         call_589318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589318, url, valid)

proc call*(call_589319: Call_ClouduseraccountsUsersDelete_589306; user: string;
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
  var path_589320 = newJObject()
  var query_589321 = newJObject()
  add(query_589321, "fields", newJString(fields))
  add(query_589321, "quotaUser", newJString(quotaUser))
  add(query_589321, "alt", newJString(alt))
  add(path_589320, "user", newJString(user))
  add(query_589321, "oauth_token", newJString(oauthToken))
  add(query_589321, "userIp", newJString(userIp))
  add(query_589321, "key", newJString(key))
  add(path_589320, "project", newJString(project))
  add(query_589321, "prettyPrint", newJBool(prettyPrint))
  result = call_589319.call(path_589320, query_589321, nil, nil, nil)

var clouduseraccountsUsersDelete* = Call_ClouduseraccountsUsersDelete_589306(
    name: "clouduseraccountsUsersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/{project}/global/users/{user}",
    validator: validate_ClouduseraccountsUsersDelete_589307,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsUsersDelete_589308, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersAddPublicKey_589322 = ref object of OpenApiRestCall_588457
proc url_ClouduseraccountsUsersAddPublicKey_589324(protocol: Scheme; host: string;
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

proc validate_ClouduseraccountsUsersAddPublicKey_589323(path: JsonNode;
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
  var valid_589325 = path.getOrDefault("user")
  valid_589325 = validateParameter(valid_589325, JString, required = true,
                                 default = nil)
  if valid_589325 != nil:
    section.add "user", valid_589325
  var valid_589326 = path.getOrDefault("project")
  valid_589326 = validateParameter(valid_589326, JString, required = true,
                                 default = nil)
  if valid_589326 != nil:
    section.add "project", valid_589326
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
  var valid_589327 = query.getOrDefault("fields")
  valid_589327 = validateParameter(valid_589327, JString, required = false,
                                 default = nil)
  if valid_589327 != nil:
    section.add "fields", valid_589327
  var valid_589328 = query.getOrDefault("quotaUser")
  valid_589328 = validateParameter(valid_589328, JString, required = false,
                                 default = nil)
  if valid_589328 != nil:
    section.add "quotaUser", valid_589328
  var valid_589329 = query.getOrDefault("alt")
  valid_589329 = validateParameter(valid_589329, JString, required = false,
                                 default = newJString("json"))
  if valid_589329 != nil:
    section.add "alt", valid_589329
  var valid_589330 = query.getOrDefault("oauth_token")
  valid_589330 = validateParameter(valid_589330, JString, required = false,
                                 default = nil)
  if valid_589330 != nil:
    section.add "oauth_token", valid_589330
  var valid_589331 = query.getOrDefault("userIp")
  valid_589331 = validateParameter(valid_589331, JString, required = false,
                                 default = nil)
  if valid_589331 != nil:
    section.add "userIp", valid_589331
  var valid_589332 = query.getOrDefault("key")
  valid_589332 = validateParameter(valid_589332, JString, required = false,
                                 default = nil)
  if valid_589332 != nil:
    section.add "key", valid_589332
  var valid_589333 = query.getOrDefault("prettyPrint")
  valid_589333 = validateParameter(valid_589333, JBool, required = false,
                                 default = newJBool(true))
  if valid_589333 != nil:
    section.add "prettyPrint", valid_589333
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

proc call*(call_589335: Call_ClouduseraccountsUsersAddPublicKey_589322;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a public key to the specified User resource with the data included in the request.
  ## 
  let valid = call_589335.validator(path, query, header, formData, body)
  let scheme = call_589335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589335.url(scheme.get, call_589335.host, call_589335.base,
                         call_589335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589335, url, valid)

proc call*(call_589336: Call_ClouduseraccountsUsersAddPublicKey_589322;
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
  var path_589337 = newJObject()
  var query_589338 = newJObject()
  var body_589339 = newJObject()
  add(query_589338, "fields", newJString(fields))
  add(query_589338, "quotaUser", newJString(quotaUser))
  add(query_589338, "alt", newJString(alt))
  add(path_589337, "user", newJString(user))
  add(query_589338, "oauth_token", newJString(oauthToken))
  add(query_589338, "userIp", newJString(userIp))
  add(query_589338, "key", newJString(key))
  add(path_589337, "project", newJString(project))
  if body != nil:
    body_589339 = body
  add(query_589338, "prettyPrint", newJBool(prettyPrint))
  result = call_589336.call(path_589337, query_589338, nil, nil, body_589339)

var clouduseraccountsUsersAddPublicKey* = Call_ClouduseraccountsUsersAddPublicKey_589322(
    name: "clouduseraccountsUsersAddPublicKey", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/users/{user}/addPublicKey",
    validator: validate_ClouduseraccountsUsersAddPublicKey_589323,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsUsersAddPublicKey_589324, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsUsersRemovePublicKey_589340 = ref object of OpenApiRestCall_588457
proc url_ClouduseraccountsUsersRemovePublicKey_589342(protocol: Scheme;
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

proc validate_ClouduseraccountsUsersRemovePublicKey_589341(path: JsonNode;
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
  var valid_589343 = path.getOrDefault("user")
  valid_589343 = validateParameter(valid_589343, JString, required = true,
                                 default = nil)
  if valid_589343 != nil:
    section.add "user", valid_589343
  var valid_589344 = path.getOrDefault("project")
  valid_589344 = validateParameter(valid_589344, JString, required = true,
                                 default = nil)
  if valid_589344 != nil:
    section.add "project", valid_589344
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
  var valid_589345 = query.getOrDefault("fields")
  valid_589345 = validateParameter(valid_589345, JString, required = false,
                                 default = nil)
  if valid_589345 != nil:
    section.add "fields", valid_589345
  assert query != nil,
        "query argument is necessary due to required `fingerprint` field"
  var valid_589346 = query.getOrDefault("fingerprint")
  valid_589346 = validateParameter(valid_589346, JString, required = true,
                                 default = nil)
  if valid_589346 != nil:
    section.add "fingerprint", valid_589346
  var valid_589347 = query.getOrDefault("quotaUser")
  valid_589347 = validateParameter(valid_589347, JString, required = false,
                                 default = nil)
  if valid_589347 != nil:
    section.add "quotaUser", valid_589347
  var valid_589348 = query.getOrDefault("alt")
  valid_589348 = validateParameter(valid_589348, JString, required = false,
                                 default = newJString("json"))
  if valid_589348 != nil:
    section.add "alt", valid_589348
  var valid_589349 = query.getOrDefault("oauth_token")
  valid_589349 = validateParameter(valid_589349, JString, required = false,
                                 default = nil)
  if valid_589349 != nil:
    section.add "oauth_token", valid_589349
  var valid_589350 = query.getOrDefault("userIp")
  valid_589350 = validateParameter(valid_589350, JString, required = false,
                                 default = nil)
  if valid_589350 != nil:
    section.add "userIp", valid_589350
  var valid_589351 = query.getOrDefault("key")
  valid_589351 = validateParameter(valid_589351, JString, required = false,
                                 default = nil)
  if valid_589351 != nil:
    section.add "key", valid_589351
  var valid_589352 = query.getOrDefault("prettyPrint")
  valid_589352 = validateParameter(valid_589352, JBool, required = false,
                                 default = newJBool(true))
  if valid_589352 != nil:
    section.add "prettyPrint", valid_589352
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589353: Call_ClouduseraccountsUsersRemovePublicKey_589340;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes the specified public key from the user.
  ## 
  let valid = call_589353.validator(path, query, header, formData, body)
  let scheme = call_589353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589353.url(scheme.get, call_589353.host, call_589353.base,
                         call_589353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589353, url, valid)

proc call*(call_589354: Call_ClouduseraccountsUsersRemovePublicKey_589340;
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
  var path_589355 = newJObject()
  var query_589356 = newJObject()
  add(query_589356, "fields", newJString(fields))
  add(query_589356, "fingerprint", newJString(fingerprint))
  add(query_589356, "quotaUser", newJString(quotaUser))
  add(query_589356, "alt", newJString(alt))
  add(path_589355, "user", newJString(user))
  add(query_589356, "oauth_token", newJString(oauthToken))
  add(query_589356, "userIp", newJString(userIp))
  add(query_589356, "key", newJString(key))
  add(path_589355, "project", newJString(project))
  add(query_589356, "prettyPrint", newJBool(prettyPrint))
  result = call_589354.call(path_589355, query_589356, nil, nil, nil)

var clouduseraccountsUsersRemovePublicKey* = Call_ClouduseraccountsUsersRemovePublicKey_589340(
    name: "clouduseraccountsUsersRemovePublicKey", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/users/{user}/removePublicKey",
    validator: validate_ClouduseraccountsUsersRemovePublicKey_589341,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsUsersRemovePublicKey_589342, schemes: {Scheme.Https})
type
  Call_ClouduseraccountsLinuxGetAuthorizedKeysView_589357 = ref object of OpenApiRestCall_588457
proc url_ClouduseraccountsLinuxGetAuthorizedKeysView_589359(protocol: Scheme;
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

proc validate_ClouduseraccountsLinuxGetAuthorizedKeysView_589358(path: JsonNode;
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
  var valid_589360 = path.getOrDefault("zone")
  valid_589360 = validateParameter(valid_589360, JString, required = true,
                                 default = nil)
  if valid_589360 != nil:
    section.add "zone", valid_589360
  var valid_589361 = path.getOrDefault("user")
  valid_589361 = validateParameter(valid_589361, JString, required = true,
                                 default = nil)
  if valid_589361 != nil:
    section.add "user", valid_589361
  var valid_589362 = path.getOrDefault("project")
  valid_589362 = validateParameter(valid_589362, JString, required = true,
                                 default = nil)
  if valid_589362 != nil:
    section.add "project", valid_589362
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
  var valid_589363 = query.getOrDefault("fields")
  valid_589363 = validateParameter(valid_589363, JString, required = false,
                                 default = nil)
  if valid_589363 != nil:
    section.add "fields", valid_589363
  var valid_589364 = query.getOrDefault("quotaUser")
  valid_589364 = validateParameter(valid_589364, JString, required = false,
                                 default = nil)
  if valid_589364 != nil:
    section.add "quotaUser", valid_589364
  var valid_589365 = query.getOrDefault("alt")
  valid_589365 = validateParameter(valid_589365, JString, required = false,
                                 default = newJString("json"))
  if valid_589365 != nil:
    section.add "alt", valid_589365
  var valid_589366 = query.getOrDefault("login")
  valid_589366 = validateParameter(valid_589366, JBool, required = false, default = nil)
  if valid_589366 != nil:
    section.add "login", valid_589366
  var valid_589367 = query.getOrDefault("oauth_token")
  valid_589367 = validateParameter(valid_589367, JString, required = false,
                                 default = nil)
  if valid_589367 != nil:
    section.add "oauth_token", valid_589367
  var valid_589368 = query.getOrDefault("userIp")
  valid_589368 = validateParameter(valid_589368, JString, required = false,
                                 default = nil)
  if valid_589368 != nil:
    section.add "userIp", valid_589368
  var valid_589369 = query.getOrDefault("key")
  valid_589369 = validateParameter(valid_589369, JString, required = false,
                                 default = nil)
  if valid_589369 != nil:
    section.add "key", valid_589369
  assert query != nil,
        "query argument is necessary due to required `instance` field"
  var valid_589370 = query.getOrDefault("instance")
  valid_589370 = validateParameter(valid_589370, JString, required = true,
                                 default = nil)
  if valid_589370 != nil:
    section.add "instance", valid_589370
  var valid_589371 = query.getOrDefault("prettyPrint")
  valid_589371 = validateParameter(valid_589371, JBool, required = false,
                                 default = newJBool(true))
  if valid_589371 != nil:
    section.add "prettyPrint", valid_589371
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589372: Call_ClouduseraccountsLinuxGetAuthorizedKeysView_589357;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of authorized public keys for a specific user account.
  ## 
  let valid = call_589372.validator(path, query, header, formData, body)
  let scheme = call_589372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589372.url(scheme.get, call_589372.host, call_589372.base,
                         call_589372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589372, url, valid)

proc call*(call_589373: Call_ClouduseraccountsLinuxGetAuthorizedKeysView_589357;
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
  var path_589374 = newJObject()
  var query_589375 = newJObject()
  add(path_589374, "zone", newJString(zone))
  add(query_589375, "fields", newJString(fields))
  add(query_589375, "quotaUser", newJString(quotaUser))
  add(query_589375, "alt", newJString(alt))
  add(path_589374, "user", newJString(user))
  add(query_589375, "login", newJBool(login))
  add(query_589375, "oauth_token", newJString(oauthToken))
  add(query_589375, "userIp", newJString(userIp))
  add(query_589375, "key", newJString(key))
  add(query_589375, "instance", newJString(instance))
  add(path_589374, "project", newJString(project))
  add(query_589375, "prettyPrint", newJBool(prettyPrint))
  result = call_589373.call(path_589374, query_589375, nil, nil, nil)

var clouduseraccountsLinuxGetAuthorizedKeysView* = Call_ClouduseraccountsLinuxGetAuthorizedKeysView_589357(
    name: "clouduseraccountsLinuxGetAuthorizedKeysView",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/authorizedKeysView/{user}",
    validator: validate_ClouduseraccountsLinuxGetAuthorizedKeysView_589358,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsLinuxGetAuthorizedKeysView_589359,
    schemes: {Scheme.Https})
type
  Call_ClouduseraccountsLinuxGetLinuxAccountViews_589376 = ref object of OpenApiRestCall_588457
proc url_ClouduseraccountsLinuxGetLinuxAccountViews_589378(protocol: Scheme;
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

proc validate_ClouduseraccountsLinuxGetLinuxAccountViews_589377(path: JsonNode;
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
  var valid_589379 = path.getOrDefault("zone")
  valid_589379 = validateParameter(valid_589379, JString, required = true,
                                 default = nil)
  if valid_589379 != nil:
    section.add "zone", valid_589379
  var valid_589380 = path.getOrDefault("project")
  valid_589380 = validateParameter(valid_589380, JString, required = true,
                                 default = nil)
  if valid_589380 != nil:
    section.add "project", valid_589380
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
  var valid_589381 = query.getOrDefault("fields")
  valid_589381 = validateParameter(valid_589381, JString, required = false,
                                 default = nil)
  if valid_589381 != nil:
    section.add "fields", valid_589381
  var valid_589382 = query.getOrDefault("pageToken")
  valid_589382 = validateParameter(valid_589382, JString, required = false,
                                 default = nil)
  if valid_589382 != nil:
    section.add "pageToken", valid_589382
  var valid_589383 = query.getOrDefault("quotaUser")
  valid_589383 = validateParameter(valid_589383, JString, required = false,
                                 default = nil)
  if valid_589383 != nil:
    section.add "quotaUser", valid_589383
  var valid_589384 = query.getOrDefault("alt")
  valid_589384 = validateParameter(valid_589384, JString, required = false,
                                 default = newJString("json"))
  if valid_589384 != nil:
    section.add "alt", valid_589384
  var valid_589385 = query.getOrDefault("oauth_token")
  valid_589385 = validateParameter(valid_589385, JString, required = false,
                                 default = nil)
  if valid_589385 != nil:
    section.add "oauth_token", valid_589385
  var valid_589386 = query.getOrDefault("userIp")
  valid_589386 = validateParameter(valid_589386, JString, required = false,
                                 default = nil)
  if valid_589386 != nil:
    section.add "userIp", valid_589386
  var valid_589387 = query.getOrDefault("maxResults")
  valid_589387 = validateParameter(valid_589387, JInt, required = false,
                                 default = newJInt(500))
  if valid_589387 != nil:
    section.add "maxResults", valid_589387
  var valid_589388 = query.getOrDefault("orderBy")
  valid_589388 = validateParameter(valid_589388, JString, required = false,
                                 default = nil)
  if valid_589388 != nil:
    section.add "orderBy", valid_589388
  var valid_589389 = query.getOrDefault("key")
  valid_589389 = validateParameter(valid_589389, JString, required = false,
                                 default = nil)
  if valid_589389 != nil:
    section.add "key", valid_589389
  assert query != nil,
        "query argument is necessary due to required `instance` field"
  var valid_589390 = query.getOrDefault("instance")
  valid_589390 = validateParameter(valid_589390, JString, required = true,
                                 default = nil)
  if valid_589390 != nil:
    section.add "instance", valid_589390
  var valid_589391 = query.getOrDefault("prettyPrint")
  valid_589391 = validateParameter(valid_589391, JBool, required = false,
                                 default = newJBool(true))
  if valid_589391 != nil:
    section.add "prettyPrint", valid_589391
  var valid_589392 = query.getOrDefault("filter")
  valid_589392 = validateParameter(valid_589392, JString, required = false,
                                 default = nil)
  if valid_589392 != nil:
    section.add "filter", valid_589392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589393: Call_ClouduseraccountsLinuxGetLinuxAccountViews_589376;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a list of user accounts for an instance within a specific project.
  ## 
  let valid = call_589393.validator(path, query, header, formData, body)
  let scheme = call_589393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589393.url(scheme.get, call_589393.host, call_589393.base,
                         call_589393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589393, url, valid)

proc call*(call_589394: Call_ClouduseraccountsLinuxGetLinuxAccountViews_589376;
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
  var path_589395 = newJObject()
  var query_589396 = newJObject()
  add(path_589395, "zone", newJString(zone))
  add(query_589396, "fields", newJString(fields))
  add(query_589396, "pageToken", newJString(pageToken))
  add(query_589396, "quotaUser", newJString(quotaUser))
  add(query_589396, "alt", newJString(alt))
  add(query_589396, "oauth_token", newJString(oauthToken))
  add(query_589396, "userIp", newJString(userIp))
  add(query_589396, "maxResults", newJInt(maxResults))
  add(query_589396, "orderBy", newJString(orderBy))
  add(query_589396, "key", newJString(key))
  add(query_589396, "instance", newJString(instance))
  add(path_589395, "project", newJString(project))
  add(query_589396, "prettyPrint", newJBool(prettyPrint))
  add(query_589396, "filter", newJString(filter))
  result = call_589394.call(path_589395, query_589396, nil, nil, nil)

var clouduseraccountsLinuxGetLinuxAccountViews* = Call_ClouduseraccountsLinuxGetLinuxAccountViews_589376(
    name: "clouduseraccountsLinuxGetLinuxAccountViews", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/linuxAccountViews",
    validator: validate_ClouduseraccountsLinuxGetLinuxAccountViews_589377,
    base: "/clouduseraccounts/alpha/projects",
    url: url_ClouduseraccountsLinuxGetLinuxAccountViews_589378,
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
