
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

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

  OpenApiRestCall_579364 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579364](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579364): Option[Scheme] {.used.} =
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
  Call_ClouderrorreportingProjectsGroupsGet_579635 = ref object of OpenApiRestCall_579364
proc url_ClouderrorreportingProjectsGroupsGet_579637(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ClouderrorreportingProjectsGroupsGet_579636(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the specified group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupName: JString (required)
  ##            : Required. The group resource name. Written as
  ## <code>projects/<var>projectID</var>/groups/<var>group_name</var></code>.
  ## Call
  ## <a href="/error-reporting/reference/rest/v1beta1/projects.groupStats/list">
  ## <code>groupStats.list</code></a> to return a list of groups belonging to
  ## this project.
  ## 
  ## Example: <code>projects/my-project-123/groups/my-group</code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupName` field"
  var valid_579763 = path.getOrDefault("groupName")
  valid_579763 = validateParameter(valid_579763, JString, required = true,
                                 default = nil)
  if valid_579763 != nil:
    section.add "groupName", valid_579763
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
  var valid_579764 = query.getOrDefault("key")
  valid_579764 = validateParameter(valid_579764, JString, required = false,
                                 default = nil)
  if valid_579764 != nil:
    section.add "key", valid_579764
  var valid_579778 = query.getOrDefault("prettyPrint")
  valid_579778 = validateParameter(valid_579778, JBool, required = false,
                                 default = newJBool(true))
  if valid_579778 != nil:
    section.add "prettyPrint", valid_579778
  var valid_579779 = query.getOrDefault("oauth_token")
  valid_579779 = validateParameter(valid_579779, JString, required = false,
                                 default = nil)
  if valid_579779 != nil:
    section.add "oauth_token", valid_579779
  var valid_579780 = query.getOrDefault("$.xgafv")
  valid_579780 = validateParameter(valid_579780, JString, required = false,
                                 default = newJString("1"))
  if valid_579780 != nil:
    section.add "$.xgafv", valid_579780
  var valid_579781 = query.getOrDefault("alt")
  valid_579781 = validateParameter(valid_579781, JString, required = false,
                                 default = newJString("json"))
  if valid_579781 != nil:
    section.add "alt", valid_579781
  var valid_579782 = query.getOrDefault("uploadType")
  valid_579782 = validateParameter(valid_579782, JString, required = false,
                                 default = nil)
  if valid_579782 != nil:
    section.add "uploadType", valid_579782
  var valid_579783 = query.getOrDefault("quotaUser")
  valid_579783 = validateParameter(valid_579783, JString, required = false,
                                 default = nil)
  if valid_579783 != nil:
    section.add "quotaUser", valid_579783
  var valid_579784 = query.getOrDefault("callback")
  valid_579784 = validateParameter(valid_579784, JString, required = false,
                                 default = nil)
  if valid_579784 != nil:
    section.add "callback", valid_579784
  var valid_579785 = query.getOrDefault("fields")
  valid_579785 = validateParameter(valid_579785, JString, required = false,
                                 default = nil)
  if valid_579785 != nil:
    section.add "fields", valid_579785
  var valid_579786 = query.getOrDefault("access_token")
  valid_579786 = validateParameter(valid_579786, JString, required = false,
                                 default = nil)
  if valid_579786 != nil:
    section.add "access_token", valid_579786
  var valid_579787 = query.getOrDefault("upload_protocol")
  valid_579787 = validateParameter(valid_579787, JString, required = false,
                                 default = nil)
  if valid_579787 != nil:
    section.add "upload_protocol", valid_579787
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579810: Call_ClouderrorreportingProjectsGroupsGet_579635;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the specified group.
  ## 
  let valid = call_579810.validator(path, query, header, formData, body)
  let scheme = call_579810.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579810.url(scheme.get, call_579810.host, call_579810.base,
                         call_579810.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579810, url, valid)

proc call*(call_579881: Call_ClouderrorreportingProjectsGroupsGet_579635;
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
  ##            : Required. The group resource name. Written as
  ## <code>projects/<var>projectID</var>/groups/<var>group_name</var></code>.
  ## Call
  ## <a href="/error-reporting/reference/rest/v1beta1/projects.groupStats/list">
  ## <code>groupStats.list</code></a> to return a list of groups belonging to
  ## this project.
  ## 
  ## Example: <code>projects/my-project-123/groups/my-group</code>
  var path_579882 = newJObject()
  var query_579884 = newJObject()
  add(query_579884, "key", newJString(key))
  add(query_579884, "prettyPrint", newJBool(prettyPrint))
  add(query_579884, "oauth_token", newJString(oauthToken))
  add(query_579884, "$.xgafv", newJString(Xgafv))
  add(query_579884, "alt", newJString(alt))
  add(query_579884, "uploadType", newJString(uploadType))
  add(query_579884, "quotaUser", newJString(quotaUser))
  add(query_579884, "callback", newJString(callback))
  add(query_579884, "fields", newJString(fields))
  add(query_579884, "access_token", newJString(accessToken))
  add(query_579884, "upload_protocol", newJString(uploadProtocol))
  add(path_579882, "groupName", newJString(groupName))
  result = call_579881.call(path_579882, query_579884, nil, nil, nil)

var clouderrorreportingProjectsGroupsGet* = Call_ClouderrorreportingProjectsGroupsGet_579635(
    name: "clouderrorreportingProjectsGroupsGet", meth: HttpMethod.HttpGet,
    host: "clouderrorreporting.googleapis.com", route: "/v1beta1/{groupName}",
    validator: validate_ClouderrorreportingProjectsGroupsGet_579636, base: "/",
    url: url_ClouderrorreportingProjectsGroupsGet_579637, schemes: {Scheme.Https})
type
  Call_ClouderrorreportingProjectsGroupsUpdate_579923 = ref object of OpenApiRestCall_579364
proc url_ClouderrorreportingProjectsGroupsUpdate_579925(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ClouderrorreportingProjectsGroupsUpdate_579924(path: JsonNode;
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
  var valid_579926 = path.getOrDefault("name")
  valid_579926 = validateParameter(valid_579926, JString, required = true,
                                 default = nil)
  if valid_579926 != nil:
    section.add "name", valid_579926
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
  var valid_579927 = query.getOrDefault("key")
  valid_579927 = validateParameter(valid_579927, JString, required = false,
                                 default = nil)
  if valid_579927 != nil:
    section.add "key", valid_579927
  var valid_579928 = query.getOrDefault("prettyPrint")
  valid_579928 = validateParameter(valid_579928, JBool, required = false,
                                 default = newJBool(true))
  if valid_579928 != nil:
    section.add "prettyPrint", valid_579928
  var valid_579929 = query.getOrDefault("oauth_token")
  valid_579929 = validateParameter(valid_579929, JString, required = false,
                                 default = nil)
  if valid_579929 != nil:
    section.add "oauth_token", valid_579929
  var valid_579930 = query.getOrDefault("$.xgafv")
  valid_579930 = validateParameter(valid_579930, JString, required = false,
                                 default = newJString("1"))
  if valid_579930 != nil:
    section.add "$.xgafv", valid_579930
  var valid_579931 = query.getOrDefault("alt")
  valid_579931 = validateParameter(valid_579931, JString, required = false,
                                 default = newJString("json"))
  if valid_579931 != nil:
    section.add "alt", valid_579931
  var valid_579932 = query.getOrDefault("uploadType")
  valid_579932 = validateParameter(valid_579932, JString, required = false,
                                 default = nil)
  if valid_579932 != nil:
    section.add "uploadType", valid_579932
  var valid_579933 = query.getOrDefault("quotaUser")
  valid_579933 = validateParameter(valid_579933, JString, required = false,
                                 default = nil)
  if valid_579933 != nil:
    section.add "quotaUser", valid_579933
  var valid_579934 = query.getOrDefault("callback")
  valid_579934 = validateParameter(valid_579934, JString, required = false,
                                 default = nil)
  if valid_579934 != nil:
    section.add "callback", valid_579934
  var valid_579935 = query.getOrDefault("fields")
  valid_579935 = validateParameter(valid_579935, JString, required = false,
                                 default = nil)
  if valid_579935 != nil:
    section.add "fields", valid_579935
  var valid_579936 = query.getOrDefault("access_token")
  valid_579936 = validateParameter(valid_579936, JString, required = false,
                                 default = nil)
  if valid_579936 != nil:
    section.add "access_token", valid_579936
  var valid_579937 = query.getOrDefault("upload_protocol")
  valid_579937 = validateParameter(valid_579937, JString, required = false,
                                 default = nil)
  if valid_579937 != nil:
    section.add "upload_protocol", valid_579937
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

proc call*(call_579939: Call_ClouderrorreportingProjectsGroupsUpdate_579923;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Replace the data for the specified group.
  ## Fails if the group does not exist.
  ## 
  let valid = call_579939.validator(path, query, header, formData, body)
  let scheme = call_579939.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579939.url(scheme.get, call_579939.host, call_579939.base,
                         call_579939.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579939, url, valid)

proc call*(call_579940: Call_ClouderrorreportingProjectsGroupsUpdate_579923;
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
  var path_579941 = newJObject()
  var query_579942 = newJObject()
  var body_579943 = newJObject()
  add(query_579942, "key", newJString(key))
  add(query_579942, "prettyPrint", newJBool(prettyPrint))
  add(query_579942, "oauth_token", newJString(oauthToken))
  add(query_579942, "$.xgafv", newJString(Xgafv))
  add(query_579942, "alt", newJString(alt))
  add(query_579942, "uploadType", newJString(uploadType))
  add(query_579942, "quotaUser", newJString(quotaUser))
  add(path_579941, "name", newJString(name))
  if body != nil:
    body_579943 = body
  add(query_579942, "callback", newJString(callback))
  add(query_579942, "fields", newJString(fields))
  add(query_579942, "access_token", newJString(accessToken))
  add(query_579942, "upload_protocol", newJString(uploadProtocol))
  result = call_579940.call(path_579941, query_579942, nil, nil, body_579943)

var clouderrorreportingProjectsGroupsUpdate* = Call_ClouderrorreportingProjectsGroupsUpdate_579923(
    name: "clouderrorreportingProjectsGroupsUpdate", meth: HttpMethod.HttpPut,
    host: "clouderrorreporting.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_ClouderrorreportingProjectsGroupsUpdate_579924, base: "/",
    url: url_ClouderrorreportingProjectsGroupsUpdate_579925,
    schemes: {Scheme.Https})
type
  Call_ClouderrorreportingProjectsEventsList_579944 = ref object of OpenApiRestCall_579364
proc url_ClouderrorreportingProjectsEventsList_579946(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ClouderrorreportingProjectsEventsList_579945(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the specified events.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectName: JString (required)
  ##              : Required. The resource name of the Google Cloud Platform project. Written
  ## as `projects/` plus the
  ## [Google Cloud Platform project
  ## ID](https://support.google.com/cloud/answer/6158840).
  ## Example: `projects/my-project-123`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `projectName` field"
  var valid_579947 = path.getOrDefault("projectName")
  valid_579947 = validateParameter(valid_579947, JString, required = true,
                                 default = nil)
  if valid_579947 != nil:
    section.add "projectName", valid_579947
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   serviceFilter.version: JString
  ##                        : Optional. The exact value to match against
  ## 
  ## [`ServiceContext.version`](/error-reporting/reference/rest/v1beta1/ServiceContext#FIELDS.version).
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional. The maximum number of results to return per response.
  ##   timeRange.period: JString
  ##                   : Restricts the query to the specified time range.
  ##   serviceFilter.resourceType: JString
  ##                             : Optional. The exact value to match against
  ## 
  ## [`ServiceContext.resource_type`](/error-reporting/reference/rest/v1beta1/ServiceContext#FIELDS.resource_type).
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Optional. A `next_page_token` provided by a previous response.
  ##   groupId: JString
  ##          : Required. The group for which events shall be returned.
  ##   serviceFilter.service: JString
  ##                        : Optional. The exact value to match against
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
  var valid_579948 = query.getOrDefault("key")
  valid_579948 = validateParameter(valid_579948, JString, required = false,
                                 default = nil)
  if valid_579948 != nil:
    section.add "key", valid_579948
  var valid_579949 = query.getOrDefault("prettyPrint")
  valid_579949 = validateParameter(valid_579949, JBool, required = false,
                                 default = newJBool(true))
  if valid_579949 != nil:
    section.add "prettyPrint", valid_579949
  var valid_579950 = query.getOrDefault("oauth_token")
  valid_579950 = validateParameter(valid_579950, JString, required = false,
                                 default = nil)
  if valid_579950 != nil:
    section.add "oauth_token", valid_579950
  var valid_579951 = query.getOrDefault("serviceFilter.version")
  valid_579951 = validateParameter(valid_579951, JString, required = false,
                                 default = nil)
  if valid_579951 != nil:
    section.add "serviceFilter.version", valid_579951
  var valid_579952 = query.getOrDefault("$.xgafv")
  valid_579952 = validateParameter(valid_579952, JString, required = false,
                                 default = newJString("1"))
  if valid_579952 != nil:
    section.add "$.xgafv", valid_579952
  var valid_579953 = query.getOrDefault("pageSize")
  valid_579953 = validateParameter(valid_579953, JInt, required = false, default = nil)
  if valid_579953 != nil:
    section.add "pageSize", valid_579953
  var valid_579954 = query.getOrDefault("timeRange.period")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = newJString("PERIOD_UNSPECIFIED"))
  if valid_579954 != nil:
    section.add "timeRange.period", valid_579954
  var valid_579955 = query.getOrDefault("serviceFilter.resourceType")
  valid_579955 = validateParameter(valid_579955, JString, required = false,
                                 default = nil)
  if valid_579955 != nil:
    section.add "serviceFilter.resourceType", valid_579955
  var valid_579956 = query.getOrDefault("alt")
  valid_579956 = validateParameter(valid_579956, JString, required = false,
                                 default = newJString("json"))
  if valid_579956 != nil:
    section.add "alt", valid_579956
  var valid_579957 = query.getOrDefault("uploadType")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = nil)
  if valid_579957 != nil:
    section.add "uploadType", valid_579957
  var valid_579958 = query.getOrDefault("quotaUser")
  valid_579958 = validateParameter(valid_579958, JString, required = false,
                                 default = nil)
  if valid_579958 != nil:
    section.add "quotaUser", valid_579958
  var valid_579959 = query.getOrDefault("pageToken")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = nil)
  if valid_579959 != nil:
    section.add "pageToken", valid_579959
  var valid_579960 = query.getOrDefault("groupId")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = nil)
  if valid_579960 != nil:
    section.add "groupId", valid_579960
  var valid_579961 = query.getOrDefault("serviceFilter.service")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = nil)
  if valid_579961 != nil:
    section.add "serviceFilter.service", valid_579961
  var valid_579962 = query.getOrDefault("callback")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "callback", valid_579962
  var valid_579963 = query.getOrDefault("fields")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = nil)
  if valid_579963 != nil:
    section.add "fields", valid_579963
  var valid_579964 = query.getOrDefault("access_token")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "access_token", valid_579964
  var valid_579965 = query.getOrDefault("upload_protocol")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "upload_protocol", valid_579965
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579966: Call_ClouderrorreportingProjectsEventsList_579944;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the specified events.
  ## 
  let valid = call_579966.validator(path, query, header, formData, body)
  let scheme = call_579966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579966.url(scheme.get, call_579966.host, call_579966.base,
                         call_579966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579966, url, valid)

proc call*(call_579967: Call_ClouderrorreportingProjectsEventsList_579944;
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
  ##                       : Optional. The exact value to match against
  ## 
  ## [`ServiceContext.version`](/error-reporting/reference/rest/v1beta1/ServiceContext#FIELDS.version).
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The maximum number of results to return per response.
  ##   timeRangePeriod: string
  ##                  : Restricts the query to the specified time range.
  ##   serviceFilterResourceType: string
  ##                            : Optional. The exact value to match against
  ## 
  ## [`ServiceContext.resource_type`](/error-reporting/reference/rest/v1beta1/ServiceContext#FIELDS.resource_type).
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Optional. A `next_page_token` provided by a previous response.
  ##   groupId: string
  ##          : Required. The group for which events shall be returned.
  ##   projectName: string (required)
  ##              : Required. The resource name of the Google Cloud Platform project. Written
  ## as `projects/` plus the
  ## [Google Cloud Platform project
  ## ID](https://support.google.com/cloud/answer/6158840).
  ## Example: `projects/my-project-123`.
  ##   serviceFilterService: string
  ##                       : Optional. The exact value to match against
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
  var path_579968 = newJObject()
  var query_579969 = newJObject()
  add(query_579969, "key", newJString(key))
  add(query_579969, "prettyPrint", newJBool(prettyPrint))
  add(query_579969, "oauth_token", newJString(oauthToken))
  add(query_579969, "serviceFilter.version", newJString(serviceFilterVersion))
  add(query_579969, "$.xgafv", newJString(Xgafv))
  add(query_579969, "pageSize", newJInt(pageSize))
  add(query_579969, "timeRange.period", newJString(timeRangePeriod))
  add(query_579969, "serviceFilter.resourceType",
      newJString(serviceFilterResourceType))
  add(query_579969, "alt", newJString(alt))
  add(query_579969, "uploadType", newJString(uploadType))
  add(query_579969, "quotaUser", newJString(quotaUser))
  add(query_579969, "pageToken", newJString(pageToken))
  add(query_579969, "groupId", newJString(groupId))
  add(path_579968, "projectName", newJString(projectName))
  add(query_579969, "serviceFilter.service", newJString(serviceFilterService))
  add(query_579969, "callback", newJString(callback))
  add(query_579969, "fields", newJString(fields))
  add(query_579969, "access_token", newJString(accessToken))
  add(query_579969, "upload_protocol", newJString(uploadProtocol))
  result = call_579967.call(path_579968, query_579969, nil, nil, nil)

var clouderrorreportingProjectsEventsList* = Call_ClouderrorreportingProjectsEventsList_579944(
    name: "clouderrorreportingProjectsEventsList", meth: HttpMethod.HttpGet,
    host: "clouderrorreporting.googleapis.com",
    route: "/v1beta1/{projectName}/events",
    validator: validate_ClouderrorreportingProjectsEventsList_579945, base: "/",
    url: url_ClouderrorreportingProjectsEventsList_579946, schemes: {Scheme.Https})
type
  Call_ClouderrorreportingProjectsDeleteEvents_579970 = ref object of OpenApiRestCall_579364
proc url_ClouderrorreportingProjectsDeleteEvents_579972(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ClouderrorreportingProjectsDeleteEvents_579971(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes all error events of a given project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectName: JString (required)
  ##              : Required. The resource name of the Google Cloud Platform project. Written
  ## as `projects/` plus the
  ## [Google Cloud Platform project
  ## ID](https://support.google.com/cloud/answer/6158840).
  ## Example: `projects/my-project-123`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `projectName` field"
  var valid_579973 = path.getOrDefault("projectName")
  valid_579973 = validateParameter(valid_579973, JString, required = true,
                                 default = nil)
  if valid_579973 != nil:
    section.add "projectName", valid_579973
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
  var valid_579974 = query.getOrDefault("key")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "key", valid_579974
  var valid_579975 = query.getOrDefault("prettyPrint")
  valid_579975 = validateParameter(valid_579975, JBool, required = false,
                                 default = newJBool(true))
  if valid_579975 != nil:
    section.add "prettyPrint", valid_579975
  var valid_579976 = query.getOrDefault("oauth_token")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "oauth_token", valid_579976
  var valid_579977 = query.getOrDefault("$.xgafv")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = newJString("1"))
  if valid_579977 != nil:
    section.add "$.xgafv", valid_579977
  var valid_579978 = query.getOrDefault("alt")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = newJString("json"))
  if valid_579978 != nil:
    section.add "alt", valid_579978
  var valid_579979 = query.getOrDefault("uploadType")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "uploadType", valid_579979
  var valid_579980 = query.getOrDefault("quotaUser")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "quotaUser", valid_579980
  var valid_579981 = query.getOrDefault("callback")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "callback", valid_579981
  var valid_579982 = query.getOrDefault("fields")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "fields", valid_579982
  var valid_579983 = query.getOrDefault("access_token")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "access_token", valid_579983
  var valid_579984 = query.getOrDefault("upload_protocol")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "upload_protocol", valid_579984
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579985: Call_ClouderrorreportingProjectsDeleteEvents_579970;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all error events of a given project.
  ## 
  let valid = call_579985.validator(path, query, header, formData, body)
  let scheme = call_579985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579985.url(scheme.get, call_579985.host, call_579985.base,
                         call_579985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579985, url, valid)

proc call*(call_579986: Call_ClouderrorreportingProjectsDeleteEvents_579970;
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
  ##              : Required. The resource name of the Google Cloud Platform project. Written
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
  var path_579987 = newJObject()
  var query_579988 = newJObject()
  add(query_579988, "key", newJString(key))
  add(query_579988, "prettyPrint", newJBool(prettyPrint))
  add(query_579988, "oauth_token", newJString(oauthToken))
  add(query_579988, "$.xgafv", newJString(Xgafv))
  add(query_579988, "alt", newJString(alt))
  add(query_579988, "uploadType", newJString(uploadType))
  add(query_579988, "quotaUser", newJString(quotaUser))
  add(path_579987, "projectName", newJString(projectName))
  add(query_579988, "callback", newJString(callback))
  add(query_579988, "fields", newJString(fields))
  add(query_579988, "access_token", newJString(accessToken))
  add(query_579988, "upload_protocol", newJString(uploadProtocol))
  result = call_579986.call(path_579987, query_579988, nil, nil, nil)

var clouderrorreportingProjectsDeleteEvents* = Call_ClouderrorreportingProjectsDeleteEvents_579970(
    name: "clouderrorreportingProjectsDeleteEvents", meth: HttpMethod.HttpDelete,
    host: "clouderrorreporting.googleapis.com",
    route: "/v1beta1/{projectName}/events",
    validator: validate_ClouderrorreportingProjectsDeleteEvents_579971, base: "/",
    url: url_ClouderrorreportingProjectsDeleteEvents_579972,
    schemes: {Scheme.Https})
type
  Call_ClouderrorreportingProjectsEventsReport_579989 = ref object of OpenApiRestCall_579364
proc url_ClouderrorreportingProjectsEventsReport_579991(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ClouderrorreportingProjectsEventsReport_579990(path: JsonNode;
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
  ##              : Required. The resource name of the Google Cloud Platform project. Written
  ## as `projects/` plus the
  ## [Google Cloud Platform project
  ## ID](https://support.google.com/cloud/answer/6158840). Example:
  ## `projects/my-project-123`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `projectName` field"
  var valid_579992 = path.getOrDefault("projectName")
  valid_579992 = validateParameter(valid_579992, JString, required = true,
                                 default = nil)
  if valid_579992 != nil:
    section.add "projectName", valid_579992
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
  var valid_579993 = query.getOrDefault("key")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "key", valid_579993
  var valid_579994 = query.getOrDefault("prettyPrint")
  valid_579994 = validateParameter(valid_579994, JBool, required = false,
                                 default = newJBool(true))
  if valid_579994 != nil:
    section.add "prettyPrint", valid_579994
  var valid_579995 = query.getOrDefault("oauth_token")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "oauth_token", valid_579995
  var valid_579996 = query.getOrDefault("$.xgafv")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = newJString("1"))
  if valid_579996 != nil:
    section.add "$.xgafv", valid_579996
  var valid_579997 = query.getOrDefault("alt")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = newJString("json"))
  if valid_579997 != nil:
    section.add "alt", valid_579997
  var valid_579998 = query.getOrDefault("uploadType")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "uploadType", valid_579998
  var valid_579999 = query.getOrDefault("quotaUser")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "quotaUser", valid_579999
  var valid_580000 = query.getOrDefault("callback")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "callback", valid_580000
  var valid_580001 = query.getOrDefault("fields")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "fields", valid_580001
  var valid_580002 = query.getOrDefault("access_token")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "access_token", valid_580002
  var valid_580003 = query.getOrDefault("upload_protocol")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "upload_protocol", valid_580003
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

proc call*(call_580005: Call_ClouderrorreportingProjectsEventsReport_579989;
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
  let valid = call_580005.validator(path, query, header, formData, body)
  let scheme = call_580005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580005.url(scheme.get, call_580005.host, call_580005.base,
                         call_580005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580005, url, valid)

proc call*(call_580006: Call_ClouderrorreportingProjectsEventsReport_579989;
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
  ##              : Required. The resource name of the Google Cloud Platform project. Written
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
  var path_580007 = newJObject()
  var query_580008 = newJObject()
  var body_580009 = newJObject()
  add(query_580008, "key", newJString(key))
  add(query_580008, "prettyPrint", newJBool(prettyPrint))
  add(query_580008, "oauth_token", newJString(oauthToken))
  add(query_580008, "$.xgafv", newJString(Xgafv))
  add(query_580008, "alt", newJString(alt))
  add(query_580008, "uploadType", newJString(uploadType))
  add(query_580008, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580009 = body
  add(path_580007, "projectName", newJString(projectName))
  add(query_580008, "callback", newJString(callback))
  add(query_580008, "fields", newJString(fields))
  add(query_580008, "access_token", newJString(accessToken))
  add(query_580008, "upload_protocol", newJString(uploadProtocol))
  result = call_580006.call(path_580007, query_580008, nil, nil, body_580009)

var clouderrorreportingProjectsEventsReport* = Call_ClouderrorreportingProjectsEventsReport_579989(
    name: "clouderrorreportingProjectsEventsReport", meth: HttpMethod.HttpPost,
    host: "clouderrorreporting.googleapis.com",
    route: "/v1beta1/{projectName}/events:report",
    validator: validate_ClouderrorreportingProjectsEventsReport_579990, base: "/",
    url: url_ClouderrorreportingProjectsEventsReport_579991,
    schemes: {Scheme.Https})
type
  Call_ClouderrorreportingProjectsGroupStatsList_580010 = ref object of OpenApiRestCall_579364
proc url_ClouderrorreportingProjectsGroupStatsList_580012(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ClouderrorreportingProjectsGroupStatsList_580011(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the specified groups.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectName: JString (required)
  ##              : Required. The resource name of the Google Cloud Platform project. Written
  ## as <code>projects/</code> plus the
  ## <a href="https://support.google.com/cloud/answer/6158840">Google Cloud
  ## Platform project ID</a>.
  ## 
  ## Example: <code>projects/my-project-123</code>.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `projectName` field"
  var valid_580013 = path.getOrDefault("projectName")
  valid_580013 = validateParameter(valid_580013, JString, required = true,
                                 default = nil)
  if valid_580013 != nil:
    section.add "projectName", valid_580013
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   serviceFilter.version: JString
  ##                        : Optional. The exact value to match against
  ## 
  ## [`ServiceContext.version`](/error-reporting/reference/rest/v1beta1/ServiceContext#FIELDS.version).
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   order: JString
  ##        : Optional. The sort order in which the results are returned.
  ## Default is `COUNT_DESC`.
  ##   alignment: JString
  ##            : Optional. The alignment of the timed counts to be returned.
  ## Default is `ALIGNMENT_EQUAL_AT_END`.
  ##   pageSize: JInt
  ##           : Optional. The maximum number of results to return per response.
  ## Default is 20.
  ##   timeRange.period: JString
  ##                   : Restricts the query to the specified time range.
  ##   alignmentTime: JString
  ##                : Optional. Time where the timed counts shall be aligned if rounded
  ## alignment is chosen. Default is 00:00 UTC.
  ##   serviceFilter.resourceType: JString
  ##                             : Optional. The exact value to match against
  ## 
  ## [`ServiceContext.resource_type`](/error-reporting/reference/rest/v1beta1/ServiceContext#FIELDS.resource_type).
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   timedCountDuration: JString
  ##                     : Optional. The preferred duration for a single returned `TimedCount`.
  ## If not set, no timed counts are returned.
  ##   pageToken: JString
  ##            : Optional. A `next_page_token` provided by a previous response. To view
  ## additional results, pass this token along with the identical query
  ## parameters as the first request.
  ##   groupId: JArray
  ##          : Optional. List all <code>ErrorGroupStats</code> with these IDs.
  ##   serviceFilter.service: JString
  ##                        : Optional. The exact value to match against
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
  var valid_580014 = query.getOrDefault("key")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "key", valid_580014
  var valid_580015 = query.getOrDefault("prettyPrint")
  valid_580015 = validateParameter(valid_580015, JBool, required = false,
                                 default = newJBool(true))
  if valid_580015 != nil:
    section.add "prettyPrint", valid_580015
  var valid_580016 = query.getOrDefault("oauth_token")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "oauth_token", valid_580016
  var valid_580017 = query.getOrDefault("serviceFilter.version")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "serviceFilter.version", valid_580017
  var valid_580018 = query.getOrDefault("$.xgafv")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = newJString("1"))
  if valid_580018 != nil:
    section.add "$.xgafv", valid_580018
  var valid_580019 = query.getOrDefault("order")
  valid_580019 = validateParameter(valid_580019, JString, required = false, default = newJString(
      "GROUP_ORDER_UNSPECIFIED"))
  if valid_580019 != nil:
    section.add "order", valid_580019
  var valid_580020 = query.getOrDefault("alignment")
  valid_580020 = validateParameter(valid_580020, JString, required = false, default = newJString(
      "ERROR_COUNT_ALIGNMENT_UNSPECIFIED"))
  if valid_580020 != nil:
    section.add "alignment", valid_580020
  var valid_580021 = query.getOrDefault("pageSize")
  valid_580021 = validateParameter(valid_580021, JInt, required = false, default = nil)
  if valid_580021 != nil:
    section.add "pageSize", valid_580021
  var valid_580022 = query.getOrDefault("timeRange.period")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = newJString("PERIOD_UNSPECIFIED"))
  if valid_580022 != nil:
    section.add "timeRange.period", valid_580022
  var valid_580023 = query.getOrDefault("alignmentTime")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "alignmentTime", valid_580023
  var valid_580024 = query.getOrDefault("serviceFilter.resourceType")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "serviceFilter.resourceType", valid_580024
  var valid_580025 = query.getOrDefault("alt")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = newJString("json"))
  if valid_580025 != nil:
    section.add "alt", valid_580025
  var valid_580026 = query.getOrDefault("uploadType")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "uploadType", valid_580026
  var valid_580027 = query.getOrDefault("quotaUser")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "quotaUser", valid_580027
  var valid_580028 = query.getOrDefault("timedCountDuration")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "timedCountDuration", valid_580028
  var valid_580029 = query.getOrDefault("pageToken")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "pageToken", valid_580029
  var valid_580030 = query.getOrDefault("groupId")
  valid_580030 = validateParameter(valid_580030, JArray, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "groupId", valid_580030
  var valid_580031 = query.getOrDefault("serviceFilter.service")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "serviceFilter.service", valid_580031
  var valid_580032 = query.getOrDefault("callback")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "callback", valid_580032
  var valid_580033 = query.getOrDefault("fields")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "fields", valid_580033
  var valid_580034 = query.getOrDefault("access_token")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "access_token", valid_580034
  var valid_580035 = query.getOrDefault("upload_protocol")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "upload_protocol", valid_580035
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580036: Call_ClouderrorreportingProjectsGroupStatsList_580010;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the specified groups.
  ## 
  let valid = call_580036.validator(path, query, header, formData, body)
  let scheme = call_580036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580036.url(scheme.get, call_580036.host, call_580036.base,
                         call_580036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580036, url, valid)

proc call*(call_580037: Call_ClouderrorreportingProjectsGroupStatsList_580010;
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
  ##                       : Optional. The exact value to match against
  ## 
  ## [`ServiceContext.version`](/error-reporting/reference/rest/v1beta1/ServiceContext#FIELDS.version).
  ##   Xgafv: string
  ##        : V1 error format.
  ##   order: string
  ##        : Optional. The sort order in which the results are returned.
  ## Default is `COUNT_DESC`.
  ##   alignment: string
  ##            : Optional. The alignment of the timed counts to be returned.
  ## Default is `ALIGNMENT_EQUAL_AT_END`.
  ##   pageSize: int
  ##           : Optional. The maximum number of results to return per response.
  ## Default is 20.
  ##   timeRangePeriod: string
  ##                  : Restricts the query to the specified time range.
  ##   alignmentTime: string
  ##                : Optional. Time where the timed counts shall be aligned if rounded
  ## alignment is chosen. Default is 00:00 UTC.
  ##   serviceFilterResourceType: string
  ##                            : Optional. The exact value to match against
  ## 
  ## [`ServiceContext.resource_type`](/error-reporting/reference/rest/v1beta1/ServiceContext#FIELDS.resource_type).
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   timedCountDuration: string
  ##                     : Optional. The preferred duration for a single returned `TimedCount`.
  ## If not set, no timed counts are returned.
  ##   pageToken: string
  ##            : Optional. A `next_page_token` provided by a previous response. To view
  ## additional results, pass this token along with the identical query
  ## parameters as the first request.
  ##   groupId: JArray
  ##          : Optional. List all <code>ErrorGroupStats</code> with these IDs.
  ##   projectName: string (required)
  ##              : Required. The resource name of the Google Cloud Platform project. Written
  ## as <code>projects/</code> plus the
  ## <a href="https://support.google.com/cloud/answer/6158840">Google Cloud
  ## Platform project ID</a>.
  ## 
  ## Example: <code>projects/my-project-123</code>.
  ##   serviceFilterService: string
  ##                       : Optional. The exact value to match against
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
  var path_580038 = newJObject()
  var query_580039 = newJObject()
  add(query_580039, "key", newJString(key))
  add(query_580039, "prettyPrint", newJBool(prettyPrint))
  add(query_580039, "oauth_token", newJString(oauthToken))
  add(query_580039, "serviceFilter.version", newJString(serviceFilterVersion))
  add(query_580039, "$.xgafv", newJString(Xgafv))
  add(query_580039, "order", newJString(order))
  add(query_580039, "alignment", newJString(alignment))
  add(query_580039, "pageSize", newJInt(pageSize))
  add(query_580039, "timeRange.period", newJString(timeRangePeriod))
  add(query_580039, "alignmentTime", newJString(alignmentTime))
  add(query_580039, "serviceFilter.resourceType",
      newJString(serviceFilterResourceType))
  add(query_580039, "alt", newJString(alt))
  add(query_580039, "uploadType", newJString(uploadType))
  add(query_580039, "quotaUser", newJString(quotaUser))
  add(query_580039, "timedCountDuration", newJString(timedCountDuration))
  add(query_580039, "pageToken", newJString(pageToken))
  if groupId != nil:
    query_580039.add "groupId", groupId
  add(path_580038, "projectName", newJString(projectName))
  add(query_580039, "serviceFilter.service", newJString(serviceFilterService))
  add(query_580039, "callback", newJString(callback))
  add(query_580039, "fields", newJString(fields))
  add(query_580039, "access_token", newJString(accessToken))
  add(query_580039, "upload_protocol", newJString(uploadProtocol))
  result = call_580037.call(path_580038, query_580039, nil, nil, nil)

var clouderrorreportingProjectsGroupStatsList* = Call_ClouderrorreportingProjectsGroupStatsList_580010(
    name: "clouderrorreportingProjectsGroupStatsList", meth: HttpMethod.HttpGet,
    host: "clouderrorreporting.googleapis.com",
    route: "/v1beta1/{projectName}/groupStats",
    validator: validate_ClouderrorreportingProjectsGroupStatsList_580011,
    base: "/", url: url_ClouderrorreportingProjectsGroupStatsList_580012,
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
