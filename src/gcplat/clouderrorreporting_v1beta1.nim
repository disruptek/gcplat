
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

  OpenApiRestCall_579408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579408): Option[Scheme] {.used.} =
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
  gcpServiceName = "clouderrorreporting"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ClouderrorreportingProjectsGroupsGet_579677 = ref object of OpenApiRestCall_579408
proc url_ClouderrorreportingProjectsGroupsGet_579679(protocol: Scheme;
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

proc validate_ClouderrorreportingProjectsGroupsGet_579678(path: JsonNode;
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
  var valid_579805 = path.getOrDefault("groupName")
  valid_579805 = validateParameter(valid_579805, JString, required = true,
                                 default = nil)
  if valid_579805 != nil:
    section.add "groupName", valid_579805
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
  var valid_579806 = query.getOrDefault("upload_protocol")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "upload_protocol", valid_579806
  var valid_579807 = query.getOrDefault("fields")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "fields", valid_579807
  var valid_579808 = query.getOrDefault("quotaUser")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "quotaUser", valid_579808
  var valid_579822 = query.getOrDefault("alt")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = newJString("json"))
  if valid_579822 != nil:
    section.add "alt", valid_579822
  var valid_579823 = query.getOrDefault("oauth_token")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "oauth_token", valid_579823
  var valid_579824 = query.getOrDefault("callback")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "callback", valid_579824
  var valid_579825 = query.getOrDefault("access_token")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "access_token", valid_579825
  var valid_579826 = query.getOrDefault("uploadType")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "uploadType", valid_579826
  var valid_579827 = query.getOrDefault("key")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "key", valid_579827
  var valid_579828 = query.getOrDefault("$.xgafv")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = newJString("1"))
  if valid_579828 != nil:
    section.add "$.xgafv", valid_579828
  var valid_579829 = query.getOrDefault("prettyPrint")
  valid_579829 = validateParameter(valid_579829, JBool, required = false,
                                 default = newJBool(true))
  if valid_579829 != nil:
    section.add "prettyPrint", valid_579829
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579852: Call_ClouderrorreportingProjectsGroupsGet_579677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the specified group.
  ## 
  let valid = call_579852.validator(path, query, header, formData, body)
  let scheme = call_579852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579852.url(scheme.get, call_579852.host, call_579852.base,
                         call_579852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579852, url, valid)

