
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

  OpenApiRestCall_579421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579421): Option[Scheme] {.used.} =
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
  gcpServiceName = "classroom"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ClassroomCoursesCreate_579967 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesCreate_579969(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ClassroomCoursesCreate_579968(path: JsonNode; query: JsonNode;
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
  var valid_579970 = query.getOrDefault("upload_protocol")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "upload_protocol", valid_579970
  var valid_579971 = query.getOrDefault("fields")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "fields", valid_579971
  var valid_579972 = query.getOrDefault("quotaUser")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "quotaUser", valid_579972
  var valid_579973 = query.getOrDefault("alt")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = newJString("json"))
  if valid_579973 != nil:
    section.add "alt", valid_579973
  var valid_579974 = query.getOrDefault("oauth_token")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "oauth_token", valid_579974
  var valid_579975 = query.getOrDefault("callback")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "callback", valid_579975
  var valid_579976 = query.getOrDefault("access_token")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "access_token", valid_579976
  var valid_579977 = query.getOrDefault("uploadType")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "uploadType", valid_579977
  var valid_579978 = query.getOrDefault("key")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "key", valid_579978
  var valid_579979 = query.getOrDefault("$.xgafv")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = newJString("1"))
  if valid_579979 != nil:
    section.add "$.xgafv", valid_579979
  var valid_579980 = query.getOrDefault("prettyPrint")
  valid_579980 = validateParameter(valid_579980, JBool, required = false,
                                 default = newJBool(true))
  if valid_579980 != nil:
    section.add "prettyPrint", valid_579980
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

