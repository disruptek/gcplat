
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

  OpenApiRestCall_578348 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578348](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578348): Option[Scheme] {.used.} =
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
  gcpServiceName = "classroom"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ClassroomCoursesCreate_578896 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesCreate_578898(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ClassroomCoursesCreate_578897(path: JsonNode; query: JsonNode;
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
  var valid_578899 = query.getOrDefault("key")
  valid_578899 = validateParameter(valid_578899, JString, required = false,
                                 default = nil)
  if valid_578899 != nil:
    section.add "key", valid_578899
  var valid_578900 = query.getOrDefault("prettyPrint")
  valid_578900 = validateParameter(valid_578900, JBool, required = false,
                                 default = newJBool(true))
  if valid_578900 != nil:
    section.add "prettyPrint", valid_578900
  var valid_578901 = query.getOrDefault("oauth_token")
  valid_578901 = validateParameter(valid_578901, JString, required = false,
                                 default = nil)
  if valid_578901 != nil:
    section.add "oauth_token", valid_578901
  var valid_578902 = query.getOrDefault("$.xgafv")
  valid_578902 = validateParameter(valid_578902, JString, required = false,
                                 default = newJString("1"))
  if valid_578902 != nil:
    section.add "$.xgafv", valid_578902
  var valid_578903 = query.getOrDefault("alt")
  valid_578903 = validateParameter(valid_578903, JString, required = false,
                                 default = newJString("json"))
  if valid_578903 != nil:
    section.add "alt", valid_578903
  var valid_578904 = query.getOrDefault("uploadType")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "uploadType", valid_578904
  var valid_578905 = query.getOrDefault("quotaUser")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = nil)
  if valid_578905 != nil:
    section.add "quotaUser", valid_578905
  var valid_578906 = query.getOrDefault("callback")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = nil)
  if valid_578906 != nil:
    section.add "callback", valid_578906
  var valid_578907 = query.getOrDefault("fields")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "fields", valid_578907
  var valid_578908 = query.getOrDefault("access_token")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "access_token", valid_578908
  var valid_578909 = query.getOrDefault("upload_protocol")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "upload_protocol", valid_578909
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

