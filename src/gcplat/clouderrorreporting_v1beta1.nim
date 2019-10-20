
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Stackdriver Error Reporting
## version: v1beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Groups and counts similar errors from cloud services and applications, reports new errors, and provides access to error groups and their associated errors.
## 
## 
## https://cloud.google.com/error-reporting/
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

  OpenApiRestCall_578339 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578339](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578339): Option[Scheme] {.used.} =
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
  gcpServiceName = "clouderrorreporting"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ClouderrorreportingProjectsGroupsGet_578610 = ref object of OpenApiRestCall_578339
proc url_ClouderrorreportingProjectsGroupsGet_578612(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupName" in path, "`groupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "groupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClouderrorreportingProjectsGroupsGet_578611(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the specified group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupName: JString (required)
  ##            : [Required] The group resource name. Written as
  ## <code>projects/<var>projectID</var>/groups/<var>group_name</var></code>.
  ## Call
  ## <a href="/error-reporting/reference/rest/v1beta1/projects.groupStats/list">
  ## <code>groupStats.list</code></a> to return a list of groups belonging to
  ## this project.
  ## 
  ## Example: <code>projects/my-project-123/groups/my-group</code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupName` field"
  var valid_578738 = path.getOrDefault("groupName")
  valid_578738 = validateParameter(valid_578738, JString, required = true,
                                 default = nil)
  if valid_578738 != nil:
    section.add "groupName", valid_578738
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578739 = query.getOrDefault("key")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "key", valid_578739
  var valid_578753 = query.getOrDefault("prettyPrint")
  valid_578753 = validateParameter(valid_578753, JBool, required = false,
                                 default = newJBool(true))
  if valid_578753 != nil:
    section.add "prettyPrint", valid_578753
  var valid_578754 = query.getOrDefault("oauth_token")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "oauth_token", valid_578754
  var valid_578755 = query.getOrDefault("$.xgafv")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = newJString("1"))
  if valid_578755 != nil:
    section.add "$.xgafv", valid_578755
  var valid_578756 = query.getOrDefault("alt")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = newJString("json"))
  if valid_578756 != nil:
    section.add "alt", valid_578756
  var valid_578757 = query.getOrDefault("uploadType")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "uploadType", valid_578757
  var valid_578758 = query.getOrDefault("quotaUser")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "quotaUser", valid_578758
  var valid_578759 = query.getOrDefault("callback")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "callback", valid_578759
  var valid_578760 = query.getOrDefault("fields")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = nil)
  if valid_578760 != nil:
    section.add "fields", valid_578760
  var valid_578761 = query.getOrDefault("access_token")
  valid_578761 = validateParameter(valid_578761, JString, required = false,
                                 default = nil)
  if valid_578761 != nil:
    section.add "access_token", valid_578761
  var valid_578762 = query.getOrDefault("upload_protocol")
  valid_578762 = validateParameter(valid_578762, JString, required = false,
                                 default = nil)
  if valid_578762 != nil:
    section.add "upload_protocol", valid_578762
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578785: Call_ClouderrorreportingProjectsGroupsGet_578610;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the specified group.
  ## 
  let valid = call_578785.validator(path, query, header, formData, body)
  let scheme = call_578785.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578785.url(scheme.get, call_578785.host, call_578785.base,
                         call_578785.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578785, url, valid)

