
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

  OpenApiRestCall_588441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588441): Option[Scheme] {.used.} =
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
  gcpServiceName = "clouderrorreporting"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ClouderrorreportingProjectsGroupsGet_588710 = ref object of OpenApiRestCall_588441
proc url_ClouderrorreportingProjectsGroupsGet_588712(protocol: Scheme;
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

proc validate_ClouderrorreportingProjectsGroupsGet_588711(path: JsonNode;
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
  var valid_588838 = path.getOrDefault("groupName")
  valid_588838 = validateParameter(valid_588838, JString, required = true,
                                 default = nil)
  if valid_588838 != nil:
    section.add "groupName", valid_588838
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
  var valid_588839 = query.getOrDefault("upload_protocol")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = nil)
  if valid_588839 != nil:
    section.add "upload_protocol", valid_588839
  var valid_588840 = query.getOrDefault("fields")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "fields", valid_588840
  var valid_588841 = query.getOrDefault("quotaUser")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "quotaUser", valid_588841
  var valid_588855 = query.getOrDefault("alt")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = newJString("json"))
  if valid_588855 != nil:
    section.add "alt", valid_588855
  var valid_588856 = query.getOrDefault("oauth_token")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "oauth_token", valid_588856
  var valid_588857 = query.getOrDefault("callback")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "callback", valid_588857
  var valid_588858 = query.getOrDefault("access_token")
  valid_588858 = validateParameter(valid_588858, JString, required = false,
                                 default = nil)
  if valid_588858 != nil:
    section.add "access_token", valid_588858
  var valid_588859 = query.getOrDefault("uploadType")
  valid_588859 = validateParameter(valid_588859, JString, required = false,
                                 default = nil)
  if valid_588859 != nil:
    section.add "uploadType", valid_588859
  var valid_588860 = query.getOrDefault("key")
  valid_588860 = validateParameter(valid_588860, JString, required = false,
                                 default = nil)
  if valid_588860 != nil:
    section.add "key", valid_588860
  var valid_588861 = query.getOrDefault("$.xgafv")
  valid_588861 = validateParameter(valid_588861, JString, required = false,
                                 default = newJString("1"))
  if valid_588861 != nil:
    section.add "$.xgafv", valid_588861
  var valid_588862 = query.getOrDefault("prettyPrint")
  valid_588862 = validateParameter(valid_588862, JBool, required = false,
                                 default = newJBool(true))
  if valid_588862 != nil:
    section.add "prettyPrint", valid_588862
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588885: Call_ClouderrorreportingProjectsGroupsGet_588710;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the specified group.
  ## 
  let valid = call_588885.validator(path, query, header, formData, body)
  let scheme = call_588885.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588885.url(scheme.get, call_588885.host, call_588885.base,
                         call_588885.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588885, url, valid)