proc call*(call_579982: Call_ClassroomCoursesCreate_579967; path: JsonNode;
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
  let valid = call_579982.validator(path, query, header, formData, body)
  let scheme = call_579982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579982.url(scheme.get, call_579982.host, call_579982.base,
                         call_579982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579982, url, valid)

proc call*(call_579983: Call_ClassroomCoursesCreate_579967;
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
  var query_579984 = newJObject()
  var body_579985 = newJObject()
  add(query_579984, "upload_protocol", newJString(uploadProtocol))
  add(query_579984, "fields", newJString(fields))
  add(query_579984, "quotaUser", newJString(quotaUser))
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
  result = call_579983.call(nil, query_579984, nil, nil, body_579985)

var classroomCoursesCreate* = Call_ClassroomCoursesCreate_579967(
    name: "classroomCoursesCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/courses",
    validator: validate_ClassroomCoursesCreate_579968, base: "/",
    url: url_ClassroomCoursesCreate_579969, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesList_579690 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesList_579692(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ClassroomCoursesList_579691(path: JsonNode; query: JsonNode;
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
  var valid_579804 = query.getOrDefault("upload_protocol")
  valid_579804 = validateParameter(valid_579804, JString, required = false,
                                 default = nil)
  if valid_579804 != nil:
    section.add "upload_protocol", valid_579804
  var valid_579805 = query.getOrDefault("fields")
  valid_579805 = validateParameter(valid_579805, JString, required = false,
                                 default = nil)
  if valid_579805 != nil:
    section.add "fields", valid_579805
  var valid_579806 = query.getOrDefault("pageToken")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "pageToken", valid_579806
  var valid_579807 = query.getOrDefault("quotaUser")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "quotaUser", valid_579807
  var valid_579808 = query.getOrDefault("studentId")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "studentId", valid_579808
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
  var valid_579827 = query.getOrDefault("teacherId")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "teacherId", valid_579827
  var valid_579828 = query.getOrDefault("key")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = nil)
  if valid_579828 != nil:
    section.add "key", valid_579828
  var valid_579829 = query.getOrDefault("$.xgafv")
  valid_579829 = validateParameter(valid_579829, JString, required = false,
                                 default = newJString("1"))
  if valid_579829 != nil:
    section.add "$.xgafv", valid_579829
  var valid_579830 = query.getOrDefault("pageSize")
  valid_579830 = validateParameter(valid_579830, JInt, required = false, default = nil)
  if valid_579830 != nil:
    section.add "pageSize", valid_579830
  var valid_579831 = query.getOrDefault("prettyPrint")
  valid_579831 = validateParameter(valid_579831, JBool, required = false,
                                 default = newJBool(true))
  if valid_579831 != nil:
    section.add "prettyPrint", valid_579831
  var valid_579832 = query.getOrDefault("courseStates")
  valid_579832 = validateParameter(valid_579832, JArray, required = false,
                                 default = nil)
  if valid_579832 != nil:
    section.add "courseStates", valid_579832
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579855: Call_ClassroomCoursesList_579690; path: JsonNode;
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
  let valid = call_579855.validator(path, query, header, formData, body)
  let scheme = call_579855.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579855.url(scheme.get, call_579855.host, call_579855.base,
                         call_579855.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579855, url, valid)

proc call*(call_579926: Call_ClassroomCoursesList_579690;
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
  var query_579927 = newJObject()
  add(query_579927, "upload_protocol", newJString(uploadProtocol))
  add(query_579927, "fields", newJString(fields))
  add(query_579927, "pageToken", newJString(pageToken))
  add(query_579927, "quotaUser", newJString(quotaUser))
  add(query_579927, "studentId", newJString(studentId))
  add(query_579927, "alt", newJString(alt))
  add(query_579927, "oauth_token", newJString(oauthToken))
  add(query_579927, "callback", newJString(callback))
  add(query_579927, "access_token", newJString(accessToken))
  add(query_579927, "uploadType", newJString(uploadType))
  add(query_579927, "teacherId", newJString(teacherId))
  add(query_579927, "key", newJString(key))
  add(query_579927, "$.xgafv", newJString(Xgafv))
  add(query_579927, "pageSize", newJInt(pageSize))
  add(query_579927, "prettyPrint", newJBool(prettyPrint))
  if courseStates != nil:
    query_579927.add "courseStates", courseStates
  result = call_579926.call(nil, query_579927, nil, nil, nil)

var classroomCoursesList* = Call_ClassroomCoursesList_579690(
    name: "classroomCoursesList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/courses",
    validator: validate_ClassroomCoursesList_579691, base: "/",
    url: url_ClassroomCoursesList_579692, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAliasesCreate_580021 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesAliasesCreate_580023(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesAliasesCreate_580022(path: JsonNode; query: JsonNode;
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
  var valid_580024 = path.getOrDefault("courseId")
  valid_580024 = validateParameter(valid_580024, JString, required = true,
                                 default = nil)
  if valid_580024 != nil:
    section.add "courseId", valid_580024
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
  var valid_580025 = query.getOrDefault("upload_protocol")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "upload_protocol", valid_580025
  var valid_580026 = query.getOrDefault("fields")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "fields", valid_580026
  var valid_580027 = query.getOrDefault("quotaUser")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "quotaUser", valid_580027
  var valid_580028 = query.getOrDefault("alt")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = newJString("json"))
  if valid_580028 != nil:
    section.add "alt", valid_580028
  var valid_580029 = query.getOrDefault("oauth_token")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "oauth_token", valid_580029
  var valid_580030 = query.getOrDefault("callback")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "callback", valid_580030
  var valid_580031 = query.getOrDefault("access_token")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "access_token", valid_580031
  var valid_580032 = query.getOrDefault("uploadType")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "uploadType", valid_580032
  var valid_580033 = query.getOrDefault("key")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "key", valid_580033
  var valid_580034 = query.getOrDefault("$.xgafv")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = newJString("1"))
  if valid_580034 != nil:
    section.add "$.xgafv", valid_580034
  var valid_580035 = query.getOrDefault("prettyPrint")
  valid_580035 = validateParameter(valid_580035, JBool, required = false,
                                 default = newJBool(true))
  if valid_580035 != nil:
    section.add "prettyPrint", valid_580035
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

proc call*(call_580037: Call_ClassroomCoursesAliasesCreate_580021; path: JsonNode;
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
  let valid = call_580037.validator(path, query, header, formData, body)
  let scheme = call_580037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580037.url(scheme.get, call_580037.host, call_580037.base,
                         call_580037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580037, url, valid)

proc call*(call_580038: Call_ClassroomCoursesAliasesCreate_580021;
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
  var path_580039 = newJObject()
  var query_580040 = newJObject()
  var body_580041 = newJObject()
  add(query_580040, "upload_protocol", newJString(uploadProtocol))
  add(query_580040, "fields", newJString(fields))
  add(query_580040, "quotaUser", newJString(quotaUser))
  add(query_580040, "alt", newJString(alt))
  add(query_580040, "oauth_token", newJString(oauthToken))
  add(query_580040, "callback", newJString(callback))
  add(query_580040, "access_token", newJString(accessToken))
  add(query_580040, "uploadType", newJString(uploadType))
  add(query_580040, "key", newJString(key))
  add(path_580039, "courseId", newJString(courseId))
  add(query_580040, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580041 = body
  add(query_580040, "prettyPrint", newJBool(prettyPrint))
  result = call_580038.call(path_580039, query_580040, nil, nil, body_580041)

var classroomCoursesAliasesCreate* = Call_ClassroomCoursesAliasesCreate_580021(
    name: "classroomCoursesAliasesCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/aliases",
    validator: validate_ClassroomCoursesAliasesCreate_580022, base: "/",
    url: url_ClassroomCoursesAliasesCreate_580023, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAliasesList_579986 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesAliasesList_579988(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesAliasesList_579987(path: JsonNode; query: JsonNode;
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
  var valid_580003 = path.getOrDefault("courseId")
  valid_580003 = validateParameter(valid_580003, JString, required = true,
                                 default = nil)
  if valid_580003 != nil:
    section.add "courseId", valid_580003
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
  var valid_580004 = query.getOrDefault("upload_protocol")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "upload_protocol", valid_580004
  var valid_580005 = query.getOrDefault("fields")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "fields", valid_580005
  var valid_580006 = query.getOrDefault("pageToken")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "pageToken", valid_580006
  var valid_580007 = query.getOrDefault("quotaUser")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "quotaUser", valid_580007
  var valid_580008 = query.getOrDefault("alt")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = newJString("json"))
  if valid_580008 != nil:
    section.add "alt", valid_580008
  var valid_580009 = query.getOrDefault("oauth_token")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "oauth_token", valid_580009
  var valid_580010 = query.getOrDefault("callback")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "callback", valid_580010
  var valid_580011 = query.getOrDefault("access_token")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "access_token", valid_580011
  var valid_580012 = query.getOrDefault("uploadType")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "uploadType", valid_580012
  var valid_580013 = query.getOrDefault("key")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "key", valid_580013
  var valid_580014 = query.getOrDefault("$.xgafv")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = newJString("1"))
  if valid_580014 != nil:
    section.add "$.xgafv", valid_580014
  var valid_580015 = query.getOrDefault("pageSize")
  valid_580015 = validateParameter(valid_580015, JInt, required = false, default = nil)
  if valid_580015 != nil:
    section.add "pageSize", valid_580015
  var valid_580016 = query.getOrDefault("prettyPrint")
  valid_580016 = validateParameter(valid_580016, JBool, required = false,
                                 default = newJBool(true))
  if valid_580016 != nil:
    section.add "prettyPrint", valid_580016
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580017: Call_ClassroomCoursesAliasesList_579986; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of aliases for a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## course or for access errors.
  ## * `NOT_FOUND` if the course does not exist.
  ## 
  let valid = call_580017.validator(path, query, header, formData, body)
  let scheme = call_580017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580017.url(scheme.get, call_580017.host, call_580017.base,
                         call_580017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580017, url, valid)

proc call*(call_580018: Call_ClassroomCoursesAliasesList_579986; courseId: string;
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
  var path_580019 = newJObject()
  var query_580020 = newJObject()
  add(query_580020, "upload_protocol", newJString(uploadProtocol))
  add(query_580020, "fields", newJString(fields))
  add(query_580020, "pageToken", newJString(pageToken))
  add(query_580020, "quotaUser", newJString(quotaUser))
  add(query_580020, "alt", newJString(alt))
  add(query_580020, "oauth_token", newJString(oauthToken))
  add(query_580020, "callback", newJString(callback))
  add(query_580020, "access_token", newJString(accessToken))
  add(query_580020, "uploadType", newJString(uploadType))
  add(query_580020, "key", newJString(key))
  add(path_580019, "courseId", newJString(courseId))
  add(query_580020, "$.xgafv", newJString(Xgafv))
  add(query_580020, "pageSize", newJInt(pageSize))
  add(query_580020, "prettyPrint", newJBool(prettyPrint))
  result = call_580018.call(path_580019, query_580020, nil, nil, nil)

var classroomCoursesAliasesList* = Call_ClassroomCoursesAliasesList_579986(
    name: "classroomCoursesAliasesList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/aliases",
    validator: validate_ClassroomCoursesAliasesList_579987, base: "/",
    url: url_ClassroomCoursesAliasesList_579988, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAliasesDelete_580042 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesAliasesDelete_580044(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesAliasesDelete_580043(path: JsonNode; query: JsonNode;
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
  var valid_580045 = path.getOrDefault("courseId")
  valid_580045 = validateParameter(valid_580045, JString, required = true,
                                 default = nil)
  if valid_580045 != nil:
    section.add "courseId", valid_580045
  var valid_580046 = path.getOrDefault("alias")
  valid_580046 = validateParameter(valid_580046, JString, required = true,
                                 default = nil)
  if valid_580046 != nil:
    section.add "alias", valid_580046
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
  var valid_580047 = query.getOrDefault("upload_protocol")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "upload_protocol", valid_580047
  var valid_580048 = query.getOrDefault("fields")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "fields", valid_580048
  var valid_580049 = query.getOrDefault("quotaUser")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "quotaUser", valid_580049
  var valid_580050 = query.getOrDefault("alt")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = newJString("json"))
  if valid_580050 != nil:
    section.add "alt", valid_580050
  var valid_580051 = query.getOrDefault("oauth_token")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "oauth_token", valid_580051
  var valid_580052 = query.getOrDefault("callback")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "callback", valid_580052
  var valid_580053 = query.getOrDefault("access_token")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "access_token", valid_580053
  var valid_580054 = query.getOrDefault("uploadType")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "uploadType", valid_580054
  var valid_580055 = query.getOrDefault("key")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "key", valid_580055
  var valid_580056 = query.getOrDefault("$.xgafv")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = newJString("1"))
  if valid_580056 != nil:
    section.add "$.xgafv", valid_580056
  var valid_580057 = query.getOrDefault("prettyPrint")
  valid_580057 = validateParameter(valid_580057, JBool, required = false,
                                 default = newJBool(true))
  if valid_580057 != nil:
    section.add "prettyPrint", valid_580057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580058: Call_ClassroomCoursesAliasesDelete_580042; path: JsonNode;
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
  let valid = call_580058.validator(path, query, header, formData, body)
  let scheme = call_580058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580058.url(scheme.get, call_580058.host, call_580058.base,
                         call_580058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580058, url, valid)

proc call*(call_580059: Call_ClassroomCoursesAliasesDelete_580042;
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
  var path_580060 = newJObject()
  var query_580061 = newJObject()
  add(query_580061, "upload_protocol", newJString(uploadProtocol))
  add(query_580061, "fields", newJString(fields))
  add(query_580061, "quotaUser", newJString(quotaUser))
  add(query_580061, "alt", newJString(alt))
  add(query_580061, "oauth_token", newJString(oauthToken))
  add(query_580061, "callback", newJString(callback))
  add(query_580061, "access_token", newJString(accessToken))
  add(query_580061, "uploadType", newJString(uploadType))
  add(query_580061, "key", newJString(key))
  add(path_580060, "courseId", newJString(courseId))
  add(query_580061, "$.xgafv", newJString(Xgafv))
  add(query_580061, "prettyPrint", newJBool(prettyPrint))
  add(path_580060, "alias", newJString(alias))
  result = call_580059.call(path_580060, query_580061, nil, nil, nil)

var classroomCoursesAliasesDelete* = Call_ClassroomCoursesAliasesDelete_580042(
    name: "classroomCoursesAliasesDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/aliases/{alias}",
    validator: validate_ClassroomCoursesAliasesDelete_580043, base: "/",
    url: url_ClassroomCoursesAliasesDelete_580044, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAnnouncementsCreate_580085 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesAnnouncementsCreate_580087(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesAnnouncementsCreate_580086(path: JsonNode;
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
  var valid_580088 = path.getOrDefault("courseId")
  valid_580088 = validateParameter(valid_580088, JString, required = true,
                                 default = nil)
  if valid_580088 != nil:
    section.add "courseId", valid_580088
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
  var valid_580089 = query.getOrDefault("upload_protocol")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "upload_protocol", valid_580089
  var valid_580090 = query.getOrDefault("fields")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "fields", valid_580090
  var valid_580091 = query.getOrDefault("quotaUser")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "quotaUser", valid_580091
  var valid_580092 = query.getOrDefault("alt")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = newJString("json"))
  if valid_580092 != nil:
    section.add "alt", valid_580092
  var valid_580093 = query.getOrDefault("oauth_token")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "oauth_token", valid_580093
  var valid_580094 = query.getOrDefault("callback")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "callback", valid_580094
  var valid_580095 = query.getOrDefault("access_token")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "access_token", valid_580095
  var valid_580096 = query.getOrDefault("uploadType")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "uploadType", valid_580096
  var valid_580097 = query.getOrDefault("key")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "key", valid_580097
  var valid_580098 = query.getOrDefault("$.xgafv")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = newJString("1"))
  if valid_580098 != nil:
    section.add "$.xgafv", valid_580098
  var valid_580099 = query.getOrDefault("prettyPrint")
  valid_580099 = validateParameter(valid_580099, JBool, required = false,
                                 default = newJBool(true))
  if valid_580099 != nil:
    section.add "prettyPrint", valid_580099
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

proc call*(call_580101: Call_ClassroomCoursesAnnouncementsCreate_580085;
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
  let valid = call_580101.validator(path, query, header, formData, body)
  let scheme = call_580101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580101.url(scheme.get, call_580101.host, call_580101.base,
                         call_580101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580101, url, valid)

proc call*(call_580102: Call_ClassroomCoursesAnnouncementsCreate_580085;
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
  var path_580103 = newJObject()
  var query_580104 = newJObject()
  var body_580105 = newJObject()
  add(query_580104, "upload_protocol", newJString(uploadProtocol))
  add(query_580104, "fields", newJString(fields))
  add(query_580104, "quotaUser", newJString(quotaUser))
  add(query_580104, "alt", newJString(alt))
  add(query_580104, "oauth_token", newJString(oauthToken))
  add(query_580104, "callback", newJString(callback))
  add(query_580104, "access_token", newJString(accessToken))
  add(query_580104, "uploadType", newJString(uploadType))
  add(query_580104, "key", newJString(key))
  add(path_580103, "courseId", newJString(courseId))
  add(query_580104, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580105 = body
  add(query_580104, "prettyPrint", newJBool(prettyPrint))
  result = call_580102.call(path_580103, query_580104, nil, nil, body_580105)

var classroomCoursesAnnouncementsCreate* = Call_ClassroomCoursesAnnouncementsCreate_580085(
    name: "classroomCoursesAnnouncementsCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/announcements",
    validator: validate_ClassroomCoursesAnnouncementsCreate_580086, base: "/",
    url: url_ClassroomCoursesAnnouncementsCreate_580087, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAnnouncementsList_580062 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesAnnouncementsList_580064(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesAnnouncementsList_580063(path: JsonNode;
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
  var valid_580065 = path.getOrDefault("courseId")
  valid_580065 = validateParameter(valid_580065, JString, required = true,
                                 default = nil)
  if valid_580065 != nil:
    section.add "courseId", valid_580065
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
  var valid_580066 = query.getOrDefault("announcementStates")
  valid_580066 = validateParameter(valid_580066, JArray, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "announcementStates", valid_580066
  var valid_580067 = query.getOrDefault("upload_protocol")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "upload_protocol", valid_580067
  var valid_580068 = query.getOrDefault("fields")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "fields", valid_580068
  var valid_580069 = query.getOrDefault("pageToken")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "pageToken", valid_580069
  var valid_580070 = query.getOrDefault("quotaUser")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "quotaUser", valid_580070
  var valid_580071 = query.getOrDefault("alt")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = newJString("json"))
  if valid_580071 != nil:
    section.add "alt", valid_580071
  var valid_580072 = query.getOrDefault("oauth_token")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "oauth_token", valid_580072
  var valid_580073 = query.getOrDefault("callback")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "callback", valid_580073
  var valid_580074 = query.getOrDefault("access_token")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "access_token", valid_580074
  var valid_580075 = query.getOrDefault("uploadType")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "uploadType", valid_580075
  var valid_580076 = query.getOrDefault("orderBy")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "orderBy", valid_580076
  var valid_580077 = query.getOrDefault("key")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "key", valid_580077
  var valid_580078 = query.getOrDefault("$.xgafv")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = newJString("1"))
  if valid_580078 != nil:
    section.add "$.xgafv", valid_580078
  var valid_580079 = query.getOrDefault("pageSize")
  valid_580079 = validateParameter(valid_580079, JInt, required = false, default = nil)
  if valid_580079 != nil:
    section.add "pageSize", valid_580079
  var valid_580080 = query.getOrDefault("prettyPrint")
  valid_580080 = validateParameter(valid_580080, JBool, required = false,
                                 default = newJBool(true))
  if valid_580080 != nil:
    section.add "prettyPrint", valid_580080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580081: Call_ClassroomCoursesAnnouncementsList_580062;
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
  let valid = call_580081.validator(path, query, header, formData, body)
  let scheme = call_580081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580081.url(scheme.get, call_580081.host, call_580081.base,
                         call_580081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580081, url, valid)

proc call*(call_580082: Call_ClassroomCoursesAnnouncementsList_580062;
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
  var path_580083 = newJObject()
  var query_580084 = newJObject()
  if announcementStates != nil:
    query_580084.add "announcementStates", announcementStates
  add(query_580084, "upload_protocol", newJString(uploadProtocol))
  add(query_580084, "fields", newJString(fields))
  add(query_580084, "pageToken", newJString(pageToken))
  add(query_580084, "quotaUser", newJString(quotaUser))
  add(query_580084, "alt", newJString(alt))
  add(query_580084, "oauth_token", newJString(oauthToken))
  add(query_580084, "callback", newJString(callback))
  add(query_580084, "access_token", newJString(accessToken))
  add(query_580084, "uploadType", newJString(uploadType))
  add(query_580084, "orderBy", newJString(orderBy))
  add(query_580084, "key", newJString(key))
  add(path_580083, "courseId", newJString(courseId))
  add(query_580084, "$.xgafv", newJString(Xgafv))
  add(query_580084, "pageSize", newJInt(pageSize))
  add(query_580084, "prettyPrint", newJBool(prettyPrint))
  result = call_580082.call(path_580083, query_580084, nil, nil, nil)

var classroomCoursesAnnouncementsList* = Call_ClassroomCoursesAnnouncementsList_580062(
    name: "classroomCoursesAnnouncementsList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/announcements",
    validator: validate_ClassroomCoursesAnnouncementsList_580063, base: "/",
    url: url_ClassroomCoursesAnnouncementsList_580064, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAnnouncementsGet_580106 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesAnnouncementsGet_580108(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesAnnouncementsGet_580107(path: JsonNode;
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
  var valid_580109 = path.getOrDefault("id")
  valid_580109 = validateParameter(valid_580109, JString, required = true,
                                 default = nil)
  if valid_580109 != nil:
    section.add "id", valid_580109
  var valid_580110 = path.getOrDefault("courseId")
  valid_580110 = validateParameter(valid_580110, JString, required = true,
                                 default = nil)
  if valid_580110 != nil:
    section.add "courseId", valid_580110
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
  var valid_580111 = query.getOrDefault("upload_protocol")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "upload_protocol", valid_580111
  var valid_580112 = query.getOrDefault("fields")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "fields", valid_580112
  var valid_580113 = query.getOrDefault("quotaUser")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "quotaUser", valid_580113
  var valid_580114 = query.getOrDefault("alt")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = newJString("json"))
  if valid_580114 != nil:
    section.add "alt", valid_580114
  var valid_580115 = query.getOrDefault("oauth_token")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "oauth_token", valid_580115
  var valid_580116 = query.getOrDefault("callback")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "callback", valid_580116
  var valid_580117 = query.getOrDefault("access_token")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "access_token", valid_580117
  var valid_580118 = query.getOrDefault("uploadType")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "uploadType", valid_580118
  var valid_580119 = query.getOrDefault("key")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "key", valid_580119
  var valid_580120 = query.getOrDefault("$.xgafv")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = newJString("1"))
  if valid_580120 != nil:
    section.add "$.xgafv", valid_580120
  var valid_580121 = query.getOrDefault("prettyPrint")
  valid_580121 = validateParameter(valid_580121, JBool, required = false,
                                 default = newJBool(true))
  if valid_580121 != nil:
    section.add "prettyPrint", valid_580121
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580122: Call_ClassroomCoursesAnnouncementsGet_580106;
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
  let valid = call_580122.validator(path, query, header, formData, body)
  let scheme = call_580122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580122.url(scheme.get, call_580122.host, call_580122.base,
                         call_580122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580122, url, valid)

proc call*(call_580123: Call_ClassroomCoursesAnnouncementsGet_580106; id: string;
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
  var path_580124 = newJObject()
  var query_580125 = newJObject()
  add(query_580125, "upload_protocol", newJString(uploadProtocol))
  add(query_580125, "fields", newJString(fields))
  add(query_580125, "quotaUser", newJString(quotaUser))
  add(query_580125, "alt", newJString(alt))
  add(query_580125, "oauth_token", newJString(oauthToken))
  add(query_580125, "callback", newJString(callback))
  add(query_580125, "access_token", newJString(accessToken))
  add(query_580125, "uploadType", newJString(uploadType))
  add(path_580124, "id", newJString(id))
  add(query_580125, "key", newJString(key))
  add(path_580124, "courseId", newJString(courseId))
  add(query_580125, "$.xgafv", newJString(Xgafv))
  add(query_580125, "prettyPrint", newJBool(prettyPrint))
  result = call_580123.call(path_580124, query_580125, nil, nil, nil)

var classroomCoursesAnnouncementsGet* = Call_ClassroomCoursesAnnouncementsGet_580106(
    name: "classroomCoursesAnnouncementsGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/announcements/{id}",
    validator: validate_ClassroomCoursesAnnouncementsGet_580107, base: "/",
    url: url_ClassroomCoursesAnnouncementsGet_580108, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAnnouncementsPatch_580146 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesAnnouncementsPatch_580148(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesAnnouncementsPatch_580147(path: JsonNode;
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
  var valid_580149 = path.getOrDefault("id")
  valid_580149 = validateParameter(valid_580149, JString, required = true,
                                 default = nil)
  if valid_580149 != nil:
    section.add "id", valid_580149
  var valid_580150 = path.getOrDefault("courseId")
  valid_580150 = validateParameter(valid_580150, JString, required = true,
                                 default = nil)
  if valid_580150 != nil:
    section.add "courseId", valid_580150
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
  var valid_580151 = query.getOrDefault("upload_protocol")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "upload_protocol", valid_580151
  var valid_580152 = query.getOrDefault("fields")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "fields", valid_580152
  var valid_580153 = query.getOrDefault("quotaUser")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "quotaUser", valid_580153
  var valid_580154 = query.getOrDefault("alt")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = newJString("json"))
  if valid_580154 != nil:
    section.add "alt", valid_580154
  var valid_580155 = query.getOrDefault("oauth_token")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "oauth_token", valid_580155
  var valid_580156 = query.getOrDefault("callback")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "callback", valid_580156
  var valid_580157 = query.getOrDefault("access_token")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "access_token", valid_580157
  var valid_580158 = query.getOrDefault("uploadType")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "uploadType", valid_580158
  var valid_580159 = query.getOrDefault("key")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "key", valid_580159
  var valid_580160 = query.getOrDefault("$.xgafv")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = newJString("1"))
  if valid_580160 != nil:
    section.add "$.xgafv", valid_580160
  var valid_580161 = query.getOrDefault("prettyPrint")
  valid_580161 = validateParameter(valid_580161, JBool, required = false,
                                 default = newJBool(true))
  if valid_580161 != nil:
    section.add "prettyPrint", valid_580161
  var valid_580162 = query.getOrDefault("updateMask")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "updateMask", valid_580162
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

proc call*(call_580164: Call_ClassroomCoursesAnnouncementsPatch_580146;
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
  let valid = call_580164.validator(path, query, header, formData, body)
  let scheme = call_580164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580164.url(scheme.get, call_580164.host, call_580164.base,
                         call_580164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580164, url, valid)

proc call*(call_580165: Call_ClassroomCoursesAnnouncementsPatch_580146; id: string;
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
  var path_580166 = newJObject()
  var query_580167 = newJObject()
  var body_580168 = newJObject()
  add(query_580167, "upload_protocol", newJString(uploadProtocol))
  add(query_580167, "fields", newJString(fields))
  add(query_580167, "quotaUser", newJString(quotaUser))
  add(query_580167, "alt", newJString(alt))
  add(query_580167, "oauth_token", newJString(oauthToken))
  add(query_580167, "callback", newJString(callback))
  add(query_580167, "access_token", newJString(accessToken))
  add(query_580167, "uploadType", newJString(uploadType))
  add(path_580166, "id", newJString(id))
  add(query_580167, "key", newJString(key))
  add(path_580166, "courseId", newJString(courseId))
  add(query_580167, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580168 = body
  add(query_580167, "prettyPrint", newJBool(prettyPrint))
  add(query_580167, "updateMask", newJString(updateMask))
  result = call_580165.call(path_580166, query_580167, nil, nil, body_580168)

var classroomCoursesAnnouncementsPatch* = Call_ClassroomCoursesAnnouncementsPatch_580146(
    name: "classroomCoursesAnnouncementsPatch", meth: HttpMethod.HttpPatch,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/announcements/{id}",
    validator: validate_ClassroomCoursesAnnouncementsPatch_580147, base: "/",
    url: url_ClassroomCoursesAnnouncementsPatch_580148, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAnnouncementsDelete_580126 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesAnnouncementsDelete_580128(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesAnnouncementsDelete_580127(path: JsonNode;
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
  var valid_580129 = path.getOrDefault("id")
  valid_580129 = validateParameter(valid_580129, JString, required = true,
                                 default = nil)
  if valid_580129 != nil:
    section.add "id", valid_580129
  var valid_580130 = path.getOrDefault("courseId")
  valid_580130 = validateParameter(valid_580130, JString, required = true,
                                 default = nil)
  if valid_580130 != nil:
    section.add "courseId", valid_580130
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
  var valid_580131 = query.getOrDefault("upload_protocol")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "upload_protocol", valid_580131
  var valid_580132 = query.getOrDefault("fields")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "fields", valid_580132
  var valid_580133 = query.getOrDefault("quotaUser")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "quotaUser", valid_580133
  var valid_580134 = query.getOrDefault("alt")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = newJString("json"))
  if valid_580134 != nil:
    section.add "alt", valid_580134
  var valid_580135 = query.getOrDefault("oauth_token")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "oauth_token", valid_580135
  var valid_580136 = query.getOrDefault("callback")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "callback", valid_580136
  var valid_580137 = query.getOrDefault("access_token")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "access_token", valid_580137
  var valid_580138 = query.getOrDefault("uploadType")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "uploadType", valid_580138
  var valid_580139 = query.getOrDefault("key")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "key", valid_580139
  var valid_580140 = query.getOrDefault("$.xgafv")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = newJString("1"))
  if valid_580140 != nil:
    section.add "$.xgafv", valid_580140
  var valid_580141 = query.getOrDefault("prettyPrint")
  valid_580141 = validateParameter(valid_580141, JBool, required = false,
                                 default = newJBool(true))
  if valid_580141 != nil:
    section.add "prettyPrint", valid_580141
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580142: Call_ClassroomCoursesAnnouncementsDelete_580126;
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
  let valid = call_580142.validator(path, query, header, formData, body)
  let scheme = call_580142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580142.url(scheme.get, call_580142.host, call_580142.base,
                         call_580142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580142, url, valid)

proc call*(call_580143: Call_ClassroomCoursesAnnouncementsDelete_580126;
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
  var path_580144 = newJObject()
  var query_580145 = newJObject()
  add(query_580145, "upload_protocol", newJString(uploadProtocol))
  add(query_580145, "fields", newJString(fields))
  add(query_580145, "quotaUser", newJString(quotaUser))
  add(query_580145, "alt", newJString(alt))
  add(query_580145, "oauth_token", newJString(oauthToken))
  add(query_580145, "callback", newJString(callback))
  add(query_580145, "access_token", newJString(accessToken))
  add(query_580145, "uploadType", newJString(uploadType))
  add(path_580144, "id", newJString(id))
  add(query_580145, "key", newJString(key))
  add(path_580144, "courseId", newJString(courseId))
  add(query_580145, "$.xgafv", newJString(Xgafv))
  add(query_580145, "prettyPrint", newJBool(prettyPrint))
  result = call_580143.call(path_580144, query_580145, nil, nil, nil)

var classroomCoursesAnnouncementsDelete* = Call_ClassroomCoursesAnnouncementsDelete_580126(
    name: "classroomCoursesAnnouncementsDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/announcements/{id}",
    validator: validate_ClassroomCoursesAnnouncementsDelete_580127, base: "/",
    url: url_ClassroomCoursesAnnouncementsDelete_580128, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAnnouncementsModifyAssignees_580169 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesAnnouncementsModifyAssignees_580171(protocol: Scheme;
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

proc validate_ClassroomCoursesAnnouncementsModifyAssignees_580170(path: JsonNode;
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
  var valid_580172 = path.getOrDefault("id")
  valid_580172 = validateParameter(valid_580172, JString, required = true,
                                 default = nil)
  if valid_580172 != nil:
    section.add "id", valid_580172
  var valid_580173 = path.getOrDefault("courseId")
  valid_580173 = validateParameter(valid_580173, JString, required = true,
                                 default = nil)
  if valid_580173 != nil:
    section.add "courseId", valid_580173
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
  var valid_580174 = query.getOrDefault("upload_protocol")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "upload_protocol", valid_580174
  var valid_580175 = query.getOrDefault("fields")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "fields", valid_580175
  var valid_580176 = query.getOrDefault("quotaUser")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "quotaUser", valid_580176
  var valid_580177 = query.getOrDefault("alt")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = newJString("json"))
  if valid_580177 != nil:
    section.add "alt", valid_580177
  var valid_580178 = query.getOrDefault("oauth_token")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "oauth_token", valid_580178
  var valid_580179 = query.getOrDefault("callback")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "callback", valid_580179
  var valid_580180 = query.getOrDefault("access_token")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = nil)
  if valid_580180 != nil:
    section.add "access_token", valid_580180
  var valid_580181 = query.getOrDefault("uploadType")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = nil)
  if valid_580181 != nil:
    section.add "uploadType", valid_580181
  var valid_580182 = query.getOrDefault("key")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "key", valid_580182
  var valid_580183 = query.getOrDefault("$.xgafv")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = newJString("1"))
  if valid_580183 != nil:
    section.add "$.xgafv", valid_580183
  var valid_580184 = query.getOrDefault("prettyPrint")
  valid_580184 = validateParameter(valid_580184, JBool, required = false,
                                 default = newJBool(true))
  if valid_580184 != nil:
    section.add "prettyPrint", valid_580184
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

proc call*(call_580186: Call_ClassroomCoursesAnnouncementsModifyAssignees_580169;
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
  let valid = call_580186.validator(path, query, header, formData, body)
  let scheme = call_580186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580186.url(scheme.get, call_580186.host, call_580186.base,
                         call_580186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580186, url, valid)

proc call*(call_580187: Call_ClassroomCoursesAnnouncementsModifyAssignees_580169;
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
  var path_580188 = newJObject()
  var query_580189 = newJObject()
  var body_580190 = newJObject()
  add(query_580189, "upload_protocol", newJString(uploadProtocol))
  add(query_580189, "fields", newJString(fields))
  add(query_580189, "quotaUser", newJString(quotaUser))
  add(query_580189, "alt", newJString(alt))
  add(query_580189, "oauth_token", newJString(oauthToken))
  add(query_580189, "callback", newJString(callback))
  add(query_580189, "access_token", newJString(accessToken))
  add(query_580189, "uploadType", newJString(uploadType))
  add(path_580188, "id", newJString(id))
  add(query_580189, "key", newJString(key))
  add(path_580188, "courseId", newJString(courseId))
  add(query_580189, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580190 = body
  add(query_580189, "prettyPrint", newJBool(prettyPrint))
  result = call_580187.call(path_580188, query_580189, nil, nil, body_580190)

var classroomCoursesAnnouncementsModifyAssignees* = Call_ClassroomCoursesAnnouncementsModifyAssignees_580169(
    name: "classroomCoursesAnnouncementsModifyAssignees",
    meth: HttpMethod.HttpPost, host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/announcements/{id}:modifyAssignees",
    validator: validate_ClassroomCoursesAnnouncementsModifyAssignees_580170,
    base: "/", url: url_ClassroomCoursesAnnouncementsModifyAssignees_580171,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkCreate_580214 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesCourseWorkCreate_580216(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesCourseWorkCreate_580215(path: JsonNode;
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
  var valid_580217 = path.getOrDefault("courseId")
  valid_580217 = validateParameter(valid_580217, JString, required = true,
                                 default = nil)
  if valid_580217 != nil:
    section.add "courseId", valid_580217
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
  var valid_580218 = query.getOrDefault("upload_protocol")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = nil)
  if valid_580218 != nil:
    section.add "upload_protocol", valid_580218
  var valid_580219 = query.getOrDefault("fields")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "fields", valid_580219
  var valid_580220 = query.getOrDefault("quotaUser")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = nil)
  if valid_580220 != nil:
    section.add "quotaUser", valid_580220
  var valid_580221 = query.getOrDefault("alt")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = newJString("json"))
  if valid_580221 != nil:
    section.add "alt", valid_580221
  var valid_580222 = query.getOrDefault("oauth_token")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "oauth_token", valid_580222
  var valid_580223 = query.getOrDefault("callback")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "callback", valid_580223
  var valid_580224 = query.getOrDefault("access_token")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "access_token", valid_580224
  var valid_580225 = query.getOrDefault("uploadType")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "uploadType", valid_580225
  var valid_580226 = query.getOrDefault("key")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "key", valid_580226
  var valid_580227 = query.getOrDefault("$.xgafv")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = newJString("1"))
  if valid_580227 != nil:
    section.add "$.xgafv", valid_580227
  var valid_580228 = query.getOrDefault("prettyPrint")
  valid_580228 = validateParameter(valid_580228, JBool, required = false,
                                 default = newJBool(true))
  if valid_580228 != nil:
    section.add "prettyPrint", valid_580228
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

proc call*(call_580230: Call_ClassroomCoursesCourseWorkCreate_580214;
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
  let valid = call_580230.validator(path, query, header, formData, body)
  let scheme = call_580230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580230.url(scheme.get, call_580230.host, call_580230.base,
                         call_580230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580230, url, valid)

proc call*(call_580231: Call_ClassroomCoursesCourseWorkCreate_580214;
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
  var path_580232 = newJObject()
  var query_580233 = newJObject()
  var body_580234 = newJObject()
  add(query_580233, "upload_protocol", newJString(uploadProtocol))
  add(query_580233, "fields", newJString(fields))
  add(query_580233, "quotaUser", newJString(quotaUser))
  add(query_580233, "alt", newJString(alt))
  add(query_580233, "oauth_token", newJString(oauthToken))
  add(query_580233, "callback", newJString(callback))
  add(query_580233, "access_token", newJString(accessToken))
  add(query_580233, "uploadType", newJString(uploadType))
  add(query_580233, "key", newJString(key))
  add(path_580232, "courseId", newJString(courseId))
  add(query_580233, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580234 = body
  add(query_580233, "prettyPrint", newJBool(prettyPrint))
  result = call_580231.call(path_580232, query_580233, nil, nil, body_580234)

var classroomCoursesCourseWorkCreate* = Call_ClassroomCoursesCourseWorkCreate_580214(
    name: "classroomCoursesCourseWorkCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork",
    validator: validate_ClassroomCoursesCourseWorkCreate_580215, base: "/",
    url: url_ClassroomCoursesCourseWorkCreate_580216, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkList_580191 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesCourseWorkList_580193(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesCourseWorkList_580192(path: JsonNode;
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
  var valid_580194 = path.getOrDefault("courseId")
  valid_580194 = validateParameter(valid_580194, JString, required = true,
                                 default = nil)
  if valid_580194 != nil:
    section.add "courseId", valid_580194
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
  var valid_580195 = query.getOrDefault("upload_protocol")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "upload_protocol", valid_580195
  var valid_580196 = query.getOrDefault("fields")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "fields", valid_580196
  var valid_580197 = query.getOrDefault("pageToken")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "pageToken", valid_580197
  var valid_580198 = query.getOrDefault("quotaUser")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "quotaUser", valid_580198
  var valid_580199 = query.getOrDefault("alt")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = newJString("json"))
  if valid_580199 != nil:
    section.add "alt", valid_580199
  var valid_580200 = query.getOrDefault("oauth_token")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "oauth_token", valid_580200
  var valid_580201 = query.getOrDefault("callback")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "callback", valid_580201
  var valid_580202 = query.getOrDefault("access_token")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "access_token", valid_580202
  var valid_580203 = query.getOrDefault("uploadType")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "uploadType", valid_580203
  var valid_580204 = query.getOrDefault("orderBy")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "orderBy", valid_580204
  var valid_580205 = query.getOrDefault("key")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "key", valid_580205
  var valid_580206 = query.getOrDefault("courseWorkStates")
  valid_580206 = validateParameter(valid_580206, JArray, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "courseWorkStates", valid_580206
  var valid_580207 = query.getOrDefault("$.xgafv")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = newJString("1"))
  if valid_580207 != nil:
    section.add "$.xgafv", valid_580207
  var valid_580208 = query.getOrDefault("pageSize")
  valid_580208 = validateParameter(valid_580208, JInt, required = false, default = nil)
  if valid_580208 != nil:
    section.add "pageSize", valid_580208
  var valid_580209 = query.getOrDefault("prettyPrint")
  valid_580209 = validateParameter(valid_580209, JBool, required = false,
                                 default = newJBool(true))
  if valid_580209 != nil:
    section.add "prettyPrint", valid_580209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580210: Call_ClassroomCoursesCourseWorkList_580191; path: JsonNode;
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
  let valid = call_580210.validator(path, query, header, formData, body)
  let scheme = call_580210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580210.url(scheme.get, call_580210.host, call_580210.base,
                         call_580210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580210, url, valid)

proc call*(call_580211: Call_ClassroomCoursesCourseWorkList_580191;
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
  var path_580212 = newJObject()
  var query_580213 = newJObject()
  add(query_580213, "upload_protocol", newJString(uploadProtocol))
  add(query_580213, "fields", newJString(fields))
  add(query_580213, "pageToken", newJString(pageToken))
  add(query_580213, "quotaUser", newJString(quotaUser))
  add(query_580213, "alt", newJString(alt))
  add(query_580213, "oauth_token", newJString(oauthToken))
  add(query_580213, "callback", newJString(callback))
  add(query_580213, "access_token", newJString(accessToken))
  add(query_580213, "uploadType", newJString(uploadType))
  add(query_580213, "orderBy", newJString(orderBy))
  add(query_580213, "key", newJString(key))
  if courseWorkStates != nil:
    query_580213.add "courseWorkStates", courseWorkStates
  add(path_580212, "courseId", newJString(courseId))
  add(query_580213, "$.xgafv", newJString(Xgafv))
  add(query_580213, "pageSize", newJInt(pageSize))
  add(query_580213, "prettyPrint", newJBool(prettyPrint))
  result = call_580211.call(path_580212, query_580213, nil, nil, nil)

var classroomCoursesCourseWorkList* = Call_ClassroomCoursesCourseWorkList_580191(
    name: "classroomCoursesCourseWorkList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork",
    validator: validate_ClassroomCoursesCourseWorkList_580192, base: "/",
    url: url_ClassroomCoursesCourseWorkList_580193, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkStudentSubmissionsList_580235 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesCourseWorkStudentSubmissionsList_580237(
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

proc validate_ClassroomCoursesCourseWorkStudentSubmissionsList_580236(
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
  var valid_580238 = path.getOrDefault("courseWorkId")
  valid_580238 = validateParameter(valid_580238, JString, required = true,
                                 default = nil)
  if valid_580238 != nil:
    section.add "courseWorkId", valid_580238
  var valid_580239 = path.getOrDefault("courseId")
  valid_580239 = validateParameter(valid_580239, JString, required = true,
                                 default = nil)
  if valid_580239 != nil:
    section.add "courseId", valid_580239
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
  var valid_580240 = query.getOrDefault("upload_protocol")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "upload_protocol", valid_580240
  var valid_580241 = query.getOrDefault("fields")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "fields", valid_580241
  var valid_580242 = query.getOrDefault("pageToken")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "pageToken", valid_580242
  var valid_580243 = query.getOrDefault("quotaUser")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "quotaUser", valid_580243
  var valid_580244 = query.getOrDefault("alt")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = newJString("json"))
  if valid_580244 != nil:
    section.add "alt", valid_580244
  var valid_580245 = query.getOrDefault("oauth_token")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "oauth_token", valid_580245
  var valid_580246 = query.getOrDefault("callback")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "callback", valid_580246
  var valid_580247 = query.getOrDefault("access_token")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "access_token", valid_580247
  var valid_580248 = query.getOrDefault("uploadType")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "uploadType", valid_580248
  var valid_580249 = query.getOrDefault("key")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "key", valid_580249
  var valid_580250 = query.getOrDefault("states")
  valid_580250 = validateParameter(valid_580250, JArray, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "states", valid_580250
  var valid_580251 = query.getOrDefault("$.xgafv")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = newJString("1"))
  if valid_580251 != nil:
    section.add "$.xgafv", valid_580251
  var valid_580252 = query.getOrDefault("pageSize")
  valid_580252 = validateParameter(valid_580252, JInt, required = false, default = nil)
  if valid_580252 != nil:
    section.add "pageSize", valid_580252
  var valid_580253 = query.getOrDefault("late")
  valid_580253 = validateParameter(valid_580253, JString, required = false, default = newJString(
      "LATE_VALUES_UNSPECIFIED"))
  if valid_580253 != nil:
    section.add "late", valid_580253
  var valid_580254 = query.getOrDefault("prettyPrint")
  valid_580254 = validateParameter(valid_580254, JBool, required = false,
                                 default = newJBool(true))
  if valid_580254 != nil:
    section.add "prettyPrint", valid_580254
  var valid_580255 = query.getOrDefault("userId")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "userId", valid_580255
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580256: Call_ClassroomCoursesCourseWorkStudentSubmissionsList_580235;
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
  let valid = call_580256.validator(path, query, header, formData, body)
  let scheme = call_580256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580256.url(scheme.get, call_580256.host, call_580256.base,
                         call_580256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580256, url, valid)

proc call*(call_580257: Call_ClassroomCoursesCourseWorkStudentSubmissionsList_580235;
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
  var path_580258 = newJObject()
  var query_580259 = newJObject()
  add(query_580259, "upload_protocol", newJString(uploadProtocol))
  add(query_580259, "fields", newJString(fields))
  add(query_580259, "pageToken", newJString(pageToken))
  add(query_580259, "quotaUser", newJString(quotaUser))
  add(path_580258, "courseWorkId", newJString(courseWorkId))
  add(query_580259, "alt", newJString(alt))
  add(query_580259, "oauth_token", newJString(oauthToken))
  add(query_580259, "callback", newJString(callback))
  add(query_580259, "access_token", newJString(accessToken))
  add(query_580259, "uploadType", newJString(uploadType))
  add(query_580259, "key", newJString(key))
  if states != nil:
    query_580259.add "states", states
  add(path_580258, "courseId", newJString(courseId))
  add(query_580259, "$.xgafv", newJString(Xgafv))
  add(query_580259, "pageSize", newJInt(pageSize))
  add(query_580259, "late", newJString(late))
  add(query_580259, "prettyPrint", newJBool(prettyPrint))
  add(query_580259, "userId", newJString(userId))
  result = call_580257.call(path_580258, query_580259, nil, nil, nil)

var classroomCoursesCourseWorkStudentSubmissionsList* = Call_ClassroomCoursesCourseWorkStudentSubmissionsList_580235(
    name: "classroomCoursesCourseWorkStudentSubmissionsList",
    meth: HttpMethod.HttpGet, host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork/{courseWorkId}/studentSubmissions",
    validator: validate_ClassroomCoursesCourseWorkStudentSubmissionsList_580236,
    base: "/", url: url_ClassroomCoursesCourseWorkStudentSubmissionsList_580237,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkStudentSubmissionsGet_580260 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesCourseWorkStudentSubmissionsGet_580262(protocol: Scheme;
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

proc validate_ClassroomCoursesCourseWorkStudentSubmissionsGet_580261(
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
  var valid_580263 = path.getOrDefault("courseWorkId")
  valid_580263 = validateParameter(valid_580263, JString, required = true,
                                 default = nil)
  if valid_580263 != nil:
    section.add "courseWorkId", valid_580263
  var valid_580264 = path.getOrDefault("id")
  valid_580264 = validateParameter(valid_580264, JString, required = true,
                                 default = nil)
  if valid_580264 != nil:
    section.add "id", valid_580264
  var valid_580265 = path.getOrDefault("courseId")
  valid_580265 = validateParameter(valid_580265, JString, required = true,
                                 default = nil)
  if valid_580265 != nil:
    section.add "courseId", valid_580265
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
  var valid_580266 = query.getOrDefault("upload_protocol")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "upload_protocol", valid_580266
  var valid_580267 = query.getOrDefault("fields")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "fields", valid_580267
  var valid_580268 = query.getOrDefault("quotaUser")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = nil)
  if valid_580268 != nil:
    section.add "quotaUser", valid_580268
  var valid_580269 = query.getOrDefault("alt")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = newJString("json"))
  if valid_580269 != nil:
    section.add "alt", valid_580269
  var valid_580270 = query.getOrDefault("oauth_token")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "oauth_token", valid_580270
  var valid_580271 = query.getOrDefault("callback")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "callback", valid_580271
  var valid_580272 = query.getOrDefault("access_token")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "access_token", valid_580272
  var valid_580273 = query.getOrDefault("uploadType")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "uploadType", valid_580273
  var valid_580274 = query.getOrDefault("key")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "key", valid_580274
  var valid_580275 = query.getOrDefault("$.xgafv")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = newJString("1"))
  if valid_580275 != nil:
    section.add "$.xgafv", valid_580275
  var valid_580276 = query.getOrDefault("prettyPrint")
  valid_580276 = validateParameter(valid_580276, JBool, required = false,
                                 default = newJBool(true))
  if valid_580276 != nil:
    section.add "prettyPrint", valid_580276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580277: Call_ClassroomCoursesCourseWorkStudentSubmissionsGet_580260;
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
  let valid = call_580277.validator(path, query, header, formData, body)
  let scheme = call_580277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580277.url(scheme.get, call_580277.host, call_580277.base,
                         call_580277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580277, url, valid)

proc call*(call_580278: Call_ClassroomCoursesCourseWorkStudentSubmissionsGet_580260;
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
  var path_580279 = newJObject()
  var query_580280 = newJObject()
  add(query_580280, "upload_protocol", newJString(uploadProtocol))
  add(query_580280, "fields", newJString(fields))
  add(query_580280, "quotaUser", newJString(quotaUser))
  add(path_580279, "courseWorkId", newJString(courseWorkId))
  add(query_580280, "alt", newJString(alt))
  add(query_580280, "oauth_token", newJString(oauthToken))
  add(query_580280, "callback", newJString(callback))
  add(query_580280, "access_token", newJString(accessToken))
  add(query_580280, "uploadType", newJString(uploadType))
  add(path_580279, "id", newJString(id))
  add(query_580280, "key", newJString(key))
  add(path_580279, "courseId", newJString(courseId))
  add(query_580280, "$.xgafv", newJString(Xgafv))
  add(query_580280, "prettyPrint", newJBool(prettyPrint))
  result = call_580278.call(path_580279, query_580280, nil, nil, nil)

var classroomCoursesCourseWorkStudentSubmissionsGet* = Call_ClassroomCoursesCourseWorkStudentSubmissionsGet_580260(
    name: "classroomCoursesCourseWorkStudentSubmissionsGet",
    meth: HttpMethod.HttpGet, host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork/{courseWorkId}/studentSubmissions/{id}",
    validator: validate_ClassroomCoursesCourseWorkStudentSubmissionsGet_580261,
    base: "/", url: url_ClassroomCoursesCourseWorkStudentSubmissionsGet_580262,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkStudentSubmissionsPatch_580281 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesCourseWorkStudentSubmissionsPatch_580283(
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

proc validate_ClassroomCoursesCourseWorkStudentSubmissionsPatch_580282(
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
  var valid_580284 = path.getOrDefault("courseWorkId")
  valid_580284 = validateParameter(valid_580284, JString, required = true,
                                 default = nil)
  if valid_580284 != nil:
    section.add "courseWorkId", valid_580284
  var valid_580285 = path.getOrDefault("id")
  valid_580285 = validateParameter(valid_580285, JString, required = true,
                                 default = nil)
  if valid_580285 != nil:
    section.add "id", valid_580285
  var valid_580286 = path.getOrDefault("courseId")
  valid_580286 = validateParameter(valid_580286, JString, required = true,
                                 default = nil)
  if valid_580286 != nil:
    section.add "courseId", valid_580286
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
  var valid_580287 = query.getOrDefault("upload_protocol")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "upload_protocol", valid_580287
  var valid_580288 = query.getOrDefault("fields")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = nil)
  if valid_580288 != nil:
    section.add "fields", valid_580288
  var valid_580289 = query.getOrDefault("quotaUser")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = nil)
  if valid_580289 != nil:
    section.add "quotaUser", valid_580289
  var valid_580290 = query.getOrDefault("alt")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = newJString("json"))
  if valid_580290 != nil:
    section.add "alt", valid_580290
  var valid_580291 = query.getOrDefault("oauth_token")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "oauth_token", valid_580291
  var valid_580292 = query.getOrDefault("callback")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = nil)
  if valid_580292 != nil:
    section.add "callback", valid_580292
  var valid_580293 = query.getOrDefault("access_token")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "access_token", valid_580293
  var valid_580294 = query.getOrDefault("uploadType")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = nil)
  if valid_580294 != nil:
    section.add "uploadType", valid_580294
  var valid_580295 = query.getOrDefault("key")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "key", valid_580295
  var valid_580296 = query.getOrDefault("$.xgafv")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = newJString("1"))
  if valid_580296 != nil:
    section.add "$.xgafv", valid_580296
  var valid_580297 = query.getOrDefault("prettyPrint")
  valid_580297 = validateParameter(valid_580297, JBool, required = false,
                                 default = newJBool(true))
  if valid_580297 != nil:
    section.add "prettyPrint", valid_580297
  var valid_580298 = query.getOrDefault("updateMask")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = nil)
  if valid_580298 != nil:
    section.add "updateMask", valid_580298
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

proc call*(call_580300: Call_ClassroomCoursesCourseWorkStudentSubmissionsPatch_580281;
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
  let valid = call_580300.validator(path, query, header, formData, body)
  let scheme = call_580300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580300.url(scheme.get, call_580300.host, call_580300.base,
                         call_580300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580300, url, valid)

proc call*(call_580301: Call_ClassroomCoursesCourseWorkStudentSubmissionsPatch_580281;
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
  var path_580302 = newJObject()
  var query_580303 = newJObject()
  var body_580304 = newJObject()
  add(query_580303, "upload_protocol", newJString(uploadProtocol))
  add(query_580303, "fields", newJString(fields))
  add(query_580303, "quotaUser", newJString(quotaUser))
  add(path_580302, "courseWorkId", newJString(courseWorkId))
  add(query_580303, "alt", newJString(alt))
  add(query_580303, "oauth_token", newJString(oauthToken))
  add(query_580303, "callback", newJString(callback))
  add(query_580303, "access_token", newJString(accessToken))
  add(query_580303, "uploadType", newJString(uploadType))
  add(path_580302, "id", newJString(id))
  add(query_580303, "key", newJString(key))
  add(path_580302, "courseId", newJString(courseId))
  add(query_580303, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580304 = body
  add(query_580303, "prettyPrint", newJBool(prettyPrint))
  add(query_580303, "updateMask", newJString(updateMask))
  result = call_580301.call(path_580302, query_580303, nil, nil, body_580304)

var classroomCoursesCourseWorkStudentSubmissionsPatch* = Call_ClassroomCoursesCourseWorkStudentSubmissionsPatch_580281(
    name: "classroomCoursesCourseWorkStudentSubmissionsPatch",
    meth: HttpMethod.HttpPatch, host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork/{courseWorkId}/studentSubmissions/{id}",
    validator: validate_ClassroomCoursesCourseWorkStudentSubmissionsPatch_580282,
    base: "/", url: url_ClassroomCoursesCourseWorkStudentSubmissionsPatch_580283,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkStudentSubmissionsModifyAttachments_580305 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesCourseWorkStudentSubmissionsModifyAttachments_580307(
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

proc validate_ClassroomCoursesCourseWorkStudentSubmissionsModifyAttachments_580306(
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
  var valid_580308 = path.getOrDefault("courseWorkId")
  valid_580308 = validateParameter(valid_580308, JString, required = true,
                                 default = nil)
  if valid_580308 != nil:
    section.add "courseWorkId", valid_580308
  var valid_580309 = path.getOrDefault("id")
  valid_580309 = validateParameter(valid_580309, JString, required = true,
                                 default = nil)
  if valid_580309 != nil:
    section.add "id", valid_580309
  var valid_580310 = path.getOrDefault("courseId")
  valid_580310 = validateParameter(valid_580310, JString, required = true,
                                 default = nil)
  if valid_580310 != nil:
    section.add "courseId", valid_580310
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
  var valid_580311 = query.getOrDefault("upload_protocol")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = nil)
  if valid_580311 != nil:
    section.add "upload_protocol", valid_580311
  var valid_580312 = query.getOrDefault("fields")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = nil)
  if valid_580312 != nil:
    section.add "fields", valid_580312
  var valid_580313 = query.getOrDefault("quotaUser")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = nil)
  if valid_580313 != nil:
    section.add "quotaUser", valid_580313
  var valid_580314 = query.getOrDefault("alt")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = newJString("json"))
  if valid_580314 != nil:
    section.add "alt", valid_580314
  var valid_580315 = query.getOrDefault("oauth_token")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "oauth_token", valid_580315
  var valid_580316 = query.getOrDefault("callback")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "callback", valid_580316
  var valid_580317 = query.getOrDefault("access_token")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = nil)
  if valid_580317 != nil:
    section.add "access_token", valid_580317
  var valid_580318 = query.getOrDefault("uploadType")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = nil)
  if valid_580318 != nil:
    section.add "uploadType", valid_580318
  var valid_580319 = query.getOrDefault("key")
  valid_580319 = validateParameter(valid_580319, JString, required = false,
                                 default = nil)
  if valid_580319 != nil:
    section.add "key", valid_580319
  var valid_580320 = query.getOrDefault("$.xgafv")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = newJString("1"))
  if valid_580320 != nil:
    section.add "$.xgafv", valid_580320
  var valid_580321 = query.getOrDefault("prettyPrint")
  valid_580321 = validateParameter(valid_580321, JBool, required = false,
                                 default = newJBool(true))
  if valid_580321 != nil:
    section.add "prettyPrint", valid_580321
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

proc call*(call_580323: Call_ClassroomCoursesCourseWorkStudentSubmissionsModifyAttachments_580305;
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
  let valid = call_580323.validator(path, query, header, formData, body)
  let scheme = call_580323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580323.url(scheme.get, call_580323.host, call_580323.base,
                         call_580323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580323, url, valid)

proc call*(call_580324: Call_ClassroomCoursesCourseWorkStudentSubmissionsModifyAttachments_580305;
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
  var path_580325 = newJObject()
  var query_580326 = newJObject()
  var body_580327 = newJObject()
  add(query_580326, "upload_protocol", newJString(uploadProtocol))
  add(query_580326, "fields", newJString(fields))
  add(query_580326, "quotaUser", newJString(quotaUser))
  add(path_580325, "courseWorkId", newJString(courseWorkId))
  add(query_580326, "alt", newJString(alt))
  add(query_580326, "oauth_token", newJString(oauthToken))
  add(query_580326, "callback", newJString(callback))
  add(query_580326, "access_token", newJString(accessToken))
  add(query_580326, "uploadType", newJString(uploadType))
  add(path_580325, "id", newJString(id))
  add(query_580326, "key", newJString(key))
  add(path_580325, "courseId", newJString(courseId))
  add(query_580326, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580327 = body
  add(query_580326, "prettyPrint", newJBool(prettyPrint))
  result = call_580324.call(path_580325, query_580326, nil, nil, body_580327)

var classroomCoursesCourseWorkStudentSubmissionsModifyAttachments* = Call_ClassroomCoursesCourseWorkStudentSubmissionsModifyAttachments_580305(
    name: "classroomCoursesCourseWorkStudentSubmissionsModifyAttachments",
    meth: HttpMethod.HttpPost, host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork/{courseWorkId}/studentSubmissions/{id}:modifyAttachments", validator: validate_ClassroomCoursesCourseWorkStudentSubmissionsModifyAttachments_580306,
    base: "/",
    url: url_ClassroomCoursesCourseWorkStudentSubmissionsModifyAttachments_580307,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkStudentSubmissionsReclaim_580328 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesCourseWorkStudentSubmissionsReclaim_580330(
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

proc validate_ClassroomCoursesCourseWorkStudentSubmissionsReclaim_580329(
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
  var valid_580331 = path.getOrDefault("courseWorkId")
  valid_580331 = validateParameter(valid_580331, JString, required = true,
                                 default = nil)
  if valid_580331 != nil:
    section.add "courseWorkId", valid_580331
  var valid_580332 = path.getOrDefault("id")
  valid_580332 = validateParameter(valid_580332, JString, required = true,
                                 default = nil)
  if valid_580332 != nil:
    section.add "id", valid_580332
  var valid_580333 = path.getOrDefault("courseId")
  valid_580333 = validateParameter(valid_580333, JString, required = true,
                                 default = nil)
  if valid_580333 != nil:
    section.add "courseId", valid_580333
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
  var valid_580334 = query.getOrDefault("upload_protocol")
  valid_580334 = validateParameter(valid_580334, JString, required = false,
                                 default = nil)
  if valid_580334 != nil:
    section.add "upload_protocol", valid_580334
  var valid_580335 = query.getOrDefault("fields")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = nil)
  if valid_580335 != nil:
    section.add "fields", valid_580335
  var valid_580336 = query.getOrDefault("quotaUser")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = nil)
  if valid_580336 != nil:
    section.add "quotaUser", valid_580336
  var valid_580337 = query.getOrDefault("alt")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = newJString("json"))
  if valid_580337 != nil:
    section.add "alt", valid_580337
  var valid_580338 = query.getOrDefault("oauth_token")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "oauth_token", valid_580338
  var valid_580339 = query.getOrDefault("callback")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "callback", valid_580339
  var valid_580340 = query.getOrDefault("access_token")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = nil)
  if valid_580340 != nil:
    section.add "access_token", valid_580340
  var valid_580341 = query.getOrDefault("uploadType")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = nil)
  if valid_580341 != nil:
    section.add "uploadType", valid_580341
  var valid_580342 = query.getOrDefault("key")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = nil)
  if valid_580342 != nil:
    section.add "key", valid_580342
  var valid_580343 = query.getOrDefault("$.xgafv")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = newJString("1"))
  if valid_580343 != nil:
    section.add "$.xgafv", valid_580343
  var valid_580344 = query.getOrDefault("prettyPrint")
  valid_580344 = validateParameter(valid_580344, JBool, required = false,
                                 default = newJBool(true))
  if valid_580344 != nil:
    section.add "prettyPrint", valid_580344
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

proc call*(call_580346: Call_ClassroomCoursesCourseWorkStudentSubmissionsReclaim_580328;
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
  let valid = call_580346.validator(path, query, header, formData, body)
  let scheme = call_580346.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580346.url(scheme.get, call_580346.host, call_580346.base,
                         call_580346.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580346, url, valid)

proc call*(call_580347: Call_ClassroomCoursesCourseWorkStudentSubmissionsReclaim_580328;
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
  var path_580348 = newJObject()
  var query_580349 = newJObject()
  var body_580350 = newJObject()
  add(query_580349, "upload_protocol", newJString(uploadProtocol))
  add(query_580349, "fields", newJString(fields))
  add(query_580349, "quotaUser", newJString(quotaUser))
  add(path_580348, "courseWorkId", newJString(courseWorkId))
  add(query_580349, "alt", newJString(alt))
  add(query_580349, "oauth_token", newJString(oauthToken))
  add(query_580349, "callback", newJString(callback))
  add(query_580349, "access_token", newJString(accessToken))
  add(query_580349, "uploadType", newJString(uploadType))
  add(path_580348, "id", newJString(id))
  add(query_580349, "key", newJString(key))
  add(path_580348, "courseId", newJString(courseId))
  add(query_580349, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580350 = body
  add(query_580349, "prettyPrint", newJBool(prettyPrint))
  result = call_580347.call(path_580348, query_580349, nil, nil, body_580350)

var classroomCoursesCourseWorkStudentSubmissionsReclaim* = Call_ClassroomCoursesCourseWorkStudentSubmissionsReclaim_580328(
    name: "classroomCoursesCourseWorkStudentSubmissionsReclaim",
    meth: HttpMethod.HttpPost, host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork/{courseWorkId}/studentSubmissions/{id}:reclaim",
    validator: validate_ClassroomCoursesCourseWorkStudentSubmissionsReclaim_580329,
    base: "/", url: url_ClassroomCoursesCourseWorkStudentSubmissionsReclaim_580330,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkStudentSubmissionsReturn_580351 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesCourseWorkStudentSubmissionsReturn_580353(
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

proc validate_ClassroomCoursesCourseWorkStudentSubmissionsReturn_580352(
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
  var valid_580354 = path.getOrDefault("courseWorkId")
  valid_580354 = validateParameter(valid_580354, JString, required = true,
                                 default = nil)
  if valid_580354 != nil:
    section.add "courseWorkId", valid_580354
  var valid_580355 = path.getOrDefault("id")
  valid_580355 = validateParameter(valid_580355, JString, required = true,
                                 default = nil)
  if valid_580355 != nil:
    section.add "id", valid_580355
  var valid_580356 = path.getOrDefault("courseId")
  valid_580356 = validateParameter(valid_580356, JString, required = true,
                                 default = nil)
  if valid_580356 != nil:
    section.add "courseId", valid_580356
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
  var valid_580357 = query.getOrDefault("upload_protocol")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = nil)
  if valid_580357 != nil:
    section.add "upload_protocol", valid_580357
  var valid_580358 = query.getOrDefault("fields")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = nil)
  if valid_580358 != nil:
    section.add "fields", valid_580358
  var valid_580359 = query.getOrDefault("quotaUser")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = nil)
  if valid_580359 != nil:
    section.add "quotaUser", valid_580359
  var valid_580360 = query.getOrDefault("alt")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = newJString("json"))
  if valid_580360 != nil:
    section.add "alt", valid_580360
  var valid_580361 = query.getOrDefault("oauth_token")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "oauth_token", valid_580361
  var valid_580362 = query.getOrDefault("callback")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = nil)
  if valid_580362 != nil:
    section.add "callback", valid_580362
  var valid_580363 = query.getOrDefault("access_token")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = nil)
  if valid_580363 != nil:
    section.add "access_token", valid_580363
  var valid_580364 = query.getOrDefault("uploadType")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = nil)
  if valid_580364 != nil:
    section.add "uploadType", valid_580364
  var valid_580365 = query.getOrDefault("key")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "key", valid_580365
  var valid_580366 = query.getOrDefault("$.xgafv")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = newJString("1"))
  if valid_580366 != nil:
    section.add "$.xgafv", valid_580366
  var valid_580367 = query.getOrDefault("prettyPrint")
  valid_580367 = validateParameter(valid_580367, JBool, required = false,
                                 default = newJBool(true))
  if valid_580367 != nil:
    section.add "prettyPrint", valid_580367
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

proc call*(call_580369: Call_ClassroomCoursesCourseWorkStudentSubmissionsReturn_580351;
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
  let valid = call_580369.validator(path, query, header, formData, body)
  let scheme = call_580369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580369.url(scheme.get, call_580369.host, call_580369.base,
                         call_580369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580369, url, valid)

proc call*(call_580370: Call_ClassroomCoursesCourseWorkStudentSubmissionsReturn_580351;
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
  var path_580371 = newJObject()
  var query_580372 = newJObject()
  var body_580373 = newJObject()
  add(query_580372, "upload_protocol", newJString(uploadProtocol))
  add(query_580372, "fields", newJString(fields))
  add(query_580372, "quotaUser", newJString(quotaUser))
  add(path_580371, "courseWorkId", newJString(courseWorkId))
  add(query_580372, "alt", newJString(alt))
  add(query_580372, "oauth_token", newJString(oauthToken))
  add(query_580372, "callback", newJString(callback))
  add(query_580372, "access_token", newJString(accessToken))
  add(query_580372, "uploadType", newJString(uploadType))
  add(path_580371, "id", newJString(id))
  add(query_580372, "key", newJString(key))
  add(path_580371, "courseId", newJString(courseId))
  add(query_580372, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580373 = body
  add(query_580372, "prettyPrint", newJBool(prettyPrint))
  result = call_580370.call(path_580371, query_580372, nil, nil, body_580373)

var classroomCoursesCourseWorkStudentSubmissionsReturn* = Call_ClassroomCoursesCourseWorkStudentSubmissionsReturn_580351(
    name: "classroomCoursesCourseWorkStudentSubmissionsReturn",
    meth: HttpMethod.HttpPost, host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork/{courseWorkId}/studentSubmissions/{id}:return",
    validator: validate_ClassroomCoursesCourseWorkStudentSubmissionsReturn_580352,
    base: "/", url: url_ClassroomCoursesCourseWorkStudentSubmissionsReturn_580353,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkStudentSubmissionsTurnIn_580374 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesCourseWorkStudentSubmissionsTurnIn_580376(
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

proc validate_ClassroomCoursesCourseWorkStudentSubmissionsTurnIn_580375(
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
  var valid_580377 = path.getOrDefault("courseWorkId")
  valid_580377 = validateParameter(valid_580377, JString, required = true,
                                 default = nil)
  if valid_580377 != nil:
    section.add "courseWorkId", valid_580377
  var valid_580378 = path.getOrDefault("id")
  valid_580378 = validateParameter(valid_580378, JString, required = true,
                                 default = nil)
  if valid_580378 != nil:
    section.add "id", valid_580378
  var valid_580379 = path.getOrDefault("courseId")
  valid_580379 = validateParameter(valid_580379, JString, required = true,
                                 default = nil)
  if valid_580379 != nil:
    section.add "courseId", valid_580379
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
  var valid_580380 = query.getOrDefault("upload_protocol")
  valid_580380 = validateParameter(valid_580380, JString, required = false,
                                 default = nil)
  if valid_580380 != nil:
    section.add "upload_protocol", valid_580380
  var valid_580381 = query.getOrDefault("fields")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = nil)
  if valid_580381 != nil:
    section.add "fields", valid_580381
  var valid_580382 = query.getOrDefault("quotaUser")
  valid_580382 = validateParameter(valid_580382, JString, required = false,
                                 default = nil)
  if valid_580382 != nil:
    section.add "quotaUser", valid_580382
  var valid_580383 = query.getOrDefault("alt")
  valid_580383 = validateParameter(valid_580383, JString, required = false,
                                 default = newJString("json"))
  if valid_580383 != nil:
    section.add "alt", valid_580383
  var valid_580384 = query.getOrDefault("oauth_token")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = nil)
  if valid_580384 != nil:
    section.add "oauth_token", valid_580384
  var valid_580385 = query.getOrDefault("callback")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = nil)
  if valid_580385 != nil:
    section.add "callback", valid_580385
  var valid_580386 = query.getOrDefault("access_token")
  valid_580386 = validateParameter(valid_580386, JString, required = false,
                                 default = nil)
  if valid_580386 != nil:
    section.add "access_token", valid_580386
  var valid_580387 = query.getOrDefault("uploadType")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = nil)
  if valid_580387 != nil:
    section.add "uploadType", valid_580387
  var valid_580388 = query.getOrDefault("key")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = nil)
  if valid_580388 != nil:
    section.add "key", valid_580388
  var valid_580389 = query.getOrDefault("$.xgafv")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = newJString("1"))
  if valid_580389 != nil:
    section.add "$.xgafv", valid_580389
  var valid_580390 = query.getOrDefault("prettyPrint")
  valid_580390 = validateParameter(valid_580390, JBool, required = false,
                                 default = newJBool(true))
  if valid_580390 != nil:
    section.add "prettyPrint", valid_580390
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

proc call*(call_580392: Call_ClassroomCoursesCourseWorkStudentSubmissionsTurnIn_580374;
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
  let valid = call_580392.validator(path, query, header, formData, body)
  let scheme = call_580392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580392.url(scheme.get, call_580392.host, call_580392.base,
                         call_580392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580392, url, valid)

proc call*(call_580393: Call_ClassroomCoursesCourseWorkStudentSubmissionsTurnIn_580374;
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
  var path_580394 = newJObject()
  var query_580395 = newJObject()
  var body_580396 = newJObject()
  add(query_580395, "upload_protocol", newJString(uploadProtocol))
  add(query_580395, "fields", newJString(fields))
  add(query_580395, "quotaUser", newJString(quotaUser))
  add(path_580394, "courseWorkId", newJString(courseWorkId))
  add(query_580395, "alt", newJString(alt))
  add(query_580395, "oauth_token", newJString(oauthToken))
  add(query_580395, "callback", newJString(callback))
  add(query_580395, "access_token", newJString(accessToken))
  add(query_580395, "uploadType", newJString(uploadType))
  add(path_580394, "id", newJString(id))
  add(query_580395, "key", newJString(key))
  add(path_580394, "courseId", newJString(courseId))
  add(query_580395, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580396 = body
  add(query_580395, "prettyPrint", newJBool(prettyPrint))
  result = call_580393.call(path_580394, query_580395, nil, nil, body_580396)

var classroomCoursesCourseWorkStudentSubmissionsTurnIn* = Call_ClassroomCoursesCourseWorkStudentSubmissionsTurnIn_580374(
    name: "classroomCoursesCourseWorkStudentSubmissionsTurnIn",
    meth: HttpMethod.HttpPost, host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork/{courseWorkId}/studentSubmissions/{id}:turnIn",
    validator: validate_ClassroomCoursesCourseWorkStudentSubmissionsTurnIn_580375,
    base: "/", url: url_ClassroomCoursesCourseWorkStudentSubmissionsTurnIn_580376,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkGet_580397 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesCourseWorkGet_580399(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesCourseWorkGet_580398(path: JsonNode; query: JsonNode;
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
  var valid_580400 = path.getOrDefault("id")
  valid_580400 = validateParameter(valid_580400, JString, required = true,
                                 default = nil)
  if valid_580400 != nil:
    section.add "id", valid_580400
  var valid_580401 = path.getOrDefault("courseId")
  valid_580401 = validateParameter(valid_580401, JString, required = true,
                                 default = nil)
  if valid_580401 != nil:
    section.add "courseId", valid_580401
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
  var valid_580402 = query.getOrDefault("upload_protocol")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = nil)
  if valid_580402 != nil:
    section.add "upload_protocol", valid_580402
  var valid_580403 = query.getOrDefault("fields")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = nil)
  if valid_580403 != nil:
    section.add "fields", valid_580403
  var valid_580404 = query.getOrDefault("quotaUser")
  valid_580404 = validateParameter(valid_580404, JString, required = false,
                                 default = nil)
  if valid_580404 != nil:
    section.add "quotaUser", valid_580404
  var valid_580405 = query.getOrDefault("alt")
  valid_580405 = validateParameter(valid_580405, JString, required = false,
                                 default = newJString("json"))
  if valid_580405 != nil:
    section.add "alt", valid_580405
  var valid_580406 = query.getOrDefault("oauth_token")
  valid_580406 = validateParameter(valid_580406, JString, required = false,
                                 default = nil)
  if valid_580406 != nil:
    section.add "oauth_token", valid_580406
  var valid_580407 = query.getOrDefault("callback")
  valid_580407 = validateParameter(valid_580407, JString, required = false,
                                 default = nil)
  if valid_580407 != nil:
    section.add "callback", valid_580407
  var valid_580408 = query.getOrDefault("access_token")
  valid_580408 = validateParameter(valid_580408, JString, required = false,
                                 default = nil)
  if valid_580408 != nil:
    section.add "access_token", valid_580408
  var valid_580409 = query.getOrDefault("uploadType")
  valid_580409 = validateParameter(valid_580409, JString, required = false,
                                 default = nil)
  if valid_580409 != nil:
    section.add "uploadType", valid_580409
  var valid_580410 = query.getOrDefault("key")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = nil)
  if valid_580410 != nil:
    section.add "key", valid_580410
  var valid_580411 = query.getOrDefault("$.xgafv")
  valid_580411 = validateParameter(valid_580411, JString, required = false,
                                 default = newJString("1"))
  if valid_580411 != nil:
    section.add "$.xgafv", valid_580411
  var valid_580412 = query.getOrDefault("prettyPrint")
  valid_580412 = validateParameter(valid_580412, JBool, required = false,
                                 default = newJBool(true))
  if valid_580412 != nil:
    section.add "prettyPrint", valid_580412
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580413: Call_ClassroomCoursesCourseWorkGet_580397; path: JsonNode;
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
  let valid = call_580413.validator(path, query, header, formData, body)
  let scheme = call_580413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580413.url(scheme.get, call_580413.host, call_580413.base,
                         call_580413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580413, url, valid)

proc call*(call_580414: Call_ClassroomCoursesCourseWorkGet_580397; id: string;
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
  var path_580415 = newJObject()
  var query_580416 = newJObject()
  add(query_580416, "upload_protocol", newJString(uploadProtocol))
  add(query_580416, "fields", newJString(fields))
  add(query_580416, "quotaUser", newJString(quotaUser))
  add(query_580416, "alt", newJString(alt))
  add(query_580416, "oauth_token", newJString(oauthToken))
  add(query_580416, "callback", newJString(callback))
  add(query_580416, "access_token", newJString(accessToken))
  add(query_580416, "uploadType", newJString(uploadType))
  add(path_580415, "id", newJString(id))
  add(query_580416, "key", newJString(key))
  add(path_580415, "courseId", newJString(courseId))
  add(query_580416, "$.xgafv", newJString(Xgafv))
  add(query_580416, "prettyPrint", newJBool(prettyPrint))
  result = call_580414.call(path_580415, query_580416, nil, nil, nil)

var classroomCoursesCourseWorkGet* = Call_ClassroomCoursesCourseWorkGet_580397(
    name: "classroomCoursesCourseWorkGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/courseWork/{id}",
    validator: validate_ClassroomCoursesCourseWorkGet_580398, base: "/",
    url: url_ClassroomCoursesCourseWorkGet_580399, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkPatch_580437 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesCourseWorkPatch_580439(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesCourseWorkPatch_580438(path: JsonNode;
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
  var valid_580440 = path.getOrDefault("id")
  valid_580440 = validateParameter(valid_580440, JString, required = true,
                                 default = nil)
  if valid_580440 != nil:
    section.add "id", valid_580440
  var valid_580441 = path.getOrDefault("courseId")
  valid_580441 = validateParameter(valid_580441, JString, required = true,
                                 default = nil)
  if valid_580441 != nil:
    section.add "courseId", valid_580441
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
  var valid_580442 = query.getOrDefault("upload_protocol")
  valid_580442 = validateParameter(valid_580442, JString, required = false,
                                 default = nil)
  if valid_580442 != nil:
    section.add "upload_protocol", valid_580442
  var valid_580443 = query.getOrDefault("fields")
  valid_580443 = validateParameter(valid_580443, JString, required = false,
                                 default = nil)
  if valid_580443 != nil:
    section.add "fields", valid_580443
  var valid_580444 = query.getOrDefault("quotaUser")
  valid_580444 = validateParameter(valid_580444, JString, required = false,
                                 default = nil)
  if valid_580444 != nil:
    section.add "quotaUser", valid_580444
  var valid_580445 = query.getOrDefault("alt")
  valid_580445 = validateParameter(valid_580445, JString, required = false,
                                 default = newJString("json"))
  if valid_580445 != nil:
    section.add "alt", valid_580445
  var valid_580446 = query.getOrDefault("oauth_token")
  valid_580446 = validateParameter(valid_580446, JString, required = false,
                                 default = nil)
  if valid_580446 != nil:
    section.add "oauth_token", valid_580446
  var valid_580447 = query.getOrDefault("callback")
  valid_580447 = validateParameter(valid_580447, JString, required = false,
                                 default = nil)
  if valid_580447 != nil:
    section.add "callback", valid_580447
  var valid_580448 = query.getOrDefault("access_token")
  valid_580448 = validateParameter(valid_580448, JString, required = false,
                                 default = nil)
  if valid_580448 != nil:
    section.add "access_token", valid_580448
  var valid_580449 = query.getOrDefault("uploadType")
  valid_580449 = validateParameter(valid_580449, JString, required = false,
                                 default = nil)
  if valid_580449 != nil:
    section.add "uploadType", valid_580449
  var valid_580450 = query.getOrDefault("key")
  valid_580450 = validateParameter(valid_580450, JString, required = false,
                                 default = nil)
  if valid_580450 != nil:
    section.add "key", valid_580450
  var valid_580451 = query.getOrDefault("$.xgafv")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = newJString("1"))
  if valid_580451 != nil:
    section.add "$.xgafv", valid_580451
  var valid_580452 = query.getOrDefault("prettyPrint")
  valid_580452 = validateParameter(valid_580452, JBool, required = false,
                                 default = newJBool(true))
  if valid_580452 != nil:
    section.add "prettyPrint", valid_580452
  var valid_580453 = query.getOrDefault("updateMask")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = nil)
  if valid_580453 != nil:
    section.add "updateMask", valid_580453
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

proc call*(call_580455: Call_ClassroomCoursesCourseWorkPatch_580437;
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
  let valid = call_580455.validator(path, query, header, formData, body)
  let scheme = call_580455.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580455.url(scheme.get, call_580455.host, call_580455.base,
                         call_580455.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580455, url, valid)

proc call*(call_580456: Call_ClassroomCoursesCourseWorkPatch_580437; id: string;
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
  var path_580457 = newJObject()
  var query_580458 = newJObject()
  var body_580459 = newJObject()
  add(query_580458, "upload_protocol", newJString(uploadProtocol))
  add(query_580458, "fields", newJString(fields))
  add(query_580458, "quotaUser", newJString(quotaUser))
  add(query_580458, "alt", newJString(alt))
  add(query_580458, "oauth_token", newJString(oauthToken))
  add(query_580458, "callback", newJString(callback))
  add(query_580458, "access_token", newJString(accessToken))
  add(query_580458, "uploadType", newJString(uploadType))
  add(path_580457, "id", newJString(id))
  add(query_580458, "key", newJString(key))
  add(path_580457, "courseId", newJString(courseId))
  add(query_580458, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580459 = body
  add(query_580458, "prettyPrint", newJBool(prettyPrint))
  add(query_580458, "updateMask", newJString(updateMask))
  result = call_580456.call(path_580457, query_580458, nil, nil, body_580459)

var classroomCoursesCourseWorkPatch* = Call_ClassroomCoursesCourseWorkPatch_580437(
    name: "classroomCoursesCourseWorkPatch", meth: HttpMethod.HttpPatch,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/courseWork/{id}",
    validator: validate_ClassroomCoursesCourseWorkPatch_580438, base: "/",
    url: url_ClassroomCoursesCourseWorkPatch_580439, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkDelete_580417 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesCourseWorkDelete_580419(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesCourseWorkDelete_580418(path: JsonNode;
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
  var valid_580420 = path.getOrDefault("id")
  valid_580420 = validateParameter(valid_580420, JString, required = true,
                                 default = nil)
  if valid_580420 != nil:
    section.add "id", valid_580420
  var valid_580421 = path.getOrDefault("courseId")
  valid_580421 = validateParameter(valid_580421, JString, required = true,
                                 default = nil)
  if valid_580421 != nil:
    section.add "courseId", valid_580421
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
  var valid_580422 = query.getOrDefault("upload_protocol")
  valid_580422 = validateParameter(valid_580422, JString, required = false,
                                 default = nil)
  if valid_580422 != nil:
    section.add "upload_protocol", valid_580422
  var valid_580423 = query.getOrDefault("fields")
  valid_580423 = validateParameter(valid_580423, JString, required = false,
                                 default = nil)
  if valid_580423 != nil:
    section.add "fields", valid_580423
  var valid_580424 = query.getOrDefault("quotaUser")
  valid_580424 = validateParameter(valid_580424, JString, required = false,
                                 default = nil)
  if valid_580424 != nil:
    section.add "quotaUser", valid_580424
  var valid_580425 = query.getOrDefault("alt")
  valid_580425 = validateParameter(valid_580425, JString, required = false,
                                 default = newJString("json"))
  if valid_580425 != nil:
    section.add "alt", valid_580425
  var valid_580426 = query.getOrDefault("oauth_token")
  valid_580426 = validateParameter(valid_580426, JString, required = false,
                                 default = nil)
  if valid_580426 != nil:
    section.add "oauth_token", valid_580426
  var valid_580427 = query.getOrDefault("callback")
  valid_580427 = validateParameter(valid_580427, JString, required = false,
                                 default = nil)
  if valid_580427 != nil:
    section.add "callback", valid_580427
  var valid_580428 = query.getOrDefault("access_token")
  valid_580428 = validateParameter(valid_580428, JString, required = false,
                                 default = nil)
  if valid_580428 != nil:
    section.add "access_token", valid_580428
  var valid_580429 = query.getOrDefault("uploadType")
  valid_580429 = validateParameter(valid_580429, JString, required = false,
                                 default = nil)
  if valid_580429 != nil:
    section.add "uploadType", valid_580429
  var valid_580430 = query.getOrDefault("key")
  valid_580430 = validateParameter(valid_580430, JString, required = false,
                                 default = nil)
  if valid_580430 != nil:
    section.add "key", valid_580430
  var valid_580431 = query.getOrDefault("$.xgafv")
  valid_580431 = validateParameter(valid_580431, JString, required = false,
                                 default = newJString("1"))
  if valid_580431 != nil:
    section.add "$.xgafv", valid_580431
  var valid_580432 = query.getOrDefault("prettyPrint")
  valid_580432 = validateParameter(valid_580432, JBool, required = false,
                                 default = newJBool(true))
  if valid_580432 != nil:
    section.add "prettyPrint", valid_580432
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580433: Call_ClassroomCoursesCourseWorkDelete_580417;
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
  let valid = call_580433.validator(path, query, header, formData, body)
  let scheme = call_580433.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580433.url(scheme.get, call_580433.host, call_580433.base,
                         call_580433.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580433, url, valid)

proc call*(call_580434: Call_ClassroomCoursesCourseWorkDelete_580417; id: string;
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
  var path_580435 = newJObject()
  var query_580436 = newJObject()
  add(query_580436, "upload_protocol", newJString(uploadProtocol))
  add(query_580436, "fields", newJString(fields))
  add(query_580436, "quotaUser", newJString(quotaUser))
  add(query_580436, "alt", newJString(alt))
  add(query_580436, "oauth_token", newJString(oauthToken))
  add(query_580436, "callback", newJString(callback))
  add(query_580436, "access_token", newJString(accessToken))
  add(query_580436, "uploadType", newJString(uploadType))
  add(path_580435, "id", newJString(id))
  add(query_580436, "key", newJString(key))
  add(path_580435, "courseId", newJString(courseId))
  add(query_580436, "$.xgafv", newJString(Xgafv))
  add(query_580436, "prettyPrint", newJBool(prettyPrint))
  result = call_580434.call(path_580435, query_580436, nil, nil, nil)

var classroomCoursesCourseWorkDelete* = Call_ClassroomCoursesCourseWorkDelete_580417(
    name: "classroomCoursesCourseWorkDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/courseWork/{id}",
    validator: validate_ClassroomCoursesCourseWorkDelete_580418, base: "/",
    url: url_ClassroomCoursesCourseWorkDelete_580419, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkModifyAssignees_580460 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesCourseWorkModifyAssignees_580462(protocol: Scheme;
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

proc validate_ClassroomCoursesCourseWorkModifyAssignees_580461(path: JsonNode;
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
  var valid_580463 = path.getOrDefault("id")
  valid_580463 = validateParameter(valid_580463, JString, required = true,
                                 default = nil)
  if valid_580463 != nil:
    section.add "id", valid_580463
  var valid_580464 = path.getOrDefault("courseId")
  valid_580464 = validateParameter(valid_580464, JString, required = true,
                                 default = nil)
  if valid_580464 != nil:
    section.add "courseId", valid_580464
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
  var valid_580465 = query.getOrDefault("upload_protocol")
  valid_580465 = validateParameter(valid_580465, JString, required = false,
                                 default = nil)
  if valid_580465 != nil:
    section.add "upload_protocol", valid_580465
  var valid_580466 = query.getOrDefault("fields")
  valid_580466 = validateParameter(valid_580466, JString, required = false,
                                 default = nil)
  if valid_580466 != nil:
    section.add "fields", valid_580466
  var valid_580467 = query.getOrDefault("quotaUser")
  valid_580467 = validateParameter(valid_580467, JString, required = false,
                                 default = nil)
  if valid_580467 != nil:
    section.add "quotaUser", valid_580467
  var valid_580468 = query.getOrDefault("alt")
  valid_580468 = validateParameter(valid_580468, JString, required = false,
                                 default = newJString("json"))
  if valid_580468 != nil:
    section.add "alt", valid_580468
  var valid_580469 = query.getOrDefault("oauth_token")
  valid_580469 = validateParameter(valid_580469, JString, required = false,
                                 default = nil)
  if valid_580469 != nil:
    section.add "oauth_token", valid_580469
  var valid_580470 = query.getOrDefault("callback")
  valid_580470 = validateParameter(valid_580470, JString, required = false,
                                 default = nil)
  if valid_580470 != nil:
    section.add "callback", valid_580470
  var valid_580471 = query.getOrDefault("access_token")
  valid_580471 = validateParameter(valid_580471, JString, required = false,
                                 default = nil)
  if valid_580471 != nil:
    section.add "access_token", valid_580471
  var valid_580472 = query.getOrDefault("uploadType")
  valid_580472 = validateParameter(valid_580472, JString, required = false,
                                 default = nil)
  if valid_580472 != nil:
    section.add "uploadType", valid_580472
  var valid_580473 = query.getOrDefault("key")
  valid_580473 = validateParameter(valid_580473, JString, required = false,
                                 default = nil)
  if valid_580473 != nil:
    section.add "key", valid_580473
  var valid_580474 = query.getOrDefault("$.xgafv")
  valid_580474 = validateParameter(valid_580474, JString, required = false,
                                 default = newJString("1"))
  if valid_580474 != nil:
    section.add "$.xgafv", valid_580474
  var valid_580475 = query.getOrDefault("prettyPrint")
  valid_580475 = validateParameter(valid_580475, JBool, required = false,
                                 default = newJBool(true))
  if valid_580475 != nil:
    section.add "prettyPrint", valid_580475
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

proc call*(call_580477: Call_ClassroomCoursesCourseWorkModifyAssignees_580460;
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
  let valid = call_580477.validator(path, query, header, formData, body)
  let scheme = call_580477.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580477.url(scheme.get, call_580477.host, call_580477.base,
                         call_580477.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580477, url, valid)

proc call*(call_580478: Call_ClassroomCoursesCourseWorkModifyAssignees_580460;
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
  var path_580479 = newJObject()
  var query_580480 = newJObject()
  var body_580481 = newJObject()
  add(query_580480, "upload_protocol", newJString(uploadProtocol))
  add(query_580480, "fields", newJString(fields))
  add(query_580480, "quotaUser", newJString(quotaUser))
  add(query_580480, "alt", newJString(alt))
  add(query_580480, "oauth_token", newJString(oauthToken))
  add(query_580480, "callback", newJString(callback))
  add(query_580480, "access_token", newJString(accessToken))
  add(query_580480, "uploadType", newJString(uploadType))
  add(path_580479, "id", newJString(id))
  add(query_580480, "key", newJString(key))
  add(path_580479, "courseId", newJString(courseId))
  add(query_580480, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580481 = body
  add(query_580480, "prettyPrint", newJBool(prettyPrint))
  result = call_580478.call(path_580479, query_580480, nil, nil, body_580481)

var classroomCoursesCourseWorkModifyAssignees* = Call_ClassroomCoursesCourseWorkModifyAssignees_580460(
    name: "classroomCoursesCourseWorkModifyAssignees", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/courseWork/{id}:modifyAssignees",
    validator: validate_ClassroomCoursesCourseWorkModifyAssignees_580461,
    base: "/", url: url_ClassroomCoursesCourseWorkModifyAssignees_580462,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesStudentsCreate_580503 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesStudentsCreate_580505(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesStudentsCreate_580504(path: JsonNode;
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
  var valid_580506 = path.getOrDefault("courseId")
  valid_580506 = validateParameter(valid_580506, JString, required = true,
                                 default = nil)
  if valid_580506 != nil:
    section.add "courseId", valid_580506
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
  var valid_580507 = query.getOrDefault("upload_protocol")
  valid_580507 = validateParameter(valid_580507, JString, required = false,
                                 default = nil)
  if valid_580507 != nil:
    section.add "upload_protocol", valid_580507
  var valid_580508 = query.getOrDefault("fields")
  valid_580508 = validateParameter(valid_580508, JString, required = false,
                                 default = nil)
  if valid_580508 != nil:
    section.add "fields", valid_580508
  var valid_580509 = query.getOrDefault("quotaUser")
  valid_580509 = validateParameter(valid_580509, JString, required = false,
                                 default = nil)
  if valid_580509 != nil:
    section.add "quotaUser", valid_580509
  var valid_580510 = query.getOrDefault("alt")
  valid_580510 = validateParameter(valid_580510, JString, required = false,
                                 default = newJString("json"))
  if valid_580510 != nil:
    section.add "alt", valid_580510
  var valid_580511 = query.getOrDefault("oauth_token")
  valid_580511 = validateParameter(valid_580511, JString, required = false,
                                 default = nil)
  if valid_580511 != nil:
    section.add "oauth_token", valid_580511
  var valid_580512 = query.getOrDefault("callback")
  valid_580512 = validateParameter(valid_580512, JString, required = false,
                                 default = nil)
  if valid_580512 != nil:
    section.add "callback", valid_580512
  var valid_580513 = query.getOrDefault("access_token")
  valid_580513 = validateParameter(valid_580513, JString, required = false,
                                 default = nil)
  if valid_580513 != nil:
    section.add "access_token", valid_580513
  var valid_580514 = query.getOrDefault("uploadType")
  valid_580514 = validateParameter(valid_580514, JString, required = false,
                                 default = nil)
  if valid_580514 != nil:
    section.add "uploadType", valid_580514
  var valid_580515 = query.getOrDefault("enrollmentCode")
  valid_580515 = validateParameter(valid_580515, JString, required = false,
                                 default = nil)
  if valid_580515 != nil:
    section.add "enrollmentCode", valid_580515
  var valid_580516 = query.getOrDefault("key")
  valid_580516 = validateParameter(valid_580516, JString, required = false,
                                 default = nil)
  if valid_580516 != nil:
    section.add "key", valid_580516
  var valid_580517 = query.getOrDefault("$.xgafv")
  valid_580517 = validateParameter(valid_580517, JString, required = false,
                                 default = newJString("1"))
  if valid_580517 != nil:
    section.add "$.xgafv", valid_580517
  var valid_580518 = query.getOrDefault("prettyPrint")
  valid_580518 = validateParameter(valid_580518, JBool, required = false,
                                 default = newJBool(true))
  if valid_580518 != nil:
    section.add "prettyPrint", valid_580518
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

proc call*(call_580520: Call_ClassroomCoursesStudentsCreate_580503; path: JsonNode;
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
  let valid = call_580520.validator(path, query, header, formData, body)
  let scheme = call_580520.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580520.url(scheme.get, call_580520.host, call_580520.base,
                         call_580520.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580520, url, valid)

proc call*(call_580521: Call_ClassroomCoursesStudentsCreate_580503;
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
  var path_580522 = newJObject()
  var query_580523 = newJObject()
  var body_580524 = newJObject()
  add(query_580523, "upload_protocol", newJString(uploadProtocol))
  add(query_580523, "fields", newJString(fields))
  add(query_580523, "quotaUser", newJString(quotaUser))
  add(query_580523, "alt", newJString(alt))
  add(query_580523, "oauth_token", newJString(oauthToken))
  add(query_580523, "callback", newJString(callback))
  add(query_580523, "access_token", newJString(accessToken))
  add(query_580523, "uploadType", newJString(uploadType))
  add(query_580523, "enrollmentCode", newJString(enrollmentCode))
  add(query_580523, "key", newJString(key))
  add(path_580522, "courseId", newJString(courseId))
  add(query_580523, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580524 = body
  add(query_580523, "prettyPrint", newJBool(prettyPrint))
  result = call_580521.call(path_580522, query_580523, nil, nil, body_580524)

var classroomCoursesStudentsCreate* = Call_ClassroomCoursesStudentsCreate_580503(
    name: "classroomCoursesStudentsCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/students",
    validator: validate_ClassroomCoursesStudentsCreate_580504, base: "/",
    url: url_ClassroomCoursesStudentsCreate_580505, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesStudentsList_580482 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesStudentsList_580484(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesStudentsList_580483(path: JsonNode; query: JsonNode;
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
  var valid_580485 = path.getOrDefault("courseId")
  valid_580485 = validateParameter(valid_580485, JString, required = true,
                                 default = nil)
  if valid_580485 != nil:
    section.add "courseId", valid_580485
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
  var valid_580486 = query.getOrDefault("upload_protocol")
  valid_580486 = validateParameter(valid_580486, JString, required = false,
                                 default = nil)
  if valid_580486 != nil:
    section.add "upload_protocol", valid_580486
  var valid_580487 = query.getOrDefault("fields")
  valid_580487 = validateParameter(valid_580487, JString, required = false,
                                 default = nil)
  if valid_580487 != nil:
    section.add "fields", valid_580487
  var valid_580488 = query.getOrDefault("pageToken")
  valid_580488 = validateParameter(valid_580488, JString, required = false,
                                 default = nil)
  if valid_580488 != nil:
    section.add "pageToken", valid_580488
  var valid_580489 = query.getOrDefault("quotaUser")
  valid_580489 = validateParameter(valid_580489, JString, required = false,
                                 default = nil)
  if valid_580489 != nil:
    section.add "quotaUser", valid_580489
  var valid_580490 = query.getOrDefault("alt")
  valid_580490 = validateParameter(valid_580490, JString, required = false,
                                 default = newJString("json"))
  if valid_580490 != nil:
    section.add "alt", valid_580490
  var valid_580491 = query.getOrDefault("oauth_token")
  valid_580491 = validateParameter(valid_580491, JString, required = false,
                                 default = nil)
  if valid_580491 != nil:
    section.add "oauth_token", valid_580491
  var valid_580492 = query.getOrDefault("callback")
  valid_580492 = validateParameter(valid_580492, JString, required = false,
                                 default = nil)
  if valid_580492 != nil:
    section.add "callback", valid_580492
  var valid_580493 = query.getOrDefault("access_token")
  valid_580493 = validateParameter(valid_580493, JString, required = false,
                                 default = nil)
  if valid_580493 != nil:
    section.add "access_token", valid_580493
  var valid_580494 = query.getOrDefault("uploadType")
  valid_580494 = validateParameter(valid_580494, JString, required = false,
                                 default = nil)
  if valid_580494 != nil:
    section.add "uploadType", valid_580494
  var valid_580495 = query.getOrDefault("key")
  valid_580495 = validateParameter(valid_580495, JString, required = false,
                                 default = nil)
  if valid_580495 != nil:
    section.add "key", valid_580495
  var valid_580496 = query.getOrDefault("$.xgafv")
  valid_580496 = validateParameter(valid_580496, JString, required = false,
                                 default = newJString("1"))
  if valid_580496 != nil:
    section.add "$.xgafv", valid_580496
  var valid_580497 = query.getOrDefault("pageSize")
  valid_580497 = validateParameter(valid_580497, JInt, required = false, default = nil)
  if valid_580497 != nil:
    section.add "pageSize", valid_580497
  var valid_580498 = query.getOrDefault("prettyPrint")
  valid_580498 = validateParameter(valid_580498, JBool, required = false,
                                 default = newJBool(true))
  if valid_580498 != nil:
    section.add "prettyPrint", valid_580498
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580499: Call_ClassroomCoursesStudentsList_580482; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of students of this course that the requester
  ## is permitted to view.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `NOT_FOUND` if the course does not exist.
  ## * `PERMISSION_DENIED` for access errors.
  ## 
  let valid = call_580499.validator(path, query, header, formData, body)
  let scheme = call_580499.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580499.url(scheme.get, call_580499.host, call_580499.base,
                         call_580499.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580499, url, valid)

proc call*(call_580500: Call_ClassroomCoursesStudentsList_580482; courseId: string;
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
  var path_580501 = newJObject()
  var query_580502 = newJObject()
  add(query_580502, "upload_protocol", newJString(uploadProtocol))
  add(query_580502, "fields", newJString(fields))
  add(query_580502, "pageToken", newJString(pageToken))
  add(query_580502, "quotaUser", newJString(quotaUser))
  add(query_580502, "alt", newJString(alt))
  add(query_580502, "oauth_token", newJString(oauthToken))
  add(query_580502, "callback", newJString(callback))
  add(query_580502, "access_token", newJString(accessToken))
  add(query_580502, "uploadType", newJString(uploadType))
  add(query_580502, "key", newJString(key))
  add(path_580501, "courseId", newJString(courseId))
  add(query_580502, "$.xgafv", newJString(Xgafv))
  add(query_580502, "pageSize", newJInt(pageSize))
  add(query_580502, "prettyPrint", newJBool(prettyPrint))
  result = call_580500.call(path_580501, query_580502, nil, nil, nil)

var classroomCoursesStudentsList* = Call_ClassroomCoursesStudentsList_580482(
    name: "classroomCoursesStudentsList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/students",
    validator: validate_ClassroomCoursesStudentsList_580483, base: "/",
    url: url_ClassroomCoursesStudentsList_580484, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesStudentsGet_580525 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesStudentsGet_580527(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesStudentsGet_580526(path: JsonNode; query: JsonNode;
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
  var valid_580528 = path.getOrDefault("courseId")
  valid_580528 = validateParameter(valid_580528, JString, required = true,
                                 default = nil)
  if valid_580528 != nil:
    section.add "courseId", valid_580528
  var valid_580529 = path.getOrDefault("userId")
  valid_580529 = validateParameter(valid_580529, JString, required = true,
                                 default = nil)
  if valid_580529 != nil:
    section.add "userId", valid_580529
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
  var valid_580530 = query.getOrDefault("upload_protocol")
  valid_580530 = validateParameter(valid_580530, JString, required = false,
                                 default = nil)
  if valid_580530 != nil:
    section.add "upload_protocol", valid_580530
  var valid_580531 = query.getOrDefault("fields")
  valid_580531 = validateParameter(valid_580531, JString, required = false,
                                 default = nil)
  if valid_580531 != nil:
    section.add "fields", valid_580531
  var valid_580532 = query.getOrDefault("quotaUser")
  valid_580532 = validateParameter(valid_580532, JString, required = false,
                                 default = nil)
  if valid_580532 != nil:
    section.add "quotaUser", valid_580532
  var valid_580533 = query.getOrDefault("alt")
  valid_580533 = validateParameter(valid_580533, JString, required = false,
                                 default = newJString("json"))
  if valid_580533 != nil:
    section.add "alt", valid_580533
  var valid_580534 = query.getOrDefault("oauth_token")
  valid_580534 = validateParameter(valid_580534, JString, required = false,
                                 default = nil)
  if valid_580534 != nil:
    section.add "oauth_token", valid_580534
  var valid_580535 = query.getOrDefault("callback")
  valid_580535 = validateParameter(valid_580535, JString, required = false,
                                 default = nil)
  if valid_580535 != nil:
    section.add "callback", valid_580535
  var valid_580536 = query.getOrDefault("access_token")
  valid_580536 = validateParameter(valid_580536, JString, required = false,
                                 default = nil)
  if valid_580536 != nil:
    section.add "access_token", valid_580536
  var valid_580537 = query.getOrDefault("uploadType")
  valid_580537 = validateParameter(valid_580537, JString, required = false,
                                 default = nil)
  if valid_580537 != nil:
    section.add "uploadType", valid_580537
  var valid_580538 = query.getOrDefault("key")
  valid_580538 = validateParameter(valid_580538, JString, required = false,
                                 default = nil)
  if valid_580538 != nil:
    section.add "key", valid_580538
  var valid_580539 = query.getOrDefault("$.xgafv")
  valid_580539 = validateParameter(valid_580539, JString, required = false,
                                 default = newJString("1"))
  if valid_580539 != nil:
    section.add "$.xgafv", valid_580539
  var valid_580540 = query.getOrDefault("prettyPrint")
  valid_580540 = validateParameter(valid_580540, JBool, required = false,
                                 default = newJBool(true))
  if valid_580540 != nil:
    section.add "prettyPrint", valid_580540
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580541: Call_ClassroomCoursesStudentsGet_580525; path: JsonNode;
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
  let valid = call_580541.validator(path, query, header, formData, body)
  let scheme = call_580541.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580541.url(scheme.get, call_580541.host, call_580541.base,
                         call_580541.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580541, url, valid)

proc call*(call_580542: Call_ClassroomCoursesStudentsGet_580525; courseId: string;
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
  var path_580543 = newJObject()
  var query_580544 = newJObject()
  add(query_580544, "upload_protocol", newJString(uploadProtocol))
  add(query_580544, "fields", newJString(fields))
  add(query_580544, "quotaUser", newJString(quotaUser))
  add(query_580544, "alt", newJString(alt))
  add(query_580544, "oauth_token", newJString(oauthToken))
  add(query_580544, "callback", newJString(callback))
  add(query_580544, "access_token", newJString(accessToken))
  add(query_580544, "uploadType", newJString(uploadType))
  add(query_580544, "key", newJString(key))
  add(path_580543, "courseId", newJString(courseId))
  add(query_580544, "$.xgafv", newJString(Xgafv))
  add(query_580544, "prettyPrint", newJBool(prettyPrint))
  add(path_580543, "userId", newJString(userId))
  result = call_580542.call(path_580543, query_580544, nil, nil, nil)

var classroomCoursesStudentsGet* = Call_ClassroomCoursesStudentsGet_580525(
    name: "classroomCoursesStudentsGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/students/{userId}",
    validator: validate_ClassroomCoursesStudentsGet_580526, base: "/",
    url: url_ClassroomCoursesStudentsGet_580527, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesStudentsDelete_580545 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesStudentsDelete_580547(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesStudentsDelete_580546(path: JsonNode;
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
  var valid_580548 = path.getOrDefault("courseId")
  valid_580548 = validateParameter(valid_580548, JString, required = true,
                                 default = nil)
  if valid_580548 != nil:
    section.add "courseId", valid_580548
  var valid_580549 = path.getOrDefault("userId")
  valid_580549 = validateParameter(valid_580549, JString, required = true,
                                 default = nil)
  if valid_580549 != nil:
    section.add "userId", valid_580549
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
  var valid_580550 = query.getOrDefault("upload_protocol")
  valid_580550 = validateParameter(valid_580550, JString, required = false,
                                 default = nil)
  if valid_580550 != nil:
    section.add "upload_protocol", valid_580550
  var valid_580551 = query.getOrDefault("fields")
  valid_580551 = validateParameter(valid_580551, JString, required = false,
                                 default = nil)
  if valid_580551 != nil:
    section.add "fields", valid_580551
  var valid_580552 = query.getOrDefault("quotaUser")
  valid_580552 = validateParameter(valid_580552, JString, required = false,
                                 default = nil)
  if valid_580552 != nil:
    section.add "quotaUser", valid_580552
  var valid_580553 = query.getOrDefault("alt")
  valid_580553 = validateParameter(valid_580553, JString, required = false,
                                 default = newJString("json"))
  if valid_580553 != nil:
    section.add "alt", valid_580553
  var valid_580554 = query.getOrDefault("oauth_token")
  valid_580554 = validateParameter(valid_580554, JString, required = false,
                                 default = nil)
  if valid_580554 != nil:
    section.add "oauth_token", valid_580554
  var valid_580555 = query.getOrDefault("callback")
  valid_580555 = validateParameter(valid_580555, JString, required = false,
                                 default = nil)
  if valid_580555 != nil:
    section.add "callback", valid_580555
  var valid_580556 = query.getOrDefault("access_token")
  valid_580556 = validateParameter(valid_580556, JString, required = false,
                                 default = nil)
  if valid_580556 != nil:
    section.add "access_token", valid_580556
  var valid_580557 = query.getOrDefault("uploadType")
  valid_580557 = validateParameter(valid_580557, JString, required = false,
                                 default = nil)
  if valid_580557 != nil:
    section.add "uploadType", valid_580557
  var valid_580558 = query.getOrDefault("key")
  valid_580558 = validateParameter(valid_580558, JString, required = false,
                                 default = nil)
  if valid_580558 != nil:
    section.add "key", valid_580558
  var valid_580559 = query.getOrDefault("$.xgafv")
  valid_580559 = validateParameter(valid_580559, JString, required = false,
                                 default = newJString("1"))
  if valid_580559 != nil:
    section.add "$.xgafv", valid_580559
  var valid_580560 = query.getOrDefault("prettyPrint")
  valid_580560 = validateParameter(valid_580560, JBool, required = false,
                                 default = newJBool(true))
  if valid_580560 != nil:
    section.add "prettyPrint", valid_580560
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580561: Call_ClassroomCoursesStudentsDelete_580545; path: JsonNode;
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
  let valid = call_580561.validator(path, query, header, formData, body)
  let scheme = call_580561.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580561.url(scheme.get, call_580561.host, call_580561.base,
                         call_580561.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580561, url, valid)

proc call*(call_580562: Call_ClassroomCoursesStudentsDelete_580545;
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
  var path_580563 = newJObject()
  var query_580564 = newJObject()
  add(query_580564, "upload_protocol", newJString(uploadProtocol))
  add(query_580564, "fields", newJString(fields))
  add(query_580564, "quotaUser", newJString(quotaUser))
  add(query_580564, "alt", newJString(alt))
  add(query_580564, "oauth_token", newJString(oauthToken))
  add(query_580564, "callback", newJString(callback))
  add(query_580564, "access_token", newJString(accessToken))
  add(query_580564, "uploadType", newJString(uploadType))
  add(query_580564, "key", newJString(key))
  add(path_580563, "courseId", newJString(courseId))
  add(query_580564, "$.xgafv", newJString(Xgafv))
  add(query_580564, "prettyPrint", newJBool(prettyPrint))
  add(path_580563, "userId", newJString(userId))
  result = call_580562.call(path_580563, query_580564, nil, nil, nil)

var classroomCoursesStudentsDelete* = Call_ClassroomCoursesStudentsDelete_580545(
    name: "classroomCoursesStudentsDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/students/{userId}",
    validator: validate_ClassroomCoursesStudentsDelete_580546, base: "/",
    url: url_ClassroomCoursesStudentsDelete_580547, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTeachersCreate_580586 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesTeachersCreate_580588(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesTeachersCreate_580587(path: JsonNode;
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
  var valid_580589 = path.getOrDefault("courseId")
  valid_580589 = validateParameter(valid_580589, JString, required = true,
                                 default = nil)
  if valid_580589 != nil:
    section.add "courseId", valid_580589
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
  var valid_580590 = query.getOrDefault("upload_protocol")
  valid_580590 = validateParameter(valid_580590, JString, required = false,
                                 default = nil)
  if valid_580590 != nil:
    section.add "upload_protocol", valid_580590
  var valid_580591 = query.getOrDefault("fields")
  valid_580591 = validateParameter(valid_580591, JString, required = false,
                                 default = nil)
  if valid_580591 != nil:
    section.add "fields", valid_580591
  var valid_580592 = query.getOrDefault("quotaUser")
  valid_580592 = validateParameter(valid_580592, JString, required = false,
                                 default = nil)
  if valid_580592 != nil:
    section.add "quotaUser", valid_580592
  var valid_580593 = query.getOrDefault("alt")
  valid_580593 = validateParameter(valid_580593, JString, required = false,
                                 default = newJString("json"))
  if valid_580593 != nil:
    section.add "alt", valid_580593
  var valid_580594 = query.getOrDefault("oauth_token")
  valid_580594 = validateParameter(valid_580594, JString, required = false,
                                 default = nil)
  if valid_580594 != nil:
    section.add "oauth_token", valid_580594
  var valid_580595 = query.getOrDefault("callback")
  valid_580595 = validateParameter(valid_580595, JString, required = false,
                                 default = nil)
  if valid_580595 != nil:
    section.add "callback", valid_580595
  var valid_580596 = query.getOrDefault("access_token")
  valid_580596 = validateParameter(valid_580596, JString, required = false,
                                 default = nil)
  if valid_580596 != nil:
    section.add "access_token", valid_580596
  var valid_580597 = query.getOrDefault("uploadType")
  valid_580597 = validateParameter(valid_580597, JString, required = false,
                                 default = nil)
  if valid_580597 != nil:
    section.add "uploadType", valid_580597
  var valid_580598 = query.getOrDefault("key")
  valid_580598 = validateParameter(valid_580598, JString, required = false,
                                 default = nil)
  if valid_580598 != nil:
    section.add "key", valid_580598
  var valid_580599 = query.getOrDefault("$.xgafv")
  valid_580599 = validateParameter(valid_580599, JString, required = false,
                                 default = newJString("1"))
  if valid_580599 != nil:
    section.add "$.xgafv", valid_580599
  var valid_580600 = query.getOrDefault("prettyPrint")
  valid_580600 = validateParameter(valid_580600, JBool, required = false,
                                 default = newJBool(true))
  if valid_580600 != nil:
    section.add "prettyPrint", valid_580600
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

proc call*(call_580602: Call_ClassroomCoursesTeachersCreate_580586; path: JsonNode;
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
  let valid = call_580602.validator(path, query, header, formData, body)
  let scheme = call_580602.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580602.url(scheme.get, call_580602.host, call_580602.base,
                         call_580602.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580602, url, valid)

proc call*(call_580603: Call_ClassroomCoursesTeachersCreate_580586;
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
  var path_580604 = newJObject()
  var query_580605 = newJObject()
  var body_580606 = newJObject()
  add(query_580605, "upload_protocol", newJString(uploadProtocol))
  add(query_580605, "fields", newJString(fields))
  add(query_580605, "quotaUser", newJString(quotaUser))
  add(query_580605, "alt", newJString(alt))
  add(query_580605, "oauth_token", newJString(oauthToken))
  add(query_580605, "callback", newJString(callback))
  add(query_580605, "access_token", newJString(accessToken))
  add(query_580605, "uploadType", newJString(uploadType))
  add(query_580605, "key", newJString(key))
  add(path_580604, "courseId", newJString(courseId))
  add(query_580605, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580606 = body
  add(query_580605, "prettyPrint", newJBool(prettyPrint))
  result = call_580603.call(path_580604, query_580605, nil, nil, body_580606)

var classroomCoursesTeachersCreate* = Call_ClassroomCoursesTeachersCreate_580586(
    name: "classroomCoursesTeachersCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/teachers",
    validator: validate_ClassroomCoursesTeachersCreate_580587, base: "/",
    url: url_ClassroomCoursesTeachersCreate_580588, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTeachersList_580565 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesTeachersList_580567(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesTeachersList_580566(path: JsonNode; query: JsonNode;
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
  var valid_580568 = path.getOrDefault("courseId")
  valid_580568 = validateParameter(valid_580568, JString, required = true,
                                 default = nil)
  if valid_580568 != nil:
    section.add "courseId", valid_580568
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
  var valid_580569 = query.getOrDefault("upload_protocol")
  valid_580569 = validateParameter(valid_580569, JString, required = false,
                                 default = nil)
  if valid_580569 != nil:
    section.add "upload_protocol", valid_580569
  var valid_580570 = query.getOrDefault("fields")
  valid_580570 = validateParameter(valid_580570, JString, required = false,
                                 default = nil)
  if valid_580570 != nil:
    section.add "fields", valid_580570
  var valid_580571 = query.getOrDefault("pageToken")
  valid_580571 = validateParameter(valid_580571, JString, required = false,
                                 default = nil)
  if valid_580571 != nil:
    section.add "pageToken", valid_580571
  var valid_580572 = query.getOrDefault("quotaUser")
  valid_580572 = validateParameter(valid_580572, JString, required = false,
                                 default = nil)
  if valid_580572 != nil:
    section.add "quotaUser", valid_580572
  var valid_580573 = query.getOrDefault("alt")
  valid_580573 = validateParameter(valid_580573, JString, required = false,
                                 default = newJString("json"))
  if valid_580573 != nil:
    section.add "alt", valid_580573
  var valid_580574 = query.getOrDefault("oauth_token")
  valid_580574 = validateParameter(valid_580574, JString, required = false,
                                 default = nil)
  if valid_580574 != nil:
    section.add "oauth_token", valid_580574
  var valid_580575 = query.getOrDefault("callback")
  valid_580575 = validateParameter(valid_580575, JString, required = false,
                                 default = nil)
  if valid_580575 != nil:
    section.add "callback", valid_580575
  var valid_580576 = query.getOrDefault("access_token")
  valid_580576 = validateParameter(valid_580576, JString, required = false,
                                 default = nil)
  if valid_580576 != nil:
    section.add "access_token", valid_580576
  var valid_580577 = query.getOrDefault("uploadType")
  valid_580577 = validateParameter(valid_580577, JString, required = false,
                                 default = nil)
  if valid_580577 != nil:
    section.add "uploadType", valid_580577
  var valid_580578 = query.getOrDefault("key")
  valid_580578 = validateParameter(valid_580578, JString, required = false,
                                 default = nil)
  if valid_580578 != nil:
    section.add "key", valid_580578
  var valid_580579 = query.getOrDefault("$.xgafv")
  valid_580579 = validateParameter(valid_580579, JString, required = false,
                                 default = newJString("1"))
  if valid_580579 != nil:
    section.add "$.xgafv", valid_580579
  var valid_580580 = query.getOrDefault("pageSize")
  valid_580580 = validateParameter(valid_580580, JInt, required = false, default = nil)
  if valid_580580 != nil:
    section.add "pageSize", valid_580580
  var valid_580581 = query.getOrDefault("prettyPrint")
  valid_580581 = validateParameter(valid_580581, JBool, required = false,
                                 default = newJBool(true))
  if valid_580581 != nil:
    section.add "prettyPrint", valid_580581
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580582: Call_ClassroomCoursesTeachersList_580565; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of teachers of this course that the requester
  ## is permitted to view.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `NOT_FOUND` if the course does not exist.
  ## * `PERMISSION_DENIED` for access errors.
  ## 
  let valid = call_580582.validator(path, query, header, formData, body)
  let scheme = call_580582.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580582.url(scheme.get, call_580582.host, call_580582.base,
                         call_580582.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580582, url, valid)

proc call*(call_580583: Call_ClassroomCoursesTeachersList_580565; courseId: string;
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
  var path_580584 = newJObject()
  var query_580585 = newJObject()
  add(query_580585, "upload_protocol", newJString(uploadProtocol))
  add(query_580585, "fields", newJString(fields))
  add(query_580585, "pageToken", newJString(pageToken))
  add(query_580585, "quotaUser", newJString(quotaUser))
  add(query_580585, "alt", newJString(alt))
  add(query_580585, "oauth_token", newJString(oauthToken))
  add(query_580585, "callback", newJString(callback))
  add(query_580585, "access_token", newJString(accessToken))
  add(query_580585, "uploadType", newJString(uploadType))
  add(query_580585, "key", newJString(key))
  add(path_580584, "courseId", newJString(courseId))
  add(query_580585, "$.xgafv", newJString(Xgafv))
  add(query_580585, "pageSize", newJInt(pageSize))
  add(query_580585, "prettyPrint", newJBool(prettyPrint))
  result = call_580583.call(path_580584, query_580585, nil, nil, nil)

var classroomCoursesTeachersList* = Call_ClassroomCoursesTeachersList_580565(
    name: "classroomCoursesTeachersList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/teachers",
    validator: validate_ClassroomCoursesTeachersList_580566, base: "/",
    url: url_ClassroomCoursesTeachersList_580567, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTeachersGet_580607 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesTeachersGet_580609(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesTeachersGet_580608(path: JsonNode; query: JsonNode;
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
  var valid_580610 = path.getOrDefault("courseId")
  valid_580610 = validateParameter(valid_580610, JString, required = true,
                                 default = nil)
  if valid_580610 != nil:
    section.add "courseId", valid_580610
  var valid_580611 = path.getOrDefault("userId")
  valid_580611 = validateParameter(valid_580611, JString, required = true,
                                 default = nil)
  if valid_580611 != nil:
    section.add "userId", valid_580611
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
  var valid_580612 = query.getOrDefault("upload_protocol")
  valid_580612 = validateParameter(valid_580612, JString, required = false,
                                 default = nil)
  if valid_580612 != nil:
    section.add "upload_protocol", valid_580612
  var valid_580613 = query.getOrDefault("fields")
  valid_580613 = validateParameter(valid_580613, JString, required = false,
                                 default = nil)
  if valid_580613 != nil:
    section.add "fields", valid_580613
  var valid_580614 = query.getOrDefault("quotaUser")
  valid_580614 = validateParameter(valid_580614, JString, required = false,
                                 default = nil)
  if valid_580614 != nil:
    section.add "quotaUser", valid_580614
  var valid_580615 = query.getOrDefault("alt")
  valid_580615 = validateParameter(valid_580615, JString, required = false,
                                 default = newJString("json"))
  if valid_580615 != nil:
    section.add "alt", valid_580615
  var valid_580616 = query.getOrDefault("oauth_token")
  valid_580616 = validateParameter(valid_580616, JString, required = false,
                                 default = nil)
  if valid_580616 != nil:
    section.add "oauth_token", valid_580616
  var valid_580617 = query.getOrDefault("callback")
  valid_580617 = validateParameter(valid_580617, JString, required = false,
                                 default = nil)
  if valid_580617 != nil:
    section.add "callback", valid_580617
  var valid_580618 = query.getOrDefault("access_token")
  valid_580618 = validateParameter(valid_580618, JString, required = false,
                                 default = nil)
  if valid_580618 != nil:
    section.add "access_token", valid_580618
  var valid_580619 = query.getOrDefault("uploadType")
  valid_580619 = validateParameter(valid_580619, JString, required = false,
                                 default = nil)
  if valid_580619 != nil:
    section.add "uploadType", valid_580619
  var valid_580620 = query.getOrDefault("key")
  valid_580620 = validateParameter(valid_580620, JString, required = false,
                                 default = nil)
  if valid_580620 != nil:
    section.add "key", valid_580620
  var valid_580621 = query.getOrDefault("$.xgafv")
  valid_580621 = validateParameter(valid_580621, JString, required = false,
                                 default = newJString("1"))
  if valid_580621 != nil:
    section.add "$.xgafv", valid_580621
  var valid_580622 = query.getOrDefault("prettyPrint")
  valid_580622 = validateParameter(valid_580622, JBool, required = false,
                                 default = newJBool(true))
  if valid_580622 != nil:
    section.add "prettyPrint", valid_580622
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580623: Call_ClassroomCoursesTeachersGet_580607; path: JsonNode;
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
  let valid = call_580623.validator(path, query, header, formData, body)
  let scheme = call_580623.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580623.url(scheme.get, call_580623.host, call_580623.base,
                         call_580623.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580623, url, valid)

proc call*(call_580624: Call_ClassroomCoursesTeachersGet_580607; courseId: string;
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
  var path_580625 = newJObject()
  var query_580626 = newJObject()
  add(query_580626, "upload_protocol", newJString(uploadProtocol))
  add(query_580626, "fields", newJString(fields))
  add(query_580626, "quotaUser", newJString(quotaUser))
  add(query_580626, "alt", newJString(alt))
  add(query_580626, "oauth_token", newJString(oauthToken))
  add(query_580626, "callback", newJString(callback))
  add(query_580626, "access_token", newJString(accessToken))
  add(query_580626, "uploadType", newJString(uploadType))
  add(query_580626, "key", newJString(key))
  add(path_580625, "courseId", newJString(courseId))
  add(query_580626, "$.xgafv", newJString(Xgafv))
  add(query_580626, "prettyPrint", newJBool(prettyPrint))
  add(path_580625, "userId", newJString(userId))
  result = call_580624.call(path_580625, query_580626, nil, nil, nil)

var classroomCoursesTeachersGet* = Call_ClassroomCoursesTeachersGet_580607(
    name: "classroomCoursesTeachersGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/teachers/{userId}",
    validator: validate_ClassroomCoursesTeachersGet_580608, base: "/",
    url: url_ClassroomCoursesTeachersGet_580609, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTeachersDelete_580627 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesTeachersDelete_580629(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesTeachersDelete_580628(path: JsonNode;
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
  var valid_580630 = path.getOrDefault("courseId")
  valid_580630 = validateParameter(valid_580630, JString, required = true,
                                 default = nil)
  if valid_580630 != nil:
    section.add "courseId", valid_580630
  var valid_580631 = path.getOrDefault("userId")
  valid_580631 = validateParameter(valid_580631, JString, required = true,
                                 default = nil)
  if valid_580631 != nil:
    section.add "userId", valid_580631
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
  var valid_580632 = query.getOrDefault("upload_protocol")
  valid_580632 = validateParameter(valid_580632, JString, required = false,
                                 default = nil)
  if valid_580632 != nil:
    section.add "upload_protocol", valid_580632
  var valid_580633 = query.getOrDefault("fields")
  valid_580633 = validateParameter(valid_580633, JString, required = false,
                                 default = nil)
  if valid_580633 != nil:
    section.add "fields", valid_580633
  var valid_580634 = query.getOrDefault("quotaUser")
  valid_580634 = validateParameter(valid_580634, JString, required = false,
                                 default = nil)
  if valid_580634 != nil:
    section.add "quotaUser", valid_580634
  var valid_580635 = query.getOrDefault("alt")
  valid_580635 = validateParameter(valid_580635, JString, required = false,
                                 default = newJString("json"))
  if valid_580635 != nil:
    section.add "alt", valid_580635
  var valid_580636 = query.getOrDefault("oauth_token")
  valid_580636 = validateParameter(valid_580636, JString, required = false,
                                 default = nil)
  if valid_580636 != nil:
    section.add "oauth_token", valid_580636
  var valid_580637 = query.getOrDefault("callback")
  valid_580637 = validateParameter(valid_580637, JString, required = false,
                                 default = nil)
  if valid_580637 != nil:
    section.add "callback", valid_580637
  var valid_580638 = query.getOrDefault("access_token")
  valid_580638 = validateParameter(valid_580638, JString, required = false,
                                 default = nil)
  if valid_580638 != nil:
    section.add "access_token", valid_580638
  var valid_580639 = query.getOrDefault("uploadType")
  valid_580639 = validateParameter(valid_580639, JString, required = false,
                                 default = nil)
  if valid_580639 != nil:
    section.add "uploadType", valid_580639
  var valid_580640 = query.getOrDefault("key")
  valid_580640 = validateParameter(valid_580640, JString, required = false,
                                 default = nil)
  if valid_580640 != nil:
    section.add "key", valid_580640
  var valid_580641 = query.getOrDefault("$.xgafv")
  valid_580641 = validateParameter(valid_580641, JString, required = false,
                                 default = newJString("1"))
  if valid_580641 != nil:
    section.add "$.xgafv", valid_580641
  var valid_580642 = query.getOrDefault("prettyPrint")
  valid_580642 = validateParameter(valid_580642, JBool, required = false,
                                 default = newJBool(true))
  if valid_580642 != nil:
    section.add "prettyPrint", valid_580642
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580643: Call_ClassroomCoursesTeachersDelete_580627; path: JsonNode;
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
  let valid = call_580643.validator(path, query, header, formData, body)
  let scheme = call_580643.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580643.url(scheme.get, call_580643.host, call_580643.base,
                         call_580643.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580643, url, valid)

proc call*(call_580644: Call_ClassroomCoursesTeachersDelete_580627;
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
  var path_580645 = newJObject()
  var query_580646 = newJObject()
  add(query_580646, "upload_protocol", newJString(uploadProtocol))
  add(query_580646, "fields", newJString(fields))
  add(query_580646, "quotaUser", newJString(quotaUser))
  add(query_580646, "alt", newJString(alt))
  add(query_580646, "oauth_token", newJString(oauthToken))
  add(query_580646, "callback", newJString(callback))
  add(query_580646, "access_token", newJString(accessToken))
  add(query_580646, "uploadType", newJString(uploadType))
  add(query_580646, "key", newJString(key))
  add(path_580645, "courseId", newJString(courseId))
  add(query_580646, "$.xgafv", newJString(Xgafv))
  add(query_580646, "prettyPrint", newJBool(prettyPrint))
  add(path_580645, "userId", newJString(userId))
  result = call_580644.call(path_580645, query_580646, nil, nil, nil)

var classroomCoursesTeachersDelete* = Call_ClassroomCoursesTeachersDelete_580627(
    name: "classroomCoursesTeachersDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/teachers/{userId}",
    validator: validate_ClassroomCoursesTeachersDelete_580628, base: "/",
    url: url_ClassroomCoursesTeachersDelete_580629, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTopicsCreate_580668 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesTopicsCreate_580670(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesTopicsCreate_580669(path: JsonNode; query: JsonNode;
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
  var valid_580671 = path.getOrDefault("courseId")
  valid_580671 = validateParameter(valid_580671, JString, required = true,
                                 default = nil)
  if valid_580671 != nil:
    section.add "courseId", valid_580671
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
  var valid_580672 = query.getOrDefault("upload_protocol")
  valid_580672 = validateParameter(valid_580672, JString, required = false,
                                 default = nil)
  if valid_580672 != nil:
    section.add "upload_protocol", valid_580672
  var valid_580673 = query.getOrDefault("fields")
  valid_580673 = validateParameter(valid_580673, JString, required = false,
                                 default = nil)
  if valid_580673 != nil:
    section.add "fields", valid_580673
  var valid_580674 = query.getOrDefault("quotaUser")
  valid_580674 = validateParameter(valid_580674, JString, required = false,
                                 default = nil)
  if valid_580674 != nil:
    section.add "quotaUser", valid_580674
  var valid_580675 = query.getOrDefault("alt")
  valid_580675 = validateParameter(valid_580675, JString, required = false,
                                 default = newJString("json"))
  if valid_580675 != nil:
    section.add "alt", valid_580675
  var valid_580676 = query.getOrDefault("oauth_token")
  valid_580676 = validateParameter(valid_580676, JString, required = false,
                                 default = nil)
  if valid_580676 != nil:
    section.add "oauth_token", valid_580676
  var valid_580677 = query.getOrDefault("callback")
  valid_580677 = validateParameter(valid_580677, JString, required = false,
                                 default = nil)
  if valid_580677 != nil:
    section.add "callback", valid_580677
  var valid_580678 = query.getOrDefault("access_token")
  valid_580678 = validateParameter(valid_580678, JString, required = false,
                                 default = nil)
  if valid_580678 != nil:
    section.add "access_token", valid_580678
  var valid_580679 = query.getOrDefault("uploadType")
  valid_580679 = validateParameter(valid_580679, JString, required = false,
                                 default = nil)
  if valid_580679 != nil:
    section.add "uploadType", valid_580679
  var valid_580680 = query.getOrDefault("key")
  valid_580680 = validateParameter(valid_580680, JString, required = false,
                                 default = nil)
  if valid_580680 != nil:
    section.add "key", valid_580680
  var valid_580681 = query.getOrDefault("$.xgafv")
  valid_580681 = validateParameter(valid_580681, JString, required = false,
                                 default = newJString("1"))
  if valid_580681 != nil:
    section.add "$.xgafv", valid_580681
  var valid_580682 = query.getOrDefault("prettyPrint")
  valid_580682 = validateParameter(valid_580682, JBool, required = false,
                                 default = newJBool(true))
  if valid_580682 != nil:
    section.add "prettyPrint", valid_580682
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

proc call*(call_580684: Call_ClassroomCoursesTopicsCreate_580668; path: JsonNode;
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
  let valid = call_580684.validator(path, query, header, formData, body)
  let scheme = call_580684.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580684.url(scheme.get, call_580684.host, call_580684.base,
                         call_580684.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580684, url, valid)

proc call*(call_580685: Call_ClassroomCoursesTopicsCreate_580668; courseId: string;
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
  var path_580686 = newJObject()
  var query_580687 = newJObject()
  var body_580688 = newJObject()
  add(query_580687, "upload_protocol", newJString(uploadProtocol))
  add(query_580687, "fields", newJString(fields))
  add(query_580687, "quotaUser", newJString(quotaUser))
  add(query_580687, "alt", newJString(alt))
  add(query_580687, "oauth_token", newJString(oauthToken))
  add(query_580687, "callback", newJString(callback))
  add(query_580687, "access_token", newJString(accessToken))
  add(query_580687, "uploadType", newJString(uploadType))
  add(query_580687, "key", newJString(key))
  add(path_580686, "courseId", newJString(courseId))
  add(query_580687, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580688 = body
  add(query_580687, "prettyPrint", newJBool(prettyPrint))
  result = call_580685.call(path_580686, query_580687, nil, nil, body_580688)

var classroomCoursesTopicsCreate* = Call_ClassroomCoursesTopicsCreate_580668(
    name: "classroomCoursesTopicsCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/topics",
    validator: validate_ClassroomCoursesTopicsCreate_580669, base: "/",
    url: url_ClassroomCoursesTopicsCreate_580670, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTopicsList_580647 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesTopicsList_580649(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesTopicsList_580648(path: JsonNode; query: JsonNode;
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
  var valid_580650 = path.getOrDefault("courseId")
  valid_580650 = validateParameter(valid_580650, JString, required = true,
                                 default = nil)
  if valid_580650 != nil:
    section.add "courseId", valid_580650
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
  var valid_580651 = query.getOrDefault("upload_protocol")
  valid_580651 = validateParameter(valid_580651, JString, required = false,
                                 default = nil)
  if valid_580651 != nil:
    section.add "upload_protocol", valid_580651
  var valid_580652 = query.getOrDefault("fields")
  valid_580652 = validateParameter(valid_580652, JString, required = false,
                                 default = nil)
  if valid_580652 != nil:
    section.add "fields", valid_580652
  var valid_580653 = query.getOrDefault("pageToken")
  valid_580653 = validateParameter(valid_580653, JString, required = false,
                                 default = nil)
  if valid_580653 != nil:
    section.add "pageToken", valid_580653
  var valid_580654 = query.getOrDefault("quotaUser")
  valid_580654 = validateParameter(valid_580654, JString, required = false,
                                 default = nil)
  if valid_580654 != nil:
    section.add "quotaUser", valid_580654
  var valid_580655 = query.getOrDefault("alt")
  valid_580655 = validateParameter(valid_580655, JString, required = false,
                                 default = newJString("json"))
  if valid_580655 != nil:
    section.add "alt", valid_580655
  var valid_580656 = query.getOrDefault("oauth_token")
  valid_580656 = validateParameter(valid_580656, JString, required = false,
                                 default = nil)
  if valid_580656 != nil:
    section.add "oauth_token", valid_580656
  var valid_580657 = query.getOrDefault("callback")
  valid_580657 = validateParameter(valid_580657, JString, required = false,
                                 default = nil)
  if valid_580657 != nil:
    section.add "callback", valid_580657
  var valid_580658 = query.getOrDefault("access_token")
  valid_580658 = validateParameter(valid_580658, JString, required = false,
                                 default = nil)
  if valid_580658 != nil:
    section.add "access_token", valid_580658
  var valid_580659 = query.getOrDefault("uploadType")
  valid_580659 = validateParameter(valid_580659, JString, required = false,
                                 default = nil)
  if valid_580659 != nil:
    section.add "uploadType", valid_580659
  var valid_580660 = query.getOrDefault("key")
  valid_580660 = validateParameter(valid_580660, JString, required = false,
                                 default = nil)
  if valid_580660 != nil:
    section.add "key", valid_580660
  var valid_580661 = query.getOrDefault("$.xgafv")
  valid_580661 = validateParameter(valid_580661, JString, required = false,
                                 default = newJString("1"))
  if valid_580661 != nil:
    section.add "$.xgafv", valid_580661
  var valid_580662 = query.getOrDefault("pageSize")
  valid_580662 = validateParameter(valid_580662, JInt, required = false, default = nil)
  if valid_580662 != nil:
    section.add "pageSize", valid_580662
  var valid_580663 = query.getOrDefault("prettyPrint")
  valid_580663 = validateParameter(valid_580663, JBool, required = false,
                                 default = newJBool(true))
  if valid_580663 != nil:
    section.add "prettyPrint", valid_580663
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580664: Call_ClassroomCoursesTopicsList_580647; path: JsonNode;
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
  let valid = call_580664.validator(path, query, header, formData, body)
  let scheme = call_580664.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580664.url(scheme.get, call_580664.host, call_580664.base,
                         call_580664.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580664, url, valid)

proc call*(call_580665: Call_ClassroomCoursesTopicsList_580647; courseId: string;
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
  var path_580666 = newJObject()
  var query_580667 = newJObject()
  add(query_580667, "upload_protocol", newJString(uploadProtocol))
  add(query_580667, "fields", newJString(fields))
  add(query_580667, "pageToken", newJString(pageToken))
  add(query_580667, "quotaUser", newJString(quotaUser))
  add(query_580667, "alt", newJString(alt))
  add(query_580667, "oauth_token", newJString(oauthToken))
  add(query_580667, "callback", newJString(callback))
  add(query_580667, "access_token", newJString(accessToken))
  add(query_580667, "uploadType", newJString(uploadType))
  add(query_580667, "key", newJString(key))
  add(path_580666, "courseId", newJString(courseId))
  add(query_580667, "$.xgafv", newJString(Xgafv))
  add(query_580667, "pageSize", newJInt(pageSize))
  add(query_580667, "prettyPrint", newJBool(prettyPrint))
  result = call_580665.call(path_580666, query_580667, nil, nil, nil)

var classroomCoursesTopicsList* = Call_ClassroomCoursesTopicsList_580647(
    name: "classroomCoursesTopicsList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/topics",
    validator: validate_ClassroomCoursesTopicsList_580648, base: "/",
    url: url_ClassroomCoursesTopicsList_580649, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTopicsGet_580689 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesTopicsGet_580691(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesTopicsGet_580690(path: JsonNode; query: JsonNode;
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
  var valid_580692 = path.getOrDefault("id")
  valid_580692 = validateParameter(valid_580692, JString, required = true,
                                 default = nil)
  if valid_580692 != nil:
    section.add "id", valid_580692
  var valid_580693 = path.getOrDefault("courseId")
  valid_580693 = validateParameter(valid_580693, JString, required = true,
                                 default = nil)
  if valid_580693 != nil:
    section.add "courseId", valid_580693
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
  var valid_580694 = query.getOrDefault("upload_protocol")
  valid_580694 = validateParameter(valid_580694, JString, required = false,
                                 default = nil)
  if valid_580694 != nil:
    section.add "upload_protocol", valid_580694
  var valid_580695 = query.getOrDefault("fields")
  valid_580695 = validateParameter(valid_580695, JString, required = false,
                                 default = nil)
  if valid_580695 != nil:
    section.add "fields", valid_580695
  var valid_580696 = query.getOrDefault("quotaUser")
  valid_580696 = validateParameter(valid_580696, JString, required = false,
                                 default = nil)
  if valid_580696 != nil:
    section.add "quotaUser", valid_580696
  var valid_580697 = query.getOrDefault("alt")
  valid_580697 = validateParameter(valid_580697, JString, required = false,
                                 default = newJString("json"))
  if valid_580697 != nil:
    section.add "alt", valid_580697
  var valid_580698 = query.getOrDefault("oauth_token")
  valid_580698 = validateParameter(valid_580698, JString, required = false,
                                 default = nil)
  if valid_580698 != nil:
    section.add "oauth_token", valid_580698
  var valid_580699 = query.getOrDefault("callback")
  valid_580699 = validateParameter(valid_580699, JString, required = false,
                                 default = nil)
  if valid_580699 != nil:
    section.add "callback", valid_580699
  var valid_580700 = query.getOrDefault("access_token")
  valid_580700 = validateParameter(valid_580700, JString, required = false,
                                 default = nil)
  if valid_580700 != nil:
    section.add "access_token", valid_580700
  var valid_580701 = query.getOrDefault("uploadType")
  valid_580701 = validateParameter(valid_580701, JString, required = false,
                                 default = nil)
  if valid_580701 != nil:
    section.add "uploadType", valid_580701
  var valid_580702 = query.getOrDefault("key")
  valid_580702 = validateParameter(valid_580702, JString, required = false,
                                 default = nil)
  if valid_580702 != nil:
    section.add "key", valid_580702
  var valid_580703 = query.getOrDefault("$.xgafv")
  valid_580703 = validateParameter(valid_580703, JString, required = false,
                                 default = newJString("1"))
  if valid_580703 != nil:
    section.add "$.xgafv", valid_580703
  var valid_580704 = query.getOrDefault("prettyPrint")
  valid_580704 = validateParameter(valid_580704, JBool, required = false,
                                 default = newJBool(true))
  if valid_580704 != nil:
    section.add "prettyPrint", valid_580704
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580705: Call_ClassroomCoursesTopicsGet_580689; path: JsonNode;
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
  let valid = call_580705.validator(path, query, header, formData, body)
  let scheme = call_580705.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580705.url(scheme.get, call_580705.host, call_580705.base,
                         call_580705.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580705, url, valid)

proc call*(call_580706: Call_ClassroomCoursesTopicsGet_580689; id: string;
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
  var path_580707 = newJObject()
  var query_580708 = newJObject()
  add(query_580708, "upload_protocol", newJString(uploadProtocol))
  add(query_580708, "fields", newJString(fields))
  add(query_580708, "quotaUser", newJString(quotaUser))
  add(query_580708, "alt", newJString(alt))
  add(query_580708, "oauth_token", newJString(oauthToken))
  add(query_580708, "callback", newJString(callback))
  add(query_580708, "access_token", newJString(accessToken))
  add(query_580708, "uploadType", newJString(uploadType))
  add(path_580707, "id", newJString(id))
  add(query_580708, "key", newJString(key))
  add(path_580707, "courseId", newJString(courseId))
  add(query_580708, "$.xgafv", newJString(Xgafv))
  add(query_580708, "prettyPrint", newJBool(prettyPrint))
  result = call_580706.call(path_580707, query_580708, nil, nil, nil)

var classroomCoursesTopicsGet* = Call_ClassroomCoursesTopicsGet_580689(
    name: "classroomCoursesTopicsGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/topics/{id}",
    validator: validate_ClassroomCoursesTopicsGet_580690, base: "/",
    url: url_ClassroomCoursesTopicsGet_580691, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTopicsPatch_580729 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesTopicsPatch_580731(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesTopicsPatch_580730(path: JsonNode; query: JsonNode;
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
  var valid_580732 = path.getOrDefault("id")
  valid_580732 = validateParameter(valid_580732, JString, required = true,
                                 default = nil)
  if valid_580732 != nil:
    section.add "id", valid_580732
  var valid_580733 = path.getOrDefault("courseId")
  valid_580733 = validateParameter(valid_580733, JString, required = true,
                                 default = nil)
  if valid_580733 != nil:
    section.add "courseId", valid_580733
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
  var valid_580734 = query.getOrDefault("upload_protocol")
  valid_580734 = validateParameter(valid_580734, JString, required = false,
                                 default = nil)
  if valid_580734 != nil:
    section.add "upload_protocol", valid_580734
  var valid_580735 = query.getOrDefault("fields")
  valid_580735 = validateParameter(valid_580735, JString, required = false,
                                 default = nil)
  if valid_580735 != nil:
    section.add "fields", valid_580735
  var valid_580736 = query.getOrDefault("quotaUser")
  valid_580736 = validateParameter(valid_580736, JString, required = false,
                                 default = nil)
  if valid_580736 != nil:
    section.add "quotaUser", valid_580736
  var valid_580737 = query.getOrDefault("alt")
  valid_580737 = validateParameter(valid_580737, JString, required = false,
                                 default = newJString("json"))
  if valid_580737 != nil:
    section.add "alt", valid_580737
  var valid_580738 = query.getOrDefault("oauth_token")
  valid_580738 = validateParameter(valid_580738, JString, required = false,
                                 default = nil)
  if valid_580738 != nil:
    section.add "oauth_token", valid_580738
  var valid_580739 = query.getOrDefault("callback")
  valid_580739 = validateParameter(valid_580739, JString, required = false,
                                 default = nil)
  if valid_580739 != nil:
    section.add "callback", valid_580739
  var valid_580740 = query.getOrDefault("access_token")
  valid_580740 = validateParameter(valid_580740, JString, required = false,
                                 default = nil)
  if valid_580740 != nil:
    section.add "access_token", valid_580740
  var valid_580741 = query.getOrDefault("uploadType")
  valid_580741 = validateParameter(valid_580741, JString, required = false,
                                 default = nil)
  if valid_580741 != nil:
    section.add "uploadType", valid_580741
  var valid_580742 = query.getOrDefault("key")
  valid_580742 = validateParameter(valid_580742, JString, required = false,
                                 default = nil)
  if valid_580742 != nil:
    section.add "key", valid_580742
  var valid_580743 = query.getOrDefault("$.xgafv")
  valid_580743 = validateParameter(valid_580743, JString, required = false,
                                 default = newJString("1"))
  if valid_580743 != nil:
    section.add "$.xgafv", valid_580743
  var valid_580744 = query.getOrDefault("prettyPrint")
  valid_580744 = validateParameter(valid_580744, JBool, required = false,
                                 default = newJBool(true))
  if valid_580744 != nil:
    section.add "prettyPrint", valid_580744
  var valid_580745 = query.getOrDefault("updateMask")
  valid_580745 = validateParameter(valid_580745, JString, required = false,
                                 default = nil)
  if valid_580745 != nil:
    section.add "updateMask", valid_580745
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

proc call*(call_580747: Call_ClassroomCoursesTopicsPatch_580729; path: JsonNode;
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
  let valid = call_580747.validator(path, query, header, formData, body)
  let scheme = call_580747.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580747.url(scheme.get, call_580747.host, call_580747.base,
                         call_580747.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580747, url, valid)

proc call*(call_580748: Call_ClassroomCoursesTopicsPatch_580729; id: string;
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
  var path_580749 = newJObject()
  var query_580750 = newJObject()
  var body_580751 = newJObject()
  add(query_580750, "upload_protocol", newJString(uploadProtocol))
  add(query_580750, "fields", newJString(fields))
  add(query_580750, "quotaUser", newJString(quotaUser))
  add(query_580750, "alt", newJString(alt))
  add(query_580750, "oauth_token", newJString(oauthToken))
  add(query_580750, "callback", newJString(callback))
  add(query_580750, "access_token", newJString(accessToken))
  add(query_580750, "uploadType", newJString(uploadType))
  add(path_580749, "id", newJString(id))
  add(query_580750, "key", newJString(key))
  add(path_580749, "courseId", newJString(courseId))
  add(query_580750, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580751 = body
  add(query_580750, "prettyPrint", newJBool(prettyPrint))
  add(query_580750, "updateMask", newJString(updateMask))
  result = call_580748.call(path_580749, query_580750, nil, nil, body_580751)

var classroomCoursesTopicsPatch* = Call_ClassroomCoursesTopicsPatch_580729(
    name: "classroomCoursesTopicsPatch", meth: HttpMethod.HttpPatch,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/topics/{id}",
    validator: validate_ClassroomCoursesTopicsPatch_580730, base: "/",
    url: url_ClassroomCoursesTopicsPatch_580731, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTopicsDelete_580709 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesTopicsDelete_580711(protocol: Scheme; host: string;
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

proc validate_ClassroomCoursesTopicsDelete_580710(path: JsonNode; query: JsonNode;
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
  var valid_580712 = path.getOrDefault("id")
  valid_580712 = validateParameter(valid_580712, JString, required = true,
                                 default = nil)
  if valid_580712 != nil:
    section.add "id", valid_580712
  var valid_580713 = path.getOrDefault("courseId")
  valid_580713 = validateParameter(valid_580713, JString, required = true,
                                 default = nil)
  if valid_580713 != nil:
    section.add "courseId", valid_580713
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
  var valid_580714 = query.getOrDefault("upload_protocol")
  valid_580714 = validateParameter(valid_580714, JString, required = false,
                                 default = nil)
  if valid_580714 != nil:
    section.add "upload_protocol", valid_580714
  var valid_580715 = query.getOrDefault("fields")
  valid_580715 = validateParameter(valid_580715, JString, required = false,
                                 default = nil)
  if valid_580715 != nil:
    section.add "fields", valid_580715
  var valid_580716 = query.getOrDefault("quotaUser")
  valid_580716 = validateParameter(valid_580716, JString, required = false,
                                 default = nil)
  if valid_580716 != nil:
    section.add "quotaUser", valid_580716
  var valid_580717 = query.getOrDefault("alt")
  valid_580717 = validateParameter(valid_580717, JString, required = false,
                                 default = newJString("json"))
  if valid_580717 != nil:
    section.add "alt", valid_580717
  var valid_580718 = query.getOrDefault("oauth_token")
  valid_580718 = validateParameter(valid_580718, JString, required = false,
                                 default = nil)
  if valid_580718 != nil:
    section.add "oauth_token", valid_580718
  var valid_580719 = query.getOrDefault("callback")
  valid_580719 = validateParameter(valid_580719, JString, required = false,
                                 default = nil)
  if valid_580719 != nil:
    section.add "callback", valid_580719
  var valid_580720 = query.getOrDefault("access_token")
  valid_580720 = validateParameter(valid_580720, JString, required = false,
                                 default = nil)
  if valid_580720 != nil:
    section.add "access_token", valid_580720
  var valid_580721 = query.getOrDefault("uploadType")
  valid_580721 = validateParameter(valid_580721, JString, required = false,
                                 default = nil)
  if valid_580721 != nil:
    section.add "uploadType", valid_580721
  var valid_580722 = query.getOrDefault("key")
  valid_580722 = validateParameter(valid_580722, JString, required = false,
                                 default = nil)
  if valid_580722 != nil:
    section.add "key", valid_580722
  var valid_580723 = query.getOrDefault("$.xgafv")
  valid_580723 = validateParameter(valid_580723, JString, required = false,
                                 default = newJString("1"))
  if valid_580723 != nil:
    section.add "$.xgafv", valid_580723
  var valid_580724 = query.getOrDefault("prettyPrint")
  valid_580724 = validateParameter(valid_580724, JBool, required = false,
                                 default = newJBool(true))
  if valid_580724 != nil:
    section.add "prettyPrint", valid_580724
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580725: Call_ClassroomCoursesTopicsDelete_580709; path: JsonNode;
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
  let valid = call_580725.validator(path, query, header, formData, body)
  let scheme = call_580725.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580725.url(scheme.get, call_580725.host, call_580725.base,
                         call_580725.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580725, url, valid)

proc call*(call_580726: Call_ClassroomCoursesTopicsDelete_580709; id: string;
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
  var path_580727 = newJObject()
  var query_580728 = newJObject()
  add(query_580728, "upload_protocol", newJString(uploadProtocol))
  add(query_580728, "fields", newJString(fields))
  add(query_580728, "quotaUser", newJString(quotaUser))
  add(query_580728, "alt", newJString(alt))
  add(query_580728, "oauth_token", newJString(oauthToken))
  add(query_580728, "callback", newJString(callback))
  add(query_580728, "access_token", newJString(accessToken))
  add(query_580728, "uploadType", newJString(uploadType))
  add(path_580727, "id", newJString(id))
  add(query_580728, "key", newJString(key))
  add(path_580727, "courseId", newJString(courseId))
  add(query_580728, "$.xgafv", newJString(Xgafv))
  add(query_580728, "prettyPrint", newJBool(prettyPrint))
  result = call_580726.call(path_580727, query_580728, nil, nil, nil)

var classroomCoursesTopicsDelete* = Call_ClassroomCoursesTopicsDelete_580709(
    name: "classroomCoursesTopicsDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/topics/{id}",
    validator: validate_ClassroomCoursesTopicsDelete_580710, base: "/",
    url: url_ClassroomCoursesTopicsDelete_580711, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesUpdate_580771 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesUpdate_580773(protocol: Scheme; host: string; base: string;
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

proc validate_ClassroomCoursesUpdate_580772(path: JsonNode; query: JsonNode;
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
  var valid_580774 = path.getOrDefault("id")
  valid_580774 = validateParameter(valid_580774, JString, required = true,
                                 default = nil)
  if valid_580774 != nil:
    section.add "id", valid_580774
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
  var valid_580775 = query.getOrDefault("upload_protocol")
  valid_580775 = validateParameter(valid_580775, JString, required = false,
                                 default = nil)
  if valid_580775 != nil:
    section.add "upload_protocol", valid_580775
  var valid_580776 = query.getOrDefault("fields")
  valid_580776 = validateParameter(valid_580776, JString, required = false,
                                 default = nil)
  if valid_580776 != nil:
    section.add "fields", valid_580776
  var valid_580777 = query.getOrDefault("quotaUser")
  valid_580777 = validateParameter(valid_580777, JString, required = false,
                                 default = nil)
  if valid_580777 != nil:
    section.add "quotaUser", valid_580777
  var valid_580778 = query.getOrDefault("alt")
  valid_580778 = validateParameter(valid_580778, JString, required = false,
                                 default = newJString("json"))
  if valid_580778 != nil:
    section.add "alt", valid_580778
  var valid_580779 = query.getOrDefault("oauth_token")
  valid_580779 = validateParameter(valid_580779, JString, required = false,
                                 default = nil)
  if valid_580779 != nil:
    section.add "oauth_token", valid_580779
  var valid_580780 = query.getOrDefault("callback")
  valid_580780 = validateParameter(valid_580780, JString, required = false,
                                 default = nil)
  if valid_580780 != nil:
    section.add "callback", valid_580780
  var valid_580781 = query.getOrDefault("access_token")
  valid_580781 = validateParameter(valid_580781, JString, required = false,
                                 default = nil)
  if valid_580781 != nil:
    section.add "access_token", valid_580781
  var valid_580782 = query.getOrDefault("uploadType")
  valid_580782 = validateParameter(valid_580782, JString, required = false,
                                 default = nil)
  if valid_580782 != nil:
    section.add "uploadType", valid_580782
  var valid_580783 = query.getOrDefault("key")
  valid_580783 = validateParameter(valid_580783, JString, required = false,
                                 default = nil)
  if valid_580783 != nil:
    section.add "key", valid_580783
  var valid_580784 = query.getOrDefault("$.xgafv")
  valid_580784 = validateParameter(valid_580784, JString, required = false,
                                 default = newJString("1"))
  if valid_580784 != nil:
    section.add "$.xgafv", valid_580784
  var valid_580785 = query.getOrDefault("prettyPrint")
  valid_580785 = validateParameter(valid_580785, JBool, required = false,
                                 default = newJBool(true))
  if valid_580785 != nil:
    section.add "prettyPrint", valid_580785
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

proc call*(call_580787: Call_ClassroomCoursesUpdate_580771; path: JsonNode;
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
  let valid = call_580787.validator(path, query, header, formData, body)
  let scheme = call_580787.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580787.url(scheme.get, call_580787.host, call_580787.base,
                         call_580787.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580787, url, valid)

proc call*(call_580788: Call_ClassroomCoursesUpdate_580771; id: string;
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
  var path_580789 = newJObject()
  var query_580790 = newJObject()
  var body_580791 = newJObject()
  add(query_580790, "upload_protocol", newJString(uploadProtocol))
  add(query_580790, "fields", newJString(fields))
  add(query_580790, "quotaUser", newJString(quotaUser))
  add(query_580790, "alt", newJString(alt))
  add(query_580790, "oauth_token", newJString(oauthToken))
  add(query_580790, "callback", newJString(callback))
  add(query_580790, "access_token", newJString(accessToken))
  add(query_580790, "uploadType", newJString(uploadType))
  add(path_580789, "id", newJString(id))
  add(query_580790, "key", newJString(key))
  add(query_580790, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580791 = body
  add(query_580790, "prettyPrint", newJBool(prettyPrint))
  result = call_580788.call(path_580789, query_580790, nil, nil, body_580791)

var classroomCoursesUpdate* = Call_ClassroomCoursesUpdate_580771(
    name: "classroomCoursesUpdate", meth: HttpMethod.HttpPut,
    host: "classroom.googleapis.com", route: "/v1/courses/{id}",
    validator: validate_ClassroomCoursesUpdate_580772, base: "/",
    url: url_ClassroomCoursesUpdate_580773, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesGet_580752 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesGet_580754(protocol: Scheme; host: string; base: string;
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

proc validate_ClassroomCoursesGet_580753(path: JsonNode; query: JsonNode;
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
  var valid_580755 = path.getOrDefault("id")
  valid_580755 = validateParameter(valid_580755, JString, required = true,
                                 default = nil)
  if valid_580755 != nil:
    section.add "id", valid_580755
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
  var valid_580756 = query.getOrDefault("upload_protocol")
  valid_580756 = validateParameter(valid_580756, JString, required = false,
                                 default = nil)
  if valid_580756 != nil:
    section.add "upload_protocol", valid_580756
  var valid_580757 = query.getOrDefault("fields")
  valid_580757 = validateParameter(valid_580757, JString, required = false,
                                 default = nil)
  if valid_580757 != nil:
    section.add "fields", valid_580757
  var valid_580758 = query.getOrDefault("quotaUser")
  valid_580758 = validateParameter(valid_580758, JString, required = false,
                                 default = nil)
  if valid_580758 != nil:
    section.add "quotaUser", valid_580758
  var valid_580759 = query.getOrDefault("alt")
  valid_580759 = validateParameter(valid_580759, JString, required = false,
                                 default = newJString("json"))
  if valid_580759 != nil:
    section.add "alt", valid_580759
  var valid_580760 = query.getOrDefault("oauth_token")
  valid_580760 = validateParameter(valid_580760, JString, required = false,
                                 default = nil)
  if valid_580760 != nil:
    section.add "oauth_token", valid_580760
  var valid_580761 = query.getOrDefault("callback")
  valid_580761 = validateParameter(valid_580761, JString, required = false,
                                 default = nil)
  if valid_580761 != nil:
    section.add "callback", valid_580761
  var valid_580762 = query.getOrDefault("access_token")
  valid_580762 = validateParameter(valid_580762, JString, required = false,
                                 default = nil)
  if valid_580762 != nil:
    section.add "access_token", valid_580762
  var valid_580763 = query.getOrDefault("uploadType")
  valid_580763 = validateParameter(valid_580763, JString, required = false,
                                 default = nil)
  if valid_580763 != nil:
    section.add "uploadType", valid_580763
  var valid_580764 = query.getOrDefault("key")
  valid_580764 = validateParameter(valid_580764, JString, required = false,
                                 default = nil)
  if valid_580764 != nil:
    section.add "key", valid_580764
  var valid_580765 = query.getOrDefault("$.xgafv")
  valid_580765 = validateParameter(valid_580765, JString, required = false,
                                 default = newJString("1"))
  if valid_580765 != nil:
    section.add "$.xgafv", valid_580765
  var valid_580766 = query.getOrDefault("prettyPrint")
  valid_580766 = validateParameter(valid_580766, JBool, required = false,
                                 default = newJBool(true))
  if valid_580766 != nil:
    section.add "prettyPrint", valid_580766
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580767: Call_ClassroomCoursesGet_580752; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or for access errors.
  ## * `NOT_FOUND` if no course exists with the requested ID.
  ## 
  let valid = call_580767.validator(path, query, header, formData, body)
  let scheme = call_580767.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580767.url(scheme.get, call_580767.host, call_580767.base,
                         call_580767.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580767, url, valid)

proc call*(call_580768: Call_ClassroomCoursesGet_580752; id: string;
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
  var path_580769 = newJObject()
  var query_580770 = newJObject()
  add(query_580770, "upload_protocol", newJString(uploadProtocol))
  add(query_580770, "fields", newJString(fields))
  add(query_580770, "quotaUser", newJString(quotaUser))
  add(query_580770, "alt", newJString(alt))
  add(query_580770, "oauth_token", newJString(oauthToken))
  add(query_580770, "callback", newJString(callback))
  add(query_580770, "access_token", newJString(accessToken))
  add(query_580770, "uploadType", newJString(uploadType))
  add(path_580769, "id", newJString(id))
  add(query_580770, "key", newJString(key))
  add(query_580770, "$.xgafv", newJString(Xgafv))
  add(query_580770, "prettyPrint", newJBool(prettyPrint))
  result = call_580768.call(path_580769, query_580770, nil, nil, nil)

var classroomCoursesGet* = Call_ClassroomCoursesGet_580752(
    name: "classroomCoursesGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/courses/{id}",
    validator: validate_ClassroomCoursesGet_580753, base: "/",
    url: url_ClassroomCoursesGet_580754, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesPatch_580811 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesPatch_580813(protocol: Scheme; host: string; base: string;
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

proc validate_ClassroomCoursesPatch_580812(path: JsonNode; query: JsonNode;
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
  var valid_580814 = path.getOrDefault("id")
  valid_580814 = validateParameter(valid_580814, JString, required = true,
                                 default = nil)
  if valid_580814 != nil:
    section.add "id", valid_580814
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
  var valid_580815 = query.getOrDefault("upload_protocol")
  valid_580815 = validateParameter(valid_580815, JString, required = false,
                                 default = nil)
  if valid_580815 != nil:
    section.add "upload_protocol", valid_580815
  var valid_580816 = query.getOrDefault("fields")
  valid_580816 = validateParameter(valid_580816, JString, required = false,
                                 default = nil)
  if valid_580816 != nil:
    section.add "fields", valid_580816
  var valid_580817 = query.getOrDefault("quotaUser")
  valid_580817 = validateParameter(valid_580817, JString, required = false,
                                 default = nil)
  if valid_580817 != nil:
    section.add "quotaUser", valid_580817
  var valid_580818 = query.getOrDefault("alt")
  valid_580818 = validateParameter(valid_580818, JString, required = false,
                                 default = newJString("json"))
  if valid_580818 != nil:
    section.add "alt", valid_580818
  var valid_580819 = query.getOrDefault("oauth_token")
  valid_580819 = validateParameter(valid_580819, JString, required = false,
                                 default = nil)
  if valid_580819 != nil:
    section.add "oauth_token", valid_580819
  var valid_580820 = query.getOrDefault("callback")
  valid_580820 = validateParameter(valid_580820, JString, required = false,
                                 default = nil)
  if valid_580820 != nil:
    section.add "callback", valid_580820
  var valid_580821 = query.getOrDefault("access_token")
  valid_580821 = validateParameter(valid_580821, JString, required = false,
                                 default = nil)
  if valid_580821 != nil:
    section.add "access_token", valid_580821
  var valid_580822 = query.getOrDefault("uploadType")
  valid_580822 = validateParameter(valid_580822, JString, required = false,
                                 default = nil)
  if valid_580822 != nil:
    section.add "uploadType", valid_580822
  var valid_580823 = query.getOrDefault("key")
  valid_580823 = validateParameter(valid_580823, JString, required = false,
                                 default = nil)
  if valid_580823 != nil:
    section.add "key", valid_580823
  var valid_580824 = query.getOrDefault("$.xgafv")
  valid_580824 = validateParameter(valid_580824, JString, required = false,
                                 default = newJString("1"))
  if valid_580824 != nil:
    section.add "$.xgafv", valid_580824
  var valid_580825 = query.getOrDefault("prettyPrint")
  valid_580825 = validateParameter(valid_580825, JBool, required = false,
                                 default = newJBool(true))
  if valid_580825 != nil:
    section.add "prettyPrint", valid_580825
  var valid_580826 = query.getOrDefault("updateMask")
  valid_580826 = validateParameter(valid_580826, JString, required = false,
                                 default = nil)
  if valid_580826 != nil:
    section.add "updateMask", valid_580826
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

proc call*(call_580828: Call_ClassroomCoursesPatch_580811; path: JsonNode;
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
  let valid = call_580828.validator(path, query, header, formData, body)
  let scheme = call_580828.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580828.url(scheme.get, call_580828.host, call_580828.base,
                         call_580828.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580828, url, valid)

proc call*(call_580829: Call_ClassroomCoursesPatch_580811; id: string;
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
  var path_580830 = newJObject()
  var query_580831 = newJObject()
  var body_580832 = newJObject()
  add(query_580831, "upload_protocol", newJString(uploadProtocol))
  add(query_580831, "fields", newJString(fields))
  add(query_580831, "quotaUser", newJString(quotaUser))
  add(query_580831, "alt", newJString(alt))
  add(query_580831, "oauth_token", newJString(oauthToken))
  add(query_580831, "callback", newJString(callback))
  add(query_580831, "access_token", newJString(accessToken))
  add(query_580831, "uploadType", newJString(uploadType))
  add(path_580830, "id", newJString(id))
  add(query_580831, "key", newJString(key))
  add(query_580831, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580832 = body
  add(query_580831, "prettyPrint", newJBool(prettyPrint))
  add(query_580831, "updateMask", newJString(updateMask))
  result = call_580829.call(path_580830, query_580831, nil, nil, body_580832)

var classroomCoursesPatch* = Call_ClassroomCoursesPatch_580811(
    name: "classroomCoursesPatch", meth: HttpMethod.HttpPatch,
    host: "classroom.googleapis.com", route: "/v1/courses/{id}",
    validator: validate_ClassroomCoursesPatch_580812, base: "/",
    url: url_ClassroomCoursesPatch_580813, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesDelete_580792 = ref object of OpenApiRestCall_579421
proc url_ClassroomCoursesDelete_580794(protocol: Scheme; host: string; base: string;
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

proc validate_ClassroomCoursesDelete_580793(path: JsonNode; query: JsonNode;
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
  var valid_580795 = path.getOrDefault("id")
  valid_580795 = validateParameter(valid_580795, JString, required = true,
                                 default = nil)
  if valid_580795 != nil:
    section.add "id", valid_580795
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
  var valid_580796 = query.getOrDefault("upload_protocol")
  valid_580796 = validateParameter(valid_580796, JString, required = false,
                                 default = nil)
  if valid_580796 != nil:
    section.add "upload_protocol", valid_580796
  var valid_580797 = query.getOrDefault("fields")
  valid_580797 = validateParameter(valid_580797, JString, required = false,
                                 default = nil)
  if valid_580797 != nil:
    section.add "fields", valid_580797
  var valid_580798 = query.getOrDefault("quotaUser")
  valid_580798 = validateParameter(valid_580798, JString, required = false,
                                 default = nil)
  if valid_580798 != nil:
    section.add "quotaUser", valid_580798
  var valid_580799 = query.getOrDefault("alt")
  valid_580799 = validateParameter(valid_580799, JString, required = false,
                                 default = newJString("json"))
  if valid_580799 != nil:
    section.add "alt", valid_580799
  var valid_580800 = query.getOrDefault("oauth_token")
  valid_580800 = validateParameter(valid_580800, JString, required = false,
                                 default = nil)
  if valid_580800 != nil:
    section.add "oauth_token", valid_580800
  var valid_580801 = query.getOrDefault("callback")
  valid_580801 = validateParameter(valid_580801, JString, required = false,
                                 default = nil)
  if valid_580801 != nil:
    section.add "callback", valid_580801
  var valid_580802 = query.getOrDefault("access_token")
  valid_580802 = validateParameter(valid_580802, JString, required = false,
                                 default = nil)
  if valid_580802 != nil:
    section.add "access_token", valid_580802
  var valid_580803 = query.getOrDefault("uploadType")
  valid_580803 = validateParameter(valid_580803, JString, required = false,
                                 default = nil)
  if valid_580803 != nil:
    section.add "uploadType", valid_580803
  var valid_580804 = query.getOrDefault("key")
  valid_580804 = validateParameter(valid_580804, JString, required = false,
                                 default = nil)
  if valid_580804 != nil:
    section.add "key", valid_580804
  var valid_580805 = query.getOrDefault("$.xgafv")
  valid_580805 = validateParameter(valid_580805, JString, required = false,
                                 default = newJString("1"))
  if valid_580805 != nil:
    section.add "$.xgafv", valid_580805
  var valid_580806 = query.getOrDefault("prettyPrint")
  valid_580806 = validateParameter(valid_580806, JBool, required = false,
                                 default = newJBool(true))
  if valid_580806 != nil:
    section.add "prettyPrint", valid_580806
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580807: Call_ClassroomCoursesDelete_580792; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to delete the
  ## requested course or for access errors.
  ## * `NOT_FOUND` if no course exists with the requested ID.
  ## 
  let valid = call_580807.validator(path, query, header, formData, body)
  let scheme = call_580807.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580807.url(scheme.get, call_580807.host, call_580807.base,
                         call_580807.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580807, url, valid)

proc call*(call_580808: Call_ClassroomCoursesDelete_580792; id: string;
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
  var path_580809 = newJObject()
  var query_580810 = newJObject()
  add(query_580810, "upload_protocol", newJString(uploadProtocol))
  add(query_580810, "fields", newJString(fields))
  add(query_580810, "quotaUser", newJString(quotaUser))
  add(query_580810, "alt", newJString(alt))
  add(query_580810, "oauth_token", newJString(oauthToken))
  add(query_580810, "callback", newJString(callback))
  add(query_580810, "access_token", newJString(accessToken))
  add(query_580810, "uploadType", newJString(uploadType))
  add(path_580809, "id", newJString(id))
  add(query_580810, "key", newJString(key))
  add(query_580810, "$.xgafv", newJString(Xgafv))
  add(query_580810, "prettyPrint", newJBool(prettyPrint))
  result = call_580808.call(path_580809, query_580810, nil, nil, nil)

var classroomCoursesDelete* = Call_ClassroomCoursesDelete_580792(
    name: "classroomCoursesDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com", route: "/v1/courses/{id}",
    validator: validate_ClassroomCoursesDelete_580793, base: "/",
    url: url_ClassroomCoursesDelete_580794, schemes: {Scheme.Https})
type
  Call_ClassroomInvitationsCreate_580854 = ref object of OpenApiRestCall_579421
proc url_ClassroomInvitationsCreate_580856(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ClassroomInvitationsCreate_580855(path: JsonNode; query: JsonNode;
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
  var valid_580857 = query.getOrDefault("upload_protocol")
  valid_580857 = validateParameter(valid_580857, JString, required = false,
                                 default = nil)
  if valid_580857 != nil:
    section.add "upload_protocol", valid_580857
  var valid_580858 = query.getOrDefault("fields")
  valid_580858 = validateParameter(valid_580858, JString, required = false,
                                 default = nil)
  if valid_580858 != nil:
    section.add "fields", valid_580858
  var valid_580859 = query.getOrDefault("quotaUser")
  valid_580859 = validateParameter(valid_580859, JString, required = false,
                                 default = nil)
  if valid_580859 != nil:
    section.add "quotaUser", valid_580859
  var valid_580860 = query.getOrDefault("alt")
  valid_580860 = validateParameter(valid_580860, JString, required = false,
                                 default = newJString("json"))
  if valid_580860 != nil:
    section.add "alt", valid_580860
  var valid_580861 = query.getOrDefault("oauth_token")
  valid_580861 = validateParameter(valid_580861, JString, required = false,
                                 default = nil)
  if valid_580861 != nil:
    section.add "oauth_token", valid_580861
  var valid_580862 = query.getOrDefault("callback")
  valid_580862 = validateParameter(valid_580862, JString, required = false,
                                 default = nil)
  if valid_580862 != nil:
    section.add "callback", valid_580862
  var valid_580863 = query.getOrDefault("access_token")
  valid_580863 = validateParameter(valid_580863, JString, required = false,
                                 default = nil)
  if valid_580863 != nil:
    section.add "access_token", valid_580863
  var valid_580864 = query.getOrDefault("uploadType")
  valid_580864 = validateParameter(valid_580864, JString, required = false,
                                 default = nil)
  if valid_580864 != nil:
    section.add "uploadType", valid_580864
  var valid_580865 = query.getOrDefault("key")
  valid_580865 = validateParameter(valid_580865, JString, required = false,
                                 default = nil)
  if valid_580865 != nil:
    section.add "key", valid_580865
  var valid_580866 = query.getOrDefault("$.xgafv")
  valid_580866 = validateParameter(valid_580866, JString, required = false,
                                 default = newJString("1"))
  if valid_580866 != nil:
    section.add "$.xgafv", valid_580866
  var valid_580867 = query.getOrDefault("prettyPrint")
  valid_580867 = validateParameter(valid_580867, JBool, required = false,
                                 default = newJBool(true))
  if valid_580867 != nil:
    section.add "prettyPrint", valid_580867
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

proc call*(call_580869: Call_ClassroomInvitationsCreate_580854; path: JsonNode;
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
  let valid = call_580869.validator(path, query, header, formData, body)
  let scheme = call_580869.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580869.url(scheme.get, call_580869.host, call_580869.base,
                         call_580869.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580869, url, valid)

proc call*(call_580870: Call_ClassroomInvitationsCreate_580854;
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
  var query_580871 = newJObject()
  var body_580872 = newJObject()
  add(query_580871, "upload_protocol", newJString(uploadProtocol))
  add(query_580871, "fields", newJString(fields))
  add(query_580871, "quotaUser", newJString(quotaUser))
  add(query_580871, "alt", newJString(alt))
  add(query_580871, "oauth_token", newJString(oauthToken))
  add(query_580871, "callback", newJString(callback))
  add(query_580871, "access_token", newJString(accessToken))
  add(query_580871, "uploadType", newJString(uploadType))
  add(query_580871, "key", newJString(key))
  add(query_580871, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580872 = body
  add(query_580871, "prettyPrint", newJBool(prettyPrint))
  result = call_580870.call(nil, query_580871, nil, nil, body_580872)

var classroomInvitationsCreate* = Call_ClassroomInvitationsCreate_580854(
    name: "classroomInvitationsCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/invitations",
    validator: validate_ClassroomInvitationsCreate_580855, base: "/",
    url: url_ClassroomInvitationsCreate_580856, schemes: {Scheme.Https})
type
  Call_ClassroomInvitationsList_580833 = ref object of OpenApiRestCall_579421
proc url_ClassroomInvitationsList_580835(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ClassroomInvitationsList_580834(path: JsonNode; query: JsonNode;
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
  var valid_580836 = query.getOrDefault("upload_protocol")
  valid_580836 = validateParameter(valid_580836, JString, required = false,
                                 default = nil)
  if valid_580836 != nil:
    section.add "upload_protocol", valid_580836
  var valid_580837 = query.getOrDefault("fields")
  valid_580837 = validateParameter(valid_580837, JString, required = false,
                                 default = nil)
  if valid_580837 != nil:
    section.add "fields", valid_580837
  var valid_580838 = query.getOrDefault("pageToken")
  valid_580838 = validateParameter(valid_580838, JString, required = false,
                                 default = nil)
  if valid_580838 != nil:
    section.add "pageToken", valid_580838
  var valid_580839 = query.getOrDefault("quotaUser")
  valid_580839 = validateParameter(valid_580839, JString, required = false,
                                 default = nil)
  if valid_580839 != nil:
    section.add "quotaUser", valid_580839
  var valid_580840 = query.getOrDefault("alt")
  valid_580840 = validateParameter(valid_580840, JString, required = false,
                                 default = newJString("json"))
  if valid_580840 != nil:
    section.add "alt", valid_580840
  var valid_580841 = query.getOrDefault("oauth_token")
  valid_580841 = validateParameter(valid_580841, JString, required = false,
                                 default = nil)
  if valid_580841 != nil:
    section.add "oauth_token", valid_580841
  var valid_580842 = query.getOrDefault("callback")
  valid_580842 = validateParameter(valid_580842, JString, required = false,
                                 default = nil)
  if valid_580842 != nil:
    section.add "callback", valid_580842
  var valid_580843 = query.getOrDefault("access_token")
  valid_580843 = validateParameter(valid_580843, JString, required = false,
                                 default = nil)
  if valid_580843 != nil:
    section.add "access_token", valid_580843
  var valid_580844 = query.getOrDefault("uploadType")
  valid_580844 = validateParameter(valid_580844, JString, required = false,
                                 default = nil)
  if valid_580844 != nil:
    section.add "uploadType", valid_580844
  var valid_580845 = query.getOrDefault("key")
  valid_580845 = validateParameter(valid_580845, JString, required = false,
                                 default = nil)
  if valid_580845 != nil:
    section.add "key", valid_580845
  var valid_580846 = query.getOrDefault("$.xgafv")
  valid_580846 = validateParameter(valid_580846, JString, required = false,
                                 default = newJString("1"))
  if valid_580846 != nil:
    section.add "$.xgafv", valid_580846
  var valid_580847 = query.getOrDefault("courseId")
  valid_580847 = validateParameter(valid_580847, JString, required = false,
                                 default = nil)
  if valid_580847 != nil:
    section.add "courseId", valid_580847
  var valid_580848 = query.getOrDefault("pageSize")
  valid_580848 = validateParameter(valid_580848, JInt, required = false, default = nil)
  if valid_580848 != nil:
    section.add "pageSize", valid_580848
  var valid_580849 = query.getOrDefault("prettyPrint")
  valid_580849 = validateParameter(valid_580849, JBool, required = false,
                                 default = newJBool(true))
  if valid_580849 != nil:
    section.add "prettyPrint", valid_580849
  var valid_580850 = query.getOrDefault("userId")
  valid_580850 = validateParameter(valid_580850, JString, required = false,
                                 default = nil)
  if valid_580850 != nil:
    section.add "userId", valid_580850
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580851: Call_ClassroomInvitationsList_580833; path: JsonNode;
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
  let valid = call_580851.validator(path, query, header, formData, body)
  let scheme = call_580851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580851.url(scheme.get, call_580851.host, call_580851.base,
                         call_580851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580851, url, valid)

proc call*(call_580852: Call_ClassroomInvitationsList_580833;
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
  var query_580853 = newJObject()
  add(query_580853, "upload_protocol", newJString(uploadProtocol))
  add(query_580853, "fields", newJString(fields))
  add(query_580853, "pageToken", newJString(pageToken))
  add(query_580853, "quotaUser", newJString(quotaUser))
  add(query_580853, "alt", newJString(alt))
  add(query_580853, "oauth_token", newJString(oauthToken))
  add(query_580853, "callback", newJString(callback))
  add(query_580853, "access_token", newJString(accessToken))
  add(query_580853, "uploadType", newJString(uploadType))
  add(query_580853, "key", newJString(key))
  add(query_580853, "$.xgafv", newJString(Xgafv))
  add(query_580853, "courseId", newJString(courseId))
  add(query_580853, "pageSize", newJInt(pageSize))
  add(query_580853, "prettyPrint", newJBool(prettyPrint))
  add(query_580853, "userId", newJString(userId))
  result = call_580852.call(nil, query_580853, nil, nil, nil)

var classroomInvitationsList* = Call_ClassroomInvitationsList_580833(
    name: "classroomInvitationsList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/invitations",
    validator: validate_ClassroomInvitationsList_580834, base: "/",
    url: url_ClassroomInvitationsList_580835, schemes: {Scheme.Https})
type
  Call_ClassroomInvitationsGet_580873 = ref object of OpenApiRestCall_579421
proc url_ClassroomInvitationsGet_580875(protocol: Scheme; host: string; base: string;
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

proc validate_ClassroomInvitationsGet_580874(path: JsonNode; query: JsonNode;
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
  var valid_580876 = path.getOrDefault("id")
  valid_580876 = validateParameter(valid_580876, JString, required = true,
                                 default = nil)
  if valid_580876 != nil:
    section.add "id", valid_580876
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
  var valid_580877 = query.getOrDefault("upload_protocol")
  valid_580877 = validateParameter(valid_580877, JString, required = false,
                                 default = nil)
  if valid_580877 != nil:
    section.add "upload_protocol", valid_580877
  var valid_580878 = query.getOrDefault("fields")
  valid_580878 = validateParameter(valid_580878, JString, required = false,
                                 default = nil)
  if valid_580878 != nil:
    section.add "fields", valid_580878
  var valid_580879 = query.getOrDefault("quotaUser")
  valid_580879 = validateParameter(valid_580879, JString, required = false,
                                 default = nil)
  if valid_580879 != nil:
    section.add "quotaUser", valid_580879
  var valid_580880 = query.getOrDefault("alt")
  valid_580880 = validateParameter(valid_580880, JString, required = false,
                                 default = newJString("json"))
  if valid_580880 != nil:
    section.add "alt", valid_580880
  var valid_580881 = query.getOrDefault("oauth_token")
  valid_580881 = validateParameter(valid_580881, JString, required = false,
                                 default = nil)
  if valid_580881 != nil:
    section.add "oauth_token", valid_580881
  var valid_580882 = query.getOrDefault("callback")
  valid_580882 = validateParameter(valid_580882, JString, required = false,
                                 default = nil)
  if valid_580882 != nil:
    section.add "callback", valid_580882
  var valid_580883 = query.getOrDefault("access_token")
  valid_580883 = validateParameter(valid_580883, JString, required = false,
                                 default = nil)
  if valid_580883 != nil:
    section.add "access_token", valid_580883
  var valid_580884 = query.getOrDefault("uploadType")
  valid_580884 = validateParameter(valid_580884, JString, required = false,
                                 default = nil)
  if valid_580884 != nil:
    section.add "uploadType", valid_580884
  var valid_580885 = query.getOrDefault("key")
  valid_580885 = validateParameter(valid_580885, JString, required = false,
                                 default = nil)
  if valid_580885 != nil:
    section.add "key", valid_580885
  var valid_580886 = query.getOrDefault("$.xgafv")
  valid_580886 = validateParameter(valid_580886, JString, required = false,
                                 default = newJString("1"))
  if valid_580886 != nil:
    section.add "$.xgafv", valid_580886
  var valid_580887 = query.getOrDefault("prettyPrint")
  valid_580887 = validateParameter(valid_580887, JBool, required = false,
                                 default = newJBool(true))
  if valid_580887 != nil:
    section.add "prettyPrint", valid_580887
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580888: Call_ClassroomInvitationsGet_580873; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns an invitation.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to view the
  ## requested invitation or for access errors.
  ## * `NOT_FOUND` if no invitation exists with the requested ID.
  ## 
  let valid = call_580888.validator(path, query, header, formData, body)
  let scheme = call_580888.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580888.url(scheme.get, call_580888.host, call_580888.base,
                         call_580888.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580888, url, valid)

proc call*(call_580889: Call_ClassroomInvitationsGet_580873; id: string;
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
  var path_580890 = newJObject()
  var query_580891 = newJObject()
  add(query_580891, "upload_protocol", newJString(uploadProtocol))
  add(query_580891, "fields", newJString(fields))
  add(query_580891, "quotaUser", newJString(quotaUser))
  add(query_580891, "alt", newJString(alt))
  add(query_580891, "oauth_token", newJString(oauthToken))
  add(query_580891, "callback", newJString(callback))
  add(query_580891, "access_token", newJString(accessToken))
  add(query_580891, "uploadType", newJString(uploadType))
  add(path_580890, "id", newJString(id))
  add(query_580891, "key", newJString(key))
  add(query_580891, "$.xgafv", newJString(Xgafv))
  add(query_580891, "prettyPrint", newJBool(prettyPrint))
  result = call_580889.call(path_580890, query_580891, nil, nil, nil)

var classroomInvitationsGet* = Call_ClassroomInvitationsGet_580873(
    name: "classroomInvitationsGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/invitations/{id}",
    validator: validate_ClassroomInvitationsGet_580874, base: "/",
    url: url_ClassroomInvitationsGet_580875, schemes: {Scheme.Https})
type
  Call_ClassroomInvitationsDelete_580892 = ref object of OpenApiRestCall_579421
proc url_ClassroomInvitationsDelete_580894(protocol: Scheme; host: string;
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

proc validate_ClassroomInvitationsDelete_580893(path: JsonNode; query: JsonNode;
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
  var valid_580895 = path.getOrDefault("id")
  valid_580895 = validateParameter(valid_580895, JString, required = true,
                                 default = nil)
  if valid_580895 != nil:
    section.add "id", valid_580895
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
  var valid_580896 = query.getOrDefault("upload_protocol")
  valid_580896 = validateParameter(valid_580896, JString, required = false,
                                 default = nil)
  if valid_580896 != nil:
    section.add "upload_protocol", valid_580896
  var valid_580897 = query.getOrDefault("fields")
  valid_580897 = validateParameter(valid_580897, JString, required = false,
                                 default = nil)
  if valid_580897 != nil:
    section.add "fields", valid_580897
  var valid_580898 = query.getOrDefault("quotaUser")
  valid_580898 = validateParameter(valid_580898, JString, required = false,
                                 default = nil)
  if valid_580898 != nil:
    section.add "quotaUser", valid_580898
  var valid_580899 = query.getOrDefault("alt")
  valid_580899 = validateParameter(valid_580899, JString, required = false,
                                 default = newJString("json"))
  if valid_580899 != nil:
    section.add "alt", valid_580899
  var valid_580900 = query.getOrDefault("oauth_token")
  valid_580900 = validateParameter(valid_580900, JString, required = false,
                                 default = nil)
  if valid_580900 != nil:
    section.add "oauth_token", valid_580900
  var valid_580901 = query.getOrDefault("callback")
  valid_580901 = validateParameter(valid_580901, JString, required = false,
                                 default = nil)
  if valid_580901 != nil:
    section.add "callback", valid_580901
  var valid_580902 = query.getOrDefault("access_token")
  valid_580902 = validateParameter(valid_580902, JString, required = false,
                                 default = nil)
  if valid_580902 != nil:
    section.add "access_token", valid_580902
  var valid_580903 = query.getOrDefault("uploadType")
  valid_580903 = validateParameter(valid_580903, JString, required = false,
                                 default = nil)
  if valid_580903 != nil:
    section.add "uploadType", valid_580903
  var valid_580904 = query.getOrDefault("key")
  valid_580904 = validateParameter(valid_580904, JString, required = false,
                                 default = nil)
  if valid_580904 != nil:
    section.add "key", valid_580904
  var valid_580905 = query.getOrDefault("$.xgafv")
  valid_580905 = validateParameter(valid_580905, JString, required = false,
                                 default = newJString("1"))
  if valid_580905 != nil:
    section.add "$.xgafv", valid_580905
  var valid_580906 = query.getOrDefault("prettyPrint")
  valid_580906 = validateParameter(valid_580906, JBool, required = false,
                                 default = newJBool(true))
  if valid_580906 != nil:
    section.add "prettyPrint", valid_580906
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580907: Call_ClassroomInvitationsDelete_580892; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an invitation.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to delete the
  ## requested invitation or for access errors.
  ## * `NOT_FOUND` if no invitation exists with the requested ID.
  ## 
  let valid = call_580907.validator(path, query, header, formData, body)
  let scheme = call_580907.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580907.url(scheme.get, call_580907.host, call_580907.base,
                         call_580907.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580907, url, valid)

proc call*(call_580908: Call_ClassroomInvitationsDelete_580892; id: string;
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
  var path_580909 = newJObject()
  var query_580910 = newJObject()
  add(query_580910, "upload_protocol", newJString(uploadProtocol))
  add(query_580910, "fields", newJString(fields))
  add(query_580910, "quotaUser", newJString(quotaUser))
  add(query_580910, "alt", newJString(alt))
  add(query_580910, "oauth_token", newJString(oauthToken))
  add(query_580910, "callback", newJString(callback))
  add(query_580910, "access_token", newJString(accessToken))
  add(query_580910, "uploadType", newJString(uploadType))
  add(path_580909, "id", newJString(id))
  add(query_580910, "key", newJString(key))
  add(query_580910, "$.xgafv", newJString(Xgafv))
  add(query_580910, "prettyPrint", newJBool(prettyPrint))
  result = call_580908.call(path_580909, query_580910, nil, nil, nil)

var classroomInvitationsDelete* = Call_ClassroomInvitationsDelete_580892(
    name: "classroomInvitationsDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com", route: "/v1/invitations/{id}",
    validator: validate_ClassroomInvitationsDelete_580893, base: "/",
    url: url_ClassroomInvitationsDelete_580894, schemes: {Scheme.Https})
type
  Call_ClassroomInvitationsAccept_580911 = ref object of OpenApiRestCall_579421
proc url_ClassroomInvitationsAccept_580913(protocol: Scheme; host: string;
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

proc validate_ClassroomInvitationsAccept_580912(path: JsonNode; query: JsonNode;
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
  var valid_580914 = path.getOrDefault("id")
  valid_580914 = validateParameter(valid_580914, JString, required = true,
                                 default = nil)
  if valid_580914 != nil:
    section.add "id", valid_580914
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
  var valid_580915 = query.getOrDefault("upload_protocol")
  valid_580915 = validateParameter(valid_580915, JString, required = false,
                                 default = nil)
  if valid_580915 != nil:
    section.add "upload_protocol", valid_580915
  var valid_580916 = query.getOrDefault("fields")
  valid_580916 = validateParameter(valid_580916, JString, required = false,
                                 default = nil)
  if valid_580916 != nil:
    section.add "fields", valid_580916
  var valid_580917 = query.getOrDefault("quotaUser")
  valid_580917 = validateParameter(valid_580917, JString, required = false,
                                 default = nil)
  if valid_580917 != nil:
    section.add "quotaUser", valid_580917
  var valid_580918 = query.getOrDefault("alt")
  valid_580918 = validateParameter(valid_580918, JString, required = false,
                                 default = newJString("json"))
  if valid_580918 != nil:
    section.add "alt", valid_580918
  var valid_580919 = query.getOrDefault("oauth_token")
  valid_580919 = validateParameter(valid_580919, JString, required = false,
                                 default = nil)
  if valid_580919 != nil:
    section.add "oauth_token", valid_580919
  var valid_580920 = query.getOrDefault("callback")
  valid_580920 = validateParameter(valid_580920, JString, required = false,
                                 default = nil)
  if valid_580920 != nil:
    section.add "callback", valid_580920
  var valid_580921 = query.getOrDefault("access_token")
  valid_580921 = validateParameter(valid_580921, JString, required = false,
                                 default = nil)
  if valid_580921 != nil:
    section.add "access_token", valid_580921
  var valid_580922 = query.getOrDefault("uploadType")
  valid_580922 = validateParameter(valid_580922, JString, required = false,
                                 default = nil)
  if valid_580922 != nil:
    section.add "uploadType", valid_580922
  var valid_580923 = query.getOrDefault("key")
  valid_580923 = validateParameter(valid_580923, JString, required = false,
                                 default = nil)
  if valid_580923 != nil:
    section.add "key", valid_580923
  var valid_580924 = query.getOrDefault("$.xgafv")
  valid_580924 = validateParameter(valid_580924, JString, required = false,
                                 default = newJString("1"))
  if valid_580924 != nil:
    section.add "$.xgafv", valid_580924
  var valid_580925 = query.getOrDefault("prettyPrint")
  valid_580925 = validateParameter(valid_580925, JBool, required = false,
                                 default = newJBool(true))
  if valid_580925 != nil:
    section.add "prettyPrint", valid_580925
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580926: Call_ClassroomInvitationsAccept_580911; path: JsonNode;
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
  let valid = call_580926.validator(path, query, header, formData, body)
  let scheme = call_580926.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580926.url(scheme.get, call_580926.host, call_580926.base,
                         call_580926.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580926, url, valid)

proc call*(call_580927: Call_ClassroomInvitationsAccept_580911; id: string;
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
  var path_580928 = newJObject()
  var query_580929 = newJObject()
  add(query_580929, "upload_protocol", newJString(uploadProtocol))
  add(query_580929, "fields", newJString(fields))
  add(query_580929, "quotaUser", newJString(quotaUser))
  add(query_580929, "alt", newJString(alt))
  add(query_580929, "oauth_token", newJString(oauthToken))
  add(query_580929, "callback", newJString(callback))
  add(query_580929, "access_token", newJString(accessToken))
  add(query_580929, "uploadType", newJString(uploadType))
  add(path_580928, "id", newJString(id))
  add(query_580929, "key", newJString(key))
  add(query_580929, "$.xgafv", newJString(Xgafv))
  add(query_580929, "prettyPrint", newJBool(prettyPrint))
  result = call_580927.call(path_580928, query_580929, nil, nil, nil)

var classroomInvitationsAccept* = Call_ClassroomInvitationsAccept_580911(
    name: "classroomInvitationsAccept", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/invitations/{id}:accept",
    validator: validate_ClassroomInvitationsAccept_580912, base: "/",
    url: url_ClassroomInvitationsAccept_580913, schemes: {Scheme.Https})
type
  Call_ClassroomRegistrationsCreate_580930 = ref object of OpenApiRestCall_579421
proc url_ClassroomRegistrationsCreate_580932(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ClassroomRegistrationsCreate_580931(path: JsonNode; query: JsonNode;
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
  var valid_580933 = query.getOrDefault("upload_protocol")
  valid_580933 = validateParameter(valid_580933, JString, required = false,
                                 default = nil)
  if valid_580933 != nil:
    section.add "upload_protocol", valid_580933
  var valid_580934 = query.getOrDefault("fields")
  valid_580934 = validateParameter(valid_580934, JString, required = false,
                                 default = nil)
  if valid_580934 != nil:
    section.add "fields", valid_580934
  var valid_580935 = query.getOrDefault("quotaUser")
  valid_580935 = validateParameter(valid_580935, JString, required = false,
                                 default = nil)
  if valid_580935 != nil:
    section.add "quotaUser", valid_580935
  var valid_580936 = query.getOrDefault("alt")
  valid_580936 = validateParameter(valid_580936, JString, required = false,
                                 default = newJString("json"))
  if valid_580936 != nil:
    section.add "alt", valid_580936
  var valid_580937 = query.getOrDefault("oauth_token")
  valid_580937 = validateParameter(valid_580937, JString, required = false,
                                 default = nil)
  if valid_580937 != nil:
    section.add "oauth_token", valid_580937
  var valid_580938 = query.getOrDefault("callback")
  valid_580938 = validateParameter(valid_580938, JString, required = false,
                                 default = nil)
  if valid_580938 != nil:
    section.add "callback", valid_580938
  var valid_580939 = query.getOrDefault("access_token")
  valid_580939 = validateParameter(valid_580939, JString, required = false,
                                 default = nil)
  if valid_580939 != nil:
    section.add "access_token", valid_580939
  var valid_580940 = query.getOrDefault("uploadType")
  valid_580940 = validateParameter(valid_580940, JString, required = false,
                                 default = nil)
  if valid_580940 != nil:
    section.add "uploadType", valid_580940
  var valid_580941 = query.getOrDefault("key")
  valid_580941 = validateParameter(valid_580941, JString, required = false,
                                 default = nil)
  if valid_580941 != nil:
    section.add "key", valid_580941
  var valid_580942 = query.getOrDefault("$.xgafv")
  valid_580942 = validateParameter(valid_580942, JString, required = false,
                                 default = newJString("1"))
  if valid_580942 != nil:
    section.add "$.xgafv", valid_580942
  var valid_580943 = query.getOrDefault("prettyPrint")
  valid_580943 = validateParameter(valid_580943, JBool, required = false,
                                 default = newJBool(true))
  if valid_580943 != nil:
    section.add "prettyPrint", valid_580943
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

proc call*(call_580945: Call_ClassroomRegistrationsCreate_580930; path: JsonNode;
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
  let valid = call_580945.validator(path, query, header, formData, body)
  let scheme = call_580945.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580945.url(scheme.get, call_580945.host, call_580945.base,
                         call_580945.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580945, url, valid)

proc call*(call_580946: Call_ClassroomRegistrationsCreate_580930;
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
  var query_580947 = newJObject()
  var body_580948 = newJObject()
  add(query_580947, "upload_protocol", newJString(uploadProtocol))
  add(query_580947, "fields", newJString(fields))
  add(query_580947, "quotaUser", newJString(quotaUser))
  add(query_580947, "alt", newJString(alt))
  add(query_580947, "oauth_token", newJString(oauthToken))
  add(query_580947, "callback", newJString(callback))
  add(query_580947, "access_token", newJString(accessToken))
  add(query_580947, "uploadType", newJString(uploadType))
  add(query_580947, "key", newJString(key))
  add(query_580947, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580948 = body
  add(query_580947, "prettyPrint", newJBool(prettyPrint))
  result = call_580946.call(nil, query_580947, nil, nil, body_580948)

var classroomRegistrationsCreate* = Call_ClassroomRegistrationsCreate_580930(
    name: "classroomRegistrationsCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/registrations",
    validator: validate_ClassroomRegistrationsCreate_580931, base: "/",
    url: url_ClassroomRegistrationsCreate_580932, schemes: {Scheme.Https})
type
  Call_ClassroomRegistrationsDelete_580949 = ref object of OpenApiRestCall_579421
proc url_ClassroomRegistrationsDelete_580951(protocol: Scheme; host: string;
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

proc validate_ClassroomRegistrationsDelete_580950(path: JsonNode; query: JsonNode;
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
  var valid_580952 = path.getOrDefault("registrationId")
  valid_580952 = validateParameter(valid_580952, JString, required = true,
                                 default = nil)
  if valid_580952 != nil:
    section.add "registrationId", valid_580952
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
  var valid_580953 = query.getOrDefault("upload_protocol")
  valid_580953 = validateParameter(valid_580953, JString, required = false,
                                 default = nil)
  if valid_580953 != nil:
    section.add "upload_protocol", valid_580953
  var valid_580954 = query.getOrDefault("fields")
  valid_580954 = validateParameter(valid_580954, JString, required = false,
                                 default = nil)
  if valid_580954 != nil:
    section.add "fields", valid_580954
  var valid_580955 = query.getOrDefault("quotaUser")
  valid_580955 = validateParameter(valid_580955, JString, required = false,
                                 default = nil)
  if valid_580955 != nil:
    section.add "quotaUser", valid_580955
  var valid_580956 = query.getOrDefault("alt")
  valid_580956 = validateParameter(valid_580956, JString, required = false,
                                 default = newJString("json"))
  if valid_580956 != nil:
    section.add "alt", valid_580956
  var valid_580957 = query.getOrDefault("oauth_token")
  valid_580957 = validateParameter(valid_580957, JString, required = false,
                                 default = nil)
  if valid_580957 != nil:
    section.add "oauth_token", valid_580957
  var valid_580958 = query.getOrDefault("callback")
  valid_580958 = validateParameter(valid_580958, JString, required = false,
                                 default = nil)
  if valid_580958 != nil:
    section.add "callback", valid_580958
  var valid_580959 = query.getOrDefault("access_token")
  valid_580959 = validateParameter(valid_580959, JString, required = false,
                                 default = nil)
  if valid_580959 != nil:
    section.add "access_token", valid_580959
  var valid_580960 = query.getOrDefault("uploadType")
  valid_580960 = validateParameter(valid_580960, JString, required = false,
                                 default = nil)
  if valid_580960 != nil:
    section.add "uploadType", valid_580960
  var valid_580961 = query.getOrDefault("key")
  valid_580961 = validateParameter(valid_580961, JString, required = false,
                                 default = nil)
  if valid_580961 != nil:
    section.add "key", valid_580961
  var valid_580962 = query.getOrDefault("$.xgafv")
  valid_580962 = validateParameter(valid_580962, JString, required = false,
                                 default = newJString("1"))
  if valid_580962 != nil:
    section.add "$.xgafv", valid_580962
  var valid_580963 = query.getOrDefault("prettyPrint")
  valid_580963 = validateParameter(valid_580963, JBool, required = false,
                                 default = newJBool(true))
  if valid_580963 != nil:
    section.add "prettyPrint", valid_580963
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580964: Call_ClassroomRegistrationsDelete_580949; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a `Registration`, causing Classroom to stop sending notifications
  ## for that `Registration`.
  ## 
  let valid = call_580964.validator(path, query, header, formData, body)
  let scheme = call_580964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580964.url(scheme.get, call_580964.host, call_580964.base,
                         call_580964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580964, url, valid)

proc call*(call_580965: Call_ClassroomRegistrationsDelete_580949;
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
  var path_580966 = newJObject()
  var query_580967 = newJObject()
  add(query_580967, "upload_protocol", newJString(uploadProtocol))
  add(query_580967, "fields", newJString(fields))
  add(query_580967, "quotaUser", newJString(quotaUser))
  add(path_580966, "registrationId", newJString(registrationId))
  add(query_580967, "alt", newJString(alt))
  add(query_580967, "oauth_token", newJString(oauthToken))
  add(query_580967, "callback", newJString(callback))
  add(query_580967, "access_token", newJString(accessToken))
  add(query_580967, "uploadType", newJString(uploadType))
  add(query_580967, "key", newJString(key))
  add(query_580967, "$.xgafv", newJString(Xgafv))
  add(query_580967, "prettyPrint", newJBool(prettyPrint))
  result = call_580965.call(path_580966, query_580967, nil, nil, nil)

var classroomRegistrationsDelete* = Call_ClassroomRegistrationsDelete_580949(
    name: "classroomRegistrationsDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com", route: "/v1/registrations/{registrationId}",
    validator: validate_ClassroomRegistrationsDelete_580950, base: "/",
    url: url_ClassroomRegistrationsDelete_580951, schemes: {Scheme.Https})
type
  Call_ClassroomUserProfilesGuardianInvitationsCreate_580991 = ref object of OpenApiRestCall_579421
proc url_ClassroomUserProfilesGuardianInvitationsCreate_580993(protocol: Scheme;
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

proc validate_ClassroomUserProfilesGuardianInvitationsCreate_580992(
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
  var valid_580994 = path.getOrDefault("studentId")
  valid_580994 = validateParameter(valid_580994, JString, required = true,
                                 default = nil)
  if valid_580994 != nil:
    section.add "studentId", valid_580994
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
  var valid_580995 = query.getOrDefault("upload_protocol")
  valid_580995 = validateParameter(valid_580995, JString, required = false,
                                 default = nil)
  if valid_580995 != nil:
    section.add "upload_protocol", valid_580995
  var valid_580996 = query.getOrDefault("fields")
  valid_580996 = validateParameter(valid_580996, JString, required = false,
                                 default = nil)
  if valid_580996 != nil:
    section.add "fields", valid_580996
  var valid_580997 = query.getOrDefault("quotaUser")
  valid_580997 = validateParameter(valid_580997, JString, required = false,
                                 default = nil)
  if valid_580997 != nil:
    section.add "quotaUser", valid_580997
  var valid_580998 = query.getOrDefault("alt")
  valid_580998 = validateParameter(valid_580998, JString, required = false,
                                 default = newJString("json"))
  if valid_580998 != nil:
    section.add "alt", valid_580998
  var valid_580999 = query.getOrDefault("oauth_token")
  valid_580999 = validateParameter(valid_580999, JString, required = false,
                                 default = nil)
  if valid_580999 != nil:
    section.add "oauth_token", valid_580999
  var valid_581000 = query.getOrDefault("callback")
  valid_581000 = validateParameter(valid_581000, JString, required = false,
                                 default = nil)
  if valid_581000 != nil:
    section.add "callback", valid_581000
  var valid_581001 = query.getOrDefault("access_token")
  valid_581001 = validateParameter(valid_581001, JString, required = false,
                                 default = nil)
  if valid_581001 != nil:
    section.add "access_token", valid_581001
  var valid_581002 = query.getOrDefault("uploadType")
  valid_581002 = validateParameter(valid_581002, JString, required = false,
                                 default = nil)
  if valid_581002 != nil:
    section.add "uploadType", valid_581002
  var valid_581003 = query.getOrDefault("key")
  valid_581003 = validateParameter(valid_581003, JString, required = false,
                                 default = nil)
  if valid_581003 != nil:
    section.add "key", valid_581003
  var valid_581004 = query.getOrDefault("$.xgafv")
  valid_581004 = validateParameter(valid_581004, JString, required = false,
                                 default = newJString("1"))
  if valid_581004 != nil:
    section.add "$.xgafv", valid_581004
  var valid_581005 = query.getOrDefault("prettyPrint")
  valid_581005 = validateParameter(valid_581005, JBool, required = false,
                                 default = newJBool(true))
  if valid_581005 != nil:
    section.add "prettyPrint", valid_581005
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

proc call*(call_581007: Call_ClassroomUserProfilesGuardianInvitationsCreate_580991;
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
  let valid = call_581007.validator(path, query, header, formData, body)
  let scheme = call_581007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581007.url(scheme.get, call_581007.host, call_581007.base,
                         call_581007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581007, url, valid)

proc call*(call_581008: Call_ClassroomUserProfilesGuardianInvitationsCreate_580991;
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
  var path_581009 = newJObject()
  var query_581010 = newJObject()
  var body_581011 = newJObject()
  add(query_581010, "upload_protocol", newJString(uploadProtocol))
  add(query_581010, "fields", newJString(fields))
  add(query_581010, "quotaUser", newJString(quotaUser))
  add(query_581010, "alt", newJString(alt))
  add(query_581010, "oauth_token", newJString(oauthToken))
  add(query_581010, "callback", newJString(callback))
  add(query_581010, "access_token", newJString(accessToken))
  add(query_581010, "uploadType", newJString(uploadType))
  add(path_581009, "studentId", newJString(studentId))
  add(query_581010, "key", newJString(key))
  add(query_581010, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_581011 = body
  add(query_581010, "prettyPrint", newJBool(prettyPrint))
  result = call_581008.call(path_581009, query_581010, nil, nil, body_581011)

var classroomUserProfilesGuardianInvitationsCreate* = Call_ClassroomUserProfilesGuardianInvitationsCreate_580991(
    name: "classroomUserProfilesGuardianInvitationsCreate",
    meth: HttpMethod.HttpPost, host: "classroom.googleapis.com",
    route: "/v1/userProfiles/{studentId}/guardianInvitations",
    validator: validate_ClassroomUserProfilesGuardianInvitationsCreate_580992,
    base: "/", url: url_ClassroomUserProfilesGuardianInvitationsCreate_580993,
    schemes: {Scheme.Https})
type
  Call_ClassroomUserProfilesGuardianInvitationsList_580968 = ref object of OpenApiRestCall_579421
proc url_ClassroomUserProfilesGuardianInvitationsList_580970(protocol: Scheme;
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

proc validate_ClassroomUserProfilesGuardianInvitationsList_580969(path: JsonNode;
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
  var valid_580971 = path.getOrDefault("studentId")
  valid_580971 = validateParameter(valid_580971, JString, required = true,
                                 default = nil)
  if valid_580971 != nil:
    section.add "studentId", valid_580971
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
  var valid_580972 = query.getOrDefault("upload_protocol")
  valid_580972 = validateParameter(valid_580972, JString, required = false,
                                 default = nil)
  if valid_580972 != nil:
    section.add "upload_protocol", valid_580972
  var valid_580973 = query.getOrDefault("fields")
  valid_580973 = validateParameter(valid_580973, JString, required = false,
                                 default = nil)
  if valid_580973 != nil:
    section.add "fields", valid_580973
  var valid_580974 = query.getOrDefault("pageToken")
  valid_580974 = validateParameter(valid_580974, JString, required = false,
                                 default = nil)
  if valid_580974 != nil:
    section.add "pageToken", valid_580974
  var valid_580975 = query.getOrDefault("quotaUser")
  valid_580975 = validateParameter(valid_580975, JString, required = false,
                                 default = nil)
  if valid_580975 != nil:
    section.add "quotaUser", valid_580975
  var valid_580976 = query.getOrDefault("alt")
  valid_580976 = validateParameter(valid_580976, JString, required = false,
                                 default = newJString("json"))
  if valid_580976 != nil:
    section.add "alt", valid_580976
  var valid_580977 = query.getOrDefault("oauth_token")
  valid_580977 = validateParameter(valid_580977, JString, required = false,
                                 default = nil)
  if valid_580977 != nil:
    section.add "oauth_token", valid_580977
  var valid_580978 = query.getOrDefault("callback")
  valid_580978 = validateParameter(valid_580978, JString, required = false,
                                 default = nil)
  if valid_580978 != nil:
    section.add "callback", valid_580978
  var valid_580979 = query.getOrDefault("access_token")
  valid_580979 = validateParameter(valid_580979, JString, required = false,
                                 default = nil)
  if valid_580979 != nil:
    section.add "access_token", valid_580979
  var valid_580980 = query.getOrDefault("uploadType")
  valid_580980 = validateParameter(valid_580980, JString, required = false,
                                 default = nil)
  if valid_580980 != nil:
    section.add "uploadType", valid_580980
  var valid_580981 = query.getOrDefault("key")
  valid_580981 = validateParameter(valid_580981, JString, required = false,
                                 default = nil)
  if valid_580981 != nil:
    section.add "key", valid_580981
  var valid_580982 = query.getOrDefault("states")
  valid_580982 = validateParameter(valid_580982, JArray, required = false,
                                 default = nil)
  if valid_580982 != nil:
    section.add "states", valid_580982
  var valid_580983 = query.getOrDefault("invitedEmailAddress")
  valid_580983 = validateParameter(valid_580983, JString, required = false,
                                 default = nil)
  if valid_580983 != nil:
    section.add "invitedEmailAddress", valid_580983
  var valid_580984 = query.getOrDefault("$.xgafv")
  valid_580984 = validateParameter(valid_580984, JString, required = false,
                                 default = newJString("1"))
  if valid_580984 != nil:
    section.add "$.xgafv", valid_580984
  var valid_580985 = query.getOrDefault("pageSize")
  valid_580985 = validateParameter(valid_580985, JInt, required = false, default = nil)
  if valid_580985 != nil:
    section.add "pageSize", valid_580985
  var valid_580986 = query.getOrDefault("prettyPrint")
  valid_580986 = validateParameter(valid_580986, JBool, required = false,
                                 default = newJBool(true))
  if valid_580986 != nil:
    section.add "prettyPrint", valid_580986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580987: Call_ClassroomUserProfilesGuardianInvitationsList_580968;
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
  let valid = call_580987.validator(path, query, header, formData, body)
  let scheme = call_580987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580987.url(scheme.get, call_580987.host, call_580987.base,
                         call_580987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580987, url, valid)

proc call*(call_580988: Call_ClassroomUserProfilesGuardianInvitationsList_580968;
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
  var path_580989 = newJObject()
  var query_580990 = newJObject()
  add(query_580990, "upload_protocol", newJString(uploadProtocol))
  add(query_580990, "fields", newJString(fields))
  add(query_580990, "pageToken", newJString(pageToken))
  add(query_580990, "quotaUser", newJString(quotaUser))
  add(query_580990, "alt", newJString(alt))
  add(query_580990, "oauth_token", newJString(oauthToken))
  add(query_580990, "callback", newJString(callback))
  add(query_580990, "access_token", newJString(accessToken))
  add(query_580990, "uploadType", newJString(uploadType))
  add(path_580989, "studentId", newJString(studentId))
  add(query_580990, "key", newJString(key))
  if states != nil:
    query_580990.add "states", states
  add(query_580990, "invitedEmailAddress", newJString(invitedEmailAddress))
  add(query_580990, "$.xgafv", newJString(Xgafv))
  add(query_580990, "pageSize", newJInt(pageSize))
  add(query_580990, "prettyPrint", newJBool(prettyPrint))
  result = call_580988.call(path_580989, query_580990, nil, nil, nil)

var classroomUserProfilesGuardianInvitationsList* = Call_ClassroomUserProfilesGuardianInvitationsList_580968(
    name: "classroomUserProfilesGuardianInvitationsList",
    meth: HttpMethod.HttpGet, host: "classroom.googleapis.com",
    route: "/v1/userProfiles/{studentId}/guardianInvitations",
    validator: validate_ClassroomUserProfilesGuardianInvitationsList_580969,
    base: "/", url: url_ClassroomUserProfilesGuardianInvitationsList_580970,
    schemes: {Scheme.Https})
type
  Call_ClassroomUserProfilesGuardianInvitationsGet_581012 = ref object of OpenApiRestCall_579421
proc url_ClassroomUserProfilesGuardianInvitationsGet_581014(protocol: Scheme;
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

proc validate_ClassroomUserProfilesGuardianInvitationsGet_581013(path: JsonNode;
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
  var valid_581015 = path.getOrDefault("studentId")
  valid_581015 = validateParameter(valid_581015, JString, required = true,
                                 default = nil)
  if valid_581015 != nil:
    section.add "studentId", valid_581015
  var valid_581016 = path.getOrDefault("invitationId")
  valid_581016 = validateParameter(valid_581016, JString, required = true,
                                 default = nil)
  if valid_581016 != nil:
    section.add "invitationId", valid_581016
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
  var valid_581017 = query.getOrDefault("upload_protocol")
  valid_581017 = validateParameter(valid_581017, JString, required = false,
                                 default = nil)
  if valid_581017 != nil:
    section.add "upload_protocol", valid_581017
  var valid_581018 = query.getOrDefault("fields")
  valid_581018 = validateParameter(valid_581018, JString, required = false,
                                 default = nil)
  if valid_581018 != nil:
    section.add "fields", valid_581018
  var valid_581019 = query.getOrDefault("quotaUser")
  valid_581019 = validateParameter(valid_581019, JString, required = false,
                                 default = nil)
  if valid_581019 != nil:
    section.add "quotaUser", valid_581019
  var valid_581020 = query.getOrDefault("alt")
  valid_581020 = validateParameter(valid_581020, JString, required = false,
                                 default = newJString("json"))
  if valid_581020 != nil:
    section.add "alt", valid_581020
  var valid_581021 = query.getOrDefault("oauth_token")
  valid_581021 = validateParameter(valid_581021, JString, required = false,
                                 default = nil)
  if valid_581021 != nil:
    section.add "oauth_token", valid_581021
  var valid_581022 = query.getOrDefault("callback")
  valid_581022 = validateParameter(valid_581022, JString, required = false,
                                 default = nil)
  if valid_581022 != nil:
    section.add "callback", valid_581022
  var valid_581023 = query.getOrDefault("access_token")
  valid_581023 = validateParameter(valid_581023, JString, required = false,
                                 default = nil)
  if valid_581023 != nil:
    section.add "access_token", valid_581023
  var valid_581024 = query.getOrDefault("uploadType")
  valid_581024 = validateParameter(valid_581024, JString, required = false,
                                 default = nil)
  if valid_581024 != nil:
    section.add "uploadType", valid_581024
  var valid_581025 = query.getOrDefault("key")
  valid_581025 = validateParameter(valid_581025, JString, required = false,
                                 default = nil)
  if valid_581025 != nil:
    section.add "key", valid_581025
  var valid_581026 = query.getOrDefault("$.xgafv")
  valid_581026 = validateParameter(valid_581026, JString, required = false,
                                 default = newJString("1"))
  if valid_581026 != nil:
    section.add "$.xgafv", valid_581026
  var valid_581027 = query.getOrDefault("prettyPrint")
  valid_581027 = validateParameter(valid_581027, JBool, required = false,
                                 default = newJBool(true))
  if valid_581027 != nil:
    section.add "prettyPrint", valid_581027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581028: Call_ClassroomUserProfilesGuardianInvitationsGet_581012;
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
  let valid = call_581028.validator(path, query, header, formData, body)
  let scheme = call_581028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581028.url(scheme.get, call_581028.host, call_581028.base,
                         call_581028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581028, url, valid)

proc call*(call_581029: Call_ClassroomUserProfilesGuardianInvitationsGet_581012;
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
  var path_581030 = newJObject()
  var query_581031 = newJObject()
  add(query_581031, "upload_protocol", newJString(uploadProtocol))
  add(query_581031, "fields", newJString(fields))
  add(query_581031, "quotaUser", newJString(quotaUser))
  add(query_581031, "alt", newJString(alt))
  add(query_581031, "oauth_token", newJString(oauthToken))
  add(query_581031, "callback", newJString(callback))
  add(query_581031, "access_token", newJString(accessToken))
  add(query_581031, "uploadType", newJString(uploadType))
  add(path_581030, "studentId", newJString(studentId))
  add(query_581031, "key", newJString(key))
  add(query_581031, "$.xgafv", newJString(Xgafv))
  add(query_581031, "prettyPrint", newJBool(prettyPrint))
  add(path_581030, "invitationId", newJString(invitationId))
  result = call_581029.call(path_581030, query_581031, nil, nil, nil)

var classroomUserProfilesGuardianInvitationsGet* = Call_ClassroomUserProfilesGuardianInvitationsGet_581012(
    name: "classroomUserProfilesGuardianInvitationsGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com",
    route: "/v1/userProfiles/{studentId}/guardianInvitations/{invitationId}",
    validator: validate_ClassroomUserProfilesGuardianInvitationsGet_581013,
    base: "/", url: url_ClassroomUserProfilesGuardianInvitationsGet_581014,
    schemes: {Scheme.Https})
type
  Call_ClassroomUserProfilesGuardianInvitationsPatch_581032 = ref object of OpenApiRestCall_579421
proc url_ClassroomUserProfilesGuardianInvitationsPatch_581034(protocol: Scheme;
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

proc validate_ClassroomUserProfilesGuardianInvitationsPatch_581033(
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
  var valid_581035 = path.getOrDefault("studentId")
  valid_581035 = validateParameter(valid_581035, JString, required = true,
                                 default = nil)
  if valid_581035 != nil:
    section.add "studentId", valid_581035
  var valid_581036 = path.getOrDefault("invitationId")
  valid_581036 = validateParameter(valid_581036, JString, required = true,
                                 default = nil)
  if valid_581036 != nil:
    section.add "invitationId", valid_581036
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
  var valid_581037 = query.getOrDefault("upload_protocol")
  valid_581037 = validateParameter(valid_581037, JString, required = false,
                                 default = nil)
  if valid_581037 != nil:
    section.add "upload_protocol", valid_581037
  var valid_581038 = query.getOrDefault("fields")
  valid_581038 = validateParameter(valid_581038, JString, required = false,
                                 default = nil)
  if valid_581038 != nil:
    section.add "fields", valid_581038
  var valid_581039 = query.getOrDefault("quotaUser")
  valid_581039 = validateParameter(valid_581039, JString, required = false,
                                 default = nil)
  if valid_581039 != nil:
    section.add "quotaUser", valid_581039
  var valid_581040 = query.getOrDefault("alt")
  valid_581040 = validateParameter(valid_581040, JString, required = false,
                                 default = newJString("json"))
  if valid_581040 != nil:
    section.add "alt", valid_581040
  var valid_581041 = query.getOrDefault("oauth_token")
  valid_581041 = validateParameter(valid_581041, JString, required = false,
                                 default = nil)
  if valid_581041 != nil:
    section.add "oauth_token", valid_581041
  var valid_581042 = query.getOrDefault("callback")
  valid_581042 = validateParameter(valid_581042, JString, required = false,
                                 default = nil)
  if valid_581042 != nil:
    section.add "callback", valid_581042
  var valid_581043 = query.getOrDefault("access_token")
  valid_581043 = validateParameter(valid_581043, JString, required = false,
                                 default = nil)
  if valid_581043 != nil:
    section.add "access_token", valid_581043
  var valid_581044 = query.getOrDefault("uploadType")
  valid_581044 = validateParameter(valid_581044, JString, required = false,
                                 default = nil)
  if valid_581044 != nil:
    section.add "uploadType", valid_581044
  var valid_581045 = query.getOrDefault("key")
  valid_581045 = validateParameter(valid_581045, JString, required = false,
                                 default = nil)
  if valid_581045 != nil:
    section.add "key", valid_581045
  var valid_581046 = query.getOrDefault("$.xgafv")
  valid_581046 = validateParameter(valid_581046, JString, required = false,
                                 default = newJString("1"))
  if valid_581046 != nil:
    section.add "$.xgafv", valid_581046
  var valid_581047 = query.getOrDefault("prettyPrint")
  valid_581047 = validateParameter(valid_581047, JBool, required = false,
                                 default = newJBool(true))
  if valid_581047 != nil:
    section.add "prettyPrint", valid_581047
  var valid_581048 = query.getOrDefault("updateMask")
  valid_581048 = validateParameter(valid_581048, JString, required = false,
                                 default = nil)
  if valid_581048 != nil:
    section.add "updateMask", valid_581048
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

proc call*(call_581050: Call_ClassroomUserProfilesGuardianInvitationsPatch_581032;
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
  let valid = call_581050.validator(path, query, header, formData, body)
  let scheme = call_581050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581050.url(scheme.get, call_581050.host, call_581050.base,
                         call_581050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581050, url, valid)

proc call*(call_581051: Call_ClassroomUserProfilesGuardianInvitationsPatch_581032;
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
  var path_581052 = newJObject()
  var query_581053 = newJObject()
  var body_581054 = newJObject()
  add(query_581053, "upload_protocol", newJString(uploadProtocol))
  add(query_581053, "fields", newJString(fields))
  add(query_581053, "quotaUser", newJString(quotaUser))
  add(query_581053, "alt", newJString(alt))
  add(query_581053, "oauth_token", newJString(oauthToken))
  add(query_581053, "callback", newJString(callback))
  add(query_581053, "access_token", newJString(accessToken))
  add(query_581053, "uploadType", newJString(uploadType))
  add(path_581052, "studentId", newJString(studentId))
  add(query_581053, "key", newJString(key))
  add(query_581053, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_581054 = body
  add(query_581053, "prettyPrint", newJBool(prettyPrint))
  add(path_581052, "invitationId", newJString(invitationId))
  add(query_581053, "updateMask", newJString(updateMask))
  result = call_581051.call(path_581052, query_581053, nil, nil, body_581054)

var classroomUserProfilesGuardianInvitationsPatch* = Call_ClassroomUserProfilesGuardianInvitationsPatch_581032(
    name: "classroomUserProfilesGuardianInvitationsPatch",
    meth: HttpMethod.HttpPatch, host: "classroom.googleapis.com",
    route: "/v1/userProfiles/{studentId}/guardianInvitations/{invitationId}",
    validator: validate_ClassroomUserProfilesGuardianInvitationsPatch_581033,
    base: "/", url: url_ClassroomUserProfilesGuardianInvitationsPatch_581034,
    schemes: {Scheme.Https})
type
  Call_ClassroomUserProfilesGuardiansList_581055 = ref object of OpenApiRestCall_579421
proc url_ClassroomUserProfilesGuardiansList_581057(protocol: Scheme; host: string;
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

proc validate_ClassroomUserProfilesGuardiansList_581056(path: JsonNode;
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
  var valid_581058 = path.getOrDefault("studentId")
  valid_581058 = validateParameter(valid_581058, JString, required = true,
                                 default = nil)
  if valid_581058 != nil:
    section.add "studentId", valid_581058
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
  var valid_581059 = query.getOrDefault("upload_protocol")
  valid_581059 = validateParameter(valid_581059, JString, required = false,
                                 default = nil)
  if valid_581059 != nil:
    section.add "upload_protocol", valid_581059
  var valid_581060 = query.getOrDefault("fields")
  valid_581060 = validateParameter(valid_581060, JString, required = false,
                                 default = nil)
  if valid_581060 != nil:
    section.add "fields", valid_581060
  var valid_581061 = query.getOrDefault("pageToken")
  valid_581061 = validateParameter(valid_581061, JString, required = false,
                                 default = nil)
  if valid_581061 != nil:
    section.add "pageToken", valid_581061
  var valid_581062 = query.getOrDefault("quotaUser")
  valid_581062 = validateParameter(valid_581062, JString, required = false,
                                 default = nil)
  if valid_581062 != nil:
    section.add "quotaUser", valid_581062
  var valid_581063 = query.getOrDefault("alt")
  valid_581063 = validateParameter(valid_581063, JString, required = false,
                                 default = newJString("json"))
  if valid_581063 != nil:
    section.add "alt", valid_581063
  var valid_581064 = query.getOrDefault("oauth_token")
  valid_581064 = validateParameter(valid_581064, JString, required = false,
                                 default = nil)
  if valid_581064 != nil:
    section.add "oauth_token", valid_581064
  var valid_581065 = query.getOrDefault("callback")
  valid_581065 = validateParameter(valid_581065, JString, required = false,
                                 default = nil)
  if valid_581065 != nil:
    section.add "callback", valid_581065
  var valid_581066 = query.getOrDefault("access_token")
  valid_581066 = validateParameter(valid_581066, JString, required = false,
                                 default = nil)
  if valid_581066 != nil:
    section.add "access_token", valid_581066
  var valid_581067 = query.getOrDefault("uploadType")
  valid_581067 = validateParameter(valid_581067, JString, required = false,
                                 default = nil)
  if valid_581067 != nil:
    section.add "uploadType", valid_581067
  var valid_581068 = query.getOrDefault("key")
  valid_581068 = validateParameter(valid_581068, JString, required = false,
                                 default = nil)
  if valid_581068 != nil:
    section.add "key", valid_581068
  var valid_581069 = query.getOrDefault("invitedEmailAddress")
  valid_581069 = validateParameter(valid_581069, JString, required = false,
                                 default = nil)
  if valid_581069 != nil:
    section.add "invitedEmailAddress", valid_581069
  var valid_581070 = query.getOrDefault("$.xgafv")
  valid_581070 = validateParameter(valid_581070, JString, required = false,
                                 default = newJString("1"))
  if valid_581070 != nil:
    section.add "$.xgafv", valid_581070
  var valid_581071 = query.getOrDefault("pageSize")
  valid_581071 = validateParameter(valid_581071, JInt, required = false, default = nil)
  if valid_581071 != nil:
    section.add "pageSize", valid_581071
  var valid_581072 = query.getOrDefault("prettyPrint")
  valid_581072 = validateParameter(valid_581072, JBool, required = false,
                                 default = newJBool(true))
  if valid_581072 != nil:
    section.add "prettyPrint", valid_581072
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581073: Call_ClassroomUserProfilesGuardiansList_581055;
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
  let valid = call_581073.validator(path, query, header, formData, body)
  let scheme = call_581073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581073.url(scheme.get, call_581073.host, call_581073.base,
                         call_581073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581073, url, valid)

proc call*(call_581074: Call_ClassroomUserProfilesGuardiansList_581055;
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
  var path_581075 = newJObject()
  var query_581076 = newJObject()
  add(query_581076, "upload_protocol", newJString(uploadProtocol))
  add(query_581076, "fields", newJString(fields))
  add(query_581076, "pageToken", newJString(pageToken))
  add(query_581076, "quotaUser", newJString(quotaUser))
  add(query_581076, "alt", newJString(alt))
  add(query_581076, "oauth_token", newJString(oauthToken))
  add(query_581076, "callback", newJString(callback))
  add(query_581076, "access_token", newJString(accessToken))
  add(query_581076, "uploadType", newJString(uploadType))
  add(path_581075, "studentId", newJString(studentId))
  add(query_581076, "key", newJString(key))
  add(query_581076, "invitedEmailAddress", newJString(invitedEmailAddress))
  add(query_581076, "$.xgafv", newJString(Xgafv))
  add(query_581076, "pageSize", newJInt(pageSize))
  add(query_581076, "prettyPrint", newJBool(prettyPrint))
  result = call_581074.call(path_581075, query_581076, nil, nil, nil)

var classroomUserProfilesGuardiansList* = Call_ClassroomUserProfilesGuardiansList_581055(
    name: "classroomUserProfilesGuardiansList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com",
    route: "/v1/userProfiles/{studentId}/guardians",
    validator: validate_ClassroomUserProfilesGuardiansList_581056, base: "/",
    url: url_ClassroomUserProfilesGuardiansList_581057, schemes: {Scheme.Https})
type
  Call_ClassroomUserProfilesGuardiansGet_581077 = ref object of OpenApiRestCall_579421
proc url_ClassroomUserProfilesGuardiansGet_581079(protocol: Scheme; host: string;
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

proc validate_ClassroomUserProfilesGuardiansGet_581078(path: JsonNode;
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
  var valid_581080 = path.getOrDefault("guardianId")
  valid_581080 = validateParameter(valid_581080, JString, required = true,
                                 default = nil)
  if valid_581080 != nil:
    section.add "guardianId", valid_581080
  var valid_581081 = path.getOrDefault("studentId")
  valid_581081 = validateParameter(valid_581081, JString, required = true,
                                 default = nil)
  if valid_581081 != nil:
    section.add "studentId", valid_581081
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
  var valid_581082 = query.getOrDefault("upload_protocol")
  valid_581082 = validateParameter(valid_581082, JString, required = false,
                                 default = nil)
  if valid_581082 != nil:
    section.add "upload_protocol", valid_581082
  var valid_581083 = query.getOrDefault("fields")
  valid_581083 = validateParameter(valid_581083, JString, required = false,
                                 default = nil)
  if valid_581083 != nil:
    section.add "fields", valid_581083
  var valid_581084 = query.getOrDefault("quotaUser")
  valid_581084 = validateParameter(valid_581084, JString, required = false,
                                 default = nil)
  if valid_581084 != nil:
    section.add "quotaUser", valid_581084
  var valid_581085 = query.getOrDefault("alt")
  valid_581085 = validateParameter(valid_581085, JString, required = false,
                                 default = newJString("json"))
  if valid_581085 != nil:
    section.add "alt", valid_581085
  var valid_581086 = query.getOrDefault("oauth_token")
  valid_581086 = validateParameter(valid_581086, JString, required = false,
                                 default = nil)
  if valid_581086 != nil:
    section.add "oauth_token", valid_581086
  var valid_581087 = query.getOrDefault("callback")
  valid_581087 = validateParameter(valid_581087, JString, required = false,
                                 default = nil)
  if valid_581087 != nil:
    section.add "callback", valid_581087
  var valid_581088 = query.getOrDefault("access_token")
  valid_581088 = validateParameter(valid_581088, JString, required = false,
                                 default = nil)
  if valid_581088 != nil:
    section.add "access_token", valid_581088
  var valid_581089 = query.getOrDefault("uploadType")
  valid_581089 = validateParameter(valid_581089, JString, required = false,
                                 default = nil)
  if valid_581089 != nil:
    section.add "uploadType", valid_581089
  var valid_581090 = query.getOrDefault("key")
  valid_581090 = validateParameter(valid_581090, JString, required = false,
                                 default = nil)
  if valid_581090 != nil:
    section.add "key", valid_581090
  var valid_581091 = query.getOrDefault("$.xgafv")
  valid_581091 = validateParameter(valid_581091, JString, required = false,
                                 default = newJString("1"))
  if valid_581091 != nil:
    section.add "$.xgafv", valid_581091
  var valid_581092 = query.getOrDefault("prettyPrint")
  valid_581092 = validateParameter(valid_581092, JBool, required = false,
                                 default = newJBool(true))
  if valid_581092 != nil:
    section.add "prettyPrint", valid_581092
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581093: Call_ClassroomUserProfilesGuardiansGet_581077;
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
  let valid = call_581093.validator(path, query, header, formData, body)
  let scheme = call_581093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581093.url(scheme.get, call_581093.host, call_581093.base,
                         call_581093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581093, url, valid)

proc call*(call_581094: Call_ClassroomUserProfilesGuardiansGet_581077;
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
  var path_581095 = newJObject()
  var query_581096 = newJObject()
  add(path_581095, "guardianId", newJString(guardianId))
  add(query_581096, "upload_protocol", newJString(uploadProtocol))
  add(query_581096, "fields", newJString(fields))
  add(query_581096, "quotaUser", newJString(quotaUser))
  add(query_581096, "alt", newJString(alt))
  add(query_581096, "oauth_token", newJString(oauthToken))
  add(query_581096, "callback", newJString(callback))
  add(query_581096, "access_token", newJString(accessToken))
  add(query_581096, "uploadType", newJString(uploadType))
  add(path_581095, "studentId", newJString(studentId))
  add(query_581096, "key", newJString(key))
  add(query_581096, "$.xgafv", newJString(Xgafv))
  add(query_581096, "prettyPrint", newJBool(prettyPrint))
  result = call_581094.call(path_581095, query_581096, nil, nil, nil)

var classroomUserProfilesGuardiansGet* = Call_ClassroomUserProfilesGuardiansGet_581077(
    name: "classroomUserProfilesGuardiansGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com",
    route: "/v1/userProfiles/{studentId}/guardians/{guardianId}",
    validator: validate_ClassroomUserProfilesGuardiansGet_581078, base: "/",
    url: url_ClassroomUserProfilesGuardiansGet_581079, schemes: {Scheme.Https})
type
  Call_ClassroomUserProfilesGuardiansDelete_581097 = ref object of OpenApiRestCall_579421
proc url_ClassroomUserProfilesGuardiansDelete_581099(protocol: Scheme;
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

proc validate_ClassroomUserProfilesGuardiansDelete_581098(path: JsonNode;
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
  var valid_581100 = path.getOrDefault("guardianId")
  valid_581100 = validateParameter(valid_581100, JString, required = true,
                                 default = nil)
  if valid_581100 != nil:
    section.add "guardianId", valid_581100
  var valid_581101 = path.getOrDefault("studentId")
  valid_581101 = validateParameter(valid_581101, JString, required = true,
                                 default = nil)
  if valid_581101 != nil:
    section.add "studentId", valid_581101
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
  var valid_581102 = query.getOrDefault("upload_protocol")
  valid_581102 = validateParameter(valid_581102, JString, required = false,
                                 default = nil)
  if valid_581102 != nil:
    section.add "upload_protocol", valid_581102
  var valid_581103 = query.getOrDefault("fields")
  valid_581103 = validateParameter(valid_581103, JString, required = false,
                                 default = nil)
  if valid_581103 != nil:
    section.add "fields", valid_581103
  var valid_581104 = query.getOrDefault("quotaUser")
  valid_581104 = validateParameter(valid_581104, JString, required = false,
                                 default = nil)
  if valid_581104 != nil:
    section.add "quotaUser", valid_581104
  var valid_581105 = query.getOrDefault("alt")
  valid_581105 = validateParameter(valid_581105, JString, required = false,
                                 default = newJString("json"))
  if valid_581105 != nil:
    section.add "alt", valid_581105
  var valid_581106 = query.getOrDefault("oauth_token")
  valid_581106 = validateParameter(valid_581106, JString, required = false,
                                 default = nil)
  if valid_581106 != nil:
    section.add "oauth_token", valid_581106
  var valid_581107 = query.getOrDefault("callback")
  valid_581107 = validateParameter(valid_581107, JString, required = false,
                                 default = nil)
  if valid_581107 != nil:
    section.add "callback", valid_581107
  var valid_581108 = query.getOrDefault("access_token")
  valid_581108 = validateParameter(valid_581108, JString, required = false,
                                 default = nil)
  if valid_581108 != nil:
    section.add "access_token", valid_581108
  var valid_581109 = query.getOrDefault("uploadType")
  valid_581109 = validateParameter(valid_581109, JString, required = false,
                                 default = nil)
  if valid_581109 != nil:
    section.add "uploadType", valid_581109
  var valid_581110 = query.getOrDefault("key")
  valid_581110 = validateParameter(valid_581110, JString, required = false,
                                 default = nil)
  if valid_581110 != nil:
    section.add "key", valid_581110
  var valid_581111 = query.getOrDefault("$.xgafv")
  valid_581111 = validateParameter(valid_581111, JString, required = false,
                                 default = newJString("1"))
  if valid_581111 != nil:
    section.add "$.xgafv", valid_581111
  var valid_581112 = query.getOrDefault("prettyPrint")
  valid_581112 = validateParameter(valid_581112, JBool, required = false,
                                 default = newJBool(true))
  if valid_581112 != nil:
    section.add "prettyPrint", valid_581112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581113: Call_ClassroomUserProfilesGuardiansDelete_581097;
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
  let valid = call_581113.validator(path, query, header, formData, body)
  let scheme = call_581113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581113.url(scheme.get, call_581113.host, call_581113.base,
                         call_581113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581113, url, valid)

proc call*(call_581114: Call_ClassroomUserProfilesGuardiansDelete_581097;
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
  var path_581115 = newJObject()
  var query_581116 = newJObject()
  add(path_581115, "guardianId", newJString(guardianId))
  add(query_581116, "upload_protocol", newJString(uploadProtocol))
  add(query_581116, "fields", newJString(fields))
  add(query_581116, "quotaUser", newJString(quotaUser))
  add(query_581116, "alt", newJString(alt))
  add(query_581116, "oauth_token", newJString(oauthToken))
  add(query_581116, "callback", newJString(callback))
  add(query_581116, "access_token", newJString(accessToken))
  add(query_581116, "uploadType", newJString(uploadType))
  add(path_581115, "studentId", newJString(studentId))
  add(query_581116, "key", newJString(key))
  add(query_581116, "$.xgafv", newJString(Xgafv))
  add(query_581116, "prettyPrint", newJBool(prettyPrint))
  result = call_581114.call(path_581115, query_581116, nil, nil, nil)

var classroomUserProfilesGuardiansDelete* = Call_ClassroomUserProfilesGuardiansDelete_581097(
    name: "classroomUserProfilesGuardiansDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com",
    route: "/v1/userProfiles/{studentId}/guardians/{guardianId}",
    validator: validate_ClassroomUserProfilesGuardiansDelete_581098, base: "/",
    url: url_ClassroomUserProfilesGuardiansDelete_581099, schemes: {Scheme.Https})
type
  Call_ClassroomUserProfilesGet_581117 = ref object of OpenApiRestCall_579421
proc url_ClassroomUserProfilesGet_581119(protocol: Scheme; host: string;
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

proc validate_ClassroomUserProfilesGet_581118(path: JsonNode; query: JsonNode;
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
  var valid_581120 = path.getOrDefault("userId")
  valid_581120 = validateParameter(valid_581120, JString, required = true,
                                 default = nil)
  if valid_581120 != nil:
    section.add "userId", valid_581120
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
  var valid_581121 = query.getOrDefault("upload_protocol")
  valid_581121 = validateParameter(valid_581121, JString, required = false,
                                 default = nil)
  if valid_581121 != nil:
    section.add "upload_protocol", valid_581121
  var valid_581122 = query.getOrDefault("fields")
  valid_581122 = validateParameter(valid_581122, JString, required = false,
                                 default = nil)
  if valid_581122 != nil:
    section.add "fields", valid_581122
  var valid_581123 = query.getOrDefault("quotaUser")
  valid_581123 = validateParameter(valid_581123, JString, required = false,
                                 default = nil)
  if valid_581123 != nil:
    section.add "quotaUser", valid_581123
  var valid_581124 = query.getOrDefault("alt")
  valid_581124 = validateParameter(valid_581124, JString, required = false,
                                 default = newJString("json"))
  if valid_581124 != nil:
    section.add "alt", valid_581124
  var valid_581125 = query.getOrDefault("oauth_token")
  valid_581125 = validateParameter(valid_581125, JString, required = false,
                                 default = nil)
  if valid_581125 != nil:
    section.add "oauth_token", valid_581125
  var valid_581126 = query.getOrDefault("callback")
  valid_581126 = validateParameter(valid_581126, JString, required = false,
                                 default = nil)
  if valid_581126 != nil:
    section.add "callback", valid_581126
  var valid_581127 = query.getOrDefault("access_token")
  valid_581127 = validateParameter(valid_581127, JString, required = false,
                                 default = nil)
  if valid_581127 != nil:
    section.add "access_token", valid_581127
  var valid_581128 = query.getOrDefault("uploadType")
  valid_581128 = validateParameter(valid_581128, JString, required = false,
                                 default = nil)
  if valid_581128 != nil:
    section.add "uploadType", valid_581128
  var valid_581129 = query.getOrDefault("key")
  valid_581129 = validateParameter(valid_581129, JString, required = false,
                                 default = nil)
  if valid_581129 != nil:
    section.add "key", valid_581129
  var valid_581130 = query.getOrDefault("$.xgafv")
  valid_581130 = validateParameter(valid_581130, JString, required = false,
                                 default = newJString("1"))
  if valid_581130 != nil:
    section.add "$.xgafv", valid_581130
  var valid_581131 = query.getOrDefault("prettyPrint")
  valid_581131 = validateParameter(valid_581131, JBool, required = false,
                                 default = newJBool(true))
  if valid_581131 != nil:
    section.add "prettyPrint", valid_581131
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581132: Call_ClassroomUserProfilesGet_581117; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a user profile.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access
  ## this user profile, if no profile exists with the requested ID, or for
  ## access errors.
  ## 
  let valid = call_581132.validator(path, query, header, formData, body)
  let scheme = call_581132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581132.url(scheme.get, call_581132.host, call_581132.base,
                         call_581132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581132, url, valid)

proc call*(call_581133: Call_ClassroomUserProfilesGet_581117; userId: string;
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
  var path_581134 = newJObject()
  var query_581135 = newJObject()
  add(query_581135, "upload_protocol", newJString(uploadProtocol))
  add(query_581135, "fields", newJString(fields))
  add(query_581135, "quotaUser", newJString(quotaUser))
  add(query_581135, "alt", newJString(alt))
  add(query_581135, "oauth_token", newJString(oauthToken))
  add(query_581135, "callback", newJString(callback))
  add(query_581135, "access_token", newJString(accessToken))
  add(query_581135, "uploadType", newJString(uploadType))
  add(query_581135, "key", newJString(key))
  add(query_581135, "$.xgafv", newJString(Xgafv))
  add(query_581135, "prettyPrint", newJBool(prettyPrint))
  add(path_581134, "userId", newJString(userId))
  result = call_581133.call(path_581134, query_581135, nil, nil, nil)

var classroomUserProfilesGet* = Call_ClassroomUserProfilesGet_581117(
    name: "classroomUserProfilesGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/userProfiles/{userId}",
    validator: validate_ClassroomUserProfilesGet_581118, base: "/",
    url: url_ClassroomUserProfilesGet_581119, schemes: {Scheme.Https})
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