proc call*(call_578856: Call_ClouderrorreportingProjectsGroupsGet_578610;
          groupName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## clouderrorreportingProjectsGroupsGet
  ## Get the specified group.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   groupName: string (required)
  ##            : [Required] The group resource name. Written as
  ## <code>projects/<var>projectID</var>/groups/<var>group_name</var></code>.
  ## Call
  ## <a href="/error-reporting/reference/rest/v1beta1/projects.groupStats/list">
  ## <code>groupStats.list</code></a> to return a list of groups belonging to
  ## this project.
  ## 
  ## Example: <code>projects/my-project-123/groups/my-group</code>
  var path_578857 = newJObject()
  var query_578859 = newJObject()
  add(query_578859, "key", newJString(key))
  add(query_578859, "prettyPrint", newJBool(prettyPrint))
  add(query_578859, "oauth_token", newJString(oauthToken))
  add(query_578859, "$.xgafv", newJString(Xgafv))
  add(query_578859, "alt", newJString(alt))
  add(query_578859, "uploadType", newJString(uploadType))
  add(query_578859, "quotaUser", newJString(quotaUser))
  add(query_578859, "callback", newJString(callback))
  add(query_578859, "fields", newJString(fields))
  add(query_578859, "access_token", newJString(accessToken))
  add(query_578859, "upload_protocol", newJString(uploadProtocol))
  add(path_578857, "groupName", newJString(groupName))
  result = call_578856.call(path_578857, query_578859, nil, nil, nil)

var clouderrorreportingProjectsGroupsGet* = Call_ClouderrorreportingProjectsGroupsGet_578610(
    name: "clouderrorreportingProjectsGroupsGet", meth: HttpMethod.HttpGet,
    host: "clouderrorreporting.googleapis.com", route: "/v1beta1/{groupName}",
    validator: validate_ClouderrorreportingProjectsGroupsGet_578611, base: "/",
    url: url_ClouderrorreportingProjectsGroupsGet_578612, schemes: {Scheme.Https})
type
  Call_ClouderrorreportingProjectsGroupsUpdate_578898 = ref object of OpenApiRestCall_578339
proc url_ClouderrorreportingProjectsGroupsUpdate_578900(protocol: Scheme;
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

proc validate_ClouderrorreportingProjectsGroupsUpdate_578899(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Replace the data for the specified group.
  ## Fails if the group does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The group resource name.
  ## Example: <code>projects/my-project-123/groups/my-groupid</code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578901 = path.getOrDefault("name")
  valid_578901 = validateParameter(valid_578901, JString, required = true,
                                 default = nil)
  if valid_578901 != nil:
    section.add "name", valid_578901
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578902 = query.getOrDefault("key")
  valid_578902 = validateParameter(valid_578902, JString, required = false,
                                 default = nil)
  if valid_578902 != nil:
    section.add "key", valid_578902
  var valid_578903 = query.getOrDefault("prettyPrint")
  valid_578903 = validateParameter(valid_578903, JBool, required = false,
                                 default = newJBool(true))
  if valid_578903 != nil:
    section.add "prettyPrint", valid_578903
  var valid_578904 = query.getOrDefault("oauth_token")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "oauth_token", valid_578904
  var valid_578905 = query.getOrDefault("$.xgafv")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = newJString("1"))
  if valid_578905 != nil:
    section.add "$.xgafv", valid_578905
  var valid_578906 = query.getOrDefault("alt")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = newJString("json"))
  if valid_578906 != nil:
    section.add "alt", valid_578906
  var valid_578907 = query.getOrDefault("uploadType")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "uploadType", valid_578907
  var valid_578908 = query.getOrDefault("quotaUser")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "quotaUser", valid_578908
  var valid_578909 = query.getOrDefault("callback")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "callback", valid_578909
  var valid_578910 = query.getOrDefault("fields")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "fields", valid_578910
  var valid_578911 = query.getOrDefault("access_token")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "access_token", valid_578911
  var valid_578912 = query.getOrDefault("upload_protocol")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "upload_protocol", valid_578912
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

proc call*(call_578914: Call_ClouderrorreportingProjectsGroupsUpdate_578898;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Replace the data for the specified group.
  ## Fails if the group does not exist.
  ## 
  let valid = call_578914.validator(path, query, header, formData, body)
  let scheme = call_578914.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578914.url(scheme.get, call_578914.host, call_578914.base,
                         call_578914.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578914, url, valid)

proc call*(call_578915: Call_ClouderrorreportingProjectsGroupsUpdate_578898;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## clouderrorreportingProjectsGroupsUpdate
  ## Replace the data for the specified group.
  ## Fails if the group does not exist.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The group resource name.
  ## Example: <code>projects/my-project-123/groups/my-groupid</code>
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578916 = newJObject()
  var query_578917 = newJObject()
  var body_578918 = newJObject()
  add(query_578917, "key", newJString(key))
  add(query_578917, "prettyPrint", newJBool(prettyPrint))
  add(query_578917, "oauth_token", newJString(oauthToken))
  add(query_578917, "$.xgafv", newJString(Xgafv))
  add(query_578917, "alt", newJString(alt))
  add(query_578917, "uploadType", newJString(uploadType))
  add(query_578917, "quotaUser", newJString(quotaUser))
  add(path_578916, "name", newJString(name))
  if body != nil:
    body_578918 = body
  add(query_578917, "callback", newJString(callback))
  add(query_578917, "fields", newJString(fields))
  add(query_578917, "access_token", newJString(accessToken))
  add(query_578917, "upload_protocol", newJString(uploadProtocol))
  result = call_578915.call(path_578916, query_578917, nil, nil, body_578918)

var clouderrorreportingProjectsGroupsUpdate* = Call_ClouderrorreportingProjectsGroupsUpdate_578898(
    name: "clouderrorreportingProjectsGroupsUpdate", meth: HttpMethod.HttpPut,
    host: "clouderrorreporting.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_ClouderrorreportingProjectsGroupsUpdate_578899, base: "/",
    url: url_ClouderrorreportingProjectsGroupsUpdate_578900,
    schemes: {Scheme.Https})
type
  Call_ClouderrorreportingProjectsEventsList_578919 = ref object of OpenApiRestCall_578339
proc url_ClouderrorreportingProjectsEventsList_578921(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/events")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClouderrorreportingProjectsEventsList_578920(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the specified events.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectName: JString (required)
  ##              : [Required] The resource name of the Google Cloud Platform project. Written
  ## as `projects/` plus the
  ## [Google Cloud Platform project
  ## ID](https://support.google.com/cloud/answer/6158840).
  ## Example: `projects/my-project-123`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `projectName` field"
  var valid_578922 = path.getOrDefault("projectName")
  valid_578922 = validateParameter(valid_578922, JString, required = true,
                                 default = nil)
  if valid_578922 != nil:
    section.add "projectName", valid_578922
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   serviceFilter.version: JString
  ##                        : [Optional] The exact value to match against
  ## 
  ## [`ServiceContext.version`](/error-reporting/reference/rest/v1beta1/ServiceContext#FIELDS.version).
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : [Optional] The maximum number of results to return per response.
  ##   timeRange.period: JString
  ##                   : Restricts the query to the specified time range.
  ##   serviceFilter.resourceType: JString
  ##                             : [Optional] The exact value to match against
  ## 
  ## [`ServiceContext.resource_type`](/error-reporting/reference/rest/v1beta1/ServiceContext#FIELDS.resource_type).
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : [Optional] A `next_page_token` provided by a previous response.
  ##   groupId: JString
  ##          : [Required] The group for which events shall be returned.
  ##   serviceFilter.service: JString
  ##                        : [Optional] The exact value to match against
  ## 
  ## [`ServiceContext.service`](/error-reporting/reference/rest/v1beta1/ServiceContext#FIELDS.service).
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578923 = query.getOrDefault("key")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "key", valid_578923
  var valid_578924 = query.getOrDefault("prettyPrint")
  valid_578924 = validateParameter(valid_578924, JBool, required = false,
                                 default = newJBool(true))
  if valid_578924 != nil:
    section.add "prettyPrint", valid_578924
  var valid_578925 = query.getOrDefault("oauth_token")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "oauth_token", valid_578925
  var valid_578926 = query.getOrDefault("serviceFilter.version")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = nil)
  if valid_578926 != nil:
    section.add "serviceFilter.version", valid_578926
  var valid_578927 = query.getOrDefault("$.xgafv")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = newJString("1"))
  if valid_578927 != nil:
    section.add "$.xgafv", valid_578927
  var valid_578928 = query.getOrDefault("pageSize")
  valid_578928 = validateParameter(valid_578928, JInt, required = false, default = nil)
  if valid_578928 != nil:
    section.add "pageSize", valid_578928
  var valid_578929 = query.getOrDefault("timeRange.period")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = newJString("PERIOD_UNSPECIFIED"))
  if valid_578929 != nil:
    section.add "timeRange.period", valid_578929
  var valid_578930 = query.getOrDefault("serviceFilter.resourceType")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "serviceFilter.resourceType", valid_578930
  var valid_578931 = query.getOrDefault("alt")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = newJString("json"))
  if valid_578931 != nil:
    section.add "alt", valid_578931
  var valid_578932 = query.getOrDefault("uploadType")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "uploadType", valid_578932
  var valid_578933 = query.getOrDefault("quotaUser")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "quotaUser", valid_578933
  var valid_578934 = query.getOrDefault("pageToken")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "pageToken", valid_578934
  var valid_578935 = query.getOrDefault("groupId")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "groupId", valid_578935
  var valid_578936 = query.getOrDefault("serviceFilter.service")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "serviceFilter.service", valid_578936
  var valid_578937 = query.getOrDefault("callback")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "callback", valid_578937
  var valid_578938 = query.getOrDefault("fields")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "fields", valid_578938
  var valid_578939 = query.getOrDefault("access_token")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "access_token", valid_578939
  var valid_578940 = query.getOrDefault("upload_protocol")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "upload_protocol", valid_578940
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578941: Call_ClouderrorreportingProjectsEventsList_578919;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the specified events.
  ## 
  let valid = call_578941.validator(path, query, header, formData, body)
  let scheme = call_578941.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578941.url(scheme.get, call_578941.host, call_578941.base,
                         call_578941.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578941, url, valid)