proc call*(call_588956: Call_ClouderrorreportingProjectsGroupsGet_588710;
          groupName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## clouderrorreportingProjectsGroupsGet
  ## Get the specified group.
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
  ##   groupName: string (required)
  ##            : [Required] The group resource name. Written as
  ## <code>projects/<var>projectID</var>/groups/<var>group_name</var></code>.
  ## Call
  ## <a href="/error-reporting/reference/rest/v1beta1/projects.groupStats/list">
  ## <code>groupStats.list</code></a> to return a list of groups belonging to
  ## this project.
  ## 
  ## Example: <code>projects/my-project-123/groups/my-group</code>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_588957 = newJObject()
  var query_588959 = newJObject()
  add(query_588959, "upload_protocol", newJString(uploadProtocol))
  add(query_588959, "fields", newJString(fields))
  add(query_588959, "quotaUser", newJString(quotaUser))
  add(query_588959, "alt", newJString(alt))
  add(query_588959, "oauth_token", newJString(oauthToken))
  add(query_588959, "callback", newJString(callback))
  add(query_588959, "access_token", newJString(accessToken))
  add(query_588959, "uploadType", newJString(uploadType))
  add(path_588957, "groupName", newJString(groupName))
  add(query_588959, "key", newJString(key))
  add(query_588959, "$.xgafv", newJString(Xgafv))
  add(query_588959, "prettyPrint", newJBool(prettyPrint))
  result = call_588956.call(path_588957, query_588959, nil, nil, nil)

var clouderrorreportingProjectsGroupsGet* = Call_ClouderrorreportingProjectsGroupsGet_588710(
    name: "clouderrorreportingProjectsGroupsGet", meth: HttpMethod.HttpGet,
    host: "clouderrorreporting.googleapis.com", route: "/v1beta1/{groupName}",
    validator: validate_ClouderrorreportingProjectsGroupsGet_588711, base: "/",
    url: url_ClouderrorreportingProjectsGroupsGet_588712, schemes: {Scheme.Https})
type
  Call_ClouderrorreportingProjectsGroupsUpdate_588998 = ref object of OpenApiRestCall_588441
proc url_ClouderrorreportingProjectsGroupsUpdate_589000(protocol: Scheme;
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

proc validate_ClouderrorreportingProjectsGroupsUpdate_588999(path: JsonNode;
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
  var valid_589001 = path.getOrDefault("name")
  valid_589001 = validateParameter(valid_589001, JString, required = true,
                                 default = nil)
  if valid_589001 != nil:
    section.add "name", valid_589001
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
  var valid_589002 = query.getOrDefault("upload_protocol")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = nil)
  if valid_589002 != nil:
    section.add "upload_protocol", valid_589002
  var valid_589003 = query.getOrDefault("fields")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = nil)
  if valid_589003 != nil:
    section.add "fields", valid_589003
  var valid_589004 = query.getOrDefault("quotaUser")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "quotaUser", valid_589004
  var valid_589005 = query.getOrDefault("alt")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = newJString("json"))
  if valid_589005 != nil:
    section.add "alt", valid_589005
  var valid_589006 = query.getOrDefault("oauth_token")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "oauth_token", valid_589006
  var valid_589007 = query.getOrDefault("callback")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "callback", valid_589007
  var valid_589008 = query.getOrDefault("access_token")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "access_token", valid_589008
  var valid_589009 = query.getOrDefault("uploadType")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "uploadType", valid_589009
  var valid_589010 = query.getOrDefault("key")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "key", valid_589010
  var valid_589011 = query.getOrDefault("$.xgafv")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = newJString("1"))
  if valid_589011 != nil:
    section.add "$.xgafv", valid_589011
  var valid_589012 = query.getOrDefault("prettyPrint")
  valid_589012 = validateParameter(valid_589012, JBool, required = false,
                                 default = newJBool(true))
  if valid_589012 != nil:
    section.add "prettyPrint", valid_589012
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

