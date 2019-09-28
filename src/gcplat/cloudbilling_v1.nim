
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Billing
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Allows developers to manage billing for their Google Cloud Platform projects
##     programmatically.
## 
## https://cloud.google.com/billing/
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
  gcpServiceName = "cloudbilling"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudbillingBillingAccountsCreate_579952 = ref object of OpenApiRestCall_579408
proc url_CloudbillingBillingAccountsCreate_579954(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudbillingBillingAccountsCreate_579953(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a billing account.
  ## This method can only be used to create
  ## [billing subaccounts](https://cloud.google.com/billing/docs/concepts)
  ## by GCP resellers.
  ## When creating a subaccount, the current authenticated user must have the
  ## `billing.accounts.update` IAM permission on the master account, which is
  ## typically given to billing account
  ## [administrators](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## This method will return an error if the master account has not been
  ## provisioned as a reseller account.
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
  var valid_579955 = query.getOrDefault("upload_protocol")
  valid_579955 = validateParameter(valid_579955, JString, required = false,
                                 default = nil)
  if valid_579955 != nil:
    section.add "upload_protocol", valid_579955
  var valid_579956 = query.getOrDefault("fields")
  valid_579956 = validateParameter(valid_579956, JString, required = false,
                                 default = nil)
  if valid_579956 != nil:
    section.add "fields", valid_579956
  var valid_579957 = query.getOrDefault("quotaUser")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = nil)
  if valid_579957 != nil:
    section.add "quotaUser", valid_579957
  var valid_579958 = query.getOrDefault("alt")
  valid_579958 = validateParameter(valid_579958, JString, required = false,
                                 default = newJString("json"))
  if valid_579958 != nil:
    section.add "alt", valid_579958
  var valid_579959 = query.getOrDefault("oauth_token")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = nil)
  if valid_579959 != nil:
    section.add "oauth_token", valid_579959
  var valid_579960 = query.getOrDefault("callback")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = nil)
  if valid_579960 != nil:
    section.add "callback", valid_579960
  var valid_579961 = query.getOrDefault("access_token")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = nil)
  if valid_579961 != nil:
    section.add "access_token", valid_579961
  var valid_579962 = query.getOrDefault("uploadType")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "uploadType", valid_579962
  var valid_579963 = query.getOrDefault("key")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = nil)
  if valid_579963 != nil:
    section.add "key", valid_579963
  var valid_579964 = query.getOrDefault("$.xgafv")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = newJString("1"))
  if valid_579964 != nil:
    section.add "$.xgafv", valid_579964
  var valid_579965 = query.getOrDefault("prettyPrint")
  valid_579965 = validateParameter(valid_579965, JBool, required = false,
                                 default = newJBool(true))
  if valid_579965 != nil:
    section.add "prettyPrint", valid_579965
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

