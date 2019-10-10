
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Classroom
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Manages classes, rosters, and invitations in Google Classroom.
## 
## https://developers.google.com/classroom/
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

  OpenApiRestCall_588450 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588450](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588450): Option[Scheme] {.used.} =
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
  gcpServiceName = "classroom"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ClassroomCoursesCreate_588996 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesCreate_588998(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ClassroomCoursesCreate_588997(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a course.
  ## 
  ## The user specified in `ownerId` is the owner of the created course
  ## and added as a teacher.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to create
  ## courses or for access errors.
  ## * `NOT_FOUND` if the primary teacher is not a valid user.
  ## * `FAILED_PRECONDITION` if the course owner's account is disabled or for
  ## the following request errors:
  ##     * UserGroupsMembershipLimitReached
  ## * `ALREADY_EXISTS` if an alias was specified in the `id` and
  ## already exists.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  var valid_588999 = query.getOrDefault("upload_protocol")
  valid_588999 = validateParameter(valid_588999, JString, required = false,
                                 default = nil)
  if valid_588999 != nil:
    section.add "upload_protocol", valid_588999
  var valid_589000 = query.getOrDefault("fields")
  valid_589000 = validateParameter(valid_589000, JString, required = false,
                                 default = nil)
  if valid_589000 != nil:
    section.add "fields", valid_589000
  var valid_589001 = query.getOrDefault("quotaUser")
  valid_589001 = validateParameter(valid_589001, JString, required = false,
                                 default = nil)
  if valid_589001 != nil:
    section.add "quotaUser", valid_589001
  var valid_589002 = query.getOrDefault("alt")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = newJString("json"))
  if valid_589002 != nil:
    section.add "alt", valid_589002
  var valid_589003 = query.getOrDefault("oauth_token")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = nil)
  if valid_589003 != nil:
    section.add "oauth_token", valid_589003
  var valid_589004 = query.getOrDefault("callback")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "callback", valid_589004
  var valid_589005 = query.getOrDefault("access_token")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = nil)
  if valid_589005 != nil:
    section.add "access_token", valid_589005
  var valid_589006 = query.getOrDefault("uploadType")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "uploadType", valid_589006
  var valid_589007 = query.getOrDefault("key")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "key", valid_589007
  var valid_589008 = query.getOrDefault("$.xgafv")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = newJString("1"))
  if valid_589008 != nil:
    section.add "$.xgafv", valid_589008
  var valid_589009 = query.getOrDefault("prettyPrint")
  valid_589009 = validateParameter(valid_589009, JBool, required = false,
                                 default = newJBool(true))
  if valid_589009 != nil:
    section.add "prettyPrint", valid_589009
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

proc call*(call_589011: Call_ClassroomCoursesCreate_588996; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a course.
  ## 
  ## The user specified in `ownerId` is the owner of the created course
  ## and added as a teacher.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to create
  ## courses or for access errors.
  ## * `NOT_FOUND` if the primary teacher is not a valid user.
  ## * `FAILED_PRECONDITION` if the course owner's account is disabled or for
  ## the following request errors:
  ##     * UserGroupsMembershipLimitReached
  ## * `ALREADY_EXISTS` if an alias was specified in the `id` and
  ## already exists.
  ## 
  let valid = call_589011.validator(path, query, header, formData, body)
  let scheme = call_589011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589011.url(scheme.get, call_589011.host, call_589011.base,
                         call_589011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589011, url, valid)

proc call*(call_589012: Call_ClassroomCoursesCreate_588996;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## classroomCoursesCreate
  ## Creates a course.
  ## 
  ## The user specified in `ownerId` is the owner of the created course
  ## and added as a teacher.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to create
  ## courses or for access errors.
  ## * `NOT_FOUND` if the primary teacher is not a valid user.
  ## * `FAILED_PRECONDITION` if the course owner's account is disabled or for
  ## the following request errors:
  ##     * UserGroupsMembershipLimitReached
  ## * `ALREADY_EXISTS` if an alias was specified in the `id` and
  ## already exists.
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
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589013 = newJObject()
  var body_589014 = newJObject()
  add(query_589013, "upload_protocol", newJString(uploadProtocol))
  add(query_589013, "fields", newJString(fields))
  add(query_589013, "quotaUser", newJString(quotaUser))
  add(query_589013, "alt", newJString(alt))
  add(query_589013, "oauth_token", newJString(oauthToken))
  add(query_589013, "callback", newJString(callback))
  add(query_589013, "access_token", newJString(accessToken))
  add(query_589013, "uploadType", newJString(uploadType))
  add(query_589013, "key", newJString(key))
  add(query_589013, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589014 = body
  add(query_589013, "prettyPrint", newJBool(prettyPrint))
  result = call_589012.call(nil, query_589013, nil, nil, body_589014)

var classroomCoursesCreate* = Call_ClassroomCoursesCreate_588996(
    name: "classroomCoursesCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/courses",
    validator: validate_ClassroomCoursesCreate_588997, base: "/",
    url: url_ClassroomCoursesCreate_588998, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesList_588719 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesList_588721(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ClassroomCoursesList_588720(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of courses that the requesting user is permitted to view,
  ## restricted to those that match the request. Returned courses are ordered by
  ## creation time, with the most recently created coming first.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` for access errors.
  ## * `INVALID_ARGUMENT` if the query argument is malformed.
  ## * `NOT_FOUND` if any users specified in the query arguments do not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : nextPageToken
  ## value returned from a previous
  ## list call,
  ## indicating that the subsequent page of results should be returned.
  ## 
  ## The list request must be
  ## otherwise identical to the one that resulted in this token.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   studentId: JString
  ##            : Restricts returned courses to those having a student with the specified
  ## identifier. The identifier can be one of the following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
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
  ##   teacherId: JString
  ##            : Restricts returned courses to those having a teacher with the specified
  ## identifier. The identifier can be one of the following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Maximum number of items to return. Zero or unspecified indicates that the
  ## server may assign a maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   courseStates: JArray
  ##               : Restricts returned courses to those in one of the specified states
  ## The default value is ACTIVE, ARCHIVED, PROVISIONED, DECLINED.
  section = newJObject()
  var valid_588833 = query.getOrDefault("upload_protocol")
  valid_588833 = validateParameter(valid_588833, JString, required = false,
                                 default = nil)
  if valid_588833 != nil:
    section.add "upload_protocol", valid_588833
  var valid_588834 = query.getOrDefault("fields")
  valid_588834 = validateParameter(valid_588834, JString, required = false,
                                 default = nil)
  if valid_588834 != nil:
    section.add "fields", valid_588834
  var valid_588835 = query.getOrDefault("pageToken")
  valid_588835 = validateParameter(valid_588835, JString, required = false,
                                 default = nil)
  if valid_588835 != nil:
    section.add "pageToken", valid_588835
  var valid_588836 = query.getOrDefault("quotaUser")
  valid_588836 = validateParameter(valid_588836, JString, required = false,
                                 default = nil)
  if valid_588836 != nil:
    section.add "quotaUser", valid_588836
  var valid_588837 = query.getOrDefault("studentId")
  valid_588837 = validateParameter(valid_588837, JString, required = false,
                                 default = nil)
  if valid_588837 != nil:
    section.add "studentId", valid_588837
  var valid_588851 = query.getOrDefault("alt")
  valid_588851 = validateParameter(valid_588851, JString, required = false,
                                 default = newJString("json"))
  if valid_588851 != nil:
    section.add "alt", valid_588851
  var valid_588852 = query.getOrDefault("oauth_token")
  valid_588852 = validateParameter(valid_588852, JString, required = false,
                                 default = nil)
  if valid_588852 != nil:
    section.add "oauth_token", valid_588852
  var valid_588853 = query.getOrDefault("callback")
  valid_588853 = validateParameter(valid_588853, JString, required = false,
                                 default = nil)
  if valid_588853 != nil:
    section.add "callback", valid_588853
  var valid_588854 = query.getOrDefault("access_token")
  valid_588854 = validateParameter(valid_588854, JString, required = false,
                                 default = nil)
  if valid_588854 != nil:
    section.add "access_token", valid_588854
  var valid_588855 = query.getOrDefault("uploadType")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = nil)
  if valid_588855 != nil:
    section.add "uploadType", valid_588855
  var valid_588856 = query.getOrDefault("teacherId")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "teacherId", valid_588856
  var valid_588857 = query.getOrDefault("key")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "key", valid_588857
  var valid_588858 = query.getOrDefault("$.xgafv")
  valid_588858 = validateParameter(valid_588858, JString, required = false,
                                 default = newJString("1"))
  if valid_588858 != nil:
    section.add "$.xgafv", valid_588858
  var valid_588859 = query.getOrDefault("pageSize")
  valid_588859 = validateParameter(valid_588859, JInt, required = false, default = nil)
  if valid_588859 != nil:
    section.add "pageSize", valid_588859
  var valid_588860 = query.getOrDefault("prettyPrint")
  valid_588860 = validateParameter(valid_588860, JBool, required = false,
                                 default = newJBool(true))
  if valid_588860 != nil:
    section.add "prettyPrint", valid_588860
  var valid_588861 = query.getOrDefault("courseStates")
  valid_588861 = validateParameter(valid_588861, JArray, required = false,
                                 default = nil)
  if valid_588861 != nil:
    section.add "courseStates", valid_588861
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588884: Call_ClassroomCoursesList_588719; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of courses that the requesting user is permitted to view,
  ## restricted to those that match the request. Returned courses are ordered by
  ## creation time, with the most recently created coming first.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` for access errors.
  ## * `INVALID_ARGUMENT` if the query argument is malformed.
  ## * `NOT_FOUND` if any users specified in the query arguments do not exist.
  ## 
  let valid = call_588884.validator(path, query, header, formData, body)
  let scheme = call_588884.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588884.url(scheme.get, call_588884.host, call_588884.base,
                         call_588884.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588884, url, valid)

proc call*(call_588955: Call_ClassroomCoursesList_588719;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; studentId: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; teacherId: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true;
          courseStates: JsonNode = nil): Recallable =
  ## classroomCoursesList
  ## Returns a list of courses that the requesting user is permitted to view,
  ## restricted to those that match the request. Returned courses are ordered by
  ## creation time, with the most recently created coming first.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` for access errors.
  ## * `INVALID_ARGUMENT` if the query argument is malformed.
  ## * `NOT_FOUND` if any users specified in the query arguments do not exist.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : nextPageToken
  ## value returned from a previous
  ## list call,
  ## indicating that the subsequent page of results should be returned.
  ## 
  ## The list request must be
  ## otherwise identical to the one that resulted in this token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   studentId: string
  ##            : Restricts returned courses to those having a student with the specified
  ## identifier. The identifier can be one of the following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
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
  ##   teacherId: string
  ##            : Restricts returned courses to those having a teacher with the specified
  ## identifier. The identifier can be one of the following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of items to return. Zero or unspecified indicates that the
  ## server may assign a maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   courseStates: JArray
  ##               : Restricts returned courses to those in one of the specified states
  ## The default value is ACTIVE, ARCHIVED, PROVISIONED, DECLINED.
  var query_588956 = newJObject()
  add(query_588956, "upload_protocol", newJString(uploadProtocol))
  add(query_588956, "fields", newJString(fields))
  add(query_588956, "pageToken", newJString(pageToken))
  add(query_588956, "quotaUser", newJString(quotaUser))
  add(query_588956, "studentId", newJString(studentId))
  add(query_588956, "alt", newJString(alt))
  add(query_588956, "oauth_token", newJString(oauthToken))
  add(query_588956, "callback", newJString(callback))
  add(query_588956, "access_token", newJString(accessToken))
  add(query_588956, "uploadType", newJString(uploadType))
  add(query_588956, "teacherId", newJString(teacherId))
  add(query_588956, "key", newJString(key))
  add(query_588956, "$.xgafv", newJString(Xgafv))
  add(query_588956, "pageSize", newJInt(pageSize))
  add(query_588956, "prettyPrint", newJBool(prettyPrint))
  if courseStates != nil:
    query_588956.add "courseStates", courseStates
  result = call_588955.call(nil, query_588956, nil, nil, nil)

var classroomCoursesList* = Call_ClassroomCoursesList_588719(
    name: "classroomCoursesList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/courses",
    validator: validate_ClassroomCoursesList_588720, base: "/",
    url: url_ClassroomCoursesList_588721, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAliasesCreate_589050 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesAliasesCreate_589052(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "courseId" in path, "`courseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "courseId"),
               (kind: ConstantSegment, value: "/aliases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesAliasesCreate_589051(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an alias for a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to create the
  ## alias or for access errors.
  ## * `NOT_FOUND` if the course does not exist.
  ## * `ALREADY_EXISTS` if the alias already exists.
  ## * `FAILED_PRECONDITION` if the alias requested does not make sense for the
  ##   requesting user or course (for example, if a user not in a domain
  ##   attempts to access a domain-scoped alias).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   courseId: JString (required)
  ##           : Identifier of the course to alias.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `courseId` field"
  var valid_589053 = path.getOrDefault("courseId")
  valid_589053 = validateParameter(valid_589053, JString, required = true,
                                 default = nil)
  if valid_589053 != nil:
    section.add "courseId", valid_589053
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
  var valid_589054 = query.getOrDefault("upload_protocol")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "upload_protocol", valid_589054
  var valid_589055 = query.getOrDefault("fields")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "fields", valid_589055
  var valid_589056 = query.getOrDefault("quotaUser")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "quotaUser", valid_589056
  var valid_589057 = query.getOrDefault("alt")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = newJString("json"))
  if valid_589057 != nil:
    section.add "alt", valid_589057
  var valid_589058 = query.getOrDefault("oauth_token")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "oauth_token", valid_589058
  var valid_589059 = query.getOrDefault("callback")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "callback", valid_589059
  var valid_589060 = query.getOrDefault("access_token")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "access_token", valid_589060
  var valid_589061 = query.getOrDefault("uploadType")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "uploadType", valid_589061
  var valid_589062 = query.getOrDefault("key")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "key", valid_589062
  var valid_589063 = query.getOrDefault("$.xgafv")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = newJString("1"))
  if valid_589063 != nil:
    section.add "$.xgafv", valid_589063
  var valid_589064 = query.getOrDefault("prettyPrint")
  valid_589064 = validateParameter(valid_589064, JBool, required = false,
                                 default = newJBool(true))
  if valid_589064 != nil:
    section.add "prettyPrint", valid_589064
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

proc call*(call_589066: Call_ClassroomCoursesAliasesCreate_589050; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an alias for a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to create the
  ## alias or for access errors.
  ## * `NOT_FOUND` if the course does not exist.
  ## * `ALREADY_EXISTS` if the alias already exists.
  ## * `FAILED_PRECONDITION` if the alias requested does not make sense for the
  ##   requesting user or course (for example, if a user not in a domain
  ##   attempts to access a domain-scoped alias).
  ## 
  let valid = call_589066.validator(path, query, header, formData, body)
  let scheme = call_589066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589066.url(scheme.get, call_589066.host, call_589066.base,
                         call_589066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589066, url, valid)

proc call*(call_589067: Call_ClassroomCoursesAliasesCreate_589050;
          courseId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## classroomCoursesAliasesCreate
  ## Creates an alias for a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to create the
  ## alias or for access errors.
  ## * `NOT_FOUND` if the course does not exist.
  ## * `ALREADY_EXISTS` if the alias already exists.
  ## * `FAILED_PRECONDITION` if the alias requested does not make sense for the
  ##   requesting user or course (for example, if a user not in a domain
  ##   attempts to access a domain-scoped alias).
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
  ##   courseId: string (required)
  ##           : Identifier of the course to alias.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589068 = newJObject()
  var query_589069 = newJObject()
  var body_589070 = newJObject()
  add(query_589069, "upload_protocol", newJString(uploadProtocol))
  add(query_589069, "fields", newJString(fields))
  add(query_589069, "quotaUser", newJString(quotaUser))
  add(query_589069, "alt", newJString(alt))
  add(query_589069, "oauth_token", newJString(oauthToken))
  add(query_589069, "callback", newJString(callback))
  add(query_589069, "access_token", newJString(accessToken))
  add(query_589069, "uploadType", newJString(uploadType))
  add(query_589069, "key", newJString(key))
  add(path_589068, "courseId", newJString(courseId))
  add(query_589069, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589070 = body
  add(query_589069, "prettyPrint", newJBool(prettyPrint))
  result = call_589067.call(path_589068, query_589069, nil, nil, body_589070)

var classroomCoursesAliasesCreate* = Call_ClassroomCoursesAliasesCreate_589050(
    name: "classroomCoursesAliasesCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/aliases",
    validator: validate_ClassroomCoursesAliasesCreate_589051, base: "/",
    url: url_ClassroomCoursesAliasesCreate_589052, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAliasesList_589015 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesAliasesList_589017(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "courseId" in path, "`courseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "courseId"),
               (kind: ConstantSegment, value: "/aliases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesAliasesList_589016(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of aliases for a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## course or for access errors.
  ## * `NOT_FOUND` if the course does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   courseId: JString (required)
  ##           : The identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `courseId` field"
  var valid_589032 = path.getOrDefault("courseId")
  valid_589032 = validateParameter(valid_589032, JString, required = true,
                                 default = nil)
  if valid_589032 != nil:
    section.add "courseId", valid_589032
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : nextPageToken
  ## value returned from a previous
  ## list call,
  ## indicating that the subsequent page of results should be returned.
  ## 
  ## The list request
  ## must be otherwise identical to the one that resulted in this token.
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
  ##   pageSize: JInt
  ##           : Maximum number of items to return. Zero or unspecified indicates that the
  ## server may assign a maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589033 = query.getOrDefault("upload_protocol")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "upload_protocol", valid_589033
  var valid_589034 = query.getOrDefault("fields")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "fields", valid_589034
  var valid_589035 = query.getOrDefault("pageToken")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "pageToken", valid_589035
  var valid_589036 = query.getOrDefault("quotaUser")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "quotaUser", valid_589036
  var valid_589037 = query.getOrDefault("alt")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = newJString("json"))
  if valid_589037 != nil:
    section.add "alt", valid_589037
  var valid_589038 = query.getOrDefault("oauth_token")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "oauth_token", valid_589038
  var valid_589039 = query.getOrDefault("callback")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "callback", valid_589039
  var valid_589040 = query.getOrDefault("access_token")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "access_token", valid_589040
  var valid_589041 = query.getOrDefault("uploadType")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "uploadType", valid_589041
  var valid_589042 = query.getOrDefault("key")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "key", valid_589042
  var valid_589043 = query.getOrDefault("$.xgafv")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = newJString("1"))
  if valid_589043 != nil:
    section.add "$.xgafv", valid_589043
  var valid_589044 = query.getOrDefault("pageSize")
  valid_589044 = validateParameter(valid_589044, JInt, required = false, default = nil)
  if valid_589044 != nil:
    section.add "pageSize", valid_589044
  var valid_589045 = query.getOrDefault("prettyPrint")
  valid_589045 = validateParameter(valid_589045, JBool, required = false,
                                 default = newJBool(true))
  if valid_589045 != nil:
    section.add "prettyPrint", valid_589045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589046: Call_ClassroomCoursesAliasesList_589015; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of aliases for a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## course or for access errors.
  ## * `NOT_FOUND` if the course does not exist.
  ## 
  let valid = call_589046.validator(path, query, header, formData, body)
  let scheme = call_589046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589046.url(scheme.get, call_589046.host, call_589046.base,
                         call_589046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589046, url, valid)

proc call*(call_589047: Call_ClassroomCoursesAliasesList_589015; courseId: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## classroomCoursesAliasesList
  ## Returns a list of aliases for a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## course or for access errors.
  ## * `NOT_FOUND` if the course does not exist.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : nextPageToken
  ## value returned from a previous
  ## list call,
  ## indicating that the subsequent page of results should be returned.
  ## 
  ## The list request
  ## must be otherwise identical to the one that resulted in this token.
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
  ##   courseId: string (required)
  ##           : The identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of items to return. Zero or unspecified indicates that the
  ## server may assign a maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589048 = newJObject()
  var query_589049 = newJObject()
  add(query_589049, "upload_protocol", newJString(uploadProtocol))
  add(query_589049, "fields", newJString(fields))
  add(query_589049, "pageToken", newJString(pageToken))
  add(query_589049, "quotaUser", newJString(quotaUser))
  add(query_589049, "alt", newJString(alt))
  add(query_589049, "oauth_token", newJString(oauthToken))
  add(query_589049, "callback", newJString(callback))
  add(query_589049, "access_token", newJString(accessToken))
  add(query_589049, "uploadType", newJString(uploadType))
  add(query_589049, "key", newJString(key))
  add(path_589048, "courseId", newJString(courseId))
  add(query_589049, "$.xgafv", newJString(Xgafv))
  add(query_589049, "pageSize", newJInt(pageSize))
  add(query_589049, "prettyPrint", newJBool(prettyPrint))
  result = call_589047.call(path_589048, query_589049, nil, nil, nil)

var classroomCoursesAliasesList* = Call_ClassroomCoursesAliasesList_589015(
    name: "classroomCoursesAliasesList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/aliases",
    validator: validate_ClassroomCoursesAliasesList_589016, base: "/",
    url: url_ClassroomCoursesAliasesList_589017, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAliasesDelete_589071 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesAliasesDelete_589073(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "courseId" in path, "`courseId` is a required path parameter"
  assert "alias" in path, "`alias` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "courseId"),
               (kind: ConstantSegment, value: "/aliases/"),
               (kind: VariableSegment, value: "alias")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesAliasesDelete_589072(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an alias of a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to remove the
  ## alias or for access errors.
  ## * `NOT_FOUND` if the alias does not exist.
  ## * `FAILED_PRECONDITION` if the alias requested does not make sense for the
  ##   requesting user or course (for example, if a user not in a domain
  ##   attempts to delete a domain-scoped alias).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   courseId: JString (required)
  ##           : Identifier of the course whose alias should be deleted.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   alias: JString (required)
  ##        : Alias to delete.
  ## This may not be the Classroom-assigned identifier.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `courseId` field"
  var valid_589074 = path.getOrDefault("courseId")
  valid_589074 = validateParameter(valid_589074, JString, required = true,
                                 default = nil)
  if valid_589074 != nil:
    section.add "courseId", valid_589074
  var valid_589075 = path.getOrDefault("alias")
  valid_589075 = validateParameter(valid_589075, JString, required = true,
                                 default = nil)
  if valid_589075 != nil:
    section.add "alias", valid_589075
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
  var valid_589076 = query.getOrDefault("upload_protocol")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "upload_protocol", valid_589076
  var valid_589077 = query.getOrDefault("fields")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "fields", valid_589077
  var valid_589078 = query.getOrDefault("quotaUser")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "quotaUser", valid_589078
  var valid_589079 = query.getOrDefault("alt")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = newJString("json"))
  if valid_589079 != nil:
    section.add "alt", valid_589079
  var valid_589080 = query.getOrDefault("oauth_token")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "oauth_token", valid_589080
  var valid_589081 = query.getOrDefault("callback")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "callback", valid_589081
  var valid_589082 = query.getOrDefault("access_token")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "access_token", valid_589082
  var valid_589083 = query.getOrDefault("uploadType")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "uploadType", valid_589083
  var valid_589084 = query.getOrDefault("key")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "key", valid_589084
  var valid_589085 = query.getOrDefault("$.xgafv")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = newJString("1"))
  if valid_589085 != nil:
    section.add "$.xgafv", valid_589085
  var valid_589086 = query.getOrDefault("prettyPrint")
  valid_589086 = validateParameter(valid_589086, JBool, required = false,
                                 default = newJBool(true))
  if valid_589086 != nil:
    section.add "prettyPrint", valid_589086
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589087: Call_ClassroomCoursesAliasesDelete_589071; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an alias of a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to remove the
  ## alias or for access errors.
  ## * `NOT_FOUND` if the alias does not exist.
  ## * `FAILED_PRECONDITION` if the alias requested does not make sense for the
  ##   requesting user or course (for example, if a user not in a domain
  ##   attempts to delete a domain-scoped alias).
  ## 
  let valid = call_589087.validator(path, query, header, formData, body)
  let scheme = call_589087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589087.url(scheme.get, call_589087.host, call_589087.base,
                         call_589087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589087, url, valid)

proc call*(call_589088: Call_ClassroomCoursesAliasesDelete_589071;
          courseId: string; alias: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## classroomCoursesAliasesDelete
  ## Deletes an alias of a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to remove the
  ## alias or for access errors.
  ## * `NOT_FOUND` if the alias does not exist.
  ## * `FAILED_PRECONDITION` if the alias requested does not make sense for the
  ##   requesting user or course (for example, if a user not in a domain
  ##   attempts to delete a domain-scoped alias).
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
  ##   courseId: string (required)
  ##           : Identifier of the course whose alias should be deleted.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   alias: string (required)
  ##        : Alias to delete.
  ## This may not be the Classroom-assigned identifier.
  var path_589089 = newJObject()
  var query_589090 = newJObject()
  add(query_589090, "upload_protocol", newJString(uploadProtocol))
  add(query_589090, "fields", newJString(fields))
  add(query_589090, "quotaUser", newJString(quotaUser))
  add(query_589090, "alt", newJString(alt))
  add(query_589090, "oauth_token", newJString(oauthToken))
  add(query_589090, "callback", newJString(callback))
  add(query_589090, "access_token", newJString(accessToken))
  add(query_589090, "uploadType", newJString(uploadType))
  add(query_589090, "key", newJString(key))
  add(path_589089, "courseId", newJString(courseId))
  add(query_589090, "$.xgafv", newJString(Xgafv))
  add(query_589090, "prettyPrint", newJBool(prettyPrint))
  add(path_589089, "alias", newJString(alias))
  result = call_589088.call(path_589089, query_589090, nil, nil, nil)

var classroomCoursesAliasesDelete* = Call_ClassroomCoursesAliasesDelete_589071(
    name: "classroomCoursesAliasesDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/aliases/{alias}",
    validator: validate_ClassroomCoursesAliasesDelete_589072, base: "/",
    url: url_ClassroomCoursesAliasesDelete_589073, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAnnouncementsCreate_589114 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesAnnouncementsCreate_589116(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "courseId" in path, "`courseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "courseId"),
               (kind: ConstantSegment, value: "/announcements")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesAnnouncementsCreate_589115(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an announcement.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course, create announcements in the requested course, share a
  ## Drive attachment, or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course does not exist.
  ## * `FAILED_PRECONDITION` for the following request error:
  ##     * AttachmentNotVisible
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `courseId` field"
  var valid_589117 = path.getOrDefault("courseId")
  valid_589117 = validateParameter(valid_589117, JString, required = true,
                                 default = nil)
  if valid_589117 != nil:
    section.add "courseId", valid_589117
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
  var valid_589118 = query.getOrDefault("upload_protocol")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "upload_protocol", valid_589118
  var valid_589119 = query.getOrDefault("fields")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = nil)
  if valid_589119 != nil:
    section.add "fields", valid_589119
  var valid_589120 = query.getOrDefault("quotaUser")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "quotaUser", valid_589120
  var valid_589121 = query.getOrDefault("alt")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = newJString("json"))
  if valid_589121 != nil:
    section.add "alt", valid_589121
  var valid_589122 = query.getOrDefault("oauth_token")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "oauth_token", valid_589122
  var valid_589123 = query.getOrDefault("callback")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "callback", valid_589123
  var valid_589124 = query.getOrDefault("access_token")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "access_token", valid_589124
  var valid_589125 = query.getOrDefault("uploadType")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "uploadType", valid_589125
  var valid_589126 = query.getOrDefault("key")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "key", valid_589126
  var valid_589127 = query.getOrDefault("$.xgafv")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = newJString("1"))
  if valid_589127 != nil:
    section.add "$.xgafv", valid_589127
  var valid_589128 = query.getOrDefault("prettyPrint")
  valid_589128 = validateParameter(valid_589128, JBool, required = false,
                                 default = newJBool(true))
  if valid_589128 != nil:
    section.add "prettyPrint", valid_589128
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

proc call*(call_589130: Call_ClassroomCoursesAnnouncementsCreate_589114;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an announcement.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course, create announcements in the requested course, share a
  ## Drive attachment, or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course does not exist.
  ## * `FAILED_PRECONDITION` for the following request error:
  ##     * AttachmentNotVisible
  ## 
  let valid = call_589130.validator(path, query, header, formData, body)
  let scheme = call_589130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589130.url(scheme.get, call_589130.host, call_589130.base,
                         call_589130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589130, url, valid)

proc call*(call_589131: Call_ClassroomCoursesAnnouncementsCreate_589114;
          courseId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## classroomCoursesAnnouncementsCreate
  ## Creates an announcement.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course, create announcements in the requested course, share a
  ## Drive attachment, or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course does not exist.
  ## * `FAILED_PRECONDITION` for the following request error:
  ##     * AttachmentNotVisible
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
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589132 = newJObject()
  var query_589133 = newJObject()
  var body_589134 = newJObject()
  add(query_589133, "upload_protocol", newJString(uploadProtocol))
  add(query_589133, "fields", newJString(fields))
  add(query_589133, "quotaUser", newJString(quotaUser))
  add(query_589133, "alt", newJString(alt))
  add(query_589133, "oauth_token", newJString(oauthToken))
  add(query_589133, "callback", newJString(callback))
  add(query_589133, "access_token", newJString(accessToken))
  add(query_589133, "uploadType", newJString(uploadType))
  add(query_589133, "key", newJString(key))
  add(path_589132, "courseId", newJString(courseId))
  add(query_589133, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589134 = body
  add(query_589133, "prettyPrint", newJBool(prettyPrint))
  result = call_589131.call(path_589132, query_589133, nil, nil, body_589134)

var classroomCoursesAnnouncementsCreate* = Call_ClassroomCoursesAnnouncementsCreate_589114(
    name: "classroomCoursesAnnouncementsCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/announcements",
    validator: validate_ClassroomCoursesAnnouncementsCreate_589115, base: "/",
    url: url_ClassroomCoursesAnnouncementsCreate_589116, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAnnouncementsList_589091 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesAnnouncementsList_589093(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "courseId" in path, "`courseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "courseId"),
               (kind: ConstantSegment, value: "/announcements")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesAnnouncementsList_589092(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of announcements that the requester is permitted to view.
  ## 
  ## Course students may only view `PUBLISHED` announcements. Course teachers
  ## and domain administrators may view all announcements.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access
  ## the requested course or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `courseId` field"
  var valid_589094 = path.getOrDefault("courseId")
  valid_589094 = validateParameter(valid_589094, JString, required = true,
                                 default = nil)
  if valid_589094 != nil:
    section.add "courseId", valid_589094
  result.add "path", section
  ## parameters in `query` object:
  ##   announcementStates: JArray
  ##                     : Restriction on the `state` of announcements returned.
  ## If this argument is left unspecified, the default value is `PUBLISHED`.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : nextPageToken
  ## value returned from a previous
  ## list call,
  ## indicating that the subsequent page of results should be returned.
  ## 
  ## The list request
  ## must be otherwise identical to the one that resulted in this token.
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
  ##   orderBy: JString
  ##          : Optional sort ordering for results. A comma-separated list of fields with
  ## an optional sort direction keyword. Supported field is `updateTime`.
  ## Supported direction keywords are `asc` and `desc`.
  ## If not specified, `updateTime desc` is the default behavior.
  ## Examples: `updateTime asc`, `updateTime`
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Maximum number of items to return. Zero or unspecified indicates that the
  ## server may assign a maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589095 = query.getOrDefault("announcementStates")
  valid_589095 = validateParameter(valid_589095, JArray, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "announcementStates", valid_589095
  var valid_589096 = query.getOrDefault("upload_protocol")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "upload_protocol", valid_589096
  var valid_589097 = query.getOrDefault("fields")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "fields", valid_589097
  var valid_589098 = query.getOrDefault("pageToken")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "pageToken", valid_589098
  var valid_589099 = query.getOrDefault("quotaUser")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "quotaUser", valid_589099
  var valid_589100 = query.getOrDefault("alt")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = newJString("json"))
  if valid_589100 != nil:
    section.add "alt", valid_589100
  var valid_589101 = query.getOrDefault("oauth_token")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "oauth_token", valid_589101
  var valid_589102 = query.getOrDefault("callback")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "callback", valid_589102
  var valid_589103 = query.getOrDefault("access_token")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "access_token", valid_589103
  var valid_589104 = query.getOrDefault("uploadType")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "uploadType", valid_589104
  var valid_589105 = query.getOrDefault("orderBy")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "orderBy", valid_589105
  var valid_589106 = query.getOrDefault("key")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "key", valid_589106
  var valid_589107 = query.getOrDefault("$.xgafv")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = newJString("1"))
  if valid_589107 != nil:
    section.add "$.xgafv", valid_589107
  var valid_589108 = query.getOrDefault("pageSize")
  valid_589108 = validateParameter(valid_589108, JInt, required = false, default = nil)
  if valid_589108 != nil:
    section.add "pageSize", valid_589108
  var valid_589109 = query.getOrDefault("prettyPrint")
  valid_589109 = validateParameter(valid_589109, JBool, required = false,
                                 default = newJBool(true))
  if valid_589109 != nil:
    section.add "prettyPrint", valid_589109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589110: Call_ClassroomCoursesAnnouncementsList_589091;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of announcements that the requester is permitted to view.
  ## 
  ## Course students may only view `PUBLISHED` announcements. Course teachers
  ## and domain administrators may view all announcements.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access
  ## the requested course or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course does not exist.
  ## 
  let valid = call_589110.validator(path, query, header, formData, body)
  let scheme = call_589110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589110.url(scheme.get, call_589110.host, call_589110.base,
                         call_589110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589110, url, valid)

proc call*(call_589111: Call_ClassroomCoursesAnnouncementsList_589091;
          courseId: string; announcementStates: JsonNode = nil;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          orderBy: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## classroomCoursesAnnouncementsList
  ## Returns a list of announcements that the requester is permitted to view.
  ## 
  ## Course students may only view `PUBLISHED` announcements. Course teachers
  ## and domain administrators may view all announcements.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access
  ## the requested course or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course does not exist.
  ##   announcementStates: JArray
  ##                     : Restriction on the `state` of announcements returned.
  ## If this argument is left unspecified, the default value is `PUBLISHED`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : nextPageToken
  ## value returned from a previous
  ## list call,
  ## indicating that the subsequent page of results should be returned.
  ## 
  ## The list request
  ## must be otherwise identical to the one that resulted in this token.
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
  ##   orderBy: string
  ##          : Optional sort ordering for results. A comma-separated list of fields with
  ## an optional sort direction keyword. Supported field is `updateTime`.
  ## Supported direction keywords are `asc` and `desc`.
  ## If not specified, `updateTime desc` is the default behavior.
  ## Examples: `updateTime asc`, `updateTime`
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of items to return. Zero or unspecified indicates that the
  ## server may assign a maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589112 = newJObject()
  var query_589113 = newJObject()
  if announcementStates != nil:
    query_589113.add "announcementStates", announcementStates
  add(query_589113, "upload_protocol", newJString(uploadProtocol))
  add(query_589113, "fields", newJString(fields))
  add(query_589113, "pageToken", newJString(pageToken))
  add(query_589113, "quotaUser", newJString(quotaUser))
  add(query_589113, "alt", newJString(alt))
  add(query_589113, "oauth_token", newJString(oauthToken))
  add(query_589113, "callback", newJString(callback))
  add(query_589113, "access_token", newJString(accessToken))
  add(query_589113, "uploadType", newJString(uploadType))
  add(query_589113, "orderBy", newJString(orderBy))
  add(query_589113, "key", newJString(key))
  add(path_589112, "courseId", newJString(courseId))
  add(query_589113, "$.xgafv", newJString(Xgafv))
  add(query_589113, "pageSize", newJInt(pageSize))
  add(query_589113, "prettyPrint", newJBool(prettyPrint))
  result = call_589111.call(path_589112, query_589113, nil, nil, nil)

var classroomCoursesAnnouncementsList* = Call_ClassroomCoursesAnnouncementsList_589091(
    name: "classroomCoursesAnnouncementsList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/announcements",
    validator: validate_ClassroomCoursesAnnouncementsList_589092, base: "/",
    url: url_ClassroomCoursesAnnouncementsList_589093, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAnnouncementsGet_589135 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesAnnouncementsGet_589137(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "courseId" in path, "`courseId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "courseId"),
               (kind: ConstantSegment, value: "/announcements/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesAnnouncementsGet_589136(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns an announcement.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or announcement, or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course or announcement does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : Identifier of the announcement.
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589138 = path.getOrDefault("id")
  valid_589138 = validateParameter(valid_589138, JString, required = true,
                                 default = nil)
  if valid_589138 != nil:
    section.add "id", valid_589138
  var valid_589139 = path.getOrDefault("courseId")
  valid_589139 = validateParameter(valid_589139, JString, required = true,
                                 default = nil)
  if valid_589139 != nil:
    section.add "courseId", valid_589139
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
  var valid_589140 = query.getOrDefault("upload_protocol")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "upload_protocol", valid_589140
  var valid_589141 = query.getOrDefault("fields")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "fields", valid_589141
  var valid_589142 = query.getOrDefault("quotaUser")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = nil)
  if valid_589142 != nil:
    section.add "quotaUser", valid_589142
  var valid_589143 = query.getOrDefault("alt")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = newJString("json"))
  if valid_589143 != nil:
    section.add "alt", valid_589143
  var valid_589144 = query.getOrDefault("oauth_token")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "oauth_token", valid_589144
  var valid_589145 = query.getOrDefault("callback")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = nil)
  if valid_589145 != nil:
    section.add "callback", valid_589145
  var valid_589146 = query.getOrDefault("access_token")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = nil)
  if valid_589146 != nil:
    section.add "access_token", valid_589146
  var valid_589147 = query.getOrDefault("uploadType")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "uploadType", valid_589147
  var valid_589148 = query.getOrDefault("key")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "key", valid_589148
  var valid_589149 = query.getOrDefault("$.xgafv")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = newJString("1"))
  if valid_589149 != nil:
    section.add "$.xgafv", valid_589149
  var valid_589150 = query.getOrDefault("prettyPrint")
  valid_589150 = validateParameter(valid_589150, JBool, required = false,
                                 default = newJBool(true))
  if valid_589150 != nil:
    section.add "prettyPrint", valid_589150
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589151: Call_ClassroomCoursesAnnouncementsGet_589135;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns an announcement.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or announcement, or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course or announcement does not exist.
  ## 
  let valid = call_589151.validator(path, query, header, formData, body)
  let scheme = call_589151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589151.url(scheme.get, call_589151.host, call_589151.base,
                         call_589151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589151, url, valid)

proc call*(call_589152: Call_ClassroomCoursesAnnouncementsGet_589135; id: string;
          courseId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## classroomCoursesAnnouncementsGet
  ## Returns an announcement.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or announcement, or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course or announcement does not exist.
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
  ##   id: string (required)
  ##     : Identifier of the announcement.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589153 = newJObject()
  var query_589154 = newJObject()
  add(query_589154, "upload_protocol", newJString(uploadProtocol))
  add(query_589154, "fields", newJString(fields))
  add(query_589154, "quotaUser", newJString(quotaUser))
  add(query_589154, "alt", newJString(alt))
  add(query_589154, "oauth_token", newJString(oauthToken))
  add(query_589154, "callback", newJString(callback))
  add(query_589154, "access_token", newJString(accessToken))
  add(query_589154, "uploadType", newJString(uploadType))
  add(path_589153, "id", newJString(id))
  add(query_589154, "key", newJString(key))
  add(path_589153, "courseId", newJString(courseId))
  add(query_589154, "$.xgafv", newJString(Xgafv))
  add(query_589154, "prettyPrint", newJBool(prettyPrint))
  result = call_589152.call(path_589153, query_589154, nil, nil, nil)

var classroomCoursesAnnouncementsGet* = Call_ClassroomCoursesAnnouncementsGet_589135(
    name: "classroomCoursesAnnouncementsGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/announcements/{id}",
    validator: validate_ClassroomCoursesAnnouncementsGet_589136, base: "/",
    url: url_ClassroomCoursesAnnouncementsGet_589137, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAnnouncementsPatch_589175 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesAnnouncementsPatch_589177(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "courseId" in path, "`courseId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "courseId"),
               (kind: ConstantSegment, value: "/announcements/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesAnnouncementsPatch_589176(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates one or more fields of an announcement.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting developer project did not create
  ## the corresponding announcement or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `FAILED_PRECONDITION` if the requested announcement has already been
  ## deleted.
  ## * `NOT_FOUND` if the requested course or announcement does not exist
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : Identifier of the announcement.
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589178 = path.getOrDefault("id")
  valid_589178 = validateParameter(valid_589178, JString, required = true,
                                 default = nil)
  if valid_589178 != nil:
    section.add "id", valid_589178
  var valid_589179 = path.getOrDefault("courseId")
  valid_589179 = validateParameter(valid_589179, JString, required = true,
                                 default = nil)
  if valid_589179 != nil:
    section.add "courseId", valid_589179
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
  ##   updateMask: JString
  ##             : Mask that identifies which fields on the announcement to update.
  ## This field is required to do an update. The update fails if invalid
  ## fields are specified. If a field supports empty values, it can be cleared
  ## by specifying it in the update mask and not in the Announcement object. If
  ## a field that does not support empty values is included in the update mask
  ## and not set in the Announcement object, an `INVALID_ARGUMENT` error will be
  ## returned.
  ## 
  ## The following fields may be specified by teachers:
  ## 
  ## * `text`
  ## * `state`
  ## * `scheduled_time`
  section = newJObject()
  var valid_589180 = query.getOrDefault("upload_protocol")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "upload_protocol", valid_589180
  var valid_589181 = query.getOrDefault("fields")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "fields", valid_589181
  var valid_589182 = query.getOrDefault("quotaUser")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "quotaUser", valid_589182
  var valid_589183 = query.getOrDefault("alt")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = newJString("json"))
  if valid_589183 != nil:
    section.add "alt", valid_589183
  var valid_589184 = query.getOrDefault("oauth_token")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = nil)
  if valid_589184 != nil:
    section.add "oauth_token", valid_589184
  var valid_589185 = query.getOrDefault("callback")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = nil)
  if valid_589185 != nil:
    section.add "callback", valid_589185
  var valid_589186 = query.getOrDefault("access_token")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "access_token", valid_589186
  var valid_589187 = query.getOrDefault("uploadType")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = nil)
  if valid_589187 != nil:
    section.add "uploadType", valid_589187
  var valid_589188 = query.getOrDefault("key")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = nil)
  if valid_589188 != nil:
    section.add "key", valid_589188
  var valid_589189 = query.getOrDefault("$.xgafv")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = newJString("1"))
  if valid_589189 != nil:
    section.add "$.xgafv", valid_589189
  var valid_589190 = query.getOrDefault("prettyPrint")
  valid_589190 = validateParameter(valid_589190, JBool, required = false,
                                 default = newJBool(true))
  if valid_589190 != nil:
    section.add "prettyPrint", valid_589190
  var valid_589191 = query.getOrDefault("updateMask")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = nil)
  if valid_589191 != nil:
    section.add "updateMask", valid_589191
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

proc call*(call_589193: Call_ClassroomCoursesAnnouncementsPatch_589175;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates one or more fields of an announcement.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting developer project did not create
  ## the corresponding announcement or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `FAILED_PRECONDITION` if the requested announcement has already been
  ## deleted.
  ## * `NOT_FOUND` if the requested course or announcement does not exist
  ## 
  let valid = call_589193.validator(path, query, header, formData, body)
  let scheme = call_589193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589193.url(scheme.get, call_589193.host, call_589193.base,
                         call_589193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589193, url, valid)

proc call*(call_589194: Call_ClassroomCoursesAnnouncementsPatch_589175; id: string;
          courseId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## classroomCoursesAnnouncementsPatch
  ## Updates one or more fields of an announcement.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting developer project did not create
  ## the corresponding announcement or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `FAILED_PRECONDITION` if the requested announcement has already been
  ## deleted.
  ## * `NOT_FOUND` if the requested course or announcement does not exist
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
  ##   id: string (required)
  ##     : Identifier of the announcement.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: string
  ##             : Mask that identifies which fields on the announcement to update.
  ## This field is required to do an update. The update fails if invalid
  ## fields are specified. If a field supports empty values, it can be cleared
  ## by specifying it in the update mask and not in the Announcement object. If
  ## a field that does not support empty values is included in the update mask
  ## and not set in the Announcement object, an `INVALID_ARGUMENT` error will be
  ## returned.
  ## 
  ## The following fields may be specified by teachers:
  ## 
  ## * `text`
  ## * `state`
  ## * `scheduled_time`
  var path_589195 = newJObject()
  var query_589196 = newJObject()
  var body_589197 = newJObject()
  add(query_589196, "upload_protocol", newJString(uploadProtocol))
  add(query_589196, "fields", newJString(fields))
  add(query_589196, "quotaUser", newJString(quotaUser))
  add(query_589196, "alt", newJString(alt))
  add(query_589196, "oauth_token", newJString(oauthToken))
  add(query_589196, "callback", newJString(callback))
  add(query_589196, "access_token", newJString(accessToken))
  add(query_589196, "uploadType", newJString(uploadType))
  add(path_589195, "id", newJString(id))
  add(query_589196, "key", newJString(key))
  add(path_589195, "courseId", newJString(courseId))
  add(query_589196, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589197 = body
  add(query_589196, "prettyPrint", newJBool(prettyPrint))
  add(query_589196, "updateMask", newJString(updateMask))
  result = call_589194.call(path_589195, query_589196, nil, nil, body_589197)

var classroomCoursesAnnouncementsPatch* = Call_ClassroomCoursesAnnouncementsPatch_589175(
    name: "classroomCoursesAnnouncementsPatch", meth: HttpMethod.HttpPatch,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/announcements/{id}",
    validator: validate_ClassroomCoursesAnnouncementsPatch_589176, base: "/",
    url: url_ClassroomCoursesAnnouncementsPatch_589177, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAnnouncementsDelete_589155 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesAnnouncementsDelete_589157(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "courseId" in path, "`courseId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "courseId"),
               (kind: ConstantSegment, value: "/announcements/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesAnnouncementsDelete_589156(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an announcement.
  ## 
  ## This request must be made by the Developer Console project of the
  ## [OAuth client ID](https://support.google.com/cloud/answer/6158849) used to
  ## create the corresponding announcement item.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting developer project did not create
  ## the corresponding announcement, if the requesting user is not permitted
  ## to delete the requested course or for access errors.
  ## * `FAILED_PRECONDITION` if the requested announcement has already been
  ## deleted.
  ## * `NOT_FOUND` if no course exists with the requested ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : Identifier of the announcement to delete.
  ## This identifier is a Classroom-assigned identifier.
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589158 = path.getOrDefault("id")
  valid_589158 = validateParameter(valid_589158, JString, required = true,
                                 default = nil)
  if valid_589158 != nil:
    section.add "id", valid_589158
  var valid_589159 = path.getOrDefault("courseId")
  valid_589159 = validateParameter(valid_589159, JString, required = true,
                                 default = nil)
  if valid_589159 != nil:
    section.add "courseId", valid_589159
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
  var valid_589160 = query.getOrDefault("upload_protocol")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "upload_protocol", valid_589160
  var valid_589161 = query.getOrDefault("fields")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "fields", valid_589161
  var valid_589162 = query.getOrDefault("quotaUser")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "quotaUser", valid_589162
  var valid_589163 = query.getOrDefault("alt")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = newJString("json"))
  if valid_589163 != nil:
    section.add "alt", valid_589163
  var valid_589164 = query.getOrDefault("oauth_token")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "oauth_token", valid_589164
  var valid_589165 = query.getOrDefault("callback")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "callback", valid_589165
  var valid_589166 = query.getOrDefault("access_token")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = nil)
  if valid_589166 != nil:
    section.add "access_token", valid_589166
  var valid_589167 = query.getOrDefault("uploadType")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = nil)
  if valid_589167 != nil:
    section.add "uploadType", valid_589167
  var valid_589168 = query.getOrDefault("key")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "key", valid_589168
  var valid_589169 = query.getOrDefault("$.xgafv")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = newJString("1"))
  if valid_589169 != nil:
    section.add "$.xgafv", valid_589169
  var valid_589170 = query.getOrDefault("prettyPrint")
  valid_589170 = validateParameter(valid_589170, JBool, required = false,
                                 default = newJBool(true))
  if valid_589170 != nil:
    section.add "prettyPrint", valid_589170
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589171: Call_ClassroomCoursesAnnouncementsDelete_589155;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an announcement.
  ## 
  ## This request must be made by the Developer Console project of the
  ## [OAuth client ID](https://support.google.com/cloud/answer/6158849) used to
  ## create the corresponding announcement item.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting developer project did not create
  ## the corresponding announcement, if the requesting user is not permitted
  ## to delete the requested course or for access errors.
  ## * `FAILED_PRECONDITION` if the requested announcement has already been
  ## deleted.
  ## * `NOT_FOUND` if no course exists with the requested ID.
  ## 
  let valid = call_589171.validator(path, query, header, formData, body)
  let scheme = call_589171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589171.url(scheme.get, call_589171.host, call_589171.base,
                         call_589171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589171, url, valid)

proc call*(call_589172: Call_ClassroomCoursesAnnouncementsDelete_589155;
          id: string; courseId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## classroomCoursesAnnouncementsDelete
  ## Deletes an announcement.
  ## 
  ## This request must be made by the Developer Console project of the
  ## [OAuth client ID](https://support.google.com/cloud/answer/6158849) used to
  ## create the corresponding announcement item.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting developer project did not create
  ## the corresponding announcement, if the requesting user is not permitted
  ## to delete the requested course or for access errors.
  ## * `FAILED_PRECONDITION` if the requested announcement has already been
  ## deleted.
  ## * `NOT_FOUND` if no course exists with the requested ID.
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
  ##   id: string (required)
  ##     : Identifier of the announcement to delete.
  ## This identifier is a Classroom-assigned identifier.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589173 = newJObject()
  var query_589174 = newJObject()
  add(query_589174, "upload_protocol", newJString(uploadProtocol))
  add(query_589174, "fields", newJString(fields))
  add(query_589174, "quotaUser", newJString(quotaUser))
  add(query_589174, "alt", newJString(alt))
  add(query_589174, "oauth_token", newJString(oauthToken))
  add(query_589174, "callback", newJString(callback))
  add(query_589174, "access_token", newJString(accessToken))
  add(query_589174, "uploadType", newJString(uploadType))
  add(path_589173, "id", newJString(id))
  add(query_589174, "key", newJString(key))
  add(path_589173, "courseId", newJString(courseId))
  add(query_589174, "$.xgafv", newJString(Xgafv))
  add(query_589174, "prettyPrint", newJBool(prettyPrint))
  result = call_589172.call(path_589173, query_589174, nil, nil, nil)

var classroomCoursesAnnouncementsDelete* = Call_ClassroomCoursesAnnouncementsDelete_589155(
    name: "classroomCoursesAnnouncementsDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/announcements/{id}",
    validator: validate_ClassroomCoursesAnnouncementsDelete_589156, base: "/",
    url: url_ClassroomCoursesAnnouncementsDelete_589157, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAnnouncementsModifyAssignees_589198 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesAnnouncementsModifyAssignees_589200(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "courseId" in path, "`courseId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "courseId"),
               (kind: ConstantSegment, value: "/announcements/"),
               (kind: VariableSegment, value: "id"),
               (kind: ConstantSegment, value: ":modifyAssignees")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesAnnouncementsModifyAssignees_589199(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies assignee mode and options of an announcement.
  ## 
  ## Only a teacher of the course that contains the announcement may
  ## call this method.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or course work or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course or course work does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : Identifier of the announcement.
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589201 = path.getOrDefault("id")
  valid_589201 = validateParameter(valid_589201, JString, required = true,
                                 default = nil)
  if valid_589201 != nil:
    section.add "id", valid_589201
  var valid_589202 = path.getOrDefault("courseId")
  valid_589202 = validateParameter(valid_589202, JString, required = true,
                                 default = nil)
  if valid_589202 != nil:
    section.add "courseId", valid_589202
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
  var valid_589203 = query.getOrDefault("upload_protocol")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = nil)
  if valid_589203 != nil:
    section.add "upload_protocol", valid_589203
  var valid_589204 = query.getOrDefault("fields")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "fields", valid_589204
  var valid_589205 = query.getOrDefault("quotaUser")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = nil)
  if valid_589205 != nil:
    section.add "quotaUser", valid_589205
  var valid_589206 = query.getOrDefault("alt")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = newJString("json"))
  if valid_589206 != nil:
    section.add "alt", valid_589206
  var valid_589207 = query.getOrDefault("oauth_token")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "oauth_token", valid_589207
  var valid_589208 = query.getOrDefault("callback")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "callback", valid_589208
  var valid_589209 = query.getOrDefault("access_token")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = nil)
  if valid_589209 != nil:
    section.add "access_token", valid_589209
  var valid_589210 = query.getOrDefault("uploadType")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = nil)
  if valid_589210 != nil:
    section.add "uploadType", valid_589210
  var valid_589211 = query.getOrDefault("key")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = nil)
  if valid_589211 != nil:
    section.add "key", valid_589211
  var valid_589212 = query.getOrDefault("$.xgafv")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = newJString("1"))
  if valid_589212 != nil:
    section.add "$.xgafv", valid_589212
  var valid_589213 = query.getOrDefault("prettyPrint")
  valid_589213 = validateParameter(valid_589213, JBool, required = false,
                                 default = newJBool(true))
  if valid_589213 != nil:
    section.add "prettyPrint", valid_589213
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

proc call*(call_589215: Call_ClassroomCoursesAnnouncementsModifyAssignees_589198;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modifies assignee mode and options of an announcement.
  ## 
  ## Only a teacher of the course that contains the announcement may
  ## call this method.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or course work or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course or course work does not exist.
  ## 
  let valid = call_589215.validator(path, query, header, formData, body)
  let scheme = call_589215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589215.url(scheme.get, call_589215.host, call_589215.base,
                         call_589215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589215, url, valid)

proc call*(call_589216: Call_ClassroomCoursesAnnouncementsModifyAssignees_589198;
          id: string; courseId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## classroomCoursesAnnouncementsModifyAssignees
  ## Modifies assignee mode and options of an announcement.
  ## 
  ## Only a teacher of the course that contains the announcement may
  ## call this method.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or course work or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course or course work does not exist.
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
  ##   id: string (required)
  ##     : Identifier of the announcement.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589217 = newJObject()
  var query_589218 = newJObject()
  var body_589219 = newJObject()
  add(query_589218, "upload_protocol", newJString(uploadProtocol))
  add(query_589218, "fields", newJString(fields))
  add(query_589218, "quotaUser", newJString(quotaUser))
  add(query_589218, "alt", newJString(alt))
  add(query_589218, "oauth_token", newJString(oauthToken))
  add(query_589218, "callback", newJString(callback))
  add(query_589218, "access_token", newJString(accessToken))
  add(query_589218, "uploadType", newJString(uploadType))
  add(path_589217, "id", newJString(id))
  add(query_589218, "key", newJString(key))
  add(path_589217, "courseId", newJString(courseId))
  add(query_589218, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589219 = body
  add(query_589218, "prettyPrint", newJBool(prettyPrint))
  result = call_589216.call(path_589217, query_589218, nil, nil, body_589219)

var classroomCoursesAnnouncementsModifyAssignees* = Call_ClassroomCoursesAnnouncementsModifyAssignees_589198(
    name: "classroomCoursesAnnouncementsModifyAssignees",
    meth: HttpMethod.HttpPost, host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/announcements/{id}:modifyAssignees",
    validator: validate_ClassroomCoursesAnnouncementsModifyAssignees_589199,
    base: "/", url: url_ClassroomCoursesAnnouncementsModifyAssignees_589200,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkCreate_589243 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesCourseWorkCreate_589245(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "courseId" in path, "`courseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "courseId"),
               (kind: ConstantSegment, value: "/courseWork")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesCourseWorkCreate_589244(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates course work.
  ## 
  ## The resulting course work (and corresponding student submissions) are
  ## associated with the Developer Console project of the
  ## [OAuth client ID](https://support.google.com/cloud/answer/6158849) used to
  ## make the request. Classroom API requests to modify course work and student
  ## submissions must be made with an OAuth client ID from the associated
  ## Developer Console project.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course, create course work in the requested course, share a
  ## Drive attachment, or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course does not exist.
  ## * `FAILED_PRECONDITION` for the following request error:
  ##     * AttachmentNotVisible
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `courseId` field"
  var valid_589246 = path.getOrDefault("courseId")
  valid_589246 = validateParameter(valid_589246, JString, required = true,
                                 default = nil)
  if valid_589246 != nil:
    section.add "courseId", valid_589246
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
  var valid_589247 = query.getOrDefault("upload_protocol")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = nil)
  if valid_589247 != nil:
    section.add "upload_protocol", valid_589247
  var valid_589248 = query.getOrDefault("fields")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "fields", valid_589248
  var valid_589249 = query.getOrDefault("quotaUser")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = nil)
  if valid_589249 != nil:
    section.add "quotaUser", valid_589249
  var valid_589250 = query.getOrDefault("alt")
  valid_589250 = validateParameter(valid_589250, JString, required = false,
                                 default = newJString("json"))
  if valid_589250 != nil:
    section.add "alt", valid_589250
  var valid_589251 = query.getOrDefault("oauth_token")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = nil)
  if valid_589251 != nil:
    section.add "oauth_token", valid_589251
  var valid_589252 = query.getOrDefault("callback")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = nil)
  if valid_589252 != nil:
    section.add "callback", valid_589252
  var valid_589253 = query.getOrDefault("access_token")
  valid_589253 = validateParameter(valid_589253, JString, required = false,
                                 default = nil)
  if valid_589253 != nil:
    section.add "access_token", valid_589253
  var valid_589254 = query.getOrDefault("uploadType")
  valid_589254 = validateParameter(valid_589254, JString, required = false,
                                 default = nil)
  if valid_589254 != nil:
    section.add "uploadType", valid_589254
  var valid_589255 = query.getOrDefault("key")
  valid_589255 = validateParameter(valid_589255, JString, required = false,
                                 default = nil)
  if valid_589255 != nil:
    section.add "key", valid_589255
  var valid_589256 = query.getOrDefault("$.xgafv")
  valid_589256 = validateParameter(valid_589256, JString, required = false,
                                 default = newJString("1"))
  if valid_589256 != nil:
    section.add "$.xgafv", valid_589256
  var valid_589257 = query.getOrDefault("prettyPrint")
  valid_589257 = validateParameter(valid_589257, JBool, required = false,
                                 default = newJBool(true))
  if valid_589257 != nil:
    section.add "prettyPrint", valid_589257
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

proc call*(call_589259: Call_ClassroomCoursesCourseWorkCreate_589243;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates course work.
  ## 
  ## The resulting course work (and corresponding student submissions) are
  ## associated with the Developer Console project of the
  ## [OAuth client ID](https://support.google.com/cloud/answer/6158849) used to
  ## make the request. Classroom API requests to modify course work and student
  ## submissions must be made with an OAuth client ID from the associated
  ## Developer Console project.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course, create course work in the requested course, share a
  ## Drive attachment, or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course does not exist.
  ## * `FAILED_PRECONDITION` for the following request error:
  ##     * AttachmentNotVisible
  ## 
  let valid = call_589259.validator(path, query, header, formData, body)
  let scheme = call_589259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589259.url(scheme.get, call_589259.host, call_589259.base,
                         call_589259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589259, url, valid)

proc call*(call_589260: Call_ClassroomCoursesCourseWorkCreate_589243;
          courseId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## classroomCoursesCourseWorkCreate
  ## Creates course work.
  ## 
  ## The resulting course work (and corresponding student submissions) are
  ## associated with the Developer Console project of the
  ## [OAuth client ID](https://support.google.com/cloud/answer/6158849) used to
  ## make the request. Classroom API requests to modify course work and student
  ## submissions must be made with an OAuth client ID from the associated
  ## Developer Console project.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course, create course work in the requested course, share a
  ## Drive attachment, or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course does not exist.
  ## * `FAILED_PRECONDITION` for the following request error:
  ##     * AttachmentNotVisible
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
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589261 = newJObject()
  var query_589262 = newJObject()
  var body_589263 = newJObject()
  add(query_589262, "upload_protocol", newJString(uploadProtocol))
  add(query_589262, "fields", newJString(fields))
  add(query_589262, "quotaUser", newJString(quotaUser))
  add(query_589262, "alt", newJString(alt))
  add(query_589262, "oauth_token", newJString(oauthToken))
  add(query_589262, "callback", newJString(callback))
  add(query_589262, "access_token", newJString(accessToken))
  add(query_589262, "uploadType", newJString(uploadType))
  add(query_589262, "key", newJString(key))
  add(path_589261, "courseId", newJString(courseId))
  add(query_589262, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589263 = body
  add(query_589262, "prettyPrint", newJBool(prettyPrint))
  result = call_589260.call(path_589261, query_589262, nil, nil, body_589263)

var classroomCoursesCourseWorkCreate* = Call_ClassroomCoursesCourseWorkCreate_589243(
    name: "classroomCoursesCourseWorkCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork",
    validator: validate_ClassroomCoursesCourseWorkCreate_589244, base: "/",
    url: url_ClassroomCoursesCourseWorkCreate_589245, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkList_589220 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesCourseWorkList_589222(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "courseId" in path, "`courseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "courseId"),
               (kind: ConstantSegment, value: "/courseWork")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesCourseWorkList_589221(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of course work that the requester is permitted to view.
  ## 
  ## Course students may only view `PUBLISHED` course work. Course teachers
  ## and domain administrators may view all course work.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access
  ## the requested course or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `courseId` field"
  var valid_589223 = path.getOrDefault("courseId")
  valid_589223 = validateParameter(valid_589223, JString, required = true,
                                 default = nil)
  if valid_589223 != nil:
    section.add "courseId", valid_589223
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : nextPageToken
  ## value returned from a previous
  ## list call,
  ## indicating that the subsequent page of results should be returned.
  ## 
  ## The list request
  ## must be otherwise identical to the one that resulted in this token.
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
  ##   orderBy: JString
  ##          : Optional sort ordering for results. A comma-separated list of fields with
  ## an optional sort direction keyword. Supported fields are `updateTime`
  ## and `dueDate`. Supported direction keywords are `asc` and `desc`.
  ## If not specified, `updateTime desc` is the default behavior.
  ## Examples: `dueDate asc,updateTime desc`, `updateTime,dueDate desc`
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   courseWorkStates: JArray
  ##                   : Restriction on the work status to return. Only courseWork that matches
  ## is returned. If unspecified, items with a work status of `PUBLISHED`
  ## is returned.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Maximum number of items to return. Zero or unspecified indicates that the
  ## server may assign a maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589224 = query.getOrDefault("upload_protocol")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = nil)
  if valid_589224 != nil:
    section.add "upload_protocol", valid_589224
  var valid_589225 = query.getOrDefault("fields")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = nil)
  if valid_589225 != nil:
    section.add "fields", valid_589225
  var valid_589226 = query.getOrDefault("pageToken")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "pageToken", valid_589226
  var valid_589227 = query.getOrDefault("quotaUser")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "quotaUser", valid_589227
  var valid_589228 = query.getOrDefault("alt")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = newJString("json"))
  if valid_589228 != nil:
    section.add "alt", valid_589228
  var valid_589229 = query.getOrDefault("oauth_token")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = nil)
  if valid_589229 != nil:
    section.add "oauth_token", valid_589229
  var valid_589230 = query.getOrDefault("callback")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = nil)
  if valid_589230 != nil:
    section.add "callback", valid_589230
  var valid_589231 = query.getOrDefault("access_token")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = nil)
  if valid_589231 != nil:
    section.add "access_token", valid_589231
  var valid_589232 = query.getOrDefault("uploadType")
  valid_589232 = validateParameter(valid_589232, JString, required = false,
                                 default = nil)
  if valid_589232 != nil:
    section.add "uploadType", valid_589232
  var valid_589233 = query.getOrDefault("orderBy")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = nil)
  if valid_589233 != nil:
    section.add "orderBy", valid_589233
  var valid_589234 = query.getOrDefault("key")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "key", valid_589234
  var valid_589235 = query.getOrDefault("courseWorkStates")
  valid_589235 = validateParameter(valid_589235, JArray, required = false,
                                 default = nil)
  if valid_589235 != nil:
    section.add "courseWorkStates", valid_589235
  var valid_589236 = query.getOrDefault("$.xgafv")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = newJString("1"))
  if valid_589236 != nil:
    section.add "$.xgafv", valid_589236
  var valid_589237 = query.getOrDefault("pageSize")
  valid_589237 = validateParameter(valid_589237, JInt, required = false, default = nil)
  if valid_589237 != nil:
    section.add "pageSize", valid_589237
  var valid_589238 = query.getOrDefault("prettyPrint")
  valid_589238 = validateParameter(valid_589238, JBool, required = false,
                                 default = newJBool(true))
  if valid_589238 != nil:
    section.add "prettyPrint", valid_589238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589239: Call_ClassroomCoursesCourseWorkList_589220; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of course work that the requester is permitted to view.
  ## 
  ## Course students may only view `PUBLISHED` course work. Course teachers
  ## and domain administrators may view all course work.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access
  ## the requested course or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course does not exist.
  ## 
  let valid = call_589239.validator(path, query, header, formData, body)
  let scheme = call_589239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589239.url(scheme.get, call_589239.host, call_589239.base,
                         call_589239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589239, url, valid)

proc call*(call_589240: Call_ClassroomCoursesCourseWorkList_589220;
          courseId: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; orderBy: string = ""; key: string = "";
          courseWorkStates: JsonNode = nil; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## classroomCoursesCourseWorkList
  ## Returns a list of course work that the requester is permitted to view.
  ## 
  ## Course students may only view `PUBLISHED` course work. Course teachers
  ## and domain administrators may view all course work.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access
  ## the requested course or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course does not exist.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : nextPageToken
  ## value returned from a previous
  ## list call,
  ## indicating that the subsequent page of results should be returned.
  ## 
  ## The list request
  ## must be otherwise identical to the one that resulted in this token.
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
  ##   orderBy: string
  ##          : Optional sort ordering for results. A comma-separated list of fields with
  ## an optional sort direction keyword. Supported fields are `updateTime`
  ## and `dueDate`. Supported direction keywords are `asc` and `desc`.
  ## If not specified, `updateTime desc` is the default behavior.
  ## Examples: `dueDate asc,updateTime desc`, `updateTime,dueDate desc`
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   courseWorkStates: JArray
  ##                   : Restriction on the work status to return. Only courseWork that matches
  ## is returned. If unspecified, items with a work status of `PUBLISHED`
  ## is returned.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of items to return. Zero or unspecified indicates that the
  ## server may assign a maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589241 = newJObject()
  var query_589242 = newJObject()
  add(query_589242, "upload_protocol", newJString(uploadProtocol))
  add(query_589242, "fields", newJString(fields))
  add(query_589242, "pageToken", newJString(pageToken))
  add(query_589242, "quotaUser", newJString(quotaUser))
  add(query_589242, "alt", newJString(alt))
  add(query_589242, "oauth_token", newJString(oauthToken))
  add(query_589242, "callback", newJString(callback))
  add(query_589242, "access_token", newJString(accessToken))
  add(query_589242, "uploadType", newJString(uploadType))
  add(query_589242, "orderBy", newJString(orderBy))
  add(query_589242, "key", newJString(key))
  if courseWorkStates != nil:
    query_589242.add "courseWorkStates", courseWorkStates
  add(path_589241, "courseId", newJString(courseId))
  add(query_589242, "$.xgafv", newJString(Xgafv))
  add(query_589242, "pageSize", newJInt(pageSize))
  add(query_589242, "prettyPrint", newJBool(prettyPrint))
  result = call_589240.call(path_589241, query_589242, nil, nil, nil)

var classroomCoursesCourseWorkList* = Call_ClassroomCoursesCourseWorkList_589220(
    name: "classroomCoursesCourseWorkList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork",
    validator: validate_ClassroomCoursesCourseWorkList_589221, base: "/",
    url: url_ClassroomCoursesCourseWorkList_589222, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkStudentSubmissionsList_589264 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesCourseWorkStudentSubmissionsList_589266(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "courseId" in path, "`courseId` is a required path parameter"
  assert "courseWorkId" in path, "`courseWorkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "courseId"),
               (kind: ConstantSegment, value: "/courseWork/"),
               (kind: VariableSegment, value: "courseWorkId"),
               (kind: ConstantSegment, value: "/studentSubmissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesCourseWorkStudentSubmissionsList_589265(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns a list of student submissions that the requester is permitted to
  ## view, factoring in the OAuth scopes of the request.
  ## `-` may be specified as the `course_work_id` to include student
  ## submissions for multiple course work items.
  ## 
  ## Course students may only view their own work. Course teachers
  ## and domain administrators may view all student submissions.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or course work, or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   courseWorkId: JString (required)
  ##               : Identifier of the student work to request.
  ## This may be set to the string literal `"-"` to request student work for
  ## all course work in the specified course.
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `courseWorkId` field"
  var valid_589267 = path.getOrDefault("courseWorkId")
  valid_589267 = validateParameter(valid_589267, JString, required = true,
                                 default = nil)
  if valid_589267 != nil:
    section.add "courseWorkId", valid_589267
  var valid_589268 = path.getOrDefault("courseId")
  valid_589268 = validateParameter(valid_589268, JString, required = true,
                                 default = nil)
  if valid_589268 != nil:
    section.add "courseId", valid_589268
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : nextPageToken
  ## value returned from a previous
  ## list call,
  ## indicating that the subsequent page of results should be returned.
  ## 
  ## The list request
  ## must be otherwise identical to the one that resulted in this token.
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
  ##   states: JArray
  ##         : Requested submission states. If specified, returned student submissions
  ## match one of the specified submission states.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Maximum number of items to return. Zero or unspecified indicates that the
  ## server may assign a maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   late: JString
  ##       : Requested lateness value. If specified, returned student submissions are
  ## restricted by the requested value.
  ## If unspecified, submissions are returned regardless of `late` value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   userId: JString
  ##         : Optional argument to restrict returned student work to those owned by the
  ## student with the specified identifier. The identifier can be one of the
  ## following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  section = newJObject()
  var valid_589269 = query.getOrDefault("upload_protocol")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = nil)
  if valid_589269 != nil:
    section.add "upload_protocol", valid_589269
  var valid_589270 = query.getOrDefault("fields")
  valid_589270 = validateParameter(valid_589270, JString, required = false,
                                 default = nil)
  if valid_589270 != nil:
    section.add "fields", valid_589270
  var valid_589271 = query.getOrDefault("pageToken")
  valid_589271 = validateParameter(valid_589271, JString, required = false,
                                 default = nil)
  if valid_589271 != nil:
    section.add "pageToken", valid_589271
  var valid_589272 = query.getOrDefault("quotaUser")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = nil)
  if valid_589272 != nil:
    section.add "quotaUser", valid_589272
  var valid_589273 = query.getOrDefault("alt")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = newJString("json"))
  if valid_589273 != nil:
    section.add "alt", valid_589273
  var valid_589274 = query.getOrDefault("oauth_token")
  valid_589274 = validateParameter(valid_589274, JString, required = false,
                                 default = nil)
  if valid_589274 != nil:
    section.add "oauth_token", valid_589274
  var valid_589275 = query.getOrDefault("callback")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = nil)
  if valid_589275 != nil:
    section.add "callback", valid_589275
  var valid_589276 = query.getOrDefault("access_token")
  valid_589276 = validateParameter(valid_589276, JString, required = false,
                                 default = nil)
  if valid_589276 != nil:
    section.add "access_token", valid_589276
  var valid_589277 = query.getOrDefault("uploadType")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = nil)
  if valid_589277 != nil:
    section.add "uploadType", valid_589277
  var valid_589278 = query.getOrDefault("key")
  valid_589278 = validateParameter(valid_589278, JString, required = false,
                                 default = nil)
  if valid_589278 != nil:
    section.add "key", valid_589278
  var valid_589279 = query.getOrDefault("states")
  valid_589279 = validateParameter(valid_589279, JArray, required = false,
                                 default = nil)
  if valid_589279 != nil:
    section.add "states", valid_589279
  var valid_589280 = query.getOrDefault("$.xgafv")
  valid_589280 = validateParameter(valid_589280, JString, required = false,
                                 default = newJString("1"))
  if valid_589280 != nil:
    section.add "$.xgafv", valid_589280
  var valid_589281 = query.getOrDefault("pageSize")
  valid_589281 = validateParameter(valid_589281, JInt, required = false, default = nil)
  if valid_589281 != nil:
    section.add "pageSize", valid_589281
  var valid_589282 = query.getOrDefault("late")
  valid_589282 = validateParameter(valid_589282, JString, required = false, default = newJString(
      "LATE_VALUES_UNSPECIFIED"))
  if valid_589282 != nil:
    section.add "late", valid_589282
  var valid_589283 = query.getOrDefault("prettyPrint")
  valid_589283 = validateParameter(valid_589283, JBool, required = false,
                                 default = newJBool(true))
  if valid_589283 != nil:
    section.add "prettyPrint", valid_589283
  var valid_589284 = query.getOrDefault("userId")
  valid_589284 = validateParameter(valid_589284, JString, required = false,
                                 default = nil)
  if valid_589284 != nil:
    section.add "userId", valid_589284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589285: Call_ClassroomCoursesCourseWorkStudentSubmissionsList_589264;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of student submissions that the requester is permitted to
  ## view, factoring in the OAuth scopes of the request.
  ## `-` may be specified as the `course_work_id` to include student
  ## submissions for multiple course work items.
  ## 
  ## Course students may only view their own work. Course teachers
  ## and domain administrators may view all student submissions.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or course work, or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course does not exist.
  ## 
  let valid = call_589285.validator(path, query, header, formData, body)
  let scheme = call_589285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589285.url(scheme.get, call_589285.host, call_589285.base,
                         call_589285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589285, url, valid)

proc call*(call_589286: Call_ClassroomCoursesCourseWorkStudentSubmissionsList_589264;
          courseWorkId: string; courseId: string; uploadProtocol: string = "";
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          states: JsonNode = nil; Xgafv: string = "1"; pageSize: int = 0;
          late: string = "LATE_VALUES_UNSPECIFIED"; prettyPrint: bool = true;
          userId: string = ""): Recallable =
  ## classroomCoursesCourseWorkStudentSubmissionsList
  ## Returns a list of student submissions that the requester is permitted to
  ## view, factoring in the OAuth scopes of the request.
  ## `-` may be specified as the `course_work_id` to include student
  ## submissions for multiple course work items.
  ## 
  ## Course students may only view their own work. Course teachers
  ## and domain administrators may view all student submissions.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or course work, or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course does not exist.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : nextPageToken
  ## value returned from a previous
  ## list call,
  ## indicating that the subsequent page of results should be returned.
  ## 
  ## The list request
  ## must be otherwise identical to the one that resulted in this token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   courseWorkId: string (required)
  ##               : Identifier of the student work to request.
  ## This may be set to the string literal `"-"` to request student work for
  ## all course work in the specified course.
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
  ##   states: JArray
  ##         : Requested submission states. If specified, returned student submissions
  ## match one of the specified submission states.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of items to return. Zero or unspecified indicates that the
  ## server may assign a maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   late: string
  ##       : Requested lateness value. If specified, returned student submissions are
  ## restricted by the requested value.
  ## If unspecified, submissions are returned regardless of `late` value.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string
  ##         : Optional argument to restrict returned student work to those owned by the
  ## student with the specified identifier. The identifier can be one of the
  ## following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  var path_589287 = newJObject()
  var query_589288 = newJObject()
  add(query_589288, "upload_protocol", newJString(uploadProtocol))
  add(query_589288, "fields", newJString(fields))
  add(query_589288, "pageToken", newJString(pageToken))
  add(query_589288, "quotaUser", newJString(quotaUser))
  add(path_589287, "courseWorkId", newJString(courseWorkId))
  add(query_589288, "alt", newJString(alt))
  add(query_589288, "oauth_token", newJString(oauthToken))
  add(query_589288, "callback", newJString(callback))
  add(query_589288, "access_token", newJString(accessToken))
  add(query_589288, "uploadType", newJString(uploadType))
  add(query_589288, "key", newJString(key))
  if states != nil:
    query_589288.add "states", states
  add(path_589287, "courseId", newJString(courseId))
  add(query_589288, "$.xgafv", newJString(Xgafv))
  add(query_589288, "pageSize", newJInt(pageSize))
  add(query_589288, "late", newJString(late))
  add(query_589288, "prettyPrint", newJBool(prettyPrint))
  add(query_589288, "userId", newJString(userId))
  result = call_589286.call(path_589287, query_589288, nil, nil, nil)

var classroomCoursesCourseWorkStudentSubmissionsList* = Call_ClassroomCoursesCourseWorkStudentSubmissionsList_589264(
    name: "classroomCoursesCourseWorkStudentSubmissionsList",
    meth: HttpMethod.HttpGet, host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork/{courseWorkId}/studentSubmissions",
    validator: validate_ClassroomCoursesCourseWorkStudentSubmissionsList_589265,
    base: "/", url: url_ClassroomCoursesCourseWorkStudentSubmissionsList_589266,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkStudentSubmissionsGet_589289 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesCourseWorkStudentSubmissionsGet_589291(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "courseId" in path, "`courseId` is a required path parameter"
  assert "courseWorkId" in path, "`courseWorkId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "courseId"),
               (kind: ConstantSegment, value: "/courseWork/"),
               (kind: VariableSegment, value: "courseWorkId"),
               (kind: ConstantSegment, value: "/studentSubmissions/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesCourseWorkStudentSubmissionsGet_589290(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns a student submission.
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course, course work, or student submission or for
  ## access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course, course work, or student submission
  ## does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   courseWorkId: JString (required)
  ##               : Identifier of the course work.
  ##   id: JString (required)
  ##     : Identifier of the student submission.
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `courseWorkId` field"
  var valid_589292 = path.getOrDefault("courseWorkId")
  valid_589292 = validateParameter(valid_589292, JString, required = true,
                                 default = nil)
  if valid_589292 != nil:
    section.add "courseWorkId", valid_589292
  var valid_589293 = path.getOrDefault("id")
  valid_589293 = validateParameter(valid_589293, JString, required = true,
                                 default = nil)
  if valid_589293 != nil:
    section.add "id", valid_589293
  var valid_589294 = path.getOrDefault("courseId")
  valid_589294 = validateParameter(valid_589294, JString, required = true,
                                 default = nil)
  if valid_589294 != nil:
    section.add "courseId", valid_589294
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
  var valid_589295 = query.getOrDefault("upload_protocol")
  valid_589295 = validateParameter(valid_589295, JString, required = false,
                                 default = nil)
  if valid_589295 != nil:
    section.add "upload_protocol", valid_589295
  var valid_589296 = query.getOrDefault("fields")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = nil)
  if valid_589296 != nil:
    section.add "fields", valid_589296
  var valid_589297 = query.getOrDefault("quotaUser")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = nil)
  if valid_589297 != nil:
    section.add "quotaUser", valid_589297
  var valid_589298 = query.getOrDefault("alt")
  valid_589298 = validateParameter(valid_589298, JString, required = false,
                                 default = newJString("json"))
  if valid_589298 != nil:
    section.add "alt", valid_589298
  var valid_589299 = query.getOrDefault("oauth_token")
  valid_589299 = validateParameter(valid_589299, JString, required = false,
                                 default = nil)
  if valid_589299 != nil:
    section.add "oauth_token", valid_589299
  var valid_589300 = query.getOrDefault("callback")
  valid_589300 = validateParameter(valid_589300, JString, required = false,
                                 default = nil)
  if valid_589300 != nil:
    section.add "callback", valid_589300
  var valid_589301 = query.getOrDefault("access_token")
  valid_589301 = validateParameter(valid_589301, JString, required = false,
                                 default = nil)
  if valid_589301 != nil:
    section.add "access_token", valid_589301
  var valid_589302 = query.getOrDefault("uploadType")
  valid_589302 = validateParameter(valid_589302, JString, required = false,
                                 default = nil)
  if valid_589302 != nil:
    section.add "uploadType", valid_589302
  var valid_589303 = query.getOrDefault("key")
  valid_589303 = validateParameter(valid_589303, JString, required = false,
                                 default = nil)
  if valid_589303 != nil:
    section.add "key", valid_589303
  var valid_589304 = query.getOrDefault("$.xgafv")
  valid_589304 = validateParameter(valid_589304, JString, required = false,
                                 default = newJString("1"))
  if valid_589304 != nil:
    section.add "$.xgafv", valid_589304
  var valid_589305 = query.getOrDefault("prettyPrint")
  valid_589305 = validateParameter(valid_589305, JBool, required = false,
                                 default = newJBool(true))
  if valid_589305 != nil:
    section.add "prettyPrint", valid_589305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589306: Call_ClassroomCoursesCourseWorkStudentSubmissionsGet_589289;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a student submission.
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course, course work, or student submission or for
  ## access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course, course work, or student submission
  ## does not exist.
  ## 
  let valid = call_589306.validator(path, query, header, formData, body)
  let scheme = call_589306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589306.url(scheme.get, call_589306.host, call_589306.base,
                         call_589306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589306, url, valid)

proc call*(call_589307: Call_ClassroomCoursesCourseWorkStudentSubmissionsGet_589289;
          courseWorkId: string; id: string; courseId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## classroomCoursesCourseWorkStudentSubmissionsGet
  ## Returns a student submission.
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course, course work, or student submission or for
  ## access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course, course work, or student submission
  ## does not exist.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   courseWorkId: string (required)
  ##               : Identifier of the course work.
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
  ##   id: string (required)
  ##     : Identifier of the student submission.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589308 = newJObject()
  var query_589309 = newJObject()
  add(query_589309, "upload_protocol", newJString(uploadProtocol))
  add(query_589309, "fields", newJString(fields))
  add(query_589309, "quotaUser", newJString(quotaUser))
  add(path_589308, "courseWorkId", newJString(courseWorkId))
  add(query_589309, "alt", newJString(alt))
  add(query_589309, "oauth_token", newJString(oauthToken))
  add(query_589309, "callback", newJString(callback))
  add(query_589309, "access_token", newJString(accessToken))
  add(query_589309, "uploadType", newJString(uploadType))
  add(path_589308, "id", newJString(id))
  add(query_589309, "key", newJString(key))
  add(path_589308, "courseId", newJString(courseId))
  add(query_589309, "$.xgafv", newJString(Xgafv))
  add(query_589309, "prettyPrint", newJBool(prettyPrint))
  result = call_589307.call(path_589308, query_589309, nil, nil, nil)

var classroomCoursesCourseWorkStudentSubmissionsGet* = Call_ClassroomCoursesCourseWorkStudentSubmissionsGet_589289(
    name: "classroomCoursesCourseWorkStudentSubmissionsGet",
    meth: HttpMethod.HttpGet, host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork/{courseWorkId}/studentSubmissions/{id}",
    validator: validate_ClassroomCoursesCourseWorkStudentSubmissionsGet_589290,
    base: "/", url: url_ClassroomCoursesCourseWorkStudentSubmissionsGet_589291,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkStudentSubmissionsPatch_589310 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesCourseWorkStudentSubmissionsPatch_589312(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "courseId" in path, "`courseId` is a required path parameter"
  assert "courseWorkId" in path, "`courseWorkId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "courseId"),
               (kind: ConstantSegment, value: "/courseWork/"),
               (kind: VariableSegment, value: "courseWorkId"),
               (kind: ConstantSegment, value: "/studentSubmissions/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesCourseWorkStudentSubmissionsPatch_589311(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates one or more fields of a student submission.
  ## 
  ## See google.classroom.v1.StudentSubmission for details
  ## of which fields may be updated and who may change them.
  ## 
  ## This request must be made by the Developer Console project of the
  ## [OAuth client ID](https://support.google.com/cloud/answer/6158849) used to
  ## create the corresponding course work item.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting developer project did not create
  ## the corresponding course work, if the user is not permitted to make the
  ## requested modification to the student submission, or for
  ## access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course, course work, or student submission
  ## does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   courseWorkId: JString (required)
  ##               : Identifier of the course work.
  ##   id: JString (required)
  ##     : Identifier of the student submission.
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `courseWorkId` field"
  var valid_589313 = path.getOrDefault("courseWorkId")
  valid_589313 = validateParameter(valid_589313, JString, required = true,
                                 default = nil)
  if valid_589313 != nil:
    section.add "courseWorkId", valid_589313
  var valid_589314 = path.getOrDefault("id")
  valid_589314 = validateParameter(valid_589314, JString, required = true,
                                 default = nil)
  if valid_589314 != nil:
    section.add "id", valid_589314
  var valid_589315 = path.getOrDefault("courseId")
  valid_589315 = validateParameter(valid_589315, JString, required = true,
                                 default = nil)
  if valid_589315 != nil:
    section.add "courseId", valid_589315
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
  ##   updateMask: JString
  ##             : Mask that identifies which fields on the student submission to update.
  ## This field is required to do an update. The update fails if invalid
  ## fields are specified.
  ## 
  ## The following fields may be specified by teachers:
  ## 
  ## * `draft_grade`
  ## * `assigned_grade`
  section = newJObject()
  var valid_589316 = query.getOrDefault("upload_protocol")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = nil)
  if valid_589316 != nil:
    section.add "upload_protocol", valid_589316
  var valid_589317 = query.getOrDefault("fields")
  valid_589317 = validateParameter(valid_589317, JString, required = false,
                                 default = nil)
  if valid_589317 != nil:
    section.add "fields", valid_589317
  var valid_589318 = query.getOrDefault("quotaUser")
  valid_589318 = validateParameter(valid_589318, JString, required = false,
                                 default = nil)
  if valid_589318 != nil:
    section.add "quotaUser", valid_589318
  var valid_589319 = query.getOrDefault("alt")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = newJString("json"))
  if valid_589319 != nil:
    section.add "alt", valid_589319
  var valid_589320 = query.getOrDefault("oauth_token")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = nil)
  if valid_589320 != nil:
    section.add "oauth_token", valid_589320
  var valid_589321 = query.getOrDefault("callback")
  valid_589321 = validateParameter(valid_589321, JString, required = false,
                                 default = nil)
  if valid_589321 != nil:
    section.add "callback", valid_589321
  var valid_589322 = query.getOrDefault("access_token")
  valid_589322 = validateParameter(valid_589322, JString, required = false,
                                 default = nil)
  if valid_589322 != nil:
    section.add "access_token", valid_589322
  var valid_589323 = query.getOrDefault("uploadType")
  valid_589323 = validateParameter(valid_589323, JString, required = false,
                                 default = nil)
  if valid_589323 != nil:
    section.add "uploadType", valid_589323
  var valid_589324 = query.getOrDefault("key")
  valid_589324 = validateParameter(valid_589324, JString, required = false,
                                 default = nil)
  if valid_589324 != nil:
    section.add "key", valid_589324
  var valid_589325 = query.getOrDefault("$.xgafv")
  valid_589325 = validateParameter(valid_589325, JString, required = false,
                                 default = newJString("1"))
  if valid_589325 != nil:
    section.add "$.xgafv", valid_589325
  var valid_589326 = query.getOrDefault("prettyPrint")
  valid_589326 = validateParameter(valid_589326, JBool, required = false,
                                 default = newJBool(true))
  if valid_589326 != nil:
    section.add "prettyPrint", valid_589326
  var valid_589327 = query.getOrDefault("updateMask")
  valid_589327 = validateParameter(valid_589327, JString, required = false,
                                 default = nil)
  if valid_589327 != nil:
    section.add "updateMask", valid_589327
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

proc call*(call_589329: Call_ClassroomCoursesCourseWorkStudentSubmissionsPatch_589310;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates one or more fields of a student submission.
  ## 
  ## See google.classroom.v1.StudentSubmission for details
  ## of which fields may be updated and who may change them.
  ## 
  ## This request must be made by the Developer Console project of the
  ## [OAuth client ID](https://support.google.com/cloud/answer/6158849) used to
  ## create the corresponding course work item.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting developer project did not create
  ## the corresponding course work, if the user is not permitted to make the
  ## requested modification to the student submission, or for
  ## access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course, course work, or student submission
  ## does not exist.
  ## 
  let valid = call_589329.validator(path, query, header, formData, body)
  let scheme = call_589329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589329.url(scheme.get, call_589329.host, call_589329.base,
                         call_589329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589329, url, valid)

proc call*(call_589330: Call_ClassroomCoursesCourseWorkStudentSubmissionsPatch_589310;
          courseWorkId: string; id: string; courseId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true;
          updateMask: string = ""): Recallable =
  ## classroomCoursesCourseWorkStudentSubmissionsPatch
  ## Updates one or more fields of a student submission.
  ## 
  ## See google.classroom.v1.StudentSubmission for details
  ## of which fields may be updated and who may change them.
  ## 
  ## This request must be made by the Developer Console project of the
  ## [OAuth client ID](https://support.google.com/cloud/answer/6158849) used to
  ## create the corresponding course work item.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting developer project did not create
  ## the corresponding course work, if the user is not permitted to make the
  ## requested modification to the student submission, or for
  ## access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course, course work, or student submission
  ## does not exist.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   courseWorkId: string (required)
  ##               : Identifier of the course work.
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
  ##   id: string (required)
  ##     : Identifier of the student submission.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: string
  ##             : Mask that identifies which fields on the student submission to update.
  ## This field is required to do an update. The update fails if invalid
  ## fields are specified.
  ## 
  ## The following fields may be specified by teachers:
  ## 
  ## * `draft_grade`
  ## * `assigned_grade`
  var path_589331 = newJObject()
  var query_589332 = newJObject()
  var body_589333 = newJObject()
  add(query_589332, "upload_protocol", newJString(uploadProtocol))
  add(query_589332, "fields", newJString(fields))
  add(query_589332, "quotaUser", newJString(quotaUser))
  add(path_589331, "courseWorkId", newJString(courseWorkId))
  add(query_589332, "alt", newJString(alt))
  add(query_589332, "oauth_token", newJString(oauthToken))
  add(query_589332, "callback", newJString(callback))
  add(query_589332, "access_token", newJString(accessToken))
  add(query_589332, "uploadType", newJString(uploadType))
  add(path_589331, "id", newJString(id))
  add(query_589332, "key", newJString(key))
  add(path_589331, "courseId", newJString(courseId))
  add(query_589332, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589333 = body
  add(query_589332, "prettyPrint", newJBool(prettyPrint))
  add(query_589332, "updateMask", newJString(updateMask))
  result = call_589330.call(path_589331, query_589332, nil, nil, body_589333)

var classroomCoursesCourseWorkStudentSubmissionsPatch* = Call_ClassroomCoursesCourseWorkStudentSubmissionsPatch_589310(
    name: "classroomCoursesCourseWorkStudentSubmissionsPatch",
    meth: HttpMethod.HttpPatch, host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork/{courseWorkId}/studentSubmissions/{id}",
    validator: validate_ClassroomCoursesCourseWorkStudentSubmissionsPatch_589311,
    base: "/", url: url_ClassroomCoursesCourseWorkStudentSubmissionsPatch_589312,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkStudentSubmissionsModifyAttachments_589334 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesCourseWorkStudentSubmissionsModifyAttachments_589336(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "courseId" in path, "`courseId` is a required path parameter"
  assert "courseWorkId" in path, "`courseWorkId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "courseId"),
               (kind: ConstantSegment, value: "/courseWork/"),
               (kind: VariableSegment, value: "courseWorkId"),
               (kind: ConstantSegment, value: "/studentSubmissions/"),
               (kind: VariableSegment, value: "id"),
               (kind: ConstantSegment, value: ":modifyAttachments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesCourseWorkStudentSubmissionsModifyAttachments_589335(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Modifies attachments of student submission.
  ## 
  ## Attachments may only be added to student submissions belonging to course
  ## work objects with a `workType` of `ASSIGNMENT`.
  ## 
  ## This request must be made by the Developer Console project of the
  ## [OAuth client ID](https://support.google.com/cloud/answer/6158849) used to
  ## create the corresponding course work item.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or course work, if the user is not permitted to modify
  ## attachments on the requested student submission, or for
  ## access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course, course work, or student submission
  ## does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   courseWorkId: JString (required)
  ##               : Identifier of the course work.
  ##   id: JString (required)
  ##     : Identifier of the student submission.
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `courseWorkId` field"
  var valid_589337 = path.getOrDefault("courseWorkId")
  valid_589337 = validateParameter(valid_589337, JString, required = true,
                                 default = nil)
  if valid_589337 != nil:
    section.add "courseWorkId", valid_589337
  var valid_589338 = path.getOrDefault("id")
  valid_589338 = validateParameter(valid_589338, JString, required = true,
                                 default = nil)
  if valid_589338 != nil:
    section.add "id", valid_589338
  var valid_589339 = path.getOrDefault("courseId")
  valid_589339 = validateParameter(valid_589339, JString, required = true,
                                 default = nil)
  if valid_589339 != nil:
    section.add "courseId", valid_589339
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
  var valid_589340 = query.getOrDefault("upload_protocol")
  valid_589340 = validateParameter(valid_589340, JString, required = false,
                                 default = nil)
  if valid_589340 != nil:
    section.add "upload_protocol", valid_589340
  var valid_589341 = query.getOrDefault("fields")
  valid_589341 = validateParameter(valid_589341, JString, required = false,
                                 default = nil)
  if valid_589341 != nil:
    section.add "fields", valid_589341
  var valid_589342 = query.getOrDefault("quotaUser")
  valid_589342 = validateParameter(valid_589342, JString, required = false,
                                 default = nil)
  if valid_589342 != nil:
    section.add "quotaUser", valid_589342
  var valid_589343 = query.getOrDefault("alt")
  valid_589343 = validateParameter(valid_589343, JString, required = false,
                                 default = newJString("json"))
  if valid_589343 != nil:
    section.add "alt", valid_589343
  var valid_589344 = query.getOrDefault("oauth_token")
  valid_589344 = validateParameter(valid_589344, JString, required = false,
                                 default = nil)
  if valid_589344 != nil:
    section.add "oauth_token", valid_589344
  var valid_589345 = query.getOrDefault("callback")
  valid_589345 = validateParameter(valid_589345, JString, required = false,
                                 default = nil)
  if valid_589345 != nil:
    section.add "callback", valid_589345
  var valid_589346 = query.getOrDefault("access_token")
  valid_589346 = validateParameter(valid_589346, JString, required = false,
                                 default = nil)
  if valid_589346 != nil:
    section.add "access_token", valid_589346
  var valid_589347 = query.getOrDefault("uploadType")
  valid_589347 = validateParameter(valid_589347, JString, required = false,
                                 default = nil)
  if valid_589347 != nil:
    section.add "uploadType", valid_589347
  var valid_589348 = query.getOrDefault("key")
  valid_589348 = validateParameter(valid_589348, JString, required = false,
                                 default = nil)
  if valid_589348 != nil:
    section.add "key", valid_589348
  var valid_589349 = query.getOrDefault("$.xgafv")
  valid_589349 = validateParameter(valid_589349, JString, required = false,
                                 default = newJString("1"))
  if valid_589349 != nil:
    section.add "$.xgafv", valid_589349
  var valid_589350 = query.getOrDefault("prettyPrint")
  valid_589350 = validateParameter(valid_589350, JBool, required = false,
                                 default = newJBool(true))
  if valid_589350 != nil:
    section.add "prettyPrint", valid_589350
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

proc call*(call_589352: Call_ClassroomCoursesCourseWorkStudentSubmissionsModifyAttachments_589334;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modifies attachments of student submission.
  ## 
  ## Attachments may only be added to student submissions belonging to course
  ## work objects with a `workType` of `ASSIGNMENT`.
  ## 
  ## This request must be made by the Developer Console project of the
  ## [OAuth client ID](https://support.google.com/cloud/answer/6158849) used to
  ## create the corresponding course work item.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or course work, if the user is not permitted to modify
  ## attachments on the requested student submission, or for
  ## access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course, course work, or student submission
  ## does not exist.
  ## 
  let valid = call_589352.validator(path, query, header, formData, body)
  let scheme = call_589352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589352.url(scheme.get, call_589352.host, call_589352.base,
                         call_589352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589352, url, valid)

proc call*(call_589353: Call_ClassroomCoursesCourseWorkStudentSubmissionsModifyAttachments_589334;
          courseWorkId: string; id: string; courseId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## classroomCoursesCourseWorkStudentSubmissionsModifyAttachments
  ## Modifies attachments of student submission.
  ## 
  ## Attachments may only be added to student submissions belonging to course
  ## work objects with a `workType` of `ASSIGNMENT`.
  ## 
  ## This request must be made by the Developer Console project of the
  ## [OAuth client ID](https://support.google.com/cloud/answer/6158849) used to
  ## create the corresponding course work item.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or course work, if the user is not permitted to modify
  ## attachments on the requested student submission, or for
  ## access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course, course work, or student submission
  ## does not exist.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   courseWorkId: string (required)
  ##               : Identifier of the course work.
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
  ##   id: string (required)
  ##     : Identifier of the student submission.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589354 = newJObject()
  var query_589355 = newJObject()
  var body_589356 = newJObject()
  add(query_589355, "upload_protocol", newJString(uploadProtocol))
  add(query_589355, "fields", newJString(fields))
  add(query_589355, "quotaUser", newJString(quotaUser))
  add(path_589354, "courseWorkId", newJString(courseWorkId))
  add(query_589355, "alt", newJString(alt))
  add(query_589355, "oauth_token", newJString(oauthToken))
  add(query_589355, "callback", newJString(callback))
  add(query_589355, "access_token", newJString(accessToken))
  add(query_589355, "uploadType", newJString(uploadType))
  add(path_589354, "id", newJString(id))
  add(query_589355, "key", newJString(key))
  add(path_589354, "courseId", newJString(courseId))
  add(query_589355, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589356 = body
  add(query_589355, "prettyPrint", newJBool(prettyPrint))
  result = call_589353.call(path_589354, query_589355, nil, nil, body_589356)

var classroomCoursesCourseWorkStudentSubmissionsModifyAttachments* = Call_ClassroomCoursesCourseWorkStudentSubmissionsModifyAttachments_589334(
    name: "classroomCoursesCourseWorkStudentSubmissionsModifyAttachments",
    meth: HttpMethod.HttpPost, host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork/{courseWorkId}/studentSubmissions/{id}:modifyAttachments", validator: validate_ClassroomCoursesCourseWorkStudentSubmissionsModifyAttachments_589335,
    base: "/",
    url: url_ClassroomCoursesCourseWorkStudentSubmissionsModifyAttachments_589336,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkStudentSubmissionsReclaim_589357 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesCourseWorkStudentSubmissionsReclaim_589359(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "courseId" in path, "`courseId` is a required path parameter"
  assert "courseWorkId" in path, "`courseWorkId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "courseId"),
               (kind: ConstantSegment, value: "/courseWork/"),
               (kind: VariableSegment, value: "courseWorkId"),
               (kind: ConstantSegment, value: "/studentSubmissions/"),
               (kind: VariableSegment, value: "id"),
               (kind: ConstantSegment, value: ":reclaim")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesCourseWorkStudentSubmissionsReclaim_589358(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Reclaims a student submission on behalf of the student that owns it.
  ## 
  ## Reclaiming a student submission transfers ownership of attached Drive
  ## files to the student and updates the submission state.
  ## 
  ## Only the student that owns the requested student submission may call this
  ## method, and only for a student submission that has been turned in.
  ## 
  ## This request must be made by the Developer Console project of the
  ## [OAuth client ID](https://support.google.com/cloud/answer/6158849) used to
  ## create the corresponding course work item.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or course work, unsubmit the requested student submission,
  ## or for access errors.
  ## * `FAILED_PRECONDITION` if the student submission has not been turned in.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course, course work, or student submission
  ## does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   courseWorkId: JString (required)
  ##               : Identifier of the course work.
  ##   id: JString (required)
  ##     : Identifier of the student submission.
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `courseWorkId` field"
  var valid_589360 = path.getOrDefault("courseWorkId")
  valid_589360 = validateParameter(valid_589360, JString, required = true,
                                 default = nil)
  if valid_589360 != nil:
    section.add "courseWorkId", valid_589360
  var valid_589361 = path.getOrDefault("id")
  valid_589361 = validateParameter(valid_589361, JString, required = true,
                                 default = nil)
  if valid_589361 != nil:
    section.add "id", valid_589361
  var valid_589362 = path.getOrDefault("courseId")
  valid_589362 = validateParameter(valid_589362, JString, required = true,
                                 default = nil)
  if valid_589362 != nil:
    section.add "courseId", valid_589362
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
  var valid_589363 = query.getOrDefault("upload_protocol")
  valid_589363 = validateParameter(valid_589363, JString, required = false,
                                 default = nil)
  if valid_589363 != nil:
    section.add "upload_protocol", valid_589363
  var valid_589364 = query.getOrDefault("fields")
  valid_589364 = validateParameter(valid_589364, JString, required = false,
                                 default = nil)
  if valid_589364 != nil:
    section.add "fields", valid_589364
  var valid_589365 = query.getOrDefault("quotaUser")
  valid_589365 = validateParameter(valid_589365, JString, required = false,
                                 default = nil)
  if valid_589365 != nil:
    section.add "quotaUser", valid_589365
  var valid_589366 = query.getOrDefault("alt")
  valid_589366 = validateParameter(valid_589366, JString, required = false,
                                 default = newJString("json"))
  if valid_589366 != nil:
    section.add "alt", valid_589366
  var valid_589367 = query.getOrDefault("oauth_token")
  valid_589367 = validateParameter(valid_589367, JString, required = false,
                                 default = nil)
  if valid_589367 != nil:
    section.add "oauth_token", valid_589367
  var valid_589368 = query.getOrDefault("callback")
  valid_589368 = validateParameter(valid_589368, JString, required = false,
                                 default = nil)
  if valid_589368 != nil:
    section.add "callback", valid_589368
  var valid_589369 = query.getOrDefault("access_token")
  valid_589369 = validateParameter(valid_589369, JString, required = false,
                                 default = nil)
  if valid_589369 != nil:
    section.add "access_token", valid_589369
  var valid_589370 = query.getOrDefault("uploadType")
  valid_589370 = validateParameter(valid_589370, JString, required = false,
                                 default = nil)
  if valid_589370 != nil:
    section.add "uploadType", valid_589370
  var valid_589371 = query.getOrDefault("key")
  valid_589371 = validateParameter(valid_589371, JString, required = false,
                                 default = nil)
  if valid_589371 != nil:
    section.add "key", valid_589371
  var valid_589372 = query.getOrDefault("$.xgafv")
  valid_589372 = validateParameter(valid_589372, JString, required = false,
                                 default = newJString("1"))
  if valid_589372 != nil:
    section.add "$.xgafv", valid_589372
  var valid_589373 = query.getOrDefault("prettyPrint")
  valid_589373 = validateParameter(valid_589373, JBool, required = false,
                                 default = newJBool(true))
  if valid_589373 != nil:
    section.add "prettyPrint", valid_589373
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

proc call*(call_589375: Call_ClassroomCoursesCourseWorkStudentSubmissionsReclaim_589357;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reclaims a student submission on behalf of the student that owns it.
  ## 
  ## Reclaiming a student submission transfers ownership of attached Drive
  ## files to the student and updates the submission state.
  ## 
  ## Only the student that owns the requested student submission may call this
  ## method, and only for a student submission that has been turned in.
  ## 
  ## This request must be made by the Developer Console project of the
  ## [OAuth client ID](https://support.google.com/cloud/answer/6158849) used to
  ## create the corresponding course work item.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or course work, unsubmit the requested student submission,
  ## or for access errors.
  ## * `FAILED_PRECONDITION` if the student submission has not been turned in.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course, course work, or student submission
  ## does not exist.
  ## 
  let valid = call_589375.validator(path, query, header, formData, body)
  let scheme = call_589375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589375.url(scheme.get, call_589375.host, call_589375.base,
                         call_589375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589375, url, valid)

proc call*(call_589376: Call_ClassroomCoursesCourseWorkStudentSubmissionsReclaim_589357;
          courseWorkId: string; id: string; courseId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## classroomCoursesCourseWorkStudentSubmissionsReclaim
  ## Reclaims a student submission on behalf of the student that owns it.
  ## 
  ## Reclaiming a student submission transfers ownership of attached Drive
  ## files to the student and updates the submission state.
  ## 
  ## Only the student that owns the requested student submission may call this
  ## method, and only for a student submission that has been turned in.
  ## 
  ## This request must be made by the Developer Console project of the
  ## [OAuth client ID](https://support.google.com/cloud/answer/6158849) used to
  ## create the corresponding course work item.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or course work, unsubmit the requested student submission,
  ## or for access errors.
  ## * `FAILED_PRECONDITION` if the student submission has not been turned in.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course, course work, or student submission
  ## does not exist.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   courseWorkId: string (required)
  ##               : Identifier of the course work.
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
  ##   id: string (required)
  ##     : Identifier of the student submission.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589377 = newJObject()
  var query_589378 = newJObject()
  var body_589379 = newJObject()
  add(query_589378, "upload_protocol", newJString(uploadProtocol))
  add(query_589378, "fields", newJString(fields))
  add(query_589378, "quotaUser", newJString(quotaUser))
  add(path_589377, "courseWorkId", newJString(courseWorkId))
  add(query_589378, "alt", newJString(alt))
  add(query_589378, "oauth_token", newJString(oauthToken))
  add(query_589378, "callback", newJString(callback))
  add(query_589378, "access_token", newJString(accessToken))
  add(query_589378, "uploadType", newJString(uploadType))
  add(path_589377, "id", newJString(id))
  add(query_589378, "key", newJString(key))
  add(path_589377, "courseId", newJString(courseId))
  add(query_589378, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589379 = body
  add(query_589378, "prettyPrint", newJBool(prettyPrint))
  result = call_589376.call(path_589377, query_589378, nil, nil, body_589379)

var classroomCoursesCourseWorkStudentSubmissionsReclaim* = Call_ClassroomCoursesCourseWorkStudentSubmissionsReclaim_589357(
    name: "classroomCoursesCourseWorkStudentSubmissionsReclaim",
    meth: HttpMethod.HttpPost, host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork/{courseWorkId}/studentSubmissions/{id}:reclaim",
    validator: validate_ClassroomCoursesCourseWorkStudentSubmissionsReclaim_589358,
    base: "/", url: url_ClassroomCoursesCourseWorkStudentSubmissionsReclaim_589359,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkStudentSubmissionsReturn_589380 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesCourseWorkStudentSubmissionsReturn_589382(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "courseId" in path, "`courseId` is a required path parameter"
  assert "courseWorkId" in path, "`courseWorkId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "courseId"),
               (kind: ConstantSegment, value: "/courseWork/"),
               (kind: VariableSegment, value: "courseWorkId"),
               (kind: ConstantSegment, value: "/studentSubmissions/"),
               (kind: VariableSegment, value: "id"),
               (kind: ConstantSegment, value: ":return")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesCourseWorkStudentSubmissionsReturn_589381(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns a student submission.
  ## 
  ## Returning a student submission transfers ownership of attached Drive
  ## files to the student and may also update the submission state.
  ## Unlike the Classroom application, returning a student submission does not
  ## set assignedGrade to the draftGrade value.
  ## 
  ## Only a teacher of the course that contains the requested student submission
  ## may call this method.
  ## 
  ## This request must be made by the Developer Console project of the
  ## [OAuth client ID](https://support.google.com/cloud/answer/6158849) used to
  ## create the corresponding course work item.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or course work, return the requested student submission,
  ## or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course, course work, or student submission
  ## does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   courseWorkId: JString (required)
  ##               : Identifier of the course work.
  ##   id: JString (required)
  ##     : Identifier of the student submission.
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `courseWorkId` field"
  var valid_589383 = path.getOrDefault("courseWorkId")
  valid_589383 = validateParameter(valid_589383, JString, required = true,
                                 default = nil)
  if valid_589383 != nil:
    section.add "courseWorkId", valid_589383
  var valid_589384 = path.getOrDefault("id")
  valid_589384 = validateParameter(valid_589384, JString, required = true,
                                 default = nil)
  if valid_589384 != nil:
    section.add "id", valid_589384
  var valid_589385 = path.getOrDefault("courseId")
  valid_589385 = validateParameter(valid_589385, JString, required = true,
                                 default = nil)
  if valid_589385 != nil:
    section.add "courseId", valid_589385
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
  var valid_589386 = query.getOrDefault("upload_protocol")
  valid_589386 = validateParameter(valid_589386, JString, required = false,
                                 default = nil)
  if valid_589386 != nil:
    section.add "upload_protocol", valid_589386
  var valid_589387 = query.getOrDefault("fields")
  valid_589387 = validateParameter(valid_589387, JString, required = false,
                                 default = nil)
  if valid_589387 != nil:
    section.add "fields", valid_589387
  var valid_589388 = query.getOrDefault("quotaUser")
  valid_589388 = validateParameter(valid_589388, JString, required = false,
                                 default = nil)
  if valid_589388 != nil:
    section.add "quotaUser", valid_589388
  var valid_589389 = query.getOrDefault("alt")
  valid_589389 = validateParameter(valid_589389, JString, required = false,
                                 default = newJString("json"))
  if valid_589389 != nil:
    section.add "alt", valid_589389
  var valid_589390 = query.getOrDefault("oauth_token")
  valid_589390 = validateParameter(valid_589390, JString, required = false,
                                 default = nil)
  if valid_589390 != nil:
    section.add "oauth_token", valid_589390
  var valid_589391 = query.getOrDefault("callback")
  valid_589391 = validateParameter(valid_589391, JString, required = false,
                                 default = nil)
  if valid_589391 != nil:
    section.add "callback", valid_589391
  var valid_589392 = query.getOrDefault("access_token")
  valid_589392 = validateParameter(valid_589392, JString, required = false,
                                 default = nil)
  if valid_589392 != nil:
    section.add "access_token", valid_589392
  var valid_589393 = query.getOrDefault("uploadType")
  valid_589393 = validateParameter(valid_589393, JString, required = false,
                                 default = nil)
  if valid_589393 != nil:
    section.add "uploadType", valid_589393
  var valid_589394 = query.getOrDefault("key")
  valid_589394 = validateParameter(valid_589394, JString, required = false,
                                 default = nil)
  if valid_589394 != nil:
    section.add "key", valid_589394
  var valid_589395 = query.getOrDefault("$.xgafv")
  valid_589395 = validateParameter(valid_589395, JString, required = false,
                                 default = newJString("1"))
  if valid_589395 != nil:
    section.add "$.xgafv", valid_589395
  var valid_589396 = query.getOrDefault("prettyPrint")
  valid_589396 = validateParameter(valid_589396, JBool, required = false,
                                 default = newJBool(true))
  if valid_589396 != nil:
    section.add "prettyPrint", valid_589396
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

proc call*(call_589398: Call_ClassroomCoursesCourseWorkStudentSubmissionsReturn_589380;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a student submission.
  ## 
  ## Returning a student submission transfers ownership of attached Drive
  ## files to the student and may also update the submission state.
  ## Unlike the Classroom application, returning a student submission does not
  ## set assignedGrade to the draftGrade value.
  ## 
  ## Only a teacher of the course that contains the requested student submission
  ## may call this method.
  ## 
  ## This request must be made by the Developer Console project of the
  ## [OAuth client ID](https://support.google.com/cloud/answer/6158849) used to
  ## create the corresponding course work item.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or course work, return the requested student submission,
  ## or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course, course work, or student submission
  ## does not exist.
  ## 
  let valid = call_589398.validator(path, query, header, formData, body)
  let scheme = call_589398.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589398.url(scheme.get, call_589398.host, call_589398.base,
                         call_589398.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589398, url, valid)

proc call*(call_589399: Call_ClassroomCoursesCourseWorkStudentSubmissionsReturn_589380;
          courseWorkId: string; id: string; courseId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## classroomCoursesCourseWorkStudentSubmissionsReturn
  ## Returns a student submission.
  ## 
  ## Returning a student submission transfers ownership of attached Drive
  ## files to the student and may also update the submission state.
  ## Unlike the Classroom application, returning a student submission does not
  ## set assignedGrade to the draftGrade value.
  ## 
  ## Only a teacher of the course that contains the requested student submission
  ## may call this method.
  ## 
  ## This request must be made by the Developer Console project of the
  ## [OAuth client ID](https://support.google.com/cloud/answer/6158849) used to
  ## create the corresponding course work item.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or course work, return the requested student submission,
  ## or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course, course work, or student submission
  ## does not exist.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   courseWorkId: string (required)
  ##               : Identifier of the course work.
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
  ##   id: string (required)
  ##     : Identifier of the student submission.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589400 = newJObject()
  var query_589401 = newJObject()
  var body_589402 = newJObject()
  add(query_589401, "upload_protocol", newJString(uploadProtocol))
  add(query_589401, "fields", newJString(fields))
  add(query_589401, "quotaUser", newJString(quotaUser))
  add(path_589400, "courseWorkId", newJString(courseWorkId))
  add(query_589401, "alt", newJString(alt))
  add(query_589401, "oauth_token", newJString(oauthToken))
  add(query_589401, "callback", newJString(callback))
  add(query_589401, "access_token", newJString(accessToken))
  add(query_589401, "uploadType", newJString(uploadType))
  add(path_589400, "id", newJString(id))
  add(query_589401, "key", newJString(key))
  add(path_589400, "courseId", newJString(courseId))
  add(query_589401, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589402 = body
  add(query_589401, "prettyPrint", newJBool(prettyPrint))
  result = call_589399.call(path_589400, query_589401, nil, nil, body_589402)

var classroomCoursesCourseWorkStudentSubmissionsReturn* = Call_ClassroomCoursesCourseWorkStudentSubmissionsReturn_589380(
    name: "classroomCoursesCourseWorkStudentSubmissionsReturn",
    meth: HttpMethod.HttpPost, host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork/{courseWorkId}/studentSubmissions/{id}:return",
    validator: validate_ClassroomCoursesCourseWorkStudentSubmissionsReturn_589381,
    base: "/", url: url_ClassroomCoursesCourseWorkStudentSubmissionsReturn_589382,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkStudentSubmissionsTurnIn_589403 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesCourseWorkStudentSubmissionsTurnIn_589405(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "courseId" in path, "`courseId` is a required path parameter"
  assert "courseWorkId" in path, "`courseWorkId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "courseId"),
               (kind: ConstantSegment, value: "/courseWork/"),
               (kind: VariableSegment, value: "courseWorkId"),
               (kind: ConstantSegment, value: "/studentSubmissions/"),
               (kind: VariableSegment, value: "id"),
               (kind: ConstantSegment, value: ":turnIn")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesCourseWorkStudentSubmissionsTurnIn_589404(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Turns in a student submission.
  ## 
  ## Turning in a student submission transfers ownership of attached Drive
  ## files to the teacher and may also update the submission state.
  ## 
  ## This may only be called by the student that owns the specified student
  ## submission.
  ## 
  ## This request must be made by the Developer Console project of the
  ## [OAuth client ID](https://support.google.com/cloud/answer/6158849) used to
  ## create the corresponding course work item.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or course work, turn in the requested student submission,
  ## or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course, course work, or student submission
  ## does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   courseWorkId: JString (required)
  ##               : Identifier of the course work.
  ##   id: JString (required)
  ##     : Identifier of the student submission.
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `courseWorkId` field"
  var valid_589406 = path.getOrDefault("courseWorkId")
  valid_589406 = validateParameter(valid_589406, JString, required = true,
                                 default = nil)
  if valid_589406 != nil:
    section.add "courseWorkId", valid_589406
  var valid_589407 = path.getOrDefault("id")
  valid_589407 = validateParameter(valid_589407, JString, required = true,
                                 default = nil)
  if valid_589407 != nil:
    section.add "id", valid_589407
  var valid_589408 = path.getOrDefault("courseId")
  valid_589408 = validateParameter(valid_589408, JString, required = true,
                                 default = nil)
  if valid_589408 != nil:
    section.add "courseId", valid_589408
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
  var valid_589409 = query.getOrDefault("upload_protocol")
  valid_589409 = validateParameter(valid_589409, JString, required = false,
                                 default = nil)
  if valid_589409 != nil:
    section.add "upload_protocol", valid_589409
  var valid_589410 = query.getOrDefault("fields")
  valid_589410 = validateParameter(valid_589410, JString, required = false,
                                 default = nil)
  if valid_589410 != nil:
    section.add "fields", valid_589410
  var valid_589411 = query.getOrDefault("quotaUser")
  valid_589411 = validateParameter(valid_589411, JString, required = false,
                                 default = nil)
  if valid_589411 != nil:
    section.add "quotaUser", valid_589411
  var valid_589412 = query.getOrDefault("alt")
  valid_589412 = validateParameter(valid_589412, JString, required = false,
                                 default = newJString("json"))
  if valid_589412 != nil:
    section.add "alt", valid_589412
  var valid_589413 = query.getOrDefault("oauth_token")
  valid_589413 = validateParameter(valid_589413, JString, required = false,
                                 default = nil)
  if valid_589413 != nil:
    section.add "oauth_token", valid_589413
  var valid_589414 = query.getOrDefault("callback")
  valid_589414 = validateParameter(valid_589414, JString, required = false,
                                 default = nil)
  if valid_589414 != nil:
    section.add "callback", valid_589414
  var valid_589415 = query.getOrDefault("access_token")
  valid_589415 = validateParameter(valid_589415, JString, required = false,
                                 default = nil)
  if valid_589415 != nil:
    section.add "access_token", valid_589415
  var valid_589416 = query.getOrDefault("uploadType")
  valid_589416 = validateParameter(valid_589416, JString, required = false,
                                 default = nil)
  if valid_589416 != nil:
    section.add "uploadType", valid_589416
  var valid_589417 = query.getOrDefault("key")
  valid_589417 = validateParameter(valid_589417, JString, required = false,
                                 default = nil)
  if valid_589417 != nil:
    section.add "key", valid_589417
  var valid_589418 = query.getOrDefault("$.xgafv")
  valid_589418 = validateParameter(valid_589418, JString, required = false,
                                 default = newJString("1"))
  if valid_589418 != nil:
    section.add "$.xgafv", valid_589418
  var valid_589419 = query.getOrDefault("prettyPrint")
  valid_589419 = validateParameter(valid_589419, JBool, required = false,
                                 default = newJBool(true))
  if valid_589419 != nil:
    section.add "prettyPrint", valid_589419
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

proc call*(call_589421: Call_ClassroomCoursesCourseWorkStudentSubmissionsTurnIn_589403;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Turns in a student submission.
  ## 
  ## Turning in a student submission transfers ownership of attached Drive
  ## files to the teacher and may also update the submission state.
  ## 
  ## This may only be called by the student that owns the specified student
  ## submission.
  ## 
  ## This request must be made by the Developer Console project of the
  ## [OAuth client ID](https://support.google.com/cloud/answer/6158849) used to
  ## create the corresponding course work item.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or course work, turn in the requested student submission,
  ## or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course, course work, or student submission
  ## does not exist.
  ## 
  let valid = call_589421.validator(path, query, header, formData, body)
  let scheme = call_589421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589421.url(scheme.get, call_589421.host, call_589421.base,
                         call_589421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589421, url, valid)

proc call*(call_589422: Call_ClassroomCoursesCourseWorkStudentSubmissionsTurnIn_589403;
          courseWorkId: string; id: string; courseId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## classroomCoursesCourseWorkStudentSubmissionsTurnIn
  ## Turns in a student submission.
  ## 
  ## Turning in a student submission transfers ownership of attached Drive
  ## files to the teacher and may also update the submission state.
  ## 
  ## This may only be called by the student that owns the specified student
  ## submission.
  ## 
  ## This request must be made by the Developer Console project of the
  ## [OAuth client ID](https://support.google.com/cloud/answer/6158849) used to
  ## create the corresponding course work item.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or course work, turn in the requested student submission,
  ## or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course, course work, or student submission
  ## does not exist.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   courseWorkId: string (required)
  ##               : Identifier of the course work.
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
  ##   id: string (required)
  ##     : Identifier of the student submission.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589423 = newJObject()
  var query_589424 = newJObject()
  var body_589425 = newJObject()
  add(query_589424, "upload_protocol", newJString(uploadProtocol))
  add(query_589424, "fields", newJString(fields))
  add(query_589424, "quotaUser", newJString(quotaUser))
  add(path_589423, "courseWorkId", newJString(courseWorkId))
  add(query_589424, "alt", newJString(alt))
  add(query_589424, "oauth_token", newJString(oauthToken))
  add(query_589424, "callback", newJString(callback))
  add(query_589424, "access_token", newJString(accessToken))
  add(query_589424, "uploadType", newJString(uploadType))
  add(path_589423, "id", newJString(id))
  add(query_589424, "key", newJString(key))
  add(path_589423, "courseId", newJString(courseId))
  add(query_589424, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589425 = body
  add(query_589424, "prettyPrint", newJBool(prettyPrint))
  result = call_589422.call(path_589423, query_589424, nil, nil, body_589425)

var classroomCoursesCourseWorkStudentSubmissionsTurnIn* = Call_ClassroomCoursesCourseWorkStudentSubmissionsTurnIn_589403(
    name: "classroomCoursesCourseWorkStudentSubmissionsTurnIn",
    meth: HttpMethod.HttpPost, host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork/{courseWorkId}/studentSubmissions/{id}:turnIn",
    validator: validate_ClassroomCoursesCourseWorkStudentSubmissionsTurnIn_589404,
    base: "/", url: url_ClassroomCoursesCourseWorkStudentSubmissionsTurnIn_589405,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkGet_589426 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesCourseWorkGet_589428(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "courseId" in path, "`courseId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "courseId"),
               (kind: ConstantSegment, value: "/courseWork/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesCourseWorkGet_589427(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns course work.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or course work, or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course or course work does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : Identifier of the course work.
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589429 = path.getOrDefault("id")
  valid_589429 = validateParameter(valid_589429, JString, required = true,
                                 default = nil)
  if valid_589429 != nil:
    section.add "id", valid_589429
  var valid_589430 = path.getOrDefault("courseId")
  valid_589430 = validateParameter(valid_589430, JString, required = true,
                                 default = nil)
  if valid_589430 != nil:
    section.add "courseId", valid_589430
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
  var valid_589431 = query.getOrDefault("upload_protocol")
  valid_589431 = validateParameter(valid_589431, JString, required = false,
                                 default = nil)
  if valid_589431 != nil:
    section.add "upload_protocol", valid_589431
  var valid_589432 = query.getOrDefault("fields")
  valid_589432 = validateParameter(valid_589432, JString, required = false,
                                 default = nil)
  if valid_589432 != nil:
    section.add "fields", valid_589432
  var valid_589433 = query.getOrDefault("quotaUser")
  valid_589433 = validateParameter(valid_589433, JString, required = false,
                                 default = nil)
  if valid_589433 != nil:
    section.add "quotaUser", valid_589433
  var valid_589434 = query.getOrDefault("alt")
  valid_589434 = validateParameter(valid_589434, JString, required = false,
                                 default = newJString("json"))
  if valid_589434 != nil:
    section.add "alt", valid_589434
  var valid_589435 = query.getOrDefault("oauth_token")
  valid_589435 = validateParameter(valid_589435, JString, required = false,
                                 default = nil)
  if valid_589435 != nil:
    section.add "oauth_token", valid_589435
  var valid_589436 = query.getOrDefault("callback")
  valid_589436 = validateParameter(valid_589436, JString, required = false,
                                 default = nil)
  if valid_589436 != nil:
    section.add "callback", valid_589436
  var valid_589437 = query.getOrDefault("access_token")
  valid_589437 = validateParameter(valid_589437, JString, required = false,
                                 default = nil)
  if valid_589437 != nil:
    section.add "access_token", valid_589437
  var valid_589438 = query.getOrDefault("uploadType")
  valid_589438 = validateParameter(valid_589438, JString, required = false,
                                 default = nil)
  if valid_589438 != nil:
    section.add "uploadType", valid_589438
  var valid_589439 = query.getOrDefault("key")
  valid_589439 = validateParameter(valid_589439, JString, required = false,
                                 default = nil)
  if valid_589439 != nil:
    section.add "key", valid_589439
  var valid_589440 = query.getOrDefault("$.xgafv")
  valid_589440 = validateParameter(valid_589440, JString, required = false,
                                 default = newJString("1"))
  if valid_589440 != nil:
    section.add "$.xgafv", valid_589440
  var valid_589441 = query.getOrDefault("prettyPrint")
  valid_589441 = validateParameter(valid_589441, JBool, required = false,
                                 default = newJBool(true))
  if valid_589441 != nil:
    section.add "prettyPrint", valid_589441
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589442: Call_ClassroomCoursesCourseWorkGet_589426; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns course work.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or course work, or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course or course work does not exist.
  ## 
  let valid = call_589442.validator(path, query, header, formData, body)
  let scheme = call_589442.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589442.url(scheme.get, call_589442.host, call_589442.base,
                         call_589442.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589442, url, valid)

proc call*(call_589443: Call_ClassroomCoursesCourseWorkGet_589426; id: string;
          courseId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## classroomCoursesCourseWorkGet
  ## Returns course work.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or course work, or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course or course work does not exist.
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
  ##   id: string (required)
  ##     : Identifier of the course work.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589444 = newJObject()
  var query_589445 = newJObject()
  add(query_589445, "upload_protocol", newJString(uploadProtocol))
  add(query_589445, "fields", newJString(fields))
  add(query_589445, "quotaUser", newJString(quotaUser))
  add(query_589445, "alt", newJString(alt))
  add(query_589445, "oauth_token", newJString(oauthToken))
  add(query_589445, "callback", newJString(callback))
  add(query_589445, "access_token", newJString(accessToken))
  add(query_589445, "uploadType", newJString(uploadType))
  add(path_589444, "id", newJString(id))
  add(query_589445, "key", newJString(key))
  add(path_589444, "courseId", newJString(courseId))
  add(query_589445, "$.xgafv", newJString(Xgafv))
  add(query_589445, "prettyPrint", newJBool(prettyPrint))
  result = call_589443.call(path_589444, query_589445, nil, nil, nil)

var classroomCoursesCourseWorkGet* = Call_ClassroomCoursesCourseWorkGet_589426(
    name: "classroomCoursesCourseWorkGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/courseWork/{id}",
    validator: validate_ClassroomCoursesCourseWorkGet_589427, base: "/",
    url: url_ClassroomCoursesCourseWorkGet_589428, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkPatch_589466 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesCourseWorkPatch_589468(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "courseId" in path, "`courseId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "courseId"),
               (kind: ConstantSegment, value: "/courseWork/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesCourseWorkPatch_589467(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates one or more fields of a course work.
  ## 
  ## See google.classroom.v1.CourseWork for details
  ## of which fields may be updated and who may change them.
  ## 
  ## This request must be made by the Developer Console project of the
  ## [OAuth client ID](https://support.google.com/cloud/answer/6158849) used to
  ## create the corresponding course work item.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting developer project did not create
  ## the corresponding course work, if the user is not permitted to make the
  ## requested modification to the student submission, or for
  ## access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `FAILED_PRECONDITION` if the requested course work has already been
  ## deleted.
  ## * `NOT_FOUND` if the requested course, course work, or student submission
  ## does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : Identifier of the course work.
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589469 = path.getOrDefault("id")
  valid_589469 = validateParameter(valid_589469, JString, required = true,
                                 default = nil)
  if valid_589469 != nil:
    section.add "id", valid_589469
  var valid_589470 = path.getOrDefault("courseId")
  valid_589470 = validateParameter(valid_589470, JString, required = true,
                                 default = nil)
  if valid_589470 != nil:
    section.add "courseId", valid_589470
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
  ##   updateMask: JString
  ##             : Mask that identifies which fields on the course work to update.
  ## This field is required to do an update. The update fails if invalid
  ## fields are specified. If a field supports empty values, it can be cleared
  ## by specifying it in the update mask and not in the CourseWork object. If a
  ## field that does not support empty values is included in the update mask and
  ## not set in the CourseWork object, an `INVALID_ARGUMENT` error will be
  ## returned.
  ## 
  ## The following fields may be specified by teachers:
  ## 
  ## * `title`
  ## * `description`
  ## * `state`
  ## * `due_date`
  ## * `due_time`
  ## * `max_points`
  ## * `scheduled_time`
  ## * `submission_modification_mode`
  ## * `topic_id`
  section = newJObject()
  var valid_589471 = query.getOrDefault("upload_protocol")
  valid_589471 = validateParameter(valid_589471, JString, required = false,
                                 default = nil)
  if valid_589471 != nil:
    section.add "upload_protocol", valid_589471
  var valid_589472 = query.getOrDefault("fields")
  valid_589472 = validateParameter(valid_589472, JString, required = false,
                                 default = nil)
  if valid_589472 != nil:
    section.add "fields", valid_589472
  var valid_589473 = query.getOrDefault("quotaUser")
  valid_589473 = validateParameter(valid_589473, JString, required = false,
                                 default = nil)
  if valid_589473 != nil:
    section.add "quotaUser", valid_589473
  var valid_589474 = query.getOrDefault("alt")
  valid_589474 = validateParameter(valid_589474, JString, required = false,
                                 default = newJString("json"))
  if valid_589474 != nil:
    section.add "alt", valid_589474
  var valid_589475 = query.getOrDefault("oauth_token")
  valid_589475 = validateParameter(valid_589475, JString, required = false,
                                 default = nil)
  if valid_589475 != nil:
    section.add "oauth_token", valid_589475
  var valid_589476 = query.getOrDefault("callback")
  valid_589476 = validateParameter(valid_589476, JString, required = false,
                                 default = nil)
  if valid_589476 != nil:
    section.add "callback", valid_589476
  var valid_589477 = query.getOrDefault("access_token")
  valid_589477 = validateParameter(valid_589477, JString, required = false,
                                 default = nil)
  if valid_589477 != nil:
    section.add "access_token", valid_589477
  var valid_589478 = query.getOrDefault("uploadType")
  valid_589478 = validateParameter(valid_589478, JString, required = false,
                                 default = nil)
  if valid_589478 != nil:
    section.add "uploadType", valid_589478
  var valid_589479 = query.getOrDefault("key")
  valid_589479 = validateParameter(valid_589479, JString, required = false,
                                 default = nil)
  if valid_589479 != nil:
    section.add "key", valid_589479
  var valid_589480 = query.getOrDefault("$.xgafv")
  valid_589480 = validateParameter(valid_589480, JString, required = false,
                                 default = newJString("1"))
  if valid_589480 != nil:
    section.add "$.xgafv", valid_589480
  var valid_589481 = query.getOrDefault("prettyPrint")
  valid_589481 = validateParameter(valid_589481, JBool, required = false,
                                 default = newJBool(true))
  if valid_589481 != nil:
    section.add "prettyPrint", valid_589481
  var valid_589482 = query.getOrDefault("updateMask")
  valid_589482 = validateParameter(valid_589482, JString, required = false,
                                 default = nil)
  if valid_589482 != nil:
    section.add "updateMask", valid_589482
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

proc call*(call_589484: Call_ClassroomCoursesCourseWorkPatch_589466;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates one or more fields of a course work.
  ## 
  ## See google.classroom.v1.CourseWork for details
  ## of which fields may be updated and who may change them.
  ## 
  ## This request must be made by the Developer Console project of the
  ## [OAuth client ID](https://support.google.com/cloud/answer/6158849) used to
  ## create the corresponding course work item.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting developer project did not create
  ## the corresponding course work, if the user is not permitted to make the
  ## requested modification to the student submission, or for
  ## access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `FAILED_PRECONDITION` if the requested course work has already been
  ## deleted.
  ## * `NOT_FOUND` if the requested course, course work, or student submission
  ## does not exist.
  ## 
  let valid = call_589484.validator(path, query, header, formData, body)
  let scheme = call_589484.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589484.url(scheme.get, call_589484.host, call_589484.base,
                         call_589484.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589484, url, valid)

proc call*(call_589485: Call_ClassroomCoursesCourseWorkPatch_589466; id: string;
          courseId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## classroomCoursesCourseWorkPatch
  ## Updates one or more fields of a course work.
  ## 
  ## See google.classroom.v1.CourseWork for details
  ## of which fields may be updated and who may change them.
  ## 
  ## This request must be made by the Developer Console project of the
  ## [OAuth client ID](https://support.google.com/cloud/answer/6158849) used to
  ## create the corresponding course work item.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting developer project did not create
  ## the corresponding course work, if the user is not permitted to make the
  ## requested modification to the student submission, or for
  ## access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `FAILED_PRECONDITION` if the requested course work has already been
  ## deleted.
  ## * `NOT_FOUND` if the requested course, course work, or student submission
  ## does not exist.
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
  ##   id: string (required)
  ##     : Identifier of the course work.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: string
  ##             : Mask that identifies which fields on the course work to update.
  ## This field is required to do an update. The update fails if invalid
  ## fields are specified. If a field supports empty values, it can be cleared
  ## by specifying it in the update mask and not in the CourseWork object. If a
  ## field that does not support empty values is included in the update mask and
  ## not set in the CourseWork object, an `INVALID_ARGUMENT` error will be
  ## returned.
  ## 
  ## The following fields may be specified by teachers:
  ## 
  ## * `title`
  ## * `description`
  ## * `state`
  ## * `due_date`
  ## * `due_time`
  ## * `max_points`
  ## * `scheduled_time`
  ## * `submission_modification_mode`
  ## * `topic_id`
  var path_589486 = newJObject()
  var query_589487 = newJObject()
  var body_589488 = newJObject()
  add(query_589487, "upload_protocol", newJString(uploadProtocol))
  add(query_589487, "fields", newJString(fields))
  add(query_589487, "quotaUser", newJString(quotaUser))
  add(query_589487, "alt", newJString(alt))
  add(query_589487, "oauth_token", newJString(oauthToken))
  add(query_589487, "callback", newJString(callback))
  add(query_589487, "access_token", newJString(accessToken))
  add(query_589487, "uploadType", newJString(uploadType))
  add(path_589486, "id", newJString(id))
  add(query_589487, "key", newJString(key))
  add(path_589486, "courseId", newJString(courseId))
  add(query_589487, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589488 = body
  add(query_589487, "prettyPrint", newJBool(prettyPrint))
  add(query_589487, "updateMask", newJString(updateMask))
  result = call_589485.call(path_589486, query_589487, nil, nil, body_589488)

var classroomCoursesCourseWorkPatch* = Call_ClassroomCoursesCourseWorkPatch_589466(
    name: "classroomCoursesCourseWorkPatch", meth: HttpMethod.HttpPatch,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/courseWork/{id}",
    validator: validate_ClassroomCoursesCourseWorkPatch_589467, base: "/",
    url: url_ClassroomCoursesCourseWorkPatch_589468, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkDelete_589446 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesCourseWorkDelete_589448(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "courseId" in path, "`courseId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "courseId"),
               (kind: ConstantSegment, value: "/courseWork/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesCourseWorkDelete_589447(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a course work.
  ## 
  ## This request must be made by the Developer Console project of the
  ## [OAuth client ID](https://support.google.com/cloud/answer/6158849) used to
  ## create the corresponding course work item.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting developer project did not create
  ## the corresponding course work, if the requesting user is not permitted
  ## to delete the requested course or for access errors.
  ## * `FAILED_PRECONDITION` if the requested course work has already been
  ## deleted.
  ## * `NOT_FOUND` if no course exists with the requested ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : Identifier of the course work to delete.
  ## This identifier is a Classroom-assigned identifier.
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589449 = path.getOrDefault("id")
  valid_589449 = validateParameter(valid_589449, JString, required = true,
                                 default = nil)
  if valid_589449 != nil:
    section.add "id", valid_589449
  var valid_589450 = path.getOrDefault("courseId")
  valid_589450 = validateParameter(valid_589450, JString, required = true,
                                 default = nil)
  if valid_589450 != nil:
    section.add "courseId", valid_589450
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
  var valid_589451 = query.getOrDefault("upload_protocol")
  valid_589451 = validateParameter(valid_589451, JString, required = false,
                                 default = nil)
  if valid_589451 != nil:
    section.add "upload_protocol", valid_589451
  var valid_589452 = query.getOrDefault("fields")
  valid_589452 = validateParameter(valid_589452, JString, required = false,
                                 default = nil)
  if valid_589452 != nil:
    section.add "fields", valid_589452
  var valid_589453 = query.getOrDefault("quotaUser")
  valid_589453 = validateParameter(valid_589453, JString, required = false,
                                 default = nil)
  if valid_589453 != nil:
    section.add "quotaUser", valid_589453
  var valid_589454 = query.getOrDefault("alt")
  valid_589454 = validateParameter(valid_589454, JString, required = false,
                                 default = newJString("json"))
  if valid_589454 != nil:
    section.add "alt", valid_589454
  var valid_589455 = query.getOrDefault("oauth_token")
  valid_589455 = validateParameter(valid_589455, JString, required = false,
                                 default = nil)
  if valid_589455 != nil:
    section.add "oauth_token", valid_589455
  var valid_589456 = query.getOrDefault("callback")
  valid_589456 = validateParameter(valid_589456, JString, required = false,
                                 default = nil)
  if valid_589456 != nil:
    section.add "callback", valid_589456
  var valid_589457 = query.getOrDefault("access_token")
  valid_589457 = validateParameter(valid_589457, JString, required = false,
                                 default = nil)
  if valid_589457 != nil:
    section.add "access_token", valid_589457
  var valid_589458 = query.getOrDefault("uploadType")
  valid_589458 = validateParameter(valid_589458, JString, required = false,
                                 default = nil)
  if valid_589458 != nil:
    section.add "uploadType", valid_589458
  var valid_589459 = query.getOrDefault("key")
  valid_589459 = validateParameter(valid_589459, JString, required = false,
                                 default = nil)
  if valid_589459 != nil:
    section.add "key", valid_589459
  var valid_589460 = query.getOrDefault("$.xgafv")
  valid_589460 = validateParameter(valid_589460, JString, required = false,
                                 default = newJString("1"))
  if valid_589460 != nil:
    section.add "$.xgafv", valid_589460
  var valid_589461 = query.getOrDefault("prettyPrint")
  valid_589461 = validateParameter(valid_589461, JBool, required = false,
                                 default = newJBool(true))
  if valid_589461 != nil:
    section.add "prettyPrint", valid_589461
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589462: Call_ClassroomCoursesCourseWorkDelete_589446;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a course work.
  ## 
  ## This request must be made by the Developer Console project of the
  ## [OAuth client ID](https://support.google.com/cloud/answer/6158849) used to
  ## create the corresponding course work item.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting developer project did not create
  ## the corresponding course work, if the requesting user is not permitted
  ## to delete the requested course or for access errors.
  ## * `FAILED_PRECONDITION` if the requested course work has already been
  ## deleted.
  ## * `NOT_FOUND` if no course exists with the requested ID.
  ## 
  let valid = call_589462.validator(path, query, header, formData, body)
  let scheme = call_589462.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589462.url(scheme.get, call_589462.host, call_589462.base,
                         call_589462.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589462, url, valid)

proc call*(call_589463: Call_ClassroomCoursesCourseWorkDelete_589446; id: string;
          courseId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## classroomCoursesCourseWorkDelete
  ## Deletes a course work.
  ## 
  ## This request must be made by the Developer Console project of the
  ## [OAuth client ID](https://support.google.com/cloud/answer/6158849) used to
  ## create the corresponding course work item.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting developer project did not create
  ## the corresponding course work, if the requesting user is not permitted
  ## to delete the requested course or for access errors.
  ## * `FAILED_PRECONDITION` if the requested course work has already been
  ## deleted.
  ## * `NOT_FOUND` if no course exists with the requested ID.
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
  ##   id: string (required)
  ##     : Identifier of the course work to delete.
  ## This identifier is a Classroom-assigned identifier.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589464 = newJObject()
  var query_589465 = newJObject()
  add(query_589465, "upload_protocol", newJString(uploadProtocol))
  add(query_589465, "fields", newJString(fields))
  add(query_589465, "quotaUser", newJString(quotaUser))
  add(query_589465, "alt", newJString(alt))
  add(query_589465, "oauth_token", newJString(oauthToken))
  add(query_589465, "callback", newJString(callback))
  add(query_589465, "access_token", newJString(accessToken))
  add(query_589465, "uploadType", newJString(uploadType))
  add(path_589464, "id", newJString(id))
  add(query_589465, "key", newJString(key))
  add(path_589464, "courseId", newJString(courseId))
  add(query_589465, "$.xgafv", newJString(Xgafv))
  add(query_589465, "prettyPrint", newJBool(prettyPrint))
  result = call_589463.call(path_589464, query_589465, nil, nil, nil)

var classroomCoursesCourseWorkDelete* = Call_ClassroomCoursesCourseWorkDelete_589446(
    name: "classroomCoursesCourseWorkDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/courseWork/{id}",
    validator: validate_ClassroomCoursesCourseWorkDelete_589447, base: "/",
    url: url_ClassroomCoursesCourseWorkDelete_589448, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkModifyAssignees_589489 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesCourseWorkModifyAssignees_589491(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "courseId" in path, "`courseId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "courseId"),
               (kind: ConstantSegment, value: "/courseWork/"),
               (kind: VariableSegment, value: "id"),
               (kind: ConstantSegment, value: ":modifyAssignees")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesCourseWorkModifyAssignees_589490(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies assignee mode and options of a coursework.
  ## 
  ## Only a teacher of the course that contains the coursework may
  ## call this method.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or course work or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course or course work does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : Identifier of the coursework.
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589492 = path.getOrDefault("id")
  valid_589492 = validateParameter(valid_589492, JString, required = true,
                                 default = nil)
  if valid_589492 != nil:
    section.add "id", valid_589492
  var valid_589493 = path.getOrDefault("courseId")
  valid_589493 = validateParameter(valid_589493, JString, required = true,
                                 default = nil)
  if valid_589493 != nil:
    section.add "courseId", valid_589493
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
  var valid_589494 = query.getOrDefault("upload_protocol")
  valid_589494 = validateParameter(valid_589494, JString, required = false,
                                 default = nil)
  if valid_589494 != nil:
    section.add "upload_protocol", valid_589494
  var valid_589495 = query.getOrDefault("fields")
  valid_589495 = validateParameter(valid_589495, JString, required = false,
                                 default = nil)
  if valid_589495 != nil:
    section.add "fields", valid_589495
  var valid_589496 = query.getOrDefault("quotaUser")
  valid_589496 = validateParameter(valid_589496, JString, required = false,
                                 default = nil)
  if valid_589496 != nil:
    section.add "quotaUser", valid_589496
  var valid_589497 = query.getOrDefault("alt")
  valid_589497 = validateParameter(valid_589497, JString, required = false,
                                 default = newJString("json"))
  if valid_589497 != nil:
    section.add "alt", valid_589497
  var valid_589498 = query.getOrDefault("oauth_token")
  valid_589498 = validateParameter(valid_589498, JString, required = false,
                                 default = nil)
  if valid_589498 != nil:
    section.add "oauth_token", valid_589498
  var valid_589499 = query.getOrDefault("callback")
  valid_589499 = validateParameter(valid_589499, JString, required = false,
                                 default = nil)
  if valid_589499 != nil:
    section.add "callback", valid_589499
  var valid_589500 = query.getOrDefault("access_token")
  valid_589500 = validateParameter(valid_589500, JString, required = false,
                                 default = nil)
  if valid_589500 != nil:
    section.add "access_token", valid_589500
  var valid_589501 = query.getOrDefault("uploadType")
  valid_589501 = validateParameter(valid_589501, JString, required = false,
                                 default = nil)
  if valid_589501 != nil:
    section.add "uploadType", valid_589501
  var valid_589502 = query.getOrDefault("key")
  valid_589502 = validateParameter(valid_589502, JString, required = false,
                                 default = nil)
  if valid_589502 != nil:
    section.add "key", valid_589502
  var valid_589503 = query.getOrDefault("$.xgafv")
  valid_589503 = validateParameter(valid_589503, JString, required = false,
                                 default = newJString("1"))
  if valid_589503 != nil:
    section.add "$.xgafv", valid_589503
  var valid_589504 = query.getOrDefault("prettyPrint")
  valid_589504 = validateParameter(valid_589504, JBool, required = false,
                                 default = newJBool(true))
  if valid_589504 != nil:
    section.add "prettyPrint", valid_589504
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

proc call*(call_589506: Call_ClassroomCoursesCourseWorkModifyAssignees_589489;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modifies assignee mode and options of a coursework.
  ## 
  ## Only a teacher of the course that contains the coursework may
  ## call this method.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or course work or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course or course work does not exist.
  ## 
  let valid = call_589506.validator(path, query, header, formData, body)
  let scheme = call_589506.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589506.url(scheme.get, call_589506.host, call_589506.base,
                         call_589506.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589506, url, valid)

proc call*(call_589507: Call_ClassroomCoursesCourseWorkModifyAssignees_589489;
          id: string; courseId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## classroomCoursesCourseWorkModifyAssignees
  ## Modifies assignee mode and options of a coursework.
  ## 
  ## Only a teacher of the course that contains the coursework may
  ## call this method.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or course work or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course or course work does not exist.
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
  ##   id: string (required)
  ##     : Identifier of the coursework.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589508 = newJObject()
  var query_589509 = newJObject()
  var body_589510 = newJObject()
  add(query_589509, "upload_protocol", newJString(uploadProtocol))
  add(query_589509, "fields", newJString(fields))
  add(query_589509, "quotaUser", newJString(quotaUser))
  add(query_589509, "alt", newJString(alt))
  add(query_589509, "oauth_token", newJString(oauthToken))
  add(query_589509, "callback", newJString(callback))
  add(query_589509, "access_token", newJString(accessToken))
  add(query_589509, "uploadType", newJString(uploadType))
  add(path_589508, "id", newJString(id))
  add(query_589509, "key", newJString(key))
  add(path_589508, "courseId", newJString(courseId))
  add(query_589509, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589510 = body
  add(query_589509, "prettyPrint", newJBool(prettyPrint))
  result = call_589507.call(path_589508, query_589509, nil, nil, body_589510)

var classroomCoursesCourseWorkModifyAssignees* = Call_ClassroomCoursesCourseWorkModifyAssignees_589489(
    name: "classroomCoursesCourseWorkModifyAssignees", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/courseWork/{id}:modifyAssignees",
    validator: validate_ClassroomCoursesCourseWorkModifyAssignees_589490,
    base: "/", url: url_ClassroomCoursesCourseWorkModifyAssignees_589491,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesStudentsCreate_589532 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesStudentsCreate_589534(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "courseId" in path, "`courseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "courseId"),
               (kind: ConstantSegment, value: "/students")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesStudentsCreate_589533(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a user as a student of a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to create
  ## students in this course or for access errors.
  ## * `NOT_FOUND` if the requested course ID does not exist.
  ## * `FAILED_PRECONDITION` if the requested user's account is disabled,
  ## for the following request errors:
  ##     * CourseMemberLimitReached
  ##     * CourseNotModifiable
  ##     * UserGroupsMembershipLimitReached
  ## * `ALREADY_EXISTS` if the user is already a student or teacher in the
  ## course.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   courseId: JString (required)
  ##           : Identifier of the course to create the student in.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `courseId` field"
  var valid_589535 = path.getOrDefault("courseId")
  valid_589535 = validateParameter(valid_589535, JString, required = true,
                                 default = nil)
  if valid_589535 != nil:
    section.add "courseId", valid_589535
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
  ##   enrollmentCode: JString
  ##                 : Enrollment code of the course to create the student in.
  ## This code is required if userId
  ## corresponds to the requesting user; it may be omitted if the requesting
  ## user has administrative permissions to create students for any user.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589536 = query.getOrDefault("upload_protocol")
  valid_589536 = validateParameter(valid_589536, JString, required = false,
                                 default = nil)
  if valid_589536 != nil:
    section.add "upload_protocol", valid_589536
  var valid_589537 = query.getOrDefault("fields")
  valid_589537 = validateParameter(valid_589537, JString, required = false,
                                 default = nil)
  if valid_589537 != nil:
    section.add "fields", valid_589537
  var valid_589538 = query.getOrDefault("quotaUser")
  valid_589538 = validateParameter(valid_589538, JString, required = false,
                                 default = nil)
  if valid_589538 != nil:
    section.add "quotaUser", valid_589538
  var valid_589539 = query.getOrDefault("alt")
  valid_589539 = validateParameter(valid_589539, JString, required = false,
                                 default = newJString("json"))
  if valid_589539 != nil:
    section.add "alt", valid_589539
  var valid_589540 = query.getOrDefault("oauth_token")
  valid_589540 = validateParameter(valid_589540, JString, required = false,
                                 default = nil)
  if valid_589540 != nil:
    section.add "oauth_token", valid_589540
  var valid_589541 = query.getOrDefault("callback")
  valid_589541 = validateParameter(valid_589541, JString, required = false,
                                 default = nil)
  if valid_589541 != nil:
    section.add "callback", valid_589541
  var valid_589542 = query.getOrDefault("access_token")
  valid_589542 = validateParameter(valid_589542, JString, required = false,
                                 default = nil)
  if valid_589542 != nil:
    section.add "access_token", valid_589542
  var valid_589543 = query.getOrDefault("uploadType")
  valid_589543 = validateParameter(valid_589543, JString, required = false,
                                 default = nil)
  if valid_589543 != nil:
    section.add "uploadType", valid_589543
  var valid_589544 = query.getOrDefault("enrollmentCode")
  valid_589544 = validateParameter(valid_589544, JString, required = false,
                                 default = nil)
  if valid_589544 != nil:
    section.add "enrollmentCode", valid_589544
  var valid_589545 = query.getOrDefault("key")
  valid_589545 = validateParameter(valid_589545, JString, required = false,
                                 default = nil)
  if valid_589545 != nil:
    section.add "key", valid_589545
  var valid_589546 = query.getOrDefault("$.xgafv")
  valid_589546 = validateParameter(valid_589546, JString, required = false,
                                 default = newJString("1"))
  if valid_589546 != nil:
    section.add "$.xgafv", valid_589546
  var valid_589547 = query.getOrDefault("prettyPrint")
  valid_589547 = validateParameter(valid_589547, JBool, required = false,
                                 default = newJBool(true))
  if valid_589547 != nil:
    section.add "prettyPrint", valid_589547
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

proc call*(call_589549: Call_ClassroomCoursesStudentsCreate_589532; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a user as a student of a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to create
  ## students in this course or for access errors.
  ## * `NOT_FOUND` if the requested course ID does not exist.
  ## * `FAILED_PRECONDITION` if the requested user's account is disabled,
  ## for the following request errors:
  ##     * CourseMemberLimitReached
  ##     * CourseNotModifiable
  ##     * UserGroupsMembershipLimitReached
  ## * `ALREADY_EXISTS` if the user is already a student or teacher in the
  ## course.
  ## 
  let valid = call_589549.validator(path, query, header, formData, body)
  let scheme = call_589549.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589549.url(scheme.get, call_589549.host, call_589549.base,
                         call_589549.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589549, url, valid)

proc call*(call_589550: Call_ClassroomCoursesStudentsCreate_589532;
          courseId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          enrollmentCode: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## classroomCoursesStudentsCreate
  ## Adds a user as a student of a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to create
  ## students in this course or for access errors.
  ## * `NOT_FOUND` if the requested course ID does not exist.
  ## * `FAILED_PRECONDITION` if the requested user's account is disabled,
  ## for the following request errors:
  ##     * CourseMemberLimitReached
  ##     * CourseNotModifiable
  ##     * UserGroupsMembershipLimitReached
  ## * `ALREADY_EXISTS` if the user is already a student or teacher in the
  ## course.
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
  ##   enrollmentCode: string
  ##                 : Enrollment code of the course to create the student in.
  ## This code is required if userId
  ## corresponds to the requesting user; it may be omitted if the requesting
  ## user has administrative permissions to create students for any user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   courseId: string (required)
  ##           : Identifier of the course to create the student in.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589551 = newJObject()
  var query_589552 = newJObject()
  var body_589553 = newJObject()
  add(query_589552, "upload_protocol", newJString(uploadProtocol))
  add(query_589552, "fields", newJString(fields))
  add(query_589552, "quotaUser", newJString(quotaUser))
  add(query_589552, "alt", newJString(alt))
  add(query_589552, "oauth_token", newJString(oauthToken))
  add(query_589552, "callback", newJString(callback))
  add(query_589552, "access_token", newJString(accessToken))
  add(query_589552, "uploadType", newJString(uploadType))
  add(query_589552, "enrollmentCode", newJString(enrollmentCode))
  add(query_589552, "key", newJString(key))
  add(path_589551, "courseId", newJString(courseId))
  add(query_589552, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589553 = body
  add(query_589552, "prettyPrint", newJBool(prettyPrint))
  result = call_589550.call(path_589551, query_589552, nil, nil, body_589553)

var classroomCoursesStudentsCreate* = Call_ClassroomCoursesStudentsCreate_589532(
    name: "classroomCoursesStudentsCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/students",
    validator: validate_ClassroomCoursesStudentsCreate_589533, base: "/",
    url: url_ClassroomCoursesStudentsCreate_589534, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesStudentsList_589511 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesStudentsList_589513(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "courseId" in path, "`courseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "courseId"),
               (kind: ConstantSegment, value: "/students")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesStudentsList_589512(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of students of this course that the requester
  ## is permitted to view.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `NOT_FOUND` if the course does not exist.
  ## * `PERMISSION_DENIED` for access errors.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `courseId` field"
  var valid_589514 = path.getOrDefault("courseId")
  valid_589514 = validateParameter(valid_589514, JString, required = true,
                                 default = nil)
  if valid_589514 != nil:
    section.add "courseId", valid_589514
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : nextPageToken
  ## value returned from a previous
  ## list call, indicating that
  ## the subsequent page of results should be returned.
  ## 
  ## The list request must be
  ## otherwise identical to the one that resulted in this token.
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
  ##   pageSize: JInt
  ##           : Maximum number of items to return. Zero means no maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589515 = query.getOrDefault("upload_protocol")
  valid_589515 = validateParameter(valid_589515, JString, required = false,
                                 default = nil)
  if valid_589515 != nil:
    section.add "upload_protocol", valid_589515
  var valid_589516 = query.getOrDefault("fields")
  valid_589516 = validateParameter(valid_589516, JString, required = false,
                                 default = nil)
  if valid_589516 != nil:
    section.add "fields", valid_589516
  var valid_589517 = query.getOrDefault("pageToken")
  valid_589517 = validateParameter(valid_589517, JString, required = false,
                                 default = nil)
  if valid_589517 != nil:
    section.add "pageToken", valid_589517
  var valid_589518 = query.getOrDefault("quotaUser")
  valid_589518 = validateParameter(valid_589518, JString, required = false,
                                 default = nil)
  if valid_589518 != nil:
    section.add "quotaUser", valid_589518
  var valid_589519 = query.getOrDefault("alt")
  valid_589519 = validateParameter(valid_589519, JString, required = false,
                                 default = newJString("json"))
  if valid_589519 != nil:
    section.add "alt", valid_589519
  var valid_589520 = query.getOrDefault("oauth_token")
  valid_589520 = validateParameter(valid_589520, JString, required = false,
                                 default = nil)
  if valid_589520 != nil:
    section.add "oauth_token", valid_589520
  var valid_589521 = query.getOrDefault("callback")
  valid_589521 = validateParameter(valid_589521, JString, required = false,
                                 default = nil)
  if valid_589521 != nil:
    section.add "callback", valid_589521
  var valid_589522 = query.getOrDefault("access_token")
  valid_589522 = validateParameter(valid_589522, JString, required = false,
                                 default = nil)
  if valid_589522 != nil:
    section.add "access_token", valid_589522
  var valid_589523 = query.getOrDefault("uploadType")
  valid_589523 = validateParameter(valid_589523, JString, required = false,
                                 default = nil)
  if valid_589523 != nil:
    section.add "uploadType", valid_589523
  var valid_589524 = query.getOrDefault("key")
  valid_589524 = validateParameter(valid_589524, JString, required = false,
                                 default = nil)
  if valid_589524 != nil:
    section.add "key", valid_589524
  var valid_589525 = query.getOrDefault("$.xgafv")
  valid_589525 = validateParameter(valid_589525, JString, required = false,
                                 default = newJString("1"))
  if valid_589525 != nil:
    section.add "$.xgafv", valid_589525
  var valid_589526 = query.getOrDefault("pageSize")
  valid_589526 = validateParameter(valid_589526, JInt, required = false, default = nil)
  if valid_589526 != nil:
    section.add "pageSize", valid_589526
  var valid_589527 = query.getOrDefault("prettyPrint")
  valid_589527 = validateParameter(valid_589527, JBool, required = false,
                                 default = newJBool(true))
  if valid_589527 != nil:
    section.add "prettyPrint", valid_589527
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589528: Call_ClassroomCoursesStudentsList_589511; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of students of this course that the requester
  ## is permitted to view.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `NOT_FOUND` if the course does not exist.
  ## * `PERMISSION_DENIED` for access errors.
  ## 
  let valid = call_589528.validator(path, query, header, formData, body)
  let scheme = call_589528.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589528.url(scheme.get, call_589528.host, call_589528.base,
                         call_589528.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589528, url, valid)

proc call*(call_589529: Call_ClassroomCoursesStudentsList_589511; courseId: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## classroomCoursesStudentsList
  ## Returns a list of students of this course that the requester
  ## is permitted to view.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `NOT_FOUND` if the course does not exist.
  ## * `PERMISSION_DENIED` for access errors.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : nextPageToken
  ## value returned from a previous
  ## list call, indicating that
  ## the subsequent page of results should be returned.
  ## 
  ## The list request must be
  ## otherwise identical to the one that resulted in this token.
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
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of items to return. Zero means no maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589530 = newJObject()
  var query_589531 = newJObject()
  add(query_589531, "upload_protocol", newJString(uploadProtocol))
  add(query_589531, "fields", newJString(fields))
  add(query_589531, "pageToken", newJString(pageToken))
  add(query_589531, "quotaUser", newJString(quotaUser))
  add(query_589531, "alt", newJString(alt))
  add(query_589531, "oauth_token", newJString(oauthToken))
  add(query_589531, "callback", newJString(callback))
  add(query_589531, "access_token", newJString(accessToken))
  add(query_589531, "uploadType", newJString(uploadType))
  add(query_589531, "key", newJString(key))
  add(path_589530, "courseId", newJString(courseId))
  add(query_589531, "$.xgafv", newJString(Xgafv))
  add(query_589531, "pageSize", newJInt(pageSize))
  add(query_589531, "prettyPrint", newJBool(prettyPrint))
  result = call_589529.call(path_589530, query_589531, nil, nil, nil)

var classroomCoursesStudentsList* = Call_ClassroomCoursesStudentsList_589511(
    name: "classroomCoursesStudentsList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/students",
    validator: validate_ClassroomCoursesStudentsList_589512, base: "/",
    url: url_ClassroomCoursesStudentsList_589513, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesStudentsGet_589554 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesStudentsGet_589556(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "courseId" in path, "`courseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "courseId"),
               (kind: ConstantSegment, value: "/students/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesStudentsGet_589555(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a student of a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to view
  ## students of this course or for access errors.
  ## * `NOT_FOUND` if no student of this course has the requested ID or if the
  ## course does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   userId: JString (required)
  ##         : Identifier of the student to return. The identifier can be one of the
  ## following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `courseId` field"
  var valid_589557 = path.getOrDefault("courseId")
  valid_589557 = validateParameter(valid_589557, JString, required = true,
                                 default = nil)
  if valid_589557 != nil:
    section.add "courseId", valid_589557
  var valid_589558 = path.getOrDefault("userId")
  valid_589558 = validateParameter(valid_589558, JString, required = true,
                                 default = nil)
  if valid_589558 != nil:
    section.add "userId", valid_589558
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
  var valid_589559 = query.getOrDefault("upload_protocol")
  valid_589559 = validateParameter(valid_589559, JString, required = false,
                                 default = nil)
  if valid_589559 != nil:
    section.add "upload_protocol", valid_589559
  var valid_589560 = query.getOrDefault("fields")
  valid_589560 = validateParameter(valid_589560, JString, required = false,
                                 default = nil)
  if valid_589560 != nil:
    section.add "fields", valid_589560
  var valid_589561 = query.getOrDefault("quotaUser")
  valid_589561 = validateParameter(valid_589561, JString, required = false,
                                 default = nil)
  if valid_589561 != nil:
    section.add "quotaUser", valid_589561
  var valid_589562 = query.getOrDefault("alt")
  valid_589562 = validateParameter(valid_589562, JString, required = false,
                                 default = newJString("json"))
  if valid_589562 != nil:
    section.add "alt", valid_589562
  var valid_589563 = query.getOrDefault("oauth_token")
  valid_589563 = validateParameter(valid_589563, JString, required = false,
                                 default = nil)
  if valid_589563 != nil:
    section.add "oauth_token", valid_589563
  var valid_589564 = query.getOrDefault("callback")
  valid_589564 = validateParameter(valid_589564, JString, required = false,
                                 default = nil)
  if valid_589564 != nil:
    section.add "callback", valid_589564
  var valid_589565 = query.getOrDefault("access_token")
  valid_589565 = validateParameter(valid_589565, JString, required = false,
                                 default = nil)
  if valid_589565 != nil:
    section.add "access_token", valid_589565
  var valid_589566 = query.getOrDefault("uploadType")
  valid_589566 = validateParameter(valid_589566, JString, required = false,
                                 default = nil)
  if valid_589566 != nil:
    section.add "uploadType", valid_589566
  var valid_589567 = query.getOrDefault("key")
  valid_589567 = validateParameter(valid_589567, JString, required = false,
                                 default = nil)
  if valid_589567 != nil:
    section.add "key", valid_589567
  var valid_589568 = query.getOrDefault("$.xgafv")
  valid_589568 = validateParameter(valid_589568, JString, required = false,
                                 default = newJString("1"))
  if valid_589568 != nil:
    section.add "$.xgafv", valid_589568
  var valid_589569 = query.getOrDefault("prettyPrint")
  valid_589569 = validateParameter(valid_589569, JBool, required = false,
                                 default = newJBool(true))
  if valid_589569 != nil:
    section.add "prettyPrint", valid_589569
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589570: Call_ClassroomCoursesStudentsGet_589554; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a student of a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to view
  ## students of this course or for access errors.
  ## * `NOT_FOUND` if no student of this course has the requested ID or if the
  ## course does not exist.
  ## 
  let valid = call_589570.validator(path, query, header, formData, body)
  let scheme = call_589570.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589570.url(scheme.get, call_589570.host, call_589570.base,
                         call_589570.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589570, url, valid)

proc call*(call_589571: Call_ClassroomCoursesStudentsGet_589554; courseId: string;
          userId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## classroomCoursesStudentsGet
  ## Returns a student of a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to view
  ## students of this course or for access errors.
  ## * `NOT_FOUND` if no student of this course has the requested ID or if the
  ## course does not exist.
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
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : Identifier of the student to return. The identifier can be one of the
  ## following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  var path_589572 = newJObject()
  var query_589573 = newJObject()
  add(query_589573, "upload_protocol", newJString(uploadProtocol))
  add(query_589573, "fields", newJString(fields))
  add(query_589573, "quotaUser", newJString(quotaUser))
  add(query_589573, "alt", newJString(alt))
  add(query_589573, "oauth_token", newJString(oauthToken))
  add(query_589573, "callback", newJString(callback))
  add(query_589573, "access_token", newJString(accessToken))
  add(query_589573, "uploadType", newJString(uploadType))
  add(query_589573, "key", newJString(key))
  add(path_589572, "courseId", newJString(courseId))
  add(query_589573, "$.xgafv", newJString(Xgafv))
  add(query_589573, "prettyPrint", newJBool(prettyPrint))
  add(path_589572, "userId", newJString(userId))
  result = call_589571.call(path_589572, query_589573, nil, nil, nil)

var classroomCoursesStudentsGet* = Call_ClassroomCoursesStudentsGet_589554(
    name: "classroomCoursesStudentsGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/students/{userId}",
    validator: validate_ClassroomCoursesStudentsGet_589555, base: "/",
    url: url_ClassroomCoursesStudentsGet_589556, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesStudentsDelete_589574 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesStudentsDelete_589576(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "courseId" in path, "`courseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "courseId"),
               (kind: ConstantSegment, value: "/students/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesStudentsDelete_589575(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a student of a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to delete
  ## students of this course or for access errors.
  ## * `NOT_FOUND` if no student of this course has the requested ID or if the
  ## course does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   userId: JString (required)
  ##         : Identifier of the student to delete. The identifier can be one of the
  ## following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `courseId` field"
  var valid_589577 = path.getOrDefault("courseId")
  valid_589577 = validateParameter(valid_589577, JString, required = true,
                                 default = nil)
  if valid_589577 != nil:
    section.add "courseId", valid_589577
  var valid_589578 = path.getOrDefault("userId")
  valid_589578 = validateParameter(valid_589578, JString, required = true,
                                 default = nil)
  if valid_589578 != nil:
    section.add "userId", valid_589578
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
  var valid_589579 = query.getOrDefault("upload_protocol")
  valid_589579 = validateParameter(valid_589579, JString, required = false,
                                 default = nil)
  if valid_589579 != nil:
    section.add "upload_protocol", valid_589579
  var valid_589580 = query.getOrDefault("fields")
  valid_589580 = validateParameter(valid_589580, JString, required = false,
                                 default = nil)
  if valid_589580 != nil:
    section.add "fields", valid_589580
  var valid_589581 = query.getOrDefault("quotaUser")
  valid_589581 = validateParameter(valid_589581, JString, required = false,
                                 default = nil)
  if valid_589581 != nil:
    section.add "quotaUser", valid_589581
  var valid_589582 = query.getOrDefault("alt")
  valid_589582 = validateParameter(valid_589582, JString, required = false,
                                 default = newJString("json"))
  if valid_589582 != nil:
    section.add "alt", valid_589582
  var valid_589583 = query.getOrDefault("oauth_token")
  valid_589583 = validateParameter(valid_589583, JString, required = false,
                                 default = nil)
  if valid_589583 != nil:
    section.add "oauth_token", valid_589583
  var valid_589584 = query.getOrDefault("callback")
  valid_589584 = validateParameter(valid_589584, JString, required = false,
                                 default = nil)
  if valid_589584 != nil:
    section.add "callback", valid_589584
  var valid_589585 = query.getOrDefault("access_token")
  valid_589585 = validateParameter(valid_589585, JString, required = false,
                                 default = nil)
  if valid_589585 != nil:
    section.add "access_token", valid_589585
  var valid_589586 = query.getOrDefault("uploadType")
  valid_589586 = validateParameter(valid_589586, JString, required = false,
                                 default = nil)
  if valid_589586 != nil:
    section.add "uploadType", valid_589586
  var valid_589587 = query.getOrDefault("key")
  valid_589587 = validateParameter(valid_589587, JString, required = false,
                                 default = nil)
  if valid_589587 != nil:
    section.add "key", valid_589587
  var valid_589588 = query.getOrDefault("$.xgafv")
  valid_589588 = validateParameter(valid_589588, JString, required = false,
                                 default = newJString("1"))
  if valid_589588 != nil:
    section.add "$.xgafv", valid_589588
  var valid_589589 = query.getOrDefault("prettyPrint")
  valid_589589 = validateParameter(valid_589589, JBool, required = false,
                                 default = newJBool(true))
  if valid_589589 != nil:
    section.add "prettyPrint", valid_589589
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589590: Call_ClassroomCoursesStudentsDelete_589574; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a student of a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to delete
  ## students of this course or for access errors.
  ## * `NOT_FOUND` if no student of this course has the requested ID or if the
  ## course does not exist.
  ## 
  let valid = call_589590.validator(path, query, header, formData, body)
  let scheme = call_589590.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589590.url(scheme.get, call_589590.host, call_589590.base,
                         call_589590.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589590, url, valid)

proc call*(call_589591: Call_ClassroomCoursesStudentsDelete_589574;
          courseId: string; userId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## classroomCoursesStudentsDelete
  ## Deletes a student of a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to delete
  ## students of this course or for access errors.
  ## * `NOT_FOUND` if no student of this course has the requested ID or if the
  ## course does not exist.
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
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : Identifier of the student to delete. The identifier can be one of the
  ## following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  var path_589592 = newJObject()
  var query_589593 = newJObject()
  add(query_589593, "upload_protocol", newJString(uploadProtocol))
  add(query_589593, "fields", newJString(fields))
  add(query_589593, "quotaUser", newJString(quotaUser))
  add(query_589593, "alt", newJString(alt))
  add(query_589593, "oauth_token", newJString(oauthToken))
  add(query_589593, "callback", newJString(callback))
  add(query_589593, "access_token", newJString(accessToken))
  add(query_589593, "uploadType", newJString(uploadType))
  add(query_589593, "key", newJString(key))
  add(path_589592, "courseId", newJString(courseId))
  add(query_589593, "$.xgafv", newJString(Xgafv))
  add(query_589593, "prettyPrint", newJBool(prettyPrint))
  add(path_589592, "userId", newJString(userId))
  result = call_589591.call(path_589592, query_589593, nil, nil, nil)

var classroomCoursesStudentsDelete* = Call_ClassroomCoursesStudentsDelete_589574(
    name: "classroomCoursesStudentsDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/students/{userId}",
    validator: validate_ClassroomCoursesStudentsDelete_589575, base: "/",
    url: url_ClassroomCoursesStudentsDelete_589576, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTeachersCreate_589615 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesTeachersCreate_589617(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "courseId" in path, "`courseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "courseId"),
               (kind: ConstantSegment, value: "/teachers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesTeachersCreate_589616(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a teacher of a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not  permitted to create
  ## teachers in this course or for access errors.
  ## * `NOT_FOUND` if the requested course ID does not exist.
  ## * `FAILED_PRECONDITION` if the requested user's account is disabled,
  ## for the following request errors:
  ##     * CourseMemberLimitReached
  ##     * CourseNotModifiable
  ##     * CourseTeacherLimitReached
  ##     * UserGroupsMembershipLimitReached
  ## * `ALREADY_EXISTS` if the user is already a teacher or student in the
  ## course.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `courseId` field"
  var valid_589618 = path.getOrDefault("courseId")
  valid_589618 = validateParameter(valid_589618, JString, required = true,
                                 default = nil)
  if valid_589618 != nil:
    section.add "courseId", valid_589618
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
  var valid_589619 = query.getOrDefault("upload_protocol")
  valid_589619 = validateParameter(valid_589619, JString, required = false,
                                 default = nil)
  if valid_589619 != nil:
    section.add "upload_protocol", valid_589619
  var valid_589620 = query.getOrDefault("fields")
  valid_589620 = validateParameter(valid_589620, JString, required = false,
                                 default = nil)
  if valid_589620 != nil:
    section.add "fields", valid_589620
  var valid_589621 = query.getOrDefault("quotaUser")
  valid_589621 = validateParameter(valid_589621, JString, required = false,
                                 default = nil)
  if valid_589621 != nil:
    section.add "quotaUser", valid_589621
  var valid_589622 = query.getOrDefault("alt")
  valid_589622 = validateParameter(valid_589622, JString, required = false,
                                 default = newJString("json"))
  if valid_589622 != nil:
    section.add "alt", valid_589622
  var valid_589623 = query.getOrDefault("oauth_token")
  valid_589623 = validateParameter(valid_589623, JString, required = false,
                                 default = nil)
  if valid_589623 != nil:
    section.add "oauth_token", valid_589623
  var valid_589624 = query.getOrDefault("callback")
  valid_589624 = validateParameter(valid_589624, JString, required = false,
                                 default = nil)
  if valid_589624 != nil:
    section.add "callback", valid_589624
  var valid_589625 = query.getOrDefault("access_token")
  valid_589625 = validateParameter(valid_589625, JString, required = false,
                                 default = nil)
  if valid_589625 != nil:
    section.add "access_token", valid_589625
  var valid_589626 = query.getOrDefault("uploadType")
  valid_589626 = validateParameter(valid_589626, JString, required = false,
                                 default = nil)
  if valid_589626 != nil:
    section.add "uploadType", valid_589626
  var valid_589627 = query.getOrDefault("key")
  valid_589627 = validateParameter(valid_589627, JString, required = false,
                                 default = nil)
  if valid_589627 != nil:
    section.add "key", valid_589627
  var valid_589628 = query.getOrDefault("$.xgafv")
  valid_589628 = validateParameter(valid_589628, JString, required = false,
                                 default = newJString("1"))
  if valid_589628 != nil:
    section.add "$.xgafv", valid_589628
  var valid_589629 = query.getOrDefault("prettyPrint")
  valid_589629 = validateParameter(valid_589629, JBool, required = false,
                                 default = newJBool(true))
  if valid_589629 != nil:
    section.add "prettyPrint", valid_589629
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

proc call*(call_589631: Call_ClassroomCoursesTeachersCreate_589615; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a teacher of a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not  permitted to create
  ## teachers in this course or for access errors.
  ## * `NOT_FOUND` if the requested course ID does not exist.
  ## * `FAILED_PRECONDITION` if the requested user's account is disabled,
  ## for the following request errors:
  ##     * CourseMemberLimitReached
  ##     * CourseNotModifiable
  ##     * CourseTeacherLimitReached
  ##     * UserGroupsMembershipLimitReached
  ## * `ALREADY_EXISTS` if the user is already a teacher or student in the
  ## course.
  ## 
  let valid = call_589631.validator(path, query, header, formData, body)
  let scheme = call_589631.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589631.url(scheme.get, call_589631.host, call_589631.base,
                         call_589631.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589631, url, valid)

proc call*(call_589632: Call_ClassroomCoursesTeachersCreate_589615;
          courseId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## classroomCoursesTeachersCreate
  ## Creates a teacher of a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not  permitted to create
  ## teachers in this course or for access errors.
  ## * `NOT_FOUND` if the requested course ID does not exist.
  ## * `FAILED_PRECONDITION` if the requested user's account is disabled,
  ## for the following request errors:
  ##     * CourseMemberLimitReached
  ##     * CourseNotModifiable
  ##     * CourseTeacherLimitReached
  ##     * UserGroupsMembershipLimitReached
  ## * `ALREADY_EXISTS` if the user is already a teacher or student in the
  ## course.
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
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589633 = newJObject()
  var query_589634 = newJObject()
  var body_589635 = newJObject()
  add(query_589634, "upload_protocol", newJString(uploadProtocol))
  add(query_589634, "fields", newJString(fields))
  add(query_589634, "quotaUser", newJString(quotaUser))
  add(query_589634, "alt", newJString(alt))
  add(query_589634, "oauth_token", newJString(oauthToken))
  add(query_589634, "callback", newJString(callback))
  add(query_589634, "access_token", newJString(accessToken))
  add(query_589634, "uploadType", newJString(uploadType))
  add(query_589634, "key", newJString(key))
  add(path_589633, "courseId", newJString(courseId))
  add(query_589634, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589635 = body
  add(query_589634, "prettyPrint", newJBool(prettyPrint))
  result = call_589632.call(path_589633, query_589634, nil, nil, body_589635)

var classroomCoursesTeachersCreate* = Call_ClassroomCoursesTeachersCreate_589615(
    name: "classroomCoursesTeachersCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/teachers",
    validator: validate_ClassroomCoursesTeachersCreate_589616, base: "/",
    url: url_ClassroomCoursesTeachersCreate_589617, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTeachersList_589594 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesTeachersList_589596(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "courseId" in path, "`courseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "courseId"),
               (kind: ConstantSegment, value: "/teachers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesTeachersList_589595(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of teachers of this course that the requester
  ## is permitted to view.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `NOT_FOUND` if the course does not exist.
  ## * `PERMISSION_DENIED` for access errors.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `courseId` field"
  var valid_589597 = path.getOrDefault("courseId")
  valid_589597 = validateParameter(valid_589597, JString, required = true,
                                 default = nil)
  if valid_589597 != nil:
    section.add "courseId", valid_589597
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : nextPageToken
  ## value returned from a previous
  ## list call, indicating that
  ## the subsequent page of results should be returned.
  ## 
  ## The list request must be
  ## otherwise identical to the one that resulted in this token.
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
  ##   pageSize: JInt
  ##           : Maximum number of items to return. Zero means no maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589598 = query.getOrDefault("upload_protocol")
  valid_589598 = validateParameter(valid_589598, JString, required = false,
                                 default = nil)
  if valid_589598 != nil:
    section.add "upload_protocol", valid_589598
  var valid_589599 = query.getOrDefault("fields")
  valid_589599 = validateParameter(valid_589599, JString, required = false,
                                 default = nil)
  if valid_589599 != nil:
    section.add "fields", valid_589599
  var valid_589600 = query.getOrDefault("pageToken")
  valid_589600 = validateParameter(valid_589600, JString, required = false,
                                 default = nil)
  if valid_589600 != nil:
    section.add "pageToken", valid_589600
  var valid_589601 = query.getOrDefault("quotaUser")
  valid_589601 = validateParameter(valid_589601, JString, required = false,
                                 default = nil)
  if valid_589601 != nil:
    section.add "quotaUser", valid_589601
  var valid_589602 = query.getOrDefault("alt")
  valid_589602 = validateParameter(valid_589602, JString, required = false,
                                 default = newJString("json"))
  if valid_589602 != nil:
    section.add "alt", valid_589602
  var valid_589603 = query.getOrDefault("oauth_token")
  valid_589603 = validateParameter(valid_589603, JString, required = false,
                                 default = nil)
  if valid_589603 != nil:
    section.add "oauth_token", valid_589603
  var valid_589604 = query.getOrDefault("callback")
  valid_589604 = validateParameter(valid_589604, JString, required = false,
                                 default = nil)
  if valid_589604 != nil:
    section.add "callback", valid_589604
  var valid_589605 = query.getOrDefault("access_token")
  valid_589605 = validateParameter(valid_589605, JString, required = false,
                                 default = nil)
  if valid_589605 != nil:
    section.add "access_token", valid_589605
  var valid_589606 = query.getOrDefault("uploadType")
  valid_589606 = validateParameter(valid_589606, JString, required = false,
                                 default = nil)
  if valid_589606 != nil:
    section.add "uploadType", valid_589606
  var valid_589607 = query.getOrDefault("key")
  valid_589607 = validateParameter(valid_589607, JString, required = false,
                                 default = nil)
  if valid_589607 != nil:
    section.add "key", valid_589607
  var valid_589608 = query.getOrDefault("$.xgafv")
  valid_589608 = validateParameter(valid_589608, JString, required = false,
                                 default = newJString("1"))
  if valid_589608 != nil:
    section.add "$.xgafv", valid_589608
  var valid_589609 = query.getOrDefault("pageSize")
  valid_589609 = validateParameter(valid_589609, JInt, required = false, default = nil)
  if valid_589609 != nil:
    section.add "pageSize", valid_589609
  var valid_589610 = query.getOrDefault("prettyPrint")
  valid_589610 = validateParameter(valid_589610, JBool, required = false,
                                 default = newJBool(true))
  if valid_589610 != nil:
    section.add "prettyPrint", valid_589610
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589611: Call_ClassroomCoursesTeachersList_589594; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of teachers of this course that the requester
  ## is permitted to view.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `NOT_FOUND` if the course does not exist.
  ## * `PERMISSION_DENIED` for access errors.
  ## 
  let valid = call_589611.validator(path, query, header, formData, body)
  let scheme = call_589611.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589611.url(scheme.get, call_589611.host, call_589611.base,
                         call_589611.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589611, url, valid)

proc call*(call_589612: Call_ClassroomCoursesTeachersList_589594; courseId: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## classroomCoursesTeachersList
  ## Returns a list of teachers of this course that the requester
  ## is permitted to view.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `NOT_FOUND` if the course does not exist.
  ## * `PERMISSION_DENIED` for access errors.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : nextPageToken
  ## value returned from a previous
  ## list call, indicating that
  ## the subsequent page of results should be returned.
  ## 
  ## The list request must be
  ## otherwise identical to the one that resulted in this token.
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
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of items to return. Zero means no maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589613 = newJObject()
  var query_589614 = newJObject()
  add(query_589614, "upload_protocol", newJString(uploadProtocol))
  add(query_589614, "fields", newJString(fields))
  add(query_589614, "pageToken", newJString(pageToken))
  add(query_589614, "quotaUser", newJString(quotaUser))
  add(query_589614, "alt", newJString(alt))
  add(query_589614, "oauth_token", newJString(oauthToken))
  add(query_589614, "callback", newJString(callback))
  add(query_589614, "access_token", newJString(accessToken))
  add(query_589614, "uploadType", newJString(uploadType))
  add(query_589614, "key", newJString(key))
  add(path_589613, "courseId", newJString(courseId))
  add(query_589614, "$.xgafv", newJString(Xgafv))
  add(query_589614, "pageSize", newJInt(pageSize))
  add(query_589614, "prettyPrint", newJBool(prettyPrint))
  result = call_589612.call(path_589613, query_589614, nil, nil, nil)

var classroomCoursesTeachersList* = Call_ClassroomCoursesTeachersList_589594(
    name: "classroomCoursesTeachersList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/teachers",
    validator: validate_ClassroomCoursesTeachersList_589595, base: "/",
    url: url_ClassroomCoursesTeachersList_589596, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTeachersGet_589636 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesTeachersGet_589638(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "courseId" in path, "`courseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "courseId"),
               (kind: ConstantSegment, value: "/teachers/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesTeachersGet_589637(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a teacher of a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to view
  ## teachers of this course or for access errors.
  ## * `NOT_FOUND` if no teacher of this course has the requested ID or if the
  ## course does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   userId: JString (required)
  ##         : Identifier of the teacher to return. The identifier can be one of the
  ## following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `courseId` field"
  var valid_589639 = path.getOrDefault("courseId")
  valid_589639 = validateParameter(valid_589639, JString, required = true,
                                 default = nil)
  if valid_589639 != nil:
    section.add "courseId", valid_589639
  var valid_589640 = path.getOrDefault("userId")
  valid_589640 = validateParameter(valid_589640, JString, required = true,
                                 default = nil)
  if valid_589640 != nil:
    section.add "userId", valid_589640
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
  var valid_589641 = query.getOrDefault("upload_protocol")
  valid_589641 = validateParameter(valid_589641, JString, required = false,
                                 default = nil)
  if valid_589641 != nil:
    section.add "upload_protocol", valid_589641
  var valid_589642 = query.getOrDefault("fields")
  valid_589642 = validateParameter(valid_589642, JString, required = false,
                                 default = nil)
  if valid_589642 != nil:
    section.add "fields", valid_589642
  var valid_589643 = query.getOrDefault("quotaUser")
  valid_589643 = validateParameter(valid_589643, JString, required = false,
                                 default = nil)
  if valid_589643 != nil:
    section.add "quotaUser", valid_589643
  var valid_589644 = query.getOrDefault("alt")
  valid_589644 = validateParameter(valid_589644, JString, required = false,
                                 default = newJString("json"))
  if valid_589644 != nil:
    section.add "alt", valid_589644
  var valid_589645 = query.getOrDefault("oauth_token")
  valid_589645 = validateParameter(valid_589645, JString, required = false,
                                 default = nil)
  if valid_589645 != nil:
    section.add "oauth_token", valid_589645
  var valid_589646 = query.getOrDefault("callback")
  valid_589646 = validateParameter(valid_589646, JString, required = false,
                                 default = nil)
  if valid_589646 != nil:
    section.add "callback", valid_589646
  var valid_589647 = query.getOrDefault("access_token")
  valid_589647 = validateParameter(valid_589647, JString, required = false,
                                 default = nil)
  if valid_589647 != nil:
    section.add "access_token", valid_589647
  var valid_589648 = query.getOrDefault("uploadType")
  valid_589648 = validateParameter(valid_589648, JString, required = false,
                                 default = nil)
  if valid_589648 != nil:
    section.add "uploadType", valid_589648
  var valid_589649 = query.getOrDefault("key")
  valid_589649 = validateParameter(valid_589649, JString, required = false,
                                 default = nil)
  if valid_589649 != nil:
    section.add "key", valid_589649
  var valid_589650 = query.getOrDefault("$.xgafv")
  valid_589650 = validateParameter(valid_589650, JString, required = false,
                                 default = newJString("1"))
  if valid_589650 != nil:
    section.add "$.xgafv", valid_589650
  var valid_589651 = query.getOrDefault("prettyPrint")
  valid_589651 = validateParameter(valid_589651, JBool, required = false,
                                 default = newJBool(true))
  if valid_589651 != nil:
    section.add "prettyPrint", valid_589651
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589652: Call_ClassroomCoursesTeachersGet_589636; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a teacher of a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to view
  ## teachers of this course or for access errors.
  ## * `NOT_FOUND` if no teacher of this course has the requested ID or if the
  ## course does not exist.
  ## 
  let valid = call_589652.validator(path, query, header, formData, body)
  let scheme = call_589652.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589652.url(scheme.get, call_589652.host, call_589652.base,
                         call_589652.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589652, url, valid)

proc call*(call_589653: Call_ClassroomCoursesTeachersGet_589636; courseId: string;
          userId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## classroomCoursesTeachersGet
  ## Returns a teacher of a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to view
  ## teachers of this course or for access errors.
  ## * `NOT_FOUND` if no teacher of this course has the requested ID or if the
  ## course does not exist.
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
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : Identifier of the teacher to return. The identifier can be one of the
  ## following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  var path_589654 = newJObject()
  var query_589655 = newJObject()
  add(query_589655, "upload_protocol", newJString(uploadProtocol))
  add(query_589655, "fields", newJString(fields))
  add(query_589655, "quotaUser", newJString(quotaUser))
  add(query_589655, "alt", newJString(alt))
  add(query_589655, "oauth_token", newJString(oauthToken))
  add(query_589655, "callback", newJString(callback))
  add(query_589655, "access_token", newJString(accessToken))
  add(query_589655, "uploadType", newJString(uploadType))
  add(query_589655, "key", newJString(key))
  add(path_589654, "courseId", newJString(courseId))
  add(query_589655, "$.xgafv", newJString(Xgafv))
  add(query_589655, "prettyPrint", newJBool(prettyPrint))
  add(path_589654, "userId", newJString(userId))
  result = call_589653.call(path_589654, query_589655, nil, nil, nil)

var classroomCoursesTeachersGet* = Call_ClassroomCoursesTeachersGet_589636(
    name: "classroomCoursesTeachersGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/teachers/{userId}",
    validator: validate_ClassroomCoursesTeachersGet_589637, base: "/",
    url: url_ClassroomCoursesTeachersGet_589638, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTeachersDelete_589656 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesTeachersDelete_589658(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "courseId" in path, "`courseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "courseId"),
               (kind: ConstantSegment, value: "/teachers/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesTeachersDelete_589657(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a teacher of a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to delete
  ## teachers of this course or for access errors.
  ## * `NOT_FOUND` if no teacher of this course has the requested ID or if the
  ## course does not exist.
  ## * `FAILED_PRECONDITION` if the requested ID belongs to the primary teacher
  ## of this course.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   userId: JString (required)
  ##         : Identifier of the teacher to delete. The identifier can be one of the
  ## following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `courseId` field"
  var valid_589659 = path.getOrDefault("courseId")
  valid_589659 = validateParameter(valid_589659, JString, required = true,
                                 default = nil)
  if valid_589659 != nil:
    section.add "courseId", valid_589659
  var valid_589660 = path.getOrDefault("userId")
  valid_589660 = validateParameter(valid_589660, JString, required = true,
                                 default = nil)
  if valid_589660 != nil:
    section.add "userId", valid_589660
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
  var valid_589661 = query.getOrDefault("upload_protocol")
  valid_589661 = validateParameter(valid_589661, JString, required = false,
                                 default = nil)
  if valid_589661 != nil:
    section.add "upload_protocol", valid_589661
  var valid_589662 = query.getOrDefault("fields")
  valid_589662 = validateParameter(valid_589662, JString, required = false,
                                 default = nil)
  if valid_589662 != nil:
    section.add "fields", valid_589662
  var valid_589663 = query.getOrDefault("quotaUser")
  valid_589663 = validateParameter(valid_589663, JString, required = false,
                                 default = nil)
  if valid_589663 != nil:
    section.add "quotaUser", valid_589663
  var valid_589664 = query.getOrDefault("alt")
  valid_589664 = validateParameter(valid_589664, JString, required = false,
                                 default = newJString("json"))
  if valid_589664 != nil:
    section.add "alt", valid_589664
  var valid_589665 = query.getOrDefault("oauth_token")
  valid_589665 = validateParameter(valid_589665, JString, required = false,
                                 default = nil)
  if valid_589665 != nil:
    section.add "oauth_token", valid_589665
  var valid_589666 = query.getOrDefault("callback")
  valid_589666 = validateParameter(valid_589666, JString, required = false,
                                 default = nil)
  if valid_589666 != nil:
    section.add "callback", valid_589666
  var valid_589667 = query.getOrDefault("access_token")
  valid_589667 = validateParameter(valid_589667, JString, required = false,
                                 default = nil)
  if valid_589667 != nil:
    section.add "access_token", valid_589667
  var valid_589668 = query.getOrDefault("uploadType")
  valid_589668 = validateParameter(valid_589668, JString, required = false,
                                 default = nil)
  if valid_589668 != nil:
    section.add "uploadType", valid_589668
  var valid_589669 = query.getOrDefault("key")
  valid_589669 = validateParameter(valid_589669, JString, required = false,
                                 default = nil)
  if valid_589669 != nil:
    section.add "key", valid_589669
  var valid_589670 = query.getOrDefault("$.xgafv")
  valid_589670 = validateParameter(valid_589670, JString, required = false,
                                 default = newJString("1"))
  if valid_589670 != nil:
    section.add "$.xgafv", valid_589670
  var valid_589671 = query.getOrDefault("prettyPrint")
  valid_589671 = validateParameter(valid_589671, JBool, required = false,
                                 default = newJBool(true))
  if valid_589671 != nil:
    section.add "prettyPrint", valid_589671
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589672: Call_ClassroomCoursesTeachersDelete_589656; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a teacher of a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to delete
  ## teachers of this course or for access errors.
  ## * `NOT_FOUND` if no teacher of this course has the requested ID or if the
  ## course does not exist.
  ## * `FAILED_PRECONDITION` if the requested ID belongs to the primary teacher
  ## of this course.
  ## 
  let valid = call_589672.validator(path, query, header, formData, body)
  let scheme = call_589672.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589672.url(scheme.get, call_589672.host, call_589672.base,
                         call_589672.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589672, url, valid)

proc call*(call_589673: Call_ClassroomCoursesTeachersDelete_589656;
          courseId: string; userId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## classroomCoursesTeachersDelete
  ## Deletes a teacher of a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to delete
  ## teachers of this course or for access errors.
  ## * `NOT_FOUND` if no teacher of this course has the requested ID or if the
  ## course does not exist.
  ## * `FAILED_PRECONDITION` if the requested ID belongs to the primary teacher
  ## of this course.
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
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : Identifier of the teacher to delete. The identifier can be one of the
  ## following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  var path_589674 = newJObject()
  var query_589675 = newJObject()
  add(query_589675, "upload_protocol", newJString(uploadProtocol))
  add(query_589675, "fields", newJString(fields))
  add(query_589675, "quotaUser", newJString(quotaUser))
  add(query_589675, "alt", newJString(alt))
  add(query_589675, "oauth_token", newJString(oauthToken))
  add(query_589675, "callback", newJString(callback))
  add(query_589675, "access_token", newJString(accessToken))
  add(query_589675, "uploadType", newJString(uploadType))
  add(query_589675, "key", newJString(key))
  add(path_589674, "courseId", newJString(courseId))
  add(query_589675, "$.xgafv", newJString(Xgafv))
  add(query_589675, "prettyPrint", newJBool(prettyPrint))
  add(path_589674, "userId", newJString(userId))
  result = call_589673.call(path_589674, query_589675, nil, nil, nil)

var classroomCoursesTeachersDelete* = Call_ClassroomCoursesTeachersDelete_589656(
    name: "classroomCoursesTeachersDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/teachers/{userId}",
    validator: validate_ClassroomCoursesTeachersDelete_589657, base: "/",
    url: url_ClassroomCoursesTeachersDelete_589658, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTopicsCreate_589697 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesTopicsCreate_589699(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "courseId" in path, "`courseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "courseId"),
               (kind: ConstantSegment, value: "/topics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesTopicsCreate_589698(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a topic.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course, create a topic in the requested course,
  ## or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `courseId` field"
  var valid_589700 = path.getOrDefault("courseId")
  valid_589700 = validateParameter(valid_589700, JString, required = true,
                                 default = nil)
  if valid_589700 != nil:
    section.add "courseId", valid_589700
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
  var valid_589701 = query.getOrDefault("upload_protocol")
  valid_589701 = validateParameter(valid_589701, JString, required = false,
                                 default = nil)
  if valid_589701 != nil:
    section.add "upload_protocol", valid_589701
  var valid_589702 = query.getOrDefault("fields")
  valid_589702 = validateParameter(valid_589702, JString, required = false,
                                 default = nil)
  if valid_589702 != nil:
    section.add "fields", valid_589702
  var valid_589703 = query.getOrDefault("quotaUser")
  valid_589703 = validateParameter(valid_589703, JString, required = false,
                                 default = nil)
  if valid_589703 != nil:
    section.add "quotaUser", valid_589703
  var valid_589704 = query.getOrDefault("alt")
  valid_589704 = validateParameter(valid_589704, JString, required = false,
                                 default = newJString("json"))
  if valid_589704 != nil:
    section.add "alt", valid_589704
  var valid_589705 = query.getOrDefault("oauth_token")
  valid_589705 = validateParameter(valid_589705, JString, required = false,
                                 default = nil)
  if valid_589705 != nil:
    section.add "oauth_token", valid_589705
  var valid_589706 = query.getOrDefault("callback")
  valid_589706 = validateParameter(valid_589706, JString, required = false,
                                 default = nil)
  if valid_589706 != nil:
    section.add "callback", valid_589706
  var valid_589707 = query.getOrDefault("access_token")
  valid_589707 = validateParameter(valid_589707, JString, required = false,
                                 default = nil)
  if valid_589707 != nil:
    section.add "access_token", valid_589707
  var valid_589708 = query.getOrDefault("uploadType")
  valid_589708 = validateParameter(valid_589708, JString, required = false,
                                 default = nil)
  if valid_589708 != nil:
    section.add "uploadType", valid_589708
  var valid_589709 = query.getOrDefault("key")
  valid_589709 = validateParameter(valid_589709, JString, required = false,
                                 default = nil)
  if valid_589709 != nil:
    section.add "key", valid_589709
  var valid_589710 = query.getOrDefault("$.xgafv")
  valid_589710 = validateParameter(valid_589710, JString, required = false,
                                 default = newJString("1"))
  if valid_589710 != nil:
    section.add "$.xgafv", valid_589710
  var valid_589711 = query.getOrDefault("prettyPrint")
  valid_589711 = validateParameter(valid_589711, JBool, required = false,
                                 default = newJBool(true))
  if valid_589711 != nil:
    section.add "prettyPrint", valid_589711
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

proc call*(call_589713: Call_ClassroomCoursesTopicsCreate_589697; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a topic.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course, create a topic in the requested course,
  ## or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course does not exist.
  ## 
  let valid = call_589713.validator(path, query, header, formData, body)
  let scheme = call_589713.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589713.url(scheme.get, call_589713.host, call_589713.base,
                         call_589713.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589713, url, valid)

proc call*(call_589714: Call_ClassroomCoursesTopicsCreate_589697; courseId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## classroomCoursesTopicsCreate
  ## Creates a topic.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course, create a topic in the requested course,
  ## or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course does not exist.
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
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589715 = newJObject()
  var query_589716 = newJObject()
  var body_589717 = newJObject()
  add(query_589716, "upload_protocol", newJString(uploadProtocol))
  add(query_589716, "fields", newJString(fields))
  add(query_589716, "quotaUser", newJString(quotaUser))
  add(query_589716, "alt", newJString(alt))
  add(query_589716, "oauth_token", newJString(oauthToken))
  add(query_589716, "callback", newJString(callback))
  add(query_589716, "access_token", newJString(accessToken))
  add(query_589716, "uploadType", newJString(uploadType))
  add(query_589716, "key", newJString(key))
  add(path_589715, "courseId", newJString(courseId))
  add(query_589716, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589717 = body
  add(query_589716, "prettyPrint", newJBool(prettyPrint))
  result = call_589714.call(path_589715, query_589716, nil, nil, body_589717)

var classroomCoursesTopicsCreate* = Call_ClassroomCoursesTopicsCreate_589697(
    name: "classroomCoursesTopicsCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/topics",
    validator: validate_ClassroomCoursesTopicsCreate_589698, base: "/",
    url: url_ClassroomCoursesTopicsCreate_589699, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTopicsList_589676 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesTopicsList_589678(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "courseId" in path, "`courseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "courseId"),
               (kind: ConstantSegment, value: "/topics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesTopicsList_589677(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the list of topics that the requester is permitted to view.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access
  ## the requested course or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `courseId` field"
  var valid_589679 = path.getOrDefault("courseId")
  valid_589679 = validateParameter(valid_589679, JString, required = true,
                                 default = nil)
  if valid_589679 != nil:
    section.add "courseId", valid_589679
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : nextPageToken
  ## value returned from a previous
  ## list call,
  ## indicating that the subsequent page of results should be returned.
  ## 
  ## The list request
  ## must be otherwise identical to the one that resulted in this token.
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
  ##   pageSize: JInt
  ##           : Maximum number of items to return. Zero or unspecified indicates that the
  ## server may assign a maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589680 = query.getOrDefault("upload_protocol")
  valid_589680 = validateParameter(valid_589680, JString, required = false,
                                 default = nil)
  if valid_589680 != nil:
    section.add "upload_protocol", valid_589680
  var valid_589681 = query.getOrDefault("fields")
  valid_589681 = validateParameter(valid_589681, JString, required = false,
                                 default = nil)
  if valid_589681 != nil:
    section.add "fields", valid_589681
  var valid_589682 = query.getOrDefault("pageToken")
  valid_589682 = validateParameter(valid_589682, JString, required = false,
                                 default = nil)
  if valid_589682 != nil:
    section.add "pageToken", valid_589682
  var valid_589683 = query.getOrDefault("quotaUser")
  valid_589683 = validateParameter(valid_589683, JString, required = false,
                                 default = nil)
  if valid_589683 != nil:
    section.add "quotaUser", valid_589683
  var valid_589684 = query.getOrDefault("alt")
  valid_589684 = validateParameter(valid_589684, JString, required = false,
                                 default = newJString("json"))
  if valid_589684 != nil:
    section.add "alt", valid_589684
  var valid_589685 = query.getOrDefault("oauth_token")
  valid_589685 = validateParameter(valid_589685, JString, required = false,
                                 default = nil)
  if valid_589685 != nil:
    section.add "oauth_token", valid_589685
  var valid_589686 = query.getOrDefault("callback")
  valid_589686 = validateParameter(valid_589686, JString, required = false,
                                 default = nil)
  if valid_589686 != nil:
    section.add "callback", valid_589686
  var valid_589687 = query.getOrDefault("access_token")
  valid_589687 = validateParameter(valid_589687, JString, required = false,
                                 default = nil)
  if valid_589687 != nil:
    section.add "access_token", valid_589687
  var valid_589688 = query.getOrDefault("uploadType")
  valid_589688 = validateParameter(valid_589688, JString, required = false,
                                 default = nil)
  if valid_589688 != nil:
    section.add "uploadType", valid_589688
  var valid_589689 = query.getOrDefault("key")
  valid_589689 = validateParameter(valid_589689, JString, required = false,
                                 default = nil)
  if valid_589689 != nil:
    section.add "key", valid_589689
  var valid_589690 = query.getOrDefault("$.xgafv")
  valid_589690 = validateParameter(valid_589690, JString, required = false,
                                 default = newJString("1"))
  if valid_589690 != nil:
    section.add "$.xgafv", valid_589690
  var valid_589691 = query.getOrDefault("pageSize")
  valid_589691 = validateParameter(valid_589691, JInt, required = false, default = nil)
  if valid_589691 != nil:
    section.add "pageSize", valid_589691
  var valid_589692 = query.getOrDefault("prettyPrint")
  valid_589692 = validateParameter(valid_589692, JBool, required = false,
                                 default = newJBool(true))
  if valid_589692 != nil:
    section.add "prettyPrint", valid_589692
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589693: Call_ClassroomCoursesTopicsList_589676; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of topics that the requester is permitted to view.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access
  ## the requested course or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course does not exist.
  ## 
  let valid = call_589693.validator(path, query, header, formData, body)
  let scheme = call_589693.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589693.url(scheme.get, call_589693.host, call_589693.base,
                         call_589693.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589693, url, valid)

proc call*(call_589694: Call_ClassroomCoursesTopicsList_589676; courseId: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## classroomCoursesTopicsList
  ## Returns the list of topics that the requester is permitted to view.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access
  ## the requested course or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course does not exist.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : nextPageToken
  ## value returned from a previous
  ## list call,
  ## indicating that the subsequent page of results should be returned.
  ## 
  ## The list request
  ## must be otherwise identical to the one that resulted in this token.
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
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of items to return. Zero or unspecified indicates that the
  ## server may assign a maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589695 = newJObject()
  var query_589696 = newJObject()
  add(query_589696, "upload_protocol", newJString(uploadProtocol))
  add(query_589696, "fields", newJString(fields))
  add(query_589696, "pageToken", newJString(pageToken))
  add(query_589696, "quotaUser", newJString(quotaUser))
  add(query_589696, "alt", newJString(alt))
  add(query_589696, "oauth_token", newJString(oauthToken))
  add(query_589696, "callback", newJString(callback))
  add(query_589696, "access_token", newJString(accessToken))
  add(query_589696, "uploadType", newJString(uploadType))
  add(query_589696, "key", newJString(key))
  add(path_589695, "courseId", newJString(courseId))
  add(query_589696, "$.xgafv", newJString(Xgafv))
  add(query_589696, "pageSize", newJInt(pageSize))
  add(query_589696, "prettyPrint", newJBool(prettyPrint))
  result = call_589694.call(path_589695, query_589696, nil, nil, nil)

var classroomCoursesTopicsList* = Call_ClassroomCoursesTopicsList_589676(
    name: "classroomCoursesTopicsList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/topics",
    validator: validate_ClassroomCoursesTopicsList_589677, base: "/",
    url: url_ClassroomCoursesTopicsList_589678, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTopicsGet_589718 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesTopicsGet_589720(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "courseId" in path, "`courseId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "courseId"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesTopicsGet_589719(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a topic.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or topic, or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course or topic does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : Identifier of the topic.
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589721 = path.getOrDefault("id")
  valid_589721 = validateParameter(valid_589721, JString, required = true,
                                 default = nil)
  if valid_589721 != nil:
    section.add "id", valid_589721
  var valid_589722 = path.getOrDefault("courseId")
  valid_589722 = validateParameter(valid_589722, JString, required = true,
                                 default = nil)
  if valid_589722 != nil:
    section.add "courseId", valid_589722
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
  var valid_589723 = query.getOrDefault("upload_protocol")
  valid_589723 = validateParameter(valid_589723, JString, required = false,
                                 default = nil)
  if valid_589723 != nil:
    section.add "upload_protocol", valid_589723
  var valid_589724 = query.getOrDefault("fields")
  valid_589724 = validateParameter(valid_589724, JString, required = false,
                                 default = nil)
  if valid_589724 != nil:
    section.add "fields", valid_589724
  var valid_589725 = query.getOrDefault("quotaUser")
  valid_589725 = validateParameter(valid_589725, JString, required = false,
                                 default = nil)
  if valid_589725 != nil:
    section.add "quotaUser", valid_589725
  var valid_589726 = query.getOrDefault("alt")
  valid_589726 = validateParameter(valid_589726, JString, required = false,
                                 default = newJString("json"))
  if valid_589726 != nil:
    section.add "alt", valid_589726
  var valid_589727 = query.getOrDefault("oauth_token")
  valid_589727 = validateParameter(valid_589727, JString, required = false,
                                 default = nil)
  if valid_589727 != nil:
    section.add "oauth_token", valid_589727
  var valid_589728 = query.getOrDefault("callback")
  valid_589728 = validateParameter(valid_589728, JString, required = false,
                                 default = nil)
  if valid_589728 != nil:
    section.add "callback", valid_589728
  var valid_589729 = query.getOrDefault("access_token")
  valid_589729 = validateParameter(valid_589729, JString, required = false,
                                 default = nil)
  if valid_589729 != nil:
    section.add "access_token", valid_589729
  var valid_589730 = query.getOrDefault("uploadType")
  valid_589730 = validateParameter(valid_589730, JString, required = false,
                                 default = nil)
  if valid_589730 != nil:
    section.add "uploadType", valid_589730
  var valid_589731 = query.getOrDefault("key")
  valid_589731 = validateParameter(valid_589731, JString, required = false,
                                 default = nil)
  if valid_589731 != nil:
    section.add "key", valid_589731
  var valid_589732 = query.getOrDefault("$.xgafv")
  valid_589732 = validateParameter(valid_589732, JString, required = false,
                                 default = newJString("1"))
  if valid_589732 != nil:
    section.add "$.xgafv", valid_589732
  var valid_589733 = query.getOrDefault("prettyPrint")
  valid_589733 = validateParameter(valid_589733, JBool, required = false,
                                 default = newJBool(true))
  if valid_589733 != nil:
    section.add "prettyPrint", valid_589733
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589734: Call_ClassroomCoursesTopicsGet_589718; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a topic.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or topic, or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course or topic does not exist.
  ## 
  let valid = call_589734.validator(path, query, header, formData, body)
  let scheme = call_589734.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589734.url(scheme.get, call_589734.host, call_589734.base,
                         call_589734.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589734, url, valid)

proc call*(call_589735: Call_ClassroomCoursesTopicsGet_589718; id: string;
          courseId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## classroomCoursesTopicsGet
  ## Returns a topic.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or topic, or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course or topic does not exist.
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
  ##   id: string (required)
  ##     : Identifier of the topic.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589736 = newJObject()
  var query_589737 = newJObject()
  add(query_589737, "upload_protocol", newJString(uploadProtocol))
  add(query_589737, "fields", newJString(fields))
  add(query_589737, "quotaUser", newJString(quotaUser))
  add(query_589737, "alt", newJString(alt))
  add(query_589737, "oauth_token", newJString(oauthToken))
  add(query_589737, "callback", newJString(callback))
  add(query_589737, "access_token", newJString(accessToken))
  add(query_589737, "uploadType", newJString(uploadType))
  add(path_589736, "id", newJString(id))
  add(query_589737, "key", newJString(key))
  add(path_589736, "courseId", newJString(courseId))
  add(query_589737, "$.xgafv", newJString(Xgafv))
  add(query_589737, "prettyPrint", newJBool(prettyPrint))
  result = call_589735.call(path_589736, query_589737, nil, nil, nil)

var classroomCoursesTopicsGet* = Call_ClassroomCoursesTopicsGet_589718(
    name: "classroomCoursesTopicsGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/topics/{id}",
    validator: validate_ClassroomCoursesTopicsGet_589719, base: "/",
    url: url_ClassroomCoursesTopicsGet_589720, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTopicsPatch_589758 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesTopicsPatch_589760(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "courseId" in path, "`courseId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "courseId"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesTopicsPatch_589759(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates one or more fields of a topic.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting developer project did not create
  ## the corresponding topic or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course or topic does not exist
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : Identifier of the topic.
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589761 = path.getOrDefault("id")
  valid_589761 = validateParameter(valid_589761, JString, required = true,
                                 default = nil)
  if valid_589761 != nil:
    section.add "id", valid_589761
  var valid_589762 = path.getOrDefault("courseId")
  valid_589762 = validateParameter(valid_589762, JString, required = true,
                                 default = nil)
  if valid_589762 != nil:
    section.add "courseId", valid_589762
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
  ##   updateMask: JString
  ##             : Mask that identifies which fields on the topic to update.
  ## This field is required to do an update. The update fails if invalid
  ## fields are specified. If a field supports empty values, it can be cleared
  ## by specifying it in the update mask and not in the Topic object. If a
  ## field that does not support empty values is included in the update mask and
  ## not set in the Topic object, an `INVALID_ARGUMENT` error will be
  ## returned.
  ## 
  ## The following fields may be specified:
  ## 
  ## * `name`
  section = newJObject()
  var valid_589763 = query.getOrDefault("upload_protocol")
  valid_589763 = validateParameter(valid_589763, JString, required = false,
                                 default = nil)
  if valid_589763 != nil:
    section.add "upload_protocol", valid_589763
  var valid_589764 = query.getOrDefault("fields")
  valid_589764 = validateParameter(valid_589764, JString, required = false,
                                 default = nil)
  if valid_589764 != nil:
    section.add "fields", valid_589764
  var valid_589765 = query.getOrDefault("quotaUser")
  valid_589765 = validateParameter(valid_589765, JString, required = false,
                                 default = nil)
  if valid_589765 != nil:
    section.add "quotaUser", valid_589765
  var valid_589766 = query.getOrDefault("alt")
  valid_589766 = validateParameter(valid_589766, JString, required = false,
                                 default = newJString("json"))
  if valid_589766 != nil:
    section.add "alt", valid_589766
  var valid_589767 = query.getOrDefault("oauth_token")
  valid_589767 = validateParameter(valid_589767, JString, required = false,
                                 default = nil)
  if valid_589767 != nil:
    section.add "oauth_token", valid_589767
  var valid_589768 = query.getOrDefault("callback")
  valid_589768 = validateParameter(valid_589768, JString, required = false,
                                 default = nil)
  if valid_589768 != nil:
    section.add "callback", valid_589768
  var valid_589769 = query.getOrDefault("access_token")
  valid_589769 = validateParameter(valid_589769, JString, required = false,
                                 default = nil)
  if valid_589769 != nil:
    section.add "access_token", valid_589769
  var valid_589770 = query.getOrDefault("uploadType")
  valid_589770 = validateParameter(valid_589770, JString, required = false,
                                 default = nil)
  if valid_589770 != nil:
    section.add "uploadType", valid_589770
  var valid_589771 = query.getOrDefault("key")
  valid_589771 = validateParameter(valid_589771, JString, required = false,
                                 default = nil)
  if valid_589771 != nil:
    section.add "key", valid_589771
  var valid_589772 = query.getOrDefault("$.xgafv")
  valid_589772 = validateParameter(valid_589772, JString, required = false,
                                 default = newJString("1"))
  if valid_589772 != nil:
    section.add "$.xgafv", valid_589772
  var valid_589773 = query.getOrDefault("prettyPrint")
  valid_589773 = validateParameter(valid_589773, JBool, required = false,
                                 default = newJBool(true))
  if valid_589773 != nil:
    section.add "prettyPrint", valid_589773
  var valid_589774 = query.getOrDefault("updateMask")
  valid_589774 = validateParameter(valid_589774, JString, required = false,
                                 default = nil)
  if valid_589774 != nil:
    section.add "updateMask", valid_589774
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

proc call*(call_589776: Call_ClassroomCoursesTopicsPatch_589758; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates one or more fields of a topic.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting developer project did not create
  ## the corresponding topic or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course or topic does not exist
  ## 
  let valid = call_589776.validator(path, query, header, formData, body)
  let scheme = call_589776.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589776.url(scheme.get, call_589776.host, call_589776.base,
                         call_589776.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589776, url, valid)

proc call*(call_589777: Call_ClassroomCoursesTopicsPatch_589758; id: string;
          courseId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## classroomCoursesTopicsPatch
  ## Updates one or more fields of a topic.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting developer project did not create
  ## the corresponding topic or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course or topic does not exist
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
  ##   id: string (required)
  ##     : Identifier of the topic.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: string
  ##             : Mask that identifies which fields on the topic to update.
  ## This field is required to do an update. The update fails if invalid
  ## fields are specified. If a field supports empty values, it can be cleared
  ## by specifying it in the update mask and not in the Topic object. If a
  ## field that does not support empty values is included in the update mask and
  ## not set in the Topic object, an `INVALID_ARGUMENT` error will be
  ## returned.
  ## 
  ## The following fields may be specified:
  ## 
  ## * `name`
  var path_589778 = newJObject()
  var query_589779 = newJObject()
  var body_589780 = newJObject()
  add(query_589779, "upload_protocol", newJString(uploadProtocol))
  add(query_589779, "fields", newJString(fields))
  add(query_589779, "quotaUser", newJString(quotaUser))
  add(query_589779, "alt", newJString(alt))
  add(query_589779, "oauth_token", newJString(oauthToken))
  add(query_589779, "callback", newJString(callback))
  add(query_589779, "access_token", newJString(accessToken))
  add(query_589779, "uploadType", newJString(uploadType))
  add(path_589778, "id", newJString(id))
  add(query_589779, "key", newJString(key))
  add(path_589778, "courseId", newJString(courseId))
  add(query_589779, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589780 = body
  add(query_589779, "prettyPrint", newJBool(prettyPrint))
  add(query_589779, "updateMask", newJString(updateMask))
  result = call_589777.call(path_589778, query_589779, nil, nil, body_589780)

var classroomCoursesTopicsPatch* = Call_ClassroomCoursesTopicsPatch_589758(
    name: "classroomCoursesTopicsPatch", meth: HttpMethod.HttpPatch,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/topics/{id}",
    validator: validate_ClassroomCoursesTopicsPatch_589759, base: "/",
    url: url_ClassroomCoursesTopicsPatch_589760, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTopicsDelete_589738 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesTopicsDelete_589740(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "courseId" in path, "`courseId` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "courseId"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesTopicsDelete_589739(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a topic.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not allowed to delete the
  ## requested topic or for access errors.
  ## * `FAILED_PRECONDITION` if the requested topic has already been
  ## deleted.
  ## * `NOT_FOUND` if no course or topic exists with the requested ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : Identifier of the topic to delete.
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589741 = path.getOrDefault("id")
  valid_589741 = validateParameter(valid_589741, JString, required = true,
                                 default = nil)
  if valid_589741 != nil:
    section.add "id", valid_589741
  var valid_589742 = path.getOrDefault("courseId")
  valid_589742 = validateParameter(valid_589742, JString, required = true,
                                 default = nil)
  if valid_589742 != nil:
    section.add "courseId", valid_589742
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
  var valid_589743 = query.getOrDefault("upload_protocol")
  valid_589743 = validateParameter(valid_589743, JString, required = false,
                                 default = nil)
  if valid_589743 != nil:
    section.add "upload_protocol", valid_589743
  var valid_589744 = query.getOrDefault("fields")
  valid_589744 = validateParameter(valid_589744, JString, required = false,
                                 default = nil)
  if valid_589744 != nil:
    section.add "fields", valid_589744
  var valid_589745 = query.getOrDefault("quotaUser")
  valid_589745 = validateParameter(valid_589745, JString, required = false,
                                 default = nil)
  if valid_589745 != nil:
    section.add "quotaUser", valid_589745
  var valid_589746 = query.getOrDefault("alt")
  valid_589746 = validateParameter(valid_589746, JString, required = false,
                                 default = newJString("json"))
  if valid_589746 != nil:
    section.add "alt", valid_589746
  var valid_589747 = query.getOrDefault("oauth_token")
  valid_589747 = validateParameter(valid_589747, JString, required = false,
                                 default = nil)
  if valid_589747 != nil:
    section.add "oauth_token", valid_589747
  var valid_589748 = query.getOrDefault("callback")
  valid_589748 = validateParameter(valid_589748, JString, required = false,
                                 default = nil)
  if valid_589748 != nil:
    section.add "callback", valid_589748
  var valid_589749 = query.getOrDefault("access_token")
  valid_589749 = validateParameter(valid_589749, JString, required = false,
                                 default = nil)
  if valid_589749 != nil:
    section.add "access_token", valid_589749
  var valid_589750 = query.getOrDefault("uploadType")
  valid_589750 = validateParameter(valid_589750, JString, required = false,
                                 default = nil)
  if valid_589750 != nil:
    section.add "uploadType", valid_589750
  var valid_589751 = query.getOrDefault("key")
  valid_589751 = validateParameter(valid_589751, JString, required = false,
                                 default = nil)
  if valid_589751 != nil:
    section.add "key", valid_589751
  var valid_589752 = query.getOrDefault("$.xgafv")
  valid_589752 = validateParameter(valid_589752, JString, required = false,
                                 default = newJString("1"))
  if valid_589752 != nil:
    section.add "$.xgafv", valid_589752
  var valid_589753 = query.getOrDefault("prettyPrint")
  valid_589753 = validateParameter(valid_589753, JBool, required = false,
                                 default = newJBool(true))
  if valid_589753 != nil:
    section.add "prettyPrint", valid_589753
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589754: Call_ClassroomCoursesTopicsDelete_589738; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a topic.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not allowed to delete the
  ## requested topic or for access errors.
  ## * `FAILED_PRECONDITION` if the requested topic has already been
  ## deleted.
  ## * `NOT_FOUND` if no course or topic exists with the requested ID.
  ## 
  let valid = call_589754.validator(path, query, header, formData, body)
  let scheme = call_589754.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589754.url(scheme.get, call_589754.host, call_589754.base,
                         call_589754.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589754, url, valid)

proc call*(call_589755: Call_ClassroomCoursesTopicsDelete_589738; id: string;
          courseId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## classroomCoursesTopicsDelete
  ## Deletes a topic.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not allowed to delete the
  ## requested topic or for access errors.
  ## * `FAILED_PRECONDITION` if the requested topic has already been
  ## deleted.
  ## * `NOT_FOUND` if no course or topic exists with the requested ID.
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
  ##   id: string (required)
  ##     : Identifier of the topic to delete.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589756 = newJObject()
  var query_589757 = newJObject()
  add(query_589757, "upload_protocol", newJString(uploadProtocol))
  add(query_589757, "fields", newJString(fields))
  add(query_589757, "quotaUser", newJString(quotaUser))
  add(query_589757, "alt", newJString(alt))
  add(query_589757, "oauth_token", newJString(oauthToken))
  add(query_589757, "callback", newJString(callback))
  add(query_589757, "access_token", newJString(accessToken))
  add(query_589757, "uploadType", newJString(uploadType))
  add(path_589756, "id", newJString(id))
  add(query_589757, "key", newJString(key))
  add(path_589756, "courseId", newJString(courseId))
  add(query_589757, "$.xgafv", newJString(Xgafv))
  add(query_589757, "prettyPrint", newJBool(prettyPrint))
  result = call_589755.call(path_589756, query_589757, nil, nil, nil)

var classroomCoursesTopicsDelete* = Call_ClassroomCoursesTopicsDelete_589738(
    name: "classroomCoursesTopicsDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/topics/{id}",
    validator: validate_ClassroomCoursesTopicsDelete_589739, base: "/",
    url: url_ClassroomCoursesTopicsDelete_589740, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesUpdate_589800 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesUpdate_589802(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesUpdate_589801(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to modify the
  ## requested course or for access errors.
  ## * `NOT_FOUND` if no course exists with the requested ID.
  ## * `FAILED_PRECONDITION` for the following request errors:
  ##     * CourseNotModifiable
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : Identifier of the course to update.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589803 = path.getOrDefault("id")
  valid_589803 = validateParameter(valid_589803, JString, required = true,
                                 default = nil)
  if valid_589803 != nil:
    section.add "id", valid_589803
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
  var valid_589804 = query.getOrDefault("upload_protocol")
  valid_589804 = validateParameter(valid_589804, JString, required = false,
                                 default = nil)
  if valid_589804 != nil:
    section.add "upload_protocol", valid_589804
  var valid_589805 = query.getOrDefault("fields")
  valid_589805 = validateParameter(valid_589805, JString, required = false,
                                 default = nil)
  if valid_589805 != nil:
    section.add "fields", valid_589805
  var valid_589806 = query.getOrDefault("quotaUser")
  valid_589806 = validateParameter(valid_589806, JString, required = false,
                                 default = nil)
  if valid_589806 != nil:
    section.add "quotaUser", valid_589806
  var valid_589807 = query.getOrDefault("alt")
  valid_589807 = validateParameter(valid_589807, JString, required = false,
                                 default = newJString("json"))
  if valid_589807 != nil:
    section.add "alt", valid_589807
  var valid_589808 = query.getOrDefault("oauth_token")
  valid_589808 = validateParameter(valid_589808, JString, required = false,
                                 default = nil)
  if valid_589808 != nil:
    section.add "oauth_token", valid_589808
  var valid_589809 = query.getOrDefault("callback")
  valid_589809 = validateParameter(valid_589809, JString, required = false,
                                 default = nil)
  if valid_589809 != nil:
    section.add "callback", valid_589809
  var valid_589810 = query.getOrDefault("access_token")
  valid_589810 = validateParameter(valid_589810, JString, required = false,
                                 default = nil)
  if valid_589810 != nil:
    section.add "access_token", valid_589810
  var valid_589811 = query.getOrDefault("uploadType")
  valid_589811 = validateParameter(valid_589811, JString, required = false,
                                 default = nil)
  if valid_589811 != nil:
    section.add "uploadType", valid_589811
  var valid_589812 = query.getOrDefault("key")
  valid_589812 = validateParameter(valid_589812, JString, required = false,
                                 default = nil)
  if valid_589812 != nil:
    section.add "key", valid_589812
  var valid_589813 = query.getOrDefault("$.xgafv")
  valid_589813 = validateParameter(valid_589813, JString, required = false,
                                 default = newJString("1"))
  if valid_589813 != nil:
    section.add "$.xgafv", valid_589813
  var valid_589814 = query.getOrDefault("prettyPrint")
  valid_589814 = validateParameter(valid_589814, JBool, required = false,
                                 default = newJBool(true))
  if valid_589814 != nil:
    section.add "prettyPrint", valid_589814
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

proc call*(call_589816: Call_ClassroomCoursesUpdate_589800; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to modify the
  ## requested course or for access errors.
  ## * `NOT_FOUND` if no course exists with the requested ID.
  ## * `FAILED_PRECONDITION` for the following request errors:
  ##     * CourseNotModifiable
  ## 
  let valid = call_589816.validator(path, query, header, formData, body)
  let scheme = call_589816.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589816.url(scheme.get, call_589816.host, call_589816.base,
                         call_589816.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589816, url, valid)

proc call*(call_589817: Call_ClassroomCoursesUpdate_589800; id: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## classroomCoursesUpdate
  ## Updates a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to modify the
  ## requested course or for access errors.
  ## * `NOT_FOUND` if no course exists with the requested ID.
  ## * `FAILED_PRECONDITION` for the following request errors:
  ##     * CourseNotModifiable
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
  ##   id: string (required)
  ##     : Identifier of the course to update.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589818 = newJObject()
  var query_589819 = newJObject()
  var body_589820 = newJObject()
  add(query_589819, "upload_protocol", newJString(uploadProtocol))
  add(query_589819, "fields", newJString(fields))
  add(query_589819, "quotaUser", newJString(quotaUser))
  add(query_589819, "alt", newJString(alt))
  add(query_589819, "oauth_token", newJString(oauthToken))
  add(query_589819, "callback", newJString(callback))
  add(query_589819, "access_token", newJString(accessToken))
  add(query_589819, "uploadType", newJString(uploadType))
  add(path_589818, "id", newJString(id))
  add(query_589819, "key", newJString(key))
  add(query_589819, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589820 = body
  add(query_589819, "prettyPrint", newJBool(prettyPrint))
  result = call_589817.call(path_589818, query_589819, nil, nil, body_589820)

var classroomCoursesUpdate* = Call_ClassroomCoursesUpdate_589800(
    name: "classroomCoursesUpdate", meth: HttpMethod.HttpPut,
    host: "classroom.googleapis.com", route: "/v1/courses/{id}",
    validator: validate_ClassroomCoursesUpdate_589801, base: "/",
    url: url_ClassroomCoursesUpdate_589802, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesGet_589781 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesGet_589783(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesGet_589782(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Returns a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or for access errors.
  ## * `NOT_FOUND` if no course exists with the requested ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : Identifier of the course to return.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589784 = path.getOrDefault("id")
  valid_589784 = validateParameter(valid_589784, JString, required = true,
                                 default = nil)
  if valid_589784 != nil:
    section.add "id", valid_589784
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
  var valid_589785 = query.getOrDefault("upload_protocol")
  valid_589785 = validateParameter(valid_589785, JString, required = false,
                                 default = nil)
  if valid_589785 != nil:
    section.add "upload_protocol", valid_589785
  var valid_589786 = query.getOrDefault("fields")
  valid_589786 = validateParameter(valid_589786, JString, required = false,
                                 default = nil)
  if valid_589786 != nil:
    section.add "fields", valid_589786
  var valid_589787 = query.getOrDefault("quotaUser")
  valid_589787 = validateParameter(valid_589787, JString, required = false,
                                 default = nil)
  if valid_589787 != nil:
    section.add "quotaUser", valid_589787
  var valid_589788 = query.getOrDefault("alt")
  valid_589788 = validateParameter(valid_589788, JString, required = false,
                                 default = newJString("json"))
  if valid_589788 != nil:
    section.add "alt", valid_589788
  var valid_589789 = query.getOrDefault("oauth_token")
  valid_589789 = validateParameter(valid_589789, JString, required = false,
                                 default = nil)
  if valid_589789 != nil:
    section.add "oauth_token", valid_589789
  var valid_589790 = query.getOrDefault("callback")
  valid_589790 = validateParameter(valid_589790, JString, required = false,
                                 default = nil)
  if valid_589790 != nil:
    section.add "callback", valid_589790
  var valid_589791 = query.getOrDefault("access_token")
  valid_589791 = validateParameter(valid_589791, JString, required = false,
                                 default = nil)
  if valid_589791 != nil:
    section.add "access_token", valid_589791
  var valid_589792 = query.getOrDefault("uploadType")
  valid_589792 = validateParameter(valid_589792, JString, required = false,
                                 default = nil)
  if valid_589792 != nil:
    section.add "uploadType", valid_589792
  var valid_589793 = query.getOrDefault("key")
  valid_589793 = validateParameter(valid_589793, JString, required = false,
                                 default = nil)
  if valid_589793 != nil:
    section.add "key", valid_589793
  var valid_589794 = query.getOrDefault("$.xgafv")
  valid_589794 = validateParameter(valid_589794, JString, required = false,
                                 default = newJString("1"))
  if valid_589794 != nil:
    section.add "$.xgafv", valid_589794
  var valid_589795 = query.getOrDefault("prettyPrint")
  valid_589795 = validateParameter(valid_589795, JBool, required = false,
                                 default = newJBool(true))
  if valid_589795 != nil:
    section.add "prettyPrint", valid_589795
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589796: Call_ClassroomCoursesGet_589781; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or for access errors.
  ## * `NOT_FOUND` if no course exists with the requested ID.
  ## 
  let valid = call_589796.validator(path, query, header, formData, body)
  let scheme = call_589796.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589796.url(scheme.get, call_589796.host, call_589796.base,
                         call_589796.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589796, url, valid)

proc call*(call_589797: Call_ClassroomCoursesGet_589781; id: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## classroomCoursesGet
  ## Returns a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or for access errors.
  ## * `NOT_FOUND` if no course exists with the requested ID.
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
  ##   id: string (required)
  ##     : Identifier of the course to return.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589798 = newJObject()
  var query_589799 = newJObject()
  add(query_589799, "upload_protocol", newJString(uploadProtocol))
  add(query_589799, "fields", newJString(fields))
  add(query_589799, "quotaUser", newJString(quotaUser))
  add(query_589799, "alt", newJString(alt))
  add(query_589799, "oauth_token", newJString(oauthToken))
  add(query_589799, "callback", newJString(callback))
  add(query_589799, "access_token", newJString(accessToken))
  add(query_589799, "uploadType", newJString(uploadType))
  add(path_589798, "id", newJString(id))
  add(query_589799, "key", newJString(key))
  add(query_589799, "$.xgafv", newJString(Xgafv))
  add(query_589799, "prettyPrint", newJBool(prettyPrint))
  result = call_589797.call(path_589798, query_589799, nil, nil, nil)

var classroomCoursesGet* = Call_ClassroomCoursesGet_589781(
    name: "classroomCoursesGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/courses/{id}",
    validator: validate_ClassroomCoursesGet_589782, base: "/",
    url: url_ClassroomCoursesGet_589783, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesPatch_589840 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesPatch_589842(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesPatch_589841(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates one or more fields in a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to modify the
  ## requested course or for access errors.
  ## * `NOT_FOUND` if no course exists with the requested ID.
  ## * `INVALID_ARGUMENT` if invalid fields are specified in the update mask or
  ## if no update mask is supplied.
  ## * `FAILED_PRECONDITION` for the following request errors:
  ##     * CourseNotModifiable
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : Identifier of the course to update.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589843 = path.getOrDefault("id")
  valid_589843 = validateParameter(valid_589843, JString, required = true,
                                 default = nil)
  if valid_589843 != nil:
    section.add "id", valid_589843
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
  ##   updateMask: JString
  ##             : Mask that identifies which fields on the course to update.
  ## This field is required to do an update. The update will fail if invalid
  ## fields are specified. The following fields are valid:
  ## 
  ## * `name`
  ## * `section`
  ## * `descriptionHeading`
  ## * `description`
  ## * `room`
  ## * `courseState`
  ## * `ownerId`
  ## 
  ## Note: patches to ownerId are treated as being effective immediately, but in
  ## practice it may take some time for the ownership transfer of all affected
  ## resources to complete.
  ## 
  ## When set in a query parameter, this field should be specified as
  ## 
  ## `updateMask=<field1>,<field2>,...`
  section = newJObject()
  var valid_589844 = query.getOrDefault("upload_protocol")
  valid_589844 = validateParameter(valid_589844, JString, required = false,
                                 default = nil)
  if valid_589844 != nil:
    section.add "upload_protocol", valid_589844
  var valid_589845 = query.getOrDefault("fields")
  valid_589845 = validateParameter(valid_589845, JString, required = false,
                                 default = nil)
  if valid_589845 != nil:
    section.add "fields", valid_589845
  var valid_589846 = query.getOrDefault("quotaUser")
  valid_589846 = validateParameter(valid_589846, JString, required = false,
                                 default = nil)
  if valid_589846 != nil:
    section.add "quotaUser", valid_589846
  var valid_589847 = query.getOrDefault("alt")
  valid_589847 = validateParameter(valid_589847, JString, required = false,
                                 default = newJString("json"))
  if valid_589847 != nil:
    section.add "alt", valid_589847
  var valid_589848 = query.getOrDefault("oauth_token")
  valid_589848 = validateParameter(valid_589848, JString, required = false,
                                 default = nil)
  if valid_589848 != nil:
    section.add "oauth_token", valid_589848
  var valid_589849 = query.getOrDefault("callback")
  valid_589849 = validateParameter(valid_589849, JString, required = false,
                                 default = nil)
  if valid_589849 != nil:
    section.add "callback", valid_589849
  var valid_589850 = query.getOrDefault("access_token")
  valid_589850 = validateParameter(valid_589850, JString, required = false,
                                 default = nil)
  if valid_589850 != nil:
    section.add "access_token", valid_589850
  var valid_589851 = query.getOrDefault("uploadType")
  valid_589851 = validateParameter(valid_589851, JString, required = false,
                                 default = nil)
  if valid_589851 != nil:
    section.add "uploadType", valid_589851
  var valid_589852 = query.getOrDefault("key")
  valid_589852 = validateParameter(valid_589852, JString, required = false,
                                 default = nil)
  if valid_589852 != nil:
    section.add "key", valid_589852
  var valid_589853 = query.getOrDefault("$.xgafv")
  valid_589853 = validateParameter(valid_589853, JString, required = false,
                                 default = newJString("1"))
  if valid_589853 != nil:
    section.add "$.xgafv", valid_589853
  var valid_589854 = query.getOrDefault("prettyPrint")
  valid_589854 = validateParameter(valid_589854, JBool, required = false,
                                 default = newJBool(true))
  if valid_589854 != nil:
    section.add "prettyPrint", valid_589854
  var valid_589855 = query.getOrDefault("updateMask")
  valid_589855 = validateParameter(valid_589855, JString, required = false,
                                 default = nil)
  if valid_589855 != nil:
    section.add "updateMask", valid_589855
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

proc call*(call_589857: Call_ClassroomCoursesPatch_589840; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates one or more fields in a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to modify the
  ## requested course or for access errors.
  ## * `NOT_FOUND` if no course exists with the requested ID.
  ## * `INVALID_ARGUMENT` if invalid fields are specified in the update mask or
  ## if no update mask is supplied.
  ## * `FAILED_PRECONDITION` for the following request errors:
  ##     * CourseNotModifiable
  ## 
  let valid = call_589857.validator(path, query, header, formData, body)
  let scheme = call_589857.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589857.url(scheme.get, call_589857.host, call_589857.base,
                         call_589857.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589857, url, valid)

proc call*(call_589858: Call_ClassroomCoursesPatch_589840; id: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true;
          updateMask: string = ""): Recallable =
  ## classroomCoursesPatch
  ## Updates one or more fields in a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to modify the
  ## requested course or for access errors.
  ## * `NOT_FOUND` if no course exists with the requested ID.
  ## * `INVALID_ARGUMENT` if invalid fields are specified in the update mask or
  ## if no update mask is supplied.
  ## * `FAILED_PRECONDITION` for the following request errors:
  ##     * CourseNotModifiable
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
  ##   id: string (required)
  ##     : Identifier of the course to update.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: string
  ##             : Mask that identifies which fields on the course to update.
  ## This field is required to do an update. The update will fail if invalid
  ## fields are specified. The following fields are valid:
  ## 
  ## * `name`
  ## * `section`
  ## * `descriptionHeading`
  ## * `description`
  ## * `room`
  ## * `courseState`
  ## * `ownerId`
  ## 
  ## Note: patches to ownerId are treated as being effective immediately, but in
  ## practice it may take some time for the ownership transfer of all affected
  ## resources to complete.
  ## 
  ## When set in a query parameter, this field should be specified as
  ## 
  ## `updateMask=<field1>,<field2>,...`
  var path_589859 = newJObject()
  var query_589860 = newJObject()
  var body_589861 = newJObject()
  add(query_589860, "upload_protocol", newJString(uploadProtocol))
  add(query_589860, "fields", newJString(fields))
  add(query_589860, "quotaUser", newJString(quotaUser))
  add(query_589860, "alt", newJString(alt))
  add(query_589860, "oauth_token", newJString(oauthToken))
  add(query_589860, "callback", newJString(callback))
  add(query_589860, "access_token", newJString(accessToken))
  add(query_589860, "uploadType", newJString(uploadType))
  add(path_589859, "id", newJString(id))
  add(query_589860, "key", newJString(key))
  add(query_589860, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589861 = body
  add(query_589860, "prettyPrint", newJBool(prettyPrint))
  add(query_589860, "updateMask", newJString(updateMask))
  result = call_589858.call(path_589859, query_589860, nil, nil, body_589861)

var classroomCoursesPatch* = Call_ClassroomCoursesPatch_589840(
    name: "classroomCoursesPatch", meth: HttpMethod.HttpPatch,
    host: "classroom.googleapis.com", route: "/v1/courses/{id}",
    validator: validate_ClassroomCoursesPatch_589841, base: "/",
    url: url_ClassroomCoursesPatch_589842, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesDelete_589821 = ref object of OpenApiRestCall_588450
proc url_ClassroomCoursesDelete_589823(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesDelete_589822(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to delete the
  ## requested course or for access errors.
  ## * `NOT_FOUND` if no course exists with the requested ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : Identifier of the course to delete.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589824 = path.getOrDefault("id")
  valid_589824 = validateParameter(valid_589824, JString, required = true,
                                 default = nil)
  if valid_589824 != nil:
    section.add "id", valid_589824
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
  var valid_589825 = query.getOrDefault("upload_protocol")
  valid_589825 = validateParameter(valid_589825, JString, required = false,
                                 default = nil)
  if valid_589825 != nil:
    section.add "upload_protocol", valid_589825
  var valid_589826 = query.getOrDefault("fields")
  valid_589826 = validateParameter(valid_589826, JString, required = false,
                                 default = nil)
  if valid_589826 != nil:
    section.add "fields", valid_589826
  var valid_589827 = query.getOrDefault("quotaUser")
  valid_589827 = validateParameter(valid_589827, JString, required = false,
                                 default = nil)
  if valid_589827 != nil:
    section.add "quotaUser", valid_589827
  var valid_589828 = query.getOrDefault("alt")
  valid_589828 = validateParameter(valid_589828, JString, required = false,
                                 default = newJString("json"))
  if valid_589828 != nil:
    section.add "alt", valid_589828
  var valid_589829 = query.getOrDefault("oauth_token")
  valid_589829 = validateParameter(valid_589829, JString, required = false,
                                 default = nil)
  if valid_589829 != nil:
    section.add "oauth_token", valid_589829
  var valid_589830 = query.getOrDefault("callback")
  valid_589830 = validateParameter(valid_589830, JString, required = false,
                                 default = nil)
  if valid_589830 != nil:
    section.add "callback", valid_589830
  var valid_589831 = query.getOrDefault("access_token")
  valid_589831 = validateParameter(valid_589831, JString, required = false,
                                 default = nil)
  if valid_589831 != nil:
    section.add "access_token", valid_589831
  var valid_589832 = query.getOrDefault("uploadType")
  valid_589832 = validateParameter(valid_589832, JString, required = false,
                                 default = nil)
  if valid_589832 != nil:
    section.add "uploadType", valid_589832
  var valid_589833 = query.getOrDefault("key")
  valid_589833 = validateParameter(valid_589833, JString, required = false,
                                 default = nil)
  if valid_589833 != nil:
    section.add "key", valid_589833
  var valid_589834 = query.getOrDefault("$.xgafv")
  valid_589834 = validateParameter(valid_589834, JString, required = false,
                                 default = newJString("1"))
  if valid_589834 != nil:
    section.add "$.xgafv", valid_589834
  var valid_589835 = query.getOrDefault("prettyPrint")
  valid_589835 = validateParameter(valid_589835, JBool, required = false,
                                 default = newJBool(true))
  if valid_589835 != nil:
    section.add "prettyPrint", valid_589835
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589836: Call_ClassroomCoursesDelete_589821; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to delete the
  ## requested course or for access errors.
  ## * `NOT_FOUND` if no course exists with the requested ID.
  ## 
  let valid = call_589836.validator(path, query, header, formData, body)
  let scheme = call_589836.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589836.url(scheme.get, call_589836.host, call_589836.base,
                         call_589836.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589836, url, valid)

proc call*(call_589837: Call_ClassroomCoursesDelete_589821; id: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## classroomCoursesDelete
  ## Deletes a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to delete the
  ## requested course or for access errors.
  ## * `NOT_FOUND` if no course exists with the requested ID.
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
  ##   id: string (required)
  ##     : Identifier of the course to delete.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589838 = newJObject()
  var query_589839 = newJObject()
  add(query_589839, "upload_protocol", newJString(uploadProtocol))
  add(query_589839, "fields", newJString(fields))
  add(query_589839, "quotaUser", newJString(quotaUser))
  add(query_589839, "alt", newJString(alt))
  add(query_589839, "oauth_token", newJString(oauthToken))
  add(query_589839, "callback", newJString(callback))
  add(query_589839, "access_token", newJString(accessToken))
  add(query_589839, "uploadType", newJString(uploadType))
  add(path_589838, "id", newJString(id))
  add(query_589839, "key", newJString(key))
  add(query_589839, "$.xgafv", newJString(Xgafv))
  add(query_589839, "prettyPrint", newJBool(prettyPrint))
  result = call_589837.call(path_589838, query_589839, nil, nil, nil)

var classroomCoursesDelete* = Call_ClassroomCoursesDelete_589821(
    name: "classroomCoursesDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com", route: "/v1/courses/{id}",
    validator: validate_ClassroomCoursesDelete_589822, base: "/",
    url: url_ClassroomCoursesDelete_589823, schemes: {Scheme.Https})
type
  Call_ClassroomInvitationsCreate_589883 = ref object of OpenApiRestCall_588450
proc url_ClassroomInvitationsCreate_589885(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ClassroomInvitationsCreate_589884(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an invitation. Only one invitation for a user and course may exist
  ## at a time. Delete and re-create an invitation to make changes.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to create
  ## invitations for this course or for access errors.
  ## * `NOT_FOUND` if the course or the user does not exist.
  ## * `FAILED_PRECONDITION` if the requested user's account is disabled or if
  ## the user already has this role or a role with greater permissions.
  ## * `ALREADY_EXISTS` if an invitation for the specified user and course
  ## already exists.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  var valid_589886 = query.getOrDefault("upload_protocol")
  valid_589886 = validateParameter(valid_589886, JString, required = false,
                                 default = nil)
  if valid_589886 != nil:
    section.add "upload_protocol", valid_589886
  var valid_589887 = query.getOrDefault("fields")
  valid_589887 = validateParameter(valid_589887, JString, required = false,
                                 default = nil)
  if valid_589887 != nil:
    section.add "fields", valid_589887
  var valid_589888 = query.getOrDefault("quotaUser")
  valid_589888 = validateParameter(valid_589888, JString, required = false,
                                 default = nil)
  if valid_589888 != nil:
    section.add "quotaUser", valid_589888
  var valid_589889 = query.getOrDefault("alt")
  valid_589889 = validateParameter(valid_589889, JString, required = false,
                                 default = newJString("json"))
  if valid_589889 != nil:
    section.add "alt", valid_589889
  var valid_589890 = query.getOrDefault("oauth_token")
  valid_589890 = validateParameter(valid_589890, JString, required = false,
                                 default = nil)
  if valid_589890 != nil:
    section.add "oauth_token", valid_589890
  var valid_589891 = query.getOrDefault("callback")
  valid_589891 = validateParameter(valid_589891, JString, required = false,
                                 default = nil)
  if valid_589891 != nil:
    section.add "callback", valid_589891
  var valid_589892 = query.getOrDefault("access_token")
  valid_589892 = validateParameter(valid_589892, JString, required = false,
                                 default = nil)
  if valid_589892 != nil:
    section.add "access_token", valid_589892
  var valid_589893 = query.getOrDefault("uploadType")
  valid_589893 = validateParameter(valid_589893, JString, required = false,
                                 default = nil)
  if valid_589893 != nil:
    section.add "uploadType", valid_589893
  var valid_589894 = query.getOrDefault("key")
  valid_589894 = validateParameter(valid_589894, JString, required = false,
                                 default = nil)
  if valid_589894 != nil:
    section.add "key", valid_589894
  var valid_589895 = query.getOrDefault("$.xgafv")
  valid_589895 = validateParameter(valid_589895, JString, required = false,
                                 default = newJString("1"))
  if valid_589895 != nil:
    section.add "$.xgafv", valid_589895
  var valid_589896 = query.getOrDefault("prettyPrint")
  valid_589896 = validateParameter(valid_589896, JBool, required = false,
                                 default = newJBool(true))
  if valid_589896 != nil:
    section.add "prettyPrint", valid_589896
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

proc call*(call_589898: Call_ClassroomInvitationsCreate_589883; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an invitation. Only one invitation for a user and course may exist
  ## at a time. Delete and re-create an invitation to make changes.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to create
  ## invitations for this course or for access errors.
  ## * `NOT_FOUND` if the course or the user does not exist.
  ## * `FAILED_PRECONDITION` if the requested user's account is disabled or if
  ## the user already has this role or a role with greater permissions.
  ## * `ALREADY_EXISTS` if an invitation for the specified user and course
  ## already exists.
  ## 
  let valid = call_589898.validator(path, query, header, formData, body)
  let scheme = call_589898.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589898.url(scheme.get, call_589898.host, call_589898.base,
                         call_589898.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589898, url, valid)

proc call*(call_589899: Call_ClassroomInvitationsCreate_589883;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## classroomInvitationsCreate
  ## Creates an invitation. Only one invitation for a user and course may exist
  ## at a time. Delete and re-create an invitation to make changes.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to create
  ## invitations for this course or for access errors.
  ## * `NOT_FOUND` if the course or the user does not exist.
  ## * `FAILED_PRECONDITION` if the requested user's account is disabled or if
  ## the user already has this role or a role with greater permissions.
  ## * `ALREADY_EXISTS` if an invitation for the specified user and course
  ## already exists.
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
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589900 = newJObject()
  var body_589901 = newJObject()
  add(query_589900, "upload_protocol", newJString(uploadProtocol))
  add(query_589900, "fields", newJString(fields))
  add(query_589900, "quotaUser", newJString(quotaUser))
  add(query_589900, "alt", newJString(alt))
  add(query_589900, "oauth_token", newJString(oauthToken))
  add(query_589900, "callback", newJString(callback))
  add(query_589900, "access_token", newJString(accessToken))
  add(query_589900, "uploadType", newJString(uploadType))
  add(query_589900, "key", newJString(key))
  add(query_589900, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589901 = body
  add(query_589900, "prettyPrint", newJBool(prettyPrint))
  result = call_589899.call(nil, query_589900, nil, nil, body_589901)

var classroomInvitationsCreate* = Call_ClassroomInvitationsCreate_589883(
    name: "classroomInvitationsCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/invitations",
    validator: validate_ClassroomInvitationsCreate_589884, base: "/",
    url: url_ClassroomInvitationsCreate_589885, schemes: {Scheme.Https})
type
  Call_ClassroomInvitationsList_589862 = ref object of OpenApiRestCall_588450
proc url_ClassroomInvitationsList_589864(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ClassroomInvitationsList_589863(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of invitations that the requesting user is permitted to
  ## view, restricted to those that match the list request.
  ## 
  ## *Note:* At least one of `user_id` or `course_id` must be supplied. Both
  ## fields can be supplied.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` for access errors.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : nextPageToken
  ## value returned from a previous
  ## list call, indicating
  ## that the subsequent page of results should be returned.
  ## 
  ## The list request must be
  ## otherwise identical to the one that resulted in this token.
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
  ##   courseId: JString
  ##           : Restricts returned invitations to those for a course with the specified
  ## identifier.
  ##   pageSize: JInt
  ##           : Maximum number of items to return. Zero means no maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   userId: JString
  ##         : Restricts returned invitations to those for a specific user. The identifier
  ## can be one of the following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  section = newJObject()
  var valid_589865 = query.getOrDefault("upload_protocol")
  valid_589865 = validateParameter(valid_589865, JString, required = false,
                                 default = nil)
  if valid_589865 != nil:
    section.add "upload_protocol", valid_589865
  var valid_589866 = query.getOrDefault("fields")
  valid_589866 = validateParameter(valid_589866, JString, required = false,
                                 default = nil)
  if valid_589866 != nil:
    section.add "fields", valid_589866
  var valid_589867 = query.getOrDefault("pageToken")
  valid_589867 = validateParameter(valid_589867, JString, required = false,
                                 default = nil)
  if valid_589867 != nil:
    section.add "pageToken", valid_589867
  var valid_589868 = query.getOrDefault("quotaUser")
  valid_589868 = validateParameter(valid_589868, JString, required = false,
                                 default = nil)
  if valid_589868 != nil:
    section.add "quotaUser", valid_589868
  var valid_589869 = query.getOrDefault("alt")
  valid_589869 = validateParameter(valid_589869, JString, required = false,
                                 default = newJString("json"))
  if valid_589869 != nil:
    section.add "alt", valid_589869
  var valid_589870 = query.getOrDefault("oauth_token")
  valid_589870 = validateParameter(valid_589870, JString, required = false,
                                 default = nil)
  if valid_589870 != nil:
    section.add "oauth_token", valid_589870
  var valid_589871 = query.getOrDefault("callback")
  valid_589871 = validateParameter(valid_589871, JString, required = false,
                                 default = nil)
  if valid_589871 != nil:
    section.add "callback", valid_589871
  var valid_589872 = query.getOrDefault("access_token")
  valid_589872 = validateParameter(valid_589872, JString, required = false,
                                 default = nil)
  if valid_589872 != nil:
    section.add "access_token", valid_589872
  var valid_589873 = query.getOrDefault("uploadType")
  valid_589873 = validateParameter(valid_589873, JString, required = false,
                                 default = nil)
  if valid_589873 != nil:
    section.add "uploadType", valid_589873
  var valid_589874 = query.getOrDefault("key")
  valid_589874 = validateParameter(valid_589874, JString, required = false,
                                 default = nil)
  if valid_589874 != nil:
    section.add "key", valid_589874
  var valid_589875 = query.getOrDefault("$.xgafv")
  valid_589875 = validateParameter(valid_589875, JString, required = false,
                                 default = newJString("1"))
  if valid_589875 != nil:
    section.add "$.xgafv", valid_589875
  var valid_589876 = query.getOrDefault("courseId")
  valid_589876 = validateParameter(valid_589876, JString, required = false,
                                 default = nil)
  if valid_589876 != nil:
    section.add "courseId", valid_589876
  var valid_589877 = query.getOrDefault("pageSize")
  valid_589877 = validateParameter(valid_589877, JInt, required = false, default = nil)
  if valid_589877 != nil:
    section.add "pageSize", valid_589877
  var valid_589878 = query.getOrDefault("prettyPrint")
  valid_589878 = validateParameter(valid_589878, JBool, required = false,
                                 default = newJBool(true))
  if valid_589878 != nil:
    section.add "prettyPrint", valid_589878
  var valid_589879 = query.getOrDefault("userId")
  valid_589879 = validateParameter(valid_589879, JString, required = false,
                                 default = nil)
  if valid_589879 != nil:
    section.add "userId", valid_589879
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589880: Call_ClassroomInvitationsList_589862; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of invitations that the requesting user is permitted to
  ## view, restricted to those that match the list request.
  ## 
  ## *Note:* At least one of `user_id` or `course_id` must be supplied. Both
  ## fields can be supplied.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` for access errors.
  ## 
  let valid = call_589880.validator(path, query, header, formData, body)
  let scheme = call_589880.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589880.url(scheme.get, call_589880.host, call_589880.base,
                         call_589880.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589880, url, valid)

proc call*(call_589881: Call_ClassroomInvitationsList_589862;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; courseId: string = ""; pageSize: int = 0;
          prettyPrint: bool = true; userId: string = ""): Recallable =
  ## classroomInvitationsList
  ## Returns a list of invitations that the requesting user is permitted to
  ## view, restricted to those that match the list request.
  ## 
  ## *Note:* At least one of `user_id` or `course_id` must be supplied. Both
  ## fields can be supplied.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` for access errors.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : nextPageToken
  ## value returned from a previous
  ## list call, indicating
  ## that the subsequent page of results should be returned.
  ## 
  ## The list request must be
  ## otherwise identical to the one that resulted in this token.
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
  ##   Xgafv: string
  ##        : V1 error format.
  ##   courseId: string
  ##           : Restricts returned invitations to those for a course with the specified
  ## identifier.
  ##   pageSize: int
  ##           : Maximum number of items to return. Zero means no maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string
  ##         : Restricts returned invitations to those for a specific user. The identifier
  ## can be one of the following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  var query_589882 = newJObject()
  add(query_589882, "upload_protocol", newJString(uploadProtocol))
  add(query_589882, "fields", newJString(fields))
  add(query_589882, "pageToken", newJString(pageToken))
  add(query_589882, "quotaUser", newJString(quotaUser))
  add(query_589882, "alt", newJString(alt))
  add(query_589882, "oauth_token", newJString(oauthToken))
  add(query_589882, "callback", newJString(callback))
  add(query_589882, "access_token", newJString(accessToken))
  add(query_589882, "uploadType", newJString(uploadType))
  add(query_589882, "key", newJString(key))
  add(query_589882, "$.xgafv", newJString(Xgafv))
  add(query_589882, "courseId", newJString(courseId))
  add(query_589882, "pageSize", newJInt(pageSize))
  add(query_589882, "prettyPrint", newJBool(prettyPrint))
  add(query_589882, "userId", newJString(userId))
  result = call_589881.call(nil, query_589882, nil, nil, nil)

var classroomInvitationsList* = Call_ClassroomInvitationsList_589862(
    name: "classroomInvitationsList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/invitations",
    validator: validate_ClassroomInvitationsList_589863, base: "/",
    url: url_ClassroomInvitationsList_589864, schemes: {Scheme.Https})
type
  Call_ClassroomInvitationsGet_589902 = ref object of OpenApiRestCall_588450
proc url_ClassroomInvitationsGet_589904(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/invitations/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomInvitationsGet_589903(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns an invitation.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to view the
  ## requested invitation or for access errors.
  ## * `NOT_FOUND` if no invitation exists with the requested ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : Identifier of the invitation to return.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589905 = path.getOrDefault("id")
  valid_589905 = validateParameter(valid_589905, JString, required = true,
                                 default = nil)
  if valid_589905 != nil:
    section.add "id", valid_589905
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
  var valid_589906 = query.getOrDefault("upload_protocol")
  valid_589906 = validateParameter(valid_589906, JString, required = false,
                                 default = nil)
  if valid_589906 != nil:
    section.add "upload_protocol", valid_589906
  var valid_589907 = query.getOrDefault("fields")
  valid_589907 = validateParameter(valid_589907, JString, required = false,
                                 default = nil)
  if valid_589907 != nil:
    section.add "fields", valid_589907
  var valid_589908 = query.getOrDefault("quotaUser")
  valid_589908 = validateParameter(valid_589908, JString, required = false,
                                 default = nil)
  if valid_589908 != nil:
    section.add "quotaUser", valid_589908
  var valid_589909 = query.getOrDefault("alt")
  valid_589909 = validateParameter(valid_589909, JString, required = false,
                                 default = newJString("json"))
  if valid_589909 != nil:
    section.add "alt", valid_589909
  var valid_589910 = query.getOrDefault("oauth_token")
  valid_589910 = validateParameter(valid_589910, JString, required = false,
                                 default = nil)
  if valid_589910 != nil:
    section.add "oauth_token", valid_589910
  var valid_589911 = query.getOrDefault("callback")
  valid_589911 = validateParameter(valid_589911, JString, required = false,
                                 default = nil)
  if valid_589911 != nil:
    section.add "callback", valid_589911
  var valid_589912 = query.getOrDefault("access_token")
  valid_589912 = validateParameter(valid_589912, JString, required = false,
                                 default = nil)
  if valid_589912 != nil:
    section.add "access_token", valid_589912
  var valid_589913 = query.getOrDefault("uploadType")
  valid_589913 = validateParameter(valid_589913, JString, required = false,
                                 default = nil)
  if valid_589913 != nil:
    section.add "uploadType", valid_589913
  var valid_589914 = query.getOrDefault("key")
  valid_589914 = validateParameter(valid_589914, JString, required = false,
                                 default = nil)
  if valid_589914 != nil:
    section.add "key", valid_589914
  var valid_589915 = query.getOrDefault("$.xgafv")
  valid_589915 = validateParameter(valid_589915, JString, required = false,
                                 default = newJString("1"))
  if valid_589915 != nil:
    section.add "$.xgafv", valid_589915
  var valid_589916 = query.getOrDefault("prettyPrint")
  valid_589916 = validateParameter(valid_589916, JBool, required = false,
                                 default = newJBool(true))
  if valid_589916 != nil:
    section.add "prettyPrint", valid_589916
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589917: Call_ClassroomInvitationsGet_589902; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns an invitation.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to view the
  ## requested invitation or for access errors.
  ## * `NOT_FOUND` if no invitation exists with the requested ID.
  ## 
  let valid = call_589917.validator(path, query, header, formData, body)
  let scheme = call_589917.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589917.url(scheme.get, call_589917.host, call_589917.base,
                         call_589917.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589917, url, valid)

proc call*(call_589918: Call_ClassroomInvitationsGet_589902; id: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## classroomInvitationsGet
  ## Returns an invitation.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to view the
  ## requested invitation or for access errors.
  ## * `NOT_FOUND` if no invitation exists with the requested ID.
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
  ##   id: string (required)
  ##     : Identifier of the invitation to return.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589919 = newJObject()
  var query_589920 = newJObject()
  add(query_589920, "upload_protocol", newJString(uploadProtocol))
  add(query_589920, "fields", newJString(fields))
  add(query_589920, "quotaUser", newJString(quotaUser))
  add(query_589920, "alt", newJString(alt))
  add(query_589920, "oauth_token", newJString(oauthToken))
  add(query_589920, "callback", newJString(callback))
  add(query_589920, "access_token", newJString(accessToken))
  add(query_589920, "uploadType", newJString(uploadType))
  add(path_589919, "id", newJString(id))
  add(query_589920, "key", newJString(key))
  add(query_589920, "$.xgafv", newJString(Xgafv))
  add(query_589920, "prettyPrint", newJBool(prettyPrint))
  result = call_589918.call(path_589919, query_589920, nil, nil, nil)

var classroomInvitationsGet* = Call_ClassroomInvitationsGet_589902(
    name: "classroomInvitationsGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/invitations/{id}",
    validator: validate_ClassroomInvitationsGet_589903, base: "/",
    url: url_ClassroomInvitationsGet_589904, schemes: {Scheme.Https})
type
  Call_ClassroomInvitationsDelete_589921 = ref object of OpenApiRestCall_588450
proc url_ClassroomInvitationsDelete_589923(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/invitations/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomInvitationsDelete_589922(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an invitation.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to delete the
  ## requested invitation or for access errors.
  ## * `NOT_FOUND` if no invitation exists with the requested ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : Identifier of the invitation to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589924 = path.getOrDefault("id")
  valid_589924 = validateParameter(valid_589924, JString, required = true,
                                 default = nil)
  if valid_589924 != nil:
    section.add "id", valid_589924
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
  var valid_589925 = query.getOrDefault("upload_protocol")
  valid_589925 = validateParameter(valid_589925, JString, required = false,
                                 default = nil)
  if valid_589925 != nil:
    section.add "upload_protocol", valid_589925
  var valid_589926 = query.getOrDefault("fields")
  valid_589926 = validateParameter(valid_589926, JString, required = false,
                                 default = nil)
  if valid_589926 != nil:
    section.add "fields", valid_589926
  var valid_589927 = query.getOrDefault("quotaUser")
  valid_589927 = validateParameter(valid_589927, JString, required = false,
                                 default = nil)
  if valid_589927 != nil:
    section.add "quotaUser", valid_589927
  var valid_589928 = query.getOrDefault("alt")
  valid_589928 = validateParameter(valid_589928, JString, required = false,
                                 default = newJString("json"))
  if valid_589928 != nil:
    section.add "alt", valid_589928
  var valid_589929 = query.getOrDefault("oauth_token")
  valid_589929 = validateParameter(valid_589929, JString, required = false,
                                 default = nil)
  if valid_589929 != nil:
    section.add "oauth_token", valid_589929
  var valid_589930 = query.getOrDefault("callback")
  valid_589930 = validateParameter(valid_589930, JString, required = false,
                                 default = nil)
  if valid_589930 != nil:
    section.add "callback", valid_589930
  var valid_589931 = query.getOrDefault("access_token")
  valid_589931 = validateParameter(valid_589931, JString, required = false,
                                 default = nil)
  if valid_589931 != nil:
    section.add "access_token", valid_589931
  var valid_589932 = query.getOrDefault("uploadType")
  valid_589932 = validateParameter(valid_589932, JString, required = false,
                                 default = nil)
  if valid_589932 != nil:
    section.add "uploadType", valid_589932
  var valid_589933 = query.getOrDefault("key")
  valid_589933 = validateParameter(valid_589933, JString, required = false,
                                 default = nil)
  if valid_589933 != nil:
    section.add "key", valid_589933
  var valid_589934 = query.getOrDefault("$.xgafv")
  valid_589934 = validateParameter(valid_589934, JString, required = false,
                                 default = newJString("1"))
  if valid_589934 != nil:
    section.add "$.xgafv", valid_589934
  var valid_589935 = query.getOrDefault("prettyPrint")
  valid_589935 = validateParameter(valid_589935, JBool, required = false,
                                 default = newJBool(true))
  if valid_589935 != nil:
    section.add "prettyPrint", valid_589935
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589936: Call_ClassroomInvitationsDelete_589921; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an invitation.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to delete the
  ## requested invitation or for access errors.
  ## * `NOT_FOUND` if no invitation exists with the requested ID.
  ## 
  let valid = call_589936.validator(path, query, header, formData, body)
  let scheme = call_589936.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589936.url(scheme.get, call_589936.host, call_589936.base,
                         call_589936.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589936, url, valid)

proc call*(call_589937: Call_ClassroomInvitationsDelete_589921; id: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## classroomInvitationsDelete
  ## Deletes an invitation.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to delete the
  ## requested invitation or for access errors.
  ## * `NOT_FOUND` if no invitation exists with the requested ID.
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
  ##   id: string (required)
  ##     : Identifier of the invitation to delete.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589938 = newJObject()
  var query_589939 = newJObject()
  add(query_589939, "upload_protocol", newJString(uploadProtocol))
  add(query_589939, "fields", newJString(fields))
  add(query_589939, "quotaUser", newJString(quotaUser))
  add(query_589939, "alt", newJString(alt))
  add(query_589939, "oauth_token", newJString(oauthToken))
  add(query_589939, "callback", newJString(callback))
  add(query_589939, "access_token", newJString(accessToken))
  add(query_589939, "uploadType", newJString(uploadType))
  add(path_589938, "id", newJString(id))
  add(query_589939, "key", newJString(key))
  add(query_589939, "$.xgafv", newJString(Xgafv))
  add(query_589939, "prettyPrint", newJBool(prettyPrint))
  result = call_589937.call(path_589938, query_589939, nil, nil, nil)

var classroomInvitationsDelete* = Call_ClassroomInvitationsDelete_589921(
    name: "classroomInvitationsDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com", route: "/v1/invitations/{id}",
    validator: validate_ClassroomInvitationsDelete_589922, base: "/",
    url: url_ClassroomInvitationsDelete_589923, schemes: {Scheme.Https})
type
  Call_ClassroomInvitationsAccept_589940 = ref object of OpenApiRestCall_588450
proc url_ClassroomInvitationsAccept_589942(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/invitations/"),
               (kind: VariableSegment, value: "id"),
               (kind: ConstantSegment, value: ":accept")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomInvitationsAccept_589941(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Accepts an invitation, removing it and adding the invited user to the
  ## teachers or students (as appropriate) of the specified course. Only the
  ## invited user may accept an invitation.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to accept the
  ## requested invitation or for access errors.
  ## * `FAILED_PRECONDITION` for the following request errors:
  ##     * CourseMemberLimitReached
  ##     * CourseNotModifiable
  ##     * CourseTeacherLimitReached
  ##     * UserGroupsMembershipLimitReached
  ## * `NOT_FOUND` if no invitation exists with the requested ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : Identifier of the invitation to accept.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589943 = path.getOrDefault("id")
  valid_589943 = validateParameter(valid_589943, JString, required = true,
                                 default = nil)
  if valid_589943 != nil:
    section.add "id", valid_589943
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
  var valid_589944 = query.getOrDefault("upload_protocol")
  valid_589944 = validateParameter(valid_589944, JString, required = false,
                                 default = nil)
  if valid_589944 != nil:
    section.add "upload_protocol", valid_589944
  var valid_589945 = query.getOrDefault("fields")
  valid_589945 = validateParameter(valid_589945, JString, required = false,
                                 default = nil)
  if valid_589945 != nil:
    section.add "fields", valid_589945
  var valid_589946 = query.getOrDefault("quotaUser")
  valid_589946 = validateParameter(valid_589946, JString, required = false,
                                 default = nil)
  if valid_589946 != nil:
    section.add "quotaUser", valid_589946
  var valid_589947 = query.getOrDefault("alt")
  valid_589947 = validateParameter(valid_589947, JString, required = false,
                                 default = newJString("json"))
  if valid_589947 != nil:
    section.add "alt", valid_589947
  var valid_589948 = query.getOrDefault("oauth_token")
  valid_589948 = validateParameter(valid_589948, JString, required = false,
                                 default = nil)
  if valid_589948 != nil:
    section.add "oauth_token", valid_589948
  var valid_589949 = query.getOrDefault("callback")
  valid_589949 = validateParameter(valid_589949, JString, required = false,
                                 default = nil)
  if valid_589949 != nil:
    section.add "callback", valid_589949
  var valid_589950 = query.getOrDefault("access_token")
  valid_589950 = validateParameter(valid_589950, JString, required = false,
                                 default = nil)
  if valid_589950 != nil:
    section.add "access_token", valid_589950
  var valid_589951 = query.getOrDefault("uploadType")
  valid_589951 = validateParameter(valid_589951, JString, required = false,
                                 default = nil)
  if valid_589951 != nil:
    section.add "uploadType", valid_589951
  var valid_589952 = query.getOrDefault("key")
  valid_589952 = validateParameter(valid_589952, JString, required = false,
                                 default = nil)
  if valid_589952 != nil:
    section.add "key", valid_589952
  var valid_589953 = query.getOrDefault("$.xgafv")
  valid_589953 = validateParameter(valid_589953, JString, required = false,
                                 default = newJString("1"))
  if valid_589953 != nil:
    section.add "$.xgafv", valid_589953
  var valid_589954 = query.getOrDefault("prettyPrint")
  valid_589954 = validateParameter(valid_589954, JBool, required = false,
                                 default = newJBool(true))
  if valid_589954 != nil:
    section.add "prettyPrint", valid_589954
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589955: Call_ClassroomInvitationsAccept_589940; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Accepts an invitation, removing it and adding the invited user to the
  ## teachers or students (as appropriate) of the specified course. Only the
  ## invited user may accept an invitation.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to accept the
  ## requested invitation or for access errors.
  ## * `FAILED_PRECONDITION` for the following request errors:
  ##     * CourseMemberLimitReached
  ##     * CourseNotModifiable
  ##     * CourseTeacherLimitReached
  ##     * UserGroupsMembershipLimitReached
  ## * `NOT_FOUND` if no invitation exists with the requested ID.
  ## 
  let valid = call_589955.validator(path, query, header, formData, body)
  let scheme = call_589955.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589955.url(scheme.get, call_589955.host, call_589955.base,
                         call_589955.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589955, url, valid)

proc call*(call_589956: Call_ClassroomInvitationsAccept_589940; id: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## classroomInvitationsAccept
  ## Accepts an invitation, removing it and adding the invited user to the
  ## teachers or students (as appropriate) of the specified course. Only the
  ## invited user may accept an invitation.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to accept the
  ## requested invitation or for access errors.
  ## * `FAILED_PRECONDITION` for the following request errors:
  ##     * CourseMemberLimitReached
  ##     * CourseNotModifiable
  ##     * CourseTeacherLimitReached
  ##     * UserGroupsMembershipLimitReached
  ## * `NOT_FOUND` if no invitation exists with the requested ID.
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
  ##   id: string (required)
  ##     : Identifier of the invitation to accept.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589957 = newJObject()
  var query_589958 = newJObject()
  add(query_589958, "upload_protocol", newJString(uploadProtocol))
  add(query_589958, "fields", newJString(fields))
  add(query_589958, "quotaUser", newJString(quotaUser))
  add(query_589958, "alt", newJString(alt))
  add(query_589958, "oauth_token", newJString(oauthToken))
  add(query_589958, "callback", newJString(callback))
  add(query_589958, "access_token", newJString(accessToken))
  add(query_589958, "uploadType", newJString(uploadType))
  add(path_589957, "id", newJString(id))
  add(query_589958, "key", newJString(key))
  add(query_589958, "$.xgafv", newJString(Xgafv))
  add(query_589958, "prettyPrint", newJBool(prettyPrint))
  result = call_589956.call(path_589957, query_589958, nil, nil, nil)

var classroomInvitationsAccept* = Call_ClassroomInvitationsAccept_589940(
    name: "classroomInvitationsAccept", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/invitations/{id}:accept",
    validator: validate_ClassroomInvitationsAccept_589941, base: "/",
    url: url_ClassroomInvitationsAccept_589942, schemes: {Scheme.Https})
type
  Call_ClassroomRegistrationsCreate_589959 = ref object of OpenApiRestCall_588450
proc url_ClassroomRegistrationsCreate_589961(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ClassroomRegistrationsCreate_589960(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a `Registration`, causing Classroom to start sending notifications
  ## from the provided `feed` to the destination provided in `cloudPubSubTopic`.
  ## 
  ## Returns the created `Registration`. Currently, this will be the same as
  ## the argument, but with server-assigned fields such as `expiry_time` and
  ## `id` filled in.
  ## 
  ## Note that any value specified for the `expiry_time` or `id` fields will be
  ## ignored.
  ## 
  ## While Classroom may validate the `cloudPubSubTopic` and return errors on a
  ## best effort basis, it is the caller's responsibility to ensure that it
  ## exists and that Classroom has permission to publish to it.
  ## 
  ## This method may return the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if:
  ##     * the authenticated user does not have permission to receive
  ##       notifications from the requested field; or
  ##     * the credential provided does not include the appropriate scope for
  ##       the requested feed.
  ##     * another access error is encountered.
  ## * `INVALID_ARGUMENT` if:
  ##     * no `cloudPubsubTopic` is specified, or the specified
  ##       `cloudPubsubTopic` is not valid; or
  ##     * no `feed` is specified, or the specified `feed` is not valid.
  ## * `NOT_FOUND` if:
  ##     * the specified `feed` cannot be located, or the requesting user does
  ##       not have permission to determine whether or not it exists; or
  ##     * the specified `cloudPubsubTopic` cannot be located, or Classroom has
  ##       not been granted permission to publish to it.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  var valid_589962 = query.getOrDefault("upload_protocol")
  valid_589962 = validateParameter(valid_589962, JString, required = false,
                                 default = nil)
  if valid_589962 != nil:
    section.add "upload_protocol", valid_589962
  var valid_589963 = query.getOrDefault("fields")
  valid_589963 = validateParameter(valid_589963, JString, required = false,
                                 default = nil)
  if valid_589963 != nil:
    section.add "fields", valid_589963
  var valid_589964 = query.getOrDefault("quotaUser")
  valid_589964 = validateParameter(valid_589964, JString, required = false,
                                 default = nil)
  if valid_589964 != nil:
    section.add "quotaUser", valid_589964
  var valid_589965 = query.getOrDefault("alt")
  valid_589965 = validateParameter(valid_589965, JString, required = false,
                                 default = newJString("json"))
  if valid_589965 != nil:
    section.add "alt", valid_589965
  var valid_589966 = query.getOrDefault("oauth_token")
  valid_589966 = validateParameter(valid_589966, JString, required = false,
                                 default = nil)
  if valid_589966 != nil:
    section.add "oauth_token", valid_589966
  var valid_589967 = query.getOrDefault("callback")
  valid_589967 = validateParameter(valid_589967, JString, required = false,
                                 default = nil)
  if valid_589967 != nil:
    section.add "callback", valid_589967
  var valid_589968 = query.getOrDefault("access_token")
  valid_589968 = validateParameter(valid_589968, JString, required = false,
                                 default = nil)
  if valid_589968 != nil:
    section.add "access_token", valid_589968
  var valid_589969 = query.getOrDefault("uploadType")
  valid_589969 = validateParameter(valid_589969, JString, required = false,
                                 default = nil)
  if valid_589969 != nil:
    section.add "uploadType", valid_589969
  var valid_589970 = query.getOrDefault("key")
  valid_589970 = validateParameter(valid_589970, JString, required = false,
                                 default = nil)
  if valid_589970 != nil:
    section.add "key", valid_589970
  var valid_589971 = query.getOrDefault("$.xgafv")
  valid_589971 = validateParameter(valid_589971, JString, required = false,
                                 default = newJString("1"))
  if valid_589971 != nil:
    section.add "$.xgafv", valid_589971
  var valid_589972 = query.getOrDefault("prettyPrint")
  valid_589972 = validateParameter(valid_589972, JBool, required = false,
                                 default = newJBool(true))
  if valid_589972 != nil:
    section.add "prettyPrint", valid_589972
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

proc call*(call_589974: Call_ClassroomRegistrationsCreate_589959; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a `Registration`, causing Classroom to start sending notifications
  ## from the provided `feed` to the destination provided in `cloudPubSubTopic`.
  ## 
  ## Returns the created `Registration`. Currently, this will be the same as
  ## the argument, but with server-assigned fields such as `expiry_time` and
  ## `id` filled in.
  ## 
  ## Note that any value specified for the `expiry_time` or `id` fields will be
  ## ignored.
  ## 
  ## While Classroom may validate the `cloudPubSubTopic` and return errors on a
  ## best effort basis, it is the caller's responsibility to ensure that it
  ## exists and that Classroom has permission to publish to it.
  ## 
  ## This method may return the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if:
  ##     * the authenticated user does not have permission to receive
  ##       notifications from the requested field; or
  ##     * the credential provided does not include the appropriate scope for
  ##       the requested feed.
  ##     * another access error is encountered.
  ## * `INVALID_ARGUMENT` if:
  ##     * no `cloudPubsubTopic` is specified, or the specified
  ##       `cloudPubsubTopic` is not valid; or
  ##     * no `feed` is specified, or the specified `feed` is not valid.
  ## * `NOT_FOUND` if:
  ##     * the specified `feed` cannot be located, or the requesting user does
  ##       not have permission to determine whether or not it exists; or
  ##     * the specified `cloudPubsubTopic` cannot be located, or Classroom has
  ##       not been granted permission to publish to it.
  ## 
  let valid = call_589974.validator(path, query, header, formData, body)
  let scheme = call_589974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589974.url(scheme.get, call_589974.host, call_589974.base,
                         call_589974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589974, url, valid)

proc call*(call_589975: Call_ClassroomRegistrationsCreate_589959;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## classroomRegistrationsCreate
  ## Creates a `Registration`, causing Classroom to start sending notifications
  ## from the provided `feed` to the destination provided in `cloudPubSubTopic`.
  ## 
  ## Returns the created `Registration`. Currently, this will be the same as
  ## the argument, but with server-assigned fields such as `expiry_time` and
  ## `id` filled in.
  ## 
  ## Note that any value specified for the `expiry_time` or `id` fields will be
  ## ignored.
  ## 
  ## While Classroom may validate the `cloudPubSubTopic` and return errors on a
  ## best effort basis, it is the caller's responsibility to ensure that it
  ## exists and that Classroom has permission to publish to it.
  ## 
  ## This method may return the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if:
  ##     * the authenticated user does not have permission to receive
  ##       notifications from the requested field; or
  ##     * the credential provided does not include the appropriate scope for
  ##       the requested feed.
  ##     * another access error is encountered.
  ## * `INVALID_ARGUMENT` if:
  ##     * no `cloudPubsubTopic` is specified, or the specified
  ##       `cloudPubsubTopic` is not valid; or
  ##     * no `feed` is specified, or the specified `feed` is not valid.
  ## * `NOT_FOUND` if:
  ##     * the specified `feed` cannot be located, or the requesting user does
  ##       not have permission to determine whether or not it exists; or
  ##     * the specified `cloudPubsubTopic` cannot be located, or Classroom has
  ##       not been granted permission to publish to it.
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
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589976 = newJObject()
  var body_589977 = newJObject()
  add(query_589976, "upload_protocol", newJString(uploadProtocol))
  add(query_589976, "fields", newJString(fields))
  add(query_589976, "quotaUser", newJString(quotaUser))
  add(query_589976, "alt", newJString(alt))
  add(query_589976, "oauth_token", newJString(oauthToken))
  add(query_589976, "callback", newJString(callback))
  add(query_589976, "access_token", newJString(accessToken))
  add(query_589976, "uploadType", newJString(uploadType))
  add(query_589976, "key", newJString(key))
  add(query_589976, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589977 = body
  add(query_589976, "prettyPrint", newJBool(prettyPrint))
  result = call_589975.call(nil, query_589976, nil, nil, body_589977)

var classroomRegistrationsCreate* = Call_ClassroomRegistrationsCreate_589959(
    name: "classroomRegistrationsCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/registrations",
    validator: validate_ClassroomRegistrationsCreate_589960, base: "/",
    url: url_ClassroomRegistrationsCreate_589961, schemes: {Scheme.Https})
type
  Call_ClassroomRegistrationsDelete_589978 = ref object of OpenApiRestCall_588450
proc url_ClassroomRegistrationsDelete_589980(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "registrationId" in path, "`registrationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/registrations/"),
               (kind: VariableSegment, value: "registrationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomRegistrationsDelete_589979(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a `Registration`, causing Classroom to stop sending notifications
  ## for that `Registration`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   registrationId: JString (required)
  ##                 : The `registration_id` of the `Registration` to be deleted.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `registrationId` field"
  var valid_589981 = path.getOrDefault("registrationId")
  valid_589981 = validateParameter(valid_589981, JString, required = true,
                                 default = nil)
  if valid_589981 != nil:
    section.add "registrationId", valid_589981
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
  var valid_589982 = query.getOrDefault("upload_protocol")
  valid_589982 = validateParameter(valid_589982, JString, required = false,
                                 default = nil)
  if valid_589982 != nil:
    section.add "upload_protocol", valid_589982
  var valid_589983 = query.getOrDefault("fields")
  valid_589983 = validateParameter(valid_589983, JString, required = false,
                                 default = nil)
  if valid_589983 != nil:
    section.add "fields", valid_589983
  var valid_589984 = query.getOrDefault("quotaUser")
  valid_589984 = validateParameter(valid_589984, JString, required = false,
                                 default = nil)
  if valid_589984 != nil:
    section.add "quotaUser", valid_589984
  var valid_589985 = query.getOrDefault("alt")
  valid_589985 = validateParameter(valid_589985, JString, required = false,
                                 default = newJString("json"))
  if valid_589985 != nil:
    section.add "alt", valid_589985
  var valid_589986 = query.getOrDefault("oauth_token")
  valid_589986 = validateParameter(valid_589986, JString, required = false,
                                 default = nil)
  if valid_589986 != nil:
    section.add "oauth_token", valid_589986
  var valid_589987 = query.getOrDefault("callback")
  valid_589987 = validateParameter(valid_589987, JString, required = false,
                                 default = nil)
  if valid_589987 != nil:
    section.add "callback", valid_589987
  var valid_589988 = query.getOrDefault("access_token")
  valid_589988 = validateParameter(valid_589988, JString, required = false,
                                 default = nil)
  if valid_589988 != nil:
    section.add "access_token", valid_589988
  var valid_589989 = query.getOrDefault("uploadType")
  valid_589989 = validateParameter(valid_589989, JString, required = false,
                                 default = nil)
  if valid_589989 != nil:
    section.add "uploadType", valid_589989
  var valid_589990 = query.getOrDefault("key")
  valid_589990 = validateParameter(valid_589990, JString, required = false,
                                 default = nil)
  if valid_589990 != nil:
    section.add "key", valid_589990
  var valid_589991 = query.getOrDefault("$.xgafv")
  valid_589991 = validateParameter(valid_589991, JString, required = false,
                                 default = newJString("1"))
  if valid_589991 != nil:
    section.add "$.xgafv", valid_589991
  var valid_589992 = query.getOrDefault("prettyPrint")
  valid_589992 = validateParameter(valid_589992, JBool, required = false,
                                 default = newJBool(true))
  if valid_589992 != nil:
    section.add "prettyPrint", valid_589992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589993: Call_ClassroomRegistrationsDelete_589978; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a `Registration`, causing Classroom to stop sending notifications
  ## for that `Registration`.
  ## 
  let valid = call_589993.validator(path, query, header, formData, body)
  let scheme = call_589993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589993.url(scheme.get, call_589993.host, call_589993.base,
                         call_589993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589993, url, valid)

proc call*(call_589994: Call_ClassroomRegistrationsDelete_589978;
          registrationId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## classroomRegistrationsDelete
  ## Deletes a `Registration`, causing Classroom to stop sending notifications
  ## for that `Registration`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   registrationId: string (required)
  ##                 : The `registration_id` of the `Registration` to be deleted.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589995 = newJObject()
  var query_589996 = newJObject()
  add(query_589996, "upload_protocol", newJString(uploadProtocol))
  add(query_589996, "fields", newJString(fields))
  add(query_589996, "quotaUser", newJString(quotaUser))
  add(path_589995, "registrationId", newJString(registrationId))
  add(query_589996, "alt", newJString(alt))
  add(query_589996, "oauth_token", newJString(oauthToken))
  add(query_589996, "callback", newJString(callback))
  add(query_589996, "access_token", newJString(accessToken))
  add(query_589996, "uploadType", newJString(uploadType))
  add(query_589996, "key", newJString(key))
  add(query_589996, "$.xgafv", newJString(Xgafv))
  add(query_589996, "prettyPrint", newJBool(prettyPrint))
  result = call_589994.call(path_589995, query_589996, nil, nil, nil)

var classroomRegistrationsDelete* = Call_ClassroomRegistrationsDelete_589978(
    name: "classroomRegistrationsDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com", route: "/v1/registrations/{registrationId}",
    validator: validate_ClassroomRegistrationsDelete_589979, base: "/",
    url: url_ClassroomRegistrationsDelete_589980, schemes: {Scheme.Https})
type
  Call_ClassroomUserProfilesGuardianInvitationsCreate_590020 = ref object of OpenApiRestCall_588450
proc url_ClassroomUserProfilesGuardianInvitationsCreate_590022(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "studentId" in path, "`studentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/userProfiles/"),
               (kind: VariableSegment, value: "studentId"),
               (kind: ConstantSegment, value: "/guardianInvitations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomUserProfilesGuardianInvitationsCreate_590021(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a guardian invitation, and sends an email to the guardian asking
  ## them to confirm that they are the student's guardian.
  ## 
  ## Once the guardian accepts the invitation, their `state` will change to
  ## `COMPLETED` and they will start receiving guardian notifications. A
  ## `Guardian` resource will also be created to represent the active guardian.
  ## 
  ## The request object must have the `student_id` and
  ## `invited_email_address` fields set. Failing to set these fields, or
  ## setting any other fields in the request, will result in an error.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the current user does not have permission to
  ##   manage guardians, if the guardian in question has already rejected
  ##   too many requests for that student, if guardians are not enabled for the
  ##   domain in question, or for other access errors.
  ## * `RESOURCE_EXHAUSTED` if the student or guardian has exceeded the guardian
  ##   link limit.
  ## * `INVALID_ARGUMENT` if the guardian email address is not valid (for
  ##   example, if it is too long), or if the format of the student ID provided
  ##   cannot be recognized (it is not an email address, nor a `user_id` from
  ##   this API). This error will also be returned if read-only fields are set,
  ##   or if the `state` field is set to to a value other than `PENDING`.
  ## * `NOT_FOUND` if the student ID provided is a valid student ID, but
  ##   Classroom has no record of that student.
  ## * `ALREADY_EXISTS` if there is already a pending guardian invitation for
  ##   the student and `invited_email_address` provided, or if the provided
  ##   `invited_email_address` matches the Google account of an existing
  ##   `Guardian` for this user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   studentId: JString (required)
  ##            : ID of the student (in standard format)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `studentId` field"
  var valid_590023 = path.getOrDefault("studentId")
  valid_590023 = validateParameter(valid_590023, JString, required = true,
                                 default = nil)
  if valid_590023 != nil:
    section.add "studentId", valid_590023
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
  var valid_590024 = query.getOrDefault("upload_protocol")
  valid_590024 = validateParameter(valid_590024, JString, required = false,
                                 default = nil)
  if valid_590024 != nil:
    section.add "upload_protocol", valid_590024
  var valid_590025 = query.getOrDefault("fields")
  valid_590025 = validateParameter(valid_590025, JString, required = false,
                                 default = nil)
  if valid_590025 != nil:
    section.add "fields", valid_590025
  var valid_590026 = query.getOrDefault("quotaUser")
  valid_590026 = validateParameter(valid_590026, JString, required = false,
                                 default = nil)
  if valid_590026 != nil:
    section.add "quotaUser", valid_590026
  var valid_590027 = query.getOrDefault("alt")
  valid_590027 = validateParameter(valid_590027, JString, required = false,
                                 default = newJString("json"))
  if valid_590027 != nil:
    section.add "alt", valid_590027
  var valid_590028 = query.getOrDefault("oauth_token")
  valid_590028 = validateParameter(valid_590028, JString, required = false,
                                 default = nil)
  if valid_590028 != nil:
    section.add "oauth_token", valid_590028
  var valid_590029 = query.getOrDefault("callback")
  valid_590029 = validateParameter(valid_590029, JString, required = false,
                                 default = nil)
  if valid_590029 != nil:
    section.add "callback", valid_590029
  var valid_590030 = query.getOrDefault("access_token")
  valid_590030 = validateParameter(valid_590030, JString, required = false,
                                 default = nil)
  if valid_590030 != nil:
    section.add "access_token", valid_590030
  var valid_590031 = query.getOrDefault("uploadType")
  valid_590031 = validateParameter(valid_590031, JString, required = false,
                                 default = nil)
  if valid_590031 != nil:
    section.add "uploadType", valid_590031
  var valid_590032 = query.getOrDefault("key")
  valid_590032 = validateParameter(valid_590032, JString, required = false,
                                 default = nil)
  if valid_590032 != nil:
    section.add "key", valid_590032
  var valid_590033 = query.getOrDefault("$.xgafv")
  valid_590033 = validateParameter(valid_590033, JString, required = false,
                                 default = newJString("1"))
  if valid_590033 != nil:
    section.add "$.xgafv", valid_590033
  var valid_590034 = query.getOrDefault("prettyPrint")
  valid_590034 = validateParameter(valid_590034, JBool, required = false,
                                 default = newJBool(true))
  if valid_590034 != nil:
    section.add "prettyPrint", valid_590034
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

proc call*(call_590036: Call_ClassroomUserProfilesGuardianInvitationsCreate_590020;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a guardian invitation, and sends an email to the guardian asking
  ## them to confirm that they are the student's guardian.
  ## 
  ## Once the guardian accepts the invitation, their `state` will change to
  ## `COMPLETED` and they will start receiving guardian notifications. A
  ## `Guardian` resource will also be created to represent the active guardian.
  ## 
  ## The request object must have the `student_id` and
  ## `invited_email_address` fields set. Failing to set these fields, or
  ## setting any other fields in the request, will result in an error.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the current user does not have permission to
  ##   manage guardians, if the guardian in question has already rejected
  ##   too many requests for that student, if guardians are not enabled for the
  ##   domain in question, or for other access errors.
  ## * `RESOURCE_EXHAUSTED` if the student or guardian has exceeded the guardian
  ##   link limit.
  ## * `INVALID_ARGUMENT` if the guardian email address is not valid (for
  ##   example, if it is too long), or if the format of the student ID provided
  ##   cannot be recognized (it is not an email address, nor a `user_id` from
  ##   this API). This error will also be returned if read-only fields are set,
  ##   or if the `state` field is set to to a value other than `PENDING`.
  ## * `NOT_FOUND` if the student ID provided is a valid student ID, but
  ##   Classroom has no record of that student.
  ## * `ALREADY_EXISTS` if there is already a pending guardian invitation for
  ##   the student and `invited_email_address` provided, or if the provided
  ##   `invited_email_address` matches the Google account of an existing
  ##   `Guardian` for this user.
  ## 
  let valid = call_590036.validator(path, query, header, formData, body)
  let scheme = call_590036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590036.url(scheme.get, call_590036.host, call_590036.base,
                         call_590036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590036, url, valid)

proc call*(call_590037: Call_ClassroomUserProfilesGuardianInvitationsCreate_590020;
          studentId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## classroomUserProfilesGuardianInvitationsCreate
  ## Creates a guardian invitation, and sends an email to the guardian asking
  ## them to confirm that they are the student's guardian.
  ## 
  ## Once the guardian accepts the invitation, their `state` will change to
  ## `COMPLETED` and they will start receiving guardian notifications. A
  ## `Guardian` resource will also be created to represent the active guardian.
  ## 
  ## The request object must have the `student_id` and
  ## `invited_email_address` fields set. Failing to set these fields, or
  ## setting any other fields in the request, will result in an error.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the current user does not have permission to
  ##   manage guardians, if the guardian in question has already rejected
  ##   too many requests for that student, if guardians are not enabled for the
  ##   domain in question, or for other access errors.
  ## * `RESOURCE_EXHAUSTED` if the student or guardian has exceeded the guardian
  ##   link limit.
  ## * `INVALID_ARGUMENT` if the guardian email address is not valid (for
  ##   example, if it is too long), or if the format of the student ID provided
  ##   cannot be recognized (it is not an email address, nor a `user_id` from
  ##   this API). This error will also be returned if read-only fields are set,
  ##   or if the `state` field is set to to a value other than `PENDING`.
  ## * `NOT_FOUND` if the student ID provided is a valid student ID, but
  ##   Classroom has no record of that student.
  ## * `ALREADY_EXISTS` if there is already a pending guardian invitation for
  ##   the student and `invited_email_address` provided, or if the provided
  ##   `invited_email_address` matches the Google account of an existing
  ##   `Guardian` for this user.
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
  ##   studentId: string (required)
  ##            : ID of the student (in standard format)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590038 = newJObject()
  var query_590039 = newJObject()
  var body_590040 = newJObject()
  add(query_590039, "upload_protocol", newJString(uploadProtocol))
  add(query_590039, "fields", newJString(fields))
  add(query_590039, "quotaUser", newJString(quotaUser))
  add(query_590039, "alt", newJString(alt))
  add(query_590039, "oauth_token", newJString(oauthToken))
  add(query_590039, "callback", newJString(callback))
  add(query_590039, "access_token", newJString(accessToken))
  add(query_590039, "uploadType", newJString(uploadType))
  add(path_590038, "studentId", newJString(studentId))
  add(query_590039, "key", newJString(key))
  add(query_590039, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_590040 = body
  add(query_590039, "prettyPrint", newJBool(prettyPrint))
  result = call_590037.call(path_590038, query_590039, nil, nil, body_590040)

var classroomUserProfilesGuardianInvitationsCreate* = Call_ClassroomUserProfilesGuardianInvitationsCreate_590020(
    name: "classroomUserProfilesGuardianInvitationsCreate",
    meth: HttpMethod.HttpPost, host: "classroom.googleapis.com",
    route: "/v1/userProfiles/{studentId}/guardianInvitations",
    validator: validate_ClassroomUserProfilesGuardianInvitationsCreate_590021,
    base: "/", url: url_ClassroomUserProfilesGuardianInvitationsCreate_590022,
    schemes: {Scheme.Https})
type
  Call_ClassroomUserProfilesGuardianInvitationsList_589997 = ref object of OpenApiRestCall_588450
proc url_ClassroomUserProfilesGuardianInvitationsList_589999(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "studentId" in path, "`studentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/userProfiles/"),
               (kind: VariableSegment, value: "studentId"),
               (kind: ConstantSegment, value: "/guardianInvitations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomUserProfilesGuardianInvitationsList_589998(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of guardian invitations that the requesting user is
  ## permitted to view, filtered by the parameters provided.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if a `student_id` is specified, and the requesting
  ##   user is not permitted to view guardian invitations for that student, if
  ##   `"-"` is specified as the `student_id` and the user is not a domain
  ##   administrator, if guardians are not enabled for the domain in question,
  ##   or for other access errors.
  ## * `INVALID_ARGUMENT` if a `student_id` is specified, but its format cannot
  ##   be recognized (it is not an email address, nor a `student_id` from the
  ##   API, nor the literal string `me`). May also be returned if an invalid
  ##   `page_token` or `state` is provided.
  ## * `NOT_FOUND` if a `student_id` is specified, and its format can be
  ##   recognized, but Classroom has no record of that student.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   studentId: JString (required)
  ##            : The ID of the student whose guardian invitations are to be returned.
  ## The identifier can be one of the following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  ## * the string literal `"-"`, indicating that results should be returned for
  ##   all students that the requesting user is permitted to view guardian
  ##   invitations.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `studentId` field"
  var valid_590000 = path.getOrDefault("studentId")
  valid_590000 = validateParameter(valid_590000, JString, required = true,
                                 default = nil)
  if valid_590000 != nil:
    section.add "studentId", valid_590000
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : nextPageToken
  ## value returned from a previous
  ## list call,
  ## indicating that the subsequent page of results should be returned.
  ## 
  ## The list request
  ## must be otherwise identical to the one that resulted in this token.
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
  ##   states: JArray
  ##         : If specified, only results with the specified `state` values will be
  ## returned. Otherwise, results with a `state` of `PENDING` will be returned.
  ##   invitedEmailAddress: JString
  ##                      : If specified, only results with the specified `invited_email_address`
  ## will be returned.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Maximum number of items to return. Zero or unspecified indicates that the
  ## server may assign a maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590001 = query.getOrDefault("upload_protocol")
  valid_590001 = validateParameter(valid_590001, JString, required = false,
                                 default = nil)
  if valid_590001 != nil:
    section.add "upload_protocol", valid_590001
  var valid_590002 = query.getOrDefault("fields")
  valid_590002 = validateParameter(valid_590002, JString, required = false,
                                 default = nil)
  if valid_590002 != nil:
    section.add "fields", valid_590002
  var valid_590003 = query.getOrDefault("pageToken")
  valid_590003 = validateParameter(valid_590003, JString, required = false,
                                 default = nil)
  if valid_590003 != nil:
    section.add "pageToken", valid_590003
  var valid_590004 = query.getOrDefault("quotaUser")
  valid_590004 = validateParameter(valid_590004, JString, required = false,
                                 default = nil)
  if valid_590004 != nil:
    section.add "quotaUser", valid_590004
  var valid_590005 = query.getOrDefault("alt")
  valid_590005 = validateParameter(valid_590005, JString, required = false,
                                 default = newJString("json"))
  if valid_590005 != nil:
    section.add "alt", valid_590005
  var valid_590006 = query.getOrDefault("oauth_token")
  valid_590006 = validateParameter(valid_590006, JString, required = false,
                                 default = nil)
  if valid_590006 != nil:
    section.add "oauth_token", valid_590006
  var valid_590007 = query.getOrDefault("callback")
  valid_590007 = validateParameter(valid_590007, JString, required = false,
                                 default = nil)
  if valid_590007 != nil:
    section.add "callback", valid_590007
  var valid_590008 = query.getOrDefault("access_token")
  valid_590008 = validateParameter(valid_590008, JString, required = false,
                                 default = nil)
  if valid_590008 != nil:
    section.add "access_token", valid_590008
  var valid_590009 = query.getOrDefault("uploadType")
  valid_590009 = validateParameter(valid_590009, JString, required = false,
                                 default = nil)
  if valid_590009 != nil:
    section.add "uploadType", valid_590009
  var valid_590010 = query.getOrDefault("key")
  valid_590010 = validateParameter(valid_590010, JString, required = false,
                                 default = nil)
  if valid_590010 != nil:
    section.add "key", valid_590010
  var valid_590011 = query.getOrDefault("states")
  valid_590011 = validateParameter(valid_590011, JArray, required = false,
                                 default = nil)
  if valid_590011 != nil:
    section.add "states", valid_590011
  var valid_590012 = query.getOrDefault("invitedEmailAddress")
  valid_590012 = validateParameter(valid_590012, JString, required = false,
                                 default = nil)
  if valid_590012 != nil:
    section.add "invitedEmailAddress", valid_590012
  var valid_590013 = query.getOrDefault("$.xgafv")
  valid_590013 = validateParameter(valid_590013, JString, required = false,
                                 default = newJString("1"))
  if valid_590013 != nil:
    section.add "$.xgafv", valid_590013
  var valid_590014 = query.getOrDefault("pageSize")
  valid_590014 = validateParameter(valid_590014, JInt, required = false, default = nil)
  if valid_590014 != nil:
    section.add "pageSize", valid_590014
  var valid_590015 = query.getOrDefault("prettyPrint")
  valid_590015 = validateParameter(valid_590015, JBool, required = false,
                                 default = newJBool(true))
  if valid_590015 != nil:
    section.add "prettyPrint", valid_590015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590016: Call_ClassroomUserProfilesGuardianInvitationsList_589997;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of guardian invitations that the requesting user is
  ## permitted to view, filtered by the parameters provided.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if a `student_id` is specified, and the requesting
  ##   user is not permitted to view guardian invitations for that student, if
  ##   `"-"` is specified as the `student_id` and the user is not a domain
  ##   administrator, if guardians are not enabled for the domain in question,
  ##   or for other access errors.
  ## * `INVALID_ARGUMENT` if a `student_id` is specified, but its format cannot
  ##   be recognized (it is not an email address, nor a `student_id` from the
  ##   API, nor the literal string `me`). May also be returned if an invalid
  ##   `page_token` or `state` is provided.
  ## * `NOT_FOUND` if a `student_id` is specified, and its format can be
  ##   recognized, but Classroom has no record of that student.
  ## 
  let valid = call_590016.validator(path, query, header, formData, body)
  let scheme = call_590016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590016.url(scheme.get, call_590016.host, call_590016.base,
                         call_590016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590016, url, valid)

proc call*(call_590017: Call_ClassroomUserProfilesGuardianInvitationsList_589997;
          studentId: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; states: JsonNode = nil;
          invitedEmailAddress: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## classroomUserProfilesGuardianInvitationsList
  ## Returns a list of guardian invitations that the requesting user is
  ## permitted to view, filtered by the parameters provided.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if a `student_id` is specified, and the requesting
  ##   user is not permitted to view guardian invitations for that student, if
  ##   `"-"` is specified as the `student_id` and the user is not a domain
  ##   administrator, if guardians are not enabled for the domain in question,
  ##   or for other access errors.
  ## * `INVALID_ARGUMENT` if a `student_id` is specified, but its format cannot
  ##   be recognized (it is not an email address, nor a `student_id` from the
  ##   API, nor the literal string `me`). May also be returned if an invalid
  ##   `page_token` or `state` is provided.
  ## * `NOT_FOUND` if a `student_id` is specified, and its format can be
  ##   recognized, but Classroom has no record of that student.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : nextPageToken
  ## value returned from a previous
  ## list call,
  ## indicating that the subsequent page of results should be returned.
  ## 
  ## The list request
  ## must be otherwise identical to the one that resulted in this token.
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
  ##   studentId: string (required)
  ##            : The ID of the student whose guardian invitations are to be returned.
  ## The identifier can be one of the following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  ## * the string literal `"-"`, indicating that results should be returned for
  ##   all students that the requesting user is permitted to view guardian
  ##   invitations.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   states: JArray
  ##         : If specified, only results with the specified `state` values will be
  ## returned. Otherwise, results with a `state` of `PENDING` will be returned.
  ##   invitedEmailAddress: string
  ##                      : If specified, only results with the specified `invited_email_address`
  ## will be returned.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of items to return. Zero or unspecified indicates that the
  ## server may assign a maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590018 = newJObject()
  var query_590019 = newJObject()
  add(query_590019, "upload_protocol", newJString(uploadProtocol))
  add(query_590019, "fields", newJString(fields))
  add(query_590019, "pageToken", newJString(pageToken))
  add(query_590019, "quotaUser", newJString(quotaUser))
  add(query_590019, "alt", newJString(alt))
  add(query_590019, "oauth_token", newJString(oauthToken))
  add(query_590019, "callback", newJString(callback))
  add(query_590019, "access_token", newJString(accessToken))
  add(query_590019, "uploadType", newJString(uploadType))
  add(path_590018, "studentId", newJString(studentId))
  add(query_590019, "key", newJString(key))
  if states != nil:
    query_590019.add "states", states
  add(query_590019, "invitedEmailAddress", newJString(invitedEmailAddress))
  add(query_590019, "$.xgafv", newJString(Xgafv))
  add(query_590019, "pageSize", newJInt(pageSize))
  add(query_590019, "prettyPrint", newJBool(prettyPrint))
  result = call_590017.call(path_590018, query_590019, nil, nil, nil)

var classroomUserProfilesGuardianInvitationsList* = Call_ClassroomUserProfilesGuardianInvitationsList_589997(
    name: "classroomUserProfilesGuardianInvitationsList",
    meth: HttpMethod.HttpGet, host: "classroom.googleapis.com",
    route: "/v1/userProfiles/{studentId}/guardianInvitations",
    validator: validate_ClassroomUserProfilesGuardianInvitationsList_589998,
    base: "/", url: url_ClassroomUserProfilesGuardianInvitationsList_589999,
    schemes: {Scheme.Https})
type
  Call_ClassroomUserProfilesGuardianInvitationsGet_590041 = ref object of OpenApiRestCall_588450
proc url_ClassroomUserProfilesGuardianInvitationsGet_590043(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "studentId" in path, "`studentId` is a required path parameter"
  assert "invitationId" in path, "`invitationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/userProfiles/"),
               (kind: VariableSegment, value: "studentId"),
               (kind: ConstantSegment, value: "/guardianInvitations/"),
               (kind: VariableSegment, value: "invitationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomUserProfilesGuardianInvitationsGet_590042(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a specific guardian invitation.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to view
  ##   guardian invitations for the student identified by the `student_id`, if
  ##   guardians are not enabled for the domain in question, or for other
  ##   access errors.
  ## * `INVALID_ARGUMENT` if a `student_id` is specified, but its format cannot
  ##   be recognized (it is not an email address, nor a `student_id` from the
  ##   API, nor the literal string `me`).
  ## * `NOT_FOUND` if Classroom cannot find any record of the given student or
  ##   `invitation_id`. May also be returned if the student exists, but the
  ##   requesting user does not have access to see that student.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   studentId: JString (required)
  ##            : The ID of the student whose guardian invitation is being requested.
  ##   invitationId: JString (required)
  ##               : The `id` field of the `GuardianInvitation` being requested.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `studentId` field"
  var valid_590044 = path.getOrDefault("studentId")
  valid_590044 = validateParameter(valid_590044, JString, required = true,
                                 default = nil)
  if valid_590044 != nil:
    section.add "studentId", valid_590044
  var valid_590045 = path.getOrDefault("invitationId")
  valid_590045 = validateParameter(valid_590045, JString, required = true,
                                 default = nil)
  if valid_590045 != nil:
    section.add "invitationId", valid_590045
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
  var valid_590046 = query.getOrDefault("upload_protocol")
  valid_590046 = validateParameter(valid_590046, JString, required = false,
                                 default = nil)
  if valid_590046 != nil:
    section.add "upload_protocol", valid_590046
  var valid_590047 = query.getOrDefault("fields")
  valid_590047 = validateParameter(valid_590047, JString, required = false,
                                 default = nil)
  if valid_590047 != nil:
    section.add "fields", valid_590047
  var valid_590048 = query.getOrDefault("quotaUser")
  valid_590048 = validateParameter(valid_590048, JString, required = false,
                                 default = nil)
  if valid_590048 != nil:
    section.add "quotaUser", valid_590048
  var valid_590049 = query.getOrDefault("alt")
  valid_590049 = validateParameter(valid_590049, JString, required = false,
                                 default = newJString("json"))
  if valid_590049 != nil:
    section.add "alt", valid_590049
  var valid_590050 = query.getOrDefault("oauth_token")
  valid_590050 = validateParameter(valid_590050, JString, required = false,
                                 default = nil)
  if valid_590050 != nil:
    section.add "oauth_token", valid_590050
  var valid_590051 = query.getOrDefault("callback")
  valid_590051 = validateParameter(valid_590051, JString, required = false,
                                 default = nil)
  if valid_590051 != nil:
    section.add "callback", valid_590051
  var valid_590052 = query.getOrDefault("access_token")
  valid_590052 = validateParameter(valid_590052, JString, required = false,
                                 default = nil)
  if valid_590052 != nil:
    section.add "access_token", valid_590052
  var valid_590053 = query.getOrDefault("uploadType")
  valid_590053 = validateParameter(valid_590053, JString, required = false,
                                 default = nil)
  if valid_590053 != nil:
    section.add "uploadType", valid_590053
  var valid_590054 = query.getOrDefault("key")
  valid_590054 = validateParameter(valid_590054, JString, required = false,
                                 default = nil)
  if valid_590054 != nil:
    section.add "key", valid_590054
  var valid_590055 = query.getOrDefault("$.xgafv")
  valid_590055 = validateParameter(valid_590055, JString, required = false,
                                 default = newJString("1"))
  if valid_590055 != nil:
    section.add "$.xgafv", valid_590055
  var valid_590056 = query.getOrDefault("prettyPrint")
  valid_590056 = validateParameter(valid_590056, JBool, required = false,
                                 default = newJBool(true))
  if valid_590056 != nil:
    section.add "prettyPrint", valid_590056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590057: Call_ClassroomUserProfilesGuardianInvitationsGet_590041;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a specific guardian invitation.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to view
  ##   guardian invitations for the student identified by the `student_id`, if
  ##   guardians are not enabled for the domain in question, or for other
  ##   access errors.
  ## * `INVALID_ARGUMENT` if a `student_id` is specified, but its format cannot
  ##   be recognized (it is not an email address, nor a `student_id` from the
  ##   API, nor the literal string `me`).
  ## * `NOT_FOUND` if Classroom cannot find any record of the given student or
  ##   `invitation_id`. May also be returned if the student exists, but the
  ##   requesting user does not have access to see that student.
  ## 
  let valid = call_590057.validator(path, query, header, formData, body)
  let scheme = call_590057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590057.url(scheme.get, call_590057.host, call_590057.base,
                         call_590057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590057, url, valid)

proc call*(call_590058: Call_ClassroomUserProfilesGuardianInvitationsGet_590041;
          studentId: string; invitationId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## classroomUserProfilesGuardianInvitationsGet
  ## Returns a specific guardian invitation.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to view
  ##   guardian invitations for the student identified by the `student_id`, if
  ##   guardians are not enabled for the domain in question, or for other
  ##   access errors.
  ## * `INVALID_ARGUMENT` if a `student_id` is specified, but its format cannot
  ##   be recognized (it is not an email address, nor a `student_id` from the
  ##   API, nor the literal string `me`).
  ## * `NOT_FOUND` if Classroom cannot find any record of the given student or
  ##   `invitation_id`. May also be returned if the student exists, but the
  ##   requesting user does not have access to see that student.
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
  ##   studentId: string (required)
  ##            : The ID of the student whose guardian invitation is being requested.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   invitationId: string (required)
  ##               : The `id` field of the `GuardianInvitation` being requested.
  var path_590059 = newJObject()
  var query_590060 = newJObject()
  add(query_590060, "upload_protocol", newJString(uploadProtocol))
  add(query_590060, "fields", newJString(fields))
  add(query_590060, "quotaUser", newJString(quotaUser))
  add(query_590060, "alt", newJString(alt))
  add(query_590060, "oauth_token", newJString(oauthToken))
  add(query_590060, "callback", newJString(callback))
  add(query_590060, "access_token", newJString(accessToken))
  add(query_590060, "uploadType", newJString(uploadType))
  add(path_590059, "studentId", newJString(studentId))
  add(query_590060, "key", newJString(key))
  add(query_590060, "$.xgafv", newJString(Xgafv))
  add(query_590060, "prettyPrint", newJBool(prettyPrint))
  add(path_590059, "invitationId", newJString(invitationId))
  result = call_590058.call(path_590059, query_590060, nil, nil, nil)

var classroomUserProfilesGuardianInvitationsGet* = Call_ClassroomUserProfilesGuardianInvitationsGet_590041(
    name: "classroomUserProfilesGuardianInvitationsGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com",
    route: "/v1/userProfiles/{studentId}/guardianInvitations/{invitationId}",
    validator: validate_ClassroomUserProfilesGuardianInvitationsGet_590042,
    base: "/", url: url_ClassroomUserProfilesGuardianInvitationsGet_590043,
    schemes: {Scheme.Https})
type
  Call_ClassroomUserProfilesGuardianInvitationsPatch_590061 = ref object of OpenApiRestCall_588450
proc url_ClassroomUserProfilesGuardianInvitationsPatch_590063(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "studentId" in path, "`studentId` is a required path parameter"
  assert "invitationId" in path, "`invitationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/userProfiles/"),
               (kind: VariableSegment, value: "studentId"),
               (kind: ConstantSegment, value: "/guardianInvitations/"),
               (kind: VariableSegment, value: "invitationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomUserProfilesGuardianInvitationsPatch_590062(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Modifies a guardian invitation.
  ## 
  ## Currently, the only valid modification is to change the `state` from
  ## `PENDING` to `COMPLETE`. This has the effect of withdrawing the invitation.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the current user does not have permission to
  ##   manage guardians, if guardians are not enabled for the domain in question
  ##   or for other access errors.
  ## * `FAILED_PRECONDITION` if the guardian link is not in the `PENDING` state.
  ## * `INVALID_ARGUMENT` if the format of the student ID provided
  ##   cannot be recognized (it is not an email address, nor a `user_id` from
  ##   this API), or if the passed `GuardianInvitation` has a `state` other than
  ##   `COMPLETE`, or if it modifies fields other than `state`.
  ## * `NOT_FOUND` if the student ID provided is a valid student ID, but
  ##   Classroom has no record of that student, or if the `id` field does not
  ##   refer to a guardian invitation known to Classroom.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   studentId: JString (required)
  ##            : The ID of the student whose guardian invitation is to be modified.
  ##   invitationId: JString (required)
  ##               : The `id` field of the `GuardianInvitation` to be modified.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `studentId` field"
  var valid_590064 = path.getOrDefault("studentId")
  valid_590064 = validateParameter(valid_590064, JString, required = true,
                                 default = nil)
  if valid_590064 != nil:
    section.add "studentId", valid_590064
  var valid_590065 = path.getOrDefault("invitationId")
  valid_590065 = validateParameter(valid_590065, JString, required = true,
                                 default = nil)
  if valid_590065 != nil:
    section.add "invitationId", valid_590065
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
  ##   updateMask: JString
  ##             : Mask that identifies which fields on the course to update.
  ## This field is required to do an update. The update will fail if invalid
  ## fields are specified. The following fields are valid:
  ## 
  ## * `state`
  ## 
  ## When set in a query parameter, this field should be specified as
  ## 
  ## `updateMask=<field1>,<field2>,...`
  section = newJObject()
  var valid_590066 = query.getOrDefault("upload_protocol")
  valid_590066 = validateParameter(valid_590066, JString, required = false,
                                 default = nil)
  if valid_590066 != nil:
    section.add "upload_protocol", valid_590066
  var valid_590067 = query.getOrDefault("fields")
  valid_590067 = validateParameter(valid_590067, JString, required = false,
                                 default = nil)
  if valid_590067 != nil:
    section.add "fields", valid_590067
  var valid_590068 = query.getOrDefault("quotaUser")
  valid_590068 = validateParameter(valid_590068, JString, required = false,
                                 default = nil)
  if valid_590068 != nil:
    section.add "quotaUser", valid_590068
  var valid_590069 = query.getOrDefault("alt")
  valid_590069 = validateParameter(valid_590069, JString, required = false,
                                 default = newJString("json"))
  if valid_590069 != nil:
    section.add "alt", valid_590069
  var valid_590070 = query.getOrDefault("oauth_token")
  valid_590070 = validateParameter(valid_590070, JString, required = false,
                                 default = nil)
  if valid_590070 != nil:
    section.add "oauth_token", valid_590070
  var valid_590071 = query.getOrDefault("callback")
  valid_590071 = validateParameter(valid_590071, JString, required = false,
                                 default = nil)
  if valid_590071 != nil:
    section.add "callback", valid_590071
  var valid_590072 = query.getOrDefault("access_token")
  valid_590072 = validateParameter(valid_590072, JString, required = false,
                                 default = nil)
  if valid_590072 != nil:
    section.add "access_token", valid_590072
  var valid_590073 = query.getOrDefault("uploadType")
  valid_590073 = validateParameter(valid_590073, JString, required = false,
                                 default = nil)
  if valid_590073 != nil:
    section.add "uploadType", valid_590073
  var valid_590074 = query.getOrDefault("key")
  valid_590074 = validateParameter(valid_590074, JString, required = false,
                                 default = nil)
  if valid_590074 != nil:
    section.add "key", valid_590074
  var valid_590075 = query.getOrDefault("$.xgafv")
  valid_590075 = validateParameter(valid_590075, JString, required = false,
                                 default = newJString("1"))
  if valid_590075 != nil:
    section.add "$.xgafv", valid_590075
  var valid_590076 = query.getOrDefault("prettyPrint")
  valid_590076 = validateParameter(valid_590076, JBool, required = false,
                                 default = newJBool(true))
  if valid_590076 != nil:
    section.add "prettyPrint", valid_590076
  var valid_590077 = query.getOrDefault("updateMask")
  valid_590077 = validateParameter(valid_590077, JString, required = false,
                                 default = nil)
  if valid_590077 != nil:
    section.add "updateMask", valid_590077
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

proc call*(call_590079: Call_ClassroomUserProfilesGuardianInvitationsPatch_590061;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modifies a guardian invitation.
  ## 
  ## Currently, the only valid modification is to change the `state` from
  ## `PENDING` to `COMPLETE`. This has the effect of withdrawing the invitation.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the current user does not have permission to
  ##   manage guardians, if guardians are not enabled for the domain in question
  ##   or for other access errors.
  ## * `FAILED_PRECONDITION` if the guardian link is not in the `PENDING` state.
  ## * `INVALID_ARGUMENT` if the format of the student ID provided
  ##   cannot be recognized (it is not an email address, nor a `user_id` from
  ##   this API), or if the passed `GuardianInvitation` has a `state` other than
  ##   `COMPLETE`, or if it modifies fields other than `state`.
  ## * `NOT_FOUND` if the student ID provided is a valid student ID, but
  ##   Classroom has no record of that student, or if the `id` field does not
  ##   refer to a guardian invitation known to Classroom.
  ## 
  let valid = call_590079.validator(path, query, header, formData, body)
  let scheme = call_590079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590079.url(scheme.get, call_590079.host, call_590079.base,
                         call_590079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590079, url, valid)

proc call*(call_590080: Call_ClassroomUserProfilesGuardianInvitationsPatch_590061;
          studentId: string; invitationId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## classroomUserProfilesGuardianInvitationsPatch
  ## Modifies a guardian invitation.
  ## 
  ## Currently, the only valid modification is to change the `state` from
  ## `PENDING` to `COMPLETE`. This has the effect of withdrawing the invitation.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the current user does not have permission to
  ##   manage guardians, if guardians are not enabled for the domain in question
  ##   or for other access errors.
  ## * `FAILED_PRECONDITION` if the guardian link is not in the `PENDING` state.
  ## * `INVALID_ARGUMENT` if the format of the student ID provided
  ##   cannot be recognized (it is not an email address, nor a `user_id` from
  ##   this API), or if the passed `GuardianInvitation` has a `state` other than
  ##   `COMPLETE`, or if it modifies fields other than `state`.
  ## * `NOT_FOUND` if the student ID provided is a valid student ID, but
  ##   Classroom has no record of that student, or if the `id` field does not
  ##   refer to a guardian invitation known to Classroom.
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
  ##   studentId: string (required)
  ##            : The ID of the student whose guardian invitation is to be modified.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   invitationId: string (required)
  ##               : The `id` field of the `GuardianInvitation` to be modified.
  ##   updateMask: string
  ##             : Mask that identifies which fields on the course to update.
  ## This field is required to do an update. The update will fail if invalid
  ## fields are specified. The following fields are valid:
  ## 
  ## * `state`
  ## 
  ## When set in a query parameter, this field should be specified as
  ## 
  ## `updateMask=<field1>,<field2>,...`
  var path_590081 = newJObject()
  var query_590082 = newJObject()
  var body_590083 = newJObject()
  add(query_590082, "upload_protocol", newJString(uploadProtocol))
  add(query_590082, "fields", newJString(fields))
  add(query_590082, "quotaUser", newJString(quotaUser))
  add(query_590082, "alt", newJString(alt))
  add(query_590082, "oauth_token", newJString(oauthToken))
  add(query_590082, "callback", newJString(callback))
  add(query_590082, "access_token", newJString(accessToken))
  add(query_590082, "uploadType", newJString(uploadType))
  add(path_590081, "studentId", newJString(studentId))
  add(query_590082, "key", newJString(key))
  add(query_590082, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_590083 = body
  add(query_590082, "prettyPrint", newJBool(prettyPrint))
  add(path_590081, "invitationId", newJString(invitationId))
  add(query_590082, "updateMask", newJString(updateMask))
  result = call_590080.call(path_590081, query_590082, nil, nil, body_590083)

var classroomUserProfilesGuardianInvitationsPatch* = Call_ClassroomUserProfilesGuardianInvitationsPatch_590061(
    name: "classroomUserProfilesGuardianInvitationsPatch",
    meth: HttpMethod.HttpPatch, host: "classroom.googleapis.com",
    route: "/v1/userProfiles/{studentId}/guardianInvitations/{invitationId}",
    validator: validate_ClassroomUserProfilesGuardianInvitationsPatch_590062,
    base: "/", url: url_ClassroomUserProfilesGuardianInvitationsPatch_590063,
    schemes: {Scheme.Https})
type
  Call_ClassroomUserProfilesGuardiansList_590084 = ref object of OpenApiRestCall_588450
proc url_ClassroomUserProfilesGuardiansList_590086(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "studentId" in path, "`studentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/userProfiles/"),
               (kind: VariableSegment, value: "studentId"),
               (kind: ConstantSegment, value: "/guardians")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomUserProfilesGuardiansList_590085(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of guardians that the requesting user is permitted to
  ## view, restricted to those that match the request.
  ## 
  ## To list guardians for any student that the requesting user may view
  ## guardians for, use the literal character `-` for the student ID.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if a `student_id` is specified, and the requesting
  ##   user is not permitted to view guardian information for that student, if
  ##   `"-"` is specified as the `student_id` and the user is not a domain
  ##   administrator, if guardians are not enabled for the domain in question,
  ##   if the `invited_email_address` filter is set by a user who is not a
  ##   domain administrator, or for other access errors.
  ## * `INVALID_ARGUMENT` if a `student_id` is specified, but its format cannot
  ##   be recognized (it is not an email address, nor a `student_id` from the
  ##   API, nor the literal string `me`). May also be returned if an invalid
  ##   `page_token` is provided.
  ## * `NOT_FOUND` if a `student_id` is specified, and its format can be
  ##   recognized, but Classroom has no record of that student.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   studentId: JString (required)
  ##            : Filter results by the student who the guardian is linked to.
  ## The identifier can be one of the following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  ## * the string literal `"-"`, indicating that results should be returned for
  ##   all students that the requesting user has access to view.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `studentId` field"
  var valid_590087 = path.getOrDefault("studentId")
  valid_590087 = validateParameter(valid_590087, JString, required = true,
                                 default = nil)
  if valid_590087 != nil:
    section.add "studentId", valid_590087
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : nextPageToken
  ## value returned from a previous
  ## list call,
  ## indicating that the subsequent page of results should be returned.
  ## 
  ## The list request
  ## must be otherwise identical to the one that resulted in this token.
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
  ##   invitedEmailAddress: JString
  ##                      : Filter results by the email address that the original invitation was sent
  ## to, resulting in this guardian link.
  ## This filter can only be used by domain administrators.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Maximum number of items to return. Zero or unspecified indicates that the
  ## server may assign a maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590088 = query.getOrDefault("upload_protocol")
  valid_590088 = validateParameter(valid_590088, JString, required = false,
                                 default = nil)
  if valid_590088 != nil:
    section.add "upload_protocol", valid_590088
  var valid_590089 = query.getOrDefault("fields")
  valid_590089 = validateParameter(valid_590089, JString, required = false,
                                 default = nil)
  if valid_590089 != nil:
    section.add "fields", valid_590089
  var valid_590090 = query.getOrDefault("pageToken")
  valid_590090 = validateParameter(valid_590090, JString, required = false,
                                 default = nil)
  if valid_590090 != nil:
    section.add "pageToken", valid_590090
  var valid_590091 = query.getOrDefault("quotaUser")
  valid_590091 = validateParameter(valid_590091, JString, required = false,
                                 default = nil)
  if valid_590091 != nil:
    section.add "quotaUser", valid_590091
  var valid_590092 = query.getOrDefault("alt")
  valid_590092 = validateParameter(valid_590092, JString, required = false,
                                 default = newJString("json"))
  if valid_590092 != nil:
    section.add "alt", valid_590092
  var valid_590093 = query.getOrDefault("oauth_token")
  valid_590093 = validateParameter(valid_590093, JString, required = false,
                                 default = nil)
  if valid_590093 != nil:
    section.add "oauth_token", valid_590093
  var valid_590094 = query.getOrDefault("callback")
  valid_590094 = validateParameter(valid_590094, JString, required = false,
                                 default = nil)
  if valid_590094 != nil:
    section.add "callback", valid_590094
  var valid_590095 = query.getOrDefault("access_token")
  valid_590095 = validateParameter(valid_590095, JString, required = false,
                                 default = nil)
  if valid_590095 != nil:
    section.add "access_token", valid_590095
  var valid_590096 = query.getOrDefault("uploadType")
  valid_590096 = validateParameter(valid_590096, JString, required = false,
                                 default = nil)
  if valid_590096 != nil:
    section.add "uploadType", valid_590096
  var valid_590097 = query.getOrDefault("key")
  valid_590097 = validateParameter(valid_590097, JString, required = false,
                                 default = nil)
  if valid_590097 != nil:
    section.add "key", valid_590097
  var valid_590098 = query.getOrDefault("invitedEmailAddress")
  valid_590098 = validateParameter(valid_590098, JString, required = false,
                                 default = nil)
  if valid_590098 != nil:
    section.add "invitedEmailAddress", valid_590098
  var valid_590099 = query.getOrDefault("$.xgafv")
  valid_590099 = validateParameter(valid_590099, JString, required = false,
                                 default = newJString("1"))
  if valid_590099 != nil:
    section.add "$.xgafv", valid_590099
  var valid_590100 = query.getOrDefault("pageSize")
  valid_590100 = validateParameter(valid_590100, JInt, required = false, default = nil)
  if valid_590100 != nil:
    section.add "pageSize", valid_590100
  var valid_590101 = query.getOrDefault("prettyPrint")
  valid_590101 = validateParameter(valid_590101, JBool, required = false,
                                 default = newJBool(true))
  if valid_590101 != nil:
    section.add "prettyPrint", valid_590101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590102: Call_ClassroomUserProfilesGuardiansList_590084;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of guardians that the requesting user is permitted to
  ## view, restricted to those that match the request.
  ## 
  ## To list guardians for any student that the requesting user may view
  ## guardians for, use the literal character `-` for the student ID.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if a `student_id` is specified, and the requesting
  ##   user is not permitted to view guardian information for that student, if
  ##   `"-"` is specified as the `student_id` and the user is not a domain
  ##   administrator, if guardians are not enabled for the domain in question,
  ##   if the `invited_email_address` filter is set by a user who is not a
  ##   domain administrator, or for other access errors.
  ## * `INVALID_ARGUMENT` if a `student_id` is specified, but its format cannot
  ##   be recognized (it is not an email address, nor a `student_id` from the
  ##   API, nor the literal string `me`). May also be returned if an invalid
  ##   `page_token` is provided.
  ## * `NOT_FOUND` if a `student_id` is specified, and its format can be
  ##   recognized, but Classroom has no record of that student.
  ## 
  let valid = call_590102.validator(path, query, header, formData, body)
  let scheme = call_590102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590102.url(scheme.get, call_590102.host, call_590102.base,
                         call_590102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590102, url, valid)

proc call*(call_590103: Call_ClassroomUserProfilesGuardiansList_590084;
          studentId: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; invitedEmailAddress: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## classroomUserProfilesGuardiansList
  ## Returns a list of guardians that the requesting user is permitted to
  ## view, restricted to those that match the request.
  ## 
  ## To list guardians for any student that the requesting user may view
  ## guardians for, use the literal character `-` for the student ID.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if a `student_id` is specified, and the requesting
  ##   user is not permitted to view guardian information for that student, if
  ##   `"-"` is specified as the `student_id` and the user is not a domain
  ##   administrator, if guardians are not enabled for the domain in question,
  ##   if the `invited_email_address` filter is set by a user who is not a
  ##   domain administrator, or for other access errors.
  ## * `INVALID_ARGUMENT` if a `student_id` is specified, but its format cannot
  ##   be recognized (it is not an email address, nor a `student_id` from the
  ##   API, nor the literal string `me`). May also be returned if an invalid
  ##   `page_token` is provided.
  ## * `NOT_FOUND` if a `student_id` is specified, and its format can be
  ##   recognized, but Classroom has no record of that student.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : nextPageToken
  ## value returned from a previous
  ## list call,
  ## indicating that the subsequent page of results should be returned.
  ## 
  ## The list request
  ## must be otherwise identical to the one that resulted in this token.
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
  ##   studentId: string (required)
  ##            : Filter results by the student who the guardian is linked to.
  ## The identifier can be one of the following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  ## * the string literal `"-"`, indicating that results should be returned for
  ##   all students that the requesting user has access to view.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   invitedEmailAddress: string
  ##                      : Filter results by the email address that the original invitation was sent
  ## to, resulting in this guardian link.
  ## This filter can only be used by domain administrators.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of items to return. Zero or unspecified indicates that the
  ## server may assign a maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590104 = newJObject()
  var query_590105 = newJObject()
  add(query_590105, "upload_protocol", newJString(uploadProtocol))
  add(query_590105, "fields", newJString(fields))
  add(query_590105, "pageToken", newJString(pageToken))
  add(query_590105, "quotaUser", newJString(quotaUser))
  add(query_590105, "alt", newJString(alt))
  add(query_590105, "oauth_token", newJString(oauthToken))
  add(query_590105, "callback", newJString(callback))
  add(query_590105, "access_token", newJString(accessToken))
  add(query_590105, "uploadType", newJString(uploadType))
  add(path_590104, "studentId", newJString(studentId))
  add(query_590105, "key", newJString(key))
  add(query_590105, "invitedEmailAddress", newJString(invitedEmailAddress))
  add(query_590105, "$.xgafv", newJString(Xgafv))
  add(query_590105, "pageSize", newJInt(pageSize))
  add(query_590105, "prettyPrint", newJBool(prettyPrint))
  result = call_590103.call(path_590104, query_590105, nil, nil, nil)

var classroomUserProfilesGuardiansList* = Call_ClassroomUserProfilesGuardiansList_590084(
    name: "classroomUserProfilesGuardiansList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com",
    route: "/v1/userProfiles/{studentId}/guardians",
    validator: validate_ClassroomUserProfilesGuardiansList_590085, base: "/",
    url: url_ClassroomUserProfilesGuardiansList_590086, schemes: {Scheme.Https})
type
  Call_ClassroomUserProfilesGuardiansGet_590106 = ref object of OpenApiRestCall_588450
proc url_ClassroomUserProfilesGuardiansGet_590108(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "studentId" in path, "`studentId` is a required path parameter"
  assert "guardianId" in path, "`guardianId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/userProfiles/"),
               (kind: VariableSegment, value: "studentId"),
               (kind: ConstantSegment, value: "/guardians/"),
               (kind: VariableSegment, value: "guardianId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomUserProfilesGuardiansGet_590107(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a specific guardian.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if no user that matches the provided `student_id`
  ##   is visible to the requesting user, if the requesting user is not
  ##   permitted to view guardian information for the student identified by the
  ##   `student_id`, if guardians are not enabled for the domain in question,
  ##   or for other access errors.
  ## * `INVALID_ARGUMENT` if a `student_id` is specified, but its format cannot
  ##   be recognized (it is not an email address, nor a `student_id` from the
  ##   API, nor the literal string `me`).
  ## * `NOT_FOUND` if the requesting user is permitted to view guardians for
  ##   the requested `student_id`, but no `Guardian` record exists for that
  ##   student that matches the provided `guardian_id`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   guardianId: JString (required)
  ##             : The `id` field from a `Guardian`.
  ##   studentId: JString (required)
  ##            : The student whose guardian is being requested. One of the following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `guardianId` field"
  var valid_590109 = path.getOrDefault("guardianId")
  valid_590109 = validateParameter(valid_590109, JString, required = true,
                                 default = nil)
  if valid_590109 != nil:
    section.add "guardianId", valid_590109
  var valid_590110 = path.getOrDefault("studentId")
  valid_590110 = validateParameter(valid_590110, JString, required = true,
                                 default = nil)
  if valid_590110 != nil:
    section.add "studentId", valid_590110
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
  var valid_590111 = query.getOrDefault("upload_protocol")
  valid_590111 = validateParameter(valid_590111, JString, required = false,
                                 default = nil)
  if valid_590111 != nil:
    section.add "upload_protocol", valid_590111
  var valid_590112 = query.getOrDefault("fields")
  valid_590112 = validateParameter(valid_590112, JString, required = false,
                                 default = nil)
  if valid_590112 != nil:
    section.add "fields", valid_590112
  var valid_590113 = query.getOrDefault("quotaUser")
  valid_590113 = validateParameter(valid_590113, JString, required = false,
                                 default = nil)
  if valid_590113 != nil:
    section.add "quotaUser", valid_590113
  var valid_590114 = query.getOrDefault("alt")
  valid_590114 = validateParameter(valid_590114, JString, required = false,
                                 default = newJString("json"))
  if valid_590114 != nil:
    section.add "alt", valid_590114
  var valid_590115 = query.getOrDefault("oauth_token")
  valid_590115 = validateParameter(valid_590115, JString, required = false,
                                 default = nil)
  if valid_590115 != nil:
    section.add "oauth_token", valid_590115
  var valid_590116 = query.getOrDefault("callback")
  valid_590116 = validateParameter(valid_590116, JString, required = false,
                                 default = nil)
  if valid_590116 != nil:
    section.add "callback", valid_590116
  var valid_590117 = query.getOrDefault("access_token")
  valid_590117 = validateParameter(valid_590117, JString, required = false,
                                 default = nil)
  if valid_590117 != nil:
    section.add "access_token", valid_590117
  var valid_590118 = query.getOrDefault("uploadType")
  valid_590118 = validateParameter(valid_590118, JString, required = false,
                                 default = nil)
  if valid_590118 != nil:
    section.add "uploadType", valid_590118
  var valid_590119 = query.getOrDefault("key")
  valid_590119 = validateParameter(valid_590119, JString, required = false,
                                 default = nil)
  if valid_590119 != nil:
    section.add "key", valid_590119
  var valid_590120 = query.getOrDefault("$.xgafv")
  valid_590120 = validateParameter(valid_590120, JString, required = false,
                                 default = newJString("1"))
  if valid_590120 != nil:
    section.add "$.xgafv", valid_590120
  var valid_590121 = query.getOrDefault("prettyPrint")
  valid_590121 = validateParameter(valid_590121, JBool, required = false,
                                 default = newJBool(true))
  if valid_590121 != nil:
    section.add "prettyPrint", valid_590121
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590122: Call_ClassroomUserProfilesGuardiansGet_590106;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a specific guardian.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if no user that matches the provided `student_id`
  ##   is visible to the requesting user, if the requesting user is not
  ##   permitted to view guardian information for the student identified by the
  ##   `student_id`, if guardians are not enabled for the domain in question,
  ##   or for other access errors.
  ## * `INVALID_ARGUMENT` if a `student_id` is specified, but its format cannot
  ##   be recognized (it is not an email address, nor a `student_id` from the
  ##   API, nor the literal string `me`).
  ## * `NOT_FOUND` if the requesting user is permitted to view guardians for
  ##   the requested `student_id`, but no `Guardian` record exists for that
  ##   student that matches the provided `guardian_id`.
  ## 
  let valid = call_590122.validator(path, query, header, formData, body)
  let scheme = call_590122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590122.url(scheme.get, call_590122.host, call_590122.base,
                         call_590122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590122, url, valid)

proc call*(call_590123: Call_ClassroomUserProfilesGuardiansGet_590106;
          guardianId: string; studentId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## classroomUserProfilesGuardiansGet
  ## Returns a specific guardian.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if no user that matches the provided `student_id`
  ##   is visible to the requesting user, if the requesting user is not
  ##   permitted to view guardian information for the student identified by the
  ##   `student_id`, if guardians are not enabled for the domain in question,
  ##   or for other access errors.
  ## * `INVALID_ARGUMENT` if a `student_id` is specified, but its format cannot
  ##   be recognized (it is not an email address, nor a `student_id` from the
  ##   API, nor the literal string `me`).
  ## * `NOT_FOUND` if the requesting user is permitted to view guardians for
  ##   the requested `student_id`, but no `Guardian` record exists for that
  ##   student that matches the provided `guardian_id`.
  ##   guardianId: string (required)
  ##             : The `id` field from a `Guardian`.
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
  ##   studentId: string (required)
  ##            : The student whose guardian is being requested. One of the following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590124 = newJObject()
  var query_590125 = newJObject()
  add(path_590124, "guardianId", newJString(guardianId))
  add(query_590125, "upload_protocol", newJString(uploadProtocol))
  add(query_590125, "fields", newJString(fields))
  add(query_590125, "quotaUser", newJString(quotaUser))
  add(query_590125, "alt", newJString(alt))
  add(query_590125, "oauth_token", newJString(oauthToken))
  add(query_590125, "callback", newJString(callback))
  add(query_590125, "access_token", newJString(accessToken))
  add(query_590125, "uploadType", newJString(uploadType))
  add(path_590124, "studentId", newJString(studentId))
  add(query_590125, "key", newJString(key))
  add(query_590125, "$.xgafv", newJString(Xgafv))
  add(query_590125, "prettyPrint", newJBool(prettyPrint))
  result = call_590123.call(path_590124, query_590125, nil, nil, nil)

var classroomUserProfilesGuardiansGet* = Call_ClassroomUserProfilesGuardiansGet_590106(
    name: "classroomUserProfilesGuardiansGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com",
    route: "/v1/userProfiles/{studentId}/guardians/{guardianId}",
    validator: validate_ClassroomUserProfilesGuardiansGet_590107, base: "/",
    url: url_ClassroomUserProfilesGuardiansGet_590108, schemes: {Scheme.Https})
type
  Call_ClassroomUserProfilesGuardiansDelete_590126 = ref object of OpenApiRestCall_588450
proc url_ClassroomUserProfilesGuardiansDelete_590128(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "studentId" in path, "`studentId` is a required path parameter"
  assert "guardianId" in path, "`guardianId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/userProfiles/"),
               (kind: VariableSegment, value: "studentId"),
               (kind: ConstantSegment, value: "/guardians/"),
               (kind: VariableSegment, value: "guardianId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomUserProfilesGuardiansDelete_590127(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a guardian.
  ## 
  ## The guardian will no longer receive guardian notifications and the guardian
  ## will no longer be accessible via the API.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if no user that matches the provided `student_id`
  ##   is visible to the requesting user, if the requesting user is not
  ##   permitted to manage guardians for the student identified by the
  ##   `student_id`, if guardians are not enabled for the domain in question,
  ##   or for other access errors.
  ## * `INVALID_ARGUMENT` if a `student_id` is specified, but its format cannot
  ##   be recognized (it is not an email address, nor a `student_id` from the
  ##   API).
  ## * `NOT_FOUND` if the requesting user is permitted to modify guardians for
  ##   the requested `student_id`, but no `Guardian` record exists for that
  ##   student with the provided `guardian_id`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   guardianId: JString (required)
  ##             : The `id` field from a `Guardian`.
  ##   studentId: JString (required)
  ##            : The student whose guardian is to be deleted. One of the following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `guardianId` field"
  var valid_590129 = path.getOrDefault("guardianId")
  valid_590129 = validateParameter(valid_590129, JString, required = true,
                                 default = nil)
  if valid_590129 != nil:
    section.add "guardianId", valid_590129
  var valid_590130 = path.getOrDefault("studentId")
  valid_590130 = validateParameter(valid_590130, JString, required = true,
                                 default = nil)
  if valid_590130 != nil:
    section.add "studentId", valid_590130
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
  var valid_590131 = query.getOrDefault("upload_protocol")
  valid_590131 = validateParameter(valid_590131, JString, required = false,
                                 default = nil)
  if valid_590131 != nil:
    section.add "upload_protocol", valid_590131
  var valid_590132 = query.getOrDefault("fields")
  valid_590132 = validateParameter(valid_590132, JString, required = false,
                                 default = nil)
  if valid_590132 != nil:
    section.add "fields", valid_590132
  var valid_590133 = query.getOrDefault("quotaUser")
  valid_590133 = validateParameter(valid_590133, JString, required = false,
                                 default = nil)
  if valid_590133 != nil:
    section.add "quotaUser", valid_590133
  var valid_590134 = query.getOrDefault("alt")
  valid_590134 = validateParameter(valid_590134, JString, required = false,
                                 default = newJString("json"))
  if valid_590134 != nil:
    section.add "alt", valid_590134
  var valid_590135 = query.getOrDefault("oauth_token")
  valid_590135 = validateParameter(valid_590135, JString, required = false,
                                 default = nil)
  if valid_590135 != nil:
    section.add "oauth_token", valid_590135
  var valid_590136 = query.getOrDefault("callback")
  valid_590136 = validateParameter(valid_590136, JString, required = false,
                                 default = nil)
  if valid_590136 != nil:
    section.add "callback", valid_590136
  var valid_590137 = query.getOrDefault("access_token")
  valid_590137 = validateParameter(valid_590137, JString, required = false,
                                 default = nil)
  if valid_590137 != nil:
    section.add "access_token", valid_590137
  var valid_590138 = query.getOrDefault("uploadType")
  valid_590138 = validateParameter(valid_590138, JString, required = false,
                                 default = nil)
  if valid_590138 != nil:
    section.add "uploadType", valid_590138
  var valid_590139 = query.getOrDefault("key")
  valid_590139 = validateParameter(valid_590139, JString, required = false,
                                 default = nil)
  if valid_590139 != nil:
    section.add "key", valid_590139
  var valid_590140 = query.getOrDefault("$.xgafv")
  valid_590140 = validateParameter(valid_590140, JString, required = false,
                                 default = newJString("1"))
  if valid_590140 != nil:
    section.add "$.xgafv", valid_590140
  var valid_590141 = query.getOrDefault("prettyPrint")
  valid_590141 = validateParameter(valid_590141, JBool, required = false,
                                 default = newJBool(true))
  if valid_590141 != nil:
    section.add "prettyPrint", valid_590141
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590142: Call_ClassroomUserProfilesGuardiansDelete_590126;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a guardian.
  ## 
  ## The guardian will no longer receive guardian notifications and the guardian
  ## will no longer be accessible via the API.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if no user that matches the provided `student_id`
  ##   is visible to the requesting user, if the requesting user is not
  ##   permitted to manage guardians for the student identified by the
  ##   `student_id`, if guardians are not enabled for the domain in question,
  ##   or for other access errors.
  ## * `INVALID_ARGUMENT` if a `student_id` is specified, but its format cannot
  ##   be recognized (it is not an email address, nor a `student_id` from the
  ##   API).
  ## * `NOT_FOUND` if the requesting user is permitted to modify guardians for
  ##   the requested `student_id`, but no `Guardian` record exists for that
  ##   student with the provided `guardian_id`.
  ## 
  let valid = call_590142.validator(path, query, header, formData, body)
  let scheme = call_590142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590142.url(scheme.get, call_590142.host, call_590142.base,
                         call_590142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590142, url, valid)

proc call*(call_590143: Call_ClassroomUserProfilesGuardiansDelete_590126;
          guardianId: string; studentId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## classroomUserProfilesGuardiansDelete
  ## Deletes a guardian.
  ## 
  ## The guardian will no longer receive guardian notifications and the guardian
  ## will no longer be accessible via the API.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if no user that matches the provided `student_id`
  ##   is visible to the requesting user, if the requesting user is not
  ##   permitted to manage guardians for the student identified by the
  ##   `student_id`, if guardians are not enabled for the domain in question,
  ##   or for other access errors.
  ## * `INVALID_ARGUMENT` if a `student_id` is specified, but its format cannot
  ##   be recognized (it is not an email address, nor a `student_id` from the
  ##   API).
  ## * `NOT_FOUND` if the requesting user is permitted to modify guardians for
  ##   the requested `student_id`, but no `Guardian` record exists for that
  ##   student with the provided `guardian_id`.
  ##   guardianId: string (required)
  ##             : The `id` field from a `Guardian`.
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
  ##   studentId: string (required)
  ##            : The student whose guardian is to be deleted. One of the following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590144 = newJObject()
  var query_590145 = newJObject()
  add(path_590144, "guardianId", newJString(guardianId))
  add(query_590145, "upload_protocol", newJString(uploadProtocol))
  add(query_590145, "fields", newJString(fields))
  add(query_590145, "quotaUser", newJString(quotaUser))
  add(query_590145, "alt", newJString(alt))
  add(query_590145, "oauth_token", newJString(oauthToken))
  add(query_590145, "callback", newJString(callback))
  add(query_590145, "access_token", newJString(accessToken))
  add(query_590145, "uploadType", newJString(uploadType))
  add(path_590144, "studentId", newJString(studentId))
  add(query_590145, "key", newJString(key))
  add(query_590145, "$.xgafv", newJString(Xgafv))
  add(query_590145, "prettyPrint", newJBool(prettyPrint))
  result = call_590143.call(path_590144, query_590145, nil, nil, nil)

var classroomUserProfilesGuardiansDelete* = Call_ClassroomUserProfilesGuardiansDelete_590126(
    name: "classroomUserProfilesGuardiansDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com",
    route: "/v1/userProfiles/{studentId}/guardians/{guardianId}",
    validator: validate_ClassroomUserProfilesGuardiansDelete_590127, base: "/",
    url: url_ClassroomUserProfilesGuardiansDelete_590128, schemes: {Scheme.Https})
type
  Call_ClassroomUserProfilesGet_590146 = ref object of OpenApiRestCall_588450
proc url_ClassroomUserProfilesGet_590148(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/userProfiles/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomUserProfilesGet_590147(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a user profile.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access
  ## this user profile, if no profile exists with the requested ID, or for
  ## access errors.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : Identifier of the profile to return. The identifier can be one of the
  ## following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_590149 = path.getOrDefault("userId")
  valid_590149 = validateParameter(valid_590149, JString, required = true,
                                 default = nil)
  if valid_590149 != nil:
    section.add "userId", valid_590149
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
  var valid_590150 = query.getOrDefault("upload_protocol")
  valid_590150 = validateParameter(valid_590150, JString, required = false,
                                 default = nil)
  if valid_590150 != nil:
    section.add "upload_protocol", valid_590150
  var valid_590151 = query.getOrDefault("fields")
  valid_590151 = validateParameter(valid_590151, JString, required = false,
                                 default = nil)
  if valid_590151 != nil:
    section.add "fields", valid_590151
  var valid_590152 = query.getOrDefault("quotaUser")
  valid_590152 = validateParameter(valid_590152, JString, required = false,
                                 default = nil)
  if valid_590152 != nil:
    section.add "quotaUser", valid_590152
  var valid_590153 = query.getOrDefault("alt")
  valid_590153 = validateParameter(valid_590153, JString, required = false,
                                 default = newJString("json"))
  if valid_590153 != nil:
    section.add "alt", valid_590153
  var valid_590154 = query.getOrDefault("oauth_token")
  valid_590154 = validateParameter(valid_590154, JString, required = false,
                                 default = nil)
  if valid_590154 != nil:
    section.add "oauth_token", valid_590154
  var valid_590155 = query.getOrDefault("callback")
  valid_590155 = validateParameter(valid_590155, JString, required = false,
                                 default = nil)
  if valid_590155 != nil:
    section.add "callback", valid_590155
  var valid_590156 = query.getOrDefault("access_token")
  valid_590156 = validateParameter(valid_590156, JString, required = false,
                                 default = nil)
  if valid_590156 != nil:
    section.add "access_token", valid_590156
  var valid_590157 = query.getOrDefault("uploadType")
  valid_590157 = validateParameter(valid_590157, JString, required = false,
                                 default = nil)
  if valid_590157 != nil:
    section.add "uploadType", valid_590157
  var valid_590158 = query.getOrDefault("key")
  valid_590158 = validateParameter(valid_590158, JString, required = false,
                                 default = nil)
  if valid_590158 != nil:
    section.add "key", valid_590158
  var valid_590159 = query.getOrDefault("$.xgafv")
  valid_590159 = validateParameter(valid_590159, JString, required = false,
                                 default = newJString("1"))
  if valid_590159 != nil:
    section.add "$.xgafv", valid_590159
  var valid_590160 = query.getOrDefault("prettyPrint")
  valid_590160 = validateParameter(valid_590160, JBool, required = false,
                                 default = newJBool(true))
  if valid_590160 != nil:
    section.add "prettyPrint", valid_590160
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590161: Call_ClassroomUserProfilesGet_590146; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a user profile.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access
  ## this user profile, if no profile exists with the requested ID, or for
  ## access errors.
  ## 
  let valid = call_590161.validator(path, query, header, formData, body)
  let scheme = call_590161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590161.url(scheme.get, call_590161.host, call_590161.base,
                         call_590161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590161, url, valid)

proc call*(call_590162: Call_ClassroomUserProfilesGet_590146; userId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## classroomUserProfilesGet
  ## Returns a user profile.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access
  ## this user profile, if no profile exists with the requested ID, or for
  ## access errors.
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
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : Identifier of the profile to return. The identifier can be one of the
  ## following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  var path_590163 = newJObject()
  var query_590164 = newJObject()
  add(query_590164, "upload_protocol", newJString(uploadProtocol))
  add(query_590164, "fields", newJString(fields))
  add(query_590164, "quotaUser", newJString(quotaUser))
  add(query_590164, "alt", newJString(alt))
  add(query_590164, "oauth_token", newJString(oauthToken))
  add(query_590164, "callback", newJString(callback))
  add(query_590164, "access_token", newJString(accessToken))
  add(query_590164, "uploadType", newJString(uploadType))
  add(query_590164, "key", newJString(key))
  add(query_590164, "$.xgafv", newJString(Xgafv))
  add(query_590164, "prettyPrint", newJBool(prettyPrint))
  add(path_590163, "userId", newJString(userId))
  result = call_590162.call(path_590163, query_590164, nil, nil, nil)

var classroomUserProfilesGet* = Call_ClassroomUserProfilesGet_590146(
    name: "classroomUserProfilesGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/userProfiles/{userId}",
    validator: validate_ClassroomUserProfilesGet_590147, base: "/",
    url: url_ClassroomUserProfilesGet_590148, schemes: {Scheme.Https})
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
