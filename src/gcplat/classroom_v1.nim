
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_597421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597421): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ClassroomCoursesCreate_597967 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesCreate_597969(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClassroomCoursesCreate_597968(path: JsonNode; query: JsonNode;
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
  var valid_597970 = query.getOrDefault("upload_protocol")
  valid_597970 = validateParameter(valid_597970, JString, required = false,
                                 default = nil)
  if valid_597970 != nil:
    section.add "upload_protocol", valid_597970
  var valid_597971 = query.getOrDefault("fields")
  valid_597971 = validateParameter(valid_597971, JString, required = false,
                                 default = nil)
  if valid_597971 != nil:
    section.add "fields", valid_597971
  var valid_597972 = query.getOrDefault("quotaUser")
  valid_597972 = validateParameter(valid_597972, JString, required = false,
                                 default = nil)
  if valid_597972 != nil:
    section.add "quotaUser", valid_597972
  var valid_597973 = query.getOrDefault("alt")
  valid_597973 = validateParameter(valid_597973, JString, required = false,
                                 default = newJString("json"))
  if valid_597973 != nil:
    section.add "alt", valid_597973
  var valid_597974 = query.getOrDefault("oauth_token")
  valid_597974 = validateParameter(valid_597974, JString, required = false,
                                 default = nil)
  if valid_597974 != nil:
    section.add "oauth_token", valid_597974
  var valid_597975 = query.getOrDefault("callback")
  valid_597975 = validateParameter(valid_597975, JString, required = false,
                                 default = nil)
  if valid_597975 != nil:
    section.add "callback", valid_597975
  var valid_597976 = query.getOrDefault("access_token")
  valid_597976 = validateParameter(valid_597976, JString, required = false,
                                 default = nil)
  if valid_597976 != nil:
    section.add "access_token", valid_597976
  var valid_597977 = query.getOrDefault("uploadType")
  valid_597977 = validateParameter(valid_597977, JString, required = false,
                                 default = nil)
  if valid_597977 != nil:
    section.add "uploadType", valid_597977
  var valid_597978 = query.getOrDefault("key")
  valid_597978 = validateParameter(valid_597978, JString, required = false,
                                 default = nil)
  if valid_597978 != nil:
    section.add "key", valid_597978
  var valid_597979 = query.getOrDefault("$.xgafv")
  valid_597979 = validateParameter(valid_597979, JString, required = false,
                                 default = newJString("1"))
  if valid_597979 != nil:
    section.add "$.xgafv", valid_597979
  var valid_597980 = query.getOrDefault("prettyPrint")
  valid_597980 = validateParameter(valid_597980, JBool, required = false,
                                 default = newJBool(true))
  if valid_597980 != nil:
    section.add "prettyPrint", valid_597980
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

proc call*(call_597982: Call_ClassroomCoursesCreate_597967; path: JsonNode;
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
  let valid = call_597982.validator(path, query, header, formData, body)
  let scheme = call_597982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597982.url(scheme.get, call_597982.host, call_597982.base,
                         call_597982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597982, url, valid)

proc call*(call_597983: Call_ClassroomCoursesCreate_597967;
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
  var query_597984 = newJObject()
  var body_597985 = newJObject()
  add(query_597984, "upload_protocol", newJString(uploadProtocol))
  add(query_597984, "fields", newJString(fields))
  add(query_597984, "quotaUser", newJString(quotaUser))
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
  result = call_597983.call(nil, query_597984, nil, nil, body_597985)

var classroomCoursesCreate* = Call_ClassroomCoursesCreate_597967(
    name: "classroomCoursesCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/courses",
    validator: validate_ClassroomCoursesCreate_597968, base: "/",
    url: url_ClassroomCoursesCreate_597969, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesList_597690 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesList_597692(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClassroomCoursesList_597691(path: JsonNode; query: JsonNode;
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
  var valid_597804 = query.getOrDefault("upload_protocol")
  valid_597804 = validateParameter(valid_597804, JString, required = false,
                                 default = nil)
  if valid_597804 != nil:
    section.add "upload_protocol", valid_597804
  var valid_597805 = query.getOrDefault("fields")
  valid_597805 = validateParameter(valid_597805, JString, required = false,
                                 default = nil)
  if valid_597805 != nil:
    section.add "fields", valid_597805
  var valid_597806 = query.getOrDefault("pageToken")
  valid_597806 = validateParameter(valid_597806, JString, required = false,
                                 default = nil)
  if valid_597806 != nil:
    section.add "pageToken", valid_597806
  var valid_597807 = query.getOrDefault("quotaUser")
  valid_597807 = validateParameter(valid_597807, JString, required = false,
                                 default = nil)
  if valid_597807 != nil:
    section.add "quotaUser", valid_597807
  var valid_597808 = query.getOrDefault("studentId")
  valid_597808 = validateParameter(valid_597808, JString, required = false,
                                 default = nil)
  if valid_597808 != nil:
    section.add "studentId", valid_597808
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
  var valid_597827 = query.getOrDefault("teacherId")
  valid_597827 = validateParameter(valid_597827, JString, required = false,
                                 default = nil)
  if valid_597827 != nil:
    section.add "teacherId", valid_597827
  var valid_597828 = query.getOrDefault("key")
  valid_597828 = validateParameter(valid_597828, JString, required = false,
                                 default = nil)
  if valid_597828 != nil:
    section.add "key", valid_597828
  var valid_597829 = query.getOrDefault("$.xgafv")
  valid_597829 = validateParameter(valid_597829, JString, required = false,
                                 default = newJString("1"))
  if valid_597829 != nil:
    section.add "$.xgafv", valid_597829
  var valid_597830 = query.getOrDefault("pageSize")
  valid_597830 = validateParameter(valid_597830, JInt, required = false, default = nil)
  if valid_597830 != nil:
    section.add "pageSize", valid_597830
  var valid_597831 = query.getOrDefault("prettyPrint")
  valid_597831 = validateParameter(valid_597831, JBool, required = false,
                                 default = newJBool(true))
  if valid_597831 != nil:
    section.add "prettyPrint", valid_597831
  var valid_597832 = query.getOrDefault("courseStates")
  valid_597832 = validateParameter(valid_597832, JArray, required = false,
                                 default = nil)
  if valid_597832 != nil:
    section.add "courseStates", valid_597832
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597855: Call_ClassroomCoursesList_597690; path: JsonNode;
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
  let valid = call_597855.validator(path, query, header, formData, body)
  let scheme = call_597855.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597855.url(scheme.get, call_597855.host, call_597855.base,
                         call_597855.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597855, url, valid)

proc call*(call_597926: Call_ClassroomCoursesList_597690;
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
  var query_597927 = newJObject()
  add(query_597927, "upload_protocol", newJString(uploadProtocol))
  add(query_597927, "fields", newJString(fields))
  add(query_597927, "pageToken", newJString(pageToken))
  add(query_597927, "quotaUser", newJString(quotaUser))
  add(query_597927, "studentId", newJString(studentId))
  add(query_597927, "alt", newJString(alt))
  add(query_597927, "oauth_token", newJString(oauthToken))
  add(query_597927, "callback", newJString(callback))
  add(query_597927, "access_token", newJString(accessToken))
  add(query_597927, "uploadType", newJString(uploadType))
  add(query_597927, "teacherId", newJString(teacherId))
  add(query_597927, "key", newJString(key))
  add(query_597927, "$.xgafv", newJString(Xgafv))
  add(query_597927, "pageSize", newJInt(pageSize))
  add(query_597927, "prettyPrint", newJBool(prettyPrint))
  if courseStates != nil:
    query_597927.add "courseStates", courseStates
  result = call_597926.call(nil, query_597927, nil, nil, nil)

var classroomCoursesList* = Call_ClassroomCoursesList_597690(
    name: "classroomCoursesList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/courses",
    validator: validate_ClassroomCoursesList_597691, base: "/",
    url: url_ClassroomCoursesList_597692, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAliasesCreate_598021 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesAliasesCreate_598023(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomCoursesAliasesCreate_598022(path: JsonNode; query: JsonNode;
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
  var valid_598024 = path.getOrDefault("courseId")
  valid_598024 = validateParameter(valid_598024, JString, required = true,
                                 default = nil)
  if valid_598024 != nil:
    section.add "courseId", valid_598024
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
  var valid_598025 = query.getOrDefault("upload_protocol")
  valid_598025 = validateParameter(valid_598025, JString, required = false,
                                 default = nil)
  if valid_598025 != nil:
    section.add "upload_protocol", valid_598025
  var valid_598026 = query.getOrDefault("fields")
  valid_598026 = validateParameter(valid_598026, JString, required = false,
                                 default = nil)
  if valid_598026 != nil:
    section.add "fields", valid_598026
  var valid_598027 = query.getOrDefault("quotaUser")
  valid_598027 = validateParameter(valid_598027, JString, required = false,
                                 default = nil)
  if valid_598027 != nil:
    section.add "quotaUser", valid_598027
  var valid_598028 = query.getOrDefault("alt")
  valid_598028 = validateParameter(valid_598028, JString, required = false,
                                 default = newJString("json"))
  if valid_598028 != nil:
    section.add "alt", valid_598028
  var valid_598029 = query.getOrDefault("oauth_token")
  valid_598029 = validateParameter(valid_598029, JString, required = false,
                                 default = nil)
  if valid_598029 != nil:
    section.add "oauth_token", valid_598029
  var valid_598030 = query.getOrDefault("callback")
  valid_598030 = validateParameter(valid_598030, JString, required = false,
                                 default = nil)
  if valid_598030 != nil:
    section.add "callback", valid_598030
  var valid_598031 = query.getOrDefault("access_token")
  valid_598031 = validateParameter(valid_598031, JString, required = false,
                                 default = nil)
  if valid_598031 != nil:
    section.add "access_token", valid_598031
  var valid_598032 = query.getOrDefault("uploadType")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = nil)
  if valid_598032 != nil:
    section.add "uploadType", valid_598032
  var valid_598033 = query.getOrDefault("key")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = nil)
  if valid_598033 != nil:
    section.add "key", valid_598033
  var valid_598034 = query.getOrDefault("$.xgafv")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = newJString("1"))
  if valid_598034 != nil:
    section.add "$.xgafv", valid_598034
  var valid_598035 = query.getOrDefault("prettyPrint")
  valid_598035 = validateParameter(valid_598035, JBool, required = false,
                                 default = newJBool(true))
  if valid_598035 != nil:
    section.add "prettyPrint", valid_598035
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

proc call*(call_598037: Call_ClassroomCoursesAliasesCreate_598021; path: JsonNode;
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
  let valid = call_598037.validator(path, query, header, formData, body)
  let scheme = call_598037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598037.url(scheme.get, call_598037.host, call_598037.base,
                         call_598037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598037, url, valid)

proc call*(call_598038: Call_ClassroomCoursesAliasesCreate_598021;
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
  var path_598039 = newJObject()
  var query_598040 = newJObject()
  var body_598041 = newJObject()
  add(query_598040, "upload_protocol", newJString(uploadProtocol))
  add(query_598040, "fields", newJString(fields))
  add(query_598040, "quotaUser", newJString(quotaUser))
  add(query_598040, "alt", newJString(alt))
  add(query_598040, "oauth_token", newJString(oauthToken))
  add(query_598040, "callback", newJString(callback))
  add(query_598040, "access_token", newJString(accessToken))
  add(query_598040, "uploadType", newJString(uploadType))
  add(query_598040, "key", newJString(key))
  add(path_598039, "courseId", newJString(courseId))
  add(query_598040, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598041 = body
  add(query_598040, "prettyPrint", newJBool(prettyPrint))
  result = call_598038.call(path_598039, query_598040, nil, nil, body_598041)

var classroomCoursesAliasesCreate* = Call_ClassroomCoursesAliasesCreate_598021(
    name: "classroomCoursesAliasesCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/aliases",
    validator: validate_ClassroomCoursesAliasesCreate_598022, base: "/",
    url: url_ClassroomCoursesAliasesCreate_598023, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAliasesList_597986 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesAliasesList_597988(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomCoursesAliasesList_597987(path: JsonNode; query: JsonNode;
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
  var valid_598003 = path.getOrDefault("courseId")
  valid_598003 = validateParameter(valid_598003, JString, required = true,
                                 default = nil)
  if valid_598003 != nil:
    section.add "courseId", valid_598003
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
  var valid_598004 = query.getOrDefault("upload_protocol")
  valid_598004 = validateParameter(valid_598004, JString, required = false,
                                 default = nil)
  if valid_598004 != nil:
    section.add "upload_protocol", valid_598004
  var valid_598005 = query.getOrDefault("fields")
  valid_598005 = validateParameter(valid_598005, JString, required = false,
                                 default = nil)
  if valid_598005 != nil:
    section.add "fields", valid_598005
  var valid_598006 = query.getOrDefault("pageToken")
  valid_598006 = validateParameter(valid_598006, JString, required = false,
                                 default = nil)
  if valid_598006 != nil:
    section.add "pageToken", valid_598006
  var valid_598007 = query.getOrDefault("quotaUser")
  valid_598007 = validateParameter(valid_598007, JString, required = false,
                                 default = nil)
  if valid_598007 != nil:
    section.add "quotaUser", valid_598007
  var valid_598008 = query.getOrDefault("alt")
  valid_598008 = validateParameter(valid_598008, JString, required = false,
                                 default = newJString("json"))
  if valid_598008 != nil:
    section.add "alt", valid_598008
  var valid_598009 = query.getOrDefault("oauth_token")
  valid_598009 = validateParameter(valid_598009, JString, required = false,
                                 default = nil)
  if valid_598009 != nil:
    section.add "oauth_token", valid_598009
  var valid_598010 = query.getOrDefault("callback")
  valid_598010 = validateParameter(valid_598010, JString, required = false,
                                 default = nil)
  if valid_598010 != nil:
    section.add "callback", valid_598010
  var valid_598011 = query.getOrDefault("access_token")
  valid_598011 = validateParameter(valid_598011, JString, required = false,
                                 default = nil)
  if valid_598011 != nil:
    section.add "access_token", valid_598011
  var valid_598012 = query.getOrDefault("uploadType")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = nil)
  if valid_598012 != nil:
    section.add "uploadType", valid_598012
  var valid_598013 = query.getOrDefault("key")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = nil)
  if valid_598013 != nil:
    section.add "key", valid_598013
  var valid_598014 = query.getOrDefault("$.xgafv")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = newJString("1"))
  if valid_598014 != nil:
    section.add "$.xgafv", valid_598014
  var valid_598015 = query.getOrDefault("pageSize")
  valid_598015 = validateParameter(valid_598015, JInt, required = false, default = nil)
  if valid_598015 != nil:
    section.add "pageSize", valid_598015
  var valid_598016 = query.getOrDefault("prettyPrint")
  valid_598016 = validateParameter(valid_598016, JBool, required = false,
                                 default = newJBool(true))
  if valid_598016 != nil:
    section.add "prettyPrint", valid_598016
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598017: Call_ClassroomCoursesAliasesList_597986; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of aliases for a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## course or for access errors.
  ## * `NOT_FOUND` if the course does not exist.
  ## 
  let valid = call_598017.validator(path, query, header, formData, body)
  let scheme = call_598017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598017.url(scheme.get, call_598017.host, call_598017.base,
                         call_598017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598017, url, valid)

proc call*(call_598018: Call_ClassroomCoursesAliasesList_597986; courseId: string;
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
  var path_598019 = newJObject()
  var query_598020 = newJObject()
  add(query_598020, "upload_protocol", newJString(uploadProtocol))
  add(query_598020, "fields", newJString(fields))
  add(query_598020, "pageToken", newJString(pageToken))
  add(query_598020, "quotaUser", newJString(quotaUser))
  add(query_598020, "alt", newJString(alt))
  add(query_598020, "oauth_token", newJString(oauthToken))
  add(query_598020, "callback", newJString(callback))
  add(query_598020, "access_token", newJString(accessToken))
  add(query_598020, "uploadType", newJString(uploadType))
  add(query_598020, "key", newJString(key))
  add(path_598019, "courseId", newJString(courseId))
  add(query_598020, "$.xgafv", newJString(Xgafv))
  add(query_598020, "pageSize", newJInt(pageSize))
  add(query_598020, "prettyPrint", newJBool(prettyPrint))
  result = call_598018.call(path_598019, query_598020, nil, nil, nil)

var classroomCoursesAliasesList* = Call_ClassroomCoursesAliasesList_597986(
    name: "classroomCoursesAliasesList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/aliases",
    validator: validate_ClassroomCoursesAliasesList_597987, base: "/",
    url: url_ClassroomCoursesAliasesList_597988, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAliasesDelete_598042 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesAliasesDelete_598044(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomCoursesAliasesDelete_598043(path: JsonNode; query: JsonNode;
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
  var valid_598045 = path.getOrDefault("courseId")
  valid_598045 = validateParameter(valid_598045, JString, required = true,
                                 default = nil)
  if valid_598045 != nil:
    section.add "courseId", valid_598045
  var valid_598046 = path.getOrDefault("alias")
  valid_598046 = validateParameter(valid_598046, JString, required = true,
                                 default = nil)
  if valid_598046 != nil:
    section.add "alias", valid_598046
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
  var valid_598047 = query.getOrDefault("upload_protocol")
  valid_598047 = validateParameter(valid_598047, JString, required = false,
                                 default = nil)
  if valid_598047 != nil:
    section.add "upload_protocol", valid_598047
  var valid_598048 = query.getOrDefault("fields")
  valid_598048 = validateParameter(valid_598048, JString, required = false,
                                 default = nil)
  if valid_598048 != nil:
    section.add "fields", valid_598048
  var valid_598049 = query.getOrDefault("quotaUser")
  valid_598049 = validateParameter(valid_598049, JString, required = false,
                                 default = nil)
  if valid_598049 != nil:
    section.add "quotaUser", valid_598049
  var valid_598050 = query.getOrDefault("alt")
  valid_598050 = validateParameter(valid_598050, JString, required = false,
                                 default = newJString("json"))
  if valid_598050 != nil:
    section.add "alt", valid_598050
  var valid_598051 = query.getOrDefault("oauth_token")
  valid_598051 = validateParameter(valid_598051, JString, required = false,
                                 default = nil)
  if valid_598051 != nil:
    section.add "oauth_token", valid_598051
  var valid_598052 = query.getOrDefault("callback")
  valid_598052 = validateParameter(valid_598052, JString, required = false,
                                 default = nil)
  if valid_598052 != nil:
    section.add "callback", valid_598052
  var valid_598053 = query.getOrDefault("access_token")
  valid_598053 = validateParameter(valid_598053, JString, required = false,
                                 default = nil)
  if valid_598053 != nil:
    section.add "access_token", valid_598053
  var valid_598054 = query.getOrDefault("uploadType")
  valid_598054 = validateParameter(valid_598054, JString, required = false,
                                 default = nil)
  if valid_598054 != nil:
    section.add "uploadType", valid_598054
  var valid_598055 = query.getOrDefault("key")
  valid_598055 = validateParameter(valid_598055, JString, required = false,
                                 default = nil)
  if valid_598055 != nil:
    section.add "key", valid_598055
  var valid_598056 = query.getOrDefault("$.xgafv")
  valid_598056 = validateParameter(valid_598056, JString, required = false,
                                 default = newJString("1"))
  if valid_598056 != nil:
    section.add "$.xgafv", valid_598056
  var valid_598057 = query.getOrDefault("prettyPrint")
  valid_598057 = validateParameter(valid_598057, JBool, required = false,
                                 default = newJBool(true))
  if valid_598057 != nil:
    section.add "prettyPrint", valid_598057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598058: Call_ClassroomCoursesAliasesDelete_598042; path: JsonNode;
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
  let valid = call_598058.validator(path, query, header, formData, body)
  let scheme = call_598058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598058.url(scheme.get, call_598058.host, call_598058.base,
                         call_598058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598058, url, valid)

proc call*(call_598059: Call_ClassroomCoursesAliasesDelete_598042;
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
  var path_598060 = newJObject()
  var query_598061 = newJObject()
  add(query_598061, "upload_protocol", newJString(uploadProtocol))
  add(query_598061, "fields", newJString(fields))
  add(query_598061, "quotaUser", newJString(quotaUser))
  add(query_598061, "alt", newJString(alt))
  add(query_598061, "oauth_token", newJString(oauthToken))
  add(query_598061, "callback", newJString(callback))
  add(query_598061, "access_token", newJString(accessToken))
  add(query_598061, "uploadType", newJString(uploadType))
  add(query_598061, "key", newJString(key))
  add(path_598060, "courseId", newJString(courseId))
  add(query_598061, "$.xgafv", newJString(Xgafv))
  add(query_598061, "prettyPrint", newJBool(prettyPrint))
  add(path_598060, "alias", newJString(alias))
  result = call_598059.call(path_598060, query_598061, nil, nil, nil)

var classroomCoursesAliasesDelete* = Call_ClassroomCoursesAliasesDelete_598042(
    name: "classroomCoursesAliasesDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/aliases/{alias}",
    validator: validate_ClassroomCoursesAliasesDelete_598043, base: "/",
    url: url_ClassroomCoursesAliasesDelete_598044, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAnnouncementsCreate_598085 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesAnnouncementsCreate_598087(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomCoursesAnnouncementsCreate_598086(path: JsonNode;
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
  var valid_598088 = path.getOrDefault("courseId")
  valid_598088 = validateParameter(valid_598088, JString, required = true,
                                 default = nil)
  if valid_598088 != nil:
    section.add "courseId", valid_598088
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
  var valid_598089 = query.getOrDefault("upload_protocol")
  valid_598089 = validateParameter(valid_598089, JString, required = false,
                                 default = nil)
  if valid_598089 != nil:
    section.add "upload_protocol", valid_598089
  var valid_598090 = query.getOrDefault("fields")
  valid_598090 = validateParameter(valid_598090, JString, required = false,
                                 default = nil)
  if valid_598090 != nil:
    section.add "fields", valid_598090
  var valid_598091 = query.getOrDefault("quotaUser")
  valid_598091 = validateParameter(valid_598091, JString, required = false,
                                 default = nil)
  if valid_598091 != nil:
    section.add "quotaUser", valid_598091
  var valid_598092 = query.getOrDefault("alt")
  valid_598092 = validateParameter(valid_598092, JString, required = false,
                                 default = newJString("json"))
  if valid_598092 != nil:
    section.add "alt", valid_598092
  var valid_598093 = query.getOrDefault("oauth_token")
  valid_598093 = validateParameter(valid_598093, JString, required = false,
                                 default = nil)
  if valid_598093 != nil:
    section.add "oauth_token", valid_598093
  var valid_598094 = query.getOrDefault("callback")
  valid_598094 = validateParameter(valid_598094, JString, required = false,
                                 default = nil)
  if valid_598094 != nil:
    section.add "callback", valid_598094
  var valid_598095 = query.getOrDefault("access_token")
  valid_598095 = validateParameter(valid_598095, JString, required = false,
                                 default = nil)
  if valid_598095 != nil:
    section.add "access_token", valid_598095
  var valid_598096 = query.getOrDefault("uploadType")
  valid_598096 = validateParameter(valid_598096, JString, required = false,
                                 default = nil)
  if valid_598096 != nil:
    section.add "uploadType", valid_598096
  var valid_598097 = query.getOrDefault("key")
  valid_598097 = validateParameter(valid_598097, JString, required = false,
                                 default = nil)
  if valid_598097 != nil:
    section.add "key", valid_598097
  var valid_598098 = query.getOrDefault("$.xgafv")
  valid_598098 = validateParameter(valid_598098, JString, required = false,
                                 default = newJString("1"))
  if valid_598098 != nil:
    section.add "$.xgafv", valid_598098
  var valid_598099 = query.getOrDefault("prettyPrint")
  valid_598099 = validateParameter(valid_598099, JBool, required = false,
                                 default = newJBool(true))
  if valid_598099 != nil:
    section.add "prettyPrint", valid_598099
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

proc call*(call_598101: Call_ClassroomCoursesAnnouncementsCreate_598085;
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
  let valid = call_598101.validator(path, query, header, formData, body)
  let scheme = call_598101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598101.url(scheme.get, call_598101.host, call_598101.base,
                         call_598101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598101, url, valid)

proc call*(call_598102: Call_ClassroomCoursesAnnouncementsCreate_598085;
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
  var path_598103 = newJObject()
  var query_598104 = newJObject()
  var body_598105 = newJObject()
  add(query_598104, "upload_protocol", newJString(uploadProtocol))
  add(query_598104, "fields", newJString(fields))
  add(query_598104, "quotaUser", newJString(quotaUser))
  add(query_598104, "alt", newJString(alt))
  add(query_598104, "oauth_token", newJString(oauthToken))
  add(query_598104, "callback", newJString(callback))
  add(query_598104, "access_token", newJString(accessToken))
  add(query_598104, "uploadType", newJString(uploadType))
  add(query_598104, "key", newJString(key))
  add(path_598103, "courseId", newJString(courseId))
  add(query_598104, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598105 = body
  add(query_598104, "prettyPrint", newJBool(prettyPrint))
  result = call_598102.call(path_598103, query_598104, nil, nil, body_598105)

var classroomCoursesAnnouncementsCreate* = Call_ClassroomCoursesAnnouncementsCreate_598085(
    name: "classroomCoursesAnnouncementsCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/announcements",
    validator: validate_ClassroomCoursesAnnouncementsCreate_598086, base: "/",
    url: url_ClassroomCoursesAnnouncementsCreate_598087, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAnnouncementsList_598062 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesAnnouncementsList_598064(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomCoursesAnnouncementsList_598063(path: JsonNode;
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
  var valid_598065 = path.getOrDefault("courseId")
  valid_598065 = validateParameter(valid_598065, JString, required = true,
                                 default = nil)
  if valid_598065 != nil:
    section.add "courseId", valid_598065
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
  var valid_598066 = query.getOrDefault("announcementStates")
  valid_598066 = validateParameter(valid_598066, JArray, required = false,
                                 default = nil)
  if valid_598066 != nil:
    section.add "announcementStates", valid_598066
  var valid_598067 = query.getOrDefault("upload_protocol")
  valid_598067 = validateParameter(valid_598067, JString, required = false,
                                 default = nil)
  if valid_598067 != nil:
    section.add "upload_protocol", valid_598067
  var valid_598068 = query.getOrDefault("fields")
  valid_598068 = validateParameter(valid_598068, JString, required = false,
                                 default = nil)
  if valid_598068 != nil:
    section.add "fields", valid_598068
  var valid_598069 = query.getOrDefault("pageToken")
  valid_598069 = validateParameter(valid_598069, JString, required = false,
                                 default = nil)
  if valid_598069 != nil:
    section.add "pageToken", valid_598069
  var valid_598070 = query.getOrDefault("quotaUser")
  valid_598070 = validateParameter(valid_598070, JString, required = false,
                                 default = nil)
  if valid_598070 != nil:
    section.add "quotaUser", valid_598070
  var valid_598071 = query.getOrDefault("alt")
  valid_598071 = validateParameter(valid_598071, JString, required = false,
                                 default = newJString("json"))
  if valid_598071 != nil:
    section.add "alt", valid_598071
  var valid_598072 = query.getOrDefault("oauth_token")
  valid_598072 = validateParameter(valid_598072, JString, required = false,
                                 default = nil)
  if valid_598072 != nil:
    section.add "oauth_token", valid_598072
  var valid_598073 = query.getOrDefault("callback")
  valid_598073 = validateParameter(valid_598073, JString, required = false,
                                 default = nil)
  if valid_598073 != nil:
    section.add "callback", valid_598073
  var valid_598074 = query.getOrDefault("access_token")
  valid_598074 = validateParameter(valid_598074, JString, required = false,
                                 default = nil)
  if valid_598074 != nil:
    section.add "access_token", valid_598074
  var valid_598075 = query.getOrDefault("uploadType")
  valid_598075 = validateParameter(valid_598075, JString, required = false,
                                 default = nil)
  if valid_598075 != nil:
    section.add "uploadType", valid_598075
  var valid_598076 = query.getOrDefault("orderBy")
  valid_598076 = validateParameter(valid_598076, JString, required = false,
                                 default = nil)
  if valid_598076 != nil:
    section.add "orderBy", valid_598076
  var valid_598077 = query.getOrDefault("key")
  valid_598077 = validateParameter(valid_598077, JString, required = false,
                                 default = nil)
  if valid_598077 != nil:
    section.add "key", valid_598077
  var valid_598078 = query.getOrDefault("$.xgafv")
  valid_598078 = validateParameter(valid_598078, JString, required = false,
                                 default = newJString("1"))
  if valid_598078 != nil:
    section.add "$.xgafv", valid_598078
  var valid_598079 = query.getOrDefault("pageSize")
  valid_598079 = validateParameter(valid_598079, JInt, required = false, default = nil)
  if valid_598079 != nil:
    section.add "pageSize", valid_598079
  var valid_598080 = query.getOrDefault("prettyPrint")
  valid_598080 = validateParameter(valid_598080, JBool, required = false,
                                 default = newJBool(true))
  if valid_598080 != nil:
    section.add "prettyPrint", valid_598080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598081: Call_ClassroomCoursesAnnouncementsList_598062;
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
  let valid = call_598081.validator(path, query, header, formData, body)
  let scheme = call_598081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598081.url(scheme.get, call_598081.host, call_598081.base,
                         call_598081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598081, url, valid)

proc call*(call_598082: Call_ClassroomCoursesAnnouncementsList_598062;
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
  var path_598083 = newJObject()
  var query_598084 = newJObject()
  if announcementStates != nil:
    query_598084.add "announcementStates", announcementStates
  add(query_598084, "upload_protocol", newJString(uploadProtocol))
  add(query_598084, "fields", newJString(fields))
  add(query_598084, "pageToken", newJString(pageToken))
  add(query_598084, "quotaUser", newJString(quotaUser))
  add(query_598084, "alt", newJString(alt))
  add(query_598084, "oauth_token", newJString(oauthToken))
  add(query_598084, "callback", newJString(callback))
  add(query_598084, "access_token", newJString(accessToken))
  add(query_598084, "uploadType", newJString(uploadType))
  add(query_598084, "orderBy", newJString(orderBy))
  add(query_598084, "key", newJString(key))
  add(path_598083, "courseId", newJString(courseId))
  add(query_598084, "$.xgafv", newJString(Xgafv))
  add(query_598084, "pageSize", newJInt(pageSize))
  add(query_598084, "prettyPrint", newJBool(prettyPrint))
  result = call_598082.call(path_598083, query_598084, nil, nil, nil)

var classroomCoursesAnnouncementsList* = Call_ClassroomCoursesAnnouncementsList_598062(
    name: "classroomCoursesAnnouncementsList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/announcements",
    validator: validate_ClassroomCoursesAnnouncementsList_598063, base: "/",
    url: url_ClassroomCoursesAnnouncementsList_598064, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAnnouncementsGet_598106 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesAnnouncementsGet_598108(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomCoursesAnnouncementsGet_598107(path: JsonNode;
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
  var valid_598109 = path.getOrDefault("id")
  valid_598109 = validateParameter(valid_598109, JString, required = true,
                                 default = nil)
  if valid_598109 != nil:
    section.add "id", valid_598109
  var valid_598110 = path.getOrDefault("courseId")
  valid_598110 = validateParameter(valid_598110, JString, required = true,
                                 default = nil)
  if valid_598110 != nil:
    section.add "courseId", valid_598110
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
  var valid_598111 = query.getOrDefault("upload_protocol")
  valid_598111 = validateParameter(valid_598111, JString, required = false,
                                 default = nil)
  if valid_598111 != nil:
    section.add "upload_protocol", valid_598111
  var valid_598112 = query.getOrDefault("fields")
  valid_598112 = validateParameter(valid_598112, JString, required = false,
                                 default = nil)
  if valid_598112 != nil:
    section.add "fields", valid_598112
  var valid_598113 = query.getOrDefault("quotaUser")
  valid_598113 = validateParameter(valid_598113, JString, required = false,
                                 default = nil)
  if valid_598113 != nil:
    section.add "quotaUser", valid_598113
  var valid_598114 = query.getOrDefault("alt")
  valid_598114 = validateParameter(valid_598114, JString, required = false,
                                 default = newJString("json"))
  if valid_598114 != nil:
    section.add "alt", valid_598114
  var valid_598115 = query.getOrDefault("oauth_token")
  valid_598115 = validateParameter(valid_598115, JString, required = false,
                                 default = nil)
  if valid_598115 != nil:
    section.add "oauth_token", valid_598115
  var valid_598116 = query.getOrDefault("callback")
  valid_598116 = validateParameter(valid_598116, JString, required = false,
                                 default = nil)
  if valid_598116 != nil:
    section.add "callback", valid_598116
  var valid_598117 = query.getOrDefault("access_token")
  valid_598117 = validateParameter(valid_598117, JString, required = false,
                                 default = nil)
  if valid_598117 != nil:
    section.add "access_token", valid_598117
  var valid_598118 = query.getOrDefault("uploadType")
  valid_598118 = validateParameter(valid_598118, JString, required = false,
                                 default = nil)
  if valid_598118 != nil:
    section.add "uploadType", valid_598118
  var valid_598119 = query.getOrDefault("key")
  valid_598119 = validateParameter(valid_598119, JString, required = false,
                                 default = nil)
  if valid_598119 != nil:
    section.add "key", valid_598119
  var valid_598120 = query.getOrDefault("$.xgafv")
  valid_598120 = validateParameter(valid_598120, JString, required = false,
                                 default = newJString("1"))
  if valid_598120 != nil:
    section.add "$.xgafv", valid_598120
  var valid_598121 = query.getOrDefault("prettyPrint")
  valid_598121 = validateParameter(valid_598121, JBool, required = false,
                                 default = newJBool(true))
  if valid_598121 != nil:
    section.add "prettyPrint", valid_598121
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598122: Call_ClassroomCoursesAnnouncementsGet_598106;
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
  let valid = call_598122.validator(path, query, header, formData, body)
  let scheme = call_598122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598122.url(scheme.get, call_598122.host, call_598122.base,
                         call_598122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598122, url, valid)

proc call*(call_598123: Call_ClassroomCoursesAnnouncementsGet_598106; id: string;
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
  var path_598124 = newJObject()
  var query_598125 = newJObject()
  add(query_598125, "upload_protocol", newJString(uploadProtocol))
  add(query_598125, "fields", newJString(fields))
  add(query_598125, "quotaUser", newJString(quotaUser))
  add(query_598125, "alt", newJString(alt))
  add(query_598125, "oauth_token", newJString(oauthToken))
  add(query_598125, "callback", newJString(callback))
  add(query_598125, "access_token", newJString(accessToken))
  add(query_598125, "uploadType", newJString(uploadType))
  add(path_598124, "id", newJString(id))
  add(query_598125, "key", newJString(key))
  add(path_598124, "courseId", newJString(courseId))
  add(query_598125, "$.xgafv", newJString(Xgafv))
  add(query_598125, "prettyPrint", newJBool(prettyPrint))
  result = call_598123.call(path_598124, query_598125, nil, nil, nil)

var classroomCoursesAnnouncementsGet* = Call_ClassroomCoursesAnnouncementsGet_598106(
    name: "classroomCoursesAnnouncementsGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/announcements/{id}",
    validator: validate_ClassroomCoursesAnnouncementsGet_598107, base: "/",
    url: url_ClassroomCoursesAnnouncementsGet_598108, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAnnouncementsPatch_598146 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesAnnouncementsPatch_598148(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomCoursesAnnouncementsPatch_598147(path: JsonNode;
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
  var valid_598149 = path.getOrDefault("id")
  valid_598149 = validateParameter(valid_598149, JString, required = true,
                                 default = nil)
  if valid_598149 != nil:
    section.add "id", valid_598149
  var valid_598150 = path.getOrDefault("courseId")
  valid_598150 = validateParameter(valid_598150, JString, required = true,
                                 default = nil)
  if valid_598150 != nil:
    section.add "courseId", valid_598150
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
  var valid_598151 = query.getOrDefault("upload_protocol")
  valid_598151 = validateParameter(valid_598151, JString, required = false,
                                 default = nil)
  if valid_598151 != nil:
    section.add "upload_protocol", valid_598151
  var valid_598152 = query.getOrDefault("fields")
  valid_598152 = validateParameter(valid_598152, JString, required = false,
                                 default = nil)
  if valid_598152 != nil:
    section.add "fields", valid_598152
  var valid_598153 = query.getOrDefault("quotaUser")
  valid_598153 = validateParameter(valid_598153, JString, required = false,
                                 default = nil)
  if valid_598153 != nil:
    section.add "quotaUser", valid_598153
  var valid_598154 = query.getOrDefault("alt")
  valid_598154 = validateParameter(valid_598154, JString, required = false,
                                 default = newJString("json"))
  if valid_598154 != nil:
    section.add "alt", valid_598154
  var valid_598155 = query.getOrDefault("oauth_token")
  valid_598155 = validateParameter(valid_598155, JString, required = false,
                                 default = nil)
  if valid_598155 != nil:
    section.add "oauth_token", valid_598155
  var valid_598156 = query.getOrDefault("callback")
  valid_598156 = validateParameter(valid_598156, JString, required = false,
                                 default = nil)
  if valid_598156 != nil:
    section.add "callback", valid_598156
  var valid_598157 = query.getOrDefault("access_token")
  valid_598157 = validateParameter(valid_598157, JString, required = false,
                                 default = nil)
  if valid_598157 != nil:
    section.add "access_token", valid_598157
  var valid_598158 = query.getOrDefault("uploadType")
  valid_598158 = validateParameter(valid_598158, JString, required = false,
                                 default = nil)
  if valid_598158 != nil:
    section.add "uploadType", valid_598158
  var valid_598159 = query.getOrDefault("key")
  valid_598159 = validateParameter(valid_598159, JString, required = false,
                                 default = nil)
  if valid_598159 != nil:
    section.add "key", valid_598159
  var valid_598160 = query.getOrDefault("$.xgafv")
  valid_598160 = validateParameter(valid_598160, JString, required = false,
                                 default = newJString("1"))
  if valid_598160 != nil:
    section.add "$.xgafv", valid_598160
  var valid_598161 = query.getOrDefault("prettyPrint")
  valid_598161 = validateParameter(valid_598161, JBool, required = false,
                                 default = newJBool(true))
  if valid_598161 != nil:
    section.add "prettyPrint", valid_598161
  var valid_598162 = query.getOrDefault("updateMask")
  valid_598162 = validateParameter(valid_598162, JString, required = false,
                                 default = nil)
  if valid_598162 != nil:
    section.add "updateMask", valid_598162
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

proc call*(call_598164: Call_ClassroomCoursesAnnouncementsPatch_598146;
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
  let valid = call_598164.validator(path, query, header, formData, body)
  let scheme = call_598164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598164.url(scheme.get, call_598164.host, call_598164.base,
                         call_598164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598164, url, valid)

proc call*(call_598165: Call_ClassroomCoursesAnnouncementsPatch_598146; id: string;
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
  var path_598166 = newJObject()
  var query_598167 = newJObject()
  var body_598168 = newJObject()
  add(query_598167, "upload_protocol", newJString(uploadProtocol))
  add(query_598167, "fields", newJString(fields))
  add(query_598167, "quotaUser", newJString(quotaUser))
  add(query_598167, "alt", newJString(alt))
  add(query_598167, "oauth_token", newJString(oauthToken))
  add(query_598167, "callback", newJString(callback))
  add(query_598167, "access_token", newJString(accessToken))
  add(query_598167, "uploadType", newJString(uploadType))
  add(path_598166, "id", newJString(id))
  add(query_598167, "key", newJString(key))
  add(path_598166, "courseId", newJString(courseId))
  add(query_598167, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598168 = body
  add(query_598167, "prettyPrint", newJBool(prettyPrint))
  add(query_598167, "updateMask", newJString(updateMask))
  result = call_598165.call(path_598166, query_598167, nil, nil, body_598168)

var classroomCoursesAnnouncementsPatch* = Call_ClassroomCoursesAnnouncementsPatch_598146(
    name: "classroomCoursesAnnouncementsPatch", meth: HttpMethod.HttpPatch,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/announcements/{id}",
    validator: validate_ClassroomCoursesAnnouncementsPatch_598147, base: "/",
    url: url_ClassroomCoursesAnnouncementsPatch_598148, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAnnouncementsDelete_598126 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesAnnouncementsDelete_598128(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomCoursesAnnouncementsDelete_598127(path: JsonNode;
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
  var valid_598129 = path.getOrDefault("id")
  valid_598129 = validateParameter(valid_598129, JString, required = true,
                                 default = nil)
  if valid_598129 != nil:
    section.add "id", valid_598129
  var valid_598130 = path.getOrDefault("courseId")
  valid_598130 = validateParameter(valid_598130, JString, required = true,
                                 default = nil)
  if valid_598130 != nil:
    section.add "courseId", valid_598130
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
  var valid_598131 = query.getOrDefault("upload_protocol")
  valid_598131 = validateParameter(valid_598131, JString, required = false,
                                 default = nil)
  if valid_598131 != nil:
    section.add "upload_protocol", valid_598131
  var valid_598132 = query.getOrDefault("fields")
  valid_598132 = validateParameter(valid_598132, JString, required = false,
                                 default = nil)
  if valid_598132 != nil:
    section.add "fields", valid_598132
  var valid_598133 = query.getOrDefault("quotaUser")
  valid_598133 = validateParameter(valid_598133, JString, required = false,
                                 default = nil)
  if valid_598133 != nil:
    section.add "quotaUser", valid_598133
  var valid_598134 = query.getOrDefault("alt")
  valid_598134 = validateParameter(valid_598134, JString, required = false,
                                 default = newJString("json"))
  if valid_598134 != nil:
    section.add "alt", valid_598134
  var valid_598135 = query.getOrDefault("oauth_token")
  valid_598135 = validateParameter(valid_598135, JString, required = false,
                                 default = nil)
  if valid_598135 != nil:
    section.add "oauth_token", valid_598135
  var valid_598136 = query.getOrDefault("callback")
  valid_598136 = validateParameter(valid_598136, JString, required = false,
                                 default = nil)
  if valid_598136 != nil:
    section.add "callback", valid_598136
  var valid_598137 = query.getOrDefault("access_token")
  valid_598137 = validateParameter(valid_598137, JString, required = false,
                                 default = nil)
  if valid_598137 != nil:
    section.add "access_token", valid_598137
  var valid_598138 = query.getOrDefault("uploadType")
  valid_598138 = validateParameter(valid_598138, JString, required = false,
                                 default = nil)
  if valid_598138 != nil:
    section.add "uploadType", valid_598138
  var valid_598139 = query.getOrDefault("key")
  valid_598139 = validateParameter(valid_598139, JString, required = false,
                                 default = nil)
  if valid_598139 != nil:
    section.add "key", valid_598139
  var valid_598140 = query.getOrDefault("$.xgafv")
  valid_598140 = validateParameter(valid_598140, JString, required = false,
                                 default = newJString("1"))
  if valid_598140 != nil:
    section.add "$.xgafv", valid_598140
  var valid_598141 = query.getOrDefault("prettyPrint")
  valid_598141 = validateParameter(valid_598141, JBool, required = false,
                                 default = newJBool(true))
  if valid_598141 != nil:
    section.add "prettyPrint", valid_598141
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598142: Call_ClassroomCoursesAnnouncementsDelete_598126;
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
  let valid = call_598142.validator(path, query, header, formData, body)
  let scheme = call_598142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598142.url(scheme.get, call_598142.host, call_598142.base,
                         call_598142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598142, url, valid)

proc call*(call_598143: Call_ClassroomCoursesAnnouncementsDelete_598126;
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
  var path_598144 = newJObject()
  var query_598145 = newJObject()
  add(query_598145, "upload_protocol", newJString(uploadProtocol))
  add(query_598145, "fields", newJString(fields))
  add(query_598145, "quotaUser", newJString(quotaUser))
  add(query_598145, "alt", newJString(alt))
  add(query_598145, "oauth_token", newJString(oauthToken))
  add(query_598145, "callback", newJString(callback))
  add(query_598145, "access_token", newJString(accessToken))
  add(query_598145, "uploadType", newJString(uploadType))
  add(path_598144, "id", newJString(id))
  add(query_598145, "key", newJString(key))
  add(path_598144, "courseId", newJString(courseId))
  add(query_598145, "$.xgafv", newJString(Xgafv))
  add(query_598145, "prettyPrint", newJBool(prettyPrint))
  result = call_598143.call(path_598144, query_598145, nil, nil, nil)

var classroomCoursesAnnouncementsDelete* = Call_ClassroomCoursesAnnouncementsDelete_598126(
    name: "classroomCoursesAnnouncementsDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/announcements/{id}",
    validator: validate_ClassroomCoursesAnnouncementsDelete_598127, base: "/",
    url: url_ClassroomCoursesAnnouncementsDelete_598128, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesAnnouncementsModifyAssignees_598169 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesAnnouncementsModifyAssignees_598171(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomCoursesAnnouncementsModifyAssignees_598170(path: JsonNode;
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
  var valid_598172 = path.getOrDefault("id")
  valid_598172 = validateParameter(valid_598172, JString, required = true,
                                 default = nil)
  if valid_598172 != nil:
    section.add "id", valid_598172
  var valid_598173 = path.getOrDefault("courseId")
  valid_598173 = validateParameter(valid_598173, JString, required = true,
                                 default = nil)
  if valid_598173 != nil:
    section.add "courseId", valid_598173
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
  var valid_598174 = query.getOrDefault("upload_protocol")
  valid_598174 = validateParameter(valid_598174, JString, required = false,
                                 default = nil)
  if valid_598174 != nil:
    section.add "upload_protocol", valid_598174
  var valid_598175 = query.getOrDefault("fields")
  valid_598175 = validateParameter(valid_598175, JString, required = false,
                                 default = nil)
  if valid_598175 != nil:
    section.add "fields", valid_598175
  var valid_598176 = query.getOrDefault("quotaUser")
  valid_598176 = validateParameter(valid_598176, JString, required = false,
                                 default = nil)
  if valid_598176 != nil:
    section.add "quotaUser", valid_598176
  var valid_598177 = query.getOrDefault("alt")
  valid_598177 = validateParameter(valid_598177, JString, required = false,
                                 default = newJString("json"))
  if valid_598177 != nil:
    section.add "alt", valid_598177
  var valid_598178 = query.getOrDefault("oauth_token")
  valid_598178 = validateParameter(valid_598178, JString, required = false,
                                 default = nil)
  if valid_598178 != nil:
    section.add "oauth_token", valid_598178
  var valid_598179 = query.getOrDefault("callback")
  valid_598179 = validateParameter(valid_598179, JString, required = false,
                                 default = nil)
  if valid_598179 != nil:
    section.add "callback", valid_598179
  var valid_598180 = query.getOrDefault("access_token")
  valid_598180 = validateParameter(valid_598180, JString, required = false,
                                 default = nil)
  if valid_598180 != nil:
    section.add "access_token", valid_598180
  var valid_598181 = query.getOrDefault("uploadType")
  valid_598181 = validateParameter(valid_598181, JString, required = false,
                                 default = nil)
  if valid_598181 != nil:
    section.add "uploadType", valid_598181
  var valid_598182 = query.getOrDefault("key")
  valid_598182 = validateParameter(valid_598182, JString, required = false,
                                 default = nil)
  if valid_598182 != nil:
    section.add "key", valid_598182
  var valid_598183 = query.getOrDefault("$.xgafv")
  valid_598183 = validateParameter(valid_598183, JString, required = false,
                                 default = newJString("1"))
  if valid_598183 != nil:
    section.add "$.xgafv", valid_598183
  var valid_598184 = query.getOrDefault("prettyPrint")
  valid_598184 = validateParameter(valid_598184, JBool, required = false,
                                 default = newJBool(true))
  if valid_598184 != nil:
    section.add "prettyPrint", valid_598184
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

proc call*(call_598186: Call_ClassroomCoursesAnnouncementsModifyAssignees_598169;
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
  let valid = call_598186.validator(path, query, header, formData, body)
  let scheme = call_598186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598186.url(scheme.get, call_598186.host, call_598186.base,
                         call_598186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598186, url, valid)

proc call*(call_598187: Call_ClassroomCoursesAnnouncementsModifyAssignees_598169;
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
  var path_598188 = newJObject()
  var query_598189 = newJObject()
  var body_598190 = newJObject()
  add(query_598189, "upload_protocol", newJString(uploadProtocol))
  add(query_598189, "fields", newJString(fields))
  add(query_598189, "quotaUser", newJString(quotaUser))
  add(query_598189, "alt", newJString(alt))
  add(query_598189, "oauth_token", newJString(oauthToken))
  add(query_598189, "callback", newJString(callback))
  add(query_598189, "access_token", newJString(accessToken))
  add(query_598189, "uploadType", newJString(uploadType))
  add(path_598188, "id", newJString(id))
  add(query_598189, "key", newJString(key))
  add(path_598188, "courseId", newJString(courseId))
  add(query_598189, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598190 = body
  add(query_598189, "prettyPrint", newJBool(prettyPrint))
  result = call_598187.call(path_598188, query_598189, nil, nil, body_598190)

var classroomCoursesAnnouncementsModifyAssignees* = Call_ClassroomCoursesAnnouncementsModifyAssignees_598169(
    name: "classroomCoursesAnnouncementsModifyAssignees",
    meth: HttpMethod.HttpPost, host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/announcements/{id}:modifyAssignees",
    validator: validate_ClassroomCoursesAnnouncementsModifyAssignees_598170,
    base: "/", url: url_ClassroomCoursesAnnouncementsModifyAssignees_598171,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkCreate_598214 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesCourseWorkCreate_598216(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomCoursesCourseWorkCreate_598215(path: JsonNode;
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
  var valid_598217 = path.getOrDefault("courseId")
  valid_598217 = validateParameter(valid_598217, JString, required = true,
                                 default = nil)
  if valid_598217 != nil:
    section.add "courseId", valid_598217
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
  var valid_598218 = query.getOrDefault("upload_protocol")
  valid_598218 = validateParameter(valid_598218, JString, required = false,
                                 default = nil)
  if valid_598218 != nil:
    section.add "upload_protocol", valid_598218
  var valid_598219 = query.getOrDefault("fields")
  valid_598219 = validateParameter(valid_598219, JString, required = false,
                                 default = nil)
  if valid_598219 != nil:
    section.add "fields", valid_598219
  var valid_598220 = query.getOrDefault("quotaUser")
  valid_598220 = validateParameter(valid_598220, JString, required = false,
                                 default = nil)
  if valid_598220 != nil:
    section.add "quotaUser", valid_598220
  var valid_598221 = query.getOrDefault("alt")
  valid_598221 = validateParameter(valid_598221, JString, required = false,
                                 default = newJString("json"))
  if valid_598221 != nil:
    section.add "alt", valid_598221
  var valid_598222 = query.getOrDefault("oauth_token")
  valid_598222 = validateParameter(valid_598222, JString, required = false,
                                 default = nil)
  if valid_598222 != nil:
    section.add "oauth_token", valid_598222
  var valid_598223 = query.getOrDefault("callback")
  valid_598223 = validateParameter(valid_598223, JString, required = false,
                                 default = nil)
  if valid_598223 != nil:
    section.add "callback", valid_598223
  var valid_598224 = query.getOrDefault("access_token")
  valid_598224 = validateParameter(valid_598224, JString, required = false,
                                 default = nil)
  if valid_598224 != nil:
    section.add "access_token", valid_598224
  var valid_598225 = query.getOrDefault("uploadType")
  valid_598225 = validateParameter(valid_598225, JString, required = false,
                                 default = nil)
  if valid_598225 != nil:
    section.add "uploadType", valid_598225
  var valid_598226 = query.getOrDefault("key")
  valid_598226 = validateParameter(valid_598226, JString, required = false,
                                 default = nil)
  if valid_598226 != nil:
    section.add "key", valid_598226
  var valid_598227 = query.getOrDefault("$.xgafv")
  valid_598227 = validateParameter(valid_598227, JString, required = false,
                                 default = newJString("1"))
  if valid_598227 != nil:
    section.add "$.xgafv", valid_598227
  var valid_598228 = query.getOrDefault("prettyPrint")
  valid_598228 = validateParameter(valid_598228, JBool, required = false,
                                 default = newJBool(true))
  if valid_598228 != nil:
    section.add "prettyPrint", valid_598228
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

proc call*(call_598230: Call_ClassroomCoursesCourseWorkCreate_598214;
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
  let valid = call_598230.validator(path, query, header, formData, body)
  let scheme = call_598230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598230.url(scheme.get, call_598230.host, call_598230.base,
                         call_598230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598230, url, valid)

proc call*(call_598231: Call_ClassroomCoursesCourseWorkCreate_598214;
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
  var path_598232 = newJObject()
  var query_598233 = newJObject()
  var body_598234 = newJObject()
  add(query_598233, "upload_protocol", newJString(uploadProtocol))
  add(query_598233, "fields", newJString(fields))
  add(query_598233, "quotaUser", newJString(quotaUser))
  add(query_598233, "alt", newJString(alt))
  add(query_598233, "oauth_token", newJString(oauthToken))
  add(query_598233, "callback", newJString(callback))
  add(query_598233, "access_token", newJString(accessToken))
  add(query_598233, "uploadType", newJString(uploadType))
  add(query_598233, "key", newJString(key))
  add(path_598232, "courseId", newJString(courseId))
  add(query_598233, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598234 = body
  add(query_598233, "prettyPrint", newJBool(prettyPrint))
  result = call_598231.call(path_598232, query_598233, nil, nil, body_598234)

var classroomCoursesCourseWorkCreate* = Call_ClassroomCoursesCourseWorkCreate_598214(
    name: "classroomCoursesCourseWorkCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork",
    validator: validate_ClassroomCoursesCourseWorkCreate_598215, base: "/",
    url: url_ClassroomCoursesCourseWorkCreate_598216, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkList_598191 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesCourseWorkList_598193(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomCoursesCourseWorkList_598192(path: JsonNode;
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
  var valid_598194 = path.getOrDefault("courseId")
  valid_598194 = validateParameter(valid_598194, JString, required = true,
                                 default = nil)
  if valid_598194 != nil:
    section.add "courseId", valid_598194
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
  var valid_598195 = query.getOrDefault("upload_protocol")
  valid_598195 = validateParameter(valid_598195, JString, required = false,
                                 default = nil)
  if valid_598195 != nil:
    section.add "upload_protocol", valid_598195
  var valid_598196 = query.getOrDefault("fields")
  valid_598196 = validateParameter(valid_598196, JString, required = false,
                                 default = nil)
  if valid_598196 != nil:
    section.add "fields", valid_598196
  var valid_598197 = query.getOrDefault("pageToken")
  valid_598197 = validateParameter(valid_598197, JString, required = false,
                                 default = nil)
  if valid_598197 != nil:
    section.add "pageToken", valid_598197
  var valid_598198 = query.getOrDefault("quotaUser")
  valid_598198 = validateParameter(valid_598198, JString, required = false,
                                 default = nil)
  if valid_598198 != nil:
    section.add "quotaUser", valid_598198
  var valid_598199 = query.getOrDefault("alt")
  valid_598199 = validateParameter(valid_598199, JString, required = false,
                                 default = newJString("json"))
  if valid_598199 != nil:
    section.add "alt", valid_598199
  var valid_598200 = query.getOrDefault("oauth_token")
  valid_598200 = validateParameter(valid_598200, JString, required = false,
                                 default = nil)
  if valid_598200 != nil:
    section.add "oauth_token", valid_598200
  var valid_598201 = query.getOrDefault("callback")
  valid_598201 = validateParameter(valid_598201, JString, required = false,
                                 default = nil)
  if valid_598201 != nil:
    section.add "callback", valid_598201
  var valid_598202 = query.getOrDefault("access_token")
  valid_598202 = validateParameter(valid_598202, JString, required = false,
                                 default = nil)
  if valid_598202 != nil:
    section.add "access_token", valid_598202
  var valid_598203 = query.getOrDefault("uploadType")
  valid_598203 = validateParameter(valid_598203, JString, required = false,
                                 default = nil)
  if valid_598203 != nil:
    section.add "uploadType", valid_598203
  var valid_598204 = query.getOrDefault("orderBy")
  valid_598204 = validateParameter(valid_598204, JString, required = false,
                                 default = nil)
  if valid_598204 != nil:
    section.add "orderBy", valid_598204
  var valid_598205 = query.getOrDefault("key")
  valid_598205 = validateParameter(valid_598205, JString, required = false,
                                 default = nil)
  if valid_598205 != nil:
    section.add "key", valid_598205
  var valid_598206 = query.getOrDefault("courseWorkStates")
  valid_598206 = validateParameter(valid_598206, JArray, required = false,
                                 default = nil)
  if valid_598206 != nil:
    section.add "courseWorkStates", valid_598206
  var valid_598207 = query.getOrDefault("$.xgafv")
  valid_598207 = validateParameter(valid_598207, JString, required = false,
                                 default = newJString("1"))
  if valid_598207 != nil:
    section.add "$.xgafv", valid_598207
  var valid_598208 = query.getOrDefault("pageSize")
  valid_598208 = validateParameter(valid_598208, JInt, required = false, default = nil)
  if valid_598208 != nil:
    section.add "pageSize", valid_598208
  var valid_598209 = query.getOrDefault("prettyPrint")
  valid_598209 = validateParameter(valid_598209, JBool, required = false,
                                 default = newJBool(true))
  if valid_598209 != nil:
    section.add "prettyPrint", valid_598209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598210: Call_ClassroomCoursesCourseWorkList_598191; path: JsonNode;
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
  let valid = call_598210.validator(path, query, header, formData, body)
  let scheme = call_598210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598210.url(scheme.get, call_598210.host, call_598210.base,
                         call_598210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598210, url, valid)

proc call*(call_598211: Call_ClassroomCoursesCourseWorkList_598191;
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
  var path_598212 = newJObject()
  var query_598213 = newJObject()
  add(query_598213, "upload_protocol", newJString(uploadProtocol))
  add(query_598213, "fields", newJString(fields))
  add(query_598213, "pageToken", newJString(pageToken))
  add(query_598213, "quotaUser", newJString(quotaUser))
  add(query_598213, "alt", newJString(alt))
  add(query_598213, "oauth_token", newJString(oauthToken))
  add(query_598213, "callback", newJString(callback))
  add(query_598213, "access_token", newJString(accessToken))
  add(query_598213, "uploadType", newJString(uploadType))
  add(query_598213, "orderBy", newJString(orderBy))
  add(query_598213, "key", newJString(key))
  if courseWorkStates != nil:
    query_598213.add "courseWorkStates", courseWorkStates
  add(path_598212, "courseId", newJString(courseId))
  add(query_598213, "$.xgafv", newJString(Xgafv))
  add(query_598213, "pageSize", newJInt(pageSize))
  add(query_598213, "prettyPrint", newJBool(prettyPrint))
  result = call_598211.call(path_598212, query_598213, nil, nil, nil)

var classroomCoursesCourseWorkList* = Call_ClassroomCoursesCourseWorkList_598191(
    name: "classroomCoursesCourseWorkList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork",
    validator: validate_ClassroomCoursesCourseWorkList_598192, base: "/",
    url: url_ClassroomCoursesCourseWorkList_598193, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkStudentSubmissionsList_598235 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesCourseWorkStudentSubmissionsList_598237(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomCoursesCourseWorkStudentSubmissionsList_598236(
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
  var valid_598238 = path.getOrDefault("courseWorkId")
  valid_598238 = validateParameter(valid_598238, JString, required = true,
                                 default = nil)
  if valid_598238 != nil:
    section.add "courseWorkId", valid_598238
  var valid_598239 = path.getOrDefault("courseId")
  valid_598239 = validateParameter(valid_598239, JString, required = true,
                                 default = nil)
  if valid_598239 != nil:
    section.add "courseId", valid_598239
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
  var valid_598240 = query.getOrDefault("upload_protocol")
  valid_598240 = validateParameter(valid_598240, JString, required = false,
                                 default = nil)
  if valid_598240 != nil:
    section.add "upload_protocol", valid_598240
  var valid_598241 = query.getOrDefault("fields")
  valid_598241 = validateParameter(valid_598241, JString, required = false,
                                 default = nil)
  if valid_598241 != nil:
    section.add "fields", valid_598241
  var valid_598242 = query.getOrDefault("pageToken")
  valid_598242 = validateParameter(valid_598242, JString, required = false,
                                 default = nil)
  if valid_598242 != nil:
    section.add "pageToken", valid_598242
  var valid_598243 = query.getOrDefault("quotaUser")
  valid_598243 = validateParameter(valid_598243, JString, required = false,
                                 default = nil)
  if valid_598243 != nil:
    section.add "quotaUser", valid_598243
  var valid_598244 = query.getOrDefault("alt")
  valid_598244 = validateParameter(valid_598244, JString, required = false,
                                 default = newJString("json"))
  if valid_598244 != nil:
    section.add "alt", valid_598244
  var valid_598245 = query.getOrDefault("oauth_token")
  valid_598245 = validateParameter(valid_598245, JString, required = false,
                                 default = nil)
  if valid_598245 != nil:
    section.add "oauth_token", valid_598245
  var valid_598246 = query.getOrDefault("callback")
  valid_598246 = validateParameter(valid_598246, JString, required = false,
                                 default = nil)
  if valid_598246 != nil:
    section.add "callback", valid_598246
  var valid_598247 = query.getOrDefault("access_token")
  valid_598247 = validateParameter(valid_598247, JString, required = false,
                                 default = nil)
  if valid_598247 != nil:
    section.add "access_token", valid_598247
  var valid_598248 = query.getOrDefault("uploadType")
  valid_598248 = validateParameter(valid_598248, JString, required = false,
                                 default = nil)
  if valid_598248 != nil:
    section.add "uploadType", valid_598248
  var valid_598249 = query.getOrDefault("key")
  valid_598249 = validateParameter(valid_598249, JString, required = false,
                                 default = nil)
  if valid_598249 != nil:
    section.add "key", valid_598249
  var valid_598250 = query.getOrDefault("states")
  valid_598250 = validateParameter(valid_598250, JArray, required = false,
                                 default = nil)
  if valid_598250 != nil:
    section.add "states", valid_598250
  var valid_598251 = query.getOrDefault("$.xgafv")
  valid_598251 = validateParameter(valid_598251, JString, required = false,
                                 default = newJString("1"))
  if valid_598251 != nil:
    section.add "$.xgafv", valid_598251
  var valid_598252 = query.getOrDefault("pageSize")
  valid_598252 = validateParameter(valid_598252, JInt, required = false, default = nil)
  if valid_598252 != nil:
    section.add "pageSize", valid_598252
  var valid_598253 = query.getOrDefault("late")
  valid_598253 = validateParameter(valid_598253, JString, required = false, default = newJString(
      "LATE_VALUES_UNSPECIFIED"))
  if valid_598253 != nil:
    section.add "late", valid_598253
  var valid_598254 = query.getOrDefault("prettyPrint")
  valid_598254 = validateParameter(valid_598254, JBool, required = false,
                                 default = newJBool(true))
  if valid_598254 != nil:
    section.add "prettyPrint", valid_598254
  var valid_598255 = query.getOrDefault("userId")
  valid_598255 = validateParameter(valid_598255, JString, required = false,
                                 default = nil)
  if valid_598255 != nil:
    section.add "userId", valid_598255
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598256: Call_ClassroomCoursesCourseWorkStudentSubmissionsList_598235;
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
  let valid = call_598256.validator(path, query, header, formData, body)
  let scheme = call_598256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598256.url(scheme.get, call_598256.host, call_598256.base,
                         call_598256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598256, url, valid)

proc call*(call_598257: Call_ClassroomCoursesCourseWorkStudentSubmissionsList_598235;
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
  var path_598258 = newJObject()
  var query_598259 = newJObject()
  add(query_598259, "upload_protocol", newJString(uploadProtocol))
  add(query_598259, "fields", newJString(fields))
  add(query_598259, "pageToken", newJString(pageToken))
  add(query_598259, "quotaUser", newJString(quotaUser))
  add(path_598258, "courseWorkId", newJString(courseWorkId))
  add(query_598259, "alt", newJString(alt))
  add(query_598259, "oauth_token", newJString(oauthToken))
  add(query_598259, "callback", newJString(callback))
  add(query_598259, "access_token", newJString(accessToken))
  add(query_598259, "uploadType", newJString(uploadType))
  add(query_598259, "key", newJString(key))
  if states != nil:
    query_598259.add "states", states
  add(path_598258, "courseId", newJString(courseId))
  add(query_598259, "$.xgafv", newJString(Xgafv))
  add(query_598259, "pageSize", newJInt(pageSize))
  add(query_598259, "late", newJString(late))
  add(query_598259, "prettyPrint", newJBool(prettyPrint))
  add(query_598259, "userId", newJString(userId))
  result = call_598257.call(path_598258, query_598259, nil, nil, nil)

var classroomCoursesCourseWorkStudentSubmissionsList* = Call_ClassroomCoursesCourseWorkStudentSubmissionsList_598235(
    name: "classroomCoursesCourseWorkStudentSubmissionsList",
    meth: HttpMethod.HttpGet, host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork/{courseWorkId}/studentSubmissions",
    validator: validate_ClassroomCoursesCourseWorkStudentSubmissionsList_598236,
    base: "/", url: url_ClassroomCoursesCourseWorkStudentSubmissionsList_598237,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkStudentSubmissionsGet_598260 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesCourseWorkStudentSubmissionsGet_598262(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomCoursesCourseWorkStudentSubmissionsGet_598261(
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
  var valid_598263 = path.getOrDefault("courseWorkId")
  valid_598263 = validateParameter(valid_598263, JString, required = true,
                                 default = nil)
  if valid_598263 != nil:
    section.add "courseWorkId", valid_598263
  var valid_598264 = path.getOrDefault("id")
  valid_598264 = validateParameter(valid_598264, JString, required = true,
                                 default = nil)
  if valid_598264 != nil:
    section.add "id", valid_598264
  var valid_598265 = path.getOrDefault("courseId")
  valid_598265 = validateParameter(valid_598265, JString, required = true,
                                 default = nil)
  if valid_598265 != nil:
    section.add "courseId", valid_598265
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
  var valid_598266 = query.getOrDefault("upload_protocol")
  valid_598266 = validateParameter(valid_598266, JString, required = false,
                                 default = nil)
  if valid_598266 != nil:
    section.add "upload_protocol", valid_598266
  var valid_598267 = query.getOrDefault("fields")
  valid_598267 = validateParameter(valid_598267, JString, required = false,
                                 default = nil)
  if valid_598267 != nil:
    section.add "fields", valid_598267
  var valid_598268 = query.getOrDefault("quotaUser")
  valid_598268 = validateParameter(valid_598268, JString, required = false,
                                 default = nil)
  if valid_598268 != nil:
    section.add "quotaUser", valid_598268
  var valid_598269 = query.getOrDefault("alt")
  valid_598269 = validateParameter(valid_598269, JString, required = false,
                                 default = newJString("json"))
  if valid_598269 != nil:
    section.add "alt", valid_598269
  var valid_598270 = query.getOrDefault("oauth_token")
  valid_598270 = validateParameter(valid_598270, JString, required = false,
                                 default = nil)
  if valid_598270 != nil:
    section.add "oauth_token", valid_598270
  var valid_598271 = query.getOrDefault("callback")
  valid_598271 = validateParameter(valid_598271, JString, required = false,
                                 default = nil)
  if valid_598271 != nil:
    section.add "callback", valid_598271
  var valid_598272 = query.getOrDefault("access_token")
  valid_598272 = validateParameter(valid_598272, JString, required = false,
                                 default = nil)
  if valid_598272 != nil:
    section.add "access_token", valid_598272
  var valid_598273 = query.getOrDefault("uploadType")
  valid_598273 = validateParameter(valid_598273, JString, required = false,
                                 default = nil)
  if valid_598273 != nil:
    section.add "uploadType", valid_598273
  var valid_598274 = query.getOrDefault("key")
  valid_598274 = validateParameter(valid_598274, JString, required = false,
                                 default = nil)
  if valid_598274 != nil:
    section.add "key", valid_598274
  var valid_598275 = query.getOrDefault("$.xgafv")
  valid_598275 = validateParameter(valid_598275, JString, required = false,
                                 default = newJString("1"))
  if valid_598275 != nil:
    section.add "$.xgafv", valid_598275
  var valid_598276 = query.getOrDefault("prettyPrint")
  valid_598276 = validateParameter(valid_598276, JBool, required = false,
                                 default = newJBool(true))
  if valid_598276 != nil:
    section.add "prettyPrint", valid_598276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598277: Call_ClassroomCoursesCourseWorkStudentSubmissionsGet_598260;
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
  let valid = call_598277.validator(path, query, header, formData, body)
  let scheme = call_598277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598277.url(scheme.get, call_598277.host, call_598277.base,
                         call_598277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598277, url, valid)

proc call*(call_598278: Call_ClassroomCoursesCourseWorkStudentSubmissionsGet_598260;
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
  var path_598279 = newJObject()
  var query_598280 = newJObject()
  add(query_598280, "upload_protocol", newJString(uploadProtocol))
  add(query_598280, "fields", newJString(fields))
  add(query_598280, "quotaUser", newJString(quotaUser))
  add(path_598279, "courseWorkId", newJString(courseWorkId))
  add(query_598280, "alt", newJString(alt))
  add(query_598280, "oauth_token", newJString(oauthToken))
  add(query_598280, "callback", newJString(callback))
  add(query_598280, "access_token", newJString(accessToken))
  add(query_598280, "uploadType", newJString(uploadType))
  add(path_598279, "id", newJString(id))
  add(query_598280, "key", newJString(key))
  add(path_598279, "courseId", newJString(courseId))
  add(query_598280, "$.xgafv", newJString(Xgafv))
  add(query_598280, "prettyPrint", newJBool(prettyPrint))
  result = call_598278.call(path_598279, query_598280, nil, nil, nil)

var classroomCoursesCourseWorkStudentSubmissionsGet* = Call_ClassroomCoursesCourseWorkStudentSubmissionsGet_598260(
    name: "classroomCoursesCourseWorkStudentSubmissionsGet",
    meth: HttpMethod.HttpGet, host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork/{courseWorkId}/studentSubmissions/{id}",
    validator: validate_ClassroomCoursesCourseWorkStudentSubmissionsGet_598261,
    base: "/", url: url_ClassroomCoursesCourseWorkStudentSubmissionsGet_598262,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkStudentSubmissionsPatch_598281 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesCourseWorkStudentSubmissionsPatch_598283(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomCoursesCourseWorkStudentSubmissionsPatch_598282(
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
  var valid_598284 = path.getOrDefault("courseWorkId")
  valid_598284 = validateParameter(valid_598284, JString, required = true,
                                 default = nil)
  if valid_598284 != nil:
    section.add "courseWorkId", valid_598284
  var valid_598285 = path.getOrDefault("id")
  valid_598285 = validateParameter(valid_598285, JString, required = true,
                                 default = nil)
  if valid_598285 != nil:
    section.add "id", valid_598285
  var valid_598286 = path.getOrDefault("courseId")
  valid_598286 = validateParameter(valid_598286, JString, required = true,
                                 default = nil)
  if valid_598286 != nil:
    section.add "courseId", valid_598286
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
  var valid_598287 = query.getOrDefault("upload_protocol")
  valid_598287 = validateParameter(valid_598287, JString, required = false,
                                 default = nil)
  if valid_598287 != nil:
    section.add "upload_protocol", valid_598287
  var valid_598288 = query.getOrDefault("fields")
  valid_598288 = validateParameter(valid_598288, JString, required = false,
                                 default = nil)
  if valid_598288 != nil:
    section.add "fields", valid_598288
  var valid_598289 = query.getOrDefault("quotaUser")
  valid_598289 = validateParameter(valid_598289, JString, required = false,
                                 default = nil)
  if valid_598289 != nil:
    section.add "quotaUser", valid_598289
  var valid_598290 = query.getOrDefault("alt")
  valid_598290 = validateParameter(valid_598290, JString, required = false,
                                 default = newJString("json"))
  if valid_598290 != nil:
    section.add "alt", valid_598290
  var valid_598291 = query.getOrDefault("oauth_token")
  valid_598291 = validateParameter(valid_598291, JString, required = false,
                                 default = nil)
  if valid_598291 != nil:
    section.add "oauth_token", valid_598291
  var valid_598292 = query.getOrDefault("callback")
  valid_598292 = validateParameter(valid_598292, JString, required = false,
                                 default = nil)
  if valid_598292 != nil:
    section.add "callback", valid_598292
  var valid_598293 = query.getOrDefault("access_token")
  valid_598293 = validateParameter(valid_598293, JString, required = false,
                                 default = nil)
  if valid_598293 != nil:
    section.add "access_token", valid_598293
  var valid_598294 = query.getOrDefault("uploadType")
  valid_598294 = validateParameter(valid_598294, JString, required = false,
                                 default = nil)
  if valid_598294 != nil:
    section.add "uploadType", valid_598294
  var valid_598295 = query.getOrDefault("key")
  valid_598295 = validateParameter(valid_598295, JString, required = false,
                                 default = nil)
  if valid_598295 != nil:
    section.add "key", valid_598295
  var valid_598296 = query.getOrDefault("$.xgafv")
  valid_598296 = validateParameter(valid_598296, JString, required = false,
                                 default = newJString("1"))
  if valid_598296 != nil:
    section.add "$.xgafv", valid_598296
  var valid_598297 = query.getOrDefault("prettyPrint")
  valid_598297 = validateParameter(valid_598297, JBool, required = false,
                                 default = newJBool(true))
  if valid_598297 != nil:
    section.add "prettyPrint", valid_598297
  var valid_598298 = query.getOrDefault("updateMask")
  valid_598298 = validateParameter(valid_598298, JString, required = false,
                                 default = nil)
  if valid_598298 != nil:
    section.add "updateMask", valid_598298
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

proc call*(call_598300: Call_ClassroomCoursesCourseWorkStudentSubmissionsPatch_598281;
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
  let valid = call_598300.validator(path, query, header, formData, body)
  let scheme = call_598300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598300.url(scheme.get, call_598300.host, call_598300.base,
                         call_598300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598300, url, valid)

proc call*(call_598301: Call_ClassroomCoursesCourseWorkStudentSubmissionsPatch_598281;
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
  var path_598302 = newJObject()
  var query_598303 = newJObject()
  var body_598304 = newJObject()
  add(query_598303, "upload_protocol", newJString(uploadProtocol))
  add(query_598303, "fields", newJString(fields))
  add(query_598303, "quotaUser", newJString(quotaUser))
  add(path_598302, "courseWorkId", newJString(courseWorkId))
  add(query_598303, "alt", newJString(alt))
  add(query_598303, "oauth_token", newJString(oauthToken))
  add(query_598303, "callback", newJString(callback))
  add(query_598303, "access_token", newJString(accessToken))
  add(query_598303, "uploadType", newJString(uploadType))
  add(path_598302, "id", newJString(id))
  add(query_598303, "key", newJString(key))
  add(path_598302, "courseId", newJString(courseId))
  add(query_598303, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598304 = body
  add(query_598303, "prettyPrint", newJBool(prettyPrint))
  add(query_598303, "updateMask", newJString(updateMask))
  result = call_598301.call(path_598302, query_598303, nil, nil, body_598304)

var classroomCoursesCourseWorkStudentSubmissionsPatch* = Call_ClassroomCoursesCourseWorkStudentSubmissionsPatch_598281(
    name: "classroomCoursesCourseWorkStudentSubmissionsPatch",
    meth: HttpMethod.HttpPatch, host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork/{courseWorkId}/studentSubmissions/{id}",
    validator: validate_ClassroomCoursesCourseWorkStudentSubmissionsPatch_598282,
    base: "/", url: url_ClassroomCoursesCourseWorkStudentSubmissionsPatch_598283,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkStudentSubmissionsModifyAttachments_598305 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesCourseWorkStudentSubmissionsModifyAttachments_598307(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomCoursesCourseWorkStudentSubmissionsModifyAttachments_598306(
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
  var valid_598308 = path.getOrDefault("courseWorkId")
  valid_598308 = validateParameter(valid_598308, JString, required = true,
                                 default = nil)
  if valid_598308 != nil:
    section.add "courseWorkId", valid_598308
  var valid_598309 = path.getOrDefault("id")
  valid_598309 = validateParameter(valid_598309, JString, required = true,
                                 default = nil)
  if valid_598309 != nil:
    section.add "id", valid_598309
  var valid_598310 = path.getOrDefault("courseId")
  valid_598310 = validateParameter(valid_598310, JString, required = true,
                                 default = nil)
  if valid_598310 != nil:
    section.add "courseId", valid_598310
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
  var valid_598311 = query.getOrDefault("upload_protocol")
  valid_598311 = validateParameter(valid_598311, JString, required = false,
                                 default = nil)
  if valid_598311 != nil:
    section.add "upload_protocol", valid_598311
  var valid_598312 = query.getOrDefault("fields")
  valid_598312 = validateParameter(valid_598312, JString, required = false,
                                 default = nil)
  if valid_598312 != nil:
    section.add "fields", valid_598312
  var valid_598313 = query.getOrDefault("quotaUser")
  valid_598313 = validateParameter(valid_598313, JString, required = false,
                                 default = nil)
  if valid_598313 != nil:
    section.add "quotaUser", valid_598313
  var valid_598314 = query.getOrDefault("alt")
  valid_598314 = validateParameter(valid_598314, JString, required = false,
                                 default = newJString("json"))
  if valid_598314 != nil:
    section.add "alt", valid_598314
  var valid_598315 = query.getOrDefault("oauth_token")
  valid_598315 = validateParameter(valid_598315, JString, required = false,
                                 default = nil)
  if valid_598315 != nil:
    section.add "oauth_token", valid_598315
  var valid_598316 = query.getOrDefault("callback")
  valid_598316 = validateParameter(valid_598316, JString, required = false,
                                 default = nil)
  if valid_598316 != nil:
    section.add "callback", valid_598316
  var valid_598317 = query.getOrDefault("access_token")
  valid_598317 = validateParameter(valid_598317, JString, required = false,
                                 default = nil)
  if valid_598317 != nil:
    section.add "access_token", valid_598317
  var valid_598318 = query.getOrDefault("uploadType")
  valid_598318 = validateParameter(valid_598318, JString, required = false,
                                 default = nil)
  if valid_598318 != nil:
    section.add "uploadType", valid_598318
  var valid_598319 = query.getOrDefault("key")
  valid_598319 = validateParameter(valid_598319, JString, required = false,
                                 default = nil)
  if valid_598319 != nil:
    section.add "key", valid_598319
  var valid_598320 = query.getOrDefault("$.xgafv")
  valid_598320 = validateParameter(valid_598320, JString, required = false,
                                 default = newJString("1"))
  if valid_598320 != nil:
    section.add "$.xgafv", valid_598320
  var valid_598321 = query.getOrDefault("prettyPrint")
  valid_598321 = validateParameter(valid_598321, JBool, required = false,
                                 default = newJBool(true))
  if valid_598321 != nil:
    section.add "prettyPrint", valid_598321
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

proc call*(call_598323: Call_ClassroomCoursesCourseWorkStudentSubmissionsModifyAttachments_598305;
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
  let valid = call_598323.validator(path, query, header, formData, body)
  let scheme = call_598323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598323.url(scheme.get, call_598323.host, call_598323.base,
                         call_598323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598323, url, valid)

proc call*(call_598324: Call_ClassroomCoursesCourseWorkStudentSubmissionsModifyAttachments_598305;
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
  var path_598325 = newJObject()
  var query_598326 = newJObject()
  var body_598327 = newJObject()
  add(query_598326, "upload_protocol", newJString(uploadProtocol))
  add(query_598326, "fields", newJString(fields))
  add(query_598326, "quotaUser", newJString(quotaUser))
  add(path_598325, "courseWorkId", newJString(courseWorkId))
  add(query_598326, "alt", newJString(alt))
  add(query_598326, "oauth_token", newJString(oauthToken))
  add(query_598326, "callback", newJString(callback))
  add(query_598326, "access_token", newJString(accessToken))
  add(query_598326, "uploadType", newJString(uploadType))
  add(path_598325, "id", newJString(id))
  add(query_598326, "key", newJString(key))
  add(path_598325, "courseId", newJString(courseId))
  add(query_598326, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598327 = body
  add(query_598326, "prettyPrint", newJBool(prettyPrint))
  result = call_598324.call(path_598325, query_598326, nil, nil, body_598327)

var classroomCoursesCourseWorkStudentSubmissionsModifyAttachments* = Call_ClassroomCoursesCourseWorkStudentSubmissionsModifyAttachments_598305(
    name: "classroomCoursesCourseWorkStudentSubmissionsModifyAttachments",
    meth: HttpMethod.HttpPost, host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork/{courseWorkId}/studentSubmissions/{id}:modifyAttachments", validator: validate_ClassroomCoursesCourseWorkStudentSubmissionsModifyAttachments_598306,
    base: "/",
    url: url_ClassroomCoursesCourseWorkStudentSubmissionsModifyAttachments_598307,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkStudentSubmissionsReclaim_598328 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesCourseWorkStudentSubmissionsReclaim_598330(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomCoursesCourseWorkStudentSubmissionsReclaim_598329(
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
  var valid_598331 = path.getOrDefault("courseWorkId")
  valid_598331 = validateParameter(valid_598331, JString, required = true,
                                 default = nil)
  if valid_598331 != nil:
    section.add "courseWorkId", valid_598331
  var valid_598332 = path.getOrDefault("id")
  valid_598332 = validateParameter(valid_598332, JString, required = true,
                                 default = nil)
  if valid_598332 != nil:
    section.add "id", valid_598332
  var valid_598333 = path.getOrDefault("courseId")
  valid_598333 = validateParameter(valid_598333, JString, required = true,
                                 default = nil)
  if valid_598333 != nil:
    section.add "courseId", valid_598333
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
  var valid_598334 = query.getOrDefault("upload_protocol")
  valid_598334 = validateParameter(valid_598334, JString, required = false,
                                 default = nil)
  if valid_598334 != nil:
    section.add "upload_protocol", valid_598334
  var valid_598335 = query.getOrDefault("fields")
  valid_598335 = validateParameter(valid_598335, JString, required = false,
                                 default = nil)
  if valid_598335 != nil:
    section.add "fields", valid_598335
  var valid_598336 = query.getOrDefault("quotaUser")
  valid_598336 = validateParameter(valid_598336, JString, required = false,
                                 default = nil)
  if valid_598336 != nil:
    section.add "quotaUser", valid_598336
  var valid_598337 = query.getOrDefault("alt")
  valid_598337 = validateParameter(valid_598337, JString, required = false,
                                 default = newJString("json"))
  if valid_598337 != nil:
    section.add "alt", valid_598337
  var valid_598338 = query.getOrDefault("oauth_token")
  valid_598338 = validateParameter(valid_598338, JString, required = false,
                                 default = nil)
  if valid_598338 != nil:
    section.add "oauth_token", valid_598338
  var valid_598339 = query.getOrDefault("callback")
  valid_598339 = validateParameter(valid_598339, JString, required = false,
                                 default = nil)
  if valid_598339 != nil:
    section.add "callback", valid_598339
  var valid_598340 = query.getOrDefault("access_token")
  valid_598340 = validateParameter(valid_598340, JString, required = false,
                                 default = nil)
  if valid_598340 != nil:
    section.add "access_token", valid_598340
  var valid_598341 = query.getOrDefault("uploadType")
  valid_598341 = validateParameter(valid_598341, JString, required = false,
                                 default = nil)
  if valid_598341 != nil:
    section.add "uploadType", valid_598341
  var valid_598342 = query.getOrDefault("key")
  valid_598342 = validateParameter(valid_598342, JString, required = false,
                                 default = nil)
  if valid_598342 != nil:
    section.add "key", valid_598342
  var valid_598343 = query.getOrDefault("$.xgafv")
  valid_598343 = validateParameter(valid_598343, JString, required = false,
                                 default = newJString("1"))
  if valid_598343 != nil:
    section.add "$.xgafv", valid_598343
  var valid_598344 = query.getOrDefault("prettyPrint")
  valid_598344 = validateParameter(valid_598344, JBool, required = false,
                                 default = newJBool(true))
  if valid_598344 != nil:
    section.add "prettyPrint", valid_598344
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

proc call*(call_598346: Call_ClassroomCoursesCourseWorkStudentSubmissionsReclaim_598328;
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
  let valid = call_598346.validator(path, query, header, formData, body)
  let scheme = call_598346.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598346.url(scheme.get, call_598346.host, call_598346.base,
                         call_598346.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598346, url, valid)

proc call*(call_598347: Call_ClassroomCoursesCourseWorkStudentSubmissionsReclaim_598328;
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
  var path_598348 = newJObject()
  var query_598349 = newJObject()
  var body_598350 = newJObject()
  add(query_598349, "upload_protocol", newJString(uploadProtocol))
  add(query_598349, "fields", newJString(fields))
  add(query_598349, "quotaUser", newJString(quotaUser))
  add(path_598348, "courseWorkId", newJString(courseWorkId))
  add(query_598349, "alt", newJString(alt))
  add(query_598349, "oauth_token", newJString(oauthToken))
  add(query_598349, "callback", newJString(callback))
  add(query_598349, "access_token", newJString(accessToken))
  add(query_598349, "uploadType", newJString(uploadType))
  add(path_598348, "id", newJString(id))
  add(query_598349, "key", newJString(key))
  add(path_598348, "courseId", newJString(courseId))
  add(query_598349, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598350 = body
  add(query_598349, "prettyPrint", newJBool(prettyPrint))
  result = call_598347.call(path_598348, query_598349, nil, nil, body_598350)

var classroomCoursesCourseWorkStudentSubmissionsReclaim* = Call_ClassroomCoursesCourseWorkStudentSubmissionsReclaim_598328(
    name: "classroomCoursesCourseWorkStudentSubmissionsReclaim",
    meth: HttpMethod.HttpPost, host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork/{courseWorkId}/studentSubmissions/{id}:reclaim",
    validator: validate_ClassroomCoursesCourseWorkStudentSubmissionsReclaim_598329,
    base: "/", url: url_ClassroomCoursesCourseWorkStudentSubmissionsReclaim_598330,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkStudentSubmissionsReturn_598351 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesCourseWorkStudentSubmissionsReturn_598353(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomCoursesCourseWorkStudentSubmissionsReturn_598352(
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
  var valid_598354 = path.getOrDefault("courseWorkId")
  valid_598354 = validateParameter(valid_598354, JString, required = true,
                                 default = nil)
  if valid_598354 != nil:
    section.add "courseWorkId", valid_598354
  var valid_598355 = path.getOrDefault("id")
  valid_598355 = validateParameter(valid_598355, JString, required = true,
                                 default = nil)
  if valid_598355 != nil:
    section.add "id", valid_598355
  var valid_598356 = path.getOrDefault("courseId")
  valid_598356 = validateParameter(valid_598356, JString, required = true,
                                 default = nil)
  if valid_598356 != nil:
    section.add "courseId", valid_598356
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
  var valid_598357 = query.getOrDefault("upload_protocol")
  valid_598357 = validateParameter(valid_598357, JString, required = false,
                                 default = nil)
  if valid_598357 != nil:
    section.add "upload_protocol", valid_598357
  var valid_598358 = query.getOrDefault("fields")
  valid_598358 = validateParameter(valid_598358, JString, required = false,
                                 default = nil)
  if valid_598358 != nil:
    section.add "fields", valid_598358
  var valid_598359 = query.getOrDefault("quotaUser")
  valid_598359 = validateParameter(valid_598359, JString, required = false,
                                 default = nil)
  if valid_598359 != nil:
    section.add "quotaUser", valid_598359
  var valid_598360 = query.getOrDefault("alt")
  valid_598360 = validateParameter(valid_598360, JString, required = false,
                                 default = newJString("json"))
  if valid_598360 != nil:
    section.add "alt", valid_598360
  var valid_598361 = query.getOrDefault("oauth_token")
  valid_598361 = validateParameter(valid_598361, JString, required = false,
                                 default = nil)
  if valid_598361 != nil:
    section.add "oauth_token", valid_598361
  var valid_598362 = query.getOrDefault("callback")
  valid_598362 = validateParameter(valid_598362, JString, required = false,
                                 default = nil)
  if valid_598362 != nil:
    section.add "callback", valid_598362
  var valid_598363 = query.getOrDefault("access_token")
  valid_598363 = validateParameter(valid_598363, JString, required = false,
                                 default = nil)
  if valid_598363 != nil:
    section.add "access_token", valid_598363
  var valid_598364 = query.getOrDefault("uploadType")
  valid_598364 = validateParameter(valid_598364, JString, required = false,
                                 default = nil)
  if valid_598364 != nil:
    section.add "uploadType", valid_598364
  var valid_598365 = query.getOrDefault("key")
  valid_598365 = validateParameter(valid_598365, JString, required = false,
                                 default = nil)
  if valid_598365 != nil:
    section.add "key", valid_598365
  var valid_598366 = query.getOrDefault("$.xgafv")
  valid_598366 = validateParameter(valid_598366, JString, required = false,
                                 default = newJString("1"))
  if valid_598366 != nil:
    section.add "$.xgafv", valid_598366
  var valid_598367 = query.getOrDefault("prettyPrint")
  valid_598367 = validateParameter(valid_598367, JBool, required = false,
                                 default = newJBool(true))
  if valid_598367 != nil:
    section.add "prettyPrint", valid_598367
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

proc call*(call_598369: Call_ClassroomCoursesCourseWorkStudentSubmissionsReturn_598351;
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
  let valid = call_598369.validator(path, query, header, formData, body)
  let scheme = call_598369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598369.url(scheme.get, call_598369.host, call_598369.base,
                         call_598369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598369, url, valid)

proc call*(call_598370: Call_ClassroomCoursesCourseWorkStudentSubmissionsReturn_598351;
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
  var path_598371 = newJObject()
  var query_598372 = newJObject()
  var body_598373 = newJObject()
  add(query_598372, "upload_protocol", newJString(uploadProtocol))
  add(query_598372, "fields", newJString(fields))
  add(query_598372, "quotaUser", newJString(quotaUser))
  add(path_598371, "courseWorkId", newJString(courseWorkId))
  add(query_598372, "alt", newJString(alt))
  add(query_598372, "oauth_token", newJString(oauthToken))
  add(query_598372, "callback", newJString(callback))
  add(query_598372, "access_token", newJString(accessToken))
  add(query_598372, "uploadType", newJString(uploadType))
  add(path_598371, "id", newJString(id))
  add(query_598372, "key", newJString(key))
  add(path_598371, "courseId", newJString(courseId))
  add(query_598372, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598373 = body
  add(query_598372, "prettyPrint", newJBool(prettyPrint))
  result = call_598370.call(path_598371, query_598372, nil, nil, body_598373)

var classroomCoursesCourseWorkStudentSubmissionsReturn* = Call_ClassroomCoursesCourseWorkStudentSubmissionsReturn_598351(
    name: "classroomCoursesCourseWorkStudentSubmissionsReturn",
    meth: HttpMethod.HttpPost, host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork/{courseWorkId}/studentSubmissions/{id}:return",
    validator: validate_ClassroomCoursesCourseWorkStudentSubmissionsReturn_598352,
    base: "/", url: url_ClassroomCoursesCourseWorkStudentSubmissionsReturn_598353,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkStudentSubmissionsTurnIn_598374 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesCourseWorkStudentSubmissionsTurnIn_598376(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomCoursesCourseWorkStudentSubmissionsTurnIn_598375(
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
  var valid_598377 = path.getOrDefault("courseWorkId")
  valid_598377 = validateParameter(valid_598377, JString, required = true,
                                 default = nil)
  if valid_598377 != nil:
    section.add "courseWorkId", valid_598377
  var valid_598378 = path.getOrDefault("id")
  valid_598378 = validateParameter(valid_598378, JString, required = true,
                                 default = nil)
  if valid_598378 != nil:
    section.add "id", valid_598378
  var valid_598379 = path.getOrDefault("courseId")
  valid_598379 = validateParameter(valid_598379, JString, required = true,
                                 default = nil)
  if valid_598379 != nil:
    section.add "courseId", valid_598379
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
  var valid_598380 = query.getOrDefault("upload_protocol")
  valid_598380 = validateParameter(valid_598380, JString, required = false,
                                 default = nil)
  if valid_598380 != nil:
    section.add "upload_protocol", valid_598380
  var valid_598381 = query.getOrDefault("fields")
  valid_598381 = validateParameter(valid_598381, JString, required = false,
                                 default = nil)
  if valid_598381 != nil:
    section.add "fields", valid_598381
  var valid_598382 = query.getOrDefault("quotaUser")
  valid_598382 = validateParameter(valid_598382, JString, required = false,
                                 default = nil)
  if valid_598382 != nil:
    section.add "quotaUser", valid_598382
  var valid_598383 = query.getOrDefault("alt")
  valid_598383 = validateParameter(valid_598383, JString, required = false,
                                 default = newJString("json"))
  if valid_598383 != nil:
    section.add "alt", valid_598383
  var valid_598384 = query.getOrDefault("oauth_token")
  valid_598384 = validateParameter(valid_598384, JString, required = false,
                                 default = nil)
  if valid_598384 != nil:
    section.add "oauth_token", valid_598384
  var valid_598385 = query.getOrDefault("callback")
  valid_598385 = validateParameter(valid_598385, JString, required = false,
                                 default = nil)
  if valid_598385 != nil:
    section.add "callback", valid_598385
  var valid_598386 = query.getOrDefault("access_token")
  valid_598386 = validateParameter(valid_598386, JString, required = false,
                                 default = nil)
  if valid_598386 != nil:
    section.add "access_token", valid_598386
  var valid_598387 = query.getOrDefault("uploadType")
  valid_598387 = validateParameter(valid_598387, JString, required = false,
                                 default = nil)
  if valid_598387 != nil:
    section.add "uploadType", valid_598387
  var valid_598388 = query.getOrDefault("key")
  valid_598388 = validateParameter(valid_598388, JString, required = false,
                                 default = nil)
  if valid_598388 != nil:
    section.add "key", valid_598388
  var valid_598389 = query.getOrDefault("$.xgafv")
  valid_598389 = validateParameter(valid_598389, JString, required = false,
                                 default = newJString("1"))
  if valid_598389 != nil:
    section.add "$.xgafv", valid_598389
  var valid_598390 = query.getOrDefault("prettyPrint")
  valid_598390 = validateParameter(valid_598390, JBool, required = false,
                                 default = newJBool(true))
  if valid_598390 != nil:
    section.add "prettyPrint", valid_598390
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

proc call*(call_598392: Call_ClassroomCoursesCourseWorkStudentSubmissionsTurnIn_598374;
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
  let valid = call_598392.validator(path, query, header, formData, body)
  let scheme = call_598392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598392.url(scheme.get, call_598392.host, call_598392.base,
                         call_598392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598392, url, valid)

proc call*(call_598393: Call_ClassroomCoursesCourseWorkStudentSubmissionsTurnIn_598374;
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
  var path_598394 = newJObject()
  var query_598395 = newJObject()
  var body_598396 = newJObject()
  add(query_598395, "upload_protocol", newJString(uploadProtocol))
  add(query_598395, "fields", newJString(fields))
  add(query_598395, "quotaUser", newJString(quotaUser))
  add(path_598394, "courseWorkId", newJString(courseWorkId))
  add(query_598395, "alt", newJString(alt))
  add(query_598395, "oauth_token", newJString(oauthToken))
  add(query_598395, "callback", newJString(callback))
  add(query_598395, "access_token", newJString(accessToken))
  add(query_598395, "uploadType", newJString(uploadType))
  add(path_598394, "id", newJString(id))
  add(query_598395, "key", newJString(key))
  add(path_598394, "courseId", newJString(courseId))
  add(query_598395, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598396 = body
  add(query_598395, "prettyPrint", newJBool(prettyPrint))
  result = call_598393.call(path_598394, query_598395, nil, nil, body_598396)

var classroomCoursesCourseWorkStudentSubmissionsTurnIn* = Call_ClassroomCoursesCourseWorkStudentSubmissionsTurnIn_598374(
    name: "classroomCoursesCourseWorkStudentSubmissionsTurnIn",
    meth: HttpMethod.HttpPost, host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/courseWork/{courseWorkId}/studentSubmissions/{id}:turnIn",
    validator: validate_ClassroomCoursesCourseWorkStudentSubmissionsTurnIn_598375,
    base: "/", url: url_ClassroomCoursesCourseWorkStudentSubmissionsTurnIn_598376,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkGet_598397 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesCourseWorkGet_598399(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomCoursesCourseWorkGet_598398(path: JsonNode; query: JsonNode;
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
  var valid_598400 = path.getOrDefault("id")
  valid_598400 = validateParameter(valid_598400, JString, required = true,
                                 default = nil)
  if valid_598400 != nil:
    section.add "id", valid_598400
  var valid_598401 = path.getOrDefault("courseId")
  valid_598401 = validateParameter(valid_598401, JString, required = true,
                                 default = nil)
  if valid_598401 != nil:
    section.add "courseId", valid_598401
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
  var valid_598402 = query.getOrDefault("upload_protocol")
  valid_598402 = validateParameter(valid_598402, JString, required = false,
                                 default = nil)
  if valid_598402 != nil:
    section.add "upload_protocol", valid_598402
  var valid_598403 = query.getOrDefault("fields")
  valid_598403 = validateParameter(valid_598403, JString, required = false,
                                 default = nil)
  if valid_598403 != nil:
    section.add "fields", valid_598403
  var valid_598404 = query.getOrDefault("quotaUser")
  valid_598404 = validateParameter(valid_598404, JString, required = false,
                                 default = nil)
  if valid_598404 != nil:
    section.add "quotaUser", valid_598404
  var valid_598405 = query.getOrDefault("alt")
  valid_598405 = validateParameter(valid_598405, JString, required = false,
                                 default = newJString("json"))
  if valid_598405 != nil:
    section.add "alt", valid_598405
  var valid_598406 = query.getOrDefault("oauth_token")
  valid_598406 = validateParameter(valid_598406, JString, required = false,
                                 default = nil)
  if valid_598406 != nil:
    section.add "oauth_token", valid_598406
  var valid_598407 = query.getOrDefault("callback")
  valid_598407 = validateParameter(valid_598407, JString, required = false,
                                 default = nil)
  if valid_598407 != nil:
    section.add "callback", valid_598407
  var valid_598408 = query.getOrDefault("access_token")
  valid_598408 = validateParameter(valid_598408, JString, required = false,
                                 default = nil)
  if valid_598408 != nil:
    section.add "access_token", valid_598408
  var valid_598409 = query.getOrDefault("uploadType")
  valid_598409 = validateParameter(valid_598409, JString, required = false,
                                 default = nil)
  if valid_598409 != nil:
    section.add "uploadType", valid_598409
  var valid_598410 = query.getOrDefault("key")
  valid_598410 = validateParameter(valid_598410, JString, required = false,
                                 default = nil)
  if valid_598410 != nil:
    section.add "key", valid_598410
  var valid_598411 = query.getOrDefault("$.xgafv")
  valid_598411 = validateParameter(valid_598411, JString, required = false,
                                 default = newJString("1"))
  if valid_598411 != nil:
    section.add "$.xgafv", valid_598411
  var valid_598412 = query.getOrDefault("prettyPrint")
  valid_598412 = validateParameter(valid_598412, JBool, required = false,
                                 default = newJBool(true))
  if valid_598412 != nil:
    section.add "prettyPrint", valid_598412
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598413: Call_ClassroomCoursesCourseWorkGet_598397; path: JsonNode;
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
  let valid = call_598413.validator(path, query, header, formData, body)
  let scheme = call_598413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598413.url(scheme.get, call_598413.host, call_598413.base,
                         call_598413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598413, url, valid)

proc call*(call_598414: Call_ClassroomCoursesCourseWorkGet_598397; id: string;
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
  var path_598415 = newJObject()
  var query_598416 = newJObject()
  add(query_598416, "upload_protocol", newJString(uploadProtocol))
  add(query_598416, "fields", newJString(fields))
  add(query_598416, "quotaUser", newJString(quotaUser))
  add(query_598416, "alt", newJString(alt))
  add(query_598416, "oauth_token", newJString(oauthToken))
  add(query_598416, "callback", newJString(callback))
  add(query_598416, "access_token", newJString(accessToken))
  add(query_598416, "uploadType", newJString(uploadType))
  add(path_598415, "id", newJString(id))
  add(query_598416, "key", newJString(key))
  add(path_598415, "courseId", newJString(courseId))
  add(query_598416, "$.xgafv", newJString(Xgafv))
  add(query_598416, "prettyPrint", newJBool(prettyPrint))
  result = call_598414.call(path_598415, query_598416, nil, nil, nil)

var classroomCoursesCourseWorkGet* = Call_ClassroomCoursesCourseWorkGet_598397(
    name: "classroomCoursesCourseWorkGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/courseWork/{id}",
    validator: validate_ClassroomCoursesCourseWorkGet_598398, base: "/",
    url: url_ClassroomCoursesCourseWorkGet_598399, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkPatch_598437 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesCourseWorkPatch_598439(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomCoursesCourseWorkPatch_598438(path: JsonNode;
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
  var valid_598440 = path.getOrDefault("id")
  valid_598440 = validateParameter(valid_598440, JString, required = true,
                                 default = nil)
  if valid_598440 != nil:
    section.add "id", valid_598440
  var valid_598441 = path.getOrDefault("courseId")
  valid_598441 = validateParameter(valid_598441, JString, required = true,
                                 default = nil)
  if valid_598441 != nil:
    section.add "courseId", valid_598441
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
  var valid_598442 = query.getOrDefault("upload_protocol")
  valid_598442 = validateParameter(valid_598442, JString, required = false,
                                 default = nil)
  if valid_598442 != nil:
    section.add "upload_protocol", valid_598442
  var valid_598443 = query.getOrDefault("fields")
  valid_598443 = validateParameter(valid_598443, JString, required = false,
                                 default = nil)
  if valid_598443 != nil:
    section.add "fields", valid_598443
  var valid_598444 = query.getOrDefault("quotaUser")
  valid_598444 = validateParameter(valid_598444, JString, required = false,
                                 default = nil)
  if valid_598444 != nil:
    section.add "quotaUser", valid_598444
  var valid_598445 = query.getOrDefault("alt")
  valid_598445 = validateParameter(valid_598445, JString, required = false,
                                 default = newJString("json"))
  if valid_598445 != nil:
    section.add "alt", valid_598445
  var valid_598446 = query.getOrDefault("oauth_token")
  valid_598446 = validateParameter(valid_598446, JString, required = false,
                                 default = nil)
  if valid_598446 != nil:
    section.add "oauth_token", valid_598446
  var valid_598447 = query.getOrDefault("callback")
  valid_598447 = validateParameter(valid_598447, JString, required = false,
                                 default = nil)
  if valid_598447 != nil:
    section.add "callback", valid_598447
  var valid_598448 = query.getOrDefault("access_token")
  valid_598448 = validateParameter(valid_598448, JString, required = false,
                                 default = nil)
  if valid_598448 != nil:
    section.add "access_token", valid_598448
  var valid_598449 = query.getOrDefault("uploadType")
  valid_598449 = validateParameter(valid_598449, JString, required = false,
                                 default = nil)
  if valid_598449 != nil:
    section.add "uploadType", valid_598449
  var valid_598450 = query.getOrDefault("key")
  valid_598450 = validateParameter(valid_598450, JString, required = false,
                                 default = nil)
  if valid_598450 != nil:
    section.add "key", valid_598450
  var valid_598451 = query.getOrDefault("$.xgafv")
  valid_598451 = validateParameter(valid_598451, JString, required = false,
                                 default = newJString("1"))
  if valid_598451 != nil:
    section.add "$.xgafv", valid_598451
  var valid_598452 = query.getOrDefault("prettyPrint")
  valid_598452 = validateParameter(valid_598452, JBool, required = false,
                                 default = newJBool(true))
  if valid_598452 != nil:
    section.add "prettyPrint", valid_598452
  var valid_598453 = query.getOrDefault("updateMask")
  valid_598453 = validateParameter(valid_598453, JString, required = false,
                                 default = nil)
  if valid_598453 != nil:
    section.add "updateMask", valid_598453
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

proc call*(call_598455: Call_ClassroomCoursesCourseWorkPatch_598437;
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
  let valid = call_598455.validator(path, query, header, formData, body)
  let scheme = call_598455.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598455.url(scheme.get, call_598455.host, call_598455.base,
                         call_598455.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598455, url, valid)

proc call*(call_598456: Call_ClassroomCoursesCourseWorkPatch_598437; id: string;
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
  var path_598457 = newJObject()
  var query_598458 = newJObject()
  var body_598459 = newJObject()
  add(query_598458, "upload_protocol", newJString(uploadProtocol))
  add(query_598458, "fields", newJString(fields))
  add(query_598458, "quotaUser", newJString(quotaUser))
  add(query_598458, "alt", newJString(alt))
  add(query_598458, "oauth_token", newJString(oauthToken))
  add(query_598458, "callback", newJString(callback))
  add(query_598458, "access_token", newJString(accessToken))
  add(query_598458, "uploadType", newJString(uploadType))
  add(path_598457, "id", newJString(id))
  add(query_598458, "key", newJString(key))
  add(path_598457, "courseId", newJString(courseId))
  add(query_598458, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598459 = body
  add(query_598458, "prettyPrint", newJBool(prettyPrint))
  add(query_598458, "updateMask", newJString(updateMask))
  result = call_598456.call(path_598457, query_598458, nil, nil, body_598459)

var classroomCoursesCourseWorkPatch* = Call_ClassroomCoursesCourseWorkPatch_598437(
    name: "classroomCoursesCourseWorkPatch", meth: HttpMethod.HttpPatch,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/courseWork/{id}",
    validator: validate_ClassroomCoursesCourseWorkPatch_598438, base: "/",
    url: url_ClassroomCoursesCourseWorkPatch_598439, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkDelete_598417 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesCourseWorkDelete_598419(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomCoursesCourseWorkDelete_598418(path: JsonNode;
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
  var valid_598420 = path.getOrDefault("id")
  valid_598420 = validateParameter(valid_598420, JString, required = true,
                                 default = nil)
  if valid_598420 != nil:
    section.add "id", valid_598420
  var valid_598421 = path.getOrDefault("courseId")
  valid_598421 = validateParameter(valid_598421, JString, required = true,
                                 default = nil)
  if valid_598421 != nil:
    section.add "courseId", valid_598421
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
  var valid_598422 = query.getOrDefault("upload_protocol")
  valid_598422 = validateParameter(valid_598422, JString, required = false,
                                 default = nil)
  if valid_598422 != nil:
    section.add "upload_protocol", valid_598422
  var valid_598423 = query.getOrDefault("fields")
  valid_598423 = validateParameter(valid_598423, JString, required = false,
                                 default = nil)
  if valid_598423 != nil:
    section.add "fields", valid_598423
  var valid_598424 = query.getOrDefault("quotaUser")
  valid_598424 = validateParameter(valid_598424, JString, required = false,
                                 default = nil)
  if valid_598424 != nil:
    section.add "quotaUser", valid_598424
  var valid_598425 = query.getOrDefault("alt")
  valid_598425 = validateParameter(valid_598425, JString, required = false,
                                 default = newJString("json"))
  if valid_598425 != nil:
    section.add "alt", valid_598425
  var valid_598426 = query.getOrDefault("oauth_token")
  valid_598426 = validateParameter(valid_598426, JString, required = false,
                                 default = nil)
  if valid_598426 != nil:
    section.add "oauth_token", valid_598426
  var valid_598427 = query.getOrDefault("callback")
  valid_598427 = validateParameter(valid_598427, JString, required = false,
                                 default = nil)
  if valid_598427 != nil:
    section.add "callback", valid_598427
  var valid_598428 = query.getOrDefault("access_token")
  valid_598428 = validateParameter(valid_598428, JString, required = false,
                                 default = nil)
  if valid_598428 != nil:
    section.add "access_token", valid_598428
  var valid_598429 = query.getOrDefault("uploadType")
  valid_598429 = validateParameter(valid_598429, JString, required = false,
                                 default = nil)
  if valid_598429 != nil:
    section.add "uploadType", valid_598429
  var valid_598430 = query.getOrDefault("key")
  valid_598430 = validateParameter(valid_598430, JString, required = false,
                                 default = nil)
  if valid_598430 != nil:
    section.add "key", valid_598430
  var valid_598431 = query.getOrDefault("$.xgafv")
  valid_598431 = validateParameter(valid_598431, JString, required = false,
                                 default = newJString("1"))
  if valid_598431 != nil:
    section.add "$.xgafv", valid_598431
  var valid_598432 = query.getOrDefault("prettyPrint")
  valid_598432 = validateParameter(valid_598432, JBool, required = false,
                                 default = newJBool(true))
  if valid_598432 != nil:
    section.add "prettyPrint", valid_598432
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598433: Call_ClassroomCoursesCourseWorkDelete_598417;
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
  let valid = call_598433.validator(path, query, header, formData, body)
  let scheme = call_598433.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598433.url(scheme.get, call_598433.host, call_598433.base,
                         call_598433.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598433, url, valid)

proc call*(call_598434: Call_ClassroomCoursesCourseWorkDelete_598417; id: string;
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
  var path_598435 = newJObject()
  var query_598436 = newJObject()
  add(query_598436, "upload_protocol", newJString(uploadProtocol))
  add(query_598436, "fields", newJString(fields))
  add(query_598436, "quotaUser", newJString(quotaUser))
  add(query_598436, "alt", newJString(alt))
  add(query_598436, "oauth_token", newJString(oauthToken))
  add(query_598436, "callback", newJString(callback))
  add(query_598436, "access_token", newJString(accessToken))
  add(query_598436, "uploadType", newJString(uploadType))
  add(path_598435, "id", newJString(id))
  add(query_598436, "key", newJString(key))
  add(path_598435, "courseId", newJString(courseId))
  add(query_598436, "$.xgafv", newJString(Xgafv))
  add(query_598436, "prettyPrint", newJBool(prettyPrint))
  result = call_598434.call(path_598435, query_598436, nil, nil, nil)

var classroomCoursesCourseWorkDelete* = Call_ClassroomCoursesCourseWorkDelete_598417(
    name: "classroomCoursesCourseWorkDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/courseWork/{id}",
    validator: validate_ClassroomCoursesCourseWorkDelete_598418, base: "/",
    url: url_ClassroomCoursesCourseWorkDelete_598419, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesCourseWorkModifyAssignees_598460 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesCourseWorkModifyAssignees_598462(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomCoursesCourseWorkModifyAssignees_598461(path: JsonNode;
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
  var valid_598463 = path.getOrDefault("id")
  valid_598463 = validateParameter(valid_598463, JString, required = true,
                                 default = nil)
  if valid_598463 != nil:
    section.add "id", valid_598463
  var valid_598464 = path.getOrDefault("courseId")
  valid_598464 = validateParameter(valid_598464, JString, required = true,
                                 default = nil)
  if valid_598464 != nil:
    section.add "courseId", valid_598464
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
  var valid_598465 = query.getOrDefault("upload_protocol")
  valid_598465 = validateParameter(valid_598465, JString, required = false,
                                 default = nil)
  if valid_598465 != nil:
    section.add "upload_protocol", valid_598465
  var valid_598466 = query.getOrDefault("fields")
  valid_598466 = validateParameter(valid_598466, JString, required = false,
                                 default = nil)
  if valid_598466 != nil:
    section.add "fields", valid_598466
  var valid_598467 = query.getOrDefault("quotaUser")
  valid_598467 = validateParameter(valid_598467, JString, required = false,
                                 default = nil)
  if valid_598467 != nil:
    section.add "quotaUser", valid_598467
  var valid_598468 = query.getOrDefault("alt")
  valid_598468 = validateParameter(valid_598468, JString, required = false,
                                 default = newJString("json"))
  if valid_598468 != nil:
    section.add "alt", valid_598468
  var valid_598469 = query.getOrDefault("oauth_token")
  valid_598469 = validateParameter(valid_598469, JString, required = false,
                                 default = nil)
  if valid_598469 != nil:
    section.add "oauth_token", valid_598469
  var valid_598470 = query.getOrDefault("callback")
  valid_598470 = validateParameter(valid_598470, JString, required = false,
                                 default = nil)
  if valid_598470 != nil:
    section.add "callback", valid_598470
  var valid_598471 = query.getOrDefault("access_token")
  valid_598471 = validateParameter(valid_598471, JString, required = false,
                                 default = nil)
  if valid_598471 != nil:
    section.add "access_token", valid_598471
  var valid_598472 = query.getOrDefault("uploadType")
  valid_598472 = validateParameter(valid_598472, JString, required = false,
                                 default = nil)
  if valid_598472 != nil:
    section.add "uploadType", valid_598472
  var valid_598473 = query.getOrDefault("key")
  valid_598473 = validateParameter(valid_598473, JString, required = false,
                                 default = nil)
  if valid_598473 != nil:
    section.add "key", valid_598473
  var valid_598474 = query.getOrDefault("$.xgafv")
  valid_598474 = validateParameter(valid_598474, JString, required = false,
                                 default = newJString("1"))
  if valid_598474 != nil:
    section.add "$.xgafv", valid_598474
  var valid_598475 = query.getOrDefault("prettyPrint")
  valid_598475 = validateParameter(valid_598475, JBool, required = false,
                                 default = newJBool(true))
  if valid_598475 != nil:
    section.add "prettyPrint", valid_598475
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

proc call*(call_598477: Call_ClassroomCoursesCourseWorkModifyAssignees_598460;
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
  let valid = call_598477.validator(path, query, header, formData, body)
  let scheme = call_598477.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598477.url(scheme.get, call_598477.host, call_598477.base,
                         call_598477.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598477, url, valid)

proc call*(call_598478: Call_ClassroomCoursesCourseWorkModifyAssignees_598460;
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
  var path_598479 = newJObject()
  var query_598480 = newJObject()
  var body_598481 = newJObject()
  add(query_598480, "upload_protocol", newJString(uploadProtocol))
  add(query_598480, "fields", newJString(fields))
  add(query_598480, "quotaUser", newJString(quotaUser))
  add(query_598480, "alt", newJString(alt))
  add(query_598480, "oauth_token", newJString(oauthToken))
  add(query_598480, "callback", newJString(callback))
  add(query_598480, "access_token", newJString(accessToken))
  add(query_598480, "uploadType", newJString(uploadType))
  add(path_598479, "id", newJString(id))
  add(query_598480, "key", newJString(key))
  add(path_598479, "courseId", newJString(courseId))
  add(query_598480, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598481 = body
  add(query_598480, "prettyPrint", newJBool(prettyPrint))
  result = call_598478.call(path_598479, query_598480, nil, nil, body_598481)

var classroomCoursesCourseWorkModifyAssignees* = Call_ClassroomCoursesCourseWorkModifyAssignees_598460(
    name: "classroomCoursesCourseWorkModifyAssignees", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/courseWork/{id}:modifyAssignees",
    validator: validate_ClassroomCoursesCourseWorkModifyAssignees_598461,
    base: "/", url: url_ClassroomCoursesCourseWorkModifyAssignees_598462,
    schemes: {Scheme.Https})
type
  Call_ClassroomCoursesStudentsCreate_598503 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesStudentsCreate_598505(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomCoursesStudentsCreate_598504(path: JsonNode;
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
  var valid_598506 = path.getOrDefault("courseId")
  valid_598506 = validateParameter(valid_598506, JString, required = true,
                                 default = nil)
  if valid_598506 != nil:
    section.add "courseId", valid_598506
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
  var valid_598507 = query.getOrDefault("upload_protocol")
  valid_598507 = validateParameter(valid_598507, JString, required = false,
                                 default = nil)
  if valid_598507 != nil:
    section.add "upload_protocol", valid_598507
  var valid_598508 = query.getOrDefault("fields")
  valid_598508 = validateParameter(valid_598508, JString, required = false,
                                 default = nil)
  if valid_598508 != nil:
    section.add "fields", valid_598508
  var valid_598509 = query.getOrDefault("quotaUser")
  valid_598509 = validateParameter(valid_598509, JString, required = false,
                                 default = nil)
  if valid_598509 != nil:
    section.add "quotaUser", valid_598509
  var valid_598510 = query.getOrDefault("alt")
  valid_598510 = validateParameter(valid_598510, JString, required = false,
                                 default = newJString("json"))
  if valid_598510 != nil:
    section.add "alt", valid_598510
  var valid_598511 = query.getOrDefault("oauth_token")
  valid_598511 = validateParameter(valid_598511, JString, required = false,
                                 default = nil)
  if valid_598511 != nil:
    section.add "oauth_token", valid_598511
  var valid_598512 = query.getOrDefault("callback")
  valid_598512 = validateParameter(valid_598512, JString, required = false,
                                 default = nil)
  if valid_598512 != nil:
    section.add "callback", valid_598512
  var valid_598513 = query.getOrDefault("access_token")
  valid_598513 = validateParameter(valid_598513, JString, required = false,
                                 default = nil)
  if valid_598513 != nil:
    section.add "access_token", valid_598513
  var valid_598514 = query.getOrDefault("uploadType")
  valid_598514 = validateParameter(valid_598514, JString, required = false,
                                 default = nil)
  if valid_598514 != nil:
    section.add "uploadType", valid_598514
  var valid_598515 = query.getOrDefault("enrollmentCode")
  valid_598515 = validateParameter(valid_598515, JString, required = false,
                                 default = nil)
  if valid_598515 != nil:
    section.add "enrollmentCode", valid_598515
  var valid_598516 = query.getOrDefault("key")
  valid_598516 = validateParameter(valid_598516, JString, required = false,
                                 default = nil)
  if valid_598516 != nil:
    section.add "key", valid_598516
  var valid_598517 = query.getOrDefault("$.xgafv")
  valid_598517 = validateParameter(valid_598517, JString, required = false,
                                 default = newJString("1"))
  if valid_598517 != nil:
    section.add "$.xgafv", valid_598517
  var valid_598518 = query.getOrDefault("prettyPrint")
  valid_598518 = validateParameter(valid_598518, JBool, required = false,
                                 default = newJBool(true))
  if valid_598518 != nil:
    section.add "prettyPrint", valid_598518
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

proc call*(call_598520: Call_ClassroomCoursesStudentsCreate_598503; path: JsonNode;
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
  let valid = call_598520.validator(path, query, header, formData, body)
  let scheme = call_598520.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598520.url(scheme.get, call_598520.host, call_598520.base,
                         call_598520.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598520, url, valid)

proc call*(call_598521: Call_ClassroomCoursesStudentsCreate_598503;
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
  var path_598522 = newJObject()
  var query_598523 = newJObject()
  var body_598524 = newJObject()
  add(query_598523, "upload_protocol", newJString(uploadProtocol))
  add(query_598523, "fields", newJString(fields))
  add(query_598523, "quotaUser", newJString(quotaUser))
  add(query_598523, "alt", newJString(alt))
  add(query_598523, "oauth_token", newJString(oauthToken))
  add(query_598523, "callback", newJString(callback))
  add(query_598523, "access_token", newJString(accessToken))
  add(query_598523, "uploadType", newJString(uploadType))
  add(query_598523, "enrollmentCode", newJString(enrollmentCode))
  add(query_598523, "key", newJString(key))
  add(path_598522, "courseId", newJString(courseId))
  add(query_598523, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598524 = body
  add(query_598523, "prettyPrint", newJBool(prettyPrint))
  result = call_598521.call(path_598522, query_598523, nil, nil, body_598524)

var classroomCoursesStudentsCreate* = Call_ClassroomCoursesStudentsCreate_598503(
    name: "classroomCoursesStudentsCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/students",
    validator: validate_ClassroomCoursesStudentsCreate_598504, base: "/",
    url: url_ClassroomCoursesStudentsCreate_598505, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesStudentsList_598482 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesStudentsList_598484(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomCoursesStudentsList_598483(path: JsonNode; query: JsonNode;
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
  var valid_598485 = path.getOrDefault("courseId")
  valid_598485 = validateParameter(valid_598485, JString, required = true,
                                 default = nil)
  if valid_598485 != nil:
    section.add "courseId", valid_598485
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
  var valid_598486 = query.getOrDefault("upload_protocol")
  valid_598486 = validateParameter(valid_598486, JString, required = false,
                                 default = nil)
  if valid_598486 != nil:
    section.add "upload_protocol", valid_598486
  var valid_598487 = query.getOrDefault("fields")
  valid_598487 = validateParameter(valid_598487, JString, required = false,
                                 default = nil)
  if valid_598487 != nil:
    section.add "fields", valid_598487
  var valid_598488 = query.getOrDefault("pageToken")
  valid_598488 = validateParameter(valid_598488, JString, required = false,
                                 default = nil)
  if valid_598488 != nil:
    section.add "pageToken", valid_598488
  var valid_598489 = query.getOrDefault("quotaUser")
  valid_598489 = validateParameter(valid_598489, JString, required = false,
                                 default = nil)
  if valid_598489 != nil:
    section.add "quotaUser", valid_598489
  var valid_598490 = query.getOrDefault("alt")
  valid_598490 = validateParameter(valid_598490, JString, required = false,
                                 default = newJString("json"))
  if valid_598490 != nil:
    section.add "alt", valid_598490
  var valid_598491 = query.getOrDefault("oauth_token")
  valid_598491 = validateParameter(valid_598491, JString, required = false,
                                 default = nil)
  if valid_598491 != nil:
    section.add "oauth_token", valid_598491
  var valid_598492 = query.getOrDefault("callback")
  valid_598492 = validateParameter(valid_598492, JString, required = false,
                                 default = nil)
  if valid_598492 != nil:
    section.add "callback", valid_598492
  var valid_598493 = query.getOrDefault("access_token")
  valid_598493 = validateParameter(valid_598493, JString, required = false,
                                 default = nil)
  if valid_598493 != nil:
    section.add "access_token", valid_598493
  var valid_598494 = query.getOrDefault("uploadType")
  valid_598494 = validateParameter(valid_598494, JString, required = false,
                                 default = nil)
  if valid_598494 != nil:
    section.add "uploadType", valid_598494
  var valid_598495 = query.getOrDefault("key")
  valid_598495 = validateParameter(valid_598495, JString, required = false,
                                 default = nil)
  if valid_598495 != nil:
    section.add "key", valid_598495
  var valid_598496 = query.getOrDefault("$.xgafv")
  valid_598496 = validateParameter(valid_598496, JString, required = false,
                                 default = newJString("1"))
  if valid_598496 != nil:
    section.add "$.xgafv", valid_598496
  var valid_598497 = query.getOrDefault("pageSize")
  valid_598497 = validateParameter(valid_598497, JInt, required = false, default = nil)
  if valid_598497 != nil:
    section.add "pageSize", valid_598497
  var valid_598498 = query.getOrDefault("prettyPrint")
  valid_598498 = validateParameter(valid_598498, JBool, required = false,
                                 default = newJBool(true))
  if valid_598498 != nil:
    section.add "prettyPrint", valid_598498
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598499: Call_ClassroomCoursesStudentsList_598482; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of students of this course that the requester
  ## is permitted to view.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `NOT_FOUND` if the course does not exist.
  ## * `PERMISSION_DENIED` for access errors.
  ## 
  let valid = call_598499.validator(path, query, header, formData, body)
  let scheme = call_598499.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598499.url(scheme.get, call_598499.host, call_598499.base,
                         call_598499.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598499, url, valid)

proc call*(call_598500: Call_ClassroomCoursesStudentsList_598482; courseId: string;
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
  var path_598501 = newJObject()
  var query_598502 = newJObject()
  add(query_598502, "upload_protocol", newJString(uploadProtocol))
  add(query_598502, "fields", newJString(fields))
  add(query_598502, "pageToken", newJString(pageToken))
  add(query_598502, "quotaUser", newJString(quotaUser))
  add(query_598502, "alt", newJString(alt))
  add(query_598502, "oauth_token", newJString(oauthToken))
  add(query_598502, "callback", newJString(callback))
  add(query_598502, "access_token", newJString(accessToken))
  add(query_598502, "uploadType", newJString(uploadType))
  add(query_598502, "key", newJString(key))
  add(path_598501, "courseId", newJString(courseId))
  add(query_598502, "$.xgafv", newJString(Xgafv))
  add(query_598502, "pageSize", newJInt(pageSize))
  add(query_598502, "prettyPrint", newJBool(prettyPrint))
  result = call_598500.call(path_598501, query_598502, nil, nil, nil)

var classroomCoursesStudentsList* = Call_ClassroomCoursesStudentsList_598482(
    name: "classroomCoursesStudentsList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/students",
    validator: validate_ClassroomCoursesStudentsList_598483, base: "/",
    url: url_ClassroomCoursesStudentsList_598484, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesStudentsGet_598525 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesStudentsGet_598527(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomCoursesStudentsGet_598526(path: JsonNode; query: JsonNode;
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
  var valid_598528 = path.getOrDefault("courseId")
  valid_598528 = validateParameter(valid_598528, JString, required = true,
                                 default = nil)
  if valid_598528 != nil:
    section.add "courseId", valid_598528
  var valid_598529 = path.getOrDefault("userId")
  valid_598529 = validateParameter(valid_598529, JString, required = true,
                                 default = nil)
  if valid_598529 != nil:
    section.add "userId", valid_598529
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
  var valid_598530 = query.getOrDefault("upload_protocol")
  valid_598530 = validateParameter(valid_598530, JString, required = false,
                                 default = nil)
  if valid_598530 != nil:
    section.add "upload_protocol", valid_598530
  var valid_598531 = query.getOrDefault("fields")
  valid_598531 = validateParameter(valid_598531, JString, required = false,
                                 default = nil)
  if valid_598531 != nil:
    section.add "fields", valid_598531
  var valid_598532 = query.getOrDefault("quotaUser")
  valid_598532 = validateParameter(valid_598532, JString, required = false,
                                 default = nil)
  if valid_598532 != nil:
    section.add "quotaUser", valid_598532
  var valid_598533 = query.getOrDefault("alt")
  valid_598533 = validateParameter(valid_598533, JString, required = false,
                                 default = newJString("json"))
  if valid_598533 != nil:
    section.add "alt", valid_598533
  var valid_598534 = query.getOrDefault("oauth_token")
  valid_598534 = validateParameter(valid_598534, JString, required = false,
                                 default = nil)
  if valid_598534 != nil:
    section.add "oauth_token", valid_598534
  var valid_598535 = query.getOrDefault("callback")
  valid_598535 = validateParameter(valid_598535, JString, required = false,
                                 default = nil)
  if valid_598535 != nil:
    section.add "callback", valid_598535
  var valid_598536 = query.getOrDefault("access_token")
  valid_598536 = validateParameter(valid_598536, JString, required = false,
                                 default = nil)
  if valid_598536 != nil:
    section.add "access_token", valid_598536
  var valid_598537 = query.getOrDefault("uploadType")
  valid_598537 = validateParameter(valid_598537, JString, required = false,
                                 default = nil)
  if valid_598537 != nil:
    section.add "uploadType", valid_598537
  var valid_598538 = query.getOrDefault("key")
  valid_598538 = validateParameter(valid_598538, JString, required = false,
                                 default = nil)
  if valid_598538 != nil:
    section.add "key", valid_598538
  var valid_598539 = query.getOrDefault("$.xgafv")
  valid_598539 = validateParameter(valid_598539, JString, required = false,
                                 default = newJString("1"))
  if valid_598539 != nil:
    section.add "$.xgafv", valid_598539
  var valid_598540 = query.getOrDefault("prettyPrint")
  valid_598540 = validateParameter(valid_598540, JBool, required = false,
                                 default = newJBool(true))
  if valid_598540 != nil:
    section.add "prettyPrint", valid_598540
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598541: Call_ClassroomCoursesStudentsGet_598525; path: JsonNode;
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
  let valid = call_598541.validator(path, query, header, formData, body)
  let scheme = call_598541.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598541.url(scheme.get, call_598541.host, call_598541.base,
                         call_598541.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598541, url, valid)

proc call*(call_598542: Call_ClassroomCoursesStudentsGet_598525; courseId: string;
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
  var path_598543 = newJObject()
  var query_598544 = newJObject()
  add(query_598544, "upload_protocol", newJString(uploadProtocol))
  add(query_598544, "fields", newJString(fields))
  add(query_598544, "quotaUser", newJString(quotaUser))
  add(query_598544, "alt", newJString(alt))
  add(query_598544, "oauth_token", newJString(oauthToken))
  add(query_598544, "callback", newJString(callback))
  add(query_598544, "access_token", newJString(accessToken))
  add(query_598544, "uploadType", newJString(uploadType))
  add(query_598544, "key", newJString(key))
  add(path_598543, "courseId", newJString(courseId))
  add(query_598544, "$.xgafv", newJString(Xgafv))
  add(query_598544, "prettyPrint", newJBool(prettyPrint))
  add(path_598543, "userId", newJString(userId))
  result = call_598542.call(path_598543, query_598544, nil, nil, nil)

var classroomCoursesStudentsGet* = Call_ClassroomCoursesStudentsGet_598525(
    name: "classroomCoursesStudentsGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/students/{userId}",
    validator: validate_ClassroomCoursesStudentsGet_598526, base: "/",
    url: url_ClassroomCoursesStudentsGet_598527, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesStudentsDelete_598545 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesStudentsDelete_598547(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomCoursesStudentsDelete_598546(path: JsonNode;
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
  var valid_598548 = path.getOrDefault("courseId")
  valid_598548 = validateParameter(valid_598548, JString, required = true,
                                 default = nil)
  if valid_598548 != nil:
    section.add "courseId", valid_598548
  var valid_598549 = path.getOrDefault("userId")
  valid_598549 = validateParameter(valid_598549, JString, required = true,
                                 default = nil)
  if valid_598549 != nil:
    section.add "userId", valid_598549
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
  var valid_598550 = query.getOrDefault("upload_protocol")
  valid_598550 = validateParameter(valid_598550, JString, required = false,
                                 default = nil)
  if valid_598550 != nil:
    section.add "upload_protocol", valid_598550
  var valid_598551 = query.getOrDefault("fields")
  valid_598551 = validateParameter(valid_598551, JString, required = false,
                                 default = nil)
  if valid_598551 != nil:
    section.add "fields", valid_598551
  var valid_598552 = query.getOrDefault("quotaUser")
  valid_598552 = validateParameter(valid_598552, JString, required = false,
                                 default = nil)
  if valid_598552 != nil:
    section.add "quotaUser", valid_598552
  var valid_598553 = query.getOrDefault("alt")
  valid_598553 = validateParameter(valid_598553, JString, required = false,
                                 default = newJString("json"))
  if valid_598553 != nil:
    section.add "alt", valid_598553
  var valid_598554 = query.getOrDefault("oauth_token")
  valid_598554 = validateParameter(valid_598554, JString, required = false,
                                 default = nil)
  if valid_598554 != nil:
    section.add "oauth_token", valid_598554
  var valid_598555 = query.getOrDefault("callback")
  valid_598555 = validateParameter(valid_598555, JString, required = false,
                                 default = nil)
  if valid_598555 != nil:
    section.add "callback", valid_598555
  var valid_598556 = query.getOrDefault("access_token")
  valid_598556 = validateParameter(valid_598556, JString, required = false,
                                 default = nil)
  if valid_598556 != nil:
    section.add "access_token", valid_598556
  var valid_598557 = query.getOrDefault("uploadType")
  valid_598557 = validateParameter(valid_598557, JString, required = false,
                                 default = nil)
  if valid_598557 != nil:
    section.add "uploadType", valid_598557
  var valid_598558 = query.getOrDefault("key")
  valid_598558 = validateParameter(valid_598558, JString, required = false,
                                 default = nil)
  if valid_598558 != nil:
    section.add "key", valid_598558
  var valid_598559 = query.getOrDefault("$.xgafv")
  valid_598559 = validateParameter(valid_598559, JString, required = false,
                                 default = newJString("1"))
  if valid_598559 != nil:
    section.add "$.xgafv", valid_598559
  var valid_598560 = query.getOrDefault("prettyPrint")
  valid_598560 = validateParameter(valid_598560, JBool, required = false,
                                 default = newJBool(true))
  if valid_598560 != nil:
    section.add "prettyPrint", valid_598560
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598561: Call_ClassroomCoursesStudentsDelete_598545; path: JsonNode;
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
  let valid = call_598561.validator(path, query, header, formData, body)
  let scheme = call_598561.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598561.url(scheme.get, call_598561.host, call_598561.base,
                         call_598561.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598561, url, valid)

proc call*(call_598562: Call_ClassroomCoursesStudentsDelete_598545;
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
  var path_598563 = newJObject()
  var query_598564 = newJObject()
  add(query_598564, "upload_protocol", newJString(uploadProtocol))
  add(query_598564, "fields", newJString(fields))
  add(query_598564, "quotaUser", newJString(quotaUser))
  add(query_598564, "alt", newJString(alt))
  add(query_598564, "oauth_token", newJString(oauthToken))
  add(query_598564, "callback", newJString(callback))
  add(query_598564, "access_token", newJString(accessToken))
  add(query_598564, "uploadType", newJString(uploadType))
  add(query_598564, "key", newJString(key))
  add(path_598563, "courseId", newJString(courseId))
  add(query_598564, "$.xgafv", newJString(Xgafv))
  add(query_598564, "prettyPrint", newJBool(prettyPrint))
  add(path_598563, "userId", newJString(userId))
  result = call_598562.call(path_598563, query_598564, nil, nil, nil)

var classroomCoursesStudentsDelete* = Call_ClassroomCoursesStudentsDelete_598545(
    name: "classroomCoursesStudentsDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/students/{userId}",
    validator: validate_ClassroomCoursesStudentsDelete_598546, base: "/",
    url: url_ClassroomCoursesStudentsDelete_598547, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTeachersCreate_598586 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesTeachersCreate_598588(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomCoursesTeachersCreate_598587(path: JsonNode;
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
  var valid_598589 = path.getOrDefault("courseId")
  valid_598589 = validateParameter(valid_598589, JString, required = true,
                                 default = nil)
  if valid_598589 != nil:
    section.add "courseId", valid_598589
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
  var valid_598590 = query.getOrDefault("upload_protocol")
  valid_598590 = validateParameter(valid_598590, JString, required = false,
                                 default = nil)
  if valid_598590 != nil:
    section.add "upload_protocol", valid_598590
  var valid_598591 = query.getOrDefault("fields")
  valid_598591 = validateParameter(valid_598591, JString, required = false,
                                 default = nil)
  if valid_598591 != nil:
    section.add "fields", valid_598591
  var valid_598592 = query.getOrDefault("quotaUser")
  valid_598592 = validateParameter(valid_598592, JString, required = false,
                                 default = nil)
  if valid_598592 != nil:
    section.add "quotaUser", valid_598592
  var valid_598593 = query.getOrDefault("alt")
  valid_598593 = validateParameter(valid_598593, JString, required = false,
                                 default = newJString("json"))
  if valid_598593 != nil:
    section.add "alt", valid_598593
  var valid_598594 = query.getOrDefault("oauth_token")
  valid_598594 = validateParameter(valid_598594, JString, required = false,
                                 default = nil)
  if valid_598594 != nil:
    section.add "oauth_token", valid_598594
  var valid_598595 = query.getOrDefault("callback")
  valid_598595 = validateParameter(valid_598595, JString, required = false,
                                 default = nil)
  if valid_598595 != nil:
    section.add "callback", valid_598595
  var valid_598596 = query.getOrDefault("access_token")
  valid_598596 = validateParameter(valid_598596, JString, required = false,
                                 default = nil)
  if valid_598596 != nil:
    section.add "access_token", valid_598596
  var valid_598597 = query.getOrDefault("uploadType")
  valid_598597 = validateParameter(valid_598597, JString, required = false,
                                 default = nil)
  if valid_598597 != nil:
    section.add "uploadType", valid_598597
  var valid_598598 = query.getOrDefault("key")
  valid_598598 = validateParameter(valid_598598, JString, required = false,
                                 default = nil)
  if valid_598598 != nil:
    section.add "key", valid_598598
  var valid_598599 = query.getOrDefault("$.xgafv")
  valid_598599 = validateParameter(valid_598599, JString, required = false,
                                 default = newJString("1"))
  if valid_598599 != nil:
    section.add "$.xgafv", valid_598599
  var valid_598600 = query.getOrDefault("prettyPrint")
  valid_598600 = validateParameter(valid_598600, JBool, required = false,
                                 default = newJBool(true))
  if valid_598600 != nil:
    section.add "prettyPrint", valid_598600
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

proc call*(call_598602: Call_ClassroomCoursesTeachersCreate_598586; path: JsonNode;
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
  let valid = call_598602.validator(path, query, header, formData, body)
  let scheme = call_598602.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598602.url(scheme.get, call_598602.host, call_598602.base,
                         call_598602.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598602, url, valid)

proc call*(call_598603: Call_ClassroomCoursesTeachersCreate_598586;
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
  var path_598604 = newJObject()
  var query_598605 = newJObject()
  var body_598606 = newJObject()
  add(query_598605, "upload_protocol", newJString(uploadProtocol))
  add(query_598605, "fields", newJString(fields))
  add(query_598605, "quotaUser", newJString(quotaUser))
  add(query_598605, "alt", newJString(alt))
  add(query_598605, "oauth_token", newJString(oauthToken))
  add(query_598605, "callback", newJString(callback))
  add(query_598605, "access_token", newJString(accessToken))
  add(query_598605, "uploadType", newJString(uploadType))
  add(query_598605, "key", newJString(key))
  add(path_598604, "courseId", newJString(courseId))
  add(query_598605, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598606 = body
  add(query_598605, "prettyPrint", newJBool(prettyPrint))
  result = call_598603.call(path_598604, query_598605, nil, nil, body_598606)

var classroomCoursesTeachersCreate* = Call_ClassroomCoursesTeachersCreate_598586(
    name: "classroomCoursesTeachersCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/teachers",
    validator: validate_ClassroomCoursesTeachersCreate_598587, base: "/",
    url: url_ClassroomCoursesTeachersCreate_598588, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTeachersList_598565 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesTeachersList_598567(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomCoursesTeachersList_598566(path: JsonNode; query: JsonNode;
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
  var valid_598568 = path.getOrDefault("courseId")
  valid_598568 = validateParameter(valid_598568, JString, required = true,
                                 default = nil)
  if valid_598568 != nil:
    section.add "courseId", valid_598568
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
  var valid_598569 = query.getOrDefault("upload_protocol")
  valid_598569 = validateParameter(valid_598569, JString, required = false,
                                 default = nil)
  if valid_598569 != nil:
    section.add "upload_protocol", valid_598569
  var valid_598570 = query.getOrDefault("fields")
  valid_598570 = validateParameter(valid_598570, JString, required = false,
                                 default = nil)
  if valid_598570 != nil:
    section.add "fields", valid_598570
  var valid_598571 = query.getOrDefault("pageToken")
  valid_598571 = validateParameter(valid_598571, JString, required = false,
                                 default = nil)
  if valid_598571 != nil:
    section.add "pageToken", valid_598571
  var valid_598572 = query.getOrDefault("quotaUser")
  valid_598572 = validateParameter(valid_598572, JString, required = false,
                                 default = nil)
  if valid_598572 != nil:
    section.add "quotaUser", valid_598572
  var valid_598573 = query.getOrDefault("alt")
  valid_598573 = validateParameter(valid_598573, JString, required = false,
                                 default = newJString("json"))
  if valid_598573 != nil:
    section.add "alt", valid_598573
  var valid_598574 = query.getOrDefault("oauth_token")
  valid_598574 = validateParameter(valid_598574, JString, required = false,
                                 default = nil)
  if valid_598574 != nil:
    section.add "oauth_token", valid_598574
  var valid_598575 = query.getOrDefault("callback")
  valid_598575 = validateParameter(valid_598575, JString, required = false,
                                 default = nil)
  if valid_598575 != nil:
    section.add "callback", valid_598575
  var valid_598576 = query.getOrDefault("access_token")
  valid_598576 = validateParameter(valid_598576, JString, required = false,
                                 default = nil)
  if valid_598576 != nil:
    section.add "access_token", valid_598576
  var valid_598577 = query.getOrDefault("uploadType")
  valid_598577 = validateParameter(valid_598577, JString, required = false,
                                 default = nil)
  if valid_598577 != nil:
    section.add "uploadType", valid_598577
  var valid_598578 = query.getOrDefault("key")
  valid_598578 = validateParameter(valid_598578, JString, required = false,
                                 default = nil)
  if valid_598578 != nil:
    section.add "key", valid_598578
  var valid_598579 = query.getOrDefault("$.xgafv")
  valid_598579 = validateParameter(valid_598579, JString, required = false,
                                 default = newJString("1"))
  if valid_598579 != nil:
    section.add "$.xgafv", valid_598579
  var valid_598580 = query.getOrDefault("pageSize")
  valid_598580 = validateParameter(valid_598580, JInt, required = false, default = nil)
  if valid_598580 != nil:
    section.add "pageSize", valid_598580
  var valid_598581 = query.getOrDefault("prettyPrint")
  valid_598581 = validateParameter(valid_598581, JBool, required = false,
                                 default = newJBool(true))
  if valid_598581 != nil:
    section.add "prettyPrint", valid_598581
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598582: Call_ClassroomCoursesTeachersList_598565; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of teachers of this course that the requester
  ## is permitted to view.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `NOT_FOUND` if the course does not exist.
  ## * `PERMISSION_DENIED` for access errors.
  ## 
  let valid = call_598582.validator(path, query, header, formData, body)
  let scheme = call_598582.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598582.url(scheme.get, call_598582.host, call_598582.base,
                         call_598582.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598582, url, valid)

proc call*(call_598583: Call_ClassroomCoursesTeachersList_598565; courseId: string;
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
  var path_598584 = newJObject()
  var query_598585 = newJObject()
  add(query_598585, "upload_protocol", newJString(uploadProtocol))
  add(query_598585, "fields", newJString(fields))
  add(query_598585, "pageToken", newJString(pageToken))
  add(query_598585, "quotaUser", newJString(quotaUser))
  add(query_598585, "alt", newJString(alt))
  add(query_598585, "oauth_token", newJString(oauthToken))
  add(query_598585, "callback", newJString(callback))
  add(query_598585, "access_token", newJString(accessToken))
  add(query_598585, "uploadType", newJString(uploadType))
  add(query_598585, "key", newJString(key))
  add(path_598584, "courseId", newJString(courseId))
  add(query_598585, "$.xgafv", newJString(Xgafv))
  add(query_598585, "pageSize", newJInt(pageSize))
  add(query_598585, "prettyPrint", newJBool(prettyPrint))
  result = call_598583.call(path_598584, query_598585, nil, nil, nil)

var classroomCoursesTeachersList* = Call_ClassroomCoursesTeachersList_598565(
    name: "classroomCoursesTeachersList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/teachers",
    validator: validate_ClassroomCoursesTeachersList_598566, base: "/",
    url: url_ClassroomCoursesTeachersList_598567, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTeachersGet_598607 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesTeachersGet_598609(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomCoursesTeachersGet_598608(path: JsonNode; query: JsonNode;
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
  var valid_598610 = path.getOrDefault("courseId")
  valid_598610 = validateParameter(valid_598610, JString, required = true,
                                 default = nil)
  if valid_598610 != nil:
    section.add "courseId", valid_598610
  var valid_598611 = path.getOrDefault("userId")
  valid_598611 = validateParameter(valid_598611, JString, required = true,
                                 default = nil)
  if valid_598611 != nil:
    section.add "userId", valid_598611
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
  var valid_598612 = query.getOrDefault("upload_protocol")
  valid_598612 = validateParameter(valid_598612, JString, required = false,
                                 default = nil)
  if valid_598612 != nil:
    section.add "upload_protocol", valid_598612
  var valid_598613 = query.getOrDefault("fields")
  valid_598613 = validateParameter(valid_598613, JString, required = false,
                                 default = nil)
  if valid_598613 != nil:
    section.add "fields", valid_598613
  var valid_598614 = query.getOrDefault("quotaUser")
  valid_598614 = validateParameter(valid_598614, JString, required = false,
                                 default = nil)
  if valid_598614 != nil:
    section.add "quotaUser", valid_598614
  var valid_598615 = query.getOrDefault("alt")
  valid_598615 = validateParameter(valid_598615, JString, required = false,
                                 default = newJString("json"))
  if valid_598615 != nil:
    section.add "alt", valid_598615
  var valid_598616 = query.getOrDefault("oauth_token")
  valid_598616 = validateParameter(valid_598616, JString, required = false,
                                 default = nil)
  if valid_598616 != nil:
    section.add "oauth_token", valid_598616
  var valid_598617 = query.getOrDefault("callback")
  valid_598617 = validateParameter(valid_598617, JString, required = false,
                                 default = nil)
  if valid_598617 != nil:
    section.add "callback", valid_598617
  var valid_598618 = query.getOrDefault("access_token")
  valid_598618 = validateParameter(valid_598618, JString, required = false,
                                 default = nil)
  if valid_598618 != nil:
    section.add "access_token", valid_598618
  var valid_598619 = query.getOrDefault("uploadType")
  valid_598619 = validateParameter(valid_598619, JString, required = false,
                                 default = nil)
  if valid_598619 != nil:
    section.add "uploadType", valid_598619
  var valid_598620 = query.getOrDefault("key")
  valid_598620 = validateParameter(valid_598620, JString, required = false,
                                 default = nil)
  if valid_598620 != nil:
    section.add "key", valid_598620
  var valid_598621 = query.getOrDefault("$.xgafv")
  valid_598621 = validateParameter(valid_598621, JString, required = false,
                                 default = newJString("1"))
  if valid_598621 != nil:
    section.add "$.xgafv", valid_598621
  var valid_598622 = query.getOrDefault("prettyPrint")
  valid_598622 = validateParameter(valid_598622, JBool, required = false,
                                 default = newJBool(true))
  if valid_598622 != nil:
    section.add "prettyPrint", valid_598622
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598623: Call_ClassroomCoursesTeachersGet_598607; path: JsonNode;
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
  let valid = call_598623.validator(path, query, header, formData, body)
  let scheme = call_598623.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598623.url(scheme.get, call_598623.host, call_598623.base,
                         call_598623.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598623, url, valid)

proc call*(call_598624: Call_ClassroomCoursesTeachersGet_598607; courseId: string;
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
  var path_598625 = newJObject()
  var query_598626 = newJObject()
  add(query_598626, "upload_protocol", newJString(uploadProtocol))
  add(query_598626, "fields", newJString(fields))
  add(query_598626, "quotaUser", newJString(quotaUser))
  add(query_598626, "alt", newJString(alt))
  add(query_598626, "oauth_token", newJString(oauthToken))
  add(query_598626, "callback", newJString(callback))
  add(query_598626, "access_token", newJString(accessToken))
  add(query_598626, "uploadType", newJString(uploadType))
  add(query_598626, "key", newJString(key))
  add(path_598625, "courseId", newJString(courseId))
  add(query_598626, "$.xgafv", newJString(Xgafv))
  add(query_598626, "prettyPrint", newJBool(prettyPrint))
  add(path_598625, "userId", newJString(userId))
  result = call_598624.call(path_598625, query_598626, nil, nil, nil)

var classroomCoursesTeachersGet* = Call_ClassroomCoursesTeachersGet_598607(
    name: "classroomCoursesTeachersGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/teachers/{userId}",
    validator: validate_ClassroomCoursesTeachersGet_598608, base: "/",
    url: url_ClassroomCoursesTeachersGet_598609, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTeachersDelete_598627 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesTeachersDelete_598629(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomCoursesTeachersDelete_598628(path: JsonNode;
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
  var valid_598630 = path.getOrDefault("courseId")
  valid_598630 = validateParameter(valid_598630, JString, required = true,
                                 default = nil)
  if valid_598630 != nil:
    section.add "courseId", valid_598630
  var valid_598631 = path.getOrDefault("userId")
  valid_598631 = validateParameter(valid_598631, JString, required = true,
                                 default = nil)
  if valid_598631 != nil:
    section.add "userId", valid_598631
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
  var valid_598632 = query.getOrDefault("upload_protocol")
  valid_598632 = validateParameter(valid_598632, JString, required = false,
                                 default = nil)
  if valid_598632 != nil:
    section.add "upload_protocol", valid_598632
  var valid_598633 = query.getOrDefault("fields")
  valid_598633 = validateParameter(valid_598633, JString, required = false,
                                 default = nil)
  if valid_598633 != nil:
    section.add "fields", valid_598633
  var valid_598634 = query.getOrDefault("quotaUser")
  valid_598634 = validateParameter(valid_598634, JString, required = false,
                                 default = nil)
  if valid_598634 != nil:
    section.add "quotaUser", valid_598634
  var valid_598635 = query.getOrDefault("alt")
  valid_598635 = validateParameter(valid_598635, JString, required = false,
                                 default = newJString("json"))
  if valid_598635 != nil:
    section.add "alt", valid_598635
  var valid_598636 = query.getOrDefault("oauth_token")
  valid_598636 = validateParameter(valid_598636, JString, required = false,
                                 default = nil)
  if valid_598636 != nil:
    section.add "oauth_token", valid_598636
  var valid_598637 = query.getOrDefault("callback")
  valid_598637 = validateParameter(valid_598637, JString, required = false,
                                 default = nil)
  if valid_598637 != nil:
    section.add "callback", valid_598637
  var valid_598638 = query.getOrDefault("access_token")
  valid_598638 = validateParameter(valid_598638, JString, required = false,
                                 default = nil)
  if valid_598638 != nil:
    section.add "access_token", valid_598638
  var valid_598639 = query.getOrDefault("uploadType")
  valid_598639 = validateParameter(valid_598639, JString, required = false,
                                 default = nil)
  if valid_598639 != nil:
    section.add "uploadType", valid_598639
  var valid_598640 = query.getOrDefault("key")
  valid_598640 = validateParameter(valid_598640, JString, required = false,
                                 default = nil)
  if valid_598640 != nil:
    section.add "key", valid_598640
  var valid_598641 = query.getOrDefault("$.xgafv")
  valid_598641 = validateParameter(valid_598641, JString, required = false,
                                 default = newJString("1"))
  if valid_598641 != nil:
    section.add "$.xgafv", valid_598641
  var valid_598642 = query.getOrDefault("prettyPrint")
  valid_598642 = validateParameter(valid_598642, JBool, required = false,
                                 default = newJBool(true))
  if valid_598642 != nil:
    section.add "prettyPrint", valid_598642
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598643: Call_ClassroomCoursesTeachersDelete_598627; path: JsonNode;
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
  let valid = call_598643.validator(path, query, header, formData, body)
  let scheme = call_598643.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598643.url(scheme.get, call_598643.host, call_598643.base,
                         call_598643.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598643, url, valid)

proc call*(call_598644: Call_ClassroomCoursesTeachersDelete_598627;
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
  var path_598645 = newJObject()
  var query_598646 = newJObject()
  add(query_598646, "upload_protocol", newJString(uploadProtocol))
  add(query_598646, "fields", newJString(fields))
  add(query_598646, "quotaUser", newJString(quotaUser))
  add(query_598646, "alt", newJString(alt))
  add(query_598646, "oauth_token", newJString(oauthToken))
  add(query_598646, "callback", newJString(callback))
  add(query_598646, "access_token", newJString(accessToken))
  add(query_598646, "uploadType", newJString(uploadType))
  add(query_598646, "key", newJString(key))
  add(path_598645, "courseId", newJString(courseId))
  add(query_598646, "$.xgafv", newJString(Xgafv))
  add(query_598646, "prettyPrint", newJBool(prettyPrint))
  add(path_598645, "userId", newJString(userId))
  result = call_598644.call(path_598645, query_598646, nil, nil, nil)

var classroomCoursesTeachersDelete* = Call_ClassroomCoursesTeachersDelete_598627(
    name: "classroomCoursesTeachersDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com",
    route: "/v1/courses/{courseId}/teachers/{userId}",
    validator: validate_ClassroomCoursesTeachersDelete_598628, base: "/",
    url: url_ClassroomCoursesTeachersDelete_598629, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTopicsCreate_598668 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesTopicsCreate_598670(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomCoursesTopicsCreate_598669(path: JsonNode; query: JsonNode;
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
  var valid_598671 = path.getOrDefault("courseId")
  valid_598671 = validateParameter(valid_598671, JString, required = true,
                                 default = nil)
  if valid_598671 != nil:
    section.add "courseId", valid_598671
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
  var valid_598672 = query.getOrDefault("upload_protocol")
  valid_598672 = validateParameter(valid_598672, JString, required = false,
                                 default = nil)
  if valid_598672 != nil:
    section.add "upload_protocol", valid_598672
  var valid_598673 = query.getOrDefault("fields")
  valid_598673 = validateParameter(valid_598673, JString, required = false,
                                 default = nil)
  if valid_598673 != nil:
    section.add "fields", valid_598673
  var valid_598674 = query.getOrDefault("quotaUser")
  valid_598674 = validateParameter(valid_598674, JString, required = false,
                                 default = nil)
  if valid_598674 != nil:
    section.add "quotaUser", valid_598674
  var valid_598675 = query.getOrDefault("alt")
  valid_598675 = validateParameter(valid_598675, JString, required = false,
                                 default = newJString("json"))
  if valid_598675 != nil:
    section.add "alt", valid_598675
  var valid_598676 = query.getOrDefault("oauth_token")
  valid_598676 = validateParameter(valid_598676, JString, required = false,
                                 default = nil)
  if valid_598676 != nil:
    section.add "oauth_token", valid_598676
  var valid_598677 = query.getOrDefault("callback")
  valid_598677 = validateParameter(valid_598677, JString, required = false,
                                 default = nil)
  if valid_598677 != nil:
    section.add "callback", valid_598677
  var valid_598678 = query.getOrDefault("access_token")
  valid_598678 = validateParameter(valid_598678, JString, required = false,
                                 default = nil)
  if valid_598678 != nil:
    section.add "access_token", valid_598678
  var valid_598679 = query.getOrDefault("uploadType")
  valid_598679 = validateParameter(valid_598679, JString, required = false,
                                 default = nil)
  if valid_598679 != nil:
    section.add "uploadType", valid_598679
  var valid_598680 = query.getOrDefault("key")
  valid_598680 = validateParameter(valid_598680, JString, required = false,
                                 default = nil)
  if valid_598680 != nil:
    section.add "key", valid_598680
  var valid_598681 = query.getOrDefault("$.xgafv")
  valid_598681 = validateParameter(valid_598681, JString, required = false,
                                 default = newJString("1"))
  if valid_598681 != nil:
    section.add "$.xgafv", valid_598681
  var valid_598682 = query.getOrDefault("prettyPrint")
  valid_598682 = validateParameter(valid_598682, JBool, required = false,
                                 default = newJBool(true))
  if valid_598682 != nil:
    section.add "prettyPrint", valid_598682
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

proc call*(call_598684: Call_ClassroomCoursesTopicsCreate_598668; path: JsonNode;
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
  let valid = call_598684.validator(path, query, header, formData, body)
  let scheme = call_598684.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598684.url(scheme.get, call_598684.host, call_598684.base,
                         call_598684.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598684, url, valid)

proc call*(call_598685: Call_ClassroomCoursesTopicsCreate_598668; courseId: string;
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
  var path_598686 = newJObject()
  var query_598687 = newJObject()
  var body_598688 = newJObject()
  add(query_598687, "upload_protocol", newJString(uploadProtocol))
  add(query_598687, "fields", newJString(fields))
  add(query_598687, "quotaUser", newJString(quotaUser))
  add(query_598687, "alt", newJString(alt))
  add(query_598687, "oauth_token", newJString(oauthToken))
  add(query_598687, "callback", newJString(callback))
  add(query_598687, "access_token", newJString(accessToken))
  add(query_598687, "uploadType", newJString(uploadType))
  add(query_598687, "key", newJString(key))
  add(path_598686, "courseId", newJString(courseId))
  add(query_598687, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598688 = body
  add(query_598687, "prettyPrint", newJBool(prettyPrint))
  result = call_598685.call(path_598686, query_598687, nil, nil, body_598688)

var classroomCoursesTopicsCreate* = Call_ClassroomCoursesTopicsCreate_598668(
    name: "classroomCoursesTopicsCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/topics",
    validator: validate_ClassroomCoursesTopicsCreate_598669, base: "/",
    url: url_ClassroomCoursesTopicsCreate_598670, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTopicsList_598647 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesTopicsList_598649(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomCoursesTopicsList_598648(path: JsonNode; query: JsonNode;
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
  var valid_598650 = path.getOrDefault("courseId")
  valid_598650 = validateParameter(valid_598650, JString, required = true,
                                 default = nil)
  if valid_598650 != nil:
    section.add "courseId", valid_598650
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
  var valid_598651 = query.getOrDefault("upload_protocol")
  valid_598651 = validateParameter(valid_598651, JString, required = false,
                                 default = nil)
  if valid_598651 != nil:
    section.add "upload_protocol", valid_598651
  var valid_598652 = query.getOrDefault("fields")
  valid_598652 = validateParameter(valid_598652, JString, required = false,
                                 default = nil)
  if valid_598652 != nil:
    section.add "fields", valid_598652
  var valid_598653 = query.getOrDefault("pageToken")
  valid_598653 = validateParameter(valid_598653, JString, required = false,
                                 default = nil)
  if valid_598653 != nil:
    section.add "pageToken", valid_598653
  var valid_598654 = query.getOrDefault("quotaUser")
  valid_598654 = validateParameter(valid_598654, JString, required = false,
                                 default = nil)
  if valid_598654 != nil:
    section.add "quotaUser", valid_598654
  var valid_598655 = query.getOrDefault("alt")
  valid_598655 = validateParameter(valid_598655, JString, required = false,
                                 default = newJString("json"))
  if valid_598655 != nil:
    section.add "alt", valid_598655
  var valid_598656 = query.getOrDefault("oauth_token")
  valid_598656 = validateParameter(valid_598656, JString, required = false,
                                 default = nil)
  if valid_598656 != nil:
    section.add "oauth_token", valid_598656
  var valid_598657 = query.getOrDefault("callback")
  valid_598657 = validateParameter(valid_598657, JString, required = false,
                                 default = nil)
  if valid_598657 != nil:
    section.add "callback", valid_598657
  var valid_598658 = query.getOrDefault("access_token")
  valid_598658 = validateParameter(valid_598658, JString, required = false,
                                 default = nil)
  if valid_598658 != nil:
    section.add "access_token", valid_598658
  var valid_598659 = query.getOrDefault("uploadType")
  valid_598659 = validateParameter(valid_598659, JString, required = false,
                                 default = nil)
  if valid_598659 != nil:
    section.add "uploadType", valid_598659
  var valid_598660 = query.getOrDefault("key")
  valid_598660 = validateParameter(valid_598660, JString, required = false,
                                 default = nil)
  if valid_598660 != nil:
    section.add "key", valid_598660
  var valid_598661 = query.getOrDefault("$.xgafv")
  valid_598661 = validateParameter(valid_598661, JString, required = false,
                                 default = newJString("1"))
  if valid_598661 != nil:
    section.add "$.xgafv", valid_598661
  var valid_598662 = query.getOrDefault("pageSize")
  valid_598662 = validateParameter(valid_598662, JInt, required = false, default = nil)
  if valid_598662 != nil:
    section.add "pageSize", valid_598662
  var valid_598663 = query.getOrDefault("prettyPrint")
  valid_598663 = validateParameter(valid_598663, JBool, required = false,
                                 default = newJBool(true))
  if valid_598663 != nil:
    section.add "prettyPrint", valid_598663
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598664: Call_ClassroomCoursesTopicsList_598647; path: JsonNode;
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
  let valid = call_598664.validator(path, query, header, formData, body)
  let scheme = call_598664.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598664.url(scheme.get, call_598664.host, call_598664.base,
                         call_598664.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598664, url, valid)

proc call*(call_598665: Call_ClassroomCoursesTopicsList_598647; courseId: string;
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
  var path_598666 = newJObject()
  var query_598667 = newJObject()
  add(query_598667, "upload_protocol", newJString(uploadProtocol))
  add(query_598667, "fields", newJString(fields))
  add(query_598667, "pageToken", newJString(pageToken))
  add(query_598667, "quotaUser", newJString(quotaUser))
  add(query_598667, "alt", newJString(alt))
  add(query_598667, "oauth_token", newJString(oauthToken))
  add(query_598667, "callback", newJString(callback))
  add(query_598667, "access_token", newJString(accessToken))
  add(query_598667, "uploadType", newJString(uploadType))
  add(query_598667, "key", newJString(key))
  add(path_598666, "courseId", newJString(courseId))
  add(query_598667, "$.xgafv", newJString(Xgafv))
  add(query_598667, "pageSize", newJInt(pageSize))
  add(query_598667, "prettyPrint", newJBool(prettyPrint))
  result = call_598665.call(path_598666, query_598667, nil, nil, nil)

var classroomCoursesTopicsList* = Call_ClassroomCoursesTopicsList_598647(
    name: "classroomCoursesTopicsList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/topics",
    validator: validate_ClassroomCoursesTopicsList_598648, base: "/",
    url: url_ClassroomCoursesTopicsList_598649, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTopicsGet_598689 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesTopicsGet_598691(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomCoursesTopicsGet_598690(path: JsonNode; query: JsonNode;
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
  var valid_598692 = path.getOrDefault("id")
  valid_598692 = validateParameter(valid_598692, JString, required = true,
                                 default = nil)
  if valid_598692 != nil:
    section.add "id", valid_598692
  var valid_598693 = path.getOrDefault("courseId")
  valid_598693 = validateParameter(valid_598693, JString, required = true,
                                 default = nil)
  if valid_598693 != nil:
    section.add "courseId", valid_598693
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
  var valid_598694 = query.getOrDefault("upload_protocol")
  valid_598694 = validateParameter(valid_598694, JString, required = false,
                                 default = nil)
  if valid_598694 != nil:
    section.add "upload_protocol", valid_598694
  var valid_598695 = query.getOrDefault("fields")
  valid_598695 = validateParameter(valid_598695, JString, required = false,
                                 default = nil)
  if valid_598695 != nil:
    section.add "fields", valid_598695
  var valid_598696 = query.getOrDefault("quotaUser")
  valid_598696 = validateParameter(valid_598696, JString, required = false,
                                 default = nil)
  if valid_598696 != nil:
    section.add "quotaUser", valid_598696
  var valid_598697 = query.getOrDefault("alt")
  valid_598697 = validateParameter(valid_598697, JString, required = false,
                                 default = newJString("json"))
  if valid_598697 != nil:
    section.add "alt", valid_598697
  var valid_598698 = query.getOrDefault("oauth_token")
  valid_598698 = validateParameter(valid_598698, JString, required = false,
                                 default = nil)
  if valid_598698 != nil:
    section.add "oauth_token", valid_598698
  var valid_598699 = query.getOrDefault("callback")
  valid_598699 = validateParameter(valid_598699, JString, required = false,
                                 default = nil)
  if valid_598699 != nil:
    section.add "callback", valid_598699
  var valid_598700 = query.getOrDefault("access_token")
  valid_598700 = validateParameter(valid_598700, JString, required = false,
                                 default = nil)
  if valid_598700 != nil:
    section.add "access_token", valid_598700
  var valid_598701 = query.getOrDefault("uploadType")
  valid_598701 = validateParameter(valid_598701, JString, required = false,
                                 default = nil)
  if valid_598701 != nil:
    section.add "uploadType", valid_598701
  var valid_598702 = query.getOrDefault("key")
  valid_598702 = validateParameter(valid_598702, JString, required = false,
                                 default = nil)
  if valid_598702 != nil:
    section.add "key", valid_598702
  var valid_598703 = query.getOrDefault("$.xgafv")
  valid_598703 = validateParameter(valid_598703, JString, required = false,
                                 default = newJString("1"))
  if valid_598703 != nil:
    section.add "$.xgafv", valid_598703
  var valid_598704 = query.getOrDefault("prettyPrint")
  valid_598704 = validateParameter(valid_598704, JBool, required = false,
                                 default = newJBool(true))
  if valid_598704 != nil:
    section.add "prettyPrint", valid_598704
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598705: Call_ClassroomCoursesTopicsGet_598689; path: JsonNode;
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
  let valid = call_598705.validator(path, query, header, formData, body)
  let scheme = call_598705.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598705.url(scheme.get, call_598705.host, call_598705.base,
                         call_598705.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598705, url, valid)

proc call*(call_598706: Call_ClassroomCoursesTopicsGet_598689; id: string;
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
  var path_598707 = newJObject()
  var query_598708 = newJObject()
  add(query_598708, "upload_protocol", newJString(uploadProtocol))
  add(query_598708, "fields", newJString(fields))
  add(query_598708, "quotaUser", newJString(quotaUser))
  add(query_598708, "alt", newJString(alt))
  add(query_598708, "oauth_token", newJString(oauthToken))
  add(query_598708, "callback", newJString(callback))
  add(query_598708, "access_token", newJString(accessToken))
  add(query_598708, "uploadType", newJString(uploadType))
  add(path_598707, "id", newJString(id))
  add(query_598708, "key", newJString(key))
  add(path_598707, "courseId", newJString(courseId))
  add(query_598708, "$.xgafv", newJString(Xgafv))
  add(query_598708, "prettyPrint", newJBool(prettyPrint))
  result = call_598706.call(path_598707, query_598708, nil, nil, nil)

var classroomCoursesTopicsGet* = Call_ClassroomCoursesTopicsGet_598689(
    name: "classroomCoursesTopicsGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/topics/{id}",
    validator: validate_ClassroomCoursesTopicsGet_598690, base: "/",
    url: url_ClassroomCoursesTopicsGet_598691, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTopicsPatch_598729 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesTopicsPatch_598731(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomCoursesTopicsPatch_598730(path: JsonNode; query: JsonNode;
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
  var valid_598732 = path.getOrDefault("id")
  valid_598732 = validateParameter(valid_598732, JString, required = true,
                                 default = nil)
  if valid_598732 != nil:
    section.add "id", valid_598732
  var valid_598733 = path.getOrDefault("courseId")
  valid_598733 = validateParameter(valid_598733, JString, required = true,
                                 default = nil)
  if valid_598733 != nil:
    section.add "courseId", valid_598733
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
  var valid_598734 = query.getOrDefault("upload_protocol")
  valid_598734 = validateParameter(valid_598734, JString, required = false,
                                 default = nil)
  if valid_598734 != nil:
    section.add "upload_protocol", valid_598734
  var valid_598735 = query.getOrDefault("fields")
  valid_598735 = validateParameter(valid_598735, JString, required = false,
                                 default = nil)
  if valid_598735 != nil:
    section.add "fields", valid_598735
  var valid_598736 = query.getOrDefault("quotaUser")
  valid_598736 = validateParameter(valid_598736, JString, required = false,
                                 default = nil)
  if valid_598736 != nil:
    section.add "quotaUser", valid_598736
  var valid_598737 = query.getOrDefault("alt")
  valid_598737 = validateParameter(valid_598737, JString, required = false,
                                 default = newJString("json"))
  if valid_598737 != nil:
    section.add "alt", valid_598737
  var valid_598738 = query.getOrDefault("oauth_token")
  valid_598738 = validateParameter(valid_598738, JString, required = false,
                                 default = nil)
  if valid_598738 != nil:
    section.add "oauth_token", valid_598738
  var valid_598739 = query.getOrDefault("callback")
  valid_598739 = validateParameter(valid_598739, JString, required = false,
                                 default = nil)
  if valid_598739 != nil:
    section.add "callback", valid_598739
  var valid_598740 = query.getOrDefault("access_token")
  valid_598740 = validateParameter(valid_598740, JString, required = false,
                                 default = nil)
  if valid_598740 != nil:
    section.add "access_token", valid_598740
  var valid_598741 = query.getOrDefault("uploadType")
  valid_598741 = validateParameter(valid_598741, JString, required = false,
                                 default = nil)
  if valid_598741 != nil:
    section.add "uploadType", valid_598741
  var valid_598742 = query.getOrDefault("key")
  valid_598742 = validateParameter(valid_598742, JString, required = false,
                                 default = nil)
  if valid_598742 != nil:
    section.add "key", valid_598742
  var valid_598743 = query.getOrDefault("$.xgafv")
  valid_598743 = validateParameter(valid_598743, JString, required = false,
                                 default = newJString("1"))
  if valid_598743 != nil:
    section.add "$.xgafv", valid_598743
  var valid_598744 = query.getOrDefault("prettyPrint")
  valid_598744 = validateParameter(valid_598744, JBool, required = false,
                                 default = newJBool(true))
  if valid_598744 != nil:
    section.add "prettyPrint", valid_598744
  var valid_598745 = query.getOrDefault("updateMask")
  valid_598745 = validateParameter(valid_598745, JString, required = false,
                                 default = nil)
  if valid_598745 != nil:
    section.add "updateMask", valid_598745
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

proc call*(call_598747: Call_ClassroomCoursesTopicsPatch_598729; path: JsonNode;
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
  let valid = call_598747.validator(path, query, header, formData, body)
  let scheme = call_598747.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598747.url(scheme.get, call_598747.host, call_598747.base,
                         call_598747.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598747, url, valid)

proc call*(call_598748: Call_ClassroomCoursesTopicsPatch_598729; id: string;
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
  var path_598749 = newJObject()
  var query_598750 = newJObject()
  var body_598751 = newJObject()
  add(query_598750, "upload_protocol", newJString(uploadProtocol))
  add(query_598750, "fields", newJString(fields))
  add(query_598750, "quotaUser", newJString(quotaUser))
  add(query_598750, "alt", newJString(alt))
  add(query_598750, "oauth_token", newJString(oauthToken))
  add(query_598750, "callback", newJString(callback))
  add(query_598750, "access_token", newJString(accessToken))
  add(query_598750, "uploadType", newJString(uploadType))
  add(path_598749, "id", newJString(id))
  add(query_598750, "key", newJString(key))
  add(path_598749, "courseId", newJString(courseId))
  add(query_598750, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598751 = body
  add(query_598750, "prettyPrint", newJBool(prettyPrint))
  add(query_598750, "updateMask", newJString(updateMask))
  result = call_598748.call(path_598749, query_598750, nil, nil, body_598751)

var classroomCoursesTopicsPatch* = Call_ClassroomCoursesTopicsPatch_598729(
    name: "classroomCoursesTopicsPatch", meth: HttpMethod.HttpPatch,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/topics/{id}",
    validator: validate_ClassroomCoursesTopicsPatch_598730, base: "/",
    url: url_ClassroomCoursesTopicsPatch_598731, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesTopicsDelete_598709 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesTopicsDelete_598711(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomCoursesTopicsDelete_598710(path: JsonNode; query: JsonNode;
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
  var valid_598712 = path.getOrDefault("id")
  valid_598712 = validateParameter(valid_598712, JString, required = true,
                                 default = nil)
  if valid_598712 != nil:
    section.add "id", valid_598712
  var valid_598713 = path.getOrDefault("courseId")
  valid_598713 = validateParameter(valid_598713, JString, required = true,
                                 default = nil)
  if valid_598713 != nil:
    section.add "courseId", valid_598713
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
  var valid_598714 = query.getOrDefault("upload_protocol")
  valid_598714 = validateParameter(valid_598714, JString, required = false,
                                 default = nil)
  if valid_598714 != nil:
    section.add "upload_protocol", valid_598714
  var valid_598715 = query.getOrDefault("fields")
  valid_598715 = validateParameter(valid_598715, JString, required = false,
                                 default = nil)
  if valid_598715 != nil:
    section.add "fields", valid_598715
  var valid_598716 = query.getOrDefault("quotaUser")
  valid_598716 = validateParameter(valid_598716, JString, required = false,
                                 default = nil)
  if valid_598716 != nil:
    section.add "quotaUser", valid_598716
  var valid_598717 = query.getOrDefault("alt")
  valid_598717 = validateParameter(valid_598717, JString, required = false,
                                 default = newJString("json"))
  if valid_598717 != nil:
    section.add "alt", valid_598717
  var valid_598718 = query.getOrDefault("oauth_token")
  valid_598718 = validateParameter(valid_598718, JString, required = false,
                                 default = nil)
  if valid_598718 != nil:
    section.add "oauth_token", valid_598718
  var valid_598719 = query.getOrDefault("callback")
  valid_598719 = validateParameter(valid_598719, JString, required = false,
                                 default = nil)
  if valid_598719 != nil:
    section.add "callback", valid_598719
  var valid_598720 = query.getOrDefault("access_token")
  valid_598720 = validateParameter(valid_598720, JString, required = false,
                                 default = nil)
  if valid_598720 != nil:
    section.add "access_token", valid_598720
  var valid_598721 = query.getOrDefault("uploadType")
  valid_598721 = validateParameter(valid_598721, JString, required = false,
                                 default = nil)
  if valid_598721 != nil:
    section.add "uploadType", valid_598721
  var valid_598722 = query.getOrDefault("key")
  valid_598722 = validateParameter(valid_598722, JString, required = false,
                                 default = nil)
  if valid_598722 != nil:
    section.add "key", valid_598722
  var valid_598723 = query.getOrDefault("$.xgafv")
  valid_598723 = validateParameter(valid_598723, JString, required = false,
                                 default = newJString("1"))
  if valid_598723 != nil:
    section.add "$.xgafv", valid_598723
  var valid_598724 = query.getOrDefault("prettyPrint")
  valid_598724 = validateParameter(valid_598724, JBool, required = false,
                                 default = newJBool(true))
  if valid_598724 != nil:
    section.add "prettyPrint", valid_598724
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598725: Call_ClassroomCoursesTopicsDelete_598709; path: JsonNode;
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
  let valid = call_598725.validator(path, query, header, formData, body)
  let scheme = call_598725.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598725.url(scheme.get, call_598725.host, call_598725.base,
                         call_598725.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598725, url, valid)

proc call*(call_598726: Call_ClassroomCoursesTopicsDelete_598709; id: string;
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
  var path_598727 = newJObject()
  var query_598728 = newJObject()
  add(query_598728, "upload_protocol", newJString(uploadProtocol))
  add(query_598728, "fields", newJString(fields))
  add(query_598728, "quotaUser", newJString(quotaUser))
  add(query_598728, "alt", newJString(alt))
  add(query_598728, "oauth_token", newJString(oauthToken))
  add(query_598728, "callback", newJString(callback))
  add(query_598728, "access_token", newJString(accessToken))
  add(query_598728, "uploadType", newJString(uploadType))
  add(path_598727, "id", newJString(id))
  add(query_598728, "key", newJString(key))
  add(path_598727, "courseId", newJString(courseId))
  add(query_598728, "$.xgafv", newJString(Xgafv))
  add(query_598728, "prettyPrint", newJBool(prettyPrint))
  result = call_598726.call(path_598727, query_598728, nil, nil, nil)

var classroomCoursesTopicsDelete* = Call_ClassroomCoursesTopicsDelete_598709(
    name: "classroomCoursesTopicsDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com", route: "/v1/courses/{courseId}/topics/{id}",
    validator: validate_ClassroomCoursesTopicsDelete_598710, base: "/",
    url: url_ClassroomCoursesTopicsDelete_598711, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesUpdate_598771 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesUpdate_598773(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesUpdate_598772(path: JsonNode; query: JsonNode;
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
  var valid_598774 = path.getOrDefault("id")
  valid_598774 = validateParameter(valid_598774, JString, required = true,
                                 default = nil)
  if valid_598774 != nil:
    section.add "id", valid_598774
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
  var valid_598775 = query.getOrDefault("upload_protocol")
  valid_598775 = validateParameter(valid_598775, JString, required = false,
                                 default = nil)
  if valid_598775 != nil:
    section.add "upload_protocol", valid_598775
  var valid_598776 = query.getOrDefault("fields")
  valid_598776 = validateParameter(valid_598776, JString, required = false,
                                 default = nil)
  if valid_598776 != nil:
    section.add "fields", valid_598776
  var valid_598777 = query.getOrDefault("quotaUser")
  valid_598777 = validateParameter(valid_598777, JString, required = false,
                                 default = nil)
  if valid_598777 != nil:
    section.add "quotaUser", valid_598777
  var valid_598778 = query.getOrDefault("alt")
  valid_598778 = validateParameter(valid_598778, JString, required = false,
                                 default = newJString("json"))
  if valid_598778 != nil:
    section.add "alt", valid_598778
  var valid_598779 = query.getOrDefault("oauth_token")
  valid_598779 = validateParameter(valid_598779, JString, required = false,
                                 default = nil)
  if valid_598779 != nil:
    section.add "oauth_token", valid_598779
  var valid_598780 = query.getOrDefault("callback")
  valid_598780 = validateParameter(valid_598780, JString, required = false,
                                 default = nil)
  if valid_598780 != nil:
    section.add "callback", valid_598780
  var valid_598781 = query.getOrDefault("access_token")
  valid_598781 = validateParameter(valid_598781, JString, required = false,
                                 default = nil)
  if valid_598781 != nil:
    section.add "access_token", valid_598781
  var valid_598782 = query.getOrDefault("uploadType")
  valid_598782 = validateParameter(valid_598782, JString, required = false,
                                 default = nil)
  if valid_598782 != nil:
    section.add "uploadType", valid_598782
  var valid_598783 = query.getOrDefault("key")
  valid_598783 = validateParameter(valid_598783, JString, required = false,
                                 default = nil)
  if valid_598783 != nil:
    section.add "key", valid_598783
  var valid_598784 = query.getOrDefault("$.xgafv")
  valid_598784 = validateParameter(valid_598784, JString, required = false,
                                 default = newJString("1"))
  if valid_598784 != nil:
    section.add "$.xgafv", valid_598784
  var valid_598785 = query.getOrDefault("prettyPrint")
  valid_598785 = validateParameter(valid_598785, JBool, required = false,
                                 default = newJBool(true))
  if valid_598785 != nil:
    section.add "prettyPrint", valid_598785
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

proc call*(call_598787: Call_ClassroomCoursesUpdate_598771; path: JsonNode;
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
  let valid = call_598787.validator(path, query, header, formData, body)
  let scheme = call_598787.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598787.url(scheme.get, call_598787.host, call_598787.base,
                         call_598787.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598787, url, valid)

proc call*(call_598788: Call_ClassroomCoursesUpdate_598771; id: string;
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
  var path_598789 = newJObject()
  var query_598790 = newJObject()
  var body_598791 = newJObject()
  add(query_598790, "upload_protocol", newJString(uploadProtocol))
  add(query_598790, "fields", newJString(fields))
  add(query_598790, "quotaUser", newJString(quotaUser))
  add(query_598790, "alt", newJString(alt))
  add(query_598790, "oauth_token", newJString(oauthToken))
  add(query_598790, "callback", newJString(callback))
  add(query_598790, "access_token", newJString(accessToken))
  add(query_598790, "uploadType", newJString(uploadType))
  add(path_598789, "id", newJString(id))
  add(query_598790, "key", newJString(key))
  add(query_598790, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598791 = body
  add(query_598790, "prettyPrint", newJBool(prettyPrint))
  result = call_598788.call(path_598789, query_598790, nil, nil, body_598791)

var classroomCoursesUpdate* = Call_ClassroomCoursesUpdate_598771(
    name: "classroomCoursesUpdate", meth: HttpMethod.HttpPut,
    host: "classroom.googleapis.com", route: "/v1/courses/{id}",
    validator: validate_ClassroomCoursesUpdate_598772, base: "/",
    url: url_ClassroomCoursesUpdate_598773, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesGet_598752 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesGet_598754(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesGet_598753(path: JsonNode; query: JsonNode;
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
  var valid_598755 = path.getOrDefault("id")
  valid_598755 = validateParameter(valid_598755, JString, required = true,
                                 default = nil)
  if valid_598755 != nil:
    section.add "id", valid_598755
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
  var valid_598756 = query.getOrDefault("upload_protocol")
  valid_598756 = validateParameter(valid_598756, JString, required = false,
                                 default = nil)
  if valid_598756 != nil:
    section.add "upload_protocol", valid_598756
  var valid_598757 = query.getOrDefault("fields")
  valid_598757 = validateParameter(valid_598757, JString, required = false,
                                 default = nil)
  if valid_598757 != nil:
    section.add "fields", valid_598757
  var valid_598758 = query.getOrDefault("quotaUser")
  valid_598758 = validateParameter(valid_598758, JString, required = false,
                                 default = nil)
  if valid_598758 != nil:
    section.add "quotaUser", valid_598758
  var valid_598759 = query.getOrDefault("alt")
  valid_598759 = validateParameter(valid_598759, JString, required = false,
                                 default = newJString("json"))
  if valid_598759 != nil:
    section.add "alt", valid_598759
  var valid_598760 = query.getOrDefault("oauth_token")
  valid_598760 = validateParameter(valid_598760, JString, required = false,
                                 default = nil)
  if valid_598760 != nil:
    section.add "oauth_token", valid_598760
  var valid_598761 = query.getOrDefault("callback")
  valid_598761 = validateParameter(valid_598761, JString, required = false,
                                 default = nil)
  if valid_598761 != nil:
    section.add "callback", valid_598761
  var valid_598762 = query.getOrDefault("access_token")
  valid_598762 = validateParameter(valid_598762, JString, required = false,
                                 default = nil)
  if valid_598762 != nil:
    section.add "access_token", valid_598762
  var valid_598763 = query.getOrDefault("uploadType")
  valid_598763 = validateParameter(valid_598763, JString, required = false,
                                 default = nil)
  if valid_598763 != nil:
    section.add "uploadType", valid_598763
  var valid_598764 = query.getOrDefault("key")
  valid_598764 = validateParameter(valid_598764, JString, required = false,
                                 default = nil)
  if valid_598764 != nil:
    section.add "key", valid_598764
  var valid_598765 = query.getOrDefault("$.xgafv")
  valid_598765 = validateParameter(valid_598765, JString, required = false,
                                 default = newJString("1"))
  if valid_598765 != nil:
    section.add "$.xgafv", valid_598765
  var valid_598766 = query.getOrDefault("prettyPrint")
  valid_598766 = validateParameter(valid_598766, JBool, required = false,
                                 default = newJBool(true))
  if valid_598766 != nil:
    section.add "prettyPrint", valid_598766
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598767: Call_ClassroomCoursesGet_598752; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access the
  ## requested course or for access errors.
  ## * `NOT_FOUND` if no course exists with the requested ID.
  ## 
  let valid = call_598767.validator(path, query, header, formData, body)
  let scheme = call_598767.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598767.url(scheme.get, call_598767.host, call_598767.base,
                         call_598767.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598767, url, valid)

proc call*(call_598768: Call_ClassroomCoursesGet_598752; id: string;
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
  var path_598769 = newJObject()
  var query_598770 = newJObject()
  add(query_598770, "upload_protocol", newJString(uploadProtocol))
  add(query_598770, "fields", newJString(fields))
  add(query_598770, "quotaUser", newJString(quotaUser))
  add(query_598770, "alt", newJString(alt))
  add(query_598770, "oauth_token", newJString(oauthToken))
  add(query_598770, "callback", newJString(callback))
  add(query_598770, "access_token", newJString(accessToken))
  add(query_598770, "uploadType", newJString(uploadType))
  add(path_598769, "id", newJString(id))
  add(query_598770, "key", newJString(key))
  add(query_598770, "$.xgafv", newJString(Xgafv))
  add(query_598770, "prettyPrint", newJBool(prettyPrint))
  result = call_598768.call(path_598769, query_598770, nil, nil, nil)

var classroomCoursesGet* = Call_ClassroomCoursesGet_598752(
    name: "classroomCoursesGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/courses/{id}",
    validator: validate_ClassroomCoursesGet_598753, base: "/",
    url: url_ClassroomCoursesGet_598754, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesPatch_598811 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesPatch_598813(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesPatch_598812(path: JsonNode; query: JsonNode;
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
  var valid_598814 = path.getOrDefault("id")
  valid_598814 = validateParameter(valid_598814, JString, required = true,
                                 default = nil)
  if valid_598814 != nil:
    section.add "id", valid_598814
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
  var valid_598815 = query.getOrDefault("upload_protocol")
  valid_598815 = validateParameter(valid_598815, JString, required = false,
                                 default = nil)
  if valid_598815 != nil:
    section.add "upload_protocol", valid_598815
  var valid_598816 = query.getOrDefault("fields")
  valid_598816 = validateParameter(valid_598816, JString, required = false,
                                 default = nil)
  if valid_598816 != nil:
    section.add "fields", valid_598816
  var valid_598817 = query.getOrDefault("quotaUser")
  valid_598817 = validateParameter(valid_598817, JString, required = false,
                                 default = nil)
  if valid_598817 != nil:
    section.add "quotaUser", valid_598817
  var valid_598818 = query.getOrDefault("alt")
  valid_598818 = validateParameter(valid_598818, JString, required = false,
                                 default = newJString("json"))
  if valid_598818 != nil:
    section.add "alt", valid_598818
  var valid_598819 = query.getOrDefault("oauth_token")
  valid_598819 = validateParameter(valid_598819, JString, required = false,
                                 default = nil)
  if valid_598819 != nil:
    section.add "oauth_token", valid_598819
  var valid_598820 = query.getOrDefault("callback")
  valid_598820 = validateParameter(valid_598820, JString, required = false,
                                 default = nil)
  if valid_598820 != nil:
    section.add "callback", valid_598820
  var valid_598821 = query.getOrDefault("access_token")
  valid_598821 = validateParameter(valid_598821, JString, required = false,
                                 default = nil)
  if valid_598821 != nil:
    section.add "access_token", valid_598821
  var valid_598822 = query.getOrDefault("uploadType")
  valid_598822 = validateParameter(valid_598822, JString, required = false,
                                 default = nil)
  if valid_598822 != nil:
    section.add "uploadType", valid_598822
  var valid_598823 = query.getOrDefault("key")
  valid_598823 = validateParameter(valid_598823, JString, required = false,
                                 default = nil)
  if valid_598823 != nil:
    section.add "key", valid_598823
  var valid_598824 = query.getOrDefault("$.xgafv")
  valid_598824 = validateParameter(valid_598824, JString, required = false,
                                 default = newJString("1"))
  if valid_598824 != nil:
    section.add "$.xgafv", valid_598824
  var valid_598825 = query.getOrDefault("prettyPrint")
  valid_598825 = validateParameter(valid_598825, JBool, required = false,
                                 default = newJBool(true))
  if valid_598825 != nil:
    section.add "prettyPrint", valid_598825
  var valid_598826 = query.getOrDefault("updateMask")
  valid_598826 = validateParameter(valid_598826, JString, required = false,
                                 default = nil)
  if valid_598826 != nil:
    section.add "updateMask", valid_598826
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

proc call*(call_598828: Call_ClassroomCoursesPatch_598811; path: JsonNode;
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
  let valid = call_598828.validator(path, query, header, formData, body)
  let scheme = call_598828.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598828.url(scheme.get, call_598828.host, call_598828.base,
                         call_598828.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598828, url, valid)

proc call*(call_598829: Call_ClassroomCoursesPatch_598811; id: string;
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
  var path_598830 = newJObject()
  var query_598831 = newJObject()
  var body_598832 = newJObject()
  add(query_598831, "upload_protocol", newJString(uploadProtocol))
  add(query_598831, "fields", newJString(fields))
  add(query_598831, "quotaUser", newJString(quotaUser))
  add(query_598831, "alt", newJString(alt))
  add(query_598831, "oauth_token", newJString(oauthToken))
  add(query_598831, "callback", newJString(callback))
  add(query_598831, "access_token", newJString(accessToken))
  add(query_598831, "uploadType", newJString(uploadType))
  add(path_598830, "id", newJString(id))
  add(query_598831, "key", newJString(key))
  add(query_598831, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598832 = body
  add(query_598831, "prettyPrint", newJBool(prettyPrint))
  add(query_598831, "updateMask", newJString(updateMask))
  result = call_598829.call(path_598830, query_598831, nil, nil, body_598832)

var classroomCoursesPatch* = Call_ClassroomCoursesPatch_598811(
    name: "classroomCoursesPatch", meth: HttpMethod.HttpPatch,
    host: "classroom.googleapis.com", route: "/v1/courses/{id}",
    validator: validate_ClassroomCoursesPatch_598812, base: "/",
    url: url_ClassroomCoursesPatch_598813, schemes: {Scheme.Https})
type
  Call_ClassroomCoursesDelete_598792 = ref object of OpenApiRestCall_597421
proc url_ClassroomCoursesDelete_598794(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/courses/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomCoursesDelete_598793(path: JsonNode; query: JsonNode;
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
  var valid_598795 = path.getOrDefault("id")
  valid_598795 = validateParameter(valid_598795, JString, required = true,
                                 default = nil)
  if valid_598795 != nil:
    section.add "id", valid_598795
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
  var valid_598796 = query.getOrDefault("upload_protocol")
  valid_598796 = validateParameter(valid_598796, JString, required = false,
                                 default = nil)
  if valid_598796 != nil:
    section.add "upload_protocol", valid_598796
  var valid_598797 = query.getOrDefault("fields")
  valid_598797 = validateParameter(valid_598797, JString, required = false,
                                 default = nil)
  if valid_598797 != nil:
    section.add "fields", valid_598797
  var valid_598798 = query.getOrDefault("quotaUser")
  valid_598798 = validateParameter(valid_598798, JString, required = false,
                                 default = nil)
  if valid_598798 != nil:
    section.add "quotaUser", valid_598798
  var valid_598799 = query.getOrDefault("alt")
  valid_598799 = validateParameter(valid_598799, JString, required = false,
                                 default = newJString("json"))
  if valid_598799 != nil:
    section.add "alt", valid_598799
  var valid_598800 = query.getOrDefault("oauth_token")
  valid_598800 = validateParameter(valid_598800, JString, required = false,
                                 default = nil)
  if valid_598800 != nil:
    section.add "oauth_token", valid_598800
  var valid_598801 = query.getOrDefault("callback")
  valid_598801 = validateParameter(valid_598801, JString, required = false,
                                 default = nil)
  if valid_598801 != nil:
    section.add "callback", valid_598801
  var valid_598802 = query.getOrDefault("access_token")
  valid_598802 = validateParameter(valid_598802, JString, required = false,
                                 default = nil)
  if valid_598802 != nil:
    section.add "access_token", valid_598802
  var valid_598803 = query.getOrDefault("uploadType")
  valid_598803 = validateParameter(valid_598803, JString, required = false,
                                 default = nil)
  if valid_598803 != nil:
    section.add "uploadType", valid_598803
  var valid_598804 = query.getOrDefault("key")
  valid_598804 = validateParameter(valid_598804, JString, required = false,
                                 default = nil)
  if valid_598804 != nil:
    section.add "key", valid_598804
  var valid_598805 = query.getOrDefault("$.xgafv")
  valid_598805 = validateParameter(valid_598805, JString, required = false,
                                 default = newJString("1"))
  if valid_598805 != nil:
    section.add "$.xgafv", valid_598805
  var valid_598806 = query.getOrDefault("prettyPrint")
  valid_598806 = validateParameter(valid_598806, JBool, required = false,
                                 default = newJBool(true))
  if valid_598806 != nil:
    section.add "prettyPrint", valid_598806
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598807: Call_ClassroomCoursesDelete_598792; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a course.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to delete the
  ## requested course or for access errors.
  ## * `NOT_FOUND` if no course exists with the requested ID.
  ## 
  let valid = call_598807.validator(path, query, header, formData, body)
  let scheme = call_598807.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598807.url(scheme.get, call_598807.host, call_598807.base,
                         call_598807.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598807, url, valid)

proc call*(call_598808: Call_ClassroomCoursesDelete_598792; id: string;
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
  var path_598809 = newJObject()
  var query_598810 = newJObject()
  add(query_598810, "upload_protocol", newJString(uploadProtocol))
  add(query_598810, "fields", newJString(fields))
  add(query_598810, "quotaUser", newJString(quotaUser))
  add(query_598810, "alt", newJString(alt))
  add(query_598810, "oauth_token", newJString(oauthToken))
  add(query_598810, "callback", newJString(callback))
  add(query_598810, "access_token", newJString(accessToken))
  add(query_598810, "uploadType", newJString(uploadType))
  add(path_598809, "id", newJString(id))
  add(query_598810, "key", newJString(key))
  add(query_598810, "$.xgafv", newJString(Xgafv))
  add(query_598810, "prettyPrint", newJBool(prettyPrint))
  result = call_598808.call(path_598809, query_598810, nil, nil, nil)

var classroomCoursesDelete* = Call_ClassroomCoursesDelete_598792(
    name: "classroomCoursesDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com", route: "/v1/courses/{id}",
    validator: validate_ClassroomCoursesDelete_598793, base: "/",
    url: url_ClassroomCoursesDelete_598794, schemes: {Scheme.Https})
type
  Call_ClassroomInvitationsCreate_598854 = ref object of OpenApiRestCall_597421
proc url_ClassroomInvitationsCreate_598856(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClassroomInvitationsCreate_598855(path: JsonNode; query: JsonNode;
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
  var valid_598857 = query.getOrDefault("upload_protocol")
  valid_598857 = validateParameter(valid_598857, JString, required = false,
                                 default = nil)
  if valid_598857 != nil:
    section.add "upload_protocol", valid_598857
  var valid_598858 = query.getOrDefault("fields")
  valid_598858 = validateParameter(valid_598858, JString, required = false,
                                 default = nil)
  if valid_598858 != nil:
    section.add "fields", valid_598858
  var valid_598859 = query.getOrDefault("quotaUser")
  valid_598859 = validateParameter(valid_598859, JString, required = false,
                                 default = nil)
  if valid_598859 != nil:
    section.add "quotaUser", valid_598859
  var valid_598860 = query.getOrDefault("alt")
  valid_598860 = validateParameter(valid_598860, JString, required = false,
                                 default = newJString("json"))
  if valid_598860 != nil:
    section.add "alt", valid_598860
  var valid_598861 = query.getOrDefault("oauth_token")
  valid_598861 = validateParameter(valid_598861, JString, required = false,
                                 default = nil)
  if valid_598861 != nil:
    section.add "oauth_token", valid_598861
  var valid_598862 = query.getOrDefault("callback")
  valid_598862 = validateParameter(valid_598862, JString, required = false,
                                 default = nil)
  if valid_598862 != nil:
    section.add "callback", valid_598862
  var valid_598863 = query.getOrDefault("access_token")
  valid_598863 = validateParameter(valid_598863, JString, required = false,
                                 default = nil)
  if valid_598863 != nil:
    section.add "access_token", valid_598863
  var valid_598864 = query.getOrDefault("uploadType")
  valid_598864 = validateParameter(valid_598864, JString, required = false,
                                 default = nil)
  if valid_598864 != nil:
    section.add "uploadType", valid_598864
  var valid_598865 = query.getOrDefault("key")
  valid_598865 = validateParameter(valid_598865, JString, required = false,
                                 default = nil)
  if valid_598865 != nil:
    section.add "key", valid_598865
  var valid_598866 = query.getOrDefault("$.xgafv")
  valid_598866 = validateParameter(valid_598866, JString, required = false,
                                 default = newJString("1"))
  if valid_598866 != nil:
    section.add "$.xgafv", valid_598866
  var valid_598867 = query.getOrDefault("prettyPrint")
  valid_598867 = validateParameter(valid_598867, JBool, required = false,
                                 default = newJBool(true))
  if valid_598867 != nil:
    section.add "prettyPrint", valid_598867
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

proc call*(call_598869: Call_ClassroomInvitationsCreate_598854; path: JsonNode;
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
  let valid = call_598869.validator(path, query, header, formData, body)
  let scheme = call_598869.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598869.url(scheme.get, call_598869.host, call_598869.base,
                         call_598869.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598869, url, valid)

proc call*(call_598870: Call_ClassroomInvitationsCreate_598854;
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
  var query_598871 = newJObject()
  var body_598872 = newJObject()
  add(query_598871, "upload_protocol", newJString(uploadProtocol))
  add(query_598871, "fields", newJString(fields))
  add(query_598871, "quotaUser", newJString(quotaUser))
  add(query_598871, "alt", newJString(alt))
  add(query_598871, "oauth_token", newJString(oauthToken))
  add(query_598871, "callback", newJString(callback))
  add(query_598871, "access_token", newJString(accessToken))
  add(query_598871, "uploadType", newJString(uploadType))
  add(query_598871, "key", newJString(key))
  add(query_598871, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598872 = body
  add(query_598871, "prettyPrint", newJBool(prettyPrint))
  result = call_598870.call(nil, query_598871, nil, nil, body_598872)

var classroomInvitationsCreate* = Call_ClassroomInvitationsCreate_598854(
    name: "classroomInvitationsCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/invitations",
    validator: validate_ClassroomInvitationsCreate_598855, base: "/",
    url: url_ClassroomInvitationsCreate_598856, schemes: {Scheme.Https})
type
  Call_ClassroomInvitationsList_598833 = ref object of OpenApiRestCall_597421
proc url_ClassroomInvitationsList_598835(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClassroomInvitationsList_598834(path: JsonNode; query: JsonNode;
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
  var valid_598836 = query.getOrDefault("upload_protocol")
  valid_598836 = validateParameter(valid_598836, JString, required = false,
                                 default = nil)
  if valid_598836 != nil:
    section.add "upload_protocol", valid_598836
  var valid_598837 = query.getOrDefault("fields")
  valid_598837 = validateParameter(valid_598837, JString, required = false,
                                 default = nil)
  if valid_598837 != nil:
    section.add "fields", valid_598837
  var valid_598838 = query.getOrDefault("pageToken")
  valid_598838 = validateParameter(valid_598838, JString, required = false,
                                 default = nil)
  if valid_598838 != nil:
    section.add "pageToken", valid_598838
  var valid_598839 = query.getOrDefault("quotaUser")
  valid_598839 = validateParameter(valid_598839, JString, required = false,
                                 default = nil)
  if valid_598839 != nil:
    section.add "quotaUser", valid_598839
  var valid_598840 = query.getOrDefault("alt")
  valid_598840 = validateParameter(valid_598840, JString, required = false,
                                 default = newJString("json"))
  if valid_598840 != nil:
    section.add "alt", valid_598840
  var valid_598841 = query.getOrDefault("oauth_token")
  valid_598841 = validateParameter(valid_598841, JString, required = false,
                                 default = nil)
  if valid_598841 != nil:
    section.add "oauth_token", valid_598841
  var valid_598842 = query.getOrDefault("callback")
  valid_598842 = validateParameter(valid_598842, JString, required = false,
                                 default = nil)
  if valid_598842 != nil:
    section.add "callback", valid_598842
  var valid_598843 = query.getOrDefault("access_token")
  valid_598843 = validateParameter(valid_598843, JString, required = false,
                                 default = nil)
  if valid_598843 != nil:
    section.add "access_token", valid_598843
  var valid_598844 = query.getOrDefault("uploadType")
  valid_598844 = validateParameter(valid_598844, JString, required = false,
                                 default = nil)
  if valid_598844 != nil:
    section.add "uploadType", valid_598844
  var valid_598845 = query.getOrDefault("key")
  valid_598845 = validateParameter(valid_598845, JString, required = false,
                                 default = nil)
  if valid_598845 != nil:
    section.add "key", valid_598845
  var valid_598846 = query.getOrDefault("$.xgafv")
  valid_598846 = validateParameter(valid_598846, JString, required = false,
                                 default = newJString("1"))
  if valid_598846 != nil:
    section.add "$.xgafv", valid_598846
  var valid_598847 = query.getOrDefault("courseId")
  valid_598847 = validateParameter(valid_598847, JString, required = false,
                                 default = nil)
  if valid_598847 != nil:
    section.add "courseId", valid_598847
  var valid_598848 = query.getOrDefault("pageSize")
  valid_598848 = validateParameter(valid_598848, JInt, required = false, default = nil)
  if valid_598848 != nil:
    section.add "pageSize", valid_598848
  var valid_598849 = query.getOrDefault("prettyPrint")
  valid_598849 = validateParameter(valid_598849, JBool, required = false,
                                 default = newJBool(true))
  if valid_598849 != nil:
    section.add "prettyPrint", valid_598849
  var valid_598850 = query.getOrDefault("userId")
  valid_598850 = validateParameter(valid_598850, JString, required = false,
                                 default = nil)
  if valid_598850 != nil:
    section.add "userId", valid_598850
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598851: Call_ClassroomInvitationsList_598833; path: JsonNode;
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
  let valid = call_598851.validator(path, query, header, formData, body)
  let scheme = call_598851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598851.url(scheme.get, call_598851.host, call_598851.base,
                         call_598851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598851, url, valid)

proc call*(call_598852: Call_ClassroomInvitationsList_598833;
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
  var query_598853 = newJObject()
  add(query_598853, "upload_protocol", newJString(uploadProtocol))
  add(query_598853, "fields", newJString(fields))
  add(query_598853, "pageToken", newJString(pageToken))
  add(query_598853, "quotaUser", newJString(quotaUser))
  add(query_598853, "alt", newJString(alt))
  add(query_598853, "oauth_token", newJString(oauthToken))
  add(query_598853, "callback", newJString(callback))
  add(query_598853, "access_token", newJString(accessToken))
  add(query_598853, "uploadType", newJString(uploadType))
  add(query_598853, "key", newJString(key))
  add(query_598853, "$.xgafv", newJString(Xgafv))
  add(query_598853, "courseId", newJString(courseId))
  add(query_598853, "pageSize", newJInt(pageSize))
  add(query_598853, "prettyPrint", newJBool(prettyPrint))
  add(query_598853, "userId", newJString(userId))
  result = call_598852.call(nil, query_598853, nil, nil, nil)

var classroomInvitationsList* = Call_ClassroomInvitationsList_598833(
    name: "classroomInvitationsList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/invitations",
    validator: validate_ClassroomInvitationsList_598834, base: "/",
    url: url_ClassroomInvitationsList_598835, schemes: {Scheme.Https})
type
  Call_ClassroomInvitationsGet_598873 = ref object of OpenApiRestCall_597421
proc url_ClassroomInvitationsGet_598875(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/invitations/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomInvitationsGet_598874(path: JsonNode; query: JsonNode;
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
  var valid_598876 = path.getOrDefault("id")
  valid_598876 = validateParameter(valid_598876, JString, required = true,
                                 default = nil)
  if valid_598876 != nil:
    section.add "id", valid_598876
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
  var valid_598877 = query.getOrDefault("upload_protocol")
  valid_598877 = validateParameter(valid_598877, JString, required = false,
                                 default = nil)
  if valid_598877 != nil:
    section.add "upload_protocol", valid_598877
  var valid_598878 = query.getOrDefault("fields")
  valid_598878 = validateParameter(valid_598878, JString, required = false,
                                 default = nil)
  if valid_598878 != nil:
    section.add "fields", valid_598878
  var valid_598879 = query.getOrDefault("quotaUser")
  valid_598879 = validateParameter(valid_598879, JString, required = false,
                                 default = nil)
  if valid_598879 != nil:
    section.add "quotaUser", valid_598879
  var valid_598880 = query.getOrDefault("alt")
  valid_598880 = validateParameter(valid_598880, JString, required = false,
                                 default = newJString("json"))
  if valid_598880 != nil:
    section.add "alt", valid_598880
  var valid_598881 = query.getOrDefault("oauth_token")
  valid_598881 = validateParameter(valid_598881, JString, required = false,
                                 default = nil)
  if valid_598881 != nil:
    section.add "oauth_token", valid_598881
  var valid_598882 = query.getOrDefault("callback")
  valid_598882 = validateParameter(valid_598882, JString, required = false,
                                 default = nil)
  if valid_598882 != nil:
    section.add "callback", valid_598882
  var valid_598883 = query.getOrDefault("access_token")
  valid_598883 = validateParameter(valid_598883, JString, required = false,
                                 default = nil)
  if valid_598883 != nil:
    section.add "access_token", valid_598883
  var valid_598884 = query.getOrDefault("uploadType")
  valid_598884 = validateParameter(valid_598884, JString, required = false,
                                 default = nil)
  if valid_598884 != nil:
    section.add "uploadType", valid_598884
  var valid_598885 = query.getOrDefault("key")
  valid_598885 = validateParameter(valid_598885, JString, required = false,
                                 default = nil)
  if valid_598885 != nil:
    section.add "key", valid_598885
  var valid_598886 = query.getOrDefault("$.xgafv")
  valid_598886 = validateParameter(valid_598886, JString, required = false,
                                 default = newJString("1"))
  if valid_598886 != nil:
    section.add "$.xgafv", valid_598886
  var valid_598887 = query.getOrDefault("prettyPrint")
  valid_598887 = validateParameter(valid_598887, JBool, required = false,
                                 default = newJBool(true))
  if valid_598887 != nil:
    section.add "prettyPrint", valid_598887
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598888: Call_ClassroomInvitationsGet_598873; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns an invitation.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to view the
  ## requested invitation or for access errors.
  ## * `NOT_FOUND` if no invitation exists with the requested ID.
  ## 
  let valid = call_598888.validator(path, query, header, formData, body)
  let scheme = call_598888.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598888.url(scheme.get, call_598888.host, call_598888.base,
                         call_598888.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598888, url, valid)

proc call*(call_598889: Call_ClassroomInvitationsGet_598873; id: string;
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
  var path_598890 = newJObject()
  var query_598891 = newJObject()
  add(query_598891, "upload_protocol", newJString(uploadProtocol))
  add(query_598891, "fields", newJString(fields))
  add(query_598891, "quotaUser", newJString(quotaUser))
  add(query_598891, "alt", newJString(alt))
  add(query_598891, "oauth_token", newJString(oauthToken))
  add(query_598891, "callback", newJString(callback))
  add(query_598891, "access_token", newJString(accessToken))
  add(query_598891, "uploadType", newJString(uploadType))
  add(path_598890, "id", newJString(id))
  add(query_598891, "key", newJString(key))
  add(query_598891, "$.xgafv", newJString(Xgafv))
  add(query_598891, "prettyPrint", newJBool(prettyPrint))
  result = call_598889.call(path_598890, query_598891, nil, nil, nil)

var classroomInvitationsGet* = Call_ClassroomInvitationsGet_598873(
    name: "classroomInvitationsGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/invitations/{id}",
    validator: validate_ClassroomInvitationsGet_598874, base: "/",
    url: url_ClassroomInvitationsGet_598875, schemes: {Scheme.Https})
type
  Call_ClassroomInvitationsDelete_598892 = ref object of OpenApiRestCall_597421
proc url_ClassroomInvitationsDelete_598894(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/invitations/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomInvitationsDelete_598893(path: JsonNode; query: JsonNode;
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
  var valid_598895 = path.getOrDefault("id")
  valid_598895 = validateParameter(valid_598895, JString, required = true,
                                 default = nil)
  if valid_598895 != nil:
    section.add "id", valid_598895
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
  var valid_598896 = query.getOrDefault("upload_protocol")
  valid_598896 = validateParameter(valid_598896, JString, required = false,
                                 default = nil)
  if valid_598896 != nil:
    section.add "upload_protocol", valid_598896
  var valid_598897 = query.getOrDefault("fields")
  valid_598897 = validateParameter(valid_598897, JString, required = false,
                                 default = nil)
  if valid_598897 != nil:
    section.add "fields", valid_598897
  var valid_598898 = query.getOrDefault("quotaUser")
  valid_598898 = validateParameter(valid_598898, JString, required = false,
                                 default = nil)
  if valid_598898 != nil:
    section.add "quotaUser", valid_598898
  var valid_598899 = query.getOrDefault("alt")
  valid_598899 = validateParameter(valid_598899, JString, required = false,
                                 default = newJString("json"))
  if valid_598899 != nil:
    section.add "alt", valid_598899
  var valid_598900 = query.getOrDefault("oauth_token")
  valid_598900 = validateParameter(valid_598900, JString, required = false,
                                 default = nil)
  if valid_598900 != nil:
    section.add "oauth_token", valid_598900
  var valid_598901 = query.getOrDefault("callback")
  valid_598901 = validateParameter(valid_598901, JString, required = false,
                                 default = nil)
  if valid_598901 != nil:
    section.add "callback", valid_598901
  var valid_598902 = query.getOrDefault("access_token")
  valid_598902 = validateParameter(valid_598902, JString, required = false,
                                 default = nil)
  if valid_598902 != nil:
    section.add "access_token", valid_598902
  var valid_598903 = query.getOrDefault("uploadType")
  valid_598903 = validateParameter(valid_598903, JString, required = false,
                                 default = nil)
  if valid_598903 != nil:
    section.add "uploadType", valid_598903
  var valid_598904 = query.getOrDefault("key")
  valid_598904 = validateParameter(valid_598904, JString, required = false,
                                 default = nil)
  if valid_598904 != nil:
    section.add "key", valid_598904
  var valid_598905 = query.getOrDefault("$.xgafv")
  valid_598905 = validateParameter(valid_598905, JString, required = false,
                                 default = newJString("1"))
  if valid_598905 != nil:
    section.add "$.xgafv", valid_598905
  var valid_598906 = query.getOrDefault("prettyPrint")
  valid_598906 = validateParameter(valid_598906, JBool, required = false,
                                 default = newJBool(true))
  if valid_598906 != nil:
    section.add "prettyPrint", valid_598906
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598907: Call_ClassroomInvitationsDelete_598892; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an invitation.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to delete the
  ## requested invitation or for access errors.
  ## * `NOT_FOUND` if no invitation exists with the requested ID.
  ## 
  let valid = call_598907.validator(path, query, header, formData, body)
  let scheme = call_598907.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598907.url(scheme.get, call_598907.host, call_598907.base,
                         call_598907.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598907, url, valid)

proc call*(call_598908: Call_ClassroomInvitationsDelete_598892; id: string;
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
  var path_598909 = newJObject()
  var query_598910 = newJObject()
  add(query_598910, "upload_protocol", newJString(uploadProtocol))
  add(query_598910, "fields", newJString(fields))
  add(query_598910, "quotaUser", newJString(quotaUser))
  add(query_598910, "alt", newJString(alt))
  add(query_598910, "oauth_token", newJString(oauthToken))
  add(query_598910, "callback", newJString(callback))
  add(query_598910, "access_token", newJString(accessToken))
  add(query_598910, "uploadType", newJString(uploadType))
  add(path_598909, "id", newJString(id))
  add(query_598910, "key", newJString(key))
  add(query_598910, "$.xgafv", newJString(Xgafv))
  add(query_598910, "prettyPrint", newJBool(prettyPrint))
  result = call_598908.call(path_598909, query_598910, nil, nil, nil)

var classroomInvitationsDelete* = Call_ClassroomInvitationsDelete_598892(
    name: "classroomInvitationsDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com", route: "/v1/invitations/{id}",
    validator: validate_ClassroomInvitationsDelete_598893, base: "/",
    url: url_ClassroomInvitationsDelete_598894, schemes: {Scheme.Https})
type
  Call_ClassroomInvitationsAccept_598911 = ref object of OpenApiRestCall_597421
proc url_ClassroomInvitationsAccept_598913(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomInvitationsAccept_598912(path: JsonNode; query: JsonNode;
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
  var valid_598914 = path.getOrDefault("id")
  valid_598914 = validateParameter(valid_598914, JString, required = true,
                                 default = nil)
  if valid_598914 != nil:
    section.add "id", valid_598914
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
  var valid_598915 = query.getOrDefault("upload_protocol")
  valid_598915 = validateParameter(valid_598915, JString, required = false,
                                 default = nil)
  if valid_598915 != nil:
    section.add "upload_protocol", valid_598915
  var valid_598916 = query.getOrDefault("fields")
  valid_598916 = validateParameter(valid_598916, JString, required = false,
                                 default = nil)
  if valid_598916 != nil:
    section.add "fields", valid_598916
  var valid_598917 = query.getOrDefault("quotaUser")
  valid_598917 = validateParameter(valid_598917, JString, required = false,
                                 default = nil)
  if valid_598917 != nil:
    section.add "quotaUser", valid_598917
  var valid_598918 = query.getOrDefault("alt")
  valid_598918 = validateParameter(valid_598918, JString, required = false,
                                 default = newJString("json"))
  if valid_598918 != nil:
    section.add "alt", valid_598918
  var valid_598919 = query.getOrDefault("oauth_token")
  valid_598919 = validateParameter(valid_598919, JString, required = false,
                                 default = nil)
  if valid_598919 != nil:
    section.add "oauth_token", valid_598919
  var valid_598920 = query.getOrDefault("callback")
  valid_598920 = validateParameter(valid_598920, JString, required = false,
                                 default = nil)
  if valid_598920 != nil:
    section.add "callback", valid_598920
  var valid_598921 = query.getOrDefault("access_token")
  valid_598921 = validateParameter(valid_598921, JString, required = false,
                                 default = nil)
  if valid_598921 != nil:
    section.add "access_token", valid_598921
  var valid_598922 = query.getOrDefault("uploadType")
  valid_598922 = validateParameter(valid_598922, JString, required = false,
                                 default = nil)
  if valid_598922 != nil:
    section.add "uploadType", valid_598922
  var valid_598923 = query.getOrDefault("key")
  valid_598923 = validateParameter(valid_598923, JString, required = false,
                                 default = nil)
  if valid_598923 != nil:
    section.add "key", valid_598923
  var valid_598924 = query.getOrDefault("$.xgafv")
  valid_598924 = validateParameter(valid_598924, JString, required = false,
                                 default = newJString("1"))
  if valid_598924 != nil:
    section.add "$.xgafv", valid_598924
  var valid_598925 = query.getOrDefault("prettyPrint")
  valid_598925 = validateParameter(valid_598925, JBool, required = false,
                                 default = newJBool(true))
  if valid_598925 != nil:
    section.add "prettyPrint", valid_598925
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598926: Call_ClassroomInvitationsAccept_598911; path: JsonNode;
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
  let valid = call_598926.validator(path, query, header, formData, body)
  let scheme = call_598926.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598926.url(scheme.get, call_598926.host, call_598926.base,
                         call_598926.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598926, url, valid)

proc call*(call_598927: Call_ClassroomInvitationsAccept_598911; id: string;
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
  var path_598928 = newJObject()
  var query_598929 = newJObject()
  add(query_598929, "upload_protocol", newJString(uploadProtocol))
  add(query_598929, "fields", newJString(fields))
  add(query_598929, "quotaUser", newJString(quotaUser))
  add(query_598929, "alt", newJString(alt))
  add(query_598929, "oauth_token", newJString(oauthToken))
  add(query_598929, "callback", newJString(callback))
  add(query_598929, "access_token", newJString(accessToken))
  add(query_598929, "uploadType", newJString(uploadType))
  add(path_598928, "id", newJString(id))
  add(query_598929, "key", newJString(key))
  add(query_598929, "$.xgafv", newJString(Xgafv))
  add(query_598929, "prettyPrint", newJBool(prettyPrint))
  result = call_598927.call(path_598928, query_598929, nil, nil, nil)

var classroomInvitationsAccept* = Call_ClassroomInvitationsAccept_598911(
    name: "classroomInvitationsAccept", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/invitations/{id}:accept",
    validator: validate_ClassroomInvitationsAccept_598912, base: "/",
    url: url_ClassroomInvitationsAccept_598913, schemes: {Scheme.Https})
type
  Call_ClassroomRegistrationsCreate_598930 = ref object of OpenApiRestCall_597421
proc url_ClassroomRegistrationsCreate_598932(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClassroomRegistrationsCreate_598931(path: JsonNode; query: JsonNode;
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
  var valid_598933 = query.getOrDefault("upload_protocol")
  valid_598933 = validateParameter(valid_598933, JString, required = false,
                                 default = nil)
  if valid_598933 != nil:
    section.add "upload_protocol", valid_598933
  var valid_598934 = query.getOrDefault("fields")
  valid_598934 = validateParameter(valid_598934, JString, required = false,
                                 default = nil)
  if valid_598934 != nil:
    section.add "fields", valid_598934
  var valid_598935 = query.getOrDefault("quotaUser")
  valid_598935 = validateParameter(valid_598935, JString, required = false,
                                 default = nil)
  if valid_598935 != nil:
    section.add "quotaUser", valid_598935
  var valid_598936 = query.getOrDefault("alt")
  valid_598936 = validateParameter(valid_598936, JString, required = false,
                                 default = newJString("json"))
  if valid_598936 != nil:
    section.add "alt", valid_598936
  var valid_598937 = query.getOrDefault("oauth_token")
  valid_598937 = validateParameter(valid_598937, JString, required = false,
                                 default = nil)
  if valid_598937 != nil:
    section.add "oauth_token", valid_598937
  var valid_598938 = query.getOrDefault("callback")
  valid_598938 = validateParameter(valid_598938, JString, required = false,
                                 default = nil)
  if valid_598938 != nil:
    section.add "callback", valid_598938
  var valid_598939 = query.getOrDefault("access_token")
  valid_598939 = validateParameter(valid_598939, JString, required = false,
                                 default = nil)
  if valid_598939 != nil:
    section.add "access_token", valid_598939
  var valid_598940 = query.getOrDefault("uploadType")
  valid_598940 = validateParameter(valid_598940, JString, required = false,
                                 default = nil)
  if valid_598940 != nil:
    section.add "uploadType", valid_598940
  var valid_598941 = query.getOrDefault("key")
  valid_598941 = validateParameter(valid_598941, JString, required = false,
                                 default = nil)
  if valid_598941 != nil:
    section.add "key", valid_598941
  var valid_598942 = query.getOrDefault("$.xgafv")
  valid_598942 = validateParameter(valid_598942, JString, required = false,
                                 default = newJString("1"))
  if valid_598942 != nil:
    section.add "$.xgafv", valid_598942
  var valid_598943 = query.getOrDefault("prettyPrint")
  valid_598943 = validateParameter(valid_598943, JBool, required = false,
                                 default = newJBool(true))
  if valid_598943 != nil:
    section.add "prettyPrint", valid_598943
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

proc call*(call_598945: Call_ClassroomRegistrationsCreate_598930; path: JsonNode;
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
  let valid = call_598945.validator(path, query, header, formData, body)
  let scheme = call_598945.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598945.url(scheme.get, call_598945.host, call_598945.base,
                         call_598945.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598945, url, valid)

proc call*(call_598946: Call_ClassroomRegistrationsCreate_598930;
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
  var query_598947 = newJObject()
  var body_598948 = newJObject()
  add(query_598947, "upload_protocol", newJString(uploadProtocol))
  add(query_598947, "fields", newJString(fields))
  add(query_598947, "quotaUser", newJString(quotaUser))
  add(query_598947, "alt", newJString(alt))
  add(query_598947, "oauth_token", newJString(oauthToken))
  add(query_598947, "callback", newJString(callback))
  add(query_598947, "access_token", newJString(accessToken))
  add(query_598947, "uploadType", newJString(uploadType))
  add(query_598947, "key", newJString(key))
  add(query_598947, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598948 = body
  add(query_598947, "prettyPrint", newJBool(prettyPrint))
  result = call_598946.call(nil, query_598947, nil, nil, body_598948)

var classroomRegistrationsCreate* = Call_ClassroomRegistrationsCreate_598930(
    name: "classroomRegistrationsCreate", meth: HttpMethod.HttpPost,
    host: "classroom.googleapis.com", route: "/v1/registrations",
    validator: validate_ClassroomRegistrationsCreate_598931, base: "/",
    url: url_ClassroomRegistrationsCreate_598932, schemes: {Scheme.Https})
type
  Call_ClassroomRegistrationsDelete_598949 = ref object of OpenApiRestCall_597421
proc url_ClassroomRegistrationsDelete_598951(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "registrationId" in path, "`registrationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/registrations/"),
               (kind: VariableSegment, value: "registrationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomRegistrationsDelete_598950(path: JsonNode; query: JsonNode;
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
  var valid_598952 = path.getOrDefault("registrationId")
  valid_598952 = validateParameter(valid_598952, JString, required = true,
                                 default = nil)
  if valid_598952 != nil:
    section.add "registrationId", valid_598952
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
  var valid_598953 = query.getOrDefault("upload_protocol")
  valid_598953 = validateParameter(valid_598953, JString, required = false,
                                 default = nil)
  if valid_598953 != nil:
    section.add "upload_protocol", valid_598953
  var valid_598954 = query.getOrDefault("fields")
  valid_598954 = validateParameter(valid_598954, JString, required = false,
                                 default = nil)
  if valid_598954 != nil:
    section.add "fields", valid_598954
  var valid_598955 = query.getOrDefault("quotaUser")
  valid_598955 = validateParameter(valid_598955, JString, required = false,
                                 default = nil)
  if valid_598955 != nil:
    section.add "quotaUser", valid_598955
  var valid_598956 = query.getOrDefault("alt")
  valid_598956 = validateParameter(valid_598956, JString, required = false,
                                 default = newJString("json"))
  if valid_598956 != nil:
    section.add "alt", valid_598956
  var valid_598957 = query.getOrDefault("oauth_token")
  valid_598957 = validateParameter(valid_598957, JString, required = false,
                                 default = nil)
  if valid_598957 != nil:
    section.add "oauth_token", valid_598957
  var valid_598958 = query.getOrDefault("callback")
  valid_598958 = validateParameter(valid_598958, JString, required = false,
                                 default = nil)
  if valid_598958 != nil:
    section.add "callback", valid_598958
  var valid_598959 = query.getOrDefault("access_token")
  valid_598959 = validateParameter(valid_598959, JString, required = false,
                                 default = nil)
  if valid_598959 != nil:
    section.add "access_token", valid_598959
  var valid_598960 = query.getOrDefault("uploadType")
  valid_598960 = validateParameter(valid_598960, JString, required = false,
                                 default = nil)
  if valid_598960 != nil:
    section.add "uploadType", valid_598960
  var valid_598961 = query.getOrDefault("key")
  valid_598961 = validateParameter(valid_598961, JString, required = false,
                                 default = nil)
  if valid_598961 != nil:
    section.add "key", valid_598961
  var valid_598962 = query.getOrDefault("$.xgafv")
  valid_598962 = validateParameter(valid_598962, JString, required = false,
                                 default = newJString("1"))
  if valid_598962 != nil:
    section.add "$.xgafv", valid_598962
  var valid_598963 = query.getOrDefault("prettyPrint")
  valid_598963 = validateParameter(valid_598963, JBool, required = false,
                                 default = newJBool(true))
  if valid_598963 != nil:
    section.add "prettyPrint", valid_598963
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598964: Call_ClassroomRegistrationsDelete_598949; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a `Registration`, causing Classroom to stop sending notifications
  ## for that `Registration`.
  ## 
  let valid = call_598964.validator(path, query, header, formData, body)
  let scheme = call_598964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598964.url(scheme.get, call_598964.host, call_598964.base,
                         call_598964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598964, url, valid)

proc call*(call_598965: Call_ClassroomRegistrationsDelete_598949;
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
  var path_598966 = newJObject()
  var query_598967 = newJObject()
  add(query_598967, "upload_protocol", newJString(uploadProtocol))
  add(query_598967, "fields", newJString(fields))
  add(query_598967, "quotaUser", newJString(quotaUser))
  add(path_598966, "registrationId", newJString(registrationId))
  add(query_598967, "alt", newJString(alt))
  add(query_598967, "oauth_token", newJString(oauthToken))
  add(query_598967, "callback", newJString(callback))
  add(query_598967, "access_token", newJString(accessToken))
  add(query_598967, "uploadType", newJString(uploadType))
  add(query_598967, "key", newJString(key))
  add(query_598967, "$.xgafv", newJString(Xgafv))
  add(query_598967, "prettyPrint", newJBool(prettyPrint))
  result = call_598965.call(path_598966, query_598967, nil, nil, nil)

var classroomRegistrationsDelete* = Call_ClassroomRegistrationsDelete_598949(
    name: "classroomRegistrationsDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com", route: "/v1/registrations/{registrationId}",
    validator: validate_ClassroomRegistrationsDelete_598950, base: "/",
    url: url_ClassroomRegistrationsDelete_598951, schemes: {Scheme.Https})
type
  Call_ClassroomUserProfilesGuardianInvitationsCreate_598991 = ref object of OpenApiRestCall_597421
proc url_ClassroomUserProfilesGuardianInvitationsCreate_598993(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomUserProfilesGuardianInvitationsCreate_598992(
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
  var valid_598994 = path.getOrDefault("studentId")
  valid_598994 = validateParameter(valid_598994, JString, required = true,
                                 default = nil)
  if valid_598994 != nil:
    section.add "studentId", valid_598994
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
  var valid_598995 = query.getOrDefault("upload_protocol")
  valid_598995 = validateParameter(valid_598995, JString, required = false,
                                 default = nil)
  if valid_598995 != nil:
    section.add "upload_protocol", valid_598995
  var valid_598996 = query.getOrDefault("fields")
  valid_598996 = validateParameter(valid_598996, JString, required = false,
                                 default = nil)
  if valid_598996 != nil:
    section.add "fields", valid_598996
  var valid_598997 = query.getOrDefault("quotaUser")
  valid_598997 = validateParameter(valid_598997, JString, required = false,
                                 default = nil)
  if valid_598997 != nil:
    section.add "quotaUser", valid_598997
  var valid_598998 = query.getOrDefault("alt")
  valid_598998 = validateParameter(valid_598998, JString, required = false,
                                 default = newJString("json"))
  if valid_598998 != nil:
    section.add "alt", valid_598998
  var valid_598999 = query.getOrDefault("oauth_token")
  valid_598999 = validateParameter(valid_598999, JString, required = false,
                                 default = nil)
  if valid_598999 != nil:
    section.add "oauth_token", valid_598999
  var valid_599000 = query.getOrDefault("callback")
  valid_599000 = validateParameter(valid_599000, JString, required = false,
                                 default = nil)
  if valid_599000 != nil:
    section.add "callback", valid_599000
  var valid_599001 = query.getOrDefault("access_token")
  valid_599001 = validateParameter(valid_599001, JString, required = false,
                                 default = nil)
  if valid_599001 != nil:
    section.add "access_token", valid_599001
  var valid_599002 = query.getOrDefault("uploadType")
  valid_599002 = validateParameter(valid_599002, JString, required = false,
                                 default = nil)
  if valid_599002 != nil:
    section.add "uploadType", valid_599002
  var valid_599003 = query.getOrDefault("key")
  valid_599003 = validateParameter(valid_599003, JString, required = false,
                                 default = nil)
  if valid_599003 != nil:
    section.add "key", valid_599003
  var valid_599004 = query.getOrDefault("$.xgafv")
  valid_599004 = validateParameter(valid_599004, JString, required = false,
                                 default = newJString("1"))
  if valid_599004 != nil:
    section.add "$.xgafv", valid_599004
  var valid_599005 = query.getOrDefault("prettyPrint")
  valid_599005 = validateParameter(valid_599005, JBool, required = false,
                                 default = newJBool(true))
  if valid_599005 != nil:
    section.add "prettyPrint", valid_599005
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

proc call*(call_599007: Call_ClassroomUserProfilesGuardianInvitationsCreate_598991;
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
  let valid = call_599007.validator(path, query, header, formData, body)
  let scheme = call_599007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599007.url(scheme.get, call_599007.host, call_599007.base,
                         call_599007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599007, url, valid)

proc call*(call_599008: Call_ClassroomUserProfilesGuardianInvitationsCreate_598991;
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
  var path_599009 = newJObject()
  var query_599010 = newJObject()
  var body_599011 = newJObject()
  add(query_599010, "upload_protocol", newJString(uploadProtocol))
  add(query_599010, "fields", newJString(fields))
  add(query_599010, "quotaUser", newJString(quotaUser))
  add(query_599010, "alt", newJString(alt))
  add(query_599010, "oauth_token", newJString(oauthToken))
  add(query_599010, "callback", newJString(callback))
  add(query_599010, "access_token", newJString(accessToken))
  add(query_599010, "uploadType", newJString(uploadType))
  add(path_599009, "studentId", newJString(studentId))
  add(query_599010, "key", newJString(key))
  add(query_599010, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_599011 = body
  add(query_599010, "prettyPrint", newJBool(prettyPrint))
  result = call_599008.call(path_599009, query_599010, nil, nil, body_599011)

var classroomUserProfilesGuardianInvitationsCreate* = Call_ClassroomUserProfilesGuardianInvitationsCreate_598991(
    name: "classroomUserProfilesGuardianInvitationsCreate",
    meth: HttpMethod.HttpPost, host: "classroom.googleapis.com",
    route: "/v1/userProfiles/{studentId}/guardianInvitations",
    validator: validate_ClassroomUserProfilesGuardianInvitationsCreate_598992,
    base: "/", url: url_ClassroomUserProfilesGuardianInvitationsCreate_598993,
    schemes: {Scheme.Https})
type
  Call_ClassroomUserProfilesGuardianInvitationsList_598968 = ref object of OpenApiRestCall_597421
proc url_ClassroomUserProfilesGuardianInvitationsList_598970(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomUserProfilesGuardianInvitationsList_598969(path: JsonNode;
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
  var valid_598971 = path.getOrDefault("studentId")
  valid_598971 = validateParameter(valid_598971, JString, required = true,
                                 default = nil)
  if valid_598971 != nil:
    section.add "studentId", valid_598971
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
  var valid_598972 = query.getOrDefault("upload_protocol")
  valid_598972 = validateParameter(valid_598972, JString, required = false,
                                 default = nil)
  if valid_598972 != nil:
    section.add "upload_protocol", valid_598972
  var valid_598973 = query.getOrDefault("fields")
  valid_598973 = validateParameter(valid_598973, JString, required = false,
                                 default = nil)
  if valid_598973 != nil:
    section.add "fields", valid_598973
  var valid_598974 = query.getOrDefault("pageToken")
  valid_598974 = validateParameter(valid_598974, JString, required = false,
                                 default = nil)
  if valid_598974 != nil:
    section.add "pageToken", valid_598974
  var valid_598975 = query.getOrDefault("quotaUser")
  valid_598975 = validateParameter(valid_598975, JString, required = false,
                                 default = nil)
  if valid_598975 != nil:
    section.add "quotaUser", valid_598975
  var valid_598976 = query.getOrDefault("alt")
  valid_598976 = validateParameter(valid_598976, JString, required = false,
                                 default = newJString("json"))
  if valid_598976 != nil:
    section.add "alt", valid_598976
  var valid_598977 = query.getOrDefault("oauth_token")
  valid_598977 = validateParameter(valid_598977, JString, required = false,
                                 default = nil)
  if valid_598977 != nil:
    section.add "oauth_token", valid_598977
  var valid_598978 = query.getOrDefault("callback")
  valid_598978 = validateParameter(valid_598978, JString, required = false,
                                 default = nil)
  if valid_598978 != nil:
    section.add "callback", valid_598978
  var valid_598979 = query.getOrDefault("access_token")
  valid_598979 = validateParameter(valid_598979, JString, required = false,
                                 default = nil)
  if valid_598979 != nil:
    section.add "access_token", valid_598979
  var valid_598980 = query.getOrDefault("uploadType")
  valid_598980 = validateParameter(valid_598980, JString, required = false,
                                 default = nil)
  if valid_598980 != nil:
    section.add "uploadType", valid_598980
  var valid_598981 = query.getOrDefault("key")
  valid_598981 = validateParameter(valid_598981, JString, required = false,
                                 default = nil)
  if valid_598981 != nil:
    section.add "key", valid_598981
  var valid_598982 = query.getOrDefault("states")
  valid_598982 = validateParameter(valid_598982, JArray, required = false,
                                 default = nil)
  if valid_598982 != nil:
    section.add "states", valid_598982
  var valid_598983 = query.getOrDefault("invitedEmailAddress")
  valid_598983 = validateParameter(valid_598983, JString, required = false,
                                 default = nil)
  if valid_598983 != nil:
    section.add "invitedEmailAddress", valid_598983
  var valid_598984 = query.getOrDefault("$.xgafv")
  valid_598984 = validateParameter(valid_598984, JString, required = false,
                                 default = newJString("1"))
  if valid_598984 != nil:
    section.add "$.xgafv", valid_598984
  var valid_598985 = query.getOrDefault("pageSize")
  valid_598985 = validateParameter(valid_598985, JInt, required = false, default = nil)
  if valid_598985 != nil:
    section.add "pageSize", valid_598985
  var valid_598986 = query.getOrDefault("prettyPrint")
  valid_598986 = validateParameter(valid_598986, JBool, required = false,
                                 default = newJBool(true))
  if valid_598986 != nil:
    section.add "prettyPrint", valid_598986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598987: Call_ClassroomUserProfilesGuardianInvitationsList_598968;
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
  let valid = call_598987.validator(path, query, header, formData, body)
  let scheme = call_598987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598987.url(scheme.get, call_598987.host, call_598987.base,
                         call_598987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598987, url, valid)

proc call*(call_598988: Call_ClassroomUserProfilesGuardianInvitationsList_598968;
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
  var path_598989 = newJObject()
  var query_598990 = newJObject()
  add(query_598990, "upload_protocol", newJString(uploadProtocol))
  add(query_598990, "fields", newJString(fields))
  add(query_598990, "pageToken", newJString(pageToken))
  add(query_598990, "quotaUser", newJString(quotaUser))
  add(query_598990, "alt", newJString(alt))
  add(query_598990, "oauth_token", newJString(oauthToken))
  add(query_598990, "callback", newJString(callback))
  add(query_598990, "access_token", newJString(accessToken))
  add(query_598990, "uploadType", newJString(uploadType))
  add(path_598989, "studentId", newJString(studentId))
  add(query_598990, "key", newJString(key))
  if states != nil:
    query_598990.add "states", states
  add(query_598990, "invitedEmailAddress", newJString(invitedEmailAddress))
  add(query_598990, "$.xgafv", newJString(Xgafv))
  add(query_598990, "pageSize", newJInt(pageSize))
  add(query_598990, "prettyPrint", newJBool(prettyPrint))
  result = call_598988.call(path_598989, query_598990, nil, nil, nil)

var classroomUserProfilesGuardianInvitationsList* = Call_ClassroomUserProfilesGuardianInvitationsList_598968(
    name: "classroomUserProfilesGuardianInvitationsList",
    meth: HttpMethod.HttpGet, host: "classroom.googleapis.com",
    route: "/v1/userProfiles/{studentId}/guardianInvitations",
    validator: validate_ClassroomUserProfilesGuardianInvitationsList_598969,
    base: "/", url: url_ClassroomUserProfilesGuardianInvitationsList_598970,
    schemes: {Scheme.Https})
type
  Call_ClassroomUserProfilesGuardianInvitationsGet_599012 = ref object of OpenApiRestCall_597421
proc url_ClassroomUserProfilesGuardianInvitationsGet_599014(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomUserProfilesGuardianInvitationsGet_599013(path: JsonNode;
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
  var valid_599015 = path.getOrDefault("studentId")
  valid_599015 = validateParameter(valid_599015, JString, required = true,
                                 default = nil)
  if valid_599015 != nil:
    section.add "studentId", valid_599015
  var valid_599016 = path.getOrDefault("invitationId")
  valid_599016 = validateParameter(valid_599016, JString, required = true,
                                 default = nil)
  if valid_599016 != nil:
    section.add "invitationId", valid_599016
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
  var valid_599017 = query.getOrDefault("upload_protocol")
  valid_599017 = validateParameter(valid_599017, JString, required = false,
                                 default = nil)
  if valid_599017 != nil:
    section.add "upload_protocol", valid_599017
  var valid_599018 = query.getOrDefault("fields")
  valid_599018 = validateParameter(valid_599018, JString, required = false,
                                 default = nil)
  if valid_599018 != nil:
    section.add "fields", valid_599018
  var valid_599019 = query.getOrDefault("quotaUser")
  valid_599019 = validateParameter(valid_599019, JString, required = false,
                                 default = nil)
  if valid_599019 != nil:
    section.add "quotaUser", valid_599019
  var valid_599020 = query.getOrDefault("alt")
  valid_599020 = validateParameter(valid_599020, JString, required = false,
                                 default = newJString("json"))
  if valid_599020 != nil:
    section.add "alt", valid_599020
  var valid_599021 = query.getOrDefault("oauth_token")
  valid_599021 = validateParameter(valid_599021, JString, required = false,
                                 default = nil)
  if valid_599021 != nil:
    section.add "oauth_token", valid_599021
  var valid_599022 = query.getOrDefault("callback")
  valid_599022 = validateParameter(valid_599022, JString, required = false,
                                 default = nil)
  if valid_599022 != nil:
    section.add "callback", valid_599022
  var valid_599023 = query.getOrDefault("access_token")
  valid_599023 = validateParameter(valid_599023, JString, required = false,
                                 default = nil)
  if valid_599023 != nil:
    section.add "access_token", valid_599023
  var valid_599024 = query.getOrDefault("uploadType")
  valid_599024 = validateParameter(valid_599024, JString, required = false,
                                 default = nil)
  if valid_599024 != nil:
    section.add "uploadType", valid_599024
  var valid_599025 = query.getOrDefault("key")
  valid_599025 = validateParameter(valid_599025, JString, required = false,
                                 default = nil)
  if valid_599025 != nil:
    section.add "key", valid_599025
  var valid_599026 = query.getOrDefault("$.xgafv")
  valid_599026 = validateParameter(valid_599026, JString, required = false,
                                 default = newJString("1"))
  if valid_599026 != nil:
    section.add "$.xgafv", valid_599026
  var valid_599027 = query.getOrDefault("prettyPrint")
  valid_599027 = validateParameter(valid_599027, JBool, required = false,
                                 default = newJBool(true))
  if valid_599027 != nil:
    section.add "prettyPrint", valid_599027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599028: Call_ClassroomUserProfilesGuardianInvitationsGet_599012;
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
  let valid = call_599028.validator(path, query, header, formData, body)
  let scheme = call_599028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599028.url(scheme.get, call_599028.host, call_599028.base,
                         call_599028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599028, url, valid)

proc call*(call_599029: Call_ClassroomUserProfilesGuardianInvitationsGet_599012;
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
  var path_599030 = newJObject()
  var query_599031 = newJObject()
  add(query_599031, "upload_protocol", newJString(uploadProtocol))
  add(query_599031, "fields", newJString(fields))
  add(query_599031, "quotaUser", newJString(quotaUser))
  add(query_599031, "alt", newJString(alt))
  add(query_599031, "oauth_token", newJString(oauthToken))
  add(query_599031, "callback", newJString(callback))
  add(query_599031, "access_token", newJString(accessToken))
  add(query_599031, "uploadType", newJString(uploadType))
  add(path_599030, "studentId", newJString(studentId))
  add(query_599031, "key", newJString(key))
  add(query_599031, "$.xgafv", newJString(Xgafv))
  add(query_599031, "prettyPrint", newJBool(prettyPrint))
  add(path_599030, "invitationId", newJString(invitationId))
  result = call_599029.call(path_599030, query_599031, nil, nil, nil)

var classroomUserProfilesGuardianInvitationsGet* = Call_ClassroomUserProfilesGuardianInvitationsGet_599012(
    name: "classroomUserProfilesGuardianInvitationsGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com",
    route: "/v1/userProfiles/{studentId}/guardianInvitations/{invitationId}",
    validator: validate_ClassroomUserProfilesGuardianInvitationsGet_599013,
    base: "/", url: url_ClassroomUserProfilesGuardianInvitationsGet_599014,
    schemes: {Scheme.Https})
type
  Call_ClassroomUserProfilesGuardianInvitationsPatch_599032 = ref object of OpenApiRestCall_597421
proc url_ClassroomUserProfilesGuardianInvitationsPatch_599034(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomUserProfilesGuardianInvitationsPatch_599033(
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
  var valid_599035 = path.getOrDefault("studentId")
  valid_599035 = validateParameter(valid_599035, JString, required = true,
                                 default = nil)
  if valid_599035 != nil:
    section.add "studentId", valid_599035
  var valid_599036 = path.getOrDefault("invitationId")
  valid_599036 = validateParameter(valid_599036, JString, required = true,
                                 default = nil)
  if valid_599036 != nil:
    section.add "invitationId", valid_599036
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
  var valid_599037 = query.getOrDefault("upload_protocol")
  valid_599037 = validateParameter(valid_599037, JString, required = false,
                                 default = nil)
  if valid_599037 != nil:
    section.add "upload_protocol", valid_599037
  var valid_599038 = query.getOrDefault("fields")
  valid_599038 = validateParameter(valid_599038, JString, required = false,
                                 default = nil)
  if valid_599038 != nil:
    section.add "fields", valid_599038
  var valid_599039 = query.getOrDefault("quotaUser")
  valid_599039 = validateParameter(valid_599039, JString, required = false,
                                 default = nil)
  if valid_599039 != nil:
    section.add "quotaUser", valid_599039
  var valid_599040 = query.getOrDefault("alt")
  valid_599040 = validateParameter(valid_599040, JString, required = false,
                                 default = newJString("json"))
  if valid_599040 != nil:
    section.add "alt", valid_599040
  var valid_599041 = query.getOrDefault("oauth_token")
  valid_599041 = validateParameter(valid_599041, JString, required = false,
                                 default = nil)
  if valid_599041 != nil:
    section.add "oauth_token", valid_599041
  var valid_599042 = query.getOrDefault("callback")
  valid_599042 = validateParameter(valid_599042, JString, required = false,
                                 default = nil)
  if valid_599042 != nil:
    section.add "callback", valid_599042
  var valid_599043 = query.getOrDefault("access_token")
  valid_599043 = validateParameter(valid_599043, JString, required = false,
                                 default = nil)
  if valid_599043 != nil:
    section.add "access_token", valid_599043
  var valid_599044 = query.getOrDefault("uploadType")
  valid_599044 = validateParameter(valid_599044, JString, required = false,
                                 default = nil)
  if valid_599044 != nil:
    section.add "uploadType", valid_599044
  var valid_599045 = query.getOrDefault("key")
  valid_599045 = validateParameter(valid_599045, JString, required = false,
                                 default = nil)
  if valid_599045 != nil:
    section.add "key", valid_599045
  var valid_599046 = query.getOrDefault("$.xgafv")
  valid_599046 = validateParameter(valid_599046, JString, required = false,
                                 default = newJString("1"))
  if valid_599046 != nil:
    section.add "$.xgafv", valid_599046
  var valid_599047 = query.getOrDefault("prettyPrint")
  valid_599047 = validateParameter(valid_599047, JBool, required = false,
                                 default = newJBool(true))
  if valid_599047 != nil:
    section.add "prettyPrint", valid_599047
  var valid_599048 = query.getOrDefault("updateMask")
  valid_599048 = validateParameter(valid_599048, JString, required = false,
                                 default = nil)
  if valid_599048 != nil:
    section.add "updateMask", valid_599048
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

proc call*(call_599050: Call_ClassroomUserProfilesGuardianInvitationsPatch_599032;
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
  let valid = call_599050.validator(path, query, header, formData, body)
  let scheme = call_599050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599050.url(scheme.get, call_599050.host, call_599050.base,
                         call_599050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599050, url, valid)

proc call*(call_599051: Call_ClassroomUserProfilesGuardianInvitationsPatch_599032;
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
  var path_599052 = newJObject()
  var query_599053 = newJObject()
  var body_599054 = newJObject()
  add(query_599053, "upload_protocol", newJString(uploadProtocol))
  add(query_599053, "fields", newJString(fields))
  add(query_599053, "quotaUser", newJString(quotaUser))
  add(query_599053, "alt", newJString(alt))
  add(query_599053, "oauth_token", newJString(oauthToken))
  add(query_599053, "callback", newJString(callback))
  add(query_599053, "access_token", newJString(accessToken))
  add(query_599053, "uploadType", newJString(uploadType))
  add(path_599052, "studentId", newJString(studentId))
  add(query_599053, "key", newJString(key))
  add(query_599053, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_599054 = body
  add(query_599053, "prettyPrint", newJBool(prettyPrint))
  add(path_599052, "invitationId", newJString(invitationId))
  add(query_599053, "updateMask", newJString(updateMask))
  result = call_599051.call(path_599052, query_599053, nil, nil, body_599054)

var classroomUserProfilesGuardianInvitationsPatch* = Call_ClassroomUserProfilesGuardianInvitationsPatch_599032(
    name: "classroomUserProfilesGuardianInvitationsPatch",
    meth: HttpMethod.HttpPatch, host: "classroom.googleapis.com",
    route: "/v1/userProfiles/{studentId}/guardianInvitations/{invitationId}",
    validator: validate_ClassroomUserProfilesGuardianInvitationsPatch_599033,
    base: "/", url: url_ClassroomUserProfilesGuardianInvitationsPatch_599034,
    schemes: {Scheme.Https})
type
  Call_ClassroomUserProfilesGuardiansList_599055 = ref object of OpenApiRestCall_597421
proc url_ClassroomUserProfilesGuardiansList_599057(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomUserProfilesGuardiansList_599056(path: JsonNode;
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
  var valid_599058 = path.getOrDefault("studentId")
  valid_599058 = validateParameter(valid_599058, JString, required = true,
                                 default = nil)
  if valid_599058 != nil:
    section.add "studentId", valid_599058
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
  var valid_599059 = query.getOrDefault("upload_protocol")
  valid_599059 = validateParameter(valid_599059, JString, required = false,
                                 default = nil)
  if valid_599059 != nil:
    section.add "upload_protocol", valid_599059
  var valid_599060 = query.getOrDefault("fields")
  valid_599060 = validateParameter(valid_599060, JString, required = false,
                                 default = nil)
  if valid_599060 != nil:
    section.add "fields", valid_599060
  var valid_599061 = query.getOrDefault("pageToken")
  valid_599061 = validateParameter(valid_599061, JString, required = false,
                                 default = nil)
  if valid_599061 != nil:
    section.add "pageToken", valid_599061
  var valid_599062 = query.getOrDefault("quotaUser")
  valid_599062 = validateParameter(valid_599062, JString, required = false,
                                 default = nil)
  if valid_599062 != nil:
    section.add "quotaUser", valid_599062
  var valid_599063 = query.getOrDefault("alt")
  valid_599063 = validateParameter(valid_599063, JString, required = false,
                                 default = newJString("json"))
  if valid_599063 != nil:
    section.add "alt", valid_599063
  var valid_599064 = query.getOrDefault("oauth_token")
  valid_599064 = validateParameter(valid_599064, JString, required = false,
                                 default = nil)
  if valid_599064 != nil:
    section.add "oauth_token", valid_599064
  var valid_599065 = query.getOrDefault("callback")
  valid_599065 = validateParameter(valid_599065, JString, required = false,
                                 default = nil)
  if valid_599065 != nil:
    section.add "callback", valid_599065
  var valid_599066 = query.getOrDefault("access_token")
  valid_599066 = validateParameter(valid_599066, JString, required = false,
                                 default = nil)
  if valid_599066 != nil:
    section.add "access_token", valid_599066
  var valid_599067 = query.getOrDefault("uploadType")
  valid_599067 = validateParameter(valid_599067, JString, required = false,
                                 default = nil)
  if valid_599067 != nil:
    section.add "uploadType", valid_599067
  var valid_599068 = query.getOrDefault("key")
  valid_599068 = validateParameter(valid_599068, JString, required = false,
                                 default = nil)
  if valid_599068 != nil:
    section.add "key", valid_599068
  var valid_599069 = query.getOrDefault("invitedEmailAddress")
  valid_599069 = validateParameter(valid_599069, JString, required = false,
                                 default = nil)
  if valid_599069 != nil:
    section.add "invitedEmailAddress", valid_599069
  var valid_599070 = query.getOrDefault("$.xgafv")
  valid_599070 = validateParameter(valid_599070, JString, required = false,
                                 default = newJString("1"))
  if valid_599070 != nil:
    section.add "$.xgafv", valid_599070
  var valid_599071 = query.getOrDefault("pageSize")
  valid_599071 = validateParameter(valid_599071, JInt, required = false, default = nil)
  if valid_599071 != nil:
    section.add "pageSize", valid_599071
  var valid_599072 = query.getOrDefault("prettyPrint")
  valid_599072 = validateParameter(valid_599072, JBool, required = false,
                                 default = newJBool(true))
  if valid_599072 != nil:
    section.add "prettyPrint", valid_599072
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599073: Call_ClassroomUserProfilesGuardiansList_599055;
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
  let valid = call_599073.validator(path, query, header, formData, body)
  let scheme = call_599073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599073.url(scheme.get, call_599073.host, call_599073.base,
                         call_599073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599073, url, valid)

proc call*(call_599074: Call_ClassroomUserProfilesGuardiansList_599055;
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
  var path_599075 = newJObject()
  var query_599076 = newJObject()
  add(query_599076, "upload_protocol", newJString(uploadProtocol))
  add(query_599076, "fields", newJString(fields))
  add(query_599076, "pageToken", newJString(pageToken))
  add(query_599076, "quotaUser", newJString(quotaUser))
  add(query_599076, "alt", newJString(alt))
  add(query_599076, "oauth_token", newJString(oauthToken))
  add(query_599076, "callback", newJString(callback))
  add(query_599076, "access_token", newJString(accessToken))
  add(query_599076, "uploadType", newJString(uploadType))
  add(path_599075, "studentId", newJString(studentId))
  add(query_599076, "key", newJString(key))
  add(query_599076, "invitedEmailAddress", newJString(invitedEmailAddress))
  add(query_599076, "$.xgafv", newJString(Xgafv))
  add(query_599076, "pageSize", newJInt(pageSize))
  add(query_599076, "prettyPrint", newJBool(prettyPrint))
  result = call_599074.call(path_599075, query_599076, nil, nil, nil)

var classroomUserProfilesGuardiansList* = Call_ClassroomUserProfilesGuardiansList_599055(
    name: "classroomUserProfilesGuardiansList", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com",
    route: "/v1/userProfiles/{studentId}/guardians",
    validator: validate_ClassroomUserProfilesGuardiansList_599056, base: "/",
    url: url_ClassroomUserProfilesGuardiansList_599057, schemes: {Scheme.Https})
type
  Call_ClassroomUserProfilesGuardiansGet_599077 = ref object of OpenApiRestCall_597421
proc url_ClassroomUserProfilesGuardiansGet_599079(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomUserProfilesGuardiansGet_599078(path: JsonNode;
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
  var valid_599080 = path.getOrDefault("guardianId")
  valid_599080 = validateParameter(valid_599080, JString, required = true,
                                 default = nil)
  if valid_599080 != nil:
    section.add "guardianId", valid_599080
  var valid_599081 = path.getOrDefault("studentId")
  valid_599081 = validateParameter(valid_599081, JString, required = true,
                                 default = nil)
  if valid_599081 != nil:
    section.add "studentId", valid_599081
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
  var valid_599082 = query.getOrDefault("upload_protocol")
  valid_599082 = validateParameter(valid_599082, JString, required = false,
                                 default = nil)
  if valid_599082 != nil:
    section.add "upload_protocol", valid_599082
  var valid_599083 = query.getOrDefault("fields")
  valid_599083 = validateParameter(valid_599083, JString, required = false,
                                 default = nil)
  if valid_599083 != nil:
    section.add "fields", valid_599083
  var valid_599084 = query.getOrDefault("quotaUser")
  valid_599084 = validateParameter(valid_599084, JString, required = false,
                                 default = nil)
  if valid_599084 != nil:
    section.add "quotaUser", valid_599084
  var valid_599085 = query.getOrDefault("alt")
  valid_599085 = validateParameter(valid_599085, JString, required = false,
                                 default = newJString("json"))
  if valid_599085 != nil:
    section.add "alt", valid_599085
  var valid_599086 = query.getOrDefault("oauth_token")
  valid_599086 = validateParameter(valid_599086, JString, required = false,
                                 default = nil)
  if valid_599086 != nil:
    section.add "oauth_token", valid_599086
  var valid_599087 = query.getOrDefault("callback")
  valid_599087 = validateParameter(valid_599087, JString, required = false,
                                 default = nil)
  if valid_599087 != nil:
    section.add "callback", valid_599087
  var valid_599088 = query.getOrDefault("access_token")
  valid_599088 = validateParameter(valid_599088, JString, required = false,
                                 default = nil)
  if valid_599088 != nil:
    section.add "access_token", valid_599088
  var valid_599089 = query.getOrDefault("uploadType")
  valid_599089 = validateParameter(valid_599089, JString, required = false,
                                 default = nil)
  if valid_599089 != nil:
    section.add "uploadType", valid_599089
  var valid_599090 = query.getOrDefault("key")
  valid_599090 = validateParameter(valid_599090, JString, required = false,
                                 default = nil)
  if valid_599090 != nil:
    section.add "key", valid_599090
  var valid_599091 = query.getOrDefault("$.xgafv")
  valid_599091 = validateParameter(valid_599091, JString, required = false,
                                 default = newJString("1"))
  if valid_599091 != nil:
    section.add "$.xgafv", valid_599091
  var valid_599092 = query.getOrDefault("prettyPrint")
  valid_599092 = validateParameter(valid_599092, JBool, required = false,
                                 default = newJBool(true))
  if valid_599092 != nil:
    section.add "prettyPrint", valid_599092
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599093: Call_ClassroomUserProfilesGuardiansGet_599077;
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
  let valid = call_599093.validator(path, query, header, formData, body)
  let scheme = call_599093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599093.url(scheme.get, call_599093.host, call_599093.base,
                         call_599093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599093, url, valid)

proc call*(call_599094: Call_ClassroomUserProfilesGuardiansGet_599077;
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
  var path_599095 = newJObject()
  var query_599096 = newJObject()
  add(path_599095, "guardianId", newJString(guardianId))
  add(query_599096, "upload_protocol", newJString(uploadProtocol))
  add(query_599096, "fields", newJString(fields))
  add(query_599096, "quotaUser", newJString(quotaUser))
  add(query_599096, "alt", newJString(alt))
  add(query_599096, "oauth_token", newJString(oauthToken))
  add(query_599096, "callback", newJString(callback))
  add(query_599096, "access_token", newJString(accessToken))
  add(query_599096, "uploadType", newJString(uploadType))
  add(path_599095, "studentId", newJString(studentId))
  add(query_599096, "key", newJString(key))
  add(query_599096, "$.xgafv", newJString(Xgafv))
  add(query_599096, "prettyPrint", newJBool(prettyPrint))
  result = call_599094.call(path_599095, query_599096, nil, nil, nil)

var classroomUserProfilesGuardiansGet* = Call_ClassroomUserProfilesGuardiansGet_599077(
    name: "classroomUserProfilesGuardiansGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com",
    route: "/v1/userProfiles/{studentId}/guardians/{guardianId}",
    validator: validate_ClassroomUserProfilesGuardiansGet_599078, base: "/",
    url: url_ClassroomUserProfilesGuardiansGet_599079, schemes: {Scheme.Https})
type
  Call_ClassroomUserProfilesGuardiansDelete_599097 = ref object of OpenApiRestCall_597421
proc url_ClassroomUserProfilesGuardiansDelete_599099(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ClassroomUserProfilesGuardiansDelete_599098(path: JsonNode;
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
  var valid_599100 = path.getOrDefault("guardianId")
  valid_599100 = validateParameter(valid_599100, JString, required = true,
                                 default = nil)
  if valid_599100 != nil:
    section.add "guardianId", valid_599100
  var valid_599101 = path.getOrDefault("studentId")
  valid_599101 = validateParameter(valid_599101, JString, required = true,
                                 default = nil)
  if valid_599101 != nil:
    section.add "studentId", valid_599101
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
  var valid_599102 = query.getOrDefault("upload_protocol")
  valid_599102 = validateParameter(valid_599102, JString, required = false,
                                 default = nil)
  if valid_599102 != nil:
    section.add "upload_protocol", valid_599102
  var valid_599103 = query.getOrDefault("fields")
  valid_599103 = validateParameter(valid_599103, JString, required = false,
                                 default = nil)
  if valid_599103 != nil:
    section.add "fields", valid_599103
  var valid_599104 = query.getOrDefault("quotaUser")
  valid_599104 = validateParameter(valid_599104, JString, required = false,
                                 default = nil)
  if valid_599104 != nil:
    section.add "quotaUser", valid_599104
  var valid_599105 = query.getOrDefault("alt")
  valid_599105 = validateParameter(valid_599105, JString, required = false,
                                 default = newJString("json"))
  if valid_599105 != nil:
    section.add "alt", valid_599105
  var valid_599106 = query.getOrDefault("oauth_token")
  valid_599106 = validateParameter(valid_599106, JString, required = false,
                                 default = nil)
  if valid_599106 != nil:
    section.add "oauth_token", valid_599106
  var valid_599107 = query.getOrDefault("callback")
  valid_599107 = validateParameter(valid_599107, JString, required = false,
                                 default = nil)
  if valid_599107 != nil:
    section.add "callback", valid_599107
  var valid_599108 = query.getOrDefault("access_token")
  valid_599108 = validateParameter(valid_599108, JString, required = false,
                                 default = nil)
  if valid_599108 != nil:
    section.add "access_token", valid_599108
  var valid_599109 = query.getOrDefault("uploadType")
  valid_599109 = validateParameter(valid_599109, JString, required = false,
                                 default = nil)
  if valid_599109 != nil:
    section.add "uploadType", valid_599109
  var valid_599110 = query.getOrDefault("key")
  valid_599110 = validateParameter(valid_599110, JString, required = false,
                                 default = nil)
  if valid_599110 != nil:
    section.add "key", valid_599110
  var valid_599111 = query.getOrDefault("$.xgafv")
  valid_599111 = validateParameter(valid_599111, JString, required = false,
                                 default = newJString("1"))
  if valid_599111 != nil:
    section.add "$.xgafv", valid_599111
  var valid_599112 = query.getOrDefault("prettyPrint")
  valid_599112 = validateParameter(valid_599112, JBool, required = false,
                                 default = newJBool(true))
  if valid_599112 != nil:
    section.add "prettyPrint", valid_599112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599113: Call_ClassroomUserProfilesGuardiansDelete_599097;
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
  let valid = call_599113.validator(path, query, header, formData, body)
  let scheme = call_599113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599113.url(scheme.get, call_599113.host, call_599113.base,
                         call_599113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599113, url, valid)

proc call*(call_599114: Call_ClassroomUserProfilesGuardiansDelete_599097;
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
  var path_599115 = newJObject()
  var query_599116 = newJObject()
  add(path_599115, "guardianId", newJString(guardianId))
  add(query_599116, "upload_protocol", newJString(uploadProtocol))
  add(query_599116, "fields", newJString(fields))
  add(query_599116, "quotaUser", newJString(quotaUser))
  add(query_599116, "alt", newJString(alt))
  add(query_599116, "oauth_token", newJString(oauthToken))
  add(query_599116, "callback", newJString(callback))
  add(query_599116, "access_token", newJString(accessToken))
  add(query_599116, "uploadType", newJString(uploadType))
  add(path_599115, "studentId", newJString(studentId))
  add(query_599116, "key", newJString(key))
  add(query_599116, "$.xgafv", newJString(Xgafv))
  add(query_599116, "prettyPrint", newJBool(prettyPrint))
  result = call_599114.call(path_599115, query_599116, nil, nil, nil)

var classroomUserProfilesGuardiansDelete* = Call_ClassroomUserProfilesGuardiansDelete_599097(
    name: "classroomUserProfilesGuardiansDelete", meth: HttpMethod.HttpDelete,
    host: "classroom.googleapis.com",
    route: "/v1/userProfiles/{studentId}/guardians/{guardianId}",
    validator: validate_ClassroomUserProfilesGuardiansDelete_599098, base: "/",
    url: url_ClassroomUserProfilesGuardiansDelete_599099, schemes: {Scheme.Https})
type
  Call_ClassroomUserProfilesGet_599117 = ref object of OpenApiRestCall_597421
proc url_ClassroomUserProfilesGet_599119(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/userProfiles/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClassroomUserProfilesGet_599118(path: JsonNode; query: JsonNode;
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
  var valid_599120 = path.getOrDefault("userId")
  valid_599120 = validateParameter(valid_599120, JString, required = true,
                                 default = nil)
  if valid_599120 != nil:
    section.add "userId", valid_599120
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
  var valid_599121 = query.getOrDefault("upload_protocol")
  valid_599121 = validateParameter(valid_599121, JString, required = false,
                                 default = nil)
  if valid_599121 != nil:
    section.add "upload_protocol", valid_599121
  var valid_599122 = query.getOrDefault("fields")
  valid_599122 = validateParameter(valid_599122, JString, required = false,
                                 default = nil)
  if valid_599122 != nil:
    section.add "fields", valid_599122
  var valid_599123 = query.getOrDefault("quotaUser")
  valid_599123 = validateParameter(valid_599123, JString, required = false,
                                 default = nil)
  if valid_599123 != nil:
    section.add "quotaUser", valid_599123
  var valid_599124 = query.getOrDefault("alt")
  valid_599124 = validateParameter(valid_599124, JString, required = false,
                                 default = newJString("json"))
  if valid_599124 != nil:
    section.add "alt", valid_599124
  var valid_599125 = query.getOrDefault("oauth_token")
  valid_599125 = validateParameter(valid_599125, JString, required = false,
                                 default = nil)
  if valid_599125 != nil:
    section.add "oauth_token", valid_599125
  var valid_599126 = query.getOrDefault("callback")
  valid_599126 = validateParameter(valid_599126, JString, required = false,
                                 default = nil)
  if valid_599126 != nil:
    section.add "callback", valid_599126
  var valid_599127 = query.getOrDefault("access_token")
  valid_599127 = validateParameter(valid_599127, JString, required = false,
                                 default = nil)
  if valid_599127 != nil:
    section.add "access_token", valid_599127
  var valid_599128 = query.getOrDefault("uploadType")
  valid_599128 = validateParameter(valid_599128, JString, required = false,
                                 default = nil)
  if valid_599128 != nil:
    section.add "uploadType", valid_599128
  var valid_599129 = query.getOrDefault("key")
  valid_599129 = validateParameter(valid_599129, JString, required = false,
                                 default = nil)
  if valid_599129 != nil:
    section.add "key", valid_599129
  var valid_599130 = query.getOrDefault("$.xgafv")
  valid_599130 = validateParameter(valid_599130, JString, required = false,
                                 default = newJString("1"))
  if valid_599130 != nil:
    section.add "$.xgafv", valid_599130
  var valid_599131 = query.getOrDefault("prettyPrint")
  valid_599131 = validateParameter(valid_599131, JBool, required = false,
                                 default = newJBool(true))
  if valid_599131 != nil:
    section.add "prettyPrint", valid_599131
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599132: Call_ClassroomUserProfilesGet_599117; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a user profile.
  ## 
  ## This method returns the following error codes:
  ## 
  ## * `PERMISSION_DENIED` if the requesting user is not permitted to access
  ## this user profile, if no profile exists with the requested ID, or for
  ## access errors.
  ## 
  let valid = call_599132.validator(path, query, header, formData, body)
  let scheme = call_599132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599132.url(scheme.get, call_599132.host, call_599132.base,
                         call_599132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599132, url, valid)

proc call*(call_599133: Call_ClassroomUserProfilesGet_599117; userId: string;
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
  var path_599134 = newJObject()
  var query_599135 = newJObject()
  add(query_599135, "upload_protocol", newJString(uploadProtocol))
  add(query_599135, "fields", newJString(fields))
  add(query_599135, "quotaUser", newJString(quotaUser))
  add(query_599135, "alt", newJString(alt))
  add(query_599135, "oauth_token", newJString(oauthToken))
  add(query_599135, "callback", newJString(callback))
  add(query_599135, "access_token", newJString(accessToken))
  add(query_599135, "uploadType", newJString(uploadType))
  add(query_599135, "key", newJString(key))
  add(query_599135, "$.xgafv", newJString(Xgafv))
  add(query_599135, "prettyPrint", newJBool(prettyPrint))
  add(path_599134, "userId", newJString(userId))
  result = call_599133.call(path_599134, query_599135, nil, nil, nil)

var classroomUserProfilesGet* = Call_ClassroomUserProfilesGet_599117(
    name: "classroomUserProfilesGet", meth: HttpMethod.HttpGet,
    host: "classroom.googleapis.com", route: "/v1/userProfiles/{userId}",
    validator: validate_ClassroomUserProfilesGet_599118, base: "/",
    url: url_ClassroomUserProfilesGet_599119, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