proc call*(call_579967: Call_CloudbillingBillingAccountsCreate_579952;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a billing account.
  ## This method can only be used to create
  ## [billing subaccounts](https://cloud.google.com/billing/docs/concepts)
  ## by GCP resellers.
  ## When creating a subaccount, the current authenticated user must have the
  ## `billing.accounts.update` IAM permission on the master account, which is
  ## typically given to billing account
  ## [administrators](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## This method will return an error if the master account has not been
  ## provisioned as a reseller account.
  ## 
  let valid = call_579967.validator(path, query, header, formData, body)
  let scheme = call_579967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579967.url(scheme.get, call_579967.host, call_579967.base,
                         call_579967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579967, url, valid)

proc call*(call_579968: Call_CloudbillingBillingAccountsCreate_579952;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## cloudbillingBillingAccountsCreate
  ## Creates a billing account.
  ## This method can only be used to create
  ## [billing subaccounts](https://cloud.google.com/billing/docs/concepts)
  ## by GCP resellers.
  ## When creating a subaccount, the current authenticated user must have the
  ## `billing.accounts.update` IAM permission on the master account, which is
  ## typically given to billing account
  ## [administrators](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## This method will return an error if the master account has not been
  ## provisioned as a reseller account.
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
  var query_579969 = newJObject()
  var body_579970 = newJObject()
  add(query_579969, "upload_protocol", newJString(uploadProtocol))
  add(query_579969, "fields", newJString(fields))
  add(query_579969, "quotaUser", newJString(quotaUser))
  add(query_579969, "alt", newJString(alt))
  add(query_579969, "oauth_token", newJString(oauthToken))
  add(query_579969, "callback", newJString(callback))
  add(query_579969, "access_token", newJString(accessToken))
  add(query_579969, "uploadType", newJString(uploadType))
  add(query_579969, "key", newJString(key))
  add(query_579969, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579970 = body
  add(query_579969, "prettyPrint", newJBool(prettyPrint))
  result = call_579968.call(nil, query_579969, nil, nil, body_579970)

var cloudbillingBillingAccountsCreate* = Call_CloudbillingBillingAccountsCreate_579952(
    name: "cloudbillingBillingAccountsCreate", meth: HttpMethod.HttpPost,
    host: "cloudbilling.googleapis.com", route: "/v1/billingAccounts",
    validator: validate_CloudbillingBillingAccountsCreate_579953, base: "/",
    url: url_CloudbillingBillingAccountsCreate_579954, schemes: {Scheme.Https})
type
  Call_CloudbillingBillingAccountsList_579677 = ref object of OpenApiRestCall_579408
proc url_CloudbillingBillingAccountsList_579679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudbillingBillingAccountsList_579678(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the billing accounts that the current authenticated user has
  ## permission to
  ## [view](https://cloud.google.com/billing/docs/how-to/billing-access).
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
  ##            : A token identifying a page of results to return. This should be a
  ## `next_page_token` value returned from a previous `ListBillingAccounts`
  ## call. If unspecified, the first page of results is returned.
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
  ##           : Requested page size. The maximum page size is 100; this is also the
  ## default.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Options for how to filter the returned billing accounts.
  ## Currently this only supports filtering for
  ## [subaccounts](https://cloud.google.com/billing/docs/concepts) under a
  ## single provided reseller billing account.
  ## (e.g. "master_billing_account=billingAccounts/012345-678901-ABCDEF").
  ## Boolean algebra and other fields are not currently supported.
  section = newJObject()
  var valid_579791 = query.getOrDefault("upload_protocol")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "upload_protocol", valid_579791
  var valid_579792 = query.getOrDefault("fields")
  valid_579792 = validateParameter(valid_579792, JString, required = false,
                                 default = nil)
  if valid_579792 != nil:
    section.add "fields", valid_579792
  var valid_579793 = query.getOrDefault("pageToken")
  valid_579793 = validateParameter(valid_579793, JString, required = false,
                                 default = nil)
  if valid_579793 != nil:
    section.add "pageToken", valid_579793
  var valid_579794 = query.getOrDefault("quotaUser")
  valid_579794 = validateParameter(valid_579794, JString, required = false,
                                 default = nil)
  if valid_579794 != nil:
    section.add "quotaUser", valid_579794
  var valid_579808 = query.getOrDefault("alt")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = newJString("json"))
  if valid_579808 != nil:
    section.add "alt", valid_579808
  var valid_579809 = query.getOrDefault("oauth_token")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = nil)
  if valid_579809 != nil:
    section.add "oauth_token", valid_579809
  var valid_579810 = query.getOrDefault("callback")
  valid_579810 = validateParameter(valid_579810, JString, required = false,
                                 default = nil)
  if valid_579810 != nil:
    section.add "callback", valid_579810
  var valid_579811 = query.getOrDefault("access_token")
  valid_579811 = validateParameter(valid_579811, JString, required = false,
                                 default = nil)
  if valid_579811 != nil:
    section.add "access_token", valid_579811
  var valid_579812 = query.getOrDefault("uploadType")
  valid_579812 = validateParameter(valid_579812, JString, required = false,
                                 default = nil)
  if valid_579812 != nil:
    section.add "uploadType", valid_579812
  var valid_579813 = query.getOrDefault("key")
  valid_579813 = validateParameter(valid_579813, JString, required = false,
                                 default = nil)
  if valid_579813 != nil:
    section.add "key", valid_579813
  var valid_579814 = query.getOrDefault("$.xgafv")
  valid_579814 = validateParameter(valid_579814, JString, required = false,
                                 default = newJString("1"))
  if valid_579814 != nil:
    section.add "$.xgafv", valid_579814
  var valid_579815 = query.getOrDefault("pageSize")
  valid_579815 = validateParameter(valid_579815, JInt, required = false, default = nil)
  if valid_579815 != nil:
    section.add "pageSize", valid_579815
  var valid_579816 = query.getOrDefault("prettyPrint")
  valid_579816 = validateParameter(valid_579816, JBool, required = false,
                                 default = newJBool(true))
  if valid_579816 != nil:
    section.add "prettyPrint", valid_579816
  var valid_579817 = query.getOrDefault("filter")
  valid_579817 = validateParameter(valid_579817, JString, required = false,
                                 default = nil)
  if valid_579817 != nil:
    section.add "filter", valid_579817
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579840: Call_CloudbillingBillingAccountsList_579677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the billing accounts that the current authenticated user has
  ## permission to
  ## [view](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  let valid = call_579840.validator(path, query, header, formData, body)
  let scheme = call_579840.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579840.url(scheme.get, call_579840.host, call_579840.base,
                         call_579840.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579840, url, valid)

proc call*(call_579911: Call_CloudbillingBillingAccountsList_579677;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## cloudbillingBillingAccountsList
  ## Lists the billing accounts that the current authenticated user has
  ## permission to
  ## [view](https://cloud.google.com/billing/docs/how-to/billing-access).
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token identifying a page of results to return. This should be a
  ## `next_page_token` value returned from a previous `ListBillingAccounts`
  ## call. If unspecified, the first page of results is returned.
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
  ##   pageSize: int
  ##           : Requested page size. The maximum page size is 100; this is also the
  ## default.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Options for how to filter the returned billing accounts.
  ## Currently this only supports filtering for
  ## [subaccounts](https://cloud.google.com/billing/docs/concepts) under a
  ## single provided reseller billing account.
  ## (e.g. "master_billing_account=billingAccounts/012345-678901-ABCDEF").
  ## Boolean algebra and other fields are not currently supported.
  var query_579912 = newJObject()
  add(query_579912, "upload_protocol", newJString(uploadProtocol))
  add(query_579912, "fields", newJString(fields))
  add(query_579912, "pageToken", newJString(pageToken))
  add(query_579912, "quotaUser", newJString(quotaUser))
  add(query_579912, "alt", newJString(alt))
  add(query_579912, "oauth_token", newJString(oauthToken))
  add(query_579912, "callback", newJString(callback))
  add(query_579912, "access_token", newJString(accessToken))
  add(query_579912, "uploadType", newJString(uploadType))
  add(query_579912, "key", newJString(key))
  add(query_579912, "$.xgafv", newJString(Xgafv))
  add(query_579912, "pageSize", newJInt(pageSize))
  add(query_579912, "prettyPrint", newJBool(prettyPrint))
  add(query_579912, "filter", newJString(filter))
  result = call_579911.call(nil, query_579912, nil, nil, nil)

var cloudbillingBillingAccountsList* = Call_CloudbillingBillingAccountsList_579677(
    name: "cloudbillingBillingAccountsList", meth: HttpMethod.HttpGet,
    host: "cloudbilling.googleapis.com", route: "/v1/billingAccounts",
    validator: validate_CloudbillingBillingAccountsList_579678, base: "/",
    url: url_CloudbillingBillingAccountsList_579679, schemes: {Scheme.Https})
type
  Call_CloudbillingServicesList_579971 = ref object of OpenApiRestCall_579408
proc url_CloudbillingServicesList_579973(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudbillingServicesList_579972(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all public cloud services.
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
  ##            : A token identifying a page of results to return. This should be a
  ## `next_page_token` value returned from a previous `ListServices`
  ## call. If unspecified, the first page of results is returned.
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
  ##           : Requested page size. Defaults to 5000.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579974 = query.getOrDefault("upload_protocol")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "upload_protocol", valid_579974
  var valid_579975 = query.getOrDefault("fields")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "fields", valid_579975
  var valid_579976 = query.getOrDefault("pageToken")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "pageToken", valid_579976
  var valid_579977 = query.getOrDefault("quotaUser")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "quotaUser", valid_579977
  var valid_579978 = query.getOrDefault("alt")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = newJString("json"))
  if valid_579978 != nil:
    section.add "alt", valid_579978
  var valid_579979 = query.getOrDefault("oauth_token")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "oauth_token", valid_579979
  var valid_579980 = query.getOrDefault("callback")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "callback", valid_579980
  var valid_579981 = query.getOrDefault("access_token")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "access_token", valid_579981
  var valid_579982 = query.getOrDefault("uploadType")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "uploadType", valid_579982
  var valid_579983 = query.getOrDefault("key")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "key", valid_579983
  var valid_579984 = query.getOrDefault("$.xgafv")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = newJString("1"))
  if valid_579984 != nil:
    section.add "$.xgafv", valid_579984
  var valid_579985 = query.getOrDefault("pageSize")
  valid_579985 = validateParameter(valid_579985, JInt, required = false, default = nil)
  if valid_579985 != nil:
    section.add "pageSize", valid_579985
  var valid_579986 = query.getOrDefault("prettyPrint")
  valid_579986 = validateParameter(valid_579986, JBool, required = false,
                                 default = newJBool(true))
  if valid_579986 != nil:
    section.add "prettyPrint", valid_579986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579987: Call_CloudbillingServicesList_579971; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all public cloud services.
  ## 
  let valid = call_579987.validator(path, query, header, formData, body)
  let scheme = call_579987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579987.url(scheme.get, call_579987.host, call_579987.base,
                         call_579987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579987, url, valid)

proc call*(call_579988: Call_CloudbillingServicesList_579971;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## cloudbillingServicesList
  ## Lists all public cloud services.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token identifying a page of results to return. This should be a
  ## `next_page_token` value returned from a previous `ListServices`
  ## call. If unspecified, the first page of results is returned.
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
  ##   pageSize: int
  ##           : Requested page size. Defaults to 5000.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579989 = newJObject()
  add(query_579989, "upload_protocol", newJString(uploadProtocol))
  add(query_579989, "fields", newJString(fields))
  add(query_579989, "pageToken", newJString(pageToken))
  add(query_579989, "quotaUser", newJString(quotaUser))
  add(query_579989, "alt", newJString(alt))
  add(query_579989, "oauth_token", newJString(oauthToken))
  add(query_579989, "callback", newJString(callback))
  add(query_579989, "access_token", newJString(accessToken))
  add(query_579989, "uploadType", newJString(uploadType))
  add(query_579989, "key", newJString(key))
  add(query_579989, "$.xgafv", newJString(Xgafv))
  add(query_579989, "pageSize", newJInt(pageSize))
  add(query_579989, "prettyPrint", newJBool(prettyPrint))
  result = call_579988.call(nil, query_579989, nil, nil, nil)

var cloudbillingServicesList* = Call_CloudbillingServicesList_579971(
    name: "cloudbillingServicesList", meth: HttpMethod.HttpGet,
    host: "cloudbilling.googleapis.com", route: "/v1/services",
    validator: validate_CloudbillingServicesList_579972, base: "/",
    url: url_CloudbillingServicesList_579973, schemes: {Scheme.Https})
type
  Call_CloudbillingBillingAccountsGet_579990 = ref object of OpenApiRestCall_579408
proc url_CloudbillingBillingAccountsGet_579992(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbillingBillingAccountsGet_579991(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about a billing account. The current authenticated user
  ## must be a [viewer of the billing
  ## account](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the billing account to retrieve. For example,
  ## `billingAccounts/012345-567890-ABCDEF`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580007 = path.getOrDefault("name")
  valid_580007 = validateParameter(valid_580007, JString, required = true,
                                 default = nil)
  if valid_580007 != nil:
    section.add "name", valid_580007
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
  var valid_580008 = query.getOrDefault("upload_protocol")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "upload_protocol", valid_580008
  var valid_580009 = query.getOrDefault("fields")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "fields", valid_580009
  var valid_580010 = query.getOrDefault("quotaUser")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "quotaUser", valid_580010
  var valid_580011 = query.getOrDefault("alt")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = newJString("json"))
  if valid_580011 != nil:
    section.add "alt", valid_580011
  var valid_580012 = query.getOrDefault("oauth_token")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "oauth_token", valid_580012
  var valid_580013 = query.getOrDefault("callback")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "callback", valid_580013
  var valid_580014 = query.getOrDefault("access_token")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "access_token", valid_580014
  var valid_580015 = query.getOrDefault("uploadType")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "uploadType", valid_580015
  var valid_580016 = query.getOrDefault("key")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "key", valid_580016
  var valid_580017 = query.getOrDefault("$.xgafv")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = newJString("1"))
  if valid_580017 != nil:
    section.add "$.xgafv", valid_580017
  var valid_580018 = query.getOrDefault("prettyPrint")
  valid_580018 = validateParameter(valid_580018, JBool, required = false,
                                 default = newJBool(true))
  if valid_580018 != nil:
    section.add "prettyPrint", valid_580018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580019: Call_CloudbillingBillingAccountsGet_579990; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a billing account. The current authenticated user
  ## must be a [viewer of the billing
  ## account](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  let valid = call_580019.validator(path, query, header, formData, body)
  let scheme = call_580019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580019.url(scheme.get, call_580019.host, call_580019.base,
                         call_580019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580019, url, valid)

proc call*(call_580020: Call_CloudbillingBillingAccountsGet_579990; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudbillingBillingAccountsGet
  ## Gets information about a billing account. The current authenticated user
  ## must be a [viewer of the billing
  ## account](https://cloud.google.com/billing/docs/how-to/billing-access).
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the billing account to retrieve. For example,
  ## `billingAccounts/012345-567890-ABCDEF`.
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
  var path_580021 = newJObject()
  var query_580022 = newJObject()
  add(query_580022, "upload_protocol", newJString(uploadProtocol))
  add(query_580022, "fields", newJString(fields))
  add(query_580022, "quotaUser", newJString(quotaUser))
  add(path_580021, "name", newJString(name))
  add(query_580022, "alt", newJString(alt))
  add(query_580022, "oauth_token", newJString(oauthToken))
  add(query_580022, "callback", newJString(callback))
  add(query_580022, "access_token", newJString(accessToken))
  add(query_580022, "uploadType", newJString(uploadType))
  add(query_580022, "key", newJString(key))
  add(query_580022, "$.xgafv", newJString(Xgafv))
  add(query_580022, "prettyPrint", newJBool(prettyPrint))
  result = call_580020.call(path_580021, query_580022, nil, nil, nil)

var cloudbillingBillingAccountsGet* = Call_CloudbillingBillingAccountsGet_579990(
    name: "cloudbillingBillingAccountsGet", meth: HttpMethod.HttpGet,
    host: "cloudbilling.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudbillingBillingAccountsGet_579991, base: "/",
    url: url_CloudbillingBillingAccountsGet_579992, schemes: {Scheme.Https})
type
  Call_CloudbillingBillingAccountsPatch_580023 = ref object of OpenApiRestCall_579408
proc url_CloudbillingBillingAccountsPatch_580025(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbillingBillingAccountsPatch_580024(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a billing account's fields.
  ## Currently the only field that can be edited is `display_name`.
  ## The current authenticated user must have the `billing.accounts.update`
  ## IAM permission, which is typically given to the
  ## [administrator](https://cloud.google.com/billing/docs/how-to/billing-access)
  ## of the billing account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the billing account resource to be updated.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580026 = path.getOrDefault("name")
  valid_580026 = validateParameter(valid_580026, JString, required = true,
                                 default = nil)
  if valid_580026 != nil:
    section.add "name", valid_580026
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
  ##             : The update mask applied to the resource.
  ## Only "display_name" is currently supported.
  section = newJObject()
  var valid_580027 = query.getOrDefault("upload_protocol")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "upload_protocol", valid_580027
  var valid_580028 = query.getOrDefault("fields")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "fields", valid_580028
  var valid_580029 = query.getOrDefault("quotaUser")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "quotaUser", valid_580029
  var valid_580030 = query.getOrDefault("alt")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = newJString("json"))
  if valid_580030 != nil:
    section.add "alt", valid_580030
  var valid_580031 = query.getOrDefault("oauth_token")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "oauth_token", valid_580031
  var valid_580032 = query.getOrDefault("callback")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "callback", valid_580032
  var valid_580033 = query.getOrDefault("access_token")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "access_token", valid_580033
  var valid_580034 = query.getOrDefault("uploadType")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "uploadType", valid_580034
  var valid_580035 = query.getOrDefault("key")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "key", valid_580035
  var valid_580036 = query.getOrDefault("$.xgafv")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = newJString("1"))
  if valid_580036 != nil:
    section.add "$.xgafv", valid_580036
  var valid_580037 = query.getOrDefault("prettyPrint")
  valid_580037 = validateParameter(valid_580037, JBool, required = false,
                                 default = newJBool(true))
  if valid_580037 != nil:
    section.add "prettyPrint", valid_580037
  var valid_580038 = query.getOrDefault("updateMask")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "updateMask", valid_580038
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

proc call*(call_580040: Call_CloudbillingBillingAccountsPatch_580023;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a billing account's fields.
  ## Currently the only field that can be edited is `display_name`.
  ## The current authenticated user must have the `billing.accounts.update`
  ## IAM permission, which is typically given to the
  ## [administrator](https://cloud.google.com/billing/docs/how-to/billing-access)
  ## of the billing account.
  ## 
  let valid = call_580040.validator(path, query, header, formData, body)
  let scheme = call_580040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580040.url(scheme.get, call_580040.host, call_580040.base,
                         call_580040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580040, url, valid)

proc call*(call_580041: Call_CloudbillingBillingAccountsPatch_580023; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true;
          updateMask: string = ""): Recallable =
  ## cloudbillingBillingAccountsPatch
  ## Updates a billing account's fields.
  ## Currently the only field that can be edited is `display_name`.
  ## The current authenticated user must have the `billing.accounts.update`
  ## IAM permission, which is typically given to the
  ## [administrator](https://cloud.google.com/billing/docs/how-to/billing-access)
  ## of the billing account.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the billing account resource to be updated.
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
  ##   updateMask: string
  ##             : The update mask applied to the resource.
  ## Only "display_name" is currently supported.
  var path_580042 = newJObject()
  var query_580043 = newJObject()
  var body_580044 = newJObject()
  add(query_580043, "upload_protocol", newJString(uploadProtocol))
  add(query_580043, "fields", newJString(fields))
  add(query_580043, "quotaUser", newJString(quotaUser))
  add(path_580042, "name", newJString(name))
  add(query_580043, "alt", newJString(alt))
  add(query_580043, "oauth_token", newJString(oauthToken))
  add(query_580043, "callback", newJString(callback))
  add(query_580043, "access_token", newJString(accessToken))
  add(query_580043, "uploadType", newJString(uploadType))
  add(query_580043, "key", newJString(key))
  add(query_580043, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580044 = body
  add(query_580043, "prettyPrint", newJBool(prettyPrint))
  add(query_580043, "updateMask", newJString(updateMask))
  result = call_580041.call(path_580042, query_580043, nil, nil, body_580044)

var cloudbillingBillingAccountsPatch* = Call_CloudbillingBillingAccountsPatch_580023(
    name: "cloudbillingBillingAccountsPatch", meth: HttpMethod.HttpPatch,
    host: "cloudbilling.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudbillingBillingAccountsPatch_580024, base: "/",
    url: url_CloudbillingBillingAccountsPatch_580025, schemes: {Scheme.Https})
type
  Call_CloudbillingProjectsUpdateBillingInfo_580064 = ref object of OpenApiRestCall_579408
proc url_CloudbillingProjectsUpdateBillingInfo_580066(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/billingInfo")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbillingProjectsUpdateBillingInfo_580065(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets or updates the billing account associated with a project. You specify
  ## the new billing account by setting the `billing_account_name` in the
  ## `ProjectBillingInfo` resource to the resource name of a billing account.
  ## Associating a project with an open billing account enables billing on the
  ## project and allows charges for resource usage. If the project already had a
  ## billing account, this method changes the billing account used for resource
  ## usage charges.
  ## 
  ## *Note:* Incurred charges that have not yet been reported in the transaction
  ## history of the GCP Console might be billed to the new billing
  ## account, even if the charge occurred before the new billing account was
  ## assigned to the project.
  ## 
  ## The current authenticated user must have ownership privileges for both the
  ## [project](https://cloud.google.com/docs/permissions-overview#h.bgs0oxofvnoo
  ## ) and the [billing
  ## account](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  ## You can disable billing on the project by setting the
  ## `billing_account_name` field to empty. This action disassociates the
  ## current billing account from the project. Any billable activity of your
  ## in-use services will stop, and your application could stop functioning as
  ## expected. Any unbilled charges to date will be billed to the previously
  ## associated account. The current authenticated user must be either an owner
  ## of the project or an owner of the billing account for the project.
  ## 
  ## Note that associating a project with a *closed* billing account will have
  ## much the same effect as disabling billing on the project: any paid
  ## resources used by the project will be shut down. Thus, unless you wish to
  ## disable billing, you should always call this method with the name of an
  ## *open* billing account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the project associated with the billing information
  ## that you want to update. For example, `projects/tokyo-rain-123`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580067 = path.getOrDefault("name")
  valid_580067 = validateParameter(valid_580067, JString, required = true,
                                 default = nil)
  if valid_580067 != nil:
    section.add "name", valid_580067
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
  var valid_580068 = query.getOrDefault("upload_protocol")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "upload_protocol", valid_580068
  var valid_580069 = query.getOrDefault("fields")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "fields", valid_580069
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
  var valid_580076 = query.getOrDefault("key")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "key", valid_580076
  var valid_580077 = query.getOrDefault("$.xgafv")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = newJString("1"))
  if valid_580077 != nil:
    section.add "$.xgafv", valid_580077
  var valid_580078 = query.getOrDefault("prettyPrint")
  valid_580078 = validateParameter(valid_580078, JBool, required = false,
                                 default = newJBool(true))
  if valid_580078 != nil:
    section.add "prettyPrint", valid_580078
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

proc call*(call_580080: Call_CloudbillingProjectsUpdateBillingInfo_580064;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets or updates the billing account associated with a project. You specify
  ## the new billing account by setting the `billing_account_name` in the
  ## `ProjectBillingInfo` resource to the resource name of a billing account.
  ## Associating a project with an open billing account enables billing on the
  ## project and allows charges for resource usage. If the project already had a
  ## billing account, this method changes the billing account used for resource
  ## usage charges.
  ## 
  ## *Note:* Incurred charges that have not yet been reported in the transaction
  ## history of the GCP Console might be billed to the new billing
  ## account, even if the charge occurred before the new billing account was
  ## assigned to the project.
  ## 
  ## The current authenticated user must have ownership privileges for both the
  ## [project](https://cloud.google.com/docs/permissions-overview#h.bgs0oxofvnoo
  ## ) and the [billing
  ## account](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  ## You can disable billing on the project by setting the
  ## `billing_account_name` field to empty. This action disassociates the
  ## current billing account from the project. Any billable activity of your
  ## in-use services will stop, and your application could stop functioning as
  ## expected. Any unbilled charges to date will be billed to the previously
  ## associated account. The current authenticated user must be either an owner
  ## of the project or an owner of the billing account for the project.
  ## 
  ## Note that associating a project with a *closed* billing account will have
  ## much the same effect as disabling billing on the project: any paid
  ## resources used by the project will be shut down. Thus, unless you wish to
  ## disable billing, you should always call this method with the name of an
  ## *open* billing account.
  ## 
  let valid = call_580080.validator(path, query, header, formData, body)
  let scheme = call_580080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580080.url(scheme.get, call_580080.host, call_580080.base,
                         call_580080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580080, url, valid)

proc call*(call_580081: Call_CloudbillingProjectsUpdateBillingInfo_580064;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudbillingProjectsUpdateBillingInfo
  ## Sets or updates the billing account associated with a project. You specify
  ## the new billing account by setting the `billing_account_name` in the
  ## `ProjectBillingInfo` resource to the resource name of a billing account.
  ## Associating a project with an open billing account enables billing on the
  ## project and allows charges for resource usage. If the project already had a
  ## billing account, this method changes the billing account used for resource
  ## usage charges.
  ## 
  ## *Note:* Incurred charges that have not yet been reported in the transaction
  ## history of the GCP Console might be billed to the new billing
  ## account, even if the charge occurred before the new billing account was
  ## assigned to the project.
  ## 
  ## The current authenticated user must have ownership privileges for both the
  ## [project](https://cloud.google.com/docs/permissions-overview#h.bgs0oxofvnoo
  ## ) and the [billing
  ## account](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  ## You can disable billing on the project by setting the
  ## `billing_account_name` field to empty. This action disassociates the
  ## current billing account from the project. Any billable activity of your
  ## in-use services will stop, and your application could stop functioning as
  ## expected. Any unbilled charges to date will be billed to the previously
  ## associated account. The current authenticated user must be either an owner
  ## of the project or an owner of the billing account for the project.
  ## 
  ## Note that associating a project with a *closed* billing account will have
  ## much the same effect as disabling billing on the project: any paid
  ## resources used by the project will be shut down. Thus, unless you wish to
  ## disable billing, you should always call this method with the name of an
  ## *open* billing account.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the project associated with the billing information
  ## that you want to update. For example, `projects/tokyo-rain-123`.
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
  var path_580082 = newJObject()
  var query_580083 = newJObject()
  var body_580084 = newJObject()
  add(query_580083, "upload_protocol", newJString(uploadProtocol))
  add(query_580083, "fields", newJString(fields))
  add(query_580083, "quotaUser", newJString(quotaUser))
  add(path_580082, "name", newJString(name))
  add(query_580083, "alt", newJString(alt))
  add(query_580083, "oauth_token", newJString(oauthToken))
  add(query_580083, "callback", newJString(callback))
  add(query_580083, "access_token", newJString(accessToken))
  add(query_580083, "uploadType", newJString(uploadType))
  add(query_580083, "key", newJString(key))
  add(query_580083, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580084 = body
  add(query_580083, "prettyPrint", newJBool(prettyPrint))
  result = call_580081.call(path_580082, query_580083, nil, nil, body_580084)

var cloudbillingProjectsUpdateBillingInfo* = Call_CloudbillingProjectsUpdateBillingInfo_580064(
    name: "cloudbillingProjectsUpdateBillingInfo", meth: HttpMethod.HttpPut,
    host: "cloudbilling.googleapis.com", route: "/v1/{name}/billingInfo",
    validator: validate_CloudbillingProjectsUpdateBillingInfo_580065, base: "/",
    url: url_CloudbillingProjectsUpdateBillingInfo_580066, schemes: {Scheme.Https})
type
  Call_CloudbillingProjectsGetBillingInfo_580045 = ref object of OpenApiRestCall_579408
proc url_CloudbillingProjectsGetBillingInfo_580047(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/billingInfo")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbillingProjectsGetBillingInfo_580046(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the billing information for a project. The current authenticated user
  ## must have [permission to view the
  ## project](https://cloud.google.com/docs/permissions-overview#h.bgs0oxofvnoo
  ## ).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the project for which billing information is
  ## retrieved. For example, `projects/tokyo-rain-123`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580048 = path.getOrDefault("name")
  valid_580048 = validateParameter(valid_580048, JString, required = true,
                                 default = nil)
  if valid_580048 != nil:
    section.add "name", valid_580048
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
  var valid_580049 = query.getOrDefault("upload_protocol")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "upload_protocol", valid_580049
  var valid_580050 = query.getOrDefault("fields")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "fields", valid_580050
  var valid_580051 = query.getOrDefault("quotaUser")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "quotaUser", valid_580051
  var valid_580052 = query.getOrDefault("alt")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = newJString("json"))
  if valid_580052 != nil:
    section.add "alt", valid_580052
  var valid_580053 = query.getOrDefault("oauth_token")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "oauth_token", valid_580053
  var valid_580054 = query.getOrDefault("callback")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "callback", valid_580054
  var valid_580055 = query.getOrDefault("access_token")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "access_token", valid_580055
  var valid_580056 = query.getOrDefault("uploadType")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "uploadType", valid_580056
  var valid_580057 = query.getOrDefault("key")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "key", valid_580057
  var valid_580058 = query.getOrDefault("$.xgafv")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = newJString("1"))
  if valid_580058 != nil:
    section.add "$.xgafv", valid_580058
  var valid_580059 = query.getOrDefault("prettyPrint")
  valid_580059 = validateParameter(valid_580059, JBool, required = false,
                                 default = newJBool(true))
  if valid_580059 != nil:
    section.add "prettyPrint", valid_580059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580060: Call_CloudbillingProjectsGetBillingInfo_580045;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the billing information for a project. The current authenticated user
  ## must have [permission to view the
  ## project](https://cloud.google.com/docs/permissions-overview#h.bgs0oxofvnoo
  ## ).
  ## 
  let valid = call_580060.validator(path, query, header, formData, body)
  let scheme = call_580060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580060.url(scheme.get, call_580060.host, call_580060.base,
                         call_580060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580060, url, valid)

proc call*(call_580061: Call_CloudbillingProjectsGetBillingInfo_580045;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudbillingProjectsGetBillingInfo
  ## Gets the billing information for a project. The current authenticated user
  ## must have [permission to view the
  ## project](https://cloud.google.com/docs/permissions-overview#h.bgs0oxofvnoo
  ## ).
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the project for which billing information is
  ## retrieved. For example, `projects/tokyo-rain-123`.
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
  var path_580062 = newJObject()
  var query_580063 = newJObject()
  add(query_580063, "upload_protocol", newJString(uploadProtocol))
  add(query_580063, "fields", newJString(fields))
  add(query_580063, "quotaUser", newJString(quotaUser))
  add(path_580062, "name", newJString(name))
  add(query_580063, "alt", newJString(alt))
  add(query_580063, "oauth_token", newJString(oauthToken))
  add(query_580063, "callback", newJString(callback))
  add(query_580063, "access_token", newJString(accessToken))
  add(query_580063, "uploadType", newJString(uploadType))
  add(query_580063, "key", newJString(key))
  add(query_580063, "$.xgafv", newJString(Xgafv))
  add(query_580063, "prettyPrint", newJBool(prettyPrint))
  result = call_580061.call(path_580062, query_580063, nil, nil, nil)

var cloudbillingProjectsGetBillingInfo* = Call_CloudbillingProjectsGetBillingInfo_580045(
    name: "cloudbillingProjectsGetBillingInfo", meth: HttpMethod.HttpGet,
    host: "cloudbilling.googleapis.com", route: "/v1/{name}/billingInfo",
    validator: validate_CloudbillingProjectsGetBillingInfo_580046, base: "/",
    url: url_CloudbillingProjectsGetBillingInfo_580047, schemes: {Scheme.Https})
type
  Call_CloudbillingBillingAccountsProjectsList_580085 = ref object of OpenApiRestCall_579408
proc url_CloudbillingBillingAccountsProjectsList_580087(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/projects")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbillingBillingAccountsProjectsList_580086(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the projects associated with a billing account. The current
  ## authenticated user must have the `billing.resourceAssociations.list` IAM
  ## permission, which is often given to billing account
  ## [viewers](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the billing account associated with the projects that
  ## you want to list. For example, `billingAccounts/012345-567890-ABCDEF`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580088 = path.getOrDefault("name")
  valid_580088 = validateParameter(valid_580088, JString, required = true,
                                 default = nil)
  if valid_580088 != nil:
    section.add "name", valid_580088
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A token identifying a page of results to be returned. This should be a
  ## `next_page_token` value returned from a previous `ListProjectBillingInfo`
  ## call. If unspecified, the first page of results is returned.
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
  ##           : Requested page size. The maximum page size is 100; this is also the
  ## default.
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
  var valid_580091 = query.getOrDefault("pageToken")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "pageToken", valid_580091
  var valid_580092 = query.getOrDefault("quotaUser")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "quotaUser", valid_580092
  var valid_580093 = query.getOrDefault("alt")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = newJString("json"))
  if valid_580093 != nil:
    section.add "alt", valid_580093
  var valid_580094 = query.getOrDefault("oauth_token")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "oauth_token", valid_580094
  var valid_580095 = query.getOrDefault("callback")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "callback", valid_580095
  var valid_580096 = query.getOrDefault("access_token")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "access_token", valid_580096
  var valid_580097 = query.getOrDefault("uploadType")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "uploadType", valid_580097
  var valid_580098 = query.getOrDefault("key")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "key", valid_580098
  var valid_580099 = query.getOrDefault("$.xgafv")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = newJString("1"))
  if valid_580099 != nil:
    section.add "$.xgafv", valid_580099
  var valid_580100 = query.getOrDefault("pageSize")
  valid_580100 = validateParameter(valid_580100, JInt, required = false, default = nil)
  if valid_580100 != nil:
    section.add "pageSize", valid_580100
  var valid_580101 = query.getOrDefault("prettyPrint")
  valid_580101 = validateParameter(valid_580101, JBool, required = false,
                                 default = newJBool(true))
  if valid_580101 != nil:
    section.add "prettyPrint", valid_580101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580102: Call_CloudbillingBillingAccountsProjectsList_580085;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the projects associated with a billing account. The current
  ## authenticated user must have the `billing.resourceAssociations.list` IAM
  ## permission, which is often given to billing account
  ## [viewers](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  let valid = call_580102.validator(path, query, header, formData, body)
  let scheme = call_580102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580102.url(scheme.get, call_580102.host, call_580102.base,
                         call_580102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580102, url, valid)

proc call*(call_580103: Call_CloudbillingBillingAccountsProjectsList_580085;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## cloudbillingBillingAccountsProjectsList
  ## Lists the projects associated with a billing account. The current
  ## authenticated user must have the `billing.resourceAssociations.list` IAM
  ## permission, which is often given to billing account
  ## [viewers](https://cloud.google.com/billing/docs/how-to/billing-access).
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token identifying a page of results to be returned. This should be a
  ## `next_page_token` value returned from a previous `ListProjectBillingInfo`
  ## call. If unspecified, the first page of results is returned.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the billing account associated with the projects that
  ## you want to list. For example, `billingAccounts/012345-567890-ABCDEF`.
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
  ##   pageSize: int
  ##           : Requested page size. The maximum page size is 100; this is also the
  ## default.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580104 = newJObject()
  var query_580105 = newJObject()
  add(query_580105, "upload_protocol", newJString(uploadProtocol))
  add(query_580105, "fields", newJString(fields))
  add(query_580105, "pageToken", newJString(pageToken))
  add(query_580105, "quotaUser", newJString(quotaUser))
  add(path_580104, "name", newJString(name))
  add(query_580105, "alt", newJString(alt))
  add(query_580105, "oauth_token", newJString(oauthToken))
  add(query_580105, "callback", newJString(callback))
  add(query_580105, "access_token", newJString(accessToken))
  add(query_580105, "uploadType", newJString(uploadType))
  add(query_580105, "key", newJString(key))
  add(query_580105, "$.xgafv", newJString(Xgafv))
  add(query_580105, "pageSize", newJInt(pageSize))
  add(query_580105, "prettyPrint", newJBool(prettyPrint))
  result = call_580103.call(path_580104, query_580105, nil, nil, nil)

var cloudbillingBillingAccountsProjectsList* = Call_CloudbillingBillingAccountsProjectsList_580085(
    name: "cloudbillingBillingAccountsProjectsList", meth: HttpMethod.HttpGet,
    host: "cloudbilling.googleapis.com", route: "/v1/{name}/projects",
    validator: validate_CloudbillingBillingAccountsProjectsList_580086, base: "/",
    url: url_CloudbillingBillingAccountsProjectsList_580087,
    schemes: {Scheme.Https})
type
  Call_CloudbillingServicesSkusList_580106 = ref object of OpenApiRestCall_579408
proc url_CloudbillingServicesSkusList_580108(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbillingServicesSkusList_580107(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all publicly available SKUs for a given cloud service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the service.
  ## Example: "services/DA34-426B-A397"
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580109 = path.getOrDefault("parent")
  valid_580109 = validateParameter(valid_580109, JString, required = true,
                                 default = nil)
  if valid_580109 != nil:
    section.add "parent", valid_580109
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A token identifying a page of results to return. This should be a
  ## `next_page_token` value returned from a previous `ListSkus`
  ## call. If unspecified, the first page of results is returned.
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
  ##   endTime: JString
  ##          : Optional exclusive end time of the time range for which the pricing
  ## versions will be returned. Timestamps in the future are not allowed.
  ## The time range has to be within a single calendar month in
  ## America/Los_Angeles timezone. Time range as a whole is optional. If not
  ## specified, the latest pricing will be returned (up to 12 hours old at
  ## most).
  ##   currencyCode: JString
  ##               : The ISO 4217 currency code for the pricing info in the response proto.
  ## Will use the conversion rate as of start_time.
  ## Optional. If not specified USD will be used.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Requested page size. Defaults to 5000.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startTime: JString
  ##            : Optional inclusive start time of the time range for which the pricing
  ## versions will be returned. Timestamps in the future are not allowed.
  ## The time range has to be within a single calendar month in
  ## America/Los_Angeles timezone. Time range as a whole is optional. If not
  ## specified, the latest pricing will be returned (up to 12 hours old at
  ## most).
  section = newJObject()
  var valid_580110 = query.getOrDefault("upload_protocol")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "upload_protocol", valid_580110
  var valid_580111 = query.getOrDefault("fields")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "fields", valid_580111
  var valid_580112 = query.getOrDefault("pageToken")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "pageToken", valid_580112
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
  var valid_580119 = query.getOrDefault("endTime")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "endTime", valid_580119
  var valid_580120 = query.getOrDefault("currencyCode")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "currencyCode", valid_580120
  var valid_580121 = query.getOrDefault("key")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "key", valid_580121
  var valid_580122 = query.getOrDefault("$.xgafv")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = newJString("1"))
  if valid_580122 != nil:
    section.add "$.xgafv", valid_580122
  var valid_580123 = query.getOrDefault("pageSize")
  valid_580123 = validateParameter(valid_580123, JInt, required = false, default = nil)
  if valid_580123 != nil:
    section.add "pageSize", valid_580123
  var valid_580124 = query.getOrDefault("prettyPrint")
  valid_580124 = validateParameter(valid_580124, JBool, required = false,
                                 default = newJBool(true))
  if valid_580124 != nil:
    section.add "prettyPrint", valid_580124
  var valid_580125 = query.getOrDefault("startTime")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "startTime", valid_580125
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580126: Call_CloudbillingServicesSkusList_580106; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all publicly available SKUs for a given cloud service.
  ## 
  let valid = call_580126.validator(path, query, header, formData, body)
  let scheme = call_580126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580126.url(scheme.get, call_580126.host, call_580126.base,
                         call_580126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580126, url, valid)

proc call*(call_580127: Call_CloudbillingServicesSkusList_580106; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          endTime: string = ""; currencyCode: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true;
          startTime: string = ""): Recallable =
  ## cloudbillingServicesSkusList
  ## Lists all publicly available SKUs for a given cloud service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token identifying a page of results to return. This should be a
  ## `next_page_token` value returned from a previous `ListSkus`
  ## call. If unspecified, the first page of results is returned.
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
  ##   parent: string (required)
  ##         : The name of the service.
  ## Example: "services/DA34-426B-A397"
  ##   endTime: string
  ##          : Optional exclusive end time of the time range for which the pricing
  ## versions will be returned. Timestamps in the future are not allowed.
  ## The time range has to be within a single calendar month in
  ## America/Los_Angeles timezone. Time range as a whole is optional. If not
  ## specified, the latest pricing will be returned (up to 12 hours old at
  ## most).
  ##   currencyCode: string
  ##               : The ISO 4217 currency code for the pricing info in the response proto.
  ## Will use the conversion rate as of start_time.
  ## Optional. If not specified USD will be used.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Requested page size. Defaults to 5000.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startTime: string
  ##            : Optional inclusive start time of the time range for which the pricing
  ## versions will be returned. Timestamps in the future are not allowed.
  ## The time range has to be within a single calendar month in
  ## America/Los_Angeles timezone. Time range as a whole is optional. If not
  ## specified, the latest pricing will be returned (up to 12 hours old at
  ## most).
  var path_580128 = newJObject()
  var query_580129 = newJObject()
  add(query_580129, "upload_protocol", newJString(uploadProtocol))
  add(query_580129, "fields", newJString(fields))
  add(query_580129, "pageToken", newJString(pageToken))
  add(query_580129, "quotaUser", newJString(quotaUser))
  add(query_580129, "alt", newJString(alt))
  add(query_580129, "oauth_token", newJString(oauthToken))
  add(query_580129, "callback", newJString(callback))
  add(query_580129, "access_token", newJString(accessToken))
  add(query_580129, "uploadType", newJString(uploadType))
  add(path_580128, "parent", newJString(parent))
  add(query_580129, "endTime", newJString(endTime))
  add(query_580129, "currencyCode", newJString(currencyCode))
  add(query_580129, "key", newJString(key))
  add(query_580129, "$.xgafv", newJString(Xgafv))
  add(query_580129, "pageSize", newJInt(pageSize))
  add(query_580129, "prettyPrint", newJBool(prettyPrint))
  add(query_580129, "startTime", newJString(startTime))
  result = call_580127.call(path_580128, query_580129, nil, nil, nil)

var cloudbillingServicesSkusList* = Call_CloudbillingServicesSkusList_580106(
    name: "cloudbillingServicesSkusList", meth: HttpMethod.HttpGet,
    host: "cloudbilling.googleapis.com", route: "/v1/{parent}/skus",
    validator: validate_CloudbillingServicesSkusList_580107, base: "/",
    url: url_CloudbillingServicesSkusList_580108, schemes: {Scheme.Https})
type
  Call_CloudbillingBillingAccountsGetIamPolicy_580130 = ref object of OpenApiRestCall_579408
proc url_CloudbillingBillingAccountsGetIamPolicy_580132(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbillingBillingAccountsGetIamPolicy_580131(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the access control policy for a billing account.
  ## The caller must have the `billing.accounts.getIamPolicy` permission on the
  ## account, which is often given to billing account
  ## [viewers](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580133 = path.getOrDefault("resource")
  valid_580133 = validateParameter(valid_580133, JString, required = true,
                                 default = nil)
  if valid_580133 != nil:
    section.add "resource", valid_580133
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
  ##   options.requestedPolicyVersion: JInt
  ##                                 : Optional. The policy format version to be returned.
  ## Acceptable values are 0, 1, and 3.
  ## If the value is 0, or the field is omitted, policy format version 1 will be
  ## returned.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580134 = query.getOrDefault("upload_protocol")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "upload_protocol", valid_580134
  var valid_580135 = query.getOrDefault("fields")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "fields", valid_580135
  var valid_580136 = query.getOrDefault("quotaUser")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "quotaUser", valid_580136
  var valid_580137 = query.getOrDefault("alt")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = newJString("json"))
  if valid_580137 != nil:
    section.add "alt", valid_580137
  var valid_580138 = query.getOrDefault("oauth_token")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "oauth_token", valid_580138
  var valid_580139 = query.getOrDefault("callback")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "callback", valid_580139
  var valid_580140 = query.getOrDefault("access_token")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "access_token", valid_580140
  var valid_580141 = query.getOrDefault("uploadType")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "uploadType", valid_580141
  var valid_580142 = query.getOrDefault("options.requestedPolicyVersion")
  valid_580142 = validateParameter(valid_580142, JInt, required = false, default = nil)
  if valid_580142 != nil:
    section.add "options.requestedPolicyVersion", valid_580142
  var valid_580143 = query.getOrDefault("key")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "key", valid_580143
  var valid_580144 = query.getOrDefault("$.xgafv")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = newJString("1"))
  if valid_580144 != nil:
    section.add "$.xgafv", valid_580144
  var valid_580145 = query.getOrDefault("prettyPrint")
  valid_580145 = validateParameter(valid_580145, JBool, required = false,
                                 default = newJBool(true))
  if valid_580145 != nil:
    section.add "prettyPrint", valid_580145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580146: Call_CloudbillingBillingAccountsGetIamPolicy_580130;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a billing account.
  ## The caller must have the `billing.accounts.getIamPolicy` permission on the
  ## account, which is often given to billing account
  ## [viewers](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  let valid = call_580146.validator(path, query, header, formData, body)
  let scheme = call_580146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580146.url(scheme.get, call_580146.host, call_580146.base,
                         call_580146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580146, url, valid)

proc call*(call_580147: Call_CloudbillingBillingAccountsGetIamPolicy_580130;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          optionsRequestedPolicyVersion: int = 0; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## cloudbillingBillingAccountsGetIamPolicy
  ## Gets the access control policy for a billing account.
  ## The caller must have the `billing.accounts.getIamPolicy` permission on the
  ## account, which is often given to billing account
  ## [viewers](https://cloud.google.com/billing/docs/how-to/billing-access).
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
  ##   optionsRequestedPolicyVersion: int
  ##                                : Optional. The policy format version to be returned.
  ## Acceptable values are 0, 1, and 3.
  ## If the value is 0, or the field is omitted, policy format version 1 will be
  ## returned.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580148 = newJObject()
  var query_580149 = newJObject()
  add(query_580149, "upload_protocol", newJString(uploadProtocol))
  add(query_580149, "fields", newJString(fields))
  add(query_580149, "quotaUser", newJString(quotaUser))
  add(query_580149, "alt", newJString(alt))
  add(query_580149, "oauth_token", newJString(oauthToken))
  add(query_580149, "callback", newJString(callback))
  add(query_580149, "access_token", newJString(accessToken))
  add(query_580149, "uploadType", newJString(uploadType))
  add(query_580149, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_580149, "key", newJString(key))
  add(query_580149, "$.xgafv", newJString(Xgafv))
  add(path_580148, "resource", newJString(resource))
  add(query_580149, "prettyPrint", newJBool(prettyPrint))
  result = call_580147.call(path_580148, query_580149, nil, nil, nil)

var cloudbillingBillingAccountsGetIamPolicy* = Call_CloudbillingBillingAccountsGetIamPolicy_580130(
    name: "cloudbillingBillingAccountsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "cloudbilling.googleapis.com", route: "/v1/{resource}:getIamPolicy",
    validator: validate_CloudbillingBillingAccountsGetIamPolicy_580131, base: "/",
    url: url_CloudbillingBillingAccountsGetIamPolicy_580132,
    schemes: {Scheme.Https})
type
  Call_CloudbillingBillingAccountsSetIamPolicy_580150 = ref object of OpenApiRestCall_579408
proc url_CloudbillingBillingAccountsSetIamPolicy_580152(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbillingBillingAccountsSetIamPolicy_580151(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the access control policy for a billing account. Replaces any existing
  ## policy.
  ## The caller must have the `billing.accounts.setIamPolicy` permission on the
  ## account, which is often given to billing account
  ## [administrators](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580153 = path.getOrDefault("resource")
  valid_580153 = validateParameter(valid_580153, JString, required = true,
                                 default = nil)
  if valid_580153 != nil:
    section.add "resource", valid_580153
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
  var valid_580154 = query.getOrDefault("upload_protocol")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "upload_protocol", valid_580154
  var valid_580155 = query.getOrDefault("fields")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "fields", valid_580155
  var valid_580156 = query.getOrDefault("quotaUser")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "quotaUser", valid_580156
  var valid_580157 = query.getOrDefault("alt")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = newJString("json"))
  if valid_580157 != nil:
    section.add "alt", valid_580157
  var valid_580158 = query.getOrDefault("oauth_token")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "oauth_token", valid_580158
  var valid_580159 = query.getOrDefault("callback")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "callback", valid_580159
  var valid_580160 = query.getOrDefault("access_token")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "access_token", valid_580160
  var valid_580161 = query.getOrDefault("uploadType")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "uploadType", valid_580161
  var valid_580162 = query.getOrDefault("key")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "key", valid_580162
  var valid_580163 = query.getOrDefault("$.xgafv")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = newJString("1"))
  if valid_580163 != nil:
    section.add "$.xgafv", valid_580163
  var valid_580164 = query.getOrDefault("prettyPrint")
  valid_580164 = validateParameter(valid_580164, JBool, required = false,
                                 default = newJBool(true))
  if valid_580164 != nil:
    section.add "prettyPrint", valid_580164
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

proc call*(call_580166: Call_CloudbillingBillingAccountsSetIamPolicy_580150;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy for a billing account. Replaces any existing
  ## policy.
  ## The caller must have the `billing.accounts.setIamPolicy` permission on the
  ## account, which is often given to billing account
  ## [administrators](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  let valid = call_580166.validator(path, query, header, formData, body)
  let scheme = call_580166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580166.url(scheme.get, call_580166.host, call_580166.base,
                         call_580166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580166, url, valid)

proc call*(call_580167: Call_CloudbillingBillingAccountsSetIamPolicy_580150;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudbillingBillingAccountsSetIamPolicy
  ## Sets the access control policy for a billing account. Replaces any existing
  ## policy.
  ## The caller must have the `billing.accounts.setIamPolicy` permission on the
  ## account, which is often given to billing account
  ## [administrators](https://cloud.google.com/billing/docs/how-to/billing-access).
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580168 = newJObject()
  var query_580169 = newJObject()
  var body_580170 = newJObject()
  add(query_580169, "upload_protocol", newJString(uploadProtocol))
  add(query_580169, "fields", newJString(fields))
  add(query_580169, "quotaUser", newJString(quotaUser))
  add(query_580169, "alt", newJString(alt))
  add(query_580169, "oauth_token", newJString(oauthToken))
  add(query_580169, "callback", newJString(callback))
  add(query_580169, "access_token", newJString(accessToken))
  add(query_580169, "uploadType", newJString(uploadType))
  add(query_580169, "key", newJString(key))
  add(query_580169, "$.xgafv", newJString(Xgafv))
  add(path_580168, "resource", newJString(resource))
  if body != nil:
    body_580170 = body
  add(query_580169, "prettyPrint", newJBool(prettyPrint))
  result = call_580167.call(path_580168, query_580169, nil, nil, body_580170)

var cloudbillingBillingAccountsSetIamPolicy* = Call_CloudbillingBillingAccountsSetIamPolicy_580150(
    name: "cloudbillingBillingAccountsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "cloudbilling.googleapis.com", route: "/v1/{resource}:setIamPolicy",
    validator: validate_CloudbillingBillingAccountsSetIamPolicy_580151, base: "/",
    url: url_CloudbillingBillingAccountsSetIamPolicy_580152,
    schemes: {Scheme.Https})
type
  Call_CloudbillingBillingAccountsTestIamPermissions_580171 = ref object of OpenApiRestCall_579408
proc url_CloudbillingBillingAccountsTestIamPermissions_580173(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbillingBillingAccountsTestIamPermissions_580172(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Tests the access control policy for a billing account. This method takes
  ## the resource and a set of permissions as input and returns the subset of
  ## the input permissions that the caller is allowed for that resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580174 = path.getOrDefault("resource")
  valid_580174 = validateParameter(valid_580174, JString, required = true,
                                 default = nil)
  if valid_580174 != nil:
    section.add "resource", valid_580174
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
  var valid_580175 = query.getOrDefault("upload_protocol")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "upload_protocol", valid_580175
  var valid_580176 = query.getOrDefault("fields")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "fields", valid_580176
  var valid_580177 = query.getOrDefault("quotaUser")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "quotaUser", valid_580177
  var valid_580178 = query.getOrDefault("alt")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = newJString("json"))
  if valid_580178 != nil:
    section.add "alt", valid_580178
  var valid_580179 = query.getOrDefault("oauth_token")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "oauth_token", valid_580179
  var valid_580180 = query.getOrDefault("callback")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = nil)
  if valid_580180 != nil:
    section.add "callback", valid_580180
  var valid_580181 = query.getOrDefault("access_token")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = nil)
  if valid_580181 != nil:
    section.add "access_token", valid_580181
  var valid_580182 = query.getOrDefault("uploadType")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "uploadType", valid_580182
  var valid_580183 = query.getOrDefault("key")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "key", valid_580183
  var valid_580184 = query.getOrDefault("$.xgafv")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = newJString("1"))
  if valid_580184 != nil:
    section.add "$.xgafv", valid_580184
  var valid_580185 = query.getOrDefault("prettyPrint")
  valid_580185 = validateParameter(valid_580185, JBool, required = false,
                                 default = newJBool(true))
  if valid_580185 != nil:
    section.add "prettyPrint", valid_580185
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

proc call*(call_580187: Call_CloudbillingBillingAccountsTestIamPermissions_580171;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Tests the access control policy for a billing account. This method takes
  ## the resource and a set of permissions as input and returns the subset of
  ## the input permissions that the caller is allowed for that resource.
  ## 
  let valid = call_580187.validator(path, query, header, formData, body)
  let scheme = call_580187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580187.url(scheme.get, call_580187.host, call_580187.base,
                         call_580187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580187, url, valid)

proc call*(call_580188: Call_CloudbillingBillingAccountsTestIamPermissions_580171;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudbillingBillingAccountsTestIamPermissions
  ## Tests the access control policy for a billing account. This method takes
  ## the resource and a set of permissions as input and returns the subset of
  ## the input permissions that the caller is allowed for that resource.
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580189 = newJObject()
  var query_580190 = newJObject()
  var body_580191 = newJObject()
  add(query_580190, "upload_protocol", newJString(uploadProtocol))
  add(query_580190, "fields", newJString(fields))
  add(query_580190, "quotaUser", newJString(quotaUser))
  add(query_580190, "alt", newJString(alt))
  add(query_580190, "oauth_token", newJString(oauthToken))
  add(query_580190, "callback", newJString(callback))
  add(query_580190, "access_token", newJString(accessToken))
  add(query_580190, "uploadType", newJString(uploadType))
  add(query_580190, "key", newJString(key))
  add(query_580190, "$.xgafv", newJString(Xgafv))
  add(path_580189, "resource", newJString(resource))
  if body != nil:
    body_580191 = body
  add(query_580190, "prettyPrint", newJBool(prettyPrint))
  result = call_580188.call(path_580189, query_580190, nil, nil, body_580191)

var cloudbillingBillingAccountsTestIamPermissions* = Call_CloudbillingBillingAccountsTestIamPermissions_580171(
    name: "cloudbillingBillingAccountsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudbilling.googleapis.com",
    route: "/v1/{resource}:testIamPermissions",
    validator: validate_CloudbillingBillingAccountsTestIamPermissions_580172,
    base: "/", url: url_CloudbillingBillingAccountsTestIamPermissions_580173,
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