proc call*(call_579923: Call_ClouderrorreportingProjectsGroupsGet_579677;
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
  var path_579924 = newJObject()
  var query_579926 = newJObject()
  add(query_579926, "upload_protocol", newJString(uploadProtocol))
  add(query_579926, "fields", newJString(fields))
  add(query_579926, "quotaUser", newJString(quotaUser))
  add(query_579926, "alt", newJString(alt))
  add(query_579926, "oauth_token", newJString(oauthToken))
  add(query_579926, "callback", newJString(callback))
  add(query_579926, "access_token", newJString(accessToken))
  add(query_579926, "uploadType", newJString(uploadType))
  add(path_579924, "groupName", newJString(groupName))
  add(query_579926, "key", newJString(key))
  add(query_579926, "$.xgafv", newJString(Xgafv))
  add(query_579926, "prettyPrint", newJBool(prettyPrint))
  result = call_579923.call(path_579924, query_579926, nil, nil, nil)

var clouderrorreportingProjectsGroupsGet* = Call_ClouderrorreportingProjectsGroupsGet_579677(
    name: "clouderrorreportingProjectsGroupsGet", meth: HttpMethod.HttpGet,
    host: "clouderrorreporting.googleapis.com", route: "/v1beta1/{groupName}",
    validator: validate_ClouderrorreportingProjectsGroupsGet_579678, base: "/",
    url: url_ClouderrorreportingProjectsGroupsGet_579679, schemes: {Scheme.Https})
type
  Call_ClouderrorreportingProjectsGroupsUpdate_579965 = ref object of OpenApiRestCall_579408
proc url_ClouderrorreportingProjectsGroupsUpdate_579967(protocol: Scheme;
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

proc validate_ClouderrorreportingProjectsGroupsUpdate_579966(path: JsonNode;
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
  var valid_579968 = path.getOrDefault("name")
  valid_579968 = validateParameter(valid_579968, JString, required = true,
                                 default = nil)
  if valid_579968 != nil:
    section.add "name", valid_579968
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
  var valid_579969 = query.getOrDefault("upload_protocol")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "upload_protocol", valid_579969
  var valid_579970 = query.getOrDefault("fields")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "fields", valid_579970
  var valid_579971 = query.getOrDefault("quotaUser")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "quotaUser", valid_579971
  var valid_579972 = query.getOrDefault("alt")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = newJString("json"))
  if valid_579972 != nil:
    section.add "alt", valid_579972
  var valid_579973 = query.getOrDefault("oauth_token")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "oauth_token", valid_579973
  var valid_579974 = query.getOrDefault("callback")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "callback", valid_579974
  var valid_579975 = query.getOrDefault("access_token")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "access_token", valid_579975
  var valid_579976 = query.getOrDefault("uploadType")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "uploadType", valid_579976
  var valid_579977 = query.getOrDefault("key")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "key", valid_579977
  var valid_579978 = query.getOrDefault("$.xgafv")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = newJString("1"))
  if valid_579978 != nil:
    section.add "$.xgafv", valid_579978
  var valid_579979 = query.getOrDefault("prettyPrint")
  valid_579979 = validateParameter(valid_579979, JBool, required = false,
                                 default = newJBool(true))
  if valid_579979 != nil:
    section.add "prettyPrint", valid_579979
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

proc call*(call_579981: Call_ClouderrorreportingProjectsGroupsUpdate_579965;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Replace the data for the specified group.
  ## Fails if the group does not exist.
  ## 
  let valid = call_579981.validator(path, query, header, formData, body)
  let scheme = call_579981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579981.url(scheme.get, call_579981.host, call_579981.base,
                         call_579981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579981, url, valid)

proc call*(call_579982: Call_ClouderrorreportingProjectsGroupsUpdate_579965;
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
  var path_579983 = newJObject()
  var query_579984 = newJObject()
  var body_579985 = newJObject()
  add(query_579984, "upload_protocol", newJString(uploadProtocol))
  add(query_579984, "fields", newJString(fields))
  add(query_579984, "quotaUser", newJString(quotaUser))
  add(path_579983, "name", newJString(name))
  add(query_579984, "alt", newJString(alt))
  add(query_579984, "oauth_token", newJString(oauthToken))
  add(query_579984, "callback", newJString(callback))
  add(query_579984, "access_token", newJString(accessToken))
  add(query_579984, "uploadType", newJString(uploadType))
  add(query_579984, "key", newJString(key))
  add(query_579984, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579985 = body
  add(query_579984, "prettyPrint", newJBool(prettyPrint))
  result = call_579982.call(path_579983, query_579984, nil, nil, body_579985)

var clouderrorreportingProjectsGroupsUpdate* = Call_ClouderrorreportingProjectsGroupsUpdate_579965(
    name: "clouderrorreportingProjectsGroupsUpdate", meth: HttpMethod.HttpPut,
    host: "clouderrorreporting.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_ClouderrorreportingProjectsGroupsUpdate_579966, base: "/",
    url: url_ClouderrorreportingProjectsGroupsUpdate_579967,
    schemes: {Scheme.Https})
type
  Call_ClouderrorreportingProjectsEventsList_579986 = ref object of OpenApiRestCall_579408
proc url_ClouderrorreportingProjectsEventsList_579988(protocol: Scheme;
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

proc validate_ClouderrorreportingProjectsEventsList_579987(path: JsonNode;
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
  var valid_579989 = path.getOrDefault("projectName")
  valid_579989 = validateParameter(valid_579989, JString, required = true,
                                 default = nil)
  if valid_579989 != nil:
    section.add "projectName", valid_579989
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
  var valid_579990 = query.getOrDefault("upload_protocol")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "upload_protocol", valid_579990
  var valid_579991 = query.getOrDefault("serviceFilter.resourceType")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "serviceFilter.resourceType", valid_579991
  var valid_579992 = query.getOrDefault("serviceFilter.version")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "serviceFilter.version", valid_579992
  var valid_579993 = query.getOrDefault("fields")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "fields", valid_579993
  var valid_579994 = query.getOrDefault("pageToken")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "pageToken", valid_579994
  var valid_579995 = query.getOrDefault("quotaUser")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "quotaUser", valid_579995
  var valid_579996 = query.getOrDefault("alt")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = newJString("json"))
  if valid_579996 != nil:
    section.add "alt", valid_579996
  var valid_579997 = query.getOrDefault("oauth_token")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "oauth_token", valid_579997
  var valid_579998 = query.getOrDefault("callback")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "callback", valid_579998
  var valid_579999 = query.getOrDefault("access_token")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "access_token", valid_579999
  var valid_580000 = query.getOrDefault("uploadType")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "uploadType", valid_580000
  var valid_580001 = query.getOrDefault("timeRange.period")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = newJString("PERIOD_UNSPECIFIED"))
  if valid_580001 != nil:
    section.add "timeRange.period", valid_580001
  var valid_580002 = query.getOrDefault("groupId")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "groupId", valid_580002
  var valid_580003 = query.getOrDefault("key")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "key", valid_580003
  var valid_580004 = query.getOrDefault("$.xgafv")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = newJString("1"))
  if valid_580004 != nil:
    section.add "$.xgafv", valid_580004
  var valid_580005 = query.getOrDefault("pageSize")
  valid_580005 = validateParameter(valid_580005, JInt, required = false, default = nil)
  if valid_580005 != nil:
    section.add "pageSize", valid_580005
  var valid_580006 = query.getOrDefault("prettyPrint")
  valid_580006 = validateParameter(valid_580006, JBool, required = false,
                                 default = newJBool(true))
  if valid_580006 != nil:
    section.add "prettyPrint", valid_580006
  var valid_580007 = query.getOrDefault("serviceFilter.service")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "serviceFilter.service", valid_580007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580008: Call_ClouderrorreportingProjectsEventsList_579986;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the specified events.
  ## 
  let valid = call_580008.validator(path, query, header, formData, body)
  let scheme = call_580008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580008.url(scheme.get, call_580008.host, call_580008.base,
                         call_580008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580008, url, valid)

proc call*(call_580009: Call_ClouderrorreportingProjectsEventsList_579986;
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
  var path_580010 = newJObject()
  var query_580011 = newJObject()
  add(query_580011, "upload_protocol", newJString(uploadProtocol))
  add(query_580011, "serviceFilter.resourceType",
      newJString(serviceFilterResourceType))
  add(query_580011, "serviceFilter.version", newJString(serviceFilterVersion))
  add(query_580011, "fields", newJString(fields))
  add(query_580011, "pageToken", newJString(pageToken))
  add(query_580011, "quotaUser", newJString(quotaUser))
  add(query_580011, "alt", newJString(alt))
  add(query_580011, "oauth_token", newJString(oauthToken))
  add(query_580011, "callback", newJString(callback))
  add(query_580011, "access_token", newJString(accessToken))
  add(query_580011, "uploadType", newJString(uploadType))
  add(query_580011, "timeRange.period", newJString(timeRangePeriod))
  add(query_580011, "groupId", newJString(groupId))
  add(query_580011, "key", newJString(key))
  add(path_580010, "projectName", newJString(projectName))
  add(query_580011, "$.xgafv", newJString(Xgafv))
  add(query_580011, "pageSize", newJInt(pageSize))
  add(query_580011, "prettyPrint", newJBool(prettyPrint))
  add(query_580011, "serviceFilter.service", newJString(serviceFilterService))
  result = call_580009.call(path_580010, query_580011, nil, nil, nil)

var clouderrorreportingProjectsEventsList* = Call_ClouderrorreportingProjectsEventsList_579986(
    name: "clouderrorreportingProjectsEventsList", meth: HttpMethod.HttpGet,
    host: "clouderrorreporting.googleapis.com",
    route: "/v1beta1/{projectName}/events",
    validator: validate_ClouderrorreportingProjectsEventsList_579987, base: "/",
    url: url_ClouderrorreportingProjectsEventsList_579988, schemes: {Scheme.Https})
type
  Call_ClouderrorreportingProjectsDeleteEvents_580012 = ref object of OpenApiRestCall_579408
proc url_ClouderrorreportingProjectsDeleteEvents_580014(protocol: Scheme;
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

proc validate_ClouderrorreportingProjectsDeleteEvents_580013(path: JsonNode;
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
  var valid_580015 = path.getOrDefault("projectName")
  valid_580015 = validateParameter(valid_580015, JString, required = true,
                                 default = nil)
  if valid_580015 != nil:
    section.add "projectName", valid_580015
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
  var valid_580016 = query.getOrDefault("upload_protocol")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "upload_protocol", valid_580016
  var valid_580017 = query.getOrDefault("fields")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "fields", valid_580017
  var valid_580018 = query.getOrDefault("quotaUser")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "quotaUser", valid_580018
  var valid_580019 = query.getOrDefault("alt")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = newJString("json"))
  if valid_580019 != nil:
    section.add "alt", valid_580019
  var valid_580020 = query.getOrDefault("oauth_token")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "oauth_token", valid_580020
  var valid_580021 = query.getOrDefault("callback")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "callback", valid_580021
  var valid_580022 = query.getOrDefault("access_token")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "access_token", valid_580022
  var valid_580023 = query.getOrDefault("uploadType")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "uploadType", valid_580023
  var valid_580024 = query.getOrDefault("key")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "key", valid_580024
  var valid_580025 = query.getOrDefault("$.xgafv")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = newJString("1"))
  if valid_580025 != nil:
    section.add "$.xgafv", valid_580025
  var valid_580026 = query.getOrDefault("prettyPrint")
  valid_580026 = validateParameter(valid_580026, JBool, required = false,
                                 default = newJBool(true))
  if valid_580026 != nil:
    section.add "prettyPrint", valid_580026
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580027: Call_ClouderrorreportingProjectsDeleteEvents_580012;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all error events of a given project.
  ## 
  let valid = call_580027.validator(path, query, header, formData, body)
  let scheme = call_580027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580027.url(scheme.get, call_580027.host, call_580027.base,
                         call_580027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580027, url, valid)

proc call*(call_580028: Call_ClouderrorreportingProjectsDeleteEvents_580012;
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
  var path_580029 = newJObject()
  var query_580030 = newJObject()
  add(query_580030, "upload_protocol", newJString(uploadProtocol))
  add(query_580030, "fields", newJString(fields))
  add(query_580030, "quotaUser", newJString(quotaUser))
  add(query_580030, "alt", newJString(alt))
  add(query_580030, "oauth_token", newJString(oauthToken))
  add(query_580030, "callback", newJString(callback))
  add(query_580030, "access_token", newJString(accessToken))
  add(query_580030, "uploadType", newJString(uploadType))
  add(query_580030, "key", newJString(key))
  add(path_580029, "projectName", newJString(projectName))
  add(query_580030, "$.xgafv", newJString(Xgafv))
  add(query_580030, "prettyPrint", newJBool(prettyPrint))
  result = call_580028.call(path_580029, query_580030, nil, nil, nil)

var clouderrorreportingProjectsDeleteEvents* = Call_ClouderrorreportingProjectsDeleteEvents_580012(
    name: "clouderrorreportingProjectsDeleteEvents", meth: HttpMethod.HttpDelete,
    host: "clouderrorreporting.googleapis.com",
    route: "/v1beta1/{projectName}/events",
    validator: validate_ClouderrorreportingProjectsDeleteEvents_580013, base: "/",
    url: url_ClouderrorreportingProjectsDeleteEvents_580014,
    schemes: {Scheme.Https})
type
  Call_ClouderrorreportingProjectsEventsReport_580031 = ref object of OpenApiRestCall_579408
proc url_ClouderrorreportingProjectsEventsReport_580033(protocol: Scheme;
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

proc validate_ClouderrorreportingProjectsEventsReport_580032(path: JsonNode;
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
  var valid_580034 = path.getOrDefault("projectName")
  valid_580034 = validateParameter(valid_580034, JString, required = true,
                                 default = nil)
  if valid_580034 != nil:
    section.add "projectName", valid_580034
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
  var valid_580035 = query.getOrDefault("upload_protocol")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "upload_protocol", valid_580035
  var valid_580036 = query.getOrDefault("fields")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "fields", valid_580036
  var valid_580037 = query.getOrDefault("quotaUser")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "quotaUser", valid_580037
  var valid_580038 = query.getOrDefault("alt")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = newJString("json"))
  if valid_580038 != nil:
    section.add "alt", valid_580038
  var valid_580039 = query.getOrDefault("oauth_token")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "oauth_token", valid_580039
  var valid_580040 = query.getOrDefault("callback")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "callback", valid_580040
  var valid_580041 = query.getOrDefault("access_token")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "access_token", valid_580041
  var valid_580042 = query.getOrDefault("uploadType")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "uploadType", valid_580042
  var valid_580043 = query.getOrDefault("key")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "key", valid_580043
  var valid_580044 = query.getOrDefault("$.xgafv")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = newJString("1"))
  if valid_580044 != nil:
    section.add "$.xgafv", valid_580044
  var valid_580045 = query.getOrDefault("prettyPrint")
  valid_580045 = validateParameter(valid_580045, JBool, required = false,
                                 default = newJBool(true))
  if valid_580045 != nil:
    section.add "prettyPrint", valid_580045
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

proc call*(call_580047: Call_ClouderrorreportingProjectsEventsReport_580031;
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
  let valid = call_580047.validator(path, query, header, formData, body)
  let scheme = call_580047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580047.url(scheme.get, call_580047.host, call_580047.base,
                         call_580047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580047, url, valid)

proc call*(call_580048: Call_ClouderrorreportingProjectsEventsReport_580031;
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
  var path_580049 = newJObject()
  var query_580050 = newJObject()
  var body_580051 = newJObject()
  add(query_580050, "upload_protocol", newJString(uploadProtocol))
  add(query_580050, "fields", newJString(fields))
  add(query_580050, "quotaUser", newJString(quotaUser))
  add(query_580050, "alt", newJString(alt))
  add(query_580050, "oauth_token", newJString(oauthToken))
  add(query_580050, "callback", newJString(callback))
  add(query_580050, "access_token", newJString(accessToken))
  add(query_580050, "uploadType", newJString(uploadType))
  add(query_580050, "key", newJString(key))
  add(path_580049, "projectName", newJString(projectName))
  add(query_580050, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580051 = body
  add(query_580050, "prettyPrint", newJBool(prettyPrint))
  result = call_580048.call(path_580049, query_580050, nil, nil, body_580051)

var clouderrorreportingProjectsEventsReport* = Call_ClouderrorreportingProjectsEventsReport_580031(
    name: "clouderrorreportingProjectsEventsReport", meth: HttpMethod.HttpPost,
    host: "clouderrorreporting.googleapis.com",
    route: "/v1beta1/{projectName}/events:report",
    validator: validate_ClouderrorreportingProjectsEventsReport_580032, base: "/",
    url: url_ClouderrorreportingProjectsEventsReport_580033,
    schemes: {Scheme.Https})
type
  Call_ClouderrorreportingProjectsGroupStatsList_580052 = ref object of OpenApiRestCall_579408
proc url_ClouderrorreportingProjectsGroupStatsList_580054(protocol: Scheme;
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

proc validate_ClouderrorreportingProjectsGroupStatsList_580053(path: JsonNode;
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
  var valid_580055 = path.getOrDefault("projectName")
  valid_580055 = validateParameter(valid_580055, JString, required = true,
                                 default = nil)
  if valid_580055 != nil:
    section.add "projectName", valid_580055
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
  var valid_580056 = query.getOrDefault("upload_protocol")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "upload_protocol", valid_580056
  var valid_580057 = query.getOrDefault("serviceFilter.resourceType")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "serviceFilter.resourceType", valid_580057
  var valid_580058 = query.getOrDefault("serviceFilter.version")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "serviceFilter.version", valid_580058
  var valid_580059 = query.getOrDefault("fields")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "fields", valid_580059
  var valid_580060 = query.getOrDefault("pageToken")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "pageToken", valid_580060
  var valid_580061 = query.getOrDefault("quotaUser")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "quotaUser", valid_580061
  var valid_580062 = query.getOrDefault("alt")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = newJString("json"))
  if valid_580062 != nil:
    section.add "alt", valid_580062
  var valid_580063 = query.getOrDefault("timedCountDuration")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "timedCountDuration", valid_580063
  var valid_580064 = query.getOrDefault("order")
  valid_580064 = validateParameter(valid_580064, JString, required = false, default = newJString(
      "GROUP_ORDER_UNSPECIFIED"))
  if valid_580064 != nil:
    section.add "order", valid_580064
  var valid_580065 = query.getOrDefault("oauth_token")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "oauth_token", valid_580065
  var valid_580066 = query.getOrDefault("callback")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "callback", valid_580066
  var valid_580067 = query.getOrDefault("access_token")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "access_token", valid_580067
  var valid_580068 = query.getOrDefault("uploadType")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "uploadType", valid_580068
  var valid_580069 = query.getOrDefault("timeRange.period")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = newJString("PERIOD_UNSPECIFIED"))
  if valid_580069 != nil:
    section.add "timeRange.period", valid_580069
  var valid_580070 = query.getOrDefault("groupId")
  valid_580070 = validateParameter(valid_580070, JArray, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "groupId", valid_580070
  var valid_580071 = query.getOrDefault("key")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "key", valid_580071
  var valid_580072 = query.getOrDefault("alignmentTime")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "alignmentTime", valid_580072
  var valid_580073 = query.getOrDefault("$.xgafv")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = newJString("1"))
  if valid_580073 != nil:
    section.add "$.xgafv", valid_580073
  var valid_580074 = query.getOrDefault("pageSize")
  valid_580074 = validateParameter(valid_580074, JInt, required = false, default = nil)
  if valid_580074 != nil:
    section.add "pageSize", valid_580074
  var valid_580075 = query.getOrDefault("prettyPrint")
  valid_580075 = validateParameter(valid_580075, JBool, required = false,
                                 default = newJBool(true))
  if valid_580075 != nil:
    section.add "prettyPrint", valid_580075
  var valid_580076 = query.getOrDefault("alignment")
  valid_580076 = validateParameter(valid_580076, JString, required = false, default = newJString(
      "ERROR_COUNT_ALIGNMENT_UNSPECIFIED"))
  if valid_580076 != nil:
    section.add "alignment", valid_580076
  var valid_580077 = query.getOrDefault("serviceFilter.service")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "serviceFilter.service", valid_580077
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580078: Call_ClouderrorreportingProjectsGroupStatsList_580052;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the specified groups.
  ## 
  let valid = call_580078.validator(path, query, header, formData, body)
  let scheme = call_580078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580078.url(scheme.get, call_580078.host, call_580078.base,
                         call_580078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580078, url, valid)

proc call*(call_580079: Call_ClouderrorreportingProjectsGroupStatsList_580052;
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
  var path_580080 = newJObject()
  var query_580081 = newJObject()
  add(query_580081, "upload_protocol", newJString(uploadProtocol))
  add(query_580081, "serviceFilter.resourceType",
      newJString(serviceFilterResourceType))
  add(query_580081, "serviceFilter.version", newJString(serviceFilterVersion))
  add(query_580081, "fields", newJString(fields))
  add(query_580081, "pageToken", newJString(pageToken))
  add(query_580081, "quotaUser", newJString(quotaUser))
  add(query_580081, "alt", newJString(alt))
  add(query_580081, "timedCountDuration", newJString(timedCountDuration))
  add(query_580081, "order", newJString(order))
  add(query_580081, "oauth_token", newJString(oauthToken))
  add(query_580081, "callback", newJString(callback))
  add(query_580081, "access_token", newJString(accessToken))
  add(query_580081, "uploadType", newJString(uploadType))
  add(query_580081, "timeRange.period", newJString(timeRangePeriod))
  if groupId != nil:
    query_580081.add "groupId", groupId
  add(query_580081, "key", newJString(key))
  add(query_580081, "alignmentTime", newJString(alignmentTime))
  add(path_580080, "projectName", newJString(projectName))
  add(query_580081, "$.xgafv", newJString(Xgafv))
  add(query_580081, "pageSize", newJInt(pageSize))
  add(query_580081, "prettyPrint", newJBool(prettyPrint))
  add(query_580081, "alignment", newJString(alignment))
  add(query_580081, "serviceFilter.service", newJString(serviceFilterService))
  result = call_580079.call(path_580080, query_580081, nil, nil, nil)

var clouderrorreportingProjectsGroupStatsList* = Call_ClouderrorreportingProjectsGroupStatsList_580052(
    name: "clouderrorreportingProjectsGroupStatsList", meth: HttpMethod.HttpGet,
    host: "clouderrorreporting.googleapis.com",
    route: "/v1beta1/{projectName}/groupStats",
    validator: validate_ClouderrorreportingProjectsGroupStatsList_580053,
    base: "/", url: url_ClouderrorreportingProjectsGroupStatsList_580054,
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
