
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  gcpServiceName = "cloudbilling"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudbillingBillingAccountsCreate_597952 = ref object of OpenApiRestCall_597408
proc url_CloudbillingBillingAccountsCreate_597954(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudbillingBillingAccountsCreate_597953(path: JsonNode;
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
  var valid_597955 = query.getOrDefault("upload_protocol")
  valid_597955 = validateParameter(valid_597955, JString, required = false,
                                 default = nil)
  if valid_597955 != nil:
    section.add "upload_protocol", valid_597955
  var valid_597956 = query.getOrDefault("fields")
  valid_597956 = validateParameter(valid_597956, JString, required = false,
                                 default = nil)
  if valid_597956 != nil:
    section.add "fields", valid_597956
  var valid_597957 = query.getOrDefault("quotaUser")
  valid_597957 = validateParameter(valid_597957, JString, required = false,
                                 default = nil)
  if valid_597957 != nil:
    section.add "quotaUser", valid_597957
  var valid_597958 = query.getOrDefault("alt")
  valid_597958 = validateParameter(valid_597958, JString, required = false,
                                 default = newJString("json"))
  if valid_597958 != nil:
    section.add "alt", valid_597958
  var valid_597959 = query.getOrDefault("oauth_token")
  valid_597959 = validateParameter(valid_597959, JString, required = false,
                                 default = nil)
  if valid_597959 != nil:
    section.add "oauth_token", valid_597959
  var valid_597960 = query.getOrDefault("callback")
  valid_597960 = validateParameter(valid_597960, JString, required = false,
                                 default = nil)
  if valid_597960 != nil:
    section.add "callback", valid_597960
  var valid_597961 = query.getOrDefault("access_token")
  valid_597961 = validateParameter(valid_597961, JString, required = false,
                                 default = nil)
  if valid_597961 != nil:
    section.add "access_token", valid_597961
  var valid_597962 = query.getOrDefault("uploadType")
  valid_597962 = validateParameter(valid_597962, JString, required = false,
                                 default = nil)
  if valid_597962 != nil:
    section.add "uploadType", valid_597962
  var valid_597963 = query.getOrDefault("key")
  valid_597963 = validateParameter(valid_597963, JString, required = false,
                                 default = nil)
  if valid_597963 != nil:
    section.add "key", valid_597963
  var valid_597964 = query.getOrDefault("$.xgafv")
  valid_597964 = validateParameter(valid_597964, JString, required = false,
                                 default = newJString("1"))
  if valid_597964 != nil:
    section.add "$.xgafv", valid_597964
  var valid_597965 = query.getOrDefault("prettyPrint")
  valid_597965 = validateParameter(valid_597965, JBool, required = false,
                                 default = newJBool(true))
  if valid_597965 != nil:
    section.add "prettyPrint", valid_597965
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

proc call*(call_597967: Call_CloudbillingBillingAccountsCreate_597952;
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
  let valid = call_597967.validator(path, query, header, formData, body)
  let scheme = call_597967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597967.url(scheme.get, call_597967.host, call_597967.base,
                         call_597967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597967, url, valid)

proc call*(call_597968: Call_CloudbillingBillingAccountsCreate_597952;
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
  var query_597969 = newJObject()
  var body_597970 = newJObject()
  add(query_597969, "upload_protocol", newJString(uploadProtocol))
  add(query_597969, "fields", newJString(fields))
  add(query_597969, "quotaUser", newJString(quotaUser))
  add(query_597969, "alt", newJString(alt))
  add(query_597969, "oauth_token", newJString(oauthToken))
  add(query_597969, "callback", newJString(callback))
  add(query_597969, "access_token", newJString(accessToken))
  add(query_597969, "uploadType", newJString(uploadType))
  add(query_597969, "key", newJString(key))
  add(query_597969, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_597970 = body
  add(query_597969, "prettyPrint", newJBool(prettyPrint))
  result = call_597968.call(nil, query_597969, nil, nil, body_597970)

var cloudbillingBillingAccountsCreate* = Call_CloudbillingBillingAccountsCreate_597952(
    name: "cloudbillingBillingAccountsCreate", meth: HttpMethod.HttpPost,
    host: "cloudbilling.googleapis.com", route: "/v1/billingAccounts",
    validator: validate_CloudbillingBillingAccountsCreate_597953, base: "/",
    url: url_CloudbillingBillingAccountsCreate_597954, schemes: {Scheme.Https})
type
  Call_CloudbillingBillingAccountsList_597677 = ref object of OpenApiRestCall_597408
proc url_CloudbillingBillingAccountsList_597679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudbillingBillingAccountsList_597678(path: JsonNode;
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
  var valid_597791 = query.getOrDefault("upload_protocol")
  valid_597791 = validateParameter(valid_597791, JString, required = false,
                                 default = nil)
  if valid_597791 != nil:
    section.add "upload_protocol", valid_597791
  var valid_597792 = query.getOrDefault("fields")
  valid_597792 = validateParameter(valid_597792, JString, required = false,
                                 default = nil)
  if valid_597792 != nil:
    section.add "fields", valid_597792
  var valid_597793 = query.getOrDefault("pageToken")
  valid_597793 = validateParameter(valid_597793, JString, required = false,
                                 default = nil)
  if valid_597793 != nil:
    section.add "pageToken", valid_597793
  var valid_597794 = query.getOrDefault("quotaUser")
  valid_597794 = validateParameter(valid_597794, JString, required = false,
                                 default = nil)
  if valid_597794 != nil:
    section.add "quotaUser", valid_597794
  var valid_597808 = query.getOrDefault("alt")
  valid_597808 = validateParameter(valid_597808, JString, required = false,
                                 default = newJString("json"))
  if valid_597808 != nil:
    section.add "alt", valid_597808
  var valid_597809 = query.getOrDefault("oauth_token")
  valid_597809 = validateParameter(valid_597809, JString, required = false,
                                 default = nil)
  if valid_597809 != nil:
    section.add "oauth_token", valid_597809
  var valid_597810 = query.getOrDefault("callback")
  valid_597810 = validateParameter(valid_597810, JString, required = false,
                                 default = nil)
  if valid_597810 != nil:
    section.add "callback", valid_597810
  var valid_597811 = query.getOrDefault("access_token")
  valid_597811 = validateParameter(valid_597811, JString, required = false,
                                 default = nil)
  if valid_597811 != nil:
    section.add "access_token", valid_597811
  var valid_597812 = query.getOrDefault("uploadType")
  valid_597812 = validateParameter(valid_597812, JString, required = false,
                                 default = nil)
  if valid_597812 != nil:
    section.add "uploadType", valid_597812
  var valid_597813 = query.getOrDefault("key")
  valid_597813 = validateParameter(valid_597813, JString, required = false,
                                 default = nil)
  if valid_597813 != nil:
    section.add "key", valid_597813
  var valid_597814 = query.getOrDefault("$.xgafv")
  valid_597814 = validateParameter(valid_597814, JString, required = false,
                                 default = newJString("1"))
  if valid_597814 != nil:
    section.add "$.xgafv", valid_597814
  var valid_597815 = query.getOrDefault("pageSize")
  valid_597815 = validateParameter(valid_597815, JInt, required = false, default = nil)
  if valid_597815 != nil:
    section.add "pageSize", valid_597815
  var valid_597816 = query.getOrDefault("prettyPrint")
  valid_597816 = validateParameter(valid_597816, JBool, required = false,
                                 default = newJBool(true))
  if valid_597816 != nil:
    section.add "prettyPrint", valid_597816
  var valid_597817 = query.getOrDefault("filter")
  valid_597817 = validateParameter(valid_597817, JString, required = false,
                                 default = nil)
  if valid_597817 != nil:
    section.add "filter", valid_597817
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597840: Call_CloudbillingBillingAccountsList_597677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the billing accounts that the current authenticated user has
  ## permission to
  ## [view](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  let valid = call_597840.validator(path, query, header, formData, body)
  let scheme = call_597840.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597840.url(scheme.get, call_597840.host, call_597840.base,
                         call_597840.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597840, url, valid)

proc call*(call_597911: Call_CloudbillingBillingAccountsList_597677;
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
  var query_597912 = newJObject()
  add(query_597912, "upload_protocol", newJString(uploadProtocol))
  add(query_597912, "fields", newJString(fields))
  add(query_597912, "pageToken", newJString(pageToken))
  add(query_597912, "quotaUser", newJString(quotaUser))
  add(query_597912, "alt", newJString(alt))
  add(query_597912, "oauth_token", newJString(oauthToken))
  add(query_597912, "callback", newJString(callback))
  add(query_597912, "access_token", newJString(accessToken))
  add(query_597912, "uploadType", newJString(uploadType))
  add(query_597912, "key", newJString(key))
  add(query_597912, "$.xgafv", newJString(Xgafv))
  add(query_597912, "pageSize", newJInt(pageSize))
  add(query_597912, "prettyPrint", newJBool(prettyPrint))
  add(query_597912, "filter", newJString(filter))
  result = call_597911.call(nil, query_597912, nil, nil, nil)

var cloudbillingBillingAccountsList* = Call_CloudbillingBillingAccountsList_597677(
    name: "cloudbillingBillingAccountsList", meth: HttpMethod.HttpGet,
    host: "cloudbilling.googleapis.com", route: "/v1/billingAccounts",
    validator: validate_CloudbillingBillingAccountsList_597678, base: "/",
    url: url_CloudbillingBillingAccountsList_597679, schemes: {Scheme.Https})
type
  Call_CloudbillingServicesList_597971 = ref object of OpenApiRestCall_597408
proc url_CloudbillingServicesList_597973(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudbillingServicesList_597972(path: JsonNode; query: JsonNode;
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
  var valid_597974 = query.getOrDefault("upload_protocol")
  valid_597974 = validateParameter(valid_597974, JString, required = false,
                                 default = nil)
  if valid_597974 != nil:
    section.add "upload_protocol", valid_597974
  var valid_597975 = query.getOrDefault("fields")
  valid_597975 = validateParameter(valid_597975, JString, required = false,
                                 default = nil)
  if valid_597975 != nil:
    section.add "fields", valid_597975
  var valid_597976 = query.getOrDefault("pageToken")
  valid_597976 = validateParameter(valid_597976, JString, required = false,
                                 default = nil)
  if valid_597976 != nil:
    section.add "pageToken", valid_597976
  var valid_597977 = query.getOrDefault("quotaUser")
  valid_597977 = validateParameter(valid_597977, JString, required = false,
                                 default = nil)
  if valid_597977 != nil:
    section.add "quotaUser", valid_597977
  var valid_597978 = query.getOrDefault("alt")
  valid_597978 = validateParameter(valid_597978, JString, required = false,
                                 default = newJString("json"))
  if valid_597978 != nil:
    section.add "alt", valid_597978
  var valid_597979 = query.getOrDefault("oauth_token")
  valid_597979 = validateParameter(valid_597979, JString, required = false,
                                 default = nil)
  if valid_597979 != nil:
    section.add "oauth_token", valid_597979
  var valid_597980 = query.getOrDefault("callback")
  valid_597980 = validateParameter(valid_597980, JString, required = false,
                                 default = nil)
  if valid_597980 != nil:
    section.add "callback", valid_597980
  var valid_597981 = query.getOrDefault("access_token")
  valid_597981 = validateParameter(valid_597981, JString, required = false,
                                 default = nil)
  if valid_597981 != nil:
    section.add "access_token", valid_597981
  var valid_597982 = query.getOrDefault("uploadType")
  valid_597982 = validateParameter(valid_597982, JString, required = false,
                                 default = nil)
  if valid_597982 != nil:
    section.add "uploadType", valid_597982
  var valid_597983 = query.getOrDefault("key")
  valid_597983 = validateParameter(valid_597983, JString, required = false,
                                 default = nil)
  if valid_597983 != nil:
    section.add "key", valid_597983
  var valid_597984 = query.getOrDefault("$.xgafv")
  valid_597984 = validateParameter(valid_597984, JString, required = false,
                                 default = newJString("1"))
  if valid_597984 != nil:
    section.add "$.xgafv", valid_597984
  var valid_597985 = query.getOrDefault("pageSize")
  valid_597985 = validateParameter(valid_597985, JInt, required = false, default = nil)
  if valid_597985 != nil:
    section.add "pageSize", valid_597985
  var valid_597986 = query.getOrDefault("prettyPrint")
  valid_597986 = validateParameter(valid_597986, JBool, required = false,
                                 default = newJBool(true))
  if valid_597986 != nil:
    section.add "prettyPrint", valid_597986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597987: Call_CloudbillingServicesList_597971; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all public cloud services.
  ## 
  let valid = call_597987.validator(path, query, header, formData, body)
  let scheme = call_597987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597987.url(scheme.get, call_597987.host, call_597987.base,
                         call_597987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597987, url, valid)

proc call*(call_597988: Call_CloudbillingServicesList_597971;
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
  var query_597989 = newJObject()
  add(query_597989, "upload_protocol", newJString(uploadProtocol))
  add(query_597989, "fields", newJString(fields))
  add(query_597989, "pageToken", newJString(pageToken))
  add(query_597989, "quotaUser", newJString(quotaUser))
  add(query_597989, "alt", newJString(alt))
  add(query_597989, "oauth_token", newJString(oauthToken))
  add(query_597989, "callback", newJString(callback))
  add(query_597989, "access_token", newJString(accessToken))
  add(query_597989, "uploadType", newJString(uploadType))
  add(query_597989, "key", newJString(key))
  add(query_597989, "$.xgafv", newJString(Xgafv))
  add(query_597989, "pageSize", newJInt(pageSize))
  add(query_597989, "prettyPrint", newJBool(prettyPrint))
  result = call_597988.call(nil, query_597989, nil, nil, nil)

var cloudbillingServicesList* = Call_CloudbillingServicesList_597971(
    name: "cloudbillingServicesList", meth: HttpMethod.HttpGet,
    host: "cloudbilling.googleapis.com", route: "/v1/services",
    validator: validate_CloudbillingServicesList_597972, base: "/",
    url: url_CloudbillingServicesList_597973, schemes: {Scheme.Https})
type
  Call_CloudbillingBillingAccountsGet_597990 = ref object of OpenApiRestCall_597408
proc url_CloudbillingBillingAccountsGet_597992(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbillingBillingAccountsGet_597991(path: JsonNode;
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
  var valid_598007 = path.getOrDefault("name")
  valid_598007 = validateParameter(valid_598007, JString, required = true,
                                 default = nil)
  if valid_598007 != nil:
    section.add "name", valid_598007
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
  var valid_598008 = query.getOrDefault("upload_protocol")
  valid_598008 = validateParameter(valid_598008, JString, required = false,
                                 default = nil)
  if valid_598008 != nil:
    section.add "upload_protocol", valid_598008
  var valid_598009 = query.getOrDefault("fields")
  valid_598009 = validateParameter(valid_598009, JString, required = false,
                                 default = nil)
  if valid_598009 != nil:
    section.add "fields", valid_598009
  var valid_598010 = query.getOrDefault("quotaUser")
  valid_598010 = validateParameter(valid_598010, JString, required = false,
                                 default = nil)
  if valid_598010 != nil:
    section.add "quotaUser", valid_598010
  var valid_598011 = query.getOrDefault("alt")
  valid_598011 = validateParameter(valid_598011, JString, required = false,
                                 default = newJString("json"))
  if valid_598011 != nil:
    section.add "alt", valid_598011
  var valid_598012 = query.getOrDefault("oauth_token")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = nil)
  if valid_598012 != nil:
    section.add "oauth_token", valid_598012
  var valid_598013 = query.getOrDefault("callback")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = nil)
  if valid_598013 != nil:
    section.add "callback", valid_598013
  var valid_598014 = query.getOrDefault("access_token")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = nil)
  if valid_598014 != nil:
    section.add "access_token", valid_598014
  var valid_598015 = query.getOrDefault("uploadType")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = nil)
  if valid_598015 != nil:
    section.add "uploadType", valid_598015
  var valid_598016 = query.getOrDefault("key")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = nil)
  if valid_598016 != nil:
    section.add "key", valid_598016
  var valid_598017 = query.getOrDefault("$.xgafv")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = newJString("1"))
  if valid_598017 != nil:
    section.add "$.xgafv", valid_598017
  var valid_598018 = query.getOrDefault("prettyPrint")
  valid_598018 = validateParameter(valid_598018, JBool, required = false,
                                 default = newJBool(true))
  if valid_598018 != nil:
    section.add "prettyPrint", valid_598018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598019: Call_CloudbillingBillingAccountsGet_597990; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a billing account. The current authenticated user
  ## must be a [viewer of the billing
  ## account](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  let valid = call_598019.validator(path, query, header, formData, body)
  let scheme = call_598019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598019.url(scheme.get, call_598019.host, call_598019.base,
                         call_598019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598019, url, valid)

proc call*(call_598020: Call_CloudbillingBillingAccountsGet_597990; name: string;
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
  var path_598021 = newJObject()
  var query_598022 = newJObject()
  add(query_598022, "upload_protocol", newJString(uploadProtocol))
  add(query_598022, "fields", newJString(fields))
  add(query_598022, "quotaUser", newJString(quotaUser))
  add(path_598021, "name", newJString(name))
  add(query_598022, "alt", newJString(alt))
  add(query_598022, "oauth_token", newJString(oauthToken))
  add(query_598022, "callback", newJString(callback))
  add(query_598022, "access_token", newJString(accessToken))
  add(query_598022, "uploadType", newJString(uploadType))
  add(query_598022, "key", newJString(key))
  add(query_598022, "$.xgafv", newJString(Xgafv))
  add(query_598022, "prettyPrint", newJBool(prettyPrint))
  result = call_598020.call(path_598021, query_598022, nil, nil, nil)

var cloudbillingBillingAccountsGet* = Call_CloudbillingBillingAccountsGet_597990(
    name: "cloudbillingBillingAccountsGet", meth: HttpMethod.HttpGet,
    host: "cloudbilling.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudbillingBillingAccountsGet_597991, base: "/",
    url: url_CloudbillingBillingAccountsGet_597992, schemes: {Scheme.Https})
type
  Call_CloudbillingBillingAccountsPatch_598023 = ref object of OpenApiRestCall_597408
proc url_CloudbillingBillingAccountsPatch_598025(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudbillingBillingAccountsPatch_598024(path: JsonNode;
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
  var valid_598026 = path.getOrDefault("name")
  valid_598026 = validateParameter(valid_598026, JString, required = true,
                                 default = nil)
  if valid_598026 != nil:
    section.add "name", valid_598026
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
  var valid_598027 = query.getOrDefault("upload_protocol")
  valid_598027 = validateParameter(valid_598027, JString, required = false,
                                 default = nil)
  if valid_598027 != nil:
    section.add "upload_protocol", valid_598027
  var valid_598028 = query.getOrDefault("fields")
  valid_598028 = validateParameter(valid_598028, JString, required = false,
                                 default = nil)
  if valid_598028 != nil:
    section.add "fields", valid_598028
  var valid_598029 = query.getOrDefault("quotaUser")
  valid_598029 = validateParameter(valid_598029, JString, required = false,
                                 default = nil)
  if valid_598029 != nil:
    section.add "quotaUser", valid_598029
  var valid_598030 = query.getOrDefault("alt")
  valid_598030 = validateParameter(valid_598030, JString, required = false,
                                 default = newJString("json"))
  if valid_598030 != nil:
    section.add "alt", valid_598030
  var valid_598031 = query.getOrDefault("oauth_token")
  valid_598031 = validateParameter(valid_598031, JString, required = false,
                                 default = nil)
  if valid_598031 != nil:
    section.add "oauth_token", valid_598031
  var valid_598032 = query.getOrDefault("callback")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = nil)
  if valid_598032 != nil:
    section.add "callback", valid_598032
  var valid_598033 = query.getOrDefault("access_token")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = nil)
  if valid_598033 != nil:
    section.add "access_token", valid_598033
  var valid_598034 = query.getOrDefault("uploadType")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = nil)
  if valid_598034 != nil:
    section.add "uploadType", valid_598034
  var valid_598035 = query.getOrDefault("key")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = nil)
  if valid_598035 != nil:
    section.add "key", valid_598035
  var valid_598036 = query.getOrDefault("$.xgafv")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = newJString("1"))
  if valid_598036 != nil:
    section.add "$.xgafv", valid_598036
  var valid_598037 = query.getOrDefault("prettyPrint")
  valid_598037 = validateParameter(valid_598037, JBool, required = false,
                                 default = newJBool(true))
  if valid_598037 != nil:
    section.add "prettyPrint", valid_598037
  var valid_598038 = query.getOrDefault("updateMask")
  valid_598038 = validateParameter(valid_598038, JString, required = false,
                                 default = nil)
  if valid_598038 != nil:
    section.add "updateMask", valid_598038
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

proc call*(call_598040: Call_CloudbillingBillingAccountsPatch_598023;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a billing account's fields.
  ## Currently the only field that can be edited is `display_name`.
  ## The current authenticated user must have the `billing.accounts.update`
  ## IAM permission, which is typically given to the
  ## [administrator](https://cloud.google.com/billing/docs/how-to/billing-access)
  ## of the billing account.
  ## 
  let valid = call_598040.validator(path, query, header, formData, body)
  let scheme = call_598040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598040.url(scheme.get, call_598040.host, call_598040.base,
                         call_598040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598040, url, valid)

proc call*(call_598041: Call_CloudbillingBillingAccountsPatch_598023; name: string;
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
  var path_598042 = newJObject()
  var query_598043 = newJObject()
  var body_598044 = newJObject()
  add(query_598043, "upload_protocol", newJString(uploadProtocol))
  add(query_598043, "fields", newJString(fields))
  add(query_598043, "quotaUser", newJString(quotaUser))
  add(path_598042, "name", newJString(name))
  add(query_598043, "alt", newJString(alt))
  add(query_598043, "oauth_token", newJString(oauthToken))
  add(query_598043, "callback", newJString(callback))
  add(query_598043, "access_token", newJString(accessToken))
  add(query_598043, "uploadType", newJString(uploadType))
  add(query_598043, "key", newJString(key))
  add(query_598043, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598044 = body
  add(query_598043, "prettyPrint", newJBool(prettyPrint))
  add(query_598043, "updateMask", newJString(updateMask))
  result = call_598041.call(path_598042, query_598043, nil, nil, body_598044)

var cloudbillingBillingAccountsPatch* = Call_CloudbillingBillingAccountsPatch_598023(
    name: "cloudbillingBillingAccountsPatch", meth: HttpMethod.HttpPatch,
    host: "cloudbilling.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudbillingBillingAccountsPatch_598024, base: "/",
    url: url_CloudbillingBillingAccountsPatch_598025, schemes: {Scheme.Https})
type
  Call_CloudbillingProjectsUpdateBillingInfo_598064 = ref object of OpenApiRestCall_597408
proc url_CloudbillingProjectsUpdateBillingInfo_598066(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudbillingProjectsUpdateBillingInfo_598065(path: JsonNode;
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
  var valid_598067 = path.getOrDefault("name")
  valid_598067 = validateParameter(valid_598067, JString, required = true,
                                 default = nil)
  if valid_598067 != nil:
    section.add "name", valid_598067
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
  var valid_598068 = query.getOrDefault("upload_protocol")
  valid_598068 = validateParameter(valid_598068, JString, required = false,
                                 default = nil)
  if valid_598068 != nil:
    section.add "upload_protocol", valid_598068
  var valid_598069 = query.getOrDefault("fields")
  valid_598069 = validateParameter(valid_598069, JString, required = false,
                                 default = nil)
  if valid_598069 != nil:
    section.add "fields", valid_598069
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
  var valid_598076 = query.getOrDefault("key")
  valid_598076 = validateParameter(valid_598076, JString, required = false,
                                 default = nil)
  if valid_598076 != nil:
    section.add "key", valid_598076
  var valid_598077 = query.getOrDefault("$.xgafv")
  valid_598077 = validateParameter(valid_598077, JString, required = false,
                                 default = newJString("1"))
  if valid_598077 != nil:
    section.add "$.xgafv", valid_598077
  var valid_598078 = query.getOrDefault("prettyPrint")
  valid_598078 = validateParameter(valid_598078, JBool, required = false,
                                 default = newJBool(true))
  if valid_598078 != nil:
    section.add "prettyPrint", valid_598078
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

proc call*(call_598080: Call_CloudbillingProjectsUpdateBillingInfo_598064;
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
  let valid = call_598080.validator(path, query, header, formData, body)
  let scheme = call_598080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598080.url(scheme.get, call_598080.host, call_598080.base,
                         call_598080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598080, url, valid)

proc call*(call_598081: Call_CloudbillingProjectsUpdateBillingInfo_598064;
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
  var path_598082 = newJObject()
  var query_598083 = newJObject()
  var body_598084 = newJObject()
  add(query_598083, "upload_protocol", newJString(uploadProtocol))
  add(query_598083, "fields", newJString(fields))
  add(query_598083, "quotaUser", newJString(quotaUser))
  add(path_598082, "name", newJString(name))
  add(query_598083, "alt", newJString(alt))
  add(query_598083, "oauth_token", newJString(oauthToken))
  add(query_598083, "callback", newJString(callback))
  add(query_598083, "access_token", newJString(accessToken))
  add(query_598083, "uploadType", newJString(uploadType))
  add(query_598083, "key", newJString(key))
  add(query_598083, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598084 = body
  add(query_598083, "prettyPrint", newJBool(prettyPrint))
  result = call_598081.call(path_598082, query_598083, nil, nil, body_598084)

var cloudbillingProjectsUpdateBillingInfo* = Call_CloudbillingProjectsUpdateBillingInfo_598064(
    name: "cloudbillingProjectsUpdateBillingInfo", meth: HttpMethod.HttpPut,
    host: "cloudbilling.googleapis.com", route: "/v1/{name}/billingInfo",
    validator: validate_CloudbillingProjectsUpdateBillingInfo_598065, base: "/",
    url: url_CloudbillingProjectsUpdateBillingInfo_598066, schemes: {Scheme.Https})
type
  Call_CloudbillingProjectsGetBillingInfo_598045 = ref object of OpenApiRestCall_597408
proc url_CloudbillingProjectsGetBillingInfo_598047(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudbillingProjectsGetBillingInfo_598046(path: JsonNode;
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
  var valid_598048 = path.getOrDefault("name")
  valid_598048 = validateParameter(valid_598048, JString, required = true,
                                 default = nil)
  if valid_598048 != nil:
    section.add "name", valid_598048
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
  var valid_598049 = query.getOrDefault("upload_protocol")
  valid_598049 = validateParameter(valid_598049, JString, required = false,
                                 default = nil)
  if valid_598049 != nil:
    section.add "upload_protocol", valid_598049
  var valid_598050 = query.getOrDefault("fields")
  valid_598050 = validateParameter(valid_598050, JString, required = false,
                                 default = nil)
  if valid_598050 != nil:
    section.add "fields", valid_598050
  var valid_598051 = query.getOrDefault("quotaUser")
  valid_598051 = validateParameter(valid_598051, JString, required = false,
                                 default = nil)
  if valid_598051 != nil:
    section.add "quotaUser", valid_598051
  var valid_598052 = query.getOrDefault("alt")
  valid_598052 = validateParameter(valid_598052, JString, required = false,
                                 default = newJString("json"))
  if valid_598052 != nil:
    section.add "alt", valid_598052
  var valid_598053 = query.getOrDefault("oauth_token")
  valid_598053 = validateParameter(valid_598053, JString, required = false,
                                 default = nil)
  if valid_598053 != nil:
    section.add "oauth_token", valid_598053
  var valid_598054 = query.getOrDefault("callback")
  valid_598054 = validateParameter(valid_598054, JString, required = false,
                                 default = nil)
  if valid_598054 != nil:
    section.add "callback", valid_598054
  var valid_598055 = query.getOrDefault("access_token")
  valid_598055 = validateParameter(valid_598055, JString, required = false,
                                 default = nil)
  if valid_598055 != nil:
    section.add "access_token", valid_598055
  var valid_598056 = query.getOrDefault("uploadType")
  valid_598056 = validateParameter(valid_598056, JString, required = false,
                                 default = nil)
  if valid_598056 != nil:
    section.add "uploadType", valid_598056
  var valid_598057 = query.getOrDefault("key")
  valid_598057 = validateParameter(valid_598057, JString, required = false,
                                 default = nil)
  if valid_598057 != nil:
    section.add "key", valid_598057
  var valid_598058 = query.getOrDefault("$.xgafv")
  valid_598058 = validateParameter(valid_598058, JString, required = false,
                                 default = newJString("1"))
  if valid_598058 != nil:
    section.add "$.xgafv", valid_598058
  var valid_598059 = query.getOrDefault("prettyPrint")
  valid_598059 = validateParameter(valid_598059, JBool, required = false,
                                 default = newJBool(true))
  if valid_598059 != nil:
    section.add "prettyPrint", valid_598059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598060: Call_CloudbillingProjectsGetBillingInfo_598045;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the billing information for a project. The current authenticated user
  ## must have [permission to view the
  ## project](https://cloud.google.com/docs/permissions-overview#h.bgs0oxofvnoo
  ## ).
  ## 
  let valid = call_598060.validator(path, query, header, formData, body)
  let scheme = call_598060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598060.url(scheme.get, call_598060.host, call_598060.base,
                         call_598060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598060, url, valid)

proc call*(call_598061: Call_CloudbillingProjectsGetBillingInfo_598045;
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
  var path_598062 = newJObject()
  var query_598063 = newJObject()
  add(query_598063, "upload_protocol", newJString(uploadProtocol))
  add(query_598063, "fields", newJString(fields))
  add(query_598063, "quotaUser", newJString(quotaUser))
  add(path_598062, "name", newJString(name))
  add(query_598063, "alt", newJString(alt))
  add(query_598063, "oauth_token", newJString(oauthToken))
  add(query_598063, "callback", newJString(callback))
  add(query_598063, "access_token", newJString(accessToken))
  add(query_598063, "uploadType", newJString(uploadType))
  add(query_598063, "key", newJString(key))
  add(query_598063, "$.xgafv", newJString(Xgafv))
  add(query_598063, "prettyPrint", newJBool(prettyPrint))
  result = call_598061.call(path_598062, query_598063, nil, nil, nil)

var cloudbillingProjectsGetBillingInfo* = Call_CloudbillingProjectsGetBillingInfo_598045(
    name: "cloudbillingProjectsGetBillingInfo", meth: HttpMethod.HttpGet,
    host: "cloudbilling.googleapis.com", route: "/v1/{name}/billingInfo",
    validator: validate_CloudbillingProjectsGetBillingInfo_598046, base: "/",
    url: url_CloudbillingProjectsGetBillingInfo_598047, schemes: {Scheme.Https})
type
  Call_CloudbillingBillingAccountsProjectsList_598085 = ref object of OpenApiRestCall_597408
proc url_CloudbillingBillingAccountsProjectsList_598087(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudbillingBillingAccountsProjectsList_598086(path: JsonNode;
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
  var valid_598088 = path.getOrDefault("name")
  valid_598088 = validateParameter(valid_598088, JString, required = true,
                                 default = nil)
  if valid_598088 != nil:
    section.add "name", valid_598088
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
  var valid_598091 = query.getOrDefault("pageToken")
  valid_598091 = validateParameter(valid_598091, JString, required = false,
                                 default = nil)
  if valid_598091 != nil:
    section.add "pageToken", valid_598091
  var valid_598092 = query.getOrDefault("quotaUser")
  valid_598092 = validateParameter(valid_598092, JString, required = false,
                                 default = nil)
  if valid_598092 != nil:
    section.add "quotaUser", valid_598092
  var valid_598093 = query.getOrDefault("alt")
  valid_598093 = validateParameter(valid_598093, JString, required = false,
                                 default = newJString("json"))
  if valid_598093 != nil:
    section.add "alt", valid_598093
  var valid_598094 = query.getOrDefault("oauth_token")
  valid_598094 = validateParameter(valid_598094, JString, required = false,
                                 default = nil)
  if valid_598094 != nil:
    section.add "oauth_token", valid_598094
  var valid_598095 = query.getOrDefault("callback")
  valid_598095 = validateParameter(valid_598095, JString, required = false,
                                 default = nil)
  if valid_598095 != nil:
    section.add "callback", valid_598095
  var valid_598096 = query.getOrDefault("access_token")
  valid_598096 = validateParameter(valid_598096, JString, required = false,
                                 default = nil)
  if valid_598096 != nil:
    section.add "access_token", valid_598096
  var valid_598097 = query.getOrDefault("uploadType")
  valid_598097 = validateParameter(valid_598097, JString, required = false,
                                 default = nil)
  if valid_598097 != nil:
    section.add "uploadType", valid_598097
  var valid_598098 = query.getOrDefault("key")
  valid_598098 = validateParameter(valid_598098, JString, required = false,
                                 default = nil)
  if valid_598098 != nil:
    section.add "key", valid_598098
  var valid_598099 = query.getOrDefault("$.xgafv")
  valid_598099 = validateParameter(valid_598099, JString, required = false,
                                 default = newJString("1"))
  if valid_598099 != nil:
    section.add "$.xgafv", valid_598099
  var valid_598100 = query.getOrDefault("pageSize")
  valid_598100 = validateParameter(valid_598100, JInt, required = false, default = nil)
  if valid_598100 != nil:
    section.add "pageSize", valid_598100
  var valid_598101 = query.getOrDefault("prettyPrint")
  valid_598101 = validateParameter(valid_598101, JBool, required = false,
                                 default = newJBool(true))
  if valid_598101 != nil:
    section.add "prettyPrint", valid_598101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598102: Call_CloudbillingBillingAccountsProjectsList_598085;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the projects associated with a billing account. The current
  ## authenticated user must have the `billing.resourceAssociations.list` IAM
  ## permission, which is often given to billing account
  ## [viewers](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  let valid = call_598102.validator(path, query, header, formData, body)
  let scheme = call_598102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598102.url(scheme.get, call_598102.host, call_598102.base,
                         call_598102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598102, url, valid)

proc call*(call_598103: Call_CloudbillingBillingAccountsProjectsList_598085;
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
  var path_598104 = newJObject()
  var query_598105 = newJObject()
  add(query_598105, "upload_protocol", newJString(uploadProtocol))
  add(query_598105, "fields", newJString(fields))
  add(query_598105, "pageToken", newJString(pageToken))
  add(query_598105, "quotaUser", newJString(quotaUser))
  add(path_598104, "name", newJString(name))
  add(query_598105, "alt", newJString(alt))
  add(query_598105, "oauth_token", newJString(oauthToken))
  add(query_598105, "callback", newJString(callback))
  add(query_598105, "access_token", newJString(accessToken))
  add(query_598105, "uploadType", newJString(uploadType))
  add(query_598105, "key", newJString(key))
  add(query_598105, "$.xgafv", newJString(Xgafv))
  add(query_598105, "pageSize", newJInt(pageSize))
  add(query_598105, "prettyPrint", newJBool(prettyPrint))
  result = call_598103.call(path_598104, query_598105, nil, nil, nil)

var cloudbillingBillingAccountsProjectsList* = Call_CloudbillingBillingAccountsProjectsList_598085(
    name: "cloudbillingBillingAccountsProjectsList", meth: HttpMethod.HttpGet,
    host: "cloudbilling.googleapis.com", route: "/v1/{name}/projects",
    validator: validate_CloudbillingBillingAccountsProjectsList_598086, base: "/",
    url: url_CloudbillingBillingAccountsProjectsList_598087,
    schemes: {Scheme.Https})
type
  Call_CloudbillingServicesSkusList_598106 = ref object of OpenApiRestCall_597408
proc url_CloudbillingServicesSkusList_598108(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudbillingServicesSkusList_598107(path: JsonNode; query: JsonNode;
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
  var valid_598109 = path.getOrDefault("parent")
  valid_598109 = validateParameter(valid_598109, JString, required = true,
                                 default = nil)
  if valid_598109 != nil:
    section.add "parent", valid_598109
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
  var valid_598110 = query.getOrDefault("upload_protocol")
  valid_598110 = validateParameter(valid_598110, JString, required = false,
                                 default = nil)
  if valid_598110 != nil:
    section.add "upload_protocol", valid_598110
  var valid_598111 = query.getOrDefault("fields")
  valid_598111 = validateParameter(valid_598111, JString, required = false,
                                 default = nil)
  if valid_598111 != nil:
    section.add "fields", valid_598111
  var valid_598112 = query.getOrDefault("pageToken")
  valid_598112 = validateParameter(valid_598112, JString, required = false,
                                 default = nil)
  if valid_598112 != nil:
    section.add "pageToken", valid_598112
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
  var valid_598119 = query.getOrDefault("endTime")
  valid_598119 = validateParameter(valid_598119, JString, required = false,
                                 default = nil)
  if valid_598119 != nil:
    section.add "endTime", valid_598119
  var valid_598120 = query.getOrDefault("currencyCode")
  valid_598120 = validateParameter(valid_598120, JString, required = false,
                                 default = nil)
  if valid_598120 != nil:
    section.add "currencyCode", valid_598120
  var valid_598121 = query.getOrDefault("key")
  valid_598121 = validateParameter(valid_598121, JString, required = false,
                                 default = nil)
  if valid_598121 != nil:
    section.add "key", valid_598121
  var valid_598122 = query.getOrDefault("$.xgafv")
  valid_598122 = validateParameter(valid_598122, JString, required = false,
                                 default = newJString("1"))
  if valid_598122 != nil:
    section.add "$.xgafv", valid_598122
  var valid_598123 = query.getOrDefault("pageSize")
  valid_598123 = validateParameter(valid_598123, JInt, required = false, default = nil)
  if valid_598123 != nil:
    section.add "pageSize", valid_598123
  var valid_598124 = query.getOrDefault("prettyPrint")
  valid_598124 = validateParameter(valid_598124, JBool, required = false,
                                 default = newJBool(true))
  if valid_598124 != nil:
    section.add "prettyPrint", valid_598124
  var valid_598125 = query.getOrDefault("startTime")
  valid_598125 = validateParameter(valid_598125, JString, required = false,
                                 default = nil)
  if valid_598125 != nil:
    section.add "startTime", valid_598125
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598126: Call_CloudbillingServicesSkusList_598106; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all publicly available SKUs for a given cloud service.
  ## 
  let valid = call_598126.validator(path, query, header, formData, body)
  let scheme = call_598126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598126.url(scheme.get, call_598126.host, call_598126.base,
                         call_598126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598126, url, valid)

proc call*(call_598127: Call_CloudbillingServicesSkusList_598106; parent: string;
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
  var path_598128 = newJObject()
  var query_598129 = newJObject()
  add(query_598129, "upload_protocol", newJString(uploadProtocol))
  add(query_598129, "fields", newJString(fields))
  add(query_598129, "pageToken", newJString(pageToken))
  add(query_598129, "quotaUser", newJString(quotaUser))
  add(query_598129, "alt", newJString(alt))
  add(query_598129, "oauth_token", newJString(oauthToken))
  add(query_598129, "callback", newJString(callback))
  add(query_598129, "access_token", newJString(accessToken))
  add(query_598129, "uploadType", newJString(uploadType))
  add(path_598128, "parent", newJString(parent))
  add(query_598129, "endTime", newJString(endTime))
  add(query_598129, "currencyCode", newJString(currencyCode))
  add(query_598129, "key", newJString(key))
  add(query_598129, "$.xgafv", newJString(Xgafv))
  add(query_598129, "pageSize", newJInt(pageSize))
  add(query_598129, "prettyPrint", newJBool(prettyPrint))
  add(query_598129, "startTime", newJString(startTime))
  result = call_598127.call(path_598128, query_598129, nil, nil, nil)

var cloudbillingServicesSkusList* = Call_CloudbillingServicesSkusList_598106(
    name: "cloudbillingServicesSkusList", meth: HttpMethod.HttpGet,
    host: "cloudbilling.googleapis.com", route: "/v1/{parent}/skus",
    validator: validate_CloudbillingServicesSkusList_598107, base: "/",
    url: url_CloudbillingServicesSkusList_598108, schemes: {Scheme.Https})
type
  Call_CloudbillingBillingAccountsGetIamPolicy_598130 = ref object of OpenApiRestCall_597408
proc url_CloudbillingBillingAccountsGetIamPolicy_598132(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudbillingBillingAccountsGetIamPolicy_598131(path: JsonNode;
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
  var valid_598133 = path.getOrDefault("resource")
  valid_598133 = validateParameter(valid_598133, JString, required = true,
                                 default = nil)
  if valid_598133 != nil:
    section.add "resource", valid_598133
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
  var valid_598134 = query.getOrDefault("upload_protocol")
  valid_598134 = validateParameter(valid_598134, JString, required = false,
                                 default = nil)
  if valid_598134 != nil:
    section.add "upload_protocol", valid_598134
  var valid_598135 = query.getOrDefault("fields")
  valid_598135 = validateParameter(valid_598135, JString, required = false,
                                 default = nil)
  if valid_598135 != nil:
    section.add "fields", valid_598135
  var valid_598136 = query.getOrDefault("quotaUser")
  valid_598136 = validateParameter(valid_598136, JString, required = false,
                                 default = nil)
  if valid_598136 != nil:
    section.add "quotaUser", valid_598136
  var valid_598137 = query.getOrDefault("alt")
  valid_598137 = validateParameter(valid_598137, JString, required = false,
                                 default = newJString("json"))
  if valid_598137 != nil:
    section.add "alt", valid_598137
  var valid_598138 = query.getOrDefault("oauth_token")
  valid_598138 = validateParameter(valid_598138, JString, required = false,
                                 default = nil)
  if valid_598138 != nil:
    section.add "oauth_token", valid_598138
  var valid_598139 = query.getOrDefault("callback")
  valid_598139 = validateParameter(valid_598139, JString, required = false,
                                 default = nil)
  if valid_598139 != nil:
    section.add "callback", valid_598139
  var valid_598140 = query.getOrDefault("access_token")
  valid_598140 = validateParameter(valid_598140, JString, required = false,
                                 default = nil)
  if valid_598140 != nil:
    section.add "access_token", valid_598140
  var valid_598141 = query.getOrDefault("uploadType")
  valid_598141 = validateParameter(valid_598141, JString, required = false,
                                 default = nil)
  if valid_598141 != nil:
    section.add "uploadType", valid_598141
  var valid_598142 = query.getOrDefault("options.requestedPolicyVersion")
  valid_598142 = validateParameter(valid_598142, JInt, required = false, default = nil)
  if valid_598142 != nil:
    section.add "options.requestedPolicyVersion", valid_598142
  var valid_598143 = query.getOrDefault("key")
  valid_598143 = validateParameter(valid_598143, JString, required = false,
                                 default = nil)
  if valid_598143 != nil:
    section.add "key", valid_598143
  var valid_598144 = query.getOrDefault("$.xgafv")
  valid_598144 = validateParameter(valid_598144, JString, required = false,
                                 default = newJString("1"))
  if valid_598144 != nil:
    section.add "$.xgafv", valid_598144
  var valid_598145 = query.getOrDefault("prettyPrint")
  valid_598145 = validateParameter(valid_598145, JBool, required = false,
                                 default = newJBool(true))
  if valid_598145 != nil:
    section.add "prettyPrint", valid_598145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598146: Call_CloudbillingBillingAccountsGetIamPolicy_598130;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a billing account.
  ## The caller must have the `billing.accounts.getIamPolicy` permission on the
  ## account, which is often given to billing account
  ## [viewers](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  let valid = call_598146.validator(path, query, header, formData, body)
  let scheme = call_598146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598146.url(scheme.get, call_598146.host, call_598146.base,
                         call_598146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598146, url, valid)

proc call*(call_598147: Call_CloudbillingBillingAccountsGetIamPolicy_598130;
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
  var path_598148 = newJObject()
  var query_598149 = newJObject()
  add(query_598149, "upload_protocol", newJString(uploadProtocol))
  add(query_598149, "fields", newJString(fields))
  add(query_598149, "quotaUser", newJString(quotaUser))
  add(query_598149, "alt", newJString(alt))
  add(query_598149, "oauth_token", newJString(oauthToken))
  add(query_598149, "callback", newJString(callback))
  add(query_598149, "access_token", newJString(accessToken))
  add(query_598149, "uploadType", newJString(uploadType))
  add(query_598149, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_598149, "key", newJString(key))
  add(query_598149, "$.xgafv", newJString(Xgafv))
  add(path_598148, "resource", newJString(resource))
  add(query_598149, "prettyPrint", newJBool(prettyPrint))
  result = call_598147.call(path_598148, query_598149, nil, nil, nil)

var cloudbillingBillingAccountsGetIamPolicy* = Call_CloudbillingBillingAccountsGetIamPolicy_598130(
    name: "cloudbillingBillingAccountsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "cloudbilling.googleapis.com", route: "/v1/{resource}:getIamPolicy",
    validator: validate_CloudbillingBillingAccountsGetIamPolicy_598131, base: "/",
    url: url_CloudbillingBillingAccountsGetIamPolicy_598132,
    schemes: {Scheme.Https})
type
  Call_CloudbillingBillingAccountsSetIamPolicy_598150 = ref object of OpenApiRestCall_597408
proc url_CloudbillingBillingAccountsSetIamPolicy_598152(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudbillingBillingAccountsSetIamPolicy_598151(path: JsonNode;
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
  var valid_598153 = path.getOrDefault("resource")
  valid_598153 = validateParameter(valid_598153, JString, required = true,
                                 default = nil)
  if valid_598153 != nil:
    section.add "resource", valid_598153
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
  var valid_598154 = query.getOrDefault("upload_protocol")
  valid_598154 = validateParameter(valid_598154, JString, required = false,
                                 default = nil)
  if valid_598154 != nil:
    section.add "upload_protocol", valid_598154
  var valid_598155 = query.getOrDefault("fields")
  valid_598155 = validateParameter(valid_598155, JString, required = false,
                                 default = nil)
  if valid_598155 != nil:
    section.add "fields", valid_598155
  var valid_598156 = query.getOrDefault("quotaUser")
  valid_598156 = validateParameter(valid_598156, JString, required = false,
                                 default = nil)
  if valid_598156 != nil:
    section.add "quotaUser", valid_598156
  var valid_598157 = query.getOrDefault("alt")
  valid_598157 = validateParameter(valid_598157, JString, required = false,
                                 default = newJString("json"))
  if valid_598157 != nil:
    section.add "alt", valid_598157
  var valid_598158 = query.getOrDefault("oauth_token")
  valid_598158 = validateParameter(valid_598158, JString, required = false,
                                 default = nil)
  if valid_598158 != nil:
    section.add "oauth_token", valid_598158
  var valid_598159 = query.getOrDefault("callback")
  valid_598159 = validateParameter(valid_598159, JString, required = false,
                                 default = nil)
  if valid_598159 != nil:
    section.add "callback", valid_598159
  var valid_598160 = query.getOrDefault("access_token")
  valid_598160 = validateParameter(valid_598160, JString, required = false,
                                 default = nil)
  if valid_598160 != nil:
    section.add "access_token", valid_598160
  var valid_598161 = query.getOrDefault("uploadType")
  valid_598161 = validateParameter(valid_598161, JString, required = false,
                                 default = nil)
  if valid_598161 != nil:
    section.add "uploadType", valid_598161
  var valid_598162 = query.getOrDefault("key")
  valid_598162 = validateParameter(valid_598162, JString, required = false,
                                 default = nil)
  if valid_598162 != nil:
    section.add "key", valid_598162
  var valid_598163 = query.getOrDefault("$.xgafv")
  valid_598163 = validateParameter(valid_598163, JString, required = false,
                                 default = newJString("1"))
  if valid_598163 != nil:
    section.add "$.xgafv", valid_598163
  var valid_598164 = query.getOrDefault("prettyPrint")
  valid_598164 = validateParameter(valid_598164, JBool, required = false,
                                 default = newJBool(true))
  if valid_598164 != nil:
    section.add "prettyPrint", valid_598164
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

proc call*(call_598166: Call_CloudbillingBillingAccountsSetIamPolicy_598150;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy for a billing account. Replaces any existing
  ## policy.
  ## The caller must have the `billing.accounts.setIamPolicy` permission on the
  ## account, which is often given to billing account
  ## [administrators](https://cloud.google.com/billing/docs/how-to/billing-access).
  ## 
  let valid = call_598166.validator(path, query, header, formData, body)
  let scheme = call_598166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598166.url(scheme.get, call_598166.host, call_598166.base,
                         call_598166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598166, url, valid)

proc call*(call_598167: Call_CloudbillingBillingAccountsSetIamPolicy_598150;
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
  var path_598168 = newJObject()
  var query_598169 = newJObject()
  var body_598170 = newJObject()
  add(query_598169, "upload_protocol", newJString(uploadProtocol))
  add(query_598169, "fields", newJString(fields))
  add(query_598169, "quotaUser", newJString(quotaUser))
  add(query_598169, "alt", newJString(alt))
  add(query_598169, "oauth_token", newJString(oauthToken))
  add(query_598169, "callback", newJString(callback))
  add(query_598169, "access_token", newJString(accessToken))
  add(query_598169, "uploadType", newJString(uploadType))
  add(query_598169, "key", newJString(key))
  add(query_598169, "$.xgafv", newJString(Xgafv))
  add(path_598168, "resource", newJString(resource))
  if body != nil:
    body_598170 = body
  add(query_598169, "prettyPrint", newJBool(prettyPrint))
  result = call_598167.call(path_598168, query_598169, nil, nil, body_598170)

var cloudbillingBillingAccountsSetIamPolicy* = Call_CloudbillingBillingAccountsSetIamPolicy_598150(
    name: "cloudbillingBillingAccountsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "cloudbilling.googleapis.com", route: "/v1/{resource}:setIamPolicy",
    validator: validate_CloudbillingBillingAccountsSetIamPolicy_598151, base: "/",
    url: url_CloudbillingBillingAccountsSetIamPolicy_598152,
    schemes: {Scheme.Https})
type
  Call_CloudbillingBillingAccountsTestIamPermissions_598171 = ref object of OpenApiRestCall_597408
proc url_CloudbillingBillingAccountsTestIamPermissions_598173(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudbillingBillingAccountsTestIamPermissions_598172(
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
  var valid_598174 = path.getOrDefault("resource")
  valid_598174 = validateParameter(valid_598174, JString, required = true,
                                 default = nil)
  if valid_598174 != nil:
    section.add "resource", valid_598174
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
  var valid_598175 = query.getOrDefault("upload_protocol")
  valid_598175 = validateParameter(valid_598175, JString, required = false,
                                 default = nil)
  if valid_598175 != nil:
    section.add "upload_protocol", valid_598175
  var valid_598176 = query.getOrDefault("fields")
  valid_598176 = validateParameter(valid_598176, JString, required = false,
                                 default = nil)
  if valid_598176 != nil:
    section.add "fields", valid_598176
  var valid_598177 = query.getOrDefault("quotaUser")
  valid_598177 = validateParameter(valid_598177, JString, required = false,
                                 default = nil)
  if valid_598177 != nil:
    section.add "quotaUser", valid_598177
  var valid_598178 = query.getOrDefault("alt")
  valid_598178 = validateParameter(valid_598178, JString, required = false,
                                 default = newJString("json"))
  if valid_598178 != nil:
    section.add "alt", valid_598178
  var valid_598179 = query.getOrDefault("oauth_token")
  valid_598179 = validateParameter(valid_598179, JString, required = false,
                                 default = nil)
  if valid_598179 != nil:
    section.add "oauth_token", valid_598179
  var valid_598180 = query.getOrDefault("callback")
  valid_598180 = validateParameter(valid_598180, JString, required = false,
                                 default = nil)
  if valid_598180 != nil:
    section.add "callback", valid_598180
  var valid_598181 = query.getOrDefault("access_token")
  valid_598181 = validateParameter(valid_598181, JString, required = false,
                                 default = nil)
  if valid_598181 != nil:
    section.add "access_token", valid_598181
  var valid_598182 = query.getOrDefault("uploadType")
  valid_598182 = validateParameter(valid_598182, JString, required = false,
                                 default = nil)
  if valid_598182 != nil:
    section.add "uploadType", valid_598182
  var valid_598183 = query.getOrDefault("key")
  valid_598183 = validateParameter(valid_598183, JString, required = false,
                                 default = nil)
  if valid_598183 != nil:
    section.add "key", valid_598183
  var valid_598184 = query.getOrDefault("$.xgafv")
  valid_598184 = validateParameter(valid_598184, JString, required = false,
                                 default = newJString("1"))
  if valid_598184 != nil:
    section.add "$.xgafv", valid_598184
  var valid_598185 = query.getOrDefault("prettyPrint")
  valid_598185 = validateParameter(valid_598185, JBool, required = false,
                                 default = newJBool(true))
  if valid_598185 != nil:
    section.add "prettyPrint", valid_598185
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

proc call*(call_598187: Call_CloudbillingBillingAccountsTestIamPermissions_598171;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Tests the access control policy for a billing account. This method takes
  ## the resource and a set of permissions as input and returns the subset of
  ## the input permissions that the caller is allowed for that resource.
  ## 
  let valid = call_598187.validator(path, query, header, formData, body)
  let scheme = call_598187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598187.url(scheme.get, call_598187.host, call_598187.base,
                         call_598187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598187, url, valid)

proc call*(call_598188: Call_CloudbillingBillingAccountsTestIamPermissions_598171;
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
  var path_598189 = newJObject()
  var query_598190 = newJObject()
  var body_598191 = newJObject()
  add(query_598190, "upload_protocol", newJString(uploadProtocol))
  add(query_598190, "fields", newJString(fields))
  add(query_598190, "quotaUser", newJString(quotaUser))
  add(query_598190, "alt", newJString(alt))
  add(query_598190, "oauth_token", newJString(oauthToken))
  add(query_598190, "callback", newJString(callback))
  add(query_598190, "access_token", newJString(accessToken))
  add(query_598190, "uploadType", newJString(uploadType))
  add(query_598190, "key", newJString(key))
  add(query_598190, "$.xgafv", newJString(Xgafv))
  add(path_598189, "resource", newJString(resource))
  if body != nil:
    body_598191 = body
  add(query_598190, "prettyPrint", newJBool(prettyPrint))
  result = call_598188.call(path_598189, query_598190, nil, nil, body_598191)

var cloudbillingBillingAccountsTestIamPermissions* = Call_CloudbillingBillingAccountsTestIamPermissions_598171(
    name: "cloudbillingBillingAccountsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudbilling.googleapis.com",
    route: "/v1/{resource}:testIamPermissions",
    validator: validate_CloudbillingBillingAccountsTestIamPermissions_598172,
    base: "/", url: url_CloudbillingBillingAccountsTestIamPermissions_598173,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
