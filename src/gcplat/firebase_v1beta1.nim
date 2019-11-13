
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

## auto-generated via openapi macro
## title: Firebase Management
## version: v1beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## The Firebase Management API enables programmatic setup and management of Firebase projects, including a project's Firebase resources and Firebase apps.
## 
## https://firebase.google.com
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
  gcpServiceName = "firebase"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FirebaseAvailableProjectsList_579635 = ref object of OpenApiRestCall_579364
proc url_FirebaseAvailableProjectsList_579637(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_FirebaseAvailableProjectsList_579636(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of [Google Cloud Platform (GCP) `Projects`]
  ## (https://cloud.google.com/resource-manager/reference/rest/v1/projects)
  ## that are available to have Firebase resources added to them.
  ## <br>
  ## <br>A GCP `Project` will only be returned if:
  ## <ol>
  ##   <li><p>The caller has sufficient
  ##          [Google IAM](https://cloud.google.com/iam) permissions to call
  ##          AddFirebase.</p></li>
  ##   <li><p>The GCP `Project` is not already a FirebaseProject.</p></li>
  ##   <li><p>The GCP `Project` is not in an Organization which has policies
  ##          that prevent Firebase resources from being added.</p></li>
  ## </ol>
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
  ##           : The maximum number of GCP `Projects` to return in the response.
  ## <br>
  ## <br>The server may return fewer than this value at its discretion.
  ## If no value is specified (or too large a value is specified), the server
  ## will impose its own limit.
  ## <br>
  ## <br>This value cannot be negative.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Token returned from a previous call to `ListAvailableProjects`
  ## indicating where in the set of GCP `Projects` to resume listing.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579749 = query.getOrDefault("key")
  valid_579749 = validateParameter(valid_579749, JString, required = false,
                                 default = nil)
  if valid_579749 != nil:
    section.add "key", valid_579749
  var valid_579763 = query.getOrDefault("prettyPrint")
  valid_579763 = validateParameter(valid_579763, JBool, required = false,
                                 default = newJBool(true))
  if valid_579763 != nil:
    section.add "prettyPrint", valid_579763
  var valid_579764 = query.getOrDefault("oauth_token")
  valid_579764 = validateParameter(valid_579764, JString, required = false,
                                 default = nil)
  if valid_579764 != nil:
    section.add "oauth_token", valid_579764
  var valid_579765 = query.getOrDefault("$.xgafv")
  valid_579765 = validateParameter(valid_579765, JString, required = false,
                                 default = newJString("1"))
  if valid_579765 != nil:
    section.add "$.xgafv", valid_579765
  var valid_579766 = query.getOrDefault("pageSize")
  valid_579766 = validateParameter(valid_579766, JInt, required = false, default = nil)
  if valid_579766 != nil:
    section.add "pageSize", valid_579766
  var valid_579767 = query.getOrDefault("alt")
  valid_579767 = validateParameter(valid_579767, JString, required = false,
                                 default = newJString("json"))
  if valid_579767 != nil:
    section.add "alt", valid_579767
  var valid_579768 = query.getOrDefault("uploadType")
  valid_579768 = validateParameter(valid_579768, JString, required = false,
                                 default = nil)
  if valid_579768 != nil:
    section.add "uploadType", valid_579768
  var valid_579769 = query.getOrDefault("quotaUser")
  valid_579769 = validateParameter(valid_579769, JString, required = false,
                                 default = nil)
  if valid_579769 != nil:
    section.add "quotaUser", valid_579769
  var valid_579770 = query.getOrDefault("pageToken")
  valid_579770 = validateParameter(valid_579770, JString, required = false,
                                 default = nil)
  if valid_579770 != nil:
    section.add "pageToken", valid_579770
  var valid_579771 = query.getOrDefault("callback")
  valid_579771 = validateParameter(valid_579771, JString, required = false,
                                 default = nil)
  if valid_579771 != nil:
    section.add "callback", valid_579771
  var valid_579772 = query.getOrDefault("fields")
  valid_579772 = validateParameter(valid_579772, JString, required = false,
                                 default = nil)
  if valid_579772 != nil:
    section.add "fields", valid_579772
  var valid_579773 = query.getOrDefault("access_token")
  valid_579773 = validateParameter(valid_579773, JString, required = false,
                                 default = nil)
  if valid_579773 != nil:
    section.add "access_token", valid_579773
  var valid_579774 = query.getOrDefault("upload_protocol")
  valid_579774 = validateParameter(valid_579774, JString, required = false,
                                 default = nil)
  if valid_579774 != nil:
    section.add "upload_protocol", valid_579774
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579797: Call_FirebaseAvailableProjectsList_579635; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of [Google Cloud Platform (GCP) `Projects`]
  ## (https://cloud.google.com/resource-manager/reference/rest/v1/projects)
  ## that are available to have Firebase resources added to them.
  ## <br>
  ## <br>A GCP `Project` will only be returned if:
  ## <ol>
  ##   <li><p>The caller has sufficient
  ##          [Google IAM](https://cloud.google.com/iam) permissions to call
  ##          AddFirebase.</p></li>
  ##   <li><p>The GCP `Project` is not already a FirebaseProject.</p></li>
  ##   <li><p>The GCP `Project` is not in an Organization which has policies
  ##          that prevent Firebase resources from being added.</p></li>
  ## </ol>
  ## 
  let valid = call_579797.validator(path, query, header, formData, body)
  let scheme = call_579797.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579797.url(scheme.get, call_579797.host, call_579797.base,
                         call_579797.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579797, url, valid)

proc call*(call_579868: Call_FirebaseAvailableProjectsList_579635;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firebaseAvailableProjectsList
  ## Returns a list of [Google Cloud Platform (GCP) `Projects`]
  ## (https://cloud.google.com/resource-manager/reference/rest/v1/projects)
  ## that are available to have Firebase resources added to them.
  ## <br>
  ## <br>A GCP `Project` will only be returned if:
  ## <ol>
  ##   <li><p>The caller has sufficient
  ##          [Google IAM](https://cloud.google.com/iam) permissions to call
  ##          AddFirebase.</p></li>
  ##   <li><p>The GCP `Project` is not already a FirebaseProject.</p></li>
  ##   <li><p>The GCP `Project` is not in an Organization which has policies
  ##          that prevent Firebase resources from being added.</p></li>
  ## </ol>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of GCP `Projects` to return in the response.
  ## <br>
  ## <br>The server may return fewer than this value at its discretion.
  ## If no value is specified (or too large a value is specified), the server
  ## will impose its own limit.
  ## <br>
  ## <br>This value cannot be negative.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Token returned from a previous call to `ListAvailableProjects`
  ## indicating where in the set of GCP `Projects` to resume listing.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579869 = newJObject()
  add(query_579869, "key", newJString(key))
  add(query_579869, "prettyPrint", newJBool(prettyPrint))
  add(query_579869, "oauth_token", newJString(oauthToken))
  add(query_579869, "$.xgafv", newJString(Xgafv))
  add(query_579869, "pageSize", newJInt(pageSize))
  add(query_579869, "alt", newJString(alt))
  add(query_579869, "uploadType", newJString(uploadType))
  add(query_579869, "quotaUser", newJString(quotaUser))
  add(query_579869, "pageToken", newJString(pageToken))
  add(query_579869, "callback", newJString(callback))
  add(query_579869, "fields", newJString(fields))
  add(query_579869, "access_token", newJString(accessToken))
  add(query_579869, "upload_protocol", newJString(uploadProtocol))
  result = call_579868.call(nil, query_579869, nil, nil, nil)

var firebaseAvailableProjectsList* = Call_FirebaseAvailableProjectsList_579635(
    name: "firebaseAvailableProjectsList", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com", route: "/v1beta1/availableProjects",
    validator: validate_FirebaseAvailableProjectsList_579636, base: "/",
    url: url_FirebaseAvailableProjectsList_579637, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsList_579909 = ref object of OpenApiRestCall_579364
proc url_FirebaseProjectsList_579911(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_FirebaseProjectsList_579910(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists each FirebaseProject accessible to the caller.
  ## <br>
  ## <br>The elements are returned in no particular order, but they will be a
  ## consistent view of the Projects when additional requests are made with a
  ## `pageToken`.
  ## <br>
  ## <br>This method is eventually consistent with Project mutations, which
  ## means newly provisioned Projects and recent modifications to existing
  ## Projects might not be reflected in the set of Projects. The list will
  ## include only ACTIVE Projects.
  ## <br>
  ## <br>Use
  ## GetFirebaseProject
  ## for consistent reads as well as for additional Project details.
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
  ##           : The maximum number of Projects to return in the response.
  ## <br>
  ## <br>The server may return fewer than this at its discretion.
  ## If no value is specified (or too large a value is specified), the server
  ## will impose its own limit.
  ## <br>
  ## <br>This value cannot be negative.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Token returned from a previous call to `ListFirebaseProjects` indicating
  ## where in the set of Projects to resume listing.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579912 = query.getOrDefault("key")
  valid_579912 = validateParameter(valid_579912, JString, required = false,
                                 default = nil)
  if valid_579912 != nil:
    section.add "key", valid_579912
  var valid_579913 = query.getOrDefault("prettyPrint")
  valid_579913 = validateParameter(valid_579913, JBool, required = false,
                                 default = newJBool(true))
  if valid_579913 != nil:
    section.add "prettyPrint", valid_579913
  var valid_579914 = query.getOrDefault("oauth_token")
  valid_579914 = validateParameter(valid_579914, JString, required = false,
                                 default = nil)
  if valid_579914 != nil:
    section.add "oauth_token", valid_579914
  var valid_579915 = query.getOrDefault("$.xgafv")
  valid_579915 = validateParameter(valid_579915, JString, required = false,
                                 default = newJString("1"))
  if valid_579915 != nil:
    section.add "$.xgafv", valid_579915
  var valid_579916 = query.getOrDefault("pageSize")
  valid_579916 = validateParameter(valid_579916, JInt, required = false, default = nil)
  if valid_579916 != nil:
    section.add "pageSize", valid_579916
  var valid_579917 = query.getOrDefault("alt")
  valid_579917 = validateParameter(valid_579917, JString, required = false,
                                 default = newJString("json"))
  if valid_579917 != nil:
    section.add "alt", valid_579917
  var valid_579918 = query.getOrDefault("uploadType")
  valid_579918 = validateParameter(valid_579918, JString, required = false,
                                 default = nil)
  if valid_579918 != nil:
    section.add "uploadType", valid_579918
  var valid_579919 = query.getOrDefault("quotaUser")
  valid_579919 = validateParameter(valid_579919, JString, required = false,
                                 default = nil)
  if valid_579919 != nil:
    section.add "quotaUser", valid_579919
  var valid_579920 = query.getOrDefault("pageToken")
  valid_579920 = validateParameter(valid_579920, JString, required = false,
                                 default = nil)
  if valid_579920 != nil:
    section.add "pageToken", valid_579920
  var valid_579921 = query.getOrDefault("callback")
  valid_579921 = validateParameter(valid_579921, JString, required = false,
                                 default = nil)
  if valid_579921 != nil:
    section.add "callback", valid_579921
  var valid_579922 = query.getOrDefault("fields")
  valid_579922 = validateParameter(valid_579922, JString, required = false,
                                 default = nil)
  if valid_579922 != nil:
    section.add "fields", valid_579922
  var valid_579923 = query.getOrDefault("access_token")
  valid_579923 = validateParameter(valid_579923, JString, required = false,
                                 default = nil)
  if valid_579923 != nil:
    section.add "access_token", valid_579923
  var valid_579924 = query.getOrDefault("upload_protocol")
  valid_579924 = validateParameter(valid_579924, JString, required = false,
                                 default = nil)
  if valid_579924 != nil:
    section.add "upload_protocol", valid_579924
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579925: Call_FirebaseProjectsList_579909; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists each FirebaseProject accessible to the caller.
  ## <br>
  ## <br>The elements are returned in no particular order, but they will be a
  ## consistent view of the Projects when additional requests are made with a
  ## `pageToken`.
  ## <br>
  ## <br>This method is eventually consistent with Project mutations, which
  ## means newly provisioned Projects and recent modifications to existing
  ## Projects might not be reflected in the set of Projects. The list will
  ## include only ACTIVE Projects.
  ## <br>
  ## <br>Use
  ## GetFirebaseProject
  ## for consistent reads as well as for additional Project details.
  ## 
  let valid = call_579925.validator(path, query, header, formData, body)
  let scheme = call_579925.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579925.url(scheme.get, call_579925.host, call_579925.base,
                         call_579925.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579925, url, valid)

proc call*(call_579926: Call_FirebaseProjectsList_579909; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firebaseProjectsList
  ## Lists each FirebaseProject accessible to the caller.
  ## <br>
  ## <br>The elements are returned in no particular order, but they will be a
  ## consistent view of the Projects when additional requests are made with a
  ## `pageToken`.
  ## <br>
  ## <br>This method is eventually consistent with Project mutations, which
  ## means newly provisioned Projects and recent modifications to existing
  ## Projects might not be reflected in the set of Projects. The list will
  ## include only ACTIVE Projects.
  ## <br>
  ## <br>Use
  ## GetFirebaseProject
  ## for consistent reads as well as for additional Project details.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of Projects to return in the response.
  ## <br>
  ## <br>The server may return fewer than this at its discretion.
  ## If no value is specified (or too large a value is specified), the server
  ## will impose its own limit.
  ## <br>
  ## <br>This value cannot be negative.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Token returned from a previous call to `ListFirebaseProjects` indicating
  ## where in the set of Projects to resume listing.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579927 = newJObject()
  add(query_579927, "key", newJString(key))
  add(query_579927, "prettyPrint", newJBool(prettyPrint))
  add(query_579927, "oauth_token", newJString(oauthToken))
  add(query_579927, "$.xgafv", newJString(Xgafv))
  add(query_579927, "pageSize", newJInt(pageSize))
  add(query_579927, "alt", newJString(alt))
  add(query_579927, "uploadType", newJString(uploadType))
  add(query_579927, "quotaUser", newJString(quotaUser))
  add(query_579927, "pageToken", newJString(pageToken))
  add(query_579927, "callback", newJString(callback))
  add(query_579927, "fields", newJString(fields))
  add(query_579927, "access_token", newJString(accessToken))
  add(query_579927, "upload_protocol", newJString(uploadProtocol))
  result = call_579926.call(nil, query_579927, nil, nil, nil)

var firebaseProjectsList* = Call_FirebaseProjectsList_579909(
    name: "firebaseProjectsList", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com", route: "/v1beta1/projects",
    validator: validate_FirebaseProjectsList_579910, base: "/",
    url: url_FirebaseProjectsList_579911, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsIosAppsGetConfig_579928 = ref object of OpenApiRestCall_579364
proc url_FirebaseProjectsIosAppsGetConfig_579930(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_FirebaseProjectsIosAppsGetConfig_579929(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the configuration artifact associated with the specified IosApp.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the App configuration to download, in the format:
  ## <br><code>projects/<var>projectId</var>/iosApps/<var>appId</var>/config</code>
  ## <br>As an <var>appId</var> is a unique identifier, the Unique Resource
  ## from Sub-Collection access pattern may be used here, in the format:
  ## <br><code>projects/-/iosApps/<var>appId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579945 = path.getOrDefault("name")
  valid_579945 = validateParameter(valid_579945, JString, required = true,
                                 default = nil)
  if valid_579945 != nil:
    section.add "name", valid_579945
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

proc call*(call_579957: Call_FirebaseProjectsIosAppsGetConfig_579928;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the configuration artifact associated with the specified IosApp.
  ## 
  let valid = call_579957.validator(path, query, header, formData, body)
  let scheme = call_579957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579957.url(scheme.get, call_579957.host, call_579957.base,
                         call_579957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579957, url, valid)

proc call*(call_579958: Call_FirebaseProjectsIosAppsGetConfig_579928; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firebaseProjectsIosAppsGetConfig
  ## Gets the configuration artifact associated with the specified IosApp.
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
  ##       : The resource name of the App configuration to download, in the format:
  ## <br><code>projects/<var>projectId</var>/iosApps/<var>appId</var>/config</code>
  ## <br>As an <var>appId</var> is a unique identifier, the Unique Resource
  ## from Sub-Collection access pattern may be used here, in the format:
  ## <br><code>projects/-/iosApps/<var>appId</var></code>
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
  add(query_579960, "$.xgafv", newJString(Xgafv))
  add(query_579960, "alt", newJString(alt))
  add(query_579960, "uploadType", newJString(uploadType))
  add(query_579960, "quotaUser", newJString(quotaUser))
  add(path_579959, "name", newJString(name))
  add(query_579960, "callback", newJString(callback))
  add(query_579960, "fields", newJString(fields))
  add(query_579960, "access_token", newJString(accessToken))
  add(query_579960, "upload_protocol", newJString(uploadProtocol))
  result = call_579958.call(path_579959, query_579960, nil, nil, nil)

var firebaseProjectsIosAppsGetConfig* = Call_FirebaseProjectsIosAppsGetConfig_579928(
    name: "firebaseProjectsIosAppsGetConfig", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_FirebaseProjectsIosAppsGetConfig_579929, base: "/",
    url: url_FirebaseProjectsIosAppsGetConfig_579930, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsIosAppsPatch_579980 = ref object of OpenApiRestCall_579364
proc url_FirebaseProjectsIosAppsPatch_579982(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_FirebaseProjectsIosAppsPatch_579981(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the attributes of the IosApp identified by the specified
  ## resource name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The fully qualified resource name of the App, in the format:
  ## <br><code>projects/<var>projectId</var>/iosApps/<var>appId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579983 = path.getOrDefault("name")
  valid_579983 = validateParameter(valid_579983, JString, required = true,
                                 default = nil)
  if valid_579983 != nil:
    section.add "name", valid_579983
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
  ##             : Specifies which fields to update.
  ## <br>Note that the fields `name`, `appId`, `projectId`, and `bundleId`
  ## are all immutable.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579984 = query.getOrDefault("key")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "key", valid_579984
  var valid_579985 = query.getOrDefault("prettyPrint")
  valid_579985 = validateParameter(valid_579985, JBool, required = false,
                                 default = newJBool(true))
  if valid_579985 != nil:
    section.add "prettyPrint", valid_579985
  var valid_579986 = query.getOrDefault("oauth_token")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "oauth_token", valid_579986
  var valid_579987 = query.getOrDefault("$.xgafv")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = newJString("1"))
  if valid_579987 != nil:
    section.add "$.xgafv", valid_579987
  var valid_579988 = query.getOrDefault("alt")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = newJString("json"))
  if valid_579988 != nil:
    section.add "alt", valid_579988
  var valid_579989 = query.getOrDefault("uploadType")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "uploadType", valid_579989
  var valid_579990 = query.getOrDefault("quotaUser")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "quotaUser", valid_579990
  var valid_579991 = query.getOrDefault("updateMask")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "updateMask", valid_579991
  var valid_579992 = query.getOrDefault("callback")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "callback", valid_579992
  var valid_579993 = query.getOrDefault("fields")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "fields", valid_579993
  var valid_579994 = query.getOrDefault("access_token")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "access_token", valid_579994
  var valid_579995 = query.getOrDefault("upload_protocol")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "upload_protocol", valid_579995
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

proc call*(call_579997: Call_FirebaseProjectsIosAppsPatch_579980; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the attributes of the IosApp identified by the specified
  ## resource name.
  ## 
  let valid = call_579997.validator(path, query, header, formData, body)
  let scheme = call_579997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579997.url(scheme.get, call_579997.host, call_579997.base,
                         call_579997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579997, url, valid)

proc call*(call_579998: Call_FirebaseProjectsIosAppsPatch_579980; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; updateMask: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firebaseProjectsIosAppsPatch
  ## Updates the attributes of the IosApp identified by the specified
  ## resource name.
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
  ##       : The fully qualified resource name of the App, in the format:
  ## <br><code>projects/<var>projectId</var>/iosApps/<var>appId</var></code>
  ##   updateMask: string
  ##             : Specifies which fields to update.
  ## <br>Note that the fields `name`, `appId`, `projectId`, and `bundleId`
  ## are all immutable.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579999 = newJObject()
  var query_580000 = newJObject()
  var body_580001 = newJObject()
  add(query_580000, "key", newJString(key))
  add(query_580000, "prettyPrint", newJBool(prettyPrint))
  add(query_580000, "oauth_token", newJString(oauthToken))
  add(query_580000, "$.xgafv", newJString(Xgafv))
  add(query_580000, "alt", newJString(alt))
  add(query_580000, "uploadType", newJString(uploadType))
  add(query_580000, "quotaUser", newJString(quotaUser))
  add(path_579999, "name", newJString(name))
  add(query_580000, "updateMask", newJString(updateMask))
  if body != nil:
    body_580001 = body
  add(query_580000, "callback", newJString(callback))
  add(query_580000, "fields", newJString(fields))
  add(query_580000, "access_token", newJString(accessToken))
  add(query_580000, "upload_protocol", newJString(uploadProtocol))
  result = call_579998.call(path_579999, query_580000, nil, nil, body_580001)

var firebaseProjectsIosAppsPatch* = Call_FirebaseProjectsIosAppsPatch_579980(
    name: "firebaseProjectsIosAppsPatch", meth: HttpMethod.HttpPatch,
    host: "firebase.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_FirebaseProjectsIosAppsPatch_579981, base: "/",
    url: url_FirebaseProjectsIosAppsPatch_579982, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsAndroidAppsShaDelete_579961 = ref object of OpenApiRestCall_579364
proc url_FirebaseProjectsAndroidAppsShaDelete_579963(protocol: Scheme;
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

proc validate_FirebaseProjectsAndroidAppsShaDelete_579962(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a SHA certificate from the specified AndroidApp.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The fully qualified resource name of the `sha-key`, in the format:
  ## 
  ## <br><code>projects/<var>projectId</var>/androidApps/<var>appId</var>/sha/<var>shaId</var></code>
  ## <br>You can obtain the full name from the response of
  ## [`ListShaCertificates`](../projects.androidApps.sha/list) or the original
  ## [`CreateShaCertificate`](../projects.androidApps.sha/create).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579964 = path.getOrDefault("name")
  valid_579964 = validateParameter(valid_579964, JString, required = true,
                                 default = nil)
  if valid_579964 != nil:
    section.add "name", valid_579964
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
  var valid_579965 = query.getOrDefault("key")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "key", valid_579965
  var valid_579966 = query.getOrDefault("prettyPrint")
  valid_579966 = validateParameter(valid_579966, JBool, required = false,
                                 default = newJBool(true))
  if valid_579966 != nil:
    section.add "prettyPrint", valid_579966
  var valid_579967 = query.getOrDefault("oauth_token")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "oauth_token", valid_579967
  var valid_579968 = query.getOrDefault("$.xgafv")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = newJString("1"))
  if valid_579968 != nil:
    section.add "$.xgafv", valid_579968
  var valid_579969 = query.getOrDefault("alt")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = newJString("json"))
  if valid_579969 != nil:
    section.add "alt", valid_579969
  var valid_579970 = query.getOrDefault("uploadType")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "uploadType", valid_579970
  var valid_579971 = query.getOrDefault("quotaUser")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "quotaUser", valid_579971
  var valid_579972 = query.getOrDefault("callback")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "callback", valid_579972
  var valid_579973 = query.getOrDefault("fields")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "fields", valid_579973
  var valid_579974 = query.getOrDefault("access_token")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "access_token", valid_579974
  var valid_579975 = query.getOrDefault("upload_protocol")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "upload_protocol", valid_579975
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579976: Call_FirebaseProjectsAndroidAppsShaDelete_579961;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a SHA certificate from the specified AndroidApp.
  ## 
  let valid = call_579976.validator(path, query, header, formData, body)
  let scheme = call_579976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579976.url(scheme.get, call_579976.host, call_579976.base,
                         call_579976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579976, url, valid)

proc call*(call_579977: Call_FirebaseProjectsAndroidAppsShaDelete_579961;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firebaseProjectsAndroidAppsShaDelete
  ## Removes a SHA certificate from the specified AndroidApp.
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
  ##       : The fully qualified resource name of the `sha-key`, in the format:
  ## 
  ## <br><code>projects/<var>projectId</var>/androidApps/<var>appId</var>/sha/<var>shaId</var></code>
  ## <br>You can obtain the full name from the response of
  ## [`ListShaCertificates`](../projects.androidApps.sha/list) or the original
  ## [`CreateShaCertificate`](../projects.androidApps.sha/create).
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579978 = newJObject()
  var query_579979 = newJObject()
  add(query_579979, "key", newJString(key))
  add(query_579979, "prettyPrint", newJBool(prettyPrint))
  add(query_579979, "oauth_token", newJString(oauthToken))
  add(query_579979, "$.xgafv", newJString(Xgafv))
  add(query_579979, "alt", newJString(alt))
  add(query_579979, "uploadType", newJString(uploadType))
  add(query_579979, "quotaUser", newJString(quotaUser))
  add(path_579978, "name", newJString(name))
  add(query_579979, "callback", newJString(callback))
  add(query_579979, "fields", newJString(fields))
  add(query_579979, "access_token", newJString(accessToken))
  add(query_579979, "upload_protocol", newJString(uploadProtocol))
  result = call_579977.call(path_579978, query_579979, nil, nil, nil)

var firebaseProjectsAndroidAppsShaDelete* = Call_FirebaseProjectsAndroidAppsShaDelete_579961(
    name: "firebaseProjectsAndroidAppsShaDelete", meth: HttpMethod.HttpDelete,
    host: "firebase.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_FirebaseProjectsAndroidAppsShaDelete_579962, base: "/",
    url: url_FirebaseProjectsAndroidAppsShaDelete_579963, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsAndroidAppsCreate_580023 = ref object of OpenApiRestCall_579364
proc url_FirebaseProjectsAndroidAppsCreate_580025(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/androidApps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_FirebaseProjectsAndroidAppsCreate_580024(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Requests that a new AndroidApp be created.
  ## <br>
  ## <br>The result of this call is an `Operation` which can be used to track
  ## the provisioning process. The `Operation` is automatically deleted after
  ## completion, so there is no need to call `DeleteOperation`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580026 = path.getOrDefault("parent")
  valid_580026 = validateParameter(valid_580026, JString, required = true,
                                 default = nil)
  if valid_580026 != nil:
    section.add "parent", valid_580026
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
  var valid_580027 = query.getOrDefault("key")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "key", valid_580027
  var valid_580028 = query.getOrDefault("prettyPrint")
  valid_580028 = validateParameter(valid_580028, JBool, required = false,
                                 default = newJBool(true))
  if valid_580028 != nil:
    section.add "prettyPrint", valid_580028
  var valid_580029 = query.getOrDefault("oauth_token")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "oauth_token", valid_580029
  var valid_580030 = query.getOrDefault("$.xgafv")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = newJString("1"))
  if valid_580030 != nil:
    section.add "$.xgafv", valid_580030
  var valid_580031 = query.getOrDefault("alt")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = newJString("json"))
  if valid_580031 != nil:
    section.add "alt", valid_580031
  var valid_580032 = query.getOrDefault("uploadType")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "uploadType", valid_580032
  var valid_580033 = query.getOrDefault("quotaUser")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "quotaUser", valid_580033
  var valid_580034 = query.getOrDefault("callback")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "callback", valid_580034
  var valid_580035 = query.getOrDefault("fields")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "fields", valid_580035
  var valid_580036 = query.getOrDefault("access_token")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "access_token", valid_580036
  var valid_580037 = query.getOrDefault("upload_protocol")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "upload_protocol", valid_580037
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

proc call*(call_580039: Call_FirebaseProjectsAndroidAppsCreate_580023;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests that a new AndroidApp be created.
  ## <br>
  ## <br>The result of this call is an `Operation` which can be used to track
  ## the provisioning process. The `Operation` is automatically deleted after
  ## completion, so there is no need to call `DeleteOperation`.
  ## 
  let valid = call_580039.validator(path, query, header, formData, body)
  let scheme = call_580039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580039.url(scheme.get, call_580039.host, call_580039.base,
                         call_580039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580039, url, valid)

proc call*(call_580040: Call_FirebaseProjectsAndroidAppsCreate_580023;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firebaseProjectsAndroidAppsCreate
  ## Requests that a new AndroidApp be created.
  ## <br>
  ## <br>The result of this call is an `Operation` which can be used to track
  ## the provisioning process. The `Operation` is automatically deleted after
  ## completion, so there is no need to call `DeleteOperation`.
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
  ##   parent: string (required)
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580041 = newJObject()
  var query_580042 = newJObject()
  var body_580043 = newJObject()
  add(query_580042, "key", newJString(key))
  add(query_580042, "prettyPrint", newJBool(prettyPrint))
  add(query_580042, "oauth_token", newJString(oauthToken))
  add(query_580042, "$.xgafv", newJString(Xgafv))
  add(query_580042, "alt", newJString(alt))
  add(query_580042, "uploadType", newJString(uploadType))
  add(query_580042, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580043 = body
  add(query_580042, "callback", newJString(callback))
  add(path_580041, "parent", newJString(parent))
  add(query_580042, "fields", newJString(fields))
  add(query_580042, "access_token", newJString(accessToken))
  add(query_580042, "upload_protocol", newJString(uploadProtocol))
  result = call_580040.call(path_580041, query_580042, nil, nil, body_580043)

var firebaseProjectsAndroidAppsCreate* = Call_FirebaseProjectsAndroidAppsCreate_580023(
    name: "firebaseProjectsAndroidAppsCreate", meth: HttpMethod.HttpPost,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}/androidApps",
    validator: validate_FirebaseProjectsAndroidAppsCreate_580024, base: "/",
    url: url_FirebaseProjectsAndroidAppsCreate_580025, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsAndroidAppsList_580002 = ref object of OpenApiRestCall_579364
proc url_FirebaseProjectsAndroidAppsList_580004(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/androidApps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_FirebaseProjectsAndroidAppsList_580003(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists each AndroidApp associated with the specified parent Project.
  ## <br>
  ## <br>The elements are returned in no particular order, but will be a
  ## consistent view of the Apps when additional requests are made with a
  ## `pageToken`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580005 = path.getOrDefault("parent")
  valid_580005 = validateParameter(valid_580005, JString, required = true,
                                 default = nil)
  if valid_580005 != nil:
    section.add "parent", valid_580005
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
  ##           : The maximum number of Apps to return in the response.
  ## <br>
  ## <br>The server may return fewer than this at its discretion.
  ## If no value is specified (or too large a value is specified), then the
  ## server will impose its own limit.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Token returned from a previous call to `ListAndroidApps` indicating where
  ## in the set of Apps to resume listing.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580006 = query.getOrDefault("key")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "key", valid_580006
  var valid_580007 = query.getOrDefault("prettyPrint")
  valid_580007 = validateParameter(valid_580007, JBool, required = false,
                                 default = newJBool(true))
  if valid_580007 != nil:
    section.add "prettyPrint", valid_580007
  var valid_580008 = query.getOrDefault("oauth_token")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "oauth_token", valid_580008
  var valid_580009 = query.getOrDefault("$.xgafv")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = newJString("1"))
  if valid_580009 != nil:
    section.add "$.xgafv", valid_580009
  var valid_580010 = query.getOrDefault("pageSize")
  valid_580010 = validateParameter(valid_580010, JInt, required = false, default = nil)
  if valid_580010 != nil:
    section.add "pageSize", valid_580010
  var valid_580011 = query.getOrDefault("alt")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = newJString("json"))
  if valid_580011 != nil:
    section.add "alt", valid_580011
  var valid_580012 = query.getOrDefault("uploadType")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "uploadType", valid_580012
  var valid_580013 = query.getOrDefault("quotaUser")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "quotaUser", valid_580013
  var valid_580014 = query.getOrDefault("pageToken")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "pageToken", valid_580014
  var valid_580015 = query.getOrDefault("callback")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "callback", valid_580015
  var valid_580016 = query.getOrDefault("fields")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "fields", valid_580016
  var valid_580017 = query.getOrDefault("access_token")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "access_token", valid_580017
  var valid_580018 = query.getOrDefault("upload_protocol")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "upload_protocol", valid_580018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580019: Call_FirebaseProjectsAndroidAppsList_580002;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists each AndroidApp associated with the specified parent Project.
  ## <br>
  ## <br>The elements are returned in no particular order, but will be a
  ## consistent view of the Apps when additional requests are made with a
  ## `pageToken`.
  ## 
  let valid = call_580019.validator(path, query, header, formData, body)
  let scheme = call_580019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580019.url(scheme.get, call_580019.host, call_580019.base,
                         call_580019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580019, url, valid)

proc call*(call_580020: Call_FirebaseProjectsAndroidAppsList_580002;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firebaseProjectsAndroidAppsList
  ## Lists each AndroidApp associated with the specified parent Project.
  ## <br>
  ## <br>The elements are returned in no particular order, but will be a
  ## consistent view of the Apps when additional requests are made with a
  ## `pageToken`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of Apps to return in the response.
  ## <br>
  ## <br>The server may return fewer than this at its discretion.
  ## If no value is specified (or too large a value is specified), then the
  ## server will impose its own limit.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Token returned from a previous call to `ListAndroidApps` indicating where
  ## in the set of Apps to resume listing.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580021 = newJObject()
  var query_580022 = newJObject()
  add(query_580022, "key", newJString(key))
  add(query_580022, "prettyPrint", newJBool(prettyPrint))
  add(query_580022, "oauth_token", newJString(oauthToken))
  add(query_580022, "$.xgafv", newJString(Xgafv))
  add(query_580022, "pageSize", newJInt(pageSize))
  add(query_580022, "alt", newJString(alt))
  add(query_580022, "uploadType", newJString(uploadType))
  add(query_580022, "quotaUser", newJString(quotaUser))
  add(query_580022, "pageToken", newJString(pageToken))
  add(query_580022, "callback", newJString(callback))
  add(path_580021, "parent", newJString(parent))
  add(query_580022, "fields", newJString(fields))
  add(query_580022, "access_token", newJString(accessToken))
  add(query_580022, "upload_protocol", newJString(uploadProtocol))
  result = call_580020.call(path_580021, query_580022, nil, nil, nil)

var firebaseProjectsAndroidAppsList* = Call_FirebaseProjectsAndroidAppsList_580002(
    name: "firebaseProjectsAndroidAppsList", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}/androidApps",
    validator: validate_FirebaseProjectsAndroidAppsList_580003, base: "/",
    url: url_FirebaseProjectsAndroidAppsList_580004, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsAvailableLocationsList_580044 = ref object of OpenApiRestCall_579364
proc url_FirebaseProjectsAvailableLocationsList_580046(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/availableLocations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_FirebaseProjectsAvailableLocationsList_580045(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of valid Google Cloud Platform (GCP) resource locations for
  ## the specified Project (including a FirebaseProject).
  ## <br>
  ## <br>The default GCP resource location of a project defines the geographical
  ## location where project resources, such as Cloud Firestore, will be
  ## provisioned by default.
  ## <br>
  ## <br>The returned list are the available
  ## [GCP resource
  ## locations](https://firebase.google.com/docs/projects/locations). <br>
  ## <br>This call checks for any location restrictions for the specified
  ## Project and, thus, might return a subset of all possible GCP resource
  ## locations. To list all GCP resource locations (regardless of any
  ## restrictions), call the endpoint without specifying a `projectId` (that is,
  ## `/v1beta1/{parent=projects/-}/listAvailableLocations`).
  ## <br>
  ## <br>To call `ListAvailableLocations` with a specified project, a member
  ## must be at minimum a Viewer of the project. Calls without a specified
  ## project do not require any specific project permissions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The Project for which to list GCP resource locations, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ## <br>If no project is specified (that is, `projects/-`), the returned list
  ## does not take into account org-specific or project-specific location
  ## restrictions.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580047 = path.getOrDefault("parent")
  valid_580047 = validateParameter(valid_580047, JString, required = true,
                                 default = nil)
  if valid_580047 != nil:
    section.add "parent", valid_580047
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
  ##           : The maximum number of locations to return in the response.
  ## <br>
  ## <br>The server may return fewer than this value at its discretion.
  ## If no value is specified (or too large a value is specified), then the
  ## server will impose its own limit.
  ## <br>
  ## <br>This value cannot be negative.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Token returned from a previous call to `ListAvailableLocations` indicating
  ## where in the list of locations to resume listing.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580048 = query.getOrDefault("key")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "key", valid_580048
  var valid_580049 = query.getOrDefault("prettyPrint")
  valid_580049 = validateParameter(valid_580049, JBool, required = false,
                                 default = newJBool(true))
  if valid_580049 != nil:
    section.add "prettyPrint", valid_580049
  var valid_580050 = query.getOrDefault("oauth_token")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "oauth_token", valid_580050
  var valid_580051 = query.getOrDefault("$.xgafv")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = newJString("1"))
  if valid_580051 != nil:
    section.add "$.xgafv", valid_580051
  var valid_580052 = query.getOrDefault("pageSize")
  valid_580052 = validateParameter(valid_580052, JInt, required = false, default = nil)
  if valid_580052 != nil:
    section.add "pageSize", valid_580052
  var valid_580053 = query.getOrDefault("alt")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = newJString("json"))
  if valid_580053 != nil:
    section.add "alt", valid_580053
  var valid_580054 = query.getOrDefault("uploadType")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "uploadType", valid_580054
  var valid_580055 = query.getOrDefault("quotaUser")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "quotaUser", valid_580055
  var valid_580056 = query.getOrDefault("pageToken")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "pageToken", valid_580056
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

proc call*(call_580061: Call_FirebaseProjectsAvailableLocationsList_580044;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of valid Google Cloud Platform (GCP) resource locations for
  ## the specified Project (including a FirebaseProject).
  ## <br>
  ## <br>The default GCP resource location of a project defines the geographical
  ## location where project resources, such as Cloud Firestore, will be
  ## provisioned by default.
  ## <br>
  ## <br>The returned list are the available
  ## [GCP resource
  ## locations](https://firebase.google.com/docs/projects/locations). <br>
  ## <br>This call checks for any location restrictions for the specified
  ## Project and, thus, might return a subset of all possible GCP resource
  ## locations. To list all GCP resource locations (regardless of any
  ## restrictions), call the endpoint without specifying a `projectId` (that is,
  ## `/v1beta1/{parent=projects/-}/listAvailableLocations`).
  ## <br>
  ## <br>To call `ListAvailableLocations` with a specified project, a member
  ## must be at minimum a Viewer of the project. Calls without a specified
  ## project do not require any specific project permissions.
  ## 
  let valid = call_580061.validator(path, query, header, formData, body)
  let scheme = call_580061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580061.url(scheme.get, call_580061.host, call_580061.base,
                         call_580061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580061, url, valid)

proc call*(call_580062: Call_FirebaseProjectsAvailableLocationsList_580044;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firebaseProjectsAvailableLocationsList
  ## Returns a list of valid Google Cloud Platform (GCP) resource locations for
  ## the specified Project (including a FirebaseProject).
  ## <br>
  ## <br>The default GCP resource location of a project defines the geographical
  ## location where project resources, such as Cloud Firestore, will be
  ## provisioned by default.
  ## <br>
  ## <br>The returned list are the available
  ## [GCP resource
  ## locations](https://firebase.google.com/docs/projects/locations). <br>
  ## <br>This call checks for any location restrictions for the specified
  ## Project and, thus, might return a subset of all possible GCP resource
  ## locations. To list all GCP resource locations (regardless of any
  ## restrictions), call the endpoint without specifying a `projectId` (that is,
  ## `/v1beta1/{parent=projects/-}/listAvailableLocations`).
  ## <br>
  ## <br>To call `ListAvailableLocations` with a specified project, a member
  ## must be at minimum a Viewer of the project. Calls without a specified
  ## project do not require any specific project permissions.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of locations to return in the response.
  ## <br>
  ## <br>The server may return fewer than this value at its discretion.
  ## If no value is specified (or too large a value is specified), then the
  ## server will impose its own limit.
  ## <br>
  ## <br>This value cannot be negative.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Token returned from a previous call to `ListAvailableLocations` indicating
  ## where in the list of locations to resume listing.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The Project for which to list GCP resource locations, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ## <br>If no project is specified (that is, `projects/-`), the returned list
  ## does not take into account org-specific or project-specific location
  ## restrictions.
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
  add(query_580064, "pageSize", newJInt(pageSize))
  add(query_580064, "alt", newJString(alt))
  add(query_580064, "uploadType", newJString(uploadType))
  add(query_580064, "quotaUser", newJString(quotaUser))
  add(query_580064, "pageToken", newJString(pageToken))
  add(query_580064, "callback", newJString(callback))
  add(path_580063, "parent", newJString(parent))
  add(query_580064, "fields", newJString(fields))
  add(query_580064, "access_token", newJString(accessToken))
  add(query_580064, "upload_protocol", newJString(uploadProtocol))
  result = call_580062.call(path_580063, query_580064, nil, nil, nil)

var firebaseProjectsAvailableLocationsList* = Call_FirebaseProjectsAvailableLocationsList_580044(
    name: "firebaseProjectsAvailableLocationsList", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com",
    route: "/v1beta1/{parent}/availableLocations",
    validator: validate_FirebaseProjectsAvailableLocationsList_580045, base: "/",
    url: url_FirebaseProjectsAvailableLocationsList_580046,
    schemes: {Scheme.Https})
type
  Call_FirebaseProjectsDefaultLocationFinalize_580065 = ref object of OpenApiRestCall_579364
proc url_FirebaseProjectsDefaultLocationFinalize_580067(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/defaultLocation:finalize")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_FirebaseProjectsDefaultLocationFinalize_580066(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the default Google Cloud Platform (GCP) resource location for the
  ## specified FirebaseProject.
  ## <br>
  ## <br>This method creates an App Engine application with a
  ## [default Cloud Storage
  ## bucket](https://cloud.google.com/appengine/docs/standard/python/googlecloudstorageclient/setting-up-cloud-storage#activating_a_cloud_storage_bucket),
  ## located in the specified
  ## [`location_id`](#body.request_body.FIELDS.location_id).
  ## This location must be one of the available
  ## [GCP resource
  ## locations](https://firebase.google.com/docs/projects/locations). <br>
  ## <br>After the default GCP resource location is finalized, or if it was
  ## already set, it cannot be changed. The default GCP resource location for
  ## the specified FirebaseProject might already be set because either the
  ## GCP `Project` already has an App Engine application or
  ## `FinalizeDefaultLocation` was previously called with a specified
  ## `location_id`. Any new calls to `FinalizeDefaultLocation` with a
  ## <em>different</em> specified `location_id` will return a 409 error.
  ## <br>
  ## <br>The result of this call is an [`Operation`](../../v1beta1/operations),
  ## which can be used to track the provisioning process. The
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) type of
  ## the `Operation` is google.protobuf.Empty.
  ## <br>
  ## <br>The `Operation` can be polled by its `name` using
  ## GetOperation until `done` is
  ## true. When `done` is true, the `Operation` has either succeeded or failed.
  ## If the `Operation` has succeeded, its
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) will be
  ## set to a google.protobuf.Empty; if the `Operation` has failed, its
  ## `error` will be set to a google.rpc.Status. The `Operation` is
  ## automatically deleted after completion, so there is no need to call
  ## DeleteOperation.
  ## <br>
  ## <br>All fields listed in the [request body](#request-body) are required.
  ## <br>
  ## <br>To call `FinalizeDefaultLocation`, a member must be an Owner
  ## of the project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The resource name of the Project for which the default GCP resource
  ## location will be set, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580068 = path.getOrDefault("parent")
  valid_580068 = validateParameter(valid_580068, JString, required = true,
                                 default = nil)
  if valid_580068 != nil:
    section.add "parent", valid_580068
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
  var valid_580069 = query.getOrDefault("key")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "key", valid_580069
  var valid_580070 = query.getOrDefault("prettyPrint")
  valid_580070 = validateParameter(valid_580070, JBool, required = false,
                                 default = newJBool(true))
  if valid_580070 != nil:
    section.add "prettyPrint", valid_580070
  var valid_580071 = query.getOrDefault("oauth_token")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "oauth_token", valid_580071
  var valid_580072 = query.getOrDefault("$.xgafv")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = newJString("1"))
  if valid_580072 != nil:
    section.add "$.xgafv", valid_580072
  var valid_580073 = query.getOrDefault("alt")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = newJString("json"))
  if valid_580073 != nil:
    section.add "alt", valid_580073
  var valid_580074 = query.getOrDefault("uploadType")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "uploadType", valid_580074
  var valid_580075 = query.getOrDefault("quotaUser")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "quotaUser", valid_580075
  var valid_580076 = query.getOrDefault("callback")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "callback", valid_580076
  var valid_580077 = query.getOrDefault("fields")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "fields", valid_580077
  var valid_580078 = query.getOrDefault("access_token")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "access_token", valid_580078
  var valid_580079 = query.getOrDefault("upload_protocol")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "upload_protocol", valid_580079
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

proc call*(call_580081: Call_FirebaseProjectsDefaultLocationFinalize_580065;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the default Google Cloud Platform (GCP) resource location for the
  ## specified FirebaseProject.
  ## <br>
  ## <br>This method creates an App Engine application with a
  ## [default Cloud Storage
  ## bucket](https://cloud.google.com/appengine/docs/standard/python/googlecloudstorageclient/setting-up-cloud-storage#activating_a_cloud_storage_bucket),
  ## located in the specified
  ## [`location_id`](#body.request_body.FIELDS.location_id).
  ## This location must be one of the available
  ## [GCP resource
  ## locations](https://firebase.google.com/docs/projects/locations). <br>
  ## <br>After the default GCP resource location is finalized, or if it was
  ## already set, it cannot be changed. The default GCP resource location for
  ## the specified FirebaseProject might already be set because either the
  ## GCP `Project` already has an App Engine application or
  ## `FinalizeDefaultLocation` was previously called with a specified
  ## `location_id`. Any new calls to `FinalizeDefaultLocation` with a
  ## <em>different</em> specified `location_id` will return a 409 error.
  ## <br>
  ## <br>The result of this call is an [`Operation`](../../v1beta1/operations),
  ## which can be used to track the provisioning process. The
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) type of
  ## the `Operation` is google.protobuf.Empty.
  ## <br>
  ## <br>The `Operation` can be polled by its `name` using
  ## GetOperation until `done` is
  ## true. When `done` is true, the `Operation` has either succeeded or failed.
  ## If the `Operation` has succeeded, its
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) will be
  ## set to a google.protobuf.Empty; if the `Operation` has failed, its
  ## `error` will be set to a google.rpc.Status. The `Operation` is
  ## automatically deleted after completion, so there is no need to call
  ## DeleteOperation.
  ## <br>
  ## <br>All fields listed in the [request body](#request-body) are required.
  ## <br>
  ## <br>To call `FinalizeDefaultLocation`, a member must be an Owner
  ## of the project.
  ## 
  let valid = call_580081.validator(path, query, header, formData, body)
  let scheme = call_580081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580081.url(scheme.get, call_580081.host, call_580081.base,
                         call_580081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580081, url, valid)

proc call*(call_580082: Call_FirebaseProjectsDefaultLocationFinalize_580065;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firebaseProjectsDefaultLocationFinalize
  ## Sets the default Google Cloud Platform (GCP) resource location for the
  ## specified FirebaseProject.
  ## <br>
  ## <br>This method creates an App Engine application with a
  ## [default Cloud Storage
  ## bucket](https://cloud.google.com/appengine/docs/standard/python/googlecloudstorageclient/setting-up-cloud-storage#activating_a_cloud_storage_bucket),
  ## located in the specified
  ## [`location_id`](#body.request_body.FIELDS.location_id).
  ## This location must be one of the available
  ## [GCP resource
  ## locations](https://firebase.google.com/docs/projects/locations). <br>
  ## <br>After the default GCP resource location is finalized, or if it was
  ## already set, it cannot be changed. The default GCP resource location for
  ## the specified FirebaseProject might already be set because either the
  ## GCP `Project` already has an App Engine application or
  ## `FinalizeDefaultLocation` was previously called with a specified
  ## `location_id`. Any new calls to `FinalizeDefaultLocation` with a
  ## <em>different</em> specified `location_id` will return a 409 error.
  ## <br>
  ## <br>The result of this call is an [`Operation`](../../v1beta1/operations),
  ## which can be used to track the provisioning process. The
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) type of
  ## the `Operation` is google.protobuf.Empty.
  ## <br>
  ## <br>The `Operation` can be polled by its `name` using
  ## GetOperation until `done` is
  ## true. When `done` is true, the `Operation` has either succeeded or failed.
  ## If the `Operation` has succeeded, its
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) will be
  ## set to a google.protobuf.Empty; if the `Operation` has failed, its
  ## `error` will be set to a google.rpc.Status. The `Operation` is
  ## automatically deleted after completion, so there is no need to call
  ## DeleteOperation.
  ## <br>
  ## <br>All fields listed in the [request body](#request-body) are required.
  ## <br>
  ## <br>To call `FinalizeDefaultLocation`, a member must be an Owner
  ## of the project.
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
  ##   parent: string (required)
  ##         : The resource name of the Project for which the default GCP resource
  ## location will be set, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580083 = newJObject()
  var query_580084 = newJObject()
  var body_580085 = newJObject()
  add(query_580084, "key", newJString(key))
  add(query_580084, "prettyPrint", newJBool(prettyPrint))
  add(query_580084, "oauth_token", newJString(oauthToken))
  add(query_580084, "$.xgafv", newJString(Xgafv))
  add(query_580084, "alt", newJString(alt))
  add(query_580084, "uploadType", newJString(uploadType))
  add(query_580084, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580085 = body
  add(query_580084, "callback", newJString(callback))
  add(path_580083, "parent", newJString(parent))
  add(query_580084, "fields", newJString(fields))
  add(query_580084, "access_token", newJString(accessToken))
  add(query_580084, "upload_protocol", newJString(uploadProtocol))
  result = call_580082.call(path_580083, query_580084, nil, nil, body_580085)

var firebaseProjectsDefaultLocationFinalize* = Call_FirebaseProjectsDefaultLocationFinalize_580065(
    name: "firebaseProjectsDefaultLocationFinalize", meth: HttpMethod.HttpPost,
    host: "firebase.googleapis.com",
    route: "/v1beta1/{parent}/defaultLocation:finalize",
    validator: validate_FirebaseProjectsDefaultLocationFinalize_580066, base: "/",
    url: url_FirebaseProjectsDefaultLocationFinalize_580067,
    schemes: {Scheme.Https})
type
  Call_FirebaseProjectsIosAppsCreate_580107 = ref object of OpenApiRestCall_579364
proc url_FirebaseProjectsIosAppsCreate_580109(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/iosApps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_FirebaseProjectsIosAppsCreate_580108(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Requests that a new IosApp be created.
  ## <br>
  ## <br>The result of this call is an `Operation` which can be used to track
  ## the provisioning process. The `Operation` is automatically deleted after
  ## completion, so there is no need to call `DeleteOperation`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580110 = path.getOrDefault("parent")
  valid_580110 = validateParameter(valid_580110, JString, required = true,
                                 default = nil)
  if valid_580110 != nil:
    section.add "parent", valid_580110
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
  var valid_580111 = query.getOrDefault("key")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "key", valid_580111
  var valid_580112 = query.getOrDefault("prettyPrint")
  valid_580112 = validateParameter(valid_580112, JBool, required = false,
                                 default = newJBool(true))
  if valid_580112 != nil:
    section.add "prettyPrint", valid_580112
  var valid_580113 = query.getOrDefault("oauth_token")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "oauth_token", valid_580113
  var valid_580114 = query.getOrDefault("$.xgafv")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = newJString("1"))
  if valid_580114 != nil:
    section.add "$.xgafv", valid_580114
  var valid_580115 = query.getOrDefault("alt")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = newJString("json"))
  if valid_580115 != nil:
    section.add "alt", valid_580115
  var valid_580116 = query.getOrDefault("uploadType")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "uploadType", valid_580116
  var valid_580117 = query.getOrDefault("quotaUser")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "quotaUser", valid_580117
  var valid_580118 = query.getOrDefault("callback")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "callback", valid_580118
  var valid_580119 = query.getOrDefault("fields")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "fields", valid_580119
  var valid_580120 = query.getOrDefault("access_token")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "access_token", valid_580120
  var valid_580121 = query.getOrDefault("upload_protocol")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "upload_protocol", valid_580121
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

proc call*(call_580123: Call_FirebaseProjectsIosAppsCreate_580107; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests that a new IosApp be created.
  ## <br>
  ## <br>The result of this call is an `Operation` which can be used to track
  ## the provisioning process. The `Operation` is automatically deleted after
  ## completion, so there is no need to call `DeleteOperation`.
  ## 
  let valid = call_580123.validator(path, query, header, formData, body)
  let scheme = call_580123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580123.url(scheme.get, call_580123.host, call_580123.base,
                         call_580123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580123, url, valid)

proc call*(call_580124: Call_FirebaseProjectsIosAppsCreate_580107; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firebaseProjectsIosAppsCreate
  ## Requests that a new IosApp be created.
  ## <br>
  ## <br>The result of this call is an `Operation` which can be used to track
  ## the provisioning process. The `Operation` is automatically deleted after
  ## completion, so there is no need to call `DeleteOperation`.
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
  ##   parent: string (required)
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580125 = newJObject()
  var query_580126 = newJObject()
  var body_580127 = newJObject()
  add(query_580126, "key", newJString(key))
  add(query_580126, "prettyPrint", newJBool(prettyPrint))
  add(query_580126, "oauth_token", newJString(oauthToken))
  add(query_580126, "$.xgafv", newJString(Xgafv))
  add(query_580126, "alt", newJString(alt))
  add(query_580126, "uploadType", newJString(uploadType))
  add(query_580126, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580127 = body
  add(query_580126, "callback", newJString(callback))
  add(path_580125, "parent", newJString(parent))
  add(query_580126, "fields", newJString(fields))
  add(query_580126, "access_token", newJString(accessToken))
  add(query_580126, "upload_protocol", newJString(uploadProtocol))
  result = call_580124.call(path_580125, query_580126, nil, nil, body_580127)

var firebaseProjectsIosAppsCreate* = Call_FirebaseProjectsIosAppsCreate_580107(
    name: "firebaseProjectsIosAppsCreate", meth: HttpMethod.HttpPost,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}/iosApps",
    validator: validate_FirebaseProjectsIosAppsCreate_580108, base: "/",
    url: url_FirebaseProjectsIosAppsCreate_580109, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsIosAppsList_580086 = ref object of OpenApiRestCall_579364
proc url_FirebaseProjectsIosAppsList_580088(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/iosApps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_FirebaseProjectsIosAppsList_580087(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists each IosApp associated with the specified parent Project.
  ## <br>
  ## <br>The elements are returned in no particular order, but will be a
  ## consistent view of the Apps when additional requests are made with a
  ## `pageToken`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580089 = path.getOrDefault("parent")
  valid_580089 = validateParameter(valid_580089, JString, required = true,
                                 default = nil)
  if valid_580089 != nil:
    section.add "parent", valid_580089
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
  ##           : The maximum number of Apps to return in the response.
  ## <br>
  ## <br>The server may return fewer than this at its discretion.
  ## If no value is specified (or too large a value is specified), the server
  ## will impose its own limit.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Token returned from a previous call to `ListIosApps` indicating where in
  ## the set of Apps to resume listing.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580090 = query.getOrDefault("key")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "key", valid_580090
  var valid_580091 = query.getOrDefault("prettyPrint")
  valid_580091 = validateParameter(valid_580091, JBool, required = false,
                                 default = newJBool(true))
  if valid_580091 != nil:
    section.add "prettyPrint", valid_580091
  var valid_580092 = query.getOrDefault("oauth_token")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "oauth_token", valid_580092
  var valid_580093 = query.getOrDefault("$.xgafv")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = newJString("1"))
  if valid_580093 != nil:
    section.add "$.xgafv", valid_580093
  var valid_580094 = query.getOrDefault("pageSize")
  valid_580094 = validateParameter(valid_580094, JInt, required = false, default = nil)
  if valid_580094 != nil:
    section.add "pageSize", valid_580094
  var valid_580095 = query.getOrDefault("alt")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = newJString("json"))
  if valid_580095 != nil:
    section.add "alt", valid_580095
  var valid_580096 = query.getOrDefault("uploadType")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "uploadType", valid_580096
  var valid_580097 = query.getOrDefault("quotaUser")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "quotaUser", valid_580097
  var valid_580098 = query.getOrDefault("pageToken")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "pageToken", valid_580098
  var valid_580099 = query.getOrDefault("callback")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "callback", valid_580099
  var valid_580100 = query.getOrDefault("fields")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "fields", valid_580100
  var valid_580101 = query.getOrDefault("access_token")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "access_token", valid_580101
  var valid_580102 = query.getOrDefault("upload_protocol")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "upload_protocol", valid_580102
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580103: Call_FirebaseProjectsIosAppsList_580086; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists each IosApp associated with the specified parent Project.
  ## <br>
  ## <br>The elements are returned in no particular order, but will be a
  ## consistent view of the Apps when additional requests are made with a
  ## `pageToken`.
  ## 
  let valid = call_580103.validator(path, query, header, formData, body)
  let scheme = call_580103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580103.url(scheme.get, call_580103.host, call_580103.base,
                         call_580103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580103, url, valid)

proc call*(call_580104: Call_FirebaseProjectsIosAppsList_580086; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firebaseProjectsIosAppsList
  ## Lists each IosApp associated with the specified parent Project.
  ## <br>
  ## <br>The elements are returned in no particular order, but will be a
  ## consistent view of the Apps when additional requests are made with a
  ## `pageToken`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of Apps to return in the response.
  ## <br>
  ## <br>The server may return fewer than this at its discretion.
  ## If no value is specified (or too large a value is specified), the server
  ## will impose its own limit.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Token returned from a previous call to `ListIosApps` indicating where in
  ## the set of Apps to resume listing.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580105 = newJObject()
  var query_580106 = newJObject()
  add(query_580106, "key", newJString(key))
  add(query_580106, "prettyPrint", newJBool(prettyPrint))
  add(query_580106, "oauth_token", newJString(oauthToken))
  add(query_580106, "$.xgafv", newJString(Xgafv))
  add(query_580106, "pageSize", newJInt(pageSize))
  add(query_580106, "alt", newJString(alt))
  add(query_580106, "uploadType", newJString(uploadType))
  add(query_580106, "quotaUser", newJString(quotaUser))
  add(query_580106, "pageToken", newJString(pageToken))
  add(query_580106, "callback", newJString(callback))
  add(path_580105, "parent", newJString(parent))
  add(query_580106, "fields", newJString(fields))
  add(query_580106, "access_token", newJString(accessToken))
  add(query_580106, "upload_protocol", newJString(uploadProtocol))
  result = call_580104.call(path_580105, query_580106, nil, nil, nil)

var firebaseProjectsIosAppsList* = Call_FirebaseProjectsIosAppsList_580086(
    name: "firebaseProjectsIosAppsList", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}/iosApps",
    validator: validate_FirebaseProjectsIosAppsList_580087, base: "/",
    url: url_FirebaseProjectsIosAppsList_580088, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsAndroidAppsShaCreate_580147 = ref object of OpenApiRestCall_579364
proc url_FirebaseProjectsAndroidAppsShaCreate_580149(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/sha")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_FirebaseProjectsAndroidAppsShaCreate_580148(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a SHA certificate to the specified AndroidApp.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent App to which a SHA certificate will be added, in the format:
  ## <br><code>projects/<var>projectId</var>/androidApps/<var>appId</var></code>
  ## <br>As an <var>appId</var> is a unique identifier, the Unique Resource
  ## from Sub-Collection access pattern may be used here, in the format:
  ## <br><code>projects/-/androidApps/<var>appId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580150 = path.getOrDefault("parent")
  valid_580150 = validateParameter(valid_580150, JString, required = true,
                                 default = nil)
  if valid_580150 != nil:
    section.add "parent", valid_580150
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
  var valid_580151 = query.getOrDefault("key")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "key", valid_580151
  var valid_580152 = query.getOrDefault("prettyPrint")
  valid_580152 = validateParameter(valid_580152, JBool, required = false,
                                 default = newJBool(true))
  if valid_580152 != nil:
    section.add "prettyPrint", valid_580152
  var valid_580153 = query.getOrDefault("oauth_token")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "oauth_token", valid_580153
  var valid_580154 = query.getOrDefault("$.xgafv")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = newJString("1"))
  if valid_580154 != nil:
    section.add "$.xgafv", valid_580154
  var valid_580155 = query.getOrDefault("alt")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = newJString("json"))
  if valid_580155 != nil:
    section.add "alt", valid_580155
  var valid_580156 = query.getOrDefault("uploadType")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "uploadType", valid_580156
  var valid_580157 = query.getOrDefault("quotaUser")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "quotaUser", valid_580157
  var valid_580158 = query.getOrDefault("callback")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "callback", valid_580158
  var valid_580159 = query.getOrDefault("fields")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "fields", valid_580159
  var valid_580160 = query.getOrDefault("access_token")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "access_token", valid_580160
  var valid_580161 = query.getOrDefault("upload_protocol")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "upload_protocol", valid_580161
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

proc call*(call_580163: Call_FirebaseProjectsAndroidAppsShaCreate_580147;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a SHA certificate to the specified AndroidApp.
  ## 
  let valid = call_580163.validator(path, query, header, formData, body)
  let scheme = call_580163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580163.url(scheme.get, call_580163.host, call_580163.base,
                         call_580163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580163, url, valid)

proc call*(call_580164: Call_FirebaseProjectsAndroidAppsShaCreate_580147;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firebaseProjectsAndroidAppsShaCreate
  ## Adds a SHA certificate to the specified AndroidApp.
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
  ##   parent: string (required)
  ##         : The parent App to which a SHA certificate will be added, in the format:
  ## <br><code>projects/<var>projectId</var>/androidApps/<var>appId</var></code>
  ## <br>As an <var>appId</var> is a unique identifier, the Unique Resource
  ## from Sub-Collection access pattern may be used here, in the format:
  ## <br><code>projects/-/androidApps/<var>appId</var></code>
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580165 = newJObject()
  var query_580166 = newJObject()
  var body_580167 = newJObject()
  add(query_580166, "key", newJString(key))
  add(query_580166, "prettyPrint", newJBool(prettyPrint))
  add(query_580166, "oauth_token", newJString(oauthToken))
  add(query_580166, "$.xgafv", newJString(Xgafv))
  add(query_580166, "alt", newJString(alt))
  add(query_580166, "uploadType", newJString(uploadType))
  add(query_580166, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580167 = body
  add(query_580166, "callback", newJString(callback))
  add(path_580165, "parent", newJString(parent))
  add(query_580166, "fields", newJString(fields))
  add(query_580166, "access_token", newJString(accessToken))
  add(query_580166, "upload_protocol", newJString(uploadProtocol))
  result = call_580164.call(path_580165, query_580166, nil, nil, body_580167)

var firebaseProjectsAndroidAppsShaCreate* = Call_FirebaseProjectsAndroidAppsShaCreate_580147(
    name: "firebaseProjectsAndroidAppsShaCreate", meth: HttpMethod.HttpPost,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}/sha",
    validator: validate_FirebaseProjectsAndroidAppsShaCreate_580148, base: "/",
    url: url_FirebaseProjectsAndroidAppsShaCreate_580149, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsAndroidAppsShaList_580128 = ref object of OpenApiRestCall_579364
proc url_FirebaseProjectsAndroidAppsShaList_580130(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/sha")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_FirebaseProjectsAndroidAppsShaList_580129(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the list of SHA-1 and SHA-256 certificates for the specified
  ## AndroidApp.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent App for which to list SHA certificates, in the format:
  ## <br><code>projects/<var>projectId</var>/androidApps/<var>appId</var></code>
  ## <br>As an <var>appId</var> is a unique identifier, the Unique Resource
  ## from Sub-Collection access pattern may be used here, in the format:
  ## <br><code>projects/-/androidApps/<var>appId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580131 = path.getOrDefault("parent")
  valid_580131 = validateParameter(valid_580131, JString, required = true,
                                 default = nil)
  if valid_580131 != nil:
    section.add "parent", valid_580131
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
  var valid_580132 = query.getOrDefault("key")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "key", valid_580132
  var valid_580133 = query.getOrDefault("prettyPrint")
  valid_580133 = validateParameter(valid_580133, JBool, required = false,
                                 default = newJBool(true))
  if valid_580133 != nil:
    section.add "prettyPrint", valid_580133
  var valid_580134 = query.getOrDefault("oauth_token")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "oauth_token", valid_580134
  var valid_580135 = query.getOrDefault("$.xgafv")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = newJString("1"))
  if valid_580135 != nil:
    section.add "$.xgafv", valid_580135
  var valid_580136 = query.getOrDefault("alt")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = newJString("json"))
  if valid_580136 != nil:
    section.add "alt", valid_580136
  var valid_580137 = query.getOrDefault("uploadType")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "uploadType", valid_580137
  var valid_580138 = query.getOrDefault("quotaUser")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "quotaUser", valid_580138
  var valid_580139 = query.getOrDefault("callback")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "callback", valid_580139
  var valid_580140 = query.getOrDefault("fields")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "fields", valid_580140
  var valid_580141 = query.getOrDefault("access_token")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "access_token", valid_580141
  var valid_580142 = query.getOrDefault("upload_protocol")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "upload_protocol", valid_580142
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580143: Call_FirebaseProjectsAndroidAppsShaList_580128;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the list of SHA-1 and SHA-256 certificates for the specified
  ## AndroidApp.
  ## 
  let valid = call_580143.validator(path, query, header, formData, body)
  let scheme = call_580143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580143.url(scheme.get, call_580143.host, call_580143.base,
                         call_580143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580143, url, valid)

proc call*(call_580144: Call_FirebaseProjectsAndroidAppsShaList_580128;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firebaseProjectsAndroidAppsShaList
  ## Returns the list of SHA-1 and SHA-256 certificates for the specified
  ## AndroidApp.
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
  ##   parent: string (required)
  ##         : The parent App for which to list SHA certificates, in the format:
  ## <br><code>projects/<var>projectId</var>/androidApps/<var>appId</var></code>
  ## <br>As an <var>appId</var> is a unique identifier, the Unique Resource
  ## from Sub-Collection access pattern may be used here, in the format:
  ## <br><code>projects/-/androidApps/<var>appId</var></code>
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580145 = newJObject()
  var query_580146 = newJObject()
  add(query_580146, "key", newJString(key))
  add(query_580146, "prettyPrint", newJBool(prettyPrint))
  add(query_580146, "oauth_token", newJString(oauthToken))
  add(query_580146, "$.xgafv", newJString(Xgafv))
  add(query_580146, "alt", newJString(alt))
  add(query_580146, "uploadType", newJString(uploadType))
  add(query_580146, "quotaUser", newJString(quotaUser))
  add(query_580146, "callback", newJString(callback))
  add(path_580145, "parent", newJString(parent))
  add(query_580146, "fields", newJString(fields))
  add(query_580146, "access_token", newJString(accessToken))
  add(query_580146, "upload_protocol", newJString(uploadProtocol))
  result = call_580144.call(path_580145, query_580146, nil, nil, nil)

var firebaseProjectsAndroidAppsShaList* = Call_FirebaseProjectsAndroidAppsShaList_580128(
    name: "firebaseProjectsAndroidAppsShaList", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}/sha",
    validator: validate_FirebaseProjectsAndroidAppsShaList_580129, base: "/",
    url: url_FirebaseProjectsAndroidAppsShaList_580130, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsWebAppsCreate_580189 = ref object of OpenApiRestCall_579364
proc url_FirebaseProjectsWebAppsCreate_580191(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/webApps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_FirebaseProjectsWebAppsCreate_580190(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Requests that a new WebApp be created.
  ## <br>
  ## <br>The result of this call is an `Operation` which can be used to track
  ## the provisioning process. The `Operation` is automatically deleted after
  ## completion, so there is no need to call `DeleteOperation`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580192 = path.getOrDefault("parent")
  valid_580192 = validateParameter(valid_580192, JString, required = true,
                                 default = nil)
  if valid_580192 != nil:
    section.add "parent", valid_580192
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
  var valid_580193 = query.getOrDefault("key")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "key", valid_580193
  var valid_580194 = query.getOrDefault("prettyPrint")
  valid_580194 = validateParameter(valid_580194, JBool, required = false,
                                 default = newJBool(true))
  if valid_580194 != nil:
    section.add "prettyPrint", valid_580194
  var valid_580195 = query.getOrDefault("oauth_token")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "oauth_token", valid_580195
  var valid_580196 = query.getOrDefault("$.xgafv")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = newJString("1"))
  if valid_580196 != nil:
    section.add "$.xgafv", valid_580196
  var valid_580197 = query.getOrDefault("alt")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = newJString("json"))
  if valid_580197 != nil:
    section.add "alt", valid_580197
  var valid_580198 = query.getOrDefault("uploadType")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "uploadType", valid_580198
  var valid_580199 = query.getOrDefault("quotaUser")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = nil)
  if valid_580199 != nil:
    section.add "quotaUser", valid_580199
  var valid_580200 = query.getOrDefault("callback")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "callback", valid_580200
  var valid_580201 = query.getOrDefault("fields")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "fields", valid_580201
  var valid_580202 = query.getOrDefault("access_token")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "access_token", valid_580202
  var valid_580203 = query.getOrDefault("upload_protocol")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "upload_protocol", valid_580203
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

proc call*(call_580205: Call_FirebaseProjectsWebAppsCreate_580189; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests that a new WebApp be created.
  ## <br>
  ## <br>The result of this call is an `Operation` which can be used to track
  ## the provisioning process. The `Operation` is automatically deleted after
  ## completion, so there is no need to call `DeleteOperation`.
  ## 
  let valid = call_580205.validator(path, query, header, formData, body)
  let scheme = call_580205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580205.url(scheme.get, call_580205.host, call_580205.base,
                         call_580205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580205, url, valid)

proc call*(call_580206: Call_FirebaseProjectsWebAppsCreate_580189; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firebaseProjectsWebAppsCreate
  ## Requests that a new WebApp be created.
  ## <br>
  ## <br>The result of this call is an `Operation` which can be used to track
  ## the provisioning process. The `Operation` is automatically deleted after
  ## completion, so there is no need to call `DeleteOperation`.
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
  ##   parent: string (required)
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580207 = newJObject()
  var query_580208 = newJObject()
  var body_580209 = newJObject()
  add(query_580208, "key", newJString(key))
  add(query_580208, "prettyPrint", newJBool(prettyPrint))
  add(query_580208, "oauth_token", newJString(oauthToken))
  add(query_580208, "$.xgafv", newJString(Xgafv))
  add(query_580208, "alt", newJString(alt))
  add(query_580208, "uploadType", newJString(uploadType))
  add(query_580208, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580209 = body
  add(query_580208, "callback", newJString(callback))
  add(path_580207, "parent", newJString(parent))
  add(query_580208, "fields", newJString(fields))
  add(query_580208, "access_token", newJString(accessToken))
  add(query_580208, "upload_protocol", newJString(uploadProtocol))
  result = call_580206.call(path_580207, query_580208, nil, nil, body_580209)

var firebaseProjectsWebAppsCreate* = Call_FirebaseProjectsWebAppsCreate_580189(
    name: "firebaseProjectsWebAppsCreate", meth: HttpMethod.HttpPost,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}/webApps",
    validator: validate_FirebaseProjectsWebAppsCreate_580190, base: "/",
    url: url_FirebaseProjectsWebAppsCreate_580191, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsWebAppsList_580168 = ref object of OpenApiRestCall_579364
proc url_FirebaseProjectsWebAppsList_580170(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/webApps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_FirebaseProjectsWebAppsList_580169(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists each WebApp associated with the specified parent Project.
  ## <br>
  ## <br>The elements are returned in no particular order, but will be a
  ## consistent view of the Apps when additional requests are made with a
  ## `pageToken`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580171 = path.getOrDefault("parent")
  valid_580171 = validateParameter(valid_580171, JString, required = true,
                                 default = nil)
  if valid_580171 != nil:
    section.add "parent", valid_580171
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
  ##           : The maximum number of Apps to return in the response.
  ## <br>
  ## <br>The server may return fewer than this value at its discretion.
  ## If no value is specified (or too large a value is specified), then the
  ## server will impose its own limit.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Token returned from a previous call to `ListWebApps` indicating where in
  ## the set of Apps to resume listing.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580172 = query.getOrDefault("key")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "key", valid_580172
  var valid_580173 = query.getOrDefault("prettyPrint")
  valid_580173 = validateParameter(valid_580173, JBool, required = false,
                                 default = newJBool(true))
  if valid_580173 != nil:
    section.add "prettyPrint", valid_580173
  var valid_580174 = query.getOrDefault("oauth_token")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "oauth_token", valid_580174
  var valid_580175 = query.getOrDefault("$.xgafv")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = newJString("1"))
  if valid_580175 != nil:
    section.add "$.xgafv", valid_580175
  var valid_580176 = query.getOrDefault("pageSize")
  valid_580176 = validateParameter(valid_580176, JInt, required = false, default = nil)
  if valid_580176 != nil:
    section.add "pageSize", valid_580176
  var valid_580177 = query.getOrDefault("alt")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = newJString("json"))
  if valid_580177 != nil:
    section.add "alt", valid_580177
  var valid_580178 = query.getOrDefault("uploadType")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "uploadType", valid_580178
  var valid_580179 = query.getOrDefault("quotaUser")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "quotaUser", valid_580179
  var valid_580180 = query.getOrDefault("pageToken")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = nil)
  if valid_580180 != nil:
    section.add "pageToken", valid_580180
  var valid_580181 = query.getOrDefault("callback")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = nil)
  if valid_580181 != nil:
    section.add "callback", valid_580181
  var valid_580182 = query.getOrDefault("fields")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "fields", valid_580182
  var valid_580183 = query.getOrDefault("access_token")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "access_token", valid_580183
  var valid_580184 = query.getOrDefault("upload_protocol")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "upload_protocol", valid_580184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580185: Call_FirebaseProjectsWebAppsList_580168; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists each WebApp associated with the specified parent Project.
  ## <br>
  ## <br>The elements are returned in no particular order, but will be a
  ## consistent view of the Apps when additional requests are made with a
  ## `pageToken`.
  ## 
  let valid = call_580185.validator(path, query, header, formData, body)
  let scheme = call_580185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580185.url(scheme.get, call_580185.host, call_580185.base,
                         call_580185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580185, url, valid)

proc call*(call_580186: Call_FirebaseProjectsWebAppsList_580168; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firebaseProjectsWebAppsList
  ## Lists each WebApp associated with the specified parent Project.
  ## <br>
  ## <br>The elements are returned in no particular order, but will be a
  ## consistent view of the Apps when additional requests are made with a
  ## `pageToken`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of Apps to return in the response.
  ## <br>
  ## <br>The server may return fewer than this value at its discretion.
  ## If no value is specified (or too large a value is specified), then the
  ## server will impose its own limit.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Token returned from a previous call to `ListWebApps` indicating where in
  ## the set of Apps to resume listing.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580187 = newJObject()
  var query_580188 = newJObject()
  add(query_580188, "key", newJString(key))
  add(query_580188, "prettyPrint", newJBool(prettyPrint))
  add(query_580188, "oauth_token", newJString(oauthToken))
  add(query_580188, "$.xgafv", newJString(Xgafv))
  add(query_580188, "pageSize", newJInt(pageSize))
  add(query_580188, "alt", newJString(alt))
  add(query_580188, "uploadType", newJString(uploadType))
  add(query_580188, "quotaUser", newJString(quotaUser))
  add(query_580188, "pageToken", newJString(pageToken))
  add(query_580188, "callback", newJString(callback))
  add(path_580187, "parent", newJString(parent))
  add(query_580188, "fields", newJString(fields))
  add(query_580188, "access_token", newJString(accessToken))
  add(query_580188, "upload_protocol", newJString(uploadProtocol))
  result = call_580186.call(path_580187, query_580188, nil, nil, nil)

var firebaseProjectsWebAppsList* = Call_FirebaseProjectsWebAppsList_580168(
    name: "firebaseProjectsWebAppsList", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}/webApps",
    validator: validate_FirebaseProjectsWebAppsList_580169, base: "/",
    url: url_FirebaseProjectsWebAppsList_580170, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsAddGoogleAnalytics_580210 = ref object of OpenApiRestCall_579364
proc url_FirebaseProjectsAddGoogleAnalytics_580212(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: ":addGoogleAnalytics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_FirebaseProjectsAddGoogleAnalytics_580211(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Links a FirebaseProject with an existing
  ## [Google Analytics account](http://www.google.com/analytics/).
  ## <br>
  ## <br>Using this call, you can either:
  ## <ul>
  ## <li>Specify an `analyticsAccountId` to provision a new Google Analytics
  ## property within the specified account and associate the new property with
  ## your `FirebaseProject`.</li>
  ## <li>Specify an existing `analyticsPropertyId` to associate the property
  ## with your `FirebaseProject`.</li>
  ## </ul>
  ## <br>
  ## Note that when you call `AddGoogleAnalytics`:
  ## <ol>
  ## <li>The first check determines if any existing data streams in the
  ## Google Analytics property correspond to any existing Firebase Apps in your
  ## `FirebaseProject` (based on the `packageName` or `bundleId` associated with
  ## the data stream). Then, as applicable, the data streams and apps are
  ## linked. Note that this auto-linking only applies to Android Apps and iOS
  ## Apps.</li>
  ## <li>If no corresponding data streams are found for your Firebase Apps,
  ## new data streams are provisioned in the Google Analytics property
  ## for each of your Firebase Apps. Note that a new data stream is always
  ## provisioned for a Web App even if it was previously associated with a
  ## data stream in your Analytics property.</li>
  ## </ol>
  ## Learn more about the hierarchy and structure of Google Analytics
  ## accounts in the
  ## [Analytics
  ## documentation](https://support.google.com/analytics/answer/9303323).
  ## <br>
  ## <br>The result of this call is an [`Operation`](../../v1beta1/operations).
  ## Poll the `Operation` to track the provisioning process by calling
  ## GetOperation until
  ## [`done`](../../v1beta1/operations#Operation.FIELDS.done) is `true`. When
  ## `done` is `true`, the `Operation` has either succeeded or failed. If the
  ## `Operation` succeeded, its
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) is set to
  ## an AnalyticsDetails; if the `Operation` failed, its
  ## [`error`](../../v1beta1/operations#Operation.FIELDS.error) is set to a
  ## google.rpc.Status.
  ## <br>
  ## <br>To call `AddGoogleAnalytics`, a member must be an Owner for
  ## the existing `FirebaseProject` and have the
  ## [`Edit` permission](https://support.google.com/analytics/answer/2884495)
  ## for the Google Analytics account.
  ## <br>
  ## <br>If a `FirebaseProject` already has Google Analytics enabled, and you
  ## call `AddGoogleAnalytics` using an `analyticsPropertyId` that's different
  ## from the currently associated property, then the call will fail. Analytics
  ## may have already been enabled in the Firebase console or by specifying
  ## `timeZone` and `regionCode` in the call to
  ## [`AddFirebase`](../../v1beta1/projects/addFirebase).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent `FirebaseProject` to link to an existing Google Analytics
  ## account, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580213 = path.getOrDefault("parent")
  valid_580213 = validateParameter(valid_580213, JString, required = true,
                                 default = nil)
  if valid_580213 != nil:
    section.add "parent", valid_580213
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
  var valid_580214 = query.getOrDefault("key")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "key", valid_580214
  var valid_580215 = query.getOrDefault("prettyPrint")
  valid_580215 = validateParameter(valid_580215, JBool, required = false,
                                 default = newJBool(true))
  if valid_580215 != nil:
    section.add "prettyPrint", valid_580215
  var valid_580216 = query.getOrDefault("oauth_token")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "oauth_token", valid_580216
  var valid_580217 = query.getOrDefault("$.xgafv")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = newJString("1"))
  if valid_580217 != nil:
    section.add "$.xgafv", valid_580217
  var valid_580218 = query.getOrDefault("alt")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = newJString("json"))
  if valid_580218 != nil:
    section.add "alt", valid_580218
  var valid_580219 = query.getOrDefault("uploadType")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "uploadType", valid_580219
  var valid_580220 = query.getOrDefault("quotaUser")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = nil)
  if valid_580220 != nil:
    section.add "quotaUser", valid_580220
  var valid_580221 = query.getOrDefault("callback")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "callback", valid_580221
  var valid_580222 = query.getOrDefault("fields")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "fields", valid_580222
  var valid_580223 = query.getOrDefault("access_token")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "access_token", valid_580223
  var valid_580224 = query.getOrDefault("upload_protocol")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "upload_protocol", valid_580224
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

proc call*(call_580226: Call_FirebaseProjectsAddGoogleAnalytics_580210;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Links a FirebaseProject with an existing
  ## [Google Analytics account](http://www.google.com/analytics/).
  ## <br>
  ## <br>Using this call, you can either:
  ## <ul>
  ## <li>Specify an `analyticsAccountId` to provision a new Google Analytics
  ## property within the specified account and associate the new property with
  ## your `FirebaseProject`.</li>
  ## <li>Specify an existing `analyticsPropertyId` to associate the property
  ## with your `FirebaseProject`.</li>
  ## </ul>
  ## <br>
  ## Note that when you call `AddGoogleAnalytics`:
  ## <ol>
  ## <li>The first check determines if any existing data streams in the
  ## Google Analytics property correspond to any existing Firebase Apps in your
  ## `FirebaseProject` (based on the `packageName` or `bundleId` associated with
  ## the data stream). Then, as applicable, the data streams and apps are
  ## linked. Note that this auto-linking only applies to Android Apps and iOS
  ## Apps.</li>
  ## <li>If no corresponding data streams are found for your Firebase Apps,
  ## new data streams are provisioned in the Google Analytics property
  ## for each of your Firebase Apps. Note that a new data stream is always
  ## provisioned for a Web App even if it was previously associated with a
  ## data stream in your Analytics property.</li>
  ## </ol>
  ## Learn more about the hierarchy and structure of Google Analytics
  ## accounts in the
  ## [Analytics
  ## documentation](https://support.google.com/analytics/answer/9303323).
  ## <br>
  ## <br>The result of this call is an [`Operation`](../../v1beta1/operations).
  ## Poll the `Operation` to track the provisioning process by calling
  ## GetOperation until
  ## [`done`](../../v1beta1/operations#Operation.FIELDS.done) is `true`. When
  ## `done` is `true`, the `Operation` has either succeeded or failed. If the
  ## `Operation` succeeded, its
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) is set to
  ## an AnalyticsDetails; if the `Operation` failed, its
  ## [`error`](../../v1beta1/operations#Operation.FIELDS.error) is set to a
  ## google.rpc.Status.
  ## <br>
  ## <br>To call `AddGoogleAnalytics`, a member must be an Owner for
  ## the existing `FirebaseProject` and have the
  ## [`Edit` permission](https://support.google.com/analytics/answer/2884495)
  ## for the Google Analytics account.
  ## <br>
  ## <br>If a `FirebaseProject` already has Google Analytics enabled, and you
  ## call `AddGoogleAnalytics` using an `analyticsPropertyId` that's different
  ## from the currently associated property, then the call will fail. Analytics
  ## may have already been enabled in the Firebase console or by specifying
  ## `timeZone` and `regionCode` in the call to
  ## [`AddFirebase`](../../v1beta1/projects/addFirebase).
  ## 
  let valid = call_580226.validator(path, query, header, formData, body)
  let scheme = call_580226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580226.url(scheme.get, call_580226.host, call_580226.base,
                         call_580226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580226, url, valid)

proc call*(call_580227: Call_FirebaseProjectsAddGoogleAnalytics_580210;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firebaseProjectsAddGoogleAnalytics
  ## Links a FirebaseProject with an existing
  ## [Google Analytics account](http://www.google.com/analytics/).
  ## <br>
  ## <br>Using this call, you can either:
  ## <ul>
  ## <li>Specify an `analyticsAccountId` to provision a new Google Analytics
  ## property within the specified account and associate the new property with
  ## your `FirebaseProject`.</li>
  ## <li>Specify an existing `analyticsPropertyId` to associate the property
  ## with your `FirebaseProject`.</li>
  ## </ul>
  ## <br>
  ## Note that when you call `AddGoogleAnalytics`:
  ## <ol>
  ## <li>The first check determines if any existing data streams in the
  ## Google Analytics property correspond to any existing Firebase Apps in your
  ## `FirebaseProject` (based on the `packageName` or `bundleId` associated with
  ## the data stream). Then, as applicable, the data streams and apps are
  ## linked. Note that this auto-linking only applies to Android Apps and iOS
  ## Apps.</li>
  ## <li>If no corresponding data streams are found for your Firebase Apps,
  ## new data streams are provisioned in the Google Analytics property
  ## for each of your Firebase Apps. Note that a new data stream is always
  ## provisioned for a Web App even if it was previously associated with a
  ## data stream in your Analytics property.</li>
  ## </ol>
  ## Learn more about the hierarchy and structure of Google Analytics
  ## accounts in the
  ## [Analytics
  ## documentation](https://support.google.com/analytics/answer/9303323).
  ## <br>
  ## <br>The result of this call is an [`Operation`](../../v1beta1/operations).
  ## Poll the `Operation` to track the provisioning process by calling
  ## GetOperation until
  ## [`done`](../../v1beta1/operations#Operation.FIELDS.done) is `true`. When
  ## `done` is `true`, the `Operation` has either succeeded or failed. If the
  ## `Operation` succeeded, its
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) is set to
  ## an AnalyticsDetails; if the `Operation` failed, its
  ## [`error`](../../v1beta1/operations#Operation.FIELDS.error) is set to a
  ## google.rpc.Status.
  ## <br>
  ## <br>To call `AddGoogleAnalytics`, a member must be an Owner for
  ## the existing `FirebaseProject` and have the
  ## [`Edit` permission](https://support.google.com/analytics/answer/2884495)
  ## for the Google Analytics account.
  ## <br>
  ## <br>If a `FirebaseProject` already has Google Analytics enabled, and you
  ## call `AddGoogleAnalytics` using an `analyticsPropertyId` that's different
  ## from the currently associated property, then the call will fail. Analytics
  ## may have already been enabled in the Firebase console or by specifying
  ## `timeZone` and `regionCode` in the call to
  ## [`AddFirebase`](../../v1beta1/projects/addFirebase).
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
  ##   parent: string (required)
  ##         : The parent `FirebaseProject` to link to an existing Google Analytics
  ## account, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580228 = newJObject()
  var query_580229 = newJObject()
  var body_580230 = newJObject()
  add(query_580229, "key", newJString(key))
  add(query_580229, "prettyPrint", newJBool(prettyPrint))
  add(query_580229, "oauth_token", newJString(oauthToken))
  add(query_580229, "$.xgafv", newJString(Xgafv))
  add(query_580229, "alt", newJString(alt))
  add(query_580229, "uploadType", newJString(uploadType))
  add(query_580229, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580230 = body
  add(query_580229, "callback", newJString(callback))
  add(path_580228, "parent", newJString(parent))
  add(query_580229, "fields", newJString(fields))
  add(query_580229, "access_token", newJString(accessToken))
  add(query_580229, "upload_protocol", newJString(uploadProtocol))
  result = call_580227.call(path_580228, query_580229, nil, nil, body_580230)

var firebaseProjectsAddGoogleAnalytics* = Call_FirebaseProjectsAddGoogleAnalytics_580210(
    name: "firebaseProjectsAddGoogleAnalytics", meth: HttpMethod.HttpPost,
    host: "firebase.googleapis.com",
    route: "/v1beta1/{parent}:addGoogleAnalytics",
    validator: validate_FirebaseProjectsAddGoogleAnalytics_580211, base: "/",
    url: url_FirebaseProjectsAddGoogleAnalytics_580212, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsRemoveAnalytics_580231 = ref object of OpenApiRestCall_579364
proc url_FirebaseProjectsRemoveAnalytics_580233(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: ":removeAnalytics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_FirebaseProjectsRemoveAnalytics_580232(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Unlinks the specified `FirebaseProject` from its Google Analytics account.
  ## <br>
  ## <br>This call removes the association of the specified `FirebaseProject`
  ## with its current Google Analytics property. However, this call does not
  ## delete the Google Analytics resources, such as the Google Analytics
  ## property or any data streams.
  ## <br>
  ## <br>These resources may be re-associated later to the `FirebaseProject` by
  ## calling
  ## [`AddGoogleAnalytics`](../../v1beta1/projects/addGoogleAnalytics) and
  ## specifying the same `analyticsPropertyId`. For Android Apps and iOS Apps,
  ## this call re-links data streams with their corresponding apps. However,
  ## for Web Apps, this call provisions a <em>new</em> data stream for each Web
  ## App.
  ## <br>
  ## <br>To call `RemoveAnalytics`, a member must be an Owner for
  ## the `FirebaseProject`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent `FirebaseProject` to unlink from its Google Analytics account,
  ## in the format:
  ## <br><code>projects/<var>projectId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580234 = path.getOrDefault("parent")
  valid_580234 = validateParameter(valid_580234, JString, required = true,
                                 default = nil)
  if valid_580234 != nil:
    section.add "parent", valid_580234
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
  var valid_580235 = query.getOrDefault("key")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "key", valid_580235
  var valid_580236 = query.getOrDefault("prettyPrint")
  valid_580236 = validateParameter(valid_580236, JBool, required = false,
                                 default = newJBool(true))
  if valid_580236 != nil:
    section.add "prettyPrint", valid_580236
  var valid_580237 = query.getOrDefault("oauth_token")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "oauth_token", valid_580237
  var valid_580238 = query.getOrDefault("$.xgafv")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = newJString("1"))
  if valid_580238 != nil:
    section.add "$.xgafv", valid_580238
  var valid_580239 = query.getOrDefault("alt")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = newJString("json"))
  if valid_580239 != nil:
    section.add "alt", valid_580239
  var valid_580240 = query.getOrDefault("uploadType")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "uploadType", valid_580240
  var valid_580241 = query.getOrDefault("quotaUser")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "quotaUser", valid_580241
  var valid_580242 = query.getOrDefault("callback")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "callback", valid_580242
  var valid_580243 = query.getOrDefault("fields")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "fields", valid_580243
  var valid_580244 = query.getOrDefault("access_token")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = nil)
  if valid_580244 != nil:
    section.add "access_token", valid_580244
  var valid_580245 = query.getOrDefault("upload_protocol")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "upload_protocol", valid_580245
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

proc call*(call_580247: Call_FirebaseProjectsRemoveAnalytics_580231;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unlinks the specified `FirebaseProject` from its Google Analytics account.
  ## <br>
  ## <br>This call removes the association of the specified `FirebaseProject`
  ## with its current Google Analytics property. However, this call does not
  ## delete the Google Analytics resources, such as the Google Analytics
  ## property or any data streams.
  ## <br>
  ## <br>These resources may be re-associated later to the `FirebaseProject` by
  ## calling
  ## [`AddGoogleAnalytics`](../../v1beta1/projects/addGoogleAnalytics) and
  ## specifying the same `analyticsPropertyId`. For Android Apps and iOS Apps,
  ## this call re-links data streams with their corresponding apps. However,
  ## for Web Apps, this call provisions a <em>new</em> data stream for each Web
  ## App.
  ## <br>
  ## <br>To call `RemoveAnalytics`, a member must be an Owner for
  ## the `FirebaseProject`.
  ## 
  let valid = call_580247.validator(path, query, header, formData, body)
  let scheme = call_580247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580247.url(scheme.get, call_580247.host, call_580247.base,
                         call_580247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580247, url, valid)

proc call*(call_580248: Call_FirebaseProjectsRemoveAnalytics_580231;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firebaseProjectsRemoveAnalytics
  ## Unlinks the specified `FirebaseProject` from its Google Analytics account.
  ## <br>
  ## <br>This call removes the association of the specified `FirebaseProject`
  ## with its current Google Analytics property. However, this call does not
  ## delete the Google Analytics resources, such as the Google Analytics
  ## property or any data streams.
  ## <br>
  ## <br>These resources may be re-associated later to the `FirebaseProject` by
  ## calling
  ## [`AddGoogleAnalytics`](../../v1beta1/projects/addGoogleAnalytics) and
  ## specifying the same `analyticsPropertyId`. For Android Apps and iOS Apps,
  ## this call re-links data streams with their corresponding apps. However,
  ## for Web Apps, this call provisions a <em>new</em> data stream for each Web
  ## App.
  ## <br>
  ## <br>To call `RemoveAnalytics`, a member must be an Owner for
  ## the `FirebaseProject`.
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
  ##   parent: string (required)
  ##         : The parent `FirebaseProject` to unlink from its Google Analytics account,
  ## in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580249 = newJObject()
  var query_580250 = newJObject()
  var body_580251 = newJObject()
  add(query_580250, "key", newJString(key))
  add(query_580250, "prettyPrint", newJBool(prettyPrint))
  add(query_580250, "oauth_token", newJString(oauthToken))
  add(query_580250, "$.xgafv", newJString(Xgafv))
  add(query_580250, "alt", newJString(alt))
  add(query_580250, "uploadType", newJString(uploadType))
  add(query_580250, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580251 = body
  add(query_580250, "callback", newJString(callback))
  add(path_580249, "parent", newJString(parent))
  add(query_580250, "fields", newJString(fields))
  add(query_580250, "access_token", newJString(accessToken))
  add(query_580250, "upload_protocol", newJString(uploadProtocol))
  result = call_580248.call(path_580249, query_580250, nil, nil, body_580251)

var firebaseProjectsRemoveAnalytics* = Call_FirebaseProjectsRemoveAnalytics_580231(
    name: "firebaseProjectsRemoveAnalytics", meth: HttpMethod.HttpPost,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}:removeAnalytics",
    validator: validate_FirebaseProjectsRemoveAnalytics_580232, base: "/",
    url: url_FirebaseProjectsRemoveAnalytics_580233, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsSearchApps_580252 = ref object of OpenApiRestCall_579364
proc url_FirebaseProjectsSearchApps_580254(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: ":searchApps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_FirebaseProjectsSearchApps_580253(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## A convenience method that lists all available Apps for the specified
  ## FirebaseProject.
  ## <br>
  ## <br>Typically, interaction with an App should be done using the
  ## platform-specific service, but some tool use-cases require a summary of all
  ## known Apps (such as for App selector interfaces).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580255 = path.getOrDefault("parent")
  valid_580255 = validateParameter(valid_580255, JString, required = true,
                                 default = nil)
  if valid_580255 != nil:
    section.add "parent", valid_580255
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
  ##           : The maximum number of Apps to return in the response.
  ## <br>
  ## <br>The server may return fewer than this value at its discretion.
  ## If no value is specified (or too large a value is specified), then the
  ## server will impose its own limit.
  ## <br>
  ## <br>This value cannot be negative.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Token returned from a previous call to `SearchFirebaseApps` indicating
  ## where in the set of Apps to resume listing.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580256 = query.getOrDefault("key")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "key", valid_580256
  var valid_580257 = query.getOrDefault("prettyPrint")
  valid_580257 = validateParameter(valid_580257, JBool, required = false,
                                 default = newJBool(true))
  if valid_580257 != nil:
    section.add "prettyPrint", valid_580257
  var valid_580258 = query.getOrDefault("oauth_token")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "oauth_token", valid_580258
  var valid_580259 = query.getOrDefault("$.xgafv")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = newJString("1"))
  if valid_580259 != nil:
    section.add "$.xgafv", valid_580259
  var valid_580260 = query.getOrDefault("pageSize")
  valid_580260 = validateParameter(valid_580260, JInt, required = false, default = nil)
  if valid_580260 != nil:
    section.add "pageSize", valid_580260
  var valid_580261 = query.getOrDefault("alt")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = newJString("json"))
  if valid_580261 != nil:
    section.add "alt", valid_580261
  var valid_580262 = query.getOrDefault("uploadType")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "uploadType", valid_580262
  var valid_580263 = query.getOrDefault("quotaUser")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = nil)
  if valid_580263 != nil:
    section.add "quotaUser", valid_580263
  var valid_580264 = query.getOrDefault("pageToken")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = nil)
  if valid_580264 != nil:
    section.add "pageToken", valid_580264
  var valid_580265 = query.getOrDefault("callback")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "callback", valid_580265
  var valid_580266 = query.getOrDefault("fields")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "fields", valid_580266
  var valid_580267 = query.getOrDefault("access_token")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "access_token", valid_580267
  var valid_580268 = query.getOrDefault("upload_protocol")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = nil)
  if valid_580268 != nil:
    section.add "upload_protocol", valid_580268
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580269: Call_FirebaseProjectsSearchApps_580252; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## A convenience method that lists all available Apps for the specified
  ## FirebaseProject.
  ## <br>
  ## <br>Typically, interaction with an App should be done using the
  ## platform-specific service, but some tool use-cases require a summary of all
  ## known Apps (such as for App selector interfaces).
  ## 
  let valid = call_580269.validator(path, query, header, formData, body)
  let scheme = call_580269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580269.url(scheme.get, call_580269.host, call_580269.base,
                         call_580269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580269, url, valid)

proc call*(call_580270: Call_FirebaseProjectsSearchApps_580252; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firebaseProjectsSearchApps
  ## A convenience method that lists all available Apps for the specified
  ## FirebaseProject.
  ## <br>
  ## <br>Typically, interaction with an App should be done using the
  ## platform-specific service, but some tool use-cases require a summary of all
  ## known Apps (such as for App selector interfaces).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of Apps to return in the response.
  ## <br>
  ## <br>The server may return fewer than this value at its discretion.
  ## If no value is specified (or too large a value is specified), then the
  ## server will impose its own limit.
  ## <br>
  ## <br>This value cannot be negative.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Token returned from a previous call to `SearchFirebaseApps` indicating
  ## where in the set of Apps to resume listing.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent Project for which to list Apps, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580271 = newJObject()
  var query_580272 = newJObject()
  add(query_580272, "key", newJString(key))
  add(query_580272, "prettyPrint", newJBool(prettyPrint))
  add(query_580272, "oauth_token", newJString(oauthToken))
  add(query_580272, "$.xgafv", newJString(Xgafv))
  add(query_580272, "pageSize", newJInt(pageSize))
  add(query_580272, "alt", newJString(alt))
  add(query_580272, "uploadType", newJString(uploadType))
  add(query_580272, "quotaUser", newJString(quotaUser))
  add(query_580272, "pageToken", newJString(pageToken))
  add(query_580272, "callback", newJString(callback))
  add(path_580271, "parent", newJString(parent))
  add(query_580272, "fields", newJString(fields))
  add(query_580272, "access_token", newJString(accessToken))
  add(query_580272, "upload_protocol", newJString(uploadProtocol))
  result = call_580270.call(path_580271, query_580272, nil, nil, nil)

var firebaseProjectsSearchApps* = Call_FirebaseProjectsSearchApps_580252(
    name: "firebaseProjectsSearchApps", meth: HttpMethod.HttpGet,
    host: "firebase.googleapis.com", route: "/v1beta1/{parent}:searchApps",
    validator: validate_FirebaseProjectsSearchApps_580253, base: "/",
    url: url_FirebaseProjectsSearchApps_580254, schemes: {Scheme.Https})
type
  Call_FirebaseProjectsAddFirebase_580273 = ref object of OpenApiRestCall_579364
proc url_FirebaseProjectsAddFirebase_580275(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: ":addFirebase")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_FirebaseProjectsAddFirebase_580274(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds Firebase resources to the specified existing
  ## [Google Cloud Platform (GCP) `Project`]
  ## (https://cloud.google.com/resource-manager/reference/rest/v1/projects).
  ## <br>
  ## <br>Since a FirebaseProject is actually also a GCP `Project`, a
  ## `FirebaseProject` uses underlying GCP identifiers (most importantly,
  ## the `projectId`) as its own for easy interop with GCP APIs.
  ## <br>
  ## <br>The result of this call is an [`Operation`](../../v1beta1/operations).
  ## Poll the `Operation` to track the provisioning process by calling
  ## GetOperation until
  ## [`done`](../../v1beta1/operations#Operation.FIELDS.done) is `true`. When
  ## `done` is `true`, the `Operation` has either succeeded or failed. If the
  ## `Operation` succeeded, its
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) is set to
  ## a FirebaseProject; if the `Operation` failed, its
  ## [`error`](../../v1beta1/operations#Operation.FIELDS.error) is set to a
  ## google.rpc.Status. The `Operation` is automatically deleted after
  ## completion, so there is no need to call
  ## DeleteOperation.
  ## <br>
  ## <br>This method does not modify any billing account information on the
  ## underlying GCP `Project`.
  ## <br>
  ## <br>To call `AddFirebase`, a member must be an Editor or Owner for the
  ## existing GCP `Project`. Service accounts cannot call `AddFirebase`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The resource name of the GCP `Project` to which Firebase resources will be
  ## added, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ## After calling `AddFirebase`, the
  ## 
  ## [`projectId`](https://cloud.google.com/resource-manager/reference/rest/v1/projects#Project.FIELDS.project_id)
  ## of the GCP `Project` is also the `projectId` of the FirebaseProject.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_580276 = path.getOrDefault("project")
  valid_580276 = validateParameter(valid_580276, JString, required = true,
                                 default = nil)
  if valid_580276 != nil:
    section.add "project", valid_580276
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
  var valid_580277 = query.getOrDefault("key")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "key", valid_580277
  var valid_580278 = query.getOrDefault("prettyPrint")
  valid_580278 = validateParameter(valid_580278, JBool, required = false,
                                 default = newJBool(true))
  if valid_580278 != nil:
    section.add "prettyPrint", valid_580278
  var valid_580279 = query.getOrDefault("oauth_token")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "oauth_token", valid_580279
  var valid_580280 = query.getOrDefault("$.xgafv")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = newJString("1"))
  if valid_580280 != nil:
    section.add "$.xgafv", valid_580280
  var valid_580281 = query.getOrDefault("alt")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = newJString("json"))
  if valid_580281 != nil:
    section.add "alt", valid_580281
  var valid_580282 = query.getOrDefault("uploadType")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = nil)
  if valid_580282 != nil:
    section.add "uploadType", valid_580282
  var valid_580283 = query.getOrDefault("quotaUser")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = nil)
  if valid_580283 != nil:
    section.add "quotaUser", valid_580283
  var valid_580284 = query.getOrDefault("callback")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "callback", valid_580284
  var valid_580285 = query.getOrDefault("fields")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = nil)
  if valid_580285 != nil:
    section.add "fields", valid_580285
  var valid_580286 = query.getOrDefault("access_token")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "access_token", valid_580286
  var valid_580287 = query.getOrDefault("upload_protocol")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "upload_protocol", valid_580287
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

proc call*(call_580289: Call_FirebaseProjectsAddFirebase_580273; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds Firebase resources to the specified existing
  ## [Google Cloud Platform (GCP) `Project`]
  ## (https://cloud.google.com/resource-manager/reference/rest/v1/projects).
  ## <br>
  ## <br>Since a FirebaseProject is actually also a GCP `Project`, a
  ## `FirebaseProject` uses underlying GCP identifiers (most importantly,
  ## the `projectId`) as its own for easy interop with GCP APIs.
  ## <br>
  ## <br>The result of this call is an [`Operation`](../../v1beta1/operations).
  ## Poll the `Operation` to track the provisioning process by calling
  ## GetOperation until
  ## [`done`](../../v1beta1/operations#Operation.FIELDS.done) is `true`. When
  ## `done` is `true`, the `Operation` has either succeeded or failed. If the
  ## `Operation` succeeded, its
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) is set to
  ## a FirebaseProject; if the `Operation` failed, its
  ## [`error`](../../v1beta1/operations#Operation.FIELDS.error) is set to a
  ## google.rpc.Status. The `Operation` is automatically deleted after
  ## completion, so there is no need to call
  ## DeleteOperation.
  ## <br>
  ## <br>This method does not modify any billing account information on the
  ## underlying GCP `Project`.
  ## <br>
  ## <br>To call `AddFirebase`, a member must be an Editor or Owner for the
  ## existing GCP `Project`. Service accounts cannot call `AddFirebase`.
  ## 
  let valid = call_580289.validator(path, query, header, formData, body)
  let scheme = call_580289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580289.url(scheme.get, call_580289.host, call_580289.base,
                         call_580289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580289, url, valid)

proc call*(call_580290: Call_FirebaseProjectsAddFirebase_580273; project: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firebaseProjectsAddFirebase
  ## Adds Firebase resources to the specified existing
  ## [Google Cloud Platform (GCP) `Project`]
  ## (https://cloud.google.com/resource-manager/reference/rest/v1/projects).
  ## <br>
  ## <br>Since a FirebaseProject is actually also a GCP `Project`, a
  ## `FirebaseProject` uses underlying GCP identifiers (most importantly,
  ## the `projectId`) as its own for easy interop with GCP APIs.
  ## <br>
  ## <br>The result of this call is an [`Operation`](../../v1beta1/operations).
  ## Poll the `Operation` to track the provisioning process by calling
  ## GetOperation until
  ## [`done`](../../v1beta1/operations#Operation.FIELDS.done) is `true`. When
  ## `done` is `true`, the `Operation` has either succeeded or failed. If the
  ## `Operation` succeeded, its
  ## [`response`](../../v1beta1/operations#Operation.FIELDS.response) is set to
  ## a FirebaseProject; if the `Operation` failed, its
  ## [`error`](../../v1beta1/operations#Operation.FIELDS.error) is set to a
  ## google.rpc.Status. The `Operation` is automatically deleted after
  ## completion, so there is no need to call
  ## DeleteOperation.
  ## <br>
  ## <br>This method does not modify any billing account information on the
  ## underlying GCP `Project`.
  ## <br>
  ## <br>To call `AddFirebase`, a member must be an Editor or Owner for the
  ## existing GCP `Project`. Service accounts cannot call `AddFirebase`.
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
  ##   project: string (required)
  ##          : The resource name of the GCP `Project` to which Firebase resources will be
  ## added, in the format:
  ## <br><code>projects/<var>projectId</var></code>
  ## After calling `AddFirebase`, the
  ## 
  ## [`projectId`](https://cloud.google.com/resource-manager/reference/rest/v1/projects#Project.FIELDS.project_id)
  ## of the GCP `Project` is also the `projectId` of the FirebaseProject.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580291 = newJObject()
  var query_580292 = newJObject()
  var body_580293 = newJObject()
  add(query_580292, "key", newJString(key))
  add(query_580292, "prettyPrint", newJBool(prettyPrint))
  add(query_580292, "oauth_token", newJString(oauthToken))
  add(query_580292, "$.xgafv", newJString(Xgafv))
  add(query_580292, "alt", newJString(alt))
  add(query_580292, "uploadType", newJString(uploadType))
  add(query_580292, "quotaUser", newJString(quotaUser))
  add(path_580291, "project", newJString(project))
  if body != nil:
    body_580293 = body
  add(query_580292, "callback", newJString(callback))
  add(query_580292, "fields", newJString(fields))
  add(query_580292, "access_token", newJString(accessToken))
  add(query_580292, "upload_protocol", newJString(uploadProtocol))
  result = call_580290.call(path_580291, query_580292, nil, nil, body_580293)

var firebaseProjectsAddFirebase* = Call_FirebaseProjectsAddFirebase_580273(
    name: "firebaseProjectsAddFirebase", meth: HttpMethod.HttpPost,
    host: "firebase.googleapis.com", route: "/v1beta1/{project}:addFirebase",
    validator: validate_FirebaseProjectsAddFirebase_580274, base: "/",
    url: url_FirebaseProjectsAddFirebase_580275, schemes: {Scheme.Https})
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
