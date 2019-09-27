
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_597408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597408): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ClouderrorreportingProjectsGroupsGet_597677 = ref object of OpenApiRestCall_597408
proc url_ClouderrorreportingProjectsGroupsGet_597679(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupName" in path, "`groupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "groupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClouderrorreportingProjectsGroupsGet_597678(path: JsonNode;
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
  var valid_597805 = path.getOrDefault("groupName")
  valid_597805 = validateParameter(valid_597805, JString, required = true,
                                 default = nil)
  if valid_597805 != nil:
    section.add "groupName", valid_597805
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
  var valid_597806 = query.getOrDefault("upload_protocol")
  valid_597806 = validateParameter(valid_597806, JString, required = false,
                                 default = nil)
  if valid_597806 != nil:
    section.add "upload_protocol", valid_597806
  var valid_597807 = query.getOrDefault("fields")
  valid_597807 = validateParameter(valid_597807, JString, required = false,
                                 default = nil)
  if valid_597807 != nil:
    section.add "fields", valid_597807
  var valid_597808 = query.getOrDefault("quotaUser")
  valid_597808 = validateParameter(valid_597808, JString, required = false,
                                 default = nil)
  if valid_597808 != nil:
    section.add "quotaUser", valid_597808
  var valid_597822 = query.getOrDefault("alt")
  valid_597822 = validateParameter(valid_597822, JString, required = false,
                                 default = newJString("json"))
  if valid_597822 != nil:
    section.add "alt", valid_597822
  var valid_597823 = query.getOrDefault("oauth_token")
  valid_597823 = validateParameter(valid_597823, JString, required = false,
                                 default = nil)
  if valid_597823 != nil:
    section.add "oauth_token", valid_597823
  var valid_597824 = query.getOrDefault("callback")
  valid_597824 = validateParameter(valid_597824, JString, required = false,
                                 default = nil)
  if valid_597824 != nil:
    section.add "callback", valid_597824
  var valid_597825 = query.getOrDefault("access_token")
  valid_597825 = validateParameter(valid_597825, JString, required = false,
                                 default = nil)
  if valid_597825 != nil:
    section.add "access_token", valid_597825
  var valid_597826 = query.getOrDefault("uploadType")
  valid_597826 = validateParameter(valid_597826, JString, required = false,
                                 default = nil)
  if valid_597826 != nil:
    section.add "uploadType", valid_597826
  var valid_597827 = query.getOrDefault("key")
  valid_597827 = validateParameter(valid_597827, JString, required = false,
                                 default = nil)
  if valid_597827 != nil:
    section.add "key", valid_597827
  var valid_597828 = query.getOrDefault("$.xgafv")
  valid_597828 = validateParameter(valid_597828, JString, required = false,
                                 default = newJString("1"))
  if valid_597828 != nil:
    section.add "$.xgafv", valid_597828
  var valid_597829 = query.getOrDefault("prettyPrint")
  valid_597829 = validateParameter(valid_597829, JBool, required = false,
                                 default = newJBool(true))
  if valid_597829 != nil:
    section.add "prettyPrint", valid_597829
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597852: Call_ClouderrorreportingProjectsGroupsGet_597677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the specified group.
  ## 
  let valid = call_597852.validator(path, query, header, formData, body)
  let scheme = call_597852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597852.url(scheme.get, call_597852.host, call_597852.base,
                         call_597852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597852, url, valid)

proc call*(call_597923: Call_ClouderrorreportingProjectsGroupsGet_597677;
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
  var path_597924 = newJObject()
  var query_597926 = newJObject()
  add(query_597926, "upload_protocol", newJString(uploadProtocol))
  add(query_597926, "fields", newJString(fields))
  add(query_597926, "quotaUser", newJString(quotaUser))
  add(query_597926, "alt", newJString(alt))
  add(query_597926, "oauth_token", newJString(oauthToken))
  add(query_597926, "callback", newJString(callback))
  add(query_597926, "access_token", newJString(accessToken))
  add(query_597926, "uploadType", newJString(uploadType))
  add(path_597924, "groupName", newJString(groupName))
  add(query_597926, "key", newJString(key))
  add(query_597926, "$.xgafv", newJString(Xgafv))
  add(query_597926, "prettyPrint", newJBool(prettyPrint))
  result = call_597923.call(path_597924, query_597926, nil, nil, nil)

var clouderrorreportingProjectsGroupsGet* = Call_ClouderrorreportingProjectsGroupsGet_597677(
    name: "clouderrorreportingProjectsGroupsGet", meth: HttpMethod.HttpGet,
    host: "clouderrorreporting.googleapis.com", route: "/v1beta1/{groupName}",
    validator: validate_ClouderrorreportingProjectsGroupsGet_597678, base: "/",
    url: url_ClouderrorreportingProjectsGroupsGet_597679, schemes: {Scheme.Https})
type
  Call_ClouderrorreportingProjectsGroupsUpdate_597965 = ref object of OpenApiRestCall_597408
proc url_ClouderrorreportingProjectsGroupsUpdate_597967(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClouderrorreportingProjectsGroupsUpdate_597966(path: JsonNode;
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
  var valid_597968 = path.getOrDefault("name")
  valid_597968 = validateParameter(valid_597968, JString, required = true,
                                 default = nil)
  if valid_597968 != nil:
    section.add "name", valid_597968
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
  var valid_597969 = query.getOrDefault("upload_protocol")
  valid_597969 = validateParameter(valid_597969, JString, required = false,
                                 default = nil)
  if valid_597969 != nil:
    section.add "upload_protocol", valid_597969
  var valid_597970 = query.getOrDefault("fields")
  valid_597970 = validateParameter(valid_597970, JString, required = false,
                                 default = nil)
  if valid_597970 != nil:
    section.add "fields", valid_597970
  var valid_597971 = query.getOrDefault("quotaUser")
  valid_597971 = validateParameter(valid_597971, JString, required = false,
                                 default = nil)
  if valid_597971 != nil:
    section.add "quotaUser", valid_597971
  var valid_597972 = query.getOrDefault("alt")
  valid_597972 = validateParameter(valid_597972, JString, required = false,
                                 default = newJString("json"))
  if valid_597972 != nil:
    section.add "alt", valid_597972
  var valid_597973 = query.getOrDefault("oauth_token")
  valid_597973 = validateParameter(valid_597973, JString, required = false,
                                 default = nil)
  if valid_597973 != nil:
    section.add "oauth_token", valid_597973
  var valid_597974 = query.getOrDefault("callback")
  valid_597974 = validateParameter(valid_597974, JString, required = false,
                                 default = nil)
  if valid_597974 != nil:
    section.add "callback", valid_597974
  var valid_597975 = query.getOrDefault("access_token")
  valid_597975 = validateParameter(valid_597975, JString, required = false,
                                 default = nil)
  if valid_597975 != nil:
    section.add "access_token", valid_597975
  var valid_597976 = query.getOrDefault("uploadType")
  valid_597976 = validateParameter(valid_597976, JString, required = false,
                                 default = nil)
  if valid_597976 != nil:
    section.add "uploadType", valid_597976
  var valid_597977 = query.getOrDefault("key")
  valid_597977 = validateParameter(valid_597977, JString, required = false,
                                 default = nil)
  if valid_597977 != nil:
    section.add "key", valid_597977
  var valid_597978 = query.getOrDefault("$.xgafv")
  valid_597978 = validateParameter(valid_597978, JString, required = false,
                                 default = newJString("1"))
  if valid_597978 != nil:
    section.add "$.xgafv", valid_597978
  var valid_597979 = query.getOrDefault("prettyPrint")
  valid_597979 = validateParameter(valid_597979, JBool, required = false,
                                 default = newJBool(true))
  if valid_597979 != nil:
    section.add "prettyPrint", valid_597979
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

proc call*(call_597981: Call_ClouderrorreportingProjectsGroupsUpdate_597965;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Replace the data for the specified group.
  ## Fails if the group does not exist.
  ## 
  let valid = call_597981.validator(path, query, header, formData, body)
  let scheme = call_597981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597981.url(scheme.get, call_597981.host, call_597981.base,
                         call_597981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597981, url, valid)

proc call*(call_597982: Call_ClouderrorreportingProjectsGroupsUpdate_597965;
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
  var path_597983 = newJObject()
  var query_597984 = newJObject()
  var body_597985 = newJObject()
  add(query_597984, "upload_protocol", newJString(uploadProtocol))
  add(query_597984, "fields", newJString(fields))
  add(query_597984, "quotaUser", newJString(quotaUser))
  add(path_597983, "name", newJString(name))
  add(query_597984, "alt", newJString(alt))
  add(query_597984, "oauth_token", newJString(oauthToken))
  add(query_597984, "callback", newJString(callback))
  add(query_597984, "access_token", newJString(accessToken))
  add(query_597984, "uploadType", newJString(uploadType))
  add(query_597984, "key", newJString(key))
  add(query_597984, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_597985 = body
  add(query_597984, "prettyPrint", newJBool(prettyPrint))
  result = call_597982.call(path_597983, query_597984, nil, nil, body_597985)

var clouderrorreportingProjectsGroupsUpdate* = Call_ClouderrorreportingProjectsGroupsUpdate_597965(
    name: "clouderrorreportingProjectsGroupsUpdate", meth: HttpMethod.HttpPut,
    host: "clouderrorreporting.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_ClouderrorreportingProjectsGroupsUpdate_597966, base: "/",
    url: url_ClouderrorreportingProjectsGroupsUpdate_597967,
    schemes: {Scheme.Https})
type
  Call_ClouderrorreportingProjectsEventsList_597986 = ref object of OpenApiRestCall_597408
proc url_ClouderrorreportingProjectsEventsList_597988(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClouderrorreportingProjectsEventsList_597987(path: JsonNode;
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
  var valid_597989 = path.getOrDefault("projectName")
  valid_597989 = validateParameter(valid_597989, JString, required = true,
                                 default = nil)
  if valid_597989 != nil:
    section.add "projectName", valid_597989
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
  var valid_597990 = query.getOrDefault("upload_protocol")
  valid_597990 = validateParameter(valid_597990, JString, required = false,
                                 default = nil)
  if valid_597990 != nil:
    section.add "upload_protocol", valid_597990
  var valid_597991 = query.getOrDefault("serviceFilter.resourceType")
  valid_597991 = validateParameter(valid_597991, JString, required = false,
                                 default = nil)
  if valid_597991 != nil:
    section.add "serviceFilter.resourceType", valid_597991
  var valid_597992 = query.getOrDefault("serviceFilter.version")
  valid_597992 = validateParameter(valid_597992, JString, required = false,
                                 default = nil)
  if valid_597992 != nil:
    section.add "serviceFilter.version", valid_597992
  var valid_597993 = query.getOrDefault("fields")
  valid_597993 = validateParameter(valid_597993, JString, required = false,
                                 default = nil)
  if valid_597993 != nil:
    section.add "fields", valid_597993
  var valid_597994 = query.getOrDefault("pageToken")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = nil)
  if valid_597994 != nil:
    section.add "pageToken", valid_597994
  var valid_597995 = query.getOrDefault("quotaUser")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = nil)
  if valid_597995 != nil:
    section.add "quotaUser", valid_597995
  var valid_597996 = query.getOrDefault("alt")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = newJString("json"))
  if valid_597996 != nil:
    section.add "alt", valid_597996
  var valid_597997 = query.getOrDefault("oauth_token")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = nil)
  if valid_597997 != nil:
    section.add "oauth_token", valid_597997
  var valid_597998 = query.getOrDefault("callback")
  valid_597998 = validateParameter(valid_597998, JString, required = false,
                                 default = nil)
  if valid_597998 != nil:
    section.add "callback", valid_597998
  var valid_597999 = query.getOrDefault("access_token")
  valid_597999 = validateParameter(valid_597999, JString, required = false,
                                 default = nil)
  if valid_597999 != nil:
    section.add "access_token", valid_597999
  var valid_598000 = query.getOrDefault("uploadType")
  valid_598000 = validateParameter(valid_598000, JString, required = false,
                                 default = nil)
  if valid_598000 != nil:
    section.add "uploadType", valid_598000
  var valid_598001 = query.getOrDefault("timeRange.period")
  valid_598001 = validateParameter(valid_598001, JString, required = false,
                                 default = newJString("PERIOD_UNSPECIFIED"))
  if valid_598001 != nil:
    section.add "timeRange.period", valid_598001
  var valid_598002 = query.getOrDefault("groupId")
  valid_598002 = validateParameter(valid_598002, JString, required = false,
                                 default = nil)
  if valid_598002 != nil:
    section.add "groupId", valid_598002
  var valid_598003 = query.getOrDefault("key")
  valid_598003 = validateParameter(valid_598003, JString, required = false,
                                 default = nil)
  if valid_598003 != nil:
    section.add "key", valid_598003
  var valid_598004 = query.getOrDefault("$.xgafv")
  valid_598004 = validateParameter(valid_598004, JString, required = false,
                                 default = newJString("1"))
  if valid_598004 != nil:
    section.add "$.xgafv", valid_598004
  var valid_598005 = query.getOrDefault("pageSize")
  valid_598005 = validateParameter(valid_598005, JInt, required = false, default = nil)
  if valid_598005 != nil:
    section.add "pageSize", valid_598005
  var valid_598006 = query.getOrDefault("prettyPrint")
  valid_598006 = validateParameter(valid_598006, JBool, required = false,
                                 default = newJBool(true))
  if valid_598006 != nil:
    section.add "prettyPrint", valid_598006
  var valid_598007 = query.getOrDefault("serviceFilter.service")
  valid_598007 = validateParameter(valid_598007, JString, required = false,
                                 default = nil)
  if valid_598007 != nil:
    section.add "serviceFilter.service", valid_598007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598008: Call_ClouderrorreportingProjectsEventsList_597986;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the specified events.
  ## 
  let valid = call_598008.validator(path, query, header, formData, body)
  let scheme = call_598008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598008.url(scheme.get, call_598008.host, call_598008.base,
                         call_598008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598008, url, valid)

proc call*(call_598009: Call_ClouderrorreportingProjectsEventsList_597986;
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
  var path_598010 = newJObject()
  var query_598011 = newJObject()
  add(query_598011, "upload_protocol", newJString(uploadProtocol))
  add(query_598011, "serviceFilter.resourceType",
      newJString(serviceFilterResourceType))
  add(query_598011, "serviceFilter.version", newJString(serviceFilterVersion))
  add(query_598011, "fields", newJString(fields))
  add(query_598011, "pageToken", newJString(pageToken))
  add(query_598011, "quotaUser", newJString(quotaUser))
  add(query_598011, "alt", newJString(alt))
  add(query_598011, "oauth_token", newJString(oauthToken))
  add(query_598011, "callback", newJString(callback))
  add(query_598011, "access_token", newJString(accessToken))
  add(query_598011, "uploadType", newJString(uploadType))
  add(query_598011, "timeRange.period", newJString(timeRangePeriod))
  add(query_598011, "groupId", newJString(groupId))
  add(query_598011, "key", newJString(key))
  add(path_598010, "projectName", newJString(projectName))
  add(query_598011, "$.xgafv", newJString(Xgafv))
  add(query_598011, "pageSize", newJInt(pageSize))
  add(query_598011, "prettyPrint", newJBool(prettyPrint))
  add(query_598011, "serviceFilter.service", newJString(serviceFilterService))
  result = call_598009.call(path_598010, query_598011, nil, nil, nil)

var clouderrorreportingProjectsEventsList* = Call_ClouderrorreportingProjectsEventsList_597986(
    name: "clouderrorreportingProjectsEventsList", meth: HttpMethod.HttpGet,
    host: "clouderrorreporting.googleapis.com",
    route: "/v1beta1/{projectName}/events",
    validator: validate_ClouderrorreportingProjectsEventsList_597987, base: "/",
    url: url_ClouderrorreportingProjectsEventsList_597988, schemes: {Scheme.Https})
type
  Call_ClouderrorreportingProjectsDeleteEvents_598012 = ref object of OpenApiRestCall_597408
proc url_ClouderrorreportingProjectsDeleteEvents_598014(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClouderrorreportingProjectsDeleteEvents_598013(path: JsonNode;
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
  var valid_598015 = path.getOrDefault("projectName")
  valid_598015 = validateParameter(valid_598015, JString, required = true,
                                 default = nil)
  if valid_598015 != nil:
    section.add "projectName", valid_598015
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
  var valid_598016 = query.getOrDefault("upload_protocol")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = nil)
  if valid_598016 != nil:
    section.add "upload_protocol", valid_598016
  var valid_598017 = query.getOrDefault("fields")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "fields", valid_598017
  var valid_598018 = query.getOrDefault("quotaUser")
  valid_598018 = validateParameter(valid_598018, JString, required = false,
                                 default = nil)
  if valid_598018 != nil:
    section.add "quotaUser", valid_598018
  var valid_598019 = query.getOrDefault("alt")
  valid_598019 = validateParameter(valid_598019, JString, required = false,
                                 default = newJString("json"))
  if valid_598019 != nil:
    section.add "alt", valid_598019
  var valid_598020 = query.getOrDefault("oauth_token")
  valid_598020 = validateParameter(valid_598020, JString, required = false,
                                 default = nil)
  if valid_598020 != nil:
    section.add "oauth_token", valid_598020
  var valid_598021 = query.getOrDefault("callback")
  valid_598021 = validateParameter(valid_598021, JString, required = false,
                                 default = nil)
  if valid_598021 != nil:
    section.add "callback", valid_598021
  var valid_598022 = query.getOrDefault("access_token")
  valid_598022 = validateParameter(valid_598022, JString, required = false,
                                 default = nil)
  if valid_598022 != nil:
    section.add "access_token", valid_598022
  var valid_598023 = query.getOrDefault("uploadType")
  valid_598023 = validateParameter(valid_598023, JString, required = false,
                                 default = nil)
  if valid_598023 != nil:
    section.add "uploadType", valid_598023
  var valid_598024 = query.getOrDefault("key")
  valid_598024 = validateParameter(valid_598024, JString, required = false,
                                 default = nil)
  if valid_598024 != nil:
    section.add "key", valid_598024
  var valid_598025 = query.getOrDefault("$.xgafv")
  valid_598025 = validateParameter(valid_598025, JString, required = false,
                                 default = newJString("1"))
  if valid_598025 != nil:
    section.add "$.xgafv", valid_598025
  var valid_598026 = query.getOrDefault("prettyPrint")
  valid_598026 = validateParameter(valid_598026, JBool, required = false,
                                 default = newJBool(true))
  if valid_598026 != nil:
    section.add "prettyPrint", valid_598026
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598027: Call_ClouderrorreportingProjectsDeleteEvents_598012;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all error events of a given project.
  ## 
  let valid = call_598027.validator(path, query, header, formData, body)
  let scheme = call_598027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598027.url(scheme.get, call_598027.host, call_598027.base,
                         call_598027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598027, url, valid)

proc call*(call_598028: Call_ClouderrorreportingProjectsDeleteEvents_598012;
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
  var path_598029 = newJObject()
  var query_598030 = newJObject()
  add(query_598030, "upload_protocol", newJString(uploadProtocol))
  add(query_598030, "fields", newJString(fields))
  add(query_598030, "quotaUser", newJString(quotaUser))
  add(query_598030, "alt", newJString(alt))
  add(query_598030, "oauth_token", newJString(oauthToken))
  add(query_598030, "callback", newJString(callback))
  add(query_598030, "access_token", newJString(accessToken))
  add(query_598030, "uploadType", newJString(uploadType))
  add(query_598030, "key", newJString(key))
  add(path_598029, "projectName", newJString(projectName))
  add(query_598030, "$.xgafv", newJString(Xgafv))
  add(query_598030, "prettyPrint", newJBool(prettyPrint))
  result = call_598028.call(path_598029, query_598030, nil, nil, nil)

var clouderrorreportingProjectsDeleteEvents* = Call_ClouderrorreportingProjectsDeleteEvents_598012(
    name: "clouderrorreportingProjectsDeleteEvents", meth: HttpMethod.HttpDelete,
    host: "clouderrorreporting.googleapis.com",
    route: "/v1beta1/{projectName}/events",
    validator: validate_ClouderrorreportingProjectsDeleteEvents_598013, base: "/",
    url: url_ClouderrorreportingProjectsDeleteEvents_598014,
    schemes: {Scheme.Https})
type
  Call_ClouderrorreportingProjectsEventsReport_598031 = ref object of OpenApiRestCall_597408
proc url_ClouderrorreportingProjectsEventsReport_598033(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClouderrorreportingProjectsEventsReport_598032(path: JsonNode;
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
  var valid_598034 = path.getOrDefault("projectName")
  valid_598034 = validateParameter(valid_598034, JString, required = true,
                                 default = nil)
  if valid_598034 != nil:
    section.add "projectName", valid_598034
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
  var valid_598035 = query.getOrDefault("upload_protocol")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = nil)
  if valid_598035 != nil:
    section.add "upload_protocol", valid_598035
  var valid_598036 = query.getOrDefault("fields")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = nil)
  if valid_598036 != nil:
    section.add "fields", valid_598036
  var valid_598037 = query.getOrDefault("quotaUser")
  valid_598037 = validateParameter(valid_598037, JString, required = false,
                                 default = nil)
  if valid_598037 != nil:
    section.add "quotaUser", valid_598037
  var valid_598038 = query.getOrDefault("alt")
  valid_598038 = validateParameter(valid_598038, JString, required = false,
                                 default = newJString("json"))
  if valid_598038 != nil:
    section.add "alt", valid_598038
  var valid_598039 = query.getOrDefault("oauth_token")
  valid_598039 = validateParameter(valid_598039, JString, required = false,
                                 default = nil)
  if valid_598039 != nil:
    section.add "oauth_token", valid_598039
  var valid_598040 = query.getOrDefault("callback")
  valid_598040 = validateParameter(valid_598040, JString, required = false,
                                 default = nil)
  if valid_598040 != nil:
    section.add "callback", valid_598040
  var valid_598041 = query.getOrDefault("access_token")
  valid_598041 = validateParameter(valid_598041, JString, required = false,
                                 default = nil)
  if valid_598041 != nil:
    section.add "access_token", valid_598041
  var valid_598042 = query.getOrDefault("uploadType")
  valid_598042 = validateParameter(valid_598042, JString, required = false,
                                 default = nil)
  if valid_598042 != nil:
    section.add "uploadType", valid_598042
  var valid_598043 = query.getOrDefault("key")
  valid_598043 = validateParameter(valid_598043, JString, required = false,
                                 default = nil)
  if valid_598043 != nil:
    section.add "key", valid_598043
  var valid_598044 = query.getOrDefault("$.xgafv")
  valid_598044 = validateParameter(valid_598044, JString, required = false,
                                 default = newJString("1"))
  if valid_598044 != nil:
    section.add "$.xgafv", valid_598044
  var valid_598045 = query.getOrDefault("prettyPrint")
  valid_598045 = validateParameter(valid_598045, JBool, required = false,
                                 default = newJBool(true))
  if valid_598045 != nil:
    section.add "prettyPrint", valid_598045
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

proc call*(call_598047: Call_ClouderrorreportingProjectsEventsReport_598031;
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
  let valid = call_598047.validator(path, query, header, formData, body)
  let scheme = call_598047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598047.url(scheme.get, call_598047.host, call_598047.base,
                         call_598047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598047, url, valid)

proc call*(call_598048: Call_ClouderrorreportingProjectsEventsReport_598031;
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
  var path_598049 = newJObject()
  var query_598050 = newJObject()
  var body_598051 = newJObject()
  add(query_598050, "upload_protocol", newJString(uploadProtocol))
  add(query_598050, "fields", newJString(fields))
  add(query_598050, "quotaUser", newJString(quotaUser))
  add(query_598050, "alt", newJString(alt))
  add(query_598050, "oauth_token", newJString(oauthToken))
  add(query_598050, "callback", newJString(callback))
  add(query_598050, "access_token", newJString(accessToken))
  add(query_598050, "uploadType", newJString(uploadType))
  add(query_598050, "key", newJString(key))
  add(path_598049, "projectName", newJString(projectName))
  add(query_598050, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598051 = body
  add(query_598050, "prettyPrint", newJBool(prettyPrint))
  result = call_598048.call(path_598049, query_598050, nil, nil, body_598051)

var clouderrorreportingProjectsEventsReport* = Call_ClouderrorreportingProjectsEventsReport_598031(
    name: "clouderrorreportingProjectsEventsReport", meth: HttpMethod.HttpPost,
    host: "clouderrorreporting.googleapis.com",
    route: "/v1beta1/{projectName}/events:report",
    validator: validate_ClouderrorreportingProjectsEventsReport_598032, base: "/",
    url: url_ClouderrorreportingProjectsEventsReport_598033,
    schemes: {Scheme.Https})
type
  Call_ClouderrorreportingProjectsGroupStatsList_598052 = ref object of OpenApiRestCall_597408
proc url_ClouderrorreportingProjectsGroupStatsList_598054(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClouderrorreportingProjectsGroupStatsList_598053(path: JsonNode;
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
  var valid_598055 = path.getOrDefault("projectName")
  valid_598055 = validateParameter(valid_598055, JString, required = true,
                                 default = nil)
  if valid_598055 != nil:
    section.add "projectName", valid_598055
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
  var valid_598056 = query.getOrDefault("upload_protocol")
  valid_598056 = validateParameter(valid_598056, JString, required = false,
                                 default = nil)
  if valid_598056 != nil:
    section.add "upload_protocol", valid_598056
  var valid_598057 = query.getOrDefault("serviceFilter.resourceType")
  valid_598057 = validateParameter(valid_598057, JString, required = false,
                                 default = nil)
  if valid_598057 != nil:
    section.add "serviceFilter.resourceType", valid_598057
  var valid_598058 = query.getOrDefault("serviceFilter.version")
  valid_598058 = validateParameter(valid_598058, JString, required = false,
                                 default = nil)
  if valid_598058 != nil:
    section.add "serviceFilter.version", valid_598058
  var valid_598059 = query.getOrDefault("fields")
  valid_598059 = validateParameter(valid_598059, JString, required = false,
                                 default = nil)
  if valid_598059 != nil:
    section.add "fields", valid_598059
  var valid_598060 = query.getOrDefault("pageToken")
  valid_598060 = validateParameter(valid_598060, JString, required = false,
                                 default = nil)
  if valid_598060 != nil:
    section.add "pageToken", valid_598060
  var valid_598061 = query.getOrDefault("quotaUser")
  valid_598061 = validateParameter(valid_598061, JString, required = false,
                                 default = nil)
  if valid_598061 != nil:
    section.add "quotaUser", valid_598061
  var valid_598062 = query.getOrDefault("alt")
  valid_598062 = validateParameter(valid_598062, JString, required = false,
                                 default = newJString("json"))
  if valid_598062 != nil:
    section.add "alt", valid_598062
  var valid_598063 = query.getOrDefault("timedCountDuration")
  valid_598063 = validateParameter(valid_598063, JString, required = false,
                                 default = nil)
  if valid_598063 != nil:
    section.add "timedCountDuration", valid_598063
  var valid_598064 = query.getOrDefault("order")
  valid_598064 = validateParameter(valid_598064, JString, required = false, default = newJString(
      "GROUP_ORDER_UNSPECIFIED"))
  if valid_598064 != nil:
    section.add "order", valid_598064
  var valid_598065 = query.getOrDefault("oauth_token")
  valid_598065 = validateParameter(valid_598065, JString, required = false,
                                 default = nil)
  if valid_598065 != nil:
    section.add "oauth_token", valid_598065
  var valid_598066 = query.getOrDefault("callback")
  valid_598066 = validateParameter(valid_598066, JString, required = false,
                                 default = nil)
  if valid_598066 != nil:
    section.add "callback", valid_598066
  var valid_598067 = query.getOrDefault("access_token")
  valid_598067 = validateParameter(valid_598067, JString, required = false,
                                 default = nil)
  if valid_598067 != nil:
    section.add "access_token", valid_598067
  var valid_598068 = query.getOrDefault("uploadType")
  valid_598068 = validateParameter(valid_598068, JString, required = false,
                                 default = nil)
  if valid_598068 != nil:
    section.add "uploadType", valid_598068
  var valid_598069 = query.getOrDefault("timeRange.period")
  valid_598069 = validateParameter(valid_598069, JString, required = false,
                                 default = newJString("PERIOD_UNSPECIFIED"))
  if valid_598069 != nil:
    section.add "timeRange.period", valid_598069
  var valid_598070 = query.getOrDefault("groupId")
  valid_598070 = validateParameter(valid_598070, JArray, required = false,
                                 default = nil)
  if valid_598070 != nil:
    section.add "groupId", valid_598070
  var valid_598071 = query.getOrDefault("key")
  valid_598071 = validateParameter(valid_598071, JString, required = false,
                                 default = nil)
  if valid_598071 != nil:
    section.add "key", valid_598071
  var valid_598072 = query.getOrDefault("alignmentTime")
  valid_598072 = validateParameter(valid_598072, JString, required = false,
                                 default = nil)
  if valid_598072 != nil:
    section.add "alignmentTime", valid_598072
  var valid_598073 = query.getOrDefault("$.xgafv")
  valid_598073 = validateParameter(valid_598073, JString, required = false,
                                 default = newJString("1"))
  if valid_598073 != nil:
    section.add "$.xgafv", valid_598073
  var valid_598074 = query.getOrDefault("pageSize")
  valid_598074 = validateParameter(valid_598074, JInt, required = false, default = nil)
  if valid_598074 != nil:
    section.add "pageSize", valid_598074
  var valid_598075 = query.getOrDefault("prettyPrint")
  valid_598075 = validateParameter(valid_598075, JBool, required = false,
                                 default = newJBool(true))
  if valid_598075 != nil:
    section.add "prettyPrint", valid_598075
  var valid_598076 = query.getOrDefault("alignment")
  valid_598076 = validateParameter(valid_598076, JString, required = false, default = newJString(
      "ERROR_COUNT_ALIGNMENT_UNSPECIFIED"))
  if valid_598076 != nil:
    section.add "alignment", valid_598076
  var valid_598077 = query.getOrDefault("serviceFilter.service")
  valid_598077 = validateParameter(valid_598077, JString, required = false,
                                 default = nil)
  if valid_598077 != nil:
    section.add "serviceFilter.service", valid_598077
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598078: Call_ClouderrorreportingProjectsGroupStatsList_598052;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the specified groups.
  ## 
  let valid = call_598078.validator(path, query, header, formData, body)
  let scheme = call_598078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598078.url(scheme.get, call_598078.host, call_598078.base,
                         call_598078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598078, url, valid)

proc call*(call_598079: Call_ClouderrorreportingProjectsGroupStatsList_598052;
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
  var path_598080 = newJObject()
  var query_598081 = newJObject()
  add(query_598081, "upload_protocol", newJString(uploadProtocol))
  add(query_598081, "serviceFilter.resourceType",
      newJString(serviceFilterResourceType))
  add(query_598081, "serviceFilter.version", newJString(serviceFilterVersion))
  add(query_598081, "fields", newJString(fields))
  add(query_598081, "pageToken", newJString(pageToken))
  add(query_598081, "quotaUser", newJString(quotaUser))
  add(query_598081, "alt", newJString(alt))
  add(query_598081, "timedCountDuration", newJString(timedCountDuration))
  add(query_598081, "order", newJString(order))
  add(query_598081, "oauth_token", newJString(oauthToken))
  add(query_598081, "callback", newJString(callback))
  add(query_598081, "access_token", newJString(accessToken))
  add(query_598081, "uploadType", newJString(uploadType))
  add(query_598081, "timeRange.period", newJString(timeRangePeriod))
  if groupId != nil:
    query_598081.add "groupId", groupId
  add(query_598081, "key", newJString(key))
  add(query_598081, "alignmentTime", newJString(alignmentTime))
  add(path_598080, "projectName", newJString(projectName))
  add(query_598081, "$.xgafv", newJString(Xgafv))
  add(query_598081, "pageSize", newJInt(pageSize))
  add(query_598081, "prettyPrint", newJBool(prettyPrint))
  add(query_598081, "alignment", newJString(alignment))
  add(query_598081, "serviceFilter.service", newJString(serviceFilterService))
  result = call_598079.call(path_598080, query_598081, nil, nil, nil)

var clouderrorreportingProjectsGroupStatsList* = Call_ClouderrorreportingProjectsGroupStatsList_598052(
    name: "clouderrorreportingProjectsGroupStatsList", meth: HttpMethod.HttpGet,
    host: "clouderrorreporting.googleapis.com",
    route: "/v1beta1/{projectName}/groupStats",
    validator: validate_ClouderrorreportingProjectsGroupStatsList_598053,
    base: "/", url: url_ClouderrorreportingProjectsGroupStatsList_598054,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