proc call*(call_578942: Call_ClouderrorreportingProjectsEventsList_578919;
          projectName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; serviceFilterVersion: string = "";
          Xgafv: string = "1"; pageSize: int = 0;
          timeRangePeriod: string = "PERIOD_UNSPECIFIED";
          serviceFilterResourceType: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          groupId: string = ""; serviceFilterService: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## clouderrorreportingProjectsEventsList
  ## Lists the specified events.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   serviceFilterVersion: string
  ##                       : [Optional] The exact value to match against
  ## 
  ## [`ServiceContext.version`](/error-reporting/reference/rest/v1beta1/ServiceContext#FIELDS.version).
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : [Optional] The maximum number of results to return per response.
  ##   timeRangePeriod: string
  ##                  : Restricts the query to the specified time range.
  ##   serviceFilterResourceType: string
  ##                            : [Optional] The exact value to match against
  ## 
  ## [`ServiceContext.resource_type`](/error-reporting/reference/rest/v1beta1/ServiceContext#FIELDS.resource_type).
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : [Optional] A `next_page_token` provided by a previous response.
  ##   groupId: string
  ##          : [Required] The group for which events shall be returned.
  ##   projectName: string (required)
  ##              : [Required] The resource name of the Google Cloud Platform project. Written
  ## as `projects/` plus the
  ## [Google Cloud Platform project
  ## ID](https://support.google.com/cloud/answer/6158840).
  ## Example: `projects/my-project-123`.
  ##   serviceFilterService: string
  ##                       : [Optional] The exact value to match against
  ## 
  ## [`ServiceContext.service`](/error-reporting/reference/rest/v1beta1/ServiceContext#FIELDS.service).
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578943 = newJObject()
  var query_578944 = newJObject()
  add(query_578944, "key", newJString(key))
  add(query_578944, "prettyPrint", newJBool(prettyPrint))
  add(query_578944, "oauth_token", newJString(oauthToken))
  add(query_578944, "serviceFilter.version", newJString(serviceFilterVersion))
  add(query_578944, "$.xgafv", newJString(Xgafv))
  add(query_578944, "pageSize", newJInt(pageSize))
  add(query_578944, "timeRange.period", newJString(timeRangePeriod))
  add(query_578944, "serviceFilter.resourceType",
      newJString(serviceFilterResourceType))
  add(query_578944, "alt", newJString(alt))
  add(query_578944, "uploadType", newJString(uploadType))
  add(query_578944, "quotaUser", newJString(quotaUser))
  add(query_578944, "pageToken", newJString(pageToken))
  add(query_578944, "groupId", newJString(groupId))
  add(path_578943, "projectName", newJString(projectName))
  add(query_578944, "serviceFilter.service", newJString(serviceFilterService))
  add(query_578944, "callback", newJString(callback))
  add(query_578944, "fields", newJString(fields))
  add(query_578944, "access_token", newJString(accessToken))
  add(query_578944, "upload_protocol", newJString(uploadProtocol))
  result = call_578942.call(path_578943, query_578944, nil, nil, nil)

var clouderrorreportingProjectsEventsList* = Call_ClouderrorreportingProjectsEventsList_578919(
    name: "clouderrorreportingProjectsEventsList", meth: HttpMethod.HttpGet,
    host: "clouderrorreporting.googleapis.com",
    route: "/v1beta1/{projectName}/events",
    validator: validate_ClouderrorreportingProjectsEventsList_578920, base: "/",
    url: url_ClouderrorreportingProjectsEventsList_578921, schemes: {Scheme.Https})
type
  Call_ClouderrorreportingProjectsDeleteEvents_578945 = ref object of OpenApiRestCall_578339
proc url_ClouderrorreportingProjectsDeleteEvents_578947(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/events")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClouderrorreportingProjectsDeleteEvents_578946(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes all error events of a given project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectName: JString (required)
  ##              : [Required] The resource name of the Google Cloud Platform project. Written
  ## as `projects/` plus the
  ## [Google Cloud Platform project
  ## ID](https://support.google.com/cloud/answer/6158840).
  ## Example: `projects/my-project-123`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `projectName` field"
  var valid_578948 = path.getOrDefault("projectName")
  valid_578948 = validateParameter(valid_578948, JString, required = true,
                                 default = nil)
  if valid_578948 != nil:
    section.add "projectName", valid_578948
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578949 = query.getOrDefault("key")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "key", valid_578949
  var valid_578950 = query.getOrDefault("prettyPrint")
  valid_578950 = validateParameter(valid_578950, JBool, required = false,
                                 default = newJBool(true))
  if valid_578950 != nil:
    section.add "prettyPrint", valid_578950
  var valid_578951 = query.getOrDefault("oauth_token")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "oauth_token", valid_578951
  var valid_578952 = query.getOrDefault("$.xgafv")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = newJString("1"))
  if valid_578952 != nil:
    section.add "$.xgafv", valid_578952
  var valid_578953 = query.getOrDefault("alt")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = newJString("json"))
  if valid_578953 != nil:
    section.add "alt", valid_578953
  var valid_578954 = query.getOrDefault("uploadType")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "uploadType", valid_578954
  var valid_578955 = query.getOrDefault("quotaUser")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "quotaUser", valid_578955
  var valid_578956 = query.getOrDefault("callback")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "callback", valid_578956
  var valid_578957 = query.getOrDefault("fields")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "fields", valid_578957
  var valid_578958 = query.getOrDefault("access_token")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "access_token", valid_578958
  var valid_578959 = query.getOrDefault("upload_protocol")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "upload_protocol", valid_578959
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578960: Call_ClouderrorreportingProjectsDeleteEvents_578945;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all error events of a given project.
  ## 
  let valid = call_578960.validator(path, query, header, formData, body)
  let scheme = call_578960.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578960.url(scheme.get, call_578960.host, call_578960.base,
                         call_578960.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578960, url, valid)