proc call*(call_578911: Call_ClassroomCoursesCreate_578896; path: JsonNode;
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
  let valid = call_578911.validator(path, query, header, formData, body)
  let scheme = call_578911.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578911.url(scheme.get, call_578911.host, call_578911.base,
                         call_578911.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578911, url, valid)

proc call*(call_578912: Call_ClassroomCoursesCreate_578896; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578913 = newJObject()
  var body_578914 = newJObject()
  add(query_578913, "key", newJString(key))
  add(query_578913, "prettyPrint", newJBool(prettyPrint))
  add(query_578913, "oauth_token", newJString(oauthToken))
  add(query_578913, "$.xgafv", newJString(Xgafv))
  add(query_578913, "alt", newJString(alt))
  add(query_578913, "uploadType", newJString(uploadType))
  add(query_578913, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578914 = body
  add(query_578913, "callback", newJString(callback))
  add(query_578913, "fields", newJString(fields))
  add(query_578913, "access_token", newJString(accessToken))
  add(query_578913, "upload_protocol", newJString(uploadProtocol))
  result = call_578912.call(nil, query_578913, nil, nil, body_578914)

var classroomCoursesCreate* = Call_ClassroomCoursesCreate_578896(
    name: "classroomCoursesCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/courses",
    validator: validate_ClassroomCoursesCreate_578897, base: "/",
    url: url_ClassroomCoursesCreate_578898, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesList_578619 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesList_578621(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ClassroomCoursesList_578620(path: JsonNode; query: JsonNode;
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Maximum number of items to return. Zero or unspecified indicates that the
  ## server may assign a maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   teacherId: JString
  ##            : Restricts returned courses to those having a teacher with the specified
  ## identifier. The identifier can be one of the following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : nextPageToken
  ## value returned from a previous
  ## list call,
  ## indicating that the subsequent page of results should be returned.
  ## 
  ## The list request must be
  ## otherwise identical to the one that resulted in this token.
  ##   studentId: JString
  ##            : Restricts returned courses to those having a student with the specified
  ## identifier. The identifier can be one of the following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   courseStates: JArray
  ##               : Restricts returned courses to those in one of the specified states
  ## The default value is ACTIVE, ARCHIVED, PROVISIONED, DECLINED.
  section = newJObject()
  var valid_578733 = query.getOrDefault("key")
  valid_578733 = validateParameter(valid_578733, JString, required = false,
                                 default = nil)
  if valid_578733 != nil:
    section.add "key", valid_578733
  var valid_578747 = query.getOrDefault("prettyPrint")
  valid_578747 = validateParameter(valid_578747, JBool, required = false,
                                 default = newJBool(true))
  if valid_578747 != nil:
    section.add "prettyPrint", valid_578747
  var valid_578748 = query.getOrDefault("oauth_token")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "oauth_token", valid_578748
  var valid_578749 = query.getOrDefault("$.xgafv")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = newJString("1"))
  if valid_578749 != nil:
    section.add "$.xgafv", valid_578749
  var valid_578750 = query.getOrDefault("pageSize")
  valid_578750 = validateParameter(valid_578750, JInt, required = false, default = nil)
  if valid_578750 != nil:
    section.add "pageSize", valid_578750
  var valid_578751 = query.getOrDefault("alt")
  valid_578751 = validateParameter(valid_578751, JString, required = false,
                                 default = newJString("json"))
  if valid_578751 != nil:
    section.add "alt", valid_578751
  var valid_578752 = query.getOrDefault("uploadType")
  valid_578752 = validateParameter(valid_578752, JString, required = false,
                                 default = nil)
  if valid_578752 != nil:
    section.add "uploadType", valid_578752
  var valid_578753 = query.getOrDefault("teacherId")
  valid_578753 = validateParameter(valid_578753, JString, required = false,
                                 default = nil)
  if valid_578753 != nil:
    section.add "teacherId", valid_578753
  var valid_578754 = query.getOrDefault("quotaUser")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "quotaUser", valid_578754
  var valid_578755 = query.getOrDefault("pageToken")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "pageToken", valid_578755
  var valid_578756 = query.getOrDefault("studentId")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "studentId", valid_578756
  var valid_578757 = query.getOrDefault("callback")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "callback", valid_578757
  var valid_578758 = query.getOrDefault("fields")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "fields", valid_578758
  var valid_578759 = query.getOrDefault("access_token")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "access_token", valid_578759
  var valid_578760 = query.getOrDefault("upload_protocol")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = nil)
  if valid_578760 != nil:
    section.add "upload_protocol", valid_578760
  var valid_578761 = query.getOrDefault("courseStates")
  valid_578761 = validateParameter(valid_578761, JArray, required = false,
                                 default = nil)
  if valid_578761 != nil:
    section.add "courseStates", valid_578761
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578784: Call_ClassroomCoursesList_578619; path: JsonNode;
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
  let valid = call_578784.validator(path, query, header, formData, body)
  let scheme = call_578784.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578784.url(scheme.get, call_578784.host, call_578784.base,
                         call_578784.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578784, url, valid)

proc call*(call_578855: Call_ClassroomCoursesList_578619; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          teacherId: string = ""; quotaUser: string = ""; pageToken: string = "";
          studentId: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = "";
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of items to return. Zero or unspecified indicates that the
  ## server may assign a maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   teacherId: string
  ##            : Restricts returned courses to those having a teacher with the specified
  ## identifier. The identifier can be one of the following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : nextPageToken
  ## value returned from a previous
  ## list call,
  ## indicating that the subsequent page of results should be returned.
  ## 
  ## The list request must be
  ## otherwise identical to the one that resulted in this token.
  ##   studentId: string
  ##            : Restricts returned courses to those having a student with the specified
  ## identifier. The identifier can be one of the following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   courseStates: JArray
  ##               : Restricts returned courses to those in one of the specified states
  ## The default value is ACTIVE, ARCHIVED, PROVISIONED, DECLINED.
  var query_578856 = newJObject()
  add(query_578856, "key", newJString(key))
  add(query_578856, "prettyPrint", newJBool(prettyPrint))
  add(query_578856, "oauth_token", newJString(oauthToken))
  add(query_578856, "$.xgafv", newJString(Xgafv))
  add(query_578856, "pageSize", newJInt(pageSize))
  add(query_578856, "alt", newJString(alt))
  add(query_578856, "uploadType", newJString(uploadType))
  add(query_578856, "teacherId", newJString(teacherId))
  add(query_578856, "quotaUser", newJString(quotaUser))
  add(query_578856, "pageToken", newJString(pageToken))
  add(query_578856, "studentId", newJString(studentId))
  add(query_578856, "callback", newJString(callback))
  add(query_578856, "fields", newJString(fields))
  add(query_578856, "access_token", newJString(accessToken))
  add(query_578856, "upload_protocol", newJString(uploadProtocol))
  if courseStates != nil:
    query_578856.add "courseStates", courseStates
  result = call_578855.call(nil, query_578856, nil, nil, nil)

var classroomCoursesList* = Call_ClassroomCoursesList_578619(
    name: "classroomCoursesList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/courses",
    validator: validate_ClassroomCoursesList_578620, base: "/",
    url: url_ClassroomCoursesList_578621, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAliasesCreate_578950 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesAliasesCreate_578952(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesAliasesCreate_578951(path: JsonNode; query: JsonNode;
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
  var valid_578953 = path.getOrDefault("courseId")
  valid_578953 = validateParameter(valid_578953, JString, required = true,
                                 default = nil)
  if valid_578953 != nil:
    section.add "courseId", valid_578953
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
  var valid_578954 = query.getOrDefault("key")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "key", valid_578954
  var valid_578955 = query.getOrDefault("prettyPrint")
  valid_578955 = validateParameter(valid_578955, JBool, required = false,
                                 default = newJBool(true))
  if valid_578955 != nil:
    section.add "prettyPrint", valid_578955
  var valid_578956 = query.getOrDefault("oauth_token")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "oauth_token", valid_578956
  var valid_578957 = query.getOrDefault("$.xgafv")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = newJString("1"))
  if valid_578957 != nil:
    section.add "$.xgafv", valid_578957
  var valid_578958 = query.getOrDefault("alt")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = newJString("json"))
  if valid_578958 != nil:
    section.add "alt", valid_578958
  var valid_578959 = query.getOrDefault("uploadType")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "uploadType", valid_578959
  var valid_578960 = query.getOrDefault("quotaUser")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "quotaUser", valid_578960
  var valid_578961 = query.getOrDefault("callback")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "callback", valid_578961
  var valid_578962 = query.getOrDefault("fields")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "fields", valid_578962
  var valid_578963 = query.getOrDefault("access_token")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "access_token", valid_578963
  var valid_578964 = query.getOrDefault("upload_protocol")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "upload_protocol", valid_578964
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

proc call*(call_578966: Call_ClassroomCoursesAliasesCreate_578950; path: JsonNode;
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
  let valid = call_578966.validator(path, query, header, formData, body)
  let scheme = call_578966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578966.url(scheme.get, call_578966.host, call_578966.base,
                         call_578966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578966, url, valid)

proc call*(call_578967: Call_ClassroomCoursesAliasesCreate_578950;
          courseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
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
  ##   courseId: string (required)
  ##           : Identifier of the course to alias.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578968 = newJObject()
  var query_578969 = newJObject()
  var body_578970 = newJObject()
  add(query_578969, "key", newJString(key))
  add(query_578969, "prettyPrint", newJBool(prettyPrint))
  add(query_578969, "oauth_token", newJString(oauthToken))
  add(query_578969, "$.xgafv", newJString(Xgafv))
  add(query_578969, "alt", newJString(alt))
  add(query_578969, "uploadType", newJString(uploadType))
  add(query_578969, "quotaUser", newJString(quotaUser))
  add(path_578968, "courseId", newJString(courseId))
  if body != nil:
    body_578970 = body
  add(query_578969, "callback", newJString(callback))
  add(query_578969, "fields", newJString(fields))
  add(query_578969, "access_token", newJString(accessToken))
  add(query_578969, "upload_protocol", newJString(uploadProtocol))
  result = call_578967.call(path_578968, query_578969, nil, nil, body_578970)

var classroomCoursesAliasesCreate* = Call_ClassroomCoursesAliasesCreate_578950(
    name: "classroomCoursesAliasesCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/aliases",
    validator: validate_ClassroomCoursesAliasesCreate_578951, base: "/",
    url: url_ClassroomCoursesAliasesCreate_578952, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAliasesList_578915 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesAliasesList_578917(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesAliasesList_578916(path: JsonNode; query: JsonNode;
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
  var valid_578932 = path.getOrDefault("courseId")
  valid_578932 = validateParameter(valid_578932, JString, required = true,
                                 default = nil)
  if valid_578932 != nil:
    section.add "courseId", valid_578932
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
  ##   pageSize: JInt
  ##           : Maximum number of items to return. Zero or unspecified indicates that the
  ## server may assign a maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : nextPageToken
  ## value returned from a previous
  ## list call,
  ## indicating that the subsequent page of results should be returned.
  ## 
  ## The list request
  ## must be otherwise identical to the one that resulted in this token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578933 = query.getOrDefault("key")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "key", valid_578933
  var valid_578934 = query.getOrDefault("prettyPrint")
  valid_578934 = validateParameter(valid_578934, JBool, required = false,
                                 default = newJBool(true))
  if valid_578934 != nil:
    section.add "prettyPrint", valid_578934
  var valid_578935 = query.getOrDefault("oauth_token")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "oauth_token", valid_578935
  var valid_578936 = query.getOrDefault("$.xgafv")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = newJString("1"))
  if valid_578936 != nil:
    section.add "$.xgafv", valid_578936
  var valid_578937 = query.getOrDefault("pageSize")
  valid_578937 = validateParameter(valid_578937, JInt, required = false, default = nil)
  if valid_578937 != nil:
    section.add "pageSize", valid_578937
  var valid_578938 = query.getOrDefault("alt")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = newJString("json"))
  if valid_578938 != nil:
    section.add "alt", valid_578938
  var valid_578939 = query.getOrDefault("uploadType")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "uploadType", valid_578939
  var valid_578940 = query.getOrDefault("quotaUser")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "quotaUser", valid_578940
  var valid_578941 = query.getOrDefault("pageToken")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "pageToken", valid_578941
  var valid_578942 = query.getOrDefault("callback")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "callback", valid_578942
  var valid_578943 = query.getOrDefault("fields")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "fields", valid_578943
  var valid_578944 = query.getOrDefault("access_token")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "access_token", valid_578944
  var valid_578945 = query.getOrDefault("upload_protocol")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "upload_protocol", valid_578945
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578946: Call_ClassroomCoursesAliasesList_578915; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of aliases for a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## course or for access errors.
  ## * `NOT_FOUND` if the course does not exist.
  ## 
  let valid = call_578946.validator(path, query, header, formData, body)
  let scheme = call_578946.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578946.url(scheme.get, call_578946.host, call_578946.base,
                         call_578946.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578946, url, valid)

proc call*(call_578947: Call_ClassroomCoursesAliasesList_578915; courseId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## classroomCoursesAliasesList
  ## Returns a list of aliases for a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## course or for access errors.
  ## * `NOT_FOUND` if the course does not exist.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of items to return. Zero or unspecified indicates that the
  ## server may assign a maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : nextPageToken
  ## value returned from a previous
  ## list call,
  ## indicating that the subsequent page of results should be returned.
  ## 
  ## The list request
  ## must be otherwise identical to the one that resulted in this token.
  ##   courseId: string (required)
  ##           : The identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578948 = newJObject()
  var query_578949 = newJObject()
  add(query_578949, "key", newJString(key))
  add(query_578949, "prettyPrint", newJBool(prettyPrint))
  add(query_578949, "oauth_token", newJString(oauthToken))
  add(query_578949, "$.xgafv", newJString(Xgafv))
  add(query_578949, "pageSize", newJInt(pageSize))
  add(query_578949, "alt", newJString(alt))
  add(query_578949, "uploadType", newJString(uploadType))
  add(query_578949, "quotaUser", newJString(quotaUser))
  add(query_578949, "pageToken", newJString(pageToken))
  add(path_578948, "courseId", newJString(courseId))
  add(query_578949, "callback", newJString(callback))
  add(query_578949, "fields", newJString(fields))
  add(query_578949, "access_token", newJString(accessToken))
  add(query_578949, "upload_protocol", newJString(uploadProtocol))
  result = call_578947.call(path_578948, query_578949, nil, nil, nil)

var classroomCoursesAliasesList* = Call_ClassroomCoursesAliasesList_578915(
    name: "classroomCoursesAliasesList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/aliases",
    validator: validate_ClassroomCoursesAliasesList_578916, base: "/",
    url: url_ClassroomCoursesAliasesList_578917, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAliasesDelete_578971 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesAliasesDelete_578973(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesAliasesDelete_578972(path: JsonNode; query: JsonNode;
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
  var valid_578974 = path.getOrDefault("courseId")
  valid_578974 = validateParameter(valid_578974, JString, required = true,
                                 default = nil)
  if valid_578974 != nil:
    section.add "courseId", valid_578974
  var valid_578975 = path.getOrDefault("alias")
  valid_578975 = validateParameter(valid_578975, JString, required = true,
                                 default = nil)
  if valid_578975 != nil:
    section.add "alias", valid_578975
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
  var valid_578976 = query.getOrDefault("key")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "key", valid_578976
  var valid_578977 = query.getOrDefault("prettyPrint")
  valid_578977 = validateParameter(valid_578977, JBool, required = false,
                                 default = newJBool(true))
  if valid_578977 != nil:
    section.add "prettyPrint", valid_578977
  var valid_578978 = query.getOrDefault("oauth_token")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "oauth_token", valid_578978
  var valid_578979 = query.getOrDefault("$.xgafv")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = newJString("1"))
  if valid_578979 != nil:
    section.add "$.xgafv", valid_578979
  var valid_578980 = query.getOrDefault("alt")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = newJString("json"))
  if valid_578980 != nil:
    section.add "alt", valid_578980
  var valid_578981 = query.getOrDefault("uploadType")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "uploadType", valid_578981
  var valid_578982 = query.getOrDefault("quotaUser")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "quotaUser", valid_578982
  var valid_578983 = query.getOrDefault("callback")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "callback", valid_578983
  var valid_578984 = query.getOrDefault("fields")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "fields", valid_578984
  var valid_578985 = query.getOrDefault("access_token")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "access_token", valid_578985
  var valid_578986 = query.getOrDefault("upload_protocol")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "upload_protocol", valid_578986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578987: Call_ClassroomCoursesAliasesDelete_578971; path: JsonNode;
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
  let valid = call_578987.validator(path, query, header, formData, body)
  let scheme = call_578987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578987.url(scheme.get, call_578987.host, call_578987.base,
                         call_578987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578987, url, valid)

proc call*(call_578988: Call_ClassroomCoursesAliasesDelete_578971;
          courseId: string; alias: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   courseId: string (required)
  ##           : Identifier of the course whose alias should be deleted.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   callback: string
  ##           : JSONP
  ##   alias: string (required)
  ##        : Alias to delete.
  ## This may not be the Classroom-assigned identifier.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578989 = newJObject()
  var query_578990 = newJObject()
  add(query_578990, "key", newJString(key))
  add(query_578990, "prettyPrint", newJBool(prettyPrint))
  add(query_578990, "oauth_token", newJString(oauthToken))
  add(query_578990, "$.xgafv", newJString(Xgafv))
  add(query_578990, "alt", newJString(alt))
  add(query_578990, "uploadType", newJString(uploadType))
  add(query_578990, "quotaUser", newJString(quotaUser))
  add(path_578989, "courseId", newJString(courseId))
  add(query_578990, "callback", newJString(callback))
  add(path_578989, "alias", newJString(alias))
  add(query_578990, "fields", newJString(fields))
  add(query_578990, "access_token", newJString(accessToken))
  add(query_578990, "upload_protocol", newJString(uploadProtocol))
  result = call_578988.call(path_578989, query_578990, nil, nil, nil)

var classroomCoursesAliasesDelete* = Call_ClassroomCoursesAliasesDelete_578971(
    name: "classroomCoursesAliasesDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/aliases/{alias}",
    validator: validate_ClassroomCoursesAliasesDelete_578972, base: "/",
    url: url_ClassroomCoursesAliasesDelete_578973, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAnnouncementsCreate_579014 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesAnnouncementsCreate_579016(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesAnnouncementsCreate_579015(path: JsonNode;
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
  var valid_579017 = path.getOrDefault("courseId")
  valid_579017 = validateParameter(valid_579017, JString, required = true,
                                 default = nil)
  if valid_579017 != nil:
    section.add "courseId", valid_579017
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
  var valid_579018 = query.getOrDefault("key")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "key", valid_579018
  var valid_579019 = query.getOrDefault("prettyPrint")
  valid_579019 = validateParameter(valid_579019, JBool, required = false,
                                 default = newJBool(true))
  if valid_579019 != nil:
    section.add "prettyPrint", valid_579019
  var valid_579020 = query.getOrDefault("oauth_token")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "oauth_token", valid_579020
  var valid_579021 = query.getOrDefault("$.xgafv")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = newJString("1"))
  if valid_579021 != nil:
    section.add "$.xgafv", valid_579021
  var valid_579022 = query.getOrDefault("alt")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = newJString("json"))
  if valid_579022 != nil:
    section.add "alt", valid_579022
  var valid_579023 = query.getOrDefault("uploadType")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "uploadType", valid_579023
  var valid_579024 = query.getOrDefault("quotaUser")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "quotaUser", valid_579024
  var valid_579025 = query.getOrDefault("callback")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "callback", valid_579025
  var valid_579026 = query.getOrDefault("fields")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "fields", valid_579026
  var valid_579027 = query.getOrDefault("access_token")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "access_token", valid_579027
  var valid_579028 = query.getOrDefault("upload_protocol")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "upload_protocol", valid_579028
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

proc call*(call_579030: Call_ClassroomCoursesAnnouncementsCreate_579014;
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
  let valid = call_579030.validator(path, query, header, formData, body)
  let scheme = call_579030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579030.url(scheme.get, call_579030.host, call_579030.base,
                         call_579030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579030, url, valid)

proc call*(call_579031: Call_ClassroomCoursesAnnouncementsCreate_579014;
          courseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
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
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579032 = newJObject()
  var query_579033 = newJObject()
  var body_579034 = newJObject()
  add(query_579033, "key", newJString(key))
  add(query_579033, "prettyPrint", newJBool(prettyPrint))
  add(query_579033, "oauth_token", newJString(oauthToken))
  add(query_579033, "$.xgafv", newJString(Xgafv))
  add(query_579033, "alt", newJString(alt))
  add(query_579033, "uploadType", newJString(uploadType))
  add(query_579033, "quotaUser", newJString(quotaUser))
  add(path_579032, "courseId", newJString(courseId))
  if body != nil:
    body_579034 = body
  add(query_579033, "callback", newJString(callback))
  add(query_579033, "fields", newJString(fields))
  add(query_579033, "access_token", newJString(accessToken))
  add(query_579033, "upload_protocol", newJString(uploadProtocol))
  result = call_579031.call(path_579032, query_579033, nil, nil, body_579034)

var classroomCoursesAnnouncementsCreate* = Call_ClassroomCoursesAnnouncementsCreate_579014(
    name: "classroomCoursesAnnouncementsCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/announcements",
    validator: validate_ClassroomCoursesAnnouncementsCreate_579015, base: "/",
    url: url_ClassroomCoursesAnnouncementsCreate_579016, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAnnouncementsList_578991 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesAnnouncementsList_578993(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesAnnouncementsList_578992(path: JsonNode;
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
  var valid_578994 = path.getOrDefault("courseId")
  valid_578994 = validateParameter(valid_578994, JString, required = true,
                                 default = nil)
  if valid_578994 != nil:
    section.add "courseId", valid_578994
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
  ##   pageSize: JInt
  ##           : Maximum number of items to return. Zero or unspecified indicates that the
  ## server may assign a maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: JString
  ##          : Optional sort ordering for results. A comma-separated list of fields with
  ## an optional sort direction keyword. Supported field is `updateTime`.
  ## Supported direction keywords are `asc` and `desc`.
  ## If not specified, `updateTime desc` is the default behavior.
  ## Examples: `updateTime asc`, `updateTime`
  ##   pageToken: JString
  ##            : nextPageToken
  ## value returned from a previous
  ## list call,
  ## indicating that the subsequent page of results should be returned.
  ## 
  ## The list request
  ## must be otherwise identical to the one that resulted in this token.
  ##   announcementStates: JArray
  ##                     : Restriction on the `state` of announcements returned.
  ## If this argument is left unspecified, the default value is `PUBLISHED`.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578995 = query.getOrDefault("key")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "key", valid_578995
  var valid_578996 = query.getOrDefault("prettyPrint")
  valid_578996 = validateParameter(valid_578996, JBool, required = false,
                                 default = newJBool(true))
  if valid_578996 != nil:
    section.add "prettyPrint", valid_578996
  var valid_578997 = query.getOrDefault("oauth_token")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "oauth_token", valid_578997
  var valid_578998 = query.getOrDefault("$.xgafv")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = newJString("1"))
  if valid_578998 != nil:
    section.add "$.xgafv", valid_578998
  var valid_578999 = query.getOrDefault("pageSize")
  valid_578999 = validateParameter(valid_578999, JInt, required = false, default = nil)
  if valid_578999 != nil:
    section.add "pageSize", valid_578999
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
  var valid_579003 = query.getOrDefault("orderBy")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "orderBy", valid_579003
  var valid_579004 = query.getOrDefault("pageToken")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "pageToken", valid_579004
  var valid_579005 = query.getOrDefault("announcementStates")
  valid_579005 = validateParameter(valid_579005, JArray, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "announcementStates", valid_579005
  var valid_579006 = query.getOrDefault("callback")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "callback", valid_579006
  var valid_579007 = query.getOrDefault("fields")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "fields", valid_579007
  var valid_579008 = query.getOrDefault("access_token")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "access_token", valid_579008
  var valid_579009 = query.getOrDefault("upload_protocol")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "upload_protocol", valid_579009
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579010: Call_ClassroomCoursesAnnouncementsList_578991;
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
  let valid = call_579010.validator(path, query, header, formData, body)
  let scheme = call_579010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579010.url(scheme.get, call_579010.host, call_579010.base,
                         call_579010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579010, url, valid)

proc call*(call_579011: Call_ClassroomCoursesAnnouncementsList_578991;
          courseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          orderBy: string = ""; pageToken: string = "";
          announcementStates: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of items to return. Zero or unspecified indicates that the
  ## server may assign a maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: string
  ##          : Optional sort ordering for results. A comma-separated list of fields with
  ## an optional sort direction keyword. Supported field is `updateTime`.
  ## Supported direction keywords are `asc` and `desc`.
  ## If not specified, `updateTime desc` is the default behavior.
  ## Examples: `updateTime asc`, `updateTime`
  ##   pageToken: string
  ##            : nextPageToken
  ## value returned from a previous
  ## list call,
  ## indicating that the subsequent page of results should be returned.
  ## 
  ## The list request
  ## must be otherwise identical to the one that resulted in this token.
  ##   announcementStates: JArray
  ##                     : Restriction on the `state` of announcements returned.
  ## If this argument is left unspecified, the default value is `PUBLISHED`.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579012 = newJObject()
  var query_579013 = newJObject()
  add(query_579013, "key", newJString(key))
  add(query_579013, "prettyPrint", newJBool(prettyPrint))
  add(query_579013, "oauth_token", newJString(oauthToken))
  add(query_579013, "$.xgafv", newJString(Xgafv))
  add(query_579013, "pageSize", newJInt(pageSize))
  add(query_579013, "alt", newJString(alt))
  add(query_579013, "uploadType", newJString(uploadType))
  add(query_579013, "quotaUser", newJString(quotaUser))
  add(query_579013, "orderBy", newJString(orderBy))
  add(query_579013, "pageToken", newJString(pageToken))
  if announcementStates != nil:
    query_579013.add "announcementStates", announcementStates
  add(path_579012, "courseId", newJString(courseId))
  add(query_579013, "callback", newJString(callback))
  add(query_579013, "fields", newJString(fields))
  add(query_579013, "access_token", newJString(accessToken))
  add(query_579013, "upload_protocol", newJString(uploadProtocol))
  result = call_579011.call(path_579012, query_579013, nil, nil, nil)

var classroomCoursesAnnouncementsList* = Call_ClassroomCoursesAnnouncementsList_578991(
    name: "classroomCoursesAnnouncementsList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/announcements",
    validator: validate_ClassroomCoursesAnnouncementsList_578992, base: "/",
    url: url_ClassroomCoursesAnnouncementsList_578993, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAnnouncementsGet_579035 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesAnnouncementsGet_579037(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesAnnouncementsGet_579036(path: JsonNode;
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
  var valid_579038 = path.getOrDefault("id")
  valid_579038 = validateParameter(valid_579038, JString, required = true,
                                 default = nil)
  if valid_579038 != nil:
    section.add "id", valid_579038
  var valid_579039 = path.getOrDefault("courseId")
  valid_579039 = validateParameter(valid_579039, JString, required = true,
                                 default = nil)
  if valid_579039 != nil:
    section.add "courseId", valid_579039
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
  var valid_579040 = query.getOrDefault("key")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "key", valid_579040
  var valid_579041 = query.getOrDefault("prettyPrint")
  valid_579041 = validateParameter(valid_579041, JBool, required = false,
                                 default = newJBool(true))
  if valid_579041 != nil:
    section.add "prettyPrint", valid_579041
  var valid_579042 = query.getOrDefault("oauth_token")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "oauth_token", valid_579042
  var valid_579043 = query.getOrDefault("$.xgafv")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = newJString("1"))
  if valid_579043 != nil:
    section.add "$.xgafv", valid_579043
  var valid_579044 = query.getOrDefault("alt")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = newJString("json"))
  if valid_579044 != nil:
    section.add "alt", valid_579044
  var valid_579045 = query.getOrDefault("uploadType")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "uploadType", valid_579045
  var valid_579046 = query.getOrDefault("quotaUser")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = nil)
  if valid_579046 != nil:
    section.add "quotaUser", valid_579046
  var valid_579047 = query.getOrDefault("callback")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "callback", valid_579047
  var valid_579048 = query.getOrDefault("fields")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "fields", valid_579048
  var valid_579049 = query.getOrDefault("access_token")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "access_token", valid_579049
  var valid_579050 = query.getOrDefault("upload_protocol")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "upload_protocol", valid_579050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579051: Call_ClassroomCoursesAnnouncementsGet_579035;
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
  let valid = call_579051.validator(path, query, header, formData, body)
  let scheme = call_579051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579051.url(scheme.get, call_579051.host, call_579051.base,
                         call_579051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579051, url, valid)

proc call*(call_579052: Call_ClassroomCoursesAnnouncementsGet_579035; id: string;
          courseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## classroomCoursesAnnouncementsGet
  ## Returns an announcement.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or announcement, or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course or announcement does not exist.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   id: string (required)
  ##     : Identifier of the announcement.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579053 = newJObject()
  var query_579054 = newJObject()
  add(query_579054, "key", newJString(key))
  add(query_579054, "prettyPrint", newJBool(prettyPrint))
  add(query_579054, "oauth_token", newJString(oauthToken))
  add(query_579054, "$.xgafv", newJString(Xgafv))
  add(path_579053, "id", newJString(id))
  add(query_579054, "alt", newJString(alt))
  add(query_579054, "uploadType", newJString(uploadType))
  add(query_579054, "quotaUser", newJString(quotaUser))
  add(path_579053, "courseId", newJString(courseId))
  add(query_579054, "callback", newJString(callback))
  add(query_579054, "fields", newJString(fields))
  add(query_579054, "access_token", newJString(accessToken))
  add(query_579054, "upload_protocol", newJString(uploadProtocol))
  result = call_579052.call(path_579053, query_579054, nil, nil, nil)

var classroomCoursesAnnouncementsGet* = Call_ClassroomCoursesAnnouncementsGet_579035(
    name: "classroomCoursesAnnouncementsGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/announcements/{id}",
    validator: validate_ClassroomCoursesAnnouncementsGet_579036, base: "/",
    url: url_ClassroomCoursesAnnouncementsGet_579037, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAnnouncementsPatch_579075 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesAnnouncementsPatch_579077(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesAnnouncementsPatch_579076(path: JsonNode;
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
  var valid_579078 = path.getOrDefault("id")
  valid_579078 = validateParameter(valid_579078, JString, required = true,
                                 default = nil)
  if valid_579078 != nil:
    section.add "id", valid_579078
  var valid_579079 = path.getOrDefault("courseId")
  valid_579079 = validateParameter(valid_579079, JString, required = true,
                                 default = nil)
  if valid_579079 != nil:
    section.add "courseId", valid_579079
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
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579080 = query.getOrDefault("key")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "key", valid_579080
  var valid_579081 = query.getOrDefault("prettyPrint")
  valid_579081 = validateParameter(valid_579081, JBool, required = false,
                                 default = newJBool(true))
  if valid_579081 != nil:
    section.add "prettyPrint", valid_579081
  var valid_579082 = query.getOrDefault("oauth_token")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = nil)
  if valid_579082 != nil:
    section.add "oauth_token", valid_579082
  var valid_579083 = query.getOrDefault("$.xgafv")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = newJString("1"))
  if valid_579083 != nil:
    section.add "$.xgafv", valid_579083
  var valid_579084 = query.getOrDefault("alt")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = newJString("json"))
  if valid_579084 != nil:
    section.add "alt", valid_579084
  var valid_579085 = query.getOrDefault("uploadType")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "uploadType", valid_579085
  var valid_579086 = query.getOrDefault("quotaUser")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "quotaUser", valid_579086
  var valid_579087 = query.getOrDefault("updateMask")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "updateMask", valid_579087
  var valid_579088 = query.getOrDefault("callback")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = nil)
  if valid_579088 != nil:
    section.add "callback", valid_579088
  var valid_579089 = query.getOrDefault("fields")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "fields", valid_579089
  var valid_579090 = query.getOrDefault("access_token")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "access_token", valid_579090
  var valid_579091 = query.getOrDefault("upload_protocol")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "upload_protocol", valid_579091
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

proc call*(call_579093: Call_ClassroomCoursesAnnouncementsPatch_579075;
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
  let valid = call_579093.validator(path, query, header, formData, body)
  let scheme = call_579093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579093.url(scheme.get, call_579093.host, call_579093.base,
                         call_579093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579093, url, valid)

proc call*(call_579094: Call_ClassroomCoursesAnnouncementsPatch_579075; id: string;
          courseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; updateMask: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   id: string (required)
  ##     : Identifier of the announcement.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579095 = newJObject()
  var query_579096 = newJObject()
  var body_579097 = newJObject()
  add(query_579096, "key", newJString(key))
  add(query_579096, "prettyPrint", newJBool(prettyPrint))
  add(query_579096, "oauth_token", newJString(oauthToken))
  add(query_579096, "$.xgafv", newJString(Xgafv))
  add(path_579095, "id", newJString(id))
  add(query_579096, "alt", newJString(alt))
  add(query_579096, "uploadType", newJString(uploadType))
  add(query_579096, "quotaUser", newJString(quotaUser))
  add(query_579096, "updateMask", newJString(updateMask))
  add(path_579095, "courseId", newJString(courseId))
  if body != nil:
    body_579097 = body
  add(query_579096, "callback", newJString(callback))
  add(query_579096, "fields", newJString(fields))
  add(query_579096, "access_token", newJString(accessToken))
  add(query_579096, "upload_protocol", newJString(uploadProtocol))
  result = call_579094.call(path_579095, query_579096, nil, nil, body_579097)

var classroomCoursesAnnouncementsPatch* = Call_ClassroomCoursesAnnouncementsPatch_579075(
    name: "classroomCoursesAnnouncementsPatch", meth: HttpMethod.HttpPatch,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/announcements/{id}",
    validator: validate_ClassroomCoursesAnnouncementsPatch_579076, base: "/",
    url: url_ClassroomCoursesAnnouncementsPatch_579077, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAnnouncementsDelete_579055 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesAnnouncementsDelete_579057(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesAnnouncementsDelete_579056(path: JsonNode;
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
  var valid_579058 = path.getOrDefault("id")
  valid_579058 = validateParameter(valid_579058, JString, required = true,
                                 default = nil)
  if valid_579058 != nil:
    section.add "id", valid_579058
  var valid_579059 = path.getOrDefault("courseId")
  valid_579059 = validateParameter(valid_579059, JString, required = true,
                                 default = nil)
  if valid_579059 != nil:
    section.add "courseId", valid_579059
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
  var valid_579060 = query.getOrDefault("key")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "key", valid_579060
  var valid_579061 = query.getOrDefault("prettyPrint")
  valid_579061 = validateParameter(valid_579061, JBool, required = false,
                                 default = newJBool(true))
  if valid_579061 != nil:
    section.add "prettyPrint", valid_579061
  var valid_579062 = query.getOrDefault("oauth_token")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "oauth_token", valid_579062
  var valid_579063 = query.getOrDefault("$.xgafv")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = newJString("1"))
  if valid_579063 != nil:
    section.add "$.xgafv", valid_579063
  var valid_579064 = query.getOrDefault("alt")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = newJString("json"))
  if valid_579064 != nil:
    section.add "alt", valid_579064
  var valid_579065 = query.getOrDefault("uploadType")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "uploadType", valid_579065
  var valid_579066 = query.getOrDefault("quotaUser")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "quotaUser", valid_579066
  var valid_579067 = query.getOrDefault("callback")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "callback", valid_579067
  var valid_579068 = query.getOrDefault("fields")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = nil)
  if valid_579068 != nil:
    section.add "fields", valid_579068
  var valid_579069 = query.getOrDefault("access_token")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "access_token", valid_579069
  var valid_579070 = query.getOrDefault("upload_protocol")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = nil)
  if valid_579070 != nil:
    section.add "upload_protocol", valid_579070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579071: Call_ClassroomCoursesAnnouncementsDelete_579055;
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
  let valid = call_579071.validator(path, query, header, formData, body)
  let scheme = call_579071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579071.url(scheme.get, call_579071.host, call_579071.base,
                         call_579071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579071, url, valid)

proc call*(call_579072: Call_ClassroomCoursesAnnouncementsDelete_579055;
          id: string; courseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   id: string (required)
  ##     : Identifier of the announcement to delete.
  ## This identifier is a Classroom-assigned identifier.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579073 = newJObject()
  var query_579074 = newJObject()
  add(query_579074, "key", newJString(key))
  add(query_579074, "prettyPrint", newJBool(prettyPrint))
  add(query_579074, "oauth_token", newJString(oauthToken))
  add(query_579074, "$.xgafv", newJString(Xgafv))
  add(path_579073, "id", newJString(id))
  add(query_579074, "alt", newJString(alt))
  add(query_579074, "uploadType", newJString(uploadType))
  add(query_579074, "quotaUser", newJString(quotaUser))
  add(path_579073, "courseId", newJString(courseId))
  add(query_579074, "callback", newJString(callback))
  add(query_579074, "fields", newJString(fields))
  add(query_579074, "access_token", newJString(accessToken))
  add(query_579074, "upload_protocol", newJString(uploadProtocol))
  result = call_579072.call(path_579073, query_579074, nil, nil, nil)

var classroomCoursesAnnouncementsDelete* = Call_ClassroomCoursesAnnouncementsDelete_579055(
    name: "classroomCoursesAnnouncementsDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/announcements/{id}",
    validator: validate_ClassroomCoursesAnnouncementsDelete_579056, base: "/",
    url: url_ClassroomCoursesAnnouncementsDelete_579057, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAnnouncementsModifyAssignees_579098 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesAnnouncementsModifyAssignees_579100(protocol: Scheme;
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

proc validate_ClassroomCoursesAnnouncementsModifyAssignees_579099(path: JsonNode;
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
  var valid_579101 = path.getOrDefault("id")
  valid_579101 = validateParameter(valid_579101, JString, required = true,
                                 default = nil)
  if valid_579101 != nil:
    section.add "id", valid_579101
  var valid_579102 = path.getOrDefault("courseId")
  valid_579102 = validateParameter(valid_579102, JString, required = true,
                                 default = nil)
  if valid_579102 != nil:
    section.add "courseId", valid_579102
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
  var valid_579103 = query.getOrDefault("key")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = nil)
  if valid_579103 != nil:
    section.add "key", valid_579103
  var valid_579104 = query.getOrDefault("prettyPrint")
  valid_579104 = validateParameter(valid_579104, JBool, required = false,
                                 default = newJBool(true))
  if valid_579104 != nil:
    section.add "prettyPrint", valid_579104
  var valid_579105 = query.getOrDefault("oauth_token")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "oauth_token", valid_579105
  var valid_579106 = query.getOrDefault("$.xgafv")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = newJString("1"))
  if valid_579106 != nil:
    section.add "$.xgafv", valid_579106
  var valid_579107 = query.getOrDefault("alt")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = newJString("json"))
  if valid_579107 != nil:
    section.add "alt", valid_579107
  var valid_579108 = query.getOrDefault("uploadType")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "uploadType", valid_579108
  var valid_579109 = query.getOrDefault("quotaUser")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "quotaUser", valid_579109
  var valid_579110 = query.getOrDefault("callback")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "callback", valid_579110
  var valid_579111 = query.getOrDefault("fields")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = nil)
  if valid_579111 != nil:
    section.add "fields", valid_579111
  var valid_579112 = query.getOrDefault("access_token")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = nil)
  if valid_579112 != nil:
    section.add "access_token", valid_579112
  var valid_579113 = query.getOrDefault("upload_protocol")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = nil)
  if valid_579113 != nil:
    section.add "upload_protocol", valid_579113
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

proc call*(call_579115: Call_ClassroomCoursesAnnouncementsModifyAssignees_579098;
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
  let valid = call_579115.validator(path, query, header, formData, body)
  let scheme = call_579115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579115.url(scheme.get, call_579115.host, call_579115.base,
                         call_579115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579115, url, valid)

proc call*(call_579116: Call_ClassroomCoursesAnnouncementsModifyAssignees_579098;
          id: string; courseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   id: string (required)
  ##     : Identifier of the announcement.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579117 = newJObject()
  var query_579118 = newJObject()
  var body_579119 = newJObject()
  add(query_579118, "key", newJString(key))
  add(query_579118, "prettyPrint", newJBool(prettyPrint))
  add(query_579118, "oauth_token", newJString(oauthToken))
  add(query_579118, "$.xgafv", newJString(Xgafv))
  add(path_579117, "id", newJString(id))
  add(query_579118, "alt", newJString(alt))
  add(query_579118, "uploadType", newJString(uploadType))
  add(query_579118, "quotaUser", newJString(quotaUser))
  add(path_579117, "courseId", newJString(courseId))
  if body != nil:
    body_579119 = body
  add(query_579118, "callback", newJString(callback))
  add(query_579118, "fields", newJString(fields))
  add(query_579118, "access_token", newJString(accessToken))
  add(query_579118, "upload_protocol", newJString(uploadProtocol))
  result = call_579116.call(path_579117, query_579118, nil, nil, body_579119)

var classroomCoursesAnnouncementsModifyAssignees* = Call_ClassroomCoursesAnnouncementsModifyAssignees_579098(
    name: "classroomCoursesAnnouncementsModifyAssignees",
    meth: HttpMethod.HttpPost, host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/announcements/{id}:modifyAssignees",
    validator: validate_ClassroomCoursesAnnouncementsModifyAssignees_579099,
    base: "/", url: url_ClassroomCoursesAnnouncementsModifyAssignees_579100,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkCreate_579143 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesCourseWorkCreate_579145(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesCourseWorkCreate_579144(path: JsonNode;
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
  var valid_579146 = path.getOrDefault("courseId")
  valid_579146 = validateParameter(valid_579146, JString, required = true,
                                 default = nil)
  if valid_579146 != nil:
    section.add "courseId", valid_579146
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
  var valid_579147 = query.getOrDefault("key")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "key", valid_579147
  var valid_579148 = query.getOrDefault("prettyPrint")
  valid_579148 = validateParameter(valid_579148, JBool, required = false,
                                 default = newJBool(true))
  if valid_579148 != nil:
    section.add "prettyPrint", valid_579148
  var valid_579149 = query.getOrDefault("oauth_token")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = nil)
  if valid_579149 != nil:
    section.add "oauth_token", valid_579149
  var valid_579150 = query.getOrDefault("$.xgafv")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = newJString("1"))
  if valid_579150 != nil:
    section.add "$.xgafv", valid_579150
  var valid_579151 = query.getOrDefault("alt")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = newJString("json"))
  if valid_579151 != nil:
    section.add "alt", valid_579151
  var valid_579152 = query.getOrDefault("uploadType")
  valid_579152 = validateParameter(valid_579152, JString, required = false,
                                 default = nil)
  if valid_579152 != nil:
    section.add "uploadType", valid_579152
  var valid_579153 = query.getOrDefault("quotaUser")
  valid_579153 = validateParameter(valid_579153, JString, required = false,
                                 default = nil)
  if valid_579153 != nil:
    section.add "quotaUser", valid_579153
  var valid_579154 = query.getOrDefault("callback")
  valid_579154 = validateParameter(valid_579154, JString, required = false,
                                 default = nil)
  if valid_579154 != nil:
    section.add "callback", valid_579154
  var valid_579155 = query.getOrDefault("fields")
  valid_579155 = validateParameter(valid_579155, JString, required = false,
                                 default = nil)
  if valid_579155 != nil:
    section.add "fields", valid_579155
  var valid_579156 = query.getOrDefault("access_token")
  valid_579156 = validateParameter(valid_579156, JString, required = false,
                                 default = nil)
  if valid_579156 != nil:
    section.add "access_token", valid_579156
  var valid_579157 = query.getOrDefault("upload_protocol")
  valid_579157 = validateParameter(valid_579157, JString, required = false,
                                 default = nil)
  if valid_579157 != nil:
    section.add "upload_protocol", valid_579157
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

proc call*(call_579159: Call_ClassroomCoursesCourseWorkCreate_579143;
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
  let valid = call_579159.validator(path, query, header, formData, body)
  let scheme = call_579159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579159.url(scheme.get, call_579159.host, call_579159.base,
                         call_579159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579159, url, valid)

proc call*(call_579160: Call_ClassroomCoursesCourseWorkCreate_579143;
          courseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
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
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579161 = newJObject()
  var query_579162 = newJObject()
  var body_579163 = newJObject()
  add(query_579162, "key", newJString(key))
  add(query_579162, "prettyPrint", newJBool(prettyPrint))
  add(query_579162, "oauth_token", newJString(oauthToken))
  add(query_579162, "$.xgafv", newJString(Xgafv))
  add(query_579162, "alt", newJString(alt))
  add(query_579162, "uploadType", newJString(uploadType))
  add(query_579162, "quotaUser", newJString(quotaUser))
  add(path_579161, "courseId", newJString(courseId))
  if body != nil:
    body_579163 = body
  add(query_579162, "callback", newJString(callback))
  add(query_579162, "fields", newJString(fields))
  add(query_579162, "access_token", newJString(accessToken))
  add(query_579162, "upload_protocol", newJString(uploadProtocol))
  result = call_579160.call(path_579161, query_579162, nil, nil, body_579163)

var classroomCoursesCourseWorkCreate* = Call_ClassroomCoursesCourseWorkCreate_579143(
    name: "classroomCoursesCourseWorkCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork",
    validator: validate_ClassroomCoursesCourseWorkCreate_579144, base: "/",
    url: url_ClassroomCoursesCourseWorkCreate_579145, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkList_579120 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesCourseWorkList_579122(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesCourseWorkList_579121(path: JsonNode;
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
  var valid_579123 = path.getOrDefault("courseId")
  valid_579123 = validateParameter(valid_579123, JString, required = true,
                                 default = nil)
  if valid_579123 != nil:
    section.add "courseId", valid_579123
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
  ##   pageSize: JInt
  ##           : Maximum number of items to return. Zero or unspecified indicates that the
  ## server may assign a maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: JString
  ##          : Optional sort ordering for results. A comma-separated list of fields with
  ## an optional sort direction keyword. Supported fields are `updateTime`
  ## and `dueDate`. Supported direction keywords are `asc` and `desc`.
  ## If not specified, `updateTime desc` is the default behavior.
  ## Examples: `dueDate asc,updateTime desc`, `updateTime,dueDate desc`
  ##   pageToken: JString
  ##            : nextPageToken
  ## value returned from a previous
  ## list call,
  ## indicating that the subsequent page of results should be returned.
  ## 
  ## The list request
  ## must be otherwise identical to the one that resulted in this token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   courseWorkStates: JArray
  ##                   : Restriction on the work status to return. Only courseWork that matches
  ## is returned. If unspecified, items with a work status of `PUBLISHED`
  ## is returned.
  section = newJObject()
  var valid_579124 = query.getOrDefault("key")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "key", valid_579124
  var valid_579125 = query.getOrDefault("prettyPrint")
  valid_579125 = validateParameter(valid_579125, JBool, required = false,
                                 default = newJBool(true))
  if valid_579125 != nil:
    section.add "prettyPrint", valid_579125
  var valid_579126 = query.getOrDefault("oauth_token")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "oauth_token", valid_579126
  var valid_579127 = query.getOrDefault("$.xgafv")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = newJString("1"))
  if valid_579127 != nil:
    section.add "$.xgafv", valid_579127
  var valid_579128 = query.getOrDefault("pageSize")
  valid_579128 = validateParameter(valid_579128, JInt, required = false, default = nil)
  if valid_579128 != nil:
    section.add "pageSize", valid_579128
  var valid_579129 = query.getOrDefault("alt")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = newJString("json"))
  if valid_579129 != nil:
    section.add "alt", valid_579129
  var valid_579130 = query.getOrDefault("uploadType")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = nil)
  if valid_579130 != nil:
    section.add "uploadType", valid_579130
  var valid_579131 = query.getOrDefault("quotaUser")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "quotaUser", valid_579131
  var valid_579132 = query.getOrDefault("orderBy")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = nil)
  if valid_579132 != nil:
    section.add "orderBy", valid_579132
  var valid_579133 = query.getOrDefault("pageToken")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = nil)
  if valid_579133 != nil:
    section.add "pageToken", valid_579133
  var valid_579134 = query.getOrDefault("callback")
  valid_579134 = validateParameter(valid_579134, JString, required = false,
                                 default = nil)
  if valid_579134 != nil:
    section.add "callback", valid_579134
  var valid_579135 = query.getOrDefault("fields")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = nil)
  if valid_579135 != nil:
    section.add "fields", valid_579135
  var valid_579136 = query.getOrDefault("access_token")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = nil)
  if valid_579136 != nil:
    section.add "access_token", valid_579136
  var valid_579137 = query.getOrDefault("upload_protocol")
  valid_579137 = validateParameter(valid_579137, JString, required = false,
                                 default = nil)
  if valid_579137 != nil:
    section.add "upload_protocol", valid_579137
  var valid_579138 = query.getOrDefault("courseWorkStates")
  valid_579138 = validateParameter(valid_579138, JArray, required = false,
                                 default = nil)
  if valid_579138 != nil:
    section.add "courseWorkStates", valid_579138
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579139: Call_ClassroomCoursesCourseWorkList_579120; path: JsonNode;
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
  let valid = call_579139.validator(path, query, header, formData, body)
  let scheme = call_579139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579139.url(scheme.get, call_579139.host, call_579139.base,
                         call_579139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579139, url, valid)

proc call*(call_579140: Call_ClassroomCoursesCourseWorkList_579120;
          courseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          orderBy: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          courseWorkStates: JsonNode = nil): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of items to return. Zero or unspecified indicates that the
  ## server may assign a maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: string
  ##          : Optional sort ordering for results. A comma-separated list of fields with
  ## an optional sort direction keyword. Supported fields are `updateTime`
  ## and `dueDate`. Supported direction keywords are `asc` and `desc`.
  ## If not specified, `updateTime desc` is the default behavior.
  ## Examples: `dueDate asc,updateTime desc`, `updateTime,dueDate desc`
  ##   pageToken: string
  ##            : nextPageToken
  ## value returned from a previous
  ## list call,
  ## indicating that the subsequent page of results should be returned.
  ## 
  ## The list request
  ## must be otherwise identical to the one that resulted in this token.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   courseWorkStates: JArray
  ##                   : Restriction on the work status to return. Only courseWork that matches
  ## is returned. If unspecified, items with a work status of `PUBLISHED`
  ## is returned.
  var path_579141 = newJObject()
  var query_579142 = newJObject()
  add(query_579142, "key", newJString(key))
  add(query_579142, "prettyPrint", newJBool(prettyPrint))
  add(query_579142, "oauth_token", newJString(oauthToken))
  add(query_579142, "$.xgafv", newJString(Xgafv))
  add(query_579142, "pageSize", newJInt(pageSize))
  add(query_579142, "alt", newJString(alt))
  add(query_579142, "uploadType", newJString(uploadType))
  add(query_579142, "quotaUser", newJString(quotaUser))
  add(query_579142, "orderBy", newJString(orderBy))
  add(query_579142, "pageToken", newJString(pageToken))
  add(path_579141, "courseId", newJString(courseId))
  add(query_579142, "callback", newJString(callback))
  add(query_579142, "fields", newJString(fields))
  add(query_579142, "access_token", newJString(accessToken))
  add(query_579142, "upload_protocol", newJString(uploadProtocol))
  if courseWorkStates != nil:
    query_579142.add "courseWorkStates", courseWorkStates
  result = call_579140.call(path_579141, query_579142, nil, nil, nil)

var classroomCoursesCourseWorkList* = Call_ClassroomCoursesCourseWorkList_579120(
    name: "classroomCoursesCourseWorkList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork",
    validator: validate_ClassroomCoursesCourseWorkList_579121, base: "/",
    url: url_ClassroomCoursesCourseWorkList_579122, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkStudentSubmissionsList_579164 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesCourseWorkStudentSubmissionsList_579166(
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

proc validate_ClassroomCoursesCourseWorkStudentSubmissionsList_579165(
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
  var valid_579167 = path.getOrDefault("courseWorkId")
  valid_579167 = validateParameter(valid_579167, JString, required = true,
                                 default = nil)
  if valid_579167 != nil:
    section.add "courseWorkId", valid_579167
  var valid_579168 = path.getOrDefault("courseId")
  valid_579168 = validateParameter(valid_579168, JString, required = true,
                                 default = nil)
  if valid_579168 != nil:
    section.add "courseId", valid_579168
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userId: JString
  ##         : Optional argument to restrict returned student work to those owned by the
  ## student with the specified identifier. The identifier can be one of the
  ## following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Maximum number of items to return. Zero or unspecified indicates that the
  ## server may assign a maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   late: JString
  ##       : Requested lateness value. If specified, returned student submissions are
  ## restricted by the requested value.
  ## If unspecified, submissions are returned regardless of `late` value.
  ##   pageToken: JString
  ##            : nextPageToken
  ## value returned from a previous
  ## list call,
  ## indicating that the subsequent page of results should be returned.
  ## 
  ## The list request
  ## must be otherwise identical to the one that resulted in this token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   states: JArray
  ##         : Requested submission states. If specified, returned student submissions
  ## match one of the specified submission states.
  section = newJObject()
  var valid_579169 = query.getOrDefault("key")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = nil)
  if valid_579169 != nil:
    section.add "key", valid_579169
  var valid_579170 = query.getOrDefault("prettyPrint")
  valid_579170 = validateParameter(valid_579170, JBool, required = false,
                                 default = newJBool(true))
  if valid_579170 != nil:
    section.add "prettyPrint", valid_579170
  var valid_579171 = query.getOrDefault("oauth_token")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = nil)
  if valid_579171 != nil:
    section.add "oauth_token", valid_579171
  var valid_579172 = query.getOrDefault("userId")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = nil)
  if valid_579172 != nil:
    section.add "userId", valid_579172
  var valid_579173 = query.getOrDefault("$.xgafv")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = newJString("1"))
  if valid_579173 != nil:
    section.add "$.xgafv", valid_579173
  var valid_579174 = query.getOrDefault("pageSize")
  valid_579174 = validateParameter(valid_579174, JInt, required = false, default = nil)
  if valid_579174 != nil:
    section.add "pageSize", valid_579174
  var valid_579175 = query.getOrDefault("alt")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = newJString("json"))
  if valid_579175 != nil:
    section.add "alt", valid_579175
  var valid_579176 = query.getOrDefault("uploadType")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = nil)
  if valid_579176 != nil:
    section.add "uploadType", valid_579176
  var valid_579177 = query.getOrDefault("quotaUser")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = nil)
  if valid_579177 != nil:
    section.add "quotaUser", valid_579177
  var valid_579178 = query.getOrDefault("late")
  valid_579178 = validateParameter(valid_579178, JString, required = false, default = newJString(
      "LATE_VALUES_UNSPECIFIED"))
  if valid_579178 != nil:
    section.add "late", valid_579178
  var valid_579179 = query.getOrDefault("pageToken")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = nil)
  if valid_579179 != nil:
    section.add "pageToken", valid_579179
  var valid_579180 = query.getOrDefault("callback")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = nil)
  if valid_579180 != nil:
    section.add "callback", valid_579180
  var valid_579181 = query.getOrDefault("fields")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = nil)
  if valid_579181 != nil:
    section.add "fields", valid_579181
  var valid_579182 = query.getOrDefault("access_token")
  valid_579182 = validateParameter(valid_579182, JString, required = false,
                                 default = nil)
  if valid_579182 != nil:
    section.add "access_token", valid_579182
  var valid_579183 = query.getOrDefault("upload_protocol")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = nil)
  if valid_579183 != nil:
    section.add "upload_protocol", valid_579183
  var valid_579184 = query.getOrDefault("states")
  valid_579184 = validateParameter(valid_579184, JArray, required = false,
                                 default = nil)
  if valid_579184 != nil:
    section.add "states", valid_579184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579185: Call_ClassroomCoursesCourseWorkStudentSubmissionsList_579164;
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
  let valid = call_579185.validator(path, query, header, formData, body)
  let scheme = call_579185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579185.url(scheme.get, call_579185.host, call_579185.base,
                         call_579185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579185, url, valid)

proc call*(call_579186: Call_ClassroomCoursesCourseWorkStudentSubmissionsList_579164;
          courseWorkId: string; courseId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; userId: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = "";
          late: string = "LATE_VALUES_UNSPECIFIED"; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; states: JsonNode = nil): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userId: string
  ##         : Optional argument to restrict returned student work to those owned by the
  ## student with the specified identifier. The identifier can be one of the
  ## following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  ##   Xgafv: string
  ##        : V1 error format.
  ##   courseWorkId: string (required)
  ##               : Identifier of the student work to request.
  ## This may be set to the string literal `"-"` to request student work for
  ## all course work in the specified course.
  ##   pageSize: int
  ##           : Maximum number of items to return. Zero or unspecified indicates that the
  ## server may assign a maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   late: string
  ##       : Requested lateness value. If specified, returned student submissions are
  ## restricted by the requested value.
  ## If unspecified, submissions are returned regardless of `late` value.
  ##   pageToken: string
  ##            : nextPageToken
  ## value returned from a previous
  ## list call,
  ## indicating that the subsequent page of results should be returned.
  ## 
  ## The list request
  ## must be otherwise identical to the one that resulted in this token.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   states: JArray
  ##         : Requested submission states. If specified, returned student submissions
  ## match one of the specified submission states.
  var path_579187 = newJObject()
  var query_579188 = newJObject()
  add(query_579188, "key", newJString(key))
  add(query_579188, "prettyPrint", newJBool(prettyPrint))
  add(query_579188, "oauth_token", newJString(oauthToken))
  add(query_579188, "userId", newJString(userId))
  add(query_579188, "$.xgafv", newJString(Xgafv))
  add(path_579187, "courseWorkId", newJString(courseWorkId))
  add(query_579188, "pageSize", newJInt(pageSize))
  add(query_579188, "alt", newJString(alt))
  add(query_579188, "uploadType", newJString(uploadType))
  add(query_579188, "quotaUser", newJString(quotaUser))
  add(query_579188, "late", newJString(late))
  add(query_579188, "pageToken", newJString(pageToken))
  add(path_579187, "courseId", newJString(courseId))
  add(query_579188, "callback", newJString(callback))
  add(query_579188, "fields", newJString(fields))
  add(query_579188, "access_token", newJString(accessToken))
  add(query_579188, "upload_protocol", newJString(uploadProtocol))
  if states != nil:
    query_579188.add "states", states
  result = call_579186.call(path_579187, query_579188, nil, nil, nil)

var classroomCoursesCourseWorkStudentSubmissionsList* = Call_ClassroomCoursesCourseWorkStudentSubmissionsList_579164(
    name: "classroomCoursesCourseWorkStudentSubmissionsList",
    meth: HttpMethod.HttpGet, host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork/{courseWorkId}/studentSubmissions",
    validator: validate_ClassroomCoursesCourseWorkStudentSubmissionsList_579165,
    base: "/", url: url_ClassroomCoursesCourseWorkStudentSubmissionsList_579166,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkStudentSubmissionsGet_579189 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesCourseWorkStudentSubmissionsGet_579191(protocol: Scheme;
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

proc validate_ClassroomCoursesCourseWorkStudentSubmissionsGet_579190(
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
  ##   id: JString (required)
  ##     : Identifier of the student submission.
  ##   courseWorkId: JString (required)
  ##               : Identifier of the course work.
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_579192 = path.getOrDefault("id")
  valid_579192 = validateParameter(valid_579192, JString, required = true,
                                 default = nil)
  if valid_579192 != nil:
    section.add "id", valid_579192
  var valid_579193 = path.getOrDefault("courseWorkId")
  valid_579193 = validateParameter(valid_579193, JString, required = true,
                                 default = nil)
  if valid_579193 != nil:
    section.add "courseWorkId", valid_579193
  var valid_579194 = path.getOrDefault("courseId")
  valid_579194 = validateParameter(valid_579194, JString, required = true,
                                 default = nil)
  if valid_579194 != nil:
    section.add "courseId", valid_579194
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
  var valid_579195 = query.getOrDefault("key")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "key", valid_579195
  var valid_579196 = query.getOrDefault("prettyPrint")
  valid_579196 = validateParameter(valid_579196, JBool, required = false,
                                 default = newJBool(true))
  if valid_579196 != nil:
    section.add "prettyPrint", valid_579196
  var valid_579197 = query.getOrDefault("oauth_token")
  valid_579197 = validateParameter(valid_579197, JString, required = false,
                                 default = nil)
  if valid_579197 != nil:
    section.add "oauth_token", valid_579197
  var valid_579198 = query.getOrDefault("$.xgafv")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = newJString("1"))
  if valid_579198 != nil:
    section.add "$.xgafv", valid_579198
  var valid_579199 = query.getOrDefault("alt")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = newJString("json"))
  if valid_579199 != nil:
    section.add "alt", valid_579199
  var valid_579200 = query.getOrDefault("uploadType")
  valid_579200 = validateParameter(valid_579200, JString, required = false,
                                 default = nil)
  if valid_579200 != nil:
    section.add "uploadType", valid_579200
  var valid_579201 = query.getOrDefault("quotaUser")
  valid_579201 = validateParameter(valid_579201, JString, required = false,
                                 default = nil)
  if valid_579201 != nil:
    section.add "quotaUser", valid_579201
  var valid_579202 = query.getOrDefault("callback")
  valid_579202 = validateParameter(valid_579202, JString, required = false,
                                 default = nil)
  if valid_579202 != nil:
    section.add "callback", valid_579202
  var valid_579203 = query.getOrDefault("fields")
  valid_579203 = validateParameter(valid_579203, JString, required = false,
                                 default = nil)
  if valid_579203 != nil:
    section.add "fields", valid_579203
  var valid_579204 = query.getOrDefault("access_token")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = nil)
  if valid_579204 != nil:
    section.add "access_token", valid_579204
  var valid_579205 = query.getOrDefault("upload_protocol")
  valid_579205 = validateParameter(valid_579205, JString, required = false,
                                 default = nil)
  if valid_579205 != nil:
    section.add "upload_protocol", valid_579205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579206: Call_ClassroomCoursesCourseWorkStudentSubmissionsGet_579189;
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
  let valid = call_579206.validator(path, query, header, formData, body)
  let scheme = call_579206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579206.url(scheme.get, call_579206.host, call_579206.base,
                         call_579206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579206, url, valid)

proc call*(call_579207: Call_ClassroomCoursesCourseWorkStudentSubmissionsGet_579189;
          id: string; courseWorkId: string; courseId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## classroomCoursesCourseWorkStudentSubmissionsGet
  ## Returns a student submission.
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course, course work, or student submission or for
  ## access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course, course work, or student submission
  ## does not exist.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   id: string (required)
  ##     : Identifier of the student submission.
  ##   courseWorkId: string (required)
  ##               : Identifier of the course work.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579208 = newJObject()
  var query_579209 = newJObject()
  add(query_579209, "key", newJString(key))
  add(query_579209, "prettyPrint", newJBool(prettyPrint))
  add(query_579209, "oauth_token", newJString(oauthToken))
  add(query_579209, "$.xgafv", newJString(Xgafv))
  add(path_579208, "id", newJString(id))
  add(path_579208, "courseWorkId", newJString(courseWorkId))
  add(query_579209, "alt", newJString(alt))
  add(query_579209, "uploadType", newJString(uploadType))
  add(query_579209, "quotaUser", newJString(quotaUser))
  add(path_579208, "courseId", newJString(courseId))
  add(query_579209, "callback", newJString(callback))
  add(query_579209, "fields", newJString(fields))
  add(query_579209, "access_token", newJString(accessToken))
  add(query_579209, "upload_protocol", newJString(uploadProtocol))
  result = call_579207.call(path_579208, query_579209, nil, nil, nil)

var classroomCoursesCourseWorkStudentSubmissionsGet* = Call_ClassroomCoursesCourseWorkStudentSubmissionsGet_579189(
    name: "classroomCoursesCourseWorkStudentSubmissionsGet",
    meth: HttpMethod.HttpGet, host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork/{courseWorkId}/studentSubmissions/{id}",
    validator: validate_ClassroomCoursesCourseWorkStudentSubmissionsGet_579190,
    base: "/", url: url_ClassroomCoursesCourseWorkStudentSubmissionsGet_579191,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkStudentSubmissionsPatch_579210 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesCourseWorkStudentSubmissionsPatch_579212(
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

proc validate_ClassroomCoursesCourseWorkStudentSubmissionsPatch_579211(
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
  ##   id: JString (required)
  ##     : Identifier of the student submission.
  ##   courseWorkId: JString (required)
  ##               : Identifier of the course work.
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_579213 = path.getOrDefault("id")
  valid_579213 = validateParameter(valid_579213, JString, required = true,
                                 default = nil)
  if valid_579213 != nil:
    section.add "id", valid_579213
  var valid_579214 = path.getOrDefault("courseWorkId")
  valid_579214 = validateParameter(valid_579214, JString, required = true,
                                 default = nil)
  if valid_579214 != nil:
    section.add "courseWorkId", valid_579214
  var valid_579215 = path.getOrDefault("courseId")
  valid_579215 = validateParameter(valid_579215, JString, required = true,
                                 default = nil)
  if valid_579215 != nil:
    section.add "courseId", valid_579215
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
  ##   updateMask: JString
  ##             : Mask that identifies which fields on the student submission to update.
  ## This field is required to do an update. The update fails if invalid
  ## fields are specified.
  ## 
  ## The following fields may be specified by teachers:
  ## 
  ## * `draft_grade`
  ## * `assigned_grade`
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579216 = query.getOrDefault("key")
  valid_579216 = validateParameter(valid_579216, JString, required = false,
                                 default = nil)
  if valid_579216 != nil:
    section.add "key", valid_579216
  var valid_579217 = query.getOrDefault("prettyPrint")
  valid_579217 = validateParameter(valid_579217, JBool, required = false,
                                 default = newJBool(true))
  if valid_579217 != nil:
    section.add "prettyPrint", valid_579217
  var valid_579218 = query.getOrDefault("oauth_token")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = nil)
  if valid_579218 != nil:
    section.add "oauth_token", valid_579218
  var valid_579219 = query.getOrDefault("$.xgafv")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = newJString("1"))
  if valid_579219 != nil:
    section.add "$.xgafv", valid_579219
  var valid_579220 = query.getOrDefault("alt")
  valid_579220 = validateParameter(valid_579220, JString, required = false,
                                 default = newJString("json"))
  if valid_579220 != nil:
    section.add "alt", valid_579220
  var valid_579221 = query.getOrDefault("uploadType")
  valid_579221 = validateParameter(valid_579221, JString, required = false,
                                 default = nil)
  if valid_579221 != nil:
    section.add "uploadType", valid_579221
  var valid_579222 = query.getOrDefault("quotaUser")
  valid_579222 = validateParameter(valid_579222, JString, required = false,
                                 default = nil)
  if valid_579222 != nil:
    section.add "quotaUser", valid_579222
  var valid_579223 = query.getOrDefault("updateMask")
  valid_579223 = validateParameter(valid_579223, JString, required = false,
                                 default = nil)
  if valid_579223 != nil:
    section.add "updateMask", valid_579223
  var valid_579224 = query.getOrDefault("callback")
  valid_579224 = validateParameter(valid_579224, JString, required = false,
                                 default = nil)
  if valid_579224 != nil:
    section.add "callback", valid_579224
  var valid_579225 = query.getOrDefault("fields")
  valid_579225 = validateParameter(valid_579225, JString, required = false,
                                 default = nil)
  if valid_579225 != nil:
    section.add "fields", valid_579225
  var valid_579226 = query.getOrDefault("access_token")
  valid_579226 = validateParameter(valid_579226, JString, required = false,
                                 default = nil)
  if valid_579226 != nil:
    section.add "access_token", valid_579226
  var valid_579227 = query.getOrDefault("upload_protocol")
  valid_579227 = validateParameter(valid_579227, JString, required = false,
                                 default = nil)
  if valid_579227 != nil:
    section.add "upload_protocol", valid_579227
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

proc call*(call_579229: Call_ClassroomCoursesCourseWorkStudentSubmissionsPatch_579210;
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
  let valid = call_579229.validator(path, query, header, formData, body)
  let scheme = call_579229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579229.url(scheme.get, call_579229.host, call_579229.base,
                         call_579229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579229, url, valid)

proc call*(call_579230: Call_ClassroomCoursesCourseWorkStudentSubmissionsPatch_579210;
          id: string; courseWorkId: string; courseId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          updateMask: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   id: string (required)
  ##     : Identifier of the student submission.
  ##   courseWorkId: string (required)
  ##               : Identifier of the course work.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: string
  ##             : Mask that identifies which fields on the student submission to update.
  ## This field is required to do an update. The update fails if invalid
  ## fields are specified.
  ## 
  ## The following fields may be specified by teachers:
  ## 
  ## * `draft_grade`
  ## * `assigned_grade`
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579231 = newJObject()
  var query_579232 = newJObject()
  var body_579233 = newJObject()
  add(query_579232, "key", newJString(key))
  add(query_579232, "prettyPrint", newJBool(prettyPrint))
  add(query_579232, "oauth_token", newJString(oauthToken))
  add(query_579232, "$.xgafv", newJString(Xgafv))
  add(path_579231, "id", newJString(id))
  add(path_579231, "courseWorkId", newJString(courseWorkId))
  add(query_579232, "alt", newJString(alt))
  add(query_579232, "uploadType", newJString(uploadType))
  add(query_579232, "quotaUser", newJString(quotaUser))
  add(query_579232, "updateMask", newJString(updateMask))
  add(path_579231, "courseId", newJString(courseId))
  if body != nil:
    body_579233 = body
  add(query_579232, "callback", newJString(callback))
  add(query_579232, "fields", newJString(fields))
  add(query_579232, "access_token", newJString(accessToken))
  add(query_579232, "upload_protocol", newJString(uploadProtocol))
  result = call_579230.call(path_579231, query_579232, nil, nil, body_579233)

var classroomCoursesCourseWorkStudentSubmissionsPatch* = Call_ClassroomCoursesCourseWorkStudentSubmissionsPatch_579210(
    name: "classroomCoursesCourseWorkStudentSubmissionsPatch",
    meth: HttpMethod.HttpPatch, host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork/{courseWorkId}/studentSubmissions/{id}",
    validator: validate_ClassroomCoursesCourseWorkStudentSubmissionsPatch_579211,
    base: "/", url: url_ClassroomCoursesCourseWorkStudentSubmissionsPatch_579212,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkStudentSubmissionsModifyAttachments_579234 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesCourseWorkStudentSubmissionsModifyAttachments_579236(
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

proc validate_ClassroomCoursesCourseWorkStudentSubmissionsModifyAttachments_579235(
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
  ##   id: JString (required)
  ##     : Identifier of the student submission.
  ##   courseWorkId: JString (required)
  ##               : Identifier of the course work.
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_579237 = path.getOrDefault("id")
  valid_579237 = validateParameter(valid_579237, JString, required = true,
                                 default = nil)
  if valid_579237 != nil:
    section.add "id", valid_579237
  var valid_579238 = path.getOrDefault("courseWorkId")
  valid_579238 = validateParameter(valid_579238, JString, required = true,
                                 default = nil)
  if valid_579238 != nil:
    section.add "courseWorkId", valid_579238
  var valid_579239 = path.getOrDefault("courseId")
  valid_579239 = validateParameter(valid_579239, JString, required = true,
                                 default = nil)
  if valid_579239 != nil:
    section.add "courseId", valid_579239
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
  var valid_579240 = query.getOrDefault("key")
  valid_579240 = validateParameter(valid_579240, JString, required = false,
                                 default = nil)
  if valid_579240 != nil:
    section.add "key", valid_579240
  var valid_579241 = query.getOrDefault("prettyPrint")
  valid_579241 = validateParameter(valid_579241, JBool, required = false,
                                 default = newJBool(true))
  if valid_579241 != nil:
    section.add "prettyPrint", valid_579241
  var valid_579242 = query.getOrDefault("oauth_token")
  valid_579242 = validateParameter(valid_579242, JString, required = false,
                                 default = nil)
  if valid_579242 != nil:
    section.add "oauth_token", valid_579242
  var valid_579243 = query.getOrDefault("$.xgafv")
  valid_579243 = validateParameter(valid_579243, JString, required = false,
                                 default = newJString("1"))
  if valid_579243 != nil:
    section.add "$.xgafv", valid_579243
  var valid_579244 = query.getOrDefault("alt")
  valid_579244 = validateParameter(valid_579244, JString, required = false,
                                 default = newJString("json"))
  if valid_579244 != nil:
    section.add "alt", valid_579244
  var valid_579245 = query.getOrDefault("uploadType")
  valid_579245 = validateParameter(valid_579245, JString, required = false,
                                 default = nil)
  if valid_579245 != nil:
    section.add "uploadType", valid_579245
  var valid_579246 = query.getOrDefault("quotaUser")
  valid_579246 = validateParameter(valid_579246, JString, required = false,
                                 default = nil)
  if valid_579246 != nil:
    section.add "quotaUser", valid_579246
  var valid_579247 = query.getOrDefault("callback")
  valid_579247 = validateParameter(valid_579247, JString, required = false,
                                 default = nil)
  if valid_579247 != nil:
    section.add "callback", valid_579247
  var valid_579248 = query.getOrDefault("fields")
  valid_579248 = validateParameter(valid_579248, JString, required = false,
                                 default = nil)
  if valid_579248 != nil:
    section.add "fields", valid_579248
  var valid_579249 = query.getOrDefault("access_token")
  valid_579249 = validateParameter(valid_579249, JString, required = false,
                                 default = nil)
  if valid_579249 != nil:
    section.add "access_token", valid_579249
  var valid_579250 = query.getOrDefault("upload_protocol")
  valid_579250 = validateParameter(valid_579250, JString, required = false,
                                 default = nil)
  if valid_579250 != nil:
    section.add "upload_protocol", valid_579250
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

proc call*(call_579252: Call_ClassroomCoursesCourseWorkStudentSubmissionsModifyAttachments_579234;
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
  let valid = call_579252.validator(path, query, header, formData, body)
  let scheme = call_579252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579252.url(scheme.get, call_579252.host, call_579252.base,
                         call_579252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579252, url, valid)

proc call*(call_579253: Call_ClassroomCoursesCourseWorkStudentSubmissionsModifyAttachments_579234;
          id: string; courseWorkId: string; courseId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   id: string (required)
  ##     : Identifier of the student submission.
  ##   courseWorkId: string (required)
  ##               : Identifier of the course work.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579254 = newJObject()
  var query_579255 = newJObject()
  var body_579256 = newJObject()
  add(query_579255, "key", newJString(key))
  add(query_579255, "prettyPrint", newJBool(prettyPrint))
  add(query_579255, "oauth_token", newJString(oauthToken))
  add(query_579255, "$.xgafv", newJString(Xgafv))
  add(path_579254, "id", newJString(id))
  add(path_579254, "courseWorkId", newJString(courseWorkId))
  add(query_579255, "alt", newJString(alt))
  add(query_579255, "uploadType", newJString(uploadType))
  add(query_579255, "quotaUser", newJString(quotaUser))
  add(path_579254, "courseId", newJString(courseId))
  if body != nil:
    body_579256 = body
  add(query_579255, "callback", newJString(callback))
  add(query_579255, "fields", newJString(fields))
  add(query_579255, "access_token", newJString(accessToken))
  add(query_579255, "upload_protocol", newJString(uploadProtocol))
  result = call_579253.call(path_579254, query_579255, nil, nil, body_579256)

var classroomCoursesCourseWorkStudentSubmissionsModifyAttachments* = Call_ClassroomCoursesCourseWorkStudentSubmissionsModifyAttachments_579234(
    name: "classroomCoursesCourseWorkStudentSubmissionsModifyAttachments",
    meth: HttpMethod.HttpPost, host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork/{courseWorkId}/studentSubmissions/{id}:modifyAttachments", validator: validate_ClassroomCoursesCourseWorkStudentSubmissionsModifyAttachments_579235,
    base: "/",
    url: url_ClassroomCoursesCourseWorkStudentSubmissionsModifyAttachments_579236,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkStudentSubmissionsReclaim_579257 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesCourseWorkStudentSubmissionsReclaim_579259(
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

proc validate_ClassroomCoursesCourseWorkStudentSubmissionsReclaim_579258(
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
  ##   id: JString (required)
  ##     : Identifier of the student submission.
  ##   courseWorkId: JString (required)
  ##               : Identifier of the course work.
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_579260 = path.getOrDefault("id")
  valid_579260 = validateParameter(valid_579260, JString, required = true,
                                 default = nil)
  if valid_579260 != nil:
    section.add "id", valid_579260
  var valid_579261 = path.getOrDefault("courseWorkId")
  valid_579261 = validateParameter(valid_579261, JString, required = true,
                                 default = nil)
  if valid_579261 != nil:
    section.add "courseWorkId", valid_579261
  var valid_579262 = path.getOrDefault("courseId")
  valid_579262 = validateParameter(valid_579262, JString, required = true,
                                 default = nil)
  if valid_579262 != nil:
    section.add "courseId", valid_579262
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
  var valid_579263 = query.getOrDefault("key")
  valid_579263 = validateParameter(valid_579263, JString, required = false,
                                 default = nil)
  if valid_579263 != nil:
    section.add "key", valid_579263
  var valid_579264 = query.getOrDefault("prettyPrint")
  valid_579264 = validateParameter(valid_579264, JBool, required = false,
                                 default = newJBool(true))
  if valid_579264 != nil:
    section.add "prettyPrint", valid_579264
  var valid_579265 = query.getOrDefault("oauth_token")
  valid_579265 = validateParameter(valid_579265, JString, required = false,
                                 default = nil)
  if valid_579265 != nil:
    section.add "oauth_token", valid_579265
  var valid_579266 = query.getOrDefault("$.xgafv")
  valid_579266 = validateParameter(valid_579266, JString, required = false,
                                 default = newJString("1"))
  if valid_579266 != nil:
    section.add "$.xgafv", valid_579266
  var valid_579267 = query.getOrDefault("alt")
  valid_579267 = validateParameter(valid_579267, JString, required = false,
                                 default = newJString("json"))
  if valid_579267 != nil:
    section.add "alt", valid_579267
  var valid_579268 = query.getOrDefault("uploadType")
  valid_579268 = validateParameter(valid_579268, JString, required = false,
                                 default = nil)
  if valid_579268 != nil:
    section.add "uploadType", valid_579268
  var valid_579269 = query.getOrDefault("quotaUser")
  valid_579269 = validateParameter(valid_579269, JString, required = false,
                                 default = nil)
  if valid_579269 != nil:
    section.add "quotaUser", valid_579269
  var valid_579270 = query.getOrDefault("callback")
  valid_579270 = validateParameter(valid_579270, JString, required = false,
                                 default = nil)
  if valid_579270 != nil:
    section.add "callback", valid_579270
  var valid_579271 = query.getOrDefault("fields")
  valid_579271 = validateParameter(valid_579271, JString, required = false,
                                 default = nil)
  if valid_579271 != nil:
    section.add "fields", valid_579271
  var valid_579272 = query.getOrDefault("access_token")
  valid_579272 = validateParameter(valid_579272, JString, required = false,
                                 default = nil)
  if valid_579272 != nil:
    section.add "access_token", valid_579272
  var valid_579273 = query.getOrDefault("upload_protocol")
  valid_579273 = validateParameter(valid_579273, JString, required = false,
                                 default = nil)
  if valid_579273 != nil:
    section.add "upload_protocol", valid_579273
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

proc call*(call_579275: Call_ClassroomCoursesCourseWorkStudentSubmissionsReclaim_579257;
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
  let valid = call_579275.validator(path, query, header, formData, body)
  let scheme = call_579275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579275.url(scheme.get, call_579275.host, call_579275.base,
                         call_579275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579275, url, valid)

proc call*(call_579276: Call_ClassroomCoursesCourseWorkStudentSubmissionsReclaim_579257;
          id: string; courseWorkId: string; courseId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   id: string (required)
  ##     : Identifier of the student submission.
  ##   courseWorkId: string (required)
  ##               : Identifier of the course work.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579277 = newJObject()
  var query_579278 = newJObject()
  var body_579279 = newJObject()
  add(query_579278, "key", newJString(key))
  add(query_579278, "prettyPrint", newJBool(prettyPrint))
  add(query_579278, "oauth_token", newJString(oauthToken))
  add(query_579278, "$.xgafv", newJString(Xgafv))
  add(path_579277, "id", newJString(id))
  add(path_579277, "courseWorkId", newJString(courseWorkId))
  add(query_579278, "alt", newJString(alt))
  add(query_579278, "uploadType", newJString(uploadType))
  add(query_579278, "quotaUser", newJString(quotaUser))
  add(path_579277, "courseId", newJString(courseId))
  if body != nil:
    body_579279 = body
  add(query_579278, "callback", newJString(callback))
  add(query_579278, "fields", newJString(fields))
  add(query_579278, "access_token", newJString(accessToken))
  add(query_579278, "upload_protocol", newJString(uploadProtocol))
  result = call_579276.call(path_579277, query_579278, nil, nil, body_579279)

var classroomCoursesCourseWorkStudentSubmissionsReclaim* = Call_ClassroomCoursesCourseWorkStudentSubmissionsReclaim_579257(
    name: "classroomCoursesCourseWorkStudentSubmissionsReclaim",
    meth: HttpMethod.HttpPost, host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork/{courseWorkId}/studentSubmissions/{id}:reclaim",
    validator: validate_ClassroomCoursesCourseWorkStudentSubmissionsReclaim_579258,
    base: "/", url: url_ClassroomCoursesCourseWorkStudentSubmissionsReclaim_579259,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkStudentSubmissionsReturn_579280 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesCourseWorkStudentSubmissionsReturn_579282(
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

proc validate_ClassroomCoursesCourseWorkStudentSubmissionsReturn_579281(
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
  ##   id: JString (required)
  ##     : Identifier of the student submission.
  ##   courseWorkId: JString (required)
  ##               : Identifier of the course work.
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_579283 = path.getOrDefault("id")
  valid_579283 = validateParameter(valid_579283, JString, required = true,
                                 default = nil)
  if valid_579283 != nil:
    section.add "id", valid_579283
  var valid_579284 = path.getOrDefault("courseWorkId")
  valid_579284 = validateParameter(valid_579284, JString, required = true,
                                 default = nil)
  if valid_579284 != nil:
    section.add "courseWorkId", valid_579284
  var valid_579285 = path.getOrDefault("courseId")
  valid_579285 = validateParameter(valid_579285, JString, required = true,
                                 default = nil)
  if valid_579285 != nil:
    section.add "courseId", valid_579285
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
  var valid_579286 = query.getOrDefault("key")
  valid_579286 = validateParameter(valid_579286, JString, required = false,
                                 default = nil)
  if valid_579286 != nil:
    section.add "key", valid_579286
  var valid_579287 = query.getOrDefault("prettyPrint")
  valid_579287 = validateParameter(valid_579287, JBool, required = false,
                                 default = newJBool(true))
  if valid_579287 != nil:
    section.add "prettyPrint", valid_579287
  var valid_579288 = query.getOrDefault("oauth_token")
  valid_579288 = validateParameter(valid_579288, JString, required = false,
                                 default = nil)
  if valid_579288 != nil:
    section.add "oauth_token", valid_579288
  var valid_579289 = query.getOrDefault("$.xgafv")
  valid_579289 = validateParameter(valid_579289, JString, required = false,
                                 default = newJString("1"))
  if valid_579289 != nil:
    section.add "$.xgafv", valid_579289
  var valid_579290 = query.getOrDefault("alt")
  valid_579290 = validateParameter(valid_579290, JString, required = false,
                                 default = newJString("json"))
  if valid_579290 != nil:
    section.add "alt", valid_579290
  var valid_579291 = query.getOrDefault("uploadType")
  valid_579291 = validateParameter(valid_579291, JString, required = false,
                                 default = nil)
  if valid_579291 != nil:
    section.add "uploadType", valid_579291
  var valid_579292 = query.getOrDefault("quotaUser")
  valid_579292 = validateParameter(valid_579292, JString, required = false,
                                 default = nil)
  if valid_579292 != nil:
    section.add "quotaUser", valid_579292
  var valid_579293 = query.getOrDefault("callback")
  valid_579293 = validateParameter(valid_579293, JString, required = false,
                                 default = nil)
  if valid_579293 != nil:
    section.add "callback", valid_579293
  var valid_579294 = query.getOrDefault("fields")
  valid_579294 = validateParameter(valid_579294, JString, required = false,
                                 default = nil)
  if valid_579294 != nil:
    section.add "fields", valid_579294
  var valid_579295 = query.getOrDefault("access_token")
  valid_579295 = validateParameter(valid_579295, JString, required = false,
                                 default = nil)
  if valid_579295 != nil:
    section.add "access_token", valid_579295
  var valid_579296 = query.getOrDefault("upload_protocol")
  valid_579296 = validateParameter(valid_579296, JString, required = false,
                                 default = nil)
  if valid_579296 != nil:
    section.add "upload_protocol", valid_579296
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

proc call*(call_579298: Call_ClassroomCoursesCourseWorkStudentSubmissionsReturn_579280;
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
  let valid = call_579298.validator(path, query, header, formData, body)
  let scheme = call_579298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579298.url(scheme.get, call_579298.host, call_579298.base,
                         call_579298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579298, url, valid)

proc call*(call_579299: Call_ClassroomCoursesCourseWorkStudentSubmissionsReturn_579280;
          id: string; courseWorkId: string; courseId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   id: string (required)
  ##     : Identifier of the student submission.
  ##   courseWorkId: string (required)
  ##               : Identifier of the course work.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579300 = newJObject()
  var query_579301 = newJObject()
  var body_579302 = newJObject()
  add(query_579301, "key", newJString(key))
  add(query_579301, "prettyPrint", newJBool(prettyPrint))
  add(query_579301, "oauth_token", newJString(oauthToken))
  add(query_579301, "$.xgafv", newJString(Xgafv))
  add(path_579300, "id", newJString(id))
  add(path_579300, "courseWorkId", newJString(courseWorkId))
  add(query_579301, "alt", newJString(alt))
  add(query_579301, "uploadType", newJString(uploadType))
  add(query_579301, "quotaUser", newJString(quotaUser))
  add(path_579300, "courseId", newJString(courseId))
  if body != nil:
    body_579302 = body
  add(query_579301, "callback", newJString(callback))
  add(query_579301, "fields", newJString(fields))
  add(query_579301, "access_token", newJString(accessToken))
  add(query_579301, "upload_protocol", newJString(uploadProtocol))
  result = call_579299.call(path_579300, query_579301, nil, nil, body_579302)

var classroomCoursesCourseWorkStudentSubmissionsReturn* = Call_ClassroomCoursesCourseWorkStudentSubmissionsReturn_579280(
    name: "classroomCoursesCourseWorkStudentSubmissionsReturn",
    meth: HttpMethod.HttpPost, host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork/{courseWorkId}/studentSubmissions/{id}:return",
    validator: validate_ClassroomCoursesCourseWorkStudentSubmissionsReturn_579281,
    base: "/", url: url_ClassroomCoursesCourseWorkStudentSubmissionsReturn_579282,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkStudentSubmissionsTurnIn_579303 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesCourseWorkStudentSubmissionsTurnIn_579305(
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

proc validate_ClassroomCoursesCourseWorkStudentSubmissionsTurnIn_579304(
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
  ##   id: JString (required)
  ##     : Identifier of the student submission.
  ##   courseWorkId: JString (required)
  ##               : Identifier of the course work.
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_579306 = path.getOrDefault("id")
  valid_579306 = validateParameter(valid_579306, JString, required = true,
                                 default = nil)
  if valid_579306 != nil:
    section.add "id", valid_579306
  var valid_579307 = path.getOrDefault("courseWorkId")
  valid_579307 = validateParameter(valid_579307, JString, required = true,
                                 default = nil)
  if valid_579307 != nil:
    section.add "courseWorkId", valid_579307
  var valid_579308 = path.getOrDefault("courseId")
  valid_579308 = validateParameter(valid_579308, JString, required = true,
                                 default = nil)
  if valid_579308 != nil:
    section.add "courseId", valid_579308
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
  var valid_579309 = query.getOrDefault("key")
  valid_579309 = validateParameter(valid_579309, JString, required = false,
                                 default = nil)
  if valid_579309 != nil:
    section.add "key", valid_579309
  var valid_579310 = query.getOrDefault("prettyPrint")
  valid_579310 = validateParameter(valid_579310, JBool, required = false,
                                 default = newJBool(true))
  if valid_579310 != nil:
    section.add "prettyPrint", valid_579310
  var valid_579311 = query.getOrDefault("oauth_token")
  valid_579311 = validateParameter(valid_579311, JString, required = false,
                                 default = nil)
  if valid_579311 != nil:
    section.add "oauth_token", valid_579311
  var valid_579312 = query.getOrDefault("$.xgafv")
  valid_579312 = validateParameter(valid_579312, JString, required = false,
                                 default = newJString("1"))
  if valid_579312 != nil:
    section.add "$.xgafv", valid_579312
  var valid_579313 = query.getOrDefault("alt")
  valid_579313 = validateParameter(valid_579313, JString, required = false,
                                 default = newJString("json"))
  if valid_579313 != nil:
    section.add "alt", valid_579313
  var valid_579314 = query.getOrDefault("uploadType")
  valid_579314 = validateParameter(valid_579314, JString, required = false,
                                 default = nil)
  if valid_579314 != nil:
    section.add "uploadType", valid_579314
  var valid_579315 = query.getOrDefault("quotaUser")
  valid_579315 = validateParameter(valid_579315, JString, required = false,
                                 default = nil)
  if valid_579315 != nil:
    section.add "quotaUser", valid_579315
  var valid_579316 = query.getOrDefault("callback")
  valid_579316 = validateParameter(valid_579316, JString, required = false,
                                 default = nil)
  if valid_579316 != nil:
    section.add "callback", valid_579316
  var valid_579317 = query.getOrDefault("fields")
  valid_579317 = validateParameter(valid_579317, JString, required = false,
                                 default = nil)
  if valid_579317 != nil:
    section.add "fields", valid_579317
  var valid_579318 = query.getOrDefault("access_token")
  valid_579318 = validateParameter(valid_579318, JString, required = false,
                                 default = nil)
  if valid_579318 != nil:
    section.add "access_token", valid_579318
  var valid_579319 = query.getOrDefault("upload_protocol")
  valid_579319 = validateParameter(valid_579319, JString, required = false,
                                 default = nil)
  if valid_579319 != nil:
    section.add "upload_protocol", valid_579319
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

proc call*(call_579321: Call_ClassroomCoursesCourseWorkStudentSubmissionsTurnIn_579303;
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
  let valid = call_579321.validator(path, query, header, formData, body)
  let scheme = call_579321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579321.url(scheme.get, call_579321.host, call_579321.base,
                         call_579321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579321, url, valid)

proc call*(call_579322: Call_ClassroomCoursesCourseWorkStudentSubmissionsTurnIn_579303;
          id: string; courseWorkId: string; courseId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   id: string (required)
  ##     : Identifier of the student submission.
  ##   courseWorkId: string (required)
  ##               : Identifier of the course work.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579323 = newJObject()
  var query_579324 = newJObject()
  var body_579325 = newJObject()
  add(query_579324, "key", newJString(key))
  add(query_579324, "prettyPrint", newJBool(prettyPrint))
  add(query_579324, "oauth_token", newJString(oauthToken))
  add(query_579324, "$.xgafv", newJString(Xgafv))
  add(path_579323, "id", newJString(id))
  add(path_579323, "courseWorkId", newJString(courseWorkId))
  add(query_579324, "alt", newJString(alt))
  add(query_579324, "uploadType", newJString(uploadType))
  add(query_579324, "quotaUser", newJString(quotaUser))
  add(path_579323, "courseId", newJString(courseId))
  if body != nil:
    body_579325 = body
  add(query_579324, "callback", newJString(callback))
  add(query_579324, "fields", newJString(fields))
  add(query_579324, "access_token", newJString(accessToken))
  add(query_579324, "upload_protocol", newJString(uploadProtocol))
  result = call_579322.call(path_579323, query_579324, nil, nil, body_579325)

var classroomCoursesCourseWorkStudentSubmissionsTurnIn* = Call_ClassroomCoursesCourseWorkStudentSubmissionsTurnIn_579303(
    name: "classroomCoursesCourseWorkStudentSubmissionsTurnIn",
    meth: HttpMethod.HttpPost, host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork/{courseWorkId}/studentSubmissions/{id}:turnIn",
    validator: validate_ClassroomCoursesCourseWorkStudentSubmissionsTurnIn_579304,
    base: "/", url: url_ClassroomCoursesCourseWorkStudentSubmissionsTurnIn_579305,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkGet_579326 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesCourseWorkGet_579328(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesCourseWorkGet_579327(path: JsonNode; query: JsonNode;
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
  var valid_579329 = path.getOrDefault("id")
  valid_579329 = validateParameter(valid_579329, JString, required = true,
                                 default = nil)
  if valid_579329 != nil:
    section.add "id", valid_579329
  var valid_579330 = path.getOrDefault("courseId")
  valid_579330 = validateParameter(valid_579330, JString, required = true,
                                 default = nil)
  if valid_579330 != nil:
    section.add "courseId", valid_579330
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
  var valid_579331 = query.getOrDefault("key")
  valid_579331 = validateParameter(valid_579331, JString, required = false,
                                 default = nil)
  if valid_579331 != nil:
    section.add "key", valid_579331
  var valid_579332 = query.getOrDefault("prettyPrint")
  valid_579332 = validateParameter(valid_579332, JBool, required = false,
                                 default = newJBool(true))
  if valid_579332 != nil:
    section.add "prettyPrint", valid_579332
  var valid_579333 = query.getOrDefault("oauth_token")
  valid_579333 = validateParameter(valid_579333, JString, required = false,
                                 default = nil)
  if valid_579333 != nil:
    section.add "oauth_token", valid_579333
  var valid_579334 = query.getOrDefault("$.xgafv")
  valid_579334 = validateParameter(valid_579334, JString, required = false,
                                 default = newJString("1"))
  if valid_579334 != nil:
    section.add "$.xgafv", valid_579334
  var valid_579335 = query.getOrDefault("alt")
  valid_579335 = validateParameter(valid_579335, JString, required = false,
                                 default = newJString("json"))
  if valid_579335 != nil:
    section.add "alt", valid_579335
  var valid_579336 = query.getOrDefault("uploadType")
  valid_579336 = validateParameter(valid_579336, JString, required = false,
                                 default = nil)
  if valid_579336 != nil:
    section.add "uploadType", valid_579336
  var valid_579337 = query.getOrDefault("quotaUser")
  valid_579337 = validateParameter(valid_579337, JString, required = false,
                                 default = nil)
  if valid_579337 != nil:
    section.add "quotaUser", valid_579337
  var valid_579338 = query.getOrDefault("callback")
  valid_579338 = validateParameter(valid_579338, JString, required = false,
                                 default = nil)
  if valid_579338 != nil:
    section.add "callback", valid_579338
  var valid_579339 = query.getOrDefault("fields")
  valid_579339 = validateParameter(valid_579339, JString, required = false,
                                 default = nil)
  if valid_579339 != nil:
    section.add "fields", valid_579339
  var valid_579340 = query.getOrDefault("access_token")
  valid_579340 = validateParameter(valid_579340, JString, required = false,
                                 default = nil)
  if valid_579340 != nil:
    section.add "access_token", valid_579340
  var valid_579341 = query.getOrDefault("upload_protocol")
  valid_579341 = validateParameter(valid_579341, JString, required = false,
                                 default = nil)
  if valid_579341 != nil:
    section.add "upload_protocol", valid_579341
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579342: Call_ClassroomCoursesCourseWorkGet_579326; path: JsonNode;
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
  let valid = call_579342.validator(path, query, header, formData, body)
  let scheme = call_579342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579342.url(scheme.get, call_579342.host, call_579342.base,
                         call_579342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579342, url, valid)

proc call*(call_579343: Call_ClassroomCoursesCourseWorkGet_579326; id: string;
          courseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## classroomCoursesCourseWorkGet
  ## Returns course work.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or course work, or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course or course work does not exist.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   id: string (required)
  ##     : Identifier of the course work.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579344 = newJObject()
  var query_579345 = newJObject()
  add(query_579345, "key", newJString(key))
  add(query_579345, "prettyPrint", newJBool(prettyPrint))
  add(query_579345, "oauth_token", newJString(oauthToken))
  add(query_579345, "$.xgafv", newJString(Xgafv))
  add(path_579344, "id", newJString(id))
  add(query_579345, "alt", newJString(alt))
  add(query_579345, "uploadType", newJString(uploadType))
  add(query_579345, "quotaUser", newJString(quotaUser))
  add(path_579344, "courseId", newJString(courseId))
  add(query_579345, "callback", newJString(callback))
  add(query_579345, "fields", newJString(fields))
  add(query_579345, "access_token", newJString(accessToken))
  add(query_579345, "upload_protocol", newJString(uploadProtocol))
  result = call_579343.call(path_579344, query_579345, nil, nil, nil)

var classroomCoursesCourseWorkGet* = Call_ClassroomCoursesCourseWorkGet_579326(
    name: "classroomCoursesCourseWorkGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/courseWork/{id}",
    validator: validate_ClassroomCoursesCourseWorkGet_579327, base: "/",
    url: url_ClassroomCoursesCourseWorkGet_579328, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkPatch_579366 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesCourseWorkPatch_579368(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesCourseWorkPatch_579367(path: JsonNode;
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
  var valid_579369 = path.getOrDefault("id")
  valid_579369 = validateParameter(valid_579369, JString, required = true,
                                 default = nil)
  if valid_579369 != nil:
    section.add "id", valid_579369
  var valid_579370 = path.getOrDefault("courseId")
  valid_579370 = validateParameter(valid_579370, JString, required = true,
                                 default = nil)
  if valid_579370 != nil:
    section.add "courseId", valid_579370
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
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579371 = query.getOrDefault("key")
  valid_579371 = validateParameter(valid_579371, JString, required = false,
                                 default = nil)
  if valid_579371 != nil:
    section.add "key", valid_579371
  var valid_579372 = query.getOrDefault("prettyPrint")
  valid_579372 = validateParameter(valid_579372, JBool, required = false,
                                 default = newJBool(true))
  if valid_579372 != nil:
    section.add "prettyPrint", valid_579372
  var valid_579373 = query.getOrDefault("oauth_token")
  valid_579373 = validateParameter(valid_579373, JString, required = false,
                                 default = nil)
  if valid_579373 != nil:
    section.add "oauth_token", valid_579373
  var valid_579374 = query.getOrDefault("$.xgafv")
  valid_579374 = validateParameter(valid_579374, JString, required = false,
                                 default = newJString("1"))
  if valid_579374 != nil:
    section.add "$.xgafv", valid_579374
  var valid_579375 = query.getOrDefault("alt")
  valid_579375 = validateParameter(valid_579375, JString, required = false,
                                 default = newJString("json"))
  if valid_579375 != nil:
    section.add "alt", valid_579375
  var valid_579376 = query.getOrDefault("uploadType")
  valid_579376 = validateParameter(valid_579376, JString, required = false,
                                 default = nil)
  if valid_579376 != nil:
    section.add "uploadType", valid_579376
  var valid_579377 = query.getOrDefault("quotaUser")
  valid_579377 = validateParameter(valid_579377, JString, required = false,
                                 default = nil)
  if valid_579377 != nil:
    section.add "quotaUser", valid_579377
  var valid_579378 = query.getOrDefault("updateMask")
  valid_579378 = validateParameter(valid_579378, JString, required = false,
                                 default = nil)
  if valid_579378 != nil:
    section.add "updateMask", valid_579378
  var valid_579379 = query.getOrDefault("callback")
  valid_579379 = validateParameter(valid_579379, JString, required = false,
                                 default = nil)
  if valid_579379 != nil:
    section.add "callback", valid_579379
  var valid_579380 = query.getOrDefault("fields")
  valid_579380 = validateParameter(valid_579380, JString, required = false,
                                 default = nil)
  if valid_579380 != nil:
    section.add "fields", valid_579380
  var valid_579381 = query.getOrDefault("access_token")
  valid_579381 = validateParameter(valid_579381, JString, required = false,
                                 default = nil)
  if valid_579381 != nil:
    section.add "access_token", valid_579381
  var valid_579382 = query.getOrDefault("upload_protocol")
  valid_579382 = validateParameter(valid_579382, JString, required = false,
                                 default = nil)
  if valid_579382 != nil:
    section.add "upload_protocol", valid_579382
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

proc call*(call_579384: Call_ClassroomCoursesCourseWorkPatch_579366;
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
  let valid = call_579384.validator(path, query, header, formData, body)
  let scheme = call_579384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579384.url(scheme.get, call_579384.host, call_579384.base,
                         call_579384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579384, url, valid)

proc call*(call_579385: Call_ClassroomCoursesCourseWorkPatch_579366; id: string;
          courseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; updateMask: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   id: string (required)
  ##     : Identifier of the course work.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579386 = newJObject()
  var query_579387 = newJObject()
  var body_579388 = newJObject()
  add(query_579387, "key", newJString(key))
  add(query_579387, "prettyPrint", newJBool(prettyPrint))
  add(query_579387, "oauth_token", newJString(oauthToken))
  add(query_579387, "$.xgafv", newJString(Xgafv))
  add(path_579386, "id", newJString(id))
  add(query_579387, "alt", newJString(alt))
  add(query_579387, "uploadType", newJString(uploadType))
  add(query_579387, "quotaUser", newJString(quotaUser))
  add(query_579387, "updateMask", newJString(updateMask))
  add(path_579386, "courseId", newJString(courseId))
  if body != nil:
    body_579388 = body
  add(query_579387, "callback", newJString(callback))
  add(query_579387, "fields", newJString(fields))
  add(query_579387, "access_token", newJString(accessToken))
  add(query_579387, "upload_protocol", newJString(uploadProtocol))
  result = call_579385.call(path_579386, query_579387, nil, nil, body_579388)

var classroomCoursesCourseWorkPatch* = Call_ClassroomCoursesCourseWorkPatch_579366(
    name: "classroomCoursesCourseWorkPatch", meth: HttpMethod.HttpPatch,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/courseWork/{id}",
    validator: validate_ClassroomCoursesCourseWorkPatch_579367, base: "/",
    url: url_ClassroomCoursesCourseWorkPatch_579368, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkDelete_579346 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesCourseWorkDelete_579348(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesCourseWorkDelete_579347(path: JsonNode;
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
  var valid_579349 = path.getOrDefault("id")
  valid_579349 = validateParameter(valid_579349, JString, required = true,
                                 default = nil)
  if valid_579349 != nil:
    section.add "id", valid_579349
  var valid_579350 = path.getOrDefault("courseId")
  valid_579350 = validateParameter(valid_579350, JString, required = true,
                                 default = nil)
  if valid_579350 != nil:
    section.add "courseId", valid_579350
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
  var valid_579351 = query.getOrDefault("key")
  valid_579351 = validateParameter(valid_579351, JString, required = false,
                                 default = nil)
  if valid_579351 != nil:
    section.add "key", valid_579351
  var valid_579352 = query.getOrDefault("prettyPrint")
  valid_579352 = validateParameter(valid_579352, JBool, required = false,
                                 default = newJBool(true))
  if valid_579352 != nil:
    section.add "prettyPrint", valid_579352
  var valid_579353 = query.getOrDefault("oauth_token")
  valid_579353 = validateParameter(valid_579353, JString, required = false,
                                 default = nil)
  if valid_579353 != nil:
    section.add "oauth_token", valid_579353
  var valid_579354 = query.getOrDefault("$.xgafv")
  valid_579354 = validateParameter(valid_579354, JString, required = false,
                                 default = newJString("1"))
  if valid_579354 != nil:
    section.add "$.xgafv", valid_579354
  var valid_579355 = query.getOrDefault("alt")
  valid_579355 = validateParameter(valid_579355, JString, required = false,
                                 default = newJString("json"))
  if valid_579355 != nil:
    section.add "alt", valid_579355
  var valid_579356 = query.getOrDefault("uploadType")
  valid_579356 = validateParameter(valid_579356, JString, required = false,
                                 default = nil)
  if valid_579356 != nil:
    section.add "uploadType", valid_579356
  var valid_579357 = query.getOrDefault("quotaUser")
  valid_579357 = validateParameter(valid_579357, JString, required = false,
                                 default = nil)
  if valid_579357 != nil:
    section.add "quotaUser", valid_579357
  var valid_579358 = query.getOrDefault("callback")
  valid_579358 = validateParameter(valid_579358, JString, required = false,
                                 default = nil)
  if valid_579358 != nil:
    section.add "callback", valid_579358
  var valid_579359 = query.getOrDefault("fields")
  valid_579359 = validateParameter(valid_579359, JString, required = false,
                                 default = nil)
  if valid_579359 != nil:
    section.add "fields", valid_579359
  var valid_579360 = query.getOrDefault("access_token")
  valid_579360 = validateParameter(valid_579360, JString, required = false,
                                 default = nil)
  if valid_579360 != nil:
    section.add "access_token", valid_579360
  var valid_579361 = query.getOrDefault("upload_protocol")
  valid_579361 = validateParameter(valid_579361, JString, required = false,
                                 default = nil)
  if valid_579361 != nil:
    section.add "upload_protocol", valid_579361
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579362: Call_ClassroomCoursesCourseWorkDelete_579346;
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
  let valid = call_579362.validator(path, query, header, formData, body)
  let scheme = call_579362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579362.url(scheme.get, call_579362.host, call_579362.base,
                         call_579362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579362, url, valid)

proc call*(call_579363: Call_ClassroomCoursesCourseWorkDelete_579346; id: string;
          courseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   id: string (required)
  ##     : Identifier of the course work to delete.
  ## This identifier is a Classroom-assigned identifier.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579364 = newJObject()
  var query_579365 = newJObject()
  add(query_579365, "key", newJString(key))
  add(query_579365, "prettyPrint", newJBool(prettyPrint))
  add(query_579365, "oauth_token", newJString(oauthToken))
  add(query_579365, "$.xgafv", newJString(Xgafv))
  add(path_579364, "id", newJString(id))
  add(query_579365, "alt", newJString(alt))
  add(query_579365, "uploadType", newJString(uploadType))
  add(query_579365, "quotaUser", newJString(quotaUser))
  add(path_579364, "courseId", newJString(courseId))
  add(query_579365, "callback", newJString(callback))
  add(query_579365, "fields", newJString(fields))
  add(query_579365, "access_token", newJString(accessToken))
  add(query_579365, "upload_protocol", newJString(uploadProtocol))
  result = call_579363.call(path_579364, query_579365, nil, nil, nil)

var classroomCoursesCourseWorkDelete* = Call_ClassroomCoursesCourseWorkDelete_579346(
    name: "classroomCoursesCourseWorkDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/courseWork/{id}",
    validator: validate_ClassroomCoursesCourseWorkDelete_579347, base: "/",
    url: url_ClassroomCoursesCourseWorkDelete_579348, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkModifyAssignees_579389 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesCourseWorkModifyAssignees_579391(protocol: Scheme;
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

proc validate_ClassroomCoursesCourseWorkModifyAssignees_579390(path: JsonNode;
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
  var valid_579392 = path.getOrDefault("id")
  valid_579392 = validateParameter(valid_579392, JString, required = true,
                                 default = nil)
  if valid_579392 != nil:
    section.add "id", valid_579392
  var valid_579393 = path.getOrDefault("courseId")
  valid_579393 = validateParameter(valid_579393, JString, required = true,
                                 default = nil)
  if valid_579393 != nil:
    section.add "courseId", valid_579393
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
  var valid_579394 = query.getOrDefault("key")
  valid_579394 = validateParameter(valid_579394, JString, required = false,
                                 default = nil)
  if valid_579394 != nil:
    section.add "key", valid_579394
  var valid_579395 = query.getOrDefault("prettyPrint")
  valid_579395 = validateParameter(valid_579395, JBool, required = false,
                                 default = newJBool(true))
  if valid_579395 != nil:
    section.add "prettyPrint", valid_579395
  var valid_579396 = query.getOrDefault("oauth_token")
  valid_579396 = validateParameter(valid_579396, JString, required = false,
                                 default = nil)
  if valid_579396 != nil:
    section.add "oauth_token", valid_579396
  var valid_579397 = query.getOrDefault("$.xgafv")
  valid_579397 = validateParameter(valid_579397, JString, required = false,
                                 default = newJString("1"))
  if valid_579397 != nil:
    section.add "$.xgafv", valid_579397
  var valid_579398 = query.getOrDefault("alt")
  valid_579398 = validateParameter(valid_579398, JString, required = false,
                                 default = newJString("json"))
  if valid_579398 != nil:
    section.add "alt", valid_579398
  var valid_579399 = query.getOrDefault("uploadType")
  valid_579399 = validateParameter(valid_579399, JString, required = false,
                                 default = nil)
  if valid_579399 != nil:
    section.add "uploadType", valid_579399
  var valid_579400 = query.getOrDefault("quotaUser")
  valid_579400 = validateParameter(valid_579400, JString, required = false,
                                 default = nil)
  if valid_579400 != nil:
    section.add "quotaUser", valid_579400
  var valid_579401 = query.getOrDefault("callback")
  valid_579401 = validateParameter(valid_579401, JString, required = false,
                                 default = nil)
  if valid_579401 != nil:
    section.add "callback", valid_579401
  var valid_579402 = query.getOrDefault("fields")
  valid_579402 = validateParameter(valid_579402, JString, required = false,
                                 default = nil)
  if valid_579402 != nil:
    section.add "fields", valid_579402
  var valid_579403 = query.getOrDefault("access_token")
  valid_579403 = validateParameter(valid_579403, JString, required = false,
                                 default = nil)
  if valid_579403 != nil:
    section.add "access_token", valid_579403
  var valid_579404 = query.getOrDefault("upload_protocol")
  valid_579404 = validateParameter(valid_579404, JString, required = false,
                                 default = nil)
  if valid_579404 != nil:
    section.add "upload_protocol", valid_579404
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

proc call*(call_579406: Call_ClassroomCoursesCourseWorkModifyAssignees_579389;
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
  let valid = call_579406.validator(path, query, header, formData, body)
  let scheme = call_579406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579406.url(scheme.get, call_579406.host, call_579406.base,
                         call_579406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579406, url, valid)

proc call*(call_579407: Call_ClassroomCoursesCourseWorkModifyAssignees_579389;
          id: string; courseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   id: string (required)
  ##     : Identifier of the coursework.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579408 = newJObject()
  var query_579409 = newJObject()
  var body_579410 = newJObject()
  add(query_579409, "key", newJString(key))
  add(query_579409, "prettyPrint", newJBool(prettyPrint))
  add(query_579409, "oauth_token", newJString(oauthToken))
  add(query_579409, "$.xgafv", newJString(Xgafv))
  add(path_579408, "id", newJString(id))
  add(query_579409, "alt", newJString(alt))
  add(query_579409, "uploadType", newJString(uploadType))
  add(query_579409, "quotaUser", newJString(quotaUser))
  add(path_579408, "courseId", newJString(courseId))
  if body != nil:
    body_579410 = body
  add(query_579409, "callback", newJString(callback))
  add(query_579409, "fields", newJString(fields))
  add(query_579409, "access_token", newJString(accessToken))
  add(query_579409, "upload_protocol", newJString(uploadProtocol))
  result = call_579407.call(path_579408, query_579409, nil, nil, body_579410)

var classroomCoursesCourseWorkModifyAssignees* = Call_ClassroomCoursesCourseWorkModifyAssignees_579389(
    name: "classroomCoursesCourseWorkModifyAssignees", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/courseWork/{id}:modifyAssignees",
    validator: validate_ClassroomCoursesCourseWorkModifyAssignees_579390,
    base: "/", url: url_ClassroomCoursesCourseWorkModifyAssignees_579391,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesStudentsCreate_579432 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesStudentsCreate_579434(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesStudentsCreate_579433(path: JsonNode;
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
  var valid_579435 = path.getOrDefault("courseId")
  valid_579435 = validateParameter(valid_579435, JString, required = true,
                                 default = nil)
  if valid_579435 != nil:
    section.add "courseId", valid_579435
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
  ##   enrollmentCode: JString
  ##                 : Enrollment code of the course to create the student in.
  ## This code is required if userId
  ## corresponds to the requesting user; it may be omitted if the requesting
  ## user has administrative permissions to create students for any user.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579436 = query.getOrDefault("key")
  valid_579436 = validateParameter(valid_579436, JString, required = false,
                                 default = nil)
  if valid_579436 != nil:
    section.add "key", valid_579436
  var valid_579437 = query.getOrDefault("prettyPrint")
  valid_579437 = validateParameter(valid_579437, JBool, required = false,
                                 default = newJBool(true))
  if valid_579437 != nil:
    section.add "prettyPrint", valid_579437
  var valid_579438 = query.getOrDefault("oauth_token")
  valid_579438 = validateParameter(valid_579438, JString, required = false,
                                 default = nil)
  if valid_579438 != nil:
    section.add "oauth_token", valid_579438
  var valid_579439 = query.getOrDefault("$.xgafv")
  valid_579439 = validateParameter(valid_579439, JString, required = false,
                                 default = newJString("1"))
  if valid_579439 != nil:
    section.add "$.xgafv", valid_579439
  var valid_579440 = query.getOrDefault("alt")
  valid_579440 = validateParameter(valid_579440, JString, required = false,
                                 default = newJString("json"))
  if valid_579440 != nil:
    section.add "alt", valid_579440
  var valid_579441 = query.getOrDefault("uploadType")
  valid_579441 = validateParameter(valid_579441, JString, required = false,
                                 default = nil)
  if valid_579441 != nil:
    section.add "uploadType", valid_579441
  var valid_579442 = query.getOrDefault("quotaUser")
  valid_579442 = validateParameter(valid_579442, JString, required = false,
                                 default = nil)
  if valid_579442 != nil:
    section.add "quotaUser", valid_579442
  var valid_579443 = query.getOrDefault("enrollmentCode")
  valid_579443 = validateParameter(valid_579443, JString, required = false,
                                 default = nil)
  if valid_579443 != nil:
    section.add "enrollmentCode", valid_579443
  var valid_579444 = query.getOrDefault("callback")
  valid_579444 = validateParameter(valid_579444, JString, required = false,
                                 default = nil)
  if valid_579444 != nil:
    section.add "callback", valid_579444
  var valid_579445 = query.getOrDefault("fields")
  valid_579445 = validateParameter(valid_579445, JString, required = false,
                                 default = nil)
  if valid_579445 != nil:
    section.add "fields", valid_579445
  var valid_579446 = query.getOrDefault("access_token")
  valid_579446 = validateParameter(valid_579446, JString, required = false,
                                 default = nil)
  if valid_579446 != nil:
    section.add "access_token", valid_579446
  var valid_579447 = query.getOrDefault("upload_protocol")
  valid_579447 = validateParameter(valid_579447, JString, required = false,
                                 default = nil)
  if valid_579447 != nil:
    section.add "upload_protocol", valid_579447
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

proc call*(call_579449: Call_ClassroomCoursesStudentsCreate_579432; path: JsonNode;
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
  let valid = call_579449.validator(path, query, header, formData, body)
  let scheme = call_579449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579449.url(scheme.get, call_579449.host, call_579449.base,
                         call_579449.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579449, url, valid)

proc call*(call_579450: Call_ClassroomCoursesStudentsCreate_579432;
          courseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; enrollmentCode: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   courseId: string (required)
  ##           : Identifier of the course to create the student in.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   enrollmentCode: string
  ##                 : Enrollment code of the course to create the student in.
  ## This code is required if userId
  ## corresponds to the requesting user; it may be omitted if the requesting
  ## user has administrative permissions to create students for any user.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579451 = newJObject()
  var query_579452 = newJObject()
  var body_579453 = newJObject()
  add(query_579452, "key", newJString(key))
  add(query_579452, "prettyPrint", newJBool(prettyPrint))
  add(query_579452, "oauth_token", newJString(oauthToken))
  add(query_579452, "$.xgafv", newJString(Xgafv))
  add(query_579452, "alt", newJString(alt))
  add(query_579452, "uploadType", newJString(uploadType))
  add(query_579452, "quotaUser", newJString(quotaUser))
  add(path_579451, "courseId", newJString(courseId))
  add(query_579452, "enrollmentCode", newJString(enrollmentCode))
  if body != nil:
    body_579453 = body
  add(query_579452, "callback", newJString(callback))
  add(query_579452, "fields", newJString(fields))
  add(query_579452, "access_token", newJString(accessToken))
  add(query_579452, "upload_protocol", newJString(uploadProtocol))
  result = call_579450.call(path_579451, query_579452, nil, nil, body_579453)

var classroomCoursesStudentsCreate* = Call_ClassroomCoursesStudentsCreate_579432(
    name: "classroomCoursesStudentsCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/students",
    validator: validate_ClassroomCoursesStudentsCreate_579433, base: "/",
    url: url_ClassroomCoursesStudentsCreate_579434, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesStudentsList_579411 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesStudentsList_579413(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesStudentsList_579412(path: JsonNode; query: JsonNode;
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
  var valid_579414 = path.getOrDefault("courseId")
  valid_579414 = validateParameter(valid_579414, JString, required = true,
                                 default = nil)
  if valid_579414 != nil:
    section.add "courseId", valid_579414
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
  ##   pageSize: JInt
  ##           : Maximum number of items to return. Zero means no maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : nextPageToken
  ## value returned from a previous
  ## list call, indicating that
  ## the subsequent page of results should be returned.
  ## 
  ## The list request must be
  ## otherwise identical to the one that resulted in this token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579415 = query.getOrDefault("key")
  valid_579415 = validateParameter(valid_579415, JString, required = false,
                                 default = nil)
  if valid_579415 != nil:
    section.add "key", valid_579415
  var valid_579416 = query.getOrDefault("prettyPrint")
  valid_579416 = validateParameter(valid_579416, JBool, required = false,
                                 default = newJBool(true))
  if valid_579416 != nil:
    section.add "prettyPrint", valid_579416
  var valid_579417 = query.getOrDefault("oauth_token")
  valid_579417 = validateParameter(valid_579417, JString, required = false,
                                 default = nil)
  if valid_579417 != nil:
    section.add "oauth_token", valid_579417
  var valid_579418 = query.getOrDefault("$.xgafv")
  valid_579418 = validateParameter(valid_579418, JString, required = false,
                                 default = newJString("1"))
  if valid_579418 != nil:
    section.add "$.xgafv", valid_579418
  var valid_579419 = query.getOrDefault("pageSize")
  valid_579419 = validateParameter(valid_579419, JInt, required = false, default = nil)
  if valid_579419 != nil:
    section.add "pageSize", valid_579419
  var valid_579420 = query.getOrDefault("alt")
  valid_579420 = validateParameter(valid_579420, JString, required = false,
                                 default = newJString("json"))
  if valid_579420 != nil:
    section.add "alt", valid_579420
  var valid_579421 = query.getOrDefault("uploadType")
  valid_579421 = validateParameter(valid_579421, JString, required = false,
                                 default = nil)
  if valid_579421 != nil:
    section.add "uploadType", valid_579421
  var valid_579422 = query.getOrDefault("quotaUser")
  valid_579422 = validateParameter(valid_579422, JString, required = false,
                                 default = nil)
  if valid_579422 != nil:
    section.add "quotaUser", valid_579422
  var valid_579423 = query.getOrDefault("pageToken")
  valid_579423 = validateParameter(valid_579423, JString, required = false,
                                 default = nil)
  if valid_579423 != nil:
    section.add "pageToken", valid_579423
  var valid_579424 = query.getOrDefault("callback")
  valid_579424 = validateParameter(valid_579424, JString, required = false,
                                 default = nil)
  if valid_579424 != nil:
    section.add "callback", valid_579424
  var valid_579425 = query.getOrDefault("fields")
  valid_579425 = validateParameter(valid_579425, JString, required = false,
                                 default = nil)
  if valid_579425 != nil:
    section.add "fields", valid_579425
  var valid_579426 = query.getOrDefault("access_token")
  valid_579426 = validateParameter(valid_579426, JString, required = false,
                                 default = nil)
  if valid_579426 != nil:
    section.add "access_token", valid_579426
  var valid_579427 = query.getOrDefault("upload_protocol")
  valid_579427 = validateParameter(valid_579427, JString, required = false,
                                 default = nil)
  if valid_579427 != nil:
    section.add "upload_protocol", valid_579427
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579428: Call_ClassroomCoursesStudentsList_579411; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of students of this course that the requester
  ## is permitted to view.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `NOT_FOUND` if the course does not exist.
  ## * `PERMISSION_DENIED` for access errors.
  ## 
  let valid = call_579428.validator(path, query, header, formData, body)
  let scheme = call_579428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579428.url(scheme.get, call_579428.host, call_579428.base,
                         call_579428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579428, url, valid)

proc call*(call_579429: Call_ClassroomCoursesStudentsList_579411; courseId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## classroomCoursesStudentsList
  ## Returns a list of students of this course that the requester
  ## is permitted to view.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `NOT_FOUND` if the course does not exist.
  ## * `PERMISSION_DENIED` for access errors.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of items to return. Zero means no maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : nextPageToken
  ## value returned from a previous
  ## list call, indicating that
  ## the subsequent page of results should be returned.
  ## 
  ## The list request must be
  ## otherwise identical to the one that resulted in this token.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579430 = newJObject()
  var query_579431 = newJObject()
  add(query_579431, "key", newJString(key))
  add(query_579431, "prettyPrint", newJBool(prettyPrint))
  add(query_579431, "oauth_token", newJString(oauthToken))
  add(query_579431, "$.xgafv", newJString(Xgafv))
  add(query_579431, "pageSize", newJInt(pageSize))
  add(query_579431, "alt", newJString(alt))
  add(query_579431, "uploadType", newJString(uploadType))
  add(query_579431, "quotaUser", newJString(quotaUser))
  add(query_579431, "pageToken", newJString(pageToken))
  add(path_579430, "courseId", newJString(courseId))
  add(query_579431, "callback", newJString(callback))
  add(query_579431, "fields", newJString(fields))
  add(query_579431, "access_token", newJString(accessToken))
  add(query_579431, "upload_protocol", newJString(uploadProtocol))
  result = call_579429.call(path_579430, query_579431, nil, nil, nil)

var classroomCoursesStudentsList* = Call_ClassroomCoursesStudentsList_579411(
    name: "classroomCoursesStudentsList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/students",
    validator: validate_ClassroomCoursesStudentsList_579412, base: "/",
    url: url_ClassroomCoursesStudentsList_579413, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesStudentsGet_579454 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesStudentsGet_579456(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesStudentsGet_579455(path: JsonNode; query: JsonNode;
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
  ##   userId: JString (required)
  ##         : Identifier of the student to return. The identifier can be one of the
  ## following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_579457 = path.getOrDefault("userId")
  valid_579457 = validateParameter(valid_579457, JString, required = true,
                                 default = nil)
  if valid_579457 != nil:
    section.add "userId", valid_579457
  var valid_579458 = path.getOrDefault("courseId")
  valid_579458 = validateParameter(valid_579458, JString, required = true,
                                 default = nil)
  if valid_579458 != nil:
    section.add "courseId", valid_579458
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
  var valid_579459 = query.getOrDefault("key")
  valid_579459 = validateParameter(valid_579459, JString, required = false,
                                 default = nil)
  if valid_579459 != nil:
    section.add "key", valid_579459
  var valid_579460 = query.getOrDefault("prettyPrint")
  valid_579460 = validateParameter(valid_579460, JBool, required = false,
                                 default = newJBool(true))
  if valid_579460 != nil:
    section.add "prettyPrint", valid_579460
  var valid_579461 = query.getOrDefault("oauth_token")
  valid_579461 = validateParameter(valid_579461, JString, required = false,
                                 default = nil)
  if valid_579461 != nil:
    section.add "oauth_token", valid_579461
  var valid_579462 = query.getOrDefault("$.xgafv")
  valid_579462 = validateParameter(valid_579462, JString, required = false,
                                 default = newJString("1"))
  if valid_579462 != nil:
    section.add "$.xgafv", valid_579462
  var valid_579463 = query.getOrDefault("alt")
  valid_579463 = validateParameter(valid_579463, JString, required = false,
                                 default = newJString("json"))
  if valid_579463 != nil:
    section.add "alt", valid_579463
  var valid_579464 = query.getOrDefault("uploadType")
  valid_579464 = validateParameter(valid_579464, JString, required = false,
                                 default = nil)
  if valid_579464 != nil:
    section.add "uploadType", valid_579464
  var valid_579465 = query.getOrDefault("quotaUser")
  valid_579465 = validateParameter(valid_579465, JString, required = false,
                                 default = nil)
  if valid_579465 != nil:
    section.add "quotaUser", valid_579465
  var valid_579466 = query.getOrDefault("callback")
  valid_579466 = validateParameter(valid_579466, JString, required = false,
                                 default = nil)
  if valid_579466 != nil:
    section.add "callback", valid_579466
  var valid_579467 = query.getOrDefault("fields")
  valid_579467 = validateParameter(valid_579467, JString, required = false,
                                 default = nil)
  if valid_579467 != nil:
    section.add "fields", valid_579467
  var valid_579468 = query.getOrDefault("access_token")
  valid_579468 = validateParameter(valid_579468, JString, required = false,
                                 default = nil)
  if valid_579468 != nil:
    section.add "access_token", valid_579468
  var valid_579469 = query.getOrDefault("upload_protocol")
  valid_579469 = validateParameter(valid_579469, JString, required = false,
                                 default = nil)
  if valid_579469 != nil:
    section.add "upload_protocol", valid_579469
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579470: Call_ClassroomCoursesStudentsGet_579454; path: JsonNode;
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
  let valid = call_579470.validator(path, query, header, formData, body)
  let scheme = call_579470.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579470.url(scheme.get, call_579470.host, call_579470.base,
                         call_579470.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579470, url, valid)

proc call*(call_579471: Call_ClassroomCoursesStudentsGet_579454; userId: string;
          courseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## classroomCoursesStudentsGet
  ## Returns a student of a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to view
  ## students of this course or for access errors.
  ## * `NOT_FOUND` if no student of this course has the requested ID or if the
  ## course does not exist.
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
  ##   userId: string (required)
  ##         : Identifier of the student to return. The identifier can be one of the
  ## following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579472 = newJObject()
  var query_579473 = newJObject()
  add(query_579473, "key", newJString(key))
  add(query_579473, "prettyPrint", newJBool(prettyPrint))
  add(query_579473, "oauth_token", newJString(oauthToken))
  add(query_579473, "$.xgafv", newJString(Xgafv))
  add(query_579473, "alt", newJString(alt))
  add(query_579473, "uploadType", newJString(uploadType))
  add(query_579473, "quotaUser", newJString(quotaUser))
  add(path_579472, "userId", newJString(userId))
  add(path_579472, "courseId", newJString(courseId))
  add(query_579473, "callback", newJString(callback))
  add(query_579473, "fields", newJString(fields))
  add(query_579473, "access_token", newJString(accessToken))
  add(query_579473, "upload_protocol", newJString(uploadProtocol))
  result = call_579471.call(path_579472, query_579473, nil, nil, nil)

var classroomCoursesStudentsGet* = Call_ClassroomCoursesStudentsGet_579454(
    name: "classroomCoursesStudentsGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/students/{userId}",
    validator: validate_ClassroomCoursesStudentsGet_579455, base: "/",
    url: url_ClassroomCoursesStudentsGet_579456, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesStudentsDelete_579474 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesStudentsDelete_579476(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesStudentsDelete_579475(path: JsonNode;
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
  ##   userId: JString (required)
  ##         : Identifier of the student to delete. The identifier can be one of the
  ## following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_579477 = path.getOrDefault("userId")
  valid_579477 = validateParameter(valid_579477, JString, required = true,
                                 default = nil)
  if valid_579477 != nil:
    section.add "userId", valid_579477
  var valid_579478 = path.getOrDefault("courseId")
  valid_579478 = validateParameter(valid_579478, JString, required = true,
                                 default = nil)
  if valid_579478 != nil:
    section.add "courseId", valid_579478
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
  var valid_579479 = query.getOrDefault("key")
  valid_579479 = validateParameter(valid_579479, JString, required = false,
                                 default = nil)
  if valid_579479 != nil:
    section.add "key", valid_579479
  var valid_579480 = query.getOrDefault("prettyPrint")
  valid_579480 = validateParameter(valid_579480, JBool, required = false,
                                 default = newJBool(true))
  if valid_579480 != nil:
    section.add "prettyPrint", valid_579480
  var valid_579481 = query.getOrDefault("oauth_token")
  valid_579481 = validateParameter(valid_579481, JString, required = false,
                                 default = nil)
  if valid_579481 != nil:
    section.add "oauth_token", valid_579481
  var valid_579482 = query.getOrDefault("$.xgafv")
  valid_579482 = validateParameter(valid_579482, JString, required = false,
                                 default = newJString("1"))
  if valid_579482 != nil:
    section.add "$.xgafv", valid_579482
  var valid_579483 = query.getOrDefault("alt")
  valid_579483 = validateParameter(valid_579483, JString, required = false,
                                 default = newJString("json"))
  if valid_579483 != nil:
    section.add "alt", valid_579483
  var valid_579484 = query.getOrDefault("uploadType")
  valid_579484 = validateParameter(valid_579484, JString, required = false,
                                 default = nil)
  if valid_579484 != nil:
    section.add "uploadType", valid_579484
  var valid_579485 = query.getOrDefault("quotaUser")
  valid_579485 = validateParameter(valid_579485, JString, required = false,
                                 default = nil)
  if valid_579485 != nil:
    section.add "quotaUser", valid_579485
  var valid_579486 = query.getOrDefault("callback")
  valid_579486 = validateParameter(valid_579486, JString, required = false,
                                 default = nil)
  if valid_579486 != nil:
    section.add "callback", valid_579486
  var valid_579487 = query.getOrDefault("fields")
  valid_579487 = validateParameter(valid_579487, JString, required = false,
                                 default = nil)
  if valid_579487 != nil:
    section.add "fields", valid_579487
  var valid_579488 = query.getOrDefault("access_token")
  valid_579488 = validateParameter(valid_579488, JString, required = false,
                                 default = nil)
  if valid_579488 != nil:
    section.add "access_token", valid_579488
  var valid_579489 = query.getOrDefault("upload_protocol")
  valid_579489 = validateParameter(valid_579489, JString, required = false,
                                 default = nil)
  if valid_579489 != nil:
    section.add "upload_protocol", valid_579489
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579490: Call_ClassroomCoursesStudentsDelete_579474; path: JsonNode;
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
  let valid = call_579490.validator(path, query, header, formData, body)
  let scheme = call_579490.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579490.url(scheme.get, call_579490.host, call_579490.base,
                         call_579490.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579490, url, valid)

proc call*(call_579491: Call_ClassroomCoursesStudentsDelete_579474; userId: string;
          courseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## classroomCoursesStudentsDelete
  ## Deletes a student of a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to delete
  ## students of this course or for access errors.
  ## * `NOT_FOUND` if no student of this course has the requested ID or if the
  ## course does not exist.
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
  ##   userId: string (required)
  ##         : Identifier of the student to delete. The identifier can be one of the
  ## following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579492 = newJObject()
  var query_579493 = newJObject()
  add(query_579493, "key", newJString(key))
  add(query_579493, "prettyPrint", newJBool(prettyPrint))
  add(query_579493, "oauth_token", newJString(oauthToken))
  add(query_579493, "$.xgafv", newJString(Xgafv))
  add(query_579493, "alt", newJString(alt))
  add(query_579493, "uploadType", newJString(uploadType))
  add(query_579493, "quotaUser", newJString(quotaUser))
  add(path_579492, "userId", newJString(userId))
  add(path_579492, "courseId", newJString(courseId))
  add(query_579493, "callback", newJString(callback))
  add(query_579493, "fields", newJString(fields))
  add(query_579493, "access_token", newJString(accessToken))
  add(query_579493, "upload_protocol", newJString(uploadProtocol))
  result = call_579491.call(path_579492, query_579493, nil, nil, nil)

var classroomCoursesStudentsDelete* = Call_ClassroomCoursesStudentsDelete_579474(
    name: "classroomCoursesStudentsDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/students/{userId}",
    validator: validate_ClassroomCoursesStudentsDelete_579475, base: "/",
    url: url_ClassroomCoursesStudentsDelete_579476, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTeachersCreate_579515 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesTeachersCreate_579517(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesTeachersCreate_579516(path: JsonNode;
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
  var valid_579518 = path.getOrDefault("courseId")
  valid_579518 = validateParameter(valid_579518, JString, required = true,
                                 default = nil)
  if valid_579518 != nil:
    section.add "courseId", valid_579518
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
  var valid_579519 = query.getOrDefault("key")
  valid_579519 = validateParameter(valid_579519, JString, required = false,
                                 default = nil)
  if valid_579519 != nil:
    section.add "key", valid_579519
  var valid_579520 = query.getOrDefault("prettyPrint")
  valid_579520 = validateParameter(valid_579520, JBool, required = false,
                                 default = newJBool(true))
  if valid_579520 != nil:
    section.add "prettyPrint", valid_579520
  var valid_579521 = query.getOrDefault("oauth_token")
  valid_579521 = validateParameter(valid_579521, JString, required = false,
                                 default = nil)
  if valid_579521 != nil:
    section.add "oauth_token", valid_579521
  var valid_579522 = query.getOrDefault("$.xgafv")
  valid_579522 = validateParameter(valid_579522, JString, required = false,
                                 default = newJString("1"))
  if valid_579522 != nil:
    section.add "$.xgafv", valid_579522
  var valid_579523 = query.getOrDefault("alt")
  valid_579523 = validateParameter(valid_579523, JString, required = false,
                                 default = newJString("json"))
  if valid_579523 != nil:
    section.add "alt", valid_579523
  var valid_579524 = query.getOrDefault("uploadType")
  valid_579524 = validateParameter(valid_579524, JString, required = false,
                                 default = nil)
  if valid_579524 != nil:
    section.add "uploadType", valid_579524
  var valid_579525 = query.getOrDefault("quotaUser")
  valid_579525 = validateParameter(valid_579525, JString, required = false,
                                 default = nil)
  if valid_579525 != nil:
    section.add "quotaUser", valid_579525
  var valid_579526 = query.getOrDefault("callback")
  valid_579526 = validateParameter(valid_579526, JString, required = false,
                                 default = nil)
  if valid_579526 != nil:
    section.add "callback", valid_579526
  var valid_579527 = query.getOrDefault("fields")
  valid_579527 = validateParameter(valid_579527, JString, required = false,
                                 default = nil)
  if valid_579527 != nil:
    section.add "fields", valid_579527
  var valid_579528 = query.getOrDefault("access_token")
  valid_579528 = validateParameter(valid_579528, JString, required = false,
                                 default = nil)
  if valid_579528 != nil:
    section.add "access_token", valid_579528
  var valid_579529 = query.getOrDefault("upload_protocol")
  valid_579529 = validateParameter(valid_579529, JString, required = false,
                                 default = nil)
  if valid_579529 != nil:
    section.add "upload_protocol", valid_579529
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

proc call*(call_579531: Call_ClassroomCoursesTeachersCreate_579515; path: JsonNode;
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
  let valid = call_579531.validator(path, query, header, formData, body)
  let scheme = call_579531.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579531.url(scheme.get, call_579531.host, call_579531.base,
                         call_579531.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579531, url, valid)

proc call*(call_579532: Call_ClassroomCoursesTeachersCreate_579515;
          courseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
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
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579533 = newJObject()
  var query_579534 = newJObject()
  var body_579535 = newJObject()
  add(query_579534, "key", newJString(key))
  add(query_579534, "prettyPrint", newJBool(prettyPrint))
  add(query_579534, "oauth_token", newJString(oauthToken))
  add(query_579534, "$.xgafv", newJString(Xgafv))
  add(query_579534, "alt", newJString(alt))
  add(query_579534, "uploadType", newJString(uploadType))
  add(query_579534, "quotaUser", newJString(quotaUser))
  add(path_579533, "courseId", newJString(courseId))
  if body != nil:
    body_579535 = body
  add(query_579534, "callback", newJString(callback))
  add(query_579534, "fields", newJString(fields))
  add(query_579534, "access_token", newJString(accessToken))
  add(query_579534, "upload_protocol", newJString(uploadProtocol))
  result = call_579532.call(path_579533, query_579534, nil, nil, body_579535)

var classroomCoursesTeachersCreate* = Call_ClassroomCoursesTeachersCreate_579515(
    name: "classroomCoursesTeachersCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/teachers",
    validator: validate_ClassroomCoursesTeachersCreate_579516, base: "/",
    url: url_ClassroomCoursesTeachersCreate_579517, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTeachersList_579494 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesTeachersList_579496(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesTeachersList_579495(path: JsonNode; query: JsonNode;
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
  var valid_579497 = path.getOrDefault("courseId")
  valid_579497 = validateParameter(valid_579497, JString, required = true,
                                 default = nil)
  if valid_579497 != nil:
    section.add "courseId", valid_579497
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
  ##   pageSize: JInt
  ##           : Maximum number of items to return. Zero means no maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : nextPageToken
  ## value returned from a previous
  ## list call, indicating that
  ## the subsequent page of results should be returned.
  ## 
  ## The list request must be
  ## otherwise identical to the one that resulted in this token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579498 = query.getOrDefault("key")
  valid_579498 = validateParameter(valid_579498, JString, required = false,
                                 default = nil)
  if valid_579498 != nil:
    section.add "key", valid_579498
  var valid_579499 = query.getOrDefault("prettyPrint")
  valid_579499 = validateParameter(valid_579499, JBool, required = false,
                                 default = newJBool(true))
  if valid_579499 != nil:
    section.add "prettyPrint", valid_579499
  var valid_579500 = query.getOrDefault("oauth_token")
  valid_579500 = validateParameter(valid_579500, JString, required = false,
                                 default = nil)
  if valid_579500 != nil:
    section.add "oauth_token", valid_579500
  var valid_579501 = query.getOrDefault("$.xgafv")
  valid_579501 = validateParameter(valid_579501, JString, required = false,
                                 default = newJString("1"))
  if valid_579501 != nil:
    section.add "$.xgafv", valid_579501
  var valid_579502 = query.getOrDefault("pageSize")
  valid_579502 = validateParameter(valid_579502, JInt, required = false, default = nil)
  if valid_579502 != nil:
    section.add "pageSize", valid_579502
  var valid_579503 = query.getOrDefault("alt")
  valid_579503 = validateParameter(valid_579503, JString, required = false,
                                 default = newJString("json"))
  if valid_579503 != nil:
    section.add "alt", valid_579503
  var valid_579504 = query.getOrDefault("uploadType")
  valid_579504 = validateParameter(valid_579504, JString, required = false,
                                 default = nil)
  if valid_579504 != nil:
    section.add "uploadType", valid_579504
  var valid_579505 = query.getOrDefault("quotaUser")
  valid_579505 = validateParameter(valid_579505, JString, required = false,
                                 default = nil)
  if valid_579505 != nil:
    section.add "quotaUser", valid_579505
  var valid_579506 = query.getOrDefault("pageToken")
  valid_579506 = validateParameter(valid_579506, JString, required = false,
                                 default = nil)
  if valid_579506 != nil:
    section.add "pageToken", valid_579506
  var valid_579507 = query.getOrDefault("callback")
  valid_579507 = validateParameter(valid_579507, JString, required = false,
                                 default = nil)
  if valid_579507 != nil:
    section.add "callback", valid_579507
  var valid_579508 = query.getOrDefault("fields")
  valid_579508 = validateParameter(valid_579508, JString, required = false,
                                 default = nil)
  if valid_579508 != nil:
    section.add "fields", valid_579508
  var valid_579509 = query.getOrDefault("access_token")
  valid_579509 = validateParameter(valid_579509, JString, required = false,
                                 default = nil)
  if valid_579509 != nil:
    section.add "access_token", valid_579509
  var valid_579510 = query.getOrDefault("upload_protocol")
  valid_579510 = validateParameter(valid_579510, JString, required = false,
                                 default = nil)
  if valid_579510 != nil:
    section.add "upload_protocol", valid_579510
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579511: Call_ClassroomCoursesTeachersList_579494; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of teachers of this course that the requester
  ## is permitted to view.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `NOT_FOUND` if the course does not exist.
  ## * `PERMISSION_DENIED` for access errors.
  ## 
  let valid = call_579511.validator(path, query, header, formData, body)
  let scheme = call_579511.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579511.url(scheme.get, call_579511.host, call_579511.base,
                         call_579511.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579511, url, valid)

proc call*(call_579512: Call_ClassroomCoursesTeachersList_579494; courseId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## classroomCoursesTeachersList
  ## Returns a list of teachers of this course that the requester
  ## is permitted to view.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `NOT_FOUND` if the course does not exist.
  ## * `PERMISSION_DENIED` for access errors.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of items to return. Zero means no maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : nextPageToken
  ## value returned from a previous
  ## list call, indicating that
  ## the subsequent page of results should be returned.
  ## 
  ## The list request must be
  ## otherwise identical to the one that resulted in this token.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579513 = newJObject()
  var query_579514 = newJObject()
  add(query_579514, "key", newJString(key))
  add(query_579514, "prettyPrint", newJBool(prettyPrint))
  add(query_579514, "oauth_token", newJString(oauthToken))
  add(query_579514, "$.xgafv", newJString(Xgafv))
  add(query_579514, "pageSize", newJInt(pageSize))
  add(query_579514, "alt", newJString(alt))
  add(query_579514, "uploadType", newJString(uploadType))
  add(query_579514, "quotaUser", newJString(quotaUser))
  add(query_579514, "pageToken", newJString(pageToken))
  add(path_579513, "courseId", newJString(courseId))
  add(query_579514, "callback", newJString(callback))
  add(query_579514, "fields", newJString(fields))
  add(query_579514, "access_token", newJString(accessToken))
  add(query_579514, "upload_protocol", newJString(uploadProtocol))
  result = call_579512.call(path_579513, query_579514, nil, nil, nil)

var classroomCoursesTeachersList* = Call_ClassroomCoursesTeachersList_579494(
    name: "classroomCoursesTeachersList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/teachers",
    validator: validate_ClassroomCoursesTeachersList_579495, base: "/",
    url: url_ClassroomCoursesTeachersList_579496, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTeachersGet_579536 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesTeachersGet_579538(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesTeachersGet_579537(path: JsonNode; query: JsonNode;
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
  ##   userId: JString (required)
  ##         : Identifier of the teacher to return. The identifier can be one of the
  ## following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_579539 = path.getOrDefault("userId")
  valid_579539 = validateParameter(valid_579539, JString, required = true,
                                 default = nil)
  if valid_579539 != nil:
    section.add "userId", valid_579539
  var valid_579540 = path.getOrDefault("courseId")
  valid_579540 = validateParameter(valid_579540, JString, required = true,
                                 default = nil)
  if valid_579540 != nil:
    section.add "courseId", valid_579540
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
  var valid_579541 = query.getOrDefault("key")
  valid_579541 = validateParameter(valid_579541, JString, required = false,
                                 default = nil)
  if valid_579541 != nil:
    section.add "key", valid_579541
  var valid_579542 = query.getOrDefault("prettyPrint")
  valid_579542 = validateParameter(valid_579542, JBool, required = false,
                                 default = newJBool(true))
  if valid_579542 != nil:
    section.add "prettyPrint", valid_579542
  var valid_579543 = query.getOrDefault("oauth_token")
  valid_579543 = validateParameter(valid_579543, JString, required = false,
                                 default = nil)
  if valid_579543 != nil:
    section.add "oauth_token", valid_579543
  var valid_579544 = query.getOrDefault("$.xgafv")
  valid_579544 = validateParameter(valid_579544, JString, required = false,
                                 default = newJString("1"))
  if valid_579544 != nil:
    section.add "$.xgafv", valid_579544
  var valid_579545 = query.getOrDefault("alt")
  valid_579545 = validateParameter(valid_579545, JString, required = false,
                                 default = newJString("json"))
  if valid_579545 != nil:
    section.add "alt", valid_579545
  var valid_579546 = query.getOrDefault("uploadType")
  valid_579546 = validateParameter(valid_579546, JString, required = false,
                                 default = nil)
  if valid_579546 != nil:
    section.add "uploadType", valid_579546
  var valid_579547 = query.getOrDefault("quotaUser")
  valid_579547 = validateParameter(valid_579547, JString, required = false,
                                 default = nil)
  if valid_579547 != nil:
    section.add "quotaUser", valid_579547
  var valid_579548 = query.getOrDefault("callback")
  valid_579548 = validateParameter(valid_579548, JString, required = false,
                                 default = nil)
  if valid_579548 != nil:
    section.add "callback", valid_579548
  var valid_579549 = query.getOrDefault("fields")
  valid_579549 = validateParameter(valid_579549, JString, required = false,
                                 default = nil)
  if valid_579549 != nil:
    section.add "fields", valid_579549
  var valid_579550 = query.getOrDefault("access_token")
  valid_579550 = validateParameter(valid_579550, JString, required = false,
                                 default = nil)
  if valid_579550 != nil:
    section.add "access_token", valid_579550
  var valid_579551 = query.getOrDefault("upload_protocol")
  valid_579551 = validateParameter(valid_579551, JString, required = false,
                                 default = nil)
  if valid_579551 != nil:
    section.add "upload_protocol", valid_579551
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579552: Call_ClassroomCoursesTeachersGet_579536; path: JsonNode;
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
  let valid = call_579552.validator(path, query, header, formData, body)
  let scheme = call_579552.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579552.url(scheme.get, call_579552.host, call_579552.base,
                         call_579552.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579552, url, valid)

proc call*(call_579553: Call_ClassroomCoursesTeachersGet_579536; userId: string;
          courseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## classroomCoursesTeachersGet
  ## Returns a teacher of a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to view
  ## teachers of this course or for access errors.
  ## * `NOT_FOUND` if no teacher of this course has the requested ID or if the
  ## course does not exist.
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
  ##   userId: string (required)
  ##         : Identifier of the teacher to return. The identifier can be one of the
  ## following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579554 = newJObject()
  var query_579555 = newJObject()
  add(query_579555, "key", newJString(key))
  add(query_579555, "prettyPrint", newJBool(prettyPrint))
  add(query_579555, "oauth_token", newJString(oauthToken))
  add(query_579555, "$.xgafv", newJString(Xgafv))
  add(query_579555, "alt", newJString(alt))
  add(query_579555, "uploadType", newJString(uploadType))
  add(query_579555, "quotaUser", newJString(quotaUser))
  add(path_579554, "userId", newJString(userId))
  add(path_579554, "courseId", newJString(courseId))
  add(query_579555, "callback", newJString(callback))
  add(query_579555, "fields", newJString(fields))
  add(query_579555, "access_token", newJString(accessToken))
  add(query_579555, "upload_protocol", newJString(uploadProtocol))
  result = call_579553.call(path_579554, query_579555, nil, nil, nil)

var classroomCoursesTeachersGet* = Call_ClassroomCoursesTeachersGet_579536(
    name: "classroomCoursesTeachersGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/teachers/{userId}",
    validator: validate_ClassroomCoursesTeachersGet_579537, base: "/",
    url: url_ClassroomCoursesTeachersGet_579538, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTeachersDelete_579556 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesTeachersDelete_579558(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesTeachersDelete_579557(path: JsonNode;
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
  ##   userId: JString (required)
  ##         : Identifier of the teacher to delete. The identifier can be one of the
  ## following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  ##   courseId: JString (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_579559 = path.getOrDefault("userId")
  valid_579559 = validateParameter(valid_579559, JString, required = true,
                                 default = nil)
  if valid_579559 != nil:
    section.add "userId", valid_579559
  var valid_579560 = path.getOrDefault("courseId")
  valid_579560 = validateParameter(valid_579560, JString, required = true,
                                 default = nil)
  if valid_579560 != nil:
    section.add "courseId", valid_579560
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
  var valid_579561 = query.getOrDefault("key")
  valid_579561 = validateParameter(valid_579561, JString, required = false,
                                 default = nil)
  if valid_579561 != nil:
    section.add "key", valid_579561
  var valid_579562 = query.getOrDefault("prettyPrint")
  valid_579562 = validateParameter(valid_579562, JBool, required = false,
                                 default = newJBool(true))
  if valid_579562 != nil:
    section.add "prettyPrint", valid_579562
  var valid_579563 = query.getOrDefault("oauth_token")
  valid_579563 = validateParameter(valid_579563, JString, required = false,
                                 default = nil)
  if valid_579563 != nil:
    section.add "oauth_token", valid_579563
  var valid_579564 = query.getOrDefault("$.xgafv")
  valid_579564 = validateParameter(valid_579564, JString, required = false,
                                 default = newJString("1"))
  if valid_579564 != nil:
    section.add "$.xgafv", valid_579564
  var valid_579565 = query.getOrDefault("alt")
  valid_579565 = validateParameter(valid_579565, JString, required = false,
                                 default = newJString("json"))
  if valid_579565 != nil:
    section.add "alt", valid_579565
  var valid_579566 = query.getOrDefault("uploadType")
  valid_579566 = validateParameter(valid_579566, JString, required = false,
                                 default = nil)
  if valid_579566 != nil:
    section.add "uploadType", valid_579566
  var valid_579567 = query.getOrDefault("quotaUser")
  valid_579567 = validateParameter(valid_579567, JString, required = false,
                                 default = nil)
  if valid_579567 != nil:
    section.add "quotaUser", valid_579567
  var valid_579568 = query.getOrDefault("callback")
  valid_579568 = validateParameter(valid_579568, JString, required = false,
                                 default = nil)
  if valid_579568 != nil:
    section.add "callback", valid_579568
  var valid_579569 = query.getOrDefault("fields")
  valid_579569 = validateParameter(valid_579569, JString, required = false,
                                 default = nil)
  if valid_579569 != nil:
    section.add "fields", valid_579569
  var valid_579570 = query.getOrDefault("access_token")
  valid_579570 = validateParameter(valid_579570, JString, required = false,
                                 default = nil)
  if valid_579570 != nil:
    section.add "access_token", valid_579570
  var valid_579571 = query.getOrDefault("upload_protocol")
  valid_579571 = validateParameter(valid_579571, JString, required = false,
                                 default = nil)
  if valid_579571 != nil:
    section.add "upload_protocol", valid_579571
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579572: Call_ClassroomCoursesTeachersDelete_579556; path: JsonNode;
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
  let valid = call_579572.validator(path, query, header, formData, body)
  let scheme = call_579572.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579572.url(scheme.get, call_579572.host, call_579572.base,
                         call_579572.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579572, url, valid)

proc call*(call_579573: Call_ClassroomCoursesTeachersDelete_579556; userId: string;
          courseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   userId: string (required)
  ##         : Identifier of the teacher to delete. The identifier can be one of the
  ## following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579574 = newJObject()
  var query_579575 = newJObject()
  add(query_579575, "key", newJString(key))
  add(query_579575, "prettyPrint", newJBool(prettyPrint))
  add(query_579575, "oauth_token", newJString(oauthToken))
  add(query_579575, "$.xgafv", newJString(Xgafv))
  add(query_579575, "alt", newJString(alt))
  add(query_579575, "uploadType", newJString(uploadType))
  add(query_579575, "quotaUser", newJString(quotaUser))
  add(path_579574, "userId", newJString(userId))
  add(path_579574, "courseId", newJString(courseId))
  add(query_579575, "callback", newJString(callback))
  add(query_579575, "fields", newJString(fields))
  add(query_579575, "access_token", newJString(accessToken))
  add(query_579575, "upload_protocol", newJString(uploadProtocol))
  result = call_579573.call(path_579574, query_579575, nil, nil, nil)

var classroomCoursesTeachersDelete* = Call_ClassroomCoursesTeachersDelete_579556(
    name: "classroomCoursesTeachersDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/teachers/{userId}",
    validator: validate_ClassroomCoursesTeachersDelete_579557, base: "/",
    url: url_ClassroomCoursesTeachersDelete_579558, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTopicsCreate_579597 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesTopicsCreate_579599(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesTopicsCreate_579598(path: JsonNode; query: JsonNode;
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
  var valid_579600 = path.getOrDefault("courseId")
  valid_579600 = validateParameter(valid_579600, JString, required = true,
                                 default = nil)
  if valid_579600 != nil:
    section.add "courseId", valid_579600
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
  var valid_579601 = query.getOrDefault("key")
  valid_579601 = validateParameter(valid_579601, JString, required = false,
                                 default = nil)
  if valid_579601 != nil:
    section.add "key", valid_579601
  var valid_579602 = query.getOrDefault("prettyPrint")
  valid_579602 = validateParameter(valid_579602, JBool, required = false,
                                 default = newJBool(true))
  if valid_579602 != nil:
    section.add "prettyPrint", valid_579602
  var valid_579603 = query.getOrDefault("oauth_token")
  valid_579603 = validateParameter(valid_579603, JString, required = false,
                                 default = nil)
  if valid_579603 != nil:
    section.add "oauth_token", valid_579603
  var valid_579604 = query.getOrDefault("$.xgafv")
  valid_579604 = validateParameter(valid_579604, JString, required = false,
                                 default = newJString("1"))
  if valid_579604 != nil:
    section.add "$.xgafv", valid_579604
  var valid_579605 = query.getOrDefault("alt")
  valid_579605 = validateParameter(valid_579605, JString, required = false,
                                 default = newJString("json"))
  if valid_579605 != nil:
    section.add "alt", valid_579605
  var valid_579606 = query.getOrDefault("uploadType")
  valid_579606 = validateParameter(valid_579606, JString, required = false,
                                 default = nil)
  if valid_579606 != nil:
    section.add "uploadType", valid_579606
  var valid_579607 = query.getOrDefault("quotaUser")
  valid_579607 = validateParameter(valid_579607, JString, required = false,
                                 default = nil)
  if valid_579607 != nil:
    section.add "quotaUser", valid_579607
  var valid_579608 = query.getOrDefault("callback")
  valid_579608 = validateParameter(valid_579608, JString, required = false,
                                 default = nil)
  if valid_579608 != nil:
    section.add "callback", valid_579608
  var valid_579609 = query.getOrDefault("fields")
  valid_579609 = validateParameter(valid_579609, JString, required = false,
                                 default = nil)
  if valid_579609 != nil:
    section.add "fields", valid_579609
  var valid_579610 = query.getOrDefault("access_token")
  valid_579610 = validateParameter(valid_579610, JString, required = false,
                                 default = nil)
  if valid_579610 != nil:
    section.add "access_token", valid_579610
  var valid_579611 = query.getOrDefault("upload_protocol")
  valid_579611 = validateParameter(valid_579611, JString, required = false,
                                 default = nil)
  if valid_579611 != nil:
    section.add "upload_protocol", valid_579611
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

proc call*(call_579613: Call_ClassroomCoursesTopicsCreate_579597; path: JsonNode;
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
  let valid = call_579613.validator(path, query, header, formData, body)
  let scheme = call_579613.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579613.url(scheme.get, call_579613.host, call_579613.base,
                         call_579613.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579613, url, valid)

proc call*(call_579614: Call_ClassroomCoursesTopicsCreate_579597; courseId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579615 = newJObject()
  var query_579616 = newJObject()
  var body_579617 = newJObject()
  add(query_579616, "key", newJString(key))
  add(query_579616, "prettyPrint", newJBool(prettyPrint))
  add(query_579616, "oauth_token", newJString(oauthToken))
  add(query_579616, "$.xgafv", newJString(Xgafv))
  add(query_579616, "alt", newJString(alt))
  add(query_579616, "uploadType", newJString(uploadType))
  add(query_579616, "quotaUser", newJString(quotaUser))
  add(path_579615, "courseId", newJString(courseId))
  if body != nil:
    body_579617 = body
  add(query_579616, "callback", newJString(callback))
  add(query_579616, "fields", newJString(fields))
  add(query_579616, "access_token", newJString(accessToken))
  add(query_579616, "upload_protocol", newJString(uploadProtocol))
  result = call_579614.call(path_579615, query_579616, nil, nil, body_579617)

var classroomCoursesTopicsCreate* = Call_ClassroomCoursesTopicsCreate_579597(
    name: "classroomCoursesTopicsCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/topics",
    validator: validate_ClassroomCoursesTopicsCreate_579598, base: "/",
    url: url_ClassroomCoursesTopicsCreate_579599, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTopicsList_579576 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesTopicsList_579578(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesTopicsList_579577(path: JsonNode; query: JsonNode;
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
  var valid_579579 = path.getOrDefault("courseId")
  valid_579579 = validateParameter(valid_579579, JString, required = true,
                                 default = nil)
  if valid_579579 != nil:
    section.add "courseId", valid_579579
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
  ##   pageSize: JInt
  ##           : Maximum number of items to return. Zero or unspecified indicates that the
  ## server may assign a maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : nextPageToken
  ## value returned from a previous
  ## list call,
  ## indicating that the subsequent page of results should be returned.
  ## 
  ## The list request
  ## must be otherwise identical to the one that resulted in this token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579580 = query.getOrDefault("key")
  valid_579580 = validateParameter(valid_579580, JString, required = false,
                                 default = nil)
  if valid_579580 != nil:
    section.add "key", valid_579580
  var valid_579581 = query.getOrDefault("prettyPrint")
  valid_579581 = validateParameter(valid_579581, JBool, required = false,
                                 default = newJBool(true))
  if valid_579581 != nil:
    section.add "prettyPrint", valid_579581
  var valid_579582 = query.getOrDefault("oauth_token")
  valid_579582 = validateParameter(valid_579582, JString, required = false,
                                 default = nil)
  if valid_579582 != nil:
    section.add "oauth_token", valid_579582
  var valid_579583 = query.getOrDefault("$.xgafv")
  valid_579583 = validateParameter(valid_579583, JString, required = false,
                                 default = newJString("1"))
  if valid_579583 != nil:
    section.add "$.xgafv", valid_579583
  var valid_579584 = query.getOrDefault("pageSize")
  valid_579584 = validateParameter(valid_579584, JInt, required = false, default = nil)
  if valid_579584 != nil:
    section.add "pageSize", valid_579584
  var valid_579585 = query.getOrDefault("alt")
  valid_579585 = validateParameter(valid_579585, JString, required = false,
                                 default = newJString("json"))
  if valid_579585 != nil:
    section.add "alt", valid_579585
  var valid_579586 = query.getOrDefault("uploadType")
  valid_579586 = validateParameter(valid_579586, JString, required = false,
                                 default = nil)
  if valid_579586 != nil:
    section.add "uploadType", valid_579586
  var valid_579587 = query.getOrDefault("quotaUser")
  valid_579587 = validateParameter(valid_579587, JString, required = false,
                                 default = nil)
  if valid_579587 != nil:
    section.add "quotaUser", valid_579587
  var valid_579588 = query.getOrDefault("pageToken")
  valid_579588 = validateParameter(valid_579588, JString, required = false,
                                 default = nil)
  if valid_579588 != nil:
    section.add "pageToken", valid_579588
  var valid_579589 = query.getOrDefault("callback")
  valid_579589 = validateParameter(valid_579589, JString, required = false,
                                 default = nil)
  if valid_579589 != nil:
    section.add "callback", valid_579589
  var valid_579590 = query.getOrDefault("fields")
  valid_579590 = validateParameter(valid_579590, JString, required = false,
                                 default = nil)
  if valid_579590 != nil:
    section.add "fields", valid_579590
  var valid_579591 = query.getOrDefault("access_token")
  valid_579591 = validateParameter(valid_579591, JString, required = false,
                                 default = nil)
  if valid_579591 != nil:
    section.add "access_token", valid_579591
  var valid_579592 = query.getOrDefault("upload_protocol")
  valid_579592 = validateParameter(valid_579592, JString, required = false,
                                 default = nil)
  if valid_579592 != nil:
    section.add "upload_protocol", valid_579592
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579593: Call_ClassroomCoursesTopicsList_579576; path: JsonNode;
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
  let valid = call_579593.validator(path, query, header, formData, body)
  let scheme = call_579593.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579593.url(scheme.get, call_579593.host, call_579593.base,
                         call_579593.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579593, url, valid)

proc call*(call_579594: Call_ClassroomCoursesTopicsList_579576; courseId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## classroomCoursesTopicsList
  ## Returns the list of topics that the requester is permitted to view.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access
  ## the requested course or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course does not exist.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of items to return. Zero or unspecified indicates that the
  ## server may assign a maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : nextPageToken
  ## value returned from a previous
  ## list call,
  ## indicating that the subsequent page of results should be returned.
  ## 
  ## The list request
  ## must be otherwise identical to the one that resulted in this token.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579595 = newJObject()
  var query_579596 = newJObject()
  add(query_579596, "key", newJString(key))
  add(query_579596, "prettyPrint", newJBool(prettyPrint))
  add(query_579596, "oauth_token", newJString(oauthToken))
  add(query_579596, "$.xgafv", newJString(Xgafv))
  add(query_579596, "pageSize", newJInt(pageSize))
  add(query_579596, "alt", newJString(alt))
  add(query_579596, "uploadType", newJString(uploadType))
  add(query_579596, "quotaUser", newJString(quotaUser))
  add(query_579596, "pageToken", newJString(pageToken))
  add(path_579595, "courseId", newJString(courseId))
  add(query_579596, "callback", newJString(callback))
  add(query_579596, "fields", newJString(fields))
  add(query_579596, "access_token", newJString(accessToken))
  add(query_579596, "upload_protocol", newJString(uploadProtocol))
  result = call_579594.call(path_579595, query_579596, nil, nil, nil)

var classroomCoursesTopicsList* = Call_ClassroomCoursesTopicsList_579576(
    name: "classroomCoursesTopicsList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/topics",
    validator: validate_ClassroomCoursesTopicsList_579577, base: "/",
    url: url_ClassroomCoursesTopicsList_579578, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTopicsGet_579618 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesTopicsGet_579620(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesTopicsGet_579619(path: JsonNode; query: JsonNode;
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
  var valid_579621 = path.getOrDefault("id")
  valid_579621 = validateParameter(valid_579621, JString, required = true,
                                 default = nil)
  if valid_579621 != nil:
    section.add "id", valid_579621
  var valid_579622 = path.getOrDefault("courseId")
  valid_579622 = validateParameter(valid_579622, JString, required = true,
                                 default = nil)
  if valid_579622 != nil:
    section.add "courseId", valid_579622
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
  var valid_579623 = query.getOrDefault("key")
  valid_579623 = validateParameter(valid_579623, JString, required = false,
                                 default = nil)
  if valid_579623 != nil:
    section.add "key", valid_579623
  var valid_579624 = query.getOrDefault("prettyPrint")
  valid_579624 = validateParameter(valid_579624, JBool, required = false,
                                 default = newJBool(true))
  if valid_579624 != nil:
    section.add "prettyPrint", valid_579624
  var valid_579625 = query.getOrDefault("oauth_token")
  valid_579625 = validateParameter(valid_579625, JString, required = false,
                                 default = nil)
  if valid_579625 != nil:
    section.add "oauth_token", valid_579625
  var valid_579626 = query.getOrDefault("$.xgafv")
  valid_579626 = validateParameter(valid_579626, JString, required = false,
                                 default = newJString("1"))
  if valid_579626 != nil:
    section.add "$.xgafv", valid_579626
  var valid_579627 = query.getOrDefault("alt")
  valid_579627 = validateParameter(valid_579627, JString, required = false,
                                 default = newJString("json"))
  if valid_579627 != nil:
    section.add "alt", valid_579627
  var valid_579628 = query.getOrDefault("uploadType")
  valid_579628 = validateParameter(valid_579628, JString, required = false,
                                 default = nil)
  if valid_579628 != nil:
    section.add "uploadType", valid_579628
  var valid_579629 = query.getOrDefault("quotaUser")
  valid_579629 = validateParameter(valid_579629, JString, required = false,
                                 default = nil)
  if valid_579629 != nil:
    section.add "quotaUser", valid_579629
  var valid_579630 = query.getOrDefault("callback")
  valid_579630 = validateParameter(valid_579630, JString, required = false,
                                 default = nil)
  if valid_579630 != nil:
    section.add "callback", valid_579630
  var valid_579631 = query.getOrDefault("fields")
  valid_579631 = validateParameter(valid_579631, JString, required = false,
                                 default = nil)
  if valid_579631 != nil:
    section.add "fields", valid_579631
  var valid_579632 = query.getOrDefault("access_token")
  valid_579632 = validateParameter(valid_579632, JString, required = false,
                                 default = nil)
  if valid_579632 != nil:
    section.add "access_token", valid_579632
  var valid_579633 = query.getOrDefault("upload_protocol")
  valid_579633 = validateParameter(valid_579633, JString, required = false,
                                 default = nil)
  if valid_579633 != nil:
    section.add "upload_protocol", valid_579633
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579634: Call_ClassroomCoursesTopicsGet_579618; path: JsonNode;
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
  let valid = call_579634.validator(path, query, header, formData, body)
  let scheme = call_579634.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579634.url(scheme.get, call_579634.host, call_579634.base,
                         call_579634.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579634, url, valid)

proc call*(call_579635: Call_ClassroomCoursesTopicsGet_579618; id: string;
          courseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## classroomCoursesTopicsGet
  ## Returns a topic.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or topic, or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course or topic does not exist.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   id: string (required)
  ##     : Identifier of the topic.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579636 = newJObject()
  var query_579637 = newJObject()
  add(query_579637, "key", newJString(key))
  add(query_579637, "prettyPrint", newJBool(prettyPrint))
  add(query_579637, "oauth_token", newJString(oauthToken))
  add(query_579637, "$.xgafv", newJString(Xgafv))
  add(path_579636, "id", newJString(id))
  add(query_579637, "alt", newJString(alt))
  add(query_579637, "uploadType", newJString(uploadType))
  add(query_579637, "quotaUser", newJString(quotaUser))
  add(path_579636, "courseId", newJString(courseId))
  add(query_579637, "callback", newJString(callback))
  add(query_579637, "fields", newJString(fields))
  add(query_579637, "access_token", newJString(accessToken))
  add(query_579637, "upload_protocol", newJString(uploadProtocol))
  result = call_579635.call(path_579636, query_579637, nil, nil, nil)

var classroomCoursesTopicsGet* = Call_ClassroomCoursesTopicsGet_579618(
    name: "classroomCoursesTopicsGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/topics/{id}",
    validator: validate_ClassroomCoursesTopicsGet_579619, base: "/",
    url: url_ClassroomCoursesTopicsGet_579620, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTopicsPatch_579658 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesTopicsPatch_579660(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesTopicsPatch_579659(path: JsonNode; query: JsonNode;
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
  var valid_579661 = path.getOrDefault("id")
  valid_579661 = validateParameter(valid_579661, JString, required = true,
                                 default = nil)
  if valid_579661 != nil:
    section.add "id", valid_579661
  var valid_579662 = path.getOrDefault("courseId")
  valid_579662 = validateParameter(valid_579662, JString, required = true,
                                 default = nil)
  if valid_579662 != nil:
    section.add "courseId", valid_579662
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
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579663 = query.getOrDefault("key")
  valid_579663 = validateParameter(valid_579663, JString, required = false,
                                 default = nil)
  if valid_579663 != nil:
    section.add "key", valid_579663
  var valid_579664 = query.getOrDefault("prettyPrint")
  valid_579664 = validateParameter(valid_579664, JBool, required = false,
                                 default = newJBool(true))
  if valid_579664 != nil:
    section.add "prettyPrint", valid_579664
  var valid_579665 = query.getOrDefault("oauth_token")
  valid_579665 = validateParameter(valid_579665, JString, required = false,
                                 default = nil)
  if valid_579665 != nil:
    section.add "oauth_token", valid_579665
  var valid_579666 = query.getOrDefault("$.xgafv")
  valid_579666 = validateParameter(valid_579666, JString, required = false,
                                 default = newJString("1"))
  if valid_579666 != nil:
    section.add "$.xgafv", valid_579666
  var valid_579667 = query.getOrDefault("alt")
  valid_579667 = validateParameter(valid_579667, JString, required = false,
                                 default = newJString("json"))
  if valid_579667 != nil:
    section.add "alt", valid_579667
  var valid_579668 = query.getOrDefault("uploadType")
  valid_579668 = validateParameter(valid_579668, JString, required = false,
                                 default = nil)
  if valid_579668 != nil:
    section.add "uploadType", valid_579668
  var valid_579669 = query.getOrDefault("quotaUser")
  valid_579669 = validateParameter(valid_579669, JString, required = false,
                                 default = nil)
  if valid_579669 != nil:
    section.add "quotaUser", valid_579669
  var valid_579670 = query.getOrDefault("updateMask")
  valid_579670 = validateParameter(valid_579670, JString, required = false,
                                 default = nil)
  if valid_579670 != nil:
    section.add "updateMask", valid_579670
  var valid_579671 = query.getOrDefault("callback")
  valid_579671 = validateParameter(valid_579671, JString, required = false,
                                 default = nil)
  if valid_579671 != nil:
    section.add "callback", valid_579671
  var valid_579672 = query.getOrDefault("fields")
  valid_579672 = validateParameter(valid_579672, JString, required = false,
                                 default = nil)
  if valid_579672 != nil:
    section.add "fields", valid_579672
  var valid_579673 = query.getOrDefault("access_token")
  valid_579673 = validateParameter(valid_579673, JString, required = false,
                                 default = nil)
  if valid_579673 != nil:
    section.add "access_token", valid_579673
  var valid_579674 = query.getOrDefault("upload_protocol")
  valid_579674 = validateParameter(valid_579674, JString, required = false,
                                 default = nil)
  if valid_579674 != nil:
    section.add "upload_protocol", valid_579674
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

proc call*(call_579676: Call_ClassroomCoursesTopicsPatch_579658; path: JsonNode;
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
  let valid = call_579676.validator(path, query, header, formData, body)
  let scheme = call_579676.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579676.url(scheme.get, call_579676.host, call_579676.base,
                         call_579676.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579676, url, valid)

proc call*(call_579677: Call_ClassroomCoursesTopicsPatch_579658; id: string;
          courseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; updateMask: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## classroomCoursesTopicsPatch
  ## Updates one or more fields of a topic.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting developer project did not create
  ## the corresponding topic or for access errors.
  ## * `INVALID_ARGUMENT` if the request is malformed.
  ## * `NOT_FOUND` if the requested course or topic does not exist
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   id: string (required)
  ##     : Identifier of the topic.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579678 = newJObject()
  var query_579679 = newJObject()
  var body_579680 = newJObject()
  add(query_579679, "key", newJString(key))
  add(query_579679, "prettyPrint", newJBool(prettyPrint))
  add(query_579679, "oauth_token", newJString(oauthToken))
  add(query_579679, "$.xgafv", newJString(Xgafv))
  add(path_579678, "id", newJString(id))
  add(query_579679, "alt", newJString(alt))
  add(query_579679, "uploadType", newJString(uploadType))
  add(query_579679, "quotaUser", newJString(quotaUser))
  add(query_579679, "updateMask", newJString(updateMask))
  add(path_579678, "courseId", newJString(courseId))
  if body != nil:
    body_579680 = body
  add(query_579679, "callback", newJString(callback))
  add(query_579679, "fields", newJString(fields))
  add(query_579679, "access_token", newJString(accessToken))
  add(query_579679, "upload_protocol", newJString(uploadProtocol))
  result = call_579677.call(path_579678, query_579679, nil, nil, body_579680)

var classroomCoursesTopicsPatch* = Call_ClassroomCoursesTopicsPatch_579658(
    name: "classroomCoursesTopicsPatch", meth: HttpMethod.HttpPatch,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/topics/{id}",
    validator: validate_ClassroomCoursesTopicsPatch_579659, base: "/",
    url: url_ClassroomCoursesTopicsPatch_579660, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTopicsDelete_579638 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesTopicsDelete_579640(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesTopicsDelete_579639(path: JsonNode; query: JsonNode;
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
  var valid_579641 = path.getOrDefault("id")
  valid_579641 = validateParameter(valid_579641, JString, required = true,
                                 default = nil)
  if valid_579641 != nil:
    section.add "id", valid_579641
  var valid_579642 = path.getOrDefault("courseId")
  valid_579642 = validateParameter(valid_579642, JString, required = true,
                                 default = nil)
  if valid_579642 != nil:
    section.add "courseId", valid_579642
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
  var valid_579643 = query.getOrDefault("key")
  valid_579643 = validateParameter(valid_579643, JString, required = false,
                                 default = nil)
  if valid_579643 != nil:
    section.add "key", valid_579643
  var valid_579644 = query.getOrDefault("prettyPrint")
  valid_579644 = validateParameter(valid_579644, JBool, required = false,
                                 default = newJBool(true))
  if valid_579644 != nil:
    section.add "prettyPrint", valid_579644
  var valid_579645 = query.getOrDefault("oauth_token")
  valid_579645 = validateParameter(valid_579645, JString, required = false,
                                 default = nil)
  if valid_579645 != nil:
    section.add "oauth_token", valid_579645
  var valid_579646 = query.getOrDefault("$.xgafv")
  valid_579646 = validateParameter(valid_579646, JString, required = false,
                                 default = newJString("1"))
  if valid_579646 != nil:
    section.add "$.xgafv", valid_579646
  var valid_579647 = query.getOrDefault("alt")
  valid_579647 = validateParameter(valid_579647, JString, required = false,
                                 default = newJString("json"))
  if valid_579647 != nil:
    section.add "alt", valid_579647
  var valid_579648 = query.getOrDefault("uploadType")
  valid_579648 = validateParameter(valid_579648, JString, required = false,
                                 default = nil)
  if valid_579648 != nil:
    section.add "uploadType", valid_579648
  var valid_579649 = query.getOrDefault("quotaUser")
  valid_579649 = validateParameter(valid_579649, JString, required = false,
                                 default = nil)
  if valid_579649 != nil:
    section.add "quotaUser", valid_579649
  var valid_579650 = query.getOrDefault("callback")
  valid_579650 = validateParameter(valid_579650, JString, required = false,
                                 default = nil)
  if valid_579650 != nil:
    section.add "callback", valid_579650
  var valid_579651 = query.getOrDefault("fields")
  valid_579651 = validateParameter(valid_579651, JString, required = false,
                                 default = nil)
  if valid_579651 != nil:
    section.add "fields", valid_579651
  var valid_579652 = query.getOrDefault("access_token")
  valid_579652 = validateParameter(valid_579652, JString, required = false,
                                 default = nil)
  if valid_579652 != nil:
    section.add "access_token", valid_579652
  var valid_579653 = query.getOrDefault("upload_protocol")
  valid_579653 = validateParameter(valid_579653, JString, required = false,
                                 default = nil)
  if valid_579653 != nil:
    section.add "upload_protocol", valid_579653
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579654: Call_ClassroomCoursesTopicsDelete_579638; path: JsonNode;
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
  let valid = call_579654.validator(path, query, header, formData, body)
  let scheme = call_579654.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579654.url(scheme.get, call_579654.host, call_579654.base,
                         call_579654.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579654, url, valid)

proc call*(call_579655: Call_ClassroomCoursesTopicsDelete_579638; id: string;
          courseId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   id: string (required)
  ##     : Identifier of the topic to delete.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   courseId: string (required)
  ##           : Identifier of the course.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579656 = newJObject()
  var query_579657 = newJObject()
  add(query_579657, "key", newJString(key))
  add(query_579657, "prettyPrint", newJBool(prettyPrint))
  add(query_579657, "oauth_token", newJString(oauthToken))
  add(query_579657, "$.xgafv", newJString(Xgafv))
  add(path_579656, "id", newJString(id))
  add(query_579657, "alt", newJString(alt))
  add(query_579657, "uploadType", newJString(uploadType))
  add(query_579657, "quotaUser", newJString(quotaUser))
  add(path_579656, "courseId", newJString(courseId))
  add(query_579657, "callback", newJString(callback))
  add(query_579657, "fields", newJString(fields))
  add(query_579657, "access_token", newJString(accessToken))
  add(query_579657, "upload_protocol", newJString(uploadProtocol))
  result = call_579655.call(path_579656, query_579657, nil, nil, nil)

var classroomCoursesTopicsDelete* = Call_ClassroomCoursesTopicsDelete_579638(
    name: "classroomCoursesTopicsDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/topics/{id}",
    validator: validate_ClassroomCoursesTopicsDelete_579639, base: "/",
    url: url_ClassroomCoursesTopicsDelete_579640, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesUpdate_579700 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesUpdate_579702(protocol: Scheme; host: string; base: string;
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

proc validate_ClassroomCoursesUpdate_579701(path: JsonNode; query: JsonNode;
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
  var valid_579703 = path.getOrDefault("id")
  valid_579703 = validateParameter(valid_579703, JString, required = true,
                                 default = nil)
  if valid_579703 != nil:
    section.add "id", valid_579703
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
  var valid_579704 = query.getOrDefault("key")
  valid_579704 = validateParameter(valid_579704, JString, required = false,
                                 default = nil)
  if valid_579704 != nil:
    section.add "key", valid_579704
  var valid_579705 = query.getOrDefault("prettyPrint")
  valid_579705 = validateParameter(valid_579705, JBool, required = false,
                                 default = newJBool(true))
  if valid_579705 != nil:
    section.add "prettyPrint", valid_579705
  var valid_579706 = query.getOrDefault("oauth_token")
  valid_579706 = validateParameter(valid_579706, JString, required = false,
                                 default = nil)
  if valid_579706 != nil:
    section.add "oauth_token", valid_579706
  var valid_579707 = query.getOrDefault("$.xgafv")
  valid_579707 = validateParameter(valid_579707, JString, required = false,
                                 default = newJString("1"))
  if valid_579707 != nil:
    section.add "$.xgafv", valid_579707
  var valid_579708 = query.getOrDefault("alt")
  valid_579708 = validateParameter(valid_579708, JString, required = false,
                                 default = newJString("json"))
  if valid_579708 != nil:
    section.add "alt", valid_579708
  var valid_579709 = query.getOrDefault("uploadType")
  valid_579709 = validateParameter(valid_579709, JString, required = false,
                                 default = nil)
  if valid_579709 != nil:
    section.add "uploadType", valid_579709
  var valid_579710 = query.getOrDefault("quotaUser")
  valid_579710 = validateParameter(valid_579710, JString, required = false,
                                 default = nil)
  if valid_579710 != nil:
    section.add "quotaUser", valid_579710
  var valid_579711 = query.getOrDefault("callback")
  valid_579711 = validateParameter(valid_579711, JString, required = false,
                                 default = nil)
  if valid_579711 != nil:
    section.add "callback", valid_579711
  var valid_579712 = query.getOrDefault("fields")
  valid_579712 = validateParameter(valid_579712, JString, required = false,
                                 default = nil)
  if valid_579712 != nil:
    section.add "fields", valid_579712
  var valid_579713 = query.getOrDefault("access_token")
  valid_579713 = validateParameter(valid_579713, JString, required = false,
                                 default = nil)
  if valid_579713 != nil:
    section.add "access_token", valid_579713
  var valid_579714 = query.getOrDefault("upload_protocol")
  valid_579714 = validateParameter(valid_579714, JString, required = false,
                                 default = nil)
  if valid_579714 != nil:
    section.add "upload_protocol", valid_579714
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

proc call*(call_579716: Call_ClassroomCoursesUpdate_579700; path: JsonNode;
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
  let valid = call_579716.validator(path, query, header, formData, body)
  let scheme = call_579716.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579716.url(scheme.get, call_579716.host, call_579716.base,
                         call_579716.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579716, url, valid)

proc call*(call_579717: Call_ClassroomCoursesUpdate_579700; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   id: string (required)
  ##     : Identifier of the course to update.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579718 = newJObject()
  var query_579719 = newJObject()
  var body_579720 = newJObject()
  add(query_579719, "key", newJString(key))
  add(query_579719, "prettyPrint", newJBool(prettyPrint))
  add(query_579719, "oauth_token", newJString(oauthToken))
  add(query_579719, "$.xgafv", newJString(Xgafv))
  add(path_579718, "id", newJString(id))
  add(query_579719, "alt", newJString(alt))
  add(query_579719, "uploadType", newJString(uploadType))
  add(query_579719, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579720 = body
  add(query_579719, "callback", newJString(callback))
  add(query_579719, "fields", newJString(fields))
  add(query_579719, "access_token", newJString(accessToken))
  add(query_579719, "upload_protocol", newJString(uploadProtocol))
  result = call_579717.call(path_579718, query_579719, nil, nil, body_579720)

var classroomCoursesUpdate* = Call_ClassroomCoursesUpdate_579700(
    name: "classroomCoursesUpdate", meth: HttpMethod.HttpPut,
    host: "classroom.googleapis.com", route: "/v1/courses/{id}",
    validator: validate_ClassroomCoursesUpdate_579701, base: "/",
    url: url_ClassroomCoursesUpdate_579702, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesGet_579681 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesGet_579683(protocol: Scheme; host: string; base: string;
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

proc validate_ClassroomCoursesGet_579682(path: JsonNode; query: JsonNode;
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
  var valid_579684 = path.getOrDefault("id")
  valid_579684 = validateParameter(valid_579684, JString, required = true,
                                 default = nil)
  if valid_579684 != nil:
    section.add "id", valid_579684
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
  var valid_579685 = query.getOrDefault("key")
  valid_579685 = validateParameter(valid_579685, JString, required = false,
                                 default = nil)
  if valid_579685 != nil:
    section.add "key", valid_579685
  var valid_579686 = query.getOrDefault("prettyPrint")
  valid_579686 = validateParameter(valid_579686, JBool, required = false,
                                 default = newJBool(true))
  if valid_579686 != nil:
    section.add "prettyPrint", valid_579686
  var valid_579687 = query.getOrDefault("oauth_token")
  valid_579687 = validateParameter(valid_579687, JString, required = false,
                                 default = nil)
  if valid_579687 != nil:
    section.add "oauth_token", valid_579687
  var valid_579688 = query.getOrDefault("$.xgafv")
  valid_579688 = validateParameter(valid_579688, JString, required = false,
                                 default = newJString("1"))
  if valid_579688 != nil:
    section.add "$.xgafv", valid_579688
  var valid_579689 = query.getOrDefault("alt")
  valid_579689 = validateParameter(valid_579689, JString, required = false,
                                 default = newJString("json"))
  if valid_579689 != nil:
    section.add "alt", valid_579689
  var valid_579690 = query.getOrDefault("uploadType")
  valid_579690 = validateParameter(valid_579690, JString, required = false,
                                 default = nil)
  if valid_579690 != nil:
    section.add "uploadType", valid_579690
  var valid_579691 = query.getOrDefault("quotaUser")
  valid_579691 = validateParameter(valid_579691, JString, required = false,
                                 default = nil)
  if valid_579691 != nil:
    section.add "quotaUser", valid_579691
  var valid_579692 = query.getOrDefault("callback")
  valid_579692 = validateParameter(valid_579692, JString, required = false,
                                 default = nil)
  if valid_579692 != nil:
    section.add "callback", valid_579692
  var valid_579693 = query.getOrDefault("fields")
  valid_579693 = validateParameter(valid_579693, JString, required = false,
                                 default = nil)
  if valid_579693 != nil:
    section.add "fields", valid_579693
  var valid_579694 = query.getOrDefault("access_token")
  valid_579694 = validateParameter(valid_579694, JString, required = false,
                                 default = nil)
  if valid_579694 != nil:
    section.add "access_token", valid_579694
  var valid_579695 = query.getOrDefault("upload_protocol")
  valid_579695 = validateParameter(valid_579695, JString, required = false,
                                 default = nil)
  if valid_579695 != nil:
    section.add "upload_protocol", valid_579695
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579696: Call_ClassroomCoursesGet_579681; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or for access errors.
  ## * `NOT_FOUND` if no course exists with the requested ID.
  ## 
  let valid = call_579696.validator(path, query, header, formData, body)
  let scheme = call_579696.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579696.url(scheme.get, call_579696.host, call_579696.base,
                         call_579696.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579696, url, valid)

proc call*(call_579697: Call_ClassroomCoursesGet_579681; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## classroomCoursesGet
  ## Returns a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or for access errors.
  ## * `NOT_FOUND` if no course exists with the requested ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   id: string (required)
  ##     : Identifier of the course to return.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
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
  var path_579698 = newJObject()
  var query_579699 = newJObject()
  add(query_579699, "key", newJString(key))
  add(query_579699, "prettyPrint", newJBool(prettyPrint))
  add(query_579699, "oauth_token", newJString(oauthToken))
  add(query_579699, "$.xgafv", newJString(Xgafv))
  add(path_579698, "id", newJString(id))
  add(query_579699, "alt", newJString(alt))
  add(query_579699, "uploadType", newJString(uploadType))
  add(query_579699, "quotaUser", newJString(quotaUser))
  add(query_579699, "callback", newJString(callback))
  add(query_579699, "fields", newJString(fields))
  add(query_579699, "access_token", newJString(accessToken))
  add(query_579699, "upload_protocol", newJString(uploadProtocol))
  result = call_579697.call(path_579698, query_579699, nil, nil, nil)

var classroomCoursesGet* = Call_ClassroomCoursesGet_579681(
    name: "classroomCoursesGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/courses/{id}",
    validator: validate_ClassroomCoursesGet_579682, base: "/",
    url: url_ClassroomCoursesGet_579683, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesPatch_579740 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesPatch_579742(protocol: Scheme; host: string; base: string;
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

proc validate_ClassroomCoursesPatch_579741(path: JsonNode; query: JsonNode;
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
  var valid_579743 = path.getOrDefault("id")
  valid_579743 = validateParameter(valid_579743, JString, required = true,
                                 default = nil)
  if valid_579743 != nil:
    section.add "id", valid_579743
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
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579744 = query.getOrDefault("key")
  valid_579744 = validateParameter(valid_579744, JString, required = false,
                                 default = nil)
  if valid_579744 != nil:
    section.add "key", valid_579744
  var valid_579745 = query.getOrDefault("prettyPrint")
  valid_579745 = validateParameter(valid_579745, JBool, required = false,
                                 default = newJBool(true))
  if valid_579745 != nil:
    section.add "prettyPrint", valid_579745
  var valid_579746 = query.getOrDefault("oauth_token")
  valid_579746 = validateParameter(valid_579746, JString, required = false,
                                 default = nil)
  if valid_579746 != nil:
    section.add "oauth_token", valid_579746
  var valid_579747 = query.getOrDefault("$.xgafv")
  valid_579747 = validateParameter(valid_579747, JString, required = false,
                                 default = newJString("1"))
  if valid_579747 != nil:
    section.add "$.xgafv", valid_579747
  var valid_579748 = query.getOrDefault("alt")
  valid_579748 = validateParameter(valid_579748, JString, required = false,
                                 default = newJString("json"))
  if valid_579748 != nil:
    section.add "alt", valid_579748
  var valid_579749 = query.getOrDefault("uploadType")
  valid_579749 = validateParameter(valid_579749, JString, required = false,
                                 default = nil)
  if valid_579749 != nil:
    section.add "uploadType", valid_579749
  var valid_579750 = query.getOrDefault("quotaUser")
  valid_579750 = validateParameter(valid_579750, JString, required = false,
                                 default = nil)
  if valid_579750 != nil:
    section.add "quotaUser", valid_579750
  var valid_579751 = query.getOrDefault("updateMask")
  valid_579751 = validateParameter(valid_579751, JString, required = false,
                                 default = nil)
  if valid_579751 != nil:
    section.add "updateMask", valid_579751
  var valid_579752 = query.getOrDefault("callback")
  valid_579752 = validateParameter(valid_579752, JString, required = false,
                                 default = nil)
  if valid_579752 != nil:
    section.add "callback", valid_579752
  var valid_579753 = query.getOrDefault("fields")
  valid_579753 = validateParameter(valid_579753, JString, required = false,
                                 default = nil)
  if valid_579753 != nil:
    section.add "fields", valid_579753
  var valid_579754 = query.getOrDefault("access_token")
  valid_579754 = validateParameter(valid_579754, JString, required = false,
                                 default = nil)
  if valid_579754 != nil:
    section.add "access_token", valid_579754
  var valid_579755 = query.getOrDefault("upload_protocol")
  valid_579755 = validateParameter(valid_579755, JString, required = false,
                                 default = nil)
  if valid_579755 != nil:
    section.add "upload_protocol", valid_579755
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

proc call*(call_579757: Call_ClassroomCoursesPatch_579740; path: JsonNode;
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
  let valid = call_579757.validator(path, query, header, formData, body)
  let scheme = call_579757.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579757.url(scheme.get, call_579757.host, call_579757.base,
                         call_579757.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579757, url, valid)

proc call*(call_579758: Call_ClassroomCoursesPatch_579740; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; updateMask: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   id: string (required)
  ##     : Identifier of the course to update.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579759 = newJObject()
  var query_579760 = newJObject()
  var body_579761 = newJObject()
  add(query_579760, "key", newJString(key))
  add(query_579760, "prettyPrint", newJBool(prettyPrint))
  add(query_579760, "oauth_token", newJString(oauthToken))
  add(query_579760, "$.xgafv", newJString(Xgafv))
  add(path_579759, "id", newJString(id))
  add(query_579760, "alt", newJString(alt))
  add(query_579760, "uploadType", newJString(uploadType))
  add(query_579760, "quotaUser", newJString(quotaUser))
  add(query_579760, "updateMask", newJString(updateMask))
  if body != nil:
    body_579761 = body
  add(query_579760, "callback", newJString(callback))
  add(query_579760, "fields", newJString(fields))
  add(query_579760, "access_token", newJString(accessToken))
  add(query_579760, "upload_protocol", newJString(uploadProtocol))
  result = call_579758.call(path_579759, query_579760, nil, nil, body_579761)

var classroomCoursesPatch* = Call_ClassroomCoursesPatch_579740(
    name: "classroomCoursesPatch", meth: HttpMethod.HttpPatch,
    host: "classroom.googleapis.com", route: "/v1/courses/{id}",
    validator: validate_ClassroomCoursesPatch_579741, base: "/",
    url: url_ClassroomCoursesPatch_579742, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesDelete_579721 = ref object of OpenApiRestCall_578348
proc url_ClassroomCoursesDelete_579723(protocol: Scheme; host: string; base: string;
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

proc validate_ClassroomCoursesDelete_579722(path: JsonNode; query: JsonNode;
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
  var valid_579724 = path.getOrDefault("id")
  valid_579724 = validateParameter(valid_579724, JString, required = true,
                                 default = nil)
  if valid_579724 != nil:
    section.add "id", valid_579724
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
  var valid_579725 = query.getOrDefault("key")
  valid_579725 = validateParameter(valid_579725, JString, required = false,
                                 default = nil)
  if valid_579725 != nil:
    section.add "key", valid_579725
  var valid_579726 = query.getOrDefault("prettyPrint")
  valid_579726 = validateParameter(valid_579726, JBool, required = false,
                                 default = newJBool(true))
  if valid_579726 != nil:
    section.add "prettyPrint", valid_579726
  var valid_579727 = query.getOrDefault("oauth_token")
  valid_579727 = validateParameter(valid_579727, JString, required = false,
                                 default = nil)
  if valid_579727 != nil:
    section.add "oauth_token", valid_579727
  var valid_579728 = query.getOrDefault("$.xgafv")
  valid_579728 = validateParameter(valid_579728, JString, required = false,
                                 default = newJString("1"))
  if valid_579728 != nil:
    section.add "$.xgafv", valid_579728
  var valid_579729 = query.getOrDefault("alt")
  valid_579729 = validateParameter(valid_579729, JString, required = false,
                                 default = newJString("json"))
  if valid_579729 != nil:
    section.add "alt", valid_579729
  var valid_579730 = query.getOrDefault("uploadType")
  valid_579730 = validateParameter(valid_579730, JString, required = false,
                                 default = nil)
  if valid_579730 != nil:
    section.add "uploadType", valid_579730
  var valid_579731 = query.getOrDefault("quotaUser")
  valid_579731 = validateParameter(valid_579731, JString, required = false,
                                 default = nil)
  if valid_579731 != nil:
    section.add "quotaUser", valid_579731
  var valid_579732 = query.getOrDefault("callback")
  valid_579732 = validateParameter(valid_579732, JString, required = false,
                                 default = nil)
  if valid_579732 != nil:
    section.add "callback", valid_579732
  var valid_579733 = query.getOrDefault("fields")
  valid_579733 = validateParameter(valid_579733, JString, required = false,
                                 default = nil)
  if valid_579733 != nil:
    section.add "fields", valid_579733
  var valid_579734 = query.getOrDefault("access_token")
  valid_579734 = validateParameter(valid_579734, JString, required = false,
                                 default = nil)
  if valid_579734 != nil:
    section.add "access_token", valid_579734
  var valid_579735 = query.getOrDefault("upload_protocol")
  valid_579735 = validateParameter(valid_579735, JString, required = false,
                                 default = nil)
  if valid_579735 != nil:
    section.add "upload_protocol", valid_579735
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579736: Call_ClassroomCoursesDelete_579721; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to delete the
  ## requested course or for access errors.
  ## * `NOT_FOUND` if no course exists with the requested ID.
  ## 
  let valid = call_579736.validator(path, query, header, formData, body)
  let scheme = call_579736.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579736.url(scheme.get, call_579736.host, call_579736.base,
                         call_579736.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579736, url, valid)

proc call*(call_579737: Call_ClassroomCoursesDelete_579721; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## classroomCoursesDelete
  ## Deletes a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to delete the
  ## requested course or for access errors.
  ## * `NOT_FOUND` if no course exists with the requested ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   id: string (required)
  ##     : Identifier of the course to delete.
  ## This identifier can be either the Classroom-assigned identifier or an
  ## alias.
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
  var path_579738 = newJObject()
  var query_579739 = newJObject()
  add(query_579739, "key", newJString(key))
  add(query_579739, "prettyPrint", newJBool(prettyPrint))
  add(query_579739, "oauth_token", newJString(oauthToken))
  add(query_579739, "$.xgafv", newJString(Xgafv))
  add(path_579738, "id", newJString(id))
  add(query_579739, "alt", newJString(alt))
  add(query_579739, "uploadType", newJString(uploadType))
  add(query_579739, "quotaUser", newJString(quotaUser))
  add(query_579739, "callback", newJString(callback))
  add(query_579739, "fields", newJString(fields))
  add(query_579739, "access_token", newJString(accessToken))
  add(query_579739, "upload_protocol", newJString(uploadProtocol))
  result = call_579737.call(path_579738, query_579739, nil, nil, nil)

var classroomCoursesDelete* = Call_ClassroomCoursesDelete_579721(
    name: "classroomCoursesDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com", route: "/v1/courses/{id}",
    validator: validate_ClassroomCoursesDelete_579722, base: "/",
    url: url_ClassroomCoursesDelete_579723, schemes: {Scheme.Https})
type
  Call_ClassroomInvitationsCreate_579783 = ref object of OpenApiRestCall_578348
proc url_ClassroomInvitationsCreate_579785(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ClassroomInvitationsCreate_579784(path: JsonNode; query: JsonNode;
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
  var valid_579786 = query.getOrDefault("key")
  valid_579786 = validateParameter(valid_579786, JString, required = false,
                                 default = nil)
  if valid_579786 != nil:
    section.add "key", valid_579786
  var valid_579787 = query.getOrDefault("prettyPrint")
  valid_579787 = validateParameter(valid_579787, JBool, required = false,
                                 default = newJBool(true))
  if valid_579787 != nil:
    section.add "prettyPrint", valid_579787
  var valid_579788 = query.getOrDefault("oauth_token")
  valid_579788 = validateParameter(valid_579788, JString, required = false,
                                 default = nil)
  if valid_579788 != nil:
    section.add "oauth_token", valid_579788
  var valid_579789 = query.getOrDefault("$.xgafv")
  valid_579789 = validateParameter(valid_579789, JString, required = false,
                                 default = newJString("1"))
  if valid_579789 != nil:
    section.add "$.xgafv", valid_579789
  var valid_579790 = query.getOrDefault("alt")
  valid_579790 = validateParameter(valid_579790, JString, required = false,
                                 default = newJString("json"))
  if valid_579790 != nil:
    section.add "alt", valid_579790
  var valid_579791 = query.getOrDefault("uploadType")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "uploadType", valid_579791
  var valid_579792 = query.getOrDefault("quotaUser")
  valid_579792 = validateParameter(valid_579792, JString, required = false,
                                 default = nil)
  if valid_579792 != nil:
    section.add "quotaUser", valid_579792
  var valid_579793 = query.getOrDefault("callback")
  valid_579793 = validateParameter(valid_579793, JString, required = false,
                                 default = nil)
  if valid_579793 != nil:
    section.add "callback", valid_579793
  var valid_579794 = query.getOrDefault("fields")
  valid_579794 = validateParameter(valid_579794, JString, required = false,
                                 default = nil)
  if valid_579794 != nil:
    section.add "fields", valid_579794
  var valid_579795 = query.getOrDefault("access_token")
  valid_579795 = validateParameter(valid_579795, JString, required = false,
                                 default = nil)
  if valid_579795 != nil:
    section.add "access_token", valid_579795
  var valid_579796 = query.getOrDefault("upload_protocol")
  valid_579796 = validateParameter(valid_579796, JString, required = false,
                                 default = nil)
  if valid_579796 != nil:
    section.add "upload_protocol", valid_579796
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

proc call*(call_579798: Call_ClassroomInvitationsCreate_579783; path: JsonNode;
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
  let valid = call_579798.validator(path, query, header, formData, body)
  let scheme = call_579798.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579798.url(scheme.get, call_579798.host, call_579798.base,
                         call_579798.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579798, url, valid)

proc call*(call_579799: Call_ClassroomInvitationsCreate_579783; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579800 = newJObject()
  var body_579801 = newJObject()
  add(query_579800, "key", newJString(key))
  add(query_579800, "prettyPrint", newJBool(prettyPrint))
  add(query_579800, "oauth_token", newJString(oauthToken))
  add(query_579800, "$.xgafv", newJString(Xgafv))
  add(query_579800, "alt", newJString(alt))
  add(query_579800, "uploadType", newJString(uploadType))
  add(query_579800, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579801 = body
  add(query_579800, "callback", newJString(callback))
  add(query_579800, "fields", newJString(fields))
  add(query_579800, "access_token", newJString(accessToken))
  add(query_579800, "upload_protocol", newJString(uploadProtocol))
  result = call_579799.call(nil, query_579800, nil, nil, body_579801)

var classroomInvitationsCreate* = Call_ClassroomInvitationsCreate_579783(
    name: "classroomInvitationsCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/invitations",
    validator: validate_ClassroomInvitationsCreate_579784, base: "/",
    url: url_ClassroomInvitationsCreate_579785, schemes: {Scheme.Https})
type
  Call_ClassroomInvitationsList_579762 = ref object of OpenApiRestCall_578348
proc url_ClassroomInvitationsList_579764(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ClassroomInvitationsList_579763(path: JsonNode; query: JsonNode;
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userId: JString
  ##         : Restricts returned invitations to those for a specific user. The identifier
  ## can be one of the following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Maximum number of items to return. Zero means no maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   courseId: JString
  ##           : Restricts returned invitations to those for a course with the specified
  ## identifier.
  ##   pageToken: JString
  ##            : nextPageToken
  ## value returned from a previous
  ## list call, indicating
  ## that the subsequent page of results should be returned.
  ## 
  ## The list request must be
  ## otherwise identical to the one that resulted in this token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579765 = query.getOrDefault("key")
  valid_579765 = validateParameter(valid_579765, JString, required = false,
                                 default = nil)
  if valid_579765 != nil:
    section.add "key", valid_579765
  var valid_579766 = query.getOrDefault("prettyPrint")
  valid_579766 = validateParameter(valid_579766, JBool, required = false,
                                 default = newJBool(true))
  if valid_579766 != nil:
    section.add "prettyPrint", valid_579766
  var valid_579767 = query.getOrDefault("oauth_token")
  valid_579767 = validateParameter(valid_579767, JString, required = false,
                                 default = nil)
  if valid_579767 != nil:
    section.add "oauth_token", valid_579767
  var valid_579768 = query.getOrDefault("userId")
  valid_579768 = validateParameter(valid_579768, JString, required = false,
                                 default = nil)
  if valid_579768 != nil:
    section.add "userId", valid_579768
  var valid_579769 = query.getOrDefault("$.xgafv")
  valid_579769 = validateParameter(valid_579769, JString, required = false,
                                 default = newJString("1"))
  if valid_579769 != nil:
    section.add "$.xgafv", valid_579769
  var valid_579770 = query.getOrDefault("pageSize")
  valid_579770 = validateParameter(valid_579770, JInt, required = false, default = nil)
  if valid_579770 != nil:
    section.add "pageSize", valid_579770
  var valid_579771 = query.getOrDefault("alt")
  valid_579771 = validateParameter(valid_579771, JString, required = false,
                                 default = newJString("json"))
  if valid_579771 != nil:
    section.add "alt", valid_579771
  var valid_579772 = query.getOrDefault("uploadType")
  valid_579772 = validateParameter(valid_579772, JString, required = false,
                                 default = nil)
  if valid_579772 != nil:
    section.add "uploadType", valid_579772
  var valid_579773 = query.getOrDefault("quotaUser")
  valid_579773 = validateParameter(valid_579773, JString, required = false,
                                 default = nil)
  if valid_579773 != nil:
    section.add "quotaUser", valid_579773
  var valid_579774 = query.getOrDefault("courseId")
  valid_579774 = validateParameter(valid_579774, JString, required = false,
                                 default = nil)
  if valid_579774 != nil:
    section.add "courseId", valid_579774
  var valid_579775 = query.getOrDefault("pageToken")
  valid_579775 = validateParameter(valid_579775, JString, required = false,
                                 default = nil)
  if valid_579775 != nil:
    section.add "pageToken", valid_579775
  var valid_579776 = query.getOrDefault("callback")
  valid_579776 = validateParameter(valid_579776, JString, required = false,
                                 default = nil)
  if valid_579776 != nil:
    section.add "callback", valid_579776
  var valid_579777 = query.getOrDefault("fields")
  valid_579777 = validateParameter(valid_579777, JString, required = false,
                                 default = nil)
  if valid_579777 != nil:
    section.add "fields", valid_579777
  var valid_579778 = query.getOrDefault("access_token")
  valid_579778 = validateParameter(valid_579778, JString, required = false,
                                 default = nil)
  if valid_579778 != nil:
    section.add "access_token", valid_579778
  var valid_579779 = query.getOrDefault("upload_protocol")
  valid_579779 = validateParameter(valid_579779, JString, required = false,
                                 default = nil)
  if valid_579779 != nil:
    section.add "upload_protocol", valid_579779
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579780: Call_ClassroomInvitationsList_579762; path: JsonNode;
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
  let valid = call_579780.validator(path, query, header, formData, body)
  let scheme = call_579780.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579780.url(scheme.get, call_579780.host, call_579780.base,
                         call_579780.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579780, url, valid)

proc call*(call_579781: Call_ClassroomInvitationsList_579762; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; userId: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; courseId: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userId: string
  ##         : Restricts returned invitations to those for a specific user. The identifier
  ## can be one of the following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of items to return. Zero means no maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   courseId: string
  ##           : Restricts returned invitations to those for a course with the specified
  ## identifier.
  ##   pageToken: string
  ##            : nextPageToken
  ## value returned from a previous
  ## list call, indicating
  ## that the subsequent page of results should be returned.
  ## 
  ## The list request must be
  ## otherwise identical to the one that resulted in this token.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579782 = newJObject()
  add(query_579782, "key", newJString(key))
  add(query_579782, "prettyPrint", newJBool(prettyPrint))
  add(query_579782, "oauth_token", newJString(oauthToken))
  add(query_579782, "userId", newJString(userId))
  add(query_579782, "$.xgafv", newJString(Xgafv))
  add(query_579782, "pageSize", newJInt(pageSize))
  add(query_579782, "alt", newJString(alt))
  add(query_579782, "uploadType", newJString(uploadType))
  add(query_579782, "quotaUser", newJString(quotaUser))
  add(query_579782, "courseId", newJString(courseId))
  add(query_579782, "pageToken", newJString(pageToken))
  add(query_579782, "callback", newJString(callback))
  add(query_579782, "fields", newJString(fields))
  add(query_579782, "access_token", newJString(accessToken))
  add(query_579782, "upload_protocol", newJString(uploadProtocol))
  result = call_579781.call(nil, query_579782, nil, nil, nil)

var classroomInvitationsList* = Call_ClassroomInvitationsList_579762(
    name: "classroomInvitationsList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/invitations",
    validator: validate_ClassroomInvitationsList_579763, base: "/",
    url: url_ClassroomInvitationsList_579764, schemes: {Scheme.Https})
type
  Call_ClassroomInvitationsGet_579802 = ref object of OpenApiRestCall_578348
proc url_ClassroomInvitationsGet_579804(protocol: Scheme; host: string; base: string;
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

proc validate_ClassroomInvitationsGet_579803(path: JsonNode; query: JsonNode;
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
  var valid_579805 = path.getOrDefault("id")
  valid_579805 = validateParameter(valid_579805, JString, required = true,
                                 default = nil)
  if valid_579805 != nil:
    section.add "id", valid_579805
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
  var valid_579806 = query.getOrDefault("key")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "key", valid_579806
  var valid_579807 = query.getOrDefault("prettyPrint")
  valid_579807 = validateParameter(valid_579807, JBool, required = false,
                                 default = newJBool(true))
  if valid_579807 != nil:
    section.add "prettyPrint", valid_579807
  var valid_579808 = query.getOrDefault("oauth_token")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "oauth_token", valid_579808
  var valid_579809 = query.getOrDefault("$.xgafv")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = newJString("1"))
  if valid_579809 != nil:
    section.add "$.xgafv", valid_579809
  var valid_579810 = query.getOrDefault("alt")
  valid_579810 = validateParameter(valid_579810, JString, required = false,
                                 default = newJString("json"))
  if valid_579810 != nil:
    section.add "alt", valid_579810
  var valid_579811 = query.getOrDefault("uploadType")
  valid_579811 = validateParameter(valid_579811, JString, required = false,
                                 default = nil)
  if valid_579811 != nil:
    section.add "uploadType", valid_579811
  var valid_579812 = query.getOrDefault("quotaUser")
  valid_579812 = validateParameter(valid_579812, JString, required = false,
                                 default = nil)
  if valid_579812 != nil:
    section.add "quotaUser", valid_579812
  var valid_579813 = query.getOrDefault("callback")
  valid_579813 = validateParameter(valid_579813, JString, required = false,
                                 default = nil)
  if valid_579813 != nil:
    section.add "callback", valid_579813
  var valid_579814 = query.getOrDefault("fields")
  valid_579814 = validateParameter(valid_579814, JString, required = false,
                                 default = nil)
  if valid_579814 != nil:
    section.add "fields", valid_579814
  var valid_579815 = query.getOrDefault("access_token")
  valid_579815 = validateParameter(valid_579815, JString, required = false,
                                 default = nil)
  if valid_579815 != nil:
    section.add "access_token", valid_579815
  var valid_579816 = query.getOrDefault("upload_protocol")
  valid_579816 = validateParameter(valid_579816, JString, required = false,
                                 default = nil)
  if valid_579816 != nil:
    section.add "upload_protocol", valid_579816
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579817: Call_ClassroomInvitationsGet_579802; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns an invitation.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to view the
  ## requested invitation or for access errors.
  ## * `NOT_FOUND` if no invitation exists with the requested ID.
  ## 
  let valid = call_579817.validator(path, query, header, formData, body)
  let scheme = call_579817.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579817.url(scheme.get, call_579817.host, call_579817.base,
                         call_579817.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579817, url, valid)

proc call*(call_579818: Call_ClassroomInvitationsGet_579802; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## classroomInvitationsGet
  ## Returns an invitation.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to view the
  ## requested invitation or for access errors.
  ## * `NOT_FOUND` if no invitation exists with the requested ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   id: string (required)
  ##     : Identifier of the invitation to return.
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
  var path_579819 = newJObject()
  var query_579820 = newJObject()
  add(query_579820, "key", newJString(key))
  add(query_579820, "prettyPrint", newJBool(prettyPrint))
  add(query_579820, "oauth_token", newJString(oauthToken))
  add(query_579820, "$.xgafv", newJString(Xgafv))
  add(path_579819, "id", newJString(id))
  add(query_579820, "alt", newJString(alt))
  add(query_579820, "uploadType", newJString(uploadType))
  add(query_579820, "quotaUser", newJString(quotaUser))
  add(query_579820, "callback", newJString(callback))
  add(query_579820, "fields", newJString(fields))
  add(query_579820, "access_token", newJString(accessToken))
  add(query_579820, "upload_protocol", newJString(uploadProtocol))
  result = call_579818.call(path_579819, query_579820, nil, nil, nil)

var classroomInvitationsGet* = Call_ClassroomInvitationsGet_579802(
    name: "classroomInvitationsGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/invitations/{id}",
    validator: validate_ClassroomInvitationsGet_579803, base: "/",
    url: url_ClassroomInvitationsGet_579804, schemes: {Scheme.Https})
type
  Call_ClassroomInvitationsDelete_579821 = ref object of OpenApiRestCall_578348
proc url_ClassroomInvitationsDelete_579823(protocol: Scheme; host: string;
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

proc validate_ClassroomInvitationsDelete_579822(path: JsonNode; query: JsonNode;
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
  var valid_579824 = path.getOrDefault("id")
  valid_579824 = validateParameter(valid_579824, JString, required = true,
                                 default = nil)
  if valid_579824 != nil:
    section.add "id", valid_579824
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
  var valid_579825 = query.getOrDefault("key")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "key", valid_579825
  var valid_579826 = query.getOrDefault("prettyPrint")
  valid_579826 = validateParameter(valid_579826, JBool, required = false,
                                 default = newJBool(true))
  if valid_579826 != nil:
    section.add "prettyPrint", valid_579826
  var valid_579827 = query.getOrDefault("oauth_token")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "oauth_token", valid_579827
  var valid_579828 = query.getOrDefault("$.xgafv")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = newJString("1"))
  if valid_579828 != nil:
    section.add "$.xgafv", valid_579828
  var valid_579829 = query.getOrDefault("alt")
  valid_579829 = validateParameter(valid_579829, JString, required = false,
                                 default = newJString("json"))
  if valid_579829 != nil:
    section.add "alt", valid_579829
  var valid_579830 = query.getOrDefault("uploadType")
  valid_579830 = validateParameter(valid_579830, JString, required = false,
                                 default = nil)
  if valid_579830 != nil:
    section.add "uploadType", valid_579830
  var valid_579831 = query.getOrDefault("quotaUser")
  valid_579831 = validateParameter(valid_579831, JString, required = false,
                                 default = nil)
  if valid_579831 != nil:
    section.add "quotaUser", valid_579831
  var valid_579832 = query.getOrDefault("callback")
  valid_579832 = validateParameter(valid_579832, JString, required = false,
                                 default = nil)
  if valid_579832 != nil:
    section.add "callback", valid_579832
  var valid_579833 = query.getOrDefault("fields")
  valid_579833 = validateParameter(valid_579833, JString, required = false,
                                 default = nil)
  if valid_579833 != nil:
    section.add "fields", valid_579833
  var valid_579834 = query.getOrDefault("access_token")
  valid_579834 = validateParameter(valid_579834, JString, required = false,
                                 default = nil)
  if valid_579834 != nil:
    section.add "access_token", valid_579834
  var valid_579835 = query.getOrDefault("upload_protocol")
  valid_579835 = validateParameter(valid_579835, JString, required = false,
                                 default = nil)
  if valid_579835 != nil:
    section.add "upload_protocol", valid_579835
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579836: Call_ClassroomInvitationsDelete_579821; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an invitation.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to delete the
  ## requested invitation or for access errors.
  ## * `NOT_FOUND` if no invitation exists with the requested ID.
  ## 
  let valid = call_579836.validator(path, query, header, formData, body)
  let scheme = call_579836.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579836.url(scheme.get, call_579836.host, call_579836.base,
                         call_579836.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579836, url, valid)

proc call*(call_579837: Call_ClassroomInvitationsDelete_579821; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## classroomInvitationsDelete
  ## Deletes an invitation.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to delete the
  ## requested invitation or for access errors.
  ## * `NOT_FOUND` if no invitation exists with the requested ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   id: string (required)
  ##     : Identifier of the invitation to delete.
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
  var path_579838 = newJObject()
  var query_579839 = newJObject()
  add(query_579839, "key", newJString(key))
  add(query_579839, "prettyPrint", newJBool(prettyPrint))
  add(query_579839, "oauth_token", newJString(oauthToken))
  add(query_579839, "$.xgafv", newJString(Xgafv))
  add(path_579838, "id", newJString(id))
  add(query_579839, "alt", newJString(alt))
  add(query_579839, "uploadType", newJString(uploadType))
  add(query_579839, "quotaUser", newJString(quotaUser))
  add(query_579839, "callback", newJString(callback))
  add(query_579839, "fields", newJString(fields))
  add(query_579839, "access_token", newJString(accessToken))
  add(query_579839, "upload_protocol", newJString(uploadProtocol))
  result = call_579837.call(path_579838, query_579839, nil, nil, nil)

var classroomInvitationsDelete* = Call_ClassroomInvitationsDelete_579821(
    name: "classroomInvitationsDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com", route: "/v1/invitations/{id}",
    validator: validate_ClassroomInvitationsDelete_579822, base: "/",
    url: url_ClassroomInvitationsDelete_579823, schemes: {Scheme.Https})
type
  Call_ClassroomInvitationsAccept_579840 = ref object of OpenApiRestCall_578348
proc url_ClassroomInvitationsAccept_579842(protocol: Scheme; host: string;
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

proc validate_ClassroomInvitationsAccept_579841(path: JsonNode; query: JsonNode;
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
  var valid_579843 = path.getOrDefault("id")
  valid_579843 = validateParameter(valid_579843, JString, required = true,
                                 default = nil)
  if valid_579843 != nil:
    section.add "id", valid_579843
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
  var valid_579844 = query.getOrDefault("key")
  valid_579844 = validateParameter(valid_579844, JString, required = false,
                                 default = nil)
  if valid_579844 != nil:
    section.add "key", valid_579844
  var valid_579845 = query.getOrDefault("prettyPrint")
  valid_579845 = validateParameter(valid_579845, JBool, required = false,
                                 default = newJBool(true))
  if valid_579845 != nil:
    section.add "prettyPrint", valid_579845
  var valid_579846 = query.getOrDefault("oauth_token")
  valid_579846 = validateParameter(valid_579846, JString, required = false,
                                 default = nil)
  if valid_579846 != nil:
    section.add "oauth_token", valid_579846
  var valid_579847 = query.getOrDefault("$.xgafv")
  valid_579847 = validateParameter(valid_579847, JString, required = false,
                                 default = newJString("1"))
  if valid_579847 != nil:
    section.add "$.xgafv", valid_579847
  var valid_579848 = query.getOrDefault("alt")
  valid_579848 = validateParameter(valid_579848, JString, required = false,
                                 default = newJString("json"))
  if valid_579848 != nil:
    section.add "alt", valid_579848
  var valid_579849 = query.getOrDefault("uploadType")
  valid_579849 = validateParameter(valid_579849, JString, required = false,
                                 default = nil)
  if valid_579849 != nil:
    section.add "uploadType", valid_579849
  var valid_579850 = query.getOrDefault("quotaUser")
  valid_579850 = validateParameter(valid_579850, JString, required = false,
                                 default = nil)
  if valid_579850 != nil:
    section.add "quotaUser", valid_579850
  var valid_579851 = query.getOrDefault("callback")
  valid_579851 = validateParameter(valid_579851, JString, required = false,
                                 default = nil)
  if valid_579851 != nil:
    section.add "callback", valid_579851
  var valid_579852 = query.getOrDefault("fields")
  valid_579852 = validateParameter(valid_579852, JString, required = false,
                                 default = nil)
  if valid_579852 != nil:
    section.add "fields", valid_579852
  var valid_579853 = query.getOrDefault("access_token")
  valid_579853 = validateParameter(valid_579853, JString, required = false,
                                 default = nil)
  if valid_579853 != nil:
    section.add "access_token", valid_579853
  var valid_579854 = query.getOrDefault("upload_protocol")
  valid_579854 = validateParameter(valid_579854, JString, required = false,
                                 default = nil)
  if valid_579854 != nil:
    section.add "upload_protocol", valid_579854
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579855: Call_ClassroomInvitationsAccept_579840; path: JsonNode;
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
  let valid = call_579855.validator(path, query, header, formData, body)
  let scheme = call_579855.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579855.url(scheme.get, call_579855.host, call_579855.base,
                         call_579855.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579855, url, valid)

proc call*(call_579856: Call_ClassroomInvitationsAccept_579840; id: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   id: string (required)
  ##     : Identifier of the invitation to accept.
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
  var path_579857 = newJObject()
  var query_579858 = newJObject()
  add(query_579858, "key", newJString(key))
  add(query_579858, "prettyPrint", newJBool(prettyPrint))
  add(query_579858, "oauth_token", newJString(oauthToken))
  add(query_579858, "$.xgafv", newJString(Xgafv))
  add(path_579857, "id", newJString(id))
  add(query_579858, "alt", newJString(alt))
  add(query_579858, "uploadType", newJString(uploadType))
  add(query_579858, "quotaUser", newJString(quotaUser))
  add(query_579858, "callback", newJString(callback))
  add(query_579858, "fields", newJString(fields))
  add(query_579858, "access_token", newJString(accessToken))
  add(query_579858, "upload_protocol", newJString(uploadProtocol))
  result = call_579856.call(path_579857, query_579858, nil, nil, nil)

var classroomInvitationsAccept* = Call_ClassroomInvitationsAccept_579840(
    name: "classroomInvitationsAccept", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/invitations/{id}:accept",
    validator: validate_ClassroomInvitationsAccept_579841, base: "/",
    url: url_ClassroomInvitationsAccept_579842, schemes: {Scheme.Https})
type
  Call_ClassroomRegistrationsCreate_579859 = ref object of OpenApiRestCall_578348
proc url_ClassroomRegistrationsCreate_579861(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ClassroomRegistrationsCreate_579860(path: JsonNode; query: JsonNode;
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
  var valid_579862 = query.getOrDefault("key")
  valid_579862 = validateParameter(valid_579862, JString, required = false,
                                 default = nil)
  if valid_579862 != nil:
    section.add "key", valid_579862
  var valid_579863 = query.getOrDefault("prettyPrint")
  valid_579863 = validateParameter(valid_579863, JBool, required = false,
                                 default = newJBool(true))
  if valid_579863 != nil:
    section.add "prettyPrint", valid_579863
  var valid_579864 = query.getOrDefault("oauth_token")
  valid_579864 = validateParameter(valid_579864, JString, required = false,
                                 default = nil)
  if valid_579864 != nil:
    section.add "oauth_token", valid_579864
  var valid_579865 = query.getOrDefault("$.xgafv")
  valid_579865 = validateParameter(valid_579865, JString, required = false,
                                 default = newJString("1"))
  if valid_579865 != nil:
    section.add "$.xgafv", valid_579865
  var valid_579866 = query.getOrDefault("alt")
  valid_579866 = validateParameter(valid_579866, JString, required = false,
                                 default = newJString("json"))
  if valid_579866 != nil:
    section.add "alt", valid_579866
  var valid_579867 = query.getOrDefault("uploadType")
  valid_579867 = validateParameter(valid_579867, JString, required = false,
                                 default = nil)
  if valid_579867 != nil:
    section.add "uploadType", valid_579867
  var valid_579868 = query.getOrDefault("quotaUser")
  valid_579868 = validateParameter(valid_579868, JString, required = false,
                                 default = nil)
  if valid_579868 != nil:
    section.add "quotaUser", valid_579868
  var valid_579869 = query.getOrDefault("callback")
  valid_579869 = validateParameter(valid_579869, JString, required = false,
                                 default = nil)
  if valid_579869 != nil:
    section.add "callback", valid_579869
  var valid_579870 = query.getOrDefault("fields")
  valid_579870 = validateParameter(valid_579870, JString, required = false,
                                 default = nil)
  if valid_579870 != nil:
    section.add "fields", valid_579870
  var valid_579871 = query.getOrDefault("access_token")
  valid_579871 = validateParameter(valid_579871, JString, required = false,
                                 default = nil)
  if valid_579871 != nil:
    section.add "access_token", valid_579871
  var valid_579872 = query.getOrDefault("upload_protocol")
  valid_579872 = validateParameter(valid_579872, JString, required = false,
                                 default = nil)
  if valid_579872 != nil:
    section.add "upload_protocol", valid_579872
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

proc call*(call_579874: Call_ClassroomRegistrationsCreate_579859; path: JsonNode;
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
  let valid = call_579874.validator(path, query, header, formData, body)
  let scheme = call_579874.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579874.url(scheme.get, call_579874.host, call_579874.base,
                         call_579874.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579874, url, valid)

proc call*(call_579875: Call_ClassroomRegistrationsCreate_579859; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579876 = newJObject()
  var body_579877 = newJObject()
  add(query_579876, "key", newJString(key))
  add(query_579876, "prettyPrint", newJBool(prettyPrint))
  add(query_579876, "oauth_token", newJString(oauthToken))
  add(query_579876, "$.xgafv", newJString(Xgafv))
  add(query_579876, "alt", newJString(alt))
  add(query_579876, "uploadType", newJString(uploadType))
  add(query_579876, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579877 = body
  add(query_579876, "callback", newJString(callback))
  add(query_579876, "fields", newJString(fields))
  add(query_579876, "access_token", newJString(accessToken))
  add(query_579876, "upload_protocol", newJString(uploadProtocol))
  result = call_579875.call(nil, query_579876, nil, nil, body_579877)

var classroomRegistrationsCreate* = Call_ClassroomRegistrationsCreate_579859(
    name: "classroomRegistrationsCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/registrations",
    validator: validate_ClassroomRegistrationsCreate_579860, base: "/",
    url: url_ClassroomRegistrationsCreate_579861, schemes: {Scheme.Https})
type
  Call_ClassroomRegistrationsDelete_579878 = ref object of OpenApiRestCall_578348
proc url_ClassroomRegistrationsDelete_579880(protocol: Scheme; host: string;
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

proc validate_ClassroomRegistrationsDelete_579879(path: JsonNode; query: JsonNode;
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
  var valid_579881 = path.getOrDefault("registrationId")
  valid_579881 = validateParameter(valid_579881, JString, required = true,
                                 default = nil)
  if valid_579881 != nil:
    section.add "registrationId", valid_579881
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
  var valid_579882 = query.getOrDefault("key")
  valid_579882 = validateParameter(valid_579882, JString, required = false,
                                 default = nil)
  if valid_579882 != nil:
    section.add "key", valid_579882
  var valid_579883 = query.getOrDefault("prettyPrint")
  valid_579883 = validateParameter(valid_579883, JBool, required = false,
                                 default = newJBool(true))
  if valid_579883 != nil:
    section.add "prettyPrint", valid_579883
  var valid_579884 = query.getOrDefault("oauth_token")
  valid_579884 = validateParameter(valid_579884, JString, required = false,
                                 default = nil)
  if valid_579884 != nil:
    section.add "oauth_token", valid_579884
  var valid_579885 = query.getOrDefault("$.xgafv")
  valid_579885 = validateParameter(valid_579885, JString, required = false,
                                 default = newJString("1"))
  if valid_579885 != nil:
    section.add "$.xgafv", valid_579885
  var valid_579886 = query.getOrDefault("alt")
  valid_579886 = validateParameter(valid_579886, JString, required = false,
                                 default = newJString("json"))
  if valid_579886 != nil:
    section.add "alt", valid_579886
  var valid_579887 = query.getOrDefault("uploadType")
  valid_579887 = validateParameter(valid_579887, JString, required = false,
                                 default = nil)
  if valid_579887 != nil:
    section.add "uploadType", valid_579887
  var valid_579888 = query.getOrDefault("quotaUser")
  valid_579888 = validateParameter(valid_579888, JString, required = false,
                                 default = nil)
  if valid_579888 != nil:
    section.add "quotaUser", valid_579888
  var valid_579889 = query.getOrDefault("callback")
  valid_579889 = validateParameter(valid_579889, JString, required = false,
                                 default = nil)
  if valid_579889 != nil:
    section.add "callback", valid_579889
  var valid_579890 = query.getOrDefault("fields")
  valid_579890 = validateParameter(valid_579890, JString, required = false,
                                 default = nil)
  if valid_579890 != nil:
    section.add "fields", valid_579890
  var valid_579891 = query.getOrDefault("access_token")
  valid_579891 = validateParameter(valid_579891, JString, required = false,
                                 default = nil)
  if valid_579891 != nil:
    section.add "access_token", valid_579891
  var valid_579892 = query.getOrDefault("upload_protocol")
  valid_579892 = validateParameter(valid_579892, JString, required = false,
                                 default = nil)
  if valid_579892 != nil:
    section.add "upload_protocol", valid_579892
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579893: Call_ClassroomRegistrationsDelete_579878; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a `Registration`, causing Classroom to stop sending notifications
  ## for that `Registration`.
  ## 
  let valid = call_579893.validator(path, query, header, formData, body)
  let scheme = call_579893.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579893.url(scheme.get, call_579893.host, call_579893.base,
                         call_579893.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579893, url, valid)

proc call*(call_579894: Call_ClassroomRegistrationsDelete_579878;
          registrationId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## classroomRegistrationsDelete
  ## Deletes a `Registration`, causing Classroom to stop sending notifications
  ## for that `Registration`.
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
  ##   registrationId: string (required)
  ##                 : The `registration_id` of the `Registration` to be deleted.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579895 = newJObject()
  var query_579896 = newJObject()
  add(query_579896, "key", newJString(key))
  add(query_579896, "prettyPrint", newJBool(prettyPrint))
  add(query_579896, "oauth_token", newJString(oauthToken))
  add(query_579896, "$.xgafv", newJString(Xgafv))
  add(query_579896, "alt", newJString(alt))
  add(query_579896, "uploadType", newJString(uploadType))
  add(query_579896, "quotaUser", newJString(quotaUser))
  add(path_579895, "registrationId", newJString(registrationId))
  add(query_579896, "callback", newJString(callback))
  add(query_579896, "fields", newJString(fields))
  add(query_579896, "access_token", newJString(accessToken))
  add(query_579896, "upload_protocol", newJString(uploadProtocol))
  result = call_579894.call(path_579895, query_579896, nil, nil, nil)

var classroomRegistrationsDelete* = Call_ClassroomRegistrationsDelete_579878(
    name: "classroomRegistrationsDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com", route: "/v1/registrations/{registrationId}",
    validator: validate_ClassroomRegistrationsDelete_579879, base: "/",
    url: url_ClassroomRegistrationsDelete_579880, schemes: {Scheme.Https})
type
  Call_ClassroomUserProfilesGuardianInvitationsCreate_579920 = ref object of OpenApiRestCall_578348
proc url_ClassroomUserProfilesGuardianInvitationsCreate_579922(protocol: Scheme;
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

proc validate_ClassroomUserProfilesGuardianInvitationsCreate_579921(
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
  var valid_579923 = path.getOrDefault("studentId")
  valid_579923 = validateParameter(valid_579923, JString, required = true,
                                 default = nil)
  if valid_579923 != nil:
    section.add "studentId", valid_579923
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
  var valid_579924 = query.getOrDefault("key")
  valid_579924 = validateParameter(valid_579924, JString, required = false,
                                 default = nil)
  if valid_579924 != nil:
    section.add "key", valid_579924
  var valid_579925 = query.getOrDefault("prettyPrint")
  valid_579925 = validateParameter(valid_579925, JBool, required = false,
                                 default = newJBool(true))
  if valid_579925 != nil:
    section.add "prettyPrint", valid_579925
  var valid_579926 = query.getOrDefault("oauth_token")
  valid_579926 = validateParameter(valid_579926, JString, required = false,
                                 default = nil)
  if valid_579926 != nil:
    section.add "oauth_token", valid_579926
  var valid_579927 = query.getOrDefault("$.xgafv")
  valid_579927 = validateParameter(valid_579927, JString, required = false,
                                 default = newJString("1"))
  if valid_579927 != nil:
    section.add "$.xgafv", valid_579927
  var valid_579928 = query.getOrDefault("alt")
  valid_579928 = validateParameter(valid_579928, JString, required = false,
                                 default = newJString("json"))
  if valid_579928 != nil:
    section.add "alt", valid_579928
  var valid_579929 = query.getOrDefault("uploadType")
  valid_579929 = validateParameter(valid_579929, JString, required = false,
                                 default = nil)
  if valid_579929 != nil:
    section.add "uploadType", valid_579929
  var valid_579930 = query.getOrDefault("quotaUser")
  valid_579930 = validateParameter(valid_579930, JString, required = false,
                                 default = nil)
  if valid_579930 != nil:
    section.add "quotaUser", valid_579930
  var valid_579931 = query.getOrDefault("callback")
  valid_579931 = validateParameter(valid_579931, JString, required = false,
                                 default = nil)
  if valid_579931 != nil:
    section.add "callback", valid_579931
  var valid_579932 = query.getOrDefault("fields")
  valid_579932 = validateParameter(valid_579932, JString, required = false,
                                 default = nil)
  if valid_579932 != nil:
    section.add "fields", valid_579932
  var valid_579933 = query.getOrDefault("access_token")
  valid_579933 = validateParameter(valid_579933, JString, required = false,
                                 default = nil)
  if valid_579933 != nil:
    section.add "access_token", valid_579933
  var valid_579934 = query.getOrDefault("upload_protocol")
  valid_579934 = validateParameter(valid_579934, JString, required = false,
                                 default = nil)
  if valid_579934 != nil:
    section.add "upload_protocol", valid_579934
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

proc call*(call_579936: Call_ClassroomUserProfilesGuardianInvitationsCreate_579920;
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
  let valid = call_579936.validator(path, query, header, formData, body)
  let scheme = call_579936.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579936.url(scheme.get, call_579936.host, call_579936.base,
                         call_579936.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579936, url, valid)

proc call*(call_579937: Call_ClassroomUserProfilesGuardianInvitationsCreate_579920;
          studentId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   studentId: string (required)
  ##            : ID of the student (in standard format)
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579938 = newJObject()
  var query_579939 = newJObject()
  var body_579940 = newJObject()
  add(query_579939, "key", newJString(key))
  add(query_579939, "prettyPrint", newJBool(prettyPrint))
  add(query_579939, "oauth_token", newJString(oauthToken))
  add(query_579939, "$.xgafv", newJString(Xgafv))
  add(path_579938, "studentId", newJString(studentId))
  add(query_579939, "alt", newJString(alt))
  add(query_579939, "uploadType", newJString(uploadType))
  add(query_579939, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579940 = body
  add(query_579939, "callback", newJString(callback))
  add(query_579939, "fields", newJString(fields))
  add(query_579939, "access_token", newJString(accessToken))
  add(query_579939, "upload_protocol", newJString(uploadProtocol))
  result = call_579937.call(path_579938, query_579939, nil, nil, body_579940)

var classroomUserProfilesGuardianInvitationsCreate* = Call_ClassroomUserProfilesGuardianInvitationsCreate_579920(
    name: "classroomUserProfilesGuardianInvitationsCreate",
    meth: HttpMethod.HttpPost, host: "classroom.googleapis.com",
    route: "/v1/userProfiles/{studentId}/guardianInvitations",
    validator: validate_ClassroomUserProfilesGuardianInvitationsCreate_579921,
    base: "/", url: url_ClassroomUserProfilesGuardianInvitationsCreate_579922,
    schemes: {Scheme.Https})
type
  Call_ClassroomUserProfilesGuardianInvitationsList_579897 = ref object of OpenApiRestCall_578348
proc url_ClassroomUserProfilesGuardianInvitationsList_579899(protocol: Scheme;
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

proc validate_ClassroomUserProfilesGuardianInvitationsList_579898(path: JsonNode;
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
  var valid_579900 = path.getOrDefault("studentId")
  valid_579900 = validateParameter(valid_579900, JString, required = true,
                                 default = nil)
  if valid_579900 != nil:
    section.add "studentId", valid_579900
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
  ##   pageSize: JInt
  ##           : Maximum number of items to return. Zero or unspecified indicates that the
  ## server may assign a maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   invitedEmailAddress: JString
  ##                      : If specified, only results with the specified `invited_email_address`
  ## will be returned.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : nextPageToken
  ## value returned from a previous
  ## list call,
  ## indicating that the subsequent page of results should be returned.
  ## 
  ## The list request
  ## must be otherwise identical to the one that resulted in this token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   states: JArray
  ##         : If specified, only results with the specified `state` values will be
  ## returned. Otherwise, results with a `state` of `PENDING` will be returned.
  section = newJObject()
  var valid_579901 = query.getOrDefault("key")
  valid_579901 = validateParameter(valid_579901, JString, required = false,
                                 default = nil)
  if valid_579901 != nil:
    section.add "key", valid_579901
  var valid_579902 = query.getOrDefault("prettyPrint")
  valid_579902 = validateParameter(valid_579902, JBool, required = false,
                                 default = newJBool(true))
  if valid_579902 != nil:
    section.add "prettyPrint", valid_579902
  var valid_579903 = query.getOrDefault("oauth_token")
  valid_579903 = validateParameter(valid_579903, JString, required = false,
                                 default = nil)
  if valid_579903 != nil:
    section.add "oauth_token", valid_579903
  var valid_579904 = query.getOrDefault("$.xgafv")
  valid_579904 = validateParameter(valid_579904, JString, required = false,
                                 default = newJString("1"))
  if valid_579904 != nil:
    section.add "$.xgafv", valid_579904
  var valid_579905 = query.getOrDefault("pageSize")
  valid_579905 = validateParameter(valid_579905, JInt, required = false, default = nil)
  if valid_579905 != nil:
    section.add "pageSize", valid_579905
  var valid_579906 = query.getOrDefault("invitedEmailAddress")
  valid_579906 = validateParameter(valid_579906, JString, required = false,
                                 default = nil)
  if valid_579906 != nil:
    section.add "invitedEmailAddress", valid_579906
  var valid_579907 = query.getOrDefault("alt")
  valid_579907 = validateParameter(valid_579907, JString, required = false,
                                 default = newJString("json"))
  if valid_579907 != nil:
    section.add "alt", valid_579907
  var valid_579908 = query.getOrDefault("uploadType")
  valid_579908 = validateParameter(valid_579908, JString, required = false,
                                 default = nil)
  if valid_579908 != nil:
    section.add "uploadType", valid_579908
  var valid_579909 = query.getOrDefault("quotaUser")
  valid_579909 = validateParameter(valid_579909, JString, required = false,
                                 default = nil)
  if valid_579909 != nil:
    section.add "quotaUser", valid_579909
  var valid_579910 = query.getOrDefault("pageToken")
  valid_579910 = validateParameter(valid_579910, JString, required = false,
                                 default = nil)
  if valid_579910 != nil:
    section.add "pageToken", valid_579910
  var valid_579911 = query.getOrDefault("callback")
  valid_579911 = validateParameter(valid_579911, JString, required = false,
                                 default = nil)
  if valid_579911 != nil:
    section.add "callback", valid_579911
  var valid_579912 = query.getOrDefault("fields")
  valid_579912 = validateParameter(valid_579912, JString, required = false,
                                 default = nil)
  if valid_579912 != nil:
    section.add "fields", valid_579912
  var valid_579913 = query.getOrDefault("access_token")
  valid_579913 = validateParameter(valid_579913, JString, required = false,
                                 default = nil)
  if valid_579913 != nil:
    section.add "access_token", valid_579913
  var valid_579914 = query.getOrDefault("upload_protocol")
  valid_579914 = validateParameter(valid_579914, JString, required = false,
                                 default = nil)
  if valid_579914 != nil:
    section.add "upload_protocol", valid_579914
  var valid_579915 = query.getOrDefault("states")
  valid_579915 = validateParameter(valid_579915, JArray, required = false,
                                 default = nil)
  if valid_579915 != nil:
    section.add "states", valid_579915
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579916: Call_ClassroomUserProfilesGuardianInvitationsList_579897;
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
  let valid = call_579916.validator(path, query, header, formData, body)
  let scheme = call_579916.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579916.url(scheme.get, call_579916.host, call_579916.base,
                         call_579916.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579916, url, valid)

proc call*(call_579917: Call_ClassroomUserProfilesGuardianInvitationsList_579897;
          studentId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          invitedEmailAddress: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; states: JsonNode = nil): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
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
  ##   pageSize: int
  ##           : Maximum number of items to return. Zero or unspecified indicates that the
  ## server may assign a maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   invitedEmailAddress: string
  ##                      : If specified, only results with the specified `invited_email_address`
  ## will be returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : nextPageToken
  ## value returned from a previous
  ## list call,
  ## indicating that the subsequent page of results should be returned.
  ## 
  ## The list request
  ## must be otherwise identical to the one that resulted in this token.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   states: JArray
  ##         : If specified, only results with the specified `state` values will be
  ## returned. Otherwise, results with a `state` of `PENDING` will be returned.
  var path_579918 = newJObject()
  var query_579919 = newJObject()
  add(query_579919, "key", newJString(key))
  add(query_579919, "prettyPrint", newJBool(prettyPrint))
  add(query_579919, "oauth_token", newJString(oauthToken))
  add(query_579919, "$.xgafv", newJString(Xgafv))
  add(path_579918, "studentId", newJString(studentId))
  add(query_579919, "pageSize", newJInt(pageSize))
  add(query_579919, "invitedEmailAddress", newJString(invitedEmailAddress))
  add(query_579919, "alt", newJString(alt))
  add(query_579919, "uploadType", newJString(uploadType))
  add(query_579919, "quotaUser", newJString(quotaUser))
  add(query_579919, "pageToken", newJString(pageToken))
  add(query_579919, "callback", newJString(callback))
  add(query_579919, "fields", newJString(fields))
  add(query_579919, "access_token", newJString(accessToken))
  add(query_579919, "upload_protocol", newJString(uploadProtocol))
  if states != nil:
    query_579919.add "states", states
  result = call_579917.call(path_579918, query_579919, nil, nil, nil)

var classroomUserProfilesGuardianInvitationsList* = Call_ClassroomUserProfilesGuardianInvitationsList_579897(
    name: "classroomUserProfilesGuardianInvitationsList",
    meth: HttpMethod.HttpGet, host: "classroom.googleapis.com",
    route: "/v1/userProfiles/{studentId}/guardianInvitations",
    validator: validate_ClassroomUserProfilesGuardianInvitationsList_579898,
    base: "/", url: url_ClassroomUserProfilesGuardianInvitationsList_579899,
    schemes: {Scheme.Https})
type
  Call_ClassroomUserProfilesGuardianInvitationsGet_579941 = ref object of OpenApiRestCall_578348
proc url_ClassroomUserProfilesGuardianInvitationsGet_579943(protocol: Scheme;
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

proc validate_ClassroomUserProfilesGuardianInvitationsGet_579942(path: JsonNode;
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
  ##   invitationId: JString (required)
  ##               : The `id` field of the `GuardianInvitation` being requested.
  ##   studentId: JString (required)
  ##            : The ID of the student whose guardian invitation is being requested.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `invitationId` field"
  var valid_579944 = path.getOrDefault("invitationId")
  valid_579944 = validateParameter(valid_579944, JString, required = true,
                                 default = nil)
  if valid_579944 != nil:
    section.add "invitationId", valid_579944
  var valid_579945 = path.getOrDefault("studentId")
  valid_579945 = validateParameter(valid_579945, JString, required = true,
                                 default = nil)
  if valid_579945 != nil:
    section.add "studentId", valid_579945
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
  var valid_579946 = query.getOrDefault("key")
  valid_579946 = validateParameter(valid_579946, JString, required = false,
                                 default = nil)
  if valid_579946 != nil:
    section.add "key", valid_579946
  var valid_579947 = query.getOrDefault("prettyPrint")
  valid_579947 = validateParameter(valid_579947, JBool, required = false,
                                 default = newJBool(true))
  if valid_579947 != nil:
    section.add "prettyPrint", valid_579947
  var valid_579948 = query.getOrDefault("oauth_token")
  valid_579948 = validateParameter(valid_579948, JString, required = false,
                                 default = nil)
  if valid_579948 != nil:
    section.add "oauth_token", valid_579948
  var valid_579949 = query.getOrDefault("$.xgafv")
  valid_579949 = validateParameter(valid_579949, JString, required = false,
                                 default = newJString("1"))
  if valid_579949 != nil:
    section.add "$.xgafv", valid_579949
  var valid_579950 = query.getOrDefault("alt")
  valid_579950 = validateParameter(valid_579950, JString, required = false,
                                 default = newJString("json"))
  if valid_579950 != nil:
    section.add "alt", valid_579950
  var valid_579951 = query.getOrDefault("uploadType")
  valid_579951 = validateParameter(valid_579951, JString, required = false,
                                 default = nil)
  if valid_579951 != nil:
    section.add "uploadType", valid_579951
  var valid_579952 = query.getOrDefault("quotaUser")
  valid_579952 = validateParameter(valid_579952, JString, required = false,
                                 default = nil)
  if valid_579952 != nil:
    section.add "quotaUser", valid_579952
  var valid_579953 = query.getOrDefault("callback")
  valid_579953 = validateParameter(valid_579953, JString, required = false,
                                 default = nil)
  if valid_579953 != nil:
    section.add "callback", valid_579953
  var valid_579954 = query.getOrDefault("fields")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = nil)
  if valid_579954 != nil:
    section.add "fields", valid_579954
  var valid_579955 = query.getOrDefault("access_token")
  valid_579955 = validateParameter(valid_579955, JString, required = false,
                                 default = nil)
  if valid_579955 != nil:
    section.add "access_token", valid_579955
  var valid_579956 = query.getOrDefault("upload_protocol")
  valid_579956 = validateParameter(valid_579956, JString, required = false,
                                 default = nil)
  if valid_579956 != nil:
    section.add "upload_protocol", valid_579956
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579957: Call_ClassroomUserProfilesGuardianInvitationsGet_579941;
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
  let valid = call_579957.validator(path, query, header, formData, body)
  let scheme = call_579957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579957.url(scheme.get, call_579957.host, call_579957.base,
                         call_579957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579957, url, valid)

proc call*(call_579958: Call_ClassroomUserProfilesGuardianInvitationsGet_579941;
          invitationId: string; studentId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   invitationId: string (required)
  ##               : The `id` field of the `GuardianInvitation` being requested.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   studentId: string (required)
  ##            : The ID of the student whose guardian invitation is being requested.
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
  var path_579959 = newJObject()
  var query_579960 = newJObject()
  add(query_579960, "key", newJString(key))
  add(query_579960, "prettyPrint", newJBool(prettyPrint))
  add(query_579960, "oauth_token", newJString(oauthToken))
  add(path_579959, "invitationId", newJString(invitationId))
  add(query_579960, "$.xgafv", newJString(Xgafv))
  add(path_579959, "studentId", newJString(studentId))
  add(query_579960, "alt", newJString(alt))
  add(query_579960, "uploadType", newJString(uploadType))
  add(query_579960, "quotaUser", newJString(quotaUser))
  add(query_579960, "callback", newJString(callback))
  add(query_579960, "fields", newJString(fields))
  add(query_579960, "access_token", newJString(accessToken))
  add(query_579960, "upload_protocol", newJString(uploadProtocol))
  result = call_579958.call(path_579959, query_579960, nil, nil, nil)

var classroomUserProfilesGuardianInvitationsGet* = Call_ClassroomUserProfilesGuardianInvitationsGet_579941(
    name: "classroomUserProfilesGuardianInvitationsGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com",
    route: "/v1/userProfiles/{studentId}/guardianInvitations/{invitationId}",
    validator: validate_ClassroomUserProfilesGuardianInvitationsGet_579942,
    base: "/", url: url_ClassroomUserProfilesGuardianInvitationsGet_579943,
    schemes: {Scheme.Https})
type
  Call_ClassroomUserProfilesGuardianInvitationsPatch_579961 = ref object of OpenApiRestCall_578348
proc url_ClassroomUserProfilesGuardianInvitationsPatch_579963(protocol: Scheme;
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

proc validate_ClassroomUserProfilesGuardianInvitationsPatch_579962(
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
  ##   invitationId: JString (required)
  ##               : The `id` field of the `GuardianInvitation` to be modified.
  ##   studentId: JString (required)
  ##            : The ID of the student whose guardian invitation is to be modified.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `invitationId` field"
  var valid_579964 = path.getOrDefault("invitationId")
  valid_579964 = validateParameter(valid_579964, JString, required = true,
                                 default = nil)
  if valid_579964 != nil:
    section.add "invitationId", valid_579964
  var valid_579965 = path.getOrDefault("studentId")
  valid_579965 = validateParameter(valid_579965, JString, required = true,
                                 default = nil)
  if valid_579965 != nil:
    section.add "studentId", valid_579965
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
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579966 = query.getOrDefault("key")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "key", valid_579966
  var valid_579967 = query.getOrDefault("prettyPrint")
  valid_579967 = validateParameter(valid_579967, JBool, required = false,
                                 default = newJBool(true))
  if valid_579967 != nil:
    section.add "prettyPrint", valid_579967
  var valid_579968 = query.getOrDefault("oauth_token")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "oauth_token", valid_579968
  var valid_579969 = query.getOrDefault("$.xgafv")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = newJString("1"))
  if valid_579969 != nil:
    section.add "$.xgafv", valid_579969
  var valid_579970 = query.getOrDefault("alt")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = newJString("json"))
  if valid_579970 != nil:
    section.add "alt", valid_579970
  var valid_579971 = query.getOrDefault("uploadType")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "uploadType", valid_579971
  var valid_579972 = query.getOrDefault("quotaUser")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "quotaUser", valid_579972
  var valid_579973 = query.getOrDefault("updateMask")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "updateMask", valid_579973
  var valid_579974 = query.getOrDefault("callback")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "callback", valid_579974
  var valid_579975 = query.getOrDefault("fields")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "fields", valid_579975
  var valid_579976 = query.getOrDefault("access_token")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "access_token", valid_579976
  var valid_579977 = query.getOrDefault("upload_protocol")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "upload_protocol", valid_579977
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

proc call*(call_579979: Call_ClassroomUserProfilesGuardianInvitationsPatch_579961;
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
  let valid = call_579979.validator(path, query, header, formData, body)
  let scheme = call_579979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579979.url(scheme.get, call_579979.host, call_579979.base,
                         call_579979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579979, url, valid)

proc call*(call_579980: Call_ClassroomUserProfilesGuardianInvitationsPatch_579961;
          invitationId: string; studentId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          updateMask: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   invitationId: string (required)
  ##               : The `id` field of the `GuardianInvitation` to be modified.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   studentId: string (required)
  ##            : The ID of the student whose guardian invitation is to be modified.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579981 = newJObject()
  var query_579982 = newJObject()
  var body_579983 = newJObject()
  add(query_579982, "key", newJString(key))
  add(query_579982, "prettyPrint", newJBool(prettyPrint))
  add(query_579982, "oauth_token", newJString(oauthToken))
  add(path_579981, "invitationId", newJString(invitationId))
  add(query_579982, "$.xgafv", newJString(Xgafv))
  add(path_579981, "studentId", newJString(studentId))
  add(query_579982, "alt", newJString(alt))
  add(query_579982, "uploadType", newJString(uploadType))
  add(query_579982, "quotaUser", newJString(quotaUser))
  add(query_579982, "updateMask", newJString(updateMask))
  if body != nil:
    body_579983 = body
  add(query_579982, "callback", newJString(callback))
  add(query_579982, "fields", newJString(fields))
  add(query_579982, "access_token", newJString(accessToken))
  add(query_579982, "upload_protocol", newJString(uploadProtocol))
  result = call_579980.call(path_579981, query_579982, nil, nil, body_579983)

var classroomUserProfilesGuardianInvitationsPatch* = Call_ClassroomUserProfilesGuardianInvitationsPatch_579961(
    name: "classroomUserProfilesGuardianInvitationsPatch",
    meth: HttpMethod.HttpPatch, host: "classroom.googleapis.com",
    route: "/v1/userProfiles/{studentId}/guardianInvitations/{invitationId}",
    validator: validate_ClassroomUserProfilesGuardianInvitationsPatch_579962,
    base: "/", url: url_ClassroomUserProfilesGuardianInvitationsPatch_579963,
    schemes: {Scheme.Https})
type
  Call_ClassroomUserProfilesGuardiansList_579984 = ref object of OpenApiRestCall_578348
proc url_ClassroomUserProfilesGuardiansList_579986(protocol: Scheme; host: string;
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

proc validate_ClassroomUserProfilesGuardiansList_579985(path: JsonNode;
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
  var valid_579987 = path.getOrDefault("studentId")
  valid_579987 = validateParameter(valid_579987, JString, required = true,
                                 default = nil)
  if valid_579987 != nil:
    section.add "studentId", valid_579987
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
  ##   pageSize: JInt
  ##           : Maximum number of items to return. Zero or unspecified indicates that the
  ## server may assign a maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   invitedEmailAddress: JString
  ##                      : Filter results by the email address that the original invitation was sent
  ## to, resulting in this guardian link.
  ## This filter can only be used by domain administrators.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : nextPageToken
  ## value returned from a previous
  ## list call,
  ## indicating that the subsequent page of results should be returned.
  ## 
  ## The list request
  ## must be otherwise identical to the one that resulted in this token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579988 = query.getOrDefault("key")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "key", valid_579988
  var valid_579989 = query.getOrDefault("prettyPrint")
  valid_579989 = validateParameter(valid_579989, JBool, required = false,
                                 default = newJBool(true))
  if valid_579989 != nil:
    section.add "prettyPrint", valid_579989
  var valid_579990 = query.getOrDefault("oauth_token")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "oauth_token", valid_579990
  var valid_579991 = query.getOrDefault("$.xgafv")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = newJString("1"))
  if valid_579991 != nil:
    section.add "$.xgafv", valid_579991
  var valid_579992 = query.getOrDefault("pageSize")
  valid_579992 = validateParameter(valid_579992, JInt, required = false, default = nil)
  if valid_579992 != nil:
    section.add "pageSize", valid_579992
  var valid_579993 = query.getOrDefault("invitedEmailAddress")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "invitedEmailAddress", valid_579993
  var valid_579994 = query.getOrDefault("alt")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = newJString("json"))
  if valid_579994 != nil:
    section.add "alt", valid_579994
  var valid_579995 = query.getOrDefault("uploadType")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "uploadType", valid_579995
  var valid_579996 = query.getOrDefault("quotaUser")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "quotaUser", valid_579996
  var valid_579997 = query.getOrDefault("pageToken")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "pageToken", valid_579997
  var valid_579998 = query.getOrDefault("callback")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "callback", valid_579998
  var valid_579999 = query.getOrDefault("fields")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "fields", valid_579999
  var valid_580000 = query.getOrDefault("access_token")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "access_token", valid_580000
  var valid_580001 = query.getOrDefault("upload_protocol")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "upload_protocol", valid_580001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580002: Call_ClassroomUserProfilesGuardiansList_579984;
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
  let valid = call_580002.validator(path, query, header, formData, body)
  let scheme = call_580002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580002.url(scheme.get, call_580002.host, call_580002.base,
                         call_580002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580002, url, valid)

proc call*(call_580003: Call_ClassroomUserProfilesGuardiansList_579984;
          studentId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          invitedEmailAddress: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   studentId: string (required)
  ##            : Filter results by the student who the guardian is linked to.
  ## The identifier can be one of the following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  ## * the string literal `"-"`, indicating that results should be returned for
  ##   all students that the requesting user has access to view.
  ##   pageSize: int
  ##           : Maximum number of items to return. Zero or unspecified indicates that the
  ## server may assign a maximum.
  ## 
  ## The server may return fewer than the specified number of results.
  ##   invitedEmailAddress: string
  ##                      : Filter results by the email address that the original invitation was sent
  ## to, resulting in this guardian link.
  ## This filter can only be used by domain administrators.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : nextPageToken
  ## value returned from a previous
  ## list call,
  ## indicating that the subsequent page of results should be returned.
  ## 
  ## The list request
  ## must be otherwise identical to the one that resulted in this token.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580004 = newJObject()
  var query_580005 = newJObject()
  add(query_580005, "key", newJString(key))
  add(query_580005, "prettyPrint", newJBool(prettyPrint))
  add(query_580005, "oauth_token", newJString(oauthToken))
  add(query_580005, "$.xgafv", newJString(Xgafv))
  add(path_580004, "studentId", newJString(studentId))
  add(query_580005, "pageSize", newJInt(pageSize))
  add(query_580005, "invitedEmailAddress", newJString(invitedEmailAddress))
  add(query_580005, "alt", newJString(alt))
  add(query_580005, "uploadType", newJString(uploadType))
  add(query_580005, "quotaUser", newJString(quotaUser))
  add(query_580005, "pageToken", newJString(pageToken))
  add(query_580005, "callback", newJString(callback))
  add(query_580005, "fields", newJString(fields))
  add(query_580005, "access_token", newJString(accessToken))
  add(query_580005, "upload_protocol", newJString(uploadProtocol))
  result = call_580003.call(path_580004, query_580005, nil, nil, nil)

var classroomUserProfilesGuardiansList* = Call_ClassroomUserProfilesGuardiansList_579984(
    name: "classroomUserProfilesGuardiansList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com",
    route: "/v1/userProfiles/{studentId}/guardians",
    validator: validate_ClassroomUserProfilesGuardiansList_579985, base: "/",
    url: url_ClassroomUserProfilesGuardiansList_579986, schemes: {Scheme.Https})
type
  Call_ClassroomUserProfilesGuardiansGet_580006 = ref object of OpenApiRestCall_578348
proc url_ClassroomUserProfilesGuardiansGet_580008(protocol: Scheme; host: string;
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

proc validate_ClassroomUserProfilesGuardiansGet_580007(path: JsonNode;
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
  var valid_580009 = path.getOrDefault("guardianId")
  valid_580009 = validateParameter(valid_580009, JString, required = true,
                                 default = nil)
  if valid_580009 != nil:
    section.add "guardianId", valid_580009
  var valid_580010 = path.getOrDefault("studentId")
  valid_580010 = validateParameter(valid_580010, JString, required = true,
                                 default = nil)
  if valid_580010 != nil:
    section.add "studentId", valid_580010
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
  var valid_580011 = query.getOrDefault("key")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "key", valid_580011
  var valid_580012 = query.getOrDefault("prettyPrint")
  valid_580012 = validateParameter(valid_580012, JBool, required = false,
                                 default = newJBool(true))
  if valid_580012 != nil:
    section.add "prettyPrint", valid_580012
  var valid_580013 = query.getOrDefault("oauth_token")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "oauth_token", valid_580013
  var valid_580014 = query.getOrDefault("$.xgafv")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = newJString("1"))
  if valid_580014 != nil:
    section.add "$.xgafv", valid_580014
  var valid_580015 = query.getOrDefault("alt")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = newJString("json"))
  if valid_580015 != nil:
    section.add "alt", valid_580015
  var valid_580016 = query.getOrDefault("uploadType")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "uploadType", valid_580016
  var valid_580017 = query.getOrDefault("quotaUser")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "quotaUser", valid_580017
  var valid_580018 = query.getOrDefault("callback")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "callback", valid_580018
  var valid_580019 = query.getOrDefault("fields")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "fields", valid_580019
  var valid_580020 = query.getOrDefault("access_token")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "access_token", valid_580020
  var valid_580021 = query.getOrDefault("upload_protocol")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "upload_protocol", valid_580021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580022: Call_ClassroomUserProfilesGuardiansGet_580006;
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
  let valid = call_580022.validator(path, query, header, formData, body)
  let scheme = call_580022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580022.url(scheme.get, call_580022.host, call_580022.base,
                         call_580022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580022, url, valid)

proc call*(call_580023: Call_ClassroomUserProfilesGuardiansGet_580006;
          guardianId: string; studentId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   guardianId: string (required)
  ##             : The `id` field from a `Guardian`.
  ##   studentId: string (required)
  ##            : The student whose guardian is being requested. One of the following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
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
  var path_580024 = newJObject()
  var query_580025 = newJObject()
  add(query_580025, "key", newJString(key))
  add(query_580025, "prettyPrint", newJBool(prettyPrint))
  add(query_580025, "oauth_token", newJString(oauthToken))
  add(query_580025, "$.xgafv", newJString(Xgafv))
  add(path_580024, "guardianId", newJString(guardianId))
  add(path_580024, "studentId", newJString(studentId))
  add(query_580025, "alt", newJString(alt))
  add(query_580025, "uploadType", newJString(uploadType))
  add(query_580025, "quotaUser", newJString(quotaUser))
  add(query_580025, "callback", newJString(callback))
  add(query_580025, "fields", newJString(fields))
  add(query_580025, "access_token", newJString(accessToken))
  add(query_580025, "upload_protocol", newJString(uploadProtocol))
  result = call_580023.call(path_580024, query_580025, nil, nil, nil)

var classroomUserProfilesGuardiansGet* = Call_ClassroomUserProfilesGuardiansGet_580006(
    name: "classroomUserProfilesGuardiansGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com",
    route: "/v1/userProfiles/{studentId}/guardians/{guardianId}",
    validator: validate_ClassroomUserProfilesGuardiansGet_580007, base: "/",
    url: url_ClassroomUserProfilesGuardiansGet_580008, schemes: {Scheme.Https})
type
  Call_ClassroomUserProfilesGuardiansDelete_580026 = ref object of OpenApiRestCall_578348
proc url_ClassroomUserProfilesGuardiansDelete_580028(protocol: Scheme;
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

proc validate_ClassroomUserProfilesGuardiansDelete_580027(path: JsonNode;
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
  var valid_580029 = path.getOrDefault("guardianId")
  valid_580029 = validateParameter(valid_580029, JString, required = true,
                                 default = nil)
  if valid_580029 != nil:
    section.add "guardianId", valid_580029
  var valid_580030 = path.getOrDefault("studentId")
  valid_580030 = validateParameter(valid_580030, JString, required = true,
                                 default = nil)
  if valid_580030 != nil:
    section.add "studentId", valid_580030
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
  var valid_580031 = query.getOrDefault("key")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "key", valid_580031
  var valid_580032 = query.getOrDefault("prettyPrint")
  valid_580032 = validateParameter(valid_580032, JBool, required = false,
                                 default = newJBool(true))
  if valid_580032 != nil:
    section.add "prettyPrint", valid_580032
  var valid_580033 = query.getOrDefault("oauth_token")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "oauth_token", valid_580033
  var valid_580034 = query.getOrDefault("$.xgafv")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = newJString("1"))
  if valid_580034 != nil:
    section.add "$.xgafv", valid_580034
  var valid_580035 = query.getOrDefault("alt")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = newJString("json"))
  if valid_580035 != nil:
    section.add "alt", valid_580035
  var valid_580036 = query.getOrDefault("uploadType")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "uploadType", valid_580036
  var valid_580037 = query.getOrDefault("quotaUser")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "quotaUser", valid_580037
  var valid_580038 = query.getOrDefault("callback")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "callback", valid_580038
  var valid_580039 = query.getOrDefault("fields")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "fields", valid_580039
  var valid_580040 = query.getOrDefault("access_token")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "access_token", valid_580040
  var valid_580041 = query.getOrDefault("upload_protocol")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "upload_protocol", valid_580041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580042: Call_ClassroomUserProfilesGuardiansDelete_580026;
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
  let valid = call_580042.validator(path, query, header, formData, body)
  let scheme = call_580042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580042.url(scheme.get, call_580042.host, call_580042.base,
                         call_580042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580042, url, valid)

proc call*(call_580043: Call_ClassroomUserProfilesGuardiansDelete_580026;
          guardianId: string; studentId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   guardianId: string (required)
  ##             : The `id` field from a `Guardian`.
  ##   studentId: string (required)
  ##            : The student whose guardian is to be deleted. One of the following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
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
  var path_580044 = newJObject()
  var query_580045 = newJObject()
  add(query_580045, "key", newJString(key))
  add(query_580045, "prettyPrint", newJBool(prettyPrint))
  add(query_580045, "oauth_token", newJString(oauthToken))
  add(query_580045, "$.xgafv", newJString(Xgafv))
  add(path_580044, "guardianId", newJString(guardianId))
  add(path_580044, "studentId", newJString(studentId))
  add(query_580045, "alt", newJString(alt))
  add(query_580045, "uploadType", newJString(uploadType))
  add(query_580045, "quotaUser", newJString(quotaUser))
  add(query_580045, "callback", newJString(callback))
  add(query_580045, "fields", newJString(fields))
  add(query_580045, "access_token", newJString(accessToken))
  add(query_580045, "upload_protocol", newJString(uploadProtocol))
  result = call_580043.call(path_580044, query_580045, nil, nil, nil)

var classroomUserProfilesGuardiansDelete* = Call_ClassroomUserProfilesGuardiansDelete_580026(
    name: "classroomUserProfilesGuardiansDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com",
    route: "/v1/userProfiles/{studentId}/guardians/{guardianId}",
    validator: validate_ClassroomUserProfilesGuardiansDelete_580027, base: "/",
    url: url_ClassroomUserProfilesGuardiansDelete_580028, schemes: {Scheme.Https})
type
  Call_ClassroomUserProfilesGet_580046 = ref object of OpenApiRestCall_578348
proc url_ClassroomUserProfilesGet_580048(protocol: Scheme; host: string;
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

proc validate_ClassroomUserProfilesGet_580047(path: JsonNode; query: JsonNode;
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
  var valid_580049 = path.getOrDefault("userId")
  valid_580049 = validateParameter(valid_580049, JString, required = true,
                                 default = nil)
  if valid_580049 != nil:
    section.add "userId", valid_580049
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
  var valid_580050 = query.getOrDefault("key")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "key", valid_580050
  var valid_580051 = query.getOrDefault("prettyPrint")
  valid_580051 = validateParameter(valid_580051, JBool, required = false,
                                 default = newJBool(true))
  if valid_580051 != nil:
    section.add "prettyPrint", valid_580051
  var valid_580052 = query.getOrDefault("oauth_token")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "oauth_token", valid_580052
  var valid_580053 = query.getOrDefault("$.xgafv")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = newJString("1"))
  if valid_580053 != nil:
    section.add "$.xgafv", valid_580053
  var valid_580054 = query.getOrDefault("alt")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = newJString("json"))
  if valid_580054 != nil:
    section.add "alt", valid_580054
  var valid_580055 = query.getOrDefault("uploadType")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "uploadType", valid_580055
  var valid_580056 = query.getOrDefault("quotaUser")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "quotaUser", valid_580056
  var valid_580057 = query.getOrDefault("callback")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "callback", valid_580057
  var valid_580058 = query.getOrDefault("fields")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "fields", valid_580058
  var valid_580059 = query.getOrDefault("access_token")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "access_token", valid_580059
  var valid_580060 = query.getOrDefault("upload_protocol")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "upload_protocol", valid_580060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580061: Call_ClassroomUserProfilesGet_580046; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a user profile.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access
  ## this user profile, if no profile exists with the requested ID, or for
  ## access errors.
  ## 
  let valid = call_580061.validator(path, query, header, formData, body)
  let scheme = call_580061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580061.url(scheme.get, call_580061.host, call_580061.base,
                         call_580061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580061, url, valid)

proc call*(call_580062: Call_ClassroomUserProfilesGet_580046; userId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## classroomUserProfilesGet
  ## Returns a user profile.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access
  ## this user profile, if no profile exists with the requested ID, or for
  ## access errors.
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
  ##   userId: string (required)
  ##         : Identifier of the profile to return. The identifier can be one of the
  ## following:
  ## 
  ## * the numeric identifier for the user
  ## * the email address of the user
  ## * the string literal `"me"`, indicating the requesting user
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580063 = newJObject()
  var query_580064 = newJObject()
  add(query_580064, "key", newJString(key))
  add(query_580064, "prettyPrint", newJBool(prettyPrint))
  add(query_580064, "oauth_token", newJString(oauthToken))
  add(query_580064, "$.xgafv", newJString(Xgafv))
  add(query_580064, "alt", newJString(alt))
  add(query_580064, "uploadType", newJString(uploadType))
  add(query_580064, "quotaUser", newJString(quotaUser))
  add(path_580063, "userId", newJString(userId))
  add(query_580064, "callback", newJString(callback))
  add(query_580064, "fields", newJString(fields))
  add(query_580064, "access_token", newJString(accessToken))
  add(query_580064, "upload_protocol", newJString(uploadProtocol))
  result = call_580062.call(path_580063, query_580064, nil, nil, nil)

var classroomUserProfilesGet* = Call_ClassroomUserProfilesGet_580046(
    name: "classroomUserProfilesGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/userProfiles/{userId}",
    validator: validate_ClassroomUserProfilesGet_580047, base: "/",
    url: url_ClassroomUserProfilesGet_580048, schemes: {Scheme.Https})
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