proc call*(call_589014: Call_ClouderrorreportingProjectsGroupsUpdate_588998;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Replace the data for the specified group.
  ## Fails if the group does not exist.
  ## 
  let valid = call_589014.validator(path, query, header, formData, body)
  let scheme = call_589014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589014.url(scheme.get, call_589014.host, call_589014.base,
                         call_589014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589014, url, valid)

proc call*(call_589015: Call_ClouderrorreportingProjectsGroupsUpdate_588998;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## clouderrorreportingProjectsGroupsUpdate
  ## Replace the data for the specified group.
  ## Fails if the group does not exist.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The group resource name.
  ## Example: <code>projects/my-project-123/groups/my-groupid</code>
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
  var path_589016 = newJObject()
  var query_589017 = newJObject()
  var body_589018 = newJObject()
  add(query_589017, "upload_protocol", newJString(uploadProtocol))
  add(query_589017, "fields", newJString(fields))
  add(query_589017, "quotaUser", newJString(quotaUser))
  add(path_589016, "name", newJString(name))
  add(query_589017, "alt", newJString(alt))
  add(query_589017, "oauth_token", newJString(oauthToken))
  add(query_589017, "callback", newJString(callback))
  add(query_589017, "access_token", newJString(accessToken))
  add(query_589017, "uploadType", newJString(uploadType))
  add(query_589017, "key", newJString(key))
  add(query_589017, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589018 = body
  add(query_589017, "prettyPrint", newJBool(prettyPrint))
  result = call_589015.call(path_589016, query_589017, nil, nil, body_589018)

var clouderrorreportingProjectsGroupsUpdate* = Call_ClouderrorreportingProjectsGroupsUpdate_588998(
    name: "clouderrorreportingProjectsGroupsUpdate", meth: HttpMethod.HttpPut,
    host: "clouderrorreporting.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_ClouderrorreportingProjectsGroupsUpdate_588999, base: "/",
    url: url_ClouderrorreportingProjectsGroupsUpdate_589000,
    schemes: {Scheme.Https})
type
  Call_ClouderrorreportingProjectsEventsList_589019 = ref object of OpenApiRestCall_588441
proc url_ClouderrorreportingProjectsEventsList_589021(protocol: Scheme;
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

proc validate_ClouderrorreportingProjectsEventsList_589020(path: JsonNode;
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
  var valid_589022 = path.getOrDefault("projectName")
  valid_589022 = validateParameter(valid_589022, JString, required = true,
                                 default = nil)
  if valid_589022 != nil:
    section.add "projectName", valid_589022
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   serviceFilter.resourceType: JString
  ##                             : [Optional] The exact value to match against
  ## 
  ## [`ServiceContext.resource_type`](/error-reporting/reference/rest/v1beta1/ServiceContext#FIELDS.resource_type).
  ##   serviceFilter.version: JString
  ##                        : [Optional] The exact value to match against
  ## 
  ## [`ServiceContext.version`](/error-reporting/reference/rest/v1beta1/ServiceContext#FIELDS.version).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : [Optional] A `next_page_token` provided by a previous response.
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
  ##   timeRange.period: JString
  ##                   : Restricts the query to the specified time range.
  ##   groupId: JString
  ##          : [Required] The group for which events shall be returned.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : [Optional] The maximum number of results to return per response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   serviceFilter.service: JString
  ##                        : [Optional] The exact value to match against
  ## 
  ## [`ServiceContext.service`](/error-reporting/reference/rest/v1beta1/ServiceContext#FIELDS.service).
  section = newJObject()
  var valid_589023 = query.getOrDefault("upload_protocol")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "upload_protocol", valid_589023
  var valid_589024 = query.getOrDefault("serviceFilter.resourceType")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "serviceFilter.resourceType", valid_589024
  var valid_589025 = query.getOrDefault("serviceFilter.version")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "serviceFilter.version", valid_589025
  var valid_589026 = query.getOrDefault("fields")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "fields", valid_589026
  var valid_589027 = query.getOrDefault("pageToken")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "pageToken", valid_589027
  var valid_589028 = query.getOrDefault("quotaUser")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "quotaUser", valid_589028
  var valid_589029 = query.getOrDefault("alt")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = newJString("json"))
  if valid_589029 != nil:
    section.add "alt", valid_589029
  var valid_589030 = query.getOrDefault("oauth_token")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "oauth_token", valid_589030
  var valid_589031 = query.getOrDefault("callback")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "callback", valid_589031
  var valid_589032 = query.getOrDefault("access_token")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "access_token", valid_589032
  var valid_589033 = query.getOrDefault("uploadType")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "uploadType", valid_589033
  var valid_589034 = query.getOrDefault("timeRange.period")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = newJString("PERIOD_UNSPECIFIED"))
  if valid_589034 != nil:
    section.add "timeRange.period", valid_589034
  var valid_589035 = query.getOrDefault("groupId")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "groupId", valid_589035
  var valid_589036 = query.getOrDefault("key")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "key", valid_589036
  var valid_589037 = query.getOrDefault("$.xgafv")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = newJString("1"))
  if valid_589037 != nil:
    section.add "$.xgafv", valid_589037
  var valid_589038 = query.getOrDefault("pageSize")
  valid_589038 = validateParameter(valid_589038, JInt, required = false, default = nil)
  if valid_589038 != nil:
    section.add "pageSize", valid_589038
  var valid_589039 = query.getOrDefault("prettyPrint")
  valid_589039 = validateParameter(valid_589039, JBool, required = false,
                                 default = newJBool(true))
  if valid_589039 != nil:
    section.add "prettyPrint", valid_589039
  var valid_589040 = query.getOrDefault("serviceFilter.service")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "serviceFilter.service", valid_589040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589041: Call_ClouderrorreportingProjectsEventsList_589019;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the specified events.
  ## 
  let valid = call_589041.validator(path, query, header, formData, body)
  let scheme = call_589041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589041.url(scheme.get, call_589041.host, call_589041.base,
                         call_589041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589041, url, valid)

proc call*(call_589042: Call_ClouderrorreportingProjectsEventsList_589019;
          projectName: string; uploadProtocol: string = "";
          serviceFilterResourceType: string = ""; serviceFilterVersion: string = "";
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          timeRangePeriod: string = "PERIOD_UNSPECIFIED"; groupId: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; serviceFilterService: string = ""): Recallable =
  ## clouderrorreportingProjectsEventsList
  ## Lists the specified events.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   serviceFilterResourceType: string
  ##                            : [Optional] The exact value to match against
  ## 
  ## [`ServiceContext.resource_type`](/error-reporting/reference/rest/v1beta1/ServiceContext#FIELDS.resource_type).
  ##   serviceFilterVersion: string
  ##                       : [Optional] The exact value to match against
  ## 
  ## [`ServiceContext.version`](/error-reporting/reference/rest/v1beta1/ServiceContext#FIELDS.version).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : [Optional] A `next_page_token` provided by a previous response.
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
  ##   timeRangePeriod: string
  ##                  : Restricts the query to the specified time range.
  ##   groupId: string
  ##          : [Required] The group for which events shall be returned.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectName: string (required)
  ##              : [Required] The resource name of the Google Cloud Platform project. Written
  ## as `projects/` plus the
  ## [Google Cloud Platform project
  ## ID](https://support.google.com/cloud/answer/6158840).
  ## Example: `projects/my-project-123`.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : [Optional] The maximum number of results to return per response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   serviceFilterService: string
  ##                       : [Optional] The exact value to match against
  ## 
  ## [`ServiceContext.service`](/error-reporting/reference/rest/v1beta1/ServiceContext#FIELDS.service).
  var path_589043 = newJObject()
  var query_589044 = newJObject()
  add(query_589044, "upload_protocol", newJString(uploadProtocol))
  add(query_589044, "serviceFilter.resourceType",
      newJString(serviceFilterResourceType))
  add(query_589044, "serviceFilter.version", newJString(serviceFilterVersion))
  add(query_589044, "fields", newJString(fields))
  add(query_589044, "pageToken", newJString(pageToken))
  add(query_589044, "quotaUser", newJString(quotaUser))
  add(query_589044, "alt", newJString(alt))
  add(query_589044, "oauth_token", newJString(oauthToken))
  add(query_589044, "callback", newJString(callback))
  add(query_589044, "access_token", newJString(accessToken))
  add(query_589044, "uploadType", newJString(uploadType))
  add(query_589044, "timeRange.period", newJString(timeRangePeriod))
  add(query_589044, "groupId", newJString(groupId))
  add(query_589044, "key", newJString(key))
  add(path_589043, "projectName", newJString(projectName))
  add(query_589044, "$.xgafv", newJString(Xgafv))
  add(query_589044, "pageSize", newJInt(pageSize))
  add(query_589044, "prettyPrint", newJBool(prettyPrint))
  add(query_589044, "serviceFilter.service", newJString(serviceFilterService))
  result = call_589042.call(path_589043, query_589044, nil, nil, nil)

var clouderrorreportingProjectsEventsList* = Call_ClouderrorreportingProjectsEventsList_589019(
    name: "clouderrorreportingProjectsEventsList", meth: HttpMethod.HttpGet,
    host: "clouderrorreporting.googleapis.com",
    route: "/v1beta1/{projectName}/events",
    validator: validate_ClouderrorreportingProjectsEventsList_589020, base: "/",
    url: url_ClouderrorreportingProjectsEventsList_589021, schemes: {Scheme.Https})
type
  Call_ClouderrorreportingProjectsDeleteEvents_589045 = ref object of OpenApiRestCall_588441
proc url_ClouderrorreportingProjectsDeleteEvents_589047(protocol: Scheme;
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

proc validate_ClouderrorreportingProjectsDeleteEvents_589046(path: JsonNode;
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
  var valid_589048 = path.getOrDefault("projectName")
  valid_589048 = validateParameter(valid_589048, JString, required = true,
                                 default = nil)
  if valid_589048 != nil:
    section.add "projectName", valid_589048
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
  var valid_589049 = query.getOrDefault("upload_protocol")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "upload_protocol", valid_589049
  var valid_589050 = query.getOrDefault("fields")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "fields", valid_589050
  var valid_589051 = query.getOrDefault("quotaUser")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "quotaUser", valid_589051
  var valid_589052 = query.getOrDefault("alt")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = newJString("json"))
  if valid_589052 != nil:
    section.add "alt", valid_589052
  var valid_589053 = query.getOrDefault("oauth_token")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "oauth_token", valid_589053
  var valid_589054 = query.getOrDefault("callback")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "callback", valid_589054
  var valid_589055 = query.getOrDefault("access_token")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "access_token", valid_589055
  var valid_589056 = query.getOrDefault("uploadType")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "uploadType", valid_589056
  var valid_589057 = query.getOrDefault("key")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "key", valid_589057
  var valid_589058 = query.getOrDefault("$.xgafv")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = newJString("1"))
  if valid_589058 != nil:
    section.add "$.xgafv", valid_589058
  var valid_589059 = query.getOrDefault("prettyPrint")
  valid_589059 = validateParameter(valid_589059, JBool, required = false,
                                 default = newJBool(true))
  if valid_589059 != nil:
    section.add "prettyPrint", valid_589059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589060: Call_ClouderrorreportingProjectsDeleteEvents_589045;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all error events of a given project.
  ## 
  let valid = call_589060.validator(path, query, header, formData, body)
  let scheme = call_589060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589060.url(scheme.get, call_589060.host, call_589060.base,
                         call_589060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589060, url, valid)

proc call*(call_589061: Call_ClouderrorreportingProjectsDeleteEvents_589045;
          projectName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## clouderrorreportingProjectsDeleteEvents
  ## Deletes all error events of a given project.
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectName: string (required)
  ##              : [Required] The resource name of the Google Cloud Platform project. Written
  ## as `projects/` plus the
  ## [Google Cloud Platform project
  ## ID](https://support.google.com/cloud/answer/6158840).
  ## Example: `projects/my-project-123`.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589062 = newJObject()
  var query_589063 = newJObject()
  add(query_589063, "upload_protocol", newJString(uploadProtocol))
  add(query_589063, "fields", newJString(fields))
  add(query_589063, "quotaUser", newJString(quotaUser))
  add(query_589063, "alt", newJString(alt))
  add(query_589063, "oauth_token", newJString(oauthToken))
  add(query_589063, "callback", newJString(callback))
  add(query_589063, "access_token", newJString(accessToken))
  add(query_589063, "uploadType", newJString(uploadType))
  add(query_589063, "key", newJString(key))
  add(path_589062, "projectName", newJString(projectName))
  add(query_589063, "$.xgafv", newJString(Xgafv))
  add(query_589063, "prettyPrint", newJBool(prettyPrint))
  result = call_589061.call(path_589062, query_589063, nil, nil, nil)

var clouderrorreportingProjectsDeleteEvents* = Call_ClouderrorreportingProjectsDeleteEvents_589045(
    name: "clouderrorreportingProjectsDeleteEvents", meth: HttpMethod.HttpDelete,
    host: "clouderrorreporting.googleapis.com",
    route: "/v1beta1/{projectName}/events",
    validator: validate_ClouderrorreportingProjectsDeleteEvents_589046, base: "/",
    url: url_ClouderrorreportingProjectsDeleteEvents_589047,
    schemes: {Scheme.Https})
type
  Call_ClouderrorreportingProjectsEventsReport_589064 = ref object of OpenApiRestCall_588441
proc url_ClouderrorreportingProjectsEventsReport_589066(protocol: Scheme;
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

proc validate_ClouderrorreportingProjectsEventsReport_589065(path: JsonNode;
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
  var valid_589067 = path.getOrDefault("projectName")
  valid_589067 = validateParameter(valid_589067, JString, required = true,
                                 default = nil)
  if valid_589067 != nil:
    section.add "projectName", valid_589067
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
  var valid_589068 = query.getOrDefault("upload_protocol")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "upload_protocol", valid_589068
  var valid_589069 = query.getOrDefault("fields")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "fields", valid_589069
  var valid_589070 = query.getOrDefault("quotaUser")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "quotaUser", valid_589070
  var valid_589071 = query.getOrDefault("alt")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = newJString("json"))
  if valid_589071 != nil:
    section.add "alt", valid_589071
  var valid_589072 = query.getOrDefault("oauth_token")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "oauth_token", valid_589072
  var valid_589073 = query.getOrDefault("callback")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "callback", valid_589073
  var valid_589074 = query.getOrDefault("access_token")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "access_token", valid_589074
  var valid_589075 = query.getOrDefault("uploadType")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "uploadType", valid_589075
  var valid_589076 = query.getOrDefault("key")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "key", valid_589076
  var valid_589077 = query.getOrDefault("$.xgafv")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = newJString("1"))
  if valid_589077 != nil:
    section.add "$.xgafv", valid_589077
  var valid_589078 = query.getOrDefault("prettyPrint")
  valid_589078 = validateParameter(valid_589078, JBool, required = false,
                                 default = newJBool(true))
  if valid_589078 != nil:
    section.add "prettyPrint", valid_589078
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

proc call*(call_589080: Call_ClouderrorreportingProjectsEventsReport_589064;
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
  let valid = call_589080.validator(path, query, header, formData, body)
  let scheme = call_589080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589080.url(scheme.get, call_589080.host, call_589080.base,
                         call_589080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589080, url, valid)

proc call*(call_589081: Call_ClouderrorreportingProjectsEventsReport_589064;
          projectName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectName: string (required)
  ##              : [Required] The resource name of the Google Cloud Platform project. Written
  ## as `projects/` plus the
  ## [Google Cloud Platform project
  ## ID](https://support.google.com/cloud/answer/6158840). Example:
  ## `projects/my-project-123`.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589082 = newJObject()
  var query_589083 = newJObject()
  var body_589084 = newJObject()
  add(query_589083, "upload_protocol", newJString(uploadProtocol))
  add(query_589083, "fields", newJString(fields))
  add(query_589083, "quotaUser", newJString(quotaUser))
  add(query_589083, "alt", newJString(alt))
  add(query_589083, "oauth_token", newJString(oauthToken))
  add(query_589083, "callback", newJString(callback))
  add(query_589083, "access_token", newJString(accessToken))
  add(query_589083, "uploadType", newJString(uploadType))
  add(query_589083, "key", newJString(key))
  add(path_589082, "projectName", newJString(projectName))
  add(query_589083, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589084 = body
  add(query_589083, "prettyPrint", newJBool(prettyPrint))
  result = call_589081.call(path_589082, query_589083, nil, nil, body_589084)

var clouderrorreportingProjectsEventsReport* = Call_ClouderrorreportingProjectsEventsReport_589064(
    name: "clouderrorreportingProjectsEventsReport", meth: HttpMethod.HttpPost,
    host: "clouderrorreporting.googleapis.com",
    route: "/v1beta1/{projectName}/events:report",
    validator: validate_ClouderrorreportingProjectsEventsReport_589065, base: "/",
    url: url_ClouderrorreportingProjectsEventsReport_589066,
    schemes: {Scheme.Https})
type
  Call_ClouderrorreportingProjectsGroupStatsList_589085 = ref object of OpenApiRestCall_588441
proc url_ClouderrorreportingProjectsGroupStatsList_589087(protocol: Scheme;
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

proc validate_ClouderrorreportingProjectsGroupStatsList_589086(path: JsonNode;
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
  var valid_589088 = path.getOrDefault("projectName")
  valid_589088 = validateParameter(valid_589088, JString, required = true,
                                 default = nil)
  if valid_589088 != nil:
    section.add "projectName", valid_589088
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   serviceFilter.resourceType: JString
  ##                             : [Optional] The exact value to match against
  ## 
  ## [`ServiceContext.resource_type`](/error-reporting/reference/rest/v1beta1/ServiceContext#FIELDS.resource_type).
  ##   serviceFilter.version: JString
  ##                        : [Optional] The exact value to match against
  ## 
  ## [`ServiceContext.version`](/error-reporting/reference/rest/v1beta1/ServiceContext#FIELDS.version).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : [Optional] A `next_page_token` provided by a previous response. To view
  ## additional results, pass this token along with the identical query
  ## parameters as the first request.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   timedCountDuration: JString
  ##                     : [Optional] The preferred duration for a single returned `TimedCount`.
  ## If not set, no timed counts are returned.
  ##   order: JString
  ##        : [Optional] The sort order in which the results are returned.
  ## Default is `COUNT_DESC`.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   timeRange.period: JString
  ##                   : Restricts the query to the specified time range.
  ##   groupId: JArray
  ##          : [Optional] List all <code>ErrorGroupStats</code> with these IDs.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   alignmentTime: JString
  ##                : [Optional] Time where the timed counts shall be aligned if rounded
  ## alignment is chosen. Default is 00:00 UTC.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : [Optional] The maximum number of results to return per response.
  ## Default is 20.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   alignment: JString
  ##            : [Optional] The alignment of the timed counts to be returned.
  ## Default is `ALIGNMENT_EQUAL_AT_END`.
  ##   serviceFilter.service: JString
  ##                        : [Optional] The exact value to match against
  ## 
  ## [`ServiceContext.service`](/error-reporting/reference/rest/v1beta1/ServiceContext#FIELDS.service).
  section = newJObject()
  var valid_589089 = query.getOrDefault("upload_protocol")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "upload_protocol", valid_589089
  var valid_589090 = query.getOrDefault("serviceFilter.resourceType")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "serviceFilter.resourceType", valid_589090
  var valid_589091 = query.getOrDefault("serviceFilter.version")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "serviceFilter.version", valid_589091
  var valid_589092 = query.getOrDefault("fields")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "fields", valid_589092
  var valid_589093 = query.getOrDefault("pageToken")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "pageToken", valid_589093
  var valid_589094 = query.getOrDefault("quotaUser")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "quotaUser", valid_589094
  var valid_589095 = query.getOrDefault("alt")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = newJString("json"))
  if valid_589095 != nil:
    section.add "alt", valid_589095
  var valid_589096 = query.getOrDefault("timedCountDuration")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "timedCountDuration", valid_589096
  var valid_589097 = query.getOrDefault("order")
  valid_589097 = validateParameter(valid_589097, JString, required = false, default = newJString(
      "GROUP_ORDER_UNSPECIFIED"))
  if valid_589097 != nil:
    section.add "order", valid_589097
  var valid_589098 = query.getOrDefault("oauth_token")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "oauth_token", valid_589098
  var valid_589099 = query.getOrDefault("callback")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "callback", valid_589099
  var valid_589100 = query.getOrDefault("access_token")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "access_token", valid_589100
  var valid_589101 = query.getOrDefault("uploadType")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "uploadType", valid_589101
  var valid_589102 = query.getOrDefault("timeRange.period")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = newJString("PERIOD_UNSPECIFIED"))
  if valid_589102 != nil:
    section.add "timeRange.period", valid_589102
  var valid_589103 = query.getOrDefault("groupId")
  valid_589103 = validateParameter(valid_589103, JArray, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "groupId", valid_589103
  var valid_589104 = query.getOrDefault("key")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "key", valid_589104
  var valid_589105 = query.getOrDefault("alignmentTime")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "alignmentTime", valid_589105
  var valid_589106 = query.getOrDefault("$.xgafv")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = newJString("1"))
  if valid_589106 != nil:
    section.add "$.xgafv", valid_589106
  var valid_589107 = query.getOrDefault("pageSize")
  valid_589107 = validateParameter(valid_589107, JInt, required = false, default = nil)
  if valid_589107 != nil:
    section.add "pageSize", valid_589107
  var valid_589108 = query.getOrDefault("prettyPrint")
  valid_589108 = validateParameter(valid_589108, JBool, required = false,
                                 default = newJBool(true))
  if valid_589108 != nil:
    section.add "prettyPrint", valid_589108
  var valid_589109 = query.getOrDefault("alignment")
  valid_589109 = validateParameter(valid_589109, JString, required = false, default = newJString(
      "ERROR_COUNT_ALIGNMENT_UNSPECIFIED"))
  if valid_589109 != nil:
    section.add "alignment", valid_589109
  var valid_589110 = query.getOrDefault("serviceFilter.service")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "serviceFilter.service", valid_589110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589111: Call_ClouderrorreportingProjectsGroupStatsList_589085;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the specified groups.
  ## 
  let valid = call_589111.validator(path, query, header, formData, body)
  let scheme = call_589111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589111.url(scheme.get, call_589111.host, call_589111.base,
                         call_589111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589111, url, valid)

proc call*(call_589112: Call_ClouderrorreportingProjectsGroupStatsList_589085;
          projectName: string; uploadProtocol: string = "";
          serviceFilterResourceType: string = ""; serviceFilterVersion: string = "";
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; timedCountDuration: string = "";
          order: string = "GROUP_ORDER_UNSPECIFIED"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          timeRangePeriod: string = "PERIOD_UNSPECIFIED"; groupId: JsonNode = nil;
          key: string = ""; alignmentTime: string = ""; Xgafv: string = "1";
          pageSize: int = 0; prettyPrint: bool = true;
          alignment: string = "ERROR_COUNT_ALIGNMENT_UNSPECIFIED";
          serviceFilterService: string = ""): Recallable =
  ## clouderrorreportingProjectsGroupStatsList
  ## Lists the specified groups.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   serviceFilterResourceType: string
  ##                            : [Optional] The exact value to match against
  ## 
  ## [`ServiceContext.resource_type`](/error-reporting/reference/rest/v1beta1/ServiceContext#FIELDS.resource_type).
  ##   serviceFilterVersion: string
  ##                       : [Optional] The exact value to match against
  ## 
  ## [`ServiceContext.version`](/error-reporting/reference/rest/v1beta1/ServiceContext#FIELDS.version).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : [Optional] A `next_page_token` provided by a previous response. To view
  ## additional results, pass this token along with the identical query
  ## parameters as the first request.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   timedCountDuration: string
  ##                     : [Optional] The preferred duration for a single returned `TimedCount`.
  ## If not set, no timed counts are returned.
  ##   order: string
  ##        : [Optional] The sort order in which the results are returned.
  ## Default is `COUNT_DESC`.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   timeRangePeriod: string
  ##                  : Restricts the query to the specified time range.
  ##   groupId: JArray
  ##          : [Optional] List all <code>ErrorGroupStats</code> with these IDs.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   alignmentTime: string
  ##                : [Optional] Time where the timed counts shall be aligned if rounded
  ## alignment is chosen. Default is 00:00 UTC.
  ##   projectName: string (required)
  ##              : [Required] The resource name of the Google Cloud Platform project. Written
  ## as <code>projects/</code> plus the
  ## <a href="https://support.google.com/cloud/answer/6158840">Google Cloud
  ## Platform project ID</a>.
  ## 
  ## Example: <code>projects/my-project-123</code>.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : [Optional] The maximum number of results to return per response.
  ## Default is 20.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   alignment: string
  ##            : [Optional] The alignment of the timed counts to be returned.
  ## Default is `ALIGNMENT_EQUAL_AT_END`.
  ##   serviceFilterService: string
  ##                       : [Optional] The exact value to match against
  ## 
  ## [`ServiceContext.service`](/error-reporting/reference/rest/v1beta1/ServiceContext#FIELDS.service).
  var path_589113 = newJObject()
  var query_589114 = newJObject()
  add(query_589114, "upload_protocol", newJString(uploadProtocol))
  add(query_589114, "serviceFilter.resourceType",
      newJString(serviceFilterResourceType))
  add(query_589114, "serviceFilter.version", newJString(serviceFilterVersion))
  add(query_589114, "fields", newJString(fields))
  add(query_589114, "pageToken", newJString(pageToken))
  add(query_589114, "quotaUser", newJString(quotaUser))
  add(query_589114, "alt", newJString(alt))
  add(query_589114, "timedCountDuration", newJString(timedCountDuration))
  add(query_589114, "order", newJString(order))
  add(query_589114, "oauth_token", newJString(oauthToken))
  add(query_589114, "callback", newJString(callback))
  add(query_589114, "access_token", newJString(accessToken))
  add(query_589114, "uploadType", newJString(uploadType))
  add(query_589114, "timeRange.period", newJString(timeRangePeriod))
  if groupId != nil:
    query_589114.add "groupId", groupId
  add(query_589114, "key", newJString(key))
  add(query_589114, "alignmentTime", newJString(alignmentTime))
  add(path_589113, "projectName", newJString(projectName))
  add(query_589114, "$.xgafv", newJString(Xgafv))
  add(query_589114, "pageSize", newJInt(pageSize))
  add(query_589114, "prettyPrint", newJBool(prettyPrint))
  add(query_589114, "alignment", newJString(alignment))
  add(query_589114, "serviceFilter.service", newJString(serviceFilterService))
  result = call_589112.call(path_589113, query_589114, nil, nil, nil)

var clouderrorreportingProjectsGroupStatsList* = Call_ClouderrorreportingProjectsGroupStatsList_589085(
    name: "clouderrorreportingProjectsGroupStatsList", meth: HttpMethod.HttpGet,
    host: "clouderrorreporting.googleapis.com",
    route: "/v1beta1/{projectName}/groupStats",
    validator: validate_ClouderrorreportingProjectsGroupStatsList_589086,
    base: "/", url: url_ClouderrorreportingProjectsGroupStatsList_589087,
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