proc call*(call_578961: Call_ClouderrorreportingProjectsDeleteEvents_578945;
          projectName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## clouderrorreportingProjectsDeleteEvents
  ## Deletes all error events of a given project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   projectName: string (required)
  ##              : [Required] The resource name of the Google Cloud Platform project. Written
  ## as `projects/` plus the
  ## [Google Cloud Platform project
  ## ID](https://support.google.com/cloud/answer/6158840).
  ## Example: `projects/my-project-123`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578962 = newJObject()
  var query_578963 = newJObject()
  add(query_578963, "key", newJString(key))
  add(query_578963, "prettyPrint", newJBool(prettyPrint))
  add(query_578963, "oauth_token", newJString(oauthToken))
  add(query_578963, "$.xgafv", newJString(Xgafv))
  add(query_578963, "alt", newJString(alt))
  add(query_578963, "uploadType", newJString(uploadType))
  add(query_578963, "quotaUser", newJString(quotaUser))
  add(path_578962, "projectName", newJString(projectName))
  add(query_578963, "callback", newJString(callback))
  add(query_578963, "fields", newJString(fields))
  add(query_578963, "access_token", newJString(accessToken))
  add(query_578963, "upload_protocol", newJString(uploadProtocol))
  result = call_578961.call(path_578962, query_578963, nil, nil, nil)

var clouderrorreportingProjectsDeleteEvents* = Call_ClouderrorreportingProjectsDeleteEvents_578945(
    name: "clouderrorreportingProjectsDeleteEvents", meth: HttpMethod.HttpDelete,
    host: "clouderrorreporting.googleapis.com",
    route: "/v1beta1/{projectName}/events",
    validator: validate_ClouderrorreportingProjectsDeleteEvents_578946, base: "/",
    url: url_ClouderrorreportingProjectsDeleteEvents_578947,
    schemes: {Scheme.Https})
type
  Call_ClouderrorreportingProjectsEventsReport_578964 = ref object of OpenApiRestCall_578339
proc url_ClouderrorreportingProjectsEventsReport_578966(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/events:report")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClouderrorreportingProjectsEventsReport_578965(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Report an individual error event.
  ## 
  ## This endpoint accepts **either** an OAuth token,
  ## **or** an [API key](https://support.google.com/cloud/answer/6158862)
  ## for authentication. To use an API key, append it to the URL as the value of
  ## a `key` parameter. For example:
  ## 
  ## `POST
  ## https://clouderrorreporting.googleapis.com/v1beta1/projects/example-project/events:report?key=123ABC456`
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectName: JString (required)
  ##              : [Required] The resource name of the Google Cloud Platform project. Written
  ## as `projects/` plus the
  ## [Google Cloud Platform project
  ## ID](https://support.google.com/cloud/answer/6158840). Example:
  ## `projects/my-project-123`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `projectName` field"
  var valid_578967 = path.getOrDefault("projectName")
  valid_578967 = validateParameter(valid_578967, JString, required = true,
                                 default = nil)
  if valid_578967 != nil:
    section.add "projectName", valid_578967
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
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
  var valid_578971 = query.getOrDefault("$.xgafv")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = newJString("1"))
  if valid_578971 != nil:
    section.add "$.xgafv", valid_578971
  var valid_578972 = query.getOrDefault("alt")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = newJString("json"))
  if valid_578972 != nil:
    section.add "alt", valid_578972
  var valid_578973 = query.getOrDefault("uploadType")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "uploadType", valid_578973
  var valid_578974 = query.getOrDefault("quotaUser")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "quotaUser", valid_578974
  var valid_578975 = query.getOrDefault("callback")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "callback", valid_578975
  var valid_578976 = query.getOrDefault("fields")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "fields", valid_578976
  var valid_578977 = query.getOrDefault("access_token")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "access_token", valid_578977
  var valid_578978 = query.getOrDefault("upload_protocol")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "upload_protocol", valid_578978
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

proc call*(call_578980: Call_ClouderrorreportingProjectsEventsReport_578964;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Report an individual error event.
  ## 
  ## This endpoint accepts **either** an OAuth token,
  ## **or** an [API key](https://support.google.com/cloud/answer/6158862)
  ## for authentication. To use an API key, append it to the URL as the value of
  ## a `key` parameter. For example:
  ## 
  ## `POST
  ## https://clouderrorreporting.googleapis.com/v1beta1/projects/example-project/events:report?key=123ABC456`
  ## 
  let valid = call_578980.validator(path, query, header, formData, body)
  let scheme = call_578980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578980.url(scheme.get, call_578980.host, call_578980.base,
                         call_578980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578980, url, valid)

proc call*(call_578981: Call_ClouderrorreportingProjectsEventsReport_578964;
          projectName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## clouderrorreportingProjectsEventsReport
  ## Report an individual error event.
  ## 
  ## This endpoint accepts **either** an OAuth token,
  ## **or** an [API key](https://support.google.com/cloud/answer/6158862)
  ## for authentication. To use an API key, append it to the URL as the value of
  ## a `key` parameter. For example:
  ## 
  ## `POST
  ## https://clouderrorreporting.googleapis.com/v1beta1/projects/example-project/events:report?key=123ABC456`
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   projectName: string (required)
  ##              : [Required] The resource name of the Google Cloud Platform project. Written
  ## as `projects/` plus the
  ## [Google Cloud Platform project
  ## ID](https://support.google.com/cloud/answer/6158840). Example:
  ## `projects/my-project-123`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578982 = newJObject()
  var query_578983 = newJObject()
  var body_578984 = newJObject()
  add(query_578983, "key", newJString(key))
  add(query_578983, "prettyPrint", newJBool(prettyPrint))
  add(query_578983, "oauth_token", newJString(oauthToken))
  add(query_578983, "$.xgafv", newJString(Xgafv))
  add(query_578983, "alt", newJString(alt))
  add(query_578983, "uploadType", newJString(uploadType))
  add(query_578983, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578984 = body
  add(path_578982, "projectName", newJString(projectName))
  add(query_578983, "callback", newJString(callback))
  add(query_578983, "fields", newJString(fields))
  add(query_578983, "access_token", newJString(accessToken))
  add(query_578983, "upload_protocol", newJString(uploadProtocol))
  result = call_578981.call(path_578982, query_578983, nil, nil, body_578984)

var clouderrorreportingProjectsEventsReport* = Call_ClouderrorreportingProjectsEventsReport_578964(
    name: "clouderrorreportingProjectsEventsReport", meth: HttpMethod.HttpPost,
    host: "clouderrorreporting.googleapis.com",
    route: "/v1beta1/{projectName}/events:report",
    validator: validate_ClouderrorreportingProjectsEventsReport_578965, base: "/",
    url: url_ClouderrorreportingProjectsEventsReport_578966,
    schemes: {Scheme.Https})
type
  Call_ClouderrorreportingProjectsGroupStatsList_578985 = ref object of OpenApiRestCall_578339
proc url_ClouderrorreportingProjectsGroupStatsList_578987(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/groupStats")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClouderrorreportingProjectsGroupStatsList_578986(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the specified groups.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectName: JString (required)
  ##              : [Required] The resource name of the Google Cloud Platform project. Written
  ## as <code>projects/</code> plus the
  ## <a href="https://support.google.com/cloud/answer/6158840">Google Cloud
  ## Platform project ID</a>.
  ## 
  ## Example: <code>projects/my-project-123</code>.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `projectName` field"
  var valid_578988 = path.getOrDefault("projectName")
  valid_578988 = validateParameter(valid_578988, JString, required = true,
                                 default = nil)
  if valid_578988 != nil:
    section.add "projectName", valid_578988
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   serviceFilter.version: JString
  ##                        : [Optional] The exact value to match against
  ## 
  ## [`ServiceContext.version`](/error-reporting/reference/rest/v1beta1/ServiceContext#FIELDS.version).
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   order: JString
  ##        : [Optional] The sort order in which the results are returned.
  ## Default is `COUNT_DESC`.
  ##   alignment: JString
  ##            : [Optional] The alignment of the timed counts to be returned.
  ## Default is `ALIGNMENT_EQUAL_AT_END`.
  ##   pageSize: JInt
  ##           : [Optional] The maximum number of results to return per response.
  ## Default is 20.
  ##   timeRange.period: JString
  ##                   : Restricts the query to the specified time range.
  ##   alignmentTime: JString
  ##                : [Optional] Time where the timed counts shall be aligned if rounded
  ## alignment is chosen. Default is 00:00 UTC.
  ##   serviceFilter.resourceType: JString
  ##                             : [Optional] The exact value to match against
  ## 
  ## [`ServiceContext.resource_type`](/error-reporting/reference/rest/v1beta1/ServiceContext#FIELDS.resource_type).
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   timedCountDuration: JString
  ##                     : [Optional] The preferred duration for a single returned `TimedCount`.
  ## If not set, no timed counts are returned.
  ##   pageToken: JString
  ##            : [Optional] A `next_page_token` provided by a previous response. To view
  ## additional results, pass this token along with the identical query
  ## parameters as the first request.
  ##   groupId: JArray
  ##          : [Optional] List all <code>ErrorGroupStats</code> with these IDs.
  ##   serviceFilter.service: JString
  ##                        : [Optional] The exact value to match against
  ## 
  ## [`ServiceContext.service`](/error-reporting/reference/rest/v1beta1/ServiceContext#FIELDS.service).
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578989 = query.getOrDefault("key")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "key", valid_578989
  var valid_578990 = query.getOrDefault("prettyPrint")
  valid_578990 = validateParameter(valid_578990, JBool, required = false,
                                 default = newJBool(true))
  if valid_578990 != nil:
    section.add "prettyPrint", valid_578990
  var valid_578991 = query.getOrDefault("oauth_token")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "oauth_token", valid_578991
  var valid_578992 = query.getOrDefault("serviceFilter.version")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "serviceFilter.version", valid_578992
  var valid_578993 = query.getOrDefault("$.xgafv")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = newJString("1"))
  if valid_578993 != nil:
    section.add "$.xgafv", valid_578993
  var valid_578994 = query.getOrDefault("order")
  valid_578994 = validateParameter(valid_578994, JString, required = false, default = newJString(
      "GROUP_ORDER_UNSPECIFIED"))
  if valid_578994 != nil:
    section.add "order", valid_578994
  var valid_578995 = query.getOrDefault("alignment")
  valid_578995 = validateParameter(valid_578995, JString, required = false, default = newJString(
      "ERROR_COUNT_ALIGNMENT_UNSPECIFIED"))
  if valid_578995 != nil:
    section.add "alignment", valid_578995
  var valid_578996 = query.getOrDefault("pageSize")
  valid_578996 = validateParameter(valid_578996, JInt, required = false, default = nil)
  if valid_578996 != nil:
    section.add "pageSize", valid_578996
  var valid_578997 = query.getOrDefault("timeRange.period")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = newJString("PERIOD_UNSPECIFIED"))
  if valid_578997 != nil:
    section.add "timeRange.period", valid_578997
  var valid_578998 = query.getOrDefault("alignmentTime")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "alignmentTime", valid_578998
  var valid_578999 = query.getOrDefault("serviceFilter.resourceType")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "serviceFilter.resourceType", valid_578999
  var valid_579000 = query.getOrDefault("alt")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = newJString("json"))
  if valid_579000 != nil:
    section.add "alt", valid_579000
  var valid_579001 = query.getOrDefault("uploadType")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "uploadType", valid_579001
  var valid_579002 = query.getOrDefault("quotaUser")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "quotaUser", valid_579002
  var valid_579003 = query.getOrDefault("timedCountDuration")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "timedCountDuration", valid_579003
  var valid_579004 = query.getOrDefault("pageToken")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "pageToken", valid_579004
  var valid_579005 = query.getOrDefault("groupId")
  valid_579005 = validateParameter(valid_579005, JArray, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "groupId", valid_579005
  var valid_579006 = query.getOrDefault("serviceFilter.service")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "serviceFilter.service", valid_579006
  var valid_579007 = query.getOrDefault("callback")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "callback", valid_579007
  var valid_579008 = query.getOrDefault("fields")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "fields", valid_579008
  var valid_579009 = query.getOrDefault("access_token")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "access_token", valid_579009
  var valid_579010 = query.getOrDefault("upload_protocol")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "upload_protocol", valid_579010
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579011: Call_ClouderrorreportingProjectsGroupStatsList_578985;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the specified groups.
  ## 
  let valid = call_579011.validator(path, query, header, formData, body)
  let scheme = call_579011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579011.url(scheme.get, call_579011.host, call_579011.base,
                         call_579011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579011, url, valid)

proc call*(call_579012: Call_ClouderrorreportingProjectsGroupStatsList_578985;
          projectName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; serviceFilterVersion: string = "";
          Xgafv: string = "1"; order: string = "GROUP_ORDER_UNSPECIFIED";
          alignment: string = "ERROR_COUNT_ALIGNMENT_UNSPECIFIED";
          pageSize: int = 0; timeRangePeriod: string = "PERIOD_UNSPECIFIED";
          alignmentTime: string = ""; serviceFilterResourceType: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          timedCountDuration: string = ""; pageToken: string = "";
          groupId: JsonNode = nil; serviceFilterService: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## clouderrorreportingProjectsGroupStatsList
  ## Lists the specified groups.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   serviceFilterVersion: string
  ##                       : [Optional] The exact value to match against
  ## 
  ## [`ServiceContext.version`](/error-reporting/reference/rest/v1beta1/ServiceContext#FIELDS.version).
  ##   Xgafv: string
  ##        : V1 error format.
  ##   order: string
  ##        : [Optional] The sort order in which the results are returned.
  ## Default is `COUNT_DESC`.
  ##   alignment: string
  ##            : [Optional] The alignment of the timed counts to be returned.
  ## Default is `ALIGNMENT_EQUAL_AT_END`.
  ##   pageSize: int
  ##           : [Optional] The maximum number of results to return per response.
  ## Default is 20.
  ##   timeRangePeriod: string
  ##                  : Restricts the query to the specified time range.
  ##   alignmentTime: string
  ##                : [Optional] Time where the timed counts shall be aligned if rounded
  ## alignment is chosen. Default is 00:00 UTC.
  ##   serviceFilterResourceType: string
  ##                            : [Optional] The exact value to match against
  ## 
  ## [`ServiceContext.resource_type`](/error-reporting/reference/rest/v1beta1/ServiceContext#FIELDS.resource_type).
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   timedCountDuration: string
  ##                     : [Optional] The preferred duration for a single returned `TimedCount`.
  ## If not set, no timed counts are returned.
  ##   pageToken: string
  ##            : [Optional] A `next_page_token` provided by a previous response. To view
  ## additional results, pass this token along with the identical query
  ## parameters as the first request.
  ##   groupId: JArray
  ##          : [Optional] List all <code>ErrorGroupStats</code> with these IDs.
  ##   projectName: string (required)
  ##              : [Required] The resource name of the Google Cloud Platform project. Written
  ## as <code>projects/</code> plus the
  ## <a href="https://support.google.com/cloud/answer/6158840">Google Cloud
  ## Platform project ID</a>.
  ## 
  ## Example: <code>projects/my-project-123</code>.
  ##   serviceFilterService: string
  ##                       : [Optional] The exact value to match against
  ## 
  ## [`ServiceContext.service`](/error-reporting/reference/rest/v1beta1/ServiceContext#FIELDS.service).
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579013 = newJObject()
  var query_579014 = newJObject()
  add(query_579014, "key", newJString(key))
  add(query_579014, "prettyPrint", newJBool(prettyPrint))
  add(query_579014, "oauth_token", newJString(oauthToken))
  add(query_579014, "serviceFilter.version", newJString(serviceFilterVersion))
  add(query_579014, "$.xgafv", newJString(Xgafv))
  add(query_579014, "order", newJString(order))
  add(query_579014, "alignment", newJString(alignment))
  add(query_579014, "pageSize", newJInt(pageSize))
  add(query_579014, "timeRange.period", newJString(timeRangePeriod))
  add(query_579014, "alignmentTime", newJString(alignmentTime))
  add(query_579014, "serviceFilter.resourceType",
      newJString(serviceFilterResourceType))
  add(query_579014, "alt", newJString(alt))
  add(query_579014, "uploadType", newJString(uploadType))
  add(query_579014, "quotaUser", newJString(quotaUser))
  add(query_579014, "timedCountDuration", newJString(timedCountDuration))
  add(query_579014, "pageToken", newJString(pageToken))
  if groupId != nil:
    query_579014.add "groupId", groupId
  add(path_579013, "projectName", newJString(projectName))
  add(query_579014, "serviceFilter.service", newJString(serviceFilterService))
  add(query_579014, "callback", newJString(callback))
  add(query_579014, "fields", newJString(fields))
  add(query_579014, "access_token", newJString(accessToken))
  add(query_579014, "upload_protocol", newJString(uploadProtocol))
  result = call_579012.call(path_579013, query_579014, nil, nil, nil)

var clouderrorreportingProjectsGroupStatsList* = Call_ClouderrorreportingProjectsGroupStatsList_578985(
    name: "clouderrorreportingProjectsGroupStatsList", meth: HttpMethod.HttpGet,
    host: "clouderrorreporting.googleapis.com",
    route: "/v1beta1/{projectName}/groupStats",
    validator: validate_ClouderrorreportingProjectsGroupStatsList_578986,
    base: "/", url: url_ClouderrorreportingProjectsGroupStatsList_578987,
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
